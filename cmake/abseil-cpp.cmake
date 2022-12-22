# Setup our dependency on Abseil.

set(ABSL_PROPAGATE_CXX_STD ON)

if(TARGET absl::strings)
  # If Abseil is included already, skip including it.
  # (https://github.com/protocolbuffers/protobuf/issues/10435)
elseif(protobuf_ABSL_PROVIDER STREQUAL "module")
  if(NOT ABSL_ROOT_DIR)
    set(ABSL_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/abseil-cpp)
  endif()
  if(EXISTS "${ABSL_ROOT_DIR}/CMakeLists.txt")
    if(protobuf_INSTALL)
      # When protobuf_INSTALL is enabled and Abseil will be built as a module,
      # Abseil will be installed along with protobuf for convenience.
      set(ABSL_ENABLE_INSTALL ON)
    endif()
    add_subdirectory(${ABSL_ROOT_DIR} third_party/abseil-cpp)
  else()
    message(WARNING "protobuf_ABSL_PROVIDER is \"module\" but ABSL_ROOT_DIR is wrong")
  endif()
  if(protobuf_INSTALL AND NOT _protobuf_INSTALL_SUPPORTED_FROM_MODULE)
    message(WARNING "protobuf_INSTALL will be forced to FALSE because protobuf_ABSL_PROVIDER is \"module\" and CMake version (${CMAKE_VERSION}) is less than 3.13.")
    set(protobuf_INSTALL FALSE)
  endif()
elseif(protobuf_ABSL_PROVIDER STREQUAL "package")
  # Use "CONFIG" as there is no built-in cmake module for absl.
  find_package(absl REQUIRED CONFIG)
endif()
set(_protobuf_FIND_ABSL "if(NOT TARGET absl::strings)\n  find_package(absl CONFIG)\nendif()")

if (BUILD_SHARED_LIBS AND MSVC)
  # On MSVC Abseil is bundled into a single DLL.
  set(protobuf_ABSL_USED_TARGETS abseil_dll)

  # As a workaround for https://github.com/abseil/abseil-cpp/issues/1118,
  # make sure ABSL_CONSUME_DLL gets set for all subsequent builds.
  add_definitions(-DABSL_CONSUME_DLL)
else()
  set(protobuf_ABSL_USED_TARGETS
    absl::algorithm
    absl::base
    absl::bind_front
    absl::bits
    absl::btree
    absl::cleanup
    absl::cord
    absl::core_headers
    absl::debugging
    absl::dynamic_annotations
    absl::flags
    absl::flat_hash_map
    absl::flat_hash_set
    absl::function_ref
    absl::hash
    absl::layout
    absl::memory
    absl::node_hash_map
    absl::node_hash_set
    absl::optional
    absl::span
    absl::status
    absl::statusor
    absl::strings
    absl::synchronization
    absl::time
    absl::type_traits
    absl::utility
    absl::variant
  )
endif ()
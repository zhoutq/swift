// -*- swift -*-

//===----------------------------------------------------------------------===//
// Automatically Generated From validation-test/stdlib/Collection/Inputs/Template.swift.gyb
// Do Not Edit Directly!
//===----------------------------------------------------------------------===//

// RUN: rm -rf %t
// RUN: mkdir -p %t
// RUN: %S/../../../utils/gyb %s -o %t/main.swift
// RUN: %S/../../../utils/line-directive %t/main.swift -- %target-build-swift %t/main.swift -o %t/MinimalCollection.swift.a.out
// RUN: %S/../../../utils/line-directive %t/main.swift -- %target-run %t/MinimalCollection.swift.a.out
// REQUIRES: executable_test

import StdlibUnittest
import StdlibCollectionUnittest

// Also import modules which are used by StdlibUnittest internally. This
// workaround is needed to link all required libraries in case we compile
// StdlibUnittest with -sil-serialize-all.
import SwiftPrivate
#if _runtime(_ObjC)
import ObjectiveC
#endif

var CollectionTests = TestSuite("Collection")

// Test collections using value types as elements.
do {
  var checksAdded: Box<Set<String>> = Box([])
  var resiliencyChecks = CollectionMisuseResiliencyChecks.all
  resiliencyChecks.creatingOutOfBoundsIndicesBehavior = .trap

  CollectionTests.addCollectionTests(
    makeCollection: { (elements: [OpaqueValue<Int>]) in
      return MinimalCollection(elements: elements)
    },
    wrapValue: identity,
    extractValue: identity,
    makeCollectionOfEquatable: { (elements: [MinimalEquatableValue]) in
      return MinimalCollection(elements: elements)
    },
    wrapValueIntoEquatable: identityEq,
    extractValueFromEquatable: identityEq,
    checksAdded: checksAdded,
    resiliencyChecks: resiliencyChecks
  )
}

// Test collections using a reference type as element.
do {
  var checksAdded: Box<Set<String>> = Box([])
  var resiliencyChecks = CollectionMisuseResiliencyChecks.all
  resiliencyChecks.creatingOutOfBoundsIndicesBehavior = .trap

  CollectionTests.addCollectionTests(
    makeCollection: { (elements: [LifetimeTracked]) in
      return MinimalCollection(elements: elements)
    },
    wrapValue: { (element: OpaqueValue<Int>) in
      LifetimeTracked(element.value, identity: element.identity)
    },
    extractValue: { (element: LifetimeTracked) in
      OpaqueValue(element.value, identity: element.identity)
    },
    makeCollectionOfEquatable: { (elements: [MinimalEquatableValue]) in
      // FIXME: use LifetimeTracked.
      return MinimalCollection(elements: elements)
    },
    wrapValueIntoEquatable: identityEq,
    extractValueFromEquatable: identityEq,
    checksAdded: checksAdded,
    resiliencyChecks: resiliencyChecks
  )
}

runAllTests()

@Tags(const ['codegen'])
@TestOn('browser')

import 'package:test/test.dart';
import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';

import 'component_loader_test.template.dart' as ng;

void main() {
  group('ComponentLoader', () {
    tearDown(() => disposeAnyRunningTest());

    test('should be able to load next to a location', () async {
      final fixture = await new NgTestBed<CompWithCustomLocation>().create();
      expect(fixture.text, 'BeforeAfter');
      await fixture.update((comp) {
        comp.loader.loadNextToLocation(
          ng.DynamicCompNgFactory,
          comp.location,
        );
      });
      expect(fixture.text, 'BeforeDynamicAfter');
    });

    test('should be able to load into a structural directive', () async {
      final fixture = await new NgTestBed<CompWithDirective>().create();
      expect(fixture.text, 'BeforeDynamicAfter');
    });

    // TODO(matanl): Add test-case for detached component.
  });
}

@Component(
  selector: 'comp-with-custom-location',
  template: r'Before<template #location></template>After',
)
class CompWithCustomLocation {
  final ComponentLoader loader;

  CompWithCustomLocation(this.loader);

  @ViewChild('location', read: ViewContainerRef)
  ViewContainerRef location;
}

@Component(
  selector: 'comp-with-directive',
  directives: const [
    DirectiveThatIsLocation,
  ],
  template: r'Before<template location></template>After',
)
class CompWithDirective {}

@Directive(
  selector: '[location]',
)
class DirectiveThatIsLocation {
  DirectiveThatIsLocation(ComponentLoader loader) {
    loader.loadNextTo(ng.DynamicCompNgFactory);
  }
}

@Component(
  selector: 'dynamic-comp',
  template: 'Dynamic',
)
class DynamicComp {}
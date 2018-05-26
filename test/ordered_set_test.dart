import 'package:test/test.dart';
import 'package:ordered_set/ordered_set.dart';

import 'comparable_object.dart';

void main() {

  group('removeWhere', () {
    test('remove single ement', () {
      OrderedSet<int> a = new OrderedSet();
      expect(a.addAll([7, 4, 3, 1, 2, 6, 5]), 7);
      expect(a.length, 7);
      expect(a.removeWhere((e) => e == 3), 1);
      expect(a.length, 6);
      expect(a.toList().join(), '124567');
    });

    test('remove with property', () {
      OrderedSet<int> a = new OrderedSet();
      expect(a.addAll([7, 4, 3, 1, 2, 6, 5]), 7);
      expect(a.removeWhere((e) => e % 2 == 1), 4);
      expect(a.length, 3);
      expect(a.toList().join(), '246');
    });

    test('remove from same group and different groups', () {
      OrderedSet<ComparableObject> a = new OrderedSet();
      expect(a.add(new ComparableObject(0, 'a1')), true);
      expect(a.add(new ComparableObject(0, 'a2')), true);
      expect(a.add(new ComparableObject(0, 'b1')), true);
      expect(a.add(new ComparableObject(1, 'a3')), true);
      expect(a.add(new ComparableObject(1, 'b2')), true);
      expect(a.add(new ComparableObject(1, 'b3')), true);
      expect(a.add(new ComparableObject(2, 'a4')), true);
      expect(a.add(new ComparableObject(2, 'b4')), true);
      expect(a.removeWhere((e) => e.name.startsWith('a')), 4);
      expect(a.length, 4);
      expect(a.toList().join(), 'b1b2b3b4');
    });

    test('remove all', () {
      OrderedSet<ComparableObject> a = new OrderedSet();
      expect(a.add(new ComparableObject(0, 'a1')), true);
      expect(a.add(new ComparableObject(0, 'a2')), true);
      expect(a.add(new ComparableObject(0, 'b1')), true);
      expect(a.add(new ComparableObject(1, 'a3')), true);
      expect(a.add(new ComparableObject(1, 'b2')), true);
      expect(a.add(new ComparableObject(1, 'b3')), true);
      expect(a.add(new ComparableObject(2, 'a4')), true);
      expect(a.add(new ComparableObject(2, 'b4')), true);
      expect(a.removeWhere((e) => true), 8);
      expect(a.length, 0);
      expect(a.toList().join(), '');
    });
  });

  group('clear', () {
    test('removes all and updates length', () {
      OrderedSet<int> a = new OrderedSet();
      expect(a.addAll([1, 2, 3, 4, 5, 6]), 6);
      a.clear();
      expect(a.length, 0);
      expect(a.toList().length, 0);
    });
  });

  group('addAll', () {
    test('maintains order', () {
      OrderedSet<int> a = new OrderedSet();
      expect(a.length, 0);
      expect(a.addAll([7, 4, 3, 1, 2, 6, 5]), 7);
      expect(a.length, 7);
      expect(a.toList().join(), '1234567');
    });

    test('with repeated priority elements', () {
      OrderedSet<int> a = new OrderedSet((a, b) => (a % 2) - (b % 2));
      expect(a.addAll([7, 4, 3, 1, 2, 6, 5]), 7);
      expect(a.length, 7);
      expect(a.toList().join(), '4267315');

      OrderedSet<int> b = new OrderedSet((a, b) => 0);
      expect(b.addAll([7, 4, 3, 1, 2, 6, 5]), 7);
      expect(a.length, 7);
      expect(b.toList().join(), '7431265');
    });

    test('with identical elements', () {
      OrderedSet<int> a = new OrderedSet();
      expect(a.addAll([4, 3, 3, 2, 2, 2, 1]), 7);
      expect(a.length, 7);
      expect(a.toList().join(), '1222334');
    });
  });

  group('length', () {
    test('keeps track of lenth when adding', () {
      OrderedSet<int> a = new OrderedSet();
      expect(a.add(1), true);
      expect(a.length, 1);
      expect(a.add(2), true);
      expect(a.length, 2);
      expect(a.add(3), true);
      expect(a.length, 3);
    });

    test('keeps track of lenth when removing', () {
      OrderedSet<int> a = new OrderedSet((a, b) => 0); // no priority
      expect(a.addAll([1, 2, 3, 4]), 4);
      expect(a.length, 4);

      expect(a.remove(1), true);
      expect(a.length, 3);
      expect(a.remove(1), false);
      expect(a.length, 3);

      expect(a.remove(5), false); // never been there
      expect(a.length, 3);

      expect(a.remove(2), true);
      expect(a.remove(3), true);
      expect(a.length, 1);

      expect(a.remove(4), true);
      expect(a.length, 0);
      expect(a.remove(4), false);
    });
  });

  group('add/remove', () {
    test('no comparator test with int', () {
      OrderedSet<int> a = new OrderedSet();
      expect(a.add(2), true);
      expect(a.add(1), true);
      expect(a.toList(), [1, 2]);
    });

    test('no comparator test with string', () {
      OrderedSet<String> a = new OrderedSet();
      expect(a.add('aab'), true);
      expect(a.add('cab'), true);
      expect(a.add('bab'), true);
      expect(a.toList(), ['aab', 'bab', 'cab']);
    });

    test('no comparator test with comparable', () {
      OrderedSet<ComparableObject> a = new OrderedSet();
      expect(a.add(new ComparableObject(12, 'Klaus')), true);
      expect(a.add(new ComparableObject(1, 'Sunny')), true);
      expect(a.add(new ComparableObject(14, 'Violet')), true);
      expect(a.toList().map((e) => e.name).toList(), ['Sunny', 'Klaus', 'Violet']);
    });

    test('test with custom comparator', () {
      OrderedSet<ComparableObject> a = new OrderedSet((a, b) => a.name.compareTo(b.name));
      expect(a.add(new ComparableObject(1, 'Sunny')), true);
      expect(a.add(new ComparableObject(12, 'Klaus')), true);
      expect(a.add(new ComparableObject(14, 'Violet')), true);
      expect(a.toList().map((e) => e.name).toList(), ['Klaus', 'Sunny', 'Violet']);
    });

    test('test items with repeated comparables, maintain insertion order', () {
      OrderedSet<int> a = new OrderedSet<int>((a, b) => (a % 2) - (b % 2));
      for (int i = 0; i < 10; i++) {
        expect(a.add(i), true);
      }
      expect(a.toList(), [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]);
    });

    test('test items with actual duplicated items', () {
      OrderedSet<int> a = new OrderedSet<int>();
      expect(a.add(1), true);
      expect(a.add(1), true);
      expect(a.toList(), [1, 1]);
    });

    test('test remove items', () {
      OrderedSet<int> a = new OrderedSet<int>();
      expect(a.add(1), true);
      expect(a.add(2), true);
      expect(a.add(0), true);
      expect(a.remove(1), true);
      expect(a.remove(3), false);
      expect(a.toList(), [0, 2]);
    });

    test('test remove with duplicates', () {
      OrderedSet<int> a = new OrderedSet<int>();
      expect(a.add(0), true);
      expect(a.add(1), true);
      expect(a.add(1), true);
      expect(a.add(2), true);
      expect(a.toList(), [0, 1, 1, 2]);
      expect(a.remove(1), true);
      expect(a.toList(), [0, 1, 2]);
      expect(a.remove(1), true);
      expect(a.toList(), [0, 2]);
    });

    test('with custom comparator, repeated items and removal', () {
      OrderedSet<ComparableObject> a = new OrderedSet((a, b) => -a.priority.compareTo(b.priority));
      ComparableObject a1, a2, a3, a4, a5, a6;
      expect(a.add(a6 = new ComparableObject(0, '6')), true);
      expect(a.add(a3 = new ComparableObject(1, '3')), true);
      expect(a.add(a4 = new ComparableObject(1, '4')), true);
      expect(a.add(a5 = new ComparableObject(1, '5')), true);
      expect(a.add(a1 = new ComparableObject(2, '1')), true);
      expect(a.add(a2 = new ComparableObject(2, '2')), true);
      expect(a.toList().join(), '123456');

      expect(a.remove(a4), true);
      expect(a.toList().join(), '12356');
      expect(a.remove(a4), false);
      expect(a.toList().join(), '12356');

      expect(a.remove(new ComparableObject(1, '5')), false);
      expect(a.toList().join(), '12356');
      expect(a.remove(a5), true);
      expect(a.toList().join(), '1236');

      expect(a.add(new ComparableObject(10, '*')), true);
      expect(a.toList().join(), '*1236');

      expect(a.remove(a1), true);
      expect(a.remove(a6), true);
      expect(a.toList().join(), '*23');

      expect(a.add(new ComparableObject(-10, '*')), true);
      expect(a.toList().join(), '*23*');
      expect(a.remove(a2), true);
      expect(a.toList().join(), '*3*');
      expect(a.remove(a2), false);
      expect(a.remove(a2), false);
      expect(a.toList().join(), '*3*');
      expect(a.remove(a3), true);
      expect(a.toList().join(), '**');
    });
  });
}

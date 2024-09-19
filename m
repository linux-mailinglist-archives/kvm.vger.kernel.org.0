Return-Path: <kvm+bounces-27105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A6297C283
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:40:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C92D1F22603
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B69761DA5F;
	Thu, 19 Sep 2024 01:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e00vo+xj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012931DA4C
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710006; cv=none; b=LF/u0rIU/K3Gu6ld4YVviLqTdt85b8ANk0NtPh1Bu2qEtiCa5j7ZF6jWRHWO6H0ZI/sSqXvuGwmISLnDqvjAa7cbLv/duZiEQ0o577sY/dlfet+TL3uQ1s2KbS2Ij3iCTTzpDm8IlWZ/+Pv3cvuq92H7YeC/Tj5EGiVvGQVb6FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710006; c=relaxed/simple;
	bh=pjDCYfWGmtcfHCeQzycylmOPTR/6NQwIB6dWf4c73R0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GK5xdP5pL/yhhln7052jLWABaQ/DrfbvgwpdYAgVMDTzv9L9tSoHVouHUQjizOejLrMp8T67RNRkr/Ah/NcrvzvuqnqV0c+0b0vo6MVkh2mKgKeVhbpWCNOdjzPD+gKGargkG1DxlmPSusUYku4JwJ594lSqvtSBiitpxcRKIvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e00vo+xj; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710005; x=1758246005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pjDCYfWGmtcfHCeQzycylmOPTR/6NQwIB6dWf4c73R0=;
  b=e00vo+xjLaDpC54+UUL4Kzi9zPeijJAwklmFDkd+YeUiUzAqVWvZjkk6
   fipU4zoCeA8jwg0OvXvSpwhWg2XI+4Cv7+Q1q+C4GwVHf39yspAi4h8AF
   M4WlTVjpLN2qPvf5DIWIZfZLSpgA/TKnEX97voLDvFmIqoziA1RcvKwdB
   E+qF8coRxRu+0XBLmNydmazesqOUqlh9XE5eckeS0VCq2EeMeIttLqoLC
   Vd9e1qe8bq8IcDMK5eYJ+zI5Y/zxptwD4Zof9dbg6TCzPkxZzt3MbWWq4
   5w1h40RAsuU1K4LDPlEPMUp+97knmNsTFNycxF+WOD0UIcr5nFjZmxfek
   w==;
X-CSE-ConnectionGUID: Y+eMeCuYQCibTtIUD6V0tA==
X-CSE-MsgGUID: /TwQZXp4Siq+9xdaW6W4Jw==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25797835"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25797835"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:40:05 -0700
X-CSE-ConnectionGUID: XUKsPmtXTHeJZs8nwwQdZA==
X-CSE-MsgGUID: 3BLglI8fRXKMxyszbBq4aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058586"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:39:58 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 03/15] hw/cpu: Introduce CPU topology device and CPU bus
Date: Thu, 19 Sep 2024 09:55:21 +0800
Message-Id: <20240919015533.766754-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919015533.766754-1-zhao1.liu@intel.com>
References: <20240919015533.766754-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hybrid (or heterogeneous) CPU topology needs to be expressed as
a topology tree, which requires to abstract all the CPU topology
level as the objects.

At present, QEMU already has the CPU device, core device and cluster
device (for TCG), so that it's natual to introduce more topology
related devices instead of abstractong native QEMU objects.

To make it easier to deal with topological relationships, introduce
the general and abstract CPU topology device, and also introduce the
CPU bus to connect such CPU topology devices.

With the underlying CPU topology device abstraction, all the CPU
topology levels could be derived from it as subclasses. Then the
specific devices, such as CPU, core, or future module/die/socket devices
etc, don't have to care about topology relationship, and the underlying
CPU topology abstraction and CPU bus will take care of everything and
build the topology tree.

Note, for the user created topology devices, they are specified the
default object parent (one of the peripheral containers: "/peripheral"
or "/peripheral-anon"). It's necessary to fixup their parent object
to correct topology parent, so that it can make their canonical path
in qtree match the actual topological hierarchies relationship. This
is done by cpu_topo_set_parent() when topology device realizes.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS                   |   2 +
 hw/cpu/cpu-topology.c         | 179 ++++++++++++++++++++++++++++++++++
 hw/cpu/meson.build            |   2 +
 include/hw/cpu/cpu-topology.h |  68 +++++++++++++
 include/qemu/typedefs.h       |   2 +
 stubs/hotplug-stubs.c         |   5 +
 6 files changed, 258 insertions(+)
 create mode 100644 hw/cpu/cpu-topology.c
 create mode 100644 include/hw/cpu/cpu-topology.h

diff --git a/MAINTAINERS b/MAINTAINERS
index ffacd60f4075..230267597b5f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1884,12 +1884,14 @@ F: hw/core/machine-smp.c
 F: hw/core/null-machine.c
 F: hw/core/numa.c
 F: hw/cpu/cluster.c
+F: hw/cpu/cpu-topology.c
 F: qapi/machine.json
 F: qapi/machine-common.json
 F: qapi/machine-target.json
 F: include/hw/boards.h
 F: include/hw/core/cpu.h
 F: include/hw/cpu/cluster.h
+F: include/hw/cpu/cpu-topology.h
 F: include/sysemu/numa.h
 F: tests/functional/test_cpu_queries.py
 F: tests/functional/test_empty_cpu_model.py
diff --git a/hw/cpu/cpu-topology.c b/hw/cpu/cpu-topology.c
new file mode 100644
index 000000000000..e68c06132e7d
--- /dev/null
+++ b/hw/cpu/cpu-topology.c
@@ -0,0 +1,179 @@
+/*
+ * General CPU topology device abstraction
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#include "qemu/osdep.h"
+
+#include "hw/cpu/cpu-topology.h"
+#include "hw/qdev-core.h"
+#include "hw/qdev-properties.h"
+#include "hw/sysbus.h"
+#include "qapi/error.h"
+
+/* Roll up until topology root to check. */
+static bool cpu_parent_check_topology(DeviceState *parent,
+                                      DeviceState *dev,
+                                      Error **errp)
+{
+    BusClass *bc;
+
+    if (!parent || !parent->parent_bus ||
+        object_dynamic_cast(OBJECT(parent->parent_bus), TYPE_CPU_BUS)) {
+        return true;
+    }
+
+    bc = BUS_GET_CLASS(parent->parent_bus);
+    if (bc->check_address) {
+        return bc->check_address(parent->parent_bus, dev, errp);
+    }
+
+    return true;
+}
+
+static bool cpu_bus_check_address(BusState *bus, DeviceState *dev,
+                                  Error **errp)
+{
+    CPUBusState *cbus = CPU_BUS(bus);
+
+    if (cbus->check_topology) {
+        return cbus->check_topology(CPU_BUS(bus), CPU_TOPO(dev), errp);
+    }
+
+    return cpu_parent_check_topology(bus->parent, dev, errp);
+}
+
+static void cpu_bus_class_init(ObjectClass *oc, void *data)
+{
+    BusClass *bc = BUS_CLASS(oc);
+
+    bc->check_address = cpu_bus_check_address;
+}
+
+static const TypeInfo cpu_bus_type_info = {
+    .name = TYPE_CPU_BUS,
+    .parent = TYPE_BUS,
+    .class_init = cpu_bus_class_init,
+    .instance_size = sizeof(CPUBusState),
+};
+
+static bool cpu_topo_set_parent(CPUTopoState *topo, Error **errp)
+{
+    DeviceState *dev = DEVICE(topo);
+    BusState *bus = dev->parent_bus;
+    CPUTopoState *parent_topo = NULL;
+    Object *parent;
+
+    if (!bus || !bus->parent) {
+        return true;
+    }
+
+    if (topo->parent) {
+        error_setg(errp, "cpu topo: %s already have the parent?",
+                   object_get_typename(OBJECT(topo)));
+        return false;
+    }
+
+    parent = OBJECT(bus->parent);
+    if (object_dynamic_cast(parent, TYPE_CPU_TOPO)) {
+        parent_topo = CPU_TOPO(parent);
+
+        if (GET_CPU_TOPO_LEVEL(topo) >= GET_CPU_TOPO_LEVEL(parent_topo)) {
+            error_setg(errp, "cpu topo: current level (%s) should be "
+                       "lower than parent (%s) level",
+                       object_get_typename(OBJECT(topo)),
+                       object_get_typename(parent));
+            return false;
+        }
+    }
+
+    if (dev->id) {
+        /*
+         * Reparent topology device to make child<> match topological
+         * relationship.
+         */
+        if (!qdev_set_parent(dev, bus, parent, NULL, errp)) {
+            return false;
+        }
+    }
+
+    topo->parent = parent_topo;
+    return true;
+}
+
+static void cpu_topo_realize(DeviceState *dev, Error **errp)
+{
+    CPUTopoState *topo = CPU_TOPO(dev);
+    CPUTopoClass *tc = CPU_TOPO_GET_CLASS(topo);
+    HotplugHandler *hotplug_handler;
+
+    if (tc->level == CPU_TOPOLOGY_LEVEL_INVALID) {
+        error_setg(errp, "cpu topo: no level specified type: %s",
+                   object_get_typename(OBJECT(dev)));
+        return;
+    }
+
+    if (!cpu_topo_set_parent(topo, errp)) {
+        return;
+    }
+
+    topo->bus = CPU_BUS(qbus_new(TYPE_CPU_BUS, dev, dev->id));
+    hotplug_handler = qdev_get_bus_hotplug_handler(dev);
+    if (hotplug_handler) {
+        qbus_set_hotplug_handler(BUS(topo->bus), OBJECT(hotplug_handler));
+    }
+}
+
+static void cpu_topo_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    CPUTopoClass *tc = CPU_TOPO_CLASS(oc);
+
+    set_bit(DEVICE_CATEGORY_CPU, dc->categories);
+    dc->realize = cpu_topo_realize;
+
+    /*
+     * If people doesn't want a topology tree, it's necessary to
+     * derive a child class and override this as NULL.
+     */
+    dc->bus_type = TYPE_CPU_BUS;
+
+    /*
+     * The general topo device is not hotpluggable by default.
+     * If any topo device needs hotplug support, this flag must be
+     * overridden.
+     */
+    dc->hotpluggable = false;
+
+    tc->level = CPU_TOPOLOGY_LEVEL_INVALID;
+}
+
+static const TypeInfo cpu_topo_type_info = {
+    .name = TYPE_CPU_TOPO,
+    .parent = TYPE_DEVICE,
+    .abstract = true,
+    .class_size = sizeof(CPUTopoClass),
+    .class_init = cpu_topo_class_init,
+    .instance_size = sizeof(CPUTopoState),
+};
+
+static void cpu_topo_register_types(void)
+{
+    type_register_static(&cpu_bus_type_info);
+    type_register_static(&cpu_topo_type_info);
+}
+
+type_init(cpu_topo_register_types)
+
+int cpu_topo_get_instances_num(CPUTopoState *topo)
+{
+    BusState *bus = DEVICE(topo)->parent_bus;
+
+    return bus ? bus->num_children : 1;
+}
diff --git a/hw/cpu/meson.build b/hw/cpu/meson.build
index 9d36bf8ae2c1..6c6546646608 100644
--- a/hw/cpu/meson.build
+++ b/hw/cpu/meson.build
@@ -1,3 +1,5 @@
+common_ss.add(files('cpu-topology.c'))
+
 system_ss.add(files('core.c'))
 system_ss.add(when: 'CONFIG_CPU_CLUSTER', if_true: files('cluster.c'))
 
diff --git a/include/hw/cpu/cpu-topology.h b/include/hw/cpu/cpu-topology.h
new file mode 100644
index 000000000000..7a447ad16ee7
--- /dev/null
+++ b/include/hw/cpu/cpu-topology.h
@@ -0,0 +1,68 @@
+/*
+ * General CPU topology device abstraction
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#ifndef CPU_TOPO_H
+#define CPU_TOPO_H
+
+#include "hw/qdev-core.h"
+#include "qapi/qapi-types-machine-common.h"
+#include "qom/object.h"
+
+#define TYPE_CPU_BUS "cpu-bus"
+OBJECT_DECLARE_SIMPLE_TYPE(CPUBusState, CPU_BUS)
+
+/**
+ * CPUBusState:
+ * @check_topology: Method to check if @topo is supported by @cbus.
+ */
+struct CPUBusState {
+    /*< private >*/
+    BusState parent_obj;
+
+    /*< public >*/
+    bool (*check_topology)(CPUBusState *cbus, CPUTopoState *topo,
+                           Error **errp);
+};
+
+#define TYPE_CPU_TOPO "cpu-topo"
+OBJECT_DECLARE_TYPE(CPUTopoState, CPUTopoClass, CPU_TOPO)
+
+/**
+ * CPUTopoClass:
+ * @level: Topology level for this CPUTopoClass.
+ */
+struct CPUTopoClass {
+    /*< private >*/
+    DeviceClass parent_class;
+
+    /*< public >*/
+    CpuTopologyLevel level;
+};
+
+/**
+ * CPUTopoState:
+ * @parent: Topology parent of this topology device.
+ * @bus: The CPU bus to add the children device.
+ */
+struct CPUTopoState {
+    /*< private >*/
+    DeviceState parent_obj;
+
+    /*< public >*/
+    struct CPUTopoState *parent;
+    CPUBusState *bus;
+};
+
+#define GET_CPU_TOPO_LEVEL(topo)    (CPU_TOPO_GET_CLASS(topo)->level)
+
+int cpu_topo_get_instances_num(CPUTopoState *topo);
+
+#endif /* CPU_TOPO_H */
diff --git a/include/qemu/typedefs.h b/include/qemu/typedefs.h
index aef41c4e67ce..d62d8687403f 100644
--- a/include/qemu/typedefs.h
+++ b/include/qemu/typedefs.h
@@ -39,8 +39,10 @@ typedef struct Chardev Chardev;
 typedef struct Clock Clock;
 typedef struct ConfidentialGuestSupport ConfidentialGuestSupport;
 typedef struct CPUArchState CPUArchState;
+typedef struct CPUBusState CPUBusState;
 typedef struct CPUPluginState CPUPluginState;
 typedef struct CPUState CPUState;
+typedef struct CPUTopoState CPUTopoState;
 typedef struct DeviceState DeviceState;
 typedef struct DirtyBitmapSnapshot DirtyBitmapSnapshot;
 typedef struct DisasContextBase DisasContextBase;
diff --git a/stubs/hotplug-stubs.c b/stubs/hotplug-stubs.c
index 7aadaa29bd57..791fae079d6d 100644
--- a/stubs/hotplug-stubs.c
+++ b/stubs/hotplug-stubs.c
@@ -19,6 +19,11 @@ HotplugHandler *qdev_get_hotplug_handler(DeviceState *dev)
     return NULL;
 }
 
+HotplugHandler *qdev_get_bus_hotplug_handler(DeviceState *dev)
+{
+    return NULL;
+}
+
 void hotplug_handler_pre_plug(HotplugHandler *plug_handler,
                               DeviceState *plugged_dev,
                               Error **errp)
-- 
2.34.1



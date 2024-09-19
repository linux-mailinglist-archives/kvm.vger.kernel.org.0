Return-Path: <kvm+bounces-27106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5D8797C284
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05BB81C213FD
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF291865C;
	Thu, 19 Sep 2024 01:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SGYN6AiL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0E31E89C
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710014; cv=none; b=XzkxgIjOXtfZqLIfJZ5HhA899+ccQSiaEc3w/KwOKX7L3ShC+Yvp+htAlO2GAC/rnMIi3rQaZaUf/+X106hfos5Z4dXMa2O6m7domNQzkBN0kWvEgkazGHgLHi0UVjxwLd8rLM6i1uEOx2VPf3BZuoNkm/0dx/02LucTmM2CMEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710014; c=relaxed/simple;
	bh=F7jWrurI1XVWfEeDSjk70sFPKqku+j5BACGGdK6zY9w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P+gSieDNZwcTYIVXj6ZzF9h2YdbSzkdW08ce2MvcOUvkV5qx3/R7tmtUrp2V52BlefQkhIKpUfPe1n6JUFNsWPpNPWIBB4abpmvRmtFETRyQxORjtmehqJFknjn2nHvkxSbbM919kDK2KIqpjLfpmhVR3Q/3DwSlHj3JiKvh47k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SGYN6AiL; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710013; x=1758246013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F7jWrurI1XVWfEeDSjk70sFPKqku+j5BACGGdK6zY9w=;
  b=SGYN6AiLCpPYJk4bOzreSTEiSLVq6N10hNBE7ExH+3bqGPrYz+TpvhmL
   JPAFllCuLT+RR25/eMHpp66/Pnq8eJClehlU698EFBhrK/aSSs6HMrUx4
   CW8ztl6qMRlTNerSmgtiEvW1wFjafH9BRduIkkG51X8fCOLxTXj3V3fzP
   NZIc7jSiFMK4s3GZ/1Aksalp4L6xEVIUaUYr8eRD6bTfmZR5kowCF2q/8
   VD1+jn17CxOZFGnPMQYLYvEfbwtfMO5XbAyi+vrF/QKYZPMjY/sd7hbxy
   MT0AlFB3B7NJoSx2IlaUzL9tgcwQI5J5pWQlNeaDhhwnzTl1t4pZAppPb
   g==;
X-CSE-ConnectionGUID: 4dHoOVmeSLKdn/mghFDN+g==
X-CSE-MsgGUID: lXAsgejeR1yltEDXkNbgkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25797853"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25797853"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:40:12 -0700
X-CSE-ConnectionGUID: VQKFuNgeQburcx//Eizfqw==
X-CSE-MsgGUID: 5cDjh2NdT+qSFPCfiK9wyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058644"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:40:05 -0700
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
Subject: [RFC v2 04/15] hw/cpu: Introduce CPU slot to manage CPU topology
Date: Thu, 19 Sep 2024 09:55:22 +0800
Message-Id: <20240919015533.766754-5-zhao1.liu@intel.com>
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

When there's a CPU topology tree, original MachineState.smp (CpuTopology
structure) is not enough to dynamically monitor changes of the tree or
update topology information in time.

To address this, introduce the CPU slot, as the root of CPU topology
tree, which is used to update and maintain global topological statistics
by listening any changes of topology device (realize() and unrealize()).

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS               |   2 +
 hw/cpu/cpu-slot.c         | 140 ++++++++++++++++++++++++++++++++++++++
 hw/cpu/meson.build        |   1 +
 include/hw/cpu/cpu-slot.h |  72 ++++++++++++++++++++
 4 files changed, 215 insertions(+)
 create mode 100644 hw/cpu/cpu-slot.c
 create mode 100644 include/hw/cpu/cpu-slot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 230267597b5f..8e5b2cd91dca 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1884,6 +1884,7 @@ F: hw/core/machine-smp.c
 F: hw/core/null-machine.c
 F: hw/core/numa.c
 F: hw/cpu/cluster.c
+F: hw/cpu/cpu-slot.c
 F: hw/cpu/cpu-topology.c
 F: qapi/machine.json
 F: qapi/machine-common.json
@@ -1891,6 +1892,7 @@ F: qapi/machine-target.json
 F: include/hw/boards.h
 F: include/hw/core/cpu.h
 F: include/hw/cpu/cluster.h
+F: include/hw/cpu/cpu-slot.h
 F: include/hw/cpu/cpu-topology.h
 F: include/sysemu/numa.h
 F: tests/functional/test_cpu_queries.py
diff --git a/hw/cpu/cpu-slot.c b/hw/cpu/cpu-slot.c
new file mode 100644
index 000000000000..66ef8d9faa97
--- /dev/null
+++ b/hw/cpu/cpu-slot.c
@@ -0,0 +1,140 @@
+/*
+ * CPU slot abstraction - manage CPU topology
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
+#include "hw/boards.h"
+#include "hw/cpu/cpu-slot.h"
+#include "hw/cpu/cpu-topology.h"
+#include "hw/qdev-core.h"
+#include "hw/qdev-properties.h"
+#include "hw/sysbus.h"
+#include "qapi/error.h"
+
+static void cpu_slot_add_topo_info(CPUSlot *slot, CPUTopoState *topo)
+{
+    CpuTopologyLevel level = GET_CPU_TOPO_LEVEL(topo);
+    CPUTopoStatEntry *entry;
+    int instances_num;
+
+    entry = &slot->stat.entries[level];
+    entry->total_instances++;
+
+    instances_num = cpu_topo_get_instances_num(topo);
+    if (instances_num > entry->max_instances) {
+        entry->max_instances = instances_num;
+    }
+
+    set_bit(level, slot->stat.curr_levels);
+
+    return;
+}
+
+static void cpu_slot_device_realize(DeviceListener *listener,
+                                    DeviceState *dev)
+{
+    CPUSlot *slot = container_of(listener, CPUSlot, listener);
+    CPUTopoState *topo;
+
+    if (!object_dynamic_cast(OBJECT(dev), TYPE_CPU_TOPO)) {
+        return;
+    }
+
+    topo = CPU_TOPO(dev);
+    cpu_slot_add_topo_info(slot, topo);
+}
+
+static void cpu_slot_del_topo_info(CPUSlot *slot, CPUTopoState *topo)
+{
+    CpuTopologyLevel level = GET_CPU_TOPO_LEVEL(topo);
+    CPUTopoStatEntry *entry;
+
+    entry = &slot->stat.entries[level];
+    entry->total_instances--;
+
+    return;
+}
+
+static void cpu_slot_device_unrealize(DeviceListener *listener,
+                                      DeviceState *dev)
+{
+    CPUSlot *slot = container_of(listener, CPUSlot, listener);
+    CPUTopoState *topo;
+
+    if (!object_dynamic_cast(OBJECT(dev), TYPE_CPU_TOPO)) {
+        return;
+    }
+
+    topo = CPU_TOPO(dev);
+    cpu_slot_del_topo_info(slot, topo);
+}
+
+DeviceListener cpu_slot_device_listener = {
+    .realize = cpu_slot_device_realize,
+    .unrealize = cpu_slot_device_unrealize,
+};
+
+static bool slot_bus_check_topology(CPUBusState *cbus,
+                                    CPUTopoState *topo,
+                                    Error **errp)
+{
+    CPUSlot *slot = CPU_SLOT(BUS(cbus)->parent);
+    CpuTopologyLevel level = GET_CPU_TOPO_LEVEL(topo);
+
+    if (!test_bit(level, slot->supported_levels)) {
+        error_setg(errp, "cpu topo: level %s is not supported",
+                   CpuTopologyLevel_str(level));
+        return false;
+    }
+    return true;
+}
+
+static void cpu_slot_realize(DeviceState *dev, Error **errp)
+{
+    CPUSlot *slot = CPU_SLOT(dev);
+
+    slot->listener = cpu_slot_device_listener;
+    device_listener_register(&slot->listener);
+
+    qbus_init(&slot->bus, sizeof(CPUBusState),
+              TYPE_CPU_BUS, dev, "cpu-slot");
+    slot->bus.check_topology = slot_bus_check_topology;
+}
+
+static void cpu_slot_unrealize(DeviceState *dev)
+{
+    CPUSlot *slot = CPU_SLOT(dev);
+
+    device_listener_unregister(&slot->listener);
+}
+
+static void cpu_slot_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+
+    set_bit(DEVICE_CATEGORY_BRIDGE, dc->categories);
+    dc->realize = cpu_slot_realize;
+    dc->unrealize = cpu_slot_unrealize;
+}
+
+static const TypeInfo cpu_slot_type_info = {
+    .name = TYPE_CPU_SLOT,
+    .parent = TYPE_SYS_BUS_DEVICE,
+    .class_init = cpu_slot_class_init,
+    .instance_size = sizeof(CPUSlot),
+};
+
+static void cpu_slot_register_types(void)
+{
+    type_register_static(&cpu_slot_type_info);
+}
+
+type_init(cpu_slot_register_types)
diff --git a/hw/cpu/meson.build b/hw/cpu/meson.build
index 6c6546646608..358e2b3960fa 100644
--- a/hw/cpu/meson.build
+++ b/hw/cpu/meson.build
@@ -1,6 +1,7 @@
 common_ss.add(files('cpu-topology.c'))
 
 system_ss.add(files('core.c'))
+system_ss.add(files('cpu-slot.c'))
 system_ss.add(when: 'CONFIG_CPU_CLUSTER', if_true: files('cluster.c'))
 
 system_ss.add(when: 'CONFIG_ARM11MPCORE', if_true: files('arm11mpcore.c'))
diff --git a/include/hw/cpu/cpu-slot.h b/include/hw/cpu/cpu-slot.h
new file mode 100644
index 000000000000..9d02d5de578e
--- /dev/null
+++ b/include/hw/cpu/cpu-slot.h
@@ -0,0 +1,72 @@
+/*
+ * CPU slot abstraction header
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#ifndef CPU_SLOT_H
+#define CPU_SLOT_H
+
+#include "hw/cpu/cpu-topology.h"
+#include "hw/qdev-core.h"
+#include "hw/sysbus.h"
+#include "qapi/qapi-types-machine-common.h"
+#include "qom/object.h"
+
+/**
+ * CPUTopoStatEntry:
+ * @total_instances: Total number of topological instances at the same level
+ *                   that are currently inserted in CPU slot
+ * @max_instances: Maximum number of topological instances at the same level
+ *                 under the parent topological container
+ */
+typedef struct CPUTopoStatEntry {
+    int total_instances;
+    int max_instances;
+} CPUTopoStatEntry;
+
+/**
+ * CPUTopoStat:
+ * @entries: Detail count information for valid topology levels under
+ *           CPU slot
+ * @curr_levels: Current CPU topology levels inserted in CPU slot
+ */
+typedef struct CPUTopoStat {
+    /* TODO: Exclude invalid and default levels. */
+    CPUTopoStatEntry entries[CPU_TOPOLOGY_LEVEL__MAX];
+    DECLARE_BITMAP(curr_levels, CPU_TOPOLOGY_LEVEL__MAX);
+} CPUTopoStat;
+
+#define TYPE_CPU_SLOT "cpu-slot"
+OBJECT_DECLARE_SIMPLE_TYPE(CPUSlot, CPU_SLOT)
+
+/**
+ * CPUSlot:
+ * @cores: Queue consisting of all the cores in the topology tree
+ *     where the cpu-slot is the root. cpu-slot can maintain similar
+ *     queues for other topology levels to facilitate traversal
+ *     when necessary.
+ * @stat: Topological statistics for topology tree.
+ * @bus: CPU bus to add the children topology device.
+ * @supported_levels: Supported topology levels for topology tree.
+ * @listener: Hooks to listen realize() and unrealize() of topology
+ *            device.
+ */
+struct CPUSlot {
+    /*< private >*/
+    SysBusDevice parent_obj;
+
+    /*< public >*/
+    CPUBusState bus;
+    CPUTopoStat stat;
+    DECLARE_BITMAP(supported_levels, CPU_TOPOLOGY_LEVEL__MAX);
+
+    DeviceListener listener;
+};
+
+#endif /* CPU_SLOT_H */
-- 
2.34.1



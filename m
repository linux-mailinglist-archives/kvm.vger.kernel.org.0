Return-Path: <kvm+bounces-27161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D21AD97C3FB
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 07:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 640191F21E52
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 05:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6317347D;
	Thu, 19 Sep 2024 05:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FbaghPv9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB76136344
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 05:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725364; cv=none; b=UtHOhc+2LhJSCzsZgSGrFyv8aJr/Rf6bzxeYwQNY6ezkRLALG6P/IB4in2UMZEROqlg9PST7IrxxkMR4NxrwgsAsnVyIxKTQ4oBSMRWMp34Yj4451ADXQh0SN+mrb1gBmjm6VQzZ11RKmOJxv7zLM3B4lHtlbFXXFZn+6z0XRaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725364; c=relaxed/simple;
	bh=aVNIbnJK5KhK/Y9DAm3101ZCx3EUgwFmVyZZJiTVby0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T4+ZZaPvThBrjvgcbQGuSQzSQTotvAbR6o8rAbPjbrfWIb8/oMCUERz3PtIscNF0l62RmfZgfmaZJuNDgaeu53L+GxyOmpd9OYnFJRTgA3jpfPfa1qngxb+r8wNM5tSuGfnDyYoXOiJ4lxwew+Yfd0mqhdnpYwJD7VmuTveke0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FbaghPv9; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726725362; x=1758261362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aVNIbnJK5KhK/Y9DAm3101ZCx3EUgwFmVyZZJiTVby0=;
  b=FbaghPv9gl/YpG4EH7kyqGR6qfO1gTuzlNIlyB3X/IngXp21WYec9HgV
   0j5KdtTejQiMlFVztB9UCnqQ2MfbKa8lBZfYZ+jq69IvuhMTb6jcDga9m
   Klx9LkuLvPcv5md0HryvnZI3xB4MkkBDHoPcwawO4AXr+qvk6qnVsYe2f
   MI5kjU7/nEaT5UKXy+ZBTgSnjiyBin2BFPoiYELvLuKABv1CfewbBADMw
   H1O7D2222lghpqsuSvSOk5DQXfCfDOuVvTO48CQNTlOQWgEDWNUl9MNCX
   UvL6u6r3T7WENEcfLFAuCH66nsxYDRC1DaFfhyqS/q19/GrItYsrIzadX
   A==;
X-CSE-ConnectionGUID: 29RW6cLlQZaSILrxL1EyVA==
X-CSE-MsgGUID: FjBbJHfVQg25++0Ub/RWKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25813558"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25813558"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 22:56:02 -0700
X-CSE-ConnectionGUID: RP7k4QczQ6OpLTckpSW2EA==
X-CSE-MsgGUID: Wf2WQRXTTnqA5CBJWbJoEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="69418694"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2024 22:55:55 -0700
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
	Sergio Lopez <slp@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 05/12] hw/core/machine: Introduce custom CPU topology with max limitations
Date: Thu, 19 Sep 2024 14:11:21 +0800
Message-Id: <20240919061128.769139-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919061128.769139-1-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Custom topology allows user to create CPU topology totally via -device
from CLI.

Once custom topology is enabled, machine will stop the default CPU
creation and expect user's CPU topology tree built from CLI.

With custom topology, any CPU topology, whether symmetric or hybrid
(aka, heterogeneous), can be created naturally.

However, custom topology also needs to be restricted because
possible_cpus[] requires some preliminary topology information for
initialization, which is the max limitation (the new max parameters in
-smp). Custom topology will be subject to this max limitation.

Max limitations are necessary because creating custom topology before
initializing possible_cpus[] would compromise future hotplug scalability.

Max limitations are placed in -smp, even though custom topology can be
defined as hybrid. From an implementation perspective, any hybrid
topology can be considered a subset of a complete SMP structure.
Therefore, semantically, using max limitations to constrain hybrid
topology is consistent.

Introduce custom CPU topology related properties in MachineClass. At the
same time, add and parse max parameters from -smp, and store the max
limitations in CPUSlot.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS               |   1 +
 hw/core/machine-smp.c     |   2 +
 hw/core/machine.c         |  33 +++++++++++
 hw/core/meson.build       |   2 +-
 hw/cpu/cpu-slot.c         | 118 ++++++++++++++++++++++++++++++++++++++
 include/hw/boards.h       |   2 +
 include/hw/cpu/cpu-slot.h |   9 +++
 qapi/machine.json         |  22 ++++++-
 stubs/machine-stubs.c     |  21 +++++++
 stubs/meson.build         |   1 +
 10 files changed, 209 insertions(+), 2 deletions(-)
 create mode 100644 stubs/machine-stubs.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4608c3c6db8c..5ea739f12857 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1901,6 +1901,7 @@ F: include/hw/cpu/die.h
 F: include/hw/cpu/module.h
 F: include/hw/cpu/socket.h
 F: include/sysemu/numa.h
+F: stubs/machine-stubs.c
 F: tests/functional/test_cpu_queries.py
 F: tests/functional/test_empty_cpu_model.py
 F: tests/unit/test-smp-parse.c
diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index 9a281946762f..d3be4352267d 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -259,6 +259,8 @@ void machine_parse_smp_config(MachineState *ms,
                    mc->name, mc->max_cpus);
         return;
     }
+
+    machine_parse_custom_topo_config(ms, config, errp);
 }
 
 static bool machine_check_topo_support(MachineState *ms,
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 7b4ac5ac52b2..dedabd75c825 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -966,6 +966,30 @@ static void machine_set_smp_cache(Object *obj, Visitor *v, const char *name,
     qapi_free_SmpCachePropertiesList(caches);
 }
 
+static bool machine_get_custom_topo(Object *obj, Error **errp)
+{
+    MachineState *ms = MACHINE(obj);
+
+    if (!ms->topo) {
+        error_setg(errp, "machine doesn't support custom topology");
+        return false;
+    }
+
+    return ms->topo->custom_topo_enabled;
+}
+
+static void machine_set_custom_topo(Object *obj, bool value, Error **errp)
+{
+    MachineState *ms = MACHINE(obj);
+
+    if (!ms->topo) {
+        error_setg(errp, "machine doesn't support custom topology");
+        return;
+    }
+
+    ms->topo->custom_topo_enabled = value;
+}
+
 static void machine_get_boot(Object *obj, Visitor *v, const char *name,
                             void *opaque, Error **errp)
 {
@@ -1240,6 +1264,15 @@ static void machine_initfn(Object *obj)
     }
 
     ms->topo = NULL;
+    if (mc->smp_props.topo_tree_supported &&
+        mc->smp_props.custom_topo_supported) {
+        object_property_add_bool(obj, "custom-topo",
+                                 machine_get_custom_topo,
+                                 machine_set_custom_topo);
+        object_property_set_description(obj, "custom-topo",
+                                        "Set on/off to enable/disable "
+                                        "user custom CPU topology tree");
+    }
 
     machine_copy_boot_config(ms, &(BootConfiguration){ 0 });
 }
diff --git a/hw/core/meson.build b/hw/core/meson.build
index a3d9bab9f42a..f70d6104a00d 100644
--- a/hw/core/meson.build
+++ b/hw/core/meson.build
@@ -13,7 +13,6 @@ hwcore_ss.add(files(
 ))
 
 common_ss.add(files('cpu-common.c'))
-common_ss.add(files('machine-smp.c'))
 system_ss.add(when: 'CONFIG_FITLOADER', if_true: files('loader-fit.c'))
 system_ss.add(when: 'CONFIG_GENERIC_LOADER', if_true: files('generic-loader.c'))
 system_ss.add(when: 'CONFIG_GUEST_LOADER', if_true: files('guest-loader.c'))
@@ -33,6 +32,7 @@ system_ss.add(files(
   'loader.c',
   'machine-hmp-cmds.c',
   'machine-qmp-cmds.c',
+  'machine-smp.c',
   'machine.c',
   'nmi.c',
   'null-machine.c',
diff --git a/hw/cpu/cpu-slot.c b/hw/cpu/cpu-slot.c
index 1cc3b32ed675..2d16a2729501 100644
--- a/hw/cpu/cpu-slot.c
+++ b/hw/cpu/cpu-slot.c
@@ -165,6 +165,11 @@ void machine_plug_cpu_slot(MachineState *ms)
         set_bit(CPU_TOPOLOGY_LEVEL_DIE, slot->supported_levels);
     }
 
+    /* Initizlize max_limit to 1, as members of CpuTopology. */
+    for (int i = 0; i < CPU_TOPOLOGY_LEVEL__MAX; i++) {
+        slot->stat.entries[i].max_limit = 1;
+    }
+
     ms->topo = slot;
     object_property_add_child(container_get(OBJECT(ms), "/peripheral"),
                               "cpu-slot", OBJECT(ms->topo));
@@ -295,6 +300,11 @@ bool machine_create_topo_tree(MachineState *ms, Error **errp)
         return false;
     }
 
+    /* User will customize topology tree. */
+    if (slot->custom_topo_enabled) {
+        return true;
+    }
+
     /*
      * Don't support full topology tree.
      * Just use slot to collect topology device.
@@ -325,3 +335,111 @@ bool machine_create_topo_tree(MachineState *ms, Error **errp)
 
     return true;
 }
+
+int get_max_topo_by_level(const MachineState *ms, CpuTopologyLevel level)
+{
+    if (!ms->topo || !ms->topo->custom_topo_enabled) {
+        return get_smp_info_by_level(&ms->smp, level);
+    }
+    return ms->topo->stat.entries[level].max_limit;
+}
+
+bool machine_parse_custom_topo_config(MachineState *ms,
+                                      const SMPConfiguration *config,
+                                      Error **errp)
+{
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+    CPUSlot *slot = ms->topo;
+    bool is_valid;
+    int maxcpus;
+
+    if (!slot) {
+        return true;
+    }
+
+    is_valid = config->has_maxsockets && config->maxsockets;
+    if (mc->smp_props.custom_topo_supported) {
+        slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
+            is_valid ? config->maxsockets : ms->smp.sockets;
+    } else if (is_valid) {
+        error_setg(errp, "maxsockets > 0 not supported "
+                   "by this machine's CPU topology");
+        return false;
+    } else {
+        slot->stat.entries[CPU_TOPOLOGY_LEVEL_SOCKET].max_limit =
+            ms->smp.sockets;
+    }
+
+    is_valid = config->has_maxdies && config->maxdies;
+    if (mc->smp_props.custom_topo_supported &&
+        mc->smp_props.dies_supported) {
+        slot->stat.entries[CPU_TOPOLOGY_LEVEL_DIE].max_limit =
+            is_valid ? config->maxdies : ms->smp.dies;
+    } else if (is_valid) {
+        error_setg(errp, "maxdies > 0 not supported "
+                   "by this machine's CPU topology");
+        return false;
+    } else {
+        slot->stat.entries[CPU_TOPOLOGY_LEVEL_DIE].max_limit =
+            ms->smp.dies;
+    }
+
+    is_valid = config->has_maxmodules && config->maxmodules;
+    if (mc->smp_props.custom_topo_supported &&
+        mc->smp_props.modules_supported) {
+        slot->stat.entries[CPU_TOPOLOGY_LEVEL_MODULE].max_limit =
+            is_valid ? config->maxmodules : ms->smp.modules;
+    } else if (is_valid) {
+        error_setg(errp, "maxmodules > 0 not supported "
+                   "by this machine's CPU topology");
+        return false;
+    } else {
+        slot->stat.entries[CPU_TOPOLOGY_LEVEL_MODULE].max_limit =
+            ms->smp.modules;
+    }
+
+    is_valid = config->has_maxcores && config->maxcores;
+    if (mc->smp_props.custom_topo_supported) {
+        slot->stat.entries[CPU_TOPOLOGY_LEVEL_CORE].max_limit =
+            is_valid ? config->maxcores : ms->smp.cores;
+    } else if (is_valid) {
+        error_setg(errp, "maxcores > 0 not supported "
+                   "by this machine's CPU topology");
+        return false;
+    } else {
+        slot->stat.entries[CPU_TOPOLOGY_LEVEL_CORE].max_limit =
+            ms->smp.cores;
+    }
+
+    is_valid = config->has_maxthreads && config->maxthreads;
+    if (mc->smp_props.custom_topo_supported) {
+        slot->stat.entries[CPU_TOPOLOGY_LEVEL_THREAD].max_limit =
+            is_valid ? config->maxthreads : ms->smp.threads;
+    } else if (is_valid) {
+        error_setg(errp, "maxthreads > 0 not supported "
+                   "by this machine's CPU topology");
+        return false;
+    } else {
+        slot->stat.entries[CPU_TOPOLOGY_LEVEL_THREAD].max_limit =
+            ms->smp.threads;
+    }
+
+    maxcpus = 1;
+    /* Initizlize max_limit to 1, as members of CpuTopology. */
+    for (int i = 0; i < CPU_TOPOLOGY_LEVEL__MAX; i++) {
+        maxcpus *= slot->stat.entries[i].max_limit;
+    }
+
+    if (!config->has_maxcpus) {
+        ms->smp.max_cpus = maxcpus;
+    } else {
+        if (maxcpus != ms->smp.max_cpus) {
+            error_setg(errp, "maxcpus (%d) should be equal to "
+                       "the product of the remaining max parameters (%d)",
+                       ms->smp.max_cpus, maxcpus);
+            return false;
+        }
+    }
+
+    return true;
+}
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 9f706223e848..6ef4ea322590 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -157,6 +157,7 @@ typedef struct {
  * @topo_tree_supported - whether QOM topology tree is supported by the
  *                        machine
  * @arch_id_topo_level - topology granularity for possible_cpus[]
+ * @custom_topo_supported - whether custom topology tree is supported
  */
 typedef struct {
     bool prefer_sockets;
@@ -169,6 +170,7 @@ typedef struct {
     bool cache_supported[CACHE_LEVEL_AND_TYPE__MAX];
     bool topo_tree_supported;
     CpuTopologyLevel arch_id_topo_level;
+    bool custom_topo_supported;
 } SMPCompatProps;
 
 /**
diff --git a/include/hw/cpu/cpu-slot.h b/include/hw/cpu/cpu-slot.h
index 1838e8c0c3f9..8d7e35aa1851 100644
--- a/include/hw/cpu/cpu-slot.h
+++ b/include/hw/cpu/cpu-slot.h
@@ -24,10 +24,13 @@
  *                   that are currently inserted in CPU slot
  * @max_instances: Maximum number of topological instances at the same level
  *                 under the parent topological container
+ * @max_limit: Maximum limitation of topological instances at the same level
+ *             under the parent topological container
  */
 typedef struct CPUTopoStatEntry {
     int total_instances;
     int max_instances;
+    int max_limit;
 } CPUTopoStatEntry;
 
 /**
@@ -54,6 +57,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(CPUSlot, CPU_SLOT)
  * @stat: Topological statistics for topology tree.
  * @bus: CPU bus to add the children topology device.
  * @supported_levels: Supported topology levels for topology tree.
+ * @custom_topo_enabled: Whether user to create custom topology tree.
  * @listener: Hooks to listen realize() and unrealize() of topology
  *            device.
  */
@@ -65,6 +69,7 @@ struct CPUSlot {
     CPUBusState bus;
     CPUTopoStat stat;
     DECLARE_BITMAP(supported_levels, CPU_TOPOLOGY_LEVEL__MAX);
+    bool custom_topo_enabled;
 
     DeviceListener listener;
 };
@@ -75,5 +80,9 @@ struct CPUSlot {
 
 void machine_plug_cpu_slot(MachineState *ms);
 bool machine_create_topo_tree(MachineState *ms, Error **errp);
+int get_max_topo_by_level(const MachineState *ms, CpuTopologyLevel level);
+bool machine_parse_custom_topo_config(MachineState *ms,
+                                      const SMPConfiguration *config,
+                                      Error **errp);
 
 #endif /* CPU_SLOT_H */
diff --git a/qapi/machine.json b/qapi/machine.json
index a6b8795b09ed..2d5c6e4becd1 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -1695,6 +1695,21 @@
 #
 # @threads: number of threads per core
 #
+# @maxsockets: maximum number of sockets allowed to be created per
+#     parent container in custom CPU topology tree (since 10.0)
+#
+# @maxdies: maximum number of dies allowed to be created per parent
+#     container in custom CPU topology tree (since 10.0)
+#
+# @maxmodules: maximum number of modules allowed to be created per
+#     parent container in custom CPU topology tree (since 10.0)
+#
+# @maxcores: maximum number of cores allowed to be created per parent
+#     container in custom CPU topology tree (since 10.0)
+#
+# @maxthreads: maximum number of threads allowed to be created per
+#     parent container in custom CPU topology tree (since 10.0)
+#
 # Since: 6.1
 ##
 { 'struct': 'SMPConfiguration', 'data': {
@@ -1707,7 +1722,12 @@
      '*modules': 'int',
      '*cores': 'int',
      '*threads': 'int',
-     '*maxcpus': 'int' } }
+     '*maxcpus': 'int',
+     '*maxsockets': 'int',
+     '*maxdies': 'int',
+     '*maxmodules': 'int',
+     '*maxcores': 'int',
+     '*maxthreads': 'int' } }
 
 ##
 # @x-query-irq:
diff --git a/stubs/machine-stubs.c b/stubs/machine-stubs.c
new file mode 100644
index 000000000000..e592504fef6b
--- /dev/null
+++ b/stubs/machine-stubs.c
@@ -0,0 +1,21 @@
+/*
+ * Machine stubs
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
+
+bool machine_parse_custom_topo_config(MachineState *ms,
+                                      const SMPConfiguration *config,
+                                      Error **errp)
+{
+    return true;
+}
diff --git a/stubs/meson.build b/stubs/meson.build
index 772a3e817df2..406a7efc5bcb 100644
--- a/stubs/meson.build
+++ b/stubs/meson.build
@@ -66,6 +66,7 @@ if have_system
   stub_ss.add(files('dump.c'))
   stub_ss.add(files('cmos.c'))
   stub_ss.add(files('fw_cfg.c'))
+  stub_ss.add(files('machine-stubs.c'))
   stub_ss.add(files('target-get-monitor-def.c'))
   stub_ss.add(files('target-monitor-defs.c'))
   stub_ss.add(files('win32-kbd-hook.c'))
-- 
2.34.1



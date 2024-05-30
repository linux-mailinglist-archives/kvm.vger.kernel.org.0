Return-Path: <kvm+bounces-18381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3AAF8D4911
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 12:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44133280E43
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 10:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631291761AC;
	Thu, 30 May 2024 10:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YgY1Khri"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6B618398E
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 10:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717063230; cv=none; b=SM87AjNO3Hs3yJ1Pybs6NaI2uObQ90uNcMoXFKkYsZw3xRv9+fe1r2ouDFXUosTnUhy5SNCAewig0leOtL+5hVU+Ru2NOYDRPy1wVd6ehIFtHHY7Ds1sowIRKvbwc3TFKUHGSC/H9UXhvK6J3TABkfp3D8uX2i+TDZUIQAElgYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717063230; c=relaxed/simple;
	bh=++BnYcoBcNAMGwyagrFEnDwmOHTuHk7IscfvAsNyKo8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r+uhwUnSQLqEsgre4nqQR8etYwheOn87ZwKB27HZBsTtsJQV/kw+6aoKz8TF5oNwzTiIU4Rk+RPOyCK9RycNNeG4LaOmyyv86ztSA6pyz29+lcSYsn95lcOJHqB/B+xtqLqNntPb6t4Zh+hrw1oE0VvYA4asWSICl6W0ED7ue+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YgY1Khri; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717063229; x=1748599229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=++BnYcoBcNAMGwyagrFEnDwmOHTuHk7IscfvAsNyKo8=;
  b=YgY1KhriG5OvebP9OTHGKXJKfEx7U1T+5XIZWDmURT2/T5hax/nliZ2K
   2h/NOw/lNzX4mbPB+B/4/bYLVdSW3+NOQNTinEbiDTJCgBfXD6qRbLxCP
   w/BmZfBEsSbNKFYVfZlGVr3q8+tpbYdddNgBC+Oe9jw31REFTU5eASN2O
   gPSDwngFvd93sSQ76hh3Y/BwQMjsbPzJb1CZJReunDMNpFSZ8/1aoe+/K
   6PGm7X91KqYtImCso9QCCGBPc0tz73XVW0gj4hc0Sbi3thPCP85vxstrt
   y5eTxSQLbWzY67aZsShQdwU7fFeqe8ftOg/mewj8Q1kDs1DXYxJlJGuyF
   A==;
X-CSE-ConnectionGUID: s1OeoQe/T7ax3e8/curqxA==
X-CSE-MsgGUID: W7ryGwS6Sf2uWdtK9vco/w==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="31032416"
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="31032416"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 03:00:28 -0700
X-CSE-ConnectionGUID: 2d6OwtX6Q7utcO6iS5tUWQ==
X-CSE-MsgGUID: Cq1pm51+TiWOBn8Wfc6VnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="35704936"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 30 May 2024 03:00:23 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 1/7] hw/core: Make CPU topology enumeration arch-agnostic
Date: Thu, 30 May 2024 18:15:33 +0800
Message-Id: <20240530101539.768484-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530101539.768484-1-zhao1.liu@intel.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cache topology needs to be defined based on CPU topology levels. Thus,
define CPU topology enumeration in qapi/machine.json to make it generic
for all architectures.

To match the general topology naming style, rename CPU_TOPO_LEVEL_SMT
and CPU_TOPO_LEVEL_PACKAGE to CPU_TOPO_LEVEL_THREAD and
CPU_TOPO_LEVEL_SOCKET.

Also, enumerate additional topology levels for non-i386 arches, and add
helpers for topology enumeration and string conversion.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC v1:
 * Use QAPI to enumerate CPU topology levels.
 * Drop string_to_cpu_topo() since QAPI will help to parse the topo
   levels.
---
 MAINTAINERS                    |  2 ++
 hw/core/cpu-topology.c         | 36 ++++++++++++++++++++++++++++++
 hw/core/meson.build            |  1 +
 include/hw/core/cpu-topology.h | 20 +++++++++++++++++
 include/hw/i386/topology.h     | 18 +--------------
 qapi/machine.json              | 40 ++++++++++++++++++++++++++++++++++
 target/i386/cpu.c              | 30 ++++++++++++-------------
 target/i386/cpu.h              |  4 ++--
 8 files changed, 117 insertions(+), 34 deletions(-)
 create mode 100644 hw/core/cpu-topology.c
 create mode 100644 include/hw/core/cpu-topology.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 448dc951c509..09173e8c953d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1875,6 +1875,7 @@ R: Yanan Wang <wangyanan55@huawei.com>
 S: Supported
 F: hw/core/cpu-common.c
 F: hw/core/cpu-sysemu.c
+F: hw/core/cpu-topology.c
 F: hw/core/machine-qmp-cmds.c
 F: hw/core/machine.c
 F: hw/core/machine-smp.c
@@ -1886,6 +1887,7 @@ F: qapi/machine-common.json
 F: qapi/machine-target.json
 F: include/hw/boards.h
 F: include/hw/core/cpu.h
+F: include/hw/core/cpu-topology.h
 F: include/hw/cpu/cluster.h
 F: include/sysemu/numa.h
 F: tests/unit/test-smp-parse.c
diff --git a/hw/core/cpu-topology.c b/hw/core/cpu-topology.c
new file mode 100644
index 000000000000..20b5d708cb54
--- /dev/null
+++ b/hw/core/cpu-topology.c
@@ -0,0 +1,36 @@
+/*
+ * QEMU CPU Topology Representation
+ *
+ * Copyright (c) 2024 Intel Corporation
+ *
+ * Authors:
+ *  Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#include "qemu/osdep.h"
+#include "hw/core/cpu-topology.h"
+
+typedef struct CPUTopoInfo {
+    const char *name;
+} CPUTopoInfo;
+
+CPUTopoInfo cpu_topo_descriptors[] = {
+    [CPU_TOPO_LEVEL_INVALID] = { .name = "invalid", },
+    [CPU_TOPO_LEVEL_THREAD]  = { .name = "thread",  },
+    [CPU_TOPO_LEVEL_CORE]    = { .name = "core",    },
+    [CPU_TOPO_LEVEL_MODULE]  = { .name = "module",  },
+    [CPU_TOPO_LEVEL_CLUSTER] = { .name = "cluster", },
+    [CPU_TOPO_LEVEL_DIE]     = { .name = "die",     },
+    [CPU_TOPO_LEVEL_SOCKET]  = { .name = "socket",  },
+    [CPU_TOPO_LEVEL_BOOK]    = { .name = "book",    },
+    [CPU_TOPO_LEVEL_DRAWER]  = { .name = "drawer",  },
+    [CPU_TOPO_LEVEL__MAX]    = { .name = NULL,      },
+};
+
+const char *cpu_topo_to_string(CPUTopoLevel topo)
+{
+    return cpu_topo_descriptors[topo].name;
+}
diff --git a/hw/core/meson.build b/hw/core/meson.build
index a3d9bab9f42a..71dc396e9bfc 100644
--- a/hw/core/meson.build
+++ b/hw/core/meson.build
@@ -13,6 +13,7 @@ hwcore_ss.add(files(
 ))
 
 common_ss.add(files('cpu-common.c'))
+common_ss.add(files('cpu-topology.c'))
 common_ss.add(files('machine-smp.c'))
 system_ss.add(when: 'CONFIG_FITLOADER', if_true: files('loader-fit.c'))
 system_ss.add(when: 'CONFIG_GENERIC_LOADER', if_true: files('generic-loader.c'))
diff --git a/include/hw/core/cpu-topology.h b/include/hw/core/cpu-topology.h
new file mode 100644
index 000000000000..0e21fe8a9bf8
--- /dev/null
+++ b/include/hw/core/cpu-topology.h
@@ -0,0 +1,20 @@
+/*
+ * QEMU CPU Topology Representation Header
+ *
+ * Copyright (c) 2024 Intel Corporation
+ *
+ * Authors:
+ *  Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#ifndef CPU_TOPOLOGY_H
+#define CPU_TOPOLOGY_H
+
+#include "qapi/qapi-types-machine.h"
+
+const char *cpu_topo_to_string(CPUTopoLevel topo);
+
+#endif /* CPU_TOPOLOGY_H */
diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
index dff49fce1154..c6ff75f23991 100644
--- a/include/hw/i386/topology.h
+++ b/include/hw/i386/topology.h
@@ -39,7 +39,7 @@
  *  CPUID Fn8000_0008_ECX[ApicIdCoreIdSize[3:0]] is set to apicid_core_width().
  */
 
-
+#include "hw/core/cpu-topology.h"
 #include "qemu/bitops.h"
 
 /*
@@ -62,22 +62,6 @@ typedef struct X86CPUTopoInfo {
     unsigned threads_per_core;
 } X86CPUTopoInfo;
 
-/*
- * CPUTopoLevel is the general i386 topology hierarchical representation,
- * ordered by increasing hierarchical relationship.
- * Its enumeration value is not bound to the type value of Intel (CPUID[0x1F])
- * or AMD (CPUID[0x80000026]).
- */
-enum CPUTopoLevel {
-    CPU_TOPO_LEVEL_INVALID,
-    CPU_TOPO_LEVEL_SMT,
-    CPU_TOPO_LEVEL_CORE,
-    CPU_TOPO_LEVEL_MODULE,
-    CPU_TOPO_LEVEL_DIE,
-    CPU_TOPO_LEVEL_PACKAGE,
-    CPU_TOPO_LEVEL_MAX,
-};
-
 /* Return the bit width needed for 'count' IDs */
 static unsigned apicid_bitwidth_for_count(unsigned count)
 {
diff --git a/qapi/machine.json b/qapi/machine.json
index bce6e1bbc412..7ac5a05bb9c9 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -1667,6 +1667,46 @@
      '*reboot-timeout': 'int',
      '*strict': 'bool' } }
 
+##
+# @CPUTopoLevel:
+#
+# An enumeration of CPU topology levels.
+#
+# @invalid: Invalid topology level, used as a placeholder.
+#
+# @thread: thread level, which would also be called SMT level or logical
+#     processor level. The @threads option in -smp is used to configure
+#     the topology of this level.
+#
+# @core: core level. The @cores option in -smp is used to configure the
+#     topology of this level.
+#
+# @module: module level. The @modules option in -smp is used to
+#     configure the topology of this level.
+#
+# @cluster: cluster level. The @clusters option in -smp is used to
+#     configure the topology of this level.
+#
+# @die: die level. The @dies option in -smp is used to configure the
+#     topology of this level.
+#
+# @socket: socket level, which would also be called package level. The
+#     @sockets option in -smp is used to configure the topology of this
+#     level.
+#
+# @book: book level. The @books option in -smp is used to configure the
+#     topology of this level.
+#
+# @drawer: drawer level. The @drawers option in -smp is used to
+#     configure the topology of this level.
+#
+# Since: 9.1
+##
+{ 'enum': 'CPUTopoLevel',
+  'prefix': 'CPU_TOPO_LEVEL',
+  'data': [ 'invalid', 'thread', 'core', 'module', 'cluster',
+            'die', 'socket', 'book', 'drawer' ] }
+
 ##
 # @SMPConfiguration:
 #
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index bc2dceb647fa..b11097b5bafd 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -247,12 +247,12 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
     case CPU_TOPO_LEVEL_DIE:
         num_ids = 1 << apicid_die_offset(topo_info);
         break;
-    case CPU_TOPO_LEVEL_PACKAGE:
+    case CPU_TOPO_LEVEL_SOCKET:
         num_ids = 1 << apicid_pkg_offset(topo_info);
         break;
     default:
         /*
-         * Currently there is no use case for SMT and MODULE, so use
+         * Currently there is no use case for THREAD and MODULE, so use
          * assert directly to facilitate debugging.
          */
         g_assert_not_reached();
@@ -304,7 +304,7 @@ static uint32_t num_threads_by_topo_level(X86CPUTopoInfo *topo_info,
                                           enum CPUTopoLevel topo_level)
 {
     switch (topo_level) {
-    case CPU_TOPO_LEVEL_SMT:
+    case CPU_TOPO_LEVEL_THREAD:
         return 1;
     case CPU_TOPO_LEVEL_CORE:
         return topo_info->threads_per_core;
@@ -313,7 +313,7 @@ static uint32_t num_threads_by_topo_level(X86CPUTopoInfo *topo_info,
     case CPU_TOPO_LEVEL_DIE:
         return topo_info->threads_per_core * topo_info->cores_per_module *
                topo_info->modules_per_die;
-    case CPU_TOPO_LEVEL_PACKAGE:
+    case CPU_TOPO_LEVEL_SOCKET:
         return topo_info->threads_per_core * topo_info->cores_per_module *
                topo_info->modules_per_die * topo_info->dies_per_pkg;
     default:
@@ -326,7 +326,7 @@ static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
                                             enum CPUTopoLevel topo_level)
 {
     switch (topo_level) {
-    case CPU_TOPO_LEVEL_SMT:
+    case CPU_TOPO_LEVEL_THREAD:
         return 0;
     case CPU_TOPO_LEVEL_CORE:
         return apicid_core_offset(topo_info);
@@ -334,7 +334,7 @@ static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
         return apicid_module_offset(topo_info);
     case CPU_TOPO_LEVEL_DIE:
         return apicid_die_offset(topo_info);
-    case CPU_TOPO_LEVEL_PACKAGE:
+    case CPU_TOPO_LEVEL_SOCKET:
         return apicid_pkg_offset(topo_info);
     default:
         g_assert_not_reached();
@@ -347,7 +347,7 @@ static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
     switch (topo_level) {
     case CPU_TOPO_LEVEL_INVALID:
         return CPUID_1F_ECX_TOPO_LEVEL_INVALID;
-    case CPU_TOPO_LEVEL_SMT:
+    case CPU_TOPO_LEVEL_THREAD:
         return CPUID_1F_ECX_TOPO_LEVEL_SMT;
     case CPU_TOPO_LEVEL_CORE:
         return CPUID_1F_ECX_TOPO_LEVEL_CORE;
@@ -371,7 +371,7 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
     unsigned long level, next_level;
     uint32_t num_threads_next_level, offset_next_level;
 
-    assert(count + 1 < CPU_TOPO_LEVEL_MAX);
+    assert(count + 1 < CPU_TOPO_LEVEL__MAX);
 
     /*
      * Find the No.(count + 1) topology level in avail_cpu_topo bitmap.
@@ -380,7 +380,7 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
     level = CPU_TOPO_LEVEL_INVALID;
     for (int i = 0; i <= count; i++) {
         level = find_next_bit(env->avail_cpu_topo,
-                              CPU_TOPO_LEVEL_PACKAGE,
+                              CPU_TOPO_LEVEL_SOCKET,
                               level + 1);
 
         /*
@@ -388,7 +388,7 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
          * and it just encodes the invalid level (all fields are 0)
          * into the last subleaf of 0x1f.
          */
-        if (level == CPU_TOPO_LEVEL_PACKAGE) {
+        if (level == CPU_TOPO_LEVEL_SOCKET) {
             level = CPU_TOPO_LEVEL_INVALID;
             break;
         }
@@ -399,7 +399,7 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
         offset_next_level = 0;
     } else {
         next_level = find_next_bit(env->avail_cpu_topo,
-                                   CPU_TOPO_LEVEL_PACKAGE,
+                                   CPU_TOPO_LEVEL_SOCKET,
                                    level + 1);
         num_threads_next_level = num_threads_by_topo_level(topo_info,
                                                            next_level);
@@ -6435,7 +6435,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 
                     /* Share the cache at package level. */
                     *eax |= max_thread_ids_for_cache(&topo_info,
-                                CPU_TOPO_LEVEL_PACKAGE) << 14;
+                                CPU_TOPO_LEVEL_SOCKET) << 14;
                 }
             }
         } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
@@ -7935,10 +7935,10 @@ static void x86_cpu_init_default_topo(X86CPU *cpu)
     env->nr_modules = 1;
     env->nr_dies = 1;
 
-    /* SMT, core and package levels are set by default. */
-    set_bit(CPU_TOPO_LEVEL_SMT, env->avail_cpu_topo);
+    /* thread, core and socket levels are set by default. */
+    set_bit(CPU_TOPO_LEVEL_THREAD, env->avail_cpu_topo);
     set_bit(CPU_TOPO_LEVEL_CORE, env->avail_cpu_topo);
-    set_bit(CPU_TOPO_LEVEL_PACKAGE, env->avail_cpu_topo);
+    set_bit(CPU_TOPO_LEVEL_SOCKET, env->avail_cpu_topo);
 }
 
 static void x86_cpu_initfn(Object *obj)
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c64ef0c1a287..c6d07f38a1e8 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1606,7 +1606,7 @@ typedef struct CPUCacheInfo {
      * Used to encode CPUID[4].EAX[bits 25:14] or
      * CPUID[0x8000001D].EAX[bits 25:14].
      */
-    enum CPUTopoLevel share_level;
+    CPUTopoLevel share_level;
 } CPUCacheInfo;
 
 
@@ -1921,7 +1921,7 @@ typedef struct CPUArchState {
     unsigned nr_modules;
 
     /* Bitmap of available CPU topology levels for this CPU. */
-    DECLARE_BITMAP(avail_cpu_topo, CPU_TOPO_LEVEL_MAX);
+    DECLARE_BITMAP(avail_cpu_topo, CPU_TOPO_LEVEL__MAX);
 } CPUX86State;
 
 struct kvm_msrs;
-- 
2.34.1



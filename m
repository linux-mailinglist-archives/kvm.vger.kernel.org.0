Return-Path: <kvm+bounces-9155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 224BE85B6F3
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5056F2854CE
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E80657C4;
	Tue, 20 Feb 2024 09:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IFp1cIl/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1586A5FDB0
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 09:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708420318; cv=none; b=nOuHxkvX9j6u0ZgGt3pFK4AqaIbc0AqjXvjz8GNc6DuHPu+F7r7uiVw2UrvjAiX4XpNsQA+IaDpVNToZ02OqC2LPHqm5sxuz/YzgfZQQPLSE5hhKbfGj5PSALj2t98UgWqcpDjVWpemu3cvosxUJ0x8P3cxfXDkxgTDpY4x7wIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708420318; c=relaxed/simple;
	bh=nXvdPraIKnI4AFbDZfobt0iujTMEBz7nDxXX+7ZH9uk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KCbCvG76IgMnHUfwdPG+ubuBEWN7xP9nmgaNp9tTbAUQf1HA8voeh2wBnnNE6vjDESZHJzUPxHbYQNZ0aGmSkBHGt7f3uleNKsuVDcyD7sDXcufc/tRYhJLsM3TQsnPfXBzV902XrkVBBk24WYQP3K7x/qCkaTpvnjfWgLHn9ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IFp1cIl/; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708420316; x=1739956316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nXvdPraIKnI4AFbDZfobt0iujTMEBz7nDxXX+7ZH9uk=;
  b=IFp1cIl/rHN9JO3Cq/UpYfvMYyqTZu0a7eIeGg55v5GPA+/u4icuzMta
   DYLwRvi/U42R0GO6VQQI9HZ1SopYIVg6hYaBB59Q6tGezZASwbEZHUXZD
   i2y+lWrGSorEnxT4ralPC8ZGjqIgxhvCdFNrCofOd+jiaRa2KS+l5CGrf
   JR4VZPuqd0E+3TKNfSYpRl0jvcGpZwhuUGNh35rQaCsCmyOEU/cr2uVwn
   nV2L5DDOoIHfgtaTOE8/v9l5n68EYLhujg+jgde4/saVaXL349HsRtJEq
   XPdWmb3FBW8v6zj21IRZYYwVQoizYjSsbZ1qNotLIlV5oeFjvK1BcJv+V
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2374971"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="2374971"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 01:11:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="5012880"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 20 Feb 2024 01:11:50 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
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
Subject: [RFC 2/8] hw/core: Move CPU topology enumeration into arch-agnostic file
Date: Tue, 20 Feb 2024 17:24:58 +0800
Message-Id: <20240220092504.726064-3-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Cache topology needs to be defined based on CPU topology levels. Thus,
move CPU topology enumeration into a common header.

To match the general topology naming style, rename CPU_TOPO_LEVEL_SMT
and CPU_TOPO_LEVEL_PACKAGE to CPU_TOPO_LEVEL_THREAD and
CPU_TOPO_LEVEL_SOCKET.

Also, enumerate additional topology levels for non-i386 arches, and add
helpers for topology enumeration and string conversion.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS                    |  2 ++
 hw/core/cpu-topology.c         | 56 ++++++++++++++++++++++++++++++++++
 hw/core/meson.build            |  1 +
 include/hw/core/cpu-topology.h | 40 ++++++++++++++++++++++++
 include/hw/i386/topology.h     | 18 +----------
 target/i386/cpu.c              | 24 +++++++--------
 target/i386/cpu.h              |  2 +-
 tests/unit/meson.build         |  3 +-
 8 files changed, 115 insertions(+), 31 deletions(-)
 create mode 100644 hw/core/cpu-topology.c
 create mode 100644 include/hw/core/cpu-topology.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7d61fb93194b..4b1cce938915 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1871,6 +1871,7 @@ R: Yanan Wang <wangyanan55@huawei.com>
 S: Supported
 F: hw/core/cpu-common.c
 F: hw/core/cpu-sysemu.c
+F: hw/core/cpu-topology.c
 F: hw/core/machine-qmp-cmds.c
 F: hw/core/machine.c
 F: hw/core/machine-smp.c
@@ -1882,6 +1883,7 @@ F: qapi/machine-common.json
 F: qapi/machine-target.json
 F: include/hw/boards.h
 F: include/hw/core/cpu.h
+F: include/hw/core/cpu-topology.h
 F: include/hw/cpu/cluster.h
 F: include/sysemu/numa.h
 F: tests/unit/test-smp-parse.c
diff --git a/hw/core/cpu-topology.c b/hw/core/cpu-topology.c
new file mode 100644
index 000000000000..ca1361d13c16
--- /dev/null
+++ b/hw/core/cpu-topology.c
@@ -0,0 +1,56 @@
+/*
+ * QEMU CPU Topology Representation
+ *
+ * Copyright (c) 2024 Intel Corporation
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
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
+    [CPU_TOPO_LEVEL_MAX]     = { .name = NULL,      },
+};
+
+const char *cpu_topo_to_string(CPUTopoLevel topo)
+{
+    return cpu_topo_descriptors[topo].name;
+}
+
+CPUTopoLevel string_to_cpu_topo(char *str)
+{
+    for (int i = 0; i < ARRAY_SIZE(cpu_topo_descriptors); i++) {
+        CPUTopoInfo *info = &cpu_topo_descriptors[i];
+
+        if (!strcmp(info->name, str)) {
+            return (CPUTopoLevel)i;
+        }
+    }
+    return CPU_TOPO_LEVEL_MAX;
+}
diff --git a/hw/core/meson.build b/hw/core/meson.build
index 67dad04de559..3b1d5ffab3e3 100644
--- a/hw/core/meson.build
+++ b/hw/core/meson.build
@@ -23,6 +23,7 @@ else
 endif
 
 common_ss.add(files('cpu-common.c'))
+common_ss.add(files('cpu-topology.c'))
 common_ss.add(files('machine-smp.c'))
 system_ss.add(when: 'CONFIG_FITLOADER', if_true: files('loader-fit.c'))
 system_ss.add(when: 'CONFIG_GENERIC_LOADER', if_true: files('generic-loader.c'))
diff --git a/include/hw/core/cpu-topology.h b/include/hw/core/cpu-topology.h
new file mode 100644
index 000000000000..cc6ca186ce3f
--- /dev/null
+++ b/include/hw/core/cpu-topology.h
@@ -0,0 +1,40 @@
+/*
+ * QEMU CPU Topology Representation Header
+ *
+ * Copyright (c) 2024 Intel Corporation
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef CPU_TOPOLOGY_H
+#define CPU_TOPOLOGY_H
+
+typedef enum CPUTopoLevel {
+    CPU_TOPO_LEVEL_INVALID,
+    CPU_TOPO_LEVEL_THREAD,
+    CPU_TOPO_LEVEL_CORE,
+    CPU_TOPO_LEVEL_MODULE,
+    CPU_TOPO_LEVEL_CLUSTER,
+    CPU_TOPO_LEVEL_DIE,
+    CPU_TOPO_LEVEL_SOCKET,
+    CPU_TOPO_LEVEL_BOOK,
+    CPU_TOPO_LEVEL_DRAWER,
+    CPU_TOPO_LEVEL_MAX,
+} CPUTopoLevel;
+
+const char *cpu_topo_to_string(CPUTopoLevel topo);
+CPUTopoLevel string_to_cpu_topo(char *str);
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
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index ac0a10abd45f..725d7e70182d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -247,7 +247,7 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
     case CPU_TOPO_LEVEL_DIE:
         num_ids = 1 << apicid_die_offset(topo_info);
         break;
-    case CPU_TOPO_LEVEL_PACKAGE:
+    case CPU_TOPO_LEVEL_SOCKET:
         num_ids = 1 << apicid_pkg_offset(topo_info);
         break;
     default:
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
@@ -380,7 +380,7 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
     level = CPU_TOPO_LEVEL_INVALID;
     for (int i = 0; i <= count; i++) {
         level = find_next_bit(env->avail_cpu_topo,
-                              CPU_TOPO_LEVEL_PACKAGE,
+                              CPU_TOPO_LEVEL_SOCKET,
                               level + 1);
 
         /*
@@ -388,7 +388,7 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
          * and it just encode the invalid level (all fields are 0)
          * into the last subleaf of 0x1f.
          */
-        if (level == CPU_TOPO_LEVEL_PACKAGE) {
+        if (level == CPU_TOPO_LEVEL_SOCKET) {
             level = CPU_TOPO_LEVEL_INVALID;
             break;
         }
@@ -401,7 +401,7 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
         unsigned long next_level;
 
         next_level = find_next_bit(env->avail_cpu_topo,
-                                   CPU_TOPO_LEVEL_PACKAGE,
+                                   CPU_TOPO_LEVEL_SOCKET,
                                    level + 1);
         num_threads_next_level = num_threads_by_topo_level(topo_info,
                                                            next_level);
@@ -6290,7 +6290,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 
                     /* Share the cache at package level. */
                     *eax |= max_thread_ids_for_cache(&topo_info,
-                                CPU_TOPO_LEVEL_PACKAGE) << 14;
+                                CPU_TOPO_LEVEL_SOCKET) << 14;
                 }
             }
         } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
@@ -7756,9 +7756,9 @@ static void x86_cpu_init_default_topo(X86CPU *cpu)
     env->nr_dies = 1;
 
     /* SMT, core and package levels are set by default. */
-    set_bit(CPU_TOPO_LEVEL_SMT, env->avail_cpu_topo);
+    set_bit(CPU_TOPO_LEVEL_THREAD, env->avail_cpu_topo);
     set_bit(CPU_TOPO_LEVEL_CORE, env->avail_cpu_topo);
-    set_bit(CPU_TOPO_LEVEL_PACKAGE, env->avail_cpu_topo);
+    set_bit(CPU_TOPO_LEVEL_SOCKET, env->avail_cpu_topo);
 }
 
 static void x86_cpu_initfn(Object *obj)
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 4b4cc70c8859..fcbf278b49e6 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1596,7 +1596,7 @@ typedef struct CPUCacheInfo {
      * Used to encode CPUID[4].EAX[bits 25:14] or
      * CPUID[0x8000001D].EAX[bits 25:14].
      */
-    enum CPUTopoLevel share_level;
+    CPUTopoLevel share_level;
 } CPUCacheInfo;
 
 
diff --git a/tests/unit/meson.build b/tests/unit/meson.build
index cae925c13259..4fe0aaff3a5e 100644
--- a/tests/unit/meson.build
+++ b/tests/unit/meson.build
@@ -138,7 +138,8 @@ if have_system
     'test-util-sockets': ['socket-helpers.c'],
     'test-base64': [],
     'test-bufferiszero': [],
-    'test-smp-parse': [qom, meson.project_source_root() / 'hw/core/machine-smp.c'],
+    'test-smp-parse': [qom, meson.project_source_root() / 'hw/core/machine-smp.c',
+                       meson.project_source_root() / 'hw/core/cpu-topology.c'],
     'test-vmstate': [migration, io],
     'test-yank': ['socket-helpers.c', qom, io, chardev]
   }
-- 
2.34.1



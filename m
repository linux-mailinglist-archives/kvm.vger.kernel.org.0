Return-Path: <kvm+bounces-20926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B356926DBD
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 05:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6A041F24059
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 03:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACC219BA6;
	Thu,  4 Jul 2024 03:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L1fx3jWv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F1718AED
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 03:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720062040; cv=none; b=fnCcSuyAN92vaNsCWUb0MlT9R+0izdRRbmFEAW7aQYjRe34vkYiSYq5xfIpeqK0q6nhUzFjEUOl0B/oLJtLC8PCV9VDJ6HGnDkY1RkUc9YOqzHCx/xrN8r/QdG54BxIAwPpQj7kOqmgf9+BmMd98uQJ/mCXoO3rfibO0fsNOa58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720062040; c=relaxed/simple;
	bh=y8DVuwDfBOx2kUhfnbErHM6n5qAnJYcEiam1NpZS4vU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uazUihqy9+4S4RtMGw2TS2NMOAxa9jAGBbV7qbmBnyw6lNIsb/0cjRqhHgyGguSQJ8W9m8XIr2wcC18E2WbSDCM5QPdi04oOMCSrIIW6lGUYvR6UyIp/IX9B5y9BN2X6SHAyxsANOfCZm3zPuDbT4Q/7EM7nX73K7XonJvJnm1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L1fx3jWv; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720062038; x=1751598038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y8DVuwDfBOx2kUhfnbErHM6n5qAnJYcEiam1NpZS4vU=;
  b=L1fx3jWvzHF7iR2cIxAFdkKgMOycPEMY0Rtt9e5OaYrrlQia4dhxNc+Z
   w01vGTB7k4ytviHAyslq/VxHxpM5D/cqFEhFYFB+SjDBgbuSm7SqUn2Gu
   4j3Ib8Bj2bo0h1b5TkA5lwYoncbE6YsjiU8GS+j+ZUomoB/C+GxdK4YgZ
   xG/+8WZiGrnabON7EgkNb7RrvTuw1Fdi/pSY+fN6xQx3YUqa/uyyYbM/m
   +nlKO8wu0J9qOjRM0+8CLoyoaweviBHGuBXov5vMR4ENUuIWP6p0UuY15
   Oj9cXXXwsKtZv6JEaCAHk30F6UdbDMWzo37ib3nybzBnlbYRPWLUeMbag
   Q==;
X-CSE-ConnectionGUID: qHVykvvYQTy5OFWaHWGwcA==
X-CSE-MsgGUID: 7Hlw9RVxSJqtsFmlr/aV+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="39838061"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="39838061"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 20:00:38 -0700
X-CSE-ConnectionGUID: i3qXcV1FRi2zABduduwTiQ==
X-CSE-MsgGUID: nB3x+nD7SyOCQEcI6EAoig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51052118"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jul 2024 20:00:33 -0700
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
Subject: [PATCH 1/8] hw/core: Make CPU topology enumeration arch-agnostic
Date: Thu,  4 Jul 2024 11:15:56 +0800
Message-Id: <20240704031603.1744546-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240704031603.1744546-1-zhao1.liu@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
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
a CPU_TOPO_LEVEL_DEFAULT to help future smp-cache object de-compatibilize
arch-specific cache topology settings.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC v2:
 * Dropped cpu-topology.h and cpu-topology.c since QAPI has the helper
   (CpuTopologyLevel_str) to convert enum to string. (Markus)
 * Fixed text format in machine.json (CpuTopologyLevel naming, 2 spaces
   between sentences). (Markus)
 * Added a new level "default" to de-compatibilize some arch-specific
   topo settings. (Daniel)
 * Moved CpuTopologyLevel to qapi/machine-common.json, at where the
   cache enumeration and smp-cache object would be added.
   - If smp-cache object is defined in qapi/machine.json, storage-daemon
     will complain about the qmp cmds in qapi/machine.json during
     compiling.

Changes since RFC v1:
 * Used QAPI to enumerate CPU topology levels.
 * Dropped string_to_cpu_topo() since QAPI will help to parse the topo
   levels.
---
 include/hw/i386/topology.h | 18 +--------------
 qapi/machine-common.json   | 47 +++++++++++++++++++++++++++++++++++++-
 target/i386/cpu.c          | 38 +++++++++++++++---------------
 target/i386/cpu.h          |  4 ++--
 4 files changed, 68 insertions(+), 39 deletions(-)

diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
index dff49fce1154..10d05ff045c7 100644
--- a/include/hw/i386/topology.h
+++ b/include/hw/i386/topology.h
@@ -39,7 +39,7 @@
  *  CPUID Fn8000_0008_ECX[ApicIdCoreIdSize[3:0]] is set to apicid_core_width().
  */
 
-
+#include "qapi/qapi-types-machine-common.h"
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
diff --git a/qapi/machine-common.json b/qapi/machine-common.json
index fa6bd71d1280..82413c668bdb 100644
--- a/qapi/machine-common.json
+++ b/qapi/machine-common.json
@@ -5,7 +5,7 @@
 # See the COPYING file in the top-level directory.
 
 ##
-# = Machines S390 data types
+# = Common machine types
 ##
 
 ##
@@ -19,3 +19,48 @@
 { 'enum': 'CpuS390Entitlement',
   'prefix': 'S390_CPU_ENTITLEMENT',
   'data': [ 'auto', 'low', 'medium', 'high' ] }
+
+##
+# @CpuTopologyLevel:
+#
+# An enumeration of CPU topology levels.
+#
+# @invalid: Invalid topology level.
+#
+# @thread: thread level, which would also be called SMT level or
+#     logical processor level.  The @threads option in
+#     SMPConfiguration is used to configure the topology of this
+#     level.
+#
+# @core: core level.  The @cores option in SMPConfiguration is used
+#     to configure the topology of this level.
+#
+# @module: module level.  The @modules option in SMPConfiguration is
+#     used to configure the topology of this level.
+#
+# @cluster: cluster level.  The @clusters option in SMPConfiguration
+#     is used to configure the topology of this level.
+#
+# @die: die level.  The @dies option in SMPConfiguration is used to
+#     configure the topology of this level.
+#
+# @socket: socket level, which would also be called package level.
+#     The @sockets option in SMPConfiguration is used to configure
+#     the topology of this level.
+#
+# @book: book level.  The @books option in SMPConfiguration is used
+#     to configure the topology of this level.
+#
+# @drawer: drawer level.  The @drawers option in SMPConfiguration is
+#     used to configure the topology of this level.
+#
+# @default: default level.  Some architectures will have default
+#     topology settings (e.g., cache topology), and this special
+#     level means following the architecture-specific settings.
+#
+# Since: 9.1
+##
+{ 'enum': 'CpuTopologyLevel',
+  'prefix': 'CPU_TOPO_LEVEL',
+  'data': [ 'invalid', 'thread', 'core', 'module', 'cluster',
+            'die', 'socket', 'book', 'drawer', 'default' ] }
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4c2e6f3a71e9..4ae3bbf30682 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -236,7 +236,7 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
                        0 /* Invalid value */)
 
 static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
-                                         enum CPUTopoLevel share_level)
+                                         enum CpuTopologyLevel share_level)
 {
     uint32_t num_ids = 0;
 
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
@@ -301,10 +301,10 @@ static void encode_cache_cpuid4(CPUCacheInfo *cache,
 }
 
 static uint32_t num_threads_by_topo_level(X86CPUTopoInfo *topo_info,
-                                          enum CPUTopoLevel topo_level)
+                                          enum CpuTopologyLevel topo_level)
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
@@ -323,10 +323,10 @@ static uint32_t num_threads_by_topo_level(X86CPUTopoInfo *topo_info,
 }
 
 static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
-                                            enum CPUTopoLevel topo_level)
+                                            enum CpuTopologyLevel topo_level)
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
@@ -342,12 +342,12 @@ static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
     return 0;
 }
 
-static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
+static uint32_t cpuid1f_topo_type(enum CpuTopologyLevel topo_level)
 {
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
@@ -6462,7 +6462,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 
                     /* Share the cache at package level. */
                     *eax |= max_thread_ids_for_cache(&topo_info,
-                                CPU_TOPO_LEVEL_PACKAGE) << 14;
+                                CPU_TOPO_LEVEL_SOCKET) << 14;
                 }
             }
         } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
@@ -7963,10 +7963,10 @@ static void x86_cpu_init_default_topo(X86CPU *cpu)
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
index 29daf3704857..9ddba249aa9e 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1653,7 +1653,7 @@ typedef struct CPUCacheInfo {
      * Used to encode CPUID[4].EAX[bits 25:14] or
      * CPUID[0x8000001D].EAX[bits 25:14].
      */
-    enum CPUTopoLevel share_level;
+    CpuTopologyLevel share_level;
 } CPUCacheInfo;
 
 
@@ -1979,7 +1979,7 @@ typedef struct CPUArchState {
     unsigned nr_modules;
 
     /* Bitmap of available CPU topology levels for this CPU. */
-    DECLARE_BITMAP(avail_cpu_topo, CPU_TOPO_LEVEL_MAX);
+    DECLARE_BITMAP(avail_cpu_topo, CPU_TOPO_LEVEL__MAX);
 } CPUX86State;
 
 struct kvm_msrs;
-- 
2.34.1



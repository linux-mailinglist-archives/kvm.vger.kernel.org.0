Return-Path: <kvm+bounces-30285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC8539B8CC4
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 09:16:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CC7C2865EF
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 08:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 437D9156649;
	Fri,  1 Nov 2024 08:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UDheNP/y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B874015531A
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 08:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730448974; cv=none; b=rDOb9mQSsjhP2xuO4OinpqRvCUNvIQQRbUvRVTqS11wYgDyFKGZA4rz4uUr5FT+8/+r1nGpEjDuWKvAKlE3F6OiDY0RSF9CSaSqWfz/A7AWZ9TwxceDYD7z9S3H8nbLlSIXzSozh6KKJwgoK2wyYx7dqdxpfzqGxxZ67gkoe2SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730448974; c=relaxed/simple;
	bh=cADX52QeG6aJc977vIccoDCUsDPglOq1brEwW5J7xMM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uWkB0tCtywhNGf3iD8lJCKJ4kOdJrOVozKkejjxV3kc4+7c6qo5ZxsR1VUJxGjcKWMkGNHsMRsZ8PxeLaBa+iIJ2y+VU0iZQDzbsTiLzvoxz4edSwsY7uejHxSLZoujb+ZweTYVBZbK5mcTp4xKWWtNjHFgy+fEVcz4zaLLyUD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UDheNP/y; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730448971; x=1761984971;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cADX52QeG6aJc977vIccoDCUsDPglOq1brEwW5J7xMM=;
  b=UDheNP/yGcYG2zy+iStyMTfpoCD5taYgu6E+4zg+4IsAcCraR+A4RwXc
   PEZnD7nfCOXc9VZ1PBrodHXjv/njNOzoMZysjPTMiwA0jtTHejEXX0i9M
   JZyR4clCTOTNLmrh2U93EupGSW99eFZ+Q6cU/qEkjA1ErPQXHcvqDzMRM
   lD/luL2pRGH+FJpJrzKbRRBSRhQx6iTJ4/pGFz/iRKEN4X2DMZJMrAdU8
   fdxHIi7RYen4W80ZkUUu7SfSbRvd6B+vYcBRKsmjox548Ht0aawU6D2Np
   hrABuwVreIKaD3APxCisXlLXTL/weTlZ3cotekmu4hacb0UIUv6Aybf2t
   A==;
X-CSE-ConnectionGUID: x/8cJEI8S5uoV4NqGX5N9Q==
X-CSE-MsgGUID: UZmWGrUcQACdIplu4Zc7fg==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="17846020"
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="17846020"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 01:16:11 -0700
X-CSE-ConnectionGUID: HYMegiioTyCNjXpIU4gNHA==
X-CSE-MsgGUID: YvcKsTwmRvi57eIKdrmIsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="86834585"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 01 Nov 2024 01:16:04 -0700
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
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v5 2/9] hw/core: Make CPU topology enumeration arch-agnostic
Date: Fri,  1 Nov 2024 16:33:24 +0800
Message-Id: <20241101083331.340178-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241101083331.340178-1-zhao1.liu@intel.com>
References: <20241101083331.340178-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Cache topology needs to be defined based on CPU topology levels. Thus,
define CPU topology enumeration in qapi/machine.json to make it generic
for all architectures.

To match the general topology naming style, rename CPU_TOPO_LEVEL_* to
CPU_TOPOLOGY_LEVEL_*, and rename SMT and package levels to thread and
socket.

Also, enumerate additional topology levels for non-i386 arches, and add
a CPU_TOPOLOGY_LEVEL_DEFAULT to help future smp-cache object to work
with compatibility requirement of arch-specific cache topology models.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
Changes since Patch v3:
 * Dropped "invalid" level to avoid an unsettable option. (Daniel)
---
 hw/i386/x86-common.c       |   4 +-
 include/hw/i386/topology.h |  23 ++----
 qapi/machine-common.json   |  44 +++++++++++-
 target/i386/cpu.c          | 144 ++++++++++++++++++-------------------
 target/i386/cpu.h          |   4 +-
 5 files changed, 123 insertions(+), 96 deletions(-)

diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index b86c38212eab..bc360a9ea44b 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -273,12 +273,12 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
 
     if (ms->smp.modules > 1) {
         env->nr_modules = ms->smp.modules;
-        set_bit(CPU_TOPO_LEVEL_MODULE, env->avail_cpu_topo);
+        set_bit(CPU_TOPOLOGY_LEVEL_MODULE, env->avail_cpu_topo);
     }
 
     if (ms->smp.dies > 1) {
         env->nr_dies = ms->smp.dies;
-        set_bit(CPU_TOPO_LEVEL_DIE, env->avail_cpu_topo);
+        set_bit(CPU_TOPOLOGY_LEVEL_DIE, env->avail_cpu_topo);
     }
 
     /*
diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
index 48b43edc5a90..b2c8bf2de158 100644
--- a/include/hw/i386/topology.h
+++ b/include/hw/i386/topology.h
@@ -39,7 +39,7 @@
  *  CPUID Fn8000_0008_ECX[ApicIdCoreIdSize[3:0]] is set to apicid_core_width().
  */
 
-
+#include "qapi/qapi-types-machine-common.h"
 #include "qemu/bitops.h"
 
 /*
@@ -62,22 +62,7 @@ typedef struct X86CPUTopoInfo {
     unsigned threads_per_core;
 } X86CPUTopoInfo;
 
-#define CPU_TOPO_LEVEL_INVALID CPU_TOPO_LEVEL_MAX
-
-/*
- * CPUTopoLevel is the general i386 topology hierarchical representation,
- * ordered by increasing hierarchical relationship.
- * Its enumeration value is not bound to the type value of Intel (CPUID[0x1F])
- * or AMD (CPUID[0x80000026]).
- */
-enum CPUTopoLevel {
-    CPU_TOPO_LEVEL_SMT,
-    CPU_TOPO_LEVEL_CORE,
-    CPU_TOPO_LEVEL_MODULE,
-    CPU_TOPO_LEVEL_DIE,
-    CPU_TOPO_LEVEL_PACKAGE,
-    CPU_TOPO_LEVEL_MAX,
-};
+#define CPU_TOPOLOGY_LEVEL_INVALID CPU_TOPOLOGY_LEVEL__MAX
 
 /* Return the bit width needed for 'count' IDs */
 static unsigned apicid_bitwidth_for_count(unsigned count)
@@ -213,8 +198,8 @@ static inline apic_id_t x86_apicid_from_cpu_idx(X86CPUTopoInfo *topo_info,
  */
 static inline bool x86_has_extended_topo(unsigned long *topo_bitmap)
 {
-    return test_bit(CPU_TOPO_LEVEL_MODULE, topo_bitmap) ||
-           test_bit(CPU_TOPO_LEVEL_DIE, topo_bitmap);
+    return test_bit(CPU_TOPOLOGY_LEVEL_MODULE, topo_bitmap) ||
+           test_bit(CPU_TOPOLOGY_LEVEL_DIE, topo_bitmap);
 }
 
 #endif /* HW_I386_TOPOLOGY_H */
diff --git a/qapi/machine-common.json b/qapi/machine-common.json
index b64e4895cfd7..1a5687fb99fc 100644
--- a/qapi/machine-common.json
+++ b/qapi/machine-common.json
@@ -5,7 +5,7 @@
 # See the COPYING file in the top-level directory.
 
 ##
-# = Machines S390 data types
+# = Common machine types
 ##
 
 ##
@@ -18,3 +18,45 @@
 ##
 { 'enum': 'S390CpuEntitlement',
   'data': [ 'auto', 'low', 'medium', 'high' ] }
+
+##
+# @CpuTopologyLevel:
+#
+# An enumeration of CPU topology levels.
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
+# Since: 9.2
+##
+{ 'enum': 'CpuTopologyLevel',
+  'data': [ 'thread', 'core', 'module', 'cluster', 'die',
+            'socket', 'book', 'drawer', 'default' ] }
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index ca13cf66a787..d46710a4030f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -238,23 +238,23 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
                        0 /* Invalid value */)
 
 static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
-                                         enum CPUTopoLevel share_level)
+                                         enum CpuTopologyLevel share_level)
 {
     uint32_t num_ids = 0;
 
     switch (share_level) {
-    case CPU_TOPO_LEVEL_CORE:
+    case CPU_TOPOLOGY_LEVEL_CORE:
         num_ids = 1 << apicid_core_offset(topo_info);
         break;
-    case CPU_TOPO_LEVEL_DIE:
+    case CPU_TOPOLOGY_LEVEL_DIE:
         num_ids = 1 << apicid_die_offset(topo_info);
         break;
-    case CPU_TOPO_LEVEL_PACKAGE:
+    case CPU_TOPOLOGY_LEVEL_SOCKET:
         num_ids = 1 << apicid_pkg_offset(topo_info);
         break;
     default:
         /*
-         * Currently there is no use case for SMT and MODULE, so use
+         * Currently there is no use case for THREAD and MODULE, so use
          * assert directly to facilitate debugging.
          */
         g_assert_not_reached();
@@ -303,19 +303,19 @@ static void encode_cache_cpuid4(CPUCacheInfo *cache,
 }
 
 static uint32_t num_threads_by_topo_level(X86CPUTopoInfo *topo_info,
-                                          enum CPUTopoLevel topo_level)
+                                          enum CpuTopologyLevel topo_level)
 {
     switch (topo_level) {
-    case CPU_TOPO_LEVEL_SMT:
+    case CPU_TOPOLOGY_LEVEL_THREAD:
         return 1;
-    case CPU_TOPO_LEVEL_CORE:
+    case CPU_TOPOLOGY_LEVEL_CORE:
         return topo_info->threads_per_core;
-    case CPU_TOPO_LEVEL_MODULE:
+    case CPU_TOPOLOGY_LEVEL_MODULE:
         return topo_info->threads_per_core * topo_info->cores_per_module;
-    case CPU_TOPO_LEVEL_DIE:
+    case CPU_TOPOLOGY_LEVEL_DIE:
         return topo_info->threads_per_core * topo_info->cores_per_module *
                topo_info->modules_per_die;
-    case CPU_TOPO_LEVEL_PACKAGE:
+    case CPU_TOPOLOGY_LEVEL_SOCKET:
         return topo_info->threads_per_core * topo_info->cores_per_module *
                topo_info->modules_per_die * topo_info->dies_per_pkg;
     default:
@@ -325,18 +325,18 @@ static uint32_t num_threads_by_topo_level(X86CPUTopoInfo *topo_info,
 }
 
 static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
-                                            enum CPUTopoLevel topo_level)
+                                            enum CpuTopologyLevel topo_level)
 {
     switch (topo_level) {
-    case CPU_TOPO_LEVEL_SMT:
+    case CPU_TOPOLOGY_LEVEL_THREAD:
         return 0;
-    case CPU_TOPO_LEVEL_CORE:
+    case CPU_TOPOLOGY_LEVEL_CORE:
         return apicid_core_offset(topo_info);
-    case CPU_TOPO_LEVEL_MODULE:
+    case CPU_TOPOLOGY_LEVEL_MODULE:
         return apicid_module_offset(topo_info);
-    case CPU_TOPO_LEVEL_DIE:
+    case CPU_TOPOLOGY_LEVEL_DIE:
         return apicid_die_offset(topo_info);
-    case CPU_TOPO_LEVEL_PACKAGE:
+    case CPU_TOPOLOGY_LEVEL_SOCKET:
         return apicid_pkg_offset(topo_info);
     default:
         g_assert_not_reached();
@@ -344,18 +344,18 @@ static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
     return 0;
 }
 
-static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
+static uint32_t cpuid1f_topo_type(enum CpuTopologyLevel topo_level)
 {
     switch (topo_level) {
-    case CPU_TOPO_LEVEL_INVALID:
+    case CPU_TOPOLOGY_LEVEL_INVALID:
         return CPUID_1F_ECX_TOPO_LEVEL_INVALID;
-    case CPU_TOPO_LEVEL_SMT:
+    case CPU_TOPOLOGY_LEVEL_THREAD:
         return CPUID_1F_ECX_TOPO_LEVEL_SMT;
-    case CPU_TOPO_LEVEL_CORE:
+    case CPU_TOPOLOGY_LEVEL_CORE:
         return CPUID_1F_ECX_TOPO_LEVEL_CORE;
-    case CPU_TOPO_LEVEL_MODULE:
+    case CPU_TOPOLOGY_LEVEL_MODULE:
         return CPUID_1F_ECX_TOPO_LEVEL_MODULE;
-    case CPU_TOPO_LEVEL_DIE:
+    case CPU_TOPOLOGY_LEVEL_DIE:
         return CPUID_1F_ECX_TOPO_LEVEL_DIE;
     default:
         /* Other types are not supported in QEMU. */
@@ -373,17 +373,17 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
     unsigned long level, base_level, next_level;
     uint32_t num_threads_next_level, offset_next_level;
 
-    assert(count <= CPU_TOPO_LEVEL_PACKAGE);
+    assert(count <= CPU_TOPOLOGY_LEVEL_SOCKET);
 
     /*
      * Find the No.(count + 1) topology level in avail_cpu_topo bitmap.
-     * The search starts from bit 0 (CPU_TOPO_LEVEL_SMT).
+     * The search starts from bit 0 (CPU_TOPOLOGY_LEVEL_THREAD).
      */
-    level = CPU_TOPO_LEVEL_SMT;
+    level = CPU_TOPOLOGY_LEVEL_THREAD;
     base_level = level;
     for (int i = 0; i <= count; i++) {
         level = find_next_bit(env->avail_cpu_topo,
-                              CPU_TOPO_LEVEL_PACKAGE,
+                              CPU_TOPOLOGY_LEVEL_SOCKET,
                               base_level);
 
         /*
@@ -391,20 +391,20 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
          * and it just encodes the invalid level (all fields are 0)
          * into the last subleaf of 0x1f.
          */
-        if (level == CPU_TOPO_LEVEL_PACKAGE) {
-            level = CPU_TOPO_LEVEL_INVALID;
+        if (level == CPU_TOPOLOGY_LEVEL_SOCKET) {
+            level = CPU_TOPOLOGY_LEVEL_INVALID;
             break;
         }
         /* Search the next level. */
         base_level = level + 1;
     }
 
-    if (level == CPU_TOPO_LEVEL_INVALID) {
+    if (level == CPU_TOPOLOGY_LEVEL_INVALID) {
         num_threads_next_level = 0;
         offset_next_level = 0;
     } else {
         next_level = find_next_bit(env->avail_cpu_topo,
-                                   CPU_TOPO_LEVEL_PACKAGE,
+                                   CPU_TOPOLOGY_LEVEL_SOCKET,
                                    level + 1);
         num_threads_next_level = num_threads_by_topo_level(topo_info,
                                                            next_level);
@@ -580,7 +580,7 @@ static CPUCacheInfo legacy_l1d_cache = {
     .sets = 64,
     .partitions = 1,
     .no_invd_sharing = true,
-    .share_level = CPU_TOPO_LEVEL_CORE,
+    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
 /*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */
@@ -595,7 +595,7 @@ static CPUCacheInfo legacy_l1d_cache_amd = {
     .partitions = 1,
     .lines_per_tag = 1,
     .no_invd_sharing = true,
-    .share_level = CPU_TOPO_LEVEL_CORE,
+    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
 /* L1 instruction cache: */
@@ -609,7 +609,7 @@ static CPUCacheInfo legacy_l1i_cache = {
     .sets = 64,
     .partitions = 1,
     .no_invd_sharing = true,
-    .share_level = CPU_TOPO_LEVEL_CORE,
+    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
 /*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */
@@ -624,7 +624,7 @@ static CPUCacheInfo legacy_l1i_cache_amd = {
     .partitions = 1,
     .lines_per_tag = 1,
     .no_invd_sharing = true,
-    .share_level = CPU_TOPO_LEVEL_CORE,
+    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
 /* Level 2 unified cache: */
@@ -638,7 +638,7 @@ static CPUCacheInfo legacy_l2_cache = {
     .sets = 4096,
     .partitions = 1,
     .no_invd_sharing = true,
-    .share_level = CPU_TOPO_LEVEL_CORE,
+    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
 /*FIXME: CPUID leaf 2 descriptor is inconsistent with CPUID leaf 4 */
@@ -648,7 +648,7 @@ static CPUCacheInfo legacy_l2_cache_cpuid2 = {
     .size = 2 * MiB,
     .line_size = 64,
     .associativity = 8,
-    .share_level = CPU_TOPO_LEVEL_INVALID,
+    .share_level = CPU_TOPOLOGY_LEVEL_INVALID,
 };
 
 
@@ -662,7 +662,7 @@ static CPUCacheInfo legacy_l2_cache_amd = {
     .associativity = 16,
     .sets = 512,
     .partitions = 1,
-    .share_level = CPU_TOPO_LEVEL_CORE,
+    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
 /* Level 3 unified cache: */
@@ -678,7 +678,7 @@ static CPUCacheInfo legacy_l3_cache = {
     .self_init = true,
     .inclusive = true,
     .complex_indexing = true,
-    .share_level = CPU_TOPO_LEVEL_DIE,
+    .share_level = CPU_TOPOLOGY_LEVEL_DIE,
 };
 
 /* TLB definitions: */
@@ -2085,7 +2085,7 @@ static const CPUCaches epyc_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2098,7 +2098,7 @@ static const CPUCaches epyc_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2109,7 +2109,7 @@ static const CPUCaches epyc_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2123,7 +2123,7 @@ static const CPUCaches epyc_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = true,
-        .share_level = CPU_TOPO_LEVEL_DIE,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
     },
 };
 
@@ -2139,7 +2139,7 @@ static CPUCaches epyc_v4_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2152,7 +2152,7 @@ static CPUCaches epyc_v4_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2163,7 +2163,7 @@ static CPUCaches epyc_v4_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2177,7 +2177,7 @@ static CPUCaches epyc_v4_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = false,
-        .share_level = CPU_TOPO_LEVEL_DIE,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
     },
 };
 
@@ -2193,7 +2193,7 @@ static const CPUCaches epyc_rome_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2206,7 +2206,7 @@ static const CPUCaches epyc_rome_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2217,7 +2217,7 @@ static const CPUCaches epyc_rome_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2231,7 +2231,7 @@ static const CPUCaches epyc_rome_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = true,
-        .share_level = CPU_TOPO_LEVEL_DIE,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
     },
 };
 
@@ -2247,7 +2247,7 @@ static const CPUCaches epyc_rome_v3_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2260,7 +2260,7 @@ static const CPUCaches epyc_rome_v3_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2271,7 +2271,7 @@ static const CPUCaches epyc_rome_v3_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2285,7 +2285,7 @@ static const CPUCaches epyc_rome_v3_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = false,
-        .share_level = CPU_TOPO_LEVEL_DIE,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
     },
 };
 
@@ -2301,7 +2301,7 @@ static const CPUCaches epyc_milan_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2314,7 +2314,7 @@ static const CPUCaches epyc_milan_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2325,7 +2325,7 @@ static const CPUCaches epyc_milan_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2339,7 +2339,7 @@ static const CPUCaches epyc_milan_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = true,
-        .share_level = CPU_TOPO_LEVEL_DIE,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
     },
 };
 
@@ -2355,7 +2355,7 @@ static const CPUCaches epyc_milan_v2_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2368,7 +2368,7 @@ static const CPUCaches epyc_milan_v2_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2379,7 +2379,7 @@ static const CPUCaches epyc_milan_v2_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2393,7 +2393,7 @@ static const CPUCaches epyc_milan_v2_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = false,
-        .share_level = CPU_TOPO_LEVEL_DIE,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
     },
 };
 
@@ -2409,7 +2409,7 @@ static const CPUCaches epyc_genoa_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2422,7 +2422,7 @@ static const CPUCaches epyc_genoa_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2433,7 +2433,7 @@ static const CPUCaches epyc_genoa_cache_info = {
         .partitions = 1,
         .sets = 2048,
         .lines_per_tag = 1,
-        .share_level = CPU_TOPO_LEVEL_CORE,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2447,7 +2447,7 @@ static const CPUCaches epyc_genoa_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = false,
-        .share_level = CPU_TOPO_LEVEL_DIE,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
     },
 };
 
@@ -6591,7 +6591,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 
                     /* Share the cache at package level. */
                     *eax |= max_thread_ids_for_cache(&topo_info,
-                                CPU_TOPO_LEVEL_PACKAGE) << 14;
+                                CPU_TOPOLOGY_LEVEL_SOCKET) << 14;
                 }
             }
         } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
@@ -8169,10 +8169,10 @@ static void x86_cpu_init_default_topo(X86CPU *cpu)
     env->nr_modules = 1;
     env->nr_dies = 1;
 
-    /* SMT, core and package levels are set by default. */
-    set_bit(CPU_TOPO_LEVEL_SMT, env->avail_cpu_topo);
-    set_bit(CPU_TOPO_LEVEL_CORE, env->avail_cpu_topo);
-    set_bit(CPU_TOPO_LEVEL_PACKAGE, env->avail_cpu_topo);
+    /* thread, core and socket levels are set by default. */
+    set_bit(CPU_TOPOLOGY_LEVEL_THREAD, env->avail_cpu_topo);
+    set_bit(CPU_TOPOLOGY_LEVEL_CORE, env->avail_cpu_topo);
+    set_bit(CPU_TOPOLOGY_LEVEL_SOCKET, env->avail_cpu_topo);
 }
 
 static void x86_cpu_initfn(Object *obj)
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 59959b8b7a4d..00b23bc5d1f1 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1716,7 +1716,7 @@ typedef struct CPUCacheInfo {
      * Used to encode CPUID[4].EAX[bits 25:14] or
      * CPUID[0x8000001D].EAX[bits 25:14].
      */
-    enum CPUTopoLevel share_level;
+    CpuTopologyLevel share_level;
 } CPUCacheInfo;
 
 
@@ -2051,7 +2051,7 @@ typedef struct CPUArchState {
     unsigned nr_modules;
 
     /* Bitmap of available CPU topology levels for this CPU. */
-    DECLARE_BITMAP(avail_cpu_topo, CPU_TOPO_LEVEL_MAX);
+    DECLARE_BITMAP(avail_cpu_topo, CPU_TOPOLOGY_LEVEL__MAX);
 } CPUX86State;
 
 struct kvm_msrs;
-- 
2.34.1



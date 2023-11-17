Return-Path: <kvm+bounces-1929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B0D17EECCF
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 840532811E1
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 07:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCAB6111A9;
	Fri, 17 Nov 2023 07:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ocd/aG1A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02222109
	for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 23:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700206813; x=1731742813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rEdU6NYjtG2tsuq6aWGcJvGfg3pqbFRsCfqR1q1CBKo=;
  b=Ocd/aG1A8aGtMVqmZHyRVSnby48LgiySKp/FUg6TD4gZPrIDwUS/g3k8
   1MRWb8UOBeJTLS3n2lUCZ6E4MR11Nh+IFS11vzF5ogbmRI5gS4jCp6UtA
   l9m5GdtLqVrw3gARfXARNfci41vPCOhs+2t9nSVzactqadjs3+QAIAJd8
   mSa1pfP6wRUovz5Vpk99Meav+xh6E1NVnVsfbBnCXeMTR4Vc+jPe3EXfw
   iDWR6y/QcyiKvAvgw4OCgjwyANlXsfyKHyMO41GVJRfZnmQrHAQqwp4ci
   SrmTHs5yMOstnSqoe67gzMol5CwBMgFVtkb2ZyVjNGTF31Dge10YYXxh1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="395180415"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="395180415"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 23:40:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="883042849"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="883042849"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2023 23:40:08 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 13/16] i386: Add cache topology info in CPUCacheInfo
Date: Fri, 17 Nov 2023 15:51:03 +0800
Message-Id: <20231117075106.432499-14-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231117075106.432499-1-zhao1.liu@linux.intel.com>
References: <20231117075106.432499-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Currently, by default, the cache topology is encoded as:
1. i/d cache is shared in one core.
2. L2 cache is shared in one core.
3. L3 cache is shared in one die.

This default general setting has caused a misunderstanding, that is, the
cache topology is completely equated with a specific cpu topology, such
as the connection between L2 cache and core level, and the connection
between L3 cache and die level.

In fact, the settings of these topologies depend on the specific
platform and are not static. For example, on Alder Lake-P, every
four Atom cores share the same L2 cache.

Thus, we should explicitly define the corresponding cache topology for
different cache models to increase scalability.

Except legacy_l2_cache_cpuid2 (its default topo level is
CPU_TOPO_LEVEL_UNKNOW), explicitly set the corresponding topology level
for all other cache models. In order to be compatible with the existing
cache topology, set the CPU_TOPO_LEVEL_CORE level for the i/d cache, set
the CPU_TOPO_LEVEL_CORE level for L2 cache, and set the
CPU_TOPO_LEVEL_DIE level for L3 cache.

The field for CPUID[4].EAX[bits 25:14] or CPUID[0x8000001D].EAX[bits
25:14] will be set based on CPUCacheInfo.share_level.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes since v3:
 * Fix cache topology uninitialization bugs for some AMD CPUs. (Babu)
 * Move the CPUTopoLevel enumeration definition to the previous 0x1f
   rework patch.

Changes since v1:
 * Add the prefix "CPU_TOPO_LEVEL_*" for CPU topology level names.
   (Yanan)
 * (Revert, pls refer "i386: Decouple CPUID[0x1F] subleaf with specific
   topology level") Rename the "INVALID" level to CPU_TOPO_LEVEL_UNKNOW.
   (Yanan)
---
 target/i386/cpu.c | 36 ++++++++++++++++++++++++++++++++++++
 target/i386/cpu.h |  7 +++++++
 2 files changed, 43 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 84f305130a6f..5dcc41329805 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -558,6 +558,7 @@ static CPUCacheInfo legacy_l1d_cache = {
     .sets = 64,
     .partitions = 1,
     .no_invd_sharing = true,
+    .share_level = CPU_TOPO_LEVEL_CORE,
 };
 
 /*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */
@@ -572,6 +573,7 @@ static CPUCacheInfo legacy_l1d_cache_amd = {
     .partitions = 1,
     .lines_per_tag = 1,
     .no_invd_sharing = true,
+    .share_level = CPU_TOPO_LEVEL_CORE,
 };
 
 /* L1 instruction cache: */
@@ -585,6 +587,7 @@ static CPUCacheInfo legacy_l1i_cache = {
     .sets = 64,
     .partitions = 1,
     .no_invd_sharing = true,
+    .share_level = CPU_TOPO_LEVEL_CORE,
 };
 
 /*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */
@@ -599,6 +602,7 @@ static CPUCacheInfo legacy_l1i_cache_amd = {
     .partitions = 1,
     .lines_per_tag = 1,
     .no_invd_sharing = true,
+    .share_level = CPU_TOPO_LEVEL_CORE,
 };
 
 /* Level 2 unified cache: */
@@ -612,6 +616,7 @@ static CPUCacheInfo legacy_l2_cache = {
     .sets = 4096,
     .partitions = 1,
     .no_invd_sharing = true,
+    .share_level = CPU_TOPO_LEVEL_CORE,
 };
 
 /*FIXME: CPUID leaf 2 descriptor is inconsistent with CPUID leaf 4 */
@@ -621,6 +626,7 @@ static CPUCacheInfo legacy_l2_cache_cpuid2 = {
     .size = 2 * MiB,
     .line_size = 64,
     .associativity = 8,
+    .share_level = CPU_TOPO_LEVEL_INVALID,
 };
 
 
@@ -634,6 +640,7 @@ static CPUCacheInfo legacy_l2_cache_amd = {
     .associativity = 16,
     .sets = 512,
     .partitions = 1,
+    .share_level = CPU_TOPO_LEVEL_CORE,
 };
 
 /* Level 3 unified cache: */
@@ -649,6 +656,7 @@ static CPUCacheInfo legacy_l3_cache = {
     .self_init = true,
     .inclusive = true,
     .complex_indexing = true,
+    .share_level = CPU_TOPO_LEVEL_DIE,
 };
 
 /* TLB definitions: */
@@ -1947,6 +1955,7 @@ static const CPUCaches epyc_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -1959,6 +1968,7 @@ static const CPUCaches epyc_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -1969,6 +1979,7 @@ static const CPUCaches epyc_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -1982,6 +1993,7 @@ static const CPUCaches epyc_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = true,
+        .share_level = CPU_TOPO_LEVEL_DIE,
     },
 };
 
@@ -1997,6 +2009,7 @@ static CPUCaches epyc_v4_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2009,6 +2022,7 @@ static CPUCaches epyc_v4_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2019,6 +2033,7 @@ static CPUCaches epyc_v4_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2032,6 +2047,7 @@ static CPUCaches epyc_v4_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = false,
+        .share_level = CPU_TOPO_LEVEL_DIE,
     },
 };
 
@@ -2047,6 +2063,7 @@ static const CPUCaches epyc_rome_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2059,6 +2076,7 @@ static const CPUCaches epyc_rome_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2069,6 +2087,7 @@ static const CPUCaches epyc_rome_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2082,6 +2101,7 @@ static const CPUCaches epyc_rome_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = true,
+        .share_level = CPU_TOPO_LEVEL_DIE,
     },
 };
 
@@ -2097,6 +2117,7 @@ static const CPUCaches epyc_rome_v3_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2109,6 +2130,7 @@ static const CPUCaches epyc_rome_v3_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2119,6 +2141,7 @@ static const CPUCaches epyc_rome_v3_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2132,6 +2155,7 @@ static const CPUCaches epyc_rome_v3_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = false,
+        .share_level = CPU_TOPO_LEVEL_DIE,
     },
 };
 
@@ -2147,6 +2171,7 @@ static const CPUCaches epyc_milan_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2159,6 +2184,7 @@ static const CPUCaches epyc_milan_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2169,6 +2195,7 @@ static const CPUCaches epyc_milan_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2182,6 +2209,7 @@ static const CPUCaches epyc_milan_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = true,
+        .share_level = CPU_TOPO_LEVEL_DIE,
     },
 };
 
@@ -2197,6 +2225,7 @@ static const CPUCaches epyc_milan_v2_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2209,6 +2238,7 @@ static const CPUCaches epyc_milan_v2_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2219,6 +2249,7 @@ static const CPUCaches epyc_milan_v2_cache_info = {
         .partitions = 1,
         .sets = 1024,
         .lines_per_tag = 1,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2232,6 +2263,7 @@ static const CPUCaches epyc_milan_v2_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = false,
+        .share_level = CPU_TOPO_LEVEL_DIE,
     },
 };
 
@@ -2247,6 +2279,7 @@ static const CPUCaches epyc_genoa_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l1i_cache = &(CPUCacheInfo) {
         .type = INSTRUCTION_CACHE,
@@ -2259,6 +2292,7 @@ static const CPUCaches epyc_genoa_cache_info = {
         .lines_per_tag = 1,
         .self_init = 1,
         .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l2_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2269,6 +2303,7 @@ static const CPUCaches epyc_genoa_cache_info = {
         .partitions = 1,
         .sets = 2048,
         .lines_per_tag = 1,
+        .share_level = CPU_TOPO_LEVEL_CORE,
     },
     .l3_cache = &(CPUCacheInfo) {
         .type = UNIFIED_CACHE,
@@ -2282,6 +2317,7 @@ static const CPUCaches epyc_genoa_cache_info = {
         .self_init = true,
         .inclusive = true,
         .complex_indexing = false,
+        .share_level = CPU_TOPO_LEVEL_DIE,
     },
 };
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 6a6356e34e62..dafc4b4a92f2 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1597,6 +1597,13 @@ typedef struct CPUCacheInfo {
      * address bits.  CPUID[4].EDX[bit 2].
      */
     bool complex_indexing;
+
+    /*
+     * Cache Topology. The level that cache is shared in.
+     * Used to encode CPUID[4].EAX[bits 25:14] or
+     * CPUID[0x8000001D].EAX[bits 25:14].
+     */
+    enum CPUTopoLevel share_level;
 } CPUCacheInfo;
 
 
-- 
2.34.1



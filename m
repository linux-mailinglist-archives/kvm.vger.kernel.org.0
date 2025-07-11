Return-Path: <kvm+bounces-52129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCEBFB0192B
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ADD43BC9B9
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66EB280CFC;
	Fri, 11 Jul 2025 10:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ddwydnsO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953C627F72C
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228077; cv=none; b=e2hT9Vxka/W5Ce5rdJ0R30OtlOMjwBswx/i5A07OFQnwgfMRz0/N9Go1cySLRKluAU2RFBY/gwSg2E1lqGYYGFrW4MPMdmRZOTD6AUo2SjxyUwzp+dhsvjRYK2cKjP8uNTwAUzgBYBd5gmyrjDuwXCg6kR7pe+fjQbDDrz1B6fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228077; c=relaxed/simple;
	bh=2YgiqgBwgQ2xRniG9fxBQVr1kcJH4e6UNHL2Y40Boa4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PU9dIgVCYdfY5G4isbn5C4/mwuVJls/SEEO3JLsdTM+H9wCsvqInrS8Vc+uhTzgrhI+kr/MBBDkc1s6zUB732SWb4rI+Z8/xS1UY0/DbSuE7wMokh7gZCA2kAmE26ip82gkAJTyUtNqMefu0STLJLGRAmOvfYAMxdTt4g0x6CHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ddwydnsO; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228075; x=1783764075;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2YgiqgBwgQ2xRniG9fxBQVr1kcJH4e6UNHL2Y40Boa4=;
  b=ddwydnsO5dAUFOGYvzfiJjLqgzPmDc9MCLjx7XK0esCJAgY7WuQeKoeF
   Go/JlIGqPBjU0MmwkklopzSthgY3ZQvLd2r/YgeceO6ukDuSbNWJ78ldG
   /cFnBwX0jlLh4+8hLSfB5+ezT9jvDAiMIKb4FUcfG2ejzNtNnSRpOjt6J
   lH3bUnxxxw9LJFd4du8PJNIpw7ClW2DzyrQTM59P13BmNDY1GqYhuEVsE
   4K+14XjDR/2RnhcqASihblDcDZqxbCUnCEQAeXri18rNppYeZUoCFvcne
   UrCP+Q7bhAe6Es1DFTpUG4eA1AMCGLAbbT0/5ZguUlbobC0lzJ8imHHL+
   w==;
X-CSE-ConnectionGUID: OOZDnJANSOejZlNm+hEhZg==
X-CSE-MsgGUID: h/XD+9CHRj2DY9oTn7dmwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496357"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496357"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:01:15 -0700
X-CSE-ConnectionGUID: EY0bXHd+ToO+CXcvqFBxmg==
X-CSE-MsgGUID: /HPSHUnrRP+Axi4IeiDikw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662089"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:01:10 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Pu Wen <puwen@hygon.cn>,
	Tao Su <tao1.su@intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH v2 11/18] i386/cpu: Add legacy_intel_cache_info cache model
Date: Fri, 11 Jul 2025 18:21:36 +0800
Message-Id: <20250711102143.1622339-12-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250711102143.1622339-1-zhao1.liu@intel.com>
References: <20250711102143.1622339-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Based on legacy_l1d_cache, legacy_l1i_cache, legacy_l2_cache and
legacy_l3_cache, build a complete legacy intel cache model, which can
clarify the purpose of these trivial legacy cache models, simplify the
initialization of cache info in X86CPUState, and make it easier to
handle compatibility later.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 101 +++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 47 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 609efb10ddb5..6cd942f95779 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -638,21 +638,6 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
  * These are legacy cache values. If there is a need to change any
  * of these values please use builtin_x86_defs
  */
-
-/* L1 data cache: */
-static CPUCacheInfo legacy_l1d_cache = {
-    .type = DATA_CACHE,
-    .level = 1,
-    .size = 32 * KiB,
-    .self_init = 1,
-    .line_size = 64,
-    .associativity = 8,
-    .sets = 64,
-    .partitions = 1,
-    .no_invd_sharing = true,
-    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
-};
-
 static CPUCacheInfo legacy_l1d_cache_amd = {
     .type = DATA_CACHE,
     .level = 1,
@@ -667,20 +652,6 @@ static CPUCacheInfo legacy_l1d_cache_amd = {
     .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
-/* L1 instruction cache: */
-static CPUCacheInfo legacy_l1i_cache = {
-    .type = INSTRUCTION_CACHE,
-    .level = 1,
-    .size = 32 * KiB,
-    .self_init = 1,
-    .line_size = 64,
-    .associativity = 8,
-    .sets = 64,
-    .partitions = 1,
-    .no_invd_sharing = true,
-    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
-};
-
 static CPUCacheInfo legacy_l1i_cache_amd = {
     .type = INSTRUCTION_CACHE,
     .level = 1,
@@ -695,20 +666,6 @@ static CPUCacheInfo legacy_l1i_cache_amd = {
     .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
-/* Level 2 unified cache: */
-static CPUCacheInfo legacy_l2_cache = {
-    .type = UNIFIED_CACHE,
-    .level = 2,
-    .size = 4 * MiB,
-    .self_init = 1,
-    .line_size = 64,
-    .associativity = 16,
-    .sets = 4096,
-    .partitions = 1,
-    .no_invd_sharing = true,
-    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
-};
-
 static CPUCacheInfo legacy_l2_cache_amd = {
     .type = UNIFIED_CACHE,
     .level = 2,
@@ -798,6 +755,59 @@ static const CPUCaches legacy_intel_cpuid2_cache_info = {
     },
 };
 
+static const CPUCaches legacy_intel_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .self_init = 1,
+        .line_size = 64,
+        .associativity = 8,
+        .sets = 64,
+        .partitions = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l1i_cache = &(CPUCacheInfo) {
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .self_init = 1,
+        .line_size = 64,
+        .associativity = 8,
+        .sets = 64,
+        .partitions = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l2_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 2,
+        .size = 4 * MiB,
+        .self_init = 1,
+        .line_size = 64,
+        .associativity = 16,
+        .sets = 4096,
+        .partitions = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l3_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 3,
+        .size = 16 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .sets = 16384,
+        .partitions = 1,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .inclusive = true,
+        .complex_indexing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
+    },
+};
+
 /* TLB definitions: */
 
 #define L1_DTLB_2M_ASSOC       1
@@ -8980,10 +8990,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
             env->enable_legacy_cpuid2_cache = true;
         }
 
-        env->cache_info_cpuid4.l1d_cache = &legacy_l1d_cache;
-        env->cache_info_cpuid4.l1i_cache = &legacy_l1i_cache;
-        env->cache_info_cpuid4.l2_cache = &legacy_l2_cache;
-        env->cache_info_cpuid4.l3_cache = &legacy_l3_cache;
+        env->cache_info_cpuid4 = legacy_intel_cache_info;
 
         env->cache_info_amd.l1d_cache = &legacy_l1d_cache_amd;
         env->cache_info_amd.l1i_cache = &legacy_l1i_cache_amd;
-- 
2.34.1



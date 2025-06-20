Return-Path: <kvm+bounces-50037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E43DEAE1707
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:07:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D38B19E4401
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A18027FD64;
	Fri, 20 Jun 2025 09:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g70QOAMn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C540D27FB1C
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750410423; cv=none; b=UPTClq+cQgTzmlGqZt/gv43KkPJkK8oCGyOvfGpRkvbU/oZV8kiBdzpXI/GqgAU6lcOcHKwfryAHh4yZzWKrCmF6up1wB6fzRWyjJcxHm8NZc5mFuSC1xCS+GCtsSS7MqR5XqkkGB477xkL39DFmUhrswja+oTCrACWNhK8WbF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750410423; c=relaxed/simple;
	bh=N4GITYpWdJ1HERjdysXD4ZPZutg2U4OiYFYUeFIS6iM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WqhmaOtdz/xlI1lvn66Rx+QY6QRFwSloUEWNP6LLW49JV4LJPpw3BXCgF1ITRx7YWy5JFgnr5OQ5i/x0lPwvKR+vVVyUfGU/2LuAsp+e8H9oy+RRyK1110UoNKyKIsijtAvrbSQCHmlBmZkLAd2QQaPruZMiBoi8J1YfjrdeZZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g70QOAMn; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750410422; x=1781946422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N4GITYpWdJ1HERjdysXD4ZPZutg2U4OiYFYUeFIS6iM=;
  b=g70QOAMnlBrwt3fe0fd+7ZPkLMaFcKJUlvLQE5ig8xBVmETfCdHu8sUx
   qEgGLy6b2LukgVCoLdHJgmYAVE7bSy+Qe+rgnIqPuSLAVtHLrrkzg+HbL
   wETbYr2RTYdG9Psec9iEEhNPtaMwCNaPGYv9mqRDxjZVL0+91ad1PGBRD
   tvn7BJHvX+zGcQgcFBXAJOvL78UmEvdmG7fBtbJUnh/9lLHsFEjFnXoGT
   k005O4mkSZAEeegwqcVlnvtIvqwXDY2wcwtwOaztF2r0jDKN4wpIF+NrS
   Jyy+hmJGkrPJ58oLE601XOdK62/KUII6yh0tjQZwTbiIoZWyiI/CUv4j+
   w==;
X-CSE-ConnectionGUID: xUK7i0RsSA2yZlXfKqRJGQ==
X-CSE-MsgGUID: fIrqCtN5TFewsKlcVzjJCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56466740"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="56466740"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 02:07:02 -0700
X-CSE-ConnectionGUID: T03zHKGqSaSLlO+61lfE1w==
X-CSE-MsgGUID: xMTKnt6PSR+jly6fF/X7LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="156670103"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 20 Jun 2025 02:06:58 -0700
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
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 09/16] i386/cpu: Add legacy_intel_cache_info cache model
Date: Fri, 20 Jun 2025 17:27:27 +0800
Message-Id: <20250620092734.1576677-10-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250620092734.1576677-1-zhao1.liu@intel.com>
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
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

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 101 +++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 47 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 0b292aa2e07b..ec229830c532 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -643,21 +643,6 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
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
@@ -672,20 +657,6 @@ static CPUCacheInfo legacy_l1d_cache_amd = {
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
@@ -700,20 +671,6 @@ static CPUCacheInfo legacy_l1i_cache_amd = {
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
@@ -803,6 +760,59 @@ static const CPUCaches legacy_intel_cpuid2_cache_info = {
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
@@ -8971,10 +8981,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
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



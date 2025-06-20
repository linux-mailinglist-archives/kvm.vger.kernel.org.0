Return-Path: <kvm+bounces-50031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21091AE16FD
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:06:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 448DA188B181
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F39D27FD41;
	Fri, 20 Jun 2025 09:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FP+Aorjp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C612356C7
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750410396; cv=none; b=hlcQgtmQm/oNqPWBiDgYGqZ0AO7xha2n0zYS50IBHKb6AacKyfyWsts0D0vj9T3mwtIlEREa5wlp9JOZjH0eVbYAdjGGVl300Swf33DYZXhnhjYk4ItpajnSA55AqzNJQpHrCpz43yQHtm5dHUP+PIsZLE1A4cdt/B5CLB10j6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750410396; c=relaxed/simple;
	bh=/UaWvm7TqZVE24eodszyVbZ46tgQZ07UFSiLrizRDTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WLTBX40R5kqjhBQafPbqnQwOYcJAsnFkK1ORYClhMrcIBZybHUpQBU1RxKLgo4q2t842XZdb4TNw3qi1KKT9/XC0x0AJgGy6RPZUmGQb9FgjCwL8bYzxNcAUjr/fQ3pAWRyRAkNAGbp8mK/3535pr7jRF3WcyA1RQ/BsaQidbhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FP+Aorjp; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750410395; x=1781946395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/UaWvm7TqZVE24eodszyVbZ46tgQZ07UFSiLrizRDTM=;
  b=FP+AorjpAIVU4DYkUcO58/yhZSUpFIzaGzHYN7/yrxJxgVXp3IcvEkBo
   OspTOiVu17P592HIaiRZd/0WhNEr58osxRfHC304K9RXU+PH+1t7e5m0d
   Uce5JxDoYjF+1coeldalrOzWyh2pFusjWfl8uRgINfiKrfGi9L12eiuI0
   xNauClRORhCBy6i/LD3FWetlvLujNe2nz/x4ZF+MhhShiNodYrmp5s2/f
   DXeTdh5jpIVOKVLx1xHgGSvcpQ2OIDJofQwOiv0TzvJm+iDrc697obb7d
   Jk5tEmRp1H7f0rPb1JDbwlYX+g8zhGTTLpOyzbl6Cr76wjn8kxX6P16Xh
   Q==;
X-CSE-ConnectionGUID: aHm7iM31QuSISCgaZopTyg==
X-CSE-MsgGUID: KLogbKVFRr6YNcn7Bg8rUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56466560"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="56466560"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 02:06:35 -0700
X-CSE-ConnectionGUID: V4s4attrReSLiNu1PEuN/w==
X-CSE-MsgGUID: He37ufVcT3yAob1jJWhqnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="156669869"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 20 Jun 2025 02:06:31 -0700
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
Subject: [PATCH 03/16] i386/cpu: Add default cache model for Intel CPUs with level < 4
Date: Fri, 20 Jun 2025 17:27:21 +0800
Message-Id: <20250620092734.1576677-4-zhao1.liu@intel.com>
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

Old Intel CPUs with CPUID level < 4, use CPUID 0x2 leaf (if available)
to encode cache information.

Introduce a cache model "legacy_intel_cpuid2_cache_info" for the CPUs
with CPUID level < 4, based on legacy_l1d_cache, legacy_l1i_cache,
legacy_l2_cache_cpuid2 and legacy_l3_cache. But for L2 cache, this
cache model completes self_init, sets, partitions, no_invd_sharing and
share_level fields, referring legacy_l2_cache, to avoid someone
increases CPUID level manually and meets assert() error. But the cache
information present in CPUID 0x2 leaf doesn't change.

This new cache model makes it possible to remove legacy_l2_cache_cpuid2
in X86CPUState and help to clarify historical cache inconsistency issue.

Furthermore, apply this legacy cache model to all Intel CPUs with CPUID
level < 4. This includes not only "pentium2" and "pentium3" (which have
0x2 leaf), but also "486" and "pentium" (which only have 0x1 leaf, and
cache model won't be presented, just for simplicity).

A legacy_intel_cpuid2_cache_info cache model doesn't change the cache
information of the above CPUs, because they just depend on 0x2 leaf.

Only when someone adjusts the min-level to >=4 will the cache
information in CPUID leaf 4 differ from before: previously, the L2
cache information in CPUID leaf 0x2 and 0x4 was different, but now with
legacy_intel_cpuid2_cache_info, the information they present will be
consistent. This case almost never happens, emulating a CPUID that is
not supported by the "ancient" hardware is itself meaningless behavior.

Therefore, even though there's the above difference (for really rare
case) and considering these old CPUs ("486", "pentium", "pentium2" and
"pentium3") won't be used for migration, there's no need to add new
versioned CPU models

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 995766c9d74c..0a2c32214cc3 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -710,6 +710,67 @@ static CPUCacheInfo legacy_l3_cache = {
     .share_level = CPU_TOPOLOGY_LEVEL_DIE,
 };
 
+/*
+ * Only used for the CPU models with CPUID level < 4.
+ * These CPUs (CPUID level < 4) only use CPUID leaf 2 to present
+ * cache information.
+ *
+ * Note: This cache model is just a default one, and is not
+ *       guaranteed to match real hardwares.
+ */
+static const CPUCaches legacy_intel_cpuid2_cache_info = {
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
+        .size = 2 * MiB,
+        .self_init = 1,
+        .line_size = 64,
+        .associativity = 8,
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
@@ -3043,6 +3104,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             I486_FEATURES,
         .xlevel = 0,
         .model_id = "",
+        .cache_info = &legacy_intel_cpuid2_cache_info,
     },
     {
         .name = "pentium",
@@ -3055,6 +3117,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             PENTIUM_FEATURES,
         .xlevel = 0,
         .model_id = "",
+        .cache_info = &legacy_intel_cpuid2_cache_info,
     },
     {
         .name = "pentium2",
@@ -3067,6 +3130,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             PENTIUM2_FEATURES,
         .xlevel = 0,
         .model_id = "",
+        .cache_info = &legacy_intel_cpuid2_cache_info,
     },
     {
         .name = "pentium3",
@@ -3079,6 +3143,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             PENTIUM3_FEATURES,
         .xlevel = 0,
         .model_id = "",
+        .cache_info = &legacy_intel_cpuid2_cache_info,
     },
     {
         .name = "athlon",
-- 
2.34.1



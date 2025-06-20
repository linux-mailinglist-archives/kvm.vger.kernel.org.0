Return-Path: <kvm+bounces-50038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C68F3AE170F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:07:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EE713B82BD
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0382127FD4F;
	Fri, 20 Jun 2025 09:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QjcqMwFq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6AF27FB1C
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750410428; cv=none; b=Z9yCBbAsVrMrX93buokneQRZ1DPEy3J9arZ8eJOF+TCdAC6O0lPwMuyPaYjDH0SedXPVrpRF5JBf/UtxhVrIB2EFo4lwTSVSF4+TWZTiqFIG1sdX8a0fyIROZ0jjwsAUhzAPlgaIBKXcczboLMgnC4bAV8yAvyJqWyUcz0rgrFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750410428; c=relaxed/simple;
	bh=Iw37FKEpWcDr+1BzreJTzrwt1dWMwF0UEcgY0aS63YM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ggIsKkGzjHok3aQbrubZvMxMmb0M8tZtjVnSJz2P4nH6AftKudOTfEaP0mxJgQCmIKvEn5ja4ONSKrzDXSdSWSrQUJeYTVesfuDeshe+mJ7VrX0PAdcI7ufYr940cCpHcO72BUYPBUjDECnj4ooHQEbm4ZlX3hRFi5OTYjuc4a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QjcqMwFq; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750410427; x=1781946427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Iw37FKEpWcDr+1BzreJTzrwt1dWMwF0UEcgY0aS63YM=;
  b=QjcqMwFqvFsruCUpGeVALQZOLRBSTGwGQSJiHBw6ukAV97jNO/zpgdIt
   seJZLIEm27gRKBDFOt9osrwmAzJanNJGrcbPhZ0i0mTufZH9XN7VsoaIa
   jDPxhbotRVMDTTmcDIjF8FsohsPNv8a5H3bira6SvDYy6W7B94W3wyQ74
   0/CAiKQXfyqyYN9zIawRk9eWzVa4pSw9hEJ0/25d1ctuSKPxkowOTzinX
   g/7a2RHUHzlKrfqOkcJGveyZJtJvDpvMsHipSH+b4n0SSvNMF/w+4rWd0
   D0CRBYZkABYcD15bxjgKOPCdxO1/lrfA4yopuxkkHAmSrT51dvZheNsto
   w==;
X-CSE-ConnectionGUID: 0tDtPMiKTMml7VjlzHKBsw==
X-CSE-MsgGUID: KV+6nMa+SUObXxOvw7oTuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56466763"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="56466763"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 02:07:06 -0700
X-CSE-ConnectionGUID: NYqwPHlIS7OiZW8BfnWllQ==
X-CSE-MsgGUID: bZ66KRLcT2ivsJ8LYBo+BQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="156670116"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 20 Jun 2025 02:07:02 -0700
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
Subject: [PATCH 10/16] i386/cpu: Add legacy_amd_cache_info cache model
Date: Fri, 20 Jun 2025 17:27:28 +0800
Message-Id: <20250620092734.1576677-11-zhao1.liu@intel.com>
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

Based on legacy_l1d_cachei_amd, legacy_l1i_cache_amd, legacy_l2_cache_amd
and legacy_l3_cache, build a complete legacy AMD cache model, which can
clarify the purpose of these trivial legacy cache models, simplify the
initialization of cache info in X86CPUState, and make it easier to
handle compatibility later.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 112 ++++++++++++++++++++++------------------------
 1 file changed, 53 insertions(+), 59 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index ec229830c532..bf8d7a19c88d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -643,60 +643,58 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
  * These are legacy cache values. If there is a need to change any
  * of these values please use builtin_x86_defs
  */
-static CPUCacheInfo legacy_l1d_cache_amd = {
-    .type = DATA_CACHE,
-    .level = 1,
-    .size = 64 * KiB,
-    .self_init = 1,
-    .line_size = 64,
-    .associativity = 2,
-    .sets = 512,
-    .partitions = 1,
-    .lines_per_tag = 1,
-    .no_invd_sharing = true,
-    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
-};
-
-static CPUCacheInfo legacy_l1i_cache_amd = {
-    .type = INSTRUCTION_CACHE,
-    .level = 1,
-    .size = 64 * KiB,
-    .self_init = 1,
-    .line_size = 64,
-    .associativity = 2,
-    .sets = 512,
-    .partitions = 1,
-    .lines_per_tag = 1,
-    .no_invd_sharing = true,
-    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
-};
-
-static CPUCacheInfo legacy_l2_cache_amd = {
-    .type = UNIFIED_CACHE,
-    .level = 2,
-    .size = 512 * KiB,
-    .line_size = 64,
-    .lines_per_tag = 1,
-    .associativity = 16,
-    .sets = 512,
-    .partitions = 1,
-    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
-};
-
-/* Level 3 unified cache: */
-static CPUCacheInfo legacy_l3_cache = {
-    .type = UNIFIED_CACHE,
-    .level = 3,
-    .size = 16 * MiB,
-    .line_size = 64,
-    .associativity = 16,
-    .sets = 16384,
-    .partitions = 1,
-    .lines_per_tag = 1,
-    .self_init = true,
-    .inclusive = true,
-    .complex_indexing = true,
-    .share_level = CPU_TOPOLOGY_LEVEL_DIE,
+static const CPUCaches legacy_amd_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
+        .level = 1,
+        .size = 64 * KiB,
+        .self_init = 1,
+        .line_size = 64,
+        .associativity = 2,
+        .sets = 512,
+        .partitions = 1,
+        .lines_per_tag = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l1i_cache = &(CPUCacheInfo) {
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .size = 64 * KiB,
+        .self_init = 1,
+        .line_size = 64,
+        .associativity = 2,
+        .sets = 512,
+        .partitions = 1,
+        .lines_per_tag = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l2_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 2,
+        .size = 512 * KiB,
+        .line_size = 64,
+        .lines_per_tag = 1,
+        .associativity = 16,
+        .sets = 512,
+        .partitions = 1,
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
 };
 
 /*
@@ -8982,11 +8980,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
         }
 
         env->cache_info_cpuid4 = legacy_intel_cache_info;
-
-        env->cache_info_amd.l1d_cache = &legacy_l1d_cache_amd;
-        env->cache_info_amd.l1i_cache = &legacy_l1i_cache_amd;
-        env->cache_info_amd.l2_cache = &legacy_l2_cache_amd;
-        env->cache_info_amd.l3_cache = &legacy_l3_cache;
+        env->cache_info_amd = legacy_amd_cache_info;
     }
 
 #ifndef CONFIG_USER_ONLY
-- 
2.34.1



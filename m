Return-Path: <kvm+bounces-52124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AFCC6B0191C
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 740B61C20892
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037CF21127D;
	Fri, 11 Jul 2025 10:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X/bgxXTz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB04A27EFED
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228053; cv=none; b=SK+4In51hg3ILllpRw6L00i8lASauyiK8JzoNUYDYu5pClLTkQ/d9f1IUSfi0mtl2XoUcBr1cZXvMVTJ+qfwvAetd5RFu49aZrfRlAq5O73MPiz1tRvjRoXRVTwwIKTPyfIyWDDfgM3hA04asAlFWFNnpOTTND1fDFhf16jD5xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228053; c=relaxed/simple;
	bh=37ekHmbjiymc2w14B0h3SzMdkzEg65B1RzqZEcyBXL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mC/dgrKbTbJxBdWABgPlrONan3liJmDXM8pAhsVxVYLEBUkp0MSdrOVT2MQSqUwhE7tg9dw4geofZQ3vPe3cS6qaUVnday7MCm8Hs0gzpTK4879yRvlR4kOtCUeUEFEbLpDm6F3r/lbwQzmxwHavlxTI/8Eqr9mkqv1Dlu9EP3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X/bgxXTz; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228052; x=1783764052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=37ekHmbjiymc2w14B0h3SzMdkzEg65B1RzqZEcyBXL0=;
  b=X/bgxXTzaF6TQW61E30Tb8jpxSzmdE4BIpefYMAMFscXblmIjKCOoWgh
   TK6MDQsaSLPSZ983t1ZhCD9dz8WxBF0rJN2O7Vqzxv5jW+wKpQVrV4k71
   9lQTpaTdqWWKfAVfdnZFAiJn287wAJNc8I3zkliMFjp/hVTKByqA1SHA0
   kMg9Stug/kaU5PbNDZnTVaVqXDJJw4WSYZblbYj8Sqat10TfaHf+K/rWF
   QhScc3Ey6Pm5/8p5CVHaTTzJ91M9U8wBqAMvWwFpIlGNrYyTg8/RHeBSt
   5vuZUlE4pUvPutLN3SFUaie04pYp9YEhgLAounmJ/8WSEXCD3NfnH+nDs
   A==;
X-CSE-ConnectionGUID: mJwkzLf3QzOMBdY+DX6vcg==
X-CSE-MsgGUID: gHp2EN1IQp+Dp8KKdQoqkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496272"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496272"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:00:51 -0700
X-CSE-ConnectionGUID: kbaFEx9UQ9aHinuKt7LG5A==
X-CSE-MsgGUID: RtRdR5z/Tf6auFkf17qefg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662051"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:00:46 -0700
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
Subject: [PATCH v2 06/18] i386/cpu: Drop CPUID 0x2 specific cache info in X86CPUState
Date: Fri, 11 Jul 2025 18:21:31 +0800
Message-Id: <20250711102143.1622339-7-zhao1.liu@intel.com>
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

With the pre-defined cache model legacy_intel_cpuid2_cache_info,
for X86CPUState there's no need to cache special cache information
for CPUID 0x2 leaf.

Drop the cache_info_cpuid2 field of X86CPUState and use the
legacy_intel_cpuid2_cache_info directly.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 31 +++++++++++--------------------
 target/i386/cpu.h |  3 ++-
 2 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 37cf591bea8d..af67f12e939d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -244,19 +244,27 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache, bool *unmacthed)
     return CACHE_DESCRIPTOR_UNAVAILABLE;
 }
 
+static const CPUCaches legacy_intel_cpuid2_cache_info;
+
 /* Encode cache info for CPUID[2] */
 static void encode_cache_cpuid2(X86CPU *cpu,
                                 uint32_t *eax, uint32_t *ebx,
                                 uint32_t *ecx, uint32_t *edx)
 {
     CPUX86State *env = &cpu->env;
-    CPUCaches *caches = &env->cache_info_cpuid2;
+    const CPUCaches *caches;
     int l1d, l1i, l2, l3;
     bool unmatched = false;
 
     *eax = 1; /* Number of CPUID[EAX=2] calls required */
     *ebx = *ecx = *edx = 0;
 
+    if (env->enable_legacy_cpuid2_cache) {
+        caches = &legacy_intel_cpuid2_cache_info;
+    } else {
+        caches = &env->cache_info_cpuid4;
+    }
+
     l1d = cpuid2_cache_descriptor(caches->l1d_cache, &unmatched);
     l1i = cpuid2_cache_descriptor(caches->l1i_cache, &unmatched);
     l2 = cpuid2_cache_descriptor(caches->l2_cache, &unmatched);
@@ -705,17 +713,6 @@ static CPUCacheInfo legacy_l2_cache = {
     .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
-/*FIXME: CPUID leaf 2 descriptor is inconsistent with CPUID leaf 4 */
-static CPUCacheInfo legacy_l2_cache_cpuid2 = {
-    .type = UNIFIED_CACHE,
-    .level = 2,
-    .size = 2 * MiB,
-    .line_size = 64,
-    .associativity = 8,
-    .share_level = CPU_TOPOLOGY_LEVEL_INVALID,
-};
-
-
 /*FIXME: CPUID leaf 0x80000006 is inconsistent with leaves 2 & 4 */
 static CPUCacheInfo legacy_l2_cache_amd = {
     .type = UNIFIED_CACHE,
@@ -8955,18 +8952,12 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
                        "CPU model '%s' doesn't support legacy-cache=off", name);
             return;
         }
-        env->cache_info_cpuid2 = env->cache_info_cpuid4 = env->cache_info_amd =
-            *cache_info;
+        env->cache_info_cpuid4 = env->cache_info_amd = *cache_info;
     } else {
         /* Build legacy cache information */
-        env->cache_info_cpuid2.l1d_cache = &legacy_l1d_cache;
-        env->cache_info_cpuid2.l1i_cache = &legacy_l1i_cache;
         if (!cpu->consistent_cache) {
-            env->cache_info_cpuid2.l2_cache = &legacy_l2_cache_cpuid2;
-        } else {
-            env->cache_info_cpuid2.l2_cache = &legacy_l2_cache;
+            env->enable_legacy_cpuid2_cache = true;
         }
-        env->cache_info_cpuid2.l3_cache = &legacy_l3_cache;
 
         env->cache_info_cpuid4.l1d_cache = &legacy_l1d_cache;
         env->cache_info_cpuid4.l1i_cache = &legacy_l1i_cache;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index d7c9a1f91446..9adba8fdf773 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2076,7 +2076,8 @@ typedef struct CPUArchState {
      * on each CPUID leaf will be different, because we keep compatibility
      * with old QEMU versions.
      */
-    CPUCaches cache_info_cpuid2, cache_info_cpuid4, cache_info_amd;
+    CPUCaches cache_info_cpuid4, cache_info_amd;
+    bool enable_legacy_cpuid2_cache;
 
     /* MTRRs */
     uint64_t mtrr_fixed[11];
-- 
2.34.1



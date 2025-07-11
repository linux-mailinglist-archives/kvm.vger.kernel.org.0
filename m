Return-Path: <kvm+bounces-52123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC1DFB01919
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:01:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6275C8E330A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E1727FB05;
	Fri, 11 Jul 2025 10:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nAaybmHq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7BA218EBF
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228051; cv=none; b=B/6QmivYvs4OZnegDlgCydkbHaHqbpEs0w1P9ROM4W18dAwVFNAgl6neBrltH/TuB7b78icTmSZV/zyww6uoooIk2JckrzJFFhAJTYrNU9mR5xwaVeuWWLzPeRqKAxwm0LUi4g1kG7Ai/u59lKFt1GB5O8nLhnQ9Fe6xb7N4RA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228051; c=relaxed/simple;
	bh=NAdqAYTXJZb5DjKif7WlBLOUKuZAQoUj2XZSaZ6yx2o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AXyChS9YOckGvv02hWa57OPmQEqKboZgsVTMfJxzrnbSl/LoJTb7Y8jsOxFZKLy2aD3fa6gzXGTDyl8jbZ0GLhkrkN/slYkXDsT3hgp+pKeKUfJiBGTqz+hxKuoGMPgI1glpBruBjkpASga2hVrqdS8Povulf6IUsODV4dsByR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nAaybmHq; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228050; x=1783764050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NAdqAYTXJZb5DjKif7WlBLOUKuZAQoUj2XZSaZ6yx2o=;
  b=nAaybmHqWMV7Ma0vub6Hj4u+2JHcMroFHZIy8Dpb74K7G1B2Ld4Ui6pP
   wVIYR68KEq21XSROn4dL93Q92qoYqQJI8NFG6GRIutqVMaj58acvuAbxA
   xfTINFJfONenOVxNeqHwmBkXowh4BlL5/jMP7daasNyprAp1ADt3JGFuQ
   M+dONoyMR5+46PkhZAJzrD83X8wbGTYGyD57AcOm3wJJig5EGpWfnwjt9
   9vHN5jVmLT4DQefdfGesG1M6pyIKauG74J0B2pF6xOukXxLNIj69ld+Ri
   Ym30dtchFGLf84WHwiEMRIkGbD+2coMcNpNRAd4mVPeGRnPw+zWhVILIy
   w==;
X-CSE-ConnectionGUID: N6a0/j7HRGSXVu505bdRcg==
X-CSE-MsgGUID: VrVsSHKrRUWHOiB+Mfr2PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496263"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496263"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:00:49 -0700
X-CSE-ConnectionGUID: TL4xReLGT6GyGPh2jf5l2w==
X-CSE-MsgGUID: e8KFagqBT5yjLtE1jLAYew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662047"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:00:40 -0700
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
Subject: [PATCH v2 05/18] i386/cpu: Consolidate CPUID 0x4 leaf
Date: Fri, 11 Jul 2025 18:21:30 +0800
Message-Id: <20250711102143.1622339-6-zhao1.liu@intel.com>
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

Modern Intel CPUs use CPUID 0x4 leaf to describe cache information
and leave space in 0x2 for prefetch and TLBs (even TLB has its own leaf
CPUID 0x18).

And 0x2 leaf provides a descriptor 0xFF to instruct software to check
cache information in 0x4 leaf instead.

Therefore, follow this behavior to encode 0xFF when Intel CPU has 0x4
leaf with "x-consistent-cache=true" for compatibility.

In addition, for older CPUs without 0x4 leaf, still enumerate the cache
descriptor in 0x2 leaf, except the case that there's no descriptor
matching the cache model, then directly encode 0xFF in 0x2 leaf. This
makes sense, as in the 0x2 leaf era, all supported caches should have
the corresponding descriptor.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v1:
 * Fix the typo in comment. (Ewan)
---
 target/i386/cpu.c | 48 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 70ac969a9cdc..37cf591bea8d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -223,7 +223,7 @@ struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
  * Return a CPUID 2 cache descriptor for a given cache.
  * If no known descriptor is found, return CACHE_DESCRIPTOR_UNAVAILABLE
  */
-static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
+static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache, bool *unmacthed)
 {
     int i;
 
@@ -240,9 +240,44 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
             }
     }
 
+    *unmacthed |= true;
     return CACHE_DESCRIPTOR_UNAVAILABLE;
 }
 
+/* Encode cache info for CPUID[2] */
+static void encode_cache_cpuid2(X86CPU *cpu,
+                                uint32_t *eax, uint32_t *ebx,
+                                uint32_t *ecx, uint32_t *edx)
+{
+    CPUX86State *env = &cpu->env;
+    CPUCaches *caches = &env->cache_info_cpuid2;
+    int l1d, l1i, l2, l3;
+    bool unmatched = false;
+
+    *eax = 1; /* Number of CPUID[EAX=2] calls required */
+    *ebx = *ecx = *edx = 0;
+
+    l1d = cpuid2_cache_descriptor(caches->l1d_cache, &unmatched);
+    l1i = cpuid2_cache_descriptor(caches->l1i_cache, &unmatched);
+    l2 = cpuid2_cache_descriptor(caches->l2_cache, &unmatched);
+    l3 = cpuid2_cache_descriptor(caches->l3_cache, &unmatched);
+
+    if (!cpu->consistent_cache ||
+        (env->cpuid_min_level < 0x4 && !unmatched)) {
+        /*
+         * Though SDM defines code 0x40 for cases with no L2 or L3. It's
+         * also valid to just ignore l3's code if there's no l2.
+         */
+        if (cpu->enable_l3_cache) {
+            *ecx = l3;
+        }
+        *edx = (l1d << 16) | (l1i <<  8) | l2;
+    } else {
+        *ecx = 0;
+        *edx = CACHE_DESCRIPTOR_UNAVAILABLE;
+    }
+}
+
 /* CPUID Leaf 4 constants: */
 
 /* EAX: */
@@ -7448,16 +7483,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *eax = *ebx = *ecx = *edx = 0;
             break;
         }
-        *eax = 1; /* Number of CPUID[EAX=2] calls required */
-        *ebx = 0;
-        if (!cpu->enable_l3_cache) {
-            *ecx = 0;
-        } else {
-            *ecx = cpuid2_cache_descriptor(env->cache_info_cpuid2.l3_cache);
-        }
-        *edx = (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1d_cache) << 16) |
-               (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1i_cache) <<  8) |
-               (cpuid2_cache_descriptor(env->cache_info_cpuid2.l2_cache));
+        encode_cache_cpuid2(cpu, eax, ebx, ecx, edx);
         break;
     case 4:
         /* cache info: needed for Core compatibility */
-- 
2.34.1



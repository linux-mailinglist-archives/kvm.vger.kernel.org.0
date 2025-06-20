Return-Path: <kvm+bounces-50040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3603BAE1712
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:07:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86EA53BBC64
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2C727FB18;
	Fri, 20 Jun 2025 09:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N3UEXpj2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C02527FB1E
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750410436; cv=none; b=uICI/ZeidbQIpHfa9SYY11UINZ8KijhIeYvSd5eVbHoPDElQx9BRWl0+fvOnsF4Xx2IrqW/Ims3QNbDPkUtJG9G03bd/8Ca1xkx6MosWWNSB16Ttgjmj1H+DTGlpiDXbXXTwdudU6dKKOi8pTbWU/Pugu5MIbbk163qMD+weYS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750410436; c=relaxed/simple;
	bh=orVDQ7hhzcZXq/b42GMTa4KUxc/JV9kxqkUb0nElsEc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kjwj7jhjdwmCItcD79Wja0EpV+7lgfElaZcaNCuzWxP2Hsn+LSqz+S4qi+zq8M+f6CfhE5MuERWO+9F63HSZnndIwIWNMbNDh2F4sGtqi4QS5K189qHAQw4+vDWNv0K0dt90BjqOuhxzcBAALCVq+AfF5qGwFGPK6fgu1OunZ34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N3UEXpj2; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750410436; x=1781946436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=orVDQ7hhzcZXq/b42GMTa4KUxc/JV9kxqkUb0nElsEc=;
  b=N3UEXpj2fTEg/8MH+CYZYg+Q6FHw0icF0eTKA1rXUOY2vupO5BTiQdnZ
   oTMlH9snLqdtCZrF7QKCegSn4JHI9gPauSnJQnM6X2vVAtsP9eOtn7K7a
   UbMhhH5OpfJ2oco52RZOunBJF03JLxgvJI/UcVahoE511FdzxvKYUbPb3
   CPKTeE3EDYrxHmTc1db365PJT6E5sLLgbxmj8ZBmOxcQDITxe/V3dSPWb
   idCIEUa2VtdVmu+R0DJIa1fVmCZvJ5qCHV2/rYmbHEVAjFQENvC+FWOFi
   7tloOp2aqE2NM1dm/SfAsDeJ6xb2XC/LCWHD7PEJSnGjEWQDX0101bPAT
   A==;
X-CSE-ConnectionGUID: Lqs/KPlyRFSgWR8pLhvG2A==
X-CSE-MsgGUID: M0Tvo1adQGaww3O5VC/HXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56466803"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="56466803"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 02:07:15 -0700
X-CSE-ConnectionGUID: I7uco2X+RieTofx7SRwilQ==
X-CSE-MsgGUID: 7GeHJErKSVWAGx81ov+g4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="156670146"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 20 Jun 2025 02:07:11 -0700
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
Subject: [PATCH 12/16] i386/cpu: Select legacy cache model based on vendor in CPUID 0x4
Date: Fri, 20 Jun 2025 17:27:30 +0800
Message-Id: <20250620092734.1576677-13-zhao1.liu@intel.com>
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

As preparation for merging cache_info_cpuid4 and cache_info_amd in
X86CPUState, set legacy cache model based on vendor in the CPUID 0x4
leaf. For AMD CPU, select legacy AMD cache model (in cache_info_amd) as
the default cache model, otherwise, select legacy Intel cache model (in
cache_info_cpuid4) as before.

To ensure compatibility is not broken, add an enable_legacy_vendor_cache
flag based on x-vendor-only-v2 to indicate cases where the legacy cache
model should be used regardless of the vendor. For CPUID 0x4 leaf,
enable_legacy_vendor_cache flag indicates to pick legacy Intel cache
model, which is for compatibility with the behavior of PC machine v10.0
and older.

The following explains how current vendor-based default legacy cache
model ensures correctness without breaking compatibility.

* For the PC machine v6.0 and older, vendor_cpuid_only=false, and
  vendor_cpuid_only_v2=false.

  - If the named CPU model has its own cache model, and doesn't use
    legacy cache model (legacy_cache=false), then cache_info_cpuid4 and
    cache_info_amd are same, so 0x4 leaf uses its own cache model
    regardless of the vendor.

  - For max/host/named CPU (without its own cache model), then the flag
    enable_legacy_vendor_cache is true, they will use legacy Intel cache
    model just like their previous behavior.

* For the PC machine v10.0 and older (to v6.1), vendor_cpuid_only=true,
  and vendor_cpuid_only_v2=false.

  - If the named CPU model has its own cache model (legacy_cache=false),
    then cache_info_cpuid4 & cache_info_amd both equal to its own cache
    model, so it uses its own cache model in 0x4 leaf regardless of the
    vendor. Only AMD CPUs have all-0 leaf due to vendor_cpuid_only=true,
    and this is exactly the behavior of these old machines.

  - For max/host/named CPU (without its own cache model), then the flag
    enable_legacy_vendor_cache is true, they will use legacy Intel cache
    model. Similarly, only AMD CPUs have all-0 leaf, and this is exactly
    the behavior of these old machines.

* For the PC machine v10.1 and newer, vendor_cpuid_only=true, and
  vendor_cpuid_only_v2=true.

  - If the named CPU model has its own cache model (legacy_cache=false),
    then cache_info_cpuid4 & cache_info_amd both equal to its own cache
    model, so it uses its own cache model in 0x4 leaf regardless of the
    vendor. And AMD CPUs have all-0 leaf. Nothing will change.

  - For max/host/named CPU (without its own cache model), then the flag
    enable_legacy_vendor_cache is false, the legacy cache model is
    selected based on vendor.

    For AMD CPU, it will use legacy AMD cache but still get all-0 leaf
    due to vendor_cpuid_only=true.

    For non-AMD (Intel/Zhaoxin) CPU, it will use legacy Intel cache as
    expected.

    Here, selecting the legacy cache model based on the vendor does not
    change the previous (before the change) behavior.

Therefore, the above analysis proves that, with the help of the flag
enable_legacy_vendor_cache, it is acceptable to select the default
legacy cache model based on the vendor.

For the CPUID 0x4 leaf, in X86CPUState, a unified cache_info is enough.
It only needs to be initialized and configured with the corresponding
legacy cache model based on the vendor.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 524d39de9ace..afbf11569ab4 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7517,7 +7517,35 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         encode_cache_cpuid2(cpu, caches, eax, ebx, ecx, edx);
         break;
     }
-    case 4:
+    case 4: {
+        const CPUCaches *caches;
+
+        if (env->enable_legacy_vendor_cache) {
+            caches = &legacy_intel_cache_info;
+        } else {
+            /*
+             * FIXME: Temporarily select cache info model here based on
+             * vendor, and merge these 2 cache info models later.
+             *
+             * This condition covers the following cases (with
+             * enable_legacy_vendor_cache=false):
+             *  - When CPU model has its own cache model and doesn't use legacy
+             *    cache model (legacy_model=off). Then cache_info_amd and
+             *    cache_info_cpuid4 are the same.
+             *
+             *  - For v10.1 and newer machines, when CPU model uses legacy cache
+             *    model. Non-AMD CPUs use cache_info_cpuid4 like before and AMD
+             *    CPU will use cache_info_amd. But this doesn't matter for AMD
+             *    CPU, because this leaf encodes all-0 for AMD whatever its cache
+             *    model is.
+             */
+            if (IS_AMD_CPU(env)) {
+                caches = &env->cache_info_amd;
+            } else {
+                caches = &env->cache_info_cpuid4;
+            }
+        }
+
         /* cache info: needed for Core compatibility */
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, count, eax, ebx, ecx, edx);
@@ -7545,30 +7573,26 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 
             switch (count) {
             case 0: /* L1 dcache info */
-                encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
-                                    topo_info,
+                encode_cache_cpuid4(caches->l1d_cache, topo_info,
                                     eax, ebx, ecx, edx);
                 if (!cpu->l1_cache_per_core) {
                     *eax &= ~MAKE_64BIT_MASK(14, 12);
                 }
                 break;
             case 1: /* L1 icache info */
-                encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
-                                    topo_info,
+                encode_cache_cpuid4(caches->l1i_cache, topo_info,
                                     eax, ebx, ecx, edx);
                 if (!cpu->l1_cache_per_core) {
                     *eax &= ~MAKE_64BIT_MASK(14, 12);
                 }
                 break;
             case 2: /* L2 cache info */
-                encode_cache_cpuid4(env->cache_info_cpuid4.l2_cache,
-                                    topo_info,
+                encode_cache_cpuid4(caches->l2_cache, topo_info,
                                     eax, ebx, ecx, edx);
                 break;
             case 3: /* L3 cache info */
                 if (cpu->enable_l3_cache) {
-                    encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
-                                        topo_info,
+                    encode_cache_cpuid4(caches->l3_cache, topo_info,
                                         eax, ebx, ecx, edx);
                     break;
                 }
@@ -7579,6 +7603,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             }
         }
         break;
+    }
     case 5:
         /* MONITOR/MWAIT Leaf */
         *eax = cpu->mwait.eax; /* Smallest monitor-line size in bytes */
-- 
2.34.1



Return-Path: <kvm+bounces-52134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23FC2B01932
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6012C1C210E4
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9494227EFED;
	Fri, 11 Jul 2025 10:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hJlEhf0T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F8527FB19
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228101; cv=none; b=ZRxLZBEhRlUas2MU0+5GxIRDnPQuMkDRz+JNw2ZD/DBn6yo4XQ4folOaysZ+XAw39xcuLjgl4ITcWjG/b/BbdDZWmKT7Vyspn5+/0JqGIwudLc9WBl3dh7ES2lZ/h2YMXa7VljSHufx3SFrTujQYdRe4WoV/1ZfXUlxioOjf7o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228101; c=relaxed/simple;
	bh=KLtRBrU7pyXx+1v3WsNd6w0Pzc8d6ZFkUOlzgqUA5mQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mm1Uign0/WSn9CbH0mdXVg3aG3wU+cM4wOurrlIvb5Silu2gDF+6GWdA3hlsJzhzvgShggS82pYISzfJlUn2OljHenL3PigP9kKs2c5lLudSB11yqs3cNTcol7ZhRFbIIPFIEBFifQz62AXehA02KL8RexyKzhAEeZSolYPTjxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hJlEhf0T; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228100; x=1783764100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KLtRBrU7pyXx+1v3WsNd6w0Pzc8d6ZFkUOlzgqUA5mQ=;
  b=hJlEhf0ToNRiKaDSsJuORsPg7qmwtKEF8AWnPWHg9zBCE83vGxnUo4+X
   pFCB6lEJGf6/7P6AbvtGrexIIadi0wTL1+OkxbFSZmnRMwr09ojAGPJVI
   cLK9c6qqWf1U30xUUmqbqRlTMDJ1DTmNvy54OUqmEi9kLfcdaAC4unlJT
   iIH1OsY8stlJ+WJlfJp86SlzRH6UBjMP+X4ou8AH1rWKcRO91lXvB7E3P
   +JYrxt4yzWwrIQPyjQj8+8pIrwVbTl8jo7rwC8G+CEv8UcreT5rXZH6hm
   9G4L4UE6h1KSR8BZu93XTKUODDJOK3DrHTOLMwKtc3uI3+HAMpWW5m2eS
   Q==;
X-CSE-ConnectionGUID: 9+t0CFP3TbSJlSbL5Kf3dQ==
X-CSE-MsgGUID: NzDYPyupTjikodfVW3jS0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496437"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496437"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:01:40 -0700
X-CSE-ConnectionGUID: a7hFDBWySc2fLCFB9aaxTQ==
X-CSE-MsgGUID: In32M7ACR7GHbpWOwAtV2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662152"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:01:35 -0700
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
Subject: [PATCH v2 16/18] i386/cpu: Select legacy cache model based on vendor in CPUID 0x80000006
Date: Fri, 11 Jul 2025 18:21:41 +0800
Message-Id: <20250711102143.1622339-17-zhao1.liu@intel.com>
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

As preparation for merging cache_info_cpuid4 and cache_info_amd in
X86CPUState, set legacy cache model based on vendor in the CPUID
0x80000006 leaf. For AMD CPU, select legacy AMD cache model (in
cache_info_amd) as the default cache model like before, otherwise,
select legacy Intel cache model (in cache_info_cpuid4).

To ensure compatibility is not broken, add an enable_legacy_vendor_cache
flag based on x-vendor-only-v2 to indicate cases where the legacy cache
model should be used regardless of the vendor. For CPUID 0x80000006 leaf,
enable_legacy_vendor_cache flag indicates to pick legacy Intel cache
model, which is for compatibility with the behavior of PC machine v10.0
and older.

The following explains how current vendor-based default legacy cache
model ensures correctness without breaking compatibility.

* For the PC machine v6.0 and older, vendor_cpuid_only=false, and
  vendor_cpuid_only_v2=false.

  - If the named CPU model has its own cache model, and doesn't use
    legacy cache model (legacy_cache=false), then cache_info_cpuid4 and
    cache_info_amd are same, so 0x80000006 leaf uses its own cache model
    regardless of the vendor.

  - For max/host/named CPU (without its own cache model), then the flag
    enable_legacy_vendor_cache is true, they will use legacy AMD cache
    model just like their previous behavior.

* For the PC machine v10.0 and older (to v6.1), vendor_cpuid_only=true,
  and vendor_cpuid_only_v2=false.

  - No change, since this leaf doesn't aware vendor_cpuid_only.

* For the PC machine v10.1 and newer, vendor_cpuid_only=true, and
  vendor_cpuid_only_v2=true.

  - If the named CPU model has its own cache model (legacy_cache=false),
    then cache_info_cpuid4 & cache_info_amd both equal to its own cache
    model, so it uses its own cache model in 0x80000006 leaf regardless
    of the vendor. Intel and Zhaoxin CPUs have their special encoding
    based on SDM, which is the expected behavior and no different from
    before.

  - For max/host/named CPU (without its own cache model), then the flag
    enable_legacy_vendor_cache is false, the legacy cache model is
    selected based on vendor.

    For AMD CPU, it will use legacy AMD cache as before.

    For non-AMD (Intel/Zhaoxin) CPU, it will use legacy Intel cache and
    be encoded based on SDM as expected.

    Here, selecting the legacy cache model based on the vendor does not
    change the previous (before the change) behavior.

Therefore, the above analysis proves that, with the help of the flag
enable_legacy_vendor_cache, it is acceptable to select the default
legacy cache model based on the vendor.

For the CPUID 0x80000006 leaf, in X86CPUState, a unified cache_info is
enough. It only needs to be initialized and configured with the
corresponding legacy cache model based on the vendor.

Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 22c955c44000..fe1c118b284f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7985,8 +7985,33 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *edx = encode_cache_cpuid80000005(caches->l1i_cache);
         break;
     }
-    case 0x80000006:
-        /* cache info (L2 cache/TLB/L3 cache) */
+    case 0x80000006: { /* cache info (L2 cache/TLB/L3 cache) */
+        const CPUCaches *caches;
+
+        if (env->enable_legacy_vendor_cache) {
+            caches = &legacy_amd_cache_info;
+        } else {
+            /*
+             * FIXME: Temporarily select cache info model here based on
+             * vendor, and merge these 2 cache info models later.
+             *
+             * This condition covers the following cases (with
+             * enable_legacy_vendor_cache=false):
+             *  - When CPU model has its own cache model and doesn't uses legacy
+             *    cache model (legacy_model=off). Then cache_info_amd and
+             *    cache_info_cpuid4 are the same.
+             *
+             *  - For v10.1 and newer machines, when CPU model uses legacy cache
+             *    model. AMD CPUs use cache_info_amd like before and non-AMD
+             *    CPU (Intel & Zhaoxin) will use cache_info_cpuid4 as expected.
+             */
+            if (IS_AMD_CPU(env)) {
+                caches = &env->cache_info_amd;
+            } else {
+                caches = &env->cache_info_cpuid4;
+            }
+        }
+
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
             break;
@@ -7995,7 +8020,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if (cpu->vendor_cpuid_only_v2 &&
             (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
             *eax = *ebx = 0;
-            encode_cache_cpuid80000006(env->cache_info_cpuid4.l2_cache,
+            encode_cache_cpuid80000006(caches->l2_cache,
                                        NULL, ecx, edx);
             break;
         }
@@ -8009,11 +8034,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                (X86_ENC_ASSOC(L2_ITLB_4K_ASSOC) << 12) |
                (L2_ITLB_4K_ENTRIES);
 
-        encode_cache_cpuid80000006(env->cache_info_amd.l2_cache,
+        encode_cache_cpuid80000006(caches->l2_cache,
                                    cpu->enable_l3_cache ?
-                                   env->cache_info_amd.l3_cache : NULL,
+                                   caches->l3_cache : NULL,
                                    ecx, edx);
         break;
+    }
     case 0x80000007:
         *eax = 0;
         *ebx = env->features[FEAT_8000_0007_EBX];
-- 
2.34.1



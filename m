Return-Path: <kvm+bounces-50042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6843DAE1713
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:07:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B21BA19E47A3
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BACED280006;
	Fri, 20 Jun 2025 09:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JdE3rBIR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBF327FD42
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750410446; cv=none; b=FadtxzHzOcNYkGh8NPgEMNDtrFmUzNVweKQzrzPnpUCsqajEXRQwd1JL59Ge/XCrZ7LM7iKtA8XJhCZENZTuYlasTffcOWl/N7k1F0PQCS8zTaHuAcPHonj8ELEI+g/omLycsF2MY/3vpvy9TWDVje2yklDPpZhqLp42auvB6VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750410446; c=relaxed/simple;
	bh=f3bs6AqT/+bwfc6zT2OHpOSRXd2vnkmqjBgAgaEUjTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=II3RHI17U1l6cWgJT+nujycfaQhv0J1G71kSkBUfw1fXvvd0rR3oOTRrTGDqiH9/hk/IQ2Qvu/2xQxfdEBzjjL58XyuBzGIphakSUbsq4RtqSBGilX8qhBvMJB/i0hv7gGsXhjWBvH/T5pRIGiuHappBCHFICadZofLY5YF3vyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JdE3rBIR; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750410445; x=1781946445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f3bs6AqT/+bwfc6zT2OHpOSRXd2vnkmqjBgAgaEUjTQ=;
  b=JdE3rBIRekqloPNo6Zxc2uWfxHF6cMG/NY+fTpAaf5u9xTOk/IdyQFED
   mUZ23aiUt0cGKv3GvNI/yWqOGvbC3JNLl4Ha0ja29sd7L7QfT9N4FsNmH
   Hzo6VE4Ck7f5caX5H3x5krcIv9bvjS/Zz6iLJfZgOyxIoz6leS0RapzLU
   U9bRYlPKLfSdDiVftI8h5Ed8Wpv1dC45iGxUYb4B021Vl8PoDQzDC2p96
   fV/BiYOj16smt4JwG2ruCvJk15P2utFKYwwFmOzNwpHsrPpkIOs7e6GMB
   VcjeN7f7/Jsz+WfDC4FTx1iJbjOdCoFM6JfF0DqG+IxwtNm8nq1Wf6JlL
   g==;
X-CSE-ConnectionGUID: lxxb9xXzRHyy9FjbOA4a/A==
X-CSE-MsgGUID: CeY09NlFRqaCl623J88lNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56466835"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="56466835"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 02:07:24 -0700
X-CSE-ConnectionGUID: 3HFMzeHmSiWAq5U13Fc5eg==
X-CSE-MsgGUID: QFtiuitrStejMBG7bPu+PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="156670179"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 20 Jun 2025 02:07:20 -0700
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
Subject: [PATCH 14/16] i386/cpu: Select legacy cache model based on vendor in CPUID 0x80000006
Date: Fri, 20 Jun 2025 17:27:32 +0800
Message-Id: <20250620092734.1576677-15-zhao1.liu@intel.com>
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

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 16b4ecb76113..4fa5907027a0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7992,8 +7992,33 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
@@ -8002,7 +8027,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if (cpu->vendor_cpuid_only_v2 &&
             (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
             *eax = *ebx = 0;
-            encode_cache_cpuid80000006(env->cache_info_cpuid4.l2_cache,
+            encode_cache_cpuid80000006(caches->l2_cache,
                                        NULL, ecx, edx, false);
             break;
         }
@@ -8016,11 +8041,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                (X86_ENC_ASSOC(L2_ITLB_4K_ASSOC) << 12) |
                (L2_ITLB_4K_ENTRIES);
 
-        encode_cache_cpuid80000006(env->cache_info_amd.l2_cache,
+        encode_cache_cpuid80000006(caches->l2_cache,
                                    cpu->enable_l3_cache ?
-                                   env->cache_info_amd.l3_cache : NULL,
+                                   caches->l3_cache : NULL,
                                    ecx, edx, true);
         break;
+    }
     case 0x80000007:
         *eax = 0;
         *ebx = env->features[FEAT_8000_0007_EBX];
-- 
2.34.1



Return-Path: <kvm+bounces-52133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE92EB0192F
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D16971C21962
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF2D27F16D;
	Fri, 11 Jul 2025 10:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XRxh3d7P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF4027E075
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228097; cv=none; b=kZH17dYIgg+4YiU+B2OHOuVsazSm+TOERgzjUHtvVeBJYltFTkKUfdFaEOWKKz9ARdZ1ACXgl3AoVAMTcusTIieIeUm8huUXmbWOY4qrvOz/I6xjWZzcfNBNcqCbjss0iLOLY5i0N6Ot7vs3RR3oIvvYR/++SHEjXNmstvVwJxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228097; c=relaxed/simple;
	bh=htnFm4BrBbQOnh6jhI+zR4FEgr7u9fy4FwyoLCptThA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rKRlkRI2tfO7hTOvcMYncwnAUF0INhgMeZtvoybteuRd4S/U5GvlDUPgtc65zYmjToulzFtR3I8zNrxLu+HjkuBCcHtXFF0QwbFvQJw3Xni6EYAyZPPF1Tf+PDq6eE7FFyIeKlqFmQ4UVRHKFc5wopfPo53NwzvIcbe7PbR3uKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XRxh3d7P; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228095; x=1783764095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=htnFm4BrBbQOnh6jhI+zR4FEgr7u9fy4FwyoLCptThA=;
  b=XRxh3d7P1JxRc6i9uByv4I68FKpFuTF2oUpMw2tLbZJviohGTZ/OdLTM
   Ra8MtHhFXW63ye5CyACEt11IXbkPhItSj2I52tsTavReUjifTpbttydeS
   aKUd1l/UpuCDiPmiC1jsqa8wDRQYjMX2pd/MDxY72ZLchtsk5rz5/kC9K
   L5Dq/iT2MwF2wI41D/zg0kUupIgHn7/MYzGDU7qyMqmhZfYD3MiQHDnhW
   P/Rrxk0nRhmXYm59Qx2yPmrZh3BmzjKuPnwwsq6ACWlHi43fSBQwE/IqO
   k74otjJk1WmLSteESCjrtbTtOXjcB9g/yG4fW760vgfQvCd6xv6FqHcBW
   g==;
X-CSE-ConnectionGUID: iMmeTk7iQmCeHJm+CNNEPg==
X-CSE-MsgGUID: PUsoN3xoS8qd4W93m754EA==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496421"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496421"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:01:35 -0700
X-CSE-ConnectionGUID: LkSMSK/JSeaJSx4zGPSBeQ==
X-CSE-MsgGUID: HQ3KamkbRUicSIfLTvgtpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662145"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:01:30 -0700
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
Subject: [PATCH v2 15/18] i386/cpu: Select legacy cache model based on vendor in CPUID 0x80000005
Date: Fri, 11 Jul 2025 18:21:40 +0800
Message-Id: <20250711102143.1622339-16-zhao1.liu@intel.com>
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
0x80000005 leaf. For AMD CPU, select legacy AMD cache model (in
cache_info_amd) as the default cache model like before, otherwise,
select legacy Intel cache model (in cache_info_cpuid4).

To ensure compatibility is not broken, add an enable_legacy_vendor_cache
flag based on x-vendor-only-v2 to indicate cases where the legacy cache
model should be used regardless of the vendor. For CPUID 0x80000005
leaf, enable_legacy_vendor_cache flag indicates to pick legacy AMD cache
model, which is for compatibility with the behavior of PC machine v10.0
and older.

The following explains how current vendor-based default legacy cache
model ensures correctness without breaking compatibility.

* For the PC machine v6.0 and older, vendor_cpuid_only=false, and
  vendor_cpuid_only_v2=false.

  - If the named CPU model has its own cache model, and doesn't use
    legacy cache model (legacy_cache=false), then cache_info_cpuid4 and
    cache_info_amd are same, so 0x80000005 leaf uses its own cache model
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
    model, so it uses its own cache model in 0x80000005 leaf regardless
    of the vendor. Only Intel CPUs have all-0 leaf due to
    vendor_cpuid_only_2=true, and this is exactly the expected behavior.

  - For max/host/named CPU (without its own cache model), then the flag
    enable_legacy_vendor_cache is false, the legacy cache model is
    selected based on vendor.

    For AMD CPU, it will use legacy AMD cache as expected.

    For Intel CPU, it will use legacy Intel cache but still get all-0
    leaf due to vendor_cpuid_only_2=true as expected.

    (Note) And for Zhaoxin CPU, it will use legacy Intel cache model
    instead of AMD's. This is the difference brought by this change! But
    it's correct since then Zhaoxin could have the consistent cache info
    in CPUID 0x2, 0x4 and 0x80000005 leaves.

    Here, except Zhaoxin, selecting the legacy cache model based on the
    vendor does not change the previous (before the change) behavior.
    And the change for Zhaoxin is also a good improvement.

Therefore, the above analysis proves that, with the help of the flag
enable_legacy_vendor_cache, it is acceptable to select the default
legacy cache model based on the vendor.

For the CPUID 0x80000005 leaf, in X86CPUState, a unified cache_info is
enough. It only needs to be initialized and configured with the
corresponding legacy cache model based on the vendor.

Cc: EwanHai <ewanhai-oc@zhaoxin.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Note, side effect of this patch: fix the inconsistency cache info for
Zhaoxin. For more details, see the commit message above.
---
 target/i386/cpu.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 73872cb74b6f..22c955c44000 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7937,8 +7937,36 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *ecx = env->cpuid_model[(index - 0x80000002) * 4 + 2];
         *edx = env->cpuid_model[(index - 0x80000002) * 4 + 3];
         break;
-    case 0x80000005:
+    case 0x80000005: {
         /* cache info (L1 cache/TLB Associativity Field) */
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
+             *    CPU will use cache_info_cpuid4. But this doesn't matter,
+             *    because for Intel CPU, it will get all-0 leaf, and Zhaoxin CPU
+             *    will get correct cache info. Both are expected.
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
@@ -7953,9 +7981,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                (L1_ITLB_2M_ASSOC <<  8) | (L1_ITLB_2M_ENTRIES);
         *ebx = (L1_DTLB_4K_ASSOC << 24) | (L1_DTLB_4K_ENTRIES << 16) |
                (L1_ITLB_4K_ASSOC <<  8) | (L1_ITLB_4K_ENTRIES);
-        *ecx = encode_cache_cpuid80000005(env->cache_info_amd.l1d_cache);
-        *edx = encode_cache_cpuid80000005(env->cache_info_amd.l1i_cache);
+        *ecx = encode_cache_cpuid80000005(caches->l1d_cache);
+        *edx = encode_cache_cpuid80000005(caches->l1i_cache);
         break;
+    }
     case 0x80000006:
         /* cache info (L2 cache/TLB/L3 cache) */
         if (cpu->cache_info_passthrough) {
-- 
2.34.1



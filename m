Return-Path: <kvm+bounces-50041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85775AE1710
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:07:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B60F4A6263
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3EC27F75C;
	Fri, 20 Jun 2025 09:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AyVjTUGZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC1227FD56
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750410441; cv=none; b=CGQrRJi9cP/FJNVTqXVV24IH+jpOuFMPsWEpMbnLOPYonJo0AwrKU+1sfWTcE81e7Vqj/bx/RCVqNP3PMvZ9VWJQueodH2L/VZXfxledoQCGND+jUXuo+WStdyqiDtJJtEYiDZxQkK+ExqIsMSytjUoAnTIkvfZfpNK1SzGcqSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750410441; c=relaxed/simple;
	bh=dtIFEjOV1P4gPMklmfM6Est0sZC3VxsPqd5RV0tmch0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TyQoVIyniG8PNvjH6U+9humsoxbeUubQ8zIgLdm3ecflxkdqMB8s4fd+j3Z0NCiZarAFKxl/+LU0yqqHrso2h252lO+YMz/p5wF221IqNrvDjFiMgkMZhM6cGpY4MdL7Jyv3fOkTZbEpW7SkpB1RVrSptW3w1RV+4VpNH2lXKcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AyVjTUGZ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750410440; x=1781946440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dtIFEjOV1P4gPMklmfM6Est0sZC3VxsPqd5RV0tmch0=;
  b=AyVjTUGZuEhSe8eeClBw69IlHcmre3+c81nUaDBw35qqbaTSxuelO34t
   d/hgngrI1aFgMRnKg2ovFRIX/9CrGwvaUJIER11t1kGW9HUTjjKquZPW1
   FPBwH8iRk/cBZZF0VHXl+W10M+2nj3qQ7vrI5PqS+soNw3tFHvyetRPA/
   xozQfBeVoySvcQKTYinLagQGPAJw3BWvWtWHoBE5YyEFM1QMeMxJ9+dD5
   cOnosQGxAxQksN5HrCohS299JxS0LK7IaAiRBXh7y7DeSXEfSqZ98K/Ht
   OvuzQHBsYbWmPiGqhRxbPppT9rneTAAD3PWFzR0ZXiTDAQn61QcVRl65H
   w==;
X-CSE-ConnectionGUID: 5Zb7dbMaSaOWiVU03aC9mg==
X-CSE-MsgGUID: vOcdXDIaQqKrFkI5dkfXUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56466823"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="56466823"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 02:07:20 -0700
X-CSE-ConnectionGUID: UYtUcJIdTlKQj0mlTyHDUw==
X-CSE-MsgGUID: JdSCB6CPTYC+VGlOiG/J5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="156670159"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 20 Jun 2025 02:07:16 -0700
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
Subject: [PATCH 13/16] i386/cpu: Select legacy cache model based on vendor in CPUID 0x80000005
Date: Fri, 20 Jun 2025 17:27:31 +0800
Message-Id: <20250620092734.1576677-14-zhao1.liu@intel.com>
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
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Note, side effect of this patch: fix the inconsistency cache info for
Zhaoxin. For more details, see the commit message above.
---
 target/i386/cpu.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index afbf11569ab4..16b4ecb76113 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7945,8 +7945,35 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *ecx = env->cpuid_model[(index - 0x80000002) * 4 + 2];
         *edx = env->cpuid_model[(index - 0x80000002) * 4 + 3];
         break;
-    case 0x80000005:
-        /* cache info (L1 cache/TLB Associativity Field) */
+    case 0x80000005: { /* cache info (L1 cache/TLB Associativity Field) */
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
@@ -7961,9 +7988,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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



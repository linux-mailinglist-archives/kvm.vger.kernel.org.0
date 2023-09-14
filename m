Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3D679FCE1
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbjINHMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjINHMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:12:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A7ECCD
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694675517; x=1726211517;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8YjE0lp0F+Nnb0Q0RgfykymXash7WBfciVL5YAubGGs=;
  b=ZhNZEM9BhjgvDX/geEFL/8fKReuo4DyVoGBHzxoRgvA5vVAIPPajPPoK
   O3/EOVY018E6lelJiSH1VkghQplhWUDnYwguJRmas9Mb2pa+MzOFHNklc
   MtodhkE17YetUoqelHmAkdYoy3P+Q+SELuz4b3ZPeRrBIRY45dDzro5a5
   qH0UAgibKsosZz5vOfYn2fvmPkb2s74dfXaBHES2TrYWcHh7FpnioBlgq
   ZyDDmBZBpSediO/DLR4Tm3GCkwXX/bQunFrNavQyZoYr+Q+41R42ZJsdF
   X3EvWc3U+amC/MQZ6tpOprcMODMm5i+Z3pVOe5TW+QHm968aJ+xfUzQyG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="359136024"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="359136024"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 00:11:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779526345"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779526345"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 14 Sep 2023 00:11:37 -0700
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v4 06/21] i386/cpu: Use APIC ID offset to encode cache topo in CPUID[4]
Date:   Thu, 14 Sep 2023 15:21:44 +0800
Message-Id: <20230914072159.1177582-7-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

Refer to the fixes of cache_info_passthrough ([1], [2]) and SDM, the
CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26] should use the
nearest power-of-2 integer.

The nearest power-of-2 integer can be calculated by pow2ceil() or by
using APIC ID offset (like L3 topology using 1 << die_offset [3]).

But in fact, CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26]
are associated with APIC ID. For example, in linux kernel, the field
"num_threads_sharing" (Bits 25 - 14) is parsed with APIC ID. And for
another example, on Alder Lake P, the CPUID.04H:EAX[bits 31:26] is not
matched with actual core numbers and it's calculated by:
"(1 << (pkg_offset - core_offset)) - 1".

Therefore the offset of APIC ID should be preferred to calculate nearest
power-of-2 integer for CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits
31:26]:
1. d/i cache is shared in a core, 1 << core_offset should be used
   instand of "cs->nr_threads" in encode_cache_cpuid4() for
   CPUID.04H.00H:EAX[bits 25:14] and CPUID.04H.01H:EAX[bits 25:14].
2. L2 cache is supposed to be shared in a core as for now, thereby
   1 << core_offset should also be used instand of "cs->nr_threads" in
   encode_cache_cpuid4() for CPUID.04H.02H:EAX[bits 25:14].
3. Similarly, the value for CPUID.04H:EAX[bits 31:26] should also be
   calculated with the bit width between the Package and SMT levels in
   the APIC ID (1 << (pkg_offset - core_offset) - 1).

In addition, use APIC ID offset to replace "pow2ceil()" for
cache_info_passthrough case.

[1]: efb3934adf9e ("x86: cpu: make sure number of addressable IDs for processor cores meets the spec")
[2]: d7caf13b5fcf ("x86: cpu: fixup number of addressable IDs for logical processors sharing cache")
[3]: d65af288a84d ("i386: Update new x86_apicid parsing rules with die_offset support")

Fixes: 7e3482f82480 ("i386: Helpers to encode cache information consistently")
Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v3:
 * Fix compile warnings. (Babu)
 * Fix spelling typo.

Changes since v1:
 * Use APIC ID offset to replace "pow2ceil()" for cache_info_passthrough
   case. (Yanan)
 * Split the L1 cache fix into a separate patch.
 * Rename the title of this patch (the original is "i386/cpu: Fix number
   of addressable IDs in CPUID.04H").
---
 target/i386/cpu.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c5c2a045e032..a3d67c1762c0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6009,7 +6009,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 {
     X86CPU *cpu = env_archcpu(env);
     CPUState *cs = env_cpu(env);
-    uint32_t die_offset;
     uint32_t limit;
     uint32_t signature[3];
     X86CPUTopoInfo topo_info;
@@ -6093,39 +6092,56 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                 int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
                 int vcpus_per_socket = cs->nr_cores * cs->nr_threads;
                 if (cs->nr_cores > 1) {
+                    int addressable_cores_offset =
+                                                apicid_pkg_offset(&topo_info) -
+                                                apicid_core_offset(&topo_info);
+
                     *eax &= ~0xFC000000;
-                    *eax |= (pow2ceil(cs->nr_cores) - 1) << 26;
+                    *eax |= (1 << (addressable_cores_offset - 1)) << 26;
                 }
                 if (host_vcpus_per_cache > vcpus_per_socket) {
+                    int pkg_offset = apicid_pkg_offset(&topo_info);
+
                     *eax &= ~0x3FFC000;
-                    *eax |= (pow2ceil(vcpus_per_socket) - 1) << 14;
+                    *eax |= (1 << (pkg_offset - 1)) << 14;
                 }
             }
         } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
             *eax = *ebx = *ecx = *edx = 0;
         } else {
             *eax = 0;
+            int addressable_cores_offset = apicid_pkg_offset(&topo_info) -
+                                           apicid_core_offset(&topo_info);
+            int core_offset, die_offset;
+
             switch (count) {
             case 0: /* L1 dcache info */
+                core_offset = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
-                                    cs->nr_threads, cs->nr_cores,
+                                    (1 << core_offset),
+                                    (1 << addressable_cores_offset),
                                     eax, ebx, ecx, edx);
                 break;
             case 1: /* L1 icache info */
+                core_offset = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
-                                    cs->nr_threads, cs->nr_cores,
+                                    (1 << core_offset),
+                                    (1 << addressable_cores_offset),
                                     eax, ebx, ecx, edx);
                 break;
             case 2: /* L2 cache info */
+                core_offset = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l2_cache,
-                                    cs->nr_threads, cs->nr_cores,
+                                    (1 << core_offset),
+                                    (1 << addressable_cores_offset),
                                     eax, ebx, ecx, edx);
                 break;
             case 3: /* L3 cache info */
                 die_offset = apicid_die_offset(&topo_info);
                 if (cpu->enable_l3_cache) {
                     encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
-                                        (1 << die_offset), cs->nr_cores,
+                                        (1 << die_offset),
+                                        (1 << addressable_cores_offset),
                                         eax, ebx, ecx, edx);
                     break;
                 }
-- 
2.34.1


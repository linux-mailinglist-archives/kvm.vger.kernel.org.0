Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE87D7D4AFC
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbjJXIww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbjJXIwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 04:52:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C42F12C
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 01:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698137554; x=1729673554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k1JtsNviP7GOybKhfmVAGdtOwHhvwjwaf3jOLEu4kx8=;
  b=dOO2jsOGEIUYMEAlZxgsWUwKHNYzmK6ZbfqSWVDSDJXZYiVpuLgdUCXb
   C13dnrXBahSeXKhxbOa1+6YOQF/iyG1CUnyoEBHzQ7SVEJaGaCsZ6Xotp
   Ub4Af3+4aV5rbIV4t5+v3p+KbUGBDlOs58tElRnt797Zyij32V29tHf/1
   6WiacXcneJvFPQ6FBtqQLP4hQjTPrA/J4laJLeerbjYhl+6y0kDahEEeG
   bkjHf2TzgRIXXKdpGmh0ewC+Fzz9UQ9Ob9Q+P3ECYKkx//J5410fjagTu
   udUzzNk+YDo73922z4pcTXLipsXkn4mZaGI35rgPXd8dUDLporSj4CaqU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="5638352"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="5638352"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:52:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="793418010"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="793418010"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 24 Oct 2023 01:52:29 -0700
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
        Yongwei Ma <yongwei.ma@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v5 06/20] i386/cpu: Use APIC ID offset to encode cache topo in CPUID[4]
Date:   Tue, 24 Oct 2023 17:03:09 +0800
Message-Id: <20231024090323.1859210-7-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231024090323.1859210-1-zhao1.liu@linux.intel.com>
References: <20231024090323.1859210-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
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
index a3b170db108e..5bdef4ac4906 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6013,7 +6013,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 {
     X86CPU *cpu = env_archcpu(env);
     CPUState *cs = env_cpu(env);
-    uint32_t die_offset;
     uint32_t limit;
     uint32_t signature[3];
     X86CPUTopoInfo topo_info;
@@ -6097,39 +6096,56 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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


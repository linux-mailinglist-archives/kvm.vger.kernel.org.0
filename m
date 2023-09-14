Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C057779FCEE
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbjINHMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236011AbjINHMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:12:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D23ECE5
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694675549; x=1726211549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qsySb+iLX3OXfGLJvMu+rPgtCwTig0+b1neIgplN/2w=;
  b=fLJjObhjjmXn8nDpHIOLFukvlxtmEJsT7q7lsX/D5+NXLD9kcYqyR8a3
   yH+enKu+fHNexfXPRIuapQNUsO3xhDWu9gf+I03Q8vqDiKW1RvjG/7Llk
   1it218DmsOEAprV9vktZX3QBArlfnPyNBar2VlW+vKBAdu5X9mCTnyf5n
   CMzOyupCd+W5mVTmTVOdds/i1zy/AJnXbXIyrYwG5Iwo9/RCFwb5JXQsk
   hGisFD4dnhFqhjgBOmHOMZ29j6bmGm95BkQjGuGx8DztZV0iG3J7tDRwh
   ElizFD00k45DrmSpz1LQBQoFA2nxqcgmNGSCiat5LU8eLIsja4k1PsERL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="359136751"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="359136751"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 00:12:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779526805"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779526805"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 14 Sep 2023 00:12:25 -0700
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
        Babu Moger <babu.moger@amd.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 18/21] i386: Use CPUCacheInfo.share_level to encode CPUID[4]
Date:   Thu, 14 Sep 2023 15:21:56 +0800
Message-Id: <20230914072159.1177582-19-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

CPUID[4].EAX[bits 25:14] is used to represent the cache topology for
Intel CPUs.

After cache models have topology information, we can use
CPUCacheInfo.share_level to decide which topology level to be encoded
into CPUID[4].EAX[bits 25:14].

And since maximum_processor_id (original "num_apic_ids") is parsed
based on cpu topology levels, which are verified when parsing smp, it's
no need to check this value by "assert(num_apic_ids > 0)" again, so
remove this assert.

Additionally, wrap the encoding of CPUID[4].EAX[bits 31:26] into a
helper to make the code cleaner.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v1:
 * Use "enum CPUTopoLevel share_level" as the parameter in
   max_processor_ids_for_cache().
 * Make cache_into_passthrough case also use
   max_processor_ids_for_cache() and max_core_ids_in_package() to
   encode CPUID[4]. (Yanan)
 * Rename the title of this patch (the original is "i386: Use
   CPUCacheInfo.share_level to encode CPUID[4].EAX[bits 25:14]").
---
 target/i386/cpu.c | 70 +++++++++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index fcb4f4da3431..5d066107d6ce 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -234,22 +234,53 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
                        ((t) == UNIFIED_CACHE) ? CACHE_TYPE_UNIFIED : \
                        0 /* Invalid value */)
 
+static uint32_t max_processor_ids_for_cache(X86CPUTopoInfo *topo_info,
+                                            enum CPUTopoLevel share_level)
+{
+    uint32_t num_ids = 0;
+
+    switch (share_level) {
+    case CPU_TOPO_LEVEL_CORE:
+        num_ids = 1 << apicid_core_offset(topo_info);
+        break;
+    case CPU_TOPO_LEVEL_DIE:
+        num_ids = 1 << apicid_die_offset(topo_info);
+        break;
+    case CPU_TOPO_LEVEL_PACKAGE:
+        num_ids = 1 << apicid_pkg_offset(topo_info);
+        break;
+    default:
+        /*
+         * Currently there is no use case for SMT and MODULE, so use
+         * assert directly to facilitate debugging.
+         */
+        g_assert_not_reached();
+    }
+
+    return num_ids - 1;
+}
+
+static uint32_t max_core_ids_in_package(X86CPUTopoInfo *topo_info)
+{
+    uint32_t num_cores = 1 << (apicid_pkg_offset(topo_info) -
+                               apicid_core_offset(topo_info));
+    return num_cores - 1;
+}
 
 /* Encode cache info for CPUID[4] */
 static void encode_cache_cpuid4(CPUCacheInfo *cache,
-                                int num_apic_ids, int num_cores,
+                                X86CPUTopoInfo *topo_info,
                                 uint32_t *eax, uint32_t *ebx,
                                 uint32_t *ecx, uint32_t *edx)
 {
     assert(cache->size == cache->line_size * cache->associativity *
                           cache->partitions * cache->sets);
 
-    assert(num_apic_ids > 0);
     *eax = CACHE_TYPE(cache->type) |
            CACHE_LEVEL(cache->level) |
            (cache->self_init ? CACHE_SELF_INIT_LEVEL : 0) |
-           ((num_cores - 1) << 26) |
-           ((num_apic_ids - 1) << 14);
+           (max_core_ids_in_package(topo_info) << 26) |
+           (max_processor_ids_for_cache(topo_info, cache->share_level) << 14);
 
     assert(cache->line_size > 0);
     assert(cache->partitions > 0);
@@ -6258,56 +6289,41 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                 int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
 
                 if (cores_per_pkg > 1) {
-                    int addressable_cores_offset =
-                                                apicid_pkg_offset(&topo_info) -
-                                                apicid_core_offset(&topo_info);
-
                     *eax &= ~0xFC000000;
-                    *eax |= (1 << (addressable_cores_offset - 1)) << 26;
+                    *eax |= max_core_ids_in_package(&topo_info) << 26;
                 }
                 if (host_vcpus_per_cache > cpus_per_pkg) {
-                    int pkg_offset = apicid_pkg_offset(&topo_info);
-
                     *eax &= ~0x3FFC000;
-                    *eax |= (1 << (pkg_offset - 1)) << 14;
+                    *eax |=
+                        max_processor_ids_for_cache(&topo_info,
+                                                CPU_TOPO_LEVEL_PACKAGE) << 14;
                 }
             }
         } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
             *eax = *ebx = *ecx = *edx = 0;
         } else {
             *eax = 0;
-            int addressable_cores_offset = apicid_pkg_offset(&topo_info) -
-                                           apicid_core_offset(&topo_info);
-            int core_offset, die_offset;
 
             switch (count) {
             case 0: /* L1 dcache info */
-                core_offset = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
-                                    (1 << core_offset),
-                                    (1 << addressable_cores_offset),
+                                    &topo_info,
                                     eax, ebx, ecx, edx);
                 break;
             case 1: /* L1 icache info */
-                core_offset = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
-                                    (1 << core_offset),
-                                    (1 << addressable_cores_offset),
+                                    &topo_info,
                                     eax, ebx, ecx, edx);
                 break;
             case 2: /* L2 cache info */
-                core_offset = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l2_cache,
-                                    (1 << core_offset),
-                                    (1 << addressable_cores_offset),
+                                    &topo_info,
                                     eax, ebx, ecx, edx);
                 break;
             case 3: /* L3 cache info */
-                die_offset = apicid_die_offset(&topo_info);
                 if (cpu->enable_l3_cache) {
                     encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
-                                        (1 << die_offset),
-                                        (1 << addressable_cores_offset),
+                                        &topo_info,
                                         eax, ebx, ecx, edx);
                     break;
                 }
-- 
2.34.1


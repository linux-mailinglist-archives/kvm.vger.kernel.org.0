Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F60579FCEF
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbjINHMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236060AbjINHMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:12:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CF410D9
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694675552; x=1726211552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M1MPqTHXsorZtEoquh+kEOpnj1sZVMk0ii0gwm0+MSk=;
  b=UlVPZU3AyzAToxa0QKpNAoQK2OEbsliRCguM1EnHDwfLcB2VQ21lT5lJ
   e5TLAhM7P6i1speqPodVeFJtIX4zeugK6XKskJn8MnYMD9ivq3fVUNE8l
   8jqZT0HFYHE5XvyGYiVhCNcVix2m/CCy5+R4UlBQ5ZXXONJSiTqmoOrUa
   ovnEgx4l6GEQ/+TQIw5uqF3Q0XmR5cEvzMWgajb4UmgLQiJGWG+aHP/Ae
   IL6B8+W5mVnPzySxknJO5hnSCOgotM3ENZQkqnX0EV0lKuwsicLd47S0K
   JIlSJo86kKfc+dcCNhF53hHzCU6uTAD+tjNe+KkeMuPbzV/Z3Ec/KCUsm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="359136766"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="359136766"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 00:12:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779526835"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779526835"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 14 Sep 2023 00:12:28 -0700
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
Subject: [PATCH v4 19/21] i386: Use offsets get NumSharingCache for CPUID[0x8000001D].EAX[bits 25:14]
Date:   Thu, 14 Sep 2023 15:21:57 +0800
Message-Id: <20230914072159.1177582-20-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

The commit 8f4202fb1080 ("i386: Populate AMD Processor Cache Information
for cpuid 0x8000001D") adds the cache topology for AMD CPU by encoding
the number of sharing threads directly.

From AMD's APM, NumSharingCache (CPUID[0x8000001D].EAX[bits 25:14])
means [1]:

The number of logical processors sharing this cache is the value of
this field incremented by 1. To determine which logical processors are
sharing a cache, determine a Share Id for each processor as follows:

ShareId = LocalApicId >> log2(NumSharingCache+1)

Logical processors with the same ShareId then share a cache. If
NumSharingCache+1 is not a power of two, round it up to the next power
of two.

From the description above, the calculation of this field should be same
as CPUID[4].EAX[bits 25:14] for Intel CPUs. So also use the offsets of
APIC ID to calculate this field.

[1]: APM, vol.3, appendix.E.4.15 Function 8000_001Dh--Cache Topology
     Information

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v3:
 * Rewrite the subject. (Babu)
 * Delete the original "comment/help" expression, as this behavior is
   confirmed for AMD CPUs. (Babu)
 * Rename "num_apic_ids" (v3) to "num_sharing_cache" to match spec
   definition. (Babu)

Changes since v1:
 * Rename "l3_threads" to "num_apic_ids" in
   encode_cache_cpuid8000001d(). (Yanan)
 * Add the description of the original commit and add Cc.
---
 target/i386/cpu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5d066107d6ce..bc28c59df089 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -482,7 +482,7 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
                                        uint32_t *eax, uint32_t *ebx,
                                        uint32_t *ecx, uint32_t *edx)
 {
-    uint32_t l3_threads;
+    uint32_t num_sharing_cache;
     assert(cache->size == cache->line_size * cache->associativity *
                           cache->partitions * cache->sets);
 
@@ -491,13 +491,11 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
 
     /* L3 is shared among multiple cores */
     if (cache->level == 3) {
-        l3_threads = topo_info->modules_per_die *
-                     topo_info->cores_per_module *
-                     topo_info->threads_per_core;
-        *eax |= (l3_threads - 1) << 14;
+        num_sharing_cache = 1 << apicid_die_offset(topo_info);
     } else {
-        *eax |= ((topo_info->threads_per_core - 1) << 14);
+        num_sharing_cache = 1 << apicid_core_offset(topo_info);
     }
+    *eax |= (num_sharing_cache - 1) << 14;
 
     assert(cache->line_size > 0);
     assert(cache->partitions > 0);
-- 
2.34.1


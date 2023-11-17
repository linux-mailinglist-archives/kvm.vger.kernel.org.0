Return-Path: <kvm+bounces-1931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D8517EECD2
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAE13280C9B
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 07:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52FCBEAD7;
	Fri, 17 Nov 2023 07:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KVbOnOa5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2DE109
	for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 23:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700206819; x=1731742819;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5tYS4G2HZatnuAwGoJ1pL4agrEatB27fQNYS9iNFe6o=;
  b=KVbOnOa59d+zHPejMiq8lfHcPHNMDu/B/rXbe/YDco9FGMhPEApicJUw
   XcR9E7C1d3xGIzyl0p+izT0CpDqqLoe41EncdPHbsZcKWr0IxSPdtOh32
   hpnNM9nM6lmxxpCs+czA2Z462PwttUT5HYmoIS590tURT1LWAgXhOJ4G/
   v/5/s0VPKHAURUaxGb8Q5tSzrb2CrS8Iu9gm+14vq46hy/fseSMwpJeqI
   awE3Lj8GzogwvYjrC7z6cL7Wue9Vwe/7mpi3xRb9LT6U5wzKAk+3qS01B
   aSJ8JhSZJPHeNuBVVrfRtCw2eakFcvW37nS57CjgA0LU/9m7P+wL2cvDj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="395180431"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="395180431"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 23:40:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="883042875"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="883042875"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2023 23:40:15 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 15/16] i386: Use offsets get NumSharingCache for CPUID[0x8000001D].EAX[bits 25:14]
Date: Fri, 17 Nov 2023 15:51:05 +0800
Message-Id: <20231117075106.432499-16-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231117075106.432499-1-zhao1.liu@linux.intel.com>
References: <20231117075106.432499-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Reviewed-by: Babu Moger <babu.moger@amd.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
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
index 86445e833a2d..3ddedd6de120 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -483,7 +483,7 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
                                        uint32_t *eax, uint32_t *ebx,
                                        uint32_t *ecx, uint32_t *edx)
 {
-    uint32_t l3_threads;
+    uint32_t num_sharing_cache;
     assert(cache->size == cache->line_size * cache->associativity *
                           cache->partitions * cache->sets);
 
@@ -492,13 +492,11 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
 
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



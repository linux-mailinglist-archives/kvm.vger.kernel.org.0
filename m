Return-Path: <kvm+bounces-12389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 035F2885AAC
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:28:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 838BA1F228FA
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B088527D;
	Thu, 21 Mar 2024 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P8xaaJ2w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCD685286
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031268; cv=none; b=NqF8fGRjPFbm2aNILjlCEg9Mqsp7wFJ/Hvju6s5+vzMhfHtNYIh4T2Z/77OuWmi7zpdp1ozkxhcAmj8fPZTCiCsTHz7g1Der9Z8EdaLz1TleIMu4T0zOSwgBacEA6f+XmUclSyb3ct5bwvcGQsU49kbtxit94cgjb5hA8kwd3fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031268; c=relaxed/simple;
	bh=ekXJB+6ra/0My548l72VHCs/SHOPsMhRgEkERLGMkFs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kb3WHsXp2qce7J9db7jmDUhI6K8aKlaZQ8NmKgpDiBJoUhzyZyb9bzMWHGeco4BiDk7EN4XP9D75dgrmI32zmbTtJSXP6tHKxfBoS8j1SLpbzrMakk+B+yVsJ1bh2Zba+JSCxXn7KjtAV8xBiUV0bHSz394YE1xMLKJ74AgwB6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P8xaaJ2w; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031267; x=1742567267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ekXJB+6ra/0My548l72VHCs/SHOPsMhRgEkERLGMkFs=;
  b=P8xaaJ2wq/mno3IyP63/oOEyCpYisVOVsZ45IbNdyaTjjo34oHgnN3W5
   69TA+jjQbdU3KIDzRHsEKlA2jLeOrCwZycRR34XEdoR+6WOgzNh3vV0gz
   PpzroSpu2GX8UFtd6br42d59tf8RSANpMA7d2FOvzXjjc7EoKTEv1VLBe
   ZjWoSIO0Wpru3kDb511Ix+B0rKxIIpOdcvWorSEuhyJlWBaqt53OPaNzK
   wP5Qs7rzbGBJia0j9ryVpZXQ+SaNB1Hg+avpL4/KvRX6NAycgsWFYGFbW
   7rKJ/RXGuJz6odKi+3jL4nkq71cJHihtblHLigUPaWCd6sGRdx2iuUzLu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806455"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806455"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14527928"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:27:42 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v10 07/21] i386/cpu: Use APIC ID info get NumSharingCache for CPUID[0x8000001D].EAX[bits 25:14]
Date: Thu, 21 Mar 2024 22:40:34 +0800
Message-Id: <20240321144048.3699388-8-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
References: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
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

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Babu Moger <babu.moger@amd.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes since v7:
 * Moved this patch after CPUID[4]'s similar change ("i386/cpu: Use APIC
   ID offset to encode cache topo in CPUID[4]"). (Xiaoyao)
 * Dropped Michael/Babu's Acked/Reviewed/Tested tags since the code
   change due to the rebase.
 * Re-added Yongwei's Tested tag For his re-testing (compilation on
   Intel platforms).

Changes since v3:
 * Rewrote the subject. (Babu)
 * Deleted the original "comment/help" expression, as this behavior is
   confirmed for AMD CPUs. (Babu)
 * Renamed "num_apic_ids" (v3) to "num_sharing_cache" to match spec
   definition. (Babu)

Changes since v1:
 * Renamed "l3_threads" to "num_apic_ids" in
   encode_cache_cpuid8000001d(). (Yanan)
 * Added the description of the original commit and add Cc.
---
 target/i386/cpu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 0ebacacf2aad..8f559b42f706 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -331,7 +331,7 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
                                        uint32_t *eax, uint32_t *ebx,
                                        uint32_t *ecx, uint32_t *edx)
 {
-    uint32_t l3_threads;
+    uint32_t num_sharing_cache;
     assert(cache->size == cache->line_size * cache->associativity *
                           cache->partitions * cache->sets);
 
@@ -340,11 +340,11 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
 
     /* L3 is shared among multiple cores */
     if (cache->level == 3) {
-        l3_threads = topo_info->cores_per_die * topo_info->threads_per_core;
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



Return-Path: <kvm+bounces-7564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00644843BA8
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:01:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 942831F2C517
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC4E69D08;
	Wed, 31 Jan 2024 10:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cXIL0PNB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC5E69969
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 10:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706695275; cv=none; b=i/lWDCBWKxbRhOvNg5U7EVJLIzfLVdku8mZVLco8zLDlw1HvRMLQgLCyBmlZdBZ4zzU6SWrq+eEru0x1stVjQBTZ8KQ5UWLjimAJdrVL6NpKTDc+MQujG54++9OSJey5VKVBeV8G0i0r0D7Rp+QPSmzCrUV3pwcKPrj29DVoW6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706695275; c=relaxed/simple;
	bh=8pds/AxxNE2hD2VW3e/TwsBBosB13a2SIE4Y7VqGv1c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UeDt79tgVYyfEE4lEpUjzT+BSftiybz9ai/4uWaYadlv+yAACaukqM3+kZxZmK3XL9iroS1hMKmeAqaibglBbdfuIRAV0CNHLc1pE87Bspj7ku7Hp3iHNz/GnJBdn5lXZdohKSYMxazX04kIKBW7jA9coMyZeqt/+XDMIaJSrNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cXIL0PNB; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706695274; x=1738231274;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8pds/AxxNE2hD2VW3e/TwsBBosB13a2SIE4Y7VqGv1c=;
  b=cXIL0PNBn9VDps9s+P8i3Ck0iMLW7y1GzR/PBjNge+dl/b15H0lm5eTj
   3a+1e4Znc2h91tpZFuyJ08dfeRoLgZu4tM7PVq5lWqJnHyh+97PWg7Gq1
   1zikkKClOTwu/D8idQrxzvEBl3/daBaUIK2n83TV/Qm3RhPIYXmX3UZS/
   ZhUxILEcDefXwtCVittMVQsNarzqSAiE3NggctkPHcKl7hegPjp37mPb3
   fJldxLVV1savjzVm7loepmn+4HxyMVBCTXdUWM3CFWcd/iuEAwi0KczOA
   OxTdkDDDLMkDCw/aBb+oVYwstljHIKa5hcCBzaNF5rtKzaCqCPHyYyesv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="25032695"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="25032695"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 02:01:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="4036026"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 31 Jan 2024 02:01:08 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v8 07/21] i386/cpu: Use APIC ID info get NumSharingCache for CPUID[0x8000001D].EAX[bits 25:14]
Date: Wed, 31 Jan 2024 18:13:36 +0800
Message-Id: <20240131101350.109512-8-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
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

Cc: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
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
index 747cfb6cac03..65944645db5c 100644
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



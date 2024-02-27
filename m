Return-Path: <kvm+bounces-10054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 969C5868D3F
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:20:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 354FE1F27705
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4816E1386A7;
	Tue, 27 Feb 2024 10:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NoVTxCAx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1300C138490
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029170; cv=none; b=Ntwj+7Nmb0C/5DClZ0lCbIG2LlVXu/n7C5QWG9zvES2puIphZY2Fk9L1QitZMvrOrvbbwtPq/JTI4rYdrYWb50qXWPXmsfFJlJXLh+SquyTzxx0NTZCEq5wlfBsd1WglQnqHH371oOLSFeKViZbyI4ApqaSlzYVEOdezNBLbFd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029170; c=relaxed/simple;
	bh=wiBtvC9npNwOGQwvG+wKYWaGKFwDNnpYwHcx9hX6vcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f6M16ap5JekchM4elBcZtISaT0ZTLx/IMDf3s0KkBpfU1hU8gTIBtPzxyjz9U36RAPTGtwM1esfDy9DbWjWoZzARcvQ0QKzpkuT4EFPYhNLGurIznEv1WtDKk7QimiV+v7MCeL7NI32CLXCPm0WYrIrMnqyMPSGTGTCoCf9gZCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NoVTxCAx; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709029169; x=1740565169;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wiBtvC9npNwOGQwvG+wKYWaGKFwDNnpYwHcx9hX6vcs=;
  b=NoVTxCAxv+SYvmyH7hoOoFRAd0EgOHv3nFBh7Sq79Wbb+jYPF4ps1tnq
   4fm3L/DqMvZq3fXDNjHIh77oh3shwrIEnIVhmuC7VIfqJS6Ot+lTtDhW2
   4h4gxYRxpsY9/N2KzN00QI/qBKAYj5f6aMO/OI3eaHtG5XFBTJkwGaZoZ
   Qo+Elteo4shMZOAzOm7Qv0pmvi01jgi8HI2JmKPM0hcgKbcIbzHXYUbni
   oYgzeOWKb4zYNMh4MCYUULpHI8SH/tWBgvfv4i4mMjyqpVGAox1UPZgbv
   TSV9ib34knD8ksF4kC4lxFeeZEPXqkAT/3C7fxg+5l8CMW0B4zDWJKNYc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6310280"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6310280"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 02:19:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6954788"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 27 Feb 2024 02:19:24 -0800
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
Subject: [PATCH v9 07/21] i386/cpu: Use APIC ID info get NumSharingCache for CPUID[0x8000001D].EAX[bits 25:14]
Date: Tue, 27 Feb 2024 18:32:17 +0800
Message-Id: <20240227103231.1556302-8-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
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
index c77bcbc44d59..df56c7a449c8 100644
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



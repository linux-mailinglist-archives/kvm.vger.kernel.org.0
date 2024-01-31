Return-Path: <kvm+bounces-7579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8AA5843BC2
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:03:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51A7C1F2CF18
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631C16A028;
	Wed, 31 Jan 2024 10:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GoopgIsx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F626774E
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706695336; cv=none; b=g3SQmZ4PTon5Q7zeGuBrbbFOJV5xgi6wjZ7t45shBxK4SOt/IRaMir4HX/Q4qc2cyO9H94Dfcq35SMSqr9z1xiJBi2eXXLXO29m1j6LZovBQ6/vPpQaNsSwOSrBw4417MTvEl2ZoS5kJbmsuI3TtnHx9b0Rpg0klG/1eCElowlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706695336; c=relaxed/simple;
	bh=fLMMs/SeWi/Vzb8lvrux8mGIdvidsDOqLQrh225b0Qg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r+k6CTALpBtaj0GNSNkX3T/oofHZNdCNHYOqv8+OozGeWD1ZCZd/+qk2x/QIi5KebPYjxydPqDdH57hNq+hG/cBfEQg7/ERnmq1Cn2e6wExemq/NGt7m2MNGMQplg2g9C1+kauzNjN8BQsX3s+G2GkBYc56c14iEm6xViW7tSZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GoopgIsx; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706695335; x=1738231335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fLMMs/SeWi/Vzb8lvrux8mGIdvidsDOqLQrh225b0Qg=;
  b=GoopgIsxuieeoHIaTdxmOmiDhKLqExg/cn+2IoAbpk26UTU7ee/3HjVx
   QVrI0Mh88MgGezxWu7D9K+wIeAI8e4a5t26cfQJ13rl/EzkwrPD3sqOio
   mtComU8k5CW2cVVmlRCbSE/gfwNQmB/xFvQTNvcPyd/VaBqbuLmX5uAuF
   TZOo5Bj9Iq4ARvZqSGGbGyY6lkQXrwz6TOp2gRLK8h2RO2uXXyjn8un8e
   RyBX27S0a5rlnZmbtbvnMeUqYcgXoEOE9PRFcGt9LXpZpZq8ZipBk+3uD
   eGcStwAFUnTFAT7h6Jm34oGp8ikMShKK14P1BVlW2AYmvE871ds54UYUg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="25033125"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="25033125"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 02:02:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="4036401"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 31 Jan 2024 02:02:09 -0800
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
Subject: [PATCH v8 21/21] i386/cpu: Use CPUCacheInfo.share_level to encode CPUID[0x8000001D].EAX[bits 25:14]
Date: Wed, 31 Jan 2024 18:13:50 +0800
Message-Id: <20240131101350.109512-22-zhao1.liu@linux.intel.com>
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

CPUID[0x8000001D].EAX[bits 25:14] NumSharingCache: number of logical
processors sharing cache.

The number of logical processors sharing this cache is
NumSharingCache + 1.

After cache models have topology information, we can use
CPUCacheInfo.share_level to decide which topology level to be encoded
into CPUID[0x8000001D].EAX[bits 25:14].

Cc: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v7:
 * Renamed max_processor_ids_for_cache() to max_thread_ids_for_cache().
 * Dropped Michael/Babu's ACKed/Tested tags since the code change.
 * Re-added Yongwei's Tested tag For his re-testing.

Changes since v3:
 * Explained what "CPUID[0x8000001D].EAX[bits 25:14]" means in the
   commit message. (Babu)

Changes since v1:
 * Used cache->share_level as the parameter in
   max_processor_ids_for_cache().
---
 target/i386/cpu.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index fbfebdc2caf3..763de2b93c28 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -481,20 +481,12 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
                                        uint32_t *eax, uint32_t *ebx,
                                        uint32_t *ecx, uint32_t *edx)
 {
-    uint32_t num_sharing_cache;
     assert(cache->size == cache->line_size * cache->associativity *
                           cache->partitions * cache->sets);
 
     *eax = CACHE_TYPE(cache->type) | CACHE_LEVEL(cache->level) |
                (cache->self_init ? CACHE_SELF_INIT_LEVEL : 0);
-
-    /* L3 is shared among multiple cores */
-    if (cache->level == 3) {
-        num_sharing_cache = 1 << apicid_die_offset(topo_info);
-    } else {
-        num_sharing_cache = 1 << apicid_core_offset(topo_info);
-    }
-    *eax |= (num_sharing_cache - 1) << 14;
+    *eax |= max_thread_ids_for_cache(topo_info, cache->share_level) << 14;
 
     assert(cache->line_size > 0);
     assert(cache->partitions > 0);
-- 
2.34.1



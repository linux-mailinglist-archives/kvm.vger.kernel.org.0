Return-Path: <kvm+bounces-1932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A07747EECD5
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:41:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51B751F2606A
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 07:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9A41FBFF;
	Fri, 17 Nov 2023 07:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EX/JfJpH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C09FD53
	for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 23:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700206823; x=1731742823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ikToKF9wpTdbj9OQGEgX17iOQo/pEcuVay/x5UrQVU0=;
  b=EX/JfJpHVOaVb8wOfHxZsX+YQhSBZgkmCuxVo7OOF1rhT2yjzbPd/oVc
   a7+RctlfvDosmWQ70nFFa3o2JnklnuTYANqz4BJoiC9M2KODKoDR2rElV
   /1piyYJ+R4qjjBlgXMKS8ueh1E7V7vvieC1jCJJZQSeMI0KNOY8uQejUp
   jCfvmSmnWOdE4mwLZ4st+dulNudHZUh9SPQTUMRyVag7Vl7BDOyOVfmaY
   D+Qv4GOXOeYvBpZxpmCIA1mo8BO7U63VqpqvY3o8c4Iow79Uh1rR6KCUF
   eqoyWqEgiaJcR1sCo4T4ROoUlwqGaiKl0HefT0miPhwlMBtQGms4+JEWZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="395180442"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="395180442"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 23:40:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="883042884"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="883042884"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2023 23:40:19 -0800
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
Subject: [PATCH v6 16/16] i386: Use CPUCacheInfo.share_level to encode CPUID[0x8000001D].EAX[bits 25:14]
Date: Fri, 17 Nov 2023 15:51:06 +0800
Message-Id: <20231117075106.432499-17-zhao1.liu@linux.intel.com>
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

CPUID[0x8000001D].EAX[bits 25:14] NumSharingCache: number of logical
processors sharing cache.

The number of logical processors sharing this cache is
NumSharingCache + 1.

After cache models have topology information, we can use
CPUCacheInfo.share_level to decide which topology level to be encoded
into CPUID[0x8000001D].EAX[bits 25:14].

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Babu Moger <babu.moger@amd.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes since v3:
 * Explain what "CPUID[0x8000001D].EAX[bits 25:14]" means in the commit
   message. (Babu)

Changes since v1:
 * Use cache->share_level as the parameter in
   max_processor_ids_for_cache().
---
 target/i386/cpu.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3ddedd6de120..b45d9eb74e67 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -483,20 +483,12 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
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
+    *eax |= max_processor_ids_for_cache(topo_info, cache->share_level) << 14;
 
     assert(cache->line_size > 0);
     assert(cache->partitions > 0);
-- 
2.34.1



Return-Path: <kvm+bounces-12403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C8A0885AD1
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:30:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A14A1F23476
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7271E86AE3;
	Thu, 21 Mar 2024 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gi4L/rCz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F2F85958
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031339; cv=none; b=ij09MSoBg11z4FcrsBX9CgIucfjhHe7l+j2d0N8dpTBXXB6HISENJ/4aRjYrH/k8hlDtPpO6PvEmJ2Y91nPTwhlQo4j0V5kKIdywQRQePDAw9Gs6H+M8vFS3h6S7BjdGRQYN1MXgw2FtARTnG3Wy7ot1ra0JErF0AVJuWjZ0FOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031339; c=relaxed/simple;
	bh=QX1+jVl2S5y7Rl1lURTSN374/eI2/rR8Zew3G5208X0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oN0ZXaStWYR/PpDF1DlWBUS5u4NXXErcd4hD5Mc7jbTADdGriysNZhqD+po/SoVxwHk5LSffDh39rjAT/76DxOw4tA116I1CFyas3xiKN7dyfDtAU2ewdpauamyt9+JZzChcEpdgmZEzkWXj6UFqj7KIAcrskgTr6YmaQPIQvUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gi4L/rCz; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031339; x=1742567339;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QX1+jVl2S5y7Rl1lURTSN374/eI2/rR8Zew3G5208X0=;
  b=Gi4L/rCzgYSGa2C6tY7ay81M/+NxuY/wApMgkhp2RST9+unnqzSRKDi8
   U8Xuybtqh3wv5rECNzBc+1owBIyaZOjSLRH7rXS4dLEhSjgakiJSwbtMG
   kQikNRZUY3FaF1H88TwOMnA+WznrX+SLEdslpBHjFMENhh0zNZkcaK72f
   57vyYUvFKalFZi+T8/+5vlweLzdDyI6tx2d5AFLGmkIOFRk86q6DICB71
   U3Akww3Z+68JH4pEmEZdWjPXQ78Oe1xcXBKesequSXkb2oZAAmUxJGtHg
   Cp+Xjqacf1M5HTu4s4MXHk2Q+pkLGNniUaoenJDtx1s7bRMfVz5soZhv1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806690"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806690"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:28:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14528484"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:28:53 -0700
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
Subject: [PATCH v10 21/21] i386/cpu: Use CPUCacheInfo.share_level to encode CPUID[0x8000001D].EAX[bits 25:14]
Date: Thu, 21 Mar 2024 22:40:48 +0800
Message-Id: <20240321144048.3699388-22-zhao1.liu@linux.intel.com>
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

CPUID[0x8000001D].EAX[bits 25:14] NumSharingCache: number of logical
processors sharing cache.

The number of logical processors sharing this cache is
NumSharingCache + 1.

After cache models have topology information, we can use
CPUCacheInfo.share_level to decide which topology level to be encoded
into CPUID[0x8000001D].EAX[bits 25:14].

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Babu Moger <babu.moger@amd.com>
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
index 831957e4a06f..b7a91c80a271 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -478,20 +478,12 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
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



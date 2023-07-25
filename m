Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6AC76261B
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjGYWTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjGYWR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:17:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16641FEC;
        Tue, 25 Jul 2023 15:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323369; x=1721859369;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OIrsaq2bp9o27ZsGmX41LNMKR7WNeny0bQMTCvxkndI=;
  b=gXBZmvjenWwuH0+/LXc2VRWS9o1uUSHoQ7hZ0euR20wzddZXyZcqI8vx
   2UfFRyzwOvHXAnlCdlh1TeW25Id2w7Js/kp/YrgZrcs7GsZmX4fJx538f
   Zd267X9e/r49rvqwdBuxwk1z+mNWR4p0I0k4PKX/5xdZkwfwShISqS2eX
   htveO2CCn/pEuWIIeZvYxpZAJ1xbgqKheWePiusrQOlUGAg6AB9Rn3bdg
   CXYDI4NXiZT9wO+C9t49qaL6z3hfgyRbBcstCeigK5kcPFke7kJDSmqAh
   +OjUd2ZWNTVF6QIN02P32G2xyLdE6JHPF7L3f0ftBab1qDL9VO2mRfrc+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863207"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863207"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938882"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938882"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:32 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 031/115] KVM: Allow page-sized MMU caches to be initialized with custom 64-bit values
Date:   Tue, 25 Jul 2023 15:13:42 -0700
Message-Id: <98d098febd95c11ea5e27cb651a634926eb38f31.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add support to MMU caches for initializing a page with a custom 64-bit
value, e.g. to pre-fill an entire page table with non-zero PTE values.
The functionality will be used by x86 to support Intel's TDX, which needs
to set bit 63 in all non-present PTEs in order to prevent !PRESENT page
faults from getting reflected into the guest (Intel's EPT Violation #VE
architecture made the less than brilliant decision of having the per-PTE
behavior be opt-out instead of opt-in).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_types.h |  1 +
 virt/kvm/kvm_main.c       | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 6f4737d5046a..4932bc90a0a0 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -93,6 +93,7 @@ struct gfn_to_pfn_cache {
 struct kvm_mmu_memory_cache {
 	gfp_t gfp_zero;
 	gfp_t gfp_custom;
+	u64 init_value;
 	struct kmem_cache *kmem_cache;
 	int capacity;
 	int nobjs;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 60ed0f613bce..14b1fa9fe644 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -378,12 +378,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
 static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 					       gfp_t gfp_flags)
 {
+	void *page;
+
 	gfp_flags |= mc->gfp_zero;
 
 	if (mc->kmem_cache)
 		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
-	else
-		return (void *)__get_free_page(gfp_flags);
+
+	page = (void *)__get_free_page(gfp_flags);
+	if (page && mc->init_value)
+		memset64(page, mc->init_value, PAGE_SIZE / sizeof(mc->init_value));
+	return page;
 }
 
 int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
@@ -398,6 +403,13 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
 		if (WARN_ON_ONCE(!capacity))
 			return -EIO;
 
+		/*
+		 * Custom init values can be used only for page allocations,
+		 * and obviously conflict with __GFP_ZERO.
+		 */
+		if (WARN_ON_ONCE(mc->init_value && (mc->kmem_cache || mc->gfp_zero)))
+			return -EIO;
+
 		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
 		if (!mc->objects)
 			return -ENOMEM;
-- 
2.25.1


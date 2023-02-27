Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9BA6A3C87
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjB0IZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjB0IYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:50 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E000D1C303;
        Mon, 27 Feb 2023 00:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486254; x=1709022254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VCu6jpU86EpIGkSblys4cK9cOLbJ9NW8iFkKQFkQpM8=;
  b=jWA301taI8CSjvpcBBX/CfAsMLJGYVhNI9gU/28WH0YwkKcLDiE8+OoW
   jbjqRyTlGTlLnRkz7zpVhWRUpPeESoLvfjzqYCEThHt5ZZd9lqpQ80IRG
   4hi/MBHosrFmqfUBqvW4701+0DM07sMlMjQXMsSmnxd+oocuqxGMhQhBV
   6miq0G/AYb6odJTtTY9vNMsGNWIfrHFLgdAJFGIvPFkBdTzrO472bm3Ll
   El0v0t61dmFAeSmjsnAFS7S7PL3ugLEEkVyTrM3YIqyjDDLccEp+ZVxh9
   0acsIVUIMzGgDS/Dnw5xDvFyOor2VCmSwg6Tc+wb3xot9yjjCXc5AA31w
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608759"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608759"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242129"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242129"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:05 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 024/106] KVM: Allow page-sized MMU caches to be initialized with custom 64-bit values
Date:   Mon, 27 Feb 2023 00:22:23 -0800
Message-Id: <de154ee8d96bd337d0c9ae82d2ababad059decb4.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
---
 include/linux/kvm_types.h |  1 +
 virt/kvm/kvm_main.c       | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 2728d49bbdf6..7c2b9332b7c5 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -94,6 +94,7 @@ struct kvm_mmu_memory_cache {
 	int nobjs;
 	gfp_t gfp_zero;
 	gfp_t gfp_custom;
+	u64 init_value;
 	struct kmem_cache *kmem_cache;
 	int capacity;
 	void **objects;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f8495e27d210..87400796df6e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -381,12 +381,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
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
@@ -401,6 +406,13 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A517E777476
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbjHJJ3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjHJJ3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:29:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CD42127;
        Thu, 10 Aug 2023 02:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691659752; x=1723195752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=c5lM4VELT+1iO33iaR4/GLXpKT7hVcv5kR8JEqEqxJc=;
  b=JENsK3pNIUS/VInK1pnaWGKTn3D7IZ8+iDwHb+vjQ7We6koIqbkePSbK
   4Wz73aU7J8F01+lbmr2CRXIP/6A/fa81WXWZjchEXkStouLk+vQ5EF3RV
   e2oXVsYUM0C5MLMlASUeIaJEZOaKz3YeHDQ0jCnzBWbo+h8FjpJHPrtQP
   5aW+KEfQzTNMb2aCvlI7PA3+s7nL7YTXoIJe49a9XHRLSM+G33XaKE5Dk
   GBws5o79nobVhiB9qxVoqd436x3eGtk1qroKFdcvy0AdP3ze4Jl1z1X5S
   W+AxxWLWA3RdveEyuGqKt9bbwmiHX68bw8nEdib0N7Ans3K3R2C41s7et
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="368806344"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="368806344"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:29:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="822172765"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="822172765"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:29:09 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com, david@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed protected for NUMA migration
Date:   Thu, 10 Aug 2023 17:02:18 +0800
Message-Id: <20230810090218.26244-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230810085636.25914-1-yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Register to .numa_protect() callback in mmu notifier so that KVM can get
acurate information about when a page is PROT_NONE protected in primary
MMU and unmap it in secondary MMU accordingly.

In KVM's .invalidate_range_start() handler, if the event is to notify that
the range may be protected to PROT_NONE for NUMA migration purpose,
don't do the unmapping in secondary MMU. Hold on until.numa_protect()
comes.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 virt/kvm/kvm_main.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dfbaafbe3a00..907444a1761b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -711,6 +711,20 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_change_spte_gfn);
 }
 
+static void kvm_mmu_notifier_numa_protect(struct mmu_notifier *mn,
+					  struct mm_struct *mm,
+					  unsigned long start,
+					  unsigned long end)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+
+	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
+	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
+		return;
+
+	kvm_handle_hva_range(mn, start, end, __pte(0), kvm_unmap_gfn_range);
+}
+
 void kvm_mmu_invalidate_begin(struct kvm *kvm, unsigned long start,
 			      unsigned long end)
 {
@@ -744,14 +758,18 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	bool is_numa = (range->event == MMU_NOTIFY_PROTECTION_VMA) &&
+		       (range->flags & MMU_NOTIFIER_RANGE_NUMA);
 	const struct kvm_hva_range hva_range = {
 		.start		= range->start,
 		.end		= range->end,
 		.pte		= __pte(0),
-		.handler	= kvm_unmap_gfn_range,
+		.handler	= !is_numa ? kvm_unmap_gfn_range :
+				  (void *)kvm_null_fn,
 		.on_lock	= kvm_mmu_invalidate_begin,
-		.on_unlock	= kvm_arch_guest_memory_reclaimed,
-		.flush_on_ret	= true,
+		.on_unlock	= !is_numa ? kvm_arch_guest_memory_reclaimed :
+				  (void *)kvm_null_fn,
+		.flush_on_ret	= !is_numa ? true : false,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
 
@@ -899,6 +917,7 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 	.clear_young		= kvm_mmu_notifier_clear_young,
 	.test_young		= kvm_mmu_notifier_test_young,
 	.change_pte		= kvm_mmu_notifier_change_pte,
+	.numa_protect		= kvm_mmu_notifier_numa_protect,
 	.release		= kvm_mmu_notifier_release,
 };
 
-- 
2.17.1


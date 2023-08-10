Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C426477746B
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbjHJJ1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjHJJ1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:27:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA31212E;
        Thu, 10 Aug 2023 02:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691659632; x=1723195632;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=C6zjOhS5sp3kUlz9iodlvnz6Wf6HLOevZBJUafi9FrU=;
  b=HDR9VMofSFRD8viOz3W4WAyjJs4b1/9MyWeUDclbT/G5B/QEi5vrfZr4
   hAF01Jr+84MKZu7ga+gkkJlHm9IJVrD/Ngfd8ZhMyEPEOwkNHtYyv2K95
   1hOHKgRnUeJuGnF0FS1j8T4txnbdJz4wB+tyutyTFpyu+NA2lJHecb5Rf
   ytA4cFAnE4F/VLy7Ld1E5uzUQ6JHyRI79uW0JE9iFn0++8HNOy0E2Yqv0
   LoOn0bxxPCqOIyx24XPzw4MMwBOlAJqkgwPa1BWSA1w7H1OK7WCtYRjSX
   zzRAuTqAn2dtcCHLbC6qL+ryJx9yIjFveVHjnCC8XgR4wavvngmDB4LD9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="375066896"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="375066896"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:27:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="905983293"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="905983293"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:27:08 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com, david@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 3/5] mm/mmu_notifier: introduce a new callback .numa_protect
Date:   Thu, 10 Aug 2023 17:00:08 +0800
Message-Id: <20230810090008.26122-1-yan.y.zhao@intel.com>
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

This .numa_protect callback is called when PROT_NONE is set for sure on a
PTE or a huge PMD for numa migration purpose.

With this callback, subscriber of mmu notifier, (e.g. KVM), can unmap NUMA
migration protected pages only in the handler, rather than unmap a wider
range containing pages that are obvious none-NUMA-migratble.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/mmu_notifier.h | 15 +++++++++++++++
 mm/mmu_notifier.c            | 18 ++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index a6dc829a4bce..a173db83b071 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -132,6 +132,10 @@ struct mmu_notifier_ops {
 			   unsigned long address,
 			   pte_t pte);
 
+	void (*numa_protect)(struct mmu_notifier *subscription,
+			     struct mm_struct *mm,
+			     unsigned long start,
+			     unsigned long end);
 	/*
 	 * invalidate_range_start() and invalidate_range_end() must be
 	 * paired and are called only when the mmap_lock and/or the
@@ -395,6 +399,9 @@ extern int __mmu_notifier_test_young(struct mm_struct *mm,
 				     unsigned long address);
 extern void __mmu_notifier_change_pte(struct mm_struct *mm,
 				      unsigned long address, pte_t pte);
+extern void __mmu_notifier_numa_protect(struct mm_struct *mm,
+					unsigned long start,
+					unsigned long end);
 extern int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *r);
 extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r,
 				  bool only_end);
@@ -448,6 +455,14 @@ static inline void mmu_notifier_change_pte(struct mm_struct *mm,
 		__mmu_notifier_change_pte(mm, address, pte);
 }
 
+static inline void mmu_notifier_numa_protect(struct mm_struct *mm,
+					     unsigned long start,
+					     unsigned long end)
+{
+	if (mm_has_notifiers(mm))
+		__mmu_notifier_numa_protect(mm, start, end);
+}
+
 static inline void
 mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 {
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 50c0dde1354f..fc96fbd46e1d 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -382,6 +382,24 @@ int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 	return young;
 }
 
+void __mmu_notifier_numa_protect(struct mm_struct *mm,
+				 unsigned long start,
+				 unsigned long end)
+{
+	struct mmu_notifier *subscription;
+	int id;
+
+	id = srcu_read_lock(&srcu);
+	hlist_for_each_entry_rcu(subscription,
+				 &mm->notifier_subscriptions->list, hlist,
+				 srcu_read_lock_held(&srcu)) {
+		if (subscription->ops->numa_protect)
+			subscription->ops->numa_protect(subscription, mm, start,
+							end);
+	}
+	srcu_read_unlock(&srcu, id);
+}
+
 int __mmu_notifier_clear_young(struct mm_struct *mm,
 			       unsigned long start,
 			       unsigned long end)
-- 
2.17.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D88F625771
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 10:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiKKJ5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 04:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbiKKJ5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 04:57:48 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D8168AD8;
        Fri, 11 Nov 2022 01:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668160667; x=1699696667;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=wt+vlOzCkH8SLs01r95Dnw3PuDC+sxswMNY5/OeykXY=;
  b=FRkzOhSH+0vQyTfGXoeSGe4tdYVL9o6MT8JQztsLh5sdm3Nb5DvYPtC/
   5+OTOwsRTcZeMo4VcHIGsNDyLEQWNKr4F1cfWOiNoogYbIn9nvjGP/6Nd
   HiKPHSgzk/+G+GmoeXr3ksoDj+AYDZiYwqgzBxPwkn3smKPxFD6CM2pxg
   PRTZuJrLcX2mFR+TDIQn2rLDVAfT++bbIhzCxgABBwBCx+PMfb2RVX/Uh
   Fsys345+njn4tLnPAxo0Kn1rguJIYNeZQsOnEGcANeid6/CfhzyeIBG59
   mObDlgOX5hJmti+UZc7PqgEBsjAF7I7B2jkKPigB7Me66eIZit/bfidYn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="373700227"
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="373700227"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 01:57:47 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="706496838"
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="706496838"
Received: from yzhao56-desk.sh.intel.com ([10.238.200.254])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 01:57:44 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, zhenyuw@linux.intel.com,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 1/3] KVM: x86: add a new page track hook track_remove_slot
Date:   Fri, 11 Nov 2022 17:34:45 +0800
Message-Id: <20221111093445.3212-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221111093222.3148-1-yan.y.zhao@intel.com>
References: <20221111093222.3148-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Page track hook track_remove_slot is used to notify users that a slot
has been removed and is called when a slot DELETE/MOVE is about to be
completed.

Users of this hook can drop write protections in the removed slot.

Note:
Since KVM_MR_MOVE currently never actually happens in KVM/QEMU, and has
never been properly supported in the external page track user, we just
use the hook track_remove_slot to notify users of the old slot being
removed.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_page_track.h | 11 +++++++++++
 arch/x86/kvm/mmu/page_track.c         | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                    |  3 +++
 3 files changed, 40 insertions(+)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index eb186bc57f6a..046b024d1813 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -44,6 +44,16 @@ struct kvm_page_track_notifier_node {
 	 */
 	void (*track_flush_slot)(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    struct kvm_page_track_notifier_node *node);
+	/*
+	 * It is called when memory slot is moved or removed
+	 * users can drop write-protection for the pages in that memory slot
+	 *
+	 * @kvm: the kvm where memory slot being moved or removed
+	 * @slot: the memory slot being moved or removed
+	 * @node: this node
+	 */
+	void (*track_remove_slot)(struct kvm *kvm, struct kvm_memory_slot *slot,
+				  struct kvm_page_track_notifier_node *node);
 };
 
 int kvm_page_track_init(struct kvm *kvm);
@@ -76,4 +86,5 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
 void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 			  int bytes);
 void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_page_track_remove_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
 #endif
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 2e09d1b6249f..4d6bab1d61c9 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -300,3 +300,29 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 			n->track_flush_slot(kvm, slot, n);
 	srcu_read_unlock(&head->track_srcu, idx);
 }
+
+/*
+ * Notify the node that memory slot is removed or moved so that it can
+ * drop write-protection for the pages in the memory slot.
+ *
+ * The node should figure out it has any write-protected pages in this slot
+ * by itself.
+ */
+void kvm_page_track_remove_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	struct kvm_page_track_notifier_head *head;
+	struct kvm_page_track_notifier_node *n;
+	int idx;
+
+	head = &kvm->arch.track_notifier_head;
+
+	if (hlist_empty(&head->track_notifier_list))
+		return;
+
+	idx = srcu_read_lock(&head->track_srcu);
+	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
+				srcu_read_lock_held(&head->track_srcu))
+		if (n->track_remove_slot)
+			n->track_remove_slot(kvm, slot, n);
+	srcu_read_unlock(&head->track_srcu, idx);
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 916ebbc81e52..a24a4a2ad1a0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12844,6 +12844,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+		kvm_page_track_remove_slot(kvm, old);
+
 	if (!kvm->arch.n_requested_mmu_pages &&
 	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
 		unsigned long nr_mmu_pages;
-- 
2.17.1


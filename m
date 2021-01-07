Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A020D2EC747
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 01:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbhAGAUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 19:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbhAGAUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 19:20:20 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18936C06136F
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 16:19:40 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id x74so4220169qkb.12
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 16:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=YAdMZ4HVtsNign4zck7MQfm5DpVic4jEJ5rVA3Cqe+I=;
        b=CmXcwBZJAfbCWX7/Zs58wTI0vo1u9HDZQ8ZtZrSWLI7giiVKMzDztOCJ1dHXIj55Fc
         n8Gl/FFNXiXEEu9Tzg0E+HT8Qq7gUkAMlXk1OGuk9O1PPJztSyvlugWSSvgIUxbBUHRd
         tL7cmhDmvGt0ml3bb1/X+YsX+ueWHrIpme0j58W3TvIP3RPrvByjwwFKxh6VcfmXwwC4
         ZyV4YjmpOe5Hs8hjbp3PsvDIoOwzq55Cd1iwEfB4ME3JT0jaeUfHgRThKaTuxU3gOrUo
         qrk9QlRixlww+fQG0Ki0gUnrkqpnfd/J+Wm3dW75EbaODtGhlpdonuKszaVO5zg/r9sJ
         x0cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=YAdMZ4HVtsNign4zck7MQfm5DpVic4jEJ5rVA3Cqe+I=;
        b=Kkb8VYKbIJeECk6xbyzBs8FiQpyOzbFXoaKGE5dSHukQ68cm02DRUDTO9K4zZ/ts4y
         rhHpqAwE0YIda27+/2goT2e07+twrg9ZlmSRWhl2eumW+vMQTNTtwNfNix77GCKQjMxu
         QC0U3mOTjklslrwnWVNukaFAzOZJa4VE1QduhBnU9MVVxo25ftD1914KP6LtpN97rOO9
         LGU2UVXNvcGfehwPz58kIfov6mBXnF+0XQRj+vgSg0nA5S/H4zB/sRJRP4vMXM/Lg3eB
         +sP3MerJImW0p7bGcw76RD6PrgUg4zTvg7c/12vvytmpfkEUO+9FdRNEG/XLDPKzA9q9
         gWRg==
X-Gm-Message-State: AOAM530fMgBpb7eDYOT1ad4Bj0Fv83LmmyWuiF1QWCsRQEonFzkTTpxJ
        WquYYNs/DsQMJAqduUm57BxU2SI7/l/G
X-Google-Smtp-Source: ABdhPJxEkku8a+6wi9WjxvTTJwJ5v53TvGkOS97Cgu2NLffiOTWVa/Iz+FrJoh+ZwOXUOP4D9fjRXln5nBYo
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a0c:e651:: with SMTP id
 c17mr6479465qvn.34.1609978779192; Wed, 06 Jan 2021 16:19:39 -0800 (PST)
Date:   Wed,  6 Jan 2021 16:19:34 -0800
Message-Id: <20210107001935.3732070-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v3 1/2] KVM: x86/mmu: Ensure TDP MMU roots are freed after yield
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Leo Hou <leohou1402@gmail.com>, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Many TDP MMU functions which need to perform some action on all TDP MMU
roots hold a reference on that root so that they can safely drop the MMU
lock in order to yield to other threads. However, when releasing the
reference on the root, there is a bug: the root will not be freed even
if its reference count (root_count) is reduced to 0.

To simplify acquiring and releasing references on TDP MMU root pages, and
to ensure that these roots are properly freed, move the get/put operations
into another TDP MMU root iterator macro.

Moving the get/put operations into an iterator macro also helps
simplify control flow when a root does need to be freed. Note that using
the list_for_each_entry_safe macro would not have been appropriate in
this situation because it could keep a pointer to the next root across
an MMU lock release + reacquire, during which time that root could be
freed.

Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
Fixes: 063afacd8730 ("kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU")
Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 104 +++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 75db27fda8f3..d4191ed193cd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -44,7 +44,48 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 }
 
-#define for_each_tdp_mmu_root(_kvm, _root)			    \
+static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+	if (kvm_mmu_put_root(kvm, root))
+		kvm_tdp_mmu_free_root(kvm, root);
+}
+
+static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
+					   struct kvm_mmu_page *root)
+{
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
+		return false;
+
+	kvm_mmu_get_root(kvm, root);
+	return true;
+
+}
+
+static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
+						     struct kvm_mmu_page *root)
+{
+	struct kvm_mmu_page *next_root;
+
+	next_root = list_next_entry(root, link);
+	tdp_mmu_put_root(kvm, root);
+	return next_root;
+}
+
+/*
+ * Note: this iterator gets and puts references to the roots it iterates over.
+ * This makes it safe to release the MMU lock and yield within the loop, but
+ * if exiting the loop early, the caller must drop the reference to the most
+ * recent root. (Unless keeping a live reference is desirable.)
+ */
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)				\
+	for (_root = list_first_entry(&_kvm->arch.tdp_mmu_roots,	\
+				      typeof(*_root), link);		\
+	     tdp_mmu_next_root_valid(_kvm, _root);			\
+	     _root = tdp_mmu_next_root(_kvm, _root))
+
+#define for_each_tdp_mmu_root(_kvm, _root)				\
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
 
 bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
@@ -447,18 +488,9 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 	struct kvm_mmu_page *root;
 	bool flush = false;
 
-	for_each_tdp_mmu_root(kvm, root) {
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
+	for_each_tdp_mmu_root_yield_safe(kvm, root)
 		flush |= zap_gfn_range(kvm, root, start, end, true);
 
-		kvm_mmu_put_root(kvm, root);
-	}
-
 	return flush;
 }
 
@@ -619,13 +651,7 @@ static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
 	int ret = 0;
 	int as_id;
 
-	for_each_tdp_mmu_root(kvm, root) {
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		as_id = kvm_mmu_page_as_id(root);
 		slots = __kvm_memslots(kvm, as_id);
 		kvm_for_each_memslot(memslot, slots) {
@@ -647,8 +673,6 @@ static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
 			ret |= handler(kvm, memslot, root, gfn_start,
 				       gfn_end, data);
 		}
-
-		kvm_mmu_put_root(kvm, root);
 	}
 
 	return ret;
@@ -838,21 +862,13 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
-
-		kvm_mmu_put_root(kvm, root);
 	}
 
 	return spte_set;
@@ -906,21 +922,13 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
-
-		kvm_mmu_put_root(kvm, root);
 	}
 
 	return spte_set;
@@ -1029,21 +1037,13 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		spte_set |= set_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
-
-		kvm_mmu_put_root(kvm, root);
 	}
 	return spte_set;
 }
@@ -1089,21 +1089,13 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 	int root_as_id;
 
-	for_each_tdp_mmu_root(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		zap_collapsible_spte_range(kvm, root, slot->base_gfn,
 					   slot->base_gfn + slot->npages);
-
-		kvm_mmu_put_root(kvm, root);
 	}
 }
 
-- 
2.29.2.729.g45daf8777d-goog


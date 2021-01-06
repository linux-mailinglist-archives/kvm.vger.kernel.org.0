Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228302EC39A
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 20:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbhAFTAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 14:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbhAFTAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 14:00:35 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98C9C061575
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 10:59:55 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 26so2594672pgl.2
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 10:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=VJVLSLdtxSjf51v52sLnCTCAPMVR3FicOzzHbZ1zDdk=;
        b=ZKYZc57KqCVwsRiFhOTTFLdKMqgTg5ofcjrSGRQ7puNhLXoQZpZg71cq/Ep5JpXzg9
         Mwpy3zp4bvNPoFoTfP8ExyqKtwCG3kn/DrZy6MTd7TQ3QZlmaqYhHxbal1WkVHE02bWw
         ROSDeUCD4XZX/oGYdQMM0aEcKfFog6yT5qQ8V4/P8W4SY1rnYSw2bN/4dKQgGlVu+OQ3
         SOxj7YLCPI5VarLLPN7D0Myvy6UgRUFAgpLSmO1mOTV8pLdoVkjZzPVLf4NTkfvfNMgB
         Cvf4ctTcL6+h/bFShidIfdDZ5o2/KGG8SZAhB+uUc1CUhWR4J1rf8otMP2nRxzz69rHJ
         hK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=VJVLSLdtxSjf51v52sLnCTCAPMVR3FicOzzHbZ1zDdk=;
        b=N07iK2fTtVmaj3q8++nE1ld317jyQQRbznstMav7KJFVUu+jTKLRslPLJ/4npphxe0
         TWiBtOfAweQ9XdUeKn5QinXN0U10ZqERCS7Z25nxIIkeSA4K7T1hDJhQf0wyJp69WNU2
         V2HkPl809Nm7DTPy/iXUncecta3NIhMOlHDLyoGB2i4vdHbxwnJc2x4xxFt9Tp607wgh
         LiW9YGI30ZkWTbndd5ZTmvlwWsgn8AqUtVqROSu2UYxHgTEPBUAwsgQuyB+QbdsRAvQq
         qSJzt/N7Bm20L9+NzDnySnSh/FtFqBJNjHKvfGtW7szJWugN1IPj5t/RZgYLlSKjYQYA
         So5g==
X-Gm-Message-State: AOAM532/bIxeXTaZLpoakrnvMbHXhX5yB6ZMEWkdFlOjLjxg5DNljVSu
        fVJQVCuz+cH9arxSg14GlqNqPL9Glhjo
X-Google-Smtp-Source: ABdhPJwbL9wte8oWAvJxfPktFTF95fs7X3SzrOa7dpHTxm2hGggMhjiaWmc70D9nzkQo9SR/+yCz4VxME/CR
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:8c7:b029:19d:afa5:34e5 with SMTP
 id s7-20020a056a0008c7b029019dafa534e5mr5524385pfu.30.1609959595127; Wed, 06
 Jan 2021 10:59:55 -0800 (PST)
Date:   Wed,  6 Jan 2021 10:59:50 -0800
Message-Id: <20210106185951.2966575-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v2 1/2] KVM: x86/mmu: Ensure TDP MMU roots are freed after yield
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
into the TDP MMU root iterator macro. Not all functions which use the macro
currently get and put a reference to the root, but adding this behavior is
harmless.

Moving the get/put operations into the iterator macro also helps
simplify control flow when a root does need to be freed. Note that using
the list_for_each_entry_unsafe macro would not have been appropriate in
this situation because it could keep a reference to the next root across
an MMU lock release + reacquire.

Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
Fixes: 063afacd8730 ("kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU")
Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 97 +++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 75db27fda8f3..6e076b66973c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -44,8 +44,44 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 }
 
-#define for_each_tdp_mmu_root(_kvm, _root)			    \
-	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
+static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+	if (kvm_mmu_put_root(kvm, root))
+		kvm_tdp_mmu_free_root(kvm, root);
+}
+
+static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
+					   struct kvm_mmu_page *root)
+{
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
+#define for_each_tdp_mmu_root(_kvm, _root)				\
+	for (_root = list_first_entry(&_kvm->arch.tdp_mmu_roots,	\
+				      typeof(*_root), link);		\
+	     tdp_mmu_next_root_valid(_kvm, _root);			\
+	     _root = tdp_mmu_next_root(_kvm, _root))
 
 bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 {
@@ -128,7 +164,11 @@ static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root) {
 		if (root->role.word == role.word) {
-			kvm_mmu_get_root(kvm, root);
+			/*
+			 * The iterator already acquired a reference to this
+			 * root, so simply return early without dropping the
+			 * reference.
+			 */
 			spin_unlock(&kvm->mmu_lock);
 			return root;
 		}
@@ -447,18 +487,9 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 	struct kvm_mmu_page *root;
 	bool flush = false;
 
-	for_each_tdp_mmu_root(kvm, root) {
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
+	for_each_tdp_mmu_root(kvm, root)
 		flush |= zap_gfn_range(kvm, root, start, end, true);
 
-		kvm_mmu_put_root(kvm, root);
-	}
-
 	return flush;
 }
 
@@ -620,12 +651,6 @@ static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
 	int as_id;
 
 	for_each_tdp_mmu_root(kvm, root) {
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		as_id = kvm_mmu_page_as_id(root);
 		slots = __kvm_memslots(kvm, as_id);
 		kvm_for_each_memslot(memslot, slots) {
@@ -647,8 +672,6 @@ static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
 			ret |= handler(kvm, memslot, root, gfn_start,
 				       gfn_end, data);
 		}
-
-		kvm_mmu_put_root(kvm, root);
 	}
 
 	return ret;
@@ -843,16 +866,8 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
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
@@ -911,16 +926,8 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
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
@@ -1034,16 +1041,8 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
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
@@ -1094,16 +1093,8 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
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


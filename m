Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF83457B6B
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237151AbhKTEy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236970AbhKTEyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:45 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E72C06139E
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:18 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id o11-20020a635a0b000000b00320daef2ad6so347296pgb.3
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bAu1NycI5VaYh61AlVlXAbtArBwZr4zvKNol64JqFfE=;
        b=Qv3E34TExcZch80wECkftwff7GeKKXoAiJhX+c/OxSrGohs6Y8I+GLyrIomKbQ3a8b
         qGv0ANBCwcxWXGKyPV1AAwzNXTQAMt3Yj/M/8V7aSubQjhrgYo8Knz/jnvuwchAXg3X1
         mTYGL0/GxR1V8KkhO7e9g1aHEgl7SospAVDzrJlPpmHelibPMZduKiy7wv7Fh8ClgqnT
         lSner/tFXmmlnpEJNhep40qNxOaI4BVzAorxZKROht10fUUc85Y0pRt1hB3AxSYNa41k
         dAsP6/v/zI6FV5MQyYrt24pKFFWC6xZP1uPom05EG1l4C7lybRFyjTlUvukmTqBvJgUH
         +rZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bAu1NycI5VaYh61AlVlXAbtArBwZr4zvKNol64JqFfE=;
        b=UIEjxvKj/hrEJhJZpvnuVcTB7Yd97ejJJPeE2PliWSuZAvTWqYovFs7u/NRPixQnbC
         zQQgQiwL7o7x5yZh2xA6yMHoGD1C2Q6DYYZOpp7JcauIUK2WRGFX+W/pEOryvr61v6Ha
         0mid9oPSAJTQm/TXX6/RBL0pOmLwsR9EsBpuQKRmxG8lGFwYf+J1e1dp3JOmnsIopdJY
         U4LOIBNANYKKMK9oeCkFTPshV16AN4fPcwxrLAN4OFb9pqIPvaKCepWZZB+r//aDWG57
         0lqobJ9WnztnFIRHxehIfhzI/HvBWcNMr+WjcRqvt8dXfSqY1Xau+nfL+nUGLSA4aMz2
         kREA==
X-Gm-Message-State: AOAM530MjPvKwon40PIDJSyePwlwzXdx3H1e6m6G02rSFNr3fAHttBCw
        ZNzR02CUABeF3V/s3JcZZAexLDGqJrU=
X-Google-Smtp-Source: ABdhPJwU0ov8qxdOaAvGe+b10jWNKLido2H1ZRZpxFJL3YDl/Ep3opNAlN9+C3/5jYt/AE8yQ18yMTE2vME=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:390c:: with SMTP id
 y12mr737608pjb.0.1637383877517; Fri, 19 Nov 2021 20:51:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:33 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-16-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 15/28] KVM: x86/mmu: Take TDP MMU roots off list when
 invalidating all roots
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take TDP MMU roots off the list of roots when they're invalidated instead
of walking later on to find the roots that were just invalidated.  In
addition to making the flow more straightforward, this allows warning
if something attempts to elevate the refcount of an invalid root, which
should be unreachable (no longer on the list so can't be reached by MMU
notifier, and vCPUs must reload a new root before installing new SPTE).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 171 ++++++++++++++++++++-----------------
 arch/x86/kvm/mmu/tdp_mmu.h |  14 ++-
 3 files changed, 108 insertions(+), 83 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e00e46205730..e3cd330c9532 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5664,6 +5664,8 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
  */
 static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 {
+	LIST_HEAD(invalidated_roots);
+
 	lockdep_assert_held(&kvm->slots_lock);
 
 	write_lock(&kvm->mmu_lock);
@@ -5685,7 +5687,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * could drop the MMU lock and yield.
 	 */
 	if (is_tdp_mmu_enabled(kvm))
-		kvm_tdp_mmu_invalidate_all_roots(kvm);
+		kvm_tdp_mmu_invalidate_all_roots(kvm, &invalidated_roots);
 
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
@@ -5703,7 +5705,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		kvm_tdp_mmu_zap_invalidated_roots(kvm);
+		kvm_tdp_mmu_zap_invalidated_roots(kvm, &invalidated_roots);
 		read_unlock(&kvm->mmu_lock);
 	}
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ca6b30a7130d..085f6b09e5f3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -94,9 +94,17 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	WARN_ON(!root->tdp_mmu_page);
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_del_rcu(&root->link);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	/*
+	 * Remove the root from tdp_mmu_roots, unless the root is invalid in
+	 * which case the root was pulled off tdp_mmu_roots when it was
+	 * invalidated.  Note, this must be an RCU-protected deletion to avoid
+	 * use-after-free in the yield-safe iterator!
+	 */
+	if (!root->role.invalid) {
+		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+		list_del_rcu(&root->link);
+		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	}
 
 	/*
 	 * A TLB flush is not necessary as KVM performs a local TLB flush when
@@ -105,18 +113,23 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
 	 * intermediate paging structures, that may be zapped, as such entries
 	 * are associated with the ASID on both VMX and SVM.
+	 *
+	 * WARN if a flush is reported for an invalid root, as its child SPTEs
+	 * should have been zapped by kvm_tdp_mmu_zap_invalidated_roots(), and
+	 * inserting new SPTEs under an invalid root is a KVM bug.
 	 */
-	(void)zap_gfn_range(kvm, root, 0, -1ull, true, false, shared);
+	if (zap_gfn_range(kvm, root, 0, -1ull, true, false, shared))
+		WARN_ON_ONCE(root->role.invalid);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
 /*
- * Finds the next valid root after root (or the first valid root if root
- * is NULL), takes a reference on it, and returns that next root. If root
- * is not NULL, this thread should have already taken a reference on it, and
- * that reference will be dropped. If no valid root is found, this
- * function will return NULL.
+ * Finds the next root after @prev_root (or the first root if @prev_root is NULL
+ * or invalid), takes a reference on it, and returns that next root.  If root is
+ * not NULL, this thread should have already taken a reference on it, and that
+ * reference will be dropped. If no valid root is found, this function will
+ * return NULL.
  */
 static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 					      struct kvm_mmu_page *prev_root,
@@ -124,6 +137,27 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 {
 	struct kvm_mmu_page *next_root;
 
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	/*
+	 * Restart the walk if the previous root was invalidated, which can
+	 * happen if the caller drops mmu_lock when yielding.  Restarting the
+	 * walke is necessary because invalidating a root also removes it from
+	 * tdp_mmu_roots.  Restarting is safe and correct because invalidating
+	 * a root is done if and only if _all_ roots are invalidated, i.e. any
+	 * root on tdp_mmu_roots was added _after_ the invalidation event.
+	 */
+	if (prev_root && prev_root->role.invalid) {
+		kvm_tdp_mmu_put_root(kvm, prev_root, shared);
+		prev_root = NULL;
+	}
+
+	/*
+	 * Finding the next root must be done under RCU read lock.  Although
+	 * @prev_root itself cannot be removed from tdp_mmu_roots because this
+	 * task holds a reference, its next and prev pointers can be modified
+	 * when freeing a different root.  Ditto for tdp_mmu_roots itself.
+	 */
 	rcu_read_lock();
 
 	if (prev_root)
@@ -230,10 +264,13 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
-
+	/*
+	 * Because mmu_lock must be held for write to ensure that KVM doesn't
+	 * create multiple roots for a given role, this does not need to use
+	 * an RCU-friendly variant as readers of tdp_mmu_roots must also hold
+	 * mmu_lock in some capacity.
+	 */
+	list_add(&root->link, &kvm->arch.tdp_mmu_roots);
 out:
 	return __pa(root->spt);
 }
@@ -814,28 +851,6 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 		kvm_flush_remote_tlbs(kvm);
 }
 
-static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
-						  struct kvm_mmu_page *prev_root)
-{
-	struct kvm_mmu_page *next_root;
-
-	if (prev_root)
-		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						  &prev_root->link,
-						  typeof(*prev_root), link);
-	else
-		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						   typeof(*next_root), link);
-
-	while (next_root && !(next_root->role.invalid &&
-			      refcount_read(&next_root->tdp_mmu_root_count)))
-		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						  &next_root->link,
-						  typeof(*next_root), link);
-
-	return next_root;
-}
-
 /*
  * Since kvm_tdp_mmu_zap_all_fast has acquired a reference to each
  * invalidated root, they will not be freed until this function drops the
@@ -844,22 +859,21 @@ static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
  * only has to do a trivial amount of work. Since the roots are invalid,
  * no new SPTEs should be created under them.
  */
-void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
+void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm,
+				       struct list_head *invalidated_roots)
 {
-	struct kvm_mmu_page *next_root;
-	struct kvm_mmu_page *root;
+	struct kvm_mmu_page *root, *tmp;
 
+	lockdep_assert_held(&kvm->slots_lock);
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	rcu_read_lock();
-
-	root = next_invalidated_root(kvm, NULL);
-
-	while (root) {
-		next_root = next_invalidated_root(kvm, root);
-
-		rcu_read_unlock();
-
+	/*
+	 * Put the ref to each root, acquired by kvm_tdp_mmu_put_root().  The
+	 * safe variant is required even though kvm_tdp_mmu_put_root() doesn't
+	 * explicitly remove the root from the invalid list, as this task does
+	 * not take rcu_read_lock() and so the list object itself can be freed.
+	 */
+	list_for_each_entry_safe(root, tmp, invalidated_roots, link) {
 		/*
 		 * A TLB flush is unnecessary, invalidated roots are guaranteed
 		 * to be unreachable by the guest (see kvm_tdp_mmu_put_root()
@@ -870,49 +884,50 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 		 * blip and not a functional issue.
 		 */
 		(void)zap_gfn_range(kvm, root, 0, -1ull, true, false, true);
-
-		/*
-		 * Put the reference acquired in
-		 * kvm_tdp_mmu_invalidate_roots
-		 */
 		kvm_tdp_mmu_put_root(kvm, root, true);
-
-		root = next_root;
-
-		rcu_read_lock();
 	}
-
-	rcu_read_unlock();
 }
 
 /*
- * Mark each TDP MMU root as invalid so that other threads
- * will drop their references and allow the root count to
- * go to 0.
+ * Mark each TDP MMU root as invalid so that other threads will drop their
+ * references and allow the root count to go to 0.
  *
- * Also take a reference on all roots so that this thread
- * can do the bulk of the work required to free the roots
- * once they are invalidated. Without this reference, a
- * vCPU thread might drop the last reference to a root and
- * get stuck with tearing down the entire paging structure.
+ * Take a reference on each root and move it to a local list so that this task
+ * can do the actual work required to free the roots once they are invalidated,
+ * e.g. zap the SPTEs and trigger a remote TLB flush. Without this reference, a
+ * vCPU task might drop the last reference to a root and get stuck with tearing
+ * down the entire paging structure.
  *
- * Roots which have a zero refcount should be skipped as
- * they're already being torn down.
- * Already invalid roots should be referenced again so that
- * they aren't freed before kvm_tdp_mmu_zap_all_fast is
- * done with them.
+ * Roots which have a zero refcount are skipped as they're already being torn
+ * down.  Encountering a root that is already invalid is a KVM bug, as this is
+ * the only path that is allowed to invalidate roots and (a) it's proteced by
+ * slots_lock and (b) pulls each root off tdp_mmu_roots.
  *
- * This has essentially the same effect for the TDP MMU
- * as updating mmu_valid_gen does for the shadow MMU.
+ * This has essentially the same effect for the TDP MMU as updating
+ * mmu_valid_gen does for the shadow MMU.
  */
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
+void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm,
+				      struct list_head *invalidated_roots)
 {
-	struct kvm_mmu_page *root;
+	struct kvm_mmu_page *root, *tmp;
 
+	/*
+	 * mmu_lock must be held for write, moving entries off an RCU-protected
+	 * list is not safe, entries can only be deleted.   All accesses to
+	 * tdp_mmu_roots are required to hold mmu_lock in some capacity, thus
+	 * holding it for write ensures there are no concurrent readers.
+	 */
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
-		if (refcount_inc_not_zero(&root->tdp_mmu_root_count))
-			root->role.invalid = true;
+
+	list_for_each_entry_safe(root, tmp, &kvm->arch.tdp_mmu_roots, link) {
+		if (!kvm_tdp_mmu_get_root(root))
+			continue;
+
+		list_move_tail(&root->link, invalidated_roots);
+
+		WARN_ON_ONCE(root->role.invalid);
+		root->role.invalid = true;
+	}
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 599714de67c3..ced6d8e47362 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -9,7 +9,13 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
-	if (root->role.invalid)
+	/*
+	 * Acquiring a reference on an invalid root is a KVM bug.  Invalid roots
+	 * are supposed to be reachable only by references that were acquired
+	 * before the invalidation, and taking an additional reference to an
+	 * invalid root is not allowed.
+	 */
+	if (WARN_ON_ONCE(root->role.invalid))
 		return false;
 
 	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
@@ -44,8 +50,10 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 }
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
-void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
+void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm,
+				      struct list_head *invalidated_roots);
+void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm,
+				       struct list_head *invalidated_roots);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
-- 
2.34.0.rc2.393.gf8c9666880-goog


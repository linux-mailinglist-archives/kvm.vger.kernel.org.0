Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67454C5293
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240459AbiBZASO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240788AbiBZARt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:49 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF91F22C6DA
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:42 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id z10-20020a634c0a000000b0036c5eb39076so3462208pga.18
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MtFjInkw6IfHM8qigYcwgTznLrkAOMo13iKHQwnE+RY=;
        b=UHd0RZGwQM9tLWquYv40cKi4O+zpI8kl9GYujD7+NRNRf/rOM3orWVXz6hbm9DPwqn
         G2yVyOwRj8r0I91Balg/eUXT4Vssf1yySR+LnqtVeDfsOK0TqyPJCjVD1j7UZIrzS+H2
         XgafyuCMW1zFpaDC/BuznK+9/sIINwetRnZ6GDAARzpqzz1Wmev0MYlL/J7X1SGHQ9gq
         fWeUYpGUxw7peSaIWNxspqeegQQGcW/VpMyL37FCggG6jWhj013Elqk9ugfloYEND583
         mFH+M+fy7wvJNgIP3EYqRpLSf3NGs7L6UDxtkyGjqKhdHEu0xqBoQqN6c8SmQU0sBMaR
         s6Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MtFjInkw6IfHM8qigYcwgTznLrkAOMo13iKHQwnE+RY=;
        b=3H9wspUQM0VToqCEIebSx0Y8H5aSD936pqQLwBFZKnLW8lm/ai6q9vPV9Z4d+OvONa
         5tMyPSot2PGRFtKgNmLMh2S5HVc+yTf3OBVdbCBD5JBn8MCteZfbzSgISgDXZAn+IF7n
         b3mYk+b22yilAQ/L66yzoxTXgwLhB9itLE8BxSc/dAfCjDAgdo1MQ94eMN7U7TGH6con
         YtXGkaABfLDb7yVHKw8zgBD4HKZDdzJHQWQT0UGrk19x11g6dXSb6P+/DMkuzLrLIaz4
         UX224cBn6GdRMHHixksD/FmsWnOs8Z65crCyQc1rtjgjGnxqGCJSbLAzLJFDMRE1DSeU
         +/hw==
X-Gm-Message-State: AOAM532Y9nknk9UIg7bEe3Pwufe4Z0hj1XU10Uh9VegArP/S5VKOVKu+
        RmDosGYD73UUrmAmlarQPWgdWd+s/Nk=
X-Google-Smtp-Source: ABdhPJyBaElSz5P3eL5Msmfyo8Q6hiVLJEgTjKZw7rh4UamsOV8nO7GCL/BZGus/ptWCadyPC/4cDm/RtOs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:244f:b0:4df:82ad:447 with SMTP id
 d15-20020a056a00244f00b004df82ad0447mr10149467pfj.49.1645834595122; Fri, 25
 Feb 2022 16:16:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:38 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-21-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 20/28] KVM: x86/mmu: Allow yielding when zapping GFNs for
 defunct TDP MMU root
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow yielding when zapping SPTEs after the last reference to a valid
root is put.  Because KVM must drop all SPTEs in response to relevant
mmu_notifier events, mark defunct roots invalid and reset their refcount
prior to zapping the root.  Keeping the refcount elevated while the zap
is in-progress ensures the root is reachable via mmu_notifier until the
zap completes and the last reference to the invalid, defunct root is put.

Allowing kvm_tdp_mmu_put_root() to yield fixes soft lockup issues if the
root in being put has a massive paging structure, e.g. zapping a root
that is backed entirely by 4kb pages for a guest with 32tb of memory can
take hundreds of seconds to complete.

  watchdog: BUG: soft lockup - CPU#49 stuck for 485s! [max_guest_memor:52368]
  RIP: 0010:kvm_set_pfn_dirty+0x30/0x50 [kvm]
   __handle_changed_spte+0x1b2/0x2f0 [kvm]
   handle_removed_tdp_mmu_page+0x1a7/0x2b8 [kvm]
   __handle_changed_spte+0x1f4/0x2f0 [kvm]
   handle_removed_tdp_mmu_page+0x1a7/0x2b8 [kvm]
   __handle_changed_spte+0x1f4/0x2f0 [kvm]
   tdp_mmu_zap_root+0x307/0x4d0 [kvm]
   kvm_tdp_mmu_put_root+0x7c/0xc0 [kvm]
   kvm_mmu_free_roots+0x22d/0x350 [kvm]
   kvm_mmu_reset_context+0x20/0x60 [kvm]
   kvm_arch_vcpu_ioctl_set_sregs+0x5a/0xc0 [kvm]
   kvm_vcpu_ioctl+0x5bd/0x710 [kvm]
   __se_sys_ioctl+0x77/0xc0
   __x64_sys_ioctl+0x1d/0x20
   do_syscall_64+0x44/0xa0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

KVM currently doesn't put a root from a non-preemptible context, so other
than the mmu_notifier wrinkle, yielding when putting a root is safe.

Yield-unfriendly iteration uses for_each_tdp_mmu_root(), which doesn't
take a reference to each root (it requires mmu_lock be held for the
entire duration of the walk).

tdp_mmu_next_root() is used only by the yield-friendly iterator.

kvm_tdp_mmu_zap_invalidated_roots() is explicitly yield friendly.

kvm_mmu_free_roots() => mmu_free_root_page() is a much bigger fan-out,
but is still yield-friendly in all call sites, as all callers can be
traced back to some combination of vcpu_run(), kvm_destroy_vm(), and/or
kvm_create_vm().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 122 ++++++++++++++++++++++++-------------
 1 file changed, 81 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3031b42c27a6..b838cfa984ad 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -91,21 +91,66 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	WARN_ON(!root->tdp_mmu_page);
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_del_rcu(&root->link);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	/*
+	 * Ensure root->role.invalid is read after the refcount reaches zero to
+	 * avoid zapping the root multiple times, e.g. if a different task
+	 * acquires a reference (after the root was marked invalid) and puts
+	 * the last reference, all while holding mmu_lock for read.  Pairs
+	 * with the smp_mb__before_atomic() below.
+	 */
+	smp_mb__after_atomic();
+
+	/*
+	 * Free the root if it's already invalid.  Invalid roots must be zapped
+	 * before their last reference is put, i.e. there's no work to be done,
+	 * and all roots must be invalidated (see below) before they're freed.
+	 * Re-zapping invalid roots would put KVM into an infinite loop (again,
+	 * see below).
+	 */
+	if (root->role.invalid) {
+		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+		list_del_rcu(&root->link);
+		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+
+		call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
+		return;
+	}
+
+	/*
+	 * Invalidate the root to prevent it from being reused by a vCPU, and
+	 * so that KVM doesn't re-zap the root when its last reference is put
+	 * again (see above).
+	 */
+	root->role.invalid = true;
+
+	/*
+	 * Ensure role.invalid is visible if a concurrent reader acquires a
+	 * reference after the root's refcount is reset.  Pairs with the
+	 * smp_mb__after_atomic() above.
+	 */
+	smp_mb__before_atomic();
+
+	/*
+	 * Note, if mmu_lock is held for read this can race with other readers,
+	 * e.g. they may acquire a reference without seeing the root as invalid,
+	 * and the refcount may be reset after the root is skipped.  Both races
+	 * are benign, as flows that must visit all roots, e.g. need to zap
+	 * SPTEs for correctness, must take mmu_lock for write to block page
+	 * faults, and the only flow that must not consume an invalid root is
+	 * allocating a new root for a vCPU, which also takes mmu_lock for write.
+	 */
+	refcount_set(&root->tdp_mmu_root_count, 1);
 
 	/*
-	 * A TLB flush is not necessary as KVM performs a local TLB flush when
-	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
-	 * to a different pCPU.  Note, the local TLB flush on reuse also
-	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
-	 * intermediate paging structures, that may be zapped, as such entries
-	 * are associated with the ASID on both VMX and SVM.
+	 * Zap the root, then put the refcount "acquired" above.   Recursively
+	 * call kvm_tdp_mmu_put_root() to test the above logic for avoiding an
+	 * infinite loop by freeing invalid roots.  By design, the root is
+	 * reachable while it's being zapped, thus a different task can put its
+	 * last reference, i.e. flowing through kvm_tdp_mmu_put_root() for a
+	 * defunct root is unavoidable.
 	 */
 	tdp_mmu_zap_root(kvm, root, shared);
-
-	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
+	kvm_tdp_mmu_put_root(kvm, root, shared);
 }
 
 enum tdp_mmu_roots_iter_type {
@@ -760,12 +805,23 @@ static inline gfn_t tdp_mmu_max_gfn_host(void)
 static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			     bool shared)
 {
-	bool root_is_unreachable = !refcount_read(&root->tdp_mmu_root_count);
 	struct tdp_iter iter;
 
 	gfn_t end = tdp_mmu_max_gfn_host();
 	gfn_t start = 0;
 
+	/*
+	 * The root must have an elevated refcount so that it's reachable via
+	 * mmu_notifier callbacks, which allows this path to yield and drop
+	 * mmu_lock.  When handling an unmap/release mmu_notifier command, KVM
+	 * must drop all references to relevant pages prior to completing the
+	 * callback.  Dropping mmu_lock with an unreachable root would result
+	 * in zapping SPTEs after a relevant mmu_notifier callback completes
+	 * and lead to use-after-free as zapping a SPTE triggers "writeback" of
+	 * dirty accessed bits to the SPTE's associated struct page.
+	 */
+	WARN_ON_ONCE(!refcount_read(&root->tdp_mmu_root_count));
+
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
 	rcu_read_lock();
@@ -776,42 +832,16 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	 */
 	for_each_tdp_pte_min_level(iter, root, root->role.level, start, end) {
 retry:
-		/*
-		 * Yielding isn't allowed when zapping an unreachable root as
-		 * the root won't be processed by mmu_notifier callbacks.  When
-		 * handling an unmap/release mmu_notifier command, KVM must
-		 * drop all references to relevant pages prior to completing
-		 * the callback.  Dropping mmu_lock can result in zapping SPTEs
-		 * for an unreachable root after a relevant callback completes,
-		 * which leads to use-after-free as zapping a SPTE triggers
-		 * "writeback" of dirty/accessed bits to the SPTE's associated
-		 * struct page.
-		 */
-		if (!root_is_unreachable &&
-		    tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte))
 			continue;
 
-		if (!shared) {
+		if (!shared)
 			tdp_mmu_set_spte(kvm, &iter, 0);
-		} else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0)) {
-			/*
-			 * cmpxchg() shouldn't fail if the root is unreachable.
-			 * Retry so as not to leak the page and its children.
-			 */
-			WARN_ONCE(root_is_unreachable,
-				  "Contended TDP MMU SPTE in unreachable root.");
+		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
 			goto retry;
-		}
-
-		/*
-		 * WARN if the root is invalid and is unreachable, all SPTEs
-		 * should've been zapped by kvm_tdp_mmu_zap_invalidated_roots(),
-		 * and inserting new SPTEs under an invalid root is a KVM bug.
-		 */
-		WARN_ON_ONCE(root_is_unreachable && root->role.invalid);
 	}
 
 	rcu_read_unlock();
@@ -906,6 +936,9 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	int i;
 
 	/*
+	 * Zap all roots, including invalid roots, as all SPTEs must be dropped
+	 * before returning to the caller.
+	 *
 	 * A TLB flush is unnecessary, KVM zaps everything if and only the VM
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
 	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
@@ -931,6 +964,13 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 
 	for_each_invalid_tdp_mmu_root_yield_safe(kvm, root) {
 		/*
+		 * Zap the root regardless of what marked it invalid, e.g. even
+		 * if the root was marked invalid by kvm_tdp_mmu_put_root() due
+		 * to its last reference being put.  All SPTEs must be dropped
+		 * before returning to the caller, e.g. if a memslot is deleted
+		 * or moved, the memslot's associated SPTEs are unreachable via
+		 * the mmu_notifier once the memslot update completes.
+		 *
 		 * A TLB flush is unnecessary, invalidated roots are guaranteed
 		 * to be unreachable by the guest (see kvm_tdp_mmu_put_root()
 		 * for more details), and unlike the legacy MMU, no vCPU kick
-- 
2.35.1.574.g5d30c73bfb-goog


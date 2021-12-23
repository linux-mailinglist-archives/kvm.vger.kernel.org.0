Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00C147E977
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350883AbhLWW02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350653AbhLWWZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:25:02 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABF8C0619DA
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:21 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id i12-20020a63584c000000b00330ec6e2c37so3896350pgm.7
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gISDifzPfM9NcqK+RFft8Pla2QecbjH1Rdd2hFIVXsM=;
        b=gc/pQdeI18xpDzB197wjMZ4F1vQ6UhUlP5O+H36rIZLcP6RTQnTKWf5oNJqQGDF5Q6
         oqA2S8HleD8TgLsaL9sqGpq2ut8A8nsxqaa5+eONnB0kah7e7qduGKsezJYEwF6ntNtx
         MdFW8XBvXoiEuKTt407Ot7OfWxf22WugTW08bLizQkmNCcbicAVESz4zgQpcJ1uIJ/CP
         xURYU19G3EBWYvq+o1IBin+DGplfdJWSlOky0HaAPByy/DYrD4Q+Xl9TbQ75ZvYvOr1u
         zEBXC5to8DBzsS/tHyqujW7mO6qc+tEkOZEu3g/ikX6T8/1U+qh0zndP3qI/nkwaNJKf
         FQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gISDifzPfM9NcqK+RFft8Pla2QecbjH1Rdd2hFIVXsM=;
        b=E0XI0wlknh48tMqn0qWL49NNCrK2WmEat8Bi6gds3XSDIhZA/z5CSi6HzYvdCmA/0b
         rE/tYn95UW7K1qbEnHc2OPU6+8yNNhbGKIQxOQhDWa0a+T1PPz4ZSXnu6Y103PpnF1G2
         rZmHYfsbg+w2YvjYm5FOS+P826V7sgZupyJV0Z8fqYbvoAvkMu8kJpjURcjSPtmVx+tI
         yBsoNk6cbe9d7MwxjBSVLjULrT9qJYLn842B99qypSD2GGIuxNIY1vH3OZtj/fNYy3YG
         DoKNDOcIpcGxH+wcANMIjpu6nPZRHgw9o+Ee73HjAu0HroXMx8owYdYrIPu/6vjBHw0N
         d+rQ==
X-Gm-Message-State: AOAM533azWMyA4wqHizdS0dYwt+3cGWMWW5g/zbuDhC5LISaR6lML2Wx
        3iyYRD7sVdmZ6vTMoRFnzMt+DUE73uc=
X-Google-Smtp-Source: ABdhPJwQqLnDJ2MgZO8u3orclBM6jREZZOfxLRV0xmKGFxZt7/wmQ4/B39tbZ4domX7NBJBa1++uarDWVBU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a03:b0:4ba:c23e:df67 with SMTP id
 g3-20020a056a001a0300b004bac23edf67mr4150250pfv.63.1640298260806; Thu, 23 Dec
 2021 14:24:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:12 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-25-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 24/30] KVM: x86/mmu: Allow yielding when zapping GFNs for
 defunct TDP MMU root
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
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
 arch/x86/kvm/mmu/mmu_internal.h |   7 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 145 +++++++++++++++++++++++---------
 2 files changed, 109 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index be063b6c91b7..8ce3d58fdf7f 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -65,7 +65,12 @@ struct kvm_mmu_page {
 		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
 		tdp_ptep_t ptep;
 	};
-	DECLARE_BITMAP(unsync_child_bitmap, 512);
+	union {
+		DECLARE_BITMAP(unsync_child_bitmap, 512);
+		struct {
+			bool tdp_mmu_defunct_root;
+		};
+	};
 
 	struct list_head lpage_disallowed_link;
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 72bcec2cd23c..aec97e037a8d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -91,21 +91,67 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	WARN_ON(!root->tdp_mmu_page);
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_del_rcu(&root->link);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	/*
+	 * Ensure root->role.invalid is read after the refcount reaches zero to
+	 * avoid zapping the root multiple times, e.g. if a different task
+	 * acquires a reference (after the root was marked invalid+defunct) and
+	 * puts the last reference, all while holding mmu_lock for read.  Pairs
+	 * with the smp_mb__before_atomic() below.
+	 */
+	smp_mb__after_atomic();
+
+	/*
+	 * Free the root if it's already invalid.  Invalid roots must be zapped
+	 * before their last reference is put, i.e. there's no work to be done,
+	 * and all roots must be invalidated (see below) before they're freed.
+	 * Re-zapping defunct roots, which are always invalid, would put KVM
+	 * into an infinite loop (again, see below).
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
+	 * mark it defunct so that kvm_tdp_mmu_zap_invalidated_roots() doesn't
+	 * try to put a reference it didn't acquire.
+	 */
+	root->role.invalid = true;
+	root->tdp_mmu_defunct_root = true;
+
+	/*
+	 * Ensure tdp_mmu_defunct_root is visible if a concurrent reader acquires
+	 * a reference after the root's refcount is reset.  Pairs with the
+	 * smp_mb__after_atomic() above and in kvm_tdp_mmu_zap_invalidated_roots().
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
@@ -758,12 +804,23 @@ static inline gfn_t tdp_mmu_max_gfn_host(void)
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
@@ -775,19 +832,7 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
 				   root->role.level, start, end) {
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
@@ -796,22 +841,9 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (!shared) {
 			tdp_mmu_set_spte(kvm, &iter, 0);
 		} else if (!tdp_mmu_set_spte_atomic(kvm, &iter, 0)) {
-			/*
-			 * cmpxchg() shouldn't fail if the root is unreachable.
-			 * to be unreachable.  Re-read the SPTE and retry so as
-			 * not to leak the page and its children.
-			 */
-			WARN_ONCE(root_is_unreachable,
-				  "Contended TDP MMU SPTE in unreachable root.");
 			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 			goto retry;
 		}
-		/*
-		 * WARN if the root is invalid and is unreachable, all SPTEs
-		 * should've been zapped by kvm_tdp_mmu_zap_invalidated_roots(),
-		 * and inserting new SPTEs under an invalid root is a KVM bug.
-		 */
-		WARN_ON_ONCE(root_is_unreachable && root->role.invalid);
 	}
 
 	rcu_read_unlock();
@@ -899,6 +931,9 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	int i;
 
 	/*
+	 * Zap all roots, including defunct roots, as all SPTEs must be dropped
+	 * before returning to the caller.
+	 *
 	 * A TLB flush is unnecessary, KVM zaps everything if and only the VM
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
 	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
@@ -924,6 +959,12 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 
 	for_each_invalid_tdp_mmu_root_yield_safe(kvm, root) {
 		/*
+		 * Zap the root, even if it's defunct, as all SPTEs must be
+		 * dropped before returning to the caller, e.g. if the root was
+		 * invalidated by a memslot update, then SPTEs associated with
+		 * a deleted/moved memslot are unreachable via the mmu_notifier
+		 * once the memslot update completes.
+		 *
 		 * A TLB flush is unnecessary, invalidated roots are guaranteed
 		 * to be unreachable by the guest (see kvm_tdp_mmu_put_root()
 		 * for more details), and unlike the legacy MMU, no vCPU kick
@@ -935,10 +976,24 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 		tdp_mmu_zap_root(kvm, root, true);
 
 		/*
-		 * Put the reference acquired in kvm_tdp_mmu_invalidate_roots().
+		 * Leverages kvm_tdp_mmu_get_root() in the iterator, pairs with
+		 * the smp_mb__before_atomic() in kvm_tdp_mmu_put_root() to
+		 * ensure a defunct root is seen as such.
+		 */
+		smp_mb__after_atomic();
+
+		/*
+		 * Put the reference acquired in kvm_tdp_mmu_invalidate_roots()
+		 * unless the root is defunct worker data, in which case no
+		 * reference was taken.  Roots become defunct only when a valid
+		 * root has its last reference put, thus holding a reference
+		 * means the root can't become defunct between invalidating the
+		 * root and re-checking the data here.
+		 *
 		 * Note, the iterator holds its own reference.
 		 */
-		kvm_tdp_mmu_put_root(kvm, root, true);
+		if (!root->tdp_mmu_defunct_root)
+			kvm_tdp_mmu_put_root(kvm, root, true);
 	}
 }
 
@@ -953,13 +1008,17 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  * a vCPU drops the last reference to a root prior to the root being zapped, it
  * will get stuck with tearing down the entire paging structure.
  *
- * Get a reference even if the root is already invalid,
+ * Get a reference even if the root is already invalid, unless it's defunct, as
  * kvm_tdp_mmu_zap_invalidated_roots() assumes it was gifted a reference to all
  * invalid roots, e.g. there's no epoch to identify roots that were invalidated
  * by a previous call.  Roots stay on the list until the last reference is
  * dropped, so even though all invalid roots are zapped, a root may not go away
  * for quite some time, e.g. if a vCPU blocks across multiple memslot updates.
  *
+ * Don't take a reference if the root is defunct, vCPUs cannot hold references
+ * to defunct roots and so will never get stuck with zapping the root.  Note,
+ * defunct roots still need to be zapped by kvm_tdp_mmu_zap_invalidated_roots().
+ *
  * Because mmu_lock is held for write, it should be impossible to observe a
  * root with zero refcount, i.e. the list of roots cannot be stale.
  *
@@ -971,8 +1030,10 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
+
 	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
-		if (!WARN_ON_ONCE(!kvm_tdp_mmu_get_root(kvm, root)))
+		if (!root->tdp_mmu_defunct_root &&
+		    !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
 			root->role.invalid = true;
 	}
 }
-- 
2.34.1.448.ga2b2bfdf31-goog


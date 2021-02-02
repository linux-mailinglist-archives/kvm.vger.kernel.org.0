Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1341B30CB18
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239378AbhBBTNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239352AbhBBTCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:02:07 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2558C061A10
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:15 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b125so17223370ybg.10
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=rQ/2uzOGEB0AGr9GTok3ymLIkQsPkRXMIAaXffzGwQU=;
        b=ItxIvvc6bbX8LPNf1NUdolXQpQ3f1ig9h1u4bngpEtSfgU4vUZOLWHOQtjHecUb7bl
         4Jp3XK77EGDPHsSHZzI3At0CkHaoXHLE+dBntZwHFexRMYZepUlITjMlW4TWrn+3gCXH
         wJWrXvSE+wdwG9U5mX+LM2RVUuhFaGeqzZO2CBY4fKYdyO8uJLHZQCeetE4ykhSqXjRg
         YK8qmGZuyRnclGhQMBJLbWTk50IXcblG8JOLdVapQjWHlxOHjirj3IHvb9S0b9Z8Cbrt
         DtW/447LFuB6vbRcC5d8qUX+xQmyZJxaHSaUXr2R9QGN4/fMa3ZMZWVGsNHR5bV0A0f9
         2CxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rQ/2uzOGEB0AGr9GTok3ymLIkQsPkRXMIAaXffzGwQU=;
        b=AuV/buSUUIPZHJTLS2W0UXwXyBrrIlUxvvstmnuIfirl4RH0oC5Fyd4j/72VUzraD4
         elY3ntofK4+r5t0jEaBsM9wnKXf9IZnJDvFuvwNc6P7rboW9KunVMk3sJfV/CwdgzEbr
         aEMdXJ5TWwNCRWjjWI0akLCU/S12y/nPw1g8CH1rRx7UzIpUFjumfAbWityQ1XAdsR1D
         AG/qwlPpRG7sNI/lLP3694QLc+Rql4xipcqx1fiJ8daUxRfuURaoas66Sf5BhvEgd6Am
         DVbTvgGxjV0fQs01lzizKnhLvwbTKlA/w1X99wBnYrvzEdYG9GgkfFgZuf2o9rRUI2TT
         UbyQ==
X-Gm-Message-State: AOAM530xZTY3X0NGDmTgw8/n77pFONkn3SIxZ5GPjTTqVzAJDV5xeNnC
        ULrpG9GCYgv9lDA+Jh32OxnS58Y5R9WY
X-Google-Smtp-Source: ABdhPJzvaZISwD/AYwji6K6c68C1mtJjmS3pJ3jB/VnOzKUamjTIQDWhwkGJWwx2ow1YaBLERWypNnJjNSe3
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a25:e08a:: with SMTP id
 x132mr19078901ybg.121.1612292295005; Tue, 02 Feb 2021 10:58:15 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:26 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-21-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 20/28] KVM: x86/mmu: Use atomic ops to set SPTEs in TDP MMU map
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To prepare for handling page faults in parallel, change the TDP MMU
page fault handler to use atomic operations to set SPTEs so that changes
are not lost if multiple threads attempt to modify the same SPTE.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

---

v1 -> v2
- Rename "atomic" arg to "shared" in multiple functions
- Merged the commit that protects the lists of TDP MMU pages with a new
  lock
- Merged the commits to add an atomic option for setting SPTEs and to
  use that option in the TDP MMU page fault handler

 arch/x86/include/asm/kvm_host.h |  13 +++
 arch/x86/kvm/mmu/tdp_mmu.c      | 142 ++++++++++++++++++++++++--------
 2 files changed, 122 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b6ebf2558386..78ebf56f2b37 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1028,6 +1028,19 @@ struct kvm_arch {
 	 * tdp_mmu_page set and a root_count of 0.
 	 */
 	struct list_head tdp_mmu_pages;
+
+	/*
+	 * Protects accesses to the following fields when the MMU lock
+	 * is held in read mode:
+	 *  - tdp_mmu_pages (above)
+	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
+	 *  - lpage_disallowed_mmu_pages
+	 *  - the lpage_disallowed_link field of struct kvm_mmu_pages used
+	 *    by the TDP MMU
+	 * It is acceptable, but not necessary, to acquire this lock when
+	 * the thread holds the MMU lock in write mode.
+	 */
+	spinlock_t tdp_mmu_pages_lock;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5a9e964e0178..0b5a9339ac55 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -7,6 +7,7 @@
 #include "tdp_mmu.h"
 #include "spte.h"
 
+#include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
 
 #ifdef CONFIG_X86_64
@@ -33,6 +34,7 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	kvm->arch.tdp_mmu_enabled = true;
 
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
+	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 }
 
@@ -225,7 +227,8 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level);
+				u64 old_spte, u64 new_spte, int level,
+				bool shared);
 
 static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 {
@@ -267,17 +270,26 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
  *
  * @kvm: kvm instance
  * @sp: the new page
+ * @shared: This operation may not be running under the exclusive use of
+ *	    the MMU lock and the operation must synchronize with other
+ *	    threads that might be adding or removing pages.
  * @account_nx: This page replaces a NX large page and should be marked for
  *		eventual reclaim.
  */
 static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			      bool account_nx)
+			      bool shared, bool account_nx)
 {
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	if (shared)
+		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	else
+		lockdep_assert_held_write(&kvm->mmu_lock);
 
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
 	if (account_nx)
 		account_huge_nx_page(kvm, sp);
+
+	if (shared)
+		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
 /**
@@ -285,14 +297,24 @@ static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
  *
  * @kvm: kvm instance
  * @sp: the page to be removed
+ * @shared: This operation may not be running under the exclusive use of
+ *	    the MMU lock and the operation must synchronize with other
+ *	    threads that might be adding or removing pages.
  */
-static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				bool shared)
 {
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	if (shared)
+		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	else
+		lockdep_assert_held_write(&kvm->mmu_lock);
 
 	list_del(&sp->link);
 	if (sp->lpage_disallowed)
 		unaccount_huge_nx_page(kvm, sp);
+
+	if (shared)
+		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
 /**
@@ -300,28 +322,39 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp)
  *
  * @kvm: kvm instance
  * @pt: the page removed from the paging structure
+ * @shared: This operation may not be running under the exclusive use
+ *	    of the MMU lock and the operation must synchronize with other
+ *	    threads that might be modifying SPTEs.
  *
  * Given a page table that has been removed from the TDP paging structure,
  * iterates through the page table to clear SPTEs and free child page tables.
  */
-static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt)
+static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt,
+					bool shared)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(pt);
 	int level = sp->role.level;
 	gfn_t gfn = sp->gfn;
 	u64 old_child_spte;
+	u64 *sptep;
 	int i;
 
 	trace_kvm_mmu_prepare_zap_page(sp);
 
-	tdp_mmu_unlink_page(kvm, sp);
+	tdp_mmu_unlink_page(kvm, sp, shared);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-		old_child_spte = READ_ONCE(*(pt + i));
-		WRITE_ONCE(*(pt + i), 0);
+		sptep = pt + i;
+
+		if (shared) {
+			old_child_spte = xchg(sptep, 0);
+		} else {
+			old_child_spte = READ_ONCE(*sptep);
+			WRITE_ONCE(*sptep, 0);
+		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp),
 			gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
-			old_child_spte, 0, level - 1);
+			old_child_spte, 0, level - 1, shared);
 	}
 
 	kvm_flush_remote_tlbs_with_address(kvm, gfn,
@@ -338,12 +371,16 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt)
  * @old_spte: The value of the SPTE before the change
  * @new_spte: The value of the SPTE after the change
  * @level: the level of the PT the SPTE is part of in the paging structure
+ * @shared: This operation may not be running under the exclusive use of
+ *	    the MMU lock and the operation must synchronize with other
+ *	    threads that might be modifying SPTEs.
  *
  * Handle bookkeeping that might result from the modification of a SPTE.
  * This function must be called for all TDP SPTE modifications.
  */
 static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level)
+				  u64 old_spte, u64 new_spte, int level,
+				  bool shared)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
@@ -415,18 +452,51 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 */
 	if (was_present && !was_leaf && (pfn_changed || !is_present))
 		handle_removed_tdp_mmu_page(kvm,
-				spte_to_child_pt(old_spte, level));
+				spte_to_child_pt(old_spte, level), shared);
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level)
+				u64 old_spte, u64 new_spte, int level,
+				bool shared)
 {
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
+			      shared);
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
 	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
 				      new_spte, level);
 }
 
+/*
+ * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically and handle the
+ * associated bookkeeping
+ *
+ * @kvm: kvm instance
+ * @iter: a tdp_iter instance currently on the SPTE that should be set
+ * @new_spte: The value the SPTE should be set to
+ * Returns: true if the SPTE was set, false if it was not. If false is returned,
+ *	    this function will have no side-effects.
+ */
+static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
+					   struct tdp_iter *iter,
+					   u64 new_spte)
+{
+	u64 *root_pt = tdp_iter_root_pt(iter);
+	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
+	int as_id = kvm_mmu_page_as_id(root);
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
+		      new_spte) != iter->old_spte)
+		return false;
+
+	handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
+			    iter->level, true);
+
+	return true;
+}
+
+
 /*
  * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
  * @kvm: kvm instance
@@ -456,7 +526,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
 
 	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-			      iter->level);
+			      iter->level, false);
 	if (record_acc_track)
 		handle_changed_spte_acc_track(iter->old_spte, new_spte,
 					      iter->level);
@@ -630,23 +700,18 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	int ret = 0;
 	int make_spte_ret = 0;
 
-	if (unlikely(is_noslot_pfn(pfn))) {
+	if (unlikely(is_noslot_pfn(pfn)))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
-				     new_spte);
-	} else {
+	else
 		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
 					 pfn, iter->old_spte, prefault, true,
 					 map_writable, !shadow_accessed_mask,
 					 &new_spte);
-		trace_kvm_mmu_set_spte(iter->level, iter->gfn,
-				       rcu_dereference(iter->sptep));
-	}
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else
-		tdp_mmu_set_spte(vcpu->kvm, iter, new_spte);
+	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+		return RET_PF_RETRY;
 
 	/*
 	 * If the page fault was caused by a write but the page is write
@@ -660,8 +725,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-	if (unlikely(is_mmio_spte(new_spte)))
+	if (unlikely(is_mmio_spte(new_spte))) {
+		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
+				     new_spte);
 		ret = RET_PF_EMULATE;
+	} else
+		trace_kvm_mmu_set_spte(iter->level, iter->gfn,
+				       rcu_dereference(iter->sptep));
 
 	trace_kvm_mmu_set_spte(iter->level, iter->gfn,
 			       rcu_dereference(iter->sptep));
@@ -720,7 +790,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		 */
 		if (is_shadow_present_pte(iter.old_spte) &&
 		    is_large_pte(iter.old_spte)) {
-			tdp_mmu_set_spte(vcpu->kvm, &iter, 0);
+			if (!tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, 0))
+				break;
 
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter.gfn,
 					KVM_PAGES_PER_HPAGE(iter.level));
@@ -737,19 +808,24 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
 			child_pt = sp->spt;
 
-			tdp_mmu_link_page(vcpu->kvm, sp,
-					  huge_page_disallowed &&
-					  req_level >= iter.level);
-
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
-			trace_kvm_mmu_get_page(sp, true);
-			tdp_mmu_set_spte(vcpu->kvm, &iter, new_spte);
+			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter,
+						    new_spte)) {
+				tdp_mmu_link_page(vcpu->kvm, sp, true,
+						  huge_page_disallowed &&
+						  req_level >= iter.level);
+
+				trace_kvm_mmu_get_page(sp, true);
+			} else {
+				tdp_mmu_free_sp(sp);
+				break;
+			}
 		}
 	}
 
-	if (WARN_ON(iter.level != level)) {
+	if (iter.level != level) {
 		rcu_read_unlock();
 		return RET_PF_RETRY;
 	}
-- 
2.30.0.365.g02bc693789-goog


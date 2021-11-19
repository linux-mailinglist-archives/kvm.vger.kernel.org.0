Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05A54579D8
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbhKTACP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236358AbhKTABc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:32 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312C1C061574
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:30 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pg9-20020a17090b1e0900b001a689204b52so7484336pjb.0
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LjrcCvl2XE6BaZeb3NcnXgGup80WJ8oxY3f4O7nxHag=;
        b=ljz37K09ZpWa/HflL79lxn1IYkFcRenPjBV3VwR7x7+9w954bJbtARLS8U5QMUPHkR
         D/W8MZi/kphOkW2ebtPdKoe4dzo4ff3AczZ7bjsTrQyDOMCKm7DkY/jjnroUFDEFJC37
         HtMYMvp0ngBWCQor1rWiDgpCzmmCIK0DMBq00iIfMRbxHcy65GCwmh2V+v3X05rnjkeT
         JUqR6lhmTuHMHSCHbb+P2HJDg0J+YENatbqIl/oZHyAyumXrCx2FZshSmAK3Wdr8YyZG
         2ELDepM6dEzEQ+93ShOivbgNKUgZEXgGyiI1Ajx4qODHdmwhxrenr7Bzrc6+2QPe+56c
         YvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LjrcCvl2XE6BaZeb3NcnXgGup80WJ8oxY3f4O7nxHag=;
        b=YuWy57QKL1rbdbPjP0W7wbHmdpIfJv66KEOkIWZBywQmFYEz9Lbu/OAZYqtMjIYFBb
         W7ysdBEpDqWFTpXh9B6oVfGPhpDh5I/2qDXA0WcXYijWY+dpAPjn1dCFaYEcS/tiy5OK
         HzzVwytLD9/VE75GNnIycHvSkxEDfAkLvEUqRjeMrCl2pkHoKVCRDZjpeZNS0j4OJF2g
         SO/xqi7g/DjcdigrfrgvSzeKEC82Ny+AmXplVIIssJcgjS0NcJRCx9+tO8oh+cheDJ4r
         HpUhhxpDP87p696gPdEZUuKCTMKfc5dZhTyKwcAkGCHaX3bI9YARhmCdRmQy9VAhajwU
         bSAQ==
X-Gm-Message-State: AOAM533XkdV9Lc5vQlYsPqkcJnUp52S9yD/s7xi6wdKckqMaCRO0ZvOg
        zUZI6+TS4F6JND6uwVrNrDXVWtzKrU4tsA==
X-Google-Smtp-Source: ABdhPJyPLcIHCk2wWLuOr2qHc5FI6qP1GLflZ+6snAADoJm7fBtXoaC7DVdK69sOCqZPYb/Lm3zY2kaU33VNCw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:c145:b0:142:50c3:c2a with SMTP id
 5-20020a170902c14500b0014250c30c2amr81272532plj.32.1637366309630; Fri, 19 Nov
 2021 15:58:29 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:56 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-13-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty logging
 is enabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dirty logging is enabled without initially-all-set, attempt to
split all large pages in the memslot down to 4KB pages so that vCPUs
do not have to take expensive write-protection faults to split large
pages.

Large page splitting is best-effort only. This commit only adds the
support for the TDP MMU, and even there splitting may fail due to out
of memory conditions. Failures to split a large page is fine from a
correctness standpoint because we still always follow it up by write-
protecting any remaining large pages.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |   6 ++
 arch/x86/kvm/mmu/mmu.c          |  83 +++++++++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h |   3 +
 arch/x86/kvm/mmu/spte.c         |  46 ++++++++++++
 arch/x86/kvm/mmu/spte.h         |   1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 123 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   5 ++
 arch/x86/kvm/x86.c              |   6 ++
 8 files changed, 273 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2a7564703ea6..432a4df817ec 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1232,6 +1232,9 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+
+	/* MMU caches used when splitting large pages during VM-ioctls. */
+	struct kvm_mmu_memory_caches split_caches;
 };
 
 struct kvm_vm_stat {
@@ -1588,6 +1591,9 @@ void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      const struct kvm_memory_slot *memslot,
 				      int start_level);
+void kvm_mmu_slot_try_split_large_pages(struct kvm *kvm,
+					const struct kvm_memory_slot *memslot,
+					int target_level);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 54f0d2228135..6768ef9c0891 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -738,6 +738,66 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 					  PT64_ROOT_MAX_LEVEL);
 }
 
+static inline void assert_split_caches_invariants(struct kvm *kvm)
+{
+	/*
+	 * The split caches must only be modified while holding the slots_lock,
+	 * since it is only used during memslot VM-ioctls.
+	 */
+	lockdep_assert_held(&kvm->slots_lock);
+
+	/*
+	 * Only the TDP MMU supports large page splitting using
+	 * kvm->arch.split_caches, which is why we only have to allocate
+	 * page_header_cache and shadow_page_cache. Assert that the TDP
+	 * MMU is at least enabled when the split cache is allocated.
+	 */
+	BUG_ON(!is_tdp_mmu_enabled(kvm));
+}
+
+int mmu_topup_split_caches(struct kvm *kvm)
+{
+	struct kvm_mmu_memory_caches *split_caches = &kvm->arch.split_caches;
+	int r;
+
+	assert_split_caches_invariants(kvm);
+
+	r = kvm_mmu_topup_memory_cache(&split_caches->page_header_cache, 1);
+	if (r)
+		goto out;
+
+	r = kvm_mmu_topup_memory_cache(&split_caches->shadow_page_cache, 1);
+	if (r)
+		goto out;
+
+	return 0;
+
+out:
+	pr_warn("Failed to top-up split caches. Will not split large pages.\n");
+	return r;
+}
+
+static void mmu_free_split_caches(struct kvm *kvm)
+{
+	assert_split_caches_invariants(kvm);
+
+	kvm_mmu_free_memory_cache(&kvm->arch.split_caches.pte_list_desc_cache);
+	kvm_mmu_free_memory_cache(&kvm->arch.split_caches.shadow_page_cache);
+}
+
+bool mmu_split_caches_need_topup(struct kvm *kvm)
+{
+	assert_split_caches_invariants(kvm);
+
+	if (kvm->arch.split_caches.page_header_cache.nobjs == 0)
+		return true;
+
+	if (kvm->arch.split_caches.shadow_page_cache.nobjs == 0)
+		return true;
+
+	return false;
+}
+
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_memory_caches *mmu_caches;
@@ -5696,6 +5756,7 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
+	mmu_init_memory_caches(&kvm->arch.split_caches);
 	kvm_mmu_init_tdp_mmu(kvm);
 
 	node->track_write = kvm_mmu_pte_write;
@@ -5819,6 +5880,28 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
+void kvm_mmu_slot_try_split_large_pages(struct kvm *kvm,
+					const struct kvm_memory_slot *memslot,
+					int target_level)
+{
+	u64 start, end;
+
+	if (!is_tdp_mmu_enabled(kvm))
+		return;
+
+	if (mmu_topup_split_caches(kvm))
+		return;
+
+	start = memslot->base_gfn;
+	end = start + memslot->npages;
+
+	read_lock(&kvm->mmu_lock);
+	kvm_tdp_mmu_try_split_large_pages(kvm, memslot, start, end, target_level);
+	read_unlock(&kvm->mmu_lock);
+
+	mmu_free_split_caches(kvm);
+}
+
 static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 					 struct kvm_rmap_head *rmap_head,
 					 const struct kvm_memory_slot *slot)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 52c6527b1a06..89b9b907c567 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -161,4 +161,7 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+int mmu_topup_split_caches(struct kvm *kvm);
+bool mmu_split_caches_need_topup(struct kvm *kvm);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index df2cdb8bcf77..6bb9b597a854 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -191,6 +191,52 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return wrprot;
 }
 
+static u64 mark_spte_executable(u64 spte)
+{
+	bool is_access_track = is_access_track_spte(spte);
+
+	if (is_access_track)
+		spte = restore_acc_track_spte(spte);
+
+	spte &= ~shadow_nx_mask;
+	spte |= shadow_x_mask;
+
+	if (is_access_track)
+		spte = mark_spte_for_access_track(spte);
+
+	return spte;
+}
+
+/*
+ * Construct an SPTE that maps a sub-page of the given large SPTE. This is
+ * used during large page splitting, to build the SPTEs that make up the new
+ * page table.
+ */
+u64 make_large_page_split_spte(u64 large_spte, int level, int index, unsigned int access)
+{
+	u64 child_spte;
+	int child_level;
+
+	BUG_ON(is_mmio_spte(large_spte));
+	BUG_ON(!is_large_present_pte(large_spte));
+
+	child_spte = large_spte;
+	child_level = level - 1;
+
+	child_spte += (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
+
+	if (child_level == PG_LEVEL_4K) {
+		child_spte &= ~PT_PAGE_SIZE_MASK;
+
+		/* Allow execution for 4K pages if it was disabled for NX HugePages. */
+		if (is_nx_huge_page_enabled() && access & ACC_EXEC_MASK)
+			child_spte = mark_spte_executable(child_spte);
+	}
+
+	return child_spte;
+}
+
+
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 {
 	u64 spte = SPTE_MMU_PRESENT_MASK;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 3e4943ee5a01..4efb4837e38d 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -339,6 +339,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
+u64 make_large_page_split_spte(u64 large_spte, int level, int index, unsigned int access);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5ca0fa659245..366857b9fb3b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -695,6 +695,39 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return false;
 }
 
+static inline bool
+tdp_mmu_need_split_caches_topup_or_resched(struct kvm *kvm, struct tdp_iter *iter)
+{
+	if (mmu_split_caches_need_topup(kvm))
+		return true;
+
+	return tdp_mmu_iter_need_resched(kvm, iter);
+}
+
+static inline int
+tdp_mmu_topup_split_caches_resched(struct kvm *kvm, struct tdp_iter *iter, bool flush)
+{
+	int r;
+
+	rcu_read_unlock();
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
+	read_unlock(&kvm->mmu_lock);
+
+	cond_resched();
+	r = mmu_topup_split_caches(kvm);
+
+	read_lock(&kvm->mmu_lock);
+
+	rcu_read_lock();
+	WARN_ON(iter->gfn > iter->next_last_level_gfn);
+	tdp_iter_restart(iter);
+
+	return r;
+}
+
 /*
  * Tears down the mappings for the range of gfns, [start, end), and frees the
  * non-root pages mapping GFNs strictly within that range. Returns true if
@@ -1241,6 +1274,96 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
+static bool tdp_mmu_split_large_page_atomic(struct kvm *kvm, struct tdp_iter *iter)
+{
+	const u64 large_spte = iter->old_spte;
+	const int level = iter->level;
+	struct kvm_mmu_page *child_sp;
+	u64 child_spte;
+	int i;
+
+	BUG_ON(mmu_split_caches_need_topup(kvm));
+
+	child_sp = alloc_child_tdp_mmu_page(&kvm->arch.split_caches, iter);
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+		child_spte = make_large_page_split_spte(large_spte, level, i, ACC_ALL);
+
+		/*
+		 * No need for atomics since child_sp has not been installed
+		 * in the table yet and thus is not reachable by any other
+		 * thread.
+		 */
+		child_sp->spt[i] = child_spte;
+	}
+
+	return tdp_mmu_install_sp_atomic(kvm, iter, child_sp, false);
+}
+
+static void tdp_mmu_split_large_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
+					   gfn_t start, gfn_t end, int target_level)
+{
+	struct tdp_iter iter;
+	bool flush = false;
+	int r;
+
+	rcu_read_lock();
+
+	/*
+	 * Traverse the page table splitting all large pages above the target
+	 * level into one lower level. For example, if we encounter a 1GB page
+	 * we split it into 512 2MB pages.
+	 *
+	 * Since the TDP iterator uses a pre-order traversal, we are guaranteed
+	 * to visit an SPTE before ever visiting its children, which means we
+	 * will correctly recursively split large pages that are more than one
+	 * level above the target level (e.g. splitting 1GB to 2MB to 4KB).
+	 */
+	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
+retry:
+		if (tdp_mmu_need_split_caches_topup_or_resched(kvm, &iter)) {
+			r = tdp_mmu_topup_split_caches_resched(kvm, &iter, flush);
+			flush = false;
+
+			/*
+			 * If topping up the split caches failed, we can't split
+			 * any more pages. Bail out of the loop.
+			 */
+			if (r)
+				break;
+
+			continue;
+		}
+
+		if (!is_large_present_pte(iter.old_spte))
+			continue;
+
+		if (!tdp_mmu_split_large_page_atomic(kvm, &iter))
+			goto retry;
+
+		flush = true;
+	}
+
+	rcu_read_unlock();
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+}
+
+void kvm_tdp_mmu_try_split_large_pages(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot,
+				       gfn_t start, gfn_t end,
+				       int target_level)
+{
+	struct kvm_mmu_page *root;
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
+		tdp_mmu_split_large_pages_root(kvm, root, start, end, target_level);
+
+}
+
 /*
  * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
  * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 476b133544dd..7812087836b2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -72,6 +72,11 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level);
 
+void kvm_tdp_mmu_try_split_large_pages(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot,
+				       gfn_t start, gfn_t end,
+				       int target_level);
+
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {
 	rcu_read_lock();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04e8dabc187d..4702ebfd394b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11735,6 +11735,12 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
 			return;
 
+		/*
+		 * Attempt to split all large pages into 4K pages so that vCPUs
+		 * do not have to take write-protection faults.
+		 */
+		kvm_mmu_slot_try_split_large_pages(kvm, new, PG_LEVEL_4K);
+
 		if (kvm_x86_ops.cpu_dirty_log_size) {
 			kvm_mmu_slot_leaf_clear_dirty(kvm, new);
 			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_2M);
-- 
2.34.0.rc2.393.gf8c9666880-goog


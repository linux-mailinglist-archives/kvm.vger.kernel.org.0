Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE092473835
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244098AbhLMW7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244095AbhLMW7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:36 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0F6C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:36 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 184-20020a6217c1000000b0049f9aad0040so10863884pfx.21
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wktwpqxo/6qTxBsMQfGKkeq9jR6p0bwTKGhJS/M9Pow=;
        b=FCfu0ELRNKVG3A4yCaH8M00UGHvxJyk0t2bJpUB9rMeUvU2Bzy68poW4iTzlt6aUlr
         AySR7lV6OQGAzKMca/O+BtxB9/evD2NZUXTNRxGlmlo71DH8GI8ZjQSTUcS14QiJLYDe
         kCBLTFeV6+KNYzxS6PuNTFHQEZzUSgq/a5JqRnbB57hXaAsbs5aSPKOt/1Ay0hIiuimf
         vZ98sqzLa5pqQw6X/Ly/n+okDkBsQNsK2mAaCBQRLcaGkquziC229KSgiaTbaxHDBm6V
         rFE5WuVcx1jgcGMWLUfi7gDNS0Ewtn3cEG1VqQSWzan7CVAmVe+Ze9Z0LgsLuKPFYTC0
         9Lig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wktwpqxo/6qTxBsMQfGKkeq9jR6p0bwTKGhJS/M9Pow=;
        b=ZYMCSLTJ6R2PeO4cJypeyKsssuPx8X2AW8w/1Xxlyg7qhv9U5/dsnU6rIgWlhxIXwr
         IuGX3RlAWUK+mlF2XgqhpHVdaQSBFQgMk0RoU0NoA2B445QUqeUgySyj3zO6bYvlxQgB
         y1dO7HnNml2uNrOl9pGWdp2ZFqihyTdjH3PJC/rxyDDLptMo299U91ANaeE5G99N0XXf
         XDqR1JBiFXrJtaf91wqQt+yrSJxE268vxN/cAh1yhCSQf5Vl7aoGwTwtvd9ifLg4nnJG
         wUPoN6RbZf5adC9AsgMReVqZAq5ARvu4ddHLaY3KtucVbUjfzwmfwSFoCr1WtQst7sa5
         xM7A==
X-Gm-Message-State: AOAM533k6tEOxPvcXZxZwigW0BPm6SrjY2Iz9pEjZ7X7yzwEMqyOk5nZ
        i0AG40Y5DLIhmRN6d4UwjNlqPWCz4t4Y3g==
X-Google-Smtp-Source: ABdhPJxyo/GUOS8gPiMJcLphvRe+qQEVZat0bdstHzETXXXjZIHgnVF+voGlbI4s+ylfNhgbzMuF9SkS524aHg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:8f93:b0:142:8731:1a5d with SMTP
 id z19-20020a1709028f9300b0014287311a5dmr1218885plo.60.1639436376196; Mon, 13
 Dec 2021 14:59:36 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:14 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 09/13] KVM: x86/mmu: Split huge pages when dirty logging is enabled
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
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dirty logging is enabled without initially-all-set, attempt to
split all huge pages in the memslot down to 4KB pages so that vCPUs
do not have to take expensive write-protection faults to split huge
pages.

Huge page splitting is best-effort only. This commit only adds the
support for the TDP MMU, and even there splitting may fail due to out
of memory conditions. Failures to split a huge page is fine from a
correctness standpoint because we still always follow it up by write-
protecting any remaining huge pages.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/mmu/mmu.c          |  14 +++
 arch/x86/kvm/mmu/spte.c         |  59 ++++++++++++
 arch/x86/kvm/mmu/spte.h         |   1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 165 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   5 +
 arch/x86/kvm/x86.c              |  10 ++
 7 files changed, 257 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e863d569c89a..4a507109e886 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1573,6 +1573,9 @@ void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      const struct kvm_memory_slot *memslot,
 				      int start_level);
+void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
+				       const struct kvm_memory_slot *memslot,
+				       int target_level);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c2cb4dd1f11..9116c6a4ced1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5807,6 +5807,20 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
+void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
+				       const struct kvm_memory_slot *memslot,
+				       int target_level)
+{
+	u64 start = memslot->base_gfn;
+	u64 end = start + memslot->npages;
+
+	if (is_tdp_mmu_enabled(kvm)) {
+		read_lock(&kvm->mmu_lock);
+		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level);
+		read_unlock(&kvm->mmu_lock);
+	}
+}
+
 static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 					 struct kvm_rmap_head *rmap_head,
 					 const struct kvm_memory_slot *slot)
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index fd34ae5d6940..11d0b3993ba5 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -191,6 +191,65 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
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
+ * Construct an SPTE that maps a sub-page of the given huge page SPTE where
+ * `index` identifies which sub-page.
+ *
+ * This is used during huge page splitting to build the SPTEs that make up the
+ * new page table.
+ */
+u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index, unsigned int access)
+{
+	u64 child_spte;
+	int child_level;
+
+	if (WARN_ON(is_mmio_spte(huge_spte)))
+		return 0;
+
+	if (WARN_ON(!is_shadow_present_pte(huge_spte)))
+		return 0;
+
+	if (WARN_ON(!is_large_pte(huge_spte)))
+		return 0;
+
+	child_spte = huge_spte;
+	child_level = huge_level - 1;
+
+	/*
+	 * The child_spte already has the base address of the huge page being
+	 * split. So we just have to OR in the offset to the page at the next
+	 * lower level for the given index.
+	 */
+	child_spte |= (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
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
index 9b0c7b27f23f..e13f335b4fef 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -334,6 +334,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
+u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index, unsigned int access);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a8354d8578f1..be5eb74ac053 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1264,6 +1264,171 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
+static struct kvm_mmu_page *alloc_tdp_mmu_page_from_kernel(gfp_t gfp)
+{
+	struct kvm_mmu_page *sp;
+
+	gfp |= __GFP_ZERO;
+
+	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
+	if (!sp)
+		return NULL;
+
+	sp->spt = (void *)__get_free_page(gfp);
+	if (!sp->spt) {
+		kmem_cache_free(mmu_page_header_cache, sp);
+		return NULL;
+	}
+
+	return sp;
+}
+
+static struct kvm_mmu_page *alloc_tdp_mmu_page_for_split(struct kvm *kvm, bool *dropped_lock)
+{
+	struct kvm_mmu_page *sp;
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	*dropped_lock = false;
+
+	/*
+	 * Since we are allocating while under the MMU lock we have to be
+	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
+	 * reclaim and to avoid making any filesystem callbacks (which can end
+	 * up invoking KVM MMU notifiers, resulting in a deadlock).
+	 *
+	 * If this allocation fails we drop the lock and retry with reclaim
+	 * allowed.
+	 */
+	sp = alloc_tdp_mmu_page_from_kernel(GFP_NOWAIT | __GFP_ACCOUNT);
+	if (sp)
+		return sp;
+
+	rcu_read_unlock();
+	read_unlock(&kvm->mmu_lock);
+
+	*dropped_lock = true;
+
+	sp = alloc_tdp_mmu_page_from_kernel(GFP_KERNEL_ACCOUNT);
+
+	read_lock(&kvm->mmu_lock);
+	rcu_read_lock();
+
+	return sp;
+}
+
+static bool
+tdp_mmu_split_huge_page_atomic(struct kvm *kvm, struct tdp_iter *iter, struct kvm_mmu_page *sp)
+{
+	const u64 huge_spte = iter->old_spte;
+	const int level = iter->level;
+	u64 child_spte;
+	int i;
+
+	init_child_tdp_mmu_page(sp, iter);
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+		child_spte = make_huge_page_split_spte(huge_spte, level, i, ACC_ALL);
+
+		/*
+		 * No need for atomics since child_sp has not been installed
+		 * in the table yet and thus is not reachable by any other
+		 * thread.
+		 */
+		sp->spt[i] = child_spte;
+	}
+
+	if (!tdp_mmu_install_sp_atomic(kvm, iter, sp, false))
+		return false;
+
+	/*
+	 * tdp_mmu_install_sp_atomic will handle subtracting the split huge
+	 * page from stats, but we have to manually update the new present child
+	 * pages.
+	 */
+	kvm_update_page_stats(kvm, level - 1, PT64_ENT_PER_PAGE);
+
+	return true;
+}
+
+static int tdp_mmu_split_huge_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
+					 gfn_t start, gfn_t end, int target_level)
+{
+	struct kvm_mmu_page *sp = NULL;
+	struct tdp_iter iter;
+	bool dropped_lock;
+
+	rcu_read_lock();
+
+	/*
+	 * Traverse the page table splitting all huge pages above the target
+	 * level into one lower level. For example, if we encounter a 1GB page
+	 * we split it into 512 2MB pages.
+	 *
+	 * Since the TDP iterator uses a pre-order traversal, we are guaranteed
+	 * to visit an SPTE before ever visiting its children, which means we
+	 * will correctly recursively split huge pages that are more than one
+	 * level above the target level (e.g. splitting 1GB to 2MB to 4KB).
+	 */
+	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
+			continue;
+
+		if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
+			continue;
+
+		if (!sp) {
+			sp = alloc_tdp_mmu_page_for_split(kvm, &dropped_lock);
+			if (!sp)
+				return -ENOMEM;
+
+			if (dropped_lock) {
+				tdp_iter_restart(&iter);
+				continue;
+			}
+		}
+
+		if (!tdp_mmu_split_huge_page_atomic(kvm, &iter, sp))
+			goto retry;
+
+		sp = NULL;
+	}
+
+	/*
+	 * It's possible to exit the loop having never used the last sp if, for
+	 * example, a vCPU doing HugePage NX splitting wins the race and
+	 * installs its own sp in place of the last sp we tried to split.
+	 */
+	if (sp)
+		tdp_mmu_free_sp(sp);
+
+	rcu_read_unlock();
+
+	return 0;
+}
+
+int kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
+				     const struct kvm_memory_slot *slot,
+				     gfn_t start, gfn_t end,
+				     int target_level)
+{
+	struct kvm_mmu_page *root;
+	int r = 0;
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true) {
+		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level);
+		if (r) {
+			kvm_tdp_mmu_put_root(kvm, root, true);
+			break;
+		}
+	}
+
+	return r;
+}
+
 /*
  * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
  * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 3899004a5d91..3557a7fcf927 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -71,6 +71,11 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level);
 
+int kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
+				     const struct kvm_memory_slot *slot,
+				     gfn_t start, gfn_t end,
+				     int target_level);
+
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {
 	rcu_read_lock();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 85127b3e3690..fb5592bf2eee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -187,6 +187,9 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+static bool __read_mostly eagerly_split_huge_pages_for_dirty_logging = true;
+module_param(eagerly_split_huge_pages_for_dirty_logging, bool, 0644);
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
@@ -11837,6 +11840,13 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
 			return;
 
+		/*
+		 * Attempt to split all large pages into 4K pages so that vCPUs
+		 * do not have to take write-protection faults.
+		 */
+		if (READ_ONCE(eagerly_split_huge_pages_for_dirty_logging))
+			kvm_mmu_slot_try_split_huge_pages(kvm, new, PG_LEVEL_4K);
+
 		if (kvm_x86_ops.cpu_dirty_log_size) {
 			kvm_mmu_slot_leaf_clear_dirty(kvm, new);
 			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_2M);
-- 
2.34.1.173.g76aa8bc2d0-goog


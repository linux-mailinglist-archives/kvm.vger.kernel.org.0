Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A9049439D
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbiASXJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245397AbiASXIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:08:12 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A469C061768
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:12 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o72-20020a17090a0a4e00b001b4e5b5b6c0so2740764pjo.5
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XjPgovmtjyh6QrYmFw2GcuVMQcGqsRFhbseVOX6BIwI=;
        b=AKaHiirRkH09K5F7EIdIsbslnrIA8o5U8ZbhSA6jlk63LiZ0JoytCrTtPHG1RH5RKB
         BLSUOYhQEQEMkDVroVggSbuG9iICzP5+UGG0T1d766DzYkZ/ZMGscElWpU8bi46MSvkD
         Ync8/P866UuTWT/AsnLBS7mPYx5J/tBUZI7O0co3ZJHXSWZwpD7wehJ5OCcrAozq0x88
         rXjeRl7gyzNRbg2RnYEiPFZ7u5NJ4vZ+sJowfk2+8fyZk3dLv4KKnnp3j4jJ3VRlo6oF
         wyxH7tCzUM2yHF4AqV0PwVsdwVO3KW3n41y8OGkULmmXAg+dF7qWSboeztHb6vBJlE6g
         Hc9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XjPgovmtjyh6QrYmFw2GcuVMQcGqsRFhbseVOX6BIwI=;
        b=RvCSpWMDNF/G6oB0tH877Ikl3j4oE7r5sjRxKn73N7nsqqFh4ECukgO29nXUEs1zae
         MmbBpc1TwwWRXLdL1NCUpN3FucuFTqNqt/P4L4/9QB+ia39R+xgP4xXZAkbibFNtRpvF
         86kCCK6AXybSPsek/U1i7fndtghOPi/Y1PDp8rgOIgqCnpLtYKcoPDeUzgklTjiAjvTe
         158yMZhQxg+RhhybGF56Cozw74WZGaaRADv0TQbSgizgvPCXzmd+m8dxfho5OaBfvJPK
         yegWVuaMt+cJGk/TR45mAzLpknO84MdR9KfYNbmhWsIaIuxg/kFEniY5nScy+MhwyFWm
         Q9GQ==
X-Gm-Message-State: AOAM530+sWTdKFqTjl5l5HogmYyDfTIyNQexSMxlC7zvVun6uzjbntiD
        PZTfQKLolqtdnPyNLG3AuLSFCO9KKG+ELg==
X-Google-Smtp-Source: ABdhPJy/od0aqU+gfzAdgerrwmYIy+hOwE97AxqI/+NBlY1xsdcuGIt62nygObXISY+W04IX3e8Koruqh/6Aaw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:8cb:b0:4bc:3def:b616 with SMTP
 id s11-20020a056a0008cb00b004bc3defb616mr33093699pfu.18.1642633692082; Wed,
 19 Jan 2022 15:08:12 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:36 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-16-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 15/18] KVM: x86/mmu: Split huge pages mapped by the TDP MMU
 when dirty logging is enabled
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

When dirty logging is enabled without initially-all-set, try to split
all huge pages in the memslot down to 4KB pages so that vCPUs do not
have to take expensive write-protection faults to split huge pages.

Eager page splitting is best-effort only. This commit only adds the
support for the TDP MMU, and even there splitting may fail due to out
of memory conditions. Failures to split a huge page is fine from a
correctness standpoint because KVM will always follow up splitting by
write-protecting any remaining huge pages.

Eager page splitting moves the cost of splitting huge pages off of the
vCPU threads and onto the thread enabling dirty logging on the memslot.
This is useful because:

 1. Splitting on the vCPU thread interrupts vCPUs execution and is
    disruptive to customers whereas splitting on VM ioctl threads can
    run in parallel with vCPU execution.

 2. Splitting all huge pages at once is more efficient because it does
    not require performing VM-exit handling or walking the page table for
    every 4KiB page in the memslot, and greatly reduces the amount of
    contention on the mmu_lock.

For example, when running dirty_log_perf_test with 96 virtual CPUs, 1GiB
per vCPU, and 1GiB HugeTLB memory, the time it takes vCPUs to write to
all of their memory after dirty logging is enabled decreased by 95% from
2.94s to 0.14s.

Eager Page Splitting is over 100x more efficient than the current
implementation of splitting on fault under the read lock. For example,
taking the same workload as above, Eager Page Splitting reduced the CPU
required to split all huge pages from ~270 CPU-seconds ((2.94s - 0.14s)
* 96 vCPU threads) to only 1.55 CPU-seconds.

Eager page splitting does increase the amount of time it takes to enable
dirty logging since it has split all huge pages. For example, the time
it took to enable dirty logging in the 96GiB region of the
aforementioned test increased from 0.001s to 1.55s.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  24 +++
 arch/x86/include/asm/kvm_host.h               |   3 +
 arch/x86/kvm/mmu/mmu.c                        |  24 +++
 arch/x86/kvm/mmu/spte.c                       |  59 ++++++
 arch/x86/kvm/mmu/spte.h                       |   1 +
 arch/x86/kvm/mmu/tdp_mmu.c                    | 173 ++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h                    |   5 +
 arch/x86/kvm/x86.c                            |   6 +
 8 files changed, 295 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 86a2456d94ba..f5e9c4a45aef 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2330,6 +2330,30 @@
 	kvm.ignore_msrs=[KVM] Ignore guest accesses to unhandled MSRs.
 			Default is 0 (don't ignore, but inject #GP)
 
+	kvm.eager_page_split=
+			[KVM,X86] Controls whether or not KVM will try to
+			proactively split all huge pages during dirty logging.
+			Eager page splitting reduces interruptions to vCPU
+			execution by eliminating the write-protection faults
+			and MMU lock contention that would otherwise be
+			required to split huge pages lazily.
+
+			VM workloads that rarely perform writes or that write
+			only to a small region of VM memory may benefit from
+			disabling eager page splitting to allow huge pages to
+			still be used for reads.
+
+			The behavior of eager page splitting depends on whether
+			KVM_DIRTY_LOG_INITIALLY_SET is enabled or disabled. If
+			disabled, all huge pages in a memslot will be eagerly
+			split when dirty logging is enabled on that memslot. If
+			enabled, huge pages will not be eagerly split.
+
+			Eager page splitting currently only supports splitting
+			huge pages mapped by the TDP MMU.
+
+			Default is Y (on).
+
 	kvm.enable_vmware_backdoor=[KVM] Support VMware backdoor PV interface.
 				   Default is false (don't support).
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 682ad02a4e58..97560980456d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1579,6 +1579,9 @@ void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
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
index 51aa38bdb858..a273536e8b25 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5834,6 +5834,30 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
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
+
+	/*
+	 * No TLB flush is necessary here. KVM will flush TLBs after
+	 * write-protecting and/or clearing dirty on the newly split SPTEs to
+	 * ensure that guest writes are reflected in the dirty log before the
+	 * ioctl to enable dirty logging on this memslot completes. Since the
+	 * split SPTEs retain the write and dirty bits of the huge SPTE, it is
+	 * safe for KVM to decide if a TLB flush is necessary based on the split
+	 * SPTEs.
+	 */
+}
+
 static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 					 struct kvm_rmap_head *rmap_head,
 					 const struct kvm_memory_slot *slot)
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index f8677404c93c..17f226bb8ec2 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -191,6 +191,65 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return wrprot;
 }
 
+static u64 make_spte_executable(u64 spte)
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
+u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
+{
+	u64 child_spte;
+	int child_level;
+
+	if (WARN_ON_ONCE(!is_shadow_present_pte(huge_spte)))
+		return 0;
+
+	if (WARN_ON_ONCE(!is_large_pte(huge_spte)))
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
+		/*
+		 * When splitting to a 4K page, mark the page executable as the
+		 * NX hugepage mitigation no longer applies.
+		 */
+		if (is_nx_huge_page_enabled())
+			child_spte = make_spte_executable(child_spte);
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
index e8ac1fab3185..9d6bb74bbb54 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -364,6 +364,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
+u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b526a1873f30..88f723fc0d1f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1242,6 +1242,179 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
+static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
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
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
+						       struct tdp_iter *iter)
+{
+	struct kvm_mmu_page *sp;
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
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
+	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	if (sp)
+		return sp;
+
+	rcu_read_unlock();
+	read_unlock(&kvm->mmu_lock);
+
+	iter->yielded = true;
+	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+
+	read_lock(&kvm->mmu_lock);
+	rcu_read_lock();
+
+	return sp;
+}
+
+static int tdp_mmu_split_huge_page_atomic(struct kvm *kvm,
+					  struct tdp_iter *iter,
+					  struct kvm_mmu_page *sp)
+{
+	const u64 huge_spte = iter->old_spte;
+	const int level = iter->level;
+	int ret, i;
+
+	tdp_mmu_init_child_sp(sp, iter);
+
+	/*
+	 * No need for atomics when writing to sp->spt since the page table has
+	 * not been linked in yet and thus is not reachable from any other CPU.
+	 */
+	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
+		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+
+	/*
+	 * Replace the huge spte with a pointer to the populated lower level
+	 * page table. Since we are making this change without a TLB flush vCPUs
+	 * will see a mix of the split mappings and the original huge mapping,
+	 * depending on what's currently in their TLB. This is fine from a
+	 * correctness standpoint since the translation will be the same either
+	 * way.
+	 */
+	ret = tdp_mmu_link_sp_atomic(kvm, iter, sp, false);
+	if (ret)
+		return ret;
+
+	/*
+	 * tdp_mmu_link_sp_atomic() will handle subtracting the huge page we
+	 * are overwriting from the page stats. But we have to manually update
+	 * the page stats with the new present child pages.
+	 */
+	kvm_update_page_stats(kvm, level - 1, PT64_ENT_PER_PAGE);
+
+	return 0;
+}
+
+static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
+					 struct kvm_mmu_page *root,
+					 gfn_t start, gfn_t end,
+					 int target_level)
+{
+	struct kvm_mmu_page *sp = NULL;
+	struct tdp_iter iter;
+	int ret = 0;
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
+	 * level above the target level (e.g. splitting a 1GB to 512 2MB pages,
+	 * and then splitting each of those to 512 4KB pages).
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
+			sp = tdp_mmu_alloc_sp_for_split(kvm, &iter);
+			if (!sp) {
+				ret = -ENOMEM;
+				break;
+			}
+
+			if (iter.yielded)
+				continue;
+		}
+
+		if (tdp_mmu_split_huge_page_atomic(kvm, &iter, sp))
+			goto retry;
+
+		sp = NULL;
+	}
+
+	rcu_read_unlock();
+
+	/*
+	 * It's possible to exit the loop having never used the last sp if, for
+	 * example, a vCPU doing HugePage NX splitting wins the race and
+	 * installs its own sp in place of the last sp we tried to split.
+	 */
+	if (sp)
+		tdp_mmu_free_sp(sp);
+
+
+	return ret;
+}
+
+/*
+ * Try to split all huge pages mapped by the TDP MMU down to the target level.
+ */
+void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
+				      const struct kvm_memory_slot *slot,
+				      gfn_t start, gfn_t end,
+				      int target_level)
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
+}
+
 /*
  * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
  * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 3899004a5d91..4a8756507829 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -71,6 +71,11 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level);
 
+void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
+				      const struct kvm_memory_slot *slot,
+				      gfn_t start, gfn_t end,
+				      int target_level);
+
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {
 	rcu_read_lock();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55518b7d3b96..f5aad3e8e0a0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -192,6 +192,9 @@ bool __read_mostly enable_pmu = true;
 EXPORT_SYMBOL_GPL(enable_pmu);
 module_param(enable_pmu, bool, 0444);
 
+static bool __read_mostly eager_page_split = true;
+module_param(eager_page_split, bool, 0644);
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
@@ -11948,6 +11951,9 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
 			return;
 
+		if (READ_ONCE(eager_page_split))
+			kvm_mmu_slot_try_split_huge_pages(kvm, new, PG_LEVEL_4K);
+
 		if (kvm_x86_ops.cpu_dirty_log_size) {
 			kvm_mmu_slot_leaf_clear_dirty(kvm, new);
 			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_2M);
-- 
2.35.0.rc0.227.g00780c9af4-goog


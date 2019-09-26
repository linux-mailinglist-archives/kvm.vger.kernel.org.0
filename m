Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 944ABBFBC9
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbfIZXSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:44 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:36810 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728923AbfIZXSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:43 -0400
Received: by mail-qt1-f202.google.com with SMTP id i10so4045440qtq.3
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PwnyhLkA6u7J7PG1BVddDEJ6Txr1VsKczG8arla6GfI=;
        b=N9A4UBioedxIVi3yP6mx0HQykLcAWDHh7FVzyTwf7rDTA0n6mwIjbKFjAaJ2JdDdi/
         lv4pWqShSL4aHMMzU7K+quePauYCGRFIp+bTqM1nEQqQwuwYiTx+QwW79N3pzIfz+KJC
         oyryd3kzhZM4qRLKm10DudQYSrLPkLmVIVMey3Z/rChnB/elV3XbN1pmcjxKSNMyfINc
         2hUgEZEsxRrJSRyzHESxbjkOzOYsCQ2jLlhhezhRAAqysu2RYOFtz2cWAbGlCVS0c6Tr
         WjQjAe5h2kbi8EY/LZwx0GzvQhfF4+9XXprvsf3ooCZ6h8uCuvTkbGenYKOqiDs2qnte
         uRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PwnyhLkA6u7J7PG1BVddDEJ6Txr1VsKczG8arla6GfI=;
        b=Glp0od9AzYSVi1Mi82JzEOPdDkTTv1ymPproYqvafQyy80Gzh7sHQeaxTLEzJ8GR1Z
         +Z9b6GvzhxCi8v+Fxg51w3p7oL5YEO3fHclK8NeBgAsKOzmJCA9ic7BavmyjuwU7p0lG
         Nz75tMBCnLR9RNmOmUSmBqZ0XYAPlZocUwB01qWhL9POI3AzwFD6hu9fy1uFf74kTTBO
         uq13uMCJsg1PmfEmC8xX/stzL42Km528fdJ05+aes6qh1DC9sTFWVTVTMK0B+zmHKUBL
         YFwisrcQ+8KAkXJ0tgadA+Jr/SyCVGjh1/b50zVM/odpq4+BwA3R+9gEA2eoNBnvJE7I
         Y+kg==
X-Gm-Message-State: APjAAAXBVnxkxAVFv1sppFNUPmtDrrOEpX+gxVnj8LWtJuyxM7jg7INs
        07kuwmnYCg/6NxAeeTVe7uHAv4zfGbTDbvdWxQ7Pg5PcRfIWIc624YOrd2pTRzB3GYKFs1ChjTw
        TIcfE95A3D8zZr80lmhyFN2k/iKZVrQiWnXCWcgC+n1+mTtO6/nnteMc6lItf
X-Google-Smtp-Source: APXvYqwTo4zQcJI8UygdkVON6I9fIXV5H0L9NvdB/yJxNXAT7f+xk3F2exv83KlVILSHZmqWPahJeMuvoEb9
X-Received: by 2002:aed:3fe9:: with SMTP id w38mr7103979qth.180.1569539921785;
 Thu, 26 Sep 2019 16:18:41 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:02 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-7-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 06/28] kvm: mmu: Replace mmu_lock with a read/write lock
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the KVM MMU spinlock with a read/write lock so that some parts of
the MMU can be made more concurrent in future commits by switching some
write mode aquisitions to read mode. A read/write lock was chosen over
other synchronization options beause it has minimal initial impact: this
change simply changes all uses of the MMU spin lock to an MMU read/write
lock, in write mode. This change has no effect on the logic of the code
and only a small performance penalty.

Other, more invasive options were considered for synchronizing access to
the paging structures. Sharding the MMU lock to protect 2MB chunks of
addresses, as the main MM does, would also work, however it makes
acquiring locks for operations on large regions of memory expensive.
Further, the parallel page fault handling algorithm introduced later in
this series does not require exclusive access to the region of memory
for which it is handling a fault.

There are several disadvantages to the read/write lock approach:
1. The reader/writer terminology does not apply well to MMU operations.
2. Many operations require exclusive access to a region of memory
(often a memslot), but not all of memory. The read/write lock does not
facilitate this.
3. Contention between readers and writers can still create problems in
the face of long running MMU operations.

Despite these issues,the use of a read/write lock facilitates
substantial improvements over the monolithic locking scheme.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c         | 106 +++++++++++++++++++------------------
 arch/x86/kvm/page_track.c  |   8 +--
 arch/x86/kvm/paging_tmpl.h |   8 +--
 arch/x86/kvm/x86.c         |   4 +-
 include/linux/kvm_host.h   |   3 +-
 virt/kvm/kvm_main.c        |  34 ++++++------
 6 files changed, 83 insertions(+), 80 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 56587655aecb9..0311d18d9a995 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2446,9 +2446,9 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 			flush |= kvm_sync_page(vcpu, sp, &invalid_list);
 			mmu_pages_clear_parents(&parents);
 		}
-		if (need_resched() || spin_needbreak(&vcpu->kvm->mmu_lock)) {
+		if (need_resched()) {
 			kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
-			cond_resched_lock(&vcpu->kvm->mmu_lock);
+			cond_resched_rwlock_write(&vcpu->kvm->mmu_lock);
 			flush = false;
 		}
 	}
@@ -2829,7 +2829,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_pages)
 {
 	LIST_HEAD(invalid_list);
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	if (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages) {
 		/* Need to free some mmu pages to achieve the goal. */
@@ -2843,7 +2843,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_pages)
 
 	kvm->arch.n_max_mmu_pages = goal_nr_mmu_pages;
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
@@ -2854,7 +2854,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 
 	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
 	r = 0;
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
 			 sp->role.word);
@@ -2862,7 +2862,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 	}
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	return r;
 }
@@ -3578,7 +3578,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 		return r;
 
 	r = RET_PF_RETRY;
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 	if (make_mmu_pages_available(vcpu) < 0)
@@ -3586,8 +3586,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
 	r = __direct_map(vcpu, v, write, map_writable, level, pfn, prefault);
+
 out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
 	return r;
 }
@@ -3629,7 +3630,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			return;
 	}
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		if (roots_to_free & KVM_MMU_ROOT_PREVIOUS(i))
@@ -3653,7 +3654,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	}
 
 	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
 
@@ -3675,31 +3676,31 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	unsigned i;
 
 	if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
-		spin_lock(&vcpu->kvm->mmu_lock);
+		write_lock(&vcpu->kvm->mmu_lock);
 		if(make_mmu_pages_available(vcpu) < 0) {
-			spin_unlock(&vcpu->kvm->mmu_lock);
+			write_unlock(&vcpu->kvm->mmu_lock);
 			return -ENOSPC;
 		}
 		sp = kvm_mmu_get_page(vcpu, 0, 0,
 				vcpu->arch.mmu->shadow_root_level, 1, ACC_ALL);
 		++sp->root_count;
-		spin_unlock(&vcpu->kvm->mmu_lock);
+		write_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu->root_hpa = __pa(sp->spt);
 	} else if (vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
 			hpa_t root = vcpu->arch.mmu->pae_root[i];
 
 			MMU_WARN_ON(VALID_PAGE(root));
-			spin_lock(&vcpu->kvm->mmu_lock);
+			write_lock(&vcpu->kvm->mmu_lock);
 			if (make_mmu_pages_available(vcpu) < 0) {
-				spin_unlock(&vcpu->kvm->mmu_lock);
+				write_unlock(&vcpu->kvm->mmu_lock);
 				return -ENOSPC;
 			}
 			sp = kvm_mmu_get_page(vcpu, i << (30 - PAGE_SHIFT),
 					i << 30, PT32_ROOT_LEVEL, 1, ACC_ALL);
 			root = __pa(sp->spt);
 			++sp->root_count;
-			spin_unlock(&vcpu->kvm->mmu_lock);
+			write_unlock(&vcpu->kvm->mmu_lock);
 			vcpu->arch.mmu->pae_root[i] = root | PT_PRESENT_MASK;
 		}
 		vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
@@ -3732,16 +3733,16 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 
 		MMU_WARN_ON(VALID_PAGE(root));
 
-		spin_lock(&vcpu->kvm->mmu_lock);
+		write_lock(&vcpu->kvm->mmu_lock);
 		if (make_mmu_pages_available(vcpu) < 0) {
-			spin_unlock(&vcpu->kvm->mmu_lock);
+			write_unlock(&vcpu->kvm->mmu_lock);
 			return -ENOSPC;
 		}
 		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
 				vcpu->arch.mmu->shadow_root_level, 0, ACC_ALL);
 		root = __pa(sp->spt);
 		++sp->root_count;
-		spin_unlock(&vcpu->kvm->mmu_lock);
+		write_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu->root_hpa = root;
 		goto set_root_cr3;
 	}
@@ -3769,16 +3770,16 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			if (mmu_check_root(vcpu, root_gfn))
 				return 1;
 		}
-		spin_lock(&vcpu->kvm->mmu_lock);
+		write_lock(&vcpu->kvm->mmu_lock);
 		if (make_mmu_pages_available(vcpu) < 0) {
-			spin_unlock(&vcpu->kvm->mmu_lock);
+			write_unlock(&vcpu->kvm->mmu_lock);
 			return -ENOSPC;
 		}
 		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30, PT32_ROOT_LEVEL,
 				      0, ACC_ALL);
 		root = __pa(sp->spt);
 		++sp->root_count;
-		spin_unlock(&vcpu->kvm->mmu_lock);
+		write_unlock(&vcpu->kvm->mmu_lock);
 
 		vcpu->arch.mmu->pae_root[i] = root | pm_mask;
 	}
@@ -3854,17 +3855,17 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		    !smp_load_acquire(&sp->unsync_children))
 			return;
 
-		spin_lock(&vcpu->kvm->mmu_lock);
+		write_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 
 		mmu_sync_children(vcpu, sp);
 
 		kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
-		spin_unlock(&vcpu->kvm->mmu_lock);
+		write_unlock(&vcpu->kvm->mmu_lock);
 		return;
 	}
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 
 	for (i = 0; i < 4; ++i) {
@@ -3878,7 +3879,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	}
 
 	kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_sync_roots);
 
@@ -4204,7 +4205,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		return r;
 
 	r = RET_PF_RETRY;
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 	if (make_mmu_pages_available(vcpu) < 0)
@@ -4212,8 +4213,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
 	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn, prefault);
+
 out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
 	return r;
 }
@@ -5338,7 +5340,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	 */
 	mmu_topup_memory_caches(vcpu);
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 
 	gentry = mmu_pte_write_fetch_gpte(vcpu, &gpa, &bytes);
 
@@ -5374,7 +5376,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	}
 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, remote_flush, local_flush);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
@@ -5581,14 +5583,14 @@ slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		if (iterator.rmap)
 			flush |= fn(kvm, iterator.rmap);
 
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		if (need_resched()) {
 			if (flush && lock_flush_tlb) {
 				kvm_flush_remote_tlbs_with_address(kvm,
 						start_gfn,
 						iterator.gfn - start_gfn + 1);
 				flush = false;
 			}
-			cond_resched_lock(&kvm->mmu_lock);
+			cond_resched_rwlock_write(&kvm->mmu_lock);
 		}
 	}
 
@@ -5738,7 +5740,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 		 * be in active use by the guest.
 		 */
 		if (batch >= BATCH_ZAP_PAGES &&
-		    cond_resched_lock(&kvm->mmu_lock)) {
+		    cond_resched_rwlock_write(&kvm->mmu_lock)) {
 			batch = 0;
 			goto restart;
 		}
@@ -5771,7 +5773,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 {
 	lockdep_assert_held(&kvm->slots_lock);
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	trace_kvm_mmu_zap_all_fast(kvm);
 
 	/*
@@ -5794,7 +5796,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	kvm_reload_remote_mmus(kvm);
 
 	kvm_zap_obsolete_pages(kvm);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
@@ -5831,7 +5833,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	struct kvm_memory_slot *memslot;
 	int i;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
 		kvm_for_each_memslot(memslot, slots) {
@@ -5848,7 +5850,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		}
 	}
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 static bool slot_rmap_write_protect(struct kvm *kvm,
@@ -5862,10 +5864,10 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
 				      false);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	/*
 	 * kvm_mmu_slot_remove_write_access() and kvm_vm_ioctl_get_dirty_log()
@@ -5933,10 +5935,10 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot)
 {
 	/* FIXME: const-ify all uses of struct kvm_memory_slot.  */
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	slot_handle_leaf(kvm, (struct kvm_memory_slot *)memslot,
 			 kvm_mmu_zap_collapsible_spte, true);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
@@ -5944,9 +5946,9 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	lockdep_assert_held(&kvm->slots_lock);
 
@@ -5967,10 +5969,10 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_large_level(kvm, memslot, slot_rmap_write_protect,
 					false);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	/* see kvm_mmu_slot_remove_write_access */
 	lockdep_assert_held(&kvm->slots_lock);
@@ -5986,9 +5988,9 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	lockdep_assert_held(&kvm->slots_lock);
 
@@ -6005,19 +6007,19 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	LIST_HEAD(invalid_list);
 	int ign;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
 		if (sp->role.invalid && sp->root_count)
 			continue;
 		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
 			goto restart;
-		if (cond_resched_lock(&kvm->mmu_lock))
+		if (cond_resched_rwlock_write(&kvm->mmu_lock))
 			goto restart;
 	}
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
@@ -6077,7 +6079,7 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 			continue;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		spin_lock(&kvm->mmu_lock);
+		write_lock(&kvm->mmu_lock);
 
 		if (kvm_has_zapped_obsolete_pages(kvm)) {
 			kvm_mmu_commit_zap_page(kvm,
@@ -6090,7 +6092,7 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
 unlock:
-		spin_unlock(&kvm->mmu_lock);
+		write_unlock(&kvm->mmu_lock);
 		srcu_read_unlock(&kvm->srcu, idx);
 
 		/*
diff --git a/arch/x86/kvm/page_track.c b/arch/x86/kvm/page_track.c
index 3521e2d176f2f..a43f4fa020db2 100644
--- a/arch/x86/kvm/page_track.c
+++ b/arch/x86/kvm/page_track.c
@@ -188,9 +188,9 @@ kvm_page_track_register_notifier(struct kvm *kvm,
 
 	head = &kvm->arch.track_notifier_head;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	hlist_add_head_rcu(&n->node, &head->track_notifier_list);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_register_notifier);
 
@@ -206,9 +206,9 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
 
 	head = &kvm->arch.track_notifier_head;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	hlist_del_rcu(&n->node);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	synchronize_srcu(&head->track_srcu);
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7d5cdb3af5943..97903c8dcad16 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -841,7 +841,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	}
 
 	r = RET_PF_RETRY;
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 
@@ -855,7 +855,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
 	return r;
 }
@@ -892,7 +892,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 		return;
 	}
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 	for_each_shadow_entry_using_root(vcpu, root_hpa, gva, iterator) {
 		level = iterator.level;
 		sptep = iterator.sptep;
@@ -925,7 +925,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
 			break;
 	}
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ed07d8d2caa0..9ecf83da396c9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6376,9 +6376,9 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
 	if (vcpu->arch.mmu->direct_map) {
 		unsigned int indirect_shadow_pages;
 
-		spin_lock(&vcpu->kvm->mmu_lock);
+		write_lock(&vcpu->kvm->mmu_lock);
 		indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
-		spin_unlock(&vcpu->kvm->mmu_lock);
+		write_unlock(&vcpu->kvm->mmu_lock);
 
 		if (indirect_shadow_pages)
 			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fcb46b3374c60..baed80f8a7f00 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -441,7 +441,8 @@ struct kvm_memslots {
 };
 
 struct kvm {
-	spinlock_t mmu_lock;
+	rwlock_t mmu_lock;
+
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e6de3159e682f..9ce067b6882b7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -356,13 +356,13 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	kvm->mmu_notifier_seq++;
 
 	if (kvm_set_spte_hva(kvm, address, pte))
 		kvm_flush_remote_tlbs(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -374,7 +374,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	int ret;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	/*
 	 * The count increase must become visible at unlock time as no
 	 * spte can be established without taking the mmu_lock and
@@ -387,7 +387,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	if (need_tlb_flush)
 		kvm_flush_remote_tlbs(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	ret = kvm_arch_mmu_notifier_invalidate_range(kvm, range->start,
 					range->end,
@@ -403,7 +403,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	/*
 	 * This sequence increase will notify the kvm page fault that
 	 * the page that is going to be mapped in the spte could have
@@ -417,7 +417,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	 * in conjunction with the smp_rmb in mmu_notifier_retry().
 	 */
 	kvm->mmu_notifier_count--;
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	BUG_ON(kvm->mmu_notifier_count < 0);
 }
@@ -431,13 +431,13 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	int young, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	young = kvm_age_hva(kvm, start, end);
 	if (young)
 		kvm_flush_remote_tlbs(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
@@ -452,7 +452,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	int young, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	/*
 	 * Even though we do not flush TLB, this will still adversely
 	 * affect performance on pre-Haswell Intel EPT, where there is
@@ -467,7 +467,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * more sophisticated heuristic later.
 	 */
 	young = kvm_age_hva(kvm, start, end);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
@@ -481,9 +481,9 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	int young, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	young = kvm_test_age_hva(kvm, address);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
@@ -632,7 +632,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
-	spin_lock_init(&kvm->mmu_lock);
+	rwlock_init(&kvm->mmu_lock);
 	mmgrab(current->mm);
 	kvm->mm = current->mm;
 	kvm_eventfd_init(kvm);
@@ -1193,7 +1193,7 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 		dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
 		memset(dirty_bitmap_buffer, 0, n);
 
-		spin_lock(&kvm->mmu_lock);
+		write_lock(&kvm->mmu_lock);
 		for (i = 0; i < n / sizeof(long); i++) {
 			unsigned long mask;
 			gfn_t offset;
@@ -1209,7 +1209,7 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
 		}
-		spin_unlock(&kvm->mmu_lock);
+		write_unlock(&kvm->mmu_lock);
 	}
 
 	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
@@ -1263,7 +1263,7 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
 		return -EFAULT;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	for (offset = log->first_page, i = offset / BITS_PER_LONG,
 		 n = DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
 	     i++, offset += BITS_PER_LONG) {
@@ -1286,7 +1286,7 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 								offset, mask);
 		}
 	}
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	return 0;
 }
-- 
2.23.0.444.g18eeb5a265-goog


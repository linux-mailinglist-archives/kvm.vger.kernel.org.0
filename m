Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF94930CB31
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhBBTPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239315AbhBBTBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:01:50 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FE5C0611C3
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:11 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z3so14131905pfj.3
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=SGEmEAOkonOeY//vvlD5pwUR/L9cbqKIAPZrPaHHSAA=;
        b=rLFpqPW2++uiwbs8DScIia5KmQ/LWwgSG65kx7WtbZxEAPCp7j6G8Lw7nF2doj+3Fh
         HUsGMqmjczwB9uG7dfY8EJ4vAHA6TI1beGGw84mNdMIH18pHNrlQZc0ac7QfCcC1z/U+
         FqCfJmrwRPufganyO1g4J3QLHZdWXiq0b4P6kOmz1xcvmvbjKQFQgikoO9dplD9pgQm/
         YrpyQfXlvBZ4DzsjPd8QrdZoUJvgkX22G2M6Xk0KLNr9FoT4R5PWGdG/bGr30e+nHi0r
         +PIVHY4q09hpKXq2F+RrCtQOOx/pQucPr0js9ZsjQHKvc8b4j0BQ54U5mqmUO4igbgeG
         3DgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SGEmEAOkonOeY//vvlD5pwUR/L9cbqKIAPZrPaHHSAA=;
        b=sl6ZvWOcUqhSGzVTVShZlhnNtqKETpAc3tcTyYKacxVphRO/VsJp5GmjW8JWILVhp5
         TDilNNinDwQQgloCC+ET4FOJog8BD05B7WhwRCom0adCmSExUuHd+wy73dZaxF+N9Bdr
         0gd9WIwcBa0U/NUFJ03I/znyQE4sSgUgnYYnz1JGNNNcRrMTvEPtPTjAWJuF2j007LJX
         xHFZzOgJQrJBz3tcGw+mY37FzSpkgurT9bFdcrk7XA6NLg9xKN/3CVEEL2BHMIdgI+YF
         /aJd8l0HvgIRn3N4cmHWPACxglY0HeU0HmUPATGEKxVP7+NMQspLvcWj6h6kfv3D/mbA
         5o1Q==
X-Gm-Message-State: AOAM530ZN0nHBwXzogltMaa7zIOCkhO3tyJwe86O3knlBgH39hPswe3l
        4DSfZKZtyl5NHyODBIeN98QY7IZC1lBS
X-Google-Smtp-Source: ABdhPJwxylqU6vPiDAJ030SBBCDz8KKpTxXZcrTnOUmcLhIvHsaSkyR+MZzwuF4uzlI+cKB5vZ+PTEl3UZDK
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a17:90a:8d83:: with SMTP id
 d3mr614627pjo.0.1612292290910; Tue, 02 Feb 2021 10:58:10 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:24 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-19-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 18/28] KVM: x86/mmu: Use an rwlock for the x86 MMU
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

Add a read / write lock to be used in place of the MMU spinlock on x86.
The rwlock will enable the TDP MMU to handle page faults, and other
operations in parallel in future commits.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

---

v1 -> v2
- Removed MMU lock wrappers
- Completely replaced the MMU spinlock with an rwlock for x86

 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/mmu/mmu.c          | 90 ++++++++++++++++-----------------
 arch/x86/kvm/mmu/page_track.c   |  8 +--
 arch/x86/kvm/mmu/paging_tmpl.h  |  8 +--
 arch/x86/kvm/mmu/tdp_mmu.c      | 20 ++++----
 arch/x86/kvm/x86.c              |  4 +-
 include/linux/kvm_host.h        |  5 ++
 virt/kvm/dirty_ring.c           | 10 ++++
 virt/kvm/kvm_main.c             | 46 +++++++++++------
 9 files changed, 112 insertions(+), 81 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d6616f6f6ef..b6ebf2558386 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -337,6 +337,8 @@ struct kvm_mmu_root_info {
 
 #define KVM_MMU_NUM_PREV_ROOTS 3
 
+#define KVM_HAVE_MMU_RWLOCK
+
 struct kvm_mmu_page;
 
 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 60ff6837655a..b4d6709c240e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2016,9 +2016,9 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 			flush |= kvm_sync_page(vcpu, sp, &invalid_list);
 			mmu_pages_clear_parents(&parents);
 		}
-		if (need_resched() || spin_needbreak(&vcpu->kvm->mmu_lock)) {
+		if (need_resched() || rwlock_needbreak(&vcpu->kvm->mmu_lock)) {
 			kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
-			cond_resched_lock(&vcpu->kvm->mmu_lock);
+			cond_resched_rwlock_write(&vcpu->kvm->mmu_lock);
 			flush = false;
 		}
 	}
@@ -2470,7 +2470,7 @@ static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
  */
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_pages)
 {
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	if (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages) {
 		kvm_mmu_zap_oldest_mmu_pages(kvm, kvm->arch.n_used_mmu_pages -
@@ -2481,7 +2481,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_pages)
 
 	kvm->arch.n_max_mmu_pages = goal_nr_mmu_pages;
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
@@ -2492,7 +2492,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 
 	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
 	r = 0;
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
 			 sp->role.word);
@@ -2500,7 +2500,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 	}
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	return r;
 }
@@ -3192,7 +3192,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			return;
 	}
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		if (roots_to_free & KVM_MMU_ROOT_PREVIOUS(i))
@@ -3215,7 +3215,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	}
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
 
@@ -3236,16 +3236,16 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 {
 	struct kvm_mmu_page *sp;
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 
 	if (make_mmu_pages_available(vcpu)) {
-		spin_unlock(&vcpu->kvm->mmu_lock);
+		write_unlock(&vcpu->kvm->mmu_lock);
 		return INVALID_PAGE;
 	}
 	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
 	++sp->root_count;
 
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 	return __pa(sp->spt);
 }
 
@@ -3416,17 +3416,17 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
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
@@ -3440,7 +3440,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	}
 
 	kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_sync_roots);
 
@@ -3724,7 +3724,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		return r;
 
 	r = RET_PF_RETRY;
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
@@ -3739,7 +3739,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 				 prefault, is_tdp);
 
 out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
 	return r;
 }
@@ -4999,7 +4999,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	 */
 	mmu_topup_memory_caches(vcpu, true);
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 
 	gentry = mmu_pte_write_fetch_gpte(vcpu, &gpa, &bytes);
 
@@ -5035,7 +5035,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	}
 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, remote_flush, local_flush);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
@@ -5233,14 +5233,14 @@ slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		if (iterator.rmap)
 			flush |= fn(kvm, iterator.rmap);
 
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
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
 
@@ -5390,7 +5390,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 		 * be in active use by the guest.
 		 */
 		if (batch >= BATCH_ZAP_PAGES &&
-		    cond_resched_lock(&kvm->mmu_lock)) {
+		    cond_resched_rwlock_write(&kvm->mmu_lock)) {
 			batch = 0;
 			goto restart;
 		}
@@ -5423,7 +5423,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 {
 	lockdep_assert_held(&kvm->slots_lock);
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	trace_kvm_mmu_zap_all_fast(kvm);
 
 	/*
@@ -5450,7 +5450,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	if (kvm->arch.tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_all(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
@@ -5492,7 +5492,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	int i;
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
 		kvm_for_each_memslot(memslot, slots) {
@@ -5516,7 +5516,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 			kvm_flush_remote_tlbs(kvm);
 	}
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 static bool slot_rmap_write_protect(struct kvm *kvm,
@@ -5531,12 +5531,12 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
 	if (kvm->arch.tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	/*
 	 * We can flush all the TLBs out of the mmu lock without TLB
@@ -5596,13 +5596,13 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot)
 {
 	/* FIXME: const-ify all uses of struct kvm_memory_slot.  */
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	slot_handle_leaf(kvm, (struct kvm_memory_slot *)memslot,
 			 kvm_mmu_zap_collapsible_spte, true);
 
 	if (kvm->arch.tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_collapsible_sptes(kvm, memslot);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
@@ -5625,11 +5625,11 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
 	if (kvm->arch.tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	/*
 	 * It's also safe to flush TLBs out of mmu lock here as currently this
@@ -5647,12 +5647,12 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_large_level(kvm, memslot, slot_rmap_write_protect,
 					false);
 	if (kvm->arch.tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_2M);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
@@ -5664,11 +5664,11 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
 	if (kvm->arch.tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_slot_set_dirty(kvm, memslot);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
@@ -5681,14 +5681,14 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	LIST_HEAD(invalid_list);
 	int ign;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
 		if (WARN_ON(sp->role.invalid))
 			continue;
 		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
 			goto restart;
-		if (cond_resched_lock(&kvm->mmu_lock))
+		if (cond_resched_rwlock_write(&kvm->mmu_lock))
 			goto restart;
 	}
 
@@ -5697,7 +5697,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	if (kvm->arch.tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_all(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
@@ -5757,7 +5757,7 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 			continue;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		spin_lock(&kvm->mmu_lock);
+		write_lock(&kvm->mmu_lock);
 
 		if (kvm_has_zapped_obsolete_pages(kvm)) {
 			kvm_mmu_commit_zap_page(kvm,
@@ -5768,7 +5768,7 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		freed = kvm_mmu_zap_oldest_mmu_pages(kvm, sc->nr_to_scan);
 
 unlock:
-		spin_unlock(&kvm->mmu_lock);
+		write_unlock(&kvm->mmu_lock);
 		srcu_read_unlock(&kvm->srcu, idx);
 
 		/*
@@ -5988,7 +5988,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	ulong to_zap;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
 	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
@@ -6013,14 +6013,14 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 			WARN_ON_ONCE(sp->lpage_disallowed);
 		}
 
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			kvm_mmu_commit_zap_page(kvm, &invalid_list);
-			cond_resched_lock(&kvm->mmu_lock);
+			cond_resched_rwlock_write(&kvm->mmu_lock);
 		}
 	}
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 8443a675715b..34bb0ec69bd8 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -184,9 +184,9 @@ kvm_page_track_register_notifier(struct kvm *kvm,
 
 	head = &kvm->arch.track_notifier_head;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	hlist_add_head_rcu(&n->node, &head->track_notifier_list);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_register_notifier);
 
@@ -202,9 +202,9 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
 
 	head = &kvm->arch.track_notifier_head;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	hlist_del_rcu(&n->node);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	synchronize_srcu(&head->track_srcu);
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50e268eb8e1a..d9f66cc459e8 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -868,7 +868,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	}
 
 	r = RET_PF_RETRY;
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 
@@ -881,7 +881,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
 	return r;
 }
@@ -919,7 +919,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 		return;
 	}
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 	for_each_shadow_entry_using_root(vcpu, root_hpa, gva, iterator) {
 		level = iterator.level;
 		sptep = iterator.sptep;
@@ -954,7 +954,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
 			break;
 	}
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
 /* Note, @addr is a GPA when gva_to_gpa() translates an L2 GPA to an L1 GPA. */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9e4009068920..f1fbed72e149 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -59,7 +59,7 @@ static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
 					   struct kvm_mmu_page *root)
 {
-	lockdep_assert_held(&kvm->mmu_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
 		return false;
@@ -117,7 +117,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 
-	lockdep_assert_held(&kvm->mmu_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	WARN_ON(root->root_count);
 	WARN_ON(!root->tdp_mmu_page);
@@ -170,13 +170,13 @@ static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
 
 	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root) {
 		if (root->role.word == role.word) {
 			kvm_mmu_get_root(kvm, root);
-			spin_unlock(&kvm->mmu_lock);
+			write_unlock(&kvm->mmu_lock);
 			return root;
 		}
 	}
@@ -186,7 +186,7 @@ static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
 
 	list_add(&root->link, &kvm->arch.tdp_mmu_roots);
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	return root;
 }
@@ -421,7 +421,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
 	int as_id = kvm_mmu_page_as_id(root);
 
-	lockdep_assert_held(&kvm->mmu_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
 
@@ -492,13 +492,13 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	if (iter->next_last_level_gfn == iter->yielded_gfn)
 		return false;
 
-	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 		rcu_read_unlock();
 
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
 
-		cond_resched_lock(&kvm->mmu_lock);
+		cond_resched_rwlock_write(&kvm->mmu_lock);
 		rcu_read_lock();
 
 		WARN_ON(iter->gfn > iter->next_last_level_gfn);
@@ -1103,7 +1103,7 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 	int root_as_id;
 
-	lockdep_assert_held(&kvm->mmu_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 	for_each_tdp_mmu_root(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
@@ -1268,7 +1268,7 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	int root_as_id;
 	bool spte_set = false;
 
-	lockdep_assert_held(&kvm->mmu_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 	for_each_tdp_mmu_root(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76bce832cade..b544f59b6952 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7092,9 +7092,9 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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
index f3b1013fb22c..f417447129b9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -451,7 +451,12 @@ struct kvm_memslots {
 };
 
 struct kvm {
+#ifdef KVM_HAVE_MMU_RWLOCK
+	rwlock_t mmu_lock;
+#else
 	spinlock_t mmu_lock;
+#endif /* KVM_HAVE_MMU_RWLOCK */
+
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 9d01299563ee..dc7052a6e033 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -60,9 +60,19 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
 		return;
 
+#ifdef KVM_HAVE_MMU_RWLOCK
+	write_lock(&kvm->mmu_lock);
+#else
 	spin_lock(&kvm->mmu_lock);
+#endif /* KVM_HAVE_MMU_RWLOCK */
+
 	kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
+
+#ifdef KVM_HAVE_MMU_RWLOCK
+	write_unlock(&kvm->mmu_lock);
+#else
 	spin_unlock(&kvm->mmu_lock);
+#endif /* KVM_HAVE_MMU_RWLOCK */
 }
 
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8367d88ce39b..44b55f9387c4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -450,6 +450,14 @@ static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
+#ifdef KVM_HAVE_MMU_RWLOCK
+#define KVM_MMU_LOCK(kvm) write_lock(&kvm->mmu_lock)
+#define KVM_MMU_UNLOCK(kvm) write_unlock(&kvm->mmu_lock)
+#else
+#define KVM_MMU_LOCK(kvm) spin_lock(&kvm->mmu_lock)
+#define KVM_MMU_UNLOCK(kvm) spin_unlock(&kvm->mmu_lock)
+#endif /* KVM_HAVE_MMU_RWLOCK */
+
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
@@ -459,13 +467,15 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+
+	KVM_MMU_LOCK(kvm);
+
 	kvm->mmu_notifier_seq++;
 
 	if (kvm_set_spte_hva(kvm, address, pte))
 		kvm_flush_remote_tlbs(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	KVM_MMU_UNLOCK(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -476,7 +486,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	int need_tlb_flush = 0, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	KVM_MMU_LOCK(kvm);
 	/*
 	 * The count increase must become visible at unlock time as no
 	 * spte can be established without taking the mmu_lock and
@@ -489,7 +499,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	if (need_tlb_flush || kvm->tlbs_dirty)
 		kvm_flush_remote_tlbs(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	KVM_MMU_UNLOCK(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return 0;
@@ -500,7 +510,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 
-	spin_lock(&kvm->mmu_lock);
+	KVM_MMU_LOCK(kvm);
 	/*
 	 * This sequence increase will notify the kvm page fault that
 	 * the page that is going to be mapped in the spte could have
@@ -514,7 +524,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	 * in conjunction with the smp_rmb in mmu_notifier_retry().
 	 */
 	kvm->mmu_notifier_count--;
-	spin_unlock(&kvm->mmu_lock);
+	KVM_MMU_UNLOCK(kvm);
 
 	BUG_ON(kvm->mmu_notifier_count < 0);
 }
@@ -528,13 +538,13 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	int young, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	KVM_MMU_LOCK(kvm);
 
 	young = kvm_age_hva(kvm, start, end);
 	if (young)
 		kvm_flush_remote_tlbs(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	KVM_MMU_UNLOCK(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
@@ -549,7 +559,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	int young, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	KVM_MMU_LOCK(kvm);
 	/*
 	 * Even though we do not flush TLB, this will still adversely
 	 * affect performance on pre-Haswell Intel EPT, where there is
@@ -564,7 +574,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * more sophisticated heuristic later.
 	 */
 	young = kvm_age_hva(kvm, start, end);
-	spin_unlock(&kvm->mmu_lock);
+	KVM_MMU_UNLOCK(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
@@ -578,9 +588,9 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	int young, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	KVM_MMU_LOCK(kvm);
 	young = kvm_test_age_hva(kvm, address);
-	spin_unlock(&kvm->mmu_lock);
+	KVM_MMU_UNLOCK(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
@@ -745,7 +755,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
+#ifdef KVM_HAVE_MMU_RWLOCK
+	rwlock_init(&kvm->mmu_lock);
+#else
 	spin_lock_init(&kvm->mmu_lock);
+#endif /* KVM_HAVE_MMU_RWLOCK */
 	mmgrab(current->mm);
 	kvm->mm = current->mm;
 	kvm_eventfd_init(kvm);
@@ -1525,7 +1539,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 		dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
 		memset(dirty_bitmap_buffer, 0, n);
 
-		spin_lock(&kvm->mmu_lock);
+		KVM_MMU_LOCK(kvm);
 		for (i = 0; i < n / sizeof(long); i++) {
 			unsigned long mask;
 			gfn_t offset;
@@ -1541,7 +1555,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
 		}
-		spin_unlock(&kvm->mmu_lock);
+		KVM_MMU_UNLOCK(kvm);
 	}
 
 	if (flush)
@@ -1636,7 +1650,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
 		return -EFAULT;
 
-	spin_lock(&kvm->mmu_lock);
+	KVM_MMU_LOCK(kvm);
 	for (offset = log->first_page, i = offset / BITS_PER_LONG,
 		 n = DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
 	     i++, offset += BITS_PER_LONG) {
@@ -1659,7 +1673,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 								offset, mask);
 		}
 	}
-	spin_unlock(&kvm->mmu_lock);
+	KVM_MMU_UNLOCK(kvm);
 
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
-- 
2.30.0.365.g02bc693789-goog


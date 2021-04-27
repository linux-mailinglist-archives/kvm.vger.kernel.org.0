Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BD436CEA5
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 00:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239282AbhD0Whk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 18:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbhD0Whj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 18:37:39 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5C1C061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:54 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id lk6-20020a17090b33c6b029015542757d77so7438112pjb.3
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wnFZTvl8EEbsYQ+vfX7Oqp9eLYvZL9QjLRirQ5ivVVo=;
        b=iGmv7hSeTrxwEawroigP5gIKdlxSL3Uc6MsodK43syZFD13gel/UY2U8kgtW4Gzp5K
         9Mqk5pkERwoqAA5wLLs8N0YqFtx3SoJ8AeFcMcDcFUJkt7KDJrEErQX/yGxtu8URedVW
         JlPq+pqCxiGAp6DPrqxjORmryuRLG0gVGVfOulf5QEhLeeBR+3ScDOKDmlTAywgDD1rx
         NHqXx/yaLXKBIh+JcV+1YrNaT+DP/iOAPQWDuqzKAtmHugUKZA/HLitHAmERNMU7I3iy
         CQ/64K0HtHprjcIzlwgf8Qg/VtAaEmx6bagh3r+rCz77bscpfVMG7Q5MMzYwLBAE3dUS
         I5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wnFZTvl8EEbsYQ+vfX7Oqp9eLYvZL9QjLRirQ5ivVVo=;
        b=FDZKQ8RGrcR8xsYYxwHhK7/SBTw34mpkPVdTrrtp9ZDXYrqz1gMfS8tO0nX0i+o8Mv
         SNfkxmrQcXJ2ZMXLQKL6lpCjufa9dQMk/Hw/KfWZd5slVQ+0yw2WMf/MQ0bei1bRCeux
         b91EXQYDwKJVzXsuGnVdOvz/TxSueLiWMYPL/2FBorcgwF9NuCifR6gf1Ft8wjQzUG3t
         5uZmgiNzJyDO3xrjPhqVEPhKdcKVpSSJDbDcYNV7/5vzYLnjWdhMia7BKJiTcZN76gYX
         GYNNrLyidcPo8WHYRT2hu45qgDWVMTzEBYg9w1cRdhbIDj0VsSRQ8/MvG5DBGbgKs8hy
         5fMw==
X-Gm-Message-State: AOAM531hjtkc6WIwleGeXphb/sZBW3zzkKePv7kBFJB/kSYuXlGGv9/d
        65LSpRwSrC054T0bheipdE5VdgGkMDbF
X-Google-Smtp-Source: ABdhPJwZpdKKKElyqoqoNGOBHNLzlOx8FpoPNdEuwe4nQ0i5gNz1PtGwWPIbb46DG0pV97KVY9+Ya8pFowig
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:d0b5:c590:c6b:bd9c])
 (user=bgardon job=sendgmr) by 2002:a62:5f87:0:b029:263:d07d:e88e with SMTP id
 t129-20020a625f870000b0290263d07de88emr25296876pfb.39.1619563013537; Tue, 27
 Apr 2021 15:36:53 -0700 (PDT)
Date:   Tue, 27 Apr 2021 15:36:35 -0700
In-Reply-To: <20210427223635.2711774-1-bgardon@google.com>
Message-Id: <20210427223635.2711774-7-bgardon@google.com>
Mime-Version: 1.0
References: <20210427223635.2711774-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 6/6] KVM: x86/mmu: Lazily allocate memslot rmaps
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
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

If the TDP MMU is in use, wait to allocate the rmaps until the shadow
MMU is actually used. (i.e. a nested VM is launched.) This saves memory
equal to 0.2% of guest memory in cases where the TDP MMU is used and
there are no nested guests involved.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h | 15 +++++++-
 arch/x86/kvm/mmu/mmu.c          | 21 ++++++++--
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/x86.c              | 68 ++++++++++++++++++++++++++++++---
 include/linux/kvm_host.h        |  2 +-
 virt/kvm/kvm_main.c             | 43 +++++++++++++++------
 6 files changed, 129 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bce7fa152473..9ce4cfaf6539 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1126,7 +1126,18 @@ struct kvm_arch {
 	bool shadow_mmu_active;
 
 	/*
-	 * Protects kvm->memslots.
+	 * If set, the rmap should be allocated for any newly created or
+	 * modified memslots. If allocating rmaps lazily, this may be set
+	 * before the rmaps are allocated for existing memslots, but
+	 * shadow_mmu_active will not be set until after the rmaps are fully
+	 * allocated. Protected by the memslot assignment lock, below.
+	 */
+	bool alloc_memslot_rmaps;
+
+	/*
+	 * Protects kvm->memslots and alloc_memslot_rmaps (above) to ensure
+	 * that once alloc_memslot_rmaps is set, no memslot is left without an
+	 * rmap.
 	 */
 	struct mutex memslot_assignment_lock;
 };
@@ -1860,4 +1871,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 
 int kvm_cpu_dirty_log_size(void);
 
+int alloc_all_memslots_rmaps(struct kvm *kvm);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e252af46f205..b2a6585bd978 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3125,9 +3125,17 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return ret;
 }
 
-void activate_shadow_mmu(struct kvm *kvm)
+int activate_shadow_mmu(struct kvm *kvm)
 {
+	int r;
+
+	r = alloc_all_memslots_rmaps(kvm);
+	if (r)
+		return r;
+
 	kvm->arch.shadow_mmu_active = true;
+
+	return 0;
 }
 
 static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
@@ -3300,7 +3308,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	activate_shadow_mmu(vcpu->kvm);
+	r = activate_shadow_mmu(vcpu->kvm);
+	if (r)
+		return r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
 	r = make_mmu_pages_available(vcpu);
@@ -5491,7 +5501,12 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 
 	if (!kvm_mmu_init_tdp_mmu(kvm))
-		activate_shadow_mmu(kvm);
+		/*
+		 * No memslots can have been allocated at this point.
+		 * activate_shadow_mmu won't actually need to allocate
+		 * rmaps, so it cannot fail.
+		 */
+		WARN_ON(activate_shadow_mmu(kvm));
 
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 297a911c018c..c6b21a916452 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -165,6 +165,6 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
-void activate_shadow_mmu(struct kvm *kvm);
+int activate_shadow_mmu(struct kvm *kvm);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 30234fe96f48..1aca39673168 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10843,11 +10843,24 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	kvm_page_track_free_memslot(slot);
 }
 
-static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
+static int alloc_memslot_rmap(struct kvm *kvm, struct kvm_memory_slot *slot,
 			      unsigned long npages)
 {
 	int i;
 
+	if (!kvm->arch.alloc_memslot_rmaps)
+		return 0;
+
+	/*
+	 * All rmaps for a memslot should be allocated either before
+	 * the memslot is installed (in which case no other threads
+	 * should have a pointer to it), or under the
+	 * memslot_assignment_lock. Avoid overwriting already allocated
+	 * rmaps.
+	 */
+	if (slot->arch.rmap[0])
+		return 0;
+
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
 		int lpages;
 		int level = i + 1;
@@ -10869,17 +10882,62 @@ static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
 	return -ENOMEM;
 }
 
+int alloc_memslots_rmaps(struct kvm *kvm, struct kvm_memslots *slots)
+{
+	struct kvm_memory_slot *slot;
+	int r = 0;
+
+	kvm_for_each_memslot(slot, slots) {
+		r = alloc_memslot_rmap(kvm, slot, slot->npages);
+		if (r)
+			break;
+	}
+	return r;
+}
+
+int alloc_all_memslots_rmaps(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	int r = 0;
+	int i;
 
-void kvm_arch_assign_memslots(struct kvm *kvm, int as_id,
+	mutex_lock(&kvm->arch.memslot_assignment_lock);
+	kvm->arch.alloc_memslot_rmaps = true;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		r = alloc_memslots_rmaps(kvm, slots);
+		if (r)
+			break;
+	}
+	mutex_unlock(&kvm->arch.memslot_assignment_lock);
+	return r;
+}
+
+int kvm_arch_assign_memslots(struct kvm *kvm, int as_id,
 			     struct kvm_memslots *slots)
 {
+	int r;
+
 	mutex_lock(&kvm->arch.memslot_assignment_lock);
+
+	if (kvm->arch.alloc_memslot_rmaps) {
+		r = alloc_memslots_rmaps(kvm, slots);
+		if (r) {
+			mutex_unlock(&kvm->arch.memslot_assignment_lock);
+			return r;
+		}
+	}
+
 	rcu_assign_pointer(kvm->memslots[as_id], slots);
 	mutex_unlock(&kvm->arch.memslot_assignment_lock);
+
+	return 0;
 }
 
 
-static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
+static int kvm_alloc_memslot_metadata(struct kvm *kvm,
+				      struct kvm_memory_slot *slot,
 				      unsigned long npages)
 {
 	int i;
@@ -10892,7 +10950,7 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
 
-	r = alloc_memslot_rmap(slot, npages);
+	r = alloc_memslot_rmap(kvm, slot, npages);
 	if (r)
 		return r;
 
@@ -10965,7 +11023,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				enum kvm_mr_change change)
 {
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
-		return kvm_alloc_memslot_metadata(memslot,
+		return kvm_alloc_memslot_metadata(kvm, memslot,
 						  mem->memory_size >> PAGE_SHIFT);
 	return 0;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 146bb839c754..0a34491a5c40 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -720,7 +720,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
 				const struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change);
-void kvm_arch_assign_memslots(struct kvm *kvm, int as_id,
+int kvm_arch_assign_memslots(struct kvm *kvm, int as_id,
 			     struct kvm_memslots *slots);
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e62a37bc5b90..657e29ce8a05 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1270,22 +1270,31 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	return 0;
 }
 
-__weak void kvm_arch_assign_memslots(struct kvm *kvm, int as_id,
+__weak int kvm_arch_assign_memslots(struct kvm *kvm, int as_id,
 				    struct kvm_memslots *slots)
 {
 	rcu_assign_pointer(kvm->memslots[as_id], slots);
+	return 0;
 }
 
-static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
-		int as_id, struct kvm_memslots *slots)
+static int install_new_memslots(struct kvm *kvm, int as_id,
+				struct kvm_memslots *slots,
+				struct kvm_memslots **old_slots)
 {
-	struct kvm_memslots *old_memslots = __kvm_memslots(kvm, as_id);
-	u64 gen = old_memslots->generation;
+	u64 gen;
+	int r;
+
+	*old_slots = __kvm_memslots(kvm, as_id);
+	gen = (*old_slots)->generation;
 
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
 	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
 
-	kvm_arch_assign_memslots(kvm, as_id, slots);
+	r = kvm_arch_assign_memslots(kvm, as_id, slots);
+	if (r) {
+		old_slots = NULL;
+		return r;
+	}
 
 	synchronize_srcu_expedited(&kvm->srcu);
 
@@ -1310,7 +1319,7 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 
 	slots->generation = gen;
 
-	return old_memslots;
+	return 0;
 }
 
 /*
@@ -1346,6 +1355,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 			   enum kvm_mr_change change)
 {
 	struct kvm_memory_slot *slot;
+	struct kvm_memslots *old_slots;
 	struct kvm_memslots *slots;
 	int r;
 
@@ -1367,7 +1377,10 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 * dropped by update_memslots anyway.  We'll also revert to the
 		 * old memslots if preparing the new memory region fails.
 		 */
-		slots = install_new_memslots(kvm, as_id, slots);
+		r = install_new_memslots(kvm, as_id, slots,  &old_slots);
+		if (r)
+			goto out_free;
+		slots = old_slots;
 
 		/* From this point no new shadow pages pointing to a deleted,
 		 * or moved, memslot will be created.
@@ -1384,7 +1397,10 @@ static int kvm_set_memslot(struct kvm *kvm,
 		goto out_slots;
 
 	update_memslots(slots, new, change);
-	slots = install_new_memslots(kvm, as_id, slots);
+	r = install_new_memslots(kvm, as_id, slots,  &old_slots);
+	if (r)
+		goto out_slots;
+	slots = old_slots;
 
 	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
 
@@ -1392,8 +1408,13 @@ static int kvm_set_memslot(struct kvm *kvm,
 	return 0;
 
 out_slots:
-	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
-		slots = install_new_memslots(kvm, as_id, slots);
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+		r = install_new_memslots(kvm, as_id, slots, &old_slots);
+		if (r)
+			goto out_slots;
+		slots = old_slots;
+	}
+out_free:
 	kvfree(slots);
 	return r;
 }
-- 
2.31.1.498.g6c1eba8ee3d-goog


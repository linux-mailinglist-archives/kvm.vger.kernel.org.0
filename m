Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F1E3E35B1
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhHGNuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232434AbhHGNuP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CghS6swKs/qRixovcoMKlot1feCsjUt83CY9MD+sD7A=;
        b=OawqPkOxPmDcFD7r4KZ0avMLYKGz/jfbGnI6JcNXzmPOJ19Fwcm4MALmqcwdQvTfsc3KPi
        avJpxRn6/BKfYDuT1r7wWKTyUXSyPHoargenJXZ2Q6dMd9IMKtwtIXHGx5xApEg6hPJdC7
        akEHZZ3ol9AhrSsssptYkrJWKeouTjQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-VL4omjppNoGBxKf3t3Isxw-1; Sat, 07 Aug 2021 09:49:56 -0400
X-MC-Unique: VL4omjppNoGBxKf3t3Isxw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED1F5107ACF5;
        Sat,  7 Aug 2021 13:49:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DB7260C13;
        Sat,  7 Aug 2021 13:49:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 14/16] KVM: MMU: change kvm_mmu_hugepage_adjust() arguments to kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:34 -0400
Message-Id: <20210807134936.3083984-15-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass struct kvm_page_fault to kvm_mmu_hugepage_adjust() instead of
extracting the arguments from the struct; the results are also stored
in the struct, so the callers are adjusted consequently.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h              | 35 +++++++++++++++++--
 arch/x86/kvm/mmu/mmu.c          | 60 +++++++++++++++------------------
 arch/x86/kvm/mmu/mmu_internal.h | 12 ++-----
 arch/x86/kvm/mmu/paging_tmpl.h  | 16 ++++-----
 arch/x86/kvm/mmu/tdp_mmu.c      | 21 +++++-------
 5 files changed, 77 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2ff2b340a206..13c20af6fa07 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -127,12 +127,34 @@ struct kvm_page_fault {
 	const bool rsvd;
 	const bool user;
 
-	/* Derived from mmu.  */
+	/* Derived from mmu and global state.  */
 	const bool is_tdp;
+	const bool nx_huge_page_workaround_enabled;
 
-	/* Input to FNAME(fetch), __direct_map and kvm_tdp_mmu_map.  */
+	/*
+	 * Whether a >4KB mapping can be created or is forbidden due to NX
+	 * hugepages.
+	 */
+	bool huge_page_disallowed;
+
+	/*
+	 * Maximum page size that can be created for this fault; input to
+	 * FNAME(fetch), __direct_map and kvm_tdp_mmu_map.
+	 */
 	u8 max_level;
 
+	/*
+	 * Page size that can be created based on the max_level and the
+	 * page size used by the host mapping.
+	 */
+	u8 req_level;
+
+	/*
+	 * Page size that will be created based on the req_level and
+	 * huge_page_disallowed.
+	 */
+	u8 goal_level;
+
 	/* Shifted addr, or result of guest page table walk if addr is a gva.  */
 	gfn_t gfn;
 
@@ -144,6 +166,12 @@ struct kvm_page_fault {
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
+extern int nx_huge_pages;
+static inline bool is_nx_huge_page_enabled(void)
+{
+	return READ_ONCE(nx_huge_pages);
+}
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefault)
 {
@@ -157,8 +185,11 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.user = err & PFERR_USER_MASK,
 		.prefault = prefault,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
+		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
 
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
+		.req_level = PG_LEVEL_4K,
+		.goal_level = PG_LEVEL_4K,
 	};
 #ifdef CONFIG_RETPOLINE
 	if (fault.is_tdp)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cd43cf8d247e..6df7da9d1d77 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2884,48 +2884,45 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 	return min(host_level, max_level);
 }
 
-int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
-			    int max_level, kvm_pfn_t *pfnp,
-			    bool huge_page_disallowed, int *req_level)
+void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot;
-	kvm_pfn_t pfn = *pfnp;
 	kvm_pfn_t mask;
-	int level;
 
-	*req_level = PG_LEVEL_4K;
+	fault->huge_page_disallowed = fault->exec && fault->nx_huge_page_workaround_enabled;
 
-	if (unlikely(max_level == PG_LEVEL_4K))
-		return PG_LEVEL_4K;
+	if (unlikely(fault->max_level == PG_LEVEL_4K))
+		return;
 
-	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn))
-		return PG_LEVEL_4K;
+	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
+		return;
 
-	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, true);
+	slot = gfn_to_memslot_dirty_bitmap(vcpu, fault->gfn, true);
 	if (!slot)
-		return PG_LEVEL_4K;
+		return;
 
 	/*
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	*req_level = level = kvm_mmu_max_mapping_level(vcpu->kvm, slot, gfn, pfn, max_level);
-	if (level == PG_LEVEL_4K || huge_page_disallowed)
-		return PG_LEVEL_4K;
+	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, slot,
+				                     fault->gfn, fault->pfn,
+					             fault->max_level);
+	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
+		return;
 
 	/*
 	 * mmu_notifier_retry() was successful and mmu_lock is held, so
 	 * the pmd can't be split from under us.
 	 */
-	mask = KVM_PAGES_PER_HPAGE(level) - 1;
-	VM_BUG_ON((gfn & mask) != (pfn & mask));
-	*pfnp = pfn & ~mask;
-
-	return level;
+	fault->goal_level = fault->req_level;
+	mask = KVM_PAGES_PER_HPAGE(fault->goal_level) - 1;
+	VM_BUG_ON((fault->gfn & mask) != (fault->pfn & mask));
+	fault->pfn &= ~mask;
 }
 
 void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
-				kvm_pfn_t *pfnp, int *goal_levelp)
+				kvm_pfn_t *pfnp, u8 *goal_levelp)
 {
 	int level = *goal_levelp;
 
@@ -2948,28 +2945,25 @@ void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
 
 static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
-	bool huge_page_disallowed = fault->exec && nx_huge_page_workaround_enabled;
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
-	int level, req_level, ret;
+	int ret;
 	gfn_t base_gfn = fault->gfn;
 
-	level = kvm_mmu_hugepage_adjust(vcpu, fault->gfn, fault->max_level, &fault->pfn,
-					huge_page_disallowed, &req_level);
+	kvm_mmu_hugepage_adjust(vcpu, fault);
 
-	trace_kvm_mmu_spte_requested(fault->addr, level, fault->pfn);
+	trace_kvm_mmu_spte_requested(fault->addr, fault->goal_level, fault->pfn);
 	for_each_shadow_entry(vcpu, fault->addr, it) {
 		/*
 		 * We cannot overwrite existing page tables with an NX
 		 * large page, as the leaf could be executable.
 		 */
-		if (nx_huge_page_workaround_enabled)
+		if (fault->nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(*it.sptep, fault->gfn, it.level,
-						   &fault->pfn, &level);
+						   &fault->pfn, &fault->goal_level);
 
 		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
-		if (it.level == level)
+		if (it.level == fault->goal_level)
 			break;
 
 		drop_large_spte(vcpu, it.sptep);
@@ -2980,13 +2974,13 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 				      it.level - 1, true, ACC_ALL);
 
 		link_shadow_page(vcpu, it.sptep, sp);
-		if (fault->is_tdp && huge_page_disallowed &&
-		    req_level >= it.level)
+		if (fault->is_tdp && fault->huge_page_disallowed &&
+		    fault->req_level >= it.level)
 			account_huge_nx_page(vcpu->kvm, sp);
 	}
 
 	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
-			   fault->write, level, base_gfn, fault->pfn,
+			   fault->write, fault->goal_level, base_gfn, fault->pfn,
 			   fault->prefault, fault->map_writable);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ca7b7595bbfc..f84e0e90e442 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -116,12 +116,6 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	       kvm_x86_ops.cpu_dirty_log_size;
 }
 
-extern int nx_huge_pages;
-static inline bool is_nx_huge_page_enabled(void)
-{
-	return READ_ONCE(nx_huge_pages);
-}
-
 int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync);
 
 void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
@@ -160,11 +154,9 @@ enum {
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
 			      kvm_pfn_t pfn, int max_level);
-int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
-			    int max_level, kvm_pfn_t *pfnp,
-			    bool huge_page_disallowed, int *req_level);
+void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
-				kvm_pfn_t *pfnp, int *goal_levelp);
+				kvm_pfn_t *pfnp, u8 *goal_levelp);
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 261100d813af..add1b41b0f1a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -666,12 +666,10 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			 struct guest_walker *gw)
 {
-	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
-	bool huge_page_disallowed = fault->exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
 	unsigned int direct_access, access;
-	int top_level, level, req_level, ret;
+	int top_level, ret;
 	gfn_t base_gfn = fault->gfn;
 
 	WARN_ON_ONCE(gw->gfn != base_gfn);
@@ -719,8 +717,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			link_shadow_page(vcpu, it.sptep, sp);
 	}
 
-	level = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, fault->max_level, &fault->pfn,
-					huge_page_disallowed, &req_level);
+	kvm_mmu_hugepage_adjust(vcpu, fault);
 
 	trace_kvm_mmu_spte_requested(fault->addr, gw->level, fault->pfn);
 
@@ -731,12 +728,12 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		 * We cannot overwrite existing page tables with an NX
 		 * large page, as the leaf could be executable.
 		 */
-		if (nx_huge_page_workaround_enabled)
+		if (fault->nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(*it.sptep, fault->gfn, it.level,
-						   &fault->pfn, &level);
+						   &fault->pfn, &fault->goal_level);
 
 		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
-		if (it.level == level)
+		if (it.level == fault->goal_level)
 			break;
 
 		validate_direct_spte(vcpu, it.sptep, direct_access);
@@ -747,7 +744,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			sp = kvm_mmu_get_page(vcpu, base_gfn, fault->addr,
 					      it.level - 1, true, direct_access);
 			link_shadow_page(vcpu, it.sptep, sp);
-			if (huge_page_disallowed && req_level >= it.level)
+			if (fault->huge_page_disallowed &&
+			    fault->req_level >= it.level)
 				account_huge_nx_page(vcpu->kvm, sp);
 		}
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d8b1735739c0..f0a9009dff96 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -995,30 +995,25 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
  */
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
-	bool huge_page_disallowed = fault->exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	u64 *child_pt;
 	u64 new_spte;
 	int ret;
-	int level;
-	int req_level;
 
-	level = kvm_mmu_hugepage_adjust(vcpu, fault->gfn, fault->max_level, &fault->pfn,
-					huge_page_disallowed, &req_level);
+	kvm_mmu_hugepage_adjust(vcpu, fault);
 
-	trace_kvm_mmu_spte_requested(fault->addr, level, fault->pfn);
+	trace_kvm_mmu_spte_requested(fault->addr, fault->goal_level, fault->pfn);
 
 	rcu_read_lock();
 
 	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
-		if (nx_huge_page_workaround_enabled)
+		if (fault->nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(iter.old_spte, fault->gfn,
-						   iter.level, &fault->pfn, &level);
+						   iter.level, &fault->pfn, &fault->goal_level);
 
-		if (iter.level == level)
+		if (iter.level == fault->goal_level)
 			break;
 
 		/*
@@ -1056,8 +1051,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 			if (tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, &iter, new_spte)) {
 				tdp_mmu_link_page(vcpu->kvm, sp, true,
-						  huge_page_disallowed &&
-						  req_level >= iter.level);
+						  fault->huge_page_disallowed &&
+						  fault->req_level >= iter.level);
 
 				trace_kvm_mmu_get_page(sp, true);
 			} else {
@@ -1067,7 +1062,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}
 
-	if (iter.level != level) {
+	if (iter.level != fault->goal_level) {
 		rcu_read_unlock();
 		return RET_PF_RETRY;
 	}
-- 
2.27.0



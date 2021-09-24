Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6776D4178B1
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347829AbhIXQeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347549AbhIXQdo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ydOpgQEqOCpuantPPpR0jKVsq5BxCDNrS6fWq6ozFI4=;
        b=HkveCeDCRp11y2CuWyBTaTGcNf4FJwFzaroQXwQE68MIMUWrj3DN+9Hh8BKfnYT0rirABa
        o3AohHZBVrhu6dTTi5odqax4Xr5kPuJjE0KX6jGADnLk2VSahCSI7XRyCF1KvaFYsQitbX
        E9z1uHr7TccidoMwdsLWRfY9eE1BOqY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-SwfPp3C1OI-AHWFxrDXFcw-1; Fri, 24 Sep 2021 12:32:06 -0400
X-MC-Unique: SwfPp3C1OI-AHWFxrDXFcw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BAB7801E72;
        Fri, 24 Sep 2021 16:32:05 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CCB15C1CF;
        Fri, 24 Sep 2021 16:32:04 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com,
        Ben Gardon <bgardon@google.com>
Subject: [PATCH v3 20/31] KVM: x86/mmu: Pass the memslot around via struct kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:41 -0400
Message-Id: <20210924163152.289027-21-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

The memslot for the faulting gfn is used throughout the page fault
handling code, so capture it in kvm_page_fault as soon as we know the
gfn and use it in the page fault handling code that has direct access
to the kvm_page_fault struct.  Replace various tests using is_noslot_pfn
with more direct tests on fault->slot being NULL.

This, in combination with the subsequent patch, improves "Populate
memory time" in dirty_log_perf_test by 5% when using the legacy MMU.
There is no discerable improvement to the performance of the TDP MMU.

No functional change intended.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20210813203504.2742757-4-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h             |  3 +++
 arch/x86/kvm/mmu/mmu.c         | 32 ++++++++++++--------------------
 arch/x86/kvm/mmu/paging_tmpl.h |  6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c     |  2 +-
 4 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 01a4d1bc5053..75367af1a6d3 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -158,6 +158,9 @@ struct kvm_page_fault {
 	/* Shifted addr, or result of guest page table walk if addr is a gva.  */
 	gfn_t gfn;
 
+	/* The memslot containing gfn. May be NULL. */
+	struct kvm_memory_slot *slot;
+
 	/* Outputs of kvm_faultin_pfn.  */
 	kvm_pfn_t pfn;
 	hva_t hva;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5a757953b98b..754578458cb7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2907,7 +2907,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_memory_slot *slot;
+	struct kvm_memory_slot *slot = fault->slot;
 	kvm_pfn_t mask;
 
 	fault->huge_page_disallowed = fault->exec && fault->nx_huge_page_workaround_enabled;
@@ -2918,8 +2918,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
 		return;
 
-	slot = gfn_to_memslot_dirty_bitmap(vcpu, fault->gfn, true);
-	if (!slot)
+	if (kvm_slot_dirty_track_enabled(slot))
 		return;
 
 	/*
@@ -3043,7 +3042,7 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		return true;
 	}
 
-	if (unlikely(is_noslot_pfn(fault->pfn))) {
+	if (unlikely(!fault->slot)) {
 		gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
 		vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
@@ -3097,13 +3096,9 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
  * someone else modified the SPTE from its original value.
  */
 static bool
-fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			u64 *sptep, u64 old_spte, u64 new_spte)
 {
-	gfn_t gfn;
-
-	WARN_ON(!sp->role.direct);
-
 	/*
 	 * Theoretically we could also set dirty bit (and flush TLB) here in
 	 * order to eliminate unnecessary PML logging. See comments in
@@ -3119,14 +3114,8 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (cmpxchg64(sptep, old_spte, new_spte) != old_spte)
 		return false;
 
-	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
-		/*
-		 * The gfn of direct spte is stable since it is
-		 * calculated by sp->gfn.
-		 */
-		gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
-		kvm_vcpu_mark_page_dirty(vcpu, gfn);
-	}
+	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
+		mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);
 
 	return true;
 }
@@ -3251,7 +3240,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * since the gfn is not stable for indirect shadow page. See
 		 * Documentation/virt/kvm/locking.rst to get more detail.
 		 */
-		if (fast_pf_fix_direct_spte(vcpu, sp, sptep, spte, new_spte)) {
+		if (fast_pf_fix_direct_spte(vcpu, fault, sptep, spte, new_spte)) {
 			ret = RET_PF_FIXED;
 			break;
 		}
@@ -3863,7 +3852,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault, int *r)
 {
-	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
+	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
 
 	/*
@@ -3877,6 +3866,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (!kvm_is_visible_memslot(slot)) {
 		/* Don't expose private memslots to L2. */
 		if (is_guest_mode(vcpu)) {
+			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
 			fault->map_writable = false;
 			return false;
@@ -3928,6 +3918,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	int r;
 
 	fault->gfn = fault->addr >> PAGE_SHIFT;
+	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
+
 	if (page_fault_handle_page_track(vcpu, fault))
 		return RET_PF_EMULATE;
 
@@ -3955,7 +3947,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
 
-	if (!is_noslot_pfn(fault->pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
+	if (fault->slot && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
 	if (r)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7a8a2d14a3c7..e4c7bf3deac8 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -861,6 +861,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	fault->gfn = walker.gfn;
+	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
+
 	if (page_fault_handle_page_track(vcpu, fault)) {
 		shadow_page_table_clear_flood(vcpu, fault->addr);
 		return RET_PF_EMULATE;
@@ -894,7 +896,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * we will cache the incorrect access into mmio spte.
 	 */
 	if (fault->write && !(walker.pte_access & ACC_WRITE_MASK) &&
-	    !is_cr0_wp(vcpu->arch.mmu) && !fault->user && !is_noslot_pfn(fault->pfn)) {
+	    !is_cr0_wp(vcpu->arch.mmu) && !fault->user && fault->slot) {
 		walker.pte_access |= ACC_WRITE_MASK;
 		walker.pte_access &= ~ACC_USER_MASK;
 
@@ -910,7 +912,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
-	if (!is_noslot_pfn(fault->pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
+	if (fault->slot && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2d92a5b54ded..3e10658cf0d7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -900,7 +900,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	int ret = RET_PF_FIXED;
 	int make_spte_ret = 0;
 
-	if (unlikely(is_noslot_pfn(fault->pfn)))
+	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
 		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
-- 
2.27.0



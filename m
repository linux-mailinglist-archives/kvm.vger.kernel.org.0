Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E093A3E35A7
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhHGNuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232389AbhHGNuG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iJEcRpVMFrHZBYZvv2XvOb74vaAaUpWfSnayIddVAII=;
        b=hhWFqyz3tq+OaUV4y3Z7M2DG7hlu/Vh93fldVyub8GWQpEG9Q6Cll/lG4wvTxHB4XtX1FT
        JJMrSx+1XRhtGaByEn6i0Zm6JNEaRrwqa02lviksejduU+J6m4YFjRHMLx/zF70stcOCXL
        tofsZX1EOMexCjcBTf8niazG6xVM7iM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-hFHzxh9SP4-1_R178cMKfw-1; Sat, 07 Aug 2021 09:49:47 -0400
X-MC-Unique: hFHzxh9SP4-1_R178cMKfw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C1201835AC4;
        Sat,  7 Aug 2021 13:49:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F05AC1700F;
        Sat,  7 Aug 2021 13:49:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 07/16] KVM: MMU: change try_async_pf() arguments to kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:27 -0400
Message-Id: <20210807134936.3083984-8-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add fields to struct kvm_page_fault corresponding to outputs of
try_async_pf().  For now they have to be extracted again from struct
kvm_page_fault in the subsequent steps, but this is temporary until
other functions in the chain are switched over as well.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h             |  5 ++++
 arch/x86/kvm/mmu/mmu.c         | 50 ++++++++++++++++------------------
 arch/x86/kvm/mmu/paging_tmpl.h | 19 ++++++-------
 3 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index c3d404155ceb..2ff2b340a206 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -135,6 +135,11 @@ struct kvm_page_fault {
 
 	/* Shifted addr, or result of guest page table walk if addr is a gva.  */
 	gfn_t gfn;
+
+	/* Outputs of try_async_pf.  */
+	kvm_pfn_t pfn;
+	hva_t hva;
+	bool map_writable;
 };
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3af49678d4f8..a6366f1c4197 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3834,11 +3834,9 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
 }
 
-static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
-			 bool write, bool *writable)
+static bool try_async_pf(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
 	bool async;
 
 	/*
@@ -3851,29 +3849,31 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 
 	/* Don't expose private memslots to L2. */
 	if (is_guest_mode(vcpu) && !kvm_is_visible_memslot(slot)) {
-		*pfn = KVM_PFN_NOSLOT;
-		*writable = false;
+		fault->pfn = KVM_PFN_NOSLOT;
+		fault->map_writable = false;
 		return false;
 	}
 
 	async = false;
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async,
-				    write, writable, hva);
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, &async,
+					  fault->write, &fault->map_writable,
+					  &fault->hva);
 	if (!async)
 		return false; /* *pfn has correct page already */
 
-	if (!prefault && kvm_can_do_async_pf(vcpu)) {
-		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
-		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
-			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
+	if (!fault->prefault && kvm_can_do_async_pf(vcpu)) {
+		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
+		if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
+			trace_kvm_async_pf_doublefault(fault->addr, fault->gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 			return true;
-		} else if (kvm_arch_setup_async_pf(vcpu, cr2_or_gpa, gfn))
+		} else if (kvm_arch_setup_async_pf(vcpu, fault->addr, fault->gfn))
 			return true;
 	}
 
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
-				    write, writable, hva);
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
+					  fault->write, &fault->map_writable,
+					  &fault->hva);
 	return false;
 }
 
@@ -3882,11 +3882,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	gpa_t gpa = fault->addr;
 	u32 error_code = fault->error_code;
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
-	bool map_writable;
 
 	unsigned long mmu_seq;
-	kvm_pfn_t pfn;
-	hva_t hva;
 	int r;
 
 	fault->gfn = gpa >> PAGE_SHIFT;
@@ -3904,12 +3901,11 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, fault->prefault, fault->gfn, gpa, &pfn, &hva,
-			 fault->write, &map_writable))
+	if (try_async_pf(vcpu, fault))
 		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, fault->is_tdp ? 0 : gpa,
-	                        fault->gfn, pfn, ACC_ALL, &r))
+	                        fault->gfn, fault->pfn, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
@@ -3919,25 +3915,25 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
 
-	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
+	if (!is_noslot_pfn(fault->pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
 
 	if (is_tdp_mmu_fault)
-		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, fault->max_level,
-				    pfn, fault->prefault);
+		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, fault->map_writable, fault->max_level,
+				    fault->pfn, fault->prefault);
 	else
-		r = __direct_map(vcpu, gpa, error_code, map_writable, fault->max_level, pfn,
-				 fault->prefault, fault->is_tdp);
+		r = __direct_map(vcpu, gpa, error_code, fault->map_writable, fault->max_level,
+		                 fault->pfn, fault->prefault, fault->is_tdp);
 
 out_unlock:
 	if (is_tdp_mmu_fault)
 		read_unlock(&vcpu->kvm->mmu_lock);
 	else
 		write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 2ef219bf1745..6ead472674ad 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -828,10 +828,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	u32 error_code = fault->error_code;
 	struct guest_walker walker;
 	int r;
-	kvm_pfn_t pfn;
-	hva_t hva;
 	unsigned long mmu_seq;
-	bool map_writable, is_self_change_mapping;
+	bool is_self_change_mapping;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 	WARN_ON_ONCE(fault->is_tdp);
@@ -881,11 +879,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, fault->prefault, fault->gfn, addr, &pfn, &hva,
-			 fault->write, &map_writable))
+	if (try_async_pf(vcpu, fault))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, addr, fault->gfn, pfn, walker.pte_access, &r))
+	if (handle_abnormal_pfn(vcpu, addr, fault->gfn, fault->pfn, walker.pte_access, &r))
 		return r;
 
 	/*
@@ -893,7 +890,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * we will cache the incorrect access into mmio spte.
 	 */
 	if (fault->write && !(walker.pte_access & ACC_WRITE_MASK) &&
-	    !is_cr0_wp(vcpu->arch.mmu) && !fault->user && !is_noslot_pfn(pfn)) {
+	    !is_cr0_wp(vcpu->arch.mmu) && !fault->user && !is_noslot_pfn(fault->pfn)) {
 		walker.pte_access |= ACC_WRITE_MASK;
 		walker.pte_access &= ~ACC_USER_MASK;
 
@@ -909,20 +906,20 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
-	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
+	if (!is_noslot_pfn(fault->pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = FNAME(fetch)(vcpu, addr, &walker, error_code, fault->max_level, pfn,
-			 map_writable, fault->prefault);
+	r = FNAME(fetch)(vcpu, addr, &walker, error_code, fault->max_level, fault->pfn,
+			 fault->map_writable, fault->prefault);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 
-- 
2.27.0



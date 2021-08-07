Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECF43E35AF
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhHGNuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232382AbhHGNuO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BOWeFPNVKgv6n1O4ylYaULUgqxiqCAsEB2/1qPs9tPE=;
        b=aNY24/n3bX94ma/s8nMddMtNV3EV03lUJJcrJrrToRwAM1ea+1MzU5UQ5wO7h5lfKv1yI8
        fbalC6StF8g3NkQ+96mow23xMhZUlZrBVWsHtX9bnineFTfsNnHDYULdfPvrFwwFs4kwnW
        sEmprZ1G6ITErs99FBfK5Csqi6X3NWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-MDd7SJNkMPmcVzjavJUbkQ-1; Sat, 07 Aug 2021 09:49:55 -0400
X-MC-Unique: MDd7SJNkMPmcVzjavJUbkQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42EAA871805;
        Sat,  7 Aug 2021 13:49:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9F6160C13;
        Sat,  7 Aug 2021 13:49:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 13/16] KVM: MMU: change fast_page_fault() arguments to kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:33 -0400
Message-Id: <20210807134936.3083984-14-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass struct kvm_page_fault to fast_page_fault() instead of
extracting the arguments from the struct.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 75635fc0720d..cd43cf8d247e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3046,18 +3046,17 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 	return false;
 }
 
-static bool page_fault_can_be_fast(u32 error_code)
+static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
 {
 	/*
 	 * Do not fix the mmio spte with invalid generation number which
 	 * need to be updated by slow page fault path.
 	 */
-	if (unlikely(error_code & PFERR_RSVD_MASK))
+	if (fault->rsvd)
 		return false;
 
 	/* See if the page fault is due to an NX violation */
-	if (unlikely(((error_code & (PFERR_FETCH_MASK | PFERR_PRESENT_MASK))
-		      == (PFERR_FETCH_MASK | PFERR_PRESENT_MASK))))
+	if (unlikely(fault->exec && fault->present))
 		return false;
 
 	/*
@@ -3074,9 +3073,7 @@ static bool page_fault_can_be_fast(u32 error_code)
 	 * accesses to a present page.
 	 */
 
-	return shadow_acc_track_mask != 0 ||
-	       ((error_code & (PFERR_WRITE_MASK | PFERR_PRESENT_MASK))
-		== (PFERR_WRITE_MASK | PFERR_PRESENT_MASK));
+	return shadow_acc_track_mask != 0 || (fault->write && fault->present);
 }
 
 /*
@@ -3118,12 +3115,12 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return true;
 }
 
-static bool is_access_allowed(u32 fault_err_code, u64 spte)
+static bool is_access_allowed(struct kvm_page_fault *fault, u64 spte)
 {
-	if (fault_err_code & PFERR_FETCH_MASK)
+	if (fault->exec)
 		return is_executable_pte(spte);
 
-	if (fault_err_code & PFERR_WRITE_MASK)
+	if (fault->write)
 		return is_writable_pte(spte);
 
 	/* Fault was on Read access */
@@ -3159,7 +3156,7 @@ static u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
 /*
  * Returns one of RET_PF_INVALID, RET_PF_FIXED or RET_PF_SPURIOUS.
  */
-static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
+static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_INVALID;
@@ -3167,7 +3164,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 	u64 *sptep = NULL;
 	uint retry_count = 0;
 
-	if (!page_fault_can_be_fast(error_code))
+	if (!page_fault_can_be_fast(fault))
 		return ret;
 
 	walk_shadow_page_lockless_begin(vcpu);
@@ -3176,9 +3173,9 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 		u64 new_spte;
 
 		if (is_tdp_mmu(vcpu->arch.mmu))
-			sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, gpa, &spte);
+			sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 		else
-			sptep = fast_pf_get_last_sptep(vcpu, gpa, &spte);
+			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 
 		if (!is_shadow_present_pte(spte))
 			break;
@@ -3197,7 +3194,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 		 * Need not check the access of upper level table entries since
 		 * they are always ACC_ALL.
 		 */
-		if (is_access_allowed(error_code, spte)) {
+		if (is_access_allowed(fault, spte)) {
 			ret = RET_PF_SPURIOUS;
 			break;
 		}
@@ -3212,7 +3209,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 		 * be removed in the fast path only if the SPTE was
 		 * write-protected for dirty-logging or access tracking.
 		 */
-		if ((error_code & PFERR_WRITE_MASK) &&
+		if (fault->write &&
 		    spte_can_locklessly_be_made_writable(spte)) {
 			new_spte |= PT_WRITABLE_MASK;
 
@@ -3233,7 +3230,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 
 		/* Verify that the fault can be handled in the fast path */
 		if (new_spte == spte ||
-		    !is_access_allowed(error_code, new_spte))
+		    !is_access_allowed(fault, new_spte))
 			break;
 
 		/*
@@ -3254,7 +3251,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 
 	} while (true);
 
-	trace_fast_page_fault(vcpu, gpa, error_code, sptep, spte, ret);
+	trace_fast_page_fault(vcpu, fault->addr, fault->error_code, sptep, spte, ret);
 	walk_shadow_page_lockless_end(vcpu);
 
 	return ret;
@@ -3874,18 +3871,16 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	gpa_t gpa = fault->addr;
-	u32 error_code = fault->error_code;
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 
 	unsigned long mmu_seq;
 	int r;
 
-	fault->gfn = gpa >> PAGE_SHIFT;
+	fault->gfn = fault->addr >> PAGE_SHIFT;
 	if (page_fault_handle_page_track(vcpu, fault))
 		return RET_PF_EMULATE;
 
-	r = fast_page_fault(vcpu, gpa, error_code);
+	r = fast_page_fault(vcpu, fault);
 	if (r != RET_PF_INVALID)
 		return r;
 
-- 
2.27.0



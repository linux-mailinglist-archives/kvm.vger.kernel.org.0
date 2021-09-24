Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036C74178A4
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347676AbhIXQeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347463AbhIXQdg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKeBaZ3G+DBcugDG2rOaw3AIxpzGZbxxA6oig3S+kbo=;
        b=Z8JXfPO74FQYKZCPECOLBF++xzHSfr5oRhJfHpZ2cpNWsOrbv+mCNcNZ62EtNfphgvlzvR
        K0Ua2a2hTTmiBrkrF54Q5s8g9Zqx+BO13M5WBnLj7yiHgRGtijSujAQkJABbxiHRb/4eLK
        vD/VD7zkVjYwN7YtGGcsU+6YKdGnYS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-SBct1jrfMfqW6yRpbh-63A-1; Fri, 24 Sep 2021 12:32:01 -0400
X-MC-Unique: SBct1jrfMfqW6yRpbh-63A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83C5E9126B;
        Fri, 24 Sep 2021 16:32:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14E6C60E1C;
        Fri, 24 Sep 2021 16:32:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com,
        Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 12/31] KVM: MMU: change fast_page_fault() arguments to kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:33 -0400
Message-Id: <20210924163152.289027-13-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
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
index b2020b481db2..36cbe5cba085 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3083,18 +3083,17 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
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
@@ -3111,9 +3110,7 @@ static bool page_fault_can_be_fast(u32 error_code)
 	 * accesses to a present page.
 	 */
 
-	return shadow_acc_track_mask != 0 ||
-	       ((error_code & (PFERR_WRITE_MASK | PFERR_PRESENT_MASK))
-		== (PFERR_WRITE_MASK | PFERR_PRESENT_MASK));
+	return shadow_acc_track_mask != 0 || (fault->write && fault->present);
 }
 
 /*
@@ -3155,12 +3152,12 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
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
@@ -3193,7 +3190,7 @@ static u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
 /*
  * Returns one of RET_PF_INVALID, RET_PF_FIXED or RET_PF_SPURIOUS.
  */
-static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
+static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_INVALID;
@@ -3201,7 +3198,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 	u64 *sptep = NULL;
 	uint retry_count = 0;
 
-	if (!page_fault_can_be_fast(error_code))
+	if (!page_fault_can_be_fast(fault))
 		return ret;
 
 	walk_shadow_page_lockless_begin(vcpu);
@@ -3210,9 +3207,9 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 		u64 new_spte;
 
 		if (is_tdp_mmu(vcpu->arch.mmu))
-			sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, gpa, &spte);
+			sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 		else
-			sptep = fast_pf_get_last_sptep(vcpu, gpa, &spte);
+			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 
 		if (!is_shadow_present_pte(spte))
 			break;
@@ -3231,7 +3228,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 		 * Need not check the access of upper level table entries since
 		 * they are always ACC_ALL.
 		 */
-		if (is_access_allowed(error_code, spte)) {
+		if (is_access_allowed(fault, spte)) {
 			ret = RET_PF_SPURIOUS;
 			break;
 		}
@@ -3246,7 +3243,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 		 * be removed in the fast path only if the SPTE was
 		 * write-protected for dirty-logging or access tracking.
 		 */
-		if ((error_code & PFERR_WRITE_MASK) &&
+		if (fault->write &&
 		    spte_can_locklessly_be_made_writable(spte)) {
 			new_spte |= PT_WRITABLE_MASK;
 
@@ -3267,7 +3264,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 
 		/* Verify that the fault can be handled in the fast path */
 		if (new_spte == spte ||
-		    !is_access_allowed(error_code, new_spte))
+		    !is_access_allowed(fault, new_spte))
 			break;
 
 		/*
@@ -3288,7 +3285,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 
 	} while (true);
 
-	trace_fast_page_fault(vcpu, gpa, error_code, sptep, spte, ret);
+	trace_fast_page_fault(vcpu, fault->addr, fault->error_code, sptep, spte, ret);
 	walk_shadow_page_lockless_end(vcpu);
 
 	return ret;
@@ -3946,18 +3943,16 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 
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



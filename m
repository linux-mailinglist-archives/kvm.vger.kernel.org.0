Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379C3193BF3
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 10:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgCZJfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 05:35:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39204 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbgCZJfW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 05:35:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585215321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=m/avxIP9KlrNmDBgwKdf8OcnP23o4V4eI0nLWWAsZqw=;
        b=d9Iw1FZVeGukWPYaQqDuDsrML6cWW2phrdisaCSRHwr2I3faqLkBGH4aTxTbN5PwwyvOE+
        PVtYPelUDxwuvF9wP9bVAufo34j3EYGt3a0yAi6Y4vVl/PF+PPigDLsUQ4ma+EUo2CANwf
        HCrupVgvZaeBrCZhzRJIx2ao/jFWnwk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-IOMi7zyVOYy1nC_VcSIAFg-1; Thu, 26 Mar 2020 05:35:19 -0400
X-MC-Unique: IOMi7zyVOYy1nC_VcSIAFg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8378D100550D;
        Thu, 26 Mar 2020 09:35:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D14129CA3;
        Thu, 26 Mar 2020 09:35:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 1/3] KVM: x86: introduce kvm_mmu_invalidate_gva
Date:   Thu, 26 Mar 2020 05:35:14 -0400
Message-Id: <20200326093516.24215-2-pbonzini@redhat.com>
In-Reply-To: <20200326093516.24215-1-pbonzini@redhat.com>
References: <20200326093516.24215-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrap the combination of mmu->invlpg and kvm_x86_ops->tlb_flush_gva
into a new function.  This function also lets us specify the host PGD to
invalidate and also the MMU, both of which will be useful in fixing and
simplifying kvm_inject_emulated_page_fault.

A nested guest's MMU however has g_context->invlpg == NULL.  Instead of
setting it to nonpaging_invlpg, make kvm_mmu_invalidate_gva the only
entry point to mmu->invlpg and make a NULL invlpg pointer equivalent
to nonpaging_invlpg, saving a retpoline.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/mmu/mmu.c          | 71 +++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 328b1765ff76..f6a1ece1bb4a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1506,6 +1506,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
+void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+		            gva_t gva, unsigned long root_hpa);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 560e85ebdf22..e26c9a583e75 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2153,10 +2153,6 @@ static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void nonpaging_invlpg(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root)
-{
-}
-
 static void nonpaging_update_pte(struct kvm_vcpu *vcpu,
 				 struct kvm_mmu_page *sp, u64 *spte,
 				 const void *pte)
@@ -4237,7 +4233,7 @@ static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_page = nonpaging_sync_page;
-	context->invlpg = nonpaging_invlpg;
+	context->invlpg = NULL;
 	context->update_pte = nonpaging_update_pte;
 	context->root_level = 0;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
@@ -4928,7 +4924,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->mmu_role.as_u64 = new_role.as_u64;
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
-	context->invlpg = nonpaging_invlpg;
+	context->invlpg = NULL;
 	context->update_pte = nonpaging_update_pte;
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
 	context->direct_map = true;
@@ -5096,6 +5092,12 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
 
+	/*
+	 * L2 page tables are never shadowed, so there is no need to sync
+	 * SPTEs.
+	 */
+	g_context->invlpg            = NULL;
+
 	/*
 	 * Note that arch.mmu->gva_to_gpa translates l2_gpa to l1_gpa using
 	 * L1's nested page tables (e.g. EPT12). The nested translation
@@ -5497,37 +5499,54 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
-void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
+void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+		            gva_t gva, unsigned long root_hpa)
 {
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	int i;
 
-	/* INVLPG on a * non-canonical address is a NOP according to the SDM.  */
-	if (is_noncanonical_address(gva, vcpu))
+	/* It's actually a GPA for vcpu->arch.guest_mmu.  */
+	if (mmu != &vcpu->arch.guest_mmu) {
+		/* INVLPG on a non-canonical address is a NOP according to the SDM.  */
+		if (is_noncanonical_address(gva, vcpu))
+			return;
+
+		kvm_x86_ops->tlb_flush_gva(vcpu, gva);
+	}
+
+	if (!mmu->invlpg)
 		return;
 
-	mmu->invlpg(vcpu, gva, mmu->root_hpa);
+	if (root_hpa == INVALID_PAGE) {
+		mmu->invlpg(vcpu, gva, mmu->root_hpa);
 
-	/*
-	 * INVLPG is required to invalidate any global mappings for the VA,
-	 * irrespective of PCID. Since it would take us roughly similar amount
-	 * of work to determine whether any of the prev_root mappings of the VA
-	 * is marked global, or to just sync it blindly, so we might as well
-	 * just always sync it.
-	 *
-	 * Mappings not reachable via the current cr3 or the prev_roots will be
-	 * synced when switching to that cr3, so nothing needs to be done here
-	 * for them.
-	 */
-	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-		if (VALID_PAGE(mmu->prev_roots[i].hpa))
-			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
+		/*
+		 * INVLPG is required to invalidate any global mappings for the VA,
+		 * irrespective of PCID. Since it would take us roughly similar amount
+		 * of work to determine whether any of the prev_root mappings of the VA
+		 * is marked global, or to just sync it blindly, so we might as well
+		 * just always sync it.
+		 *
+		 * Mappings not reachable via the current cr3 or the prev_roots will be
+		 * synced when switching to that cr3, so nothing needs to be done here
+		 * for them.
+		 */
+		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+			if (VALID_PAGE(mmu->prev_roots[i].hpa))
+				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
+	} else {
+		mmu->invlpg(vcpu, gva, root_hpa);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_gva);
 
-	kvm_x86_ops->tlb_flush_gva(vcpu, gva);
+void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
+{
+	kvm_mmu_invalidate_gva(vcpu, vcpu->arch.mmu, gva, INVALID_PAGE);
 	++vcpu->stat.invlpg;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
 
+
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-- 
2.18.2



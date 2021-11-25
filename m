Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1122745D2F5
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbhKYCNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236312AbhKYCNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:13:11 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D243BC0698D4
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:49:50 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id b11-20020a17090acc0b00b001a9179dc89fso3914571pju.6
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MEUK24U0BQI/RmjuOG97a0RuEOXEO0NMWXCnh+8+ycU=;
        b=eDboZQ7bAZLZFpTY4V9ag/VJHXK9axmnoZewEZ90DQ4ZejeVXatOVmfwgXELv+ei53
         nyrtat4EvFy5cpDW6ptxHxfl4UpTg8tzpvgr4VAqKpuGO1/QJlSTb2giRiJwVccGl46T
         s5gMFVUacOxrm84iYAawtYru1AT/hbBYXF7T+oFFPARELkFDEvjs/FyfP6mkomYfe8Op
         Yu+Pi2UUnT/XBV/I24KBfVchlbGTgMYU2qRrwCibuGX0L8HOwK2eAY1bIh6Gd4bmDHOK
         jvdH5w+ZVhRnszQUqkgVXBfxqIWLfpNBa5tZ1Y+Xn8EzjJ0yAfsiq4pMs3EnGU0GtvzV
         /r5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MEUK24U0BQI/RmjuOG97a0RuEOXEO0NMWXCnh+8+ycU=;
        b=mQyY4gwShNZzU4CTGse84YGMCFZx7cPTrprUv0M68+Bav0PUrGQLm0sVOWbTGi6L4G
         7m6oxjn7SCSkQhogy/VNSxSaj9z4KWLLITkW2ls26A7tsanHFZsR05nVW7z2VpGCi8A/
         xWzOjyphXE37gmMPLvcUMa9Qn2PmSLvUnTblZlQ9sx+NAc1o+xWWvCzVLFZehEyRW3Tp
         Rv9ymEqhX2w/1H89JlJscK1BfX5DJOuriyE0zG+JCOAzTvyJNf6Kf0Cz5cvmrQkAmrMt
         eSeGHVuRi9GdGNSMZ70MxMSW6CjjpSUfBtIJovLt1WzG5LUWzkaCb9ULiaZxPsYKg87L
         hNOA==
X-Gm-Message-State: AOAM531/x0qT0Smh8gk/EzkFiSaXuLlVHADsRI9LrZuiLJGtmXVEMtJ2
        3hdB4+Ia072UyOQYfaFY7EnUFsLHBt8=
X-Google-Smtp-Source: ABdhPJwDCB+Xy4Ty0MSdlI0yhG4DHFkzbkkzr5WuulNpPfT5/m/vDOOFMEE92KNI2QS0sKDOX4Eo4/jpSt8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:94:: with SMTP id
 bb20mr2309851pjb.210.1637804990280; Wed, 24 Nov 2021 17:49:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:49:43 +0000
In-Reply-To: <20211125014944.536398-1-seanjc@google.com>
Message-Id: <20211125014944.536398-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211125014944.536398-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 1/2] KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Flush the current VPID when handling KVM_REQ_TLB_FLUSH_GUEST instead of
always flushing vpid01.  Any TLB flush that is triggered when L2 is
active is scoped to L2's VPID (if it has one), e.g. if L2 toggles CR4.PGE
and L1 doesn't intercept PGE writes, then KVM's emulation of the TLB
flush needs to be applied to L2's VPID.

Like KVM_REQ_TLB_FLUSH_CURRENT, the GUEST variant needs to be serviced at
nested transitions, as KVM doesn't track requests for L1 vs L2.  E.g. if
there's a pending flush when a nested VM-Exit occurs, then the flush was
requested in the context of L2 and needs to be handled before switching
to L1, otherwise the flush for L2 would effectiely be lost.

Opportunistically add a helper to handle CURRENT and GUEST as a pair, the
logic for when they need to be serviced is identical as both requests are
tied to L1 vs. L2, the only difference is the scope of the flush.

Reported-by: Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Fixes: 07ffaf343e34 ("KVM: nVMX: Sync all PGDs on nested transition with shadow paging")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c |  8 +++-----
 arch/x86/kvm/vmx/vmx.c    | 23 ++++++++++++++---------
 arch/x86/kvm/x86.c        | 28 ++++++++++++++++++++++++----
 arch/x86/kvm/x86.h        |  7 +------
 4 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2d9565b37fe0..2ef1d5562a54 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3344,8 +3344,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	};
 	u32 failed_index;
 
-	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
-		kvm_vcpu_flush_tlb_current(vcpu);
+	kvm_service_local_tlb_flush_requests(vcpu);
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
 		(CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITING);
@@ -4502,9 +4501,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		(void)nested_get_evmcs_page(vcpu);
 	}
 
-	/* Service the TLB flush request for L2 before switching to L1. */
-	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
-		kvm_vcpu_flush_tlb_current(vcpu);
+	/* Service pending TLB flush requests for L2 before switching to L1. */
+	kvm_service_local_tlb_flush_requests(vcpu);
 
 	/*
 	 * VCPU_EXREG_PDPTR will be clobbered in arch/x86/kvm/vmx/vmx.h between
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3127c66a1651..226b06f1ddd1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2918,6 +2918,13 @@ static void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
 	}
 }
 
+static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
+{
+	if (is_guest_mode(vcpu))
+		return nested_get_vpid02(vcpu);
+	return to_vmx(vcpu)->vpid;
+}
+
 static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -2930,31 +2937,29 @@ static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 	if (enable_ept)
 		ept_sync_context(construct_eptp(vcpu, root_hpa,
 						mmu->shadow_root_level));
-	else if (!is_guest_mode(vcpu))
-		vpid_sync_context(to_vmx(vcpu)->vpid);
 	else
-		vpid_sync_context(nested_get_vpid02(vcpu));
+		vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
 
 static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	/*
-	 * vpid_sync_vcpu_addr() is a nop if vmx->vpid==0, see the comment in
+	 * vpid_sync_vcpu_addr() is a nop if vpid==0, see the comment in
 	 * vmx_flush_tlb_guest() for an explanation of why this is ok.
 	 */
-	vpid_sync_vcpu_addr(to_vmx(vcpu)->vpid, addr);
+	vpid_sync_vcpu_addr(vmx_get_current_vpid(vcpu), addr);
 }
 
 static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * vpid_sync_context() is a nop if vmx->vpid==0, e.g. if enable_vpid==0
-	 * or a vpid couldn't be allocated for this vCPU.  VM-Enter and VM-Exit
-	 * are required to flush GVA->{G,H}PA mappings from the TLB if vpid is
+	 * vpid_sync_context() is a nop if vpid==0, e.g. if enable_vpid==0 or a
+	 * vpid couldn't be allocated for this vCPU.  VM-Enter and VM-Exit are
+	 * required to flush GVA->{G,H}PA mappings from the TLB if vpid is
 	 * disabled (VM-Enter with vpid enabled and vpid==0 is disallowed),
 	 * i.e. no explicit INVVPID is necessary.
 	 */
-	vpid_sync_context(to_vmx(vcpu)->vpid);
+	vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
 
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04e8dabc187d..9b9b27ef3655 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3258,6 +3258,29 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_tlb_flush_guest)(vcpu);
 }
 
+
+static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	++vcpu->stat.tlb_flush;
+	static_call(kvm_x86_tlb_flush_current)(vcpu);
+}
+
+/*
+ * Service "local" TLB flush requests, which are specific to the current MMU
+ * context.  In addition to the generic event handling in vcpu_enter_guest(),
+ * TLB flushes that are targeted at an MMU context also need to be serviced
+ * prior before nested VM-Enter/VM-Exit.
+ */
+void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
+{
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
+		kvm_vcpu_flush_tlb_current(vcpu);
+
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
+		kvm_vcpu_flush_tlb_guest(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
+
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
@@ -9653,10 +9676,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			/* Flushing all ASIDs flushes the current ASID... */
 			kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}
-		if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
-			kvm_vcpu_flush_tlb_current(vcpu);
-		if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
-			kvm_vcpu_flush_tlb_guest(vcpu);
+		kvm_service_local_tlb_flush_requests(vcpu);
 
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 997669ae9caa..4abcd8d9836d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -103,6 +103,7 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
 
 #define MSR_IA32_CR_PAT_DEFAULT  0x0007040600070406ULL
 
+void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
 int kvm_check_nested_events(struct kvm_vcpu *vcpu);
 
 static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
@@ -185,12 +186,6 @@ static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)
 	return vcpu->arch.walk_mmu == &vcpu->arch.nested_mmu;
 }
 
-static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
-{
-	++vcpu->stat.tlb_flush;
-	static_call(kvm_x86_tlb_flush_current)(vcpu);
-}
-
 static inline int is_pae(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr4_bits(vcpu, X86_CR4_PAE);
-- 
2.34.0.rc2.393.gf8c9666880-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE813A20EC
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhFIXpT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhFIXpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:45:09 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BEAC0617AF
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 16:42:56 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id m18-20020a05622a1192b0290247a89f63bcso5938214qtk.20
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=IaHvriPR1ilnz00LgSKYZNDwy+t0L+MzDKmguXPVTIU=;
        b=MHgOPpSpKZ+onNecVS/T1TDwOCedi+KOQmXbTeAm/KuGD3YTLADXeur6XvPWjGKp9a
         0DALtfjZ94/elE2wLmLX8UfS7MtgLC39VFTYx3b4DL5EcMhpeCENrvOGnc6hwVtgDB8t
         8bMwaCu28N7N9SulkZtEe459ldZZPgoIrh3m/e6kzaCjZHHPahFgJjHpjhdHFzGwoC6V
         htNM/xWI2HlYCcZ85s1ynnDjTTBqfsIbV6clg9oBvpjB/ecGnft6AneNKDN27HaE/hNx
         ASu+EalLdUJu6ZmxbFS/QUtd1wQ/tknQeXvj4PGYlex4+uq6/LCQ+j/f+MuxLXAjI5Di
         B6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=IaHvriPR1ilnz00LgSKYZNDwy+t0L+MzDKmguXPVTIU=;
        b=R1LMJM42zsJFKpTEnZaTK8VWf/rLGBCaPC6IVPIFzu8YU1yvmlikeDbAyGRdz1VY4L
         LrR1O4OxuQBuNgN0LjwPrc2QShRVijlz1qA/qUWPclFD25ScPnuOfImSGr1vUpU/wGre
         VhmTLZenNAhk5Yi7WBuht084Ebjzb0/QTgm3Tg0p29SUi8r4wRgmUYjS92aehi4D1ckS
         pYha1Jc4V8byCb04lNtN1QX2oWsIuC5T8oFw0tw88+kaJ6zh+Kn/3Z9pa+9nkljnuzyW
         vTL3KXmzo7r89jZFnhAGd56JTq1gw3UJGN3tzdM6Jo8ryRGRzv0OVpnSboFaC2/555ru
         1Nvw==
X-Gm-Message-State: AOAM533F8qRO0oDG0vSwN0sL5VWOQjv0RgojanZuisI2+8MFbf0QwYN2
        ie/AHNVF1beDWF2cblnJLO2wywTy8e4=
X-Google-Smtp-Source: ABdhPJz+QZrNtj4Rku4gjD033qxRenTviSAlZ1fQ8xlfDY3NGP6a/NZJNOML9KwqS+Vleoo+POLZt8kZENs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:a0c:f582:: with SMTP id k2mr2424200qvm.51.1623282176141;
 Wed, 09 Jun 2021 16:42:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:26 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 06/15] KVM: nSVM: Move TLB flushing logic (or lack thereof) to
 dedicated helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce nested_svm_transition_tlb_flush() and use it force an MMU sync
and TLB flush on nSVM VM-Enter and VM-Exit instead of sneaking the logic
into the __kvm_mmu_new_pgd() call sites.  Add a partial todo list to
document issues that need to be addressed before the unconditional sync
and flush can be modified to look more like nVMX's logic.

In addition to making nSVM's forced flushing more overt (guess who keeps
losing track of it), the new helper brings further convergence between
nSVM and nVMX, and also sets the stage for dropping the "skip" params
from __kvm_mmu_new_pgd().

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c    |  2 +-
 arch/x86/kvm/svm/nested.c | 38 +++++++++++++++++++++++++++++---------
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0144c40d09c7..d7f29bf94ca3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4648,7 +4648,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	union kvm_mmu_role new_role = kvm_calc_shadow_npt_root_page_role(vcpu);
 
-	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base, false, false);
+	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base, true, true);
 
 	if (new_role.as_u64 != context->mmu_role.as_u64) {
 		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e8d8443154e..fe2705557960 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -380,6 +380,25 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
 }
 
+static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
+	 * things to fix before this can be conditional:
+	 *
+	 *  - Flush TLBs for both L1 and L2 remote TLB flush
+	 *  - Honor L1's request to flush an ASID on nested VMRUN
+	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
+	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
+	 *  - Flush L1's ASID on KVM_REQ_TLB_FLUSH_GUEST
+	 *
+	 * [*] Unlike nested EPT, SVM's ASID management can invalidate nested
+	 *     NPT guest-physical mappings on VMRUN.
+	 */
+	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
+	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+}
+
 /*
  * Load guest's/host's cr3 on nested vmentry or vmexit. @nested_npt is true
  * if we are emulating VM-Entry into a guest with NPT enabled.
@@ -396,12 +415,8 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 			return -EINVAL;
 	}
 
-	/*
-	 * TODO: optimize unconditional TLB flush/MMU sync here and in
-	 * kvm_init_shadow_npt_mmu().
-	 */
 	if (!nested_npt)
-		kvm_mmu_new_pgd(vcpu, cr3, false, false);
+		kvm_mmu_new_pgd(vcpu, cr3, true, true);
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
@@ -481,6 +496,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
 	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	/*
 	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
@@ -505,10 +521,10 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 
 	/* nested_cr3.  */
 	if (nested_npt_enabled(svm))
-		nested_svm_init_mmu_context(&svm->vcpu);
+		nested_svm_init_mmu_context(vcpu);
 
-	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
-		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
+	svm->vmcb->control.tsc_offset = vcpu->arch.tsc_offset =
+		vcpu->arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
 
 	svm->vmcb->control.int_ctl             =
 		(svm->nested.ctl.int_ctl & ~mask) |
@@ -523,8 +539,10 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	svm->vmcb->control.pause_filter_count  = svm->nested.ctl.pause_filter_count;
 	svm->vmcb->control.pause_filter_thresh = svm->nested.ctl.pause_filter_thresh;
 
+	nested_svm_transition_tlb_flush(vcpu);
+
 	/* Enter Guest-Mode */
-	enter_guest_mode(&svm->vcpu);
+	enter_guest_mode(vcpu);
 
 	/*
 	 * Merge guest and host intercepts - must be called with vcpu in
@@ -803,6 +821,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	kvm_vcpu_unmap(vcpu, &map, true);
 
+	nested_svm_transition_tlb_flush(vcpu);
+
 	nested_svm_uninit_mmu_context(vcpu);
 
 	rc = nested_svm_load_cr3(vcpu, svm->vmcb->save.cr3, false);
-- 
2.32.0.rc1.229.g3e70b5a671-goog


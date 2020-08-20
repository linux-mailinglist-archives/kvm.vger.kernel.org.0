Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9533C24B1DF
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 11:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHTJOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 05:14:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726309AbgHTJOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 05:14:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597914852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Peu0So29goC0kwU0oEhiX4gY9t6XgKmP71nwrfXlKus=;
        b=LshiRgxXTjX/o2P9s3WGn5n886knMPqfSzKky7FR8mSdBPsnbvyLUzelLVfKvInQn9M+2+
        aH1+I7ZVFqKxUgaJ2KAUxHxvw3NTdc2ZZ9tXbZFLAlG72SLunaVbph/iwQ8nQvOU+uXU1/
        zxje73gm6KFpLgSLXkUoY2zJy8QOmYM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-9Hzw8yB3MFSKMQ7_y4BPbg-1; Thu, 20 Aug 2020 05:13:57 -0400
X-MC-Unique: 9Hzw8yB3MFSKMQ7_y4BPbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45AB71006706;
        Thu, 20 Aug 2020 09:13:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D491A747B0;
        Thu, 20 Aug 2020 09:13:52 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 6/8] SVM: nSVM: cache whole nested vmcb instead of only its control area
Date:   Thu, 20 Aug 2020 12:13:25 +0300
Message-Id: <20200820091327.197807-7-mlevitsk@redhat.com>
In-Reply-To: <20200820091327.197807-1-mlevitsk@redhat.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Until now we were only caching the 'control' are of the vmcb, but we will
want soon to have some checks on the data area as well and this caching
will allow us to fix various races that can happen if a (malicious) guest
changes parts of the 'save' area during vm entry.

No functional change intended other that slightly higher memory usage,
since this patch doesn't touch the data area of the cached vmcb.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 96 +++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.c    | 10 ++--
 arch/x86/kvm/svm/svm.h    | 15 +++---
 3 files changed, 69 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b6704611fc02..c9bb17e9ba11 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -54,7 +54,7 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	u64 cr3 = svm->nested.ctl.nested_cr3;
+	u64 cr3 = svm->nested.vmcb->control.nested_cr3;
 	u64 pdpte;
 	int ret;
 
@@ -69,7 +69,7 @@ static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	return svm->nested.ctl.nested_cr3;
+	return svm->nested.vmcb->control.nested_cr3;
 }
 
 static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
@@ -81,7 +81,7 @@ static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
 	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, hsave->save.cr4, hsave->save.efer,
-				svm->nested.ctl.nested_cr3);
+				svm->nested.vmcb->control.nested_cr3);
 	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
 	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
 	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
@@ -106,7 +106,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 
 	c = &svm->vmcb->control;
 	h = &svm->nested.hsave->control;
-	g = &svm->nested.ctl;
+	g = &svm->nested.vmcb->control;
 
 	svm->nested.host_intercept_exceptions = h->intercept_exceptions;
 
@@ -176,7 +176,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	 */
 	int i;
 
-	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+	if (!(svm->nested.vmcb->control.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return true;
 
 	for (i = 0; i < MSRPM_OFFSETS; i++) {
@@ -187,7 +187,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 			break;
 
 		p      = msrpm_offsets[i];
-		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
+		offset = svm->nested.vmcb->control.msrpm_base_pa + (p * 4);
 
 		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4))
 			return false;
@@ -255,12 +255,12 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
 static void load_nested_vmcb_control(struct vcpu_svm *svm,
 				     struct vmcb_control_area *control)
 {
-	copy_vmcb_control_area(&svm->nested.ctl, control);
+	copy_vmcb_control_area(&svm->nested.vmcb->control, control);
 
 	/* Copy it here because nested_svm_check_controls will check it.  */
-	svm->nested.ctl.asid           = control->asid;
-	svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
-	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
+	svm->nested.vmcb->control.asid           = control->asid;
+	svm->nested.vmcb->control.msrpm_base_pa &= ~0x0fffULL;
+	svm->nested.vmcb->control.iopm_base_pa  &= ~0x0fffULL;
 }
 
 /*
@@ -270,12 +270,12 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
 void sync_nested_vmcb_control(struct vcpu_svm *svm)
 {
 	u32 mask;
-	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
-	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
+	svm->nested.vmcb->control.event_inj      = svm->vmcb->control.event_inj;
+	svm->nested.vmcb->control.event_inj_err  = svm->vmcb->control.event_inj_err;
 
 	/* Only a few fields of int_ctl are written by the processor.  */
 	mask = V_IRQ_MASK | V_TPR_MASK;
-	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
+	if (!(svm->nested.vmcb->control.int_ctl & V_INTR_MASKING_MASK) &&
 	    svm_is_intercept(svm, INTERCEPT_VINTR)) {
 		/*
 		 * In order to request an interrupt window, L0 is usurping
@@ -287,8 +287,8 @@ void sync_nested_vmcb_control(struct vcpu_svm *svm)
 		 */
 		mask &= ~V_IRQ_MASK;
 	}
-	svm->nested.ctl.int_ctl        &= ~mask;
-	svm->nested.ctl.int_ctl        |= svm->vmcb->control.int_ctl & mask;
+	svm->nested.vmcb->control.int_ctl        &= ~mask;
+	svm->nested.vmcb->control.int_ctl        |= svm->vmcb->control.int_ctl & mask;
 }
 
 /*
@@ -330,7 +330,7 @@ static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
 
 static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 {
-	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
+	return svm->nested.vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
 }
 
 /*
@@ -399,20 +399,20 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 		nested_svm_init_mmu_context(&svm->vcpu);
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
-		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
+		svm->vcpu.arch.l1_tsc_offset + svm->nested.vmcb->control.tsc_offset;
 
 	svm->vmcb->control.int_ctl             =
-		(svm->nested.ctl.int_ctl & ~mask) |
+		(svm->nested.vmcb->control.int_ctl & ~mask) |
 		(svm->nested.hsave->control.int_ctl & mask);
 
-	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
-	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
-	svm->vmcb->control.int_state           = svm->nested.ctl.int_state;
-	svm->vmcb->control.event_inj           = svm->nested.ctl.event_inj;
-	svm->vmcb->control.event_inj_err       = svm->nested.ctl.event_inj_err;
+	svm->vmcb->control.virt_ext            = svm->nested.vmcb->control.virt_ext;
+	svm->vmcb->control.int_vector          = svm->nested.vmcb->control.int_vector;
+	svm->vmcb->control.int_state           = svm->nested.vmcb->control.int_state;
+	svm->vmcb->control.event_inj           = svm->nested.vmcb->control.event_inj;
+	svm->vmcb->control.event_inj_err       = svm->nested.vmcb->control.event_inj_err;
 
-	svm->vmcb->control.pause_filter_count  = svm->nested.ctl.pause_filter_count;
-	svm->vmcb->control.pause_filter_thresh = svm->nested.ctl.pause_filter_thresh;
+	svm->vmcb->control.pause_filter_count  = svm->nested.vmcb->control.pause_filter_count;
+	svm->vmcb->control.pause_filter_thresh = svm->nested.vmcb->control.pause_filter_thresh;
 
 	/* Enter Guest-Mode */
 	enter_guest_mode(&svm->vcpu);
@@ -622,10 +622,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (svm->nrips_enabled)
 		nested_vmcb->control.next_rip  = vmcb->control.next_rip;
 
-	nested_vmcb->control.int_ctl           = svm->nested.ctl.int_ctl;
-	nested_vmcb->control.tlb_ctl           = svm->nested.ctl.tlb_ctl;
-	nested_vmcb->control.event_inj         = svm->nested.ctl.event_inj;
-	nested_vmcb->control.event_inj_err     = svm->nested.ctl.event_inj_err;
+	nested_vmcb->control.int_ctl           = svm->nested.vmcb->control.int_ctl;
+	nested_vmcb->control.tlb_ctl           = svm->nested.vmcb->control.tlb_ctl;
+	nested_vmcb->control.event_inj         = svm->nested.vmcb->control.event_inj;
+	nested_vmcb->control.event_inj_err     = svm->nested.vmcb->control.event_inj_err;
 
 	nested_vmcb->control.pause_filter_count =
 		svm->vmcb->control.pause_filter_count;
@@ -638,7 +638,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset;
 
-	svm->nested.ctl.nested_cr3 = 0;
+	svm->nested.vmcb->control.nested_cr3 = 0;
 
 	/* Restore selected save entries */
 	svm->vmcb->save.es = hsave->save.es;
@@ -692,6 +692,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 int svm_allocate_nested(struct vcpu_svm *svm)
 {
 	struct page *hsave_page;
+	struct page *vmcb_page;
 
 	if (svm->nested.initialized)
 		return 0;
@@ -707,8 +708,18 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 	if (!svm->nested.msrpm)
 		goto free_page2;
 
+	vmcb_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!vmcb_page)
+		goto free_page3;
+
+	svm->nested.vmcb = page_address(vmcb_page);
+	clear_page(svm->nested.vmcb);
+
 	svm->nested.initialized = true;
 	return 0;
+
+free_page3:
+	svm_vcpu_free_msrpm(svm->nested.msrpm);
 free_page2:
 	__free_page(hsave_page);
 free_page1:
@@ -726,6 +737,9 @@ void svm_free_nested(struct vcpu_svm *svm)
 	__free_page(virt_to_page(svm->nested.hsave));
 	svm->nested.hsave = NULL;
 
+	__free_page(virt_to_page(svm->nested.vmcb));
+	svm->nested.vmcb = NULL;
+
 	svm->nested.initialized = false;
 }
 
@@ -750,7 +764,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	u32 offset, msr, value;
 	int write, mask;
 
-	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+	if (!(svm->nested.vmcb->control.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
 
 	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
@@ -764,7 +778,9 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	/* Offset is in 32 bit units but need in 8 bit units */
 	offset *= 4;
 
-	if (kvm_vcpu_read_guest(&svm->vcpu, svm->nested.ctl.msrpm_base_pa + offset, &value, 4))
+	if (kvm_vcpu_read_guest(&svm->vcpu,
+				svm->nested.vmcb->control.msrpm_base_pa + offset,
+				&value, 4))
 		return NESTED_EXIT_DONE;
 
 	return (value & mask) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
@@ -777,13 +793,13 @@ static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
 	u8 start_bit;
 	u64 gpa;
 
-	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
+	if (!(svm->nested.vmcb->control.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
 		return NESTED_EXIT_HOST;
 
 	port = svm->vmcb->control.exit_info_1 >> 16;
 	size = (svm->vmcb->control.exit_info_1 & SVM_IOIO_SIZE_MASK) >>
 		SVM_IOIO_SIZE_SHIFT;
-	gpa  = svm->nested.ctl.iopm_base_pa + (port / 8);
+	gpa  = svm->nested.vmcb->control.iopm_base_pa + (port / 8);
 	start_bit = port % 8;
 	iopm_len = (start_bit + size > 8) ? 2 : 1;
 	mask = (0xf >> (4 - size)) << start_bit;
@@ -809,13 +825,13 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		break;
 	case SVM_EXIT_READ_CR0 ... SVM_EXIT_WRITE_CR8: {
 		u32 bit = 1U << (exit_code - SVM_EXIT_READ_CR0);
-		if (svm->nested.ctl.intercept_cr & bit)
+		if (svm->nested.vmcb->control.intercept_cr & bit)
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
 	case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
 		u32 bit = 1U << (exit_code - SVM_EXIT_READ_DR0);
-		if (svm->nested.ctl.intercept_dr & bit)
+		if (svm->nested.vmcb->control.intercept_dr & bit)
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
@@ -834,7 +850,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 	}
 	default: {
 		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
-		if (svm->nested.ctl.intercept & exit_bits)
+		if (svm->nested.vmcb->control.intercept & exit_bits)
 			vmexit = NESTED_EXIT_DONE;
 	}
 	}
@@ -874,7 +890,7 @@ static bool nested_exit_on_exception(struct vcpu_svm *svm)
 {
 	unsigned int nr = svm->vcpu.arch.exception.nr;
 
-	return (svm->nested.ctl.intercept_exceptions & (1 << nr));
+	return (svm->nested.vmcb->control.intercept_exceptions & (1 << nr));
 }
 
 static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
@@ -942,7 +958,7 @@ static void nested_svm_intr(struct vcpu_svm *svm)
 
 static inline bool nested_exit_on_init(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INIT));
+	return (svm->nested.vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
 }
 
 static void nested_svm_init(struct vcpu_svm *svm)
@@ -1084,7 +1100,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	 */
 	if (clear_user(user_vmcb, KVM_STATE_NESTED_SVM_VMCB_SIZE))
 		return -EFAULT;
-	if (copy_to_user(&user_vmcb->control, &svm->nested.ctl,
+	if (copy_to_user(&user_vmcb->control, &svm->nested.vmcb->control,
 			 sizeof(user_vmcb->control)))
 		return -EFAULT;
 	if (copy_to_user(&user_vmcb->save, &svm->nested.hsave->save,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d941acc36b50..0af51b54c9f5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1400,8 +1400,8 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 		svm->nested.hsave->control.int_ctl &= mask;
 
 		WARN_ON((svm->vmcb->control.int_ctl & V_TPR_MASK) !=
-			(svm->nested.ctl.int_ctl & V_TPR_MASK));
-		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl & ~mask;
+			(svm->nested.vmcb->control.int_ctl & V_TPR_MASK));
+		svm->vmcb->control.int_ctl |= svm->nested.vmcb->control.int_ctl & ~mask;
 	}
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
@@ -2224,7 +2224,7 @@ static bool check_selective_cr0_intercepted(struct vcpu_svm *svm,
 	bool ret = false;
 	u64 intercept;
 
-	intercept = svm->nested.ctl.intercept;
+	intercept = svm->nested.vmcb->control.intercept;
 
 	if (!is_guest_mode(&svm->vcpu) ||
 	    (!(intercept & (1ULL << INTERCEPT_SELECTIVE_CR0))))
@@ -3132,7 +3132,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 
 	if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
-		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
+		if ((svm->nested.vmcb->control.int_ctl & V_INTR_MASKING_MASK)
 		    ? !(svm->nested.hsave->save.rflags & X86_EFLAGS_IF)
 		    : !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
 			return true;
@@ -3751,7 +3751,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		    info->intercept == x86_intercept_clts)
 			break;
 
-		intercept = svm->nested.ctl.intercept;
+		intercept = svm->nested.vmcb->control.intercept;
 
 		if (!(intercept & (1ULL << INTERCEPT_SELECTIVE_CR0)))
 			break;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9dca64a2edb5..1669755f796e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -85,7 +85,11 @@ struct svm_nested_state {
 	struct vmcb *hsave;
 	u64 hsave_msr;
 	u64 vm_cr_msr;
+
+	/* guest mode vmcb, aka vmcb12*/
+	struct vmcb *vmcb;
 	u64 vmcb_gpa;
+
 	u32 host_intercept_exceptions;
 
 	/* These are the merged vectors */
@@ -95,9 +99,6 @@ struct svm_nested_state {
 	 * we cannot inject a nested vmexit yet.  */
 	bool nested_run_pending;
 
-	/* cache for control fields of the guest */
-	struct vmcb_control_area ctl;
-
 	bool initialized;
 };
 
@@ -373,22 +374,22 @@ static inline bool nested_svm_virtualize_tpr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	return is_guest_mode(vcpu) && (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK);
+	return is_guest_mode(vcpu) && (svm->nested.vmcb->control.int_ctl & V_INTR_MASKING_MASK);
 }
 
 static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_SMI));
+	return (svm->nested.vmcb->control.intercept & (1ULL << INTERCEPT_SMI));
 }
 
 static inline bool nested_exit_on_intr(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INTR));
+	return (svm->nested.vmcb->control.intercept & (1ULL << INTERCEPT_INTR));
 }
 
 static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 {
-	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_NMI));
+	return (svm->nested.vmcb->control.intercept & (1ULL << INTERCEPT_NMI));
 }
 
 int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-- 
2.26.2


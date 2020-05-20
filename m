Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F04D1DBB48
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgETRX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:23:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53368 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728046AbgETRWO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 13:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=FMOPd6BM86UupJVQWE47ES4+9V7BqT84btawir6AkT4=;
        b=TwitjXP0O2t7mjZbl8xVdLG8rG8GJ1XP0F1Etp9zAFYnMPg9cs5wMH5Z2EdujGChiCkhM9
        glMpEMH5Yr2tOzAzsZo3FbBptP7LWWTkDR8A+oQfBA/hrLOGKLva8/aY9XyUOqryC3X08r
        COuy2Q5d9d0XJtC7DzqTLKYtbLPzJUg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-U8HHjcNXMeKlqDaTwMRHyA-1; Wed, 20 May 2020 13:22:10 -0400
X-MC-Unique: U8HHjcNXMeKlqDaTwMRHyA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5EEB8B7850;
        Wed, 20 May 2020 17:22:00 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 127CE70461;
        Wed, 20 May 2020 17:21:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 12/24] KVM: nSVM: save all control fields in svm->nested
Date:   Wed, 20 May 2020 13:21:33 -0400
Message-Id: <20200520172145.23284-13-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for nested SVM save/restore, store all data that matters
from the VMCB control area into svm->nested.  It will then become part
of the nested SVM state that is saved by KVM_SET_NESTED_STATE and
restored by KVM_GET_NESTED_STATE, just like the cached vmcs12 for nVMX.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 73 +++++++++++++++++----------------------
 arch/x86/kvm/svm/svm.c    | 10 ++++--
 arch/x86/kvm/svm/svm.h    | 20 +++--------
 3 files changed, 45 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c759124ed6af..9999bce9adcf 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -60,7 +60,7 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	u64 cr3 = svm->nested.nested_cr3;
+	u64 cr3 = svm->nested.ctl.nested_cr3;
 	u64 pdpte;
 	int ret;
 
@@ -75,7 +75,7 @@ static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	return svm->nested.nested_cr3;
+	return svm->nested.ctl.nested_cr3;
 }
 
 static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
@@ -100,8 +100,7 @@ static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
 
 void recalc_intercepts(struct vcpu_svm *svm)
 {
-	struct vmcb_control_area *c, *h;
-	struct nested_state *g;
+	struct vmcb_control_area *c, *h, *g;
 
 	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 
@@ -110,7 +109,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 
 	c = &svm->vmcb->control;
 	h = &svm->nested.hsave->control;
-	g = &svm->nested;
+	g = &svm->nested.ctl;
 
 	svm->nested.host_intercept_exceptions = h->intercept_exceptions;
 
@@ -180,7 +179,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	 */
 	int i;
 
-	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return true;
 
 	for (i = 0; i < MSRPM_OFFSETS; i++) {
@@ -191,7 +190,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 			break;
 
 		p      = msrpm_offsets[i];
-		offset = svm->nested.vmcb_msrpm + (p * 4);
+		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
 
 		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4))
 			return false;
@@ -229,16 +228,10 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 static void load_nested_vmcb_control(struct vcpu_svm *svm,
 				     struct vmcb_control_area *control)
 {
-	svm->nested.nested_cr3 = control->nested_cr3;
+	copy_vmcb_control_area(&svm->nested.ctl, control);
 
-	svm->nested.vmcb_msrpm = control->msrpm_base_pa & ~0x0fffULL;
-	svm->nested.vmcb_iopm  = control->iopm_base_pa  & ~0x0fffULL;
-
-	/* cache intercepts */
-	svm->nested.intercept_cr         = control->intercept_cr;
-	svm->nested.intercept_dr         = control->intercept_dr;
-	svm->nested.intercept_exceptions = control->intercept_exceptions;
-	svm->nested.intercept            = control->intercept;
+	svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
+	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
 }
 
 static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
@@ -274,34 +267,32 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
 }
 
-static void nested_prepare_vmcb_control(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
+static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 {
-	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
+	if (svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
 		nested_svm_init_mmu_context(&svm->vcpu);
 
 	/* Guest paging mode is active - reset mmu */
 	kvm_mmu_reset_context(&svm->vcpu);
 
 	svm_flush_tlb(&svm->vcpu);
-	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
+	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
 	else
 		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
-		svm->vcpu.arch.l1_tsc_offset + nested_vmcb->control.tsc_offset;
+		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
 
-	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
-	svm->vmcb->control.virt_ext = nested_vmcb->control.virt_ext;
-	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
-	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
-	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
-	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
+	svm->vmcb->control.int_ctl             = svm->nested.ctl.int_ctl | V_INTR_MASKING_MASK;
+	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
+	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
+	svm->vmcb->control.int_state           = svm->nested.ctl.int_state;
+	svm->vmcb->control.event_inj           = svm->nested.ctl.event_inj;
+	svm->vmcb->control.event_inj_err       = svm->nested.ctl.event_inj_err;
 
-	svm->vmcb->control.pause_filter_count =
-		nested_vmcb->control.pause_filter_count;
-	svm->vmcb->control.pause_filter_thresh =
-		nested_vmcb->control.pause_filter_thresh;
+	svm->vmcb->control.pause_filter_count  = svm->nested.ctl.pause_filter_count;
+	svm->vmcb->control.pause_filter_thresh = svm->nested.ctl.pause_filter_thresh;
 
 	/* Enter Guest-Mode */
 	enter_guest_mode(&svm->vcpu);
@@ -330,7 +321,7 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 
 	load_nested_vmcb_control(svm, &nested_vmcb->control);
 	nested_prepare_vmcb_save(svm, nested_vmcb);
-	nested_prepare_vmcb_control(svm, nested_vmcb);
+	nested_prepare_vmcb_control(svm);
 
 	/*
 	 * If L1 had a pending IRQ/NMI before executing VMRUN,
@@ -560,7 +551,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
-	svm->nested.nested_cr3 = 0;
+	svm->nested.ctl.nested_cr3 = 0;
 
 	/* Restore selected save entries */
 	svm->vmcb->save.es = hsave->save.es;
@@ -610,7 +601,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	u32 offset, msr, value;
 	int write, mask;
 
-	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
 
 	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
@@ -624,7 +615,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	/* Offset is in 32 bit units but need in 8 bit units */
 	offset *= 4;
 
-	if (kvm_vcpu_read_guest(&svm->vcpu, svm->nested.vmcb_msrpm + offset, &value, 4))
+	if (kvm_vcpu_read_guest(&svm->vcpu, svm->nested.ctl.msrpm_base_pa + offset, &value, 4))
 		return NESTED_EXIT_DONE;
 
 	return (value & mask) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
@@ -637,13 +628,13 @@ static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
 	u8 start_bit;
 	u64 gpa;
 
-	if (!(svm->nested.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
+	if (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
 		return NESTED_EXIT_HOST;
 
 	port = svm->vmcb->control.exit_info_1 >> 16;
 	size = (svm->vmcb->control.exit_info_1 & SVM_IOIO_SIZE_MASK) >>
 		SVM_IOIO_SIZE_SHIFT;
-	gpa  = svm->nested.vmcb_iopm + (port / 8);
+	gpa  = svm->nested.ctl.iopm_base_pa + (port / 8);
 	start_bit = port % 8;
 	iopm_len = (start_bit + size > 8) ? 2 : 1;
 	mask = (0xf >> (4 - size)) << start_bit;
@@ -669,13 +660,13 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		break;
 	case SVM_EXIT_READ_CR0 ... SVM_EXIT_WRITE_CR8: {
 		u32 bit = 1U << (exit_code - SVM_EXIT_READ_CR0);
-		if (svm->nested.intercept_cr & bit)
+		if (svm->nested.ctl.intercept_cr & bit)
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
 	case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
 		u32 bit = 1U << (exit_code - SVM_EXIT_READ_DR0);
-		if (svm->nested.intercept_dr & bit)
+		if (svm->nested.ctl.intercept_dr & bit)
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
@@ -694,7 +685,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 	}
 	default: {
 		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
-		if (svm->nested.intercept & exit_bits)
+		if (svm->nested.ctl.intercept & exit_bits)
 			vmexit = NESTED_EXIT_DONE;
 	}
 	}
@@ -734,7 +725,7 @@ static bool nested_exit_on_exception(struct vcpu_svm *svm)
 {
 	unsigned int nr = svm->vcpu.arch.exception.nr;
 
-	return (svm->nested.intercept_exceptions & (1 << nr));
+	return (svm->nested.ctl.intercept_exceptions & (1 << nr));
 }
 
 static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
@@ -795,7 +786,7 @@ static void nested_svm_intr(struct vcpu_svm *svm)
 
 static inline bool nested_exit_on_init(struct vcpu_svm *svm)
 {
-	return (svm->nested.intercept & (1ULL << INTERCEPT_INIT));
+	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INIT));
 }
 
 static void nested_svm_init(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 47c565338426..ffb349739e0c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2173,7 +2173,7 @@ static bool check_selective_cr0_intercepted(struct vcpu_svm *svm,
 	bool ret = false;
 	u64 intercept;
 
-	intercept = svm->nested.intercept;
+	intercept = svm->nested.ctl.intercept;
 
 	if (!is_guest_mode(&svm->vcpu) ||
 	    (!(intercept & (1ULL << INTERCEPT_SELECTIVE_CR0))))
@@ -3320,6 +3320,12 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
 
+	if (unlikely(svm->nested.nested_run_pending)) {
+		/* After this vmentry, these fields will be used up.  */
+		svm->nested.ctl.event_inj     = 0;
+		svm->nested.ctl.event_inj_err = 0;
+	}
+
 	/*
 	 * Disable singlestep if we're injecting an interrupt/exception.
 	 * We don't want our modified rflags to be pushed on the stack where
@@ -3655,7 +3661,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		    info->intercept == x86_intercept_clts)
 			break;
 
-		intercept = svm->nested.intercept;
+		intercept = svm->nested.ctl.intercept;
 
 		if (!(intercept & (1ULL << INTERCEPT_SELECTIVE_CR0)))
 			break;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 33e3f09d7a8e..dd5418f20256 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -91,22 +91,12 @@ struct nested_state {
 	/* These are the merged vectors */
 	u32 *msrpm;
 
-	/* gpa pointers to the real vectors */
-	u64 vmcb_msrpm;
-	u64 vmcb_iopm;
-
 	/* A VMRUN has started but has not yet been performed, so
 	 * we cannot inject a nested vmexit yet.  */
 	bool nested_run_pending;
 
-	/* cache for intercepts of the guest */
-	u32 intercept_cr;
-	u32 intercept_dr;
-	u32 intercept_exceptions;
-	u64 intercept;
-
-	/* Nested Paging related state */
-	u64 nested_cr3;
+	/* cache for control fields of the guest */
+	struct vmcb_control_area ctl;
 };
 
 struct vcpu_svm {
@@ -381,17 +371,17 @@ static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
 
 static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
 {
-	return (svm->nested.intercept & (1ULL << INTERCEPT_SMI));
+	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_SMI));
 }
 
 static inline bool nested_exit_on_intr(struct vcpu_svm *svm)
 {
-	return (svm->nested.intercept & (1ULL << INTERCEPT_INTR));
+	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INTR));
 }
 
 static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 {
-	return (svm->nested.intercept & (1ULL << INTERCEPT_NMI));
+	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_NMI));
 }
 
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-- 
2.18.2



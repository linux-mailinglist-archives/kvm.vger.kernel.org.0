Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EBD429230
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 16:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242383AbhJKOlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 10:41:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243484AbhJKOjt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 10:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633963068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xujwxfl7xK6inImwhxxP5THqj50LkXSin8m8zHsf2nw=;
        b=Y1kHAmeSm9xYKhboRENr6a7pZkvzn6hnf2WapB0YrGdCb2PavLKcRg5lUrGpsiK4LhJuha
        xK+5L/3f8aXa6a5s9LcT221HmX4emmH6NCTY8jfdCdzQcP/ZXSut1Xc2E+afx6+Kh980wy
        HTnvg2I90GdSJyIFGMuQrf5jV8s8q+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-HbxqzmSeMGGzmAlaT3Y8OQ-1; Mon, 11 Oct 2021 10:37:16 -0400
X-MC-Unique: HbxqzmSeMGGzmAlaT3Y8OQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E77E8042BD;
        Mon, 11 Oct 2021 14:37:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0941919C59;
        Mon, 11 Oct 2021 14:37:13 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v3 7/8] nSVM: use vmcb_ctrl_area_cached instead of vmcb_control_area in struct svm_nested_state
Date:   Mon, 11 Oct 2021 10:37:01 -0400
Message-Id: <20211011143702.1786568-8-eesposit@redhat.com>
In-Reply-To: <20211011143702.1786568-1-eesposit@redhat.com>
References: <20211011143702.1786568-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This requires changing all vmcb_is_intercept(&svm->nested.ctl, ...)
calls with vmcb12_is_intercept().

In addition, in svm_get_nested_state() user space expects a
vmcb_control_area struct, so we need to copy back all fields
in a temporary structure to provide to the user space.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 41 +++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.c    |  4 ++--
 arch/x86/kvm/svm/svm.h    |  8 ++++----
 3 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c84cded1dcf6..13be1002ad1c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -58,8 +58,9 @@ static void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_excep
        struct vcpu_svm *svm = to_svm(vcpu);
        WARN_ON(!is_guest_mode(vcpu));
 
-       if (vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
-	   !svm->nested.nested_run_pending) {
+	if (vmcb12_is_intercept(&svm->nested.ctl,
+				INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
+	    !svm->nested.nested_run_pending) {
                svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
                svm->vmcb->control.exit_code_hi = 0;
                svm->vmcb->control.exit_info_1 = fault->error_code;
@@ -121,7 +122,8 @@ static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
 
 void recalc_intercepts(struct vcpu_svm *svm)
 {
-	struct vmcb_control_area *c, *h, *g;
+	struct vmcb_control_area *c, *h;
+	struct vmcb_ctrl_area_cached *g;
 	unsigned int i;
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
@@ -172,7 +174,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	 */
 	int i;
 
-	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
+	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return true;
 
 	for (i = 0; i < MSRPM_OFFSETS; i++) {
@@ -208,9 +210,9 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 }
 
 static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
-				       struct vmcb_control_area *control)
+				       struct vmcb_ctrl_area_cached *control)
 {
-	if (CC(!vmcb_is_intercept(control, INTERCEPT_VMRUN)))
+	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
 		return false;
 
 	if (CC(control->asid == 0))
@@ -960,7 +962,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	u32 offset, msr, value;
 	int write, mask;
 
-	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
+	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
 
 	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
@@ -987,7 +989,7 @@ static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
 	u8 start_bit;
 	u64 gpa;
 
-	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_IOIO_PROT)))
+	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_IOIO_PROT)))
 		return NESTED_EXIT_HOST;
 
 	port = svm->vmcb->control.exit_info_1 >> 16;
@@ -1018,12 +1020,12 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		vmexit = nested_svm_intercept_ioio(svm);
 		break;
 	case SVM_EXIT_READ_CR0 ... SVM_EXIT_WRITE_CR8: {
-		if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
+		if (vmcb12_is_intercept(&svm->nested.ctl, exit_code))
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
 	case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
-		if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
+		if (vmcb12_is_intercept(&svm->nested.ctl, exit_code))
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
@@ -1041,7 +1043,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		break;
 	}
 	default: {
-		if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
+		if (vmcb12_is_intercept(&svm->nested.ctl, exit_code))
 			vmexit = NESTED_EXIT_DONE;
 	}
 	}
@@ -1119,7 +1121,7 @@ static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
 
 static inline bool nested_exit_on_init(struct vcpu_svm *svm)
 {
-	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_INIT);
+	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_INIT);
 }
 
 static int svm_check_nested_events(struct kvm_vcpu *vcpu)
@@ -1250,6 +1252,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 				u32 user_data_size)
 {
 	struct vcpu_svm *svm;
+	struct vmcb_control_area ctl_temp;
 	struct kvm_nested_state kvm_state = {
 		.flags = 0,
 		.format = KVM_STATE_NESTED_FORMAT_SVM,
@@ -1291,7 +1294,8 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	 */
 	if (clear_user(user_vmcb, KVM_STATE_NESTED_SVM_VMCB_SIZE))
 		return -EFAULT;
-	if (copy_to_user(&user_vmcb->control, &svm->nested.ctl,
+	nested_copy_vmcb_cache_to_control(&ctl_temp, &svm->nested.ctl);
+	if (copy_to_user(&user_vmcb->control, &ctl_temp,
 			 sizeof(user_vmcb->control)))
 		return -EFAULT;
 	if (copy_to_user(&user_vmcb->save, &svm->vmcb01.ptr->save,
@@ -1362,8 +1366,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		goto out_free;
 
 	ret = -EINVAL;
-	if (!nested_vmcb_check_controls(vcpu, ctl))
-		goto out_free;
+	nested_copy_vmcb_control_to_cache(svm, ctl);
+	if (!nested_vmcb_check_controls(vcpu, &svm->nested.ctl))
+		goto out_free_ctl;
 
 	/*
 	 * Processor state contains L2 state.  Check that it is
@@ -1371,7 +1376,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 */
 	cr0 = kvm_read_cr0(vcpu);
         if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
-		goto out_free;
+		goto out_free_ctl;
 
 	/*
 	 * Validate host state saved from before VMRUN (see
@@ -1417,7 +1422,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
 
 	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
-	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm);
@@ -1427,6 +1431,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 out_free_save:
 	memset(&svm->nested.save, 0, sizeof(struct vmcb_save_area_cached));
 
+out_free_ctl:
+	memset(&svm->nested.ctl, 0, sizeof(struct vmcb_ctrl_area_cached));
+
 out_free:
 	kfree(save);
 	kfree(ctl);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1b6d25c6e0ae..d866eea39777 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2465,7 +2465,7 @@ static bool check_selective_cr0_intercepted(struct kvm_vcpu *vcpu,
 	bool ret = false;
 
 	if (!is_guest_mode(vcpu) ||
-	    (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_SELECTIVE_CR0))))
+	    (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_SELECTIVE_CR0))))
 		return false;
 
 	cr0 &= ~SVM_CR0_SELECTIVE_MASK;
@@ -4184,7 +4184,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		    info->intercept == x86_intercept_clts)
 			break;
 
-		if (!(vmcb_is_intercept(&svm->nested.ctl,
+		if (!(vmcb12_is_intercept(&svm->nested.ctl,
 					INTERCEPT_SELECTIVE_CR0)))
 			break;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 78006245e334..051b7d0a13a1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -156,7 +156,7 @@ struct svm_nested_state {
 	bool nested_run_pending;
 
 	/* cache for control fields of the guest */
-	struct vmcb_control_area ctl;
+	struct vmcb_ctrl_area_cached ctl;
 	struct vmcb_save_area_cached save;
 
 	bool initialized;
@@ -491,17 +491,17 @@ static inline bool nested_svm_virtualize_tpr(struct kvm_vcpu *vcpu)
 
 static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
 {
-	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_SMI);
+	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_SMI);
 }
 
 static inline bool nested_exit_on_intr(struct vcpu_svm *svm)
 {
-	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_INTR);
+	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_INTR);
 }
 
 static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 {
-	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
+	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
 }
 
 int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb_gpa, struct vmcb *vmcb12);
-- 
2.27.0


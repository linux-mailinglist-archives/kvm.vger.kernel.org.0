Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD227254B84
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 19:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgH0RFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 13:05:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726246AbgH0RFA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 13:05:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598547897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Aqr0sMWnpP1Y1u+jH+cboJwF6hlUJ7t1+za2Gs6ehks=;
        b=GOMNrW703a8vaL52rG1b/zISuk8HhJabPKFZ4yKg7AkFTKMz5B2kKfGXVGYH1kZps+bHfz
        WSxGz2wC4Y86iNcm7UACg1o1PDGJfVQCCPEIdYxCr51BF/eizIxl4QdN/ycO8v/f32mAdK
        hZbj3ZvcYjPxrDHzkeZaUBldvIP0SeM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-g36zNeOqO_a0vkdRagKgXQ-1; Thu, 27 Aug 2020 13:04:50 -0400
X-MC-Unique: g36zNeOqO_a0vkdRagKgXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A38DF85C706;
        Thu, 27 Aug 2020 17:04:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55F6A196F3;
        Thu, 27 Aug 2020 17:04:44 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/8] KVM: nSVM: rename nested vmcb to vmcb12
Date:   Thu, 27 Aug 2020 20:04:28 +0300
Message-Id: <20200827170434.284680-3-mlevitsk@redhat.com>
In-Reply-To: <20200827170434.284680-1-mlevitsk@redhat.com>
References: <20200827170434.284680-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is to be more consistient with VMX, and to support
upcoming addition of vmcb02

Hopefully no functional changes.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 225 +++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.c    |  10 +-
 arch/x86/kvm/svm/svm.h    |   2 +-
 3 files changed, 118 insertions(+), 119 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e90bc436f5849..7b1c98826c365 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -215,41 +215,39 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
+static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
-	bool nested_vmcb_lma;
-	if ((vmcb->save.efer & EFER_SVME) == 0)
+	bool vmcb12_lma;
+
+	if ((vmcb12->save.efer & EFER_SVME) == 0)
 		return false;
 
-	if (((vmcb->save.cr0 & X86_CR0_CD) == 0) &&
-	    (vmcb->save.cr0 & X86_CR0_NW))
+	if (((vmcb12->save.cr0 & X86_CR0_CD) == 0) && (vmcb12->save.cr0 & X86_CR0_NW))
 		return false;
 
-	if (!kvm_dr6_valid(vmcb->save.dr6) || !kvm_dr7_valid(vmcb->save.dr7))
+	if (!kvm_dr6_valid(vmcb12->save.dr6) || !kvm_dr7_valid(vmcb12->save.dr7))
 		return false;
 
-	nested_vmcb_lma =
-	        (vmcb->save.efer & EFER_LME) &&
-		(vmcb->save.cr0 & X86_CR0_PG);
+	vmcb12_lma = (vmcb12->save.efer & EFER_LME) && (vmcb12->save.cr0 & X86_CR0_PG);
 
-	if (!nested_vmcb_lma) {
-		if (vmcb->save.cr4 & X86_CR4_PAE) {
-			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
+	if (!vmcb12_lma) {
+		if (vmcb12->save.cr4 & X86_CR4_PAE) {
+			if (vmcb12->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
 				return false;
 		} else {
-			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
+			if (vmcb12->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
 				return false;
 		}
 	} else {
-		if (!(vmcb->save.cr4 & X86_CR4_PAE) ||
-		    !(vmcb->save.cr0 & X86_CR0_PE) ||
-		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
+		if (!(vmcb12->save.cr4 & X86_CR4_PAE) ||
+		    !(vmcb12->save.cr0 & X86_CR0_PE) ||
+		    (vmcb12->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
 			return false;
 	}
-	if (kvm_valid_cr4(&svm->vcpu, vmcb->save.cr4))
+	if (kvm_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
 		return false;
 
-	return nested_vmcb_check_controls(&vmcb->control);
+	return nested_vmcb_check_controls(&vmcb12->control);
 }
 
 static void load_nested_vmcb_control(struct vcpu_svm *svm,
@@ -296,7 +294,7 @@ void sync_nested_vmcb_control(struct vcpu_svm *svm)
  * EXIT_INT_INFO.
  */
 static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
-					   struct vmcb *nested_vmcb)
+					   struct vmcb *vmcb12)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	u32 exit_int_info = 0;
@@ -308,7 +306,7 @@ static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
 
 		if (vcpu->arch.exception.has_error_code) {
 			exit_int_info |= SVM_EVTINJ_VALID_ERR;
-			nested_vmcb->control.exit_int_info_err =
+			vmcb12->control.exit_int_info_err =
 				vcpu->arch.exception.error_code;
 		}
 
@@ -325,7 +323,7 @@ static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
 			exit_int_info |= SVM_EVTINJ_TYPE_INTR;
 	}
 
-	nested_vmcb->control.exit_int_info = exit_int_info;
+	vmcb12->control.exit_int_info = exit_int_info;
 }
 
 static inline bool nested_npt_enabled(struct vcpu_svm *svm)
@@ -364,31 +362,31 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	return 0;
 }
 
-static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
+static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	/* Load the nested guest state */
-	svm->vmcb->save.es = nested_vmcb->save.es;
-	svm->vmcb->save.cs = nested_vmcb->save.cs;
-	svm->vmcb->save.ss = nested_vmcb->save.ss;
-	svm->vmcb->save.ds = nested_vmcb->save.ds;
-	svm->vmcb->save.gdtr = nested_vmcb->save.gdtr;
-	svm->vmcb->save.idtr = nested_vmcb->save.idtr;
-	kvm_set_rflags(&svm->vcpu, nested_vmcb->save.rflags);
-	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
-	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
-	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
-	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
-	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
-	kvm_rsp_write(&svm->vcpu, nested_vmcb->save.rsp);
-	kvm_rip_write(&svm->vcpu, nested_vmcb->save.rip);
+	svm->vmcb->save.es = vmcb12->save.es;
+	svm->vmcb->save.cs = vmcb12->save.cs;
+	svm->vmcb->save.ss = vmcb12->save.ss;
+	svm->vmcb->save.ds = vmcb12->save.ds;
+	svm->vmcb->save.gdtr = vmcb12->save.gdtr;
+	svm->vmcb->save.idtr = vmcb12->save.idtr;
+	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags);
+	svm_set_efer(&svm->vcpu, vmcb12->save.efer);
+	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
+	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
+	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = vmcb12->save.cr2;
+	kvm_rax_write(&svm->vcpu, vmcb12->save.rax);
+	kvm_rsp_write(&svm->vcpu, vmcb12->save.rsp);
+	kvm_rip_write(&svm->vcpu, vmcb12->save.rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
-	svm->vmcb->save.rax = nested_vmcb->save.rax;
-	svm->vmcb->save.rsp = nested_vmcb->save.rsp;
-	svm->vmcb->save.rip = nested_vmcb->save.rip;
-	svm->vmcb->save.dr7 = nested_vmcb->save.dr7;
-	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;
-	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
+	svm->vmcb->save.rax = vmcb12->save.rax;
+	svm->vmcb->save.rsp = vmcb12->save.rsp;
+	svm->vmcb->save.rip = vmcb12->save.rip;
+	svm->vmcb->save.dr7 = vmcb12->save.dr7;
+	svm->vcpu.arch.dr6  = vmcb12->save.dr6;
+	svm->vmcb->save.cpl = vmcb12->save.cpl;
 }
 
 static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
@@ -426,17 +424,17 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	vmcb_mark_all_dirty(svm->vmcb);
 }
 
-int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-			  struct vmcb *nested_vmcb)
+int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
+			 struct vmcb *vmcb12)
 {
 	int ret;
 
-	svm->nested.vmcb = vmcb_gpa;
-	load_nested_vmcb_control(svm, &nested_vmcb->control);
-	nested_prepare_vmcb_save(svm, nested_vmcb);
+	svm->nested.vmcb12_gpa = vmcb12_gpa;
+	load_nested_vmcb_control(svm, &vmcb12->control);
+	nested_prepare_vmcb_save(svm, vmcb12);
 	nested_prepare_vmcb_control(svm);
 
-	ret = nested_svm_load_cr3(&svm->vcpu, nested_vmcb->save.cr3,
+	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
 				  nested_npt_enabled(svm));
 	if (ret)
 		return ret;
@@ -449,19 +447,19 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 int nested_svm_vmrun(struct vcpu_svm *svm)
 {
 	int ret;
-	struct vmcb *nested_vmcb;
+	struct vmcb *vmcb12;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
-	u64 vmcb_gpa;
+	u64 vmcb12_gpa;
 
 	if (is_smm(&svm->vcpu)) {
 		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 		return 1;
 	}
 
-	vmcb_gpa = svm->vmcb->save.rax;
-	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
+	vmcb12_gpa = svm->vmcb->save.rax;
+	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb12_gpa), &map);
 	if (ret == -EINVAL) {
 		kvm_inject_gp(&svm->vcpu, 0);
 		return 1;
@@ -471,26 +469,26 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
 
-	nested_vmcb = map.hva;
+	vmcb12 = map.hva;
 
-	if (!nested_vmcb_checks(svm, nested_vmcb)) {
-		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
-		nested_vmcb->control.exit_code_hi = 0;
-		nested_vmcb->control.exit_info_1  = 0;
-		nested_vmcb->control.exit_info_2  = 0;
+	if (!nested_vmcb_checks(svm, vmcb12)) {
+		vmcb12->control.exit_code    = SVM_EXIT_ERR;
+		vmcb12->control.exit_code_hi = 0;
+		vmcb12->control.exit_info_1  = 0;
+		vmcb12->control.exit_info_2  = 0;
 		goto out;
 	}
 
-	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
-			       nested_vmcb->save.rip,
-			       nested_vmcb->control.int_ctl,
-			       nested_vmcb->control.event_inj,
-			       nested_vmcb->control.nested_ctl);
+	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
+			       vmcb12->save.rip,
+			       vmcb12->control.int_ctl,
+			       vmcb12->control.event_inj,
+			       vmcb12->control.nested_ctl);
 
-	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr & 0xffff,
-				    nested_vmcb->control.intercept_cr >> 16,
-				    nested_vmcb->control.intercept_exceptions,
-				    nested_vmcb->control.intercept);
+	trace_kvm_nested_intercepts(vmcb12->control.intercept_cr & 0xffff,
+				    vmcb12->control.intercept_cr >> 16,
+				    vmcb12->control.intercept_exceptions,
+				    vmcb12->control.intercept);
 
 	/* Clear internal status */
 	kvm_clear_exception_queue(&svm->vcpu);
@@ -522,7 +520,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	svm->nested.nested_run_pending = 1;
 
-	if (enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb))
+	if (enter_svm_guest_mode(svm, vmcb12_gpa, vmcb12))
 		goto out_exit_err;
 
 	if (nested_svm_vmrun_msrpm(svm))
@@ -563,23 +561,23 @@ void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
 int nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	int rc;
-	struct vmcb *nested_vmcb;
+	struct vmcb *vmcb12;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
 
-	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
+	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
 	if (rc) {
 		if (rc == -EINVAL)
 			kvm_inject_gp(&svm->vcpu, 0);
 		return 1;
 	}
 
-	nested_vmcb = map.hva;
+	vmcb12 = map.hva;
 
 	/* Exit Guest-Mode */
 	leave_guest_mode(&svm->vcpu);
-	svm->nested.vmcb = 0;
+	svm->nested.vmcb12_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
 	/* in case we halted in L2 */
@@ -587,45 +585,45 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	/* Give the current vmcb to the guest */
 
-	nested_vmcb->save.es     = vmcb->save.es;
-	nested_vmcb->save.cs     = vmcb->save.cs;
-	nested_vmcb->save.ss     = vmcb->save.ss;
-	nested_vmcb->save.ds     = vmcb->save.ds;
-	nested_vmcb->save.gdtr   = vmcb->save.gdtr;
-	nested_vmcb->save.idtr   = vmcb->save.idtr;
-	nested_vmcb->save.efer   = svm->vcpu.arch.efer;
-	nested_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
-	nested_vmcb->save.cr3    = kvm_read_cr3(&svm->vcpu);
-	nested_vmcb->save.cr2    = vmcb->save.cr2;
-	nested_vmcb->save.cr4    = svm->vcpu.arch.cr4;
-	nested_vmcb->save.rflags = kvm_get_rflags(&svm->vcpu);
-	nested_vmcb->save.rip    = kvm_rip_read(&svm->vcpu);
-	nested_vmcb->save.rsp    = kvm_rsp_read(&svm->vcpu);
-	nested_vmcb->save.rax    = kvm_rax_read(&svm->vcpu);
-	nested_vmcb->save.dr7    = vmcb->save.dr7;
-	nested_vmcb->save.dr6    = svm->vcpu.arch.dr6;
-	nested_vmcb->save.cpl    = vmcb->save.cpl;
-
-	nested_vmcb->control.int_state         = vmcb->control.int_state;
-	nested_vmcb->control.exit_code         = vmcb->control.exit_code;
-	nested_vmcb->control.exit_code_hi      = vmcb->control.exit_code_hi;
-	nested_vmcb->control.exit_info_1       = vmcb->control.exit_info_1;
-	nested_vmcb->control.exit_info_2       = vmcb->control.exit_info_2;
-
-	if (nested_vmcb->control.exit_code != SVM_EXIT_ERR)
-		nested_vmcb_save_pending_event(svm, nested_vmcb);
+	vmcb12->save.es     = vmcb->save.es;
+	vmcb12->save.cs     = vmcb->save.cs;
+	vmcb12->save.ss     = vmcb->save.ss;
+	vmcb12->save.ds     = vmcb->save.ds;
+	vmcb12->save.gdtr   = vmcb->save.gdtr;
+	vmcb12->save.idtr   = vmcb->save.idtr;
+	vmcb12->save.efer   = svm->vcpu.arch.efer;
+	vmcb12->save.cr0    = kvm_read_cr0(&svm->vcpu);
+	vmcb12->save.cr3    = kvm_read_cr3(&svm->vcpu);
+	vmcb12->save.cr2    = vmcb->save.cr2;
+	vmcb12->save.cr4    = svm->vcpu.arch.cr4;
+	vmcb12->save.rflags = kvm_get_rflags(&svm->vcpu);
+	vmcb12->save.rip    = kvm_rip_read(&svm->vcpu);
+	vmcb12->save.rsp    = kvm_rsp_read(&svm->vcpu);
+	vmcb12->save.rax    = kvm_rax_read(&svm->vcpu);
+	vmcb12->save.dr7    = vmcb->save.dr7;
+	vmcb12->save.dr6    = svm->vcpu.arch.dr6;
+	vmcb12->save.cpl    = vmcb->save.cpl;
+
+	vmcb12->control.int_state         = vmcb->control.int_state;
+	vmcb12->control.exit_code         = vmcb->control.exit_code;
+	vmcb12->control.exit_code_hi      = vmcb->control.exit_code_hi;
+	vmcb12->control.exit_info_1       = vmcb->control.exit_info_1;
+	vmcb12->control.exit_info_2       = vmcb->control.exit_info_2;
+
+	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
+		nested_vmcb_save_pending_event(svm, vmcb12);
 
 	if (svm->nrips_enabled)
-		nested_vmcb->control.next_rip  = vmcb->control.next_rip;
+		vmcb12->control.next_rip  = vmcb->control.next_rip;
 
-	nested_vmcb->control.int_ctl           = svm->nested.ctl.int_ctl;
-	nested_vmcb->control.tlb_ctl           = svm->nested.ctl.tlb_ctl;
-	nested_vmcb->control.event_inj         = svm->nested.ctl.event_inj;
-	nested_vmcb->control.event_inj_err     = svm->nested.ctl.event_inj_err;
+	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
+	vmcb12->control.tlb_ctl           = svm->nested.ctl.tlb_ctl;
+	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
+	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
-	nested_vmcb->control.pause_filter_count =
+	vmcb12->control.pause_filter_count =
 		svm->vmcb->control.pause_filter_count;
-	nested_vmcb->control.pause_filter_thresh =
+	vmcb12->control.pause_filter_thresh =
 		svm->vmcb->control.pause_filter_thresh;
 
 	/* Restore the original control entries */
@@ -659,11 +657,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	vmcb_mark_all_dirty(svm->vmcb);
 
-	trace_kvm_nested_vmexit_inject(nested_vmcb->control.exit_code,
-				       nested_vmcb->control.exit_info_1,
-				       nested_vmcb->control.exit_info_2,
-				       nested_vmcb->control.exit_int_info,
-				       nested_vmcb->control.exit_int_info_err,
+	trace_kvm_nested_vmexit_inject(vmcb12->control.exit_code,
+				       vmcb12->control.exit_info_1,
+				       vmcb12->control.exit_info_2,
+				       vmcb12->control.exit_int_info,
+				       vmcb12->control.exit_int_info_err,
 				       KVM_ISA_SVM);
 
 	kvm_vcpu_unmap(&svm->vcpu, &map, true);
@@ -1020,7 +1018,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 
 	/* First fill in the header and copy it out.  */
 	if (is_guest_mode(vcpu)) {
-		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb;
+		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
 		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
 		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
 
@@ -1130,7 +1128,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
 	hsave->save = save;
 
-	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
+	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
+
 	load_nested_vmcb_control(svm, &ctl);
 	nested_prepare_vmcb_control(svm);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 722769eaaf8ce..c75a68b2a9c2a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1102,7 +1102,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	}
 	svm->asid_generation = 0;
 
-	svm->nested.vmcb = 0;
+	svm->nested.vmcb12_gpa = 0;
 	svm->vcpu.arch.hflags = 0;
 
 	if (!kvm_pause_in_guest(svm->vcpu.kvm)) {
@@ -3884,7 +3884,7 @@ static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 		/* FED8h - SVM Guest */
 		put_smstate(u64, smstate, 0x7ed8, 1);
 		/* FEE0h - SVM Guest VMCB Physical Address */
-		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb);
+		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb12_gpa);
 
 		svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 		svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
@@ -3906,7 +3906,7 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
 		u64 saved_efer = GET_SMSTATE(u64, smstate, 0x7ed0);
 		u64 guest = GET_SMSTATE(u64, smstate, 0x7ed8);
-		u64 vmcb = GET_SMSTATE(u64, smstate, 0x7ee0);
+		u64 vmcb12_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
 
 		if (guest) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
@@ -3916,10 +3916,10 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 				return 1;
 
 			if (kvm_vcpu_map(&svm->vcpu,
-					 gpa_to_gfn(vmcb), &map) == -EINVAL)
+					 gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
 				return 1;
 
-			ret = enter_svm_guest_mode(svm, vmcb, map.hva);
+			ret = enter_svm_guest_mode(svm, vmcb12_gpa, map.hva);
 			kvm_vcpu_unmap(&svm->vcpu, &map, true);
 		}
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a798e17317094..ab913468f9cbe 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -85,7 +85,7 @@ struct svm_nested_state {
 	struct vmcb *hsave;
 	u64 hsave_msr;
 	u64 vm_cr_msr;
-	u64 vmcb;
+	u64 vmcb12_gpa;
 	u32 host_intercept_exceptions;
 
 	/* These are the merged vectors */
-- 
2.26.2


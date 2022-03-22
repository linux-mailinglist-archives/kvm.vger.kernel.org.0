Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813D64E450B
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbiCVR0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239641AbiCVR0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:26:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F288C46156
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647969917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rKDRAjIHXRB118gX9l+xARuxZXtMVqCCWlGMVq8Sub0=;
        b=Sg9VIY847UgvABaexNBgCl29KrUnLGuaX/Gj7m2V6VpIn4uqPsny8xdkG5kiLuz02LO84b
        zgNT9n7dIr3u/wcNjxretxfkd3n5deLB6p2ixQ+GgLBE8CjycfWK9D6s6hQ+Dvgyh2Ilk+
        5L+HaYyaHgiWgIAg3wCV7lq9iB2gcvs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-0uyVDhRYMgyNYl1VAFbJhA-1; Tue, 22 Mar 2022 13:25:13 -0400
X-MC-Unique: 0uyVDhRYMgyNYl1VAFbJhA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2734E82A682;
        Tue, 22 Mar 2022 17:25:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D4A62166B2D;
        Tue, 22 Mar 2022 17:25:09 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/8] kvm: x86: SVM: use vmcb* instead of svm->vmcb where it makes sense
Date:   Tue, 22 Mar 2022 19:24:44 +0200
Message-Id: <20220322172449.235575-4-mlevitsk@redhat.com>
In-Reply-To: <20220322172449.235575-1-mlevitsk@redhat.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes the code a bit shorter and cleaner.

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 179 ++++++++++++++++++++------------------
 1 file changed, 94 insertions(+), 85 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d736ec6514ca..1c381c6a7b51 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -36,40 +36,43 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 				       struct x86_exception *fault)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb;
 
-	if (svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
+	if (vmcb->control.exit_code != SVM_EXIT_NPF) {
 		/*
 		 * TODO: track the cause of the nested page fault, and
 		 * correctly fill in the high bits of exit_info_1.
 		 */
-		svm->vmcb->control.exit_code = SVM_EXIT_NPF;
-		svm->vmcb->control.exit_code_hi = 0;
-		svm->vmcb->control.exit_info_1 = (1ULL << 32);
-		svm->vmcb->control.exit_info_2 = fault->address;
+		vmcb->control.exit_code = SVM_EXIT_NPF;
+		vmcb->control.exit_code_hi = 0;
+		vmcb->control.exit_info_1 = (1ULL << 32);
+		vmcb->control.exit_info_2 = fault->address;
 	}
 
-	svm->vmcb->control.exit_info_1 &= ~0xffffffffULL;
-	svm->vmcb->control.exit_info_1 |= fault->error_code;
+	vmcb->control.exit_info_1 &= ~0xffffffffULL;
+	vmcb->control.exit_info_1 |= fault->error_code;
 
 	nested_svm_vmexit(svm);
 }
 
 static void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 {
-       struct vcpu_svm *svm = to_svm(vcpu);
-       WARN_ON(!is_guest_mode(vcpu));
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb;
+
+	WARN_ON(!is_guest_mode(vcpu));
 
 	if (vmcb12_is_intercept(&svm->nested.ctl,
 				INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
-	    !svm->nested.nested_run_pending) {
-               svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
-               svm->vmcb->control.exit_code_hi = 0;
-               svm->vmcb->control.exit_info_1 = fault->error_code;
-               svm->vmcb->control.exit_info_2 = fault->address;
-               nested_svm_vmexit(svm);
-       } else {
-               kvm_inject_page_fault(vcpu, fault);
-       }
+				!svm->nested.nested_run_pending) {
+		vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
+		vmcb->control.exit_code_hi = 0;
+		vmcb->control.exit_info_1 = fault->error_code;
+		vmcb->control.exit_info_2 = fault->address;
+		nested_svm_vmexit(svm);
+	} else {
+		kvm_inject_page_fault(vcpu, fault);
+	}
 }
 
 static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
@@ -533,6 +536,7 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	bool new_vmcb12 = false;
+	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 
 	nested_vmcb02_compute_g_pat(svm);
 
@@ -544,18 +548,18 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	}
 
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
-		svm->vmcb->save.es = vmcb12->save.es;
-		svm->vmcb->save.cs = vmcb12->save.cs;
-		svm->vmcb->save.ss = vmcb12->save.ss;
-		svm->vmcb->save.ds = vmcb12->save.ds;
-		svm->vmcb->save.cpl = vmcb12->save.cpl;
-		vmcb_mark_dirty(svm->vmcb, VMCB_SEG);
+		vmcb02->save.es = vmcb12->save.es;
+		vmcb02->save.cs = vmcb12->save.cs;
+		vmcb02->save.ss = vmcb12->save.ss;
+		vmcb02->save.ds = vmcb12->save.ds;
+		vmcb02->save.cpl = vmcb12->save.cpl;
+		vmcb_mark_dirty(vmcb02, VMCB_SEG);
 	}
 
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DT))) {
-		svm->vmcb->save.gdtr = vmcb12->save.gdtr;
-		svm->vmcb->save.idtr = vmcb12->save.idtr;
-		vmcb_mark_dirty(svm->vmcb, VMCB_DT);
+		vmcb02->save.gdtr = vmcb12->save.gdtr;
+		vmcb02->save.idtr = vmcb12->save.idtr;
+		vmcb_mark_dirty(vmcb02, VMCB_DT);
 	}
 
 	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
@@ -572,15 +576,15 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	kvm_rip_write(&svm->vcpu, vmcb12->save.rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
-	svm->vmcb->save.rax = vmcb12->save.rax;
-	svm->vmcb->save.rsp = vmcb12->save.rsp;
-	svm->vmcb->save.rip = vmcb12->save.rip;
+	vmcb02->save.rax = vmcb12->save.rax;
+	vmcb02->save.rsp = vmcb12->save.rsp;
+	vmcb02->save.rip = vmcb12->save.rip;
 
 	/* These bits will be set properly on the first execution when new_vmc12 is true */
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
-		svm->vmcb->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
+		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
 		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
-		vmcb_mark_dirty(svm->vmcb, VMCB_DR);
+		vmcb_mark_dirty(vmcb02, VMCB_DR);
 	}
 }
 
@@ -592,6 +596,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	const u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
 
 	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
+	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 
 	/*
 	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
@@ -605,14 +611,14 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
 
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
-	svm->vmcb->control.nested_ctl = svm->vmcb01.ptr->control.nested_ctl;
-	svm->vmcb->control.iopm_base_pa = svm->vmcb01.ptr->control.iopm_base_pa;
-	svm->vmcb->control.msrpm_base_pa = svm->vmcb01.ptr->control.msrpm_base_pa;
+	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
+	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
+	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 
 	/* Done at vmrun: asid.  */
 
 	/* Also overwritten later if necessary.  */
-	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	vmcb02->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 
 	/* nested_cr3.  */
 	if (nested_npt_enabled(svm))
@@ -623,24 +629,24 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 			svm->nested.ctl.tsc_offset,
 			svm->tsc_ratio_msr);
 
-	svm->vmcb->control.tsc_offset = vcpu->arch.tsc_offset;
+	vmcb02->control.tsc_offset = vcpu->arch.tsc_offset;
 
 	if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
 		WARN_ON(!svm->tsc_scaling_enabled);
 		nested_svm_update_tsc_ratio_msr(vcpu);
 	}
 
-	svm->vmcb->control.int_ctl             =
+	vmcb02->control.int_ctl             =
 		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
-		(svm->vmcb01.ptr->control.int_ctl & int_ctl_vmcb01_bits);
+		(vmcb01->control.int_ctl & int_ctl_vmcb01_bits);
 
-	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
-	svm->vmcb->control.int_state           = svm->nested.ctl.int_state;
-	svm->vmcb->control.event_inj           = svm->nested.ctl.event_inj;
-	svm->vmcb->control.event_inj_err       = svm->nested.ctl.event_inj_err;
+	vmcb02->control.int_vector          = svm->nested.ctl.int_vector;
+	vmcb02->control.int_state           = svm->nested.ctl.int_state;
+	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
+	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
 
 	if (!nested_vmcb_needs_vls_intercept(svm))
-		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
 	nested_svm_transition_tlb_flush(vcpu);
 
@@ -719,6 +725,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	struct vmcb *vmcb12;
 	struct kvm_host_map map;
 	u64 vmcb12_gpa;
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 
 	if (!svm->nested.hsave_msr) {
 		kvm_inject_gp(vcpu, 0);
@@ -762,14 +769,14 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
 	 * state.
 	 */
-	svm->vmcb01.ptr->save.efer   = vcpu->arch.efer;
-	svm->vmcb01.ptr->save.cr0    = kvm_read_cr0(vcpu);
-	svm->vmcb01.ptr->save.cr4    = vcpu->arch.cr4;
-	svm->vmcb01.ptr->save.rflags = kvm_get_rflags(vcpu);
-	svm->vmcb01.ptr->save.rip    = kvm_rip_read(vcpu);
+	vmcb01->save.efer   = vcpu->arch.efer;
+	vmcb01->save.cr0    = kvm_read_cr0(vcpu);
+	vmcb01->save.cr4    = vcpu->arch.cr4;
+	vmcb01->save.rflags = kvm_get_rflags(vcpu);
+	vmcb01->save.rip    = kvm_rip_read(vcpu);
 
 	if (!npt_enabled)
-		svm->vmcb01.ptr->save.cr3 = kvm_read_cr3(vcpu);
+		vmcb01->save.cr3 = kvm_read_cr3(vcpu);
 
 	svm->nested.nested_run_pending = 1;
 
@@ -835,8 +842,9 @@ void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 int nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
+	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 	struct vmcb *vmcb12;
-	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
 	int rc;
 
@@ -864,36 +872,36 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	/* Give the current vmcb to the guest */
 
-	vmcb12->save.es     = vmcb->save.es;
-	vmcb12->save.cs     = vmcb->save.cs;
-	vmcb12->save.ss     = vmcb->save.ss;
-	vmcb12->save.ds     = vmcb->save.ds;
-	vmcb12->save.gdtr   = vmcb->save.gdtr;
-	vmcb12->save.idtr   = vmcb->save.idtr;
+	vmcb12->save.es     = vmcb02->save.es;
+	vmcb12->save.cs     = vmcb02->save.cs;
+	vmcb12->save.ss     = vmcb02->save.ss;
+	vmcb12->save.ds     = vmcb02->save.ds;
+	vmcb12->save.gdtr   = vmcb02->save.gdtr;
+	vmcb12->save.idtr   = vmcb02->save.idtr;
 	vmcb12->save.efer   = svm->vcpu.arch.efer;
 	vmcb12->save.cr0    = kvm_read_cr0(vcpu);
 	vmcb12->save.cr3    = kvm_read_cr3(vcpu);
-	vmcb12->save.cr2    = vmcb->save.cr2;
+	vmcb12->save.cr2    = vmcb02->save.cr2;
 	vmcb12->save.cr4    = svm->vcpu.arch.cr4;
 	vmcb12->save.rflags = kvm_get_rflags(vcpu);
 	vmcb12->save.rip    = kvm_rip_read(vcpu);
 	vmcb12->save.rsp    = kvm_rsp_read(vcpu);
 	vmcb12->save.rax    = kvm_rax_read(vcpu);
-	vmcb12->save.dr7    = vmcb->save.dr7;
+	vmcb12->save.dr7    = vmcb02->save.dr7;
 	vmcb12->save.dr6    = svm->vcpu.arch.dr6;
-	vmcb12->save.cpl    = vmcb->save.cpl;
+	vmcb12->save.cpl    = vmcb02->save.cpl;
 
-	vmcb12->control.int_state         = vmcb->control.int_state;
-	vmcb12->control.exit_code         = vmcb->control.exit_code;
-	vmcb12->control.exit_code_hi      = vmcb->control.exit_code_hi;
-	vmcb12->control.exit_info_1       = vmcb->control.exit_info_1;
-	vmcb12->control.exit_info_2       = vmcb->control.exit_info_2;
+	vmcb12->control.int_state         = vmcb02->control.int_state;
+	vmcb12->control.exit_code         = vmcb02->control.exit_code;
+	vmcb12->control.exit_code_hi      = vmcb02->control.exit_code_hi;
+	vmcb12->control.exit_info_1       = vmcb02->control.exit_info_1;
+	vmcb12->control.exit_info_2       = vmcb02->control.exit_info_2;
 
 	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
 		nested_save_pending_event_to_vmcb12(svm, vmcb12);
 
 	if (svm->nrips_enabled)
-		vmcb12->control.next_rip  = vmcb->control.next_rip;
+		vmcb12->control.next_rip  = vmcb02->control.next_rip;
 
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
 	vmcb12->control.tlb_ctl           = svm->nested.ctl.tlb_ctl;
@@ -909,12 +917,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	 * no event can be injected in L1.
 	 */
 	svm_set_gif(svm, false);
-	svm->vmcb->control.exit_int_info = 0;
+	vmcb01->control.exit_int_info = 0;
 
 	svm->vcpu.arch.tsc_offset = svm->vcpu.arch.l1_tsc_offset;
-	if (svm->vmcb->control.tsc_offset != svm->vcpu.arch.tsc_offset) {
-		svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
-		vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+	if (vmcb01->control.tsc_offset != svm->vcpu.arch.tsc_offset) {
+		vmcb01->control.tsc_offset = svm->vcpu.arch.tsc_offset;
+		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
 	}
 
 	if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
@@ -928,13 +936,13 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/*
 	 * Restore processor state that had been saved in vmcb01
 	 */
-	kvm_set_rflags(vcpu, svm->vmcb->save.rflags);
-	svm_set_efer(vcpu, svm->vmcb->save.efer);
-	svm_set_cr0(vcpu, svm->vmcb->save.cr0 | X86_CR0_PE);
-	svm_set_cr4(vcpu, svm->vmcb->save.cr4);
-	kvm_rax_write(vcpu, svm->vmcb->save.rax);
-	kvm_rsp_write(vcpu, svm->vmcb->save.rsp);
-	kvm_rip_write(vcpu, svm->vmcb->save.rip);
+	kvm_set_rflags(vcpu, vmcb01->save.rflags);
+	svm_set_efer(vcpu, vmcb01->save.efer);
+	svm_set_cr0(vcpu, vmcb01->save.cr0 | X86_CR0_PE);
+	svm_set_cr4(vcpu, vmcb01->save.cr4);
+	kvm_rax_write(vcpu, vmcb01->save.rax);
+	kvm_rsp_write(vcpu, vmcb01->save.rsp);
+	kvm_rip_write(vcpu, vmcb01->save.rip);
 
 	svm->vcpu.arch.dr7 = DR7_FIXED_1;
 	kvm_update_dr7(&svm->vcpu);
@@ -952,7 +960,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(vcpu);
 
-	rc = nested_svm_load_cr3(vcpu, svm->vmcb->save.cr3, false, true);
+	rc = nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true);
 	if (rc)
 		return 1;
 
@@ -970,7 +978,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	 * right now so that it an be accounted for before we execute
 	 * L1's next instruction.
 	 */
-	if (unlikely(svm->vmcb->save.rflags & X86_EFLAGS_TF))
+	if (unlikely(vmcb01->save.rflags & X86_EFLAGS_TF))
 		kvm_queue_exception(&(svm->vcpu), DB_VECTOR);
 
 	return 0;
@@ -1183,12 +1191,13 @@ static bool nested_exit_on_exception(struct vcpu_svm *svm)
 static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
 {
 	unsigned int nr = svm->vcpu.arch.exception.nr;
+	struct vmcb *vmcb = svm->vmcb;
 
-	svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
-	svm->vmcb->control.exit_code_hi = 0;
+	vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
+	vmcb->control.exit_code_hi = 0;
 
 	if (svm->vcpu.arch.exception.has_error_code)
-		svm->vmcb->control.exit_info_1 = svm->vcpu.arch.exception.error_code;
+		vmcb->control.exit_info_1 = svm->vcpu.arch.exception.error_code;
 
 	/*
 	 * EXITINFO2 is undefined for all exception intercepts other
@@ -1196,11 +1205,11 @@ static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
 	 */
 	if (nr == PF_VECTOR) {
 		if (svm->vcpu.arch.exception.nested_apf)
-			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.apf.nested_apf_token;
+			vmcb->control.exit_info_2 = svm->vcpu.arch.apf.nested_apf_token;
 		else if (svm->vcpu.arch.exception.has_payload)
-			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.exception.payload;
+			vmcb->control.exit_info_2 = svm->vcpu.arch.exception.payload;
 		else
-			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
+			vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
 	} else if (nr == DB_VECTOR) {
 		/* See inject_pending_event.  */
 		kvm_deliver_exception_payload(&svm->vcpu);
-- 
2.26.3


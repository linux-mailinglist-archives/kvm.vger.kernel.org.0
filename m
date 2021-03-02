Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4E832B5B7
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383146AbhCCHTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835997AbhCBTfh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=70Y0vUTxopTrIgobJndAZGkBKSsGOUgsKSZzgxwz6bA=;
        b=DMGM8TryRzjAFveHw3sdxSSCFWVM0jx13XGtXdFFCvnxn0Xgk9yc4wnqhMHeBDHbtWhGf8
        ceVzwEyGwG79Fm/pycEVM5GnXyBirD+skjni50SXMtW0UyvtnG1sTm1gFz6dtQi0PB2Jgs
        Bag1Dg/ObaVN9J/TZwd1dJd1GwNKPN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-rF_IPFo2MlWCJv59k4IfTQ-1; Tue, 02 Mar 2021 14:33:54 -0500
X-MC-Unique: rF_IPFo2MlWCJv59k4IfTQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86EA418B6141;
        Tue,  2 Mar 2021 19:33:53 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EC066F99F;
        Tue,  2 Mar 2021 19:33:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 16/23] KVM: x86: Move trivial instruction-based exit handlers to common code
Date:   Tue,  2 Mar 2021 14:33:36 -0500
Message-Id: <20210302193343.313318-17-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Move the trivial exit handlers, e.g. for instructions that KVM
"emulates" as nops, to common x86 code.  Assign the common handlers
directly to the exit handler arrays and drop the vendor trampolines.

Opportunistically use pr_warn_once() where appropriate.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210205005750.3841462-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  5 ++
 arch/x86/kvm/svm/svm.c          | 90 +++++----------------------------
 arch/x86/kvm/vmx/vmx.c          | 53 +++----------------
 arch/x86/kvm/x86.c              | 34 +++++++++++++
 4 files changed, 59 insertions(+), 123 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b396e854c7db..cd26756dc9c1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1514,6 +1514,11 @@ int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
 int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu);
+int kvm_emulate_as_nop(struct kvm_vcpu *vcpu);
+int kvm_emulate_invd(struct kvm_vcpu *vcpu);
+int kvm_emulate_mwait(struct kvm_vcpu *vcpu);
+int kvm_handle_invalid_op(struct kvm_vcpu *vcpu);
+int kvm_emulate_monitor(struct kvm_vcpu *vcpu);
 
 int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fcea45f40d76..607d7698c7ea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2101,21 +2101,6 @@ static int intr_interception(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int nop_on_interception(struct kvm_vcpu *vcpu)
-{
-	return 1;
-}
-
-static int halt_interception(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_halt(vcpu);
-}
-
-static int vmmcall_interception(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_hypercall(vcpu);
-}
-
 static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -2341,17 +2326,6 @@ static int skinit_interception(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int wbinvd_interception(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_wbinvd(vcpu);
-}
-
-static int rdpru_interception(struct kvm_vcpu *vcpu)
-{
-	kvm_queue_exception(vcpu, UD_VECTOR);
-	return 1;
-}
-
 static int task_switch_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -2417,11 +2391,6 @@ static int task_switch_interception(struct kvm_vcpu *vcpu)
 			       has_error_code, error_code);
 }
 
-static int cpuid_interception(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_cpuid(vcpu);
-}
-
 static int iret_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -2436,12 +2405,6 @@ static int iret_interception(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int invd_interception(struct kvm_vcpu *vcpu)
-{
-	/* Treat an INVD instruction as a NOP and just skip it. */
-	return kvm_skip_emulated_instruction(vcpu);
-}
-
 static int invlpg_interception(struct kvm_vcpu *vcpu)
 {
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
@@ -2808,11 +2771,6 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 	return 1;
 }
 
-static int rdmsr_interception(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_rdmsr(vcpu);
-}
-
 static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -2996,17 +2954,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	return 0;
 }
 
-static int wrmsr_interception(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_wrmsr(vcpu);
-}
-
 static int msr_interception(struct kvm_vcpu *vcpu)
 {
 	if (to_svm(vcpu)->vmcb->control.exit_info_1)
-		return wrmsr_interception(vcpu);
+		return kvm_emulate_wrmsr(vcpu);
 	else
-		return rdmsr_interception(vcpu);
+		return kvm_emulate_rdmsr(vcpu);
 }
 
 static int interrupt_window_interception(struct kvm_vcpu *vcpu)
@@ -3043,23 +2996,6 @@ static int pause_interception(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int nop_interception(struct kvm_vcpu *vcpu)
-{
-	return kvm_skip_emulated_instruction(vcpu);
-}
-
-static int monitor_interception(struct kvm_vcpu *vcpu)
-{
-	printk_once(KERN_WARNING "kvm: MONITOR instruction emulated as NOP!\n");
-	return nop_interception(vcpu);
-}
-
-static int mwait_interception(struct kvm_vcpu *vcpu)
-{
-	printk_once(KERN_WARNING "kvm: MWAIT instruction emulated as NOP!\n");
-	return nop_interception(vcpu);
-}
-
 static int invpcid_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3122,15 +3058,15 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_EXCP_BASE + GP_VECTOR]	= gp_interception,
 	[SVM_EXIT_INTR]				= intr_interception,
 	[SVM_EXIT_NMI]				= nmi_interception,
-	[SVM_EXIT_SMI]				= nop_on_interception,
-	[SVM_EXIT_INIT]				= nop_on_interception,
+	[SVM_EXIT_SMI]				= kvm_emulate_as_nop,
+	[SVM_EXIT_INIT]				= kvm_emulate_as_nop,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
 	[SVM_EXIT_RDPMC]			= rdpmc_interception,
-	[SVM_EXIT_CPUID]			= cpuid_interception,
+	[SVM_EXIT_CPUID]			= kvm_emulate_cpuid,
 	[SVM_EXIT_IRET]                         = iret_interception,
-	[SVM_EXIT_INVD]                         = invd_interception,
+	[SVM_EXIT_INVD]                         = kvm_emulate_invd,
 	[SVM_EXIT_PAUSE]			= pause_interception,
-	[SVM_EXIT_HLT]				= halt_interception,
+	[SVM_EXIT_HLT]				= kvm_emulate_halt,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
 	[SVM_EXIT_INVLPGA]			= invlpga_interception,
 	[SVM_EXIT_IOIO]				= io_interception,
@@ -3138,17 +3074,17 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= vmrun_interception,
-	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
+	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
 	[SVM_EXIT_VMLOAD]			= vmload_interception,
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,
 	[SVM_EXIT_CLGI]				= clgi_interception,
 	[SVM_EXIT_SKINIT]			= skinit_interception,
-	[SVM_EXIT_WBINVD]                       = wbinvd_interception,
-	[SVM_EXIT_MONITOR]			= monitor_interception,
-	[SVM_EXIT_MWAIT]			= mwait_interception,
+	[SVM_EXIT_WBINVD]                       = kvm_emulate_wbinvd,
+	[SVM_EXIT_MONITOR]			= kvm_emulate_monitor,
+	[SVM_EXIT_MWAIT]			= kvm_emulate_mwait,
 	[SVM_EXIT_XSETBV]			= kvm_emulate_xsetbv,
-	[SVM_EXIT_RDPRU]			= rdpru_interception,
+	[SVM_EXIT_RDPRU]			= kvm_handle_invalid_op,
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_CR4_WRITE_TRAP]		= cr_trap,
@@ -3311,7 +3247,7 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 	else if (exit_code == SVM_EXIT_INTR)
 		return intr_interception(vcpu);
 	else if (exit_code == SVM_EXIT_HLT)
-		return halt_interception(vcpu);
+		return kvm_emulate_halt(vcpu);
 	else if (exit_code == SVM_EXIT_NPF)
 		return npf_interception(vcpu);
 #endif
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0df836897447..83afedbdbfe1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5184,17 +5184,6 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int handle_vmcall(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_hypercall(vcpu);
-}
-
-static int handle_invd(struct kvm_vcpu *vcpu)
-{
-	/* Treat an INVD instruction as a NOP and just skip it. */
-	return kvm_skip_emulated_instruction(vcpu);
-}
-
 static int handle_invlpg(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
@@ -5211,11 +5200,6 @@ static int handle_rdpmc(struct kvm_vcpu *vcpu)
 	return kvm_complete_insn_gp(vcpu, err);
 }
 
-static int handle_wbinvd(struct kvm_vcpu *vcpu)
-{
-	return kvm_emulate_wbinvd(vcpu);
-}
-
 static int handle_apic_access(struct kvm_vcpu *vcpu)
 {
 	if (likely(fasteoi)) {
@@ -5507,34 +5491,11 @@ static int handle_pause(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-static int handle_nop(struct kvm_vcpu *vcpu)
-{
-	return kvm_skip_emulated_instruction(vcpu);
-}
-
-static int handle_mwait(struct kvm_vcpu *vcpu)
-{
-	printk_once(KERN_WARNING "kvm: MWAIT instruction emulated as NOP!\n");
-	return handle_nop(vcpu);
-}
-
-static int handle_invalid_op(struct kvm_vcpu *vcpu)
-{
-	kvm_queue_exception(vcpu, UD_VECTOR);
-	return 1;
-}
-
 static int handle_monitor_trap(struct kvm_vcpu *vcpu)
 {
 	return 1;
 }
 
-static int handle_monitor(struct kvm_vcpu *vcpu)
-{
-	printk_once(KERN_WARNING "kvm: MONITOR instruction emulated as NOP!\n");
-	return handle_nop(vcpu);
-}
-
 static int handle_invpcid(struct kvm_vcpu *vcpu)
 {
 	u32 vmx_instruction_info;
@@ -5659,10 +5620,10 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_MSR_WRITE]               = kvm_emulate_wrmsr,
 	[EXIT_REASON_INTERRUPT_WINDOW]        = handle_interrupt_window,
 	[EXIT_REASON_HLT]                     = kvm_emulate_halt,
-	[EXIT_REASON_INVD]		      = handle_invd,
+	[EXIT_REASON_INVD]		      = kvm_emulate_invd,
 	[EXIT_REASON_INVLPG]		      = handle_invlpg,
 	[EXIT_REASON_RDPMC]                   = handle_rdpmc,
-	[EXIT_REASON_VMCALL]                  = handle_vmcall,
+	[EXIT_REASON_VMCALL]                  = kvm_emulate_hypercall,
 	[EXIT_REASON_VMCLEAR]		      = handle_vmx_instruction,
 	[EXIT_REASON_VMLAUNCH]		      = handle_vmx_instruction,
 	[EXIT_REASON_VMPTRLD]		      = handle_vmx_instruction,
@@ -5676,7 +5637,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_APIC_ACCESS]             = handle_apic_access,
 	[EXIT_REASON_APIC_WRITE]              = handle_apic_write,
 	[EXIT_REASON_EOI_INDUCED]             = handle_apic_eoi_induced,
-	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
+	[EXIT_REASON_WBINVD]                  = kvm_emulate_wbinvd,
 	[EXIT_REASON_XSETBV]                  = kvm_emulate_xsetbv,
 	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
 	[EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
@@ -5685,13 +5646,13 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
 	[EXIT_REASON_EPT_MISCONFIG]           = handle_ept_misconfig,
 	[EXIT_REASON_PAUSE_INSTRUCTION]       = handle_pause,
-	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_mwait,
+	[EXIT_REASON_MWAIT_INSTRUCTION]	      = kvm_emulate_mwait,
 	[EXIT_REASON_MONITOR_TRAP_FLAG]       = handle_monitor_trap,
-	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_monitor,
+	[EXIT_REASON_MONITOR_INSTRUCTION]     = kvm_emulate_monitor,
 	[EXIT_REASON_INVEPT]                  = handle_vmx_instruction,
 	[EXIT_REASON_INVVPID]                 = handle_vmx_instruction,
-	[EXIT_REASON_RDRAND]                  = handle_invalid_op,
-	[EXIT_REASON_RDSEED]                  = handle_invalid_op,
+	[EXIT_REASON_RDRAND]                  = kvm_handle_invalid_op,
+	[EXIT_REASON_RDSEED]                  = kvm_handle_invalid_op,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
 	[EXIT_REASON_INVPCID]                 = handle_invpcid,
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8dc69ff3d205..90a35769951f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1786,6 +1786,40 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
+int kvm_emulate_as_nop(struct kvm_vcpu *vcpu)
+{
+	return kvm_skip_emulated_instruction(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_as_nop);
+
+int kvm_emulate_invd(struct kvm_vcpu *vcpu)
+{
+	/* Treat an INVD instruction as a NOP and just skip it. */
+	return kvm_emulate_as_nop(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_invd);
+
+int kvm_emulate_mwait(struct kvm_vcpu *vcpu)
+{
+	pr_warn_once("kvm: MWAIT instruction emulated as NOP!\n");
+	return kvm_emulate_as_nop(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_mwait);
+
+int kvm_handle_invalid_op(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_exception(vcpu, UD_VECTOR);
+	return 1;
+}
+EXPORT_SYMBOL_GPL(kvm_handle_invalid_op);
+
+int kvm_emulate_monitor(struct kvm_vcpu *vcpu)
+{
+	pr_warn_once("kvm: MONITOR instruction emulated as NOP!\n");
+	return kvm_emulate_as_nop(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_monitor);
+
 static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 {
 	return vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu) ||
-- 
2.26.2



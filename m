Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC29D310205
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhBEBCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 20:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbhBEA7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:59:23 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ECEC06121F
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 16:58:11 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id d1so3988138qtp.11
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 16:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8w+uy0ikvkZJNtDGn41K0tFBOZ4UFq/csm7Vi4b/wao=;
        b=wNyJD3Vyd8GcU8NrcX/dftonICqt62/+KvjM0m3j1xlaeHq4Xc6/OMwAnSRRGbGFdZ
         1MFnQRBZRI7vI1JJrHVyn64VdBVmJx5M5nBqiZvbWtOVSHWxty5QKsGaE3TjvS8uo0GB
         /8gWqfHpwEySOrJYYXg2HaposFdZDKvNfRO70SPPcHK3mf8kqyau+hodOKdDGtp8KNhR
         /GpJnlczqzShJ5vpG9YMbn4ddSMZvM++XwsE5PEJmi/BCpB1xo2DWGFJxwqjFbtuwN1G
         Jnqk6fDHjGvAN45p4vZu7NFVOZl8udyhRc/crqIwf0zVzVy0gSavtPxrmqt1VJcoylZl
         FjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8w+uy0ikvkZJNtDGn41K0tFBOZ4UFq/csm7Vi4b/wao=;
        b=bONEQXicz+SfG3S9bEW07UDny3o2dFI7YUpRq7ygGleKJeknBL3jyhe9kvR+YQVSmi
         kGZJq+k8kz65pAL6qGsZheLeZtBANL1p/LVbM5ePwaYM1Dg4gbpdPExrtS/lua34AV9P
         iapFWqsOjwQyU36a+46Zc5ZHANudOS8n2LLhLkSvpHBWq1bI3h2seEfHrxwQaAbEE2W/
         llegeNq5a/CC1BpZBWRV7p8riq1wKtiU8PHoJ11pWY6iOIzkT65bFMRdA7zwcypjmV9D
         TWAwyACISftnLsbYMJyyGTLggtomQxh0Yh8fnkU1dP36Ro4QFQg+GlWA5XEmRuFVhClH
         FcEg==
X-Gm-Message-State: AOAM530akcd6Ie784EB6tGSOJ6LIGMpfOaEt0Hg/I9Ke9C/3kWdQBuQs
        5wENgJWItIsoZZrDHo8YsvvKhnrkJKw=
X-Google-Smtp-Source: ABdhPJxYIr97GKbg/ra7ite5R8PrDEXe9zC6RzNB+7cETEDP7y3kNUGb35dAZbs2EkBZH0Osk+qWKEaEOjs=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1110:: with SMTP id
 e16mr1978824qvs.62.1612486690600; Thu, 04 Feb 2021 16:58:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Feb 2021 16:57:47 -0800
In-Reply-To: <20210205005750.3841462-1-seanjc@google.com>
Message-Id: <20210205005750.3841462-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210205005750.3841462-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 6/9] KVM: x86: Move trivial instruction-based exit handlers to
 common code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Kosina <trivial@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the trivial exit handlers, e.g. for instructions that KVM
"emulates" as nops, to common x86 code.  Assign the common handlers
directly to the exit handler arrays and drop the vendor trampolines.

Opportunistically use pr_warn_once() where appropriate.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 ++
 arch/x86/kvm/svm/svm.c          | 90 +++++----------------------------
 arch/x86/kvm/vmx/vmx.c          | 53 +++----------------
 arch/x86/kvm/x86.c              | 34 +++++++++++++
 4 files changed, 59 insertions(+), 123 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3f9d343aa071..edac91914f46 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1539,6 +1539,11 @@ int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
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
index 46646d7539ad..3eb5a6c19ed7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2116,21 +2116,6 @@ static int intr_interception(struct kvm_vcpu *vcpu)
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
@@ -2351,17 +2336,6 @@ static int skinit_interception(struct kvm_vcpu *vcpu)
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
@@ -2427,11 +2401,6 @@ static int task_switch_interception(struct kvm_vcpu *vcpu)
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
@@ -2446,12 +2415,6 @@ static int iret_interception(struct kvm_vcpu *vcpu)
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
@@ -2818,11 +2781,6 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
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
@@ -3006,17 +2964,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
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
@@ -3053,23 +3006,6 @@ static int pause_interception(struct kvm_vcpu *vcpu)
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
@@ -3132,15 +3068,15 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
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
@@ -3148,17 +3084,17 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
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
@@ -3321,7 +3257,7 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 	else if (exit_code == SVM_EXIT_INTR)
 		return intr_interception(vcpu);
 	else if (exit_code == SVM_EXIT_HLT)
-		return halt_interception(vcpu);
+		return kvm_emulate_halt(vcpu);
 	else if (exit_code == SVM_EXIT_NPF)
 		return npf_interception(vcpu);
 #endif
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 96b58aef8d29..82f39cf3bc4b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5302,17 +5302,6 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu)
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
@@ -5329,11 +5318,6 @@ static int handle_rdpmc(struct kvm_vcpu *vcpu)
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
@@ -5625,34 +5609,11 @@ static int handle_pause(struct kvm_vcpu *vcpu)
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
@@ -5777,10 +5738,10 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
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
@@ -5794,7 +5755,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_APIC_ACCESS]             = handle_apic_access,
 	[EXIT_REASON_APIC_WRITE]              = handle_apic_write,
 	[EXIT_REASON_EOI_INDUCED]             = handle_apic_eoi_induced,
-	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
+	[EXIT_REASON_WBINVD]                  = kvm_emulate_wbinvd,
 	[EXIT_REASON_XSETBV]                  = kvm_emulate_xsetbv,
 	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
 	[EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
@@ -5803,13 +5764,13 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
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
index 51f2485bc6d6..d81ffbc42bba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1805,6 +1805,40 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
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
2.30.0.365.g02bc693789-goog


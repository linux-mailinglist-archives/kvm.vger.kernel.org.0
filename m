Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4197F1A4981
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 19:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgDJRrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 13:47:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:60983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgDJRrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 13:47:07 -0400
IronPort-SDR: Bj2u/7qCO7ifbHx0ZP/UMDsTQ41xv5g7EEiwuFvxVGoDvaN1W22HXt/TK8378naUWysWw8vye3
 CFrFBdq2elMQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 10:47:06 -0700
IronPort-SDR: uybQ7BS/rqig19+Nu3jMvYXTrCeIDyjx1tziRb6ARbismW6RICiYlLrg3XsFwJsd2/UzprwnOK
 5qJtwF9F785w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,367,1580803200"; 
   d="scan'208";a="297857982"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Apr 2020 10:47:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v3 2/2] KVM: X86: Ultra fast single target IPI fastpath
Date:   Fri, 10 Apr 2020 10:47:03 -0700
Message-Id: <20200410174703.1138-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410174703.1138-1-sean.j.christopherson@intel.com>
References: <f51251cc-885e-2f7a-b18d-faa76db15b87@redhat.com>
 <20200410174703.1138-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

IPI and Timer cause the main MSRs write vmexits in cloud environment
observation, let's optimize virtual IPI latency more aggressively to
inject target IPI as soon as possible.

Running kvm-unit-tests/vmexit.flat IPI testing on SKX server, disable
adaptive advance lapic timer and adaptive halt-polling to avoid the
interference, this patch can give another 7% improvement.

w/o fastpath -> fastpath            4238 -> 3543  16.4%
fastpath     -> ultra fastpath      3543 -> 3293     7%
w/o fastpath -> ultra fastpath      4238 -> 3293  22.3%

This also revises the performance data in commit 1e9e2622a1 (KVM: VMX:
FIXED+PHYSICAL mode single target IPI fastpath), that testing adds
--overcommit cpu-pm=on to kvm-unit-tests guest which is unnecessary.

Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Note, I dropped Haiwei Li's tested tag.

 arch/x86/include/asm/kvm_host.h |  5 ++---
 arch/x86/kvm/svm/svm.c          | 24 ++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.c          | 22 +++++++++++++---------
 arch/x86/kvm/x86.c              |  6 +++---
 4 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c7da23aed79a..40cb197b4903 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1124,7 +1124,7 @@ struct kvm_x86_ops {
 	 */
 	void (*tlb_flush_guest)(struct kvm_vcpu *vcpu);
 
-	void (*run)(struct kvm_vcpu *vcpu);
+	enum exit_fastpath_completion (*run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
@@ -1174,8 +1174,7 @@ struct kvm_x86_ops {
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage,
 			       struct x86_exception *exception);
-	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
-		enum exit_fastpath_completion *exit_fastpath);
+	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 27f4684a4c20..f40aa5a4253e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3283,10 +3283,21 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	svm_complete_interrupts(svm);
 }
 
+static enum exit_fastpath_completion svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+{
+	if (!is_guest_mode(vcpu) &&
+	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
+	    to_svm(vcpu)->vmcb->control.exit_info_1)
+		return handle_fastpath_set_msr_irqoff(vcpu);
+
+	return EXIT_FASTPATH_NONE;
+}
+
 bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
 
-static void svm_vcpu_run(struct kvm_vcpu *vcpu)
+static enum exit_fastpath_completion svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
+	enum exit_fastpath_completion exit_fastpath;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
@@ -3298,7 +3309,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * again.
 	 */
 	if (unlikely(svm->nested.exit_required))
-		return;
+		return EXIT_FASTPATH_NONE;
 
 	/*
 	 * Disable singlestep if we're injecting an interrupt/exception.
@@ -3389,6 +3400,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	stgi();
 
 	/* Any pending NMI will happen here */
+	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_after_interrupt(&svm->vcpu);
@@ -3417,6 +3429,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 		svm_handle_mce(svm);
 
 	mark_all_clean(svm->vmcb);
+	return exit_fastpath;
 }
 STACK_FRAME_NON_STANDARD(svm_vcpu_run);
 
@@ -3719,13 +3732,8 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu,
-	enum exit_fastpath_completion *exit_fastpath)
+static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
-	if (!is_guest_mode(vcpu) &&
-	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
-	    to_svm(vcpu)->vmcb->control.exit_info_1)
-		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
 }
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a8402bed29e3..a2e6c93a563b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6354,8 +6354,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 }
 STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
 
-static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
-	enum exit_fastpath_completion *exit_fastpath)
+static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6363,9 +6362,6 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
 		handle_exception_nmi_irqoff(vmx);
-	else if (!is_guest_mode(vcpu) &&
-		vmx->exit_reason == EXIT_REASON_MSR_WRITE)
-		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
 }
 
 static bool vmx_has_emulated_msr(int index)
@@ -6572,8 +6568,9 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
-static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
+static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
+	enum exit_fastpath_completion exit_fastpath;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
@@ -6585,7 +6582,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	/* Don't enter VMX if guest state is invalid, let the exit handler
 	   start emulation until we arrive back to a valid state */
 	if (vmx->emulation_required)
-		return;
+		return EXIT_FASTPATH_NONE;
 
 	if (vmx->ple_window_dirty) {
 		vmx->ple_window_dirty = false;
@@ -6738,7 +6735,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (unlikely(vmx->fail)) {
 		vmx->exit_reason = 0xdead;
-		return;
+		return EXIT_FASTPATH_NONE;
 	}
 
 	vmx->exit_reason = vmcs_read32(VM_EXIT_REASON);
@@ -6746,13 +6743,20 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		kvm_machine_check();
 
 	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
-		return;
+		return EXIT_FASTPATH_NONE;
+
+	if (!is_guest_mode(vcpu) && vmx->exit_reason == EXIT_REASON_MSR_WRITE)
+		exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
+	else
+		exit_fastpath = EXIT_FASTPATH_NONE;
 
 	vmx->loaded_vmcs->launched = 1;
 	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
+
+	return exit_fastpath;
 }
 
 static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3089aa4ffedf..1c1af0d31267 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8182,7 +8182,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	bool req_int_win =
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
-	enum exit_fastpath_completion exit_fastpath = EXIT_FASTPATH_NONE;
+	enum exit_fastpath_completion exit_fastpath;
 
 	bool req_immediate_exit = false;
 
@@ -8409,7 +8409,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	}
 
-	kvm_x86_ops.run(vcpu);
+	exit_fastpath = kvm_x86_ops.run(vcpu);
 
 	/*
 	 * Do this here before restoring debug registers on the host.  And
@@ -8441,7 +8441,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_x86_ops.handle_exit_irqoff(vcpu, &exit_fastpath);
+	kvm_x86_ops.handle_exit_irqoff(vcpu);
 
 	/*
 	 * Consume any pending interrupts, including the possible source of
-- 
2.26.0


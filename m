Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B42169C3C
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 03:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgBXCNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Feb 2020 21:13:06 -0500
Received: from mga06.intel.com ([134.134.136.31]:24747 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgBXCNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Feb 2020 21:13:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Feb 2020 18:13:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,478,1574150400"; 
   d="scan'208";a="255437187"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by orsmga002.jf.intel.com with ESMTP; 23 Feb 2020 18:13:02 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 1/2] kvm: vmx: Use basic exit reason to check if it's the specific VM EXIT
Date:   Mon, 24 Feb 2020 10:07:50 +0800
Message-Id: <20200224020751.1469-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200224020751.1469-1-xiaoyao.li@intel.com>
References: <20200224020751.1469-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current kvm uses the 32-bit exit reason to check if it's any specific VM
EXIT, however only the low 16-bit of VM EXIT REASON acts as the basic
exit reason.

Introduce Macro basic(exit_reaso) to help retrieve the basic exit reason
from VM EXIT REASON, and use the basic exit reason for checking and
indexing the exit hanlder.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 44 ++++++++++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.h |  2 ++
 2 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9a6664886f2e..85da72d4dc92 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1584,7 +1584,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 * i.e. we end up advancing IP with some random value.
 	 */
 	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
-	    to_vmx(vcpu)->exit_reason != EXIT_REASON_EPT_MISCONFIG) {
+	    basic(to_vmx(vcpu)->exit_reason) != EXIT_REASON_EPT_MISCONFIG) {
 		rip = kvm_rip_read(vcpu);
 		rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 		kvm_rip_write(vcpu, rip);
@@ -5797,6 +5797,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 exit_reason = vmx->exit_reason;
+	u16 basic_exit_reason = basic(exit_reason);
 	u32 vectoring_info = vmx->idt_vectoring_info;
 
 	trace_kvm_exit(exit_reason, vcpu, KVM_ISA_VMX);
@@ -5842,17 +5843,17 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	 * will cause infinite loop.
 	 */
 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
-			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
-			exit_reason != EXIT_REASON_EPT_VIOLATION &&
-			exit_reason != EXIT_REASON_PML_FULL &&
-			exit_reason != EXIT_REASON_TASK_SWITCH)) {
+			(basic_exit_reason != EXIT_REASON_EXCEPTION_NMI &&
+			 basic_exit_reason != EXIT_REASON_EPT_VIOLATION &&
+			 basic_exit_reason != EXIT_REASON_PML_FULL &&
+			 basic_exit_reason != EXIT_REASON_TASK_SWITCH)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
 		vcpu->run->internal.ndata = 3;
 		vcpu->run->internal.data[0] = vectoring_info;
 		vcpu->run->internal.data[1] = exit_reason;
 		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
-		if (exit_reason == EXIT_REASON_EPT_MISCONFIG) {
+		if (basic_exit_reason == EXIT_REASON_EPT_MISCONFIG) {
 			vcpu->run->internal.ndata++;
 			vcpu->run->internal.data[3] =
 				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
@@ -5884,32 +5885,32 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 		return 1;
 	}
 
-	if (exit_reason >= kvm_vmx_max_exit_handlers)
+	if (basic_exit_reason >= kvm_vmx_max_exit_handlers)
 		goto unexpected_vmexit;
 #ifdef CONFIG_RETPOLINE
-	if (exit_reason == EXIT_REASON_MSR_WRITE)
+	if (basic_exit_reason == EXIT_REASON_MSR_WRITE)
 		return kvm_emulate_wrmsr(vcpu);
-	else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
+	else if (basic_exit_reason == EXIT_REASON_PREEMPTION_TIMER)
 		return handle_preemption_timer(vcpu);
-	else if (exit_reason == EXIT_REASON_INTERRUPT_WINDOW)
+	else if (basic_exit_reason == EXIT_REASON_INTERRUPT_WINDOW)
 		return handle_interrupt_window(vcpu);
-	else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+	else if (basic_exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
 		return handle_external_interrupt(vcpu);
-	else if (exit_reason == EXIT_REASON_HLT)
+	else if (basic_exit_reason == EXIT_REASON_HLT)
 		return kvm_emulate_halt(vcpu);
-	else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
+	else if (basic_exit_reason == EXIT_REASON_EPT_MISCONFIG)
 		return handle_ept_misconfig(vcpu);
 #endif
 
-	exit_reason = array_index_nospec(exit_reason,
+	basic_exit_reason = array_index_nospec(basic_exit_reason,
 					 kvm_vmx_max_exit_handlers);
-	if (!kvm_vmx_exit_handlers[exit_reason])
+	if (!kvm_vmx_exit_handlers[basic_exit_reason])
 		goto unexpected_vmexit;
 
-	return kvm_vmx_exit_handlers[exit_reason](vcpu);
+	return kvm_vmx_exit_handlers[basic_exit_reason](vcpu);
 
 unexpected_vmexit:
-	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", exit_reason);
+	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", basic_exit_reason);
 	dump_vmcs();
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	vcpu->run->internal.suberror =
@@ -6241,13 +6242,14 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
 	enum exit_fastpath_completion *exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u16 basic_exit_reason = basic(vmx->exit_reason);
 
-	if (vmx->exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+	if (basic_exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
-	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
+	else if (basic_exit_reason == EXIT_REASON_EXCEPTION_NMI)
 		handle_exception_nmi_irqoff(vmx);
 	else if (!is_guest_mode(vcpu) &&
-		vmx->exit_reason == EXIT_REASON_MSR_WRITE)
+		 basic_exit_reason == EXIT_REASON_MSR_WRITE)
 		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
 }
 
@@ -6621,7 +6623,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->idt_vectoring_info = 0;
 
 	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
-	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
+	if (basic(vmx->exit_reason) == EXIT_REASON_MCE_DURING_VMENTRY)
 		kvm_machine_check();
 
 	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7f42cf3dcd70..c6ba33eedb59 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -22,6 +22,8 @@ extern u32 get_umwait_control_msr(void);
 
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
+#define basic(exit_reason) ((u16)(exit_reason))
+
 #ifdef CONFIG_X86_64
 #define NR_SHARED_MSRS	7
 #else
-- 
2.23.0


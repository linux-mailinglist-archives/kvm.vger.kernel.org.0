Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16EC1838E2
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 19:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgCLSpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 14:45:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:23446 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbgCLSp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 14:45:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 11:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="416041253"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2020 11:45:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 10/10] KVM: VMX: Convert vcpu_vmx.exit_reason to a union
Date:   Thu, 12 Mar 2020 11:45:21 -0700
Message-Id: <20200312184521.24579-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312184521.24579-1-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
bits 15:0, and single-bit modifiers in bits 31:16.

Historically, KVM has only had to worry about handling the "failed
VM-Entry" modifier, which could only be set in very specific flows and
required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
bit was a somewhat viable approach.  But even with only a single bit to
worry about, KVM has had several bugs related to comparing a basic exit
reason against the full exit reason stored in vcpu_vmx.

Upcoming Intel features, e.g. SGX, will add new modifier bits that can
be set on more or less any VM-Exit, as opposed to the significantly more
restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
flows isn't scalable.  Tracking exit reason in a union forces code to
explicitly choose between consuming the full exit reason and the basic
exit reason, and is a convenient way to document and access the
modifiers.

No functional change intended.

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 11 ++++++++---
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 24 ++++++++++++------------
 arch/x86/kvm/vmx/vmx.h    | 25 ++++++++++++++++++++++++-
 4 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c775feca3eb0..0c7cea35dd33 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5307,7 +5307,12 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 
 fail:
-	nested_vmx_vmexit(vcpu, vmx->exit_reason,
+	/*
+	 * This is effectively a reflected VM-Exit, as opposed to a synthesized
+	 * nested VM-Exit.  Pass the original exit reason, i.e. don't hardcode
+	 * EXIT_REASON_VMFUNC as the exit reason.
+	 */
+	nested_vmx_vmexit(vcpu, vmx->exit_reason.full,
 			  vmcs_read32(VM_EXIT_INTR_INFO),
 			  vmcs_readl(EXIT_QUALIFICATION));
 	return 1;
@@ -5549,14 +5554,14 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu)
 	 */
 	nested_mark_vmcs12_pages_dirty(vcpu);
 
-	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), vmx->exit_reason,
+	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), vmx->exit_reason.full,
 				vmcs_readl(EXIT_QUALIFICATION),
 				vmx->idt_vectoring_info,
 				intr_info,
 				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
 				KVM_ISA_VMX);
 
-	exit_reason = vmx->exit_reason;
+	exit_reason = vmx->exit_reason.basic;
 
 	switch (exit_reason) {
 	case EXIT_REASON_EXCEPTION_NMI:
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 04584bcbcc8d..07ce09f88977 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -98,7 +98,7 @@ static inline bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 			vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	}
 
-	nested_vmx_vmexit(vcpu, to_vmx(vcpu)->exit_reason, exit_intr_info,
+	nested_vmx_vmexit(vcpu, to_vmx(vcpu)->exit_reason.full, exit_intr_info,
 			  vmcs_readl(EXIT_QUALIFICATION));
 	return true;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 910a7cadeaf7..521b99f63608 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1588,7 +1588,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 * i.e. we end up advancing IP with some random value.
 	 */
 	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
-	    to_vmx(vcpu)->exit_reason != EXIT_REASON_EPT_MISCONFIG) {
+	    to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_EPT_MISCONFIG) {
 		rip = kvm_rip_read(vcpu);
 		rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 		kvm_rip_write(vcpu, rip);
@@ -5847,7 +5847,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	u32 vectoring_info = vmx->idt_vectoring_info;
 	u16 exit_reason;
 
-	trace_kvm_exit(vmx->exit_reason, vcpu, KVM_ISA_VMX);
+	trace_kvm_exit(vmx->exit_reason.full, vcpu, KVM_ISA_VMX);
 
 	/*
 	 * Flush logged GPAs PML buffer, this will make dirty_bitmap more
@@ -5866,11 +5866,11 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	if (is_guest_mode(vcpu) && nested_vmx_reflect_vmexit(vcpu))
 		return 1;
 
-	if (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
+	if (vmx->exit_reason.failed_vmentry) {
 		dump_vmcs();
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
-			= vmx->exit_reason;
+			= vmx->exit_reason.full;
 		return 0;
 	}
 
@@ -5882,7 +5882,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 		return 0;
 	}
 
-	exit_reason = vmx->exit_reason;
+	exit_reason = vmx->exit_reason.basic;
 
 	/*
 	 * Note:
@@ -5900,7 +5900,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
 		vcpu->run->internal.ndata = 3;
 		vcpu->run->internal.data[0] = vectoring_info;
-		vcpu->run->internal.data[1] = vmx->exit_reason;
+		vcpu->run->internal.data[1] = vmx->exit_reason.full;
 		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
 		if (exit_reason == EXIT_REASON_EPT_MISCONFIG) {
 			vcpu->run->internal.ndata++;
@@ -5960,13 +5960,13 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 
 unexpected_vmexit:
 	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
-		    vmx->exit_reason);
+		    vmx->exit_reason.full);
 	dump_vmcs();
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
 	vcpu->run->internal.ndata = 1;
-	vcpu->run->internal.data[0] = vmx->exit_reason;
+	vcpu->run->internal.data[0] = vmx->exit_reason.full;
 	return 0;
 }
 
@@ -6290,7 +6290,7 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
 				   enum exit_fastpath_completion *exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u16 exit_reason = vmx->exit_reason;
+	u16 exit_reason = vmx->exit_reason.basic;
 
 	if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
@@ -6672,11 +6672,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->nested.nested_run_pending = 0;
 	vmx->idt_vectoring_info = 0;
 
-	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
-	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
+	vmx->exit_reason.full = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
+	if (vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY)
 		kvm_machine_check();
 
-	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
+	if (vmx->fail || vmx->exit_reason.failed_vmentry)
 		return;
 
 	vmx->loaded_vmcs->launched = 1;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e64da06c7009..2d9a005d11ab 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -93,6 +93,29 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
+union vmx_exit_reason {
+	struct {
+		u32	basic			: 16;
+		u32	reserved16		: 1;
+		u32	reserved17		: 1;
+		u32	reserved18		: 1;
+		u32	reserved19		: 1;
+		u32	reserved20		: 1;
+		u32	reserved21		: 1;
+		u32	reserved22		: 1;
+		u32	reserved23		: 1;
+		u32	reserved24		: 1;
+		u32	reserved25		: 1;
+		u32	reserved26		: 1;
+		u32	enclave_mode		: 1;
+		u32	smi_pending_mtf		: 1;
+		u32	smi_from_vmx_root	: 1;
+		u32	reserved30		: 1;
+		u32	failed_vmentry		: 1;
+	};
+	u32 full;
+};
+
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -263,7 +286,7 @@ struct vcpu_vmx {
 	int vpid;
 	bool emulation_required;
 
-	u32 exit_reason;
+	union vmx_exit_reason exit_reason;
 
 	/* Posted interrupt descriptor */
 	struct pi_desc pi_desc;
-- 
2.24.1


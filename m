Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C971077705
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfG0Fxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:53:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:40960 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728243AbfG0FwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568604"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 09/21] KVM: VMX: Add basic handling of VM-Exit from SGX enclave
Date:   Fri, 26 Jul 2019 22:52:02 -0700
Message-Id: <20190727055214.9282-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel SGX adds a new CPL3-only execution environment referred to as an
"enclave".  To protect the secrets of an enclave, the CPU's state is
loaded with synthetic data when exiting the enclave (the enclave's state
is saved/restored via protected memory), and the RIP is set to a defined
exit value.  This behavior also applies to VMi-Exits from the enclave,
e.g. GUEST_RIP may not necessarily reflect the actual RIP that triggered
the VMExit.

To help a VMM recognize and handle exits from enclaves, SGX adds bits to
existing VMCS fields, VM_EXIT_REASON.VMX_EXIT_REASON_FROM_ENCLAVE and
GUEST_INTERRUPTIBILITY_INFO.GUEST_INTR_STATE_ENCLAVE_INTR.  Define the
new architectural bits and add a boolean to struct vcpu_vmx to cache
VMX_EXIT_REASON_FROM_ENCLAVE and clear the bit in exit_reason so that
checks against exit_reason do not need to account for SGX, e.g.
exit_reason == EXIT_REASON_EXCEPTION_NMI continues to work.

As for new behavior for VM-Exits from enclaves, KVM is for the most
part a passive observer of both bits, e.g. it needs to account for
the bits when propagating information to a nested VMM, but otherwise
doesn't need to act differently for VMExits from enclaves.

The one scenario that is impacted is emulation, which becomes impossible
since KVM does not have access to the RIP or instruction stream that
triggered the VMExit[2].  This is largely a non-issue as most
instructions that might trigger VM-Exit are designed to unconditionally
that may VM-Exit but do not #UD, KVM either never sets the exiting
control, e.g. PAUSE_EXITING[1], or sets it if and only if the feature is
not exposed to the guest in order to inject a #UD, e.g. RDRAND_EXITING.

But, because it is still possible for a guest to trigger emulation,
e.g. MMIO, inject a #UD if KVM ever attempts emulation after a VM-Exit
from an enclave.  This is architecturally accurate for instruction
VM-Exits, and for MMIO it's the least bad choice, e.g. it's preferable
to killing the VM.  In practice, only broken or particularly stupid
guests should ever encounter this behavior.

Add a WARN in skip_emulated_instruction to detect any attempt to
modify the guest's RIP during an SGX enclave VM-Exit as all such flows
should either be unreachable or must handle exits from enclaves before
getting to skip_emulated_instruction.

[1] PAUSE_LOOP_EXITING only affects CPL0 and enclaves exist only at
    CPL3, so we also don't need to worry about that interaction.

[2] Impossible for all practical purposes.  Not truly impossible
    since KVM could implement some form of para-virtualization scheme.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/include/uapi/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/nested.c       |  2 ++
 arch/x86/kvm/vmx/vmx.c          | 42 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h          |  3 +++
 5 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index a39136b0d509..a62ac47d2006 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -364,6 +364,7 @@ enum vmcs_field {
 #define GUEST_INTR_STATE_MOV_SS		0x00000002
 #define GUEST_INTR_STATE_SMI		0x00000004
 #define GUEST_INTR_STATE_NMI		0x00000008
+#define GUEST_INTR_STATE_ENCLAVE_INTR	0x00000010
 
 /* GUEST_ACTIVITY_STATE flags */
 #define GUEST_ACTIVITY_ACTIVE		0
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index d213ec5c3766..501a35bd4cc7 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -27,6 +27,7 @@
 
 
 #define VMX_EXIT_REASONS_FAILED_VMENTRY         0x80000000
+#define VMX_EXIT_REASON_FROM_ENCLAVE		0x08000000
 
 #define EXIT_REASON_EXCEPTION_NMI       0
 #define EXIT_REASON_EXTERNAL_INTERRUPT  1
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 46af3a5e9209..fef4fb3e1aaa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3523,6 +3523,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	/* update exit information fields: */
 
 	vmcs12->vm_exit_reason = exit_reason;
+	if (to_vmx(vcpu)->sgx_enclave_exit)
+		vmcs12->vm_exit_reason |= VMX_EXIT_REASON_FROM_ENCLAVE;
 	vmcs12->exit_qualification = exit_qualification;
 	vmcs12->vm_exit_intr_info = exit_intr_info;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f48fc990ca6d..abcd2f7a36f5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1460,16 +1460,40 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 
 static bool vmx_is_emulatable(struct kvm_vcpu *vcpu, void *insn, int insn_len)
 {
+	if (unlikely(to_vmx(vcpu)->sgx_enclave_exit)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return false;
+	}
 	return true;
 }
 
 static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
+	u32 instr_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 	unsigned long rip;
 
-	rip = kvm_rip_read(vcpu);
-	rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
-	kvm_rip_write(vcpu, rip);
+	/*
+	 * Emulating an enclave instruction is not supported as KVM cannot
+	 * access the enclave's memory or its true RIP, e.g. the GUEST_RIP
+	 * field points at the exit point of the enclave, not the RIP that
+	 * actually triggered the VMExit.  But, because most instructions
+	 * that cause VM-Exit will #UD in an enclave, this conundrum is
+	 * handled for us.  There are a few exceptions, notably the debug
+	 * instructions INT1ICEBRK and INT3, as they are allowed in debug
+	 * enclaves and generate #DB/#BP as expected, which KVM might
+	 * intercept.  But again, the CPU does the dirty work and saves an
+	 * instr length of zero so that VMMs don't shoot themselves in the
+	 * foot.  WARN if we try to skip a non-zero length instruction after
+	 * a VMExit from an enclave.
+	 */
+	if (likely(instr_len)) {
+		WARN(to_vmx(vcpu)->sgx_enclave_exit,
+		     "KVM: skipping instruction after SGX enclave VM-Exit");
+
+		rip = kvm_rip_read(vcpu);
+		rip += instr_len;
+		kvm_rip_write(vcpu, rip);
+	}
 
 	/* skipping an emulated instruction also counts */
 	vmx_set_interrupt_shadow(vcpu, 0);
@@ -5104,6 +5128,9 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 {
 	gpa_t gpa;
 
+	if (!vmx_is_emulatable(vcpu, NULL, 0))
+		return 1;
+
 	/*
 	 * A nested guest cannot optimize MMIO vmexits, because we have an
 	 * nGPA here instead of the required GPA.
@@ -6537,6 +6564,15 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->idt_vectoring_info = 0;
 
 	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
+
+	/*
+	 * Immediately cache and clear the "exit from SGX enclave" bit so that
+	 * KVM can directly compare exit_reason against the base exit reasons,
+	 * e.g. exit_reason == EXIT_REASON_EXCEPTION_NMI.
+	 */
+	vmx->sgx_enclave_exit =
+		(vmx->exit_reason & VMX_EXIT_REASON_FROM_ENCLAVE);
+	vmx->exit_reason &= ~VMX_EXIT_REASON_FROM_ENCLAVE;
 	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 61128b48c503..6d1b57e0337e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -247,6 +247,9 @@ struct vcpu_vmx {
 
 	bool req_immediate_exit;
 
+	/* Exit from SGX enclave */
+	bool sgx_enclave_exit;
+
 	/* Support for PML */
 #define PML_ENTITY_NUM		512
 	struct page *pml_pg;
-- 
2.22.0


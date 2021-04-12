Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BEF35B940
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhDLEWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:22:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:53377 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230042AbhDLEWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:22:25 -0400
IronPort-SDR: cP4hcNdLIwJU03+7davTFasV9WwlZ3XLIZyj2YDIEvwYnBINSma1kHQNQJvCnkokpPqDP+nPT8
 VgC8xSSpkIpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9951"; a="258083769"
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="258083769"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:07 -0700
IronPort-SDR: f8gxkgTn5oynauq/M5zCerUEh7RZokTpmXtyXIpPjklyyDGSqKurvZ7dSTlLtQ/xQzwsyo1P9+
 yhMz6PQH9yWg==
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="521030388"
Received: from rutujajo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.194.203])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:04 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v5 05/11] KVM: VMX: Add basic handling of VM-Exit from SGX enclave
Date:   Mon, 12 Apr 2021 16:21:37 +1200
Message-Id: <315f54a8507d09c292463ef29104e1d4c62e9090.1618196135.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618196135.git.kai.huang@intel.com>
References: <cover.1618196135.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add support for handling VM-Exits that originate from a guest SGX
enclave.  In SGX, an "enclave" is a new CPL3-only execution environment,
wherein the CPU and memory state is protected by hardware to make the
state inaccesible to code running outside of the enclave.  When exiting
an enclave due to an asynchronous event (from the perspective of the
enclave), e.g. exceptions, interrupts, and VM-Exits, the enclave's state
is automatically saved and scrubbed (the CPU loads synthetic state), and
then reloaded when re-entering the enclave.  E.g. after an instruction
based VM-Exit from an enclave, vmcs.GUEST_RIP will not contain the RIP
of the enclave instruction that trigered VM-Exit, but will instead point
to a RIP in the enclave's untrusted runtime (the guest userspace code
that coordinates entry/exit to/from the enclave).

To help a VMM recognize and handle exits from enclaves, SGX adds bits to
existing VMCS fields, VM_EXIT_REASON.VMX_EXIT_REASON_FROM_ENCLAVE and
GUEST_INTERRUPTIBILITY_INFO.GUEST_INTR_STATE_ENCLAVE_INTR.  Define the
new architectural bits, and add a boolean to struct vcpu_vmx to cache
VMX_EXIT_REASON_FROM_ENCLAVE.  Clear the bit in exit_reason so that
checks against exit_reason do not need to account for SGX, e.g.
"if (exit_reason == EXIT_REASON_EXCEPTION_NMI)" continues to work.

KVM is a largely a passive observer of the new bits, e.g. KVM needs to
account for the bits when propagating information to a nested VMM, but
otherwise doesn't need to act differently for the majority of VM-Exits
from enclaves.

The one scenario that is directly impacted is emulation, which is for
all intents and purposes impossible[1] since KVM does not have access to
the RIP or instruction stream that triggered the VM-Exit.  The inability
to emulate is a non-issue for KVM, as most instructions that might
trigger VM-Exit unconditionally #UD in an enclave (before the VM-Exit
check.  For the few instruction that conditionally #UD, KVM either never
sets the exiting control, e.g. PAUSE_EXITING[2], or sets it if and only
if the feature is not exposed to the guest in order to inject a #UD,
e.g. RDRAND_EXITING.

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

[1] Impossible for all practical purposes.  Not truly impossible
    since KVM could implement some form of para-virtualization scheme.

[2] PAUSE_LOOP_EXITING only affects CPL0 and enclaves exist only at
    CPL3, so we also don't need to worry about that interaction.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/include/uapi/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/nested.c       |  2 ++
 arch/x86/kvm/vmx/vmx.c          | 45 +++++++++++++++++++++++++++++++--
 4 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 358707f60d99..0ffaa3156a4e 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -373,6 +373,7 @@ enum vmcs_field {
 #define GUEST_INTR_STATE_MOV_SS		0x00000002
 #define GUEST_INTR_STATE_SMI		0x00000004
 #define GUEST_INTR_STATE_NMI		0x00000008
+#define GUEST_INTR_STATE_ENCLAVE_INTR	0x00000010
 
 /* GUEST_ACTIVITY_STATE flags */
 #define GUEST_ACTIVITY_ACTIVE		0
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index b8e650a985e3..946d761adbd3 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -27,6 +27,7 @@
 
 
 #define VMX_EXIT_REASONS_FAILED_VMENTRY         0x80000000
+#define VMX_EXIT_REASONS_SGX_ENCLAVE_MODE	0x08000000
 
 #define EXIT_REASON_EXCEPTION_NMI       0
 #define EXIT_REASON_EXTERNAL_INTERRUPT  1
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e02ebc28270e..baaea9bbb8e5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4111,6 +4111,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 {
 	/* update exit information fields: */
 	vmcs12->vm_exit_reason = vm_exit_reason;
+	if (to_vmx(vcpu)->exit_reason.enclave_mode)
+		vmcs12->vm_exit_reason |= VMX_EXIT_REASONS_SGX_ENCLAVE_MODE;
 	vmcs12->exit_qualification = exit_qualification;
 	vmcs12->vm_exit_intr_info = exit_intr_info;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c05e6e2854b5..09f2c9ec4468 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1588,12 +1588,25 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 
 static bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len)
 {
+	/*
+	 * Emulation of instructions in SGX enclaves is impossible as RIP does
+	 * not point  tthe failing instruction, and even if it did, the code
+	 * stream is inaccessible.  Inject #UD instead of exiting to userspace
+	 * so that guest userspace can't DoS the guest simply by triggering
+	 * emulation (enclaves are CPL3 only).
+	 */
+	if (to_vmx(vcpu)->exit_reason.enclave_mode) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return false;
+	}
 	return true;
 }
 
 static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
+	union vmx_exit_reason exit_reason = to_vmx(vcpu)->exit_reason;
 	unsigned long rip, orig_rip;
+	u32 instr_len;
 
 	/*
 	 * Using VMCS.VM_EXIT_INSTRUCTION_LEN on EPT misconfig depends on
@@ -1604,9 +1617,33 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 * i.e. we end up advancing IP with some random value.
 	 */
 	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
-	    to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_EPT_MISCONFIG) {
+	    exit_reason.basic != EXIT_REASON_EPT_MISCONFIG) {
+		instr_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+
+		/*
+		 * Emulating an enclave's instructions isn't supported as KVM
+		 * cannot access the enclave's memory or its true RIP, e.g. the
+		 * vmcs.GUEST_RIP points at the exit point of the enclave, not
+		 * the RIP that actually triggered the VM-Exit.  But, because
+		 * most instructions that cause VM-Exit will #UD in an enclave,
+		 * most instruction-based VM-Exits simply do not occur.
+		 *
+		 * There are a few exceptions, notably the debug instructions
+		 * INT1ICEBRK and INT3, as they are allowed in debug enclaves
+		 * and generate #DB/#BP as expected, which KVM might intercept.
+		 * But again, the CPU does the dirty work and saves an instr
+		 * length of zero so VMMs don't shoot themselves in the foot.
+		 * WARN if KVM tries to skip a non-zero length instruction on
+		 * a VM-Exit from an enclave.
+		 */
+		if (!instr_len)
+			goto rip_updated;
+
+		WARN(exit_reason.enclave_mode,
+		     "KVM: skipping instruction after SGX enclave VM-Exit");
+
 		orig_rip = kvm_rip_read(vcpu);
-		rip = orig_rip + vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+		rip = orig_rip + instr_len;
 #ifdef CONFIG_X86_64
 		/*
 		 * We need to mask out the high 32 bits of RIP if not in 64-bit
@@ -1622,6 +1659,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 			return 0;
 	}
 
+rip_updated:
 	/* skipping an emulated instruction also counts */
 	vmx_set_interrupt_shadow(vcpu, 0);
 
@@ -5353,6 +5391,9 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 {
 	gpa_t gpa;
 
+	if (!vmx_can_emulate_instruction(vcpu, NULL, 0))
+		return 1;
+
 	/*
 	 * A nested guest cannot optimize MMIO vmexits, because we have an
 	 * nGPA here instead of the required GPA.
-- 
2.30.2


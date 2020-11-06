Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDA42A8FB0
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 07:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgKFGvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 01:51:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:59061 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbgKFGvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 01:51:42 -0500
IronPort-SDR: A9dVzy4xvPfkOip7KLYns/KWOiW5+FWnwhY/BYirUta3N8VajjT/+NVLz9zosyKRVEmoD6H2e9
 mJI6Lj7oc6lw==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="169659862"
X-IronPort-AV: E=Sophos;i="5.77,455,1596524400"; 
   d="scan'208";a="169659862"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 22:51:41 -0800
IronPort-SDR: d0svsbFeVXli8MM2DmxpPXMh5BrJfU0WnQ5OPni4sTnq33S0tq8mnxCVYzD6CGFzUVphqZ8mMz
 HMtOVySzfOcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,455,1596524400"; 
   d="scan'208";a="364087368"
Received: from yadong-antec.sh.intel.com ([10.239.158.61])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Nov 2020 22:51:40 -0800
From:   yadong.qi@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, yadong.qi@intel.com
Subject: [PATCH v2 2/2] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Date:   Fri,  6 Nov 2020 14:51:22 +0800
Message-Id: <20201106065122.403183-1-yadong.qi@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yadong Qi <yadong.qi@intel.com>

Background: We have a lightweight HV, it needs INIT-VMExit and
SIPI-VMExit to wake-up APs for guests since it do not monitor
the Local APIC. But currently virtual wait-for-SIPI(WFS) state
is not supported in nVMX, so when running on top of KVM, the L1
HV cannot receive the INIT-VMExit and SIPI-VMExit which cause
the L2 guest cannot wake up the APs.

According to Intel SDM Chapter 25.2 Other Causes of VM Exits,
SIPIs cause VM exits when a logical processor is in
wait-for-SIPI state.

In this patch:
    1. introduce SIPI exit reason,
    2. introduce wait-for-SIPI state for nVMX,
    3. advertise wait-for-SIPI support to guest.

When L1 hypervisor is not monitoring Local APIC, L0 need to emulate
INIT-VMExit and SIPI-VMExit to L1 to emulate INIT-SIPI-SIPI for
L2. L2 LAPIC write would be traped by L0 Hypervisor(KVM), L0 should
emulate the INIT/SIPI vmexit to L1 hypervisor to set proper state
for L2's vcpu state.

Handle procdure:
Source vCPU:
    L2 write LAPIC.ICR(INIT).
    L0 trap LAPIC.ICR write(INIT): inject a latched INIT event to target
       vCPU.
Target vCPU:
    L0 emulate an INIT VMExit to L1 if is guest mode.
    L1 set guest VMCS, guest_activity_state=WAIT_SIPI, vmresume.
    L0 set vcpu.mp_state to INIT_RECEIVED if (vmcs12.guest_activity_state
       == WAIT_SIPI).

Source vCPU:
    L2 write LAPIC.ICR(SIPI).
    L0 trap LAPIC.ICR write(INIT): inject a latched SIPI event to traget
       vCPU.
Target vCPU:
    L0 emulate an SIPI VMExit to L1 if (vcpu.mp_state == INIT_RECEIVED).
    L1 set CS:IP, guest_activity_state=ACTIVE, vmresume.
    L0 resume to L2.
    L2 start-up.

Signed-off-by: Yadong Qi <yadong.qi@intel.com>
Message-Id: <20200922052343.84388-1-yadong.qi@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
v1->v2:
 * sync_vmcs02_to_vmcs12(): set vmcs12->guest_activity_state to WAIT_SIPI
   if vcpu's mp_state is INIT_RECEIVED state.
---
 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/include/uapi/asm/vmx.h |  2 ++
 arch/x86/kvm/vmx/nested.c       | 55 ++++++++++++++++++++++++---------
 3 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f8ba5289ecb0..38ca445a8429 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -113,6 +113,7 @@
 #define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
 #define VMX_MISC_SAVE_EFER_LMA			0x00000020
 #define VMX_MISC_ACTIVITY_HLT			0x00000040
+#define VMX_MISC_ACTIVITY_WAIT_SIPI		0x00000100
 #define VMX_MISC_ZERO_LEN_INS			0x40000000
 #define VMX_MISC_MSR_LIST_MULTIPLIER		512
 
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index b8ff9e8ac0d5..ada955c5ebb6 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -32,6 +32,7 @@
 #define EXIT_REASON_EXTERNAL_INTERRUPT  1
 #define EXIT_REASON_TRIPLE_FAULT        2
 #define EXIT_REASON_INIT_SIGNAL			3
+#define EXIT_REASON_SIPI_SIGNAL         4
 
 #define EXIT_REASON_INTERRUPT_WINDOW    7
 #define EXIT_REASON_NMI_WINDOW          8
@@ -94,6 +95,7 @@
 	{ EXIT_REASON_EXTERNAL_INTERRUPT,    "EXTERNAL_INTERRUPT" }, \
 	{ EXIT_REASON_TRIPLE_FAULT,          "TRIPLE_FAULT" }, \
 	{ EXIT_REASON_INIT_SIGNAL,           "INIT_SIGNAL" }, \
+	{ EXIT_REASON_SIPI_SIGNAL,           "SIPI_SIGNAL" }, \
 	{ EXIT_REASON_INTERRUPT_WINDOW,      "INTERRUPT_WINDOW" }, \
 	{ EXIT_REASON_NMI_WINDOW,            "NMI_WINDOW" }, \
 	{ EXIT_REASON_TASK_SWITCH,           "TASK_SWITCH" }, \
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 89af692deb7e..6dc9017289ba 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2952,7 +2952,8 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
 static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
 {
 	if (CC(vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE &&
-	       vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT))
+	       vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT &&
+	       vmcs12->guest_activity_state != GUEST_ACTIVITY_WAIT_SIPI))
 		return -EINVAL;
 
 	return 0;
@@ -3559,19 +3560,29 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 */
 	nested_cache_shadow_vmcs12(vcpu, vmcs12);
 
-	/*
-	 * If we're entering a halted L2 vcpu and the L2 vcpu won't be
-	 * awakened by event injection or by an NMI-window VM-exit or
-	 * by an interrupt-window VM-exit, halt the vcpu.
-	 */
-	if ((vmcs12->guest_activity_state == GUEST_ACTIVITY_HLT) &&
-	    !(vmcs12->vm_entry_intr_info_field & INTR_INFO_VALID_MASK) &&
-	    !(vmcs12->cpu_based_vm_exec_control & CPU_BASED_NMI_WINDOW_EXITING) &&
-	    !((vmcs12->cpu_based_vm_exec_control & CPU_BASED_INTR_WINDOW_EXITING) &&
-	      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
+	switch (vmcs12->guest_activity_state) {
+	case GUEST_ACTIVITY_HLT:
+		/*
+		 * If we're entering a halted L2 vcpu and the L2 vcpu won't be
+		 * awakened by event injection or by an NMI-window VM-exit or
+		 * by an interrupt-window VM-exit, halt the vcpu.
+		 */
+		if (!(vmcs12->vm_entry_intr_info_field & INTR_INFO_VALID_MASK) &&
+		    !nested_cpu_has(vmcs12, CPU_BASED_NMI_WINDOW_EXITING) &&
+		    !(nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING) &&
+		      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
+			vmx->nested.nested_run_pending = 0;
+			return kvm_vcpu_halt(vcpu);
+		}
+		break;
+	case GUEST_ACTIVITY_WAIT_SIPI:
 		vmx->nested.nested_run_pending = 0;
-		return kvm_vcpu_halt(vcpu);
+		vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
+		break;
+	default:
+		break;
 	}
+
 	return 1;
 
 vmentry_failed:
@@ -3797,7 +3808,20 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 			return -EBUSY;
 		nested_vmx_update_pending_dbg(vcpu);
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
-		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
+		if (vcpu->arch.mp_state != KVM_MP_STATE_INIT_RECEIVED)
+			nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
+		return 0;
+	}
+
+	if (lapic_in_kernel(vcpu) &&
+	    test_bit(KVM_APIC_SIPI, &apic->pending_events)) {
+		if (block_nested_events)
+			return -EBUSY;
+
+		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
+		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED)
+			nested_vmx_vmexit(vcpu, EXIT_REASON_SIPI_SIGNAL, 0,
+						apic->sipi_vector & 0xFFUL);
 		return 0;
 	}
 
@@ -4036,6 +4060,8 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
 		vmcs12->guest_activity_state = GUEST_ACTIVITY_HLT;
+	else if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED)
+		vmcs12->guest_activity_state = GUEST_ACTIVITY_WAIT_SIPI;
 	else
 		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
 
@@ -6483,7 +6509,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->misc_low |=
 		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
 		VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE |
-		VMX_MISC_ACTIVITY_HLT;
+		VMX_MISC_ACTIVITY_HLT |
+		VMX_MISC_ACTIVITY_WAIT_SIPI;
 	msrs->misc_high = 0;
 
 	/*
-- 
2.25.1


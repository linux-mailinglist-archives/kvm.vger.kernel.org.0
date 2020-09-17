Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2421C26D126
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 04:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgIQCcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 22:32:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:27316 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgIQCcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 22:32:22 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 22:32:21 EDT
IronPort-SDR: DoQgVxg+pNPNCyhdfJXCdCnRlpNVgAW0mbZ4f7KYNxwpZC1+M6K7RMCB7U5j9bL3HnmwecFLLT
 Ylvz5x2Hibpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="223791703"
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="223791703"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 19:25:12 -0700
IronPort-SDR: uDz+ipUyDkh+CGmXVhJDknh9smuAUgciSMODoMrBIV48iO92bFx3mHpPjHtumLb4Ioujt/SxTz
 NXLcOEsJBmZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="339287186"
Received: from yadong-antec.sh.intel.com ([10.239.158.61])
  by fmsmga002.fm.intel.com with ESMTP; 16 Sep 2020 19:25:08 -0700
From:   yadong.qi@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, liran.alon@oracle.com,
        nikita.leshchenko@oracle.com, chao.gao@intel.com,
        kevin.tian@intel.com, luhai.chen@intel.com, bing.zhu@intel.com,
        kai.z.wang@intel.com, yadong.qi@intel.com
Subject: [PATCH RFC] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Date:   Thu, 17 Sep 2020 10:25:01 +0800
Message-Id: <20200917022501.369121-1-yadong.qi@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yadong Qi <yadong.qi@intel.com>

Background: We have a lightweight HV, it needs INIT-VMExit and
SIPI-VMExit to wake-up APs for guests since it do not monitoring
the Local APIC. But currently virtual wait-for-SIPI(WFS) state
is not supported in KVM, so when running on top of KVM, the L1
HV cannot receive the INIT-VMExit and SIPI-VMExit which cause
the L2 guest cannot wake up the APs.

This patch is incomplete, it emulated wait-for-SIPI state by halt
the vCPU and emulated SIPI-VMExit to L1 when trapped SIPI signal
from L2. I am posting it RFC to gauge whether or not upstream
KVM is interested in emulating wait-for-SIPI state before
investing the time to finish the full support.

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
    L0 halt vCPU if (vmcs12.guest_activity_state == WAIT_SIPI).

Source vCPU:
    L2 write LAPIC.ICR(SIPI).
    L0 trap LAPIC.ICR write(INIT): inject a latched SIPI event to traget
       vCPU.
Target vCPU:
    L0 emulate an SIPI VMExit to L1 if (vmcs12.guest_activity_state ==
       WAIT_SIPI).
    L1 set CS:IP, guest_activity_state=ACTIVE, vmresume
    L0 resume to L2
    L2 start-up

Signed-off-by: Yadong Qi <yadong.qi@intel.com>
---
 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/include/uapi/asm/vmx.h |  2 ++
 arch/x86/kvm/lapic.c            |  5 +++--
 arch/x86/kvm/vmx/nested.c       | 25 +++++++++++++++++++++----
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index cd7de4b401fe..bff06dc64c52 100644
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
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5ccbee7165a2..d04ac7dc6adf 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2839,7 +2839,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 
 	/*
 	 * INITs are latched while CPU is in specific states
-	 * (SMM, VMX non-root mode, SVM with GIF=0).
+	 * (SMM, SVM with GIF=0).
 	 * Because a CPU cannot be in these states immediately
 	 * after it has processed an INIT signal (and thus in
 	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
@@ -2847,7 +2847,8 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_vcpu_latch_init(vcpu)) {
 		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
-		if (test_bit(KVM_APIC_SIPI, &apic->pending_events))
+		if (test_bit(KVM_APIC_SIPI, &apic->pending_events) &&
+		    !is_guest_mode(vcpu))
 			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
 		return;
 	}
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1bb6b31eb646..399933b8ac3a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2946,7 +2946,8 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
 static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
 {
 	if (CC(vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE &&
-	       vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT))
+	       vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT &&
+	       vmcs12->guest_activity_state != GUEST_ACTIVITY_WAIT_SIPI))
 		return -EINVAL;
 
 	return 0;
@@ -3548,7 +3549,8 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 * awakened by event injection or by an NMI-window VM-exit or
 	 * by an interrupt-window VM-exit, halt the vcpu.
 	 */
-	if ((vmcs12->guest_activity_state == GUEST_ACTIVITY_HLT) &&
+	if (((vmcs12->guest_activity_state == GUEST_ACTIVITY_HLT) ||
+	    (vmcs12->guest_activity_state == GUEST_ACTIVITY_WAIT_SIPI)) &&
 	    !(vmcs12->vm_entry_intr_info_field & INTR_INFO_VALID_MASK) &&
 	    !(vmcs12->cpu_based_vm_exec_control & CPU_BASED_NMI_WINDOW_EXITING) &&
 	    !((vmcs12->cpu_based_vm_exec_control & CPU_BASED_INTR_WINDOW_EXITING) &&
@@ -3767,6 +3769,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
 	bool mtf_pending = vmx->nested.mtf_pending;
 	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
 	/*
 	 * Clear the MTF state. If a higher priority VM-exit is delivered first,
@@ -3781,7 +3784,20 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 			return -EBUSY;
 		nested_vmx_update_pending_dbg(vcpu);
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
-		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
+		if (vmcs12->guest_activity_state != GUEST_ACTIVITY_WAIT_SIPI)
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
+		if (vmcs12->guest_activity_state == GUEST_ACTIVITY_WAIT_SIPI)
+			nested_vmx_vmexit(vcpu, EXIT_REASON_SIPI_SIGNAL, 0,
+						apic->sipi_vector & 0xFFUL);
 		return 0;
 	}
 
@@ -6471,7 +6487,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639DD2A8494
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 18:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731763AbgKERPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 12:15:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731736AbgKERPe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 12:15:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604596532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SNvhLe4ZO1acx0vkrmzM1482cyKjNHogPIf4jsxyGo0=;
        b=CrEqdHoQ9GOfI4678m57x7Qm8KgymcdkZj07ueE9gotgoxtxplJleqJHHpH/pIMQdIkntF
        oaHQgTBuC+gJZA2O+JOiNqy4MA1VS/M8b7fubnapgaIfTw4JfuhKSexmSAmmCZ/rNTpMUD
        oieBPrWvJZ3tvxALwJB2hXkT5t+3KhA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-PrXAJncrMqSBPDYaDF4Z1g-1; Thu, 05 Nov 2020 12:15:27 -0500
X-MC-Unique: PrXAJncrMqSBPDYaDF4Z1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 461416D584;
        Thu,  5 Nov 2020 17:15:26 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF7916CE4F;
        Thu,  5 Nov 2020 17:15:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     yadong.qi@intel.com
Subject: [PATCH 2/2] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Date:   Thu,  5 Nov 2020 12:15:24 -0500
Message-Id: <20201105171524.650693-3-pbonzini@redhat.com>
In-Reply-To: <20201105171524.650693-1-pbonzini@redhat.com>
References: <20201105171524.650693-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/include/uapi/asm/vmx.h |  2 ++
 arch/x86/kvm/vmx/nested.c       | 53 ++++++++++++++++++++++++---------
 3 files changed, 42 insertions(+), 14 deletions(-)

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
index 89af692deb7e..c35eec55b2c6 100644
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
 
@@ -6483,7 +6507,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->misc_low |=
 		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
 		VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE |
-		VMX_MISC_ACTIVITY_HLT;
+		VMX_MISC_ACTIVITY_HLT |
+		VMX_MISC_ACTIVITY_WAIT_SIPI;
 	msrs->misc_high = 0;
 
 	/*
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAF916B1E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfEGTSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:55700 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbfEGTSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 15:18:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 12:18:06 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 07 May 2019 12:18:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 13/13] KVM: VMX: Leave preemption timer running when it's disabled
Date:   Tue,  7 May 2019 12:18:05 -0700
Message-Id: <20190507191805.9932-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507191805.9932-1-sean.j.christopherson@intel.com>
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMWRITEs to the major VMCS controls, pin controls included, are
deceptively expensive.  CPUs with VMCS caching (Westmere and later) also
optimize away consistency checks on VM-Entry, i.e. skip consistency
checks if the relevant fields have not changed since the last successful
VM-Entry (of the cached VMCS).  Because uops are a precious commodity,
uCode's dirty VMCS field tracking isn't as precise as software would
prefer.  Notably, writing any of the major VMCS fields effectively marks
the entire VMCS dirty, i.e. causes the next VM-Entry to perform all
consistency checks, which consumes several hundred cycles.

As it pertains to KVM, toggling PIN_BASED_VMX_PREEMPTION_TIMER more than
doubles the latency of the next VM-Entry (and again when/if the flag is
toggled back).  In a non-nested scenario, running a "standard" guest
with the preemption timer enabled, toggling the timer flag is uncommon
but not rare, e.g. roughly 1 in 10 entries.  Disabling the preemption
timer can change these numbers due to its use for "immediate exits",
even when explicitly disabled by userspace.

Nested virtualization in particular is painful, as the timer flag is set
for the majority of VM-Enters, but prepare_vmcs02() initializes vmcs02's
pin controls to *clear* the flag since its the timer's final state isn't
known until vmx_vcpu_run().  I.e. the majority of nested VM-Enters end
up unnecessarily writing pin controls *twice*.

Rather than toggle the timer flag in pin controls, set the timer value
itself to the largest allowed value to put it into a "soft disabled"
state, and ignore any spurious preemption timer exits.

Sadly, the timer is a 32-bit value and so theoretically it can fire
before the head death of the universe, i.e. spurious exits are possible.
But because KVM does *not* save the timer value on VM-Exit and because
the timer runs at a slower rate than the TSC, the maximuma timer value
is still sufficiently large for KVM's purposes.  E.g. on a modern CPU
with a timer that runs at 1/32 the frequency of a 2.4ghz constant-rate
TSC, the timer will fire after ~55 seconds of *uninterrupted* guest
execution.  In other words, spurious VM-Exits are effectively only
possible if the *host* is tickless on the logical CPU, the guest is
not using the preemption timer, and the guest is not generating VM-Exits
for *any* other reason.

To be safe from bad/weird hardware, disable the preemption timer if its
maximum delay is less than ten seconds.  Ten seconds is mostly arbitrary
and was selected in no small part because it's a nice round number.
For simplicity and paranoia, fall back to __kvm_request_immediate_exit()
if the preemption timer is disabled by KVM or userspace.  Previously
KVM continued to use the preemption timer to force immediate exits even
when the timer was disabled by userspace.  Now that KVM leaves the timer
running instead of truly disabling it, allow userspace to kill it
entirely in the unlikely event the timer (or KVM) malfunctions.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  5 ++--
 arch/x86/kvm/vmx/vmcs.h   |  1 +
 arch/x86/kvm/vmx/vmx.c    | 60 +++++++++++++++++++++++++--------------
 3 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 652022a77b64..0b86f0990943 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1985,9 +1985,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * PIN CONTROLS
 	 */
 	exec_control = vmx_pin_based_exec_ctrl(vmx);
-	exec_control |= vmcs12->pin_based_vm_exec_control;
-	/* Preemption timer setting is computed directly in vmx_vcpu_run.  */
-	exec_control &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
+	exec_control |= (vmcs12->pin_based_vm_exec_control &
+			 ~PIN_BASED_VMX_PREEMPTION_TIMER);
 
 	/* Posted interrupts setting is only taken from vmcs12.  */
 	if (nested_cpu_has_posted_intr(vmcs12)) {
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 52657d747668..c0abf06f245f 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -61,6 +61,7 @@ struct loaded_vmcs {
 	int cpu;
 	bool launched;
 	bool nmi_known_unmasked;
+	bool hv_timer_soft_disabled;
 	/* Support for vnmi-less CPUs */
 	int soft_vnmi_blocked;
 	ktime_t entry_time;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 70e9109b6481..795a2000dd3f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2435,6 +2435,7 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 		return -ENOMEM;
 
 	loaded_vmcs->shadow_vmcs = NULL;
+	loaded_vmcs->hv_timer_soft_disabled = false;
 	loaded_vmcs_init(loaded_vmcs);
 
 	if (cpu_has_vmx_msr_bitmap()) {
@@ -3808,8 +3809,9 @@ u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 	if (!enable_vnmi)
 		pin_based_exec_ctrl &= ~PIN_BASED_VIRTUAL_NMIS;
 
-	/* Enable the preemption timer dynamically */
-	pin_based_exec_ctrl &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
+	if (!enable_preemption_timer)
+		pin_based_exec_ctrl &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
+
 	return pin_based_exec_ctrl;
 }
 
@@ -5430,8 +5432,12 @@ static int handle_pml_full(struct kvm_vcpu *vcpu)
 
 static int handle_preemption_timer(struct kvm_vcpu *vcpu)
 {
-	if (!to_vmx(vcpu)->req_immediate_exit)
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (!vmx->req_immediate_exit &&
+	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled))
 		kvm_lapic_expired_hv_timer(vcpu);
+
 	return 1;
 }
 
@@ -6317,12 +6323,6 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					msrs[i].host, false);
 }
 
-static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
-{
-	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
-	pin_controls_setbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
-}
-
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6330,11 +6330,9 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 	u32 delta_tsc;
 
 	if (vmx->req_immediate_exit) {
-		vmx_arm_hv_timer(vmx, 0);
-		return;
-	}
-
-	if (vmx->hv_deadline_tsc != -1) {
+		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, 0);
+		vmx->loaded_vmcs->hv_timer_soft_disabled = false;
+	} else if (vmx->hv_deadline_tsc != -1) {
 		tscl = rdtsc();
 		if (vmx->hv_deadline_tsc > tscl)
 			/* set_hv_timer ensures the delta fits in 32-bits */
@@ -6343,11 +6341,12 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 		else
 			delta_tsc = 0;
 
-		vmx_arm_hv_timer(vmx, delta_tsc);
-		return;
+		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, delta_tsc);
+		vmx->loaded_vmcs->hv_timer_soft_disabled = false;
+	} else if (!vmx->loaded_vmcs->hv_timer_soft_disabled) {
+		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, -1);
+		vmx->loaded_vmcs->hv_timer_soft_disabled = true;
 	}
-
-	pin_controls_clearbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
 }
 
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
@@ -6419,7 +6418,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	atomic_switch_perf_msrs(vmx);
 
-	vmx_update_hv_timer(vcpu);
+	if (enable_preemption_timer)
+		vmx_update_hv_timer(vcpu);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
@@ -7533,17 +7533,33 @@ static __init int hardware_setup(void)
 	}
 
 	if (!cpu_has_vmx_preemption_timer())
-		kvm_x86_ops->request_immediate_exit = __kvm_request_immediate_exit;
+		enable_preemption_timer = false;
 
-	if (cpu_has_vmx_preemption_timer() && enable_preemption_timer) {
+	if (enable_preemption_timer) {
+		u64 use_timer_freq = 5000ULL * 1000 * 1000;
 		u64 vmx_msr;
 
 		rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
 		cpu_preemption_timer_multi =
 			vmx_msr & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
-	} else {
+
+		if (tsc_khz)
+			use_timer_freq = (u64)tsc_khz * 1000;
+		use_timer_freq >>= cpu_preemption_timer_multi;
+
+		/*
+		 * KVM "disables" the preemption timer by setting it to its max
+		 * value.  Don't use the timer if it might cause spurious exits
+		 * at a rate faster than 0.1 Hz (of uninterrupted guest time).
+		 */
+		if ((0xffffffffu / use_timer_freq) < 10)
+			enable_preemption_timer = false;
+	}
+
+	if (!enable_preemption_timer) {
 		kvm_x86_ops->set_hv_timer = NULL;
 		kvm_x86_ops->cancel_hv_timer = NULL;
+		kvm_x86_ops->request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
 	kvm_set_posted_intr_wakeup_handler(wakeup_handler);
-- 
2.21.0


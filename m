Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342AE176F66
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 07:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgCCG1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 01:27:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:40059 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgCCG1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 01:27:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 22:27:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,510,1574150400"; 
   d="scan'208";a="274076019"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 02 Mar 2020 22:27:36 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: [PATCH] KVM: nVMX: Properly handle userspace interrupt window request
Date:   Mon,  2 Mar 2020 22:27:35 -0800
Message-Id: <20200303062735.31868-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return true for vmx_interrupt_allowed() if the vCPU is in L2 and L1 has
external interrupt exiting enabled.  IRQs are never blocked in hardware
if the CPU is in the guest (L2 from L1's perspective) when IRQs trigger
VM-Exit.

The new check percolates up to kvm_vcpu_ready_for_interrupt_injection()
and thus vcpu_run(), and so KVM will exit to userspace if userspace has
requested an interrupt window (to inject an IRQ into L1).

Remove the @external_intr param from vmx_check_nested_events(), which is
actually an indicator that userspace wants an interrupt window, e.g.
it's named @req_int_win further up the stack.  Injecting a VM-Exit into
L1 to try and bounce out to L0 userspace is all kinds of broken and is
no longer necessary.

Remove the hack in nested_vmx_vmexit() that attempted to workaround the
breakage in vmx_check_nested_events() by only filling interrupt info if
there's an actual interrupt pending.  The hack actually made things
worse because it caused KVM to _never_ fill interrupt info when the
LAPIC resides in userspace (kvm_cpu_has_interrupt() queries
interrupt.injected, which is always cleared by prepare_vmcs12() before
reaching the hack in nested_vmx_vmexit()).

Fixes: 6550c4df7e50 ("KVM: nVMX: Fix interrupt window request with "Acknowledge interrupt on exit"")
Cc: stable@vger.kernel.org
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Odds are good that this doesn't solve all the problems with running nested
VMX and a userspace LAPIC, but I'm at least able to boot a kernel and run
unit tests, i.e. it's less broken than before.  Not that it matters, I'm
guessing no one actually uses this configuration, e.g. running a SMP
guest with the current KVM+kernel hangs during boot because Qemu
advertises PV IPIs to the guest, which require an in-kernel LAPIC.  I
stumbled on this disaster when disabling the in-kernel LAPIC for a
completely unrelated test.  I'm happy even if it does nothing more than
get rid of the awful logic vmx_check_nested_events().

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/nested.c       | 18 ++++--------------
 arch/x86/kvm/vmx/vmx.c          |  9 +++++++--
 arch/x86/kvm/x86.c              | 10 +++++-----
 4 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5edf6425c747..b3e936eeb07b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1175,7 +1175,7 @@ struct kvm_x86_ops {
 	bool (*pt_supported)(void);
 	bool (*pku_supported)(void);
 
-	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
+	int (*check_nested_events)(struct kvm_vcpu *vcpu);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
 
 	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0946122a8d3b..745cdc382ea2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3603,7 +3603,7 @@ static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
 			    vcpu->arch.exception.payload);
 }
 
-static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
+static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qual;
@@ -3679,8 +3679,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 		return 0;
 	}
 
-	if ((kvm_cpu_has_interrupt(vcpu) || external_intr) &&
-	    nested_exit_on_intr(vcpu)) {
+	if (kvm_cpu_has_interrupt(vcpu) && nested_exit_on_intr(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
 		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
@@ -4328,17 +4327,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	if (likely(!vmx->fail)) {
-		/*
-		 * TODO: SDM says that with acknowledge interrupt on
-		 * exit, bit 31 of the VM-exit interrupt information
-		 * (valid interrupt) is always set to 1 on
-		 * EXIT_REASON_EXTERNAL_INTERRUPT, so we shouldn't
-		 * need kvm_cpu_has_interrupt().  See the commit
-		 * message for details.
-		 */
-		if (nested_exit_intr_ack_set(vcpu) &&
-		    exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
-		    kvm_cpu_has_interrupt(vcpu)) {
+		if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
+		    nested_exit_intr_ack_set(vcpu)) {
 			int irq = kvm_cpu_get_interrupt(vcpu);
 			WARN_ON(irq < 0);
 			vmcs12->vm_exit_intr_info = irq |
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a04017bdae05..585e89f31340 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4493,8 +4493,13 @@ static int vmx_nmi_allowed(struct kvm_vcpu *vcpu)
 
 static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
-	return (!to_vmx(vcpu)->nested.nested_run_pending &&
-		vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
+	if (to_vmx(vcpu)->nested.nested_run_pending)
+		return false;
+
+	if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
+		return true;
+
+	return (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
 		!(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
 			(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ddd1d296bd20..928c1ba08321 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7578,7 +7578,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
-static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
+static int inject_pending_event(struct kvm_vcpu *vcpu)
 {
 	int r;
 
@@ -7614,7 +7614,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 	 * from L2 to L1.
 	 */
 	if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
-		r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
+		r = kvm_x86_ops->check_nested_events(vcpu);
 		if (r != 0)
 			return r;
 	}
@@ -7676,7 +7676,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 		 * KVM_REQ_EVENT only on certain events and not unconditionally?
 		 */
 		if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
-			r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
+			r = kvm_x86_ops->check_nested_events(vcpu);
 			if (r != 0)
 				return r;
 		}
@@ -8209,7 +8209,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		if (inject_pending_event(vcpu, req_int_win) != 0)
+		if (inject_pending_event(vcpu) != 0)
 			req_immediate_exit = true;
 		else {
 			/* Enable SMI/NMI/IRQ window open exits if needed.
@@ -8437,7 +8437,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events)
-		kvm_x86_ops->check_nested_events(vcpu, false);
+		kvm_x86_ops->check_nested_events(vcpu);
 
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
-- 
2.24.1


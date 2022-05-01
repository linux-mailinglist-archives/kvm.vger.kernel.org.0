Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86406516882
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 00:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377166AbiEAWLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 18:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377243AbiEAWLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 18:11:44 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1105226118;
        Sun,  1 May 2022 15:08:16 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlHjc-0008Nc-M5; Mon, 02 May 2022 00:08:08 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 05/12] KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction
Date:   Mon,  2 May 2022 00:07:29 +0200
Message-Id: <65cb88deab40bc1649d509194864312a89bbe02e.1651440202.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651440202.git.maciej.szmigiero@oracle.com>
References: <cover.1651440202.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Re-inject INT3/INTO instead of retrying the instruction if the CPU
encountered an intercepted exception while vectoring the software
exception, e.g. if vectoring INT3 encounters a #PF and KVM is using
shadow paging.  Retrying the instruction is architecturally wrong, e.g.
will result in a spurious #DB if there's a code breakpoint on the INT3/O,
and lack of re-injection also breaks nested virtualization, e.g. if L1
injects a software exception and vectoring the injected exception
encounters an exception that is intercepted by L0 but not L1.

Due to, ahem, deficiencies in the SVM architecture, acquiring the next
RIP may require flowing through the emulator even if NRIPS is supported,
as the CPU clears next_rip if the VM-Exit is due to an exception other
than "exceptions caused by the INT3, INTO, and BOUND instructions".  To
deal with this, "skip" the instruction to calculate next_rip (if it's
not already known), and then unwind the RIP write and any side effects
(RFLAGS updates).

Save the computed next_rip and use it to re-stuff next_rip if injection
doesn't complete.  This allows KVM to do the right thing if next_rip was
known prior to injection, e.g. if L1 injects a soft event into L2, and
there is no backing INTn instruction, e.g. if L1 is injecting an
arbitrary event.

Note, it's impossible to guarantee architectural correctness given SVM's
architectural flaws.  E.g. if the guest executes INTn (no KVM injection),
an exit occurs while vectoring the INTn, and the guest modifies the code
stream while the exit is being handled, KVM will compute the incorrect
next_rip due to "skipping" the wrong instruction.  A future enhancement
to make this less awful would be for KVM to detect that the decoded
instruction is not the correct INTn and drop the to-be-injected soft
event (retrying is a lesser evil compared to shoving the wrong RIP on the
exception stack).

Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/nested.c |  26 +++++++
 arch/x86/kvm/svm/svm.c    | 140 +++++++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h    |   6 +-
 3 files changed, 129 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 91a1f9ff2b86..0163238aa198 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -609,6 +609,21 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	}
 }
 
+static inline bool is_evtinj_soft(u32 evtinj)
+{
+	u32 type = evtinj & SVM_EVTINJ_TYPE_MASK;
+	u8 vector = evtinj & SVM_EVTINJ_VEC_MASK;
+
+	if (!(evtinj & SVM_EVTINJ_VALID))
+		return false;
+
+	/*
+	 * Intentionally return false for SOFT events, SVM doesn't yet support
+	 * re-injecting soft interrupts.
+	 */
+	return type == SVM_EVTINJ_TYPE_EXEPT && kvm_exception_is_soft(vector);
+}
+
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 					  unsigned long vmcb12_rip)
 {
@@ -677,6 +692,16 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
 		vmcb02->control.next_rip    = vmcb12_rip;
 
+	if (is_evtinj_soft(vmcb02->control.event_inj)) {
+		svm->soft_int_injected = true;
+		svm->soft_int_csbase = svm->vmcb->save.cs.base;
+		svm->soft_int_old_rip = vmcb12_rip;
+		if (svm->nrips_enabled)
+			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
+		else
+			svm->soft_int_next_rip = vmcb12_rip;
+	}
+
 	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
 					      LBR_CTL_ENABLE_MASK;
 	if (svm->lbrv_enabled)
@@ -849,6 +874,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 out_exit_err:
 	svm->nested.nested_run_pending = 0;
+	svm->soft_int_injected = false;
 
 	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
 	svm->vmcb->control.exit_code_hi = 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a05a4e521400..94d111ddec1c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -342,9 +342,11 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 
 }
 
-static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
+static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
+					   bool commit_side_effects)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long old_rflags;
 
 	/*
 	 * SEV-ES does not expose the next RIP. The RIP update is controlled by
@@ -359,18 +361,75 @@ static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	}
 
 	if (!svm->next_rip) {
+		if (unlikely(!commit_side_effects))
+			old_rflags = svm->vmcb->save.rflags;
+
 		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
 			return 0;
+
+		if (unlikely(!commit_side_effects))
+			svm->vmcb->save.rflags = old_rflags;
 	} else {
 		kvm_rip_write(vcpu, svm->next_rip);
 	}
 
 done:
-	svm_set_interrupt_shadow(vcpu, 0);
+	if (likely(commit_side_effects))
+		svm_set_interrupt_shadow(vcpu, 0);
 
 	return 1;
 }
 
+static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
+{
+	return __svm_skip_emulated_instruction(vcpu, true);
+}
+
+static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
+{
+	unsigned long rip, old_rip = kvm_rip_read(vcpu);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/*
+	 * Due to architectural shortcomings, the CPU doesn't always provide
+	 * NextRIP, e.g. if KVM intercepted an exception that occurred while
+	 * the CPU was vectoring an INTO/INT3 in the guest.  Temporarily skip
+	 * the instruction even if NextRIP is supported to acquire the next
+	 * RIP so that it can be shoved into the NextRIP field, otherwise
+	 * hardware will fail to advance guest RIP during event injection.
+	 * Drop the exception/interrupt if emulation fails and effectively
+	 * retry the instruction, it's the least awful option.  If NRIPS is
+	 * in use, the skip must not commit any side effects such as clearing
+	 * the interrupt shadow or RFLAGS.RF.
+	 */
+	if (!__svm_skip_emulated_instruction(vcpu, !nrips))
+		return -EIO;
+
+	rip = kvm_rip_read(vcpu);
+
+	/*
+	 * Save the injection information, even when using next_rip, as the
+	 * VMCB's next_rip will be lost (cleared on VM-Exit) if the injection
+	 * doesn't complete due to a VM-Exit occurring while the CPU is
+	 * vectoring the event.   Decoding the instruction isn't guaranteed to
+	 * work as there may be no backing instruction, e.g. if the event is
+	 * being injected by L1 for L2, or if the guest is patching INT3 into
+	 * a different instruction.
+	 */
+	svm->soft_int_injected = true;
+	svm->soft_int_csbase = svm->vmcb->save.cs.base;
+	svm->soft_int_old_rip = old_rip;
+	svm->soft_int_next_rip = rip;
+
+	if (nrips)
+		kvm_rip_write(vcpu, old_rip);
+
+	if (static_cpu_has(X86_FEATURE_NRIPS))
+		svm->vmcb->control.next_rip = rip;
+
+	return 0;
+}
+
 static void svm_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -380,25 +439,9 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 
 	kvm_deliver_exception_payload(vcpu);
 
-	if (nr == BP_VECTOR && !nrips) {
-		unsigned long rip, old_rip = kvm_rip_read(vcpu);
-
-		/*
-		 * For guest debugging where we have to reinject #BP if some
-		 * INT3 is guest-owned:
-		 * Emulate nRIP by moving RIP forward. Will fail if injection
-		 * raises a fault that is not intercepted. Still better than
-		 * failing in all cases.
-		 */
-		(void)svm_skip_emulated_instruction(vcpu);
-		rip = kvm_rip_read(vcpu);
-
-		if (boot_cpu_has(X86_FEATURE_NRIPS))
-			svm->vmcb->control.next_rip = rip;
-
-		svm->int3_rip = rip + svm->vmcb->save.cs.base;
-		svm->int3_injected = rip - old_rip;
-	}
+	if (kvm_exception_is_soft(nr) &&
+	    svm_update_soft_interrupt_rip(vcpu))
+		return;
 
 	svm->vmcb->control.event_inj = nr
 		| SVM_EVTINJ_VALID
@@ -3669,15 +3712,46 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 	svm->vmcb->control.int_ctl |= cr8 & V_TPR_MASK;
 }
 
+static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
+					int type)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/*
+	 * If NRIPS is enabled, KVM must snapshot the pre-VMRUN next_rip that's
+	 * associated with the original soft exception/interrupt.  next_rip is
+	 * cleared on all exits that can occur while vectoring an event, so KVM
+	 * needs to manually set next_rip for re-injection.  Unlike the !nrips
+	 * case below, this needs to be done if and only if KVM is re-injecting
+	 * the same event, i.e. if the event is a soft exception/interrupt,
+	 * otherwise next_rip is unused on VMRUN.
+	 */
+	if (nrips && type == SVM_EXITINTINFO_TYPE_EXEPT &&
+	    kvm_exception_is_soft(vector) &&
+	    kvm_is_linear_rip(vcpu, svm->soft_int_old_rip + svm->soft_int_csbase))
+		svm->vmcb->control.next_rip = svm->soft_int_next_rip;
+	/*
+	 * If NRIPS isn't enabled, KVM must manually advance RIP prior to
+	 * injecting the soft exception/interrupt.  That advancement needs to
+	 * be unwound if vectoring didn't complete.  Note, the new event may
+	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
+	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
+	 * be the reported vectored event, but RIP still needs to be unwound.
+	 */
+	else if (!nrips && type == SVM_EXITINTINFO_TYPE_EXEPT &&
+		 kvm_is_linear_rip(vcpu, svm->soft_int_next_rip + svm->soft_int_csbase))
+		kvm_rip_write(vcpu, svm->soft_int_old_rip);
+}
+
 static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u8 vector;
 	int type;
 	u32 exitintinfo = svm->vmcb->control.exit_int_info;
-	unsigned int3_injected = svm->int3_injected;
+	bool soft_int_injected = svm->soft_int_injected;
 
-	svm->int3_injected = 0;
+	svm->soft_int_injected = false;
 
 	/*
 	 * If we've made progress since setting HF_IRET_MASK, we've
@@ -3702,17 +3776,8 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
 	type = exitintinfo & SVM_EXITINTINFO_TYPE_MASK;
 
-	/*
-	 * If NextRIP isn't enabled, KVM must manually advance RIP prior to
-	 * injecting the soft exception/interrupt.  That advancement needs to
-	 * be unwound if vectoring didn't complete.  Note, the new event may
-	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
-	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
-	 * be the reported vectored event, but RIP still needs to be unwound.
-	 */
-	if (int3_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
-	   kvm_is_linear_rip(vcpu, svm->int3_rip))
-		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - int3_injected);
+	if (soft_int_injected)
+		svm_complete_soft_interrupt(vcpu, vector, type);
 
 	switch (type) {
 	case SVM_EXITINTINFO_TYPE_NMI:
@@ -3725,13 +3790,6 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 		if (vector == X86_TRAP_VC)
 			break;
 
-		/*
-		 * In case of software exceptions, do not reinject the vector,
-		 * but re-execute the instruction instead.
-		 */
-		if (kvm_exception_is_soft(vector))
-			break;
-
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
 			u32 err = svm->vmcb->control.exit_int_info_err;
 			kvm_requeue_exception_e(vcpu, vector, err);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7d97e4d18c8b..6acb494e3598 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -230,8 +230,10 @@ struct vcpu_svm {
 	bool nmi_singlestep;
 	u64 nmi_singlestep_guest_rflags;
 
-	unsigned int3_injected;
-	unsigned long int3_rip;
+	unsigned long soft_int_csbase;
+	unsigned long soft_int_old_rip;
+	unsigned long soft_int_next_rip;
+	bool soft_int_injected;
 
 	/* optional nested SVM features that are enabled for this guest  */
 	bool nrips_enabled                : 1;

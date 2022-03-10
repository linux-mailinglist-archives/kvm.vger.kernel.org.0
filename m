Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72484D53B1
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 22:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344013AbiCJVk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 16:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344008AbiCJVk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 16:40:26 -0500
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28524CD33F;
        Thu, 10 Mar 2022 13:39:24 -0800 (PST)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nSQUx-0006JF-7w; Thu, 10 Mar 2022 22:39:03 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] KVM: nSVM: Don't forget about L1-injected events
Date:   Thu, 10 Mar 2022 22:38:39 +0100
Message-Id: <a28577564a7583c32f0029f2307f63ca8869cf22.1646944472.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1646944472.git.maciej.szmigiero@oracle.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
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

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

In SVM synthetic software interrupts or INT3 or INTO exception that L1
wants to inject into its L2 guest are forgotten if there is an intervening
L0 VMEXIT during their delivery.

They are re-injected correctly with VMX, however.

This is because there is an assumption in SVM that such exceptions will be
re-delivered by simply re-executing the current instruction.
Which might not be true if this is a synthetic exception injected by L1,
since in this case the re-executed instruction will be one already in L2,
not the VMRUN instruction in L1 that attempted the injection.

Leave the pending L1 -> L2 event in svm->nested.ctl.event_inj{,err} until
it is either re-injected successfully or returned to L1 upon a nested
VMEXIT.
Make sure to always re-queue such event if returned in EXITINTINFO.

The handling of L0 -> {L1, L2} event re-injection is left as-is to avoid
unforeseen regressions.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 65 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c    | 17 ++++++++--
 arch/x86/kvm/svm/svm.h    | 47 ++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9656f0d6815c..75017bf77955 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -420,8 +420,17 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 {
 	u32 mask;
-	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
-	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
+
+	/*
+	 * Leave the pending L1 -> L2 event in svm->nested.ctl.event_inj{,err}
+	 * if its re-injection is needed
+	 */
+	if (!exit_during_event_injection(svm, svm->nested.ctl.event_inj,
+					 svm->nested.ctl.event_inj_err)) {
+		WARN_ON_ONCE(svm->vmcb->control.event_inj & SVM_EVTINJ_VALID);
+		svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
+		svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
+	}
 
 	/* Only a few fields of int_ctl are written by the processor.  */
 	mask = V_IRQ_MASK | V_TPR_MASK;
@@ -669,6 +678,54 @@ static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to
 	to_vmcb->save.spec_ctrl = from_vmcb->save.spec_ctrl;
 }
 
+void nested_svm_maybe_reinject(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned int vector, type;
+	u32 exitintinfo = svm->vmcb->control.exit_int_info;
+
+	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
+		return;
+
+	/*
+	 * No L1 -> L2 event to re-inject?
+	 *
+	 * In this case event_inj will be cleared by
+	 * nested_sync_control_from_vmcb02().
+	 */
+	if (!(svm->nested.ctl.event_inj & SVM_EVTINJ_VALID))
+		return;
+
+	/* If the last event injection was successful there shouldn't be any pending event */
+	if (WARN_ON_ONCE(!(exitintinfo & SVM_EXITINTINFO_VALID)))
+		return;
+
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
+	type = exitintinfo & SVM_EXITINTINFO_TYPE_MASK;
+
+	switch (type) {
+	case SVM_EXITINTINFO_TYPE_NMI:
+		vcpu->arch.nmi_injected = true;
+		break;
+	case SVM_EXITINTINFO_TYPE_EXEPT:
+		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR)
+			kvm_requeue_exception_e(vcpu, vector,
+						svm->vmcb->control.exit_int_info_err);
+		else
+			kvm_requeue_exception(vcpu, vector);
+		break;
+	case SVM_EXITINTINFO_TYPE_SOFT:
+	case SVM_EXITINTINFO_TYPE_INTR:
+		kvm_queue_interrupt(vcpu, vector, type == SVM_EXITINTINFO_TYPE_SOFT);
+		break;
+	default:
+		vcpu_unimpl(vcpu, "unknown L1 -> L2 exitintinfo type 0x%x\n", type);
+		break;
+	}
+}
+
 int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 			 struct vmcb *vmcb12, bool from_vmrun)
 {
@@ -898,6 +955,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (svm->nrips_enabled)
 		vmcb12->control.next_rip  = vmcb->control.next_rip;
 
+	/* Forget about any pending L1 event injection since it's a L1 worry now */
+	svm->nested.ctl.event_inj = 0;
+	svm->nested.ctl.event_inj_err = 0;
+
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
 	vmcb12->control.tlb_ctl           = svm->nested.ctl.tlb_ctl;
 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1e5d904aeec3..5b128baa5e57 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3322,13 +3322,18 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	WARN_ON(!gif_set(svm));
+	WARN_ON(!(vcpu->arch.interrupt.soft || gif_set(svm)));
 
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
 	++vcpu->stat.irq_injections;
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
-		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
+		SVM_EVTINJ_VALID;
+	if (vcpu->arch.interrupt.soft) {
+		svm->vmcb->control.event_inj |= SVM_EVTINJ_TYPE_SOFT;
+	} else {
+		svm->vmcb->control.event_inj |= SVM_EVTINJ_TYPE_INTR;
+	}
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
@@ -3627,6 +3632,14 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	if (!(exitintinfo & SVM_EXITINTINFO_VALID))
 		return;
 
+	/* L1 -> L2 event re-injection needs a different handling */
+	if (is_guest_mode(vcpu) &&
+	    exit_during_event_injection(svm, svm->nested.ctl.event_inj,
+					svm->nested.ctl.event_inj_err)) {
+		nested_svm_maybe_reinject(vcpu);
+		return;
+	}
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f757400fc933..7cafc2e6c82a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -488,6 +488,52 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
 }
 
+static inline bool event_inj_same(u32 event_inj1, u32 event_inj_err1,
+				  u32 event_inj2, u32 event_inj_err2)
+{
+	unsigned int vector_1, vector_2, type_1, type_2;
+
+	/* Either of them not valid? */
+	if (!(event_inj1 & SVM_EVTINJ_VALID) ||
+	    !(event_inj2 & SVM_EVTINJ_VALID))
+		return false;
+
+	vector_1 = event_inj1 & SVM_EVTINJ_VEC_MASK;
+	type_1 = event_inj1 & SVM_EVTINJ_TYPE_MASK;
+	vector_2 = event_inj2 & SVM_EVTINJ_VEC_MASK;
+	type_2 = event_inj2 & SVM_EVTINJ_TYPE_MASK;
+
+	/* Different vector or type? */
+	if (vector_1 != vector_2 || type_1 != type_2)
+		return false;
+
+	/* Different error code presence flag? */
+	if ((event_inj1 & SVM_EVTINJ_VALID_ERR) !=
+	    (event_inj2 & SVM_EVTINJ_VALID_ERR))
+		return false;
+
+	/* No error code? */
+	if (!(event_inj1 & SVM_EVTINJ_VALID_ERR))
+		return true;
+
+	/* Same error code? */
+	return event_inj_err1 == event_inj_err2;
+}
+
+/* Did the last VMEXIT happen when attempting to inject that event? */
+static inline bool exit_during_event_injection(struct vcpu_svm *svm,
+					       u32 event_inj, u32 event_inj_err)
+{
+	BUILD_BUG_ON(SVM_EXITINTINFO_VEC_MASK != SVM_EVTINJ_VEC_MASK ||
+		     SVM_EXITINTINFO_TYPE_MASK != SVM_EVTINJ_TYPE_MASK ||
+		     SVM_EXITINTINFO_VALID != SVM_EVTINJ_VALID ||
+		     SVM_EXITINTINFO_VALID_ERR != SVM_EVTINJ_VALID_ERR);
+
+	return event_inj_same(svm->vmcb->control.exit_int_info,
+			      svm->vmcb->control.exit_int_info_err,
+			      event_inj, event_inj_err);
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
@@ -540,6 +586,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
 }
 
+void nested_svm_maybe_reinject(struct kvm_vcpu *vcpu);
 int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
 			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
 void svm_leave_nested(struct kvm_vcpu *vcpu);

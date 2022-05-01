Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7E0516885
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 00:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377915AbiEAWMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 18:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377148AbiEAWL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 18:11:56 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6415E75D;
        Sun,  1 May 2022 15:08:22 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlHjh-0008O1-W1; Mon, 02 May 2022 00:08:14 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/12] KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"
Date:   Mon,  2 May 2022 00:07:30 +0200
Message-Id: <1654ad502f860948e4f2d57b8bd881d67301f785.1651440202.git.maciej.szmigiero@oracle.com>
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

Re-inject INTn software interrupts instead of retrying the instruction if
the CPU encountered an intercepted exception while vectoring the INTn,
e.g. if KVM intercepted a #PF when utilizing shadow paging.  Retrying the
instruction is architecturally wrong e.g. will result in a spurious #DB
if there's a code breakpoint on the INT3/O, and lack of re-injection also
breaks nested virtualization, e.g. if L1 injects a software interrupt and
vectoring the injected interrupt encounters an exception that is
intercepted by L0 but not L1.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/nested.c |  7 +++----
 arch/x86/kvm/svm/svm.c    | 23 +++++++++++++++++++----
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0163238aa198..a83e367ade54 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -617,10 +617,9 @@ static inline bool is_evtinj_soft(u32 evtinj)
 	if (!(evtinj & SVM_EVTINJ_VALID))
 		return false;
 
-	/*
-	 * Intentionally return false for SOFT events, SVM doesn't yet support
-	 * re-injecting soft interrupts.
-	 */
+	if (type == SVM_EVTINJ_TYPE_SOFT)
+		return true;
+
 	return type == SVM_EVTINJ_TYPE_EXEPT && kvm_exception_is_soft(vector);
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 94d111ddec1c..a1158fc25c4c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3430,12 +3430,22 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 type;
+
+	if (vcpu->arch.interrupt.soft) {
+		if (svm_update_soft_interrupt_rip(vcpu))
+			return;
+
+		type = SVM_EVTINJ_TYPE_SOFT;
+	} else {
+		type = SVM_EVTINJ_TYPE_INTR;
+	}
 
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
 	++vcpu->stat.irq_injections;
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
-		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
+				       SVM_EVTINJ_VALID | type;
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
@@ -3715,6 +3725,8 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
 					int type)
 {
+	bool is_exception = (type == SVM_EXITINTINFO_TYPE_EXEPT);
+	bool is_soft = (type == SVM_EXITINTINFO_TYPE_SOFT);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
@@ -3726,8 +3738,7 @@ static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
 	 * the same event, i.e. if the event is a soft exception/interrupt,
 	 * otherwise next_rip is unused on VMRUN.
 	 */
-	if (nrips && type == SVM_EXITINTINFO_TYPE_EXEPT &&
-	    kvm_exception_is_soft(vector) &&
+	if (nrips && (is_soft || (is_exception && kvm_exception_is_soft(vector))) &&
 	    kvm_is_linear_rip(vcpu, svm->soft_int_old_rip + svm->soft_int_csbase))
 		svm->vmcb->control.next_rip = svm->soft_int_next_rip;
 	/*
@@ -3738,7 +3749,7 @@ static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
 	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
 	 * be the reported vectored event, but RIP still needs to be unwound.
 	 */
-	else if (!nrips && type == SVM_EXITINTINFO_TYPE_EXEPT &&
+	else if (!nrips && (is_soft || is_exception) &&
 		 kvm_is_linear_rip(vcpu, svm->soft_int_next_rip + svm->soft_int_csbase))
 		kvm_rip_write(vcpu, svm->soft_int_old_rip);
 }
@@ -3800,9 +3811,13 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	case SVM_EXITINTINFO_TYPE_INTR:
 		kvm_queue_interrupt(vcpu, vector, false);
 		break;
+	case SVM_EXITINTINFO_TYPE_SOFT:
+		kvm_queue_interrupt(vcpu, vector, true);
+		break;
 	default:
 		break;
 	}
+
 }
 
 static void svm_cancel_injection(struct kvm_vcpu *vcpu)

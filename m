Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449C54D53AC
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 22:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343992AbiCJVkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 16:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344017AbiCJVkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 16:40:32 -0500
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF8CC084B;
        Thu, 10 Mar 2022 13:39:30 -0800 (PST)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nSQV2-0006Ja-IC; Thu, 10 Mar 2022 22:39:08 +0100
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
Subject: [PATCH 4/5] KVM: nSVM: Restore next_rip when doing L1 -> L2 event re-injection
Date:   Thu, 10 Mar 2022 22:38:40 +0100
Message-Id: <a5380706e5a1679bf8e5967252335e1f2167065f.1646944472.git.maciej.szmigiero@oracle.com>
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

According to APM 15.7.1 "State Saved on Exit" the next_rip field can be
zero after a VMEXIT in some cases.
Yet, it is used by the CPU for the return address pushed on stack when
injecting INT3 or INTO exception or a software interrupt.

Restore this field to the L1-provided value if zeroed by the CPU when
re-injecting a L1-provided event into L2.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/svm.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5b128baa5e57..760dd0e070ea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -385,6 +385,44 @@ static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+/*
+ * According to APM 15.7.1 "State Saved on Exit" the next_rip field can
+ * be zero after a VMEXIT in some cases.
+ * Yet, it is used by the CPU for the return address pushed on stack when
+ * injecting INT3 or INTO exception or a software interrupt.
+ *
+ * Restore this field to the L1-provided value if zeroed by the CPU when
+ * re-injecting a L1-provided event into L2.
+ */
+static void maybe_fixup_next_rip(struct kvm_vcpu *vcpu, bool uses_err)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 err_vmcb = uses_err ? svm->vmcb->control.event_inj_err : 0;
+	u32 err_inject = uses_err ? svm->nested.ctl.event_inj_err : 0;
+
+	/* No nRIP Save feature? Then nothing to fix up. */
+	if (!nrips)
+		return;
+
+	/* The fix only applies to event injection into a L2. */
+	if (!is_guest_mode(vcpu))
+		return;
+
+	/*
+	 * If the current next_rip field is already non-zero assume the CPU had
+	 * returned the correct address during the last VMEXIT.
+	 */
+	if (svm->vmcb->control.next_rip)
+		return;
+
+	/* Is this a L1 -> L2 event re-injection? */
+	if (!event_inj_same(svm->vmcb->control.event_inj, err_vmcb,
+			    svm->nested.ctl.event_inj, err_inject))
+		return;
+
+	svm->vmcb->control.next_rip = svm->nested.ctl.next_rip;
+}
+
 static void svm_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -415,6 +453,9 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 		| (has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
 		| SVM_EVTINJ_TYPE_EXEPT;
 	svm->vmcb->control.event_inj_err = error_code;
+
+	if (kvm_exception_is_soft(nr))
+		maybe_fixup_next_rip(vcpu, true);
 }
 
 static void svm_init_erratum_383(void)
@@ -3331,6 +3372,8 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu)
 		SVM_EVTINJ_VALID;
 	if (vcpu->arch.interrupt.soft) {
 		svm->vmcb->control.event_inj |= SVM_EVTINJ_TYPE_SOFT;
+
+		maybe_fixup_next_rip(vcpu, false);
 	} else {
 		svm->vmcb->control.event_inj |= SVM_EVTINJ_TYPE_INTR;
 	}

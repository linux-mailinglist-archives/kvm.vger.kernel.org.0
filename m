Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA00516883
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 00:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376452AbiEAWLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 18:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376843AbiEAWLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 18:11:36 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF4B1DA73;
        Sun,  1 May 2022 15:08:07 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlHjS-0008Mw-12; Mon, 02 May 2022 00:07:58 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/12] KVM: SVM: Unwind "speculative" RIP advancement if INTn injection "fails"
Date:   Mon,  2 May 2022 00:07:27 +0200
Message-Id: <450133cf0a026cb9825a2ff55d02cb136a1cb111.1651440202.git.maciej.szmigiero@oracle.com>
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

Unwind the RIP advancement done by svm_queue_exception() when injecting
an INT3 ultimately "fails" due to the CPU encountering a VM-Exit while
vectoring the injected event, even if the exception reported by the CPU
isn't the same event that was injected.  If vectoring INT3 encounters an
exception, e.g. #NP, and vectoring the #NP encounters an intercepted
exception, e.g. #PF when KVM is using shadow paging, then the #NP will
be reported as the event that was in-progress.

Note, this is still imperfect, as it will get a false positive if the
INT3 is cleanly injected, no VM-Exit occurs before the IRET from the INT3
handler in the guest, the instruction following the INT3 generates an
exception (directly or indirectly), _and_ vectoring that exception
encounters an exception that is intercepted by KVM.  The false positives
could theoretically be solved by further analyzing the vectoring event,
e.g. by comparing the error code against the expected error code were an
exception to occur when vectoring the original injected exception, but
SVM without NRIPS is a complete disaster, trying to make it 100% correct
is a waste of time.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: 66b7138f9136 ("KVM: SVM: Emulate nRIP feature when reinjecting INT3")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/svm.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1cec671fc668..1a719f47a964 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3698,6 +3698,18 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
 	type = exitintinfo & SVM_EXITINTINFO_TYPE_MASK;
 
+	/*
+	 * If NextRIP isn't enabled, KVM must manually advance RIP prior to
+	 * injecting the soft exception/interrupt.  That advancement needs to
+	 * be unwound if vectoring didn't complete.  Note, the _new_ event may
+	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
+	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
+	 * be the reported vectored event, but RIP still needs to be unwound.
+	 */
+	if (int3_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
+	   kvm_is_linear_rip(vcpu, svm->int3_rip))
+		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - int3_injected);
+
 	switch (type) {
 	case SVM_EXITINTINFO_TYPE_NMI:
 		vcpu->arch.nmi_injected = true;
@@ -3711,16 +3723,11 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 
 		/*
 		 * In case of software exceptions, do not reinject the vector,
-		 * but re-execute the instruction instead. Rewind RIP first
-		 * if we emulated INT3 before.
+		 * but re-execute the instruction instead.
 		 */
-		if (kvm_exception_is_soft(vector)) {
-			if (vector == BP_VECTOR && int3_injected &&
-			    kvm_is_linear_rip(vcpu, svm->int3_rip))
-				kvm_rip_write(vcpu,
-					      kvm_rip_read(vcpu) - int3_injected);
+		if (kvm_exception_is_soft(vector))
 			break;
-		}
+
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
 			u32 err = svm->vmcb->control.exit_int_info_err;
 			kvm_requeue_exception_e(vcpu, vector, err);

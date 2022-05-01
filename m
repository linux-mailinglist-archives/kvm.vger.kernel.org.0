Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E7A516891
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 00:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377826AbiEAWMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 18:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377791AbiEAWMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 18:12:23 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A1E5E76F;
        Sun,  1 May 2022 15:08:40 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlHk3-0008PB-8f; Mon, 02 May 2022 00:08:35 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/12] KVM: nSVM: Transparently handle L1 -> L2 NMI re-injection
Date:   Mon,  2 May 2022 00:07:34 +0200
Message-Id: <f894d13501cd48157b3069a4b4c7369575ddb60e.1651440202.git.maciej.szmigiero@oracle.com>
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

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

A NMI that L1 wants to inject into its L2 should be directly re-injected,
without causing L0 side effects like engaging NMI blocking for L1.

It's also worth noting that in this case it is L1 responsibility
to track the NMI window status for its L2 guest.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 12 ++++++++++++
 arch/x86/kvm/svm/svm.c    |  7 +++++++
 arch/x86/kvm/svm/svm.h    |  1 +
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a83e367ade54..2cf92c12706a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -623,6 +623,16 @@ static inline bool is_evtinj_soft(u32 evtinj)
 	return type == SVM_EVTINJ_TYPE_EXEPT && kvm_exception_is_soft(vector);
 }
 
+static bool is_evtinj_nmi(u32 evtinj)
+{
+	u32 type = evtinj & SVM_EVTINJ_TYPE_MASK;
+
+	if (!(evtinj & SVM_EVTINJ_VALID))
+		return false;
+
+	return type == SVM_EVTINJ_TYPE_NMI;
+}
+
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 					  unsigned long vmcb12_rip)
 {
@@ -691,6 +701,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
 		vmcb02->control.next_rip    = vmcb12_rip;
 
+	svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
 		svm->soft_int_injected = true;
 		svm->soft_int_csbase = svm->vmcb->save.cs.base;
@@ -873,6 +884,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 out_exit_err:
 	svm->nested.nested_run_pending = 0;
+	svm->nmi_l1_to_l2 = false;
 	svm->soft_int_injected = false;
 
 	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f946161520f6..88eacbbe9348 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3421,6 +3421,10 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
+
+	if (svm->nmi_l1_to_l2)
+		return;
+
 	vcpu->arch.hflags |= HF_NMI_MASK;
 	if (!sev_es_guest(vcpu->kvm))
 		svm_set_intercept(svm, INTERCEPT_IRET);
@@ -3761,8 +3765,10 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	u8 vector;
 	int type;
 	u32 exitintinfo = svm->vmcb->control.exit_int_info;
+	bool nmi_l1_to_l2 = svm->nmi_l1_to_l2;
 	bool soft_int_injected = svm->soft_int_injected;
 
+	svm->nmi_l1_to_l2 = false;
 	svm->soft_int_injected = false;
 
 	/*
@@ -3794,6 +3800,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	switch (type) {
 	case SVM_EXITINTINFO_TYPE_NMI:
 		vcpu->arch.nmi_injected = true;
+		svm->nmi_l1_to_l2 = nmi_l1_to_l2;
 		break;
 	case SVM_EXITINTINFO_TYPE_EXEPT:
 		/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6acb494e3598..e1117d92789d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -229,6 +229,7 @@ struct vcpu_svm {
 
 	bool nmi_singlestep;
 	u64 nmi_singlestep_guest_rflags;
+	bool nmi_l1_to_l2;
 
 	unsigned long soft_int_csbase;
 	unsigned long soft_int_old_rip;

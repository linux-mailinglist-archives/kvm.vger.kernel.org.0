Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840B563C8A4
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiK2Tld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbiK2Tkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:40:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C2B6320
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669750665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9dwVem96795eE3qcgmMV9GIrD+Dv4vNEuuuNJ0HxdFU=;
        b=Z6SIkez/PvzD+N4sm4Biv07E2R0+5KG7WHXKh42O735qupOQZ0joSwBwGzDmRCVwnoGCJ4
        JOoBenOXD50BUBCJLC0kWxiMUjnlO7T/8ZtaA03iN5Dqr0C9eX/cWj5yLANhLzLfyZ07pY
        8JTIStDc7pxoqLrNti2iPpOi+rnjfS8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-7GtzMlR6PnaHeX50cy6XPw-1; Tue, 29 Nov 2022 14:37:42 -0500
X-MC-Unique: 7GtzMlR6PnaHeX50cy6XPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 418321C06EDC;
        Tue, 29 Nov 2022 19:37:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 500D32024CB7;
        Tue, 29 Nov 2022 19:37:35 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 04/11] KVM: SVM: drop the SVM specific H_FLAGS
Date:   Tue, 29 Nov 2022 21:37:10 +0200
Message-Id: <20221129193717.513824-5-mlevitsk@redhat.com>
In-Reply-To: <20221129193717.513824-1-mlevitsk@redhat.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GIF and 'waiting for IRET' are used only for the SVM and thus should
not be in H_FLAGS.

NMI mask is not x86 specific but it is only used for SVM without vNMI.

The VMX have similar concept of NMI mask (soft_vnmi_blocked),
and it is used when its 'vNMI' feature is not enabled,
but because the VMX can't intercept IRET, it is more of a hack,
and thus should not use common host flags either.

No functional change is intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/svm/svm.c          | 22 +++++++++++++---------
 arch/x86/kvm/svm/svm.h          | 25 ++++++++++++++++++++++---
 3 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 70af7240a1d5af..9208ad7a6bd004 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2052,9 +2052,6 @@ enum {
 	TASK_SWITCH_GATE = 3,
 };
 
-#define HF_GIF_MASK		(1 << 0)
-#define HF_NMI_MASK		(1 << 3)
-#define HF_IRET_MASK		(1 << 4)
 #define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
 
 #ifdef CONFIG_KVM_SMM
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 91352d69284524..512b2aa21137e2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1326,6 +1326,9 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.microcode_version = 0x01000065;
 	svm->tsc_ratio_msr = kvm_caps.default_tsc_scaling_ratio;
 
+	svm->nmi_masked = false;
+	svm->awaiting_iret_completion = false;
+
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_vcpu_reset(svm);
 }
@@ -2470,7 +2473,7 @@ static int iret_interception(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	++vcpu->stat.nmi_window_exits;
-	vcpu->arch.hflags |= HF_IRET_MASK;
+	svm->awaiting_iret_completion = true;
 	if (!sev_es_guest(vcpu->kvm)) {
 		svm_clr_intercept(svm, INTERCEPT_IRET);
 		svm->nmi_iret_rip = kvm_rip_read(vcpu);
@@ -3466,7 +3469,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	if (svm->nmi_l1_to_l2)
 		return;
 
-	vcpu->arch.hflags |= HF_NMI_MASK;
+	svm->nmi_masked = true;
 	if (!sev_es_guest(vcpu->kvm))
 		svm_set_intercept(svm, INTERCEPT_IRET);
 	++vcpu->stat.nmi_injections;
@@ -3580,7 +3583,7 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 		return false;
 
 	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
-	      (vcpu->arch.hflags & HF_NMI_MASK);
+	      (svm->nmi_masked);
 
 	return ret;
 }
@@ -3602,7 +3605,7 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 
 static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
 {
-	return !!(vcpu->arch.hflags & HF_NMI_MASK);
+	return to_svm(vcpu)->nmi_masked;
 }
 
 static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
@@ -3610,11 +3613,11 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (masked) {
-		vcpu->arch.hflags |= HF_NMI_MASK;
+		svm->nmi_masked = true;
 		if (!sev_es_guest(vcpu->kvm))
 			svm_set_intercept(svm, INTERCEPT_IRET);
 	} else {
-		vcpu->arch.hflags &= ~HF_NMI_MASK;
+		svm->nmi_masked = false;
 		if (!sev_es_guest(vcpu->kvm))
 			svm_clr_intercept(svm, INTERCEPT_IRET);
 	}
@@ -3700,7 +3703,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
+	if (svm->nmi_masked && !svm->awaiting_iret_completion)
 		return; /* IRET will cause a vm exit */
 
 	if (!gif_set(svm)) {
@@ -3824,10 +3827,11 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	 * If we've made progress since setting HF_IRET_MASK, we've
 	 * executed an IRET and can allow NMI injection.
 	 */
-	if ((vcpu->arch.hflags & HF_IRET_MASK) &&
+	if (svm->awaiting_iret_completion &&
 	    (sev_es_guest(vcpu->kvm) ||
 	     kvm_rip_read(vcpu) != svm->nmi_iret_rip)) {
-		vcpu->arch.hflags &= ~(HF_NMI_MASK | HF_IRET_MASK);
+		svm->awaiting_iret_completion = false;
+		svm->nmi_masked = false;
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4826e6cc611bf1..587ddc150f9f34 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -237,8 +237,24 @@ struct vcpu_svm {
 
 	struct svm_nested_state nested;
 
+	/* NMI mask value, used when vNMI is not enabled */
+	bool nmi_masked;
+
+	/*
+	 * True when the NMI still masked but guest IRET was just intercepted
+	 * and KVM is waiting for RIP change which will signal that this IRET was
+	 * retired and thus NMI can be unmasked.
+	 */
+	bool awaiting_iret_completion;
+
+	/*
+	 * Set when KVM waits for IRET completion and needs to
+	 * inject NMIs as soon as it completes (e.g NMI is pending injection).
+	 * The KVM takes over EFLAGS.TF for this.
+	 */
 	bool nmi_singlestep;
 	u64 nmi_singlestep_guest_rflags;
+
 	bool nmi_l1_to_l2;
 
 	unsigned long soft_int_csbase;
@@ -280,6 +296,9 @@ struct vcpu_svm {
 	bool guest_state_loaded;
 
 	bool x2avic_msrs_intercepted;
+
+	/* Guest GIF value which is used when vGIF is not enabled */
+	bool gif_value;
 };
 
 struct svm_cpu_data {
@@ -497,7 +516,7 @@ static inline void enable_gif(struct vcpu_svm *svm)
 	if (vmcb)
 		vmcb->control.int_ctl |= V_GIF_MASK;
 	else
-		svm->vcpu.arch.hflags |= HF_GIF_MASK;
+		svm->gif_value = true;
 }
 
 static inline void disable_gif(struct vcpu_svm *svm)
@@ -507,7 +526,7 @@ static inline void disable_gif(struct vcpu_svm *svm)
 	if (vmcb)
 		vmcb->control.int_ctl &= ~V_GIF_MASK;
 	else
-		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+		svm->gif_value = false;
 }
 
 static inline bool gif_set(struct vcpu_svm *svm)
@@ -517,7 +536,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 	if (vmcb)
 		return !!(vmcb->control.int_ctl & V_GIF_MASK);
 	else
-		return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
+		return svm->gif_value;
 }
 
 static inline bool nested_npt_enabled(struct vcpu_svm *svm)
-- 
2.26.3


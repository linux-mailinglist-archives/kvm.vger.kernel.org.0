Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8852C63C8AB
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236369AbiK2Tly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237095AbiK2TlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:41:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0B95915A
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669750691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rGwAkLQUJjI6/SajL0tjhWVIBhdO0EXs4usgx0YdcWo=;
        b=VbJB2gNEzUyOq/yBWONBPAHRKyuOarIuwlZ5Y6tadDkCL+SS386qaur8fG26Z6uRNBX4tc
        jK812x/LFPhXbT2tAwUWSDOiOifyKqkw9miLqi4HgI7l7WQvvJkPrh71K3Ap1ug9kC3hO2
        SUn1giqIiNA6Uh7GB2OcY0XeCslGoPQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-I7THsf4vNf6hAU3FMB9_Jg-1; Tue, 29 Nov 2022 14:38:06 -0500
X-MC-Unique: I7THsf4vNf6hAU3FMB9_Jg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FC5086C141;
        Tue, 29 Nov 2022 19:38:05 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDDF42028DC1;
        Tue, 29 Nov 2022 19:38:00 +0000 (UTC)
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
        Maxim Levitsky <mlevitsk@redhat.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: [PATCH v2 10/11] KVM: SVM: implement support for vNMI
Date:   Tue, 29 Nov 2022 21:37:16 +0200
Message-Id: <20221129193717.513824-11-mlevitsk@redhat.com>
In-Reply-To: <20221129193717.513824-1-mlevitsk@redhat.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements support for injecting pending
NMIs via the .kvm_x86_set_hw_nmi_pending using new AMD's vNMI
feature.

Note that the vNMI can't cause a VM exit, which is needed
when a nested guest intercepts NMIs.

Therefore to avoid breaking nesting, the vNMI is inhibited while
a nested guest is running and instead, the legacy NMI window
detection and delivery method is used.

While it is possible to passthrough the vNMI if a nested guest
doesn't intercept NMIs, such usage is very uncommon, and it's
not worth to optimize for.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  42 +++++++++++++++
 arch/x86/kvm/svm/svm.c    | 111 ++++++++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.h    |  10 ++++
 3 files changed, 140 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e891318595113e..5bea672bf8b12d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -623,6 +623,42 @@ static bool is_evtinj_nmi(u32 evtinj)
 	return type == SVM_EVTINJ_TYPE_NMI;
 }
 
+static void nested_svm_save_vnmi(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
+
+	/*
+	 * Copy the vNMI state back to software NMI tracking state
+	 * for the duration of the nested run
+	 */
+
+	svm->nmi_masked = vmcb01->control.int_ctl & V_NMI_MASK;
+	svm->vcpu.arch.nmi_pending += vmcb01->control.int_ctl & V_NMI_PENDING;
+}
+
+static void nested_svm_restore_vnmi(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
+
+	/*
+	 * Restore the vNMI state from the software NMI tracking state
+	 * after a nested run
+	 */
+
+	if (svm->nmi_masked)
+		vmcb01->control.int_ctl |= V_NMI_MASK;
+	else
+		vmcb01->control.int_ctl &= ~V_NMI_MASK;
+
+	if (vcpu->arch.nmi_pending) {
+		vcpu->arch.nmi_pending--;
+		vmcb01->control.int_ctl |= V_NMI_PENDING;
+	} else
+		vmcb01->control.int_ctl &= ~V_NMI_PENDING;
+}
+
+
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 					  unsigned long vmcb12_rip,
 					  unsigned long vmcb12_csbase)
@@ -646,6 +682,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	else
 		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 
+	if (vnmi)
+		nested_svm_save_vnmi(svm);
+
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
@@ -1049,6 +1088,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		svm_update_lbrv(vcpu);
 	}
 
+	if (vnmi)
+		nested_svm_restore_vnmi(svm);
+
 	/*
 	 * On vmexit the  GIF is set to false and
 	 * no event can be injected in L1.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cfed6ab29c839a..bf10adcf3170a8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -230,6 +230,8 @@ module_param(dump_invalid_vmcb, bool, 0644);
 bool intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
 
+bool vnmi = true;
+module_param(vnmi, bool, 0444);
 
 static bool svm_gp_erratum_intercept = true;
 
@@ -1299,6 +1301,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
+	if (vnmi)
+		svm->vmcb->control.int_ctl |= V_NMI_ENABLE;
+
 	if (vgif) {
 		svm_clr_intercept(svm, INTERCEPT_STGI);
 		svm_clr_intercept(svm, INTERCEPT_CLGI);
@@ -3487,6 +3492,39 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	++vcpu->stat.nmi_injections;
 }
 
+
+static bool svm_get_hw_nmi_pending(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!is_vnmi_enabled(svm))
+		return false;
+
+	return !!(svm->vmcb->control.int_ctl & V_NMI_MASK);
+}
+
+static bool svm_set_hw_nmi_pending(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!is_vnmi_enabled(svm))
+		return false;
+
+	if (svm->vmcb->control.int_ctl & V_NMI_PENDING)
+		return false;
+
+	svm->vmcb->control.int_ctl |= V_NMI_PENDING;
+	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
+
+	/*
+	 * NMI isn't yet technically injected but
+	 * this rough estimation should be good enough
+	 */
+	++vcpu->stat.nmi_injections;
+
+	return true;
+}
+
 static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3582,11 +3620,38 @@ static void svm_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
 }
 
+static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (is_vnmi_enabled(svm))
+		return svm->vmcb->control.int_ctl & V_NMI_MASK;
+	else
+		return svm->nmi_masked;
+}
+
+static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (is_vnmi_enabled(svm)) {
+		if (masked)
+			svm->vmcb->control.int_ctl |= V_NMI_MASK;
+		else
+			svm->vmcb->control.int_ctl &= ~V_NMI_MASK;
+	} else {
+		svm->nmi_masked = masked;
+		if (masked)
+			svm_enable_iret_interception(svm);
+		else
+			svm_disable_iret_interception(svm);
+	}
+}
+
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
-	bool ret;
 
 	if (!gif_set(svm))
 		return true;
@@ -3594,10 +3659,10 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
 		return false;
 
-	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
-	      (svm->nmi_masked);
+	if (svm_get_nmi_mask(vcpu))
+		return true;
 
-	return ret;
+	return vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK;
 }
 
 static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
@@ -3615,24 +3680,6 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return 1;
 }
 
-static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
-{
-	return to_svm(vcpu)->nmi_masked;
-}
-
-static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	if (masked) {
-		svm->nmi_masked = true;
-		svm_enable_iret_interception(svm);
-	} else {
-		svm->nmi_masked = false;
-		svm_disable_iret_interception(svm);
-	}
-}
-
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3725,10 +3772,16 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	/*
 	 * Something prevents NMI from been injected. Single step over possible
 	 * problem (IRET or exception injection or interrupt shadow)
+	 *
+	 * With vNMI we should never need an NMI window
+	 * (we can always inject vNMI either by setting VNMI_PENDING or by EVENTINJ)
 	 */
+	if (WARN_ON_ONCE(is_vnmi_enabled(svm)))
+		return;
+
 	svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
-	svm->nmi_singlestep = true;
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
+	svm->nmi_singlestep = true;
 }
 
 static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
@@ -4770,6 +4823,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.patch_hypercall = svm_patch_hypercall,
 	.inject_irq = svm_inject_irq,
 	.inject_nmi = svm_inject_nmi,
+	.get_hw_nmi_pending = svm_get_hw_nmi_pending,
+	.set_hw_nmi_pending = svm_set_hw_nmi_pending,
 	.inject_exception = svm_inject_exception,
 	.cancel_injection = svm_cancel_injection,
 	.interrupt_allowed = svm_interrupt_allowed,
@@ -5058,6 +5113,16 @@ static __init int svm_hardware_setup(void)
 			pr_info("Virtual GIF supported\n");
 	}
 
+
+	vnmi = vgif && vnmi && boot_cpu_has(X86_FEATURE_AMD_VNMI);
+	if (vnmi)
+		pr_info("Virtual NMI enabled\n");
+
+	if (!vnmi) {
+		svm_x86_ops.get_hw_nmi_pending = NULL;
+		svm_x86_ops.set_hw_nmi_pending = NULL;
+	}
+
 	if (lbrv) {
 		if (!boot_cpu_has(X86_FEATURE_LBRV))
 			lbrv = false;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 587ddc150f9f34..0b7e1790fadde1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern int vgif;
 extern bool intercept_smi;
+extern bool vnmi;
 
 enum avic_modes {
 	AVIC_MODE_NONE = 0,
@@ -553,6 +554,15 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
 	       (msr < (APIC_BASE_MSR + 0x100));
 }
 
+static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
+{
+	/* L1's vNMI is inhibited while nested guest is running */
+	if (is_guest_mode(&svm->vcpu))
+		return false;
+
+	return !!(svm->vmcb01.ptr->control.int_ctl & V_NMI_ENABLE);
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-- 
2.26.3


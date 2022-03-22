Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14324E455A
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbiCVRmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239828AbiCVRmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:42:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D375888E1
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647970870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+e9NToXRpqgZ9g9wR+p53ywLfd/FHw5SMrMjPBdjnHg=;
        b=PEr+H6cle4Tb29SZxT4+e/4z28wA/PFuW7+CxvXHsm1Lbxljj/xWMRd7aLEjxTRmi60wAB
        tB5Sq/CkJz3xkeyqm9D36YlBCVTmflm+/KOPokf1JkWcKbo+VjYvZyZxnU43A3OQMUzG4W
        0DOKECXZBJNYeGPYmYrjdrpOip/s0DY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-ktAub7WtNdiZdLe08f3gPA-1; Tue, 22 Mar 2022 13:41:06 -0400
X-MC-Unique: ktAub7WtNdiZdLe08f3gPA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01FCB811E84;
        Tue, 22 Mar 2022 17:41:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04ADEC27E80;
        Tue, 22 Mar 2022 17:41:01 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 3/6] KVM: x86: nSVM: support PAUSE filtering when L0 doesn't intercept PAUSE
Date:   Tue, 22 Mar 2022 19:40:47 +0200
Message-Id: <20220322174050.241850-4-mlevitsk@redhat.com>
In-Reply-To: <20220322174050.241850-1-mlevitsk@redhat.com>
References: <20220322174050.241850-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow L1 to use PAUSE filtering if L0 doesn't use it.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    | 22 +++++++++++++++++++---
 arch/x86/kvm/svm/svm.h    |  2 ++
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c1baa3a68ce6..0a0b4b26c91e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -667,6 +667,29 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	if (!nested_vmcb_needs_vls_intercept(svm))
 		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
+	if (kvm_pause_in_guest(svm->vcpu.kvm)) {
+		/* use guest values since host doesn't use them */
+		vmcb02->control.pause_filter_count =
+				svm->pause_filter_enabled ?
+				svm->nested.ctl.pause_filter_count : 0;
+
+		vmcb02->control.pause_filter_thresh =
+				svm->pause_threshold_enabled ?
+				svm->nested.ctl.pause_filter_thresh : 0;
+
+	} else if (!vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_PAUSE)) {
+		/* use host values when guest doesn't use them */
+		vmcb02->control.pause_filter_count = vmcb01->control.pause_filter_count;
+		vmcb02->control.pause_filter_thresh = vmcb01->control.pause_filter_thresh;
+	} else {
+		/*
+		 * Intercept every PAUSE otherwise and
+		 * ignore both host and guest values
+		 */
+		vmcb02->control.pause_filter_count = 0;
+		vmcb02->control.pause_filter_thresh = 0;
+	}
+
 	nested_svm_transition_tlb_flush(vcpu);
 
 	/* Enter Guest-Mode */
@@ -927,6 +950,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
+	if (!kvm_pause_in_guest(vcpu->kvm) && vmcb02->control.pause_filter_count)
+		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
+
 	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ec9a1dabdcc3..4c23cb1895ab 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -910,6 +910,9 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
+	if (kvm_pause_in_guest(vcpu->kvm) || !old)
+		return;
+
 	control->pause_filter_count = __grow_ple_window(old,
 							pause_filter_count,
 							pause_filter_count_grow,
@@ -928,6 +931,9 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
+	if (kvm_pause_in_guest(vcpu->kvm) || !old)
+		return;
+
 	control->pause_filter_count =
 				__shrink_ple_window(old,
 						    pause_filter_count,
@@ -2984,7 +2990,6 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 static int pause_interception(struct kvm_vcpu *vcpu)
 {
 	bool in_kernel;
-
 	/*
 	 * CPL is not made available for an SEV-ES guest, therefore
 	 * vcpu->arch.preempted_in_kernel can never be true.  Just
@@ -2992,8 +2997,7 @@ static int pause_interception(struct kvm_vcpu *vcpu)
 	 */
 	in_kernel = !sev_es_guest(vcpu->kvm) && svm_get_cpl(vcpu) == 0;
 
-	if (!kvm_pause_in_guest(vcpu->kvm))
-		grow_ple_window(vcpu);
+	grow_ple_window(vcpu);
 
 	kvm_vcpu_on_spin(vcpu, in_kernel);
 	return kvm_skip_emulated_instruction(vcpu);
@@ -4020,6 +4024,12 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm->v_vmload_vmsave_enabled = vls && guest_cpuid_has(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
 
+	svm->pause_filter_enabled = kvm_cpu_cap_has(X86_FEATURE_PAUSEFILTER) &&
+			guest_cpuid_has(vcpu, X86_FEATURE_PAUSEFILTER);
+
+	svm->pause_threshold_enabled = kvm_cpu_cap_has(X86_FEATURE_PFTHRESHOLD) &&
+			guest_cpuid_has(vcpu, X86_FEATURE_PFTHRESHOLD);
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4773,6 +4783,12 @@ static __init void svm_set_cpu_caps(void)
 		if (lbrv)
 			kvm_cpu_cap_set(X86_FEATURE_LBRV);
 
+		if (boot_cpu_has(X86_FEATURE_PAUSEFILTER))
+			kvm_cpu_cap_set(X86_FEATURE_PAUSEFILTER);
+
+		if (boot_cpu_has(X86_FEATURE_PFTHRESHOLD))
+			kvm_cpu_cap_set(X86_FEATURE_PFTHRESHOLD);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index aaf46b1fbf76..9895fd6a7310 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -237,6 +237,8 @@ struct vcpu_svm {
 	bool tsc_scaling_enabled          : 1;
 	bool v_vmload_vmsave_enabled      : 1;
 	bool lbrv_enabled                 : 1;
+	bool pause_filter_enabled         : 1;
+	bool pause_threshold_enabled      : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-- 
2.26.3


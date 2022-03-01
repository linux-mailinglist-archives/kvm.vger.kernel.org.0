Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F23B4C8DF0
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 15:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbiCAOib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 09:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiCAOiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 09:38:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66AD927FFB
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 06:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646145457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZjQN7wznicklRYRjP7490OYXQBlwkJyTh9CvMU4u2NE=;
        b=MyI1p00daRMjqT0YiaWCc2hP7RO7No70R7EMdQD7dTy3mwhBG3kk9ICmFBLAMXFpm0O6wb
        hOv7jDe9Eays/Vtp3NXYP6LR060PN37AjeYPSFRzNBVZmpeD6EIYY7Z/fNNioLGMDkTbWm
        x4egYEz4d+npkVwmyVFZtxLPc2L7+0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-y4B9GXlbO86N0ip71HZ4VA-1; Tue, 01 Mar 2022 09:37:34 -0500
X-MC-Unique: y4B9GXlbO86N0ip71HZ4VA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31B531854E2B;
        Tue,  1 Mar 2022 14:37:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37F2F866DC;
        Tue,  1 Mar 2022 14:37:28 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 5/7] KVM: x86: nSVM: implement nested vGIF
Date:   Tue,  1 Mar 2022 16:36:48 +0200
Message-Id: <20220301143650.143749-6-mlevitsk@redhat.com>
In-Reply-To: <20220301143650.143749-1-mlevitsk@redhat.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case L1 enables vGIF for L2, the L2 cannot affect L1's GIF, regardless
of STGI/CLGI intercepts, and since VM entry enables GIF, this means
that L1's GIF is always 1 while L2 is running.

Thus in this case leave L1's vGIF in vmcb01, while letting L2
control the vGIF thus implementing nested vGIF.

Also allow KVM to toggle L1's GIF during nested entry/exit
by always using vmcb01.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 17 +++++++++++++----
 arch/x86/kvm/svm/svm.c    |  5 +++++
 arch/x86/kvm/svm/svm.h    | 25 +++++++++++++++++++++----
 3 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4cb0bc49986d5..4f8b5a330096e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -436,6 +436,10 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 		 */
 		mask &= ~V_IRQ_MASK;
 	}
+
+	if (nested_vgif_enabled(svm))
+		mask |= V_GIF_MASK;
+
 	svm->nested.ctl.int_ctl        &= ~mask;
 	svm->nested.ctl.int_ctl        |= svm->vmcb->control.int_ctl & mask;
 }
@@ -602,10 +606,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
-	const u32 int_ctl_vmcb01_bits =
-		V_INTR_MASKING_MASK | V_GIF_MASK | V_GIF_ENABLE_MASK;
-
-	const u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
+	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
+	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
 
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
@@ -620,6 +622,13 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	 */
 	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
 
+
+
+	if (svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
+		int_ctl_vmcb12_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
+	else
+		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
+
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
 	svm->vmcb->control.nested_ctl = svm->vmcb01.ptr->control.nested_ctl;
 	svm->vmcb->control.iopm_base_pa = svm->vmcb01.ptr->control.iopm_base_pa;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 52198e63c5fc4..776585dd77769 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4019,6 +4019,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		svm->pause_threshold_enabled = false;
 	}
 
+	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4780,6 +4782,9 @@ static __init void svm_set_cpu_caps(void)
 		if (pause_filter_thresh)
 			kvm_cpu_cap_set(X86_FEATURE_PFTHRESHOLD);
 
+		if (vgif)
+			kvm_cpu_cap_set(X86_FEATURE_VGIF);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6fa81eb3ffb78..7e2f9bddf47dd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -236,6 +236,7 @@ struct vcpu_svm {
 	bool v_vmload_vmsave_enabled      : 1;
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
+	bool vgif_enabled                 : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
@@ -454,31 +455,47 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
 	return vmcb_is_intercept(&svm->vmcb->control, bit);
 }
 
+static bool nested_vgif_enabled(struct vcpu_svm *svm)
+{
+	if (!is_guest_mode(&svm->vcpu) || !svm->vgif_enabled)
+		return false;
+	return svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK;
+}
+
 static inline bool vgif_enabled(struct vcpu_svm *svm)
 {
-	return !!(svm->vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
+	struct vmcb *vmcb = nested_vgif_enabled(svm) ? svm->vmcb01.ptr : svm->vmcb;
+
+	return !!(vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
 }
 
 static inline void enable_gif(struct vcpu_svm *svm)
 {
+	struct vmcb *vmcb = nested_vgif_enabled(svm) ? svm->vmcb01.ptr : svm->vmcb;
+
 	if (vgif_enabled(svm))
-		svm->vmcb->control.int_ctl |= V_GIF_MASK;
+		vmcb->control.int_ctl |= V_GIF_MASK;
 	else
 		svm->vcpu.arch.hflags |= HF_GIF_MASK;
 }
 
 static inline void disable_gif(struct vcpu_svm *svm)
 {
+	struct vmcb *vmcb = nested_vgif_enabled(svm) ? svm->vmcb01.ptr : svm->vmcb;
+
 	if (vgif_enabled(svm))
-		svm->vmcb->control.int_ctl &= ~V_GIF_MASK;
+		vmcb->control.int_ctl &= ~V_GIF_MASK;
 	else
 		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+
 }
 
 static inline bool gif_set(struct vcpu_svm *svm)
 {
+	struct vmcb *vmcb = nested_vgif_enabled(svm) ? svm->vmcb01.ptr : svm->vmcb;
+
 	if (vgif_enabled(svm))
-		return !!(svm->vmcb->control.int_ctl & V_GIF_MASK);
+		return !!(vmcb->control.int_ctl & V_GIF_MASK);
 	else
 		return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
 }
-- 
2.26.3


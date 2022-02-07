Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78244AC501
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391940AbiBGQEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385583AbiBGQA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 11:00:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAA53C0401CE
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 08:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644249655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0YZKFPfPAlzbRhVzmbaqcoTuZ3BdIzpFOausE6A/ZGI=;
        b=XSUntx453+VZjjGXsn173/BO/GCCZiiUU3gLH1dZQFQ7ihYdGfQtIc1/FLlKr/7Bv7fSmJ
        t2jch6QnC7Kn4GkiWmsY2OpqEmuuiXwwnxToBm8GcHbD41VmzqPyd5aQFuS6lYFHqVJEwI
        QZbnIGF4fr82bqZ4NEZwe9RwYMx8fGQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-DItzqBf_Nx6qyRMfwq5ONQ-1; Mon, 07 Feb 2022 11:00:52 -0500
X-MC-Unique: DItzqBf_Nx6qyRMfwq5ONQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 527A8100C611;
        Mon,  7 Feb 2022 16:00:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D44AD7DE38;
        Mon,  7 Feb 2022 16:00:12 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        David Airlie <airlied@linux.ie>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH RESEND 26/30] KVM: x86: nSVM: implement nested vGIF
Date:   Mon,  7 Feb 2022 17:54:43 +0200
Message-Id: <20220207155447.840194-27-mlevitsk@redhat.com>
In-Reply-To: <20220207155447.840194-1-mlevitsk@redhat.com>
References: <20220207155447.840194-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 601d38ae05cc6..a426d4d3dcd82 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -408,6 +408,10 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
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
@@ -573,10 +577,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
-	const u32 int_ctl_vmcb01_bits =
-		V_INTR_MASKING_MASK | V_GIF_MASK | V_GIF_ENABLE_MASK;
-
-	const u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
+	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
+	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
 
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
@@ -586,6 +588,13 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	 */
 
 
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
index e49043807ec44..1cf682d1553cc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4008,6 +4008,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		svm->pause_threshold_enabled = false;
 	}
 
+	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4823,6 +4825,9 @@ static __init void svm_set_cpu_caps(void)
 		if (pause_filter_thresh)
 			kvm_cpu_cap_set(X86_FEATURE_PFTHRESHOLD);
 
+		if (vgif)
+			kvm_cpu_cap_set(X86_FEATURE_VGIF);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 297ec57f9941c..73cc9d3e784bd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -224,6 +224,7 @@ struct vcpu_svm {
 	bool v_vmload_vmsave_enabled      : 1;
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
+	bool vgif_enabled                 : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
@@ -442,31 +443,47 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A5C4E4554
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239841AbiCVRmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239843AbiCVRmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:42:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 427648D6A8
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647970874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I6BtCBu5Oq00qG5Jtfeh+nKlDytZZoOPC9H3EiLLaQU=;
        b=Bejka4175ztVA8XnQ8mS3q+hNc2VBdnJ/Vas+n4Sq4lcpi7y31io7zwty3+XdDWKowvKQg
        dJKgArXcj8SMq99EOoEDCW33NZinZVXkAwSh+ZSodCxcMq10huPi4LMVPCnDW4NKyxtCfl
        1azQZavvf8i5QIVGXHj5r2DrfAKIksc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-Vgx2cQRNPc-MioS53Ncb1g-1; Tue, 22 Mar 2022 13:41:11 -0400
X-MC-Unique: Vgx2cQRNPc-MioS53Ncb1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87321185A7A4;
        Tue, 22 Mar 2022 17:41:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B25CC090DC;
        Tue, 22 Mar 2022 17:41:06 +0000 (UTC)
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
Subject: [PATCH v4 4/6] KVM: x86: nSVM: implement nested vGIF
Date:   Tue, 22 Mar 2022 19:40:48 +0200
Message-Id: <20220322174050.241850-5-mlevitsk@redhat.com>
In-Reply-To: <20220322174050.241850-1-mlevitsk@redhat.com>
References: <20220322174050.241850-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/svm/svm.h    | 35 +++++++++++++++++++++++++++++------
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0a0b4b26c91e..47a5e8d8b578 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -439,6 +439,10 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
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
@@ -603,10 +607,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
-	const u32 int_ctl_vmcb01_bits =
-		V_INTR_MASKING_MASK | V_GIF_MASK | V_GIF_ENABLE_MASK;
-
-	const u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
+	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
+	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
 
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
@@ -623,6 +625,13 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
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
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4c23cb1895ab..7fb4cf3bce4f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4030,6 +4030,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	svm->pause_threshold_enabled = kvm_cpu_cap_has(X86_FEATURE_PFTHRESHOLD) &&
 			guest_cpuid_has(vcpu, X86_FEATURE_PFTHRESHOLD);
 
+	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
+
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
@@ -4789,6 +4791,9 @@ static __init void svm_set_cpu_caps(void)
 		if (boot_cpu_has(X86_FEATURE_PFTHRESHOLD))
 			kvm_cpu_cap_set(X86_FEATURE_PFTHRESHOLD);
 
+		if (vgif)
+			kvm_cpu_cap_set(X86_FEATURE_VGIF);
+
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9895fd6a7310..ba0c90bc5c55 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -239,6 +239,7 @@ struct vcpu_svm {
 	bool lbrv_enabled                 : 1;
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
+	bool vgif_enabled                 : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
@@ -457,26 +458,48 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
 	return vmcb_is_intercept(&svm->vmcb->control, bit);
 }
 
+static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
+{
+	return svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
+}
+
+static inline struct vmcb *get_vgif_vmcb(struct vcpu_svm *svm)
+{
+	if (!vgif)
+		return NULL;
+
+	if (is_guest_mode(&svm->vcpu) && !nested_vgif_enabled(svm))
+		return svm->nested.vmcb02.ptr;
+	else
+		return svm->vmcb01.ptr;
+}
+
 static inline void enable_gif(struct vcpu_svm *svm)
 {
-	if (vgif)
-		svm->vmcb->control.int_ctl |= V_GIF_MASK;
+	struct vmcb *vmcb = get_vgif_vmcb(svm);
+
+	if (vmcb)
+		vmcb->control.int_ctl |= V_GIF_MASK;
 	else
 		svm->vcpu.arch.hflags |= HF_GIF_MASK;
 }
 
 static inline void disable_gif(struct vcpu_svm *svm)
 {
-	if (vgif)
-		svm->vmcb->control.int_ctl &= ~V_GIF_MASK;
+	struct vmcb *vmcb = get_vgif_vmcb(svm);
+
+	if (vmcb)
+		vmcb->control.int_ctl &= ~V_GIF_MASK;
 	else
 		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
 }
 
 static inline bool gif_set(struct vcpu_svm *svm)
 {
-	if (vgif)
-		return !!(svm->vmcb->control.int_ctl & V_GIF_MASK);
+	struct vmcb *vmcb = get_vgif_vmcb(svm);
+
+	if (vmcb)
+		return !!(vmcb->control.int_ctl & V_GIF_MASK);
 	else
 		return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
 }
-- 
2.26.3


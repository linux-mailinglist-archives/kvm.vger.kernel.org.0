Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6CE4E4521
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbiCVR1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239658AbiCVR1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:27:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 763494AE27
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647969937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7I7dqYMl5+doAoV5btm6XXybkDOAVnQ7eRTvquSjCLU=;
        b=ekMZRk8duAqW9OUJ/kmpDobyUia0WkqwGTc0cF/a3E8/Q7OACFXJAKN9KSMBYuELZufsek
        arsI1P44Q+eLOwfOp3rhHdc+uIqVrkihSDjxNMhId79Xs1S6WDTGhwSa8nHUQQqA/IvB/T
        ynFkYg6qSey45v719/tVCmwtk+IMfgQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-g0aVRgOeOwC64VKOor939A-1; Tue, 22 Mar 2022 13:25:32 -0400
X-MC-Unique: g0aVRgOeOwC64VKOor939A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A248C811E76;
        Tue, 22 Mar 2022 17:25:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EB3D2166B2D;
        Tue, 22 Mar 2022 17:25:28 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 8/8] KVM: x86: SVM: remove vgif_enabled()
Date:   Tue, 22 Mar 2022 19:24:49 +0200
Message-Id: <20220322172449.235575-9-mlevitsk@redhat.com>
In-Reply-To: <20220322172449.235575-1-mlevitsk@redhat.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM always uses vgif when allowed, thus there is
no need to query current vmcb for it

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++++------
 arch/x86/kvm/svm/svm.h | 12 ++++--------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index acf04cf4ed2a..70fc5897f5f2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -172,7 +172,7 @@ static int vls = true;
 module_param(vls, int, 0444);
 
 /* enable/disable Virtual GIF */
-static int vgif = true;
+int vgif = true;
 module_param(vgif, int, 0444);
 
 /* enable/disable LBR virtualization */
@@ -2148,7 +2148,7 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)
 		 * Likewise, clear the VINTR intercept, we will set it
 		 * again while processing KVM_REQ_EVENT if needed.
 		 */
-		if (vgif_enabled(svm))
+		if (vgif)
 			svm_clr_intercept(svm, INTERCEPT_STGI);
 		if (svm_is_intercept(svm, INTERCEPT_VINTR))
 			svm_clear_vintr(svm);
@@ -2166,7 +2166,7 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)
 		 * in use, we still rely on the VINTR intercept (rather than
 		 * STGI) to detect an open interrupt window.
 		*/
-		if (!vgif_enabled(svm))
+		if (!vgif)
 			svm_clear_vintr(svm);
 	}
 }
@@ -3502,7 +3502,7 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 	 * enabled, the STGI interception will not occur. Enable the irq
 	 * window under the assumption that the hardware will set the GIF.
 	 */
-	if (vgif_enabled(svm) || gif_set(svm)) {
+	if (vgif || gif_set(svm)) {
 		/*
 		 * IRQ window is not needed when AVIC is enabled,
 		 * unless we have pending ExtINT since it cannot be injected
@@ -3522,7 +3522,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 		return; /* IRET will cause a vm exit */
 
 	if (!gif_set(svm)) {
-		if (vgif_enabled(svm))
+		if (vgif)
 			svm_set_intercept(svm, INTERCEPT_STGI);
 		return; /* STGI will cause a vm exit */
 	}
@@ -4329,7 +4329,7 @@ static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (!gif_set(svm)) {
-		if (vgif_enabled(svm))
+		if (vgif)
 			svm_set_intercept(svm, INTERCEPT_STGI);
 		/* STGI will cause a vm exit */
 	} else {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 468f149556dd..6a10cb4817e8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -33,6 +33,7 @@
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
+extern int vgif;
 extern bool intercept_smi;
 
 /*
@@ -453,14 +454,9 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
 	return vmcb_is_intercept(&svm->vmcb->control, bit);
 }
 
-static inline bool vgif_enabled(struct vcpu_svm *svm)
-{
-	return !!(svm->vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
-}
-
 static inline void enable_gif(struct vcpu_svm *svm)
 {
-	if (vgif_enabled(svm))
+	if (vgif)
 		svm->vmcb->control.int_ctl |= V_GIF_MASK;
 	else
 		svm->vcpu.arch.hflags |= HF_GIF_MASK;
@@ -468,7 +464,7 @@ static inline void enable_gif(struct vcpu_svm *svm)
 
 static inline void disable_gif(struct vcpu_svm *svm)
 {
-	if (vgif_enabled(svm))
+	if (vgif)
 		svm->vmcb->control.int_ctl &= ~V_GIF_MASK;
 	else
 		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
@@ -476,7 +472,7 @@ static inline void disable_gif(struct vcpu_svm *svm)
 
 static inline bool gif_set(struct vcpu_svm *svm)
 {
-	if (vgif_enabled(svm))
+	if (vgif)
 		return !!(svm->vmcb->control.int_ctl & V_GIF_MASK);
 	else
 		return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
-- 
2.26.3


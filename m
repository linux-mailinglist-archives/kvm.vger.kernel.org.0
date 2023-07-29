Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A968767AA9
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbjG2BSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235535AbjG2BRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:17:39 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C0749ED
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d07cb52a768so2507043276.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593403; x=1691198203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RivGO1zReamo45LkTKZurMbG/2NW5Na6scf+1QseqDY=;
        b=hIQtvbpt0HUSaqF39Lk9Xfa9TrQTmVjU7RALdaw1fEsbZtAiuObGnFR0Gku+I64fsr
         EVrNvlR/IQ3tigJBye53R3SEyQq9ap5sEjRS/w2ib/Nbaz6ND/a27qXUH/r81czS+i95
         +4M/PpgfVpbnHAK78VBIkHZWNOg/uMCvRhbsbRb5Hz+3PclOkZWQ3b+JNlm+EY4AMFDN
         20KHnMdzEj16XfUGCUjYSYQTHQI7CuKSHt/AuA1oUQSVbnuRFX7uwRCDJlxDMZO7lCzE
         2180eCxVHw5kgi3tfuffiJsVwm2w8dHM1viduqd8KLxmLQDiaS63Vsh1giEXn7bIp+Nv
         Jtog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593403; x=1691198203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RivGO1zReamo45LkTKZurMbG/2NW5Na6scf+1QseqDY=;
        b=lFscy8dUtzDlj7JYZ0NPMhHkdjMix8ifQubPhMAaD7WmU4G46dR/bnGfI+k0ffxWyZ
         q3jQiRCrzqUrORgiHJr+h8kAFqsBOo4ApuILqevvCX46s/qPb6xgJ+5SWYy/d988hxMy
         EjElhgn59a0JzWniDHtcxmbriS2mYmalI7M6CipBo6EpDbYRc5eEpu73IeraRdlyms2t
         dHRZpee1QrG0oejWUF4VaTh3w7Dra7kjUlGAIVf47TOTGlB9iTx2+wszWjz/f0eAMipU
         oeZ1tuzNWUHtNTCiDKMV2sv21V8rzy8l3d1xXrMnoyq/ZHQMSx7FpFGbJP5YfL0BNv0u
         APFw==
X-Gm-Message-State: ABy/qLZQ2OmbBjJx3RlVe4slqztyrSvtYSgxwhIUt9N1egWqKvhltxNm
        NIwn6iM+ZMUGKKN8xmChjJcVWDMgrhM=
X-Google-Smtp-Source: APBJJlFzrRMu/FipBCWOALymzRtbc31rIKvodpA1k0Hng04DLRC6eCO5Q8u++IKFWaiaXRNNRrLr5Q/WTcQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2d1a:0:b0:d0c:77a8:1f6b with SMTP id
 t26-20020a252d1a000000b00d0c77a81f6bmr20040ybt.10.1690593403726; Fri, 28 Jul
 2023 18:16:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:16:03 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-17-seanjc@google.com>
Subject: [PATCH v2 16/21] KVM: nSVM: Use KVM-governed feature framework to
 track "vVM{SAVE,LOAD} enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track "virtual VMSAVE/VMLOAD exposed to L1" via a governed feature flag
instead of using a dedicated bit/flag in vcpu_svm.

Opportunistically add a comment explaining why KVM disallows virtual
VMLOAD/VMSAVE when the vCPU model is Intel.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h |  1 +
 arch/x86/kvm/svm/nested.c        |  2 +-
 arch/x86/kvm/svm/svm.c           | 10 +++++++---
 arch/x86/kvm/svm/svm.h           |  1 -
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 32c0469cf952..f01a95fd0071 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -10,6 +10,7 @@ KVM_GOVERNED_X86_FEATURE(XSAVES)
 KVM_GOVERNED_X86_FEATURE(VMX)
 KVM_GOVERNED_X86_FEATURE(NRIPS)
 KVM_GOVERNED_X86_FEATURE(TSCRATEMSR)
+KVM_GOVERNED_X86_FEATURE(V_VMSAVE_VMLOAD)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index da65948064dc..24d47ebeb0e0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -107,7 +107,7 @@ static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
 
 static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
 {
-	if (!svm->v_vmload_vmsave_enabled)
+	if (!guest_can_use(&svm->vcpu, X86_FEATURE_V_VMSAVE_VMLOAD))
 		return true;
 
 	if (!nested_npt_enabled(svm))
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f7f7df5a591..39a69c1786ea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1154,8 +1154,6 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 0, 0);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 0, 0);
-
-		svm->v_vmload_vmsave_enabled = false;
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -4226,7 +4224,13 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
 
-	svm->v_vmload_vmsave_enabled = vls && guest_cpuid_has(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
+	/*
+	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
+	 * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that exposing
+	 * SVM on Intel is bonkers and extremely unlikely to work).
+	 */
+	if (!guest_cpuid_is_intel(vcpu))
+		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
 
 	svm->pause_filter_enabled = kvm_cpu_cap_has(X86_FEATURE_PAUSEFILTER) &&
 			guest_cpuid_has(vcpu, X86_FEATURE_PAUSEFILTER);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4e7332f77702..b475241df6dc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -259,7 +259,6 @@ struct vcpu_svm {
 	bool soft_int_injected;
 
 	/* optional nested SVM features that are enabled for this guest  */
-	bool v_vmload_vmsave_enabled      : 1;
 	bool lbrv_enabled                 : 1;
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
-- 
2.41.0.487.g6d72f3e995-goog


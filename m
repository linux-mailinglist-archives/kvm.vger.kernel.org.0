Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD5677D45D
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238648AbjHOUiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238998AbjHOUiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:38:00 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEB02109
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:36 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589fae40913so28344967b3.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131834; x=1692736634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xweNaIPfBOW/m2asVm+iJf6F67YoA7+If7dzBXn/b2Y=;
        b=2oLSelu7YkNFbhZ/UQnbxUbVBAXwQYUifvFWTVXmtT4FzbqBb4rzm3HnWelumm7aaj
         ern2HGbKmvY5u7ctzw7P7dxSvh02STXDN7MwyP52+48bArlfGV6h58bZdNl0NGvDAziS
         Bw3xVpuEo7BfRpATSQfhfBQfH3FEqDGHxydQfz0n5B55+IIiEEKvX9azNbN+DCWXELE0
         32SxhRkJiN1c5+hx5nRMdl3yf3zvYlSRALQoqwwwwTDzkRXioAQM8+RV3to588YmkUkQ
         xBSYkh8vt7x6Vn4zxrkpq+Ho2UepxYjfhJA1aOXeXQAQeBoaRPqCZ1oWdQ9iVSA1gsx3
         Qxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131834; x=1692736634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xweNaIPfBOW/m2asVm+iJf6F67YoA7+If7dzBXn/b2Y=;
        b=Z7egljcW7ZSQa5Nzgr3nDx//mUir2rmNvxmbEU138JFu3or60ZZ6cYXiZekd3KMyXJ
         2ThMlO1SfWXbbXif4MVIJZ1CJSlIV+IbwT3eJmjLSBk/zHsrhp4Atud0Q/PD/Wb4+IkN
         Mo0sbhenfBtuIEZbm65U2Tqe5NezqffrEG+JPdt3hk2/JXgbwfskS3H6cnW6hj20UeQ8
         KBH5A/i/QCzrCZinBEp7c4zalQQbPb+W6Ek48B3Fvw9Wu2kSTmng9HCxy5SSQLEo/HTi
         Tc25GAHuRCEh9TsKfnHhkonnVkFt/PJs61bD/+z39Abk/l9ZP485XrNIM8OFDiWLDDU7
         zlJg==
X-Gm-Message-State: AOJu0Yw11UN+OIdbQBYlTLM7h9cbY2T471wfWRcBV1+Uw0s6rjC0NmUO
        cgNT1ouZUIwJI+wVkPkvGqh6+kPGjKA=
X-Google-Smtp-Source: AGHT+IE8HWufBzXiSTHPBdArXsit6jTp3EmYvkjHZ8UH0EAgkj5U6Kyx0wfq5t5UtKprhvbBJJaPc841cxQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af17:0:b0:586:5d03:67c8 with SMTP id
 n23-20020a81af17000000b005865d0367c8mr197252ywh.3.1692131834240; Tue, 15 Aug
 2023 13:37:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:48 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-11-seanjc@google.com>
Subject: [PATCH v3 10/15] KVM: nSVM: Use KVM-governed feature framework to
 track "vVM{SAVE,LOAD} enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 15c79457d8c5..7cecbb58c60f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1201,8 +1201,6 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 0, 0);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 0, 0);
-
-		svm->v_vmload_vmsave_enabled = false;
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -4295,7 +4293,13 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
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
index 3696f10e2887..b3fdaab57363 100644
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
2.41.0.694.ge786442a9b-goog


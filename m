Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7621C77D45F
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238844AbjHOUi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239071AbjHOUiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:38:02 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F9C2112
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:40 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589ebdea23fso49437727b3.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131838; x=1692736638;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=quIPS1pAkj8snq1ZBSsiom42DynaYCyzTMFv1WUiS2M=;
        b=RvRWqcWMpEvAk1DUNu/JSGL6I3nolm8Pj4MN/HkYUT+sPFvsYA3TSAh5vBr7kmMt/H
         J40DMugrpKOgkOr4zldFpm0Ft197XG7kKdrlSaAMlXuXwcE+1qJVh6lVQbcHk1gvCtxF
         IPdKxacSEA9rUJy+wn4nJqerjEyHVLI1o1SwKD36GQhcVKF2C51gd42peJyWsvi5J+Pk
         i1i32qqaCfDJm7juIktsbPASIFqkyH6DH3CZiFskIb0vX0BWbGaIubYLHqFxw95URUMp
         WBptsQKNO4eS6W9Z/tqU22fGyr1wAVg6glABsnRaMcp/YO1Hdt1p7sN3VTGZt6gFQczz
         faPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131838; x=1692736638;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=quIPS1pAkj8snq1ZBSsiom42DynaYCyzTMFv1WUiS2M=;
        b=jyCGsJAi4A14WZmrL4VC5cPAibjiRBwh1KQNETvAl4UwitdUdp5srRlcen567lRBYr
         XNRMrCvQrkkWzMyjrisqqtjTrrn1ZFugGXDB41NIuHi+f//EOClLs5Xg9e5ed5qdhsBT
         jvnLsWD3fB0R62e64cpc1mnHIZl7TU6r4r3X8Tm4ro5pilErb0sxz/vfwrWel2xJa5dk
         nlRtzEKAivziDW6uvpDDnzUjuRH9KyNdTMWXnzsMaKhIFE92dunGJpXOhTMGue9hi6o0
         o7WIGyKHzEMb0RZ86foGHfRlHtJ2nWMLS74Lff8bgDD9AiFWDGG5fiJLYz0+RnmH+XHH
         9Z4Q==
X-Gm-Message-State: AOJu0Yyh3Ii+bvfZjVzQ0XCZXP3IZaSSVo8Z0Lhwy+Kd1dFV/zfnH/OE
        arDPWGbM4hmnuwLtRQUQrvsOvbgdP28=
X-Google-Smtp-Source: AGHT+IGvFX/F2YB5U602ZWBWYYnMgRv9dvTBT04aawRwHtFIqhCUHsWEJDTV7yn9hv1vy8J/KeqCknhg/6k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dc87:0:b0:ca3:3341:6315 with SMTP id
 y129-20020a25dc87000000b00ca333416315mr1741ybe.0.1692131838149; Tue, 15 Aug
 2023 13:37:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:50 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-13-seanjc@google.com>
Subject: [PATCH v3 12/15] KVM: nSVM: Use KVM-governed feature framework to
 track "Pause Filter enabled"
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

Track "Pause Filtering is exposed to L1" via governed feature flags
instead of using dedicated bits/flags in vcpu_svm.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h |  2 ++
 arch/x86/kvm/svm/nested.c        | 10 ++++++++--
 arch/x86/kvm/svm/svm.c           |  7 ++-----
 arch/x86/kvm/svm/svm.h           |  2 --
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 3a4c0e40e1e0..9afd34f30599 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -12,6 +12,8 @@ KVM_GOVERNED_X86_FEATURE(NRIPS)
 KVM_GOVERNED_X86_FEATURE(TSCRATEMSR)
 KVM_GOVERNED_X86_FEATURE(V_VMSAVE_VMLOAD)
 KVM_GOVERNED_X86_FEATURE(LBRV)
+KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
+KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f50f74b1a04e..ac03b2bc5b2c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -743,8 +743,14 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	if (!nested_vmcb_needs_vls_intercept(svm))
 		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
-	pause_count12 = svm->pause_filter_enabled ? svm->nested.ctl.pause_filter_count : 0;
-	pause_thresh12 = svm->pause_threshold_enabled ? svm->nested.ctl.pause_filter_thresh : 0;
+	if (guest_can_use(vcpu, X86_FEATURE_PAUSEFILTER))
+		pause_count12 = svm->nested.ctl.pause_filter_count;
+	else
+		pause_count12 = 0;
+	if (guest_can_use(vcpu, X86_FEATURE_PFTHRESHOLD))
+		pause_thresh12 = svm->nested.ctl.pause_filter_thresh;
+	else
+		pause_thresh12 = 0;
 	if (kvm_pause_in_guest(svm->vcpu.kvm)) {
 		/* use guest values since host doesn't intercept PAUSE */
 		vmcb02->control.pause_filter_count = pause_count12;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index de40745bc8a6..9bfff65e8b7a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4300,11 +4300,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (!guest_cpuid_is_intel(vcpu))
 		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
 
-	svm->pause_filter_enabled = kvm_cpu_cap_has(X86_FEATURE_PAUSEFILTER) &&
-			guest_cpuid_has(vcpu, X86_FEATURE_PAUSEFILTER);
-
-	svm->pause_threshold_enabled = kvm_cpu_cap_has(X86_FEATURE_PFTHRESHOLD) &&
-			guest_cpuid_has(vcpu, X86_FEATURE_PFTHRESHOLD);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
 
 	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 45cbbdeac3a3..d57a096e070a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -259,8 +259,6 @@ struct vcpu_svm {
 	bool soft_int_injected;
 
 	/* optional nested SVM features that are enabled for this guest  */
-	bool pause_filter_enabled         : 1;
-	bool pause_threshold_enabled      : 1;
 	bool vgif_enabled                 : 1;
 	bool vnmi_enabled                 : 1;
 
-- 
2.41.0.694.ge786442a9b-goog


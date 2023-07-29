Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C180767AAD
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbjG2BSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237422AbjG2BRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:17:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD785261
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:16 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5704995f964so29397987b3.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593407; x=1691198207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IAQPKbD8tPDmYBWrX7RApaZ6urq2NKcobd6GaE19UZk=;
        b=ZeRoOCqFI4p+w9IAeXNpwy5tKs7MTBzITIeEzXVkbc0WGkIBaxYXBabBmGzaP1liLi
         XzrIM1m5WJ5mzyQ+rtejbV0YofqVAwW9vi2WTcum05Q9JdcoEmvQzyNePKLll1Sn2HMO
         ahBeBbAd+C4oZYuQ4+SLDrttWUUutbvJzB+NPE7xpQnmvhQPgMqjg7siGDxiXFihzVXR
         CGyom5LhVfRPhLZEQNaMXxCXXDXIhIMlYrl/Im0JiotbqoucEne7MLA8+4hOwpXgTPnp
         HZqMWWaIu0y0sib7kJ858UYs6W7nHxDs6gM9J0R2oTbVCNf3/l6v/DSd89ZM/J9z6Dt8
         UoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593407; x=1691198207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IAQPKbD8tPDmYBWrX7RApaZ6urq2NKcobd6GaE19UZk=;
        b=ADJjFUfVn+pN+LrpQAoqXS/O2jkCfDpP5/jlpk6XHrnvlU1yFDB9F3XmkIst/ztgUu
         1Hy/8pghMkU7sPWOZeJRos7ErRMB1k+AYWSBoVuzp0GT+F4EP9Z6mN6E2iEPiX+nXmzM
         1fTdo+SiAzVuszoEjxIwicRtOlFZpTD7msEpsGctrKK5qke7GMR7oSg1J8qUaAW6A844
         9CI1G/rQxXP+t7Xxwe5F1ttrnhhM4P3BAXI9joxMfSsP/bypd6leWkdEnrMpaiY5JQ2f
         8sdbMV6l5QiTZO+rPkHKPyB7OjNi8+0BY7ZH7UQZtYJAArkUd+N720MuzsrEYOe6IJ6A
         5mww==
X-Gm-Message-State: ABy/qLaSG6Qaoc0tpvCkqt1Yz/mHLROvQS8htLnbfPC1tZ66WSY3KTxD
        itbtuoftI4IKqAd1ZLMwEyHIsH1qFTM=
X-Google-Smtp-Source: APBJJlGCdrikao/e6/kr7d/aLh6t1yJ8UDloeWc8WvjWjWmX1Ju375VMcZzc7H1kC6TbxCNSrsZbWzRKWOc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae25:0:b0:56c:b037:88aa with SMTP id
 m37-20020a81ae25000000b0056cb03788aamr24021ywh.5.1690593407555; Fri, 28 Jul
 2023 18:16:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:16:05 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-19-seanjc@google.com>
Subject: [PATCH v2 18/21] KVM: nSVM: Use KVM-governed feature framework to
 track "Pause Filter enabled"
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
index a83fa6df7c04..be3a11f00f4e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4233,11 +4233,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
index 0e21823e8a19..fb438439b61e 100644
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
2.41.0.487.g6d72f3e995-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A75E69B64B
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 00:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjBQXLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 18:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjBQXL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 18:11:26 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784AB6B305
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:52 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id ns9-20020a17090b250900b0023487c793d0so1264998pjb.7
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TQzYXroMSTeC6jBkk8L8kpJ+IXUUCZH+35l1d+2iFCk=;
        b=nDWIVzLIP0yst3AFQlqDNtPsqJCThrW68j/ZDgsIoK51pQLuviijWNO1GiQNNGfcD4
         GYM/nmpNu2qua902e+XJlPwfEnqeyWoe4s3Vb9i0Y1jVuzJWJ0wCTnDT4WrRry0KOOdA
         1EvSk1Ml1D4JrModuEI7cV+JTr2ved0KqLeoFWDFdZZeMDm6Uui++DSXcDEHfDmoGKEn
         Amq0zZule0c9Xfswa3PJzg+CfbLGjw6SxBGdcFuUGioZRdQjUYH1XO7H/YAz36FXKc6W
         1N6fmIjiwtceyLVKbWIRc4iUOqgSuX5UaryxPThGgeLffTTL/uoZX6eCLzvFdhzYcE6M
         jPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TQzYXroMSTeC6jBkk8L8kpJ+IXUUCZH+35l1d+2iFCk=;
        b=dPDhD5XmjuIM0vZJGYs7QYHIOqrU7RlJyYwb6ROCpx1l029Mji9GpPY9TkcC/tE80+
         lCQtT0h1t3Va8sE2fYDuQvMFB5cpYF1NL1vYPBSBm/sLOS9Yz0zCplHkfL9h5Ingi/tV
         TyZVoQZ3cM/pZ+jdiKnDhuCxIYuBkvTdy4YuHlpN1f3zUATMdel/3OGrcsMQ10qri88f
         cqq8BDYhJE/vuGh3nysoGeUlJ3+Zp+ceDKH36Dfi+kjrWSGoilT0t7weocQ/VW73e8vV
         XJEgncLiwzkcY4IS6IdbnSWAhLcMdaljv5rOYC7WRVBgXLKduKLsWMVd55hslvdZKuUq
         xqyA==
X-Gm-Message-State: AO0yUKX63pv78BWjITSgXMagXp9nJI4hDIAAL1luD6y7YppT9OAvFdn+
        y/t6UZuY9YEiqAtLEjkfgweBEEj8Cz0=
X-Google-Smtp-Source: AK7set+hEkYWDn+KojTekGnWoBUk2Po7OXFgXYtmHrHkQClwpCjfHeHQHcwXrS5VyaQ6pS4PCCWQ1yqqAE0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6d4a:0:b0:500:16e8:a008 with SMTP id
 i71-20020a636d4a000000b0050016e8a008mr130045pgc.8.1676675446370; Fri, 17 Feb
 2023 15:10:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 17 Feb 2023 15:10:21 -0800
In-Reply-To: <20230217231022.816138-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230217231022.816138-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217231022.816138-12-seanjc@google.com>
Subject: [PATCH 11/12] KVM: nSVM: Use KVM-governed feature framework to track
 "vGIF enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track "virtual GIF exposed to L1" via a governed feature flag instead of
using a dedicated bit/flag in vcpu_svm.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h | 1 +
 arch/x86/kvm/svm/nested.c        | 3 ++-
 arch/x86/kvm/svm/svm.c           | 3 ++-
 arch/x86/kvm/svm/svm.h           | 7 +++----
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 93c7d840e546..b49fdabb88c4 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -13,6 +13,7 @@ KVM_GOVERNED_X86_FEATURE(V_VMSAVE_VMLOAD)
 KVM_GOVERNED_X86_FEATURE(LBRV)
 KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
 KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
+KVM_GOVERNED_X86_FEATURE(VGIF)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c38f17ba818e..c73c2acaf4c0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -648,7 +648,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
 	 */
 
-	if (svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
+	if (guest_can_use(vcpu, X86_FEATURE_VGIF) &&
+	    (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
 		int_ctl_vmcb12_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 	else
 		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b18bd0b33942..11068e8eb969 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4163,7 +4163,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (kvm_cpu_cap_has(X86_FEATURE_PFTHRESHOLD))
 		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
 
-	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
+	if (vgif)
+		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c05eea319d28..be5419975694 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -22,6 +22,7 @@
 #include <asm/svm.h>
 #include <asm/sev-common.h>
 
+#include "cpuid.h"
 #include "kvm_cache_regs.h"
 
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
@@ -257,9 +258,6 @@ struct vcpu_svm {
 	unsigned long soft_int_next_rip;
 	bool soft_int_injected;
 
-	/* optional nested SVM features that are enabled for this guest  */
-	bool vgif_enabled                 : 1;
-
 	u32 ldr_reg;
 	u32 dfr_reg;
 	struct page *avic_backing_page;
@@ -484,7 +482,8 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
 
 static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
 {
-	return svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
+	return guest_can_use(&svm->vcpu, X86_FEATURE_VGIF) &&
+	       (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
 }
 
 static inline struct vmcb *get_vgif_vmcb(struct vcpu_svm *svm)
-- 
2.39.2.637.g21b0678d19-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1131477D464
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239007AbjHOUic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbjHOUiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:38:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADAFF7
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:43 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58c583f885cso13302727b3.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131842; x=1692736642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VwtSsZcreifatu5kqX13Ny2lYN44xoh9lZLAjI9CDV8=;
        b=AmAafd7qRjGmX/mLXgqNgydSCc9aK6NcG30m1fuahWAHRHqvFlIbpCKPn+NV6I5UVF
         OFG34PdV66G+P3lRdo3c1y7tJzczc0T1F6szwbEAaFLi3/wpayPhLYeg25cUaa8PhtsI
         rcMZxEuEFj092/IFMueABKOaw6IGtwFU48abuvfsvlDZo2QNoSY+a9h6ywJAIhJj3JsS
         +Hkq4kJZLeYxqWAg+kNPeCFpOkK3axC8bfUC6JTGpBQX17ELYbMghqFqX6Xao0AWByP5
         4nVc2Y2GWh9r2Vh1SEvdlERQ5o5yDm30+H+IDd6P4qCJNiaK+toyaviGrU7zakTQGJyL
         56Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131842; x=1692736642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VwtSsZcreifatu5kqX13Ny2lYN44xoh9lZLAjI9CDV8=;
        b=h2fbW8VD8jVRUadQJQze7LAUx1Zl6Y7JcFkyK3q6wNtcnJ+IlX/o0ng0baR9iNFa3i
         HUvjwjPtIHr7zIUDLuXQhZfqMm8u1mtdWRMB7apCNeyUkeG1jmmQhV2uHzS8jivV+Hfu
         /cU3k5tBliEVnWSHyBrJtvspj7O9qXn4HFuIt3/BFyAzjmaL4coZDURiL9AGDrhAty4p
         5f+SSY68AR0NuCNMkzSPFXvkPr9ZyY8w282i1U33dr76Iwp2QNPaXxUvCwgj8TiMi+xj
         AH6HbSmwjFsbKsDJWCZMEwHF2+AcKM4nS/V07iFpo2CalNFCLNNBCN1JwhL2GbM7xdRx
         kLIw==
X-Gm-Message-State: AOJu0YyJQj7vsWzLwtoZOUJYOGpX432zZJeHQMmPQckoMHxYVb9Kpx7/
        lpa0Otrp1PkYmncm7UXzvrWZ2T9rjwQ=
X-Google-Smtp-Source: AGHT+IEg51nJ1FSI9AYLBI/nqW4Ys6jGGyoFtvJP9mNyIiW2JZRRrW9LZzRJC7GQGVWIqdNrI6plVPfgu5M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2683:0:b0:d62:7f3f:621d with SMTP id
 m125-20020a252683000000b00d627f3f621dmr188998ybm.11.1692131842554; Tue, 15
 Aug 2023 13:37:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:52 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-15-seanjc@google.com>
Subject: [PATCH v3 14/15] KVM: nSVM: Use KVM-governed feature framework to
 track "vNMI enabled"
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track "virtual NMI exposed to L1" via a governed feature flag instead of
using a dedicated bit/flag in vcpu_svm.

Note, checking KVM's capabilities instead of the "vnmi" param means that
the code isn't strictly equivalent, as vnmi_enabled could have been set
if nested=false where as that the governed feature cannot.  But that's a
glorified nop as the feature/flag is consumed only by paths that are
gated by nSVM being enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h | 1 +
 arch/x86/kvm/svm/svm.c           | 3 +--
 arch/x86/kvm/svm/svm.h           | 5 +----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 368696c2e96b..423a73395c10 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -15,6 +15,7 @@ KVM_GOVERNED_X86_FEATURE(LBRV)
 KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
 KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
 KVM_GOVERNED_X86_FEATURE(VGIF)
+KVM_GOVERNED_X86_FEATURE(VNMI)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9eac0ad3403e..a139c626fa8b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4303,8 +4303,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
-
-	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_VNMI);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VNMI);
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index eaddaac6bf18..2237230aad98 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -259,9 +259,6 @@ struct vcpu_svm {
 	unsigned long soft_int_next_rip;
 	bool soft_int_injected;
 
-	/* optional nested SVM features that are enabled for this guest  */
-	bool vnmi_enabled                 : 1;
-
 	u32 ldr_reg;
 	u32 dfr_reg;
 	struct page *avic_backing_page;
@@ -495,7 +492,7 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 
 static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
 {
-	return svm->vnmi_enabled &&
+	return guest_can_use(&svm->vcpu, X86_FEATURE_VNMI) &&
 	       (svm->nested.ctl.int_ctl & V_NMI_ENABLE_MASK);
 }
 
-- 
2.41.0.694.ge786442a9b-goog


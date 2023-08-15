Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685B877D462
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbjHOUi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239084AbjHOUiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:38:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AA42114
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:42 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bdf1994d0cso21673175ad.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131840; x=1692736640;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=T8HV7UgIa1dG2H5Sf/ED5TJcqQr5XJgF9Itu7yEIR4Q=;
        b=eRl6rED/Pj2iZDULtLilXVj59YR7XMUFqHnszIcxYB5GnQ+iWW9mAG9veo0hrSniC/
         9QNra63TT3K0jSUT+FxdTV6Ddex/szHO6sFqpBLz3S6BwCVN6bqODIWqR8dLiaFClgER
         J/1jxVz9oU0Wiau77mexr81UK3oI/uAVpyHD71+khbEqeJszPPlDzM1m+ZsgFF+g7U7d
         IkTJZo+Ug6ezuIT1dkaCx/ACl0e8DmJro07eeJgBXef5tdWaMxcBYf+1wUF3xS+Ji0PW
         iKu972u8veilFphQuTnxZwg9pHVo1kmQn2pMH1Z4m+eb/Cxopj2WSPsDT8FvW/LlU1hp
         NRtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131840; x=1692736640;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T8HV7UgIa1dG2H5Sf/ED5TJcqQr5XJgF9Itu7yEIR4Q=;
        b=dTOjat/5kUTTww+jBC7TMZjpQZR4EPSCGfjq8naW3MJKbPzN4I+oVJuntAylF9pwID
         DLRZAJnt5rlP6sM0if57xtAyVUaPxU1bbhlLiAvY6WcXSbliamaqx5mmwPhVF1fFUoc0
         hFvaqU0UJAWbuXdTiAJhJmuA9y5nU5aIFBXgXu5i4UJB9bjkbLQEy0/VFu4dc9Kt1aH2
         w4est41OwaEIOuXatxdG4E36Lb0MhvK15cBbA4lFhQf1wf2ZhV8Eh/3TUxt/xF82bx5c
         8jpXuhlXXIX94trc7iBKmsCiAK7vj6NBhnpWA6thOlLBNL0cTGW1d5G7ynbmVewCBUWo
         qD5g==
X-Gm-Message-State: AOJu0YzYwJu1INrdNnalHaEs4FeZIm3yReKTjfjTHRIygJtkIRHDzZC0
        M/rJAAJ/xniBagDoy3W23cNK7ZO+ZdA=
X-Google-Smtp-Source: AGHT+IFBBFSCSZHMid9QQ0CZPxzLqvzwEiYVZ9f1w0QfrdjyI6Rw65m/hlyGdz+4GDRzt0C902bFASlnFvY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f54e:b0:1b9:d335:1742 with SMTP id
 h14-20020a170902f54e00b001b9d3351742mr5767760plf.11.1692131840421; Tue, 15
 Aug 2023 13:37:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:51 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-14-seanjc@google.com>
Subject: [PATCH v3 13/15] KVM: nSVM: Use KVM-governed feature framework to
 track "vGIF enabled"
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

Track "virtual GIF exposed to L1" via a governed feature flag instead of
using a dedicated bit/flag in vcpu_svm.

Note, checking KVM's capabilities instead of the "vgif" param means that
the code isn't strictly equivalent, as vgif_enabled could have been set
if nested=false where as that the governed feature cannot.  But that's a
glorified nop as the feature/flag is consumed only by paths that are

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h | 1 +
 arch/x86/kvm/svm/nested.c        | 3 ++-
 arch/x86/kvm/svm/svm.c           | 3 +--
 arch/x86/kvm/svm/svm.h           | 5 +++--
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 9afd34f30599..368696c2e96b 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -14,6 +14,7 @@ KVM_GOVERNED_X86_FEATURE(V_VMSAVE_VMLOAD)
 KVM_GOVERNED_X86_FEATURE(LBRV)
 KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
 KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
+KVM_GOVERNED_X86_FEATURE(VGIF)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ac03b2bc5b2c..dd496c9e5f91 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -660,7 +660,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
 	 */
 
-	if (svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
+	if (guest_can_use(vcpu, X86_FEATURE_VGIF) &&
+	    (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
 		int_ctl_vmcb12_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 	else
 		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9bfff65e8b7a..9eac0ad3403e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4302,8 +4302,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
-
-	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
 
 	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_VNMI);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d57a096e070a..eaddaac6bf18 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -22,6 +22,7 @@
 #include <asm/svm.h>
 #include <asm/sev-common.h>
 
+#include "cpuid.h"
 #include "kvm_cache_regs.h"
 
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
@@ -259,7 +260,6 @@ struct vcpu_svm {
 	bool soft_int_injected;
 
 	/* optional nested SVM features that are enabled for this guest  */
-	bool vgif_enabled                 : 1;
 	bool vnmi_enabled                 : 1;
 
 	u32 ldr_reg;
@@ -443,7 +443,8 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
 
 static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
 {
-	return svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
+	return guest_can_use(&svm->vcpu, X86_FEATURE_VGIF) &&
+	       (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
 }
 
 static inline struct vmcb *get_vgif_vmcb(struct vcpu_svm *svm)
-- 
2.41.0.694.ge786442a9b-goog


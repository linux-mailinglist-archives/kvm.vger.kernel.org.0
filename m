Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3247E6FFD59
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbjEKXeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239600AbjEKXeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:34:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EFC61B3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:34:03 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9a75194eebso11457262276.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683848043; x=1686440043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3SaHwYEbuDBGE2GkNVn0nUXWR/dUffqKjw9nfTur2e0=;
        b=azTYuOeMwkjRdRGvY2tkEm8mIWO3uiXKb8TEZWxqgdMKxgvivF0rVoBMQv3TkBtBBs
         dsI2mSzVifPR+40xtIyraTQ5C04mCD/anwqN5rq9NYANplpBl7X4I2y10mT4kBuTyNSC
         MzkAmn2QGmnpNG/HphgKY6OR2FA86nlHdjWo2y/KVpJI1VZ7RUtl7glezHZtZeKTEjsB
         YOmirNZvwfUB99+a1JZQdbC3/ghfRhtMqZPOX6Bc+dqpO7zn2aMka9BvX6rEl1S570Bt
         mX6pB+8e0Aava0hcMaK2IRqnwSvg/+u1gqrLnBM/dWxJAvLfjbk7oyf561ur8fxmpXZX
         4p7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848043; x=1686440043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3SaHwYEbuDBGE2GkNVn0nUXWR/dUffqKjw9nfTur2e0=;
        b=eoZe+NNXRnaWKfms4rotIibTpv+s7kpzNul/HmWOvIYI9dU8xVfPC7dPtW3r0x2QGn
         2/5ODRTnu/o4EexSQlCtuCH59XzSgdojvCcpDy/SSuJge/RT8ZhYcCCICth2vKADEZsj
         9N2E1oalunwCrqSTVHrh6Zq0IvbQJGNu3HbJVMjc7Zp5pJ/E+wWms4TrFJQRKcxOS7ve
         Pjgy9r7nreASuqvkIvWjEDI4G9XSPN1JaRSUSPc6EulWPfFXD1DkNi++dlErtl8zZuF4
         RE6lgjIz0/kWcTiJMk4Up5l+mszyH7f7eLuAOYkWmC0YCHFJT2hZSmWTr0UiJMaseI0r
         TT7Q==
X-Gm-Message-State: AC+VfDzsYi+MW/hgxIhMmmQ5H9qfcIm7FlLUZOGWOTtrOHtwuSCCcs/V
        dSazJ4JQGE3xIFLTRR+djLP/zGu2TiY=
X-Google-Smtp-Source: ACHHUZ79iIJdti9njQxhjICrxyA5WlMJlaeg16Xk10A9nqWOboU+SIaGH2Ro8UG0drmCMy8PtlTq7U2xk1o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:11c9:b0:b9d:ed0f:b9db with SMTP id
 n9-20020a05690211c900b00b9ded0fb9dbmr14291341ybu.6.1683848043038; Thu, 11 May
 2023 16:34:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:33:48 -0700
In-Reply-To: <20230511233351.635053-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511233351.635053-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511233351.635053-6-seanjc@google.com>
Subject: [PATCH v2 5/8] KVM: x86: Use MTRR macros to define possible MTRR MSR ranges
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
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

Use the MTRR macros to identify the ranges of possible MTRR MSRs instead
of bounding the ranges with a mismash of open coded values and unrelated
MSR indices.  Carving out the gap for the machine check MSRs in particular
is confusing, as it's easy to incorrectly think the case statement handles
MCE MSRs instead of skipping them.

Drop the range-based funneling of MSRs between the end of the MCE MSRs
and MTRR_DEF_TYPE, i.e. 0x2A0-0x2FF, and instead handle MTTR_DEF_TYPE as
the one-off case that it is.

Extract PAT (0x277) as well in anticipation of dropping PAT "handling"
from the MTRR code.

Keep the range-based handling for the variable+fixed MTRRs even though
capturing unknown MSRs 0x214-0x24F is arguably "wrong".  There is a gap in
the fixed MTRRs, 0x260-0x267, i.e. the MTRR code needs to filter out
unknown MSRs anyways, and using a single range generates marginally better
code for the big switch statement.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mtrr.c |  7 ++++---
 arch/x86/kvm/x86.c  | 10 ++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 59851dbebfea..dc213b940141 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -34,7 +34,7 @@ static bool is_mtrr_base_msr(unsigned int msr)
 static struct kvm_mtrr_range *var_mtrr_msr_to_range(struct kvm_vcpu *vcpu,
 						    unsigned int msr)
 {
-	int index = (msr - 0x200) / 2;
+	int index = (msr - MTRRphysBase_MSR(0)) / 2;
 
 	return &vcpu->arch.mtrr_state.var_ranges[index];
 }
@@ -42,7 +42,7 @@ static struct kvm_mtrr_range *var_mtrr_msr_to_range(struct kvm_vcpu *vcpu,
 static bool msr_mtrr_valid(unsigned msr)
 {
 	switch (msr) {
-	case 0x200 ... 0x200 + 2 * KVM_NR_VAR_MTRR - 1:
+	case MTRRphysBase_MSR(0) ... MTRRphysMask_MSR(KVM_NR_VAR_MTRR - 1):
 	case MSR_MTRRfix64K_00000:
 	case MSR_MTRRfix16K_80000:
 	case MSR_MTRRfix16K_A0000:
@@ -88,7 +88,8 @@ bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	}
 
 	/* variable MTRRs */
-	WARN_ON(!(msr >= 0x200 && msr < 0x200 + 2 * KVM_NR_VAR_MTRR));
+	WARN_ON(!(msr >= MTRRphysBase_MSR(0) &&
+		  msr <= MTRRphysMask_MSR(KVM_NR_VAR_MTRR - 1)));
 
 	mask = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 	if ((msr & 1) == 0) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7f78fe79b32..8b356c9d8a81 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3700,8 +3700,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		}
 		break;
-	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
-	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
+	case MSR_IA32_CR_PAT:
+	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
+	case MSR_MTRRdefType:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
 		return kvm_set_apic_base(vcpu, msr_info);
@@ -4108,9 +4109,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = kvm_scale_tsc(rdtsc(), ratio) + offset;
 		break;
 	}
+	case MSR_IA32_CR_PAT:
 	case MSR_MTRRcap:
-	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
-	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
+	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
+	case MSR_MTRRdefType:
 		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
 	case 0xcd: /* fsb frequency */
 		msr_info->data = 3;
-- 
2.40.1.606.ga4b1b128d6-goog


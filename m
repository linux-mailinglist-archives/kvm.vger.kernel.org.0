Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7379B6F5DEC
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 20:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjECS3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 14:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjECS3L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 14:29:11 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F9F7D98
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 11:29:03 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-55a1aec6693so73557057b3.1
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 11:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683138543; x=1685730543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bcUuJsmnNf1FE7EU8eKP0IPIgfKzwZXNJofkM8/MGEI=;
        b=0xWagrPwWS6KtZvncnYm+PQ1pC+fpjXwRTFHojXSiK4uCSQMd4zFwJsSHuDj1xngtw
         X70UtcGdZoTNm6sMNGsoYBdAg3rwStYXTsruvK0NzgmClrr33et/0m7gbrxNpYDLsIVS
         Mm6fiPPmS8lXwJoP3lX4/N0/MkHsMpSWqCzD0dQ/Ot8CitX06ZQbc/760jgIAa1KHVcO
         33ST7LSGDTibEQwzj1Y9IBQlOCQ6eZsCel6Qsx6n57mnjKkNFHEtCqorrrZkB/kWq6TL
         plHi0VohADz3vEt2ZBATmqMV3d5rr62rcv0mmKXKL5Vk230w6Pi3RrwZUdhS4BFJOI+l
         H2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683138543; x=1685730543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bcUuJsmnNf1FE7EU8eKP0IPIgfKzwZXNJofkM8/MGEI=;
        b=UgFqvG5REtZjePkCmzN0yLqAmrfZLJ4yd/hstLCnCZP516E74it5Rj8+jitGUXyVYe
         kWDxeGmGWsYln7zC5eojDS2RFAwox8Lzl3Yzr3oXStp6rXSF8OJFDVI/yk3xtk1nRtr2
         MYZXUQcxfoxIzYkCPrmz53MnKkO493lzAXe16HDt+fedWZtTs7V3MtG5peFJxu4Uha0b
         zZakMuTl832I2kBI7ISNW2XfNePU9hMz/QGiiss+x7oYlXXNa+8TKGLLnXyaPjRmeWZI
         ld16R/I194Bn7oCaU0rztu4La5Ro0JCwPFMV2T53nr9mJdlXWcy0w1LFpIsSXWs6DZ1J
         9teQ==
X-Gm-Message-State: AC+VfDzjnSWPs8RnovncO84Y0yVFdj056noSmcVAVFU4AMkTXpZ0gujy
        OUnZydX0onncIF3TU49Oh/tK4djre54=
X-Google-Smtp-Source: ACHHUZ5yBw+H5JFnlvjHVMd9MoBmVM7glR0pGbMbbeUTU9PaTeJ0Bxw15VjcwtQnkLers1iFUq4hwAvPdXg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4007:0:b0:545:1d7f:acbf with SMTP id
 l7-20020a814007000000b005451d7facbfmr12675966ywn.10.1683138543201; Wed, 03
 May 2023 11:29:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 May 2023 11:28:50 -0700
In-Reply-To: <20230503182852.3431281-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503182852.3431281-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: x86: Use MTRR macros to define possible MTRR MSR ranges
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
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
 arch/x86/kvm/mtrr.c |  2 +-
 arch/x86/kvm/x86.c  | 10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 9fac1ec03463..d2c428f4ae42 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -28,7 +28,7 @@
 static bool msr_mtrr_valid(unsigned msr)
 {
 	switch (msr) {
-	case 0x200 ... 0x200 + 2 * KVM_NR_VAR_MTRR - 1:
+	case MTRRphysBase_MSR(0) ... MTRRphysMask_MSR(KVM_NR_VAR_MTRR - 1):
 	case MSR_MTRRfix64K_00000:
 	case MSR_MTRRfix16K_80000:
 	case MSR_MTRRfix16K_A0000:
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
2.40.1.495.gc816e09b53d-goog


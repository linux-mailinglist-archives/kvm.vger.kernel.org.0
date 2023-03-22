Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09DD6C3F98
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjCVBQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjCVBPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:15:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6085A6F8
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:15:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z4-20020a25bb04000000b00b392ae70300so18304776ybg.21
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679447719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CY4cnk4UOMeVTH0kQ1tQ9VzeyOFu2K0f5K2GYFhb34s=;
        b=AkqrcYEiE53LAVOgUo3cY+bXfl82+gNCSSPEEGj65pQsP74Nh5wscxPvqarY6zz8gX
         wxFFEj4sVQ55KaHHudOG4SDRtxMvI7uReX6C9FV2XQ/Kr1D1OmZn/Kzzzn2h0yJ0saqI
         JoqmsXg94qdQ2pJ5/VzpC1eYtVTUY20JIwxA80o8ZYoMjbHr5HHZx8pKe+9qsOk8FJPe
         H/SVIFvpeBwLPKZyiYdt9ta06DDjeJs1pCzvoW/rlLWhDOAoV3sIwYqJVVTJh/xgYRlC
         dY9OC0h/FG9tJKvDkkaea/P/7kzKuE1QUvgRtkl5IgPrgLUX94yW+4No4Wyc5PB/xOCB
         nvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679447719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CY4cnk4UOMeVTH0kQ1tQ9VzeyOFu2K0f5K2GYFhb34s=;
        b=W2N626913a/hU4FNNIW3EwOOHPcz8t902KI+4IzLTvFLp3+aimZNTbG68mXkaIg2g/
         uTFsV7inAyIP6v8pAHdBronPuwfkuo7NGSqPgp9Y2fgVCmzBWEUh568cIqEXD6evbAck
         o0PfIgxxw8QcvkNrgDP1OVTAiaixD+EjasWeo83z97l307QaPA1xGrf5yZLPr2+NLrWu
         /Be4pdSKfrkX++68SaLiHa/GtgS37NTVTGCokWRN13lmm4dUUtLedtIm+ttA0mnJ96cX
         V9nqaZruyZagf2r3fdaTm/dKEUfqxu4qCnaXLdMBlryilKvlD51rWMPClWq0TaiC22qK
         3Udw==
X-Gm-Message-State: AAQBX9dyswOQ8K4kLP5yVoT4VRNreywTWrnjjHHl/fKhCr+rbmolugTK
        4IqQy8vMknds5kyF3WoOTXtP3prJcvM=
X-Google-Smtp-Source: AKy350Z1Pz7Il1MvE5au3oW5jW3Jfl7nOGY73wWqSaw4J9IQh/AUgbMNAONy8q9hsNO8ETNgRFoyd6JFKe8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:820d:0:b0:a27:3ecc:ffe7 with SMTP id
 q13-20020a25820d000000b00a273eccffe7mr361394ybk.3.1679447719213; Tue, 21 Mar
 2023 18:15:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Mar 2023 18:14:36 -0700
In-Reply-To: <20230322011440.2195485-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230322011440.2195485-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230322011440.2195485-3-seanjc@google.com>
Subject: [PATCH 2/6] KVM: VMX: Passthrough MSR_IA32_PRED_CMD based purely on
 host+guest CPUID
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Passthrough MSR_IA32_PRED_CMD based purely on whether or not the MSR is
supported and enabled, i.e. don't wait until the first write.  There's no
benefit to deferred passthrough, and the extra logic only adds complexity.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f777509ecf17..5c01c76c0d45 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2298,19 +2298,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			break;
 
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
-
-		/*
-		 * For non-nested:
-		 * When it's written (to non-zero) for the first time, pass
-		 * it through.
-		 *
-		 * For nested:
-		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_prepare_msr_bitmap. We should not touch the
-		 * vmcs02.msr_bitmap here since it gets completely overwritten
-		 * in the merging.
-		 */
-		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
 		break;
 	case MSR_IA32_CR_PAT:
 		if (!kvm_pat_valid(data))
@@ -7743,6 +7730,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
 					  !guest_cpuid_has(vcpu, X86_FEATURE_XFD));
 
+	if (boot_cpu_has(X86_FEATURE_IBPB))
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
+					  !guest_has_pred_cmd_msr(vcpu));
 
 	set_cr4_guest_host_mask(vmx);
 
-- 
2.40.0.rc2.332.ga46443480c-goog


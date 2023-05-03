Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D2F6F5DE8
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 20:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjECS3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 14:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjECS3B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 14:29:01 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BE32680
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 11:29:00 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64115e69e1eso4794751b3a.0
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 11:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683138539; x=1685730539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HR9sDhe1dBWwYsQO66isTNLen+QloTOYlqac4Dib2S0=;
        b=RpPim3urdDOUWuJ3wzy0utodCmxX0rjPl4mUUzwsMX1hw3s9PCKBeD92U/Flg1VcXo
         BMbqTLLdj3Gx+nc7TzpBr5JLhosnACTWbU/0TivFrLub70MDUpfAHs0InFAoISRRSUp5
         4NlW5AgbyWlxTr1gGf8HlzJWL6KgxFkdynlz8+tHNMBJJlw7ATdALt5US3SEahkdNYd1
         dIwiZLYlUblywLajLjSm/9axWRGxsCEhBzqFau67BCzEzwvURmB17++fg+byQc22wiYq
         iMsyTypPoYLBkHF5sXZ4TQC3Zsjq1YTb/kirR7uPmKL81tsozyRZG93BvGjGArcBuy/8
         xDtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683138539; x=1685730539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HR9sDhe1dBWwYsQO66isTNLen+QloTOYlqac4Dib2S0=;
        b=jpqBC1tKS8LiDRZmbe6svIEFGjr+u77otfi+76gp6qvCV10OMUB9WfUVyPMsrf9yLw
         FwdHSznLyQ8g2OT3EWcg7zZM9EYlUkl7/Anm2YCiJfrGx1glHeUGCJMaDwB+B64WtmIf
         Cd1EJemNI3x0QmAmWn71CaJkmy3I0az6XzjqKUUkbjo+aoBzOP4xqUKMLuLvXJ91DRGR
         Cov5Uggb3aCqNEfMX8uJH7QLF9VeNMeq3Xbm9XWJnxj9AaYeA5M+5HjA5Ct8fkxuRlgv
         vwtlekqDRVC0AE8ymn5fvecDFY/lDCvyxpRyAFb7UKOnBuVIl0l1qXmXkafe8ip8VVOZ
         SwuA==
X-Gm-Message-State: AC+VfDyaVmIRNlsvYvsv++bKINlUzQYjPzNy9sU+TdvTp+84Yc0YoWcW
        SPjFFwAgVN8msiqNW578PVyrDtnIrVY=
X-Google-Smtp-Source: ACHHUZ5vnASrY3rkukhJSdTxihZ9oIFdZd4vjgC2U7Dd72NAC5HyWufuYAK64L7jBvjgUGjqegNa8gPOV8U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2c14:0:b0:51a:7d6a:65c9 with SMTP id
 s20-20020a632c14000000b0051a7d6a65c9mr714454pgs.6.1683138539464; Wed, 03 May
 2023 11:28:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 May 2023 11:28:48 -0700
In-Reply-To: <20230503182852.3431281-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503182852.3431281-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: VMX: Open code writing vCPU's PAT in VMX's MSR handler
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

From: Wenyao Hai <haiwenyao@uniontech.com>

Open code setting "vcpu->arch.pat" in vmx_set_msr() instead of bouncing
through kvm_set_msr_common() to get to the same code in kvm_mtrr_set_msr().

Note, MSR_IA32_CR_PAT is 0x277, and is very subtly handled by

	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:

in kvm_set_msr_common().

Signed-off-by: Wenyao Hai <haiwenyao@uniontech.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..53e249109483 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2294,12 +2294,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    get_vmcs12(vcpu)->vm_exit_controls & VM_EXIT_SAVE_IA32_PAT)
 			get_vmcs12(vcpu)->guest_ia32_pat = data;
 
-		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
+		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
 			vmcs_write64(GUEST_IA32_PAT, data);
-			vcpu->arch.pat = data;
-			break;
-		}
-		ret = kvm_set_msr_common(vcpu, msr_info);
+
+		vcpu->arch.pat = data;
 		break;
 	case MSR_IA32_MCG_EXT_CTL:
 		if ((!msr_info->host_initiated &&
-- 
2.40.1.495.gc816e09b53d-goog


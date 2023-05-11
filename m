Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0446FFD52
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbjEKXd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239538AbjEKXd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:33:57 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518675FD2
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:33:56 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1aae2223aaeso52391325ad.2
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683848036; x=1686440036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=izzWvJrvZ+wq2quseVrGnV9xDpgTViMwy/x29y6d3lY=;
        b=wPABa2//xybhgaoz98n4fU3sMtb97lbp9QoLDf5XJKyMW955uetOUGpIsxhf2D0+h1
         kn+5jyba6p1ZvP7/COis+n2CawHWe2XRffkjGaagvUbmm2HFIGP2rF6yDfs7B6b+OQtA
         +FaseZz3SixBibyBK2Hdk21BQdHgwRuIKfsf7hrMx021SjUXh2peFZPML3T1QS1uT6u1
         Y7c3aWGR5rMfVK0sfD+mc3R21HqD1m1VSKrviyxnAaXS/bO7WgypDVdI9hQ9j8g51gWb
         In3EiL1mjn50YsA1vD0/xMgDrVMpYUkrAKjfu0HBpTltWE2RZB0FT8bg3uzmIvyZWVD3
         Q3gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848036; x=1686440036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izzWvJrvZ+wq2quseVrGnV9xDpgTViMwy/x29y6d3lY=;
        b=BwW2k/PSwqMB+KS4dHAXFbPG85K5b/ZIEYFUoQOv95YAG3Z8Y+7WrBS78+JClyeb52
         HnM3UurFpW+iJpTWA8WrLmuc/IkIgo41hj/OTOjENX/G0k31h/2imNUgfNexOlXFeqDw
         2liGHnoBFZs3IYyEhgfbqgmgUCbsjavInKQbEWMn/tufLGtkZIXGCkL+cX67hovm5yd/
         3zA4D2vqO90p0+Sqp273AXQv7+Q4ecuL7FY11YiNM+pK5MTxTH14sMCgiM/Sbik6T8yw
         QZXe83sF8niNBB4YuIif7lc0ZQUcLyASFLtxxBnAEGBQrd76V78BvmhClTJ7R2pL2KqN
         g3OQ==
X-Gm-Message-State: AC+VfDzKhrlIPN1kVHJtx7bI6EVCUm4zwFt9iOoU9kuDjdNKyPEYEcUC
        Vbs2Fjr91oq0mj/ciCWZkQJMS2YA9/g=
X-Google-Smtp-Source: ACHHUZ4z9vFlYRhSJ0NltP5ziF9IsbtTYU7xD5WPPmDd/TQRrndJvLHJuVSb+rEJgxsWgdcdwUHWbOwEHC0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8f98:b0:1ad:c1ca:55ae with SMTP id
 z24-20020a1709028f9800b001adc1ca55aemr1398487plo.13.1683848035878; Thu, 11
 May 2023 16:33:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:33:44 -0700
In-Reply-To: <20230511233351.635053-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511233351.635053-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511233351.635053-2-seanjc@google.com>
Subject: [PATCH v2 1/8] KVM: VMX: Open code writing vCPU's PAT in VMX's MSR handler
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wenyao Hai <haiwenyao@uniontech.com>

Open code setting "vcpu->arch.pat" in vmx_set_msr() instead of bouncing
through kvm_set_msr_common() to get to the same code in kvm_mtrr_set_msr().
This aligns VMX with SVM, avoids hiding a very simple operation behind a
relatively complicated function call (finding the PAT MSR case in
kvm_set_msr_common() is non-trivial), and most importantly, makes it clear
that not unwinding the VMCS updates if kvm_set_msr_common() isn't a bug
(because kvm_set_msr_common() can never fail for PAT).

Opportunistically set vcpu->arch.pat before updating the VMCS info so that
a future patch can move the common bits (back) into kvm_set_msr_common()
without a functional change.

Note, MSR_IA32_CR_PAT is 0x277, and is very subtly handled by

	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:

in kvm_set_msr_common().

Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Wenyao Hai <haiwenyao@uniontech.com>
[sean: massage changelog, hoist setting vcpu->arch.pat up]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..33b8625d3541 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2290,16 +2290,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!kvm_pat_valid(data))
 			return 1;
 
+		vcpu->arch.pat = data;
+
 		if (is_guest_mode(vcpu) &&
 		    get_vmcs12(vcpu)->vm_exit_controls & VM_EXIT_SAVE_IA32_PAT)
 			get_vmcs12(vcpu)->guest_ia32_pat = data;
 
-		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
+		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
 			vmcs_write64(GUEST_IA32_PAT, data);
-			vcpu->arch.pat = data;
-			break;
-		}
-		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
 	case MSR_IA32_MCG_EXT_CTL:
 		if ((!msr_info->host_initiated &&
-- 
2.40.1.606.ga4b1b128d6-goog


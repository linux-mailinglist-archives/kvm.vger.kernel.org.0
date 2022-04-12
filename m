Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911FF4FEA54
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiDLX3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiDLX2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:28:24 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F57385964
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:32:00 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m11-20020a170902f64b00b0015820f8038fso126404plg.23
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Lah+ZaDfEmw//L0hip2rnZQuJuspeP8TeA0jB6gFnj0=;
        b=Ma0G8nIZYDMjsKmcDqFcAKG4AZn5vIx0/Dcn1mi9PF+87knaoVYpRVtBnlJW0NlGst
         9KMKdNq0RwMv/qWUEeb0Arb4EkuTWhjCRCjaAMp2hOaggtl0lWPEZpdVDIBFfQimpZsY
         ccieOg8vyPnNK7nx2n801YwHHvRSzC2hCWNtN79EMavi/CaD7y4gVfRqNNNVkw6rekaN
         k83qSgLEzP9uEDO1jc+9K/6UgbMARC1yw899sn/gEBhORqTfPOWwye72ZCQepXp6fvpg
         YD9wvDe/Jh1Q4xcwJcEeramPwjbM/fW6WkytcxNkb5orFfD9bt7Lu+1IOEMjX2nF+Lrg
         k5Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Lah+ZaDfEmw//L0hip2rnZQuJuspeP8TeA0jB6gFnj0=;
        b=fapewOQxE8MGYSFvYaCbAD0fQSNMienHhrwvO1vmPEtuWqDkHGcfz3GgdCtXWulwgz
         9Ymc6wFdsMYOkSuvLp3tCD3CoOPJ9VLwb7P56M+opuX99ewEolwmYKeqy4PD13vBwYgU
         iyyzL+vR7Xcf/5S/es17dABnvMrybWYO7YRrMnfpIiHYDyxaoZ/D7QnIchNlyhO+1ry8
         Rzppnzd4vsE2byFhY9B2QSmt/yk42AbYwSSu2JNdHd6mOPteejmJJ6kShOvrJ+ZuPBb8
         hv7zBLLRywYV6EBWlLWN3fCBV6RiZAbEwziZpRmNJGdjeLl0kXLZnFBtBZL6Aen/W88o
         41og==
X-Gm-Message-State: AOAM530TE/F3ms0dbeEEQ3lrFZgfRjSCkWc8QhmJgEs9mZTkhNsfVs+5
        rX52733HGX0+BqUAFpqi/V/B6oHv
X-Google-Smtp-Source: ABdhPJyc6OQ6HjoUKRwh8Y9T/5FFsGYGiZ7YXjZwsCCMgz6yB+3tG9AEZ3NRP1OIQEdSWRP51IE3evDr
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:6315:7654:72ee:17c3])
 (user=juew job=sendgmr) by 2002:a17:90a:858b:b0:1c6:5bc8:781a with SMTP id
 m11-20020a17090a858b00b001c65bc8781amr183631pjn.0.1649802719426; Tue, 12 Apr
 2022 15:31:59 -0700 (PDT)
Date:   Tue, 12 Apr 2022 15:31:33 -0700
In-Reply-To: <20220412223134.1736547-1-juew@google.com>
Message-Id: <20220412223134.1736547-4-juew@google.com>
Mime-Version: 1.0
References: <20220412223134.1736547-1-juew@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v2 3/4] KVM: x86: Add support for MSR_IA32_MCx_CTL2 MSRs.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Jue Wang <juew@google.com>
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

Note the support of CMCI (MCG_CMCI_P) is not enabled in
kvm_mce_cap_supported yet.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 50 +++++++++++++++++++++++++--------
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ec9830d2aabf..639ef92d01d1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -800,6 +800,7 @@ struct kvm_vcpu_arch {
 	u64 mcg_ctl;
 	u64 mcg_ext_ctl;
 	u64 *mce_banks;
+	u64 *mci_ctl2_banks;
 
 	/* Cache MMIO info */
 	u64 mmio_gva;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb4029660bd9..73c64d2b9e60 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3167,6 +3167,7 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	unsigned bank_num = mcg_cap & 0xff;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
+	u32 offset;
 
 	switch (msr) {
 	case MSR_IA32_MCG_STATUS:
@@ -3180,10 +3181,22 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.mcg_ctl = data;
 		break;
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
+		if (!(mcg_cap & MCG_CMCI_P) &&
+				(data || !msr_info->host_initiated))
+			return 1;
+		/* An attempt to write a 1 to a reserved bit raises #GP */
+		if (data & ~(MCI_CTL2_CMCI_EN | MCI_CTL2_CMCI_THRESHOLD_MASK))
+			return 1;
+		offset = array_index_nospec(
+				msr - MSR_IA32_MC0_CTL2,
+				MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);
+		vcpu->arch.mci_ctl2_banks[offset] = data;
+		break;
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = array_index_nospec(
+			offset = array_index_nospec(
 				msr - MSR_IA32_MC0_CTL,
 				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
 
@@ -3489,7 +3502,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		}
 		break;
-	case 0x200 ... 0x2ff:
+	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
+	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
 		return kvm_set_apic_base(vcpu, msr_info);
@@ -3646,6 +3660,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
 		return set_msr_mce(vcpu, msr_info);
 
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
@@ -3750,6 +3765,7 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	u64 data;
 	u64 mcg_cap = vcpu->arch.mcg_cap;
 	unsigned bank_num = mcg_cap & 0xff;
+	u32 offset;
 
 	switch (msr) {
 	case MSR_IA32_P5_MC_ADDR:
@@ -3767,10 +3783,18 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	case MSR_IA32_MCG_STATUS:
 		data = vcpu->arch.mcg_status;
 		break;
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
+		if (!(mcg_cap & MCG_CMCI_P) && !host)
+			return 1;
+		offset = array_index_nospec(
+				msr - MSR_IA32_MC0_CTL2,
+				MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);
+		data = vcpu->arch.mci_ctl2_banks[offset];
+		break;
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = array_index_nospec(
+			offset = array_index_nospec(
 				msr - MSR_IA32_MC0_CTL,
 				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
 
@@ -3873,7 +3897,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	}
 	case MSR_MTRRcap:
-	case 0x200 ... 0x2ff:
+	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
+	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
 		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
 	case 0xcd: /* fsb frequency */
 		msr_info->data = 3;
@@ -3989,6 +4014,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
 		return get_msr_mce(vcpu, msr_info->index, &msr_info->data,
 				   msr_info->host_initiated);
 	case MSR_IA32_XSS:
@@ -4737,12 +4763,12 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 		goto out;
 	r = 0;
 	vcpu->arch.mcg_cap = mcg_cap;
-	/* Init IA32_MCG_CTL to all 1s */
-	if (mcg_cap & MCG_CTL_P)
-		vcpu->arch.mcg_ctl = ~(u64)0;
-	/* Init IA32_MCi_CTL to all 1s */
-	for (bank = 0; bank < bank_num; bank++)
+	/* Init IA32_MCi_CTL to all 1s, IA32_MCi_CTL2 to all 0s */
+	for (bank = 0; bank < bank_num; bank++) {
 		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
+		if (mcg_cap & MCG_CMCI_P)
+			vcpu->arch.mci_ctl2_banks[bank] = 0;
+	}
 
 	static_call(kvm_x86_setup_mce)(vcpu);
 out:
@@ -11126,9 +11152,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		goto fail_free_lapic;
 	vcpu->arch.pio_data = page_address(page);
 
-	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
+	vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
+				       GFP_KERNEL_ACCOUNT);
+	vcpu->arch.mci_ctl2_banks = kcalloc(KVM_MAX_MCE_BANKS, sizeof(u64),
 				       GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.mce_banks)
+	if (!vcpu->arch.mce_banks | !vcpu->arch.mci_ctl2_banks)
 		goto fail_free_pio_data;
 	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
 
-- 
2.35.1.1178.g4f1659d476-goog


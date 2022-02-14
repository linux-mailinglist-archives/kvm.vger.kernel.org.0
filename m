Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3AA4B4259
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbiBNHBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:01:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241111AbiBNHBQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:01:16 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF52F58E6C
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:09 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 7-20020aa79247000000b004cdd523525eso11090894pfp.19
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WYuhkQ1f9dyamGY/Zm/EszPZUHJciigBEFscTFR6Bbw=;
        b=bbqD228uP706InbH2h7WhJkjP0aAamFk6IHT3n76f+VHZ+W/H4+ENS0JrfgQZL1YAK
         rcjRdAC6qf4WWs0/bAGyzacIBmradolt+LB0UbbUEYPe6dxQ3oLRJ4TFE4IzY5zWOpfV
         RenjpPlONHGgGah8xZ+qo1qLNBxBoQPxlUQ1S9lnvRlZLjS4hbgYe9fmKV+P4Pe8DbNA
         w8XjztpgpFlmkHuTQedWE56kbeLYzQsEJ06G8MgCL3M/NH2CktBkOxGrqGyt4aqjTvUZ
         FrDWnVzmwBCZkIsgjQvNFPIOwucfK1af2me7YOWIsfr6/5WxaFAafdBnW9RXxQFQ4KN6
         phqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WYuhkQ1f9dyamGY/Zm/EszPZUHJciigBEFscTFR6Bbw=;
        b=1G8SiDyfcsGiAd1Zeph7wUy+j/9yacRVdYtyvZTYUitlyLj8Bknufj+dJ/03Th8Gbu
         +EYb0Or1qzMH15KQTPBSrK+5G5FOrNkdNu5luCjRg3voJW/l9KgM/8KDHNtPmT9EKAnw
         CqAHeVfOGtNiuMSOjI57fC40ShldG0nB1y1H/MXw3QPLjR3Q0nKqewpmxCRcsbnb/zyQ
         xGUhAHc6uJV34STWfwK3W/iR0cr7KSL4173qs2pbfnvOOHVLEmU8rCwWngZXKtUm8/1w
         YFfgiIqWZ3pInLjV8f/Et0uA61+Vw6d21Mu6cucnDU5To5ZYNA8VHjkxVYi7o12NV+3I
         sJ4g==
X-Gm-Message-State: AOAM533S9y5nUEOSsedP4LMAlm9D7+sCKid1NYgZUJT7rtffjptzq0hs
        ABxa3dLaKgIH+VOoSGiyhWHLxhwGJI0=
X-Google-Smtp-Source: ABdhPJzR9/E9zp9+mkiJY/7Sg226qKOMdx/CNBGfWEk2e+hbHLK+Z+McJBJzuxOgwkWIepeZPXePrEjL9XA=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:13c5:: with SMTP id
 s5mr13311018pjf.181.1644822069118; Sun, 13 Feb 2022 23:01:09 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:38 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-20-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 19/27] KVM: arm64: Use vcpu->arch.mdcr_el2 to track value
 of mdcr_el2
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

Track the baseline guest value for mdcr_el2 in struct kvm_vcpu_arch.
Use this value when setting mdcr_el2 for the guest.

Currently this value is unchanged, but the following patches will set
trapping bits based on features supported for the guest.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 16 ++++++++++++++++
 arch/arm64/kvm/arm.c             |  1 +
 arch/arm64/kvm/debug.c           | 13 ++++---------
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8ab6ea038721..4b2ac9e32a36 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -333,6 +333,22 @@
 				 BIT(18) |		\
 				 GENMASK(16, 15))
 
+/*
+ * The default value for the guest below also clears MDCR_EL2_E2PB_MASK
+ * and MDCR_EL2_E2TB_MASK to disable guest access to the profiling and
+ * trace buffers.
+ */
+#define MDCR_GUEST_FLAGS_DEFAULT				\
+	(MDCR_EL2_TPM  | MDCR_EL2_TPMS | MDCR_EL2_TTRF |	\
+	 MDCR_EL2_TPMCR | MDCR_EL2_TDRA | MDCR_EL2_TDOSA)
+
+/* Bits that are copied from vcpu->arch.mdcr_el2 to set mdcr_el2 for guest. */
+#define MDCR_GUEST_FLAGS_TRACKED_MASK				\
+	(MDCR_EL2_TPM  | MDCR_EL2_TPMS | MDCR_EL2_TTRF |	\
+	 MDCR_EL2_TPMCR | MDCR_EL2_TDRA | MDCR_EL2_TDOSA |	\
+	 (MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT))
+
+
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
 #define FSC_ACCESS	ESR_ELx_FSC_ACCESS
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7bb744bb23ce..ce7229010a78 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1182,6 +1182,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
+	vcpu->arch.mdcr_el2 = MDCR_GUEST_FLAGS_DEFAULT;
 	if (has_vhe())
 		vcpu->arch.cptr_el2 = CPTR_EL2_VHE_GUEST_DEFAULT;
 	else
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index db9361338b2a..83330968a411 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -84,16 +84,11 @@ void kvm_arm_init_debug(void)
 static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
-	 * to disable guest access to the profiling and trace buffers
+	 * Keep the vcpu->arch.mdcr_el2 bits that are specified by
+	 * MDCR_GUEST_FLAGS_TRACKED_MASK.
 	 */
-	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
-	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
-				MDCR_EL2_TPMS |
-				MDCR_EL2_TTRF |
-				MDCR_EL2_TPMCR |
-				MDCR_EL2_TDRA |
-				MDCR_EL2_TDOSA);
+	vcpu->arch.mdcr_el2 &= MDCR_GUEST_FLAGS_TRACKED_MASK;
+	vcpu->arch.mdcr_el2 |= __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
 
 	/* Is the VM being debugged by userspace? */
 	if (vcpu->guest_debug)
-- 
2.35.1.265.g69c8d7142f-goog


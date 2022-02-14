Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2804B423A
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 07:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240980AbiBNG72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 01:59:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240976AbiBNG71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 01:59:27 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9898C575DD
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 22:59:19 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id b9-20020a17090aa58900b001b8b14b4aabso11501283pjq.9
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 22:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nFKWm08/SB0d1ggvgDB8huKOebJguFEKlgavW3DhhV4=;
        b=SOWCDC49txblCKM7OcSGkDgPljb9jONYJiHVoeUuZ56PTzt2rs3EFqAWPpqr+nGeA2
         gkrUnT4xd5S3SJ2gluMqYUAUse6VME5NQ8dyIXWFn47qUH6MiNcFiQ7BiV6qRmf/vmyK
         e/R7NaRt+xXPMCQMJoJb7JEOWaR7iLQKGr2dp3eEN0cmECwg1LX322YmJIPhW0Jmapmn
         qolXdtQFRvX2akhBM3XpoSqBAeyMFFrjI4AiIi1Zd85cQ1zHNLI48OGPDUGpbYGRVfS9
         T5NWsskLzyDzORA/maWh797SmjqRSzGErm/95RKIFSiideKmVoIQ7SmdQ6j6ZJ6Tn4u/
         Hd6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nFKWm08/SB0d1ggvgDB8huKOebJguFEKlgavW3DhhV4=;
        b=QLZp7fsHmzSgSz2ea3pCWsYGBdYE5G8rDlOwc11PKVnYCnLuErlwfZL++n7dpTqqsQ
         OzhTfvTlhlZ1lxeOyRbywerV1ZjB0uUhZ3BfAVfibbytjsARjFjJ2t3MK0wvgflrstLN
         aIFaD0gdnzs5oEX9aFwEbzCIEpREi+N6a8bPBeOdzVsHZlog5aJQfeU9T+JxwyFE6HW9
         xBFOuhi1Gzp8M5AmTETjnWvomB5G2H5mM0nM0z5ighAiQmgRQf8gliiTd5plrDpsMqfh
         F88O0z6g6QyJa1biHRGIPuOhfsM14+7kOOPiPHuUWySSi4RdvIW68jOLRKjPSAgMDXED
         L8eg==
X-Gm-Message-State: AOAM532VtLkjcRNgox5CPK5vxzdYymzATVdmVfjsMzn5iPeHUVv2mYDU
        3bOXn3w+OLkRz6L+Bg4DuOak06uX9nI=
X-Google-Smtp-Source: ABdhPJx2Ec/+nsYcWA84TY73qEpvM2PGqi5gbUk1tbJNdJx+hg4p8r62EcMY+Q+HnKZCTC5AQjivum7e1yM=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1514:: with SMTP id
 q20mr13246603pfu.82.1644821958877; Sun, 13 Feb 2022 22:59:18 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:24 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-6-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 05/27] KVM: arm64: Make ID_AA64PFR1_EL1 writable
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

This patch adds id_reg_info for ID_AA64PFR1_EL1 to make it writable
by userspace.

Return an error if userspace tries to set MTE field of the register
to a value that conflicts with KVM_CAP_ARM_MTE configuration for
the guest.
Skip fractional feature fields validation at present and they will
be handled by the following patches.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 arch/arm64/kvm/sys_regs.c       | 42 +++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index bfdf32ff5985..b7fb26f5a8f8 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -816,6 +816,7 @@
 #define ID_AA64PFR0_GIC3		0x1
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
 #define ID_AA64PFR1_RASFRAC_SHIFT	12
 #define ID_AA64PFR1_MTE_SHIFT		8
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 14df7c112e57..b41e9662736d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -372,6 +372,21 @@ static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_info *id_reg, u64 val)
+{
+	bool kvm_mte = kvm_has_mte(vcpu->kvm);
+	unsigned int mte;
+
+	mte = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR1_MTE_SHIFT);
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT. */
+	if (kvm_mte ^ (mte > 0))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -403,12 +418,24 @@ static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_aa64pfr1_el1_info(struct id_reg_info *id_reg)
+{
+	if (!system_supports_mte())
+		id_reg->vcpu_limit_val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
+}
+
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
 					 const struct id_reg_info *idr)
 {
 	return vcpu_has_sve(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
 }
 
+static u64 vcpu_mask_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu,
+					 const struct id_reg_info *idr)
+{
+	return kvm_has_mte(vcpu->kvm) ? 0 : (ARM64_FEATURE_MASK(ID_AA64PFR1_MTE));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR0_GIC),
@@ -417,6 +444,16 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 	.vcpu_mask = vcpu_mask_id_aa64pfr0_el1,
 };
 
+static struct id_reg_info id_aa64pfr1_el1_info = {
+	.sys_reg = SYS_ID_AA64PFR1_EL1,
+	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
+		       ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
+		       ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
+	.init = init_id_aa64pfr1_el1_info,
+	.validate = validate_id_aa64pfr1_el1,
+	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -427,6 +464,7 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
@@ -1351,10 +1389,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		val &= ~(id_reg->vcpu_mask(vcpu, id_reg));
 
 	switch (id) {
-	case SYS_ID_AA64PFR1_EL1:
-		if (!kvm_has_mte(vcpu->kvm))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
-- 
2.35.1.265.g69c8d7142f-goog


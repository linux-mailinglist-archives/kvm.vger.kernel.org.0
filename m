Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A294B426B
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241119AbiBNHBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:01:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241074AbiBNHBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:01:37 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E68C5F8C9
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:21 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id v14-20020a170902e8ce00b0014b48e8e498so5784726plg.2
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wbtKndzAWvCkk7WyRwv4b5BaCedyCpezxbPT2xu5RJI=;
        b=p6ujj/lKiFqYkdKFMxlHGT+Frbk0tdmmd9TniaJj8/tpMqYTDNEGFxATe8rnWIymL/
         ObEcGY34riW2pN4p5uuyMYUwl77InvEVNgVZ8rWwF5F+vdqBJ1eHv9feQIvrJ7pjHZjG
         DzKl1FMeYMXz3NHD8ReCUOx1/Cvdf1acbtkqsxVZUPMiUEEHxlK/AC8q3XONnkRwT0OV
         1xTHodCTqhi0ySWqpoO7EuFnqYEhzVgeQEewffTmFxNSfBIQXoP6J4a+vXCjxaCKs7UM
         Gg6QuYGNH4SfYvRZKxkAnCY24l1xno9QweTQnQigeQ63LR96xoCuAkm4e0RwN2/ybsgF
         E0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wbtKndzAWvCkk7WyRwv4b5BaCedyCpezxbPT2xu5RJI=;
        b=CV8StZ+Iot6jzQSv0ipq7b3qefObXs/V7YRMl+MYo85B3G3WHBJ+aMHjFVvtp+FbWp
         C0WaairiR7SBdXN9AJ5Ii4vE0xD1cXtyaWepnNQrxLktPUnLxLdxDLLkTEC+Reu5MrSs
         x09PaV0Sut4sXmzDWLCobNWf5jaiFh3MY+x2dpCWsFnbVqu0JGtCjTS+jhzvnqIM3bd2
         YzB+QLT7jLw0kn575wQNTlEdM4I7hBBUbfHBVgMQnN2cYwAaJc9nre/akr01Km/NmlUN
         xRoF09xs/6CqOjaqH7pykrY40Bn31jhboLmtcs4B6KhMcPsEoopFT0Zt3FvwXisknbIO
         /bcQ==
X-Gm-Message-State: AOAM530x2xRv2Zi2O9bjgNwNzuDrvNpCMXBx/1wXTjTFz1n9dXjm7/mB
        ntmnrt6UTb4siVq6wiSHMNNEMfoifIk=
X-Google-Smtp-Source: ABdhPJwYu3eHHu7vONkLYq7yvs6BlGo8YwufFo6hGxBHerJCuXqQM+wJbzVOX7Pn89wbvQVd+ujOZB5s4qM=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:e40f:: with SMTP id
 hv15mr1640233pjb.1.1644822081267; Sun, 13 Feb 2022 23:01:21 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:40 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-22-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 21/27] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
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

Add feature_config_ctrl for RAS and AMU, which are indicated in
ID_AA64PFR0_EL1, to program configuration registers to trap
guest's using those features when they are not exposed to the guest.

Introduce trap_ras_regs() to change a behavior of guest's access to
the registers, which is currently raz/wi, depending on the feature's
availability for the guest (and inject undefined instruction
exception when guest's RAS register access are trapped and RAS is
not exposed to the guest).  In order to keep the current visibility
of the RAS registers from userspace (always visible), a visibility
function for RAS registers is not added.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 90 +++++++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index faa28e7926b2..72b7cfaef41e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -304,6 +304,63 @@ struct feature_config_ctrl {
 	void	(*trap_activate)(struct kvm_vcpu *vcpu);
 };
 
+enum vcpu_config_reg {
+	VCPU_HCR_EL2 = 1,
+	VCPU_MDCR_EL2,
+	VCPU_CPTR_EL2,
+};
+
+static void feature_trap_activate(struct kvm_vcpu *vcpu,
+				  enum vcpu_config_reg cfg_reg,
+				  u64 cfg_set, u64 cfg_clear)
+{
+	u64 *reg_ptr, reg_val;
+
+	switch (cfg_reg) {
+	case VCPU_HCR_EL2:
+		reg_ptr = &vcpu->arch.hcr_el2;
+		break;
+	case VCPU_MDCR_EL2:
+		reg_ptr = &vcpu->arch.mdcr_el2;
+		break;
+	case VCPU_CPTR_EL2:
+		reg_ptr = &vcpu->arch.cptr_el2;
+		break;
+	}
+
+	/* Clear/Set fields that are indicated by cfg_clear/cfg_set. */
+	reg_val = (*reg_ptr & ~cfg_clear);
+	reg_val |= cfg_set;
+	*reg_ptr = reg_val;
+}
+
+static void feature_ras_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TERR | HCR_TEA, HCR_FIEN);
+}
+
+static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
+}
+
+/* For ID_AA64PFR0_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ras = {
+	.ftr_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_shift = ID_AA64PFR0_RAS_SHIFT,
+	.ftr_min = ID_AA64PFR0_RAS_V1,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_ras_trap_activate,
+};
+
+static struct feature_config_ctrl ftr_ctrl_amu = {
+	.ftr_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_shift = ID_AA64PFR0_AMU_SHIFT,
+	.ftr_min = ID_AA64PFR0_AMU,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_amu_trap_activate,
+};
+
 struct id_reg_info {
 	/* Register ID */
 	u32	sys_reg;
@@ -816,6 +873,11 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 	.init = init_id_aa64pfr0_el1_info,
 	.validate = validate_id_aa64pfr0_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr0_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ras,
+		&ftr_ctrl_amu,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
@@ -945,6 +1007,18 @@ static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
 	return feature_avail(ctrl, val);
 }
 
+static bool trap_ras_regs(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_ras)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	return trap_raz_wi(vcpu, p, r);
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -2316,14 +2390,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
 
-	{ SYS_DESC(SYS_ERRIDR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERRSELR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXFR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXCTLR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXSTATUS_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXADDR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERRIDR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERRSELR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXFR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXCTLR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXSTATUS_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXADDR_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_ras_regs },
+	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_ras_regs },
 
 	MTE_REG(TFSR_EL1),
 	MTE_REG(TFSRE0_EL1),
-- 
2.35.1.265.g69c8d7142f-goog


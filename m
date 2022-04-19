Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF720506524
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349136AbiDSHAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349134AbiDSHAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:40 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC58F3204C
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:50 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id d15-20020a17090a3b0f00b001cd5528627eso928995pjc.1
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xydmrQbn6xBF8/ePfVL7th+l3rERvkG3uvSek2g29PM=;
        b=B3aAhbDXLtzCKoc11fDKloW896IaGDdEbmBBz/bkUK5ainOaSynxr95k4hqmcFDIOm
         XSX5BxR7DJS4pmGIm1pdkb9wUUT09tkOPCwpv3fW8NiTBWCkhm65qgJiC3a4BPQ+Ri0M
         +TPtopVHEVTAWl0UHuYBlZ/vjq4jdcvyIhVhZ1m6yXzS391nw+F+oBa+8z+Dwc0qjuBQ
         x0v2ScmIGPiHC/L7Gsw0wddnIzIPzFOMEvq+10S1VQ5N8DeDpwYRbaXHRXSTMQh8JkAm
         ye6N97rv5CM+hd43K7Hqn3bZZrNwsgFp+CA/u0fL/WatKT3gaILa4hshuBhr+8b4j7iL
         ZW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xydmrQbn6xBF8/ePfVL7th+l3rERvkG3uvSek2g29PM=;
        b=fgQeUXldxX0OQ3yYdKCMj+jQYB1Hcz2iYGLXJF2BG6DLFTxSJIZdtjnTzOayqdDeBJ
         URZCl6rrU1olIrvW28+yugSz9qgeFH0ZveWaC4Z0DbxBlFsg+IAuJ8jc8Lx/dW7o4Vci
         3Hth71f3lQBA/UdAyaqbEYvtjeBpmfACM3awww6zgsZERXZIIX7NpMrZUjsHBog9E3zC
         BLOxIQG7UvT8XxIIwMLM/mopKBZK8tYR28jZm46K3mNNgwbp1BxgB2nNoCGkU3bK9Hdn
         vhZIhTdNxx4BkAAJerMS5MaEmOrbKd87vfPPIswmL1kxzKN/5Uok2WdZ65mDGifz58+t
         vSFQ==
X-Gm-Message-State: AOAM531Wpvsec2j0K/S0G9XppeJ+KxC3uWiLSw3IZNEA1LiXEMzPmzbv
        iwhB3z9uhz5dOXrAgvArHYc99uTalbA=
X-Google-Smtp-Source: ABdhPJymWpo78icljcdDrBVhbQitXud9ofh1LnhHGu4eZMLV5WZFlPKgYwB0b6QD2F2Vs2FOm+A56WLFg34=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:dd45:b0:1bc:9466:9b64 with SMTP id
 u5-20020a17090add4500b001bc94669b64mr22322996pjv.23.1650351469934; Mon, 18
 Apr 2022 23:57:49 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:33 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-28-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 27/38] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
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
 arch/arm64/kvm/sys_regs.c | 92 +++++++++++++++++++++++++++++++++++----
 1 file changed, 83 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7fe44dec11fd..fecd54a58d34 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -320,6 +320,63 @@ struct feature_config_ctrl {
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
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -954,6 +1011,18 @@ static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
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
@@ -2786,14 +2855,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -4230,7 +4299,12 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 	.ftr_bits = {
 		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, ID_AA64PFR0_FP_NI),
 		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, ID_AA64PFR0_ASIMD_NI),
-	}
+	},
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ras,
+		&ftr_ctrl_amu,
+		NULL,
+	},
 };
 
 static struct id_reg_desc id_aa64pfr1_el1_desc = {
-- 
2.36.0.rc0.470.gd361397f0d-goog


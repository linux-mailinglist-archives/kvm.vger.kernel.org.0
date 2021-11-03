Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B75443D49
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhKCGbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbhKCGbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:31:07 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902F5C06120B
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:31 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w4-20020a1709029a8400b00138e222b06aso655548plp.12
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=stxvqpS43GKPlFzuxNRd3Kw5X/pb/WSIMK3gN777H7I=;
        b=IHQDLDOYeY7XgsxKhEsFtXdkfK0mb0dBJWK6OuGaazo3Fodx/+jp4nrjFwRFVhyf8Q
         WR5kQW/dlUUPyoN4Csr/tkwoR4oeMQFo4PU+ByF5vABq5NYxNtsU9XzLKHlFVCxmX0dk
         yCleWxaFhOu04rzcLR+dHqVTHnSA0BjtHB8ePBqvn0h7+juHuxd50058AWol7qNsbdzA
         SLNYI4gL1xpNByWHOuyijeCltzuSHRy46GyVjmnAPwTjnAnxiY8+yForLk4w5vzN780E
         sR9Jqel9nyYzQyKNO36FT/oNO9q2IBIG5degiaLbnrU07lZn6gHFLZFihfGRbBufIsYe
         8rrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=stxvqpS43GKPlFzuxNRd3Kw5X/pb/WSIMK3gN777H7I=;
        b=X3dDi4WFJcnR3U48G1pPbThIwkSMXhTUj1x6xNm3O0ozwjw64goLMB0YiygBubYX0G
         lJoOa6R9KdwVZdFp19VImdv9j8VgLmnQMHrPp34u6aE6QJFFvLx2+OnATzJc5PWCZYKK
         LTfdKkyaojEPatkgqKk3y/NA+uWXRqYNdmo5A9Oo3VWYAevw/OZ/v1s6s19/aR6Fomd9
         REfNDLqZrhEpJSjfOZoBGSfs383crW2oOfNCHXHpiJejesHMR0pI4Ddz1KZPKQOSS26E
         3AQ16VBRMr/LqqL1LRjtoRdOcSixifKlYoMnr/I8B+e1p9P3hVrQvhjsiVzSHAxrNYL5
         EIZg==
X-Gm-Message-State: AOAM530biSlGiHrOpXDQLfzKYNci66NOzD5PKbITKdRXm99Y+Gqv1K25
        JqZfsWBwAmUTwsYY1wuxDvZPaFcFDoc=
X-Google-Smtp-Source: ABdhPJwKC5UfgtW/4DN0Ud9DJaQEbXi5o3b0e5aheeOv71jnjTZGp0cYDLSH5/u/wOzSZOUSW+HvFY2qmz0=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:f24a:b0:141:c6fc:2e18 with SMTP id
 j10-20020a170902f24a00b00141c6fc2e18mr23852030plc.55.1635920911096; Tue, 02
 Nov 2021 23:28:31 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:14 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-23-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 22/28] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
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

No code is added for AMU's access/visibility handler because the
current code already injects the exception for Guest's AMU register
access unconditionally because AMU is never exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 54 +++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 504e1ff86848..99cbfa865864 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -403,6 +403,27 @@ struct feature_config_ctrl {
 	u64	cfg_val;	/* Value that are set for the field */
 };
 
+/* For ID_AA64PFR0_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ras = {
+	.ftr_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_shift = ID_AA64PFR0_RAS_SHIFT,
+	.ftr_min = ID_AA64PFR0_RAS_V1,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = (HCR_TERR | HCR_TEA | HCR_FIEN),
+	.cfg_val = (HCR_TERR | HCR_TEA),
+};
+
+static struct feature_config_ctrl ftr_ctrl_amu = {
+	.ftr_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_shift = ID_AA64PFR0_AMU_SHIFT,
+	.ftr_min = ID_AA64PFR0_AMU,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_CPTR_EL2,
+	.cfg_mask = CPTR_EL2_TAM,
+	.cfg_val = CPTR_EL2_TAM,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -847,6 +868,11 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 	.init = init_id_aa64pfr0_el1_info,
 	.validate = validate_id_aa64pfr0_el1,
 	.get_reset_val = get_reset_id_aa64pfr0_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ras,
+		&ftr_ctrl_amu,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
@@ -1003,6 +1029,18 @@ static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
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
@@ -2265,14 +2303,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
2.33.1.1089.g2158813163f-goog


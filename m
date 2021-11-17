Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F62345416C
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhKQG4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhKQG4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:41 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EF7C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:43 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pg9-20020a17090b1e0900b001a689204b52so2647898pjb.0
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4r4dnGc0QUxfmpMgxENAZwxToTocn/Wh0WdJQeDNk90=;
        b=KKsm9rkFm/QOI7qFPojRub9O/w6IU6WRes4Tk4KmRqWfD7iq15YY0sFxX0IUah79pB
         dlkjXriHiEJDCPSb/hJWN5SxXZZFY4RdJwbi88EBN9RJbVLuC0Jp/4B4iiwxznqFUsLT
         3M+KV1l0ePdFaQrT2XaX6BZJ+c0FQH3ZeK8eXWM2uCzW+FdlFsTmv2XnXWH/5DadYHQ6
         O3jw/JsLgCNgtGJ417Wg8nmGOjtmqhQPBMtjs/Y3PS8X4hlaVJjCPd/64DsFgMX2Qalh
         Gz006lsabDPmoFPoHlzZzXdrfRgE3po8uf/c5/Q6KF1INwP8BGDf1Zpb6vhkQDK/ltzG
         gL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4r4dnGc0QUxfmpMgxENAZwxToTocn/Wh0WdJQeDNk90=;
        b=WIU4blUcklmlaaV88LHX8HOdblkeErp7BxdxaqQzW0mWBa3hFR/O5eGRDWfQrGqSoT
         OKTWXdQ11mL6FX8eDN1NhQ7vfOGNqdH0b1dlkx6Cqml2+k3E1EEljvF3oEDWymtlE0Th
         qSoOD2bOTXWG86OudxFt7T7eBubyHwoLsH20tH7JTI/OZTOb4DX4SoTN848elWuaXlcH
         FeHoK79je0TobhtsCYtYUv1dUqHuPufcaH0Z5OleeZd9DwyrRyblKd5pQA5pfjUDcjFg
         +NiWL4lwnnAY1d6Sgp5S11Owv49xRtTpC3xhm4pUwPqx7PhNclqoXr1nUys5R6DM0QMz
         ifzA==
X-Gm-Message-State: AOAM532qMVpSazIhhdJk2UToTyXb30sGcvpG21P1p8cSIhmqxP8JVIub
        AOdIwJuPOEfax6qy6Fwv3YpoEmWJQXY=
X-Google-Smtp-Source: ABdhPJyGVVmaEL5PQuPlf6iHi8bhoT0WT+vCtCanbdtf7ZVw0zdaOzbC1zXQq2fF70ugDq3mSaxormkPK+I=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:3447:: with SMTP id
 lj7mr7048244pjb.112.1637132022917; Tue, 16 Nov 2021 22:53:42 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:52 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-23-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 22/29] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
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
index 501de08dacb7..42db8cf18fbb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -405,6 +405,27 @@ struct feature_config_ctrl {
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
@@ -871,6 +892,11 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
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
@@ -1027,6 +1053,18 @@ static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
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
@@ -2318,14 +2356,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
2.34.0.rc1.387.gb447b232ab-goog


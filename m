Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B35429CA9
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhJLEjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbhJLEiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:54 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1526EC061777
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:49 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id g10-20020a17090a578a00b0019f1277a815so893403pji.1
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aRSx5zsU8oar0tb24ztRfo+cPgh7JwnM1ai34rY7D1c=;
        b=cYhiDj33nfyC1+mBMm3OX/sk39KmpppUj6JtIztRs3tz0amKzYK5kcV4cxVpWZXfg4
         bTWk0/6bU4Zvq2uI+1uL/yMfWefIo4MQdEckJ44mowOvJtPPi0vus7k/2XEqB2ypPjY9
         fJX+tPmHrUgbq1fgzi8vtt8vcgO7dp1y5ioqBi0XzM89yZPoQd7PvWicCEHqmA23SP9q
         lH7fwIHrQjJtLM3nTriL0j9gmXlmqAPikl59xzwEsrjG139moFR1UUaBdUzjfgt+89UO
         WMoGcLgXEcRUFn2J9P77SlB4HqSPpjpY9XeBggk036qs3o/688SPHWQpfyAVju5CnKgT
         oIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aRSx5zsU8oar0tb24ztRfo+cPgh7JwnM1ai34rY7D1c=;
        b=dvFAcuh5ISON0hF7MTLMME3mlODUGKy4LsTIbE53KqyQGosv4XwUY3kCOa6NaRD0Pf
         33v/5Pwl0Q6rwRqDNL4hkGKSJZQeuRBp/YmnGtQM3U8R3PBxNx3hR1LYVq9NnTTjG1ye
         9l30spIWQzZ2LYVs7m5LsBIIg4T+X0z4H40WCeuy25ECGj0qvxoV5CiPb+aOBcfEPMwJ
         BW1OemJ/TuVj8mqNFKkiozHcJMZ8GLtEJkMJwcEF7yxTGLrnmp7UK5FBaMlYdpLvVJHW
         RazdGP35xhzja2wiyrkYyMGW8+9oi+svBgYWQHVdE29T3hHJO4Prf0ToirUKm5424qGx
         31/g==
X-Gm-Message-State: AOAM531HMkU1KnJ1NyZfJHFyPN9N6DdaNtPlg4eAx9VWiOIvg5u2bbpF
        Egway3pZM49Ur9a+A4NbRee4caMHB1Y=
X-Google-Smtp-Source: ABdhPJwMjijcnPLmRF0gVFsrWCvfaeII36N+1PxEShOqBpmnd6e5wcu2sZR24dDiEMFwJYbs4Q5g7aB3YhQ=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:181c:b0:44c:bf17:e8ad with SMTP id
 y28-20020a056a00181c00b0044cbf17e8admr28869751pfa.67.1634013408614; Mon, 11
 Oct 2021 21:36:48 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:29 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-20-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 19/25] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
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
index 55c514e21214..2b45db310151 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -310,6 +310,27 @@ struct feature_config_ctrl {
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
@@ -660,6 +681,11 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
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
@@ -790,6 +816,18 @@ static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
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
@@ -2052,14 +2090,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
2.33.0.882.g93a45727a2-goog


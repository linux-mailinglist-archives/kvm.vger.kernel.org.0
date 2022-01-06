Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBB9485FD0
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbiAFE3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiAFE3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:29:05 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6A1C034001
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:29:05 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id f24-20020aa782d8000000b004bc00caa4c0so949672pfn.3
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vAzKz8VnLED7JizGSuKkWSji/qrCKwtnpVmiTZ6Ul2s=;
        b=nlnwOfQvStw+Mz8pAhxQWNUgrkdZWCwkurIHjLg+9XvBQSKPI0ruIWzx9i3TlRvImH
         m6z6XWk7Oh0v1de3XruoETBbXK2Jc3oSutRuWqGbdy9A4BeE651nGnvdyAagvVASxvO6
         bwJwHrStu95hSl4DhAwVrYf4rivTcyqqYZCcJ70NIos6rkqUoc6F2JVckr2yevgznADu
         /akLiPtHj2GBhRPH0L3NMvDlX/hZy32zpaNXQDoIxNetZ+8VdkP6inbJiDiSauuxQbR8
         VxnyQKrOvCIjh2jISoEhtb7eo5V9ybjPYiJqGYvP5bfcdnMteLYCXlQraB66IgSzQu+2
         rZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vAzKz8VnLED7JizGSuKkWSji/qrCKwtnpVmiTZ6Ul2s=;
        b=FrbnmowJRi1ybyhVtKoJcECA3EP6nwwyg47xkMve5Bc/H1Ns0/r+tMjEQARZ71+Ndl
         qktnoJn6HPz9+5laja7CYQYU13p2AQ+depEfZAtm6IAGvEehkSP9ZUvsvNgNbMKPrE2R
         TE/nWR6iwDa9HaaPg+135PNWU9VGoLAdxcEaOgCGfWBPcrRzG6nMdPjXW7NJG7xl27Kh
         nV6+S+IGCSkQ/b44EdeILbe46WRC7D5hGdMInO0cQCMJb+ccVKkkBSBl9FwiOTsfoE/N
         9AXcYBMCutHO+IgwUei4XqWs3LwXkpk9AmS43q35wNCLL3mPllHvxWaulNV1qd4W0inn
         88zQ==
X-Gm-Message-State: AOAM533C8+Zxr5YxnrCXJrxZgxu9oZJLEmImis/tFTpow4w9RDZPdTzU
        gd9TTJ+/ibxNF6cI/NZ+FV/AHhZwh6k=
X-Google-Smtp-Source: ABdhPJzD5NQdlHGXFcJ/ANmXYaRnVSoPiNlfdJcywqQUu+s82OazALe8sdMAz6vdAAJzU2LN2c+4+RPgFw4=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:b687:b0:149:90e2:8687 with SMTP id
 c7-20020a170902b68700b0014990e28687mr39915203pls.131.1641443344718; Wed, 05
 Jan 2022 20:29:04 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:27:04 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-23-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 22/26] KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
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

Add feature_config_ctrl for PMUv3, PMS and TraceFilt, which are
indicated in ID_AA64DFR0_EL1, to program configuration registers
to trap guest's using those features when they are not exposed to
the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 47 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 72e745c5a9c2..229671ec3abd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -349,6 +349,22 @@ static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TID5, HCR_DCT | HCR_ATA);
 }
 
+static void feature_pmuv3_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TPM, 0);
+}
+
+static void feature_pms_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TPMS,
+			      MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT);
+}
+
+static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TTRF, 0);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -375,6 +391,31 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
 	.trap_activate = feature_mte_trap_activate,
 };
 
+/* For ID_AA64DFR0_EL1 */
+static struct feature_config_ctrl ftr_ctrl_pmuv3 = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_PMUVER_SHIFT,
+	.ftr_min = ID_AA64DFR0_PMUVER_8_0,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_pmuv3_trap_activate,
+};
+
+static struct feature_config_ctrl ftr_ctrl_pms = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_PMSVER_SHIFT,
+	.ftr_min = ID_AA64DFR0_PMSVER_8_2,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_pms_trap_activate,
+};
+
+static struct feature_config_ctrl ftr_ctrl_tracefilt = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_TRACE_FILT_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_tracefilt_trap_activate,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -898,6 +939,12 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	.init = init_id_aa64dfr0_el1_info,
 	.validate = validate_id_aa64dfr0_el1,
 	.vcpu_mask = vcpu_mask_id_aa64dfr0_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_pmuv3,
+		&ftr_ctrl_pms,
+		&ftr_ctrl_tracefilt,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_dfr0_el1_info = {
-- 
2.34.1.448.ga2b2bfdf31-goog


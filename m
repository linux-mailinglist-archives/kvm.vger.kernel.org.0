Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426AF4B4276
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241071AbiBNHBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:01:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241076AbiBNHBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:01:40 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5B7593BE
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:26 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id y10-20020a17090a134a00b001b8b7e5983bso10295226pjf.6
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1nsgNzH+YpfR3/KlbrupFdkkNs/4tvboqaVeY8OSkcA=;
        b=Uzrf4k8tdsN8iZk1o4Z1sprsLA1ZDIULzNZcfKvd8PPrrmESS5rysT77OyuSEML4DF
         U+5KaNW1vZk4LEbccSoj8bsf7DakaW2MOusPTwkA6AnYJdltLtH9e+Ur/jj6FnKaSXKh
         w8Ygcb7Ge32vFXcMJxmtWjb0wlLab22kQyymXpYmZOE/GBiqqvZeBwz9HPTFVkQSXKZ9
         2BpaE2lLws1UG9FMApBj1HgD73tjL9mrvvH8rtVIVeW4+InQUIx9yB+ESPmrBJgfSkor
         v698uTnpwEjjkaP3DqhEzGLB6oSx2h5oSNbJTFcf2ZsjxZ8MuLPpPlszv4nC4g9HCC5A
         iByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1nsgNzH+YpfR3/KlbrupFdkkNs/4tvboqaVeY8OSkcA=;
        b=202KpQekOvIWgpyTHLioHPhs/JiGfctxTAifPk8816nfMdi2vDq1U95YFTBzeCHvs4
         ObZ50up0z/mowHxDBO35tWun1Tyfqs6oyNG9trPhD+CsdXFKiivWb3e71Oif8N3l1Xeo
         RkOcABxViJ3FAn/Bns6F7klOWMB9xFAGVoy1ZTjjcL5pSV1j0I0X2YfwGBFT1l0Jsvzr
         xMIgSRxbAhyRekBbhuEcIc3C4Yr63V6YCB7nNJPgW3bnRNyGyXLxLsZf7ohjSnDmnt8D
         UkmIxRLOfrEKFetdx4XyztmXFkbj19dAlAo/lFfd3MhBmjEqxisscico0ZmJtlz7cwDx
         77Rg==
X-Gm-Message-State: AOAM533f28XeUqvwJDuEMAC25Ou3lhTOo2voLNKEmgZtFAqdEOmHU0NV
        WsPpC+kfTYhzZ+IqKHtdY8qf2krTiXw=
X-Google-Smtp-Source: ABdhPJwSnhJG8X92VE6HuDLs//NrS5KMmVjqlsnEZdsMnybSnY0KcHl4l/b6B2QmMc6sHthhI0qqWsxaD2k=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:224d:: with SMTP id
 hk13mr751201pjb.183.1644822086476; Sun, 13 Feb 2022 23:01:26 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:41 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-23-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 22/27] KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
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

Add feature_config_ctrl for MTE, which is indicated in
ID_AA64PFR1_EL1, to program configuration register to trap the
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 72b7cfaef41e..a3d22f7f642b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -344,6 +344,11 @@ static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
 }
 
+static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TID5, HCR_DCT | HCR_ATA);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -361,6 +366,15 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
 	.trap_activate = feature_amu_trap_activate,
 };
 
+/* For ID_AA64PFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_mte = {
+	.ftr_reg = SYS_ID_AA64PFR1_EL1,
+	.ftr_shift = ID_AA64PFR1_MTE_SHIFT,
+	.ftr_min = ID_AA64PFR1_MTE_EL0,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_mte_trap_activate,
+};
+
 struct id_reg_info {
 	/* Register ID */
 	u32	sys_reg;
@@ -885,6 +899,10 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_mte,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64isar0_el1_info = {
-- 
2.35.1.265.g69c8d7142f-goog


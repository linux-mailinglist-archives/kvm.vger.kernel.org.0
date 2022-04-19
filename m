Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBCF506529
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349143AbiDSHAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349124AbiDSHAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:42 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784E03192D
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:53 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n4-20020a170902f60400b00158d1f2d442so6109118plg.18
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6xPTbO2+lphyYIiZZ7nszYhBXnFaCQQSE3MHungiG3k=;
        b=It96CsYEpNqOcLwAVOb9ZqqedaZuQTEj/TXyGKgn91DGN1sbhJ2YzVPkGyHNPtG0Nv
         aNAZtDspBnw31IkOSfsaQRnyOa1+vukEVhRRJuyFETlx+Xga9HV7nASuyNJsYJd6eFZO
         Z24gMEtrO+U5npwqvSLXDznZlYHSyFsmBAFIFZoEMTLt46ZN4DzUxj55xgjRqSxJ6hm5
         euhJuYDyTiUwy8G6uL3tc5CKsuhmecf0ulBOQZbgyj0Zgb0i2TxRTfji88zGyTtAvcIk
         KyaEUd4bs969tANr4AJvZOIcTWBIOCB3bZmNr5U2nuMhhVOvPHgX0HvX8PSt923l0aer
         fGuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6xPTbO2+lphyYIiZZ7nszYhBXnFaCQQSE3MHungiG3k=;
        b=w5CtXKtZ1ItLl48vJsio9WUhEsicQGaXTyU2mOAyWjoOOCIRzXq3cXF0YvS5J1X0lh
         CAuntqFzihVAHqpVOA6nUNygu0/25m6lyMPhhzjE8K5KhMK76oCz2rwMX8OZZOG47A5s
         4op1ENz/A3gwtNnBNbDBq2ixerqfOoxBcnoVn9UXM9088aqtRXvMbQBVIL7N1G0Bw0eG
         j/OFe+/CDuO+s+CvkLy07f8+L3CUWBhJ+OHZiJDuJg3X9oyilDBrfg+uzh5LfDBZr5qw
         TkawdYQTXdWcdevdGkBL7GD2cwQtWf69vb8WD67LMHXDcyRUU4vRmcYL0HYR81NQsdJ2
         T9mg==
X-Gm-Message-State: AOAM5314IygLLWHgYQKKUFzUIP3FaWwbQV/Vt2PS8sucOY1LQ41z9r/X
        5pfj4O1W3MxFyCu7gZL7zoqaRr+Qacw=
X-Google-Smtp-Source: ABdhPJy3D0n5a+z17jnE0L3OXrhl0HuwRJ6F1nYYDplfhvW3GN0Q2u9zJiIaYhrSBbwPfSrzLKaQHN+kyIk=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1490:b0:4fb:1544:bc60 with SMTP id
 v16-20020a056a00149000b004fb1544bc60mr16144093pfu.73.1650351472945; Mon, 18
 Apr 2022 23:57:52 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:35 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-30-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 29/38] KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
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

Add feature_config_ctrl for PMUv3, PMS and TraceFilt, which are
indicated in ID_AA64DFR0_EL1, to program configuration registers
to trap guest's using those features when they are not exposed to
the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 64 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 10f366957ce9..a09c910198d6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -365,6 +365,30 @@ static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TID5, HCR_DCT | HCR_ATA);
 }
 
+static void feature_trace_trap_activate(struct kvm_vcpu *vcpu)
+{
+	if (has_vhe())
+		feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPACR_EL1_TTA, 0);
+	else
+		feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TTA, 0);
+}
+
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
@@ -391,6 +415,39 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
 	.trap_activate = feature_mte_trap_activate,
 };
 
+/* For ID_AA64DFR0_EL1 */
+static struct feature_config_ctrl ftr_ctrl_trace = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_TRACEVER_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_trace_trap_activate,
+};
+
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
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -4389,6 +4446,13 @@ static struct id_reg_desc id_aa64dfr0_el1_desc = {
 	.ftr_bits = {
 		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_DOUBLELOCK_SHIFT, 0xf),
 	},
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_trace,
+		&ftr_ctrl_pmuv3,
+		&ftr_ctrl_pms,
+		&ftr_ctrl_tracefilt,
+		NULL,
+	},
 };
 
 static struct id_reg_desc id_dfr0_el1_desc = {
-- 
2.36.0.rc0.470.gd361397f0d-goog


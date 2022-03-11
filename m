Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3D64D5A05
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346511AbiCKEuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346462AbiCKEuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:50:15 -0500
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E231AAFE8
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:49:06 -0800 (PST)
Received: by mail-oi1-x249.google.com with SMTP id x15-20020a54400f000000b002d9be4bd8a2so5234678oie.20
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BOtqtDPmFVbXSVQplJqqHWzAUqxe06WK8Hgp5xswEjo=;
        b=hjhU16IsuclGFWjBCSbzTVlbAwlKDoX+LoOaMMapNL8w6ClETZtePMebhWY3wK5qIK
         RZEHvgJmeqic7DauveyRHrogrFXjjQ85aC3eM8tEEZDRQgwFFdu1DoR7i7O5ksFs8Txt
         svGWTqmO2+IXkKE0AZ43wyFmymaBBq/gDGxMFfrjh4/l3akP8lAMWo204hbl6MV1Zg/k
         qKMoVz0evWLjjaVKZeDfsnMMG9pfgq7OYNe+xMFlARUmlTiBUCwPaIpoYMUuftn6NsV/
         Baw2+PpEMVAYvXavy87vEyU6/Fx6J3KYqq0/epl8LhXllOnBkt2+UKcqAlmAixhzde6Z
         pHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BOtqtDPmFVbXSVQplJqqHWzAUqxe06WK8Hgp5xswEjo=;
        b=QFQtRHtCjIIPqKO+scFRC4yEitjqNlQlezomBgUI9+S8O/xX5slpUD+Run2mypMRh6
         VvzRfR5SRZUEG4jO0/PiJNp5OLEK1RQSWx9Tp+dNOEabE5A5UsOSQicG6qKTqIgVDHGP
         Bxq7qbkz+A82xS6Eq6sW0lLiKC6NAcRD0L76aGgWIjZbB5X90AKBLwjOdupWG+yPtG3A
         0n+pB5sjwBtVxI3ziR1QLTJ1IeFNCopMYDb68J7nk4iwaJ+0FFuKfbwpBrhLBB3qxTM8
         gZkq8kILNtKtCtbVswkFaQp5VMIc0tWxJydCeTRDqb0pKcH19RG1SW8VvrR0rgSdSaE6
         QuLQ==
X-Gm-Message-State: AOAM532aC1VI1wqd9iR6oiDbqL9gSDJBKNY0dFLiL8VDNGvkjCILyPbZ
        wP32rkUAIo3ksRCpeYYy1dHIoT5gcec=
X-Google-Smtp-Source: ABdhPJwxlwQXx8fxZeLKU4n6nbDbzjRmOlYI/0f1fj5lPlt6ZBH1yo0WCK5jePLAp870++wELV/pob1U/z4=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6870:c588:b0:da:3d88:de58 with SMTP id
 ba8-20020a056870c58800b000da3d88de58mr10499144oab.32.1646974145880; Thu, 10
 Mar 2022 20:49:05 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:48:07 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-22-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 21/25] KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
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
index 924ffedf4b05..677815030d44 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -350,6 +350,30 @@ static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -376,6 +400,39 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
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
 /* id_reg_desc flags field values */
 #define ID_DESC_REG_UNALLOC	(1UL << 0)
 #define ID_DESC_REG_HIDDEN	(1UL << 1)
@@ -3733,6 +3790,13 @@ static struct id_reg_desc id_aa64dfr0_el1_desc = {
 	.init = init_id_aa64dfr0_el1_desc,
 	.validate = validate_id_aa64dfr0_el1,
 	.vcpu_mask = vcpu_mask_id_aa64dfr0_el1,
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
2.35.1.723.g4982287a31-goog


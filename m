Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01F94D5A19
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346231AbiCKEuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346472AbiCKEuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:50:12 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127781AC29C
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:49:04 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u75-20020a63794e000000b003810e49ae0eso293892pgc.3
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xLUCA41gdz7FCF8bUZA9Zti+AcGuAvR0DZ5YiMSov0E=;
        b=Vc1EayLhrOzYdEvO5XuG7Sgh7TZEmWxNUoLCYTfidCSdg7vSpbf5BcKDmMUiZl0R4L
         CcNTXxUh+KYp/iwYE1FVJOkNwuRBUIRgJJ06rfIze0sumJqVgeVADx0lWC6ZegwQwGV7
         rZd7qnPTxFexvkYJpVgyrh7VoKI38Vw+/6Bm4wxZxwbL3oSfWGHOr/oXFkcox9o4aOZR
         qoWOPG2Lg6D7YwkNu6abWchaG/BHS0j5K51sVIMGZUvWrCud0I3x3dG9lgbSG7VoE/Pf
         sFKHEuec5XVRta/06pVQrd8by8u3oAeYEkNBzh0/2/duFKN4qLtp8pYOEcYBHEztNXJm
         FwoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xLUCA41gdz7FCF8bUZA9Zti+AcGuAvR0DZ5YiMSov0E=;
        b=DtRjNdNDLp9nbgJqLmm7gOGkWahWzBPhxb0S0Wl5TRg+QRKy+W6uYggYTSRdJ7pPPR
         GN54G3To21LGK1QvAIQerDnfjsx601aHuZo3JRVEXqHBkiiUJa6hlKoi6bpS5igQPou1
         VGUPv7BFYPFl7QHzCFOyJCaqHz3za67M0/JVcgdIU0P+9ugwHqpenWAK2kG2/s+0/ttE
         1jI5aNrlkrAiCdnfWld8jXAn07vuVY0DUcwkCYo3LkGwg6QejKajM9idxs+zdug3NMo9
         Io4C8gTo+vAeVS2o2SgIi+UQhODYfhYrOD/eTWXi8hyIGvgetGaPZZEiA1qeqg/m+tWm
         P0Gw==
X-Gm-Message-State: AOAM530M9aL27wjjWH2gLqT+PgNBCJIknCACu91VxIyaDcbVcJufvoug
        PXDD43wviNvJ+ukwpiHLBNEsBkCCnco=
X-Google-Smtp-Source: ABdhPJwyRNt8QZSL25MhBfqeOrj7itaUKc+bzv73Qi9m6d1fIbeodfC9ndqspbZ/YEChD2vpQA5YzFqEYxw=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:b92:b0:4f6:dfe0:9abb with SMTP id
 g18-20020a056a000b9200b004f6dfe09abbmr8235033pfj.68.1646974144149; Thu, 10
 Mar 2022 20:49:04 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:48:06 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-21-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 20/25] KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
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
index 3f3f2800ff8b..924ffedf4b05 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -345,6 +345,11 @@ static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -362,6 +367,15 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
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
 /* id_reg_desc flags field values */
 #define ID_DESC_REG_UNALLOC	(1UL << 0)
 #define ID_DESC_REG_HIDDEN	(1UL << 1)
@@ -3682,6 +3696,10 @@ static struct id_reg_desc id_aa64pfr1_el1_desc = {
 	.init = init_id_aa64pfr1_el1_desc,
 	.validate = validate_id_aa64pfr1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_mte,
+		NULL,
+	},
 };
 
 static struct id_reg_desc id_aa64isar0_el1_desc = {
-- 
2.35.1.723.g4982287a31-goog


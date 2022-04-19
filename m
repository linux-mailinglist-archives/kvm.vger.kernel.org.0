Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36153506528
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345046AbiDSHAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349118AbiDSHAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:40 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1894832056
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:52 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id e12-20020a17090a7c4c00b001cb1b3274c9so1042722pjl.4
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=11aokqGJX88zjYco/n0ZubDfebB61Zyyzannu13jVUU=;
        b=KGkjLi1nc3eXEFUtTXU9CrYnMm5oE1zb1JyJJ5B7usLojN2sR4jMVUo4tdKam79pra
         OVVDdODyp0s3nG2ZJo8xAbdCAAdfINz0DvmkTYgcDoJPyjrFRzEMbWEhr3S17VgMcZzD
         nM3JFqyi9usgPOH9nh6yHH3K9EhDv+VHrkC9rBBlvfOu2MszL4Hs+DDC22Em2O6ZKNxl
         5AeVCwzg50biwYCMn8UmZJ1+S+oPSbmtdfJ4IcoWZFIIysV0uXT2l+BZurMipMNhaudj
         6H2envE5Qpe3dAMXTa3BuELSOXXVwTJH4rpI5ANhGr44gOvC13Npdua3r4pKU8cmUmQJ
         8T2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=11aokqGJX88zjYco/n0ZubDfebB61Zyyzannu13jVUU=;
        b=aJrmNNEFJjOAwOgzXl2gveoh4rnk66jZatwkAo6g02mswL/6X3y4duBIIAVpvdyZd6
         GIoRmKDpyI14//+ldS2f82WFeSwAxYz4lHWs3RSp6/5DNtk2tywgf/KL0uH+2xH1IiwO
         tqtQtD1Bog/WtY/PuehR4s+IboQ8Sj/nCz3cA7Q66x/9j8QaJL0SR1F7jAsHeFhzMNx0
         TWQSvXphqyrZLA3yxZN7p8bCaOQ6v1/B3Y2lGN738SL+HQ56+3S1+q6xA2PpwvDDq3zG
         wvydrzA4+J0k+qk7I1Fz8mUnu900d6ruaM4matyL6pYllGKeDIpvcbjgRfEYiS1PEXN0
         USBA==
X-Gm-Message-State: AOAM530HV2hjC/sex+OgOHatWWxnjQjAVZ9V9RoDGbq9He3w6ZGMeO5Z
        KjaAnKF2zSJktYv09DPl63LZ43aqBxU=
X-Google-Smtp-Source: ABdhPJxTNMo4W/KfFAQ3BdCNc/v2d2neST1XZcUkDoxRPAerssfdLoDu8lxxEk0L7o4yB7dQku5s92k37v0=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:c792:b0:158:ba0c:cf6d with SMTP id
 w18-20020a170902c79200b00158ba0ccf6dmr14555949pla.131.1650351471625; Mon, 18
 Apr 2022 23:57:51 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:34 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-29-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 28/38] KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
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
index fecd54a58d34..10f366957ce9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -360,6 +360,11 @@ static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -377,6 +382,15 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
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
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -4312,6 +4326,10 @@ static struct id_reg_desc id_aa64pfr1_el1_desc = {
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
2.36.0.rc0.470.gd361397f0d-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F274D5A0A
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiCKEum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241275AbiCKEuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:50:17 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5E21AAFF7
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:49:08 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id r64-20020a17090a43c600b001bf8e05847eso6548997pjg.4
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=46qXeSpi4Sz/Cxmd+kiVveMfXndYTJmQfut6cp7XrW4=;
        b=CPA2eRLxteZJs71CJ0dQUl7ireq+1W+7rl/oRTYFYRyGUMOlkRpx2xNk/s4nJt0A5r
         2C238ZfVTpkE8Ujii9v29Vnk3ITgwjUnaK5PZZcdRWiOcqwYYB1AfVnxYQDJqGFhu/IJ
         4XJ2k1wjuss+Kvd7Au27jIRjPf3JHrzenFHb9knbYT8bjBzl7Glg6u4TzmchCCtHmDo5
         xQwJVTxMcZqLGgRxDvWHsAJvBNogJqoy9TP687htkO+JtIaYO9W+v/vnOaPs9OWplpPv
         mu4BnmDtCuFN7vZQ5agxRAstLL9+XA9aErEQiU7EXruF8IhFID8v76gHBJml9H2eG3Rm
         aVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=46qXeSpi4Sz/Cxmd+kiVveMfXndYTJmQfut6cp7XrW4=;
        b=UYliAc/jqOOYtIGQ8bXiUXlGI+7jYl4mL2yHQAQ/qXDWNC2kJLUytUUPrdypyvPePO
         uNtA/H8OU+PM4wjHsh7b1SboGgtRB83cAmcVwwkLMP8PAn2Mo4rl9k8oZkFEpsCJnHpV
         Snzbc8Um1r3t+fk5gWIZvj8KI8J0sp0rTPBZWiJJvZkEnUJIpTghrAEkHmdMe2uVC8ZF
         MRb6xkRF2T5oZUUf1gwEVhNNuXvUMelD1mcsrJoyfMToR/9pJ2HCdLFMMxXvdlJMEbk6
         1ws1VNNCNZxPcyNAvQfcD7p2WHKXaTgxb4GRxn7JgalbCoAGEOPx/G+R3V4u29Wb3/FD
         Of9A==
X-Gm-Message-State: AOAM5328k5sNuGI+ocDsR3zUYKqAumkwj4/Mf22uLonOf3kbxjBeTDZT
        UjAdPEVOrh8wZE4ekOndkWrowdQ/+WY=
X-Google-Smtp-Source: ABdhPJwSHuu2+YqzR0IJLcSfz4UuQFLPxAgOKQjBnghAqNzp2YYPCYKHN+sp+/U5r8Ffe0yVzT7zWbBDzAU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:1e10:b0:1bf:6c78:54a9 with SMTP id
 pg16-20020a17090b1e1000b001bf6c7854a9mr434986pjb.1.1646974147365; Thu, 10 Mar
 2022 20:49:07 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:48:08 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-23-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 22/25] KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
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

Add feature_config_ctrl for LORegions, which is indicated in
ID_AA64MMFR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Change trap_loregion() to use vcpu_feature_is_available()
to simplify checking of the feature's availability.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 677815030d44..f3661881cbed 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -374,6 +374,11 @@ static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TTRF, 0);
 }
 
+static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TLOR, 0);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -433,6 +438,15 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
 	.trap_activate = feature_tracefilt_trap_activate,
 };
 
+/* For ID_AA64MMFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_lor = {
+	.ftr_reg = SYS_ID_AA64MMFR1_EL1,
+	.ftr_shift = ID_AA64MMFR1_LOR_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_lor_trap_activate,
+};
+
 /* id_reg_desc flags field values */
 #define ID_DESC_REG_UNALLOC	(1UL << 0)
 #define ID_DESC_REG_HIDDEN	(1UL << 1)
@@ -1003,10 +1017,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_id_reg_with_encoding(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
@@ -3785,6 +3798,14 @@ static struct id_reg_desc id_aa64mmfr0_el1_desc = {
 	.validate = validate_id_aa64mmfr0_el1,
 };
 
+static struct id_reg_desc id_aa64mmfr1_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64MMFR1_EL1),
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_lor,
+		NULL,
+	},
+};
+
 static struct id_reg_desc id_aa64dfr0_el1_desc = {
 	.reg_desc = ID_SANITISED(ID_AA64DFR0_EL1),
 	.init = init_id_aa64dfr0_el1_desc,
@@ -3901,7 +3922,7 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 
 	/* CRm=7 */
 	ID_DESC(ID_AA64MMFR0_EL1, &id_aa64mmfr0_el1_desc),
-	ID_DESC_DEFAULT(ID_AA64MMFR1_EL1),
+	ID_DESC(ID_AA64MMFR1_EL1, &id_aa64mmfr1_el1_desc),
 	ID_DESC_DEFAULT(ID_AA64MMFR2_EL1),
 	ID_DESC_UNALLOC(7, 3),
 	ID_DESC_UNALLOC(7, 4),
-- 
2.35.1.723.g4982287a31-goog


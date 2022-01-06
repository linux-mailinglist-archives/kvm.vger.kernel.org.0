Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9EC485FD3
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbiAFE3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiAFE3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:29:06 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB9EC061201
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:29:06 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x128-20020a628686000000b004ba53b6ec72so940121pfd.9
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=b5C+ulXk8DtiFV4JWD7KK9B/636Yn3BYdNq9V7se8IQ=;
        b=PjwCpBHP/IlWcYBXpvIsuDywh36YeiZC/7CnqpU98fCKw1F5N2wvJRLtoHAP9QkS5C
         n5/eEfsy3Xv8rOxDpQY6S4WGbteBxe4aB36WpHnCQKWmg3S88vB1pOgk2k3ur57OwRAE
         P0jHYQrmrp5PVY775P9xRzw6t2r4MXLM0WrV5YWHbOC6Y/BLxqnwTdVQ0Qs18SH6r18G
         frBoODBE/xAJ0M6PMSR64DM+nyddamS3h03/mO/72kIxeL0cCF5h/qMHitTkz5H6Sddp
         KifN4e1+JOQ0O0sDfHdrhYHUOTJFMmvO3Z6vPUMnGHwARDDCwzll55HGvBS1KhtAu4y9
         18Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=b5C+ulXk8DtiFV4JWD7KK9B/636Yn3BYdNq9V7se8IQ=;
        b=7cqdHIsOUKaY/w128z/3gbuji9cuvGkYkfn/sPKWLadzebxgIF93jQY0kMuu7D5u32
         pz5HKtQde6cGX0j3riSqoWq5kDKqBJQFhxx+Jk051tYAQnFJJese9Rz/uyP7Zcommp6L
         mk4XtEZAcCgHn0U7kbAN8hE6ENyE+Z8bDn25MeTgz9AeTlSDqowTxg30lMsognrBWAkQ
         KZ2m8g4EYQauOuuHRdH3wrdrc23DWvTFAfG+Hrn4NrNISD2Mg4gkeUc8RCuP3CTe1cyp
         3cXjbaj8A+b/cP67OFoQjMhIG70pRzx5MZKjmMHc1FSiwszI67AQyc68q52DCkOFF1RF
         lanA==
X-Gm-Message-State: AOAM530M2n9qLlluSlvNJyWd8dm7hjwQAOGOF2kYrNvAx216y49vXcaz
        NkyoXRXQsk3Wk1SaYlLo9iWD7hAPPfI=
X-Google-Smtp-Source: ABdhPJywQHVMdwWzXRNzQnbUj7l0gau6d2J6BL/vkouVUlOhhdSI1dpQp4sJkOWx/rCODBxotVyGj6bV4c4=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:ced2:b0:148:a3e6:b48d with SMTP id
 d18-20020a170902ced200b00148a3e6b48dmr56863089plg.103.1641443346010; Wed, 05
 Jan 2022 20:29:06 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:27:05 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-24-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 23/26] KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
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

Add feature_config_ctrl for LORegions, which is indicated in
ID_AA64MMFR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Change trap_loregion() to use vcpu_feature_is_available()
to simplify checking of the feature's availability.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 229671ec3abd..f8a5ee927ecf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -365,6 +365,11 @@ static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -416,6 +421,15 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
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
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -947,6 +961,14 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	},
 };
 
+static struct id_reg_info id_aa64mmfr1_el1_info = {
+	.sys_reg = SYS_ID_AA64MMFR1_EL1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_lor,
+		NULL,
+	},
+};
+
 static struct id_reg_info id_dfr0_el1_info = {
 	.sys_reg = SYS_ID_DFR0_EL1,
 	.init = init_id_dfr0_el1_info,
@@ -976,6 +998,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
@@ -1050,10 +1073,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
-- 
2.34.1.448.ga2b2bfdf31-goog


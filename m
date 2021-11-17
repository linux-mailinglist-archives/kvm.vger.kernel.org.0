Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C8545416F
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhKQG4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbhKQG4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:46 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F44C061746
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:48 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id v23-20020a170902bf9700b001421d86afc4so569289pls.9
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ap+PS7CD+HFBr7r8+vNbRPns4hwGZn9RZNY8Os9x/I8=;
        b=ME8TBN6HNLGOmfWdS07tu+6rYpz8jFnzNkaM3AZinIB5Y5rSPGGpQSiFoHOMsTPTgR
         KB+BXxWvxfUtevsqjCwhMzybSqT2HJRuVPaCCd/iP0EHRDDmNTDBaeXD6IeucnltyX5V
         8wnPTb44HXZ181eXmc6VngO8oBOrDFP/wOdDuIZ/b2iUw1nXOCxe/qQQDzlTxnRj9lWe
         PPrXTJyGtiFWiEThG9Z1i55BWOYWpWgTv911tEvlcAKzKXMTlxqzPfA2Mu/keixChqpF
         HDJwXVj3GrfQzaJ0SeyfC97K4M+g6d/bN1Vn2cnoPn7etEJqpn3cb/dJU0o0svqJNUax
         y3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ap+PS7CD+HFBr7r8+vNbRPns4hwGZn9RZNY8Os9x/I8=;
        b=Bns02ssL5xUfwQqXXtDci11Eqo2i18iTL31K0k3XmOuCL8PJlKABy38VT0PhmZZFib
         ap8l5vkwE1hnAb9Laq9ZV6mIz+Zus6MMmH+cnIF9AOmRJI7XrBVpKdQAQbAhRZ6+68/x
         YYElzP1d220NZmXihDhShAb5UdiVrbUDgX42CAofkm3ZUkW+4AvOd/K4pMLA2PpIn9QE
         pnuJi+2djHuobIxOLsYk6+TuTa3LFhFB3xJmYlEWLT6Jt5FttRmBdV1If3ORIcLOz7vK
         wPMWi6hVt8ziI+12dmy3LlqNrsA/A/SCDwgSpvUatCvBH58Vvh/ypuZKWwdGaUda46ab
         gYUw==
X-Gm-Message-State: AOAM532e76CRIIWClhuaR8sxRs3DkMUF+HBYKkmGOVIGhd1I2Fwjm0Gj
        yQ4dG2+MM5FizszwMaKFGLV5yngi7H8=
X-Google-Smtp-Source: ABdhPJx22jUgmf1vQhrGDnEI3IA2ofCSFdssKrHCARSsL9OdUAakMfgccLuH/dwXswlHbXm2xj+dGZ0IezE=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:3509:: with SMTP id
 ls9mr6754492pjb.99.1637132028334; Tue, 16 Nov 2021 22:53:48 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:55 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-26-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 25/29] KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
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
 arch/arm64/kvm/sys_regs.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cb18d1fe0658..3d3b29515b8b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -469,6 +469,17 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
 	.cfg_val = MDCR_EL2_TTRF,
 };
 
+/* For ID_AA64MMFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_lor = {
+	.ftr_reg = SYS_ID_AA64MMFR1_EL1,
+	.ftr_shift = ID_AA64MMFR1_LOR_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = HCR_TLOR,
+	.cfg_val = HCR_TLOR,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -992,6 +1003,14 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
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
@@ -1034,6 +1053,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -1128,10 +1148,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
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
2.34.0.rc1.387.gb447b232ab-goog


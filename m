Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CF1429CAC
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhJLEjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbhJLEjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:39:00 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DCAC061766
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:53 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id m14-20020a63fd4e000000b00287791fb324so8049827pgj.7
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q7BixuP9It6rmSZII5to1B682tn/DwfVjd2jGHGuE3Y=;
        b=VGyjwy0JLnxlj+5/nSK7fzF48FMF95j1whwYEMpop9FWTB0rqlyROF9oshJ3QC19Ah
         /nWVAeJYXtbJeeOlLH1Hc9uwEfAtyGk8MUxmFTq19H8/qadkNx6jrZEnOkwURLzC2fUl
         igxGrUonWVrPb8y1F0DrvziuACcatliv7ZDhATMzOtkVF4HHKQv1Hjb7OBYAni2IPR+/
         tShJ+JcFQPQigr0Xzq/uFDjxCZfpv+E8aCD0o5d5RL9BKthxy7V7aHUj533ZCFAyxkRO
         ZIRjwMvfOuP1CUsBO4HcQZ6sG+oThFCDbNRhtPeEP8AfPXKh5RA4n8TfknOirMYZ7Oqh
         e7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q7BixuP9It6rmSZII5to1B682tn/DwfVjd2jGHGuE3Y=;
        b=1+XWr3mY1XAxlEHbT2V5Q9jU/QszhlfsAEKOEha7koVxAyj4wf0+n4szDS06tgJ1q1
         o7j+rMlQVwK0f1TPQpN5u6wI2Rvde4oINkT01YLW/QTcp4UpGSnw3yRYD3r3jqmud9Ce
         A60oxXAXEL49Zx17xzEqa1+pl5g1sbVDnzHEY3+MJIlR4FxLcXFTKJPDmAlwQ6TzVYL9
         4iZClxblwOQ0QFRd3UjaOtnbRTVsYn61k0RfIOI6MwLnXDNoWyALTXe0Cjf/sOSd2qOq
         S+r3MEr8utJPxx5Yk/17mieity7blMPxRKQNw9NSWOAb5EoeINCrAw30UT4Lp4w2+PP7
         fDRw==
X-Gm-Message-State: AOAM531H91jeD4aYmbFwG48KyDv5CYDhVLGe0hVxUGE1I9YNJRgcluzm
        hroKw3KSCu09q0XTyNViRwn3exdpDfk=
X-Google-Smtp-Source: ABdhPJw5rppfGPZ6lLyq9dLDd23bK7T/kn8o9AZfVh2XW/iGmZLrNXsPL87P/02l4KUEPKW2WmekxAQ68aU=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:2284:b0:43d:fc72:e565 with SMTP id
 f4-20020a056a00228400b0043dfc72e565mr29890632pfe.84.1634013413069; Mon, 11
 Oct 2021 21:36:53 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:32 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-23-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 22/25] KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
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
index 23a3bcac4986..68df4e4eba05 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -374,6 +374,17 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
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
@@ -767,6 +778,14 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
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
@@ -795,6 +814,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -891,10 +911,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
-- 
2.33.0.882.g93a45727a2-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC586454155
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhKQG4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbhKQG43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:29 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52767C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:31 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id e12-20020aa7980c000000b0049fa3fc29d0so1117850pfl.10
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yLVjb77owO5ybb+blXdLB2u8TBEDp8SiZFpXOiEwz6E=;
        b=fDzUBhciz6ab1h3rP9Ucku2G59ZHon7OMlm9GJaTcxGw2QIj3w2oxTr1XbvW+YZGLK
         7wlw21isyxEL1SzBvtRO/6hdnL6njQInjzEyBb2El4SNEGGElu1d4+EsGvx58kgvAnZM
         8Gz4R4bDwans0su5HW0IxJMKTcNsIDR45GF3PbE/M5ON0BtbzheJDgH3qDgKegWzIKAT
         tFxMfu1B4/TO71tiG8E2e62rlo237Abtbxy+MpcnGSQV+Xh+nRNyk7K2+ULWma3kgQDz
         O01BmklYF4syu1w6IWWxuSSa6AoJyckwb7/7v5xiN3vqEvebFLzUrS3vaFD+4jTLJLsA
         5Yxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yLVjb77owO5ybb+blXdLB2u8TBEDp8SiZFpXOiEwz6E=;
        b=KM9L1h1r39ML+CVhwASQYQbPyJGzsvj2iSeYbgo/gxVnmdeODidPwRb37U3rkPqG6p
         zQTBMBoER80bRIzHzM0YUMvBCfZi0XAQFDBoalDUoJBL+e/CKLmpAMDs1nYAnm5bxY53
         /z5RHgp5ngOSO1VP5npg3DMNIKQS7WqAOFxS5AnDY0xvSfkBIDA4Lb+IUCuri+J92MxH
         nUF4aWB3nU08CkCOoYSOBC23WNXLjMEpzkvIAtVGj+iTjvWzLl4jQLHVuPqm5AxbXPTM
         PfgkVZiObr99AefT8qrKmDtAV7ZGL2gdntxrMdMZTw4KoDk9nfujqRxBvsy8f+DbE9gQ
         +1mQ==
X-Gm-Message-State: AOAM533mP+m8TYYUFxV+jcaMXWIpA1g3M+SR4L2MuOC4jYN0ppFgO0Vr
        g5eapuCQReDGfEpHszlBSjqhkH1C0H8=
X-Google-Smtp-Source: ABdhPJwT4TE1Cp4Q7rnEHEKQedPKGeSfrSxBPQGD89L53thUMmYvU82rt7nCRoE3lbp7K0eH1lqvYb0pO6M=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr314180pjf.1.1637132010579; Tue, 16 Nov 2021 22:53:30 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:44 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-15-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 14/29] KVM: arm64: Make MVFR1_EL1 writable
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

This patch adds id_reg_info for MVFR1_EL1 to make it writable
by userspace.

There are only a few valid combinations of values that can be set
for FPHP and SIMDHP fields according to Arm ARM.  Return an error
when userspace tries to set those fields to values that don't match
any of the valid combinations.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5b16d422b37d..659ec880d527 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -686,6 +686,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_mvfr1_el1(struct kvm_vcpu *vcpu,
+			      const struct id_reg_info *id_reg, u64 val)
+{
+	unsigned int fphp, simdhp;
+	struct fphp_simdhp {
+		unsigned int fphp;
+		unsigned int simdhp;
+	};
+	/* Permitted fphp/simdhp value combinations according to Arm ARM */
+	struct fphp_simdhp valid_fphp_simdhp[3] = {{0, 0}, {2, 1}, {3, 2}};
+	int i;
+	bool is_valid_fphp_simdhp = false;
+
+	fphp = cpuid_feature_extract_unsigned_field(val, MVFR1_FPHP_SHIFT);
+	simdhp = cpuid_feature_extract_unsigned_field(val, MVFR1_SIMDHP_SHIFT);
+
+	for (i = 0; i < ARRAY_SIZE(valid_fphp_simdhp); i++) {
+		if (valid_fphp_simdhp[i].fphp == fphp &&
+		    valid_fphp_simdhp[i].simdhp == simdhp) {
+			is_valid_fphp_simdhp = true;
+			break;
+		}
+	}
+
+	if (!is_valid_fphp_simdhp)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -870,6 +900,11 @@ static struct id_reg_info id_mmfr0_el1_info = {
 			   S_FCT(ID_MMFR0_OUTERSHR_SHIFT, FCT_LOWER_SAFE),
 };
 
+static struct id_reg_info mvfr1_el1_info = {
+	.sys_reg = SYS_MVFR1_EL1,
+	.validate = validate_mvfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -881,6 +916,7 @@ static struct id_reg_info id_mmfr0_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_MMFR0_EL1)] = &id_mmfr0_el1_info,
+	[IDREG_IDX(SYS_MVFR1_EL1)] = &mvfr1_el1_info,
 	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
-- 
2.34.0.rc1.387.gb447b232ab-goog


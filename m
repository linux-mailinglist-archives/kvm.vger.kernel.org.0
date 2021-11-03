Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D199443D2E
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhKCGa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbhKCGaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:55 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B8AC061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:19 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x25-20020aa79199000000b0044caf0d1ba8so857841pfa.1
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=23B18KCm6Ef3G7/a/geAU0JJefv7D3zT1xrTavh52uo=;
        b=TJOFxqE5MKgPy2BU7Sw3QhOpxRNeKudKuKKjMFP3BxR4yJKXV8O2GszJPdJTLi914P
         3EWI/MTTzLwFoyVxXun5bBW7w7PjeHiXcT/pOhLcMtKZ3Y/vFU176tZ+yj+mmZg4N4KP
         1HZ55D9w2iPe0tawLlbshFprqWovMHF+a/i7ubcg966vwylt5un5aydqLaKKfcfKfYvD
         42K9dSyaMigT3QRT+Kf8hG0iHhZwIWNwP+SEbcbQ6ABkJZOEK1rpqEtklhSuteaYdMXI
         Wk11L8P8IC9oVFXJ/zcnmiMKqrRK2XN2+qJtrycqxmeXbPofqNkPOvGzBByVFvni9hem
         N92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=23B18KCm6Ef3G7/a/geAU0JJefv7D3zT1xrTavh52uo=;
        b=4A6v5+lw8ej2XtjTr73TpkfXd27Ts1aYgz6NrkpT6KyuN6LMU9J3H9Pn3T+Z561F+y
         jlEzIa4P3Zz/8w++AQwCnxQwCQUHRC5ck6syMtRD4y6CZIXDuJDTgj3EBVTMT2N/ZAR2
         w9wkqo8A/z0iyEBQ9aMjEvgzy2/9GFxISiYfCTdiu1oWWuyHL9ZIbIWwvLeqvi2lzwaY
         1eiBpt7mBBQuaxKuVCdGJLIZ9mHGA7Mq/msgP1r0PeTcHremZz8iwIZGL6UZmZG/n+YP
         gcHbj+SkpLrDGB6gk+4A9+2Hs5JJ0xq+c0XNIBZ+QjmP3K482SK0EzXf+RRp5RcD4LLZ
         Y+gg==
X-Gm-Message-State: AOAM533yqTLzBIuxPWhgWrWbdjodbFdmsp3OhIejE0CMaYje+4Qku/eS
        01ypQTNYqG9SU9U+RF22DL9wuDeWqKg=
X-Google-Smtp-Source: ABdhPJx0JzpdmVa2hGMrf0I8g1N0qU+cSRr0gP5gtA+oqT2tR+iwo2LuP4bq6crb6rDwpf/AuaG6Vsn/aSU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:6b0c:b0:13f:aaf4:3db4 with SMTP id
 o12-20020a1709026b0c00b0013faaf43db4mr36190330plk.46.1635920899378; Tue, 02
 Nov 2021 23:28:19 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:07 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-16-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 15/28] KVM: arm64: Make MVFR1_EL1 writable
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
index cfa3624ee081..99dc2d622df2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -675,6 +675,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -846,6 +876,11 @@ static struct id_reg_info id_mmfr0_el1_info = {
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
@@ -857,6 +892,7 @@ static struct id_reg_info id_mmfr0_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_MMFR0_EL1)] = &id_mmfr0_el1_info,
+	[IDREG_IDX(SYS_MVFR1_EL1)] = &mvfr1_el1_info,
 	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
-- 
2.33.1.1089.g2158813163f-goog


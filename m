Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788194B4256
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbiBNHAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:00:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbiBNHAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:00:16 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0197575F7
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:00:08 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 2-20020aa79202000000b004cef2fc59f0so11088009pfo.12
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AlRY+TVEbXq6jkXsggOYA+sdawrTQOSBDRRIDVsnbf4=;
        b=gOQtZBYK4/O+UGc2DlGN3H2S4bbXG+/Ysw+X1OToYjnAmANzwJ00NKQDaEden8R6Lt
         EIks1VH/ELQa/Evwz2khcecWxunjNUdoPyJnoDia7e0nOfCmfl2WIjUCiZO0dFohx7xu
         3ffjl8dBUtMXu2aLvUFqnTrWUEjHQBhiBBUWcNVA07TaIPCjoTA5gVcC5Y2mid+IC2fQ
         6nFH+MPVzCX2FZWa/afdcmzaWOzb9bxUiLX/EV2uHOW/5Md7QU9VLbOYf+sYlvpEo6Fx
         Z6mwN+G+TEcs0x0vCmQTseG3ZeRFY/0Rp8Xvw2NmKP13WhVZBcfzdd9LSrEF1kt51hvn
         0vTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AlRY+TVEbXq6jkXsggOYA+sdawrTQOSBDRRIDVsnbf4=;
        b=ztqzkjpItcIlAApHy5xaH9e1ikOkvhJUm1yXLsDgDC1BTGSN6um4qE7glIIg+Sl2hF
         ptVErn3U8dMpIBQKAIzqeWgusL+xLvWlAPmI7xaEEI0TJp1sgvY4mG1dMBgLBgrHpThN
         8yj1Wtv2MJSliSg4JcP7KSqqyuLFd9P9WXW2S6EXAFRUwIjKG9jbJ26TwMjAB85pSRv+
         WdRI7Oxn6HNiIyMZtJEZcC2X2g7a7cV3gxxJ+c91y/OxZ/uZ3j9MwGGHAF3JMYIZhXZW
         dtFoP0S9dHnUUsnJgwiFNrMVUd8MvRih6tHucss/ghiKR3yiVnaGwTyDiicNLFUA43PC
         OI9Q==
X-Gm-Message-State: AOAM531ptgd7DYVem5KmvCU8gdaRGxYaOB1/SOg4q4D2rsrOu8ha7lqa
        /pAF3YZNDUmtTSEMcqfDxOooFyesLJk=
X-Google-Smtp-Source: ABdhPJwdP31lN+BaOgTpUFbEnsC6ugEKu7lGxqBZRuiZPsew2z5H4gOvrp4Hl8/IoytO1+AVbR2qYnOOFmI=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:e40f:: with SMTP id
 hv15mr1639878pjb.1.1644822008078; Sun, 13 Feb 2022 23:00:08 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:30 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-12-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 11/27] KVM: arm64: Make ID_AA64DFR0_EL1 writable
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

This patch adds id_reg_info for ID_AA64DFR0_EL1 to make it writable
by userspace.

Return an error if userspace tries to set PMUVER field of the
register to a value that conflicts with the PMU configuration.

Since number of context-aware breakpoints must be no more than number
of supported breakpoints according to Arm ARM, return an error
if userspace tries to set CTX_CMPS field to such value.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 83 +++++++++++++++++++++++++++++++++------
 1 file changed, 71 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1c137f8c236f..ae379755fa26 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -594,6 +594,45 @@ static int validate_id_aa64mmfr1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static bool id_reg_has_pmu(u64 val, u64 shift, unsigned int min)
+{
+	unsigned int pmu = cpuid_feature_extract_unsigned_field(val, shift);
+
+	/*
+	 * Treat IMPLEMENTATION DEFINED functionality as unimplemented for
+	 * ID_AA64DFR0_EL1.PMUVer/ID_DFR0_EL1.PerfMon.
+	 */
+	if (pmu == 0xf)
+		pmu = 0;
+
+	return (pmu >= min);
+}
+
+static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_info *id_reg, u64 val)
+{
+	unsigned int brps, ctx_cmps;
+	bool vcpu_pmu, dfr0_pmu;
+
+	brps = cpuid_feature_extract_unsigned_field(val, ID_AA64DFR0_BRPS_SHIFT);
+	ctx_cmps = cpuid_feature_extract_unsigned_field(val, ID_AA64DFR0_CTX_CMPS_SHIFT);
+
+	/*
+	 * Number of context-aware breakpoints can be no more than number of
+	 * supported breakpoints.
+	 */
+	if (ctx_cmps > brps)
+		return -EINVAL;
+
+	vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
+	dfr0_pmu = id_reg_has_pmu(val, ID_AA64DFR0_PMUVER_SHIFT, ID_AA64DFR0_PMUVER_8_0);
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_pmu ^ dfr0_pmu)
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -637,8 +676,25 @@ static void init_id_aa64isar1_el1_info(struct id_reg_info *id_reg)
 		id_reg->vcpu_limit_val &= ~PTRAUTH_MASK;
 }
 
+static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
+{
+	u64 limit = id_reg->vcpu_limit_val;
+
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	limit = cpuid_feature_cap_perfmon_field(limit, ID_AA64DFR0_PMUVER_SHIFT,
+						ID_AA64DFR0_PMUVER_8_4);
+	/* Limit debug to ARMv8.0 */
+	limit &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
+	limit |= (FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6));
+
+	/* Hide SPE from guests */
+	limit &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
+
+	id_reg->vcpu_limit_val = limit;
+}
+
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
-				     const struct id_reg_info *idr)
+					 const struct id_reg_info *idr)
 {
 	return vcpu_has_sve(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
 }
@@ -655,6 +711,12 @@ static u64 vcpu_mask_id_aa64isar1_el1(const struct kvm_vcpu *vcpu,
 	return vcpu_has_ptrauth(vcpu) ? 0 : PTRAUTH_MASK;
 }
 
+static u64 vcpu_mask_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
+					 const struct id_reg_info *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER);
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR0_GIC),
@@ -704,6 +766,13 @@ static struct id_reg_info id_aa64mmfr1_el1_info = {
 	.validate = validate_id_aa64mmfr1_el1,
 };
 
+static struct id_reg_info id_aa64dfr0_el1_info = {
+	.sys_reg = SYS_ID_AA64DFR0_EL1,
+	.init = init_id_aa64dfr0_el1_info,
+	.validate = validate_id_aa64dfr0_el1,
+	.vcpu_mask = vcpu_mask_id_aa64dfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -715,6 +784,7 @@ static struct id_reg_info id_aa64mmfr1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
@@ -1643,17 +1713,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		val &= ~(id_reg->vcpu_mask(vcpu, id_reg));
 
 	switch (id) {
-	case SYS_ID_AA64DFR0_EL1:
-		/* Limit debug to ARMv8.0 */
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_AA64DFR0_PMUVER_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
-		/* Hide SPE from guests */
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
-		break;
 	case SYS_ID_DFR0_EL1:
 		/* Limit guests to PMUv3 for ARMv8.4 */
 		val = cpuid_feature_cap_perfmon_field(val,
-- 
2.35.1.265.g69c8d7142f-goog


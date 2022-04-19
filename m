Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCC050650D
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349033AbiDSHAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349063AbiDSHAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:16 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89D72AE2D
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:30 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q6-20020a170902eb8600b001588e49dcaaso9253661plg.9
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YXalEvL5V6OCiUslrdBdC3x5nYT2WOf4a/IV/CCw06k=;
        b=PBolxCNPqF/rYwCSGkME7PiAyjXXHuCvjT0iZNEZCb4UsNO/plPhzccwgGr3BMSa8c
         qYIv3k9YmvEm0jnHH8aOEfDd+Jz3wW8Pal3dbZm9Zr89ptohuxfunoyyo690KChdXylr
         BAnxcpKTeQqbIxZeQsKehjYF/qG93pGRQEtb3wEri0PgRyej+PlRhFlyhZhU1VMM25FG
         2XNAvsn6BDxTp6+Ol1AO6/cMdXZMNHkoiHvX1S+zju41nFgQs7zJ6P+1qxSqqFMeeyPb
         8wU07LHBjIKEM+a0DsU8p638g7ca57j5iBENAizVjw6KVT8brSDjAjq4sQnRneTW4F9r
         LlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YXalEvL5V6OCiUslrdBdC3x5nYT2WOf4a/IV/CCw06k=;
        b=xh9NPE8FJNtrlw0ajRHYI0ONUpYjpLypAp70dwiWbowJ9Z8EiU7e5ihyaSHzWv9jUx
         Kp/N/LU3x7IXzCqZ49BdS+3BzbpMQzF6IWRM8SJf2VuV15vyHmiX5xj8hH9L3PPpLU4Q
         DhFxoVRXBxuVjF+UpgMRGVCT8GwBJ5DfpRatwEnYgzyWMsXVvRE542YQLru/9lkFCs2s
         4ijYBOe38VuKxlHmbDt2S8QfJJTsMVzGjzbgFoT1JwtCuEYD8rh7LVNogbrvRxcueYgH
         UjQF/RlvYDWS8KItbHp56pNVbc8AstfyzpMgV4LFJaXgir+tAHtoWh3LkgFci42M5UW4
         Yw4A==
X-Gm-Message-State: AOAM530jlPbWGWXGWgW7RQQQU3Lk7EQfs7yaIHHO40lafjdbtSTftC/Q
        HLZy2u4hIzPgNIzYZqiyUvM//neUOJA=
X-Google-Smtp-Source: ABdhPJwNeyv4uuU7jneD4R263Q3CDhNQoNxJyLlw5PFrvBvjhbMrkb5ffdVyboN5y95J7aLLHm8T4JnHZ9A=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1f0b:b0:50a:8181:fecb with SMTP id
 be11-20020a056a001f0b00b0050a8181fecbmr6190053pfb.12.1650351450390; Mon, 18
 Apr 2022 23:57:30 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:21 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-16-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 15/38] KVM: arm64: Make ID_AA64DFR0_EL1/ID_DFR0_EL1 writable
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

This patch adds id_reg_desc for ID_AA64DFR0_EL1 and ID_DFR0_EL1
to make them writable by userspace.

Return an error if userspace tries to set PMUVER/PerfMon field
of ID_AA64DFR0_EL1/ID_DFR0_EL1 to a value that conflicts with the
PMU configuration.

When a value of ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON on the
host is 0xf, which means IMPLEMENTATION DEFINED PMU supported, KVM
erroneously expose the value for the guest as it is even though KVM
doesn't support it for the guest. In that case, since KVM should
expose 0x0 (PMU is not implemented), change the initial value of
ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON for the guest to 0x0.
If userspace requests KVM to set them to 0xf, which shouldn't be
allowed as KVM doesn't support IMPLEMENTATION DEFINED PMU for the
guest, ignore the request (set the fields to 0x0 instead) so that
a live migration from the older kernel works fine.

Since number of context-aware breakpoints must be no more than number
of supported breakpoints according to Arm ARM, return an error
if userspace tries to set CTX_CMPS field to such value.

Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h |   2 +-
 arch/arm64/kvm/sys_regs.c           | 164 ++++++++++++++++++++++++----
 2 files changed, 143 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 7a009d4e18a6..7ed2d32b3854 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -554,7 +554,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
 
 	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
 	if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
-		val = 0;
+		return (features & ~mask);
 
 	if (val > cap) {
 		features &= ~mask;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 400fa7ff582f..9eca085886f5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -654,6 +654,75 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_desc *id_reg, u64 val)
+{
+	unsigned int brps, ctx_cmps;
+	u64 pmu, lim_pmu;
+	u64 lim = id_reg->vcpu_limit_val;
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
+	/*
+	 * KVM will not set PMUVER to 0xf (IMPLEMENTATION DEFINED PMU)
+	 * for the guest because KVM doesn't support it.
+	 * If userspace requests KVM to set the field to 0xf, KVM will treat
+	 * that as 0 instead of returning an error since userspace might do
+	 * that when the guest is migrated from a host with older KVM,
+	 * which sets the field to 0xf when the host value is 0xf.
+	 */
+	pmu = cpuid_feature_extract_unsigned_field(val, ID_AA64DFR0_PMUVER_SHIFT);
+	pmu = (pmu == 0xf) ? 0 : pmu;
+	lim_pmu = cpuid_feature_extract_unsigned_field(lim, ID_AA64DFR0_PMUVER_SHIFT);
+	if (pmu > lim_pmu)
+		return -E2BIG;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (kvm_vcpu_has_pmu(vcpu) ^ (pmu >= ID_AA64DFR0_PMUVER_8_0))
+		return -EPERM;
+
+	return 0;
+}
+
+static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
+				const struct id_reg_desc *id_reg, u64 val)
+{
+	u64 pmon, lim_pmon;
+	u64 lim = id_reg->vcpu_limit_val;
+
+	/*
+	 * KVM will not set PERFMON to 0xf (IMPLEMENTATION DEFINED PERFMON)
+	 * for the guest because KVM doesn't support it.
+	 * If userspace requests KVM to set the field to 0xf, KVM will treat
+	 * that as 0 instead of returning an error since userspace might do
+	 * that when the guest is migrated from a host with older KVM,
+	 * which sets the field to 0xf when the host value is 0xf.
+	 */
+	pmon = cpuid_feature_extract_unsigned_field(val, ID_DFR0_PERFMON_SHIFT);
+	pmon = (pmon == 0xf) ? 0 : pmon;
+	lim_pmon = cpuid_feature_extract_unsigned_field(lim, ID_DFR0_PERFMON_SHIFT);
+	if (pmon > lim_pmon)
+		return -E2BIG;
+
+	if (pmon == 1 || pmon == 2)
+		/* PMUv1 or PMUv2 is not allowed on ARMv8. */
+		return -EINVAL;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (kvm_vcpu_has_pmu(vcpu) ^ (pmon >= ID_DFR0_PERFMON_8_0))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -703,6 +772,31 @@ static void init_id_aa64isar2_el1_desc(struct id_reg_desc *id_reg)
 		id_reg->vcpu_limit_val &= ~ISAR2_PTRAUTH_MASK;
 }
 
+static void init_id_aa64dfr0_el1_desc(struct id_reg_desc *id_reg)
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
+static void init_id_dfr0_el1_desc(struct id_reg_desc *id_reg)
+{
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	id_reg->vcpu_limit_val =
+		cpuid_feature_cap_perfmon_field(id_reg->vcpu_limit_val,
+						ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_4);
+}
 
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
 					 const struct id_reg_desc *idr)
@@ -729,6 +823,18 @@ static u64 vcpu_mask_id_aa64isar2_el1(const struct kvm_vcpu *vcpu,
 }
 
 
+static u64 vcpu_mask_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
+					 const struct id_reg_desc *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER);
+}
+
+static u64 vcpu_mask_id_dfr0_el1(const struct kvm_vcpu *vcpu,
+				     const struct id_reg_desc *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
+}
+
 static int validate_id_reg(struct kvm_vcpu *vcpu,
 			   const struct id_reg_desc *id_reg, u64 val)
 {
@@ -2186,28 +2292,9 @@ static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 	const struct id_reg_desc *id_reg = get_id_reg_desc(id);
 
 	if (id_reg)
-		return __read_id_reg(vcpu, id_reg);
-
-	val = read_kvm_id_reg(vcpu->kvm, id);
-	switch (id) {
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
-	case SYS_ID_DFR0_EL1:
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_DFR0_PERFMON_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
-		break;
-	}
+		val = __read_id_reg(vcpu, id_reg);
+	else
+		val = read_kvm_id_reg(vcpu->kvm, id);
 
 	return val;
 }
@@ -4028,15 +4115,48 @@ static struct id_reg_desc id_aa64mmfr0_el1_desc = {
 	},
 };
 
+static struct id_reg_desc id_aa64dfr0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64DFR0_EL1),
+	/*
+	 * PMUVER doesn't follow the ID scheme for fields in ID registers.
+	 * So, it will be validated by validate_id_aa64dfr0_el1.
+	 */
+	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER),
+	.init = init_id_aa64dfr0_el1_desc,
+	.validate = validate_id_aa64dfr0_el1,
+	.vcpu_mask = vcpu_mask_id_aa64dfr0_el1,
+	.ftr_bits = {
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_DOUBLELOCK_SHIFT, 0xf),
+	},
+};
+
+static struct id_reg_desc id_dfr0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_DFR0_EL1),
+	/*
+	 * PERFMON doesn't follow the ID scheme for fields in ID registers.
+	 * So, it will be validated by validate_id_dfr0_el1.
+	 */
+	.ignore_mask = ARM64_FEATURE_MASK(ID_DFR0_PERFMON),
+	.init = init_id_dfr0_el1_desc,
+	.validate = validate_id_dfr0_el1,
+	.vcpu_mask = vcpu_mask_id_dfr0_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
 /* A table for ID registers's information. */
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	/* CRm=1 */
+	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
+
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
 
+	/* CRm=5 */
+	ID_DESC(ID_AA64DFR0_EL1, &id_aa64dfr0_el1_desc),
+
 	/* CRm=6 */
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
-- 
2.36.0.rc0.470.gd361397f0d-goog


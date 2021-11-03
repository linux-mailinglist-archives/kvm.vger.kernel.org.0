Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB59443D25
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhKCGau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbhKCGas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:48 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ED4C061203
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:13 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x25-20020aa79199000000b0044caf0d1ba8so857724pfa.1
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=odNn+kh1mJM9Vd30nM7BMUJpocE6S6YUrl3newH0ovg=;
        b=Uk/WrXnp6UTWiI4qWkD9cWC5dtMD9py++anoNbqWH45LTS0dTWf1XDifA3JnVp2wzf
         cM4Svvigvs6rdongOug1BrvZQJ3ExdllQjyUkpwHONJdXEX+cAaaTBEMcDqYIsL3UFrL
         +FeDBc6sKGmHvdRqruCtmfGaiPvtTzhzDPrEFKCwL2hiVU2+7+OfJ7ntHcgpG8GcpkEg
         O/o0aCHXFRgrQHQ4+aSdmFYdAueE2BOyoFI9xArIpb47uOuP+/4L6ne0v8z/AoA3do4p
         VYVptKUmCpuuBOQxPA1DyylxdM/OoXCT7N02uHaVTkY+xNFdKUelHARVQzm1acTqE8E5
         6/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=odNn+kh1mJM9Vd30nM7BMUJpocE6S6YUrl3newH0ovg=;
        b=pdlCueoPJs73Q4pjWPGjtTwSrSoxLSQZq9ovERdyeCi+vG1mvFnTavl3fZGHEhQY3t
         ElSu1Hwn+bNWImk/rZTtyN6hV42xAt6WzsK3S/I3+Box2ujRZXGLvfSk0kvKw4VY5pqw
         xOgt00K1tSxaVjGcfki2/XnUbC1U4D/nFhr35s/PwLRp5H9xfrDFE4KHC4BGwF1efkGQ
         YUTTjGQyNT1MTH76mHbP46hLjoVi8Ri1Aze6SDcrWez9jjPkrqeXSE0eygp92KejU08Q
         UbMerxtxoLSQKb/WxvquQ6uckk0MSKil4k+hYUYLeaILFPfYBB9dZE/7JykBodi9Ldca
         hW8Q==
X-Gm-Message-State: AOAM531av39RV28WaENOwKT1EzaTiOJCSGBO4v4PiBCb8JcuvYwqWl/Z
        DNvB0nftToXHDs3kRUNjI3E0kWAspcE=
X-Google-Smtp-Source: ABdhPJzwNcnZ5x5fy33mJFN2zMuF3k+sEoLH7Zqcea22WcEnEgYTEVa6HyxhzXnd/IokK2/cxHx5dZ+fymg=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:23cc:b0:481:1399:cc40 with SMTP id
 g12-20020a056a0023cc00b004811399cc40mr17145121pfc.7.1635920892456; Tue, 02
 Nov 2021 23:28:12 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:03 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-12-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 11/28] KVM: arm64: Make ID_AA64DFR0_EL1 writable
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

This patch adds id_reg_info for ID_AA64DFR0_EL1 to make it writable
by userspace.

Return an error if userspace tries to set PMUVER field of the
register to a value that conflicts with the PMU configuration.

Since number of context-aware breakpoints must be no more than number
of supported breakpoints according to Arm ARM, return an error
if userspace tries to set CTX_CMPS field to such value.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 84 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 73 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7c1ac456dc94..54bc3641d582 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -615,6 +615,45 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -651,6 +690,23 @@ static void init_id_aa64isar1_el1_info(struct id_reg_info *id_reg)
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
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     const struct id_reg_info *idr)
 {
@@ -674,6 +730,14 @@ static u64 get_reset_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
 	       idr->vcpu_limit_val : (idr->vcpu_limit_val & ~PTRAUTH_MASK);
 }
 
+static u64 get_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER)));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
@@ -718,6 +782,14 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
 	.validate = validate_id_aa64mmfr0_el1,
 };
 
+static struct id_reg_info id_aa64dfr0_el1_info = {
+	.sys_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_check_types = S_FCT(ID_AA64DFR0_DOUBLELOCK_SHIFT, FCT_LOWER_SAFE),
+	.init = init_id_aa64dfr0_el1_info,
+	.validate = validate_id_aa64dfr0_el1,
+	.get_reset_val = get_reset_id_aa64dfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -729,6 +801,7 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
@@ -1566,17 +1639,6 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
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
2.33.1.1089.g2158813163f-goog


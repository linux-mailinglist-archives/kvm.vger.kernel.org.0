Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FBB45414C
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhKQG4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbhKQG4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:04 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF498C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:06 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x1-20020a17090a294100b001a6e7ba6b4eso841430pjf.9
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xIn1TXsOInH4444HBtq8lDE6nz5k0hEewQ+rXZOcsIo=;
        b=RubVz5vGyInFZsyOsKQbph78wzeGOs27T9Z3/e1OzOz0GK8ra7LTlWSCfJX57EC9Cb
         LQjSU7gdcytATbmn1/T8Jiq/nHHVJ/mSvgFMtSpGHvao8Fwgd4wNtcKhhiUpUFkNokqK
         bwYTwyifKaj5au/rfC7Ee8GyrrAEgrUxm8GQ4fKrafiB/J2IMk1+XXSV30Gri7npBHs5
         6cvPjPzgAHsDbs2X4SR5GO5aIsZCYhQ2N2RksEX8uQNwbtpDSZTUbrQ0w0opO9BjjteF
         RlwcFSohKKnjlVjWqzzn8IGAD8VsE9ZUb3H2uFSt2e/t1B8mhqO86lZ3EOwwZ1HgFUge
         H5IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xIn1TXsOInH4444HBtq8lDE6nz5k0hEewQ+rXZOcsIo=;
        b=Y+FPSP+KFfmJGQ0UPjwNbIa80gpQ3sKGPVNbtB1vo8Bgm/jiZvKSo02i0RwYrHaDdN
         NJr3ngYguIspa/4rPOua8As/blmM6t6ri5nIohr2WZ/NWWtZ7huokZxZo60DpWdQWLby
         zorokB08y6j2HcrGn/SSWimyeoyzJHtF7RGDaXwkcJgWzaKPpEPPZFlgAonUvH2drS/v
         yiMiE4ZEHpXBbUASd1oQH979E4NQL7RCJNmZZ+DJgLTQhREEcWPv/uUP60Hrnc1OOO6j
         zraZKaIWuxL5kVEe8USMDOZ+T7fMxnYGA+dz1a/vLCoPFOuwRsSknYh9esunZF7Ga3kR
         mU7w==
X-Gm-Message-State: AOAM533ETB4rW8+JEkvkMmX5EntuoOjUGpMRvUWvjZXr1JgVIhtVEhcw
        PXsNNFjxpKVS5/+Q7/P9alTlptNnd1Y=
X-Google-Smtp-Source: ABdhPJzViDRuBcyE/NWMOeuexd9lVDAnAWnZc3xo/3UeavDavxUZRDOs2MBp/eMgCfy7MThZKNO4ybEXDiY=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:1208:b0:143:e4e9:4ce3 with SMTP id
 l8-20020a170903120800b00143e4e94ce3mr753877plh.21.1637131986440; Tue, 16 Nov
 2021 22:53:06 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:40 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-11-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 10/29] KVM: arm64: Make ID_AA64DFR0_EL1 writable
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
index 772e3d3067b2..0faf458b0efb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -626,6 +626,45 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -669,6 +708,23 @@ static void init_id_aa64isar1_el1_info(struct id_reg_info *id_reg)
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
@@ -698,6 +754,14 @@ static u64 get_reset_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
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
@@ -742,6 +806,14 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
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
@@ -753,6 +825,7 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
@@ -1604,17 +1677,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), gic_lim);
 		}
 		break;
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
2.34.0.rc1.387.gb447b232ab-goog


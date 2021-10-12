Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A3D429C8C
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhJLEig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhJLEif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:35 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE545C061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:34 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id v22-20020a170902e8d600b0013eed5613f1so8393981plg.10
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KkXFZ5Fme7Kzy6UMAllI6J6cKTiNLiuGaTgPl7tFhoc=;
        b=gNWTCyHt0F+Tgvg9IjH1MQsh4TR7Z/ZVpwe1d0n6s1PxESO4F3WckfgA0IFJR+4tn1
         BrtW2efC0MMgaI4/C1g8YwITxHGdB4kUZ8wLio9087ilyqc9MkdkTM5VcR8GGZVdnnTi
         C4dix4cTMWXtL1S55G+HZOYWpktnCDcr0foHyFoJu3MczBgMQQVGsAhhUogHjuB6MlUM
         1GuIC4m5jLesSIHV4l7obvirl8Dh/035/DnD5RnDlOgtzH4urkuhgGTc1/+if+XBxq4g
         KjJDD0rV93rZv/LytfXCBIvF3/Ei+xCOLf7Mii0kfNbDKXYS8fASBPTK9gv1TluP05hb
         0nmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KkXFZ5Fme7Kzy6UMAllI6J6cKTiNLiuGaTgPl7tFhoc=;
        b=izyUSFxOsu8hHCJ2kEQ0DUP/p/AnrP3xZOHxblx7XY05n+cmPaubKsqZft5fXBHtL0
         jr/I1rDGoKHGKct4zQd47M639KaeNItbp1/EV7pfpTyIc9Qzt5FjYVRZLunwFNXJT8e9
         Uh6Eq5i1VY6dZ97x2L0bbhdeqEW8Xqlhw4hBvb08uclSCW0h+IXKQVyDxb8d3+PQKrvB
         HR+LG/ancCi0LgkDr1y1u2JYunm8hwVXYk7uwqlLtMA6Jy+JzdG2QJoFjlnk6uzxjf/x
         nD45iKgiWozqXxNRqLNqYm7xLU8m3+ox3hT+Yvi35S/412+tmoa54qtjvf1rUAAWqY1T
         1I/w==
X-Gm-Message-State: AOAM533n17D30pBDhYQgTsi7K01jboXE+2pFxwVOZq4HUecA/oEU+mOy
        OTzLuqOruMQ3Fi5ssHpq2iXUn13llVs=
X-Google-Smtp-Source: ABdhPJyzBf51TEcN/HoLmrN431l4sJxIHytNAgq2tIPPD+LnRTXbAwEq84O2Hau4z9V+wwNwWLecscNAgN0=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90a:8b8d:: with SMTP id
 z13mr296118pjn.0.1634013393949; Mon, 11 Oct 2021 21:36:33 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:20 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-11-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 10/25] KVM: arm64: Make ID_AA64DFR0_EL1 writable
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
 arch/arm64/kvm/sys_regs.c | 108 ++++++++++++++++++++++++++++++++++----
 1 file changed, 97 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7819a07ee248..61e61f4bb81c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -402,6 +402,46 @@ static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu, u64 val)
 	return 0;
 }
 
+static bool id_reg_has_pmu(u64 val, u64 shift, u64 min)
+{
+	u64 pmu = ((val >> shift) & 0xf);
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
+static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	unsigned int brps, ctx_cmps;
+	bool vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
+	bool dfr0_pmu = id_reg_has_pmu(val, ID_AA64DFR0_PMUVER_SHIFT,
+				       ID_AA64DFR0_PMUVER_8_0);
+
+	brps = cpuid_feature_extract_unsigned_field(val,
+						ID_AA64DFR0_BRPS_SHIFT);
+	ctx_cmps = cpuid_feature_extract_unsigned_field(val,
+						ID_AA64DFR0_CTX_CMPS_SHIFT);
+
+	/*
+	 * Number of context-aware breakpoints can be no more than number of
+	 * supported breakpoints.
+	 */
+	if (ctx_cmps > brps)
+		return -EINVAL;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_pmu ^ dfr0_pmu)
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit;
@@ -445,6 +485,47 @@ static void init_id_aa64isar1_el1_info(struct id_reg_info *id_reg)
 				 (id_reg->sys_val & ~PTRAUTH_MASK);
 }
 
+/*
+ * ID_AA64DFR0_EL1.PMUVer/ID_DFR0_EL1.PerfMon == 0xf indicates
+ * IMPLEMENTATION DEFINED form of performance monitors supported,
+ * PMUv3 not supported (NOTE: 0x0 indicates PMU is not supported).
+ * This function is to cap a value of those two fields with the
+ * given 'cap_val' treating 0xf in the fields as 0.
+ */
+static u64 id_reg_cap_pmu(u64 val, u64 shift, u64 cap_val)
+{
+	u64 mask = 0xf;
+	u64 pmu;
+
+	pmu = (val >> shift) & mask;
+	pmu = (pmu == 0xf) ? 0 : pmu;
+	pmu = min(pmu, cap_val);
+
+	val &= ~(0xfULL << shift);
+	val |= (pmu & 0xf) << shift;
+	return val;
+}
+
+static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
+{
+	u64 limit;
+
+	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	limit = id_reg->sys_val;
+
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	limit = id_reg_cap_pmu(limit, ID_AA64DFR0_PMUVER_SHIFT,
+			       ID_AA64DFR0_PMUVER_8_4);
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
 				     struct id_reg_info *idr)
 {
@@ -468,6 +549,14 @@ static u64 get_reset_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
 	       idr->vcpu_limit_val : (idr->vcpu_limit_val & ~PTRAUTH_MASK);
 }
 
+static u64 get_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+				     struct id_reg_info *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER)));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.init = init_id_aa64pfr0_el1_info,
@@ -497,6 +586,13 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 	.get_reset_val = get_reset_id_aa64isar1_el1,
 };
 
+static struct id_reg_info id_aa64dfr0_el1_info = {
+	.sys_reg = SYS_ID_AA64DFR0_EL1,
+	.init = init_id_aa64dfr0_el1_info,
+	.validate = validate_id_aa64dfr0_el1,
+	.get_reset_val = get_reset_id_aa64dfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -508,6 +604,7 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 };
@@ -1346,17 +1443,6 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
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
2.33.0.882.g93a45727a2-goog


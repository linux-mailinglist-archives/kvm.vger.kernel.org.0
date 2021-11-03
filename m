Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6939C443D15
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhKCGaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbhKCGaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:02 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C67EC061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:27:26 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id bq14-20020a05620a468e00b0046335b327e9so1428075qkb.23
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=n5Mpm1dPS5qrwYaJYU/agwQssFs98KR5NEscCLDHrDk=;
        b=ABd1koV8Gl2hJTJlzKQ2TE4i0OZM6joq3RY59RXxM78F5WprMLFsfcFyrasCljyITD
         OAuHWRzVkhEgUYg/9UiOGSarEqfDsv7z8ihB9IMACLrgqxFVPzNrNZNcE/o3qxfyrvBi
         qxITEXj6LAe5KFxUkA3kbAhJ8Z+gPSpWIEkPsKV7uK+IN/gxNPRYeIFomGHAT1wSDVtj
         7axcVo+RR7e2CHo9HzXVMAupRNaJSTSe5tnL+dxGAEPW2+IcENHVw0wMmTKtC/gPlzCF
         vNFCTZCYiMUoul0kMxAOtPLIoZjYX+n4s8IBr+IeLGXh8RyTVrSt2V4SPwmRVGSfiCCP
         BLTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=n5Mpm1dPS5qrwYaJYU/agwQssFs98KR5NEscCLDHrDk=;
        b=pqHPIN11P6yo353AvV6dH/ir7ywcocd5B4oxC4tVLXehH+RO9sz/C5m20bxSuu/OGk
         T4G49fquP58jOOOd4fqf2maaNimfmHyxURaRDzAlWmAdP/VPobD5f2CuOleuaApelJe3
         i6S7FEgaH36I7qaFQR65xoNlwvPgoBKi/y5dcVlLnoxF5Azrfu3SfgvHxMJggDBN/k89
         KlGrj3yridhC28wD7UL+uQMMQ5oeP3AZldlAH5NEtOVnozU3dYLy1NE2FAJ7DkrG09RV
         abDXFubRf+DYy54SdxgFy/IjnAauWhuTkchNcNPwacxIUOEqPP/pQmzMDYD1Y3Rg+PjM
         MFHg==
X-Gm-Message-State: AOAM531pJ87pkaXQBnYk93hFnlxm6gFJsx9RYhLSIVldtLQRhySacNHQ
        zkqZZcU+IZAG7IS6O7YSz//dOiZtZpE=
X-Google-Smtp-Source: ABdhPJz/OH1hMFPzW8wb6ElpnTc74oWf3BDGaQL86sDvpE3n7HWvwsPReTOA/V/bduCiFdD2eoOskTKhtQM=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:ac8:5a4b:: with SMTP id o11mr44697222qta.59.1635920845521;
 Tue, 02 Nov 2021 23:27:25 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:24:54 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-3-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 02/28] KVM: arm64: Save ID registers' sanitized value
 per vCPU
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

Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
registers' sanitized value in the array for the vCPU at the first
vCPU reset. Use the saved ones when ID registers are read by
userspace (via KVM_GET_ONE_REG) or the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
 arch/arm64/kvm/sys_regs.c         | 24 ++++++++++++++++--------
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9b5e7a3b6011..0cd351099adf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -145,6 +145,14 @@ struct kvm_vcpu_fault_info {
 	u64 disr_el1;		/* Deferred [SError] Status Register */
 };
 
+/*
+ * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
+ * where 0<=crm<8, 0<=op2<8.
+ */
+#define KVM_ARM_ID_REG_MAX_NUM 64
+#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
+#define IDREG_SYS_IDX(id)	(ID_REG_BASE + IDREG_IDX(id))
+
 enum vcpu_sysreg {
 	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
 	MPIDR_EL1,	/* MultiProcessor Affinity Register */
@@ -209,6 +217,8 @@ enum vcpu_sysreg {
 	CNTP_CVAL_EL0,
 	CNTP_CTL_EL0,
 
+	ID_REG_BASE,
+	ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
 	/* Memory Tagging Extension registers */
 	RGSR_EL1,	/* Random Allocation Tag Seed Register */
 	GCR_EL1,	/* Tag Control Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..2443440720b4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -273,7 +273,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
@@ -1059,12 +1059,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = reg_to_encoding(r);
-	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
+	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -1174,6 +1173,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
+{
+	u32 id = reg_to_encoding(rd);
+
+	if (vcpu_has_reset_once(vcpu))
+		return;
+
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
+}
+
 static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       const struct kvm_one_reg *reg, void __user *uaddr)
@@ -1219,9 +1228,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 /*
  * cpufeature ID register user accessors
  *
- * For now, these registers are immutable for userspace, so no values
- * are stored, and for set_id_reg() we don't allow the effective value
- * to be changed.
+ * We don't allow the effective value to be changed.
  */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1375,6 +1382,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
 	.access	= access_id_reg,		\
+	.reset	= reset_id_reg,			\
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = id_visibility,		\
@@ -1830,8 +1838,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64DFR0_EL1));
+		u64 pfr = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64PFR0_EL1));
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
-- 
2.33.1.1089.g2158813163f-goog


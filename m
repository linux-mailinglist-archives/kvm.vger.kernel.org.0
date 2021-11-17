Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA3D454141
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhKQGwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhKQGv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:51:56 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86879C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:48:57 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p8-20020a17090a748800b001a6cceee8afso761301pjk.4
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2eOkydO3aK8psZwx8Y6ejKnu0TttLN3rQcK8oU4rowQ=;
        b=sdBJMLTCs36EcokYsAIZerM6fzM+A7dkhUcEe3eCuRqL1SCNd1qCBuexvgc5pQpgeL
         P52pZMirZcFvVkx+y6BOo3547P/eSKcnjflIY/U7oa9uV/UUvRzg1Hsv0AHI5PQQG0V3
         ErJJeu3Qdw5AoPk3JOe4eKcKDTzC54Ua0px8es+IJSWUPUWB/Mgjv2CF4WWBR0LwgIBN
         doh2Hq07LP1UOmiVLCyFHp9SWY5dxvT24sjzAbYc3Gf4NKyoQKXMS0EX/hyRrangyPor
         zrsbHGNIf11eKu3rTEn9v+X980f26RAjtcXR3sr1kzVmHMsTm5xXa5iwpOSfUDFCIX7b
         fEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2eOkydO3aK8psZwx8Y6ejKnu0TttLN3rQcK8oU4rowQ=;
        b=n4HMt4UOWaJ2sFwt5GWbwUAgrgh3GM4O/dyNI/G6k4F1sGrtcDV0ytg3SYaAUJ+Wr7
         2oRpNhocYKEs+fJ5Qj9AqPwlqFwhovOpfXYW+zfK2y1T+v5kGA7YsD6Y3EicnrXHsVvN
         7WbboyFxlSpg5e1u5mFqGO2Kuokep8RwvxACGTqixV07qOsqYvBiGinxMJ9UADiDYsVX
         ePxsFxPn4oZJ4hvEu9e6rksH9UhTlfg9js0LsFUyXruWcmoFFYvIHDdZ+po7ngOG+boX
         iQuA3oBYRV8OpKBLOI1559O0ZHFRwiWUZHRbtc2TSMxNuV5euI79NE6T9kEBHFw2Ac8Q
         GDwQ==
X-Gm-Message-State: AOAM530mENZ1E3+rEWcKYk5L9/7xtnHt90nVHZQtThHcQmJY79M2eTBq
        /iCriPLfgPuMbVxxEayRKxoiPBeb+w0=
X-Google-Smtp-Source: ABdhPJz/AyRbGlm/9OYeriA4BlIWqodYO0uDJARf+tGRmDDLMq0c2Q4JUMHp6DmDYDXFY0qZhRvEHXRXmsc=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a65:40c3:: with SMTP id u3mr3746373pgp.160.1637131737085;
 Tue, 16 Nov 2021 22:48:57 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:32 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-3-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 02/29] KVM: arm64: Save ID registers' sanitized value
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
 arch/arm64/include/asm/kvm_host.h | 10 +++++++
 arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++------------
 2 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index edbe2cb21947..72db73c79403 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -146,6 +146,14 @@ struct kvm_vcpu_fault_info {
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
@@ -210,6 +218,8 @@ enum vcpu_sysreg {
 	CNTP_CVAL_EL0,
 	CNTP_CTL_EL0,
 
+	ID_REG_BASE,
+	ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
 	/* Memory Tagging Extension registers */
 	RGSR_EL1,	/* Random Allocation Tag Seed Register */
 	GCR_EL1,	/* Tag Control Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e3ec1a44f94d..5608d3410660 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -33,6 +33,8 @@
 
 #include "trace.h"
 
+static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
+
 /*
  * All of this file is extremely similar to the ARM coproc.c, but the
  * types are different. My gut feeling is that it should be pretty
@@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
@@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu,
-		struct sys_reg_desc const *r, bool raz)
+static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 {
-	u32 id = reg_to_encoding(r);
-	u64 val;
-
-	if (raz)
-		return 0;
-
-	val = read_sanitised_ftr_reg(id);
+	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	return val;
 }
 
+static u64 read_id_reg(const struct kvm_vcpu *vcpu,
+		       struct sys_reg_desc const *r, bool raz)
+{
+	u32 id = reg_to_encoding(r);
+
+	return raz ? 0 : __read_id_reg(vcpu, id);
+}
+
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 				  const struct sys_reg_desc *r)
 {
@@ -1178,6 +1180,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
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
@@ -1223,9 +1235,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -1382,6 +1392,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
 	.access	= access_id_reg,		\
+	.reset	= reset_id_reg,			\
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = id_visibility,		\
@@ -1837,8 +1848,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
-- 
2.34.0.rc1.387.gb447b232ab-goog


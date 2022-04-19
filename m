Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0606B5064F4
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349057AbiDSG77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 02:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349059AbiDSG75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 02:59:57 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F7627B2D
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:16 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id t24-20020a17090a449800b001d2d6e740c3so765087pjg.9
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+1i7m94WPnvGucFL2GeFJ3E0bHVaMwecFNukYu6XUWY=;
        b=gqE5oIxvxoF3RF9Eb6xFb5KdNCFf4iQFf6ZwJ0NHsC/BK9y9cftZ1I7H3bJRyE0iUe
         7rl3PcWJ+l1OsF3xvVj5Q3nQ2BFbm3jfjKxAsvB/tYqEfWrKWqC69qFI0e17rUiz+qg5
         Yvn6hD5FKR5q3abn1VKgfq++0UGjNqDDN2/vZFCd0Vd6o0eiv5Kt95s/M3CvZ0mwwjx2
         27Xg6NFBfwKtDGvz3u9dQyEOH3R2a/I8ES3bN69msrxYETM8MKX2DZhIuH9quJJTobsn
         mO1sn69F42iUXCHuhRdeGjPk+O9d5b6xGcMcdfTijJYsPjM4TsCO5g9+wSyVqRuAAWPt
         MIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+1i7m94WPnvGucFL2GeFJ3E0bHVaMwecFNukYu6XUWY=;
        b=Ss3Wn8dQ6WzbC0MS3nKQ17lRkTp0e6LqDnoceomboTfDtZ0+WfJOxi3SCBNHBGFGcU
         9c14/QgH44qySKCHSTJsyHfmKIJSZ1m5qOnTlnWHpwQHDgB3aKC15X3ohZpQ9cBb2ScG
         s6XaUf9V/CtxV2jR4R9xFpWsSfjm+elTlTLxsDwmmpcBilwDBhJdOeVn+/pVlccdG65M
         j7g0cqyweGX8eGNsFfg61SE0MvgrgFafjOH3dNn2U8Mv14Y5FDJ7ONgPQtocW5maAP3Y
         nF5uDRCRCtMGkW/H/WbSI33PKfaM6ekMTYzvopk/nOJzuOeSFRAi5mbc1jjqPzeP7TL1
         Wptg==
X-Gm-Message-State: AOAM530H4KTfHWPEHf4uP5Dcr2u7ByhQTvOFYbeSigam+88VE063ZkeW
        Ysrv/b21Rj2Kq7fdlFElYO2gN4WcvAk=
X-Google-Smtp-Source: ABdhPJw+LFmFhghAXPsnU+QIeZuTJu6vCbhMzC4h4qzizPpPRBlzrz++jClVsuPutXAbnTGljcQXTfwBSdc=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1505:b0:50a:8a96:2994 with SMTP id
 q5-20020a056a00150500b0050a8a962994mr5157138pfu.2.1650351435732; Mon, 18 Apr
 2022 23:57:15 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:12 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-7-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 06/38] KVM: arm64: Make ID_AA64PFR0_EL1 writable
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

This patch adds id_reg_desc for ID_AA64PFR0_EL1 to make it writable by
userspace.

Return an error if userspace tries to set SVE/GIC field of the register
to a value that conflicts with SVE/GIC configuration for the guest.
SIMD/FP/SVE fields of the requested value are validated according to
Arm ARM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/sysreg.h |   1 +
 arch/arm64/kvm/sys_regs.c       | 172 +++++++++++++++++++++-----------
 arch/arm64/kvm/vgic/vgic-init.c |   9 ++
 3 files changed, 123 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 3d860108661b..3adb402fab86 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -834,6 +834,7 @@
 #define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
 #define ID_AA64PFR0_ELx_64BIT_ONLY	0x1
 #define ID_AA64PFR0_ELx_32BIT_64BIT	0x2
+#define ID_AA64PFR0_GIC3		0x1
 
 /* id_aa64pfr1 */
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bc06570523f4..67a0604fe6f1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -271,6 +271,19 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+#define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
+	.sign = ftr_sign,					\
+	.type = ftr_type,					\
+	.shift = bit_pos,					\
+	.width = ARM64_FEATURE_FIELD_BITS,			\
+	.safe_val = safe,					\
+}
+
+#define S_FTR_BITS(ftr_type, bit_pos, safe_val)	\
+	__FTR_BITS(FTR_SIGNED, ftr_type, bit_pos, safe_val)
+#define U_FTR_BITS(ftr_type, bit_pos, safe_val)	\
+	__FTR_BITS(FTR_UNSIGNED, ftr_type, bit_pos, safe_val)
+
 /*
  * Number of entries in id_reg_desc's ftr_bits[] (Number of 4 bits fields
  * in 64 bit register + 1 entry for a terminator entry).
@@ -354,6 +367,86 @@ static void id_reg_desc_init(struct id_reg_desc *id_reg)
 					  id_reg->vcpu_limit_val, val));
 }
 
+static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_desc *id_reg, u64 val)
+{
+	int fp, simd;
+	unsigned int gic;
+	bool vcpu_has_sve = vcpu_has_sve(vcpu);
+	bool pfr0_has_sve = id_aa64pfr0_sve(val);
+
+	simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
+	fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
+	/* AdvSIMD field must have the same value as FP field */
+	if (simd != fp)
+		return -EINVAL;
+
+	/* fp must be supported when sve is supported */
+	if (pfr0_has_sve && (fp < 0))
+		return -EINVAL;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_has_sve ^ pfr0_has_sve)
+		return -EPERM;
+
+	if ((irqchip_in_kernel(vcpu->kvm) &&
+	     vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)) {
+		gic = cpuid_feature_extract_unsigned_field(val,
+							ID_AA64PFR0_GIC_SHIFT);
+		if (gic == 0)
+			return -EPERM;
+
+		if (gic > ID_AA64PFR0_GIC3)
+			return -E2BIG;
+	} else {
+		u64 mask = ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
+		int r = arm64_check_features(id_reg->ftr_bits, val & mask,
+					     id_reg->vcpu_limit_val & mask);
+
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
+static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
+{
+	u64 limit = id_reg->vcpu_limit_val;
+	unsigned int gic;
+
+	limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
+	if (!system_supports_sve())
+		limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
+
+	/*
+	 * The default is to expose CSV2 == 1 and CSV3 == 1 if the HW
+	 * isn't affected.  Userspace can override this as long as it
+	 * doesn't promise the impossible.
+	 */
+	limit &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2) |
+		   ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3));
+
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
+		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), 1);
+	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
+		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), 1);
+
+	gic = cpuid_feature_extract_unsigned_field(limit, ID_AA64PFR0_GIC_SHIFT);
+	if (gic > 1) {
+		/* Limit to GICv3.0/4.0 */
+		limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
+		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), ID_AA64PFR0_GIC3);
+	}
+	id_reg->vcpu_limit_val = limit;
+}
+
+static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
+					 const struct id_reg_desc *idr)
+{
+	return vcpu_has_sve(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
+}
+
 static int validate_id_reg(struct kvm_vcpu *vcpu,
 			   const struct id_reg_desc *id_reg, u64 val)
 {
@@ -1330,20 +1423,6 @@ static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 
 	val = read_kvm_id_reg(vcpu->kvm, id);
 	switch (id) {
-	case SYS_ID_AA64PFR0_EL1:
-		if (!vcpu_has_sve(vcpu))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
-		if (irqchip_in_kernel(vcpu->kvm) &&
-		    vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
-			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
-		}
-		break;
 	case SYS_ID_AA64PFR1_EL1:
 		if (!kvm_has_mte(vcpu->kvm))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
@@ -1443,48 +1522,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
-			       const struct sys_reg_desc *rd,
-			       const struct kvm_one_reg *reg, void __user *uaddr)
-{
-	const u64 id = sys_reg_to_index(rd);
-	u8 csv2, csv3;
-	int err;
-	u64 val;
-
-	err = reg_from_user(&val, uaddr, id);
-	if (err)
-		return err;
-
-	/*
-	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
-	 * it doesn't promise more than what is actually provided (the
-	 * guest could otherwise be covered in ectoplasmic residue).
-	 */
-	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV2_SHIFT);
-	if (csv2 > 1 ||
-	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
-
-	/* Same thing for CSV3 */
-	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV3_SHIFT);
-	if (csv3 > 1 ||
-	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
-
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd, false);
-	val &= ~((0xFUL << ID_AA64PFR0_CSV2_SHIFT) |
-		 (0xFUL << ID_AA64PFR0_CSV3_SHIFT));
-	if (val)
-		return -EINVAL;
-
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3 ;
-
-	return 0;
-}
-
 /* cpufeature ID register user accessors */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1809,8 +1846,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
+	ID_SANITISED(ID_AA64PFR0_EL1),
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
@@ -3175,8 +3211,26 @@ int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval)
 	return __modify_kvm_id_reg(kvm, id, val, preserve_mask);
 }
 
+static struct id_reg_desc id_aa64pfr0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64PFR0_EL1),
+	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR0_GIC),
+	.init = init_id_aa64pfr0_el1_desc,
+	.validate = validate_id_aa64pfr0_el1,
+	.vcpu_mask = vcpu_mask_id_aa64pfr0_el1,
+	.ftr_bits = {
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, ID_AA64PFR0_FP_NI),
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, ID_AA64PFR0_ASIMD_NI),
+	}
+};
+
+#define ID_DESC(id_reg_name, id_reg_desc)	\
+	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
+
 /* A table for ID registers's information. */
-static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {};
+static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	/* CRm=4 */
+	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
+};
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
 {
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index fc00304fe7d8..f0632b46fbf9 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -117,6 +117,15 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	else
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
+		/*
+		 * Set ID_AA64PFR0_EL1.GIC to 1.  This shouldn't fail unless
+		 * any vCPU in the guest have started.
+		 */
+		WARN_ON_ONCE(kvm_set_id_reg_feature(kvm, SYS_ID_AA64PFR0_EL1,
+						    ID_AA64PFR0_GIC3,
+						    ID_AA64PFR0_GIC_SHIFT));
+
 out_unlock:
 	unlock_all_vcpus(kvm);
 	return ret;
-- 
2.36.0.rc0.470.gd361397f0d-goog


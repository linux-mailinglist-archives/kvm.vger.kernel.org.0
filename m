Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F755064EF
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349031AbiDSG7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 02:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349027AbiDSG7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 02:59:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D03727B24
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:11 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i36-20020a25b224000000b006420453d37aso9636548ybj.10
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KS/wIIJ7uM3yRJfC0p0anyF55IOjLEEQRah7lyLn2og=;
        b=pi46jYG8e8DWlS5vsuaGpm4q+O+GL53YTvZkLbMuftAu5GXIzWzk5CVuyrf1XF9eJ9
         ++2oSNEKKUu9cz60xNWUWV1HBhSKnwJjlYTlU7LrIL3x+kc87hoAebkMbDE66dJuTR7x
         6HY86ZbiimWgPPvk3OswZbPJ3NAOtAwwwEVcPrQLZh8zbaXbDazgLfioljLnaqped+Q8
         Zluv9RdeOa5Fv4xCjh48HgtW1Ndm4l4bsjj+5nZETZ/DK2TCsVN/QTxxbBL1nvqFPuto
         QLaSbncWLLAfj29CKMU55tfytj9BI7o6khBtZZx0Y3H8yMP1PU78EJRihlblluNkRDCT
         puXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KS/wIIJ7uM3yRJfC0p0anyF55IOjLEEQRah7lyLn2og=;
        b=UQUOvYFeq+YVvFqj8bN8ILlMuillDS9UK3zqvzZvbEWtIzcvE2yYVYIY24gFbs8iJ3
         G8bFCVzPCwvBCQ76qgTPovX+NJ22eFPUeHDmCJqGmVbw6x4+SM/mG60uEORRZwPNcy8Z
         x4Q8soBjPLaLsa/PsBL7PVYd3MeNVAc5eNpYeDhGLJTjGRtEwUPXVk671j3yFi/EwhGI
         0GzJUMlqDh/ZKY/ynA8PogDcGLw46s9V5afTHQiUdLknHmHhMSo56YgGqGxn0ojxbHvd
         YcfhiM4nJSY6A1R6Z1gwGva+6MBo4wj1ppL9Epc8GagbfMd51+nGKPkoItO9HzWZ9U64
         ri/A==
X-Gm-Message-State: AOAM530Q1xjl+GI/TG81V1XYUnAscCCACnK6A/TYffTJluTSG/iH90b/
        ivkzPO6b+mwzq0rjhYJZgQaUcHBiEdY=
X-Google-Smtp-Source: ABdhPJwlHiTAOkInHI+UkF/bI/+q1ncsfqZcs+GYTID72n/O+fP2xR9PIGz73byjxBPqM4WrghkUY7tVmcU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:52c3:0:b0:645:35f9:b55 with SMTP id
 g186-20020a2552c3000000b0064535f90b55mr2681156ybb.307.1650351430454; Mon, 18
 Apr 2022 23:57:10 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:09 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-4-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 03/38] KVM: arm64: Introduce struct id_reg_desc
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

This patch lays the groundwork to make ID registers writable.

Introduce struct id_reg_desc for an ID register to manage the
register specific control of its value for the guest, and provide set
of functions commonly used for ID registers to make them writable.
Use the id_reg_desc to do register specific initialization, validation
of the ID register, etc.  The id_reg_desc has reg_desc field (struct
sys_reg_desc), which will be used instead of sys_reg_desc in
sys_reg_descs[] for ID registers in the following patches (and then
the entries in sys_reg_descs[] will be removed).

At present, changing an ID register from userspace is allowed only
if the ID register has the id_reg_desc, but that will be changed
by the following patches.

No ID register has the id_reg_desc yet, and the following patches
will add them for all the ID registers currently in sys_reg_descs[].

kvm_set_id_reg_feature(), which is introduced in this patch,
is going to be used by the following patch outside from sys_regs.c
when an ID register field needs to be updated.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/include/asm/sysreg.h   |   3 +-
 arch/arm64/kvm/sys_regs.c         | 313 ++++++++++++++++++++++++++++--
 3 files changed, 300 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fc836df84748..a43fddd58e68 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -785,6 +785,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
 void set_default_id_regs(struct kvm *kvm);
+int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index fbf5f8bb9055..3d860108661b 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1234,9 +1234,10 @@
 #define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
 
 #define ARM64_FEATURE_FIELD_BITS	4
+#define ARM64_FEATURE_FIELD_MASK	GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0)
 
 /* Create a mask for the feature bits of the specified feature. */
-#define ARM64_FEATURE_MASK(x)	(GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
+#define ARM64_FEATURE_MASK(x)	(ARM64_FEATURE_FIELD_MASK << x##_SHIFT)
 
 #ifdef __ASSEMBLY__
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5b813a0b7b1c..30adc19e4619 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -34,6 +34,7 @@
 #include "trace.h"
 
 static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id);
+static inline struct id_reg_desc *get_id_reg_desc(u32 id);
 
 /*
  * All of this file is extremely similar to the ARM coproc.c, but the
@@ -269,6 +270,112 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+/*
+ * Number of entries in id_reg_desc's ftr_bits[] (Number of 4 bits fields
+ * in 64 bit register + 1 entry for a terminator entry).
+ */
+#define	FTR_FIELDS_NUM	17
+
+struct id_reg_desc {
+	const struct sys_reg_desc	reg_desc;
+
+	/*
+	 * Limit value of the register for a vcpu. The value is the sanitized
+	 * system value with bits set/cleared for unsupported features for the
+	 * guest.
+	 */
+	u64	vcpu_limit_val;
+
+	/* Fields that are not validated by arm64_check_features. */
+	u64	ignore_mask;
+
+	/* An optional initialization function of the id_reg_desc */
+	void (*init)(struct id_reg_desc *id_reg);
+
+	/*
+	 * This is an optional ID register specific validation function. When
+	 * userspace tries to set the ID register, arm64_check_features()
+	 * will check if the requested value indicates any features that cannot
+	 * be supported by KVM on the host.  But, some ID register fields need
+	 * a special checking, and this function can be used for such fields.
+	 * e.g. When SVE is configured for a vCPU by KVM_ARM_VCPU_INIT,
+	 * ID_AA64PFR0_EL1.SVE shouldn't be set to 0 for the vCPU.
+	 * The validation function for ID_AA64PFR0_EL1 could be used to check
+	 * the field is consistent with SVE configuration.
+	 */
+	int (*validate)(struct kvm_vcpu *vcpu, const struct id_reg_desc *id_reg,
+			u64 val);
+
+	/*
+	 * Return a bitmask of the vCPU's ID register fields that are not
+	 * synced with saved (per VM) ID register value, which usually
+	 * indicates opt-in CPU features that are not configured for the vCPU.
+	 * ID registers are saved per VM, but some opt-in CPU features can
+	 * be configured per vCPU.  The saved (per VM) values for such
+	 * features are for vCPUs with the features (and zero for
+	 * vCPUs without the features).
+	 * Return value of this function is used to handle such fields
+	 * for per vCPU ID register read/write request with saved per VM
+	 * ID register.  See the __write_id_reg's comment for more detail.
+	 */
+	u64 (*vcpu_mask)(const struct kvm_vcpu *vcpu,
+			 const struct id_reg_desc *id_reg);
+
+	/*
+	 * Used to validate the ID register values with arm64_check_features().
+	 * The last item in the array must be terminated by an item whose
+	 * width field is zero as that is expected by arm64_check_features().
+	 */
+	struct arm64_ftr_bits	ftr_bits[FTR_FIELDS_NUM];
+};
+
+static void id_reg_desc_init(struct id_reg_desc *id_reg)
+{
+	u32 id = reg_to_encoding(&id_reg->reg_desc);
+	u64 val = read_sanitised_ftr_reg(id);
+
+	id_reg->vcpu_limit_val = val;
+	if (id_reg->init)
+		id_reg->init(id_reg);
+
+	/*
+	 * id_reg->init() might update id_reg->vcpu_limit_val.
+	 * Make sure that id_reg->vcpu_limit_val, which will be the default
+	 * register value for guests, is a safe value to use for guests
+	 * on the host.
+	 */
+	WARN_ON_ONCE(arm64_check_features(id_reg->ftr_bits,
+					  id_reg->vcpu_limit_val, val));
+}
+
+static int validate_id_reg(struct kvm_vcpu *vcpu,
+			   const struct id_reg_desc *id_reg, u64 val)
+{
+	u64 limit, tmp_val;
+	int err;
+
+	limit = id_reg->vcpu_limit_val;
+
+	/*
+	 * Replace the fields that are indicated in ignore_mask with
+	 * the value in the limit to not have arm64_check_features()
+	 * check the field in @val.
+	 */
+	tmp_val = val & ~id_reg->ignore_mask;
+	tmp_val |= (limit & id_reg->ignore_mask);
+
+	/* Check if the value indicates any feature that is not in the limit. */
+	err = arm64_check_features(id_reg->ftr_bits, tmp_val, limit);
+	if (err)
+		return err;
+
+	if (id_reg && id_reg->validate)
+		/* Run the ID register specific validity check. */
+		err = id_reg->validate(vcpu, id_reg, val);
+
+	return err;
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -1115,10 +1222,107 @@ static bool is_id_reg(u32 id)
 		sys_reg_CRm(id) < 8);
 }
 
+static u64 read_kvm_id_reg(struct kvm *kvm, u32 id)
+{
+	return kvm->arch.id_regs[IDREG_IDX(id)];
+}
+
+static int __modify_kvm_id_reg(struct kvm *kvm, u32 id, u64 val,
+			     u64 preserve_mask)
+{
+	u64 old, new;
+
+	lockdep_assert_held(&kvm->lock);
+
+	old = kvm->arch.id_regs[IDREG_IDX(id)];
+
+	/* Preserve the value at the bit position set in preserve_mask */
+	new = old & preserve_mask;
+	new |= (val & ~preserve_mask);
+
+	/* Don't allow to modify ID register value after KVM_RUN on any vCPUs */
+	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags) &&
+	    new != old)
+		return -EBUSY;
+
+	WRITE_ONCE(kvm->arch.id_regs[IDREG_IDX(id)], new);
+
+	return 0;
+}
+
+static int modify_kvm_id_reg(struct kvm *kvm, u32 id, u64 val,
+			     u64 preserve_mask)
+{
+	int ret;
+
+	mutex_lock(&kvm->lock);
+	ret = __modify_kvm_id_reg(kvm, id, val, preserve_mask);
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
+
+static int write_kvm_id_reg(struct kvm *kvm, u32 id, u64 val)
+{
+	return modify_kvm_id_reg(kvm, id, val, 0);
+}
+
+/*
+ * KVM basically forces all vCPUs of the guest to have a uniform value for
+ * each ID register (it means KVM_SET_ONE_REG for a vCPU affects all
+ * the vCPUs of the guest), and the id_regs[] of kvm_arch holds values
+ * of ID registers for the guest.  However, there is an exception for
+ * ID register fields corresponding to CPU features that can be
+ * configured per vCPU by KVM_ARM_VCPU_INIT, or etc (e.g. PMUv3, SVE, etc).
+ * For such fields, all vCPUs that have the feature will have a non-zero
+ * uniform value, which can be updated by userspace, but the vCPUs that
+ * don't have the feature will have zero for the fields.
+ * Values that @id_regs holds are for vCPUs that have such features.  So,
+ * to get the ID register value for a vCPU that doesn't have those features,
+ * the corresponding fields in id_regs[] needs to be cleared.
+ * A bitmask of the fields are provided by id_reg_desc's vcpu_mask(), and
+ * __write_id_reg() and __read_id_reg() take care of those fields using
+ * the bitmask.
+ */
+static int __write_id_reg(struct kvm_vcpu *vcpu,
+			  struct id_reg_desc *id_reg, u64 val)
+{
+	u64 mask = 0;
+	u32 id = reg_to_encoding(&id_reg->reg_desc);
+
+	if (id_reg->vcpu_mask)
+		mask = id_reg->vcpu_mask(vcpu, id_reg);
+
+	/*
+	 * Update the ID register for the guest with @val, except for fields
+	 * that are set in the mask, which indicates fields for opt-in
+	 * features that are not configured for the vCPU.
+	 */
+	return modify_kvm_id_reg(vcpu->kvm, id, val, mask);
+}
+
+static u64 __read_id_reg(const struct kvm_vcpu *vcpu,
+			 const struct id_reg_desc *id_reg)
+{
+	u32 id = reg_to_encoding(&id_reg->reg_desc);
+	u64 val = read_kvm_id_reg(vcpu->kvm, id);
+
+	if (id_reg && id_reg->vcpu_mask)
+		/* Clear fields for opt-in features that are not configured. */
+		val &= ~(id_reg->vcpu_mask(vcpu, id_reg));
+
+	return val;
+}
+
 static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 {
-	u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
+	u64 val;
+	const struct id_reg_desc *id_reg = get_id_reg_desc(id);
+
+	if (id_reg)
+		return __read_id_reg(vcpu, id_reg);
 
+	val = read_kvm_id_reg(vcpu->kvm, id);
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
@@ -1175,9 +1379,7 @@ static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		       struct sys_reg_desc const *r, bool raz)
 {
-	u32 id = reg_to_encoding(r);
-
-	return raz ? 0 : read_id_reg_with_encoding(vcpu, id);
+	return raz ? 0 : read_id_reg_with_encoding(vcpu, reg_to_encoding(r));
 }
 
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
@@ -1277,12 +1479,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-/*
- * cpufeature ID register user accessors
- *
- * For now, these registers are immutable for userspace, so for set_id_reg()
- * we don't allow the effective value to be changed.
- */
+/* cpufeature ID register user accessors */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
@@ -1293,11 +1490,32 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
 	return reg_to_user(uaddr, &val, id);
 }
 
-static int __set_id_reg(const struct kvm_vcpu *vcpu,
+/*
+ * Check if the given id indicates AArch32 ID register encoding.
+ */
+static bool is_aarch32_id_reg(u32 id)
+{
+	u32 crm, op2;
+
+	if (!is_id_reg(id))
+		return false;
+
+	crm = sys_reg_CRm(id);
+	op2 = sys_reg_Op2(id);
+	if (crm == 1 || crm == 2 || (crm == 3 && (op2 != 3 && op2 != 7)))
+		/* AArch32 ID register */
+		return true;
+
+	return false;
+}
+
+static int __set_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
 	const u64 id = sys_reg_to_index(rd);
+	u32 encoding = reg_to_encoding(rd);
+	struct id_reg_desc *id_reg;
 	int err;
 	u64 val;
 
@@ -1305,11 +1523,33 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
 	if (err)
 		return err;
 
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd, raz))
+	if (val == read_id_reg(vcpu, rd, raz))
+		/* The value is same as the current value. Nothing to do. */
+		return 0;
+
+	/* Don't allow to modify the register's value if the register is raz. */
+	if (raz)
 		return -EINVAL;
 
-	return 0;
+	/*
+	 * Don't allow to modify the register's value if the register doesn't
+	 * have the id_reg_desc.
+	 */
+	id_reg = get_id_reg_desc(encoding);
+	if (!id_reg)
+		return -EINVAL;
+
+	/*
+	 * Skip the validation of AArch32 ID registers if the system doesn't
+	 * 32bit EL0 (their value are UNKNOWN).
+	 */
+	if (system_supports_32bit_el0() || !is_aarch32_id_reg(encoding)) {
+		err = validate_id_reg(vcpu, id_reg, val);
+		if (err)
+			return err;
+	}
+
+	return __write_id_reg(vcpu, id_reg, val);
 }
 
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
@@ -2872,6 +3112,8 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+static void id_reg_desc_init_all(void);
+
 void kvm_sys_reg_table_init(void)
 {
 	unsigned int i;
@@ -2906,6 +3148,43 @@ void kvm_sys_reg_table_init(void)
 			break;
 	/* Clear all higher bits. */
 	cache_levels &= (1 << (i*3))-1;
+
+	id_reg_desc_init_all();
+}
+
+/*
+ * Update the ID register's field with @fval for the guest.
+ * The caller is expected to hold the kvm->lock.
+ * This will not fail unless any vCPUs in the guest have started.
+ */
+int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval)
+{
+	u64 val = ((u64)fval & ARM64_FEATURE_FIELD_MASK) << field_shift;
+	u64 preserve_mask = ~(ARM64_FEATURE_FIELD_MASK << field_shift);
+
+	return __modify_kvm_id_reg(kvm, id, val, preserve_mask);
+}
+
+/* A table for ID registers's information. */
+static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {};
+
+static inline struct id_reg_desc *get_id_reg_desc(u32 id)
+{
+	return id_reg_desc_table[IDREG_IDX(id)];
+}
+
+static void id_reg_desc_init_all(void)
+{
+	int i;
+	struct id_reg_desc *id_reg;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_desc_table); i++) {
+		id_reg = (struct id_reg_desc *)id_reg_desc_table[i];
+		if (!id_reg)
+			continue;
+
+		id_reg_desc_init(id_reg);
+	}
 }
 
 /*
@@ -2918,6 +3197,7 @@ void set_default_id_regs(struct kvm *kvm)
 	u32 id;
 	const struct sys_reg_desc *rd;
 	u64 val;
+	struct id_reg_desc *idr;
 	struct sys_reg_params params = {
 		Op0(sys_reg_Op0(SYS_ID_PFR0_EL1)),
 		Op1(sys_reg_Op1(SYS_ID_PFR0_EL1)),
@@ -2942,7 +3222,8 @@ void set_default_id_regs(struct kvm *kvm)
 			/* Hidden or reserved ID register */
 			continue;
 
-		val = read_sanitised_ftr_reg(id);
-		kvm->arch.id_regs[IDREG_IDX(id)] = val;
+		idr = get_id_reg_desc(id);
+		val = idr ? idr->vcpu_limit_val : read_sanitised_ftr_reg(id);
+		WARN_ON_ONCE(write_kvm_id_reg(kvm, id, val));
 	}
 }
-- 
2.36.0.rc0.470.gd361397f0d-goog


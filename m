Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C9B429CA7
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhJLEjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbhJLEiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:54 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11281C061776
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:48 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id w4-20020a1709029a8400b00138e222b06aso8402010plp.12
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OQYgwRpV/afvA18lL6MxXV8IUfnKjIjbj1gRfgEyVlM=;
        b=IXmq+jTnwzeMBZKuKOipuIYaqVqyDgFMjOwwqaAgqb69yrm6IYJI+VT/YZ5EeAWbSq
         gCLxYJ+uTN3DFS1my5x2/PLGxbN9dRP5QOnJ/ssIh7ETvLkRsUOqZlVwI/ahI8wMgahd
         bCXEbEQzWffBR905nT9Ci/R/YNi+a+J9L6RmWiRtI0WBgUIUd4hCS+EgjruLZtHR40WH
         hkCCqtj9wBP07X1FJFqKlmx39A4gvLr+AXiIvUp94hY3RkNS7y3kZCECK51vw7qF/gcq
         lQUcFrWMU2XfVxGskB5pP/mWuzWV4MnjVj+dLW5eyUPPGDPUj5CUUy2HBW7TvX6rhT2n
         Adjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OQYgwRpV/afvA18lL6MxXV8IUfnKjIjbj1gRfgEyVlM=;
        b=IBdJIvMVq+2zgxeW7OrU2YBShHHsQ1dFs4FzzhBtLG5Osigaei6V/JhqerqMk5vewt
         pPjGF87kVzoojMV/vbD7+/YohbVK66GPpDcIBeBaPy2KCfbNwaFLm/hiMch46gd8FDyF
         1Ous396pZz100ybvtlUvY9e5IdgHJRQO3JY+DK31ovVyd6s9twiRxZCddX0bsIDVp0pT
         dqZ8EVqzdkNjlk8GNl2ogdx9J1puJqNRwN0RzWp2fBXgextDkKNYrM6lWnDYzpnu1F9L
         +0L2C/D8v9I/6adto4+kNnZ0yYjtRfkiPoPSOjM6FSL7x1RiNAjfeqYW+COo5yau6LqY
         657A==
X-Gm-Message-State: AOAM531EH+0LnVPmZ/giGO4uz6ejvWrf5IsBTGtr6JL4xN2/febfSFK6
        PbSyg6yVEq/wPgPrukweaoDKWc6h3pY=
X-Google-Smtp-Source: ABdhPJxBaQNXtyGD8dhFMG0rTvuje7KSg1St0xidYAdYw8pJDEOzrI/xNhyhGBTWV3iL65bgyq5YRTWE8mM=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90a:3ee4:: with SMTP id
 k91mr295603pjc.1.1634013407117; Mon, 11 Oct 2021 21:36:47 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:28 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-19-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 18/25] KVM: arm64: Introduce framework to trap disabled features
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

When a CPU feature that is supported on the host is not exposed to
its guest, emulating a real CPU's behavior (by trapping or disabling
guest's using the feature) is generally a desirable behavior (when
it's possible without any or little side effect).

Introduce feature_config_ctrl structure, which manages feature
information to program configuration register to trap or disable
the feature when the feature is not exposed to the guest, and
functions that uses the structure to activate trapping the feature.

At present, no feature has feature_config_ctrl yet and the following
patches will add the feature_config_ctrl for several features.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 117 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 536e313992d4..55c514e21214 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -281,6 +281,35 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+enum vcpu_config_reg {
+	VCPU_HCR_EL2 = 1,
+	VCPU_MDCR_EL2,
+	VCPU_CPTR_EL2,
+};
+
+/*
+ * Feature information to program configuration register to trap or disable
+ * guest's using a feature when the feature is not exposed to the guest.
+ */
+struct feature_config_ctrl {
+	/* ID register/field for the feature */
+	u32	ftr_reg;	/* ID register */
+	bool	ftr_signed;	/* Is the feature field signed ? */
+	u8	ftr_shift;	/* Field of ID register for the feature */
+	s8	ftr_min;	/* Min value that indicate the feature */
+
+	/*
+	 * Function to check trapping is needed. This is used when the above
+	 * fields are not enough to determine if trapping is needed.
+	 */
+	bool	(*ftr_need_trap)(struct kvm_vcpu *vcpu);
+
+	/* Configuration register information to trap the feature. */
+	enum vcpu_config_reg cfg_reg;	/* Configuration register */
+	u64	cfg_mask;	/* Field of the configuration register */
+	u64	cfg_val;	/* Value that are set for the field */
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -302,6 +331,9 @@ struct id_reg_info {
 
 	/* Return the reset value of the register for the vCPU */
 	u64 (*get_reset_val)(struct kvm_vcpu *vcpu, struct id_reg_info *id_reg);
+
+	/* Information to trap features that are disabled for the guest */
+	const struct feature_config_ctrl *(*trap_features)[];
 };
 
 static void id_reg_info_init(struct id_reg_info *id_reg)
@@ -717,6 +749,47 @@ static int validate_id_reg(struct kvm_vcpu *vcpu,
 	return err;
 }
 
+static void feature_trap_activate(struct kvm_vcpu *vcpu,
+				  const struct feature_config_ctrl *config)
+{
+	u64 *reg_ptr, reg_val;
+
+	switch (config->cfg_reg) {
+	case VCPU_HCR_EL2:
+		reg_ptr = &vcpu->arch.hcr_el2;
+		break;
+	case VCPU_MDCR_EL2:
+		reg_ptr = &vcpu->arch.mdcr_el2;
+		break;
+	case VCPU_CPTR_EL2:
+		reg_ptr = &vcpu->arch.cptr_el2;
+		break;
+	}
+
+	/* Update cfg_mask fields with cfg_val */
+	reg_val = (*reg_ptr & ~config->cfg_mask);
+	reg_val |= config->cfg_val;
+	*reg_ptr = reg_val;
+}
+
+static inline bool feature_avail(const struct feature_config_ctrl *ctrl,
+				 u64 id_val)
+{
+	int field_val = cpuid_feature_extract_field(id_val,
+				ctrl->ftr_shift, ctrl->ftr_signed);
+
+	return (field_val >= ctrl->ftr_min);
+}
+
+static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
+					const struct feature_config_ctrl *ctrl)
+{
+	u64 val;
+
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(ctrl->ftr_reg));
+	return feature_avail(ctrl, val);
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -1570,6 +1643,42 @@ static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
 static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
+static void id_reg_features_trap_activate(struct kvm_vcpu *vcpu,
+					  const struct id_reg_info *id_reg)
+{
+	u64 val;
+	int i = 0;
+	const struct feature_config_ctrl **ctrlp_array, *ctrl;
+
+	if (!id_reg || !id_reg->trap_features)
+		/* No information to trap a feature */
+		return;
+
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id_reg->sys_reg));
+	if (val == id_reg->sys_val)
+		/* No feature needs to be trapped (no feature is disabled). */
+		return;
+
+	ctrlp_array = *id_reg->trap_features;
+	while ((ctrl = ctrlp_array[i++]) != NULL) {
+		if (ctrl->ftr_need_trap && ctrl->ftr_need_trap(vcpu)) {
+			feature_trap_activate(vcpu, ctrl);
+			continue;
+		}
+
+		if (!feature_avail(ctrl, id_reg->sys_val))
+			/* The feature is not supported on the host. */
+			continue;
+
+		if (feature_avail(ctrl, val))
+			/* The feature is enabled for the guest. */
+			continue;
+
+		/* The feature is supported but disabled. */
+		feature_trap_activate(vcpu, ctrl);
+	}
+}
+
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -3195,6 +3304,14 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+void kvm_vcpu_id_regs_trap_activate(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++)
+		id_reg_features_trap_activate(vcpu, id_reg_info_table[i]);
+}
+
 /* ID register's fractional field information with its feature field. */
 struct feature_frac {
 	u32	frac_id;
-- 
2.33.0.882.g93a45727a2-goog


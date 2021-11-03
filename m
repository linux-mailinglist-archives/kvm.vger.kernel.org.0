Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9A2443D4A
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhKCGb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhKCGbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:31:06 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467EAC061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id t24-20020a252d18000000b005c225ae9e16so2707039ybt.15
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1lfGW3uUgr0CY8K4JFTRsimFp+SzJHY9CklAaedGo2Y=;
        b=dgJhd+anU5DKo0ONOMzDKNE6v++uX3EutjlLi0DF0IBxu8EIpJbKZAmnyMCqM+9n/u
         /W+zFwLfODB4FQSatwb6maKrJl4LTaQD6G69c92UEMNlrJL2ZuIhL/tCOiefnP46XGzv
         qtj7trpqD7yk2tzPZm4PqrW45VUdPoyAJztmw7rND2Fm4Me9TEj/1VrH39xJrHj39xPm
         J36BktdLXaNNipzmQmrEGhSXCCUJqFNk11sVmdxf0LKxZCiYocE3pzbqt+GSIqYH4eIf
         aUa9weuyfvgS7c9SD6RWM/rYu8esqEKaJelpblOjoXciFtcmHz6FOGdQltyOlUeFf1Xg
         l4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1lfGW3uUgr0CY8K4JFTRsimFp+SzJHY9CklAaedGo2Y=;
        b=fndcq/u6zqmcBr52MDk8bsrsilMr4Ie+fu2gWZFu2fEaYURbQbpIiws4p2SWoLdwvf
         XiHdj8dYJ72PE42UdbwR7Bt8e27+VHfrIRfWGRig/SWsMqVAeXATZbixHEWwm3V08roD
         E1sFCO80R/2DOQv0ndnAqc5OT8RHSlTOg8a8A+Q33nd29kCXDLWslPOCPPVGAHpGAojn
         HIgkl7LeQ+OEwR0vaG6cDkMuEVL2IWio9KCTePFSysROWYSlq63KO5+f16w/WFX4NF5f
         LuwajzarofyweEEdDkNq2mSp/ZoClIp4mntUfWZvL88oekjhm8djNtYueEIh/IOabjFR
         temQ==
X-Gm-Message-State: AOAM5339Y761O3Tpw8aE3ANWNWFH8iyd2G/7DKCEryNTm7zXlkiChPqh
        EPeMb8yk3MwV8bp2BNR3q+jr5seDuwY=
X-Google-Smtp-Source: ABdhPJzvRlzhHgCrOc1A3vUiZK4QFvFi8eSsp2hkt/8T54a+0Czu4C02OOJz24SVVzhytf8yVh6SIQeMn1Y=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:74c8:: with SMTP id p191mr35575047ybc.157.1635920909508;
 Tue, 02 Nov 2021 23:28:29 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:13 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-22-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 21/28] KVM: arm64: Introduce framework to trap disabled features
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
 arch/arm64/kvm/sys_regs.c | 121 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 120 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ec984fd4e319..504e1ff86848 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -374,8 +374,38 @@ static int arm64_check_features(u64 check_types, u64 val, u64 lim)
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
+	u64	sys_val;	/* Sanitized system value */
 
 	/*
 	 * Limit value of the register for a vcpu. The value is the sanitized
@@ -408,11 +438,15 @@ struct id_reg_info {
 	/* Return the reset value of the register for the vCPU */
 	u64 (*get_reset_val)(struct kvm_vcpu *vcpu,
 			     const struct id_reg_info *id_reg);
+
+	/* Information to trap features that are disabled for the guest */
+	const struct feature_config_ctrl *(*trap_features)[];
 };
 
 static void id_reg_info_init(struct id_reg_info *id_reg)
 {
-	id_reg->vcpu_limit_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	id_reg->vcpu_limit_val = id_reg->sys_val;
 	if (id_reg->init)
 		id_reg->init(id_reg);
 }
@@ -928,6 +962,47 @@ static int validate_id_reg(struct kvm_vcpu *vcpu,
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
@@ -1781,6 +1856,42 @@ static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
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
@@ -3404,6 +3515,14 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
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
 	u32	id;
-- 
2.33.1.1089.g2158813163f-goog


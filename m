Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B785506521
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349125AbiDSHAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349128AbiDSHAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4037731DFE
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:49 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id e12-20020a17090a7c4c00b001cb1b3274c9so1042600pjl.4
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B1I2hIjHdTMX5JOJBkL6j3t0rzu4sj1sIMHdlZhAORQ=;
        b=sLdKpYgmWisFvw0h7w4vqAUGy5Ze3pz+9xltI0cwBnIXOZCk8SJ4JMMtSX69/qpU4w
         MQ1CbtoOKdWZBT5iEP7QAjdBxJXIU+2i1+xuvL2Bxgwqw7IsamVZ81oLl4ixcYtFI59O
         xN3n/t1sCzaDNHDXkKLETaKyxQQqRxL8PSHH6lu2uuKBr3DSKcjRwRvtXAZnAWAxd0M5
         jqUNRAdecFmD+UoygrYyhbdhhrPAiXaiQaxKhtP7eaexV5wKabO4nr+ozUPwa9hbAXsQ
         G+/C0K2bNs1fpPEWvTbwEN3UHMHKe8wq5dYQRzd/kEhfhGeK23Bic1Pw8G1TlOe2ExO1
         2POw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B1I2hIjHdTMX5JOJBkL6j3t0rzu4sj1sIMHdlZhAORQ=;
        b=Bh2EIGhQ53hLgvHTJ6nZ8lOGVksy0H4vD2iSHHW974U9JshR5HEpzNvWHc916LPg+p
         BXc0nF53biV3AcoXH4Zkg+3TL7Nbw46J0Y/5pZ3L7QDicuAgPCI6W3wxbo+Cj6DwylVm
         4NJu8KuY7Bk2Bsq6hkCiZXfKJVd23ZLxgmV85miJl2QdJmnN4emkwl9PWM1m9OScMchp
         FGMvB2E0AUc15Dp/r+CGnSW+hLHyxhpX7tRr4LkIS90NPH+uBgUa8o0sj2+5LilgrCeO
         zByWT1q0nFL3amuVOo8NzQp17RFDhlmryzjVjDbzEbLlYrwAcWvGJ/4frLof6EFTKPTq
         RV+A==
X-Gm-Message-State: AOAM532NrhxjJ8L5BEnTSmu55Zy2RqeUeu42r+XA3TzuH1kT6zA/lSMc
        Li4F3mUlbCGDRoyfNXbpjxc843NqjRM=
X-Google-Smtp-Source: ABdhPJzN1iwm3YJb0ZtY2RQlAXZkF8VXrNv44zhCAriIwP97RNc+KwflV5KlNxeryAwEWROW0FPqTsPglMU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a62:8384:0:b0:507:3460:6395 with SMTP id
 h126-20020a628384000000b0050734606395mr16169854pfe.81.1650351468194; Mon, 18
 Apr 2022 23:57:48 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:32 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-27-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 26/38] KVM: arm64: Introduce framework to trap disabled features
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

When a CPU feature that is supported on the host is not exposed to
its guest, emulating a real CPU's behavior (by trapping or disabling
guest's using the feature) is generally a desirable behavior (when
it's possible without any or little side effect).

Introduce feature_config_ctrl structure, which manages feature
information to program configuration register to trap or disable
the feature when the feature is not exposed to the guest, and
functions that uses the structure to activate the vcpu's trapping the
feature.  Those codes don't update trap configuration registers
themselves (HCR_EL2, etc) but values for the registers in
kvm_vcpu_arch at the first KVM_RUN.

At present, no feature has feature_config_ctrl yet and the following
patches will add the feature_config_ctrl for some features.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/arm.c              |  13 ++--
 arch/arm64/kvm/sys_regs.c         | 111 ++++++++++++++++++++++++++++++
 3 files changed, 120 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b85af83b4542..92785b33df0f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -790,6 +790,7 @@ void set_default_id_regs(struct kvm *kvm);
 int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
 void kvm_vcpu_breakpoint_config(struct kvm_vcpu *vcpu);
 int kvm_id_regs_check_frac_fields(const struct kvm_vcpu *vcpu);
+void kvm_vcpu_init_traps(struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 69189907579c..bcccf3876fcf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -556,13 +556,16 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		static_branch_inc(&userspace_irqchip_in_use);
 	}
 
-	/*
-	 * Initialize traps for protected VMs.
-	 * NOTE: Move to run in EL2 directly, rather than via a hypercall, once
-	 * the code is in place for first run initialization at EL2.
-	 */
+	/* Initialize traps for the guest. */
 	if (kvm_vm_is_protected(kvm))
+		/*
+		 * NOTE: Move to run in EL2 directly, rather than via a
+		 * hypercall, once the code is in place for first run
+		 * initialization at EL2.
+		 */
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
+	else
+		kvm_vcpu_init_traps(vcpu);
 
 	mutex_lock(&kvm->lock);
 	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a71c52aee34e..7fe44dec11fd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -299,6 +299,27 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR2_GPA3_SHIFT) >= \
 	 ID_AA64ISAR2_GPA3_ARCHITECTED)
 
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
+	/* Function to activate trapping the feature. */
+	void	(*trap_activate)(struct kvm_vcpu *vcpu);
+};
+
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -321,6 +342,9 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 struct id_reg_desc {
 	const struct sys_reg_desc	reg_desc;
 
+	/* Sanitized system value */
+	u64	sys_val;
+
 	/*
 	 * Limit value of the register for a vcpu. The value is the sanitized
 	 * system value with bits set/cleared for unsupported features for the
@@ -376,6 +400,9 @@ struct id_reg_desc {
 	 * UNSIGNED+LOWER_SAFE entries during KVM's initialization.
 	 */
 	struct arm64_ftr_bits	ftr_bits[FTR_FIELDS_NUM];
+
+	/* Information to trap features that are disabled for the guest */
+	const struct feature_config_ctrl *(*trap_features)[];
 };
 
 static inline struct id_reg_desc *sys_to_id_desc(const struct sys_reg_desc *r)
@@ -393,6 +420,7 @@ static void id_reg_desc_init(struct id_reg_desc *id_reg)
 		return;
 
 	val = read_sanitised_ftr_reg(id);
+	id_reg->sys_val = val;
 	id_reg->vcpu_limit_val = val;
 
 	id_reg_desc_init_ftr(id_reg);
@@ -908,6 +936,24 @@ static int validate_id_reg(struct kvm_vcpu *vcpu,
 	return err;
 }
 
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
+	val = read_id_reg_with_encoding(vcpu, ctrl->ftr_reg);
+	return feature_avail(ctrl, val);
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -2387,6 +2433,46 @@ static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
 	return __access_id_reg(vcpu, p, r, true);
 }
 
+static void id_reg_features_trap_activate(struct kvm_vcpu *vcpu,
+					  const struct id_reg_desc *id_reg)
+{
+	u64 val;
+	int i = 0;
+	const struct feature_config_ctrl **ctrlp_array, *ctrl;
+
+	if (!id_reg->trap_features)
+		/* No information to trap a feature */
+		return;
+
+	val = __read_id_reg(vcpu, id_reg);
+	if (val == id_reg->sys_val)
+		/* No feature needs to be trapped (no feature is disabled). */
+		return;
+
+	ctrlp_array = *id_reg->trap_features;
+	while ((ctrl = ctrlp_array[i++]) != NULL) {
+		if (WARN_ON_ONCE(!ctrl->trap_activate))
+			/* Shouldn't happen */
+			continue;
+
+		if (ctrl->ftr_need_trap && ctrl->ftr_need_trap(vcpu)) {
+			ctrl->trap_activate(vcpu);
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
+		ctrl->trap_activate(vcpu);
+	}
+}
+
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -4487,6 +4573,31 @@ static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * This function activates vcpu's trapping of features that are included in
+ * trap_features[] of id_reg_desc if the features are supported on the
+ * host, but are hidden from the guest (i.e. values of ID registers for
+ * the guest are modified to not show the features' availability).
+ * This function just updates values for trap configuration registers (e.g.
+ * HCR_EL2, etc) in kvm_vcpu_arch, which will be restored before switching
+ * to the guest, but doesn't update the registers themselves.
+ * This function should be called once at the first KVM_RUN (ID registers
+ * are immutable after the first KVM_RUN).
+ */
+void kvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct id_reg_desc *idr;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_desc_table); i++) {
+		idr = (struct id_reg_desc *)id_reg_desc_table[i];
+		if (!idr)
+			continue;
+
+		id_reg_features_trap_activate(vcpu, idr);
+	}
+}
+
 #if IS_ENABLED(CONFIG_KVM_KUNIT_TEST)
 #include "sys_regs_test.c"
 #endif
-- 
2.36.0.rc0.470.gd361397f0d-goog


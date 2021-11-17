Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A042454158
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhKQG4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhKQG4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:32 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7320FC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:34 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id a127-20020a627f85000000b0047feae4a8d9so1098164pfd.19
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=psTrxtwmxcm5rWooRpuQaAR3nVgY0IlcZBqer69Z6tc=;
        b=UBXpZukQ5zrpL7SsqvdkAikI4NJd2P3kp46lyiX+NiYdeleul7dfOIZgS5AoRGDAT4
         YT8MM21cnN42v5+kuoXy96L507UgNYucGn+LJ1AWuJFcPmKKav0LaCJxD6GZf2bPQ/qd
         0thX01zvsbvmKoRZ4xTE+OFYeFCwKTEYUwP7iwEK5b7lYJGki0/dVul6DGDRieTcsONv
         oLw0mgBPd3y16/s9uWKcxKV2SvXuPMl+jA6dHY1bMwEeiOpYdg0teT7dZWlpwwrm6D7l
         VJgrzmujyZHFg1hc/Dx3ZdLy2MkcA/+Je/I/Bm8skN9QNUpa/DD3ABdw+EjxlPRfxwkN
         9cqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=psTrxtwmxcm5rWooRpuQaAR3nVgY0IlcZBqer69Z6tc=;
        b=ea8Cw+hUzE1huMf1u+a2rkptpHMqLUpogKc1WAa5cH0RPNWjwLlDTtg/Ped5AzFiox
         ew0OS25muvV5GSrElHYyvytZNGyAkO2hN3mNE8Erued8Z9A06hDgAWpN5FwG/OOe3BmN
         X8tg/sjpLmfx4BEnP8c1glTx/1m9E02OJQ1oEDttckd7DwptiSY1Zh2HCg7OCe4wYQpT
         Pjms81THHajvEPGP2KMuPN3weg9736/kRSfm4vgthsSBq3nIqCiIQSl/E035FREwXePE
         H7RsGP9DAapir6Ca3TzH5mY8doLZqPzpoCGPiExQnPS8bt5N8UOKN47vhF62JmT/DKxc
         /O0Q==
X-Gm-Message-State: AOAM533Gh1TPixQafx5DjugK9TyS+tSJHiKJTvMTGykTpTONzCORzImJ
        ZhpNphYlsbVCrl0zSAKFJgpbWzvwwys=
X-Google-Smtp-Source: ABdhPJw8RPq/1UnPllZ/jYUntq5PJiPUgqtorRSt/EgY0E8lnwwEIidYAysxQZUIwRz0bj4FwGjlkwwQcX8=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:390a:: with SMTP id
 ob10mr6950955pjb.216.1637132013923; Tue, 16 Nov 2021 22:53:33 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:46 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-17-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 16/29] KVM: arm64: Add consistency checking for frac
 fields of ID registers
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

Feature fractional field of an ID register cannot be simply validated
at KVM_SET_ONE_REG because its validity depends on its (main) feature
field value, which could be in a different ID register (and might be
set later).
Validate fractional fields at the first KVM_RUN instead.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/kvm/arm.c              |   3 +
 arch/arm64/kvm/sys_regs.c         | 125 +++++++++++++++++++++++++++++-
 3 files changed, 127 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 72db73c79403..9dc9970a2d46 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -746,6 +746,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2f03cbfefe67..19c4a78f931d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -588,6 +588,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
+	if (!kvm_vm_is_protected(kvm) && kvm_id_regs_consistency_check(vcpu))
+		return -EPERM;
+
 	vcpu->arch.has_run_once = true;
 
 	kvm_arm_vcpu_init_debug(vcpu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 35e458cc1e1d..b848ecea0c59 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -841,9 +841,6 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR1_EL1,
-	.ftr_check_types = U_FCT(ID_AA64PFR1_RASFRAC_SHIFT, FCT_IGNORE) |
-			   U_FCT(ID_AA64PFR1_MPAMFRAC_SHIFT, FCT_IGNORE) |
-			   U_FCT(ID_AA64PFR1_CSV2FRAC_SHIFT, FCT_IGNORE),
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.get_reset_val = get_reset_id_aa64pfr1_el1,
@@ -3460,10 +3457,106 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+/* ID register's fractional field information with its feature field. */
+struct feature_frac {
+	u32	id;
+	u32	shift;
+	u32	frac_id;
+	u32	frac_shift;
+	u8	frac_ftr_check;
+};
+
+static struct feature_frac feature_frac_table[] = {
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_RASFRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_RAS_SHIFT,
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_MPAMFRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_MPAM_SHIFT,
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_CSV2FRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_CSV2_SHIFT,
+	},
+};
+
+/*
+ * Return non-zero if the feature/fractional fields pair are not
+ * supported. Return zero otherwise.
+ * This function only checks fractional feature field and assumes
+ * the feature field is valid.
+ */
+static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
+					  const struct feature_frac *ftr_frac)
+{
+	u32 id;
+	int fval, flim, ret;
+	u64 val, lim, mask;
+	const struct id_reg_info *id_reg;
+	bool sign = FCT_SIGN(ftr_frac->frac_ftr_check);
+	enum feature_check_type type = FCT_TYPE(ftr_frac->frac_ftr_check);
+
+	/* Check if the feature field value is same as the limit */
+	id = ftr_frac->id;
+	id_reg = GET_ID_REG_INFO(id);
+
+	val = __read_id_reg(vcpu, id);
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+
+	mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->shift;
+	if ((val & mask) != (lim & mask))
+		/*
+		 * The feature level is smaller than the limit.
+		 * Any fractional version should be fine.
+		 */
+		return 0;
+
+	/* Check the fractional feature field */
+	id = ftr_frac->frac_id;
+	id_reg = GET_ID_REG_INFO(id);
+
+	val = __read_id_reg(vcpu, id);
+	fval = cpuid_feature_extract_field(val, ftr_frac->frac_shift, sign);
+
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	flim = cpuid_feature_extract_field(lim, ftr_frac->frac_shift, sign);
+
+	ret = arm64_check_feature_one(type, fval, flim);
+	return ret ? -E2BIG : 0;
+}
+
+int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
+{
+	int i, err;
+	const struct feature_frac *frac;
+
+	/*
+	 * Check ID registers' fractional fields, which aren't checked
+	 * at KVM_SET_ONE_REG.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		err = vcpu_id_reg_feature_frac_check(vcpu, frac);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static void id_reg_info_init_all(void)
 {
 	int i;
 	struct id_reg_info *id_reg;
+	struct feature_frac *frac;
+	u64 mask = ARM64_FEATURE_FIELD_MASK;
+	u64 org;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
 		id_reg = (struct id_reg_info *)id_reg_info_table[i];
@@ -3472,6 +3565,32 @@ static void id_reg_info_init_all(void)
 
 		id_reg_info_init(id_reg);
 	}
+
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		id_reg = GET_ID_REG_INFO(frac->frac_id);
+
+		/*
+		 * An ID register that has fractional fields is expected
+		 * to have its own id_reg_info.
+		 */
+		if (WARN_ON_ONCE(!id_reg))
+			continue;
+
+		/*
+		 * Update the id_reg's ftr_check_types for the fractional
+		 * field with FCT_IGNORE so that the field won't be validated
+		 * when the ID register is set by userspace, which could
+		 * temporarily cause an inconsistency if its (main) feature
+		 * field is not set yet.  Save the original ftr_check_types
+		 * for the fractional field to validate the field later.
+		 */
+		org = (id_reg->ftr_check_types >> frac->frac_shift) & mask;
+		id_reg->ftr_check_types &= ~(mask << frac->frac_shift);
+		id_reg->ftr_check_types |=
+			MAKE_FCT(frac->frac_shift, FCT_IGNORE, FCT_SIGN(org));
+		frac->frac_ftr_check = org;
+	}
 }
 
 void kvm_sys_reg_table_init(void)
-- 
2.34.0.rc1.387.gb447b232ab-goog


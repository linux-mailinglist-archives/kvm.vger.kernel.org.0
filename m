Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2794D5A09
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346455AbiCKEuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346494AbiCKEuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:50:01 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CE01AAFD0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:53 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x123-20020a626381000000b004f6fc50208eso4535309pfb.11
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DltmKg7opwhIQvsCwmEx6qs3h14xPlDqswCiLBq3BvI=;
        b=N39NQTTkdbZnRTzSRZEqZFrgTaFi2lK42y1/qZ1pn8Pbr5yj0p9nYTSuhihb/Lu7sN
         dcVYmv/4AvKdLQy0RzMJr/m5lgP/QBuf9FWhQU5tcKmJLEpCItk3qaBIYUuyaqVenVRb
         QPqY7gVLWPRDfezgK4RqFc7luPzOknbDAl0I0mtaKwd/XlEWy/XLC2GGb8aWgsnsZ/ld
         DT+bSp2hAUW+34+S4eKwqMNUNcpyxVHKM97cmvbV3wBjdQJNAzCQTistKsISe5uLVoZz
         8//fO4tniGmbUOmnQGpOVgylJluO75sgWNrifgjIbTlzAefKYxlH7Fi09jTmhfkjfLl6
         r6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DltmKg7opwhIQvsCwmEx6qs3h14xPlDqswCiLBq3BvI=;
        b=cqYTKk0VbPkNUVZ9R77kb1xo/6WHSknsB8xLEQsSaN2YDxfZkoxu63DK8wiSkL1Aad
         WtmtvqxRtRdoJQwgvxop1luIDsbgUd5ZCLDFds0UDX08ibZf6O/Q4QSUylYZmBnbna+I
         l/taNTTTk7XWtQ+np0JvNrADHOItLV9h1twu4Ri2qT1qgLcqs5HbD3S3r6NAWpsXKdwY
         efQrAm2FAqGg8YKBBTNj4vXx5msRrAqmbnCnL5bTQQLk8z53TPuKSQMa5aW8BreKBjZ6
         dXtXFqAl/IiNh8Wwdo0PpxmlDBeyVbdhj76oE2zwyiT7pKl9LmwtYNuoWWdstmy0Nqig
         yzOg==
X-Gm-Message-State: AOAM530gZNU1zCmPrzgZ+7+Cwlj0B08qqoj461VDJvouM/d+8SrZnfZd
        Z26WhCBTjGFI7/YZkxilZOc0pZzmjFI=
X-Google-Smtp-Source: ABdhPJwFRwT5Fgamh4l+5MQdfg7BYHp05vvdFwuVRvSeFNzp6LJbqoSWM+rN32ZUxVO+QSRSMIPfjJ4nruM=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:10cf:b0:4f6:5834:aefb with SMTP id
 d15-20020a056a0010cf00b004f65834aefbmr8229183pfu.77.1646974132762; Thu, 10
 Mar 2022 20:48:52 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:47:59 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-14-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 13/25] KVM: arm64: Add consistency checking for frac fields
 of ID registers
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

Feature fractional field of an ID register cannot be simply validated
at KVM_SET_ONE_REG because its validity depends on its (main) feature
field value, which could be in a different ID register (and might be
set later).
Validate fractional fields at the first KVM_RUN instead.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/arm.c              |   3 +
 arch/arm64/kvm/sys_regs.c         | 112 ++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9ffe6604a58a..5e53102a1ac1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -748,6 +748,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 
 void set_default_id_regs(struct kvm *kvm);
 int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
+int kvm_id_regs_check_frac_fields(const struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 91110d996ed6..e7dcc7704302 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -599,6 +599,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (likely(vcpu_has_run_once(vcpu)))
 		return 0;
 
+	if (!kvm_vm_is_protected(kvm) && kvm_id_regs_check_frac_fields(vcpu))
+		return -EPERM;
+
 	kvm_arm_vcpu_init_debug(vcpu);
 
 	if (likely(irqchip_in_kernel(kvm))) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ba851de6486d..3805b69ed23e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3397,6 +3397,102 @@ void kvm_sys_reg_table_init(void)
 	id_reg_desc_init_all();
 }
 
+/* ID register's fractional field information with its feature field. */
+struct feature_frac {
+	u32	id;
+	u32	shift;
+	u32	frac_id;
+	u32	frac_shift;
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
+ * This function validates only the fractional feature field,
+ * and relies on the fact the feature field is validated before
+ * through arm64_check_features_kvm.
+ */
+static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
+					  const struct feature_frac *ftr_frac)
+{
+	const struct id_reg_desc *id_reg;
+	u32 id;
+	u64 val, lim, mask;
+
+	/* Check if the feature field value is same as the limit */
+	id = ftr_frac->id;
+	id_reg = get_id_reg_desc(id);
+
+	mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->shift;
+	val = __read_id_reg(vcpu, id_reg) & mask;
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	lim &= mask;
+
+	if (val != lim)
+		/*
+		 * The feature level is lower than the limit.
+		 * Any fractional version should be fine.
+		 */
+		return 0;
+
+	/* Check the fractional feature field */
+	id = ftr_frac->frac_id;
+	id_reg = get_id_reg_desc(id);
+
+	mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->frac_shift;
+	val = __read_id_reg(vcpu, id_reg) & mask;
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	lim &= mask;
+
+	if (val == lim)
+		/*
+		 * Both the feature and fractional fields are the same
+		 * as limit.
+		 */
+		return 0;
+
+	return arm64_check_features_kvm(id, val, lim);
+}
+
+int kvm_id_regs_check_frac_fields(const struct kvm_vcpu *vcpu)
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
 /*
  * Update the ID register's field with @fval for the guest.
  * The caller is expected to hold the kvm->lock.
@@ -3600,6 +3696,8 @@ static void id_reg_desc_init_all(void)
 {
 	int i;
 	struct id_reg_desc *id_reg;
+	struct feature_frac *frac;
+	u64 ftr_mask = ARM64_FEATURE_FIELD_MASK;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_desc_table); i++) {
 		id_reg = (struct id_reg_desc *)id_reg_desc_table[i];
@@ -3608,6 +3706,20 @@ static void id_reg_desc_init_all(void)
 
 		id_reg_desc_init(id_reg);
 	}
+
+	/*
+	 * Update ignore_mask of ID registers based on fractional fields
+	 * information.  Any ID register that have fractional fields
+	 * is expected to have its own id_reg_desc.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		id_reg = get_id_reg_desc(frac->frac_id);
+		if (WARN_ON_ONCE(!id_reg))
+			continue;
+
+		id_reg->ignore_mask |= ftr_mask << frac->frac_shift;
+	}
 }
 
 /*
-- 
2.35.1.723.g4982287a31-goog


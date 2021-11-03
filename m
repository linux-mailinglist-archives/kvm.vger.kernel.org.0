Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D8A443D35
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhKCGbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbhKCGa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:59 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C659C061203
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:23 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id v18-20020a170902e8d200b00141df2da949so664180plg.10
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=C5yQ8yOodLMSFDUkZwymSW+rTndotw8MH+3y9C4rprM=;
        b=hp7Gve4yuw1Lb8fSnMTaCb1v3CrKrMIh7lOFjpQry051BYkVMJaPcmD5uXfn45bS99
         ZfaZECLNPlxL6/G7mCWP2IQj+t+BiUvS7Y7/Z2vYzVGt3DqYNwOYUBfkXKPDS8se+vCE
         P8IXmSxPCdU/4Ch2lQfLHZFO7HOHGCK1CugfdIJmPs6PHVY6iFHCVkpYM+bN0LndC4I9
         afP3BcZs/dkMnywcE0AMdAexTLcKeYGnFwwONqJ2q0CEonVmiplrXkDstgRS7mQAYPxS
         Q7OrAUNx5N0A8diXaGEFBUnCEl3GaFjNaJkUU1QjXmldNtoXQxMdbvwO/mZWSKOS8Exb
         tEBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C5yQ8yOodLMSFDUkZwymSW+rTndotw8MH+3y9C4rprM=;
        b=fKrYSOSuKUbeUV0FGpjJ1W5OoDtGZ4ggwQKCCQd5B1RjMVpAV9UmYSumzftKzb0Y/j
         2aSlM5IFXueBfWY9RPBOv5yNOeaj1dCXIMwWPfrDkwgiTo8/92PxY36mzqNCvNkTI7bu
         5u3CMUPiE5aERMRJI5Qaah0l7ashO8+GM4dIk7pgGMVTfav3LfV4POG8fNN+xrA84Glf
         8dPzUUqoZ/d1KyZCcxxxvKfGI74G0LRuy3FuMNpuFf8JaAR6G8I1/ae8OrnxKictd9E4
         zo3kpReXbok4GFNJIVpaB2pGZA5qck5rT6GUiWQmX1M/EI0FAUyzm5b+y8V8G/Cg51MG
         /2CA==
X-Gm-Message-State: AOAM533HYsODzuX5ZBy4t6TGAsf+yvPFAHHcg1Pf9C7YodBXSEOSgXPD
        pGOTNVPaFB9T1tpBN8b/c3myZQpr2SI=
X-Google-Smtp-Source: ABdhPJxcks24XT7LWQqlv4ZZTDZSBB0irMiSAQnwrrX8h6gSYkanjyBTWa61E3/HPOvc7PD9rNXtBIcbNp4=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:9b8a:b0:13f:c286:a060 with SMTP id
 y10-20020a1709029b8a00b0013fc286a060mr36314809plp.66.1635920903036; Tue, 02
 Nov 2021 23:28:23 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:09 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-18-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 17/28] KVM: arm64: Add consistency checking for frac
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
 arch/arm64/kvm/sys_regs.c | 121 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 117 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1b4ffbf539a7..ec984fd4e319 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -817,9 +817,6 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR1_EL1,
-	.ftr_check_types = U_FCT(ID_AA64PFR1_RASFRAC_SHIFT, FCT_IGNORE) |
-			   U_FCT(ID_AA64PFR1_MPAMFRAC_SHIFT, FCT_IGNORE) |
-			   U_FCT(ID_AA64PFR1_CSV2FRAC_SHIFT, FCT_IGNORE),
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.get_reset_val = get_reset_id_aa64pfr1_el1,
@@ -3407,10 +3404,86 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
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
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
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
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
+	fval = cpuid_feature_extract_field(val, ftr_frac->frac_shift, sign);
+
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	flim = cpuid_feature_extract_field(lim, ftr_frac->frac_shift, sign);
+
+	ret = arm64_check_feature_one(type, fval, flim);
+	return ret ? -E2BIG : 0;
+}
+
 int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
 {
-	int i;
+	int i, err;
 	const struct kvm_vcpu *t_vcpu;
+	const struct feature_frac *frac;
 
 	/*
 	 * Make sure vcpu->arch.has_run_once is visible for others so that
@@ -3431,6 +3504,17 @@ int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
 					KVM_ARM_ID_REG_MAX_NUM))
 			return -EINVAL;
 	}
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
 	return 0;
 }
 
@@ -3438,6 +3522,9 @@ static void id_reg_info_init_all(void)
 {
 	int i;
 	struct id_reg_info *id_reg;
+	struct feature_frac *frac;
+	u64 mask = ARM64_FEATURE_FIELD_MASK;
+	u64 org;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
 		id_reg = (struct id_reg_info *)id_reg_info_table[i];
@@ -3446,6 +3533,32 @@ static void id_reg_info_init_all(void)
 
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
2.33.1.1089.g2158813163f-goog


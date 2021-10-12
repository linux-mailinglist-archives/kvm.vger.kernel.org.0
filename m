Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1963F429C9F
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhJLEiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbhJLEim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:42 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEB8C061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:41 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k18-20020a170902c41200b0013f24806d35so2668752plk.1
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NdSMRo52Kt8R49ASB3iWmgOfNvqbp057LlUUAD7mUQ8=;
        b=UJMj1LQnQg8ni482AfX60HHwpm8Qdom8NNgfPE0bTl86X4YpvAIA/blDO5OHvVVxpt
         OMG9HXknPMZA4yh62hHr1vUuixaM5NtleBEvLLzCSflMqnJR94YrBRunIlqd27uYLYzo
         Hke6AO32AiOv7drD5U03XDkZJ4BJwD9kLzPeXwwzxkOwEOfZFdxzlj2p0ncOC1z7EL0H
         YJiP8uqQz3Ozfmb3zGYTDjQtsnZkCpE26TLAb3d7ro6dcu8FBo2zNWngLlRQQtPh9mHA
         py5TkWMBMMoPGNxlnZAu46Jzbv+EzyRZ2ULtjhNyIDXMgvJme8F7lkvqQUrLXOfbNQ3n
         uPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NdSMRo52Kt8R49ASB3iWmgOfNvqbp057LlUUAD7mUQ8=;
        b=EOsBW/Q0oNmUYTAph1APEwzp84WPW5DfQC16RxI4UsMSrYY2AuC9oFh+73eDMfaoUZ
         k9Ui+/lxMvcBosebHibP/XlQVWQmKA+EagXYaT241p3ugiIawQ+zstroE5GCRsUsHSVP
         Nl8DHBHvaoI6NE2ROMCAG4QoFkZoBHGlQ2xxJnfqVekB/IocT6mQbcGaun1VPTwNJSIC
         +B8PU+3nJZRgg54rxOizi7jusYtDxrGuAV+w3USCL5byxDW7byyv6o0+u3bcuiATY31P
         UwcB8g+4cjvJ8ty9tiMRVZrMP72I+k03wigRn8FOwaAFhS34pp6oQHnhX9wHeejehaUZ
         Xtyw==
X-Gm-Message-State: AOAM531KvWK7jDe3lhDsumxYCarO+KZmvMkD2hSM+dCZlckfnNCWwr5u
        Iza9pFGfwaM6CiRe/HvA+x2n9VOOICk=
X-Google-Smtp-Source: ABdhPJwFu+FIz+R1kOBR7i1iuVZKIe5AIiaGB4ZNE8m5SuwM1w6CfzaHd9uansbux6G4jPV1AJeCKsHeMB0=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90a:8b8d:: with SMTP id
 z13mr296149pjn.0.1634013400403; Mon, 11 Oct 2021 21:36:40 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:24 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-15-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 14/25] KVM: arm64: Add consistency checking for frac
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
 arch/arm64/kvm/sys_regs.c | 98 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2c092136cdff..536e313992d4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -632,9 +632,6 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR1_EL1,
-	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
-		       ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
-		       ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.get_reset_val = get_reset_id_aa64pfr1_el1,
@@ -3198,10 +3195,79 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+/* ID register's fractional field information with its feature field. */
+struct feature_frac {
+	u32	frac_id;
+	u32	id;
+	u64	frac_mask;
+	u64	mask;
+};
+
+static const struct feature_frac feature_frac_table[] = {
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC),
+		.id = SYS_ID_AA64PFR0_EL1,
+		.mask = ARM64_FEATURE_MASK(ID_AA64PFR0_RAS),
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC),
+		.id = SYS_ID_AA64PFR0_EL1,
+		.mask = ARM64_FEATURE_MASK(ID_AA64PFR0_MPAM),
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
+		.id = SYS_ID_AA64PFR0_EL1,
+		.mask = ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2),
+	},
+};
+
+/*
+ * Return non-zero if the feature/fractional fields pair are not
+ * supported. Return zero otherwise.
+ */
+static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
+					  const struct feature_frac *ftr_frac)
+{
+	const struct id_reg_info *id_reg;
+	u32 id;
+	u64 val, lim;
+	int err;
+
+	/* Check the feature field */
+	id = ftr_frac->id;
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) & ftr_frac->mask;
+	id_reg = GET_ID_REG_INFO(id);
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	lim &= ftr_frac->mask;
+	err = arm64_check_features(id, val, lim);
+	if (err)
+		/* The feature version is larger than the limit. */
+		return err;
+
+	if (val != lim)
+		/*
+		 * The feature version is smaller than the limit.
+		 * Any fractional version should be fine.
+		 */
+		return 0;
+
+	/* Check the fractional field */
+	id = ftr_frac->frac_id;
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) & ftr_frac->frac_mask;
+	id_reg = GET_ID_REG_INFO(id);
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	lim &= ftr_frac->frac_mask;
+	return arm64_check_features(id, val, lim);
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
@@ -3222,6 +3288,17 @@ int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
 					KVM_ARM_ID_REG_MAX_NUM))
 			return -EINVAL;
 	}
+
+	/*
+	 * Check ID registers' fractional fields, which aren't checked
+	 * when userspace sets.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		err = vcpu_id_reg_feature_frac_check(vcpu, frac);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
@@ -3240,6 +3317,19 @@ static void id_reg_info_init_all(void)
 		else
 			id_reg_info_init(id_reg);
 	}
+
+	/*
+	 * Update ignore_mask of ID registers based on fractional fields
+	 * information.  Any ID register that have fractional fields
+	 * is expected to have its own id_reg_info.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		id_reg = GET_ID_REG_INFO(feature_frac_table[i].frac_id);
+		if (WARN_ON_ONCE(!id_reg))
+			continue;
+
+		id_reg->ignore_mask |= feature_frac_table[i].frac_mask;
+	}
 }
 
 void kvm_sys_reg_table_init(void)
-- 
2.33.0.882.g93a45727a2-goog


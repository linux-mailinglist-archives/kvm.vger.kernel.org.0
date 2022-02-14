Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53ECA4B4273
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241122AbiBNHCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:02:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241112AbiBNHCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:02:04 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E516192A4
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:53 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id bj11-20020a17090b088b00b001b8ba3e7ce7so13505140pjb.2
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WABpAU2qJkR+sw2cfBDI8FHTBtRLd4dMUYVQ4LTw+8g=;
        b=egG8vVaEUevzkZVdPaLHtKQAzmIgZvBcVp8ieR2m6tLmQMm2jlr7pTCRgxjTqekbsu
         2jyMfLERly9YpBSfK/EBG62D6RMBp7HeixQgR0F+UWY19HM4aJ7e7HzDtJPhVlxibLpD
         7Jz+IDHi9HSO/OKLz1wNCSTBrdCqyObCHZNWlEteoZ6IZZ0lkR+QkrqKPgxm6vhSV+dB
         AmS/AaK/5a9cPCefsXhaTb8SRJiCnWSz0fOgRRTdDAAi8Bw+XLQ8Mpf5CkKIJX6fv8+S
         s96RtXJd3i9wRGmA9jTycTV/Ie+IdDlk7EKelIP56POUTq2mjVON/+DWt5iti4bXHxa5
         CYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WABpAU2qJkR+sw2cfBDI8FHTBtRLd4dMUYVQ4LTw+8g=;
        b=fTPuY26HmcrzQqcf4UEgDm+kxM6GTJcj0jV/ak6fWNOFcmzAHG0VLF28UnotTIRXtI
         bmXgtdktjVXfwcBJcE492ApiHNyvUfjzyrVaUfL6NZdorSVXtgvY//8HoZdnDK8ZNPVq
         TmiIvruyM6OchtREFuNRVAx4uykb/fIJ0gtO6p4dWUvojQNnrPSLFax3KJBbwVI9BDq4
         57HkLGXAc0CP0lzB3DfMYIn7jTRnR0w3N3IxDuRFHm02WdGFd9DxI8I1wMs4wrQt2OG+
         hnfa1KbOUfGvqz+7iGbxErjlS0VvXDs5Rl8SnmbT9q2OQ+hzUIhN0awg9nJk2DR0y+gI
         MRvw==
X-Gm-Message-State: AOAM532I3VfFPgwKYTH6A5Ld6lamMMR+03QaKlTvkuQ2lsci3nrf7Vse
        R9+bPqZJ4mp23TFgLgKZPPgngEoA7ic=
X-Google-Smtp-Source: ABdhPJyvylkGqpuhgkE8kDj+Z2dPsaGDCw0umQZ4l2AioHsBizRpURLxEI5OPwq6awe+SzAOYrvdOOoekx8=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:4d91:: with SMTP id
 oj17mr9258241pjb.236.1644822112637; Sun, 13 Feb 2022 23:01:52 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:45 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-27-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 26/27] KVM: arm64: Add kunit test for trap initialization
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

Add KUnit tests for functions in arch/arm64/kvm/sys_regs_test.c
that activates traps for disabled features.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs_test.c | 262 +++++++++++++++++++++++++++++++++
 1 file changed, 262 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs_test.c b/arch/arm64/kvm/sys_regs_test.c
index 30603d0623cd..391e13579ca7 100644
--- a/arch/arm64/kvm/sys_regs_test.c
+++ b/arch/arm64/kvm/sys_regs_test.c
@@ -991,6 +991,265 @@ static void validate_id_reg_test(struct kunit *test)
 	GET_ID_REG_INFO(id) = original_idr;
 }
 
+struct trap_config_test {
+	u64 set;
+	u64 clear;
+	u64 prev_val;
+	u64 expect_val;
+};
+
+struct trap_config_test trap_params[] = {
+	{0x30000800000, 0, 0, 0x30000800000},
+	{0, 0x30000800000, 0, 0},
+	{0x30000800000, 0, (u64)-1, (u64)-1},
+	{0, 0x30000800000, (u64)-1, (u64)0xfffffcffff7fffff},
+};
+
+static void trap_case_to_desc(struct trap_config_test *t, char *desc)
+{
+	snprintf(desc, KUNIT_PARAM_DESC_SIZE,
+		 "trap - set:0x%llx, clear:0x%llx, prev_val:0x%llx\n",
+		 t->set, t->clear, t->prev_val);
+}
+
+KUNIT_ARRAY_PARAM(trap, trap_params, trap_case_to_desc);
+
+/* Tests for feature_trap_activate(). */
+static void feature_trap_activate_test(struct kunit *test)
+{
+	struct kvm_vcpu *vcpu;
+	const struct trap_config_test *trap = test->param_value;
+
+	vcpu = test_kvm_vcpu_init(test);
+	KUNIT_ASSERT_TRUE(test, vcpu);
+
+	/* Test for HCR_EL2 */
+	vcpu->arch.hcr_el2 = trap->prev_val;
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, trap->set, trap->clear);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2, trap->expect_val);
+
+	/* Test for MDCR_EL2 */
+	vcpu->arch.mdcr_el2 = trap->prev_val;
+	feature_trap_activate(vcpu, VCPU_MDCR_EL2, trap->set, trap->clear);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.mdcr_el2, trap->expect_val);
+
+	/* Test for CPTR_EL2 */
+	vcpu->arch.cptr_el2 = trap->prev_val;
+	feature_trap_activate(vcpu, VCPU_CPTR_EL2, trap->set, trap->clear);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.cptr_el2, trap->expect_val);
+}
+
+static u64 test_trap_set0;
+static u64 test_trap_clear0;
+static void test_trap_activate0(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2,
+			      test_trap_set0, test_trap_clear0);
+}
+
+static u64 test_trap_set1;
+static u64 test_trap_clear1;
+static void test_trap_activate1(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2,
+			      test_trap_set1, test_trap_clear1);
+}
+
+static u64 test_trap_set2;
+static u64 test_trap_clear2;
+static void test_trap_activate2(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2,
+			      test_trap_set2, test_trap_clear2);
+}
+
+
+static void setup_feature_config_ctrl(struct feature_config_ctrl *config,
+				      u32 id, int shift, int min, bool sign,
+				      void *fn)
+{
+	memset(config, 0, sizeof(*config));
+	config->ftr_reg = id;
+	config->ftr_shift = shift;
+	config->ftr_min = min;
+	config->ftr_signed = sign;
+	config->trap_activate = fn;
+}
+
+/*
+ * Tests for id_reg_features_trap_activate.
+ * Setup a id_reg_info with three entries in id_reg_info->trap_features[].
+ * Check if the config register is updated to enable trap for the disabled
+ * features.
+ */
+static void id_reg_features_trap_activate_test(struct kunit *test)
+{
+	struct kvm_vcpu *vcpu;
+	u32 id;
+	u64 cfg_set, cfg_clear, id_reg_sys_val, id_reg_val;
+	struct id_reg_info id_reg_data;
+	struct feature_config_ctrl config0, config1, config2;
+	struct feature_config_ctrl *trap_features[] = {
+		&config0, &config1, &config2, NULL,
+	};
+
+	vcpu = test_kvm_vcpu_init(test);
+	KUNIT_EXPECT_TRUE(test, vcpu);
+	if (!vcpu)
+		return;
+
+	/* Setup id_reg_info */
+	id_reg_sys_val = 0x7777777777777777;
+	id = SYS_ID_AA64DFR0_EL1;
+	id_reg_data.sys_reg = id;
+	id_reg_data.sys_val = id_reg_sys_val;
+	id_reg_data.vcpu_limit_val  = (u64)-1;
+	id_reg_data.trap_features =
+			(const struct feature_config_ctrl *(*)[])trap_features;
+
+	/* Setup the 1st feature_config_ctrl */
+	test_trap_set0 = 0x3;
+	test_trap_clear0 = 0x0;
+	setup_feature_config_ctrl(&config0, id, 60, 2, FTR_UNSIGNED,
+				  &test_trap_activate0);
+
+	/* Setup the 2nd feature_config_ctrl */
+	test_trap_set1 = 0x30000040;
+	test_trap_clear1 = 0x40000000;
+	setup_feature_config_ctrl(&config1, id, 0, 1, FTR_UNSIGNED,
+				  &test_trap_activate1);
+
+	/* Setup the 3rd feature_config_ctrl */
+	test_trap_set2 = 0x30000000800;
+	test_trap_clear2 = 0x40000000000;
+	setup_feature_config_ctrl(&config2, id, 4, 0, FTR_SIGNED,
+				  &test_trap_activate2);
+
+#define	ftr_dis(cfg)	\
+	((u64)(((cfg)->ftr_min - 1) & 0xf) << (cfg)->ftr_shift)
+
+#define	ftr_en(cfg)	\
+	((u64)(cfg)->ftr_min << (cfg)->ftr_shift)
+
+	/* Test with features enabled for config0, 1 and 2 */
+	id_reg_val = ftr_en(&config0) | ftr_en(&config1) | ftr_en(&config2);
+	write_kvm_id_reg(vcpu->kvm, id, id_reg_val);
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2, 0);
+
+
+	/* Test with features disabled for config0 only */
+	id_reg_val = ftr_dis(&config0) | ftr_en(&config1) | ftr_en(&config2);
+	write_kvm_id_reg(vcpu->kvm, id, id_reg_val);
+	vcpu->arch.hcr_el2 = 0;
+	cfg_set = test_trap_set0;
+	cfg_clear = test_trap_clear0;
+
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_set, cfg_set);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_clear, 0);
+
+
+	/* Test with features disabled for config0 and config1  */
+	id_reg_val = ftr_dis(&config0) | ftr_dis(&config1) | ftr_en(&config2);
+	write_kvm_id_reg(vcpu->kvm, id, id_reg_val);
+	vcpu->arch.hcr_el2 = 0;
+
+	cfg_set = test_trap_set0 | test_trap_set1;
+	cfg_clear = test_trap_clear0 | test_trap_clear1;
+
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_set, cfg_set);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_clear, 0);
+
+
+	/* Test with features disabled for config0, config1, and config2 */
+	id_reg_val = ftr_dis(&config0) | ftr_dis(&config1) | ftr_dis(&config2);
+	write_kvm_id_reg(vcpu->kvm, id, id_reg_val);
+	vcpu->arch.hcr_el2 = 0;
+
+	cfg_set = test_trap_set0 | test_trap_set1 | test_trap_set2;
+	cfg_clear = test_trap_clear0 | test_trap_clear1 | test_trap_clear2;
+
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_set, cfg_set);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_clear, 0);
+
+
+	/* Test with id_reg_info == NULL */
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, NULL);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2, 0);
+
+
+	/* Test with id_reg_data.trap_features = NULL */
+	id_reg_data.trap_features = NULL;
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2, 0);
+
+}
+
+/* Tests for vcpu_need_trap_ptrauth(). */
+static void vcpu_need_trap_ptrauth_test(struct kunit *test)
+{
+	struct kvm_vcpu *vcpu;
+	u32 id = SYS_ID_AA64ISAR1_EL1;
+
+	vcpu = test_kvm_vcpu_init(test);
+	KUNIT_EXPECT_TRUE(test, vcpu);
+	if (!vcpu)
+		return;
+
+	if (system_has_full_ptr_auth()) {
+		/* Tests with PTRAUTH disabled vCPU */
+		write_kvm_id_reg(vcpu->kvm, id, 0x0);
+		KUNIT_EXPECT_TRUE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPI = 1, API = 1 */
+		write_kvm_id_reg(vcpu->kvm, id, 0x10000100);
+		KUNIT_EXPECT_TRUE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPI = 1, APA = 1 */
+		write_kvm_id_reg(vcpu->kvm, id, 0x10000010);
+		KUNIT_EXPECT_TRUE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPA = 1, API = 1 */
+		write_kvm_id_reg(vcpu->kvm, id, 0x01000100);
+		KUNIT_EXPECT_TRUE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPA = 1, APA = 1 */
+		write_kvm_id_reg(vcpu->kvm, id, 0x01000010);
+		KUNIT_EXPECT_TRUE(test, vcpu_need_trap_ptrauth(vcpu));
+
+
+		/* Tests with PTRAUTH enabled vCPU */
+		vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
+
+		write_kvm_id_reg(vcpu->kvm, id, 0x0);
+		KUNIT_EXPECT_TRUE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPI = 1, API = 1 */
+		write_kvm_id_reg(vcpu->kvm, id, 0x10000100);
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPI = 1, APA = 1 */
+		write_kvm_id_reg(vcpu->kvm, id, 0x10000010);
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPA = 1, API = 1 */
+		write_kvm_id_reg(vcpu->kvm, id, 0x01000100);
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPA = 1, APA = 1 */
+		write_kvm_id_reg(vcpu->kvm, id, 0x01000010);
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+	} else {
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+	}
+}
+
 static struct kunit_case kvm_sys_regs_test_cases[] = {
 	KUNIT_CASE_PARAM(vcpu_id_reg_feature_frac_check_test, frac_gen_params),
 	KUNIT_CASE_PARAM(validate_id_aa64mmfr0_tgran2_test, tgran4_2_gen_params),
@@ -1006,6 +1265,9 @@ static struct kunit_case kvm_sys_regs_test_cases[] = {
 	KUNIT_CASE(validate_id_dfr0_el1_test),
 	KUNIT_CASE(validate_mvfr1_el1_test),
 	KUNIT_CASE(validate_id_reg_test),
+	KUNIT_CASE(vcpu_need_trap_ptrauth_test),
+	KUNIT_CASE_PARAM(feature_trap_activate_test, trap_gen_params),
+	KUNIT_CASE(id_reg_features_trap_activate_test),
 	{}
 };
 
-- 
2.35.1.265.g69c8d7142f-goog


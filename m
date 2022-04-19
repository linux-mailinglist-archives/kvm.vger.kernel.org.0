Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7770C506532
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349151AbiDSHA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349137AbiDSHAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:48 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B626627B23
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:57 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id oj16-20020a17090b4d9000b001c7552b7546so1167968pjb.8
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NuyHwIdLopy65edSNneYdDxbRUfisj8CwS/EiSJPzd8=;
        b=JuUUKKxB0c/5jIWsiYKyQ96v92kR8U04zVTmghfJqxxpOX8oOFxp3i2Z2Nh093oYyp
         H0/kx9a1P/1ubVd3lZh6kDtH/OiOf71OtqLY72YPtLpY8YP3ffOIP/lEAVsJQSBvHYot
         vzBxzkQhgwMMo9LdW17weQLrbPW108wD8tKY1Wbzlos4ZAFAKrE5q0N/q3ZNwaUf4SuT
         cdlO0hLMTuo62b1V7ayXsfaOxdiaZeIynR2WqLtL3z1lshngrZDzOiNr4pCJeXSHE/TC
         ruUHeK7oqyDFbziR9rKDw4GGtuul/EAGF4K2GLLmivhjb0emsW0h1fQUYia2GZAa0et3
         2qFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NuyHwIdLopy65edSNneYdDxbRUfisj8CwS/EiSJPzd8=;
        b=HJYaGLUyh6DcIeF8P6sMeoz54HyegBISOR/H8liT92ZuiXzlgAZpCoZgs3GtPov8Bi
         YmGeqPvfTfhJwUTCYJ0qin7dFNwbTiMR48XxDP6G8hzdMiYn1cyYHLOBNwBeu9IL0ZY6
         MkHKGvgdzZOb8x1Mp9CfdqSqT0oB+rAUxjS/pcdajEHoyahT4lDWNxrnqzxD5ARrYUW6
         4lCv/rkxroQKqy+OtZfOQXuMNVV+nh7BnSFyYcFWlyJd6qgwjzVjn1AXtOazXvR05Iwp
         STDzTz8PGhuQ2lCR08bCC+dA0HUgSL9fCVvJoJm5oNL76DmJr52k/rCeRAk/ztc8XYQk
         4sJg==
X-Gm-Message-State: AOAM530sm0F+JJtI4WPWx4yDYoL+1Fm1AZIXC8NQOY1qTnjLHwumKbsL
        oYdPo9od7LX9pXiUqy7+4zGzXTGSRjk=
X-Google-Smtp-Source: ABdhPJydE7fDS2laiwWJTKLimV4fAMnUFfC2eflrLVOosa8XXTixDdxvFoVs0mgS6AY3uBwDt69iQ8327ek=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a63:1141:0:b0:39c:b664:c508 with SMTP id
 1-20020a631141000000b0039cb664c508mr13579700pgr.49.1650351477273; Mon, 18 Apr
 2022 23:57:57 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:38 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-33-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 32/38] KVM: arm64: Add kunit test for trap initialization
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
 arch/arm64/kvm/sys_regs_test.c | 219 +++++++++++++++++++++++++++++++++
 1 file changed, 219 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs_test.c b/arch/arm64/kvm/sys_regs_test.c
index dff146fe0e62..f9b032032ec3 100644
--- a/arch/arm64/kvm/sys_regs_test.c
+++ b/arch/arm64/kvm/sys_regs_test.c
@@ -1041,6 +1041,222 @@ static void validate_id_reg_test(struct kunit *test)
 	}
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
+ * Setup a id_reg_desc with three entries in id_reg_desc->trap_features[].
+ * Check if the config register is updated to enable trap for the disabled
+ * features.
+ */
+static void id_reg_features_trap_activate_test(struct kunit *test)
+{
+	struct kvm_vcpu *vcpu;
+	u32 id;
+	u64 cfg_set, cfg_clear, id_reg_sys_val, id_reg_val;
+	struct id_reg_desc id_reg_data = {};
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
+	/* Setup id_reg_desc */
+	id_reg_sys_val = 0x7777777777777777;
+	id = SYS_ID_AA64DFR0_EL1;
+	set_sys_desc((struct sys_reg_desc *)&id_reg_data.reg_desc, id);
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
+	/* Test with id_reg_data.trap_features = NULL */
+	id_reg_data.trap_features = NULL;
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2, 0);
+}
+
+/* Tests for vcpu_need_trap_ptrauth(). */
+static void vcpu_need_trap_ptrauth_test(struct kunit *test)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = test_kvm_vcpu_init(test);
+	KUNIT_EXPECT_TRUE(test, vcpu);
+	if (!vcpu)
+		return;
+
+	if (system_has_full_ptr_auth()) {
+		/* Tests with PTRAUTH disabled vCPU */
+		KUNIT_EXPECT_TRUE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* Tests with PTRAUTH enabled vCPU */
+		vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
+
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+	} else {
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+	}
+}
+
 static struct kunit_case kvm_sys_regs_test_cases[] = {
 	KUNIT_CASE_PARAM(vcpu_id_reg_feature_frac_check_test, frac_gen_params),
 	KUNIT_CASE_PARAM(validate_id_aa64mmfr0_tgran2_test, tgran4_2_gen_params),
@@ -1056,6 +1272,9 @@ static struct kunit_case kvm_sys_regs_test_cases[] = {
 	KUNIT_CASE(validate_id_dfr0_el1_test),
 	KUNIT_CASE(validate_mvfr1_el1_test),
 	KUNIT_CASE(validate_id_reg_test),
+	KUNIT_CASE(vcpu_need_trap_ptrauth_test),
+	KUNIT_CASE_PARAM(feature_trap_activate_test, trap_gen_params),
+	KUNIT_CASE(id_reg_features_trap_activate_test),
 	{}
 };
 
-- 
2.36.0.rc0.470.gd361397f0d-goog


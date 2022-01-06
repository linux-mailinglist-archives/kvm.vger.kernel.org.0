Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999AE485FD6
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiAFE3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiAFE3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:29:10 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78488C061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:29:09 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id v20-20020a627a14000000b004bcdad8b249so948475pfc.5
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wUse+BjaO1EF62PN4ckFPpkWudR1Nst96Ufxr1ENT0o=;
        b=nl5EdeTn2MX99TOwr55i4V3kuX25v6crVaWQ/Ohk1jblFHVvp3SbXi0yyJEZygcY6G
         kzNJ7zivPq2LPdg+aXWmkL0QzFmQGxM1OLnKwwwOOHniSpLUOSyrrHBi9BG4GIIIA9bl
         GRQKa82FAVZLv8HYxiLFDQOBuFcNxMsWzYgshZhmgWbokBX6TIKLdeRkEvGH++V0/ON0
         8I89kKVEFX7Ls4E8KQaLWxRknLJe259TOI/kwKm4UlGri530GtbXCthZOuk0hLl2cBlm
         BgBxNaqZlthFa52c6M2Iglku+ARb4csxZL7HtXaks20TGEKe+2ndQYp7qqRTmRJjdpVI
         DtnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wUse+BjaO1EF62PN4ckFPpkWudR1Nst96Ufxr1ENT0o=;
        b=U2v5BXtj0uh8UZfr+L96Wr04LC5t2e3+S9aoo7r18tJb88ECyidclzzmagG5vw5jSQ
         ylFtmCF5Wq7p8Al5JnjB/BE7RZMwwHLbNou/KCF9JuOWWNmvpkm4kAcQ8DoYV988s849
         JH8Z2uOI8pXNaaGqK8f5pkxe5aXuqgY93/TXF/z8184aWluNHtf+VOvdo2Ev/5stxfKD
         OhjG4bRx7z+kaXshjGHryszsOfl4+XoUPabPjLBuxmCubchsTOONijkPGQ+D00kHWcgO
         YrBGBjjCpU/TqF2vrfBnROZOz8FRevrr3Z+XPJAS1OELJYMqZvgLtPOwozl4gon1yzb9
         XOxQ==
X-Gm-Message-State: AOAM533z22lG1d0dUCSvWqtyXXXqa4pSXjxYy8nUr11/UCmAzwxvVcT4
        U9iLfp6bAp1g9rYLAHgV1424iC/iazE=
X-Google-Smtp-Source: ABdhPJxjvSwFROaVM+pJUQ/XDyGBVQQKBDVruJZAXdd/RLU6848R10ZTYfNm7R/udZmhFgLlLLY4SedmMp8=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:120d:b0:149:ab6c:75d4 with SMTP id
 l13-20020a170903120d00b00149ab6c75d4mr26584318plh.3.1641443349014; Wed, 05
 Jan 2022 20:29:09 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:27:07 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-26-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 25/26] KVM: arm64: Add kunit test for trap initialization
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

Add KUnit tests for functions in arch/arm64/kvm/sys_regs_test.c
that activates traps for disabled features.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs_test.c | 262 +++++++++++++++++++++++++++++++++
 1 file changed, 262 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs_test.c b/arch/arm64/kvm/sys_regs_test.c
index 5b1b95bd9ec4..4a705ffef93b 100644
--- a/arch/arm64/kvm/sys_regs_test.c
+++ b/arch/arm64/kvm/sys_regs_test.c
@@ -959,6 +959,265 @@ static void validate_id_reg_test(struct kunit *test)
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
@@ -973,6 +1232,9 @@ static struct kunit_case kvm_sys_regs_test_cases[] = {
 	KUNIT_CASE(validate_id_dfr0_el1_test),
 	KUNIT_CASE(validate_mvfr1_el1_test),
 	KUNIT_CASE(validate_id_reg_test),
+	KUNIT_CASE(vcpu_need_trap_ptrauth_test),
+	KUNIT_CASE_PARAM(feature_trap_activate_test, trap_gen_params),
+	KUNIT_CASE(id_reg_features_trap_activate_test),
 	{}
 };
 
-- 
2.34.1.448.ga2b2bfdf31-goog


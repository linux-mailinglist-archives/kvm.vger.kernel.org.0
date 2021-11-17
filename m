Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8FD454172
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhKQG4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbhKQG4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:51 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D169BC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:53 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id o8-20020a170902d4c800b001424abc88f3so580313plg.2
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3Vy8zl0uiB6BzrVyosP76h+gx7fVBOmrAidLKwyOmLo=;
        b=SIFfTVfI7I8A9xtfgW2SGwAAgVjhFtCYzxi+nqRkzYADw/h3e55zX8dv0tcR7U3gTs
         Ow0HGNvpz/NuJG85fy363/AcS51o/aycC/kCv5uCjNhS+RCTNdAFQi4+DcDeTOnDeDse
         FVkEWvlwCHnfDvOvPIJ9ghlPfoOQgt8kKi10mbK55MgoCJkbF1IJEjpJu1oblfYzNLKq
         y4xT6lWYpL+xwM+iKPJwn2wFgMnVAK5Or854NPyaNECj9/og+mfPKEOLl7iIRm4Lmngr
         PItBcWboqdv21plvaPRpZkKCuZVq0DXHslVP9GpedQEfAciDbpFEfcddLsx2m9IGBW55
         wq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3Vy8zl0uiB6BzrVyosP76h+gx7fVBOmrAidLKwyOmLo=;
        b=61ybwpV0X0ifRyH9hqriMfHssOOyRZq7wZ1Z7DtFqPhS+RKpyuvbgpjWKTFlZuflYJ
         RZpvl8pOxnPSHBfkQj6szC4QvU8vx/B1bdDVqLCz7KxNoDZmtVBxh/3H2PDSIvxQDanK
         YTsfcf7LBkG3rDwgqzrRcbFekPgjdCm9K8hkp5oxcIkw0Atuo30w46N5mcmGy678QlpO
         rAuO1tSJgkurZ4nvkLApvn9VmVjityDXWcynZDaPDVhGgaoHTgGcvK/ijblPVUQIP1I0
         It6Sd5d+veMrh/VHPUolhr0zUfX4DssIhZ6Ok97dGU0fbiotuUSl8U6YC2vdZ6rLJ6QL
         8ffg==
X-Gm-Message-State: AOAM533dnovcVjhUSR3DYVRhNPDOtuTzJgBqGqoTKVXPerpTXc/iiXK0
        GxDHyp2F7OfjsQ1USqzobTwTtKsAjV0=
X-Google-Smtp-Source: ABdhPJyuYg+X9kpMVUPN5OoZNv12tw8vlVgjnQ4xCZ/tC4KYbUa1SUFiMJwvsngrbAH2RAUicLELQrXc63o=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:ed89:b0:141:f601:d6a with SMTP id
 e9-20020a170902ed8900b00141f6010d6amr52839367plj.77.1637132033292; Tue, 16
 Nov 2021 22:53:53 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:58 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-29-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 28/29] KVM: arm64: Add kunit test for trap initialization
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

Add KUnit tests for functions that initialize traps.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs_test.c | 238 +++++++++++++++++++++++++++++++++
 1 file changed, 238 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs_test.c b/arch/arm64/kvm/sys_regs_test.c
index 8d27c7c361fb..f73b207be4ee 100644
--- a/arch/arm64/kvm/sys_regs_test.c
+++ b/arch/arm64/kvm/sys_regs_test.c
@@ -844,6 +844,241 @@ static void validate_mvfr1_el1_test(struct kunit *test)
 	test_kvm_vcpu_fini(test, vcpu);
 }
 
+static void feature_trap_activate_test(struct kunit *test)
+{
+	struct kvm_vcpu *vcpu;
+	struct feature_config_ctrl config_data, *config = &config_data;
+	u64 cfg_mask, cfg_val;
+
+	vcpu = test_kvm_vcpu_init(test);
+	KUNIT_EXPECT_TRUE(test, vcpu);
+	if (!vcpu)
+		return;
+
+	vcpu->arch.hcr_el2 = 0;
+	config->ftr_reg = SYS_ID_AA64MMFR1_EL1;
+	config->ftr_shift = 4;
+	config->ftr_min = 2;
+	config->ftr_signed = FTR_UNSIGNED;
+
+	/* Test for hcr_el2 */
+	config->cfg_reg = VCPU_HCR_EL2;
+	cfg_mask = 0x30000800000;
+	cfg_val = 0x30000800000;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.hcr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_mask, cfg_val);
+
+	cfg_mask = 0x30000800000;
+	cfg_val = 0;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.hcr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_mask, cfg_val);
+
+	/* Test for mdcr_el2 */
+	config->cfg_reg = VCPU_MDCR_EL2;
+	cfg_mask = 0x30000800000;
+	cfg_val = 0x30000800000;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.mdcr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.mdcr_el2 & cfg_mask, cfg_val);
+
+	cfg_mask = 0x30000800000;
+	cfg_val = 0x0;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.mdcr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.mdcr_el2 & cfg_mask, cfg_val);
+
+	/* Test for cptr_el2 */
+	config->cfg_reg = VCPU_CPTR_EL2;
+	cfg_mask = 0x30000800000;
+	cfg_val = 0x30000800000;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.cptr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.cptr_el2 & cfg_mask, cfg_val);
+
+	cfg_mask = 0x30000800000;
+	cfg_val = 0x0;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.cptr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.cptr_el2 & cfg_mask, cfg_val);
+
+	test_kvm_vcpu_fini(test, vcpu);
+}
+
+static bool test_need_trap_aa64dfr0(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64DFR0_EL1));
+	return ((val & 0xf) == 0);
+}
+
+static void id_reg_features_trap_activate_test(struct kunit *test)
+{
+	struct kvm_vcpu *vcpu;
+	u32 id;
+	u64 cfg_mask0, cfg_val0, cfg_mask1, cfg_val1, cfg_mask2, cfg_val2;
+	u64 cfg_mask, cfg_val, id_reg_sys_val;
+	struct id_reg_info id_reg_data;
+	struct feature_config_ctrl *config, config0, config1, config2;
+	struct feature_config_ctrl *trap_features[] = {
+		&config0, &config1, &config2, NULL,
+	};
+
+	vcpu = test_kvm_vcpu_init(test);
+	KUNIT_EXPECT_TRUE(test, vcpu);
+	if (!vcpu)
+		return;
+
+	id_reg_sys_val = 0x7777777777777777;
+	id = SYS_ID_AA64DFR0_EL1;
+	id_reg_data.sys_reg = id;
+	id_reg_data.sys_val = id_reg_sys_val;
+	id_reg_data.vcpu_limit_val  = (u64)-1;
+	id_reg_data.trap_features =
+			(const struct feature_config_ctrl *(*)[])trap_features;
+
+	cfg_mask0 = 0x3;
+	cfg_val0 = 0x3;
+	config = &config0;
+	memset(config, 0, sizeof(*config));
+	config->ftr_reg = id;
+	config->ftr_shift = 60;
+	config->ftr_min = 2;
+	config->ftr_signed = FTR_UNSIGNED;
+	config->cfg_reg = VCPU_HCR_EL2;
+	config->cfg_mask = cfg_mask0;
+	config->cfg_val = cfg_val0;
+
+	cfg_mask1 = 0x70000040;
+	cfg_val1 = 0x30000040;
+	config = &config1;
+	memset(config, 0, sizeof(*config));
+	config->ftr_reg = id;
+	config->ftr_need_trap = test_need_trap_aa64dfr0;
+	config->ftr_signed = FTR_UNSIGNED;
+	config->cfg_reg = VCPU_HCR_EL2;
+	config->cfg_mask = cfg_mask1;
+	config->cfg_val = cfg_val1;
+
+	/* Feature with signed ID register field */
+	cfg_mask2 = 0x70000000800;
+	cfg_val2 = 0x30000000800;
+	config = &config2;
+	memset(config, 0, sizeof(*config));
+	config->ftr_reg = id;
+	config->ftr_shift = 4;
+	config->ftr_min = 0;
+	config->ftr_signed = FTR_SIGNED;
+	config->cfg_reg = VCPU_HCR_EL2;
+	config->cfg_mask = cfg_mask2;
+	config->cfg_val = cfg_val2;
+
+	/* Enable features for config0, 1 and 2 */
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = id_reg_sys_val;
+
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2, 0);
+
+	/* Disable features for config0 only */
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x1;
+	cfg_mask = cfg_mask0;
+	cfg_val = cfg_val0;
+
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_mask, cfg_val);
+
+	/* Disable features for config0 and config1 */
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x0;
+	cfg_mask = (cfg_mask0 | cfg_mask1);
+	cfg_val = (cfg_val0 | cfg_val1);
+
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_mask, cfg_val);
+
+	/* Disable features for config0, 1, and 2 */
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0xf0;
+	cfg_mask = (cfg_mask0 | cfg_mask1 | cfg_mask2);
+	cfg_val = (cfg_val0 | cfg_val1 | cfg_val2);
+
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_mask, cfg_val);
+
+	/* Test with id_reg_info == NULL */
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, NULL);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2, 0);
+
+	/* Test with id_reg_data.trap_features = NULL */
+	id_reg_data.trap_features = NULL;
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0xf0;
+
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2, 0);
+
+	test_kvm_vcpu_fini(test, vcpu);
+}
+
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
+		__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x0;
+		KUNIT_EXPECT_TRUE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPI = 1, API = 1 */
+		__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x10000100;
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPI = 1, APA = 1 */
+		__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x10000010;
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPA = 1, API = 1 */
+		__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x01000100;
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPA = 1, APA = 1 */
+		__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x01000010;
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+	} else {
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+	}
+
+	test_kvm_vcpu_fini(test, vcpu);
+}
+
 static struct kunit_case kvm_sys_regs_test_cases[] = {
 	KUNIT_CASE_PARAM(arm64_check_feature_one_test, feature_one_gen_params),
 	KUNIT_CASE_PARAM(arm64_check_features_test, features_gen_params),
@@ -859,6 +1094,9 @@ static struct kunit_case kvm_sys_regs_test_cases[] = {
 	KUNIT_CASE(validate_id_aa64dfr0_el1_test),
 	KUNIT_CASE(validate_id_dfr0_el1_test),
 	KUNIT_CASE(validate_mvfr1_el1_test),
+	KUNIT_CASE(vcpu_need_trap_ptrauth_test),
+	KUNIT_CASE(feature_trap_activate_test),
+	KUNIT_CASE(id_reg_features_trap_activate_test),
 	{}
 };
 
-- 
2.34.0.rc1.387.gb447b232ab-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B3C4D5A13
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241275AbiCKEup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346457AbiCKEuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:50:19 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8AA1AAFE0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:49:09 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id c70-20020a624e49000000b004f69bac03d0so4519975pfb.13
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7z5Uw2gRXSzvSWZCDvr7dARcE7XtDS3gb33aMNuIZp0=;
        b=LgvVZuqBFOS0jJKhiMC7n9409cSkdsgPrFen1ZDgAcy8XvbK5y7SuNyF2yj99Gs50X
         8ctQndJnSgLFIAP995LFH9A9CyErl47PF5oJfFOu37jmWeQMiZlViWMsQEMouVLx2FId
         uw+L8ae+yJG3jRPydLz99/TREejGMtYarMr2/rXAq8Tn5lS+SPhVzfCJotveG3TIQZiQ
         DNxTGJan0vG2MDqBnZuRXt5+Wgx/DkcsUZfeBOe9WM466Bhc6ShUyRX9yyMHE0vpZlP+
         hIit8D51RNTa1Bc+lf1P3YK4GXsm1D6MV0qYFKb+lJ2vdpvDXYmqaRka0xVr+4UriKpe
         d/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7z5Uw2gRXSzvSWZCDvr7dARcE7XtDS3gb33aMNuIZp0=;
        b=2MrfGGZw4ZigG81lRRf3tCt444p/euQEiIDR7NyHDP5J8Ma9PKHloYHWi7nhFuzL/n
         n8oEYzwUQoTz65yocNUb7ARsweflm9Vh/BZtCrQQkx04K91b7Q0w4EEEn02XEZ0wDGs1
         dffwOhGn9t2ux5IXx1eDsADCJMcu4v8pUDaF8MSJljpJUQG9GMAOoCf92hu3vljHJ4k5
         DVlmwAl8ffr1RnUCCSxlUEsipjLVouLAEO3ZvxzHRLMHXyHUTYNKWHdlwMgHCa+fQCN6
         yaLu5EjRrWAyuE4q2wgsYNFeA13QYO+CXoD1fe7639I3LzaI5CuKN6RNuiGSrpbGNElv
         kGxw==
X-Gm-Message-State: AOAM532iuZvzY3b9AHzoT6TfNI78c7VNtRFpftWjbvVf/M6qGoaPjP2w
        w1cE9ADsEoKBTk1IsfGwDTgFij6zNpw=
X-Google-Smtp-Source: ABdhPJw61zM8eXq9A5LGOH7Lc1dcnB3i8F9/nsnO0WTPLudzhQ0Ew+bphYaAwCUfdiwvwCU4sgAbzOAPE+w=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:228b:b0:4f7:9155:b685 with SMTP id
 f11-20020a056a00228b00b004f79155b685mr208604pfe.61.1646974149257; Thu, 10 Mar
 2022 20:49:09 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:48:09 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-24-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 23/25] KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
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

Add feature_config_ctrl for PTRAUTH, which is indicated in
ID_AA64ISAR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f3661881cbed..881e8879a48b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -284,6 +284,30 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+/*
+ * Return true if ptrauth needs to be trapped.
+ * (i.e. if ptrauth is supported on the host but not exposed to the guest)
+ */
+static bool vcpu_need_trap_ptrauth(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+	bool generic, address;
+
+	if (!system_has_full_ptr_auth())
+		/* The feature is not supported. */
+		return false;
+
+	val = read_id_reg_with_encoding(vcpu, SYS_ID_AA64ISAR1_EL1);
+	generic = aa64isar1_has_gpi(val) || aa64isar1_has_gpa(val);
+	address = aa64isar1_has_api(val) || aa64isar1_has_apa(val);
+	if (generic && address)
+		/* The feature is available. */
+		return false;
+
+	/* The feature is supported but hidden. */
+	return true;
+}
+
 /*
  * Feature information to program configuration register to trap or disable
  * guest's using a feature when the feature is not exposed to the guest.
@@ -379,6 +403,11 @@ static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TLOR, 0);
 }
 
+static void feature_ptrauth_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, 0, HCR_API | HCR_APK);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -447,6 +476,12 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.trap_activate = feature_lor_trap_activate,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.trap_activate = feature_ptrauth_trap_activate,
+};
+
 /* id_reg_desc flags field values */
 #define ID_DESC_REG_UNALLOC	(1UL << 0)
 #define ID_DESC_REG_HIDDEN	(1UL << 1)
@@ -3782,6 +3817,10 @@ static struct id_reg_desc id_aa64isar1_el1_desc = {
 	.init = init_id_aa64isar1_el1_desc,
 	.validate = validate_id_aa64isar1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64isar1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ptrauth,
+		NULL,
+	},
 };
 
 static struct id_reg_desc id_aa64mmfr0_el1_desc = {
-- 
2.35.1.723.g4982287a31-goog


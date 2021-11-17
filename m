Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4A6454170
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbhKQG4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbhKQG4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:50 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651C4C061206
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:50 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id z5-20020a631905000000b002e79413f1caso718139pgl.8
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=l9cL+44fLGdDyYUFjHlYq+dL32isCwZtQcuWO6mBjWA=;
        b=o36k6i54cI44CkxNoyng06/1cnBbAHYmtiCr8v2I/KDJLlWFA9DKoh2o8QlHJ4ioDR
         ZBxEhJYYuxUj3CTLSPaVa+LdwzJtLW5vmimI7ZyOL/v2EdkMBv8s7Zb8aNQg1qDNc1Ji
         0DxExQLqbrEaTySPkb4iHM10iwaD6drKdifBiW/5Im3Zz2e/K9hPnXG1khJlse+zcZfe
         e1gO5CpHsd0NA0rBCs8UNOzB5v4100BqKNd+PqC7I11geGCXteo1kcbBCX3QdXqmulGu
         Uet1f3rbkcNvy1NTGYTYO05MVb+WFisTpVESqHDn9yTzGcCfcX+q2hF+HlQKq8DvKfbW
         rToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l9cL+44fLGdDyYUFjHlYq+dL32isCwZtQcuWO6mBjWA=;
        b=hyTnUANKrk1YEBLzaehGsYmkL7agstakPfgm4t06NZq6n6X+T0r7IoO0RL/AR1HhV6
         LSpis4x6cEiubedCjTwdjwpArlZIkMNcGYMAfSxmTxQbXVSmvLoni5o6vEiJc5bOJnFv
         KpO4gAK6TsBUkcopDNU4uDR5gU3PZ8J52hD/zsppVtT1iaPB/yVmI3ucFyiG5Xlviv2E
         wwaoWmZnXyF5gf583du2Ww45LmyercPrGcvXXwsighS/sdtb9g9YtjrchF2GYPEUwfhj
         o3T5EXXkZK3AuwL8olNRFk/qFd5kgq5QMjZmeHfFMW65q7H5mRGfFOQbDpJlacrt3Sax
         m3jQ==
X-Gm-Message-State: AOAM532NgviNuVm4lzQFDKa0yshVVLD5TvPhQaKvs/xu5obPszMYs+Id
        0SYxyv18aIx0HDfU2910G6bBHodCuu0=
X-Google-Smtp-Source: ABdhPJx9DDeQMUXc6095SOTfgNA0s7/GlZiDRs9vbKaSt1H48YgTnr7zDO2ifTxH2Q2Olse8b10fDPjrRfI=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:df97:: with SMTP id
 p23mr6831251pjv.3.1637132029846; Tue, 16 Nov 2021 22:53:49 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:56 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-27-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 26/29] KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
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

Add feature_config_ctrl for PTRAUTH, which is indicated in
ID_AA64ISAR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3d3b29515b8b..f1f975ce7b07 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -376,6 +376,30 @@ static int arm64_check_features(u64 check_types, u64 val, u64 lim)
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
+	val = __read_id_reg(vcpu, SYS_ID_AA64ISAR1_EL1);
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
 enum vcpu_config_reg {
 	VCPU_HCR_EL2 = 1,
 	VCPU_MDCR_EL2,
@@ -480,6 +504,14 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.cfg_val = HCR_TLOR,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = (HCR_API | HCR_APK),
+	.cfg_val = 0,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -977,6 +1009,10 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 	.init = init_id_aa64isar1_el1_info,
 	.validate = validate_id_aa64isar1_el1,
 	.get_reset_val = get_reset_id_aa64isar1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ptrauth,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64mmfr0_el1_info = {
-- 
2.34.0.rc1.387.gb447b232ab-goog


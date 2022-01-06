Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB2A485FBD
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiAFE2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiAFE2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:28:49 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666FAC061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:28:49 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p4-20020a17090a348400b001b103a13f69so3984490pjb.8
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dNkIY86roqvUs5KX8m9clWmkcxYrW6AP5WIcgyGoEyo=;
        b=Nzz+VxZf/lB+zPH+PqKajDHFdhn1JdeZEJzsLwwupGArmVBXhQe8QQ6qGhWt75yn9t
         9co4L/J1Cpeuu7gKqT324yGMZT4umFYWyo0isuQcHr5O4v9gzUFT3O4qItVmPBTL7EIW
         fFYSl2PSQWPoAz7jUX0y1q2OA3cOXIAl11SzYbaF1wlewoIEqaouLdYkAEbdnfafS6+3
         oWTziBOVd1zgc7moWOkVZlqhU+qy2foHjOB6xa+G6PnKXNLPufGgtngqcFKWTH0XvIVz
         ZZZxGOqCGZfn/WVwYWEyOqqyk+6bFUudMia2RSJq/RZb1brUNXzAPfGMXdCKJA3JGyk9
         j+0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dNkIY86roqvUs5KX8m9clWmkcxYrW6AP5WIcgyGoEyo=;
        b=JqlsySRjT/Dns10ifO5p4OJMvK1kIMb2vT8vztrxlzqfxroKlE82alm3tmwZBzUi1T
         wOpzsZjqMSTvJCEAEhMRkgoor0tX5W9JYLazt3uXXaKN6EyP7dCclB80ovUsFq4aPypL
         /kfQA9P2r4RzlvJSW0RJ22CRZQgQSKxtK0jUFVPZb1QlgX4C4C4m7jvFwIiBXdzCCjyR
         Aq7F7qg7XVnlOzt7e79j5bB3cVHYm2A2N7sOE+FcsxkMr3R/NXJ2o+p3cn1cFGpLFvOT
         JATgiYVC1Zxrd/aaXizjEgJcdqFU2mNWJl2MCGwyydG0Ptqcp2t9PjI1pDiX1pNjU46B
         LQ/Q==
X-Gm-Message-State: AOAM531LEhIagH3/A9w9vhb5euLYDXkN+zyQj23ebPMPd/uAH2FiWbmG
        eEJNmkv33mZDeJKGPfxmkTgtd2EmU4w=
X-Google-Smtp-Source: ABdhPJx6ej0/VULi52k2Cisyjwi/BQ1mJqWpnqSt57jvJErT5sSc3j4wqzqGEgzikXKJrB0iKnva8GTQ0Ws=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:5d8d:: with SMTP id
 t13mr7987455pji.47.1641443328938; Wed, 05 Jan 2022 20:28:48 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:26:54 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-13-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 12/26] KVM: arm64: Make MVFR1_EL1 writable
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

This patch adds id_reg_info for MVFR1_EL1 to make it writable
by userspace.

There are only a few valid combinations of values that can be set
for FPHP and SIMDHP fields according to Arm ARM.  Return an error
when userspace tries to set those fields to values that don't match
any of the valid combinations.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1707c7832593..1c18a19c5785 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -617,6 +617,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_mvfr1_el1(struct kvm_vcpu *vcpu,
+			      const struct id_reg_info *id_reg, u64 val)
+{
+	unsigned int fphp, simdhp;
+	struct fphp_simdhp {
+		unsigned int fphp;
+		unsigned int simdhp;
+	};
+	/* Permitted fphp/simdhp value combinations according to Arm ARM */
+	struct fphp_simdhp valid_fphp_simdhp[3] = {{0, 0}, {2, 1}, {3, 2}};
+	int i;
+	bool is_valid_fphp_simdhp = false;
+
+	fphp = cpuid_feature_extract_unsigned_field(val, MVFR1_FPHP_SHIFT);
+	simdhp = cpuid_feature_extract_unsigned_field(val, MVFR1_SIMDHP_SHIFT);
+
+	for (i = 0; i < ARRAY_SIZE(valid_fphp_simdhp); i++) {
+		if (valid_fphp_simdhp[i].fphp == fphp &&
+		    valid_fphp_simdhp[i].simdhp == simdhp) {
+			is_valid_fphp_simdhp = true;
+			break;
+		}
+	}
+
+	if (!is_valid_fphp_simdhp)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -774,6 +804,11 @@ static struct id_reg_info id_dfr0_el1_info = {
 	.vcpu_mask = vcpu_mask_id_dfr0_el1,
 };
 
+static struct id_reg_info mvfr1_el1_info = {
+	.sys_reg = SYS_MVFR1_EL1,
+	.validate = validate_mvfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -784,6 +819,7 @@ static struct id_reg_info id_dfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_MVFR1_EL1)] = &mvfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
-- 
2.34.1.448.ga2b2bfdf31-goog


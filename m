Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C57F4D5A12
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346518AbiCKEue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346231AbiCKEt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:49:59 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A36DE86B6
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:45 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id q9-20020a17090a7a8900b001bf0a7d9dfdso4617882pjf.4
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BC/RhHZyQh20zJ4o/L/jR6ipTx5n23zl8pNE5Kswitk=;
        b=lI34I92LM8QIflRlzMT6EfFDAy+1YBmg8eJPRcNsFzEaEHoumYH1WYQw3kZilJENyE
         dtWeXXFAxTSqdv6eyxMvE18sw4WTaQ4u+k27UeLSOvKMERLk3ZLePx+v277Oe1qsJXYQ
         7+uAAFCSeWx6QKH9g83hOq1SvSKcgRbGcq+cZzbbNje8nDQc0SGt6qhcF52YSZrY76dS
         oi01m32m6XMrD5Z0yPlgmWJaII/TA04eC2vsOcXCvc0/uM7A56Rcu5U1W6D9UZhCWCEp
         K2ezwCf1YL3aXhgj4GAumNh4az0xH1pC2aP5o1bDxEB3KWvsPJGWIIPIqiwg/kM5BNDZ
         IlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BC/RhHZyQh20zJ4o/L/jR6ipTx5n23zl8pNE5Kswitk=;
        b=lSKTn4+0fcwOR6VvEuuzPpgHQWSMYTEj8w1aW6h9S5dSOTN45BX8LbnBs/rha7xV1n
         dGWcMWjcPuh6jyTqTGd9JBDFNDJu2zfsTo7yxX37ktjz5oRpGShS0gw9AMI3rw5mXHkc
         1w6faFJpGE4kfl7DjhBzB4zb1ONxuAEj+jWPqKrLzHlbyUCUQ2SRBEP3UUR7xy2LfXNG
         m9P0UnNlCG+roMpw5XHBeAjIilp6w8YeVB6x9p131zvb8K47XVySdY9v+Y9O6l18KliU
         EUU4WsnjkvI+t5hF30lgupQSX8DJW5UMaXVnXUFKLgEcdUdRo/Ghycpr/JttnFOW9adW
         DIzw==
X-Gm-Message-State: AOAM532s81yye52n5Lr6afS5L3vyb5DKeDmuqFjuVXjtAiZj9VZRVqPn
        w+3chYHgSYIWwkwerggnUM4unPXkXZQ=
X-Google-Smtp-Source: ABdhPJy7JXTk0HnRt/o3W8puG08ezjtccoA9tPMKC2datbpeXgEETraGwWU0YIdJv6KUiq8OPkEUw6kaylo=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:7246:b0:151:49e7:d4fc with SMTP id
 c6-20020a170902724600b0015149e7d4fcmr8872189pll.88.1646974124662; Thu, 10 Mar
 2022 20:48:44 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:47:54 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-9-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 08/25] KVM: arm64: Make ID_AA64MMFR0_EL1 writable
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

This patch adds id_reg_desc for ID_AA64MMFR0_EL1 to make it
writable by userspace.

Since ID_AA64MMFR0_EL1 stage 2 granule size fields don't follow the
standard ID scheme, we need a special handling to validate those fields.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 129 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 33b4918109b7..ad23361d3a3b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -460,6 +460,118 @@ static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*
+ * Check if the requested stage2 translation granule size indicated in
+ * @mmfr0 is also indicated in @mmfr0_lim.
+ * If TGranX_2 field is zero, the value must be validated based on TGranX
+ * field because that indicates the feature support is identified in
+ * TGranX field.
+ * This function relies on the fact TGranX fields are validated before
+ * through arm64_check_features_kvm.
+ */
+static int aa64mmfr0_tgran2_check(int field, u64 mmfr0, u64 mmfr0_lim)
+{
+	s64 tgran2, lim_tgran2, rtgran1;
+	int f1;
+	bool is_signed;
+
+	tgran2 = cpuid_feature_extract_unsigned_field(mmfr0, field);
+	lim_tgran2 = cpuid_feature_extract_unsigned_field(mmfr0_lim, field);
+	if (tgran2 && lim_tgran2)
+		/*
+		 * We don't need to check TGranX field. We can simply
+		 * compare tgran2 and lim_tgran2.
+		 */
+		return (tgran2 > lim_tgran2) ? -E2BIG : 0;
+
+	if (tgran2 == lim_tgran2)
+		/*
+		 * Both of them are zero.  Since TGranX in @mmfr0 is already
+		 * validated by arm64_check_features_kvm, tgran2 must be fine.
+		 */
+		return 0;
+
+	/*
+	 * Either tgran2 or lim_tgran2 is zero.
+	 * Need stage1 granule size to validate tgran2.
+	 */
+
+	/*
+	 * Get TGranX's bit position by subtracting 12 from TGranX_2's bit
+	 * position.
+	 */
+	f1 = field - 12;
+
+	/* TGran4/TGran64 is signed and TGran16 is unsigned field. */
+	is_signed = (f1 == ID_AA64MMFR0_TGRAN16_SHIFT) ? false : true;
+
+	/*
+	 * If tgran2 == 0 (&& lim_tgran2 != 0), the requested stage2 granule
+	 * size is indicated in the stage1 granule size field of @mmfr0.
+	 * So, validate the stage1 granule size against the stage2 limit
+	 * granule size.
+	 * If lim_tgran2 == 0 (&& tgran2 != 0), the stage2 limit granule size
+	 * is indicated in the stage1 granule size field of @mmfr0_lim.
+	 * So, validate the requested stage2 granule size against the stage1
+	 * limit granule size.
+	 */
+
+	 /* Get the relevant stage1 granule size to validate tgran2 */
+	if (tgran2 == 0)
+		/* The requested stage1 granule size */
+		rtgran1 = cpuid_feature_extract_field(mmfr0, f1, is_signed);
+	else /* lim_tgran2 == 0 */
+		/* The stage1 limit granule size */
+		rtgran1 = cpuid_feature_extract_field(mmfr0_lim, f1, is_signed);
+
+	/*
+	 * Adjust the value of rtgran1 to compare with stage2 granule size,
+	 * which indicates: 1: Not supported, 2: Supported, etc.
+	 */
+	if (is_signed)
+		/* For signed, -1: Not supported, 0: Supported, etc. */
+		rtgran1 += 0x2;
+	else
+		/* For unsigned, 0: Not supported, 1: Supported, etc. */
+		rtgran1 += 0x1;
+
+	if ((tgran2 == 0) && (rtgran1 > lim_tgran2))
+		/*
+		 * The requested stage1 granule size (== the requested stage2
+		 * granule size) is larger than the stage2 limit granule size.
+		 */
+		return -E2BIG;
+	else if ((lim_tgran2 == 0) && (tgran2 > rtgran1))
+		/*
+		 * The requested stage2 granule size is larger than the stage1
+		 * limit granulze size (== the stage2 limit granule size).
+		 */
+		return -E2BIG;
+
+	return 0;
+}
+
+static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_desc *id_reg, u64 val)
+{
+	u64 limit = id_reg->vcpu_limit_val;
+	int ret;
+
+	ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN4_2_SHIFT, val, limit);
+	if (ret)
+		return ret;
+
+	ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN64_2_SHIFT, val, limit);
+	if (ret)
+		return ret;
+
+	ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN16_2_SHIFT, val, limit);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -3255,6 +3367,20 @@ static struct id_reg_desc id_aa64isar1_el1_desc = {
 	.vcpu_mask = vcpu_mask_id_aa64isar1_el1,
 };
 
+static struct id_reg_desc id_aa64mmfr0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64MMFR0_EL1),
+	/*
+	 * When TGranX_2 value is 0, validity of the value depend on TGranX
+	 * value, and TGranX_2 value must be validated against TGranX value,
+	 * which is done by validate_id_aa64mmfr0_el1.
+	 * So, skip the regular validity checking for TGranX_2 fields.
+	 */
+	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4_2) |
+		       ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64_2) |
+		       ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN16_2),
+	.validate = validate_id_aa64mmfr0_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3267,6 +3393,9 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=6 */
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
+
+	/* CRm=7 */
+	ID_DESC(ID_AA64MMFR0_EL1, &id_aa64mmfr0_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.35.1.723.g4982287a31-goog


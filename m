Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76536506500
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349072AbiDSHAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349063AbiDSHAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:08 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F10B3191D
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:24 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id f8-20020a170902ce8800b00158ed29a480so4010759plg.1
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5GFeg0Qhkqt0F/Jtoeb93WWvQllcpb+IlKZnd70ZJik=;
        b=Fv4yxIMKsOfPGl1VWc42zdtocbfbfZISNCLx3NGwULK0h1JKlUIWpfnlR/UL/RRMyA
         eKMYR3vCEvPzuoFW6dKiSVM7mNuCTj58732pG3PZ8cRx/V/jpgNu+AzLyMznTWkU7AYm
         XEbug58FYBe7rIGRKQkJPaCRjF6EBPjlknVNwBqVFn/SJT1P9Opmpy/2CQpay9I+WDBe
         hZwitU1DkclcjVe3OR1Fg1KMkZ5GPGfwYoC4VNzLLHXq+DhNlaG572W/i2tRZU+M/i+i
         Wp5xaAMVEBc0q1E5xZnp3K5MrJ62+uiDQ2cSm3mL+VFCJUUn4k8M7XbGWaLgDE7OWKPp
         ttBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5GFeg0Qhkqt0F/Jtoeb93WWvQllcpb+IlKZnd70ZJik=;
        b=docKCM3lbxZPoH7/DnUvMJOTvhmyzH6kBStELpPmkKi5hY5r1JDrd5aWIepY9r2a7R
         JyuwF4bFkvOaR2Hyz0Ka7MYObA6tb+0VU3pM+UWVe4J0VvpR2gNDZmlbnFhdcf+74tSS
         YhuDLA6uR9p5IJ4SojJb8oHuZNjWyGQkr9aovsMP8lab1RFo0t+YDGqBV7pVt4TbenyS
         YV9qxwe8jLksUVK2Gddsar4EJ7DQoJw4Y6Ch8q9IwvaVnsOylBwib2xA7Z6e+O1+yBTy
         lEBcekpiKD8S46ZDu3wT/DSUr8vDwIaD8JWWQV2xmfFFfLOA+tfiQqPjKZVfR5w59hfK
         j+iw==
X-Gm-Message-State: AOAM531DT52CXCDcx4tyhcH+nnBpWT4A2Fk084sWRtmzNsz8TQxFgPyJ
        oNNVcG8hmtqibenA6bgccy63qBEF+mI=
X-Google-Smtp-Source: ABdhPJxWTrb+BY8xwpwyXUFdaoymj4StHXGAR+lBoWQZOnAwK6U8eNBK6/ve0byeXMAGA0OzQxHDtDdAAhc=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:9696:b0:158:f809:310e with SMTP id
 n22-20020a170902969600b00158f809310emr9827150plp.16.1650351443506; Mon, 18
 Apr 2022 23:57:23 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:17 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-12-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 11/38] KVM: arm64: Make ID_AA64MMFR0_EL1 writable
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
 arch/arm64/kvm/sys_regs.c | 133 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ba2e6dac7774..b68ae53af792 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -542,6 +542,118 @@ static int validate_id_aa64isar2_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*
+ * Check if the requested stage2 translation granule size indicated in
+ * @mmfr0 is also indicated in @mmfr0_lim.
+ * If TGranX_2 field is zero, the value must be validated based on TGranX
+ * field because that indicates the feature support is identified in
+ * TGranX field.
+ * This function relies on the fact TGranX fields are validated before
+ * through arm64_check_features.
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
+		 * validated by arm64_check_features, tgran2 must be fine.
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
@@ -3413,6 +3525,24 @@ static struct id_reg_desc id_aa64isar2_el1_desc = {
 	},
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
+	.ftr_bits = {
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN64_SHIFT, ID_AA64MMFR0_TGRAN64_NI),
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN4_SHIFT, ID_AA64MMFR0_TGRAN4_NI),
+	},
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3426,6 +3556,9 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
 	ID_DESC(ID_AA64ISAR2_EL1, &id_aa64isar2_el1_desc),
+
+	/* CRm=7 */
+	ID_DESC(ID_AA64MMFR0_EL1, &id_aa64mmfr0_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.36.0.rc0.470.gd361397f0d-goog


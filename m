Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87935064F7
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349061AbiDSHAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349033AbiDSG77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 02:59:59 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B5A27B2C
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:17 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id pb1-20020a17090b3c0100b001d2b09b6185so1043997pjb.2
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a16GM35sjxxlQKcTXUheYgNf0O4Bz0BcVFGp05uoS+A=;
        b=hmBUOWaE1NnSP7Cp16j43pFlkvvZ9H4KmuU1Ra0gR7gHPnKNVuuN/naQee0HGOq3wQ
         fhToaMAKA8werNfqWNDm4scTHg+CXLxsNd0bPmtIZ98ylO0egYYaGed8n9RV3b6YVnU8
         TA1nq43ZdqjtTkTT14ylfDZnTljfxNpKCsQr0Jyp5JLqiRNk7vu05YSVXfl8heWvEEcD
         kyG8xu2676waxirA3V03XO3j1Y8yrruZKhgqfd9LDVUI0Jg2Py76OhPlrZymt9GC87n0
         0yLCnkD4UUjAaRUW2fH/FO9u9C3Qozv9NXoUc/5gwc8WpGf//tZLbjmUWuDttbWDIge0
         75/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a16GM35sjxxlQKcTXUheYgNf0O4Bz0BcVFGp05uoS+A=;
        b=S3eJI3C5QuqWayoKxnBfasa0AH1/WNCIJv+4AIV7VrXcO8N/skuPjqj+2wPf8Wc+Fq
         gNEnjEES1ldzUEQBj/gMwcwbPAE2jv+BF4VoC4MUVNmPfttrtGpUQUZsr/W2HceiYKU8
         1eA0j628uCWu30+ZCOZfOwm/fu5JCk7Gq23sE6tgYkyTxzVxwyRcuWjD1QngmyH7qItv
         vN+/zyXmDogJg8TmWfxbWVgDSdGeDnEsbwf+gl4YPgMzrOrCUi0noy0GrZsET4ly8lOF
         MLSb4gHArOYfuBNRh0vsHQFWorXpitl3jIPbKkxEujt3hnkqAL/Ab1i7lcb/+yGF6Mxb
         rtDA==
X-Gm-Message-State: AOAM532LCYxhEVsj9h5McNtKzETM+lgDLY+qVBWaG7jZqMeiMy7O/Rr/
        mktfacS03X9mKNOtQu9xj2IgQDn4dXg=
X-Google-Smtp-Source: ABdhPJwSDKGRLdk5m+uU0CnsYnVPDSIqAFVbJcSmiEhdttrrb/Xm7zdvkXFnaC/AVP85cyC6XCAbFW3dIa0=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:808:b0:50a:870d:6c8c with SMTP id
 m8-20020a056a00080800b0050a870d6c8cmr5634521pfk.76.1650351437207; Mon, 18 Apr
 2022 23:57:17 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:13 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-8-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 07/38] KVM: arm64: Make ID_AA64PFR1_EL1 writable
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

This patch adds id_reg_desc for ID_AA64PFR1_EL1 to make it writable
by userspace.

Return an error if userspace tries to set MTE field of the register
to a value that conflicts with KVM_CAP_ARM_MTE configuration for
the guest.
Skip fractional feature fields validation at present and they will
be handled by the following patches.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 arch/arm64/kvm/sys_regs.c       | 42 +++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 3adb402fab86..b33b7ce87fb2 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -837,6 +837,7 @@
 #define ID_AA64PFR0_GIC3		0x1
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
 #define ID_AA64PFR1_RASFRAC_SHIFT	12
 #define ID_AA64PFR1_MTE_SHIFT		8
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 67a0604fe6f1..c3537cd4fe58 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -410,6 +410,21 @@ static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_desc *id_reg, u64 val)
+{
+	bool kvm_mte = kvm_has_mte(vcpu->kvm);
+	unsigned int mte;
+
+	mte = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR1_MTE_SHIFT);
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT. */
+	if (kvm_mte ^ (mte > 0))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -441,12 +456,24 @@ static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_aa64pfr1_el1_desc(struct id_reg_desc *id_reg)
+{
+	if (!system_supports_mte())
+		id_reg->vcpu_limit_val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
+}
+
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
 					 const struct id_reg_desc *idr)
 {
 	return vcpu_has_sve(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
 }
 
+static u64 vcpu_mask_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu,
+					 const struct id_reg_desc *idr)
+{
+	return kvm_has_mte(vcpu->kvm) ? 0 : (ARM64_FEATURE_MASK(ID_AA64PFR1_MTE));
+}
+
 static int validate_id_reg(struct kvm_vcpu *vcpu,
 			   const struct id_reg_desc *id_reg, u64 val)
 {
@@ -1423,10 +1450,6 @@ static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 
 	val = read_kvm_id_reg(vcpu->kvm, id);
 	switch (id) {
-	case SYS_ID_AA64PFR1_EL1:
-		if (!kvm_has_mte(vcpu->kvm))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
@@ -3223,6 +3246,16 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 	}
 };
 
+static struct id_reg_desc id_aa64pfr1_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64PFR1_EL1),
+	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
+		       ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
+		       ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
+	.init = init_id_aa64pfr1_el1_desc,
+	.validate = validate_id_aa64pfr1_el1,
+	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3230,6 +3263,7 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
+	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.36.0.rc0.470.gd361397f0d-goog


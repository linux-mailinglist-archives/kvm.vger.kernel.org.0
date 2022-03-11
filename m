Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF78C4D5A17
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346484AbiCKEuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346454AbiCKEts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:49:48 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316E81AC287
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:40 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d13-20020a170902b70d00b0015317d9f08bso2606450pls.1
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uBoyKzZk3Qtv9aZ00wbOXF/ba3q4Fu49o+9bq2Th1Ww=;
        b=WaOEzQ3J63TTZvIp5H/lnZK5BcWK/0Md7Gxah9ozJWTjDdZZC9UvfdGXYgP9LilqU+
         sGSsV8EwJD/Ug/h0cTRJGvN5EVdPxOfsDaM8dgkcFQgh7GUeQPrPuRXPfGZnswqjU9m1
         o1aNriRRHMPgy57Zbt1IjI9BeXj+A7Zks11gx9CDeya7BSM1y2OljGQgFMP+jYUajo4z
         jfHlLPscsINpYKG94NQSEfftScLI6kNjHMPt5RzTcza0jhZaoHOSstIAnzTEcGfIm5C8
         fxw014HKohpMkivmaWj3BFqjDArfo3Ei2h4NN+Bh31LZo7Wkkjgj2wZ0rKcuzVoHHhw8
         JO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uBoyKzZk3Qtv9aZ00wbOXF/ba3q4Fu49o+9bq2Th1Ww=;
        b=O5Kv7kIJR1zgkwuUt35PLC+ecErVYSotNnL3Tgkp2sFhpV5wpdfKeEmRzfVBUCFGBa
         WmY6veQKPWg0RlOr5sgHgABZgz1q69bS4BLXzp581JTSkpGkH5/h6ZJ4O61SOmexRDO4
         kpNsU6b1gnbfAX1lleaXIclPZeF4oYilS+6BZ5ZJnNpjaqLp6IxZBOI9RTnK7nHNyRVJ
         dHiLf7ezbxkZY/0qVjhjE/qilMhy8YL74KE+zO4IC6WtCxGmPEF5Ol9DCf6q1cPyyRlE
         XQuH10RTyg0EGb2E+9tqdRUqIeXcGOPieHe682iG2jG1AKSEgcdwr98sNx6jjAGv78Qb
         cAfA==
X-Gm-Message-State: AOAM533mp/cER28J39pyO2UlF1RyXxjWE5TCSAjfw4iXlBMx7HMMEYpk
        X1LKYbGXH9lmahKmY2F6V9i+6PeM+1Q=
X-Google-Smtp-Source: ABdhPJyOxSYFndroMYYb/thCoU6B1JaiKrgug4u+QvotKZqS7wBgDmUI8tVODpRPXtY1pGqD5AxfCVCODJs=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:e811:b0:151:f486:a32f with SMTP id
 u17-20020a170902e81100b00151f486a32fmr8570545plg.141.1646974119624; Thu, 10
 Mar 2022 20:48:39 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:47:51 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-6-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 05/25] KVM: arm64: Make ID_AA64PFR1_EL1 writable
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
index 84edc87f0005..249f1fdc1f59 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -816,6 +816,7 @@
 #define ID_AA64PFR0_GIC3		0x1
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
 #define ID_AA64PFR1_RASFRAC_SHIFT	12
 #define ID_AA64PFR1_MTE_SHIFT		8
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9e9fa90afb82..4294dbfd8fd4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -374,6 +374,21 @@ static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -405,12 +420,24 @@ static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
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
@@ -1344,10 +1371,6 @@ static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 
 	val = read_kvm_id_reg(vcpu->kvm, id);
 	switch (id) {
-	case SYS_ID_AA64PFR1_EL1:
-		if (!kvm_has_mte(vcpu->kvm))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
@@ -3134,6 +3157,16 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 	.vcpu_mask = vcpu_mask_id_aa64pfr0_el1,
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
 
@@ -3141,6 +3174,7 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
+	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.35.1.723.g4982287a31-goog


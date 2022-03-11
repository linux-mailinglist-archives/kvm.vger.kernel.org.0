Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6374D59FB
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346463AbiCKEuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346487AbiCKEuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:50:00 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2493B1AAFED
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:50 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id b1-20020a170902bd4100b00151f3f97b0cso3929832plx.5
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sBS0GPRrbiWgeVNZb+9UNH7PQVRywzH/+pUDODbMZ1g=;
        b=ENpayKBmfeMK+Uq+f7lTV/mKRuXOdPZr6mTDUvWd+uAPU+KZk0izLdEguLYuIuauLM
         N0WLJyDNbdzroBnPwDIbJSsVmV7p0FNDRujmdbz0kuz2j8Dk1Ch6rAe7jApHzRPecewZ
         /zkDyEZZMllmc3VuiLdVg1ge5BCnpZC7ODpi91HC2Msz23yqldvH9XYpnI9FqGVxDgEP
         jA/4LCoyfsavGVedZcFh6hWz/NUuYfyxNKy4kSxRbKmbIiT4FiLhwmH812Y2QdatN014
         JBPE8d0E4jZg3dAHRfEFOMda+Ip5JeEI4wmWALk7bTkpcQNd8bP6K8cNuXyhmXAyYuOw
         2BcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sBS0GPRrbiWgeVNZb+9UNH7PQVRywzH/+pUDODbMZ1g=;
        b=KfucKaKl9PWdN/BNpgxcjHDs5CjQXsmXtNImcoW5vrziVBVGwLmXUOsLJFSSHnt+jD
         PIEuVeDpE5YzEQ+ZuAC+TeqwyWlYuXfbuvPuRWnMnDUzxgh2rhIuzNLK/q87G8mT4qZ/
         SR2Wobqwski5CsWuS+uXS35sMA3NaKUc1pd7BdkBElKcStqfOPWJwj0Bj/cV1i6AJS01
         kGsP12KIKyo2jHelrzHUUzSWLl1q9KXRoDA5Gu4GS8TEZ8l3Vf0w74LN1G73XCqoHIDl
         48q870lcZmDzRHqLqXPjR3i0KFo6+nub5WfQ+W8eaTvDvjbydzDbNQXjoog/7By/o4GP
         wW5Q==
X-Gm-Message-State: AOAM531gJoRFd9pctdlbRcYt0I7wCv1cxXMUBJBk5WLReDtXjPEzQD84
        s2WW5ksKp+OzyEYgD0Yp9k8hzBBea34=
X-Google-Smtp-Source: ABdhPJwvo+MlpuYLsqLclXrIHZ70iMCXv6C4gJL27oO/w0gInxEG7NIHVVmbw30zKgrbMrTj7EgvpKtQd4E=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:350b:b0:1bf:c563:f0c7 with SMTP id
 ls11-20020a17090b350b00b001bfc563f0c7mr8762325pjb.157.1646974129584; Thu, 10
 Mar 2022 20:48:49 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:47:57 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-12-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to id_reg_desc_table
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

Add hidden or reserved ID registers, and remaining ID registers,
which don't require special handling, to id_reg_desc_table.
Add 'flags' field to id_reg_desc, which is used to indicates hiddden
or reserved registers. Since now id_reg_desc_init() is called even
for hidden/reserved registers, change it to not do anything for them.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 89 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 87 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 45d22b9e0d40..fe2a4de2b8f3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -284,6 +284,10 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+/* id_reg_desc flags field values */
+#define ID_DESC_REG_UNALLOC	(1UL << 0)
+#define ID_DESC_REG_HIDDEN	(1UL << 1)
+
 struct id_reg_desc {
 	const struct sys_reg_desc	reg_desc;
 
@@ -297,6 +301,9 @@ struct id_reg_desc {
 	/* Fields that are not validated by arm64_check_features_kvm. */
 	u64	ignore_mask;
 
+	/* Miscellaneous flags */
+	u64	flags;
+
 	/* An optional initialization function of the id_reg_desc */
 	void (*init)(struct id_reg_desc *id_reg);
 
@@ -333,8 +340,13 @@ struct id_reg_desc {
 static void id_reg_desc_init(struct id_reg_desc *id_reg)
 {
 	u32 id = reg_to_encoding(&id_reg->reg_desc);
-	u64 val = read_sanitised_ftr_reg(id);
+	u64 val;
+
+	if (id_reg->flags & (ID_DESC_REG_HIDDEN | ID_DESC_REG_UNALLOC))
+		/* Nothing to do for a hidden/unalloc ID register */
+		return;
 
+	val = read_sanitised_ftr_reg(id);
 	id_reg->vcpu_limit_val = val;
 	if (id_reg->init)
 		id_reg->init(id_reg);
@@ -3509,30 +3521,103 @@ static struct id_reg_desc mvfr1_el1_desc = {
 	.validate = validate_mvfr1_el1,
 };
 
+#define ID_DESC_DEFAULT(name)					\
+	[IDREG_IDX(SYS_##name)] = &(struct id_reg_desc) {	\
+		.reg_desc = ID_SANITISED(name),			\
+	}
+
+#define ID_DESC_HIDDEN(name)					\
+	[IDREG_IDX(SYS_##name)] = &(struct id_reg_desc) {	\
+		.reg_desc = ID_HIDDEN(name),			\
+		.flags = ID_DESC_REG_HIDDEN,			\
+	}
+
+#define ID_DESC_UNALLOC(crm, op2)				\
+	[crm << 3 | op2] = &(struct id_reg_desc) {		\
+		.reg_desc = ID_UNALLOCATED(crm, op2),		\
+		.flags = ID_DESC_REG_UNALLOC,			\
+	}
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
-/* A table for ID registers's information. */
+/*
+ * A table for ID registers's information.
+ * All entries in the table except ID_DESC_HIDDEN and ID_DESC_UNALLOC
+ * must have corresponding entries in arm64_ftr_regs[] in
+ * arch/arm64/kernel/cpufeature.c because read_sanitised_ftr_reg() is
+ * called for each of the ID registers.
+ */
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=1 */
+	ID_DESC_DEFAULT(ID_PFR0_EL1),
+	ID_DESC_DEFAULT(ID_PFR1_EL1),
 	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
+	ID_DESC_HIDDEN(ID_AFR0_EL1),
+	ID_DESC_DEFAULT(ID_MMFR0_EL1),
+	ID_DESC_DEFAULT(ID_MMFR1_EL1),
+	ID_DESC_DEFAULT(ID_MMFR2_EL1),
+	ID_DESC_DEFAULT(ID_MMFR3_EL1),
+
+	/* CRm=2 */
+	ID_DESC_DEFAULT(ID_ISAR0_EL1),
+	ID_DESC_DEFAULT(ID_ISAR1_EL1),
+	ID_DESC_DEFAULT(ID_ISAR2_EL1),
+	ID_DESC_DEFAULT(ID_ISAR3_EL1),
+	ID_DESC_DEFAULT(ID_ISAR4_EL1),
+	ID_DESC_DEFAULT(ID_ISAR5_EL1),
+	ID_DESC_DEFAULT(ID_MMFR4_EL1),
+	ID_DESC_DEFAULT(ID_ISAR6_EL1),
 
 	/* CRm=3 */
+	ID_DESC_DEFAULT(MVFR0_EL1),
 	ID_DESC(MVFR1_EL1, &mvfr1_el1_desc),
+	ID_DESC_DEFAULT(MVFR2_EL1),
+	ID_DESC_UNALLOC(3, 3),
+	ID_DESC_DEFAULT(ID_PFR2_EL1),
+	ID_DESC_HIDDEN(ID_DFR1_EL1),
+	ID_DESC_DEFAULT(ID_MMFR5_EL1),
+	ID_DESC_UNALLOC(3, 7),
 
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
+	ID_DESC_UNALLOC(4, 2),
+	ID_DESC_UNALLOC(4, 3),
+	ID_DESC_DEFAULT(ID_AA64ZFR0_EL1),
+	ID_DESC_UNALLOC(4, 5),
+	ID_DESC_UNALLOC(4, 6),
+	ID_DESC_UNALLOC(4, 7),
 
 	/* CRm=5 */
 	ID_DESC(ID_AA64DFR0_EL1, &id_aa64dfr0_el1_desc),
+	ID_DESC_DEFAULT(ID_AA64DFR1_EL1),
+	ID_DESC_UNALLOC(5, 2),
+	ID_DESC_UNALLOC(5, 3),
+	ID_DESC_HIDDEN(ID_AA64AFR0_EL1),
+	ID_DESC_HIDDEN(ID_AA64AFR1_EL1),
+	ID_DESC_UNALLOC(5, 6),
+	ID_DESC_UNALLOC(5, 7),
 
 	/* CRm=6 */
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
+	ID_DESC_DEFAULT(ID_AA64ISAR2_EL1),
+	ID_DESC_UNALLOC(6, 3),
+	ID_DESC_UNALLOC(6, 4),
+	ID_DESC_UNALLOC(6, 5),
+	ID_DESC_UNALLOC(6, 6),
+	ID_DESC_UNALLOC(6, 7),
 
 	/* CRm=7 */
 	ID_DESC(ID_AA64MMFR0_EL1, &id_aa64mmfr0_el1_desc),
+	ID_DESC_DEFAULT(ID_AA64MMFR1_EL1),
+	ID_DESC_DEFAULT(ID_AA64MMFR2_EL1),
+	ID_DESC_UNALLOC(7, 3),
+	ID_DESC_UNALLOC(7, 4),
+	ID_DESC_UNALLOC(7, 5),
+	ID_DESC_UNALLOC(7, 6),
+	ID_DESC_UNALLOC(7, 7),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.35.1.723.g4982287a31-goog


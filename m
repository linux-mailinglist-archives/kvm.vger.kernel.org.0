Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3FB5064FF
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349068AbiDSHAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349077AbiDSHAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:06 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE583056F
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:22 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i10-20020a1709026aca00b00158f14b4f2fso3811084plt.2
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4TCi+sJLW2uaem/+k27V6Nf+rQ0PhWYVioo5Q6rkdZk=;
        b=Hp9HgO/5PopUEK+kzy6sJa4PypL+kqEMbC0oXyjEuGS+tzp+ZuEBJ5KSrhSO+ILmk6
         y3AOpc1wZCpj2wIc6+I+hBwQ3UH842aJJThkW8WOBRZKQFE/jmRiW7GBjnOgjPi0I/Ja
         AlRFrV3q/j3YxsH9BMEAwDaIr+amb8gc2m4D1tyjC5WJMoZXm451ThezOj25kGVusGj8
         Ae2esA2cfwtvUAbyGmHBoQZ+mflUw46F4D9BrYFkYw9TPctz5VQJDQXghVxFQhXKEmcT
         vYiIHlopdqiMQCAx/nKa/mhAkBI+zDzW7XuUWrAOvDuoE3jerlVF3x+P9zxP8OTvDRxi
         cLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4TCi+sJLW2uaem/+k27V6Nf+rQ0PhWYVioo5Q6rkdZk=;
        b=WwDZS+N5yAywv9tuNW1P1s9Jyufujtr6/uWIlLSosBbhIvyAzDQO8qgqymjtMm/8Db
         eBdSkefeXj29432z8N0phY9ajsbO5CpE8MkUxgA3pZH6/mYF8T7Pd9hBgJSgoQDmgnP+
         vDe0zS/iR1sYEtsLSY1RT5MBRTKgeATP9AkroQJG64CE0KtwAYtgrfJ42HCW9dj34dDC
         E5f6y+vaJ3/kHbKB4kJo8Ga3Urc1ydQXf1z4wk+r4rcAzIvPEE2iT6QqQmxnwFnwfR6B
         2Z9JX+rkS7LPMmPhyC23+oiCMP1ifxZakCJgD9ZkMWeVuLGelQ7rJYZ127B5yJEPv4zv
         7kWg==
X-Gm-Message-State: AOAM530BXYAdT1Mc8VfR2Gz6oGcds9QM0Le9jdsA1Qmdg+R3RARWAAds
        ReiwPV8uZne5y60262TPWzSb676smQI=
X-Google-Smtp-Source: ABdhPJzSEZPodaqcIqvMD82N8W0cud+ZqgBHTt/0eiSMy13p/um5GCarQPZcMAPbrjM8K4rm6xCKlIue0Vo=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:2283:b0:158:e7f4:7056 with SMTP id
 b3-20020a170903228300b00158e7f47056mr14258890plh.24.1650351441718; Mon, 18
 Apr 2022 23:57:21 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:16 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-11-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 10/38] KVM: arm64: Make ID_AA64ISAR2_EL1 writable
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

This patch adds id_reg_desc for ID_AA64ISAR2_EL1 to make it
writable by userspace.

Return an error if userspace tries to set PTRAUTH related fields
of the register to values that conflict with PTRAUTH configuration,
which was configured by KVM_ARM_VCPU_INIT, for the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 65 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dd4dcc1e4982..ba2e6dac7774 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -289,6 +289,16 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+#define ISAR2_PTRAUTH_MASK	(ARM64_FEATURE_MASK(ID_AA64ISAR2_APA3) | \
+				 ARM64_FEATURE_MASK(ID_AA64ISAR2_GPA3))
+
+#define aa64isar2_has_apa3(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR2_APA3_SHIFT) >= \
+	 ID_AA64ISAR2_APA3_ARCHITECTED)
+#define aa64isar2_has_gpa3(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR2_GPA3_SHIFT) >= \
+	 ID_AA64ISAR2_GPA3_ARCHITECTED)
+
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -507,6 +517,31 @@ static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64isar2_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_desc *id_reg, u64 val)
+{
+	bool has_gpa3, has_apa3, lim_has_gpa3, lim_has_apa3;
+	u64 lim = id_reg->vcpu_limit_val;
+
+	has_gpa3 = aa64isar2_has_gpa3(val);
+	has_apa3 = aa64isar2_has_apa3(val);
+	lim_has_gpa3 = aa64isar2_has_gpa3(lim);
+	lim_has_apa3 = aa64isar2_has_apa3(lim);
+
+	/*
+	 * Check if there is a conflict in the requested value for
+	 * ID_AA64ISAR2_EL1 with PTRAUTH configuration.
+	 * See comments in validate_id_aa64isar1_el1() for more detail.
+	 */
+	if (lim_has_gpa3 && (vcpu_has_ptrauth(vcpu) ^ has_gpa3))
+		return -EPERM;
+
+	if (lim_has_apa3 && (vcpu_has_ptrauth(vcpu) ^ has_apa3))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -550,6 +585,13 @@ static void init_id_aa64isar1_el1_desc(struct id_reg_desc *id_reg)
 		id_reg->vcpu_limit_val &= ~ISAR1_TRAUTH_MASK;
 }
 
+static void init_id_aa64isar2_el1_desc(struct id_reg_desc *id_reg)
+{
+	if (!system_has_full_ptr_auth())
+		id_reg->vcpu_limit_val &= ~ISAR2_PTRAUTH_MASK;
+}
+
+
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
 					 const struct id_reg_desc *idr)
 {
@@ -568,6 +610,13 @@ static u64 vcpu_mask_id_aa64isar1_el1(const struct kvm_vcpu *vcpu,
 	return vcpu_has_ptrauth(vcpu) ? 0 : ISAR1_TRAUTH_MASK;
 }
 
+static u64 vcpu_mask_id_aa64isar2_el1(const struct kvm_vcpu *vcpu,
+					  const struct id_reg_desc *idr)
+{
+	return vcpu_has_ptrauth(vcpu) ? 0 : ISAR2_PTRAUTH_MASK;
+}
+
+
 static int validate_id_reg(struct kvm_vcpu *vcpu,
 			   const struct id_reg_desc *id_reg, u64 val)
 {
@@ -1544,11 +1593,6 @@ static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 
 	val = read_kvm_id_reg(vcpu->kvm, id);
 	switch (id) {
-	case SYS_ID_AA64ISAR2_EL1:
-		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR2_APA3) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR2_GPA3));
-		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Limit debug to ARMv8.0 */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
@@ -3359,6 +3403,16 @@ static struct id_reg_desc id_aa64isar1_el1_desc = {
 	},
 };
 
+static struct id_reg_desc id_aa64isar2_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64ISAR2_EL1),
+	.init = init_id_aa64isar2_el1_desc,
+	.validate = validate_id_aa64isar2_el1,
+	.vcpu_mask = vcpu_mask_id_aa64isar2_el1,
+	.ftr_bits = {
+		U_FTR_BITS(FTR_EXACT, ID_AA64ISAR2_APA3_SHIFT, 0),
+	},
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3371,6 +3425,7 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=6 */
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
+	ID_DESC(ID_AA64ISAR2_EL1, &id_aa64isar2_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.36.0.rc0.470.gd361397f0d-goog


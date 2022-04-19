Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1227506501
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349085AbiDSHAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349073AbiDSHAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:04 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDCD2E9FB
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:20 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q1-20020a17090a2dc100b001cba43e127dso1033339pjm.9
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=T9Xy6Y7bYT/jvhM2kTPbgpDtWYIyMfhZbMRA2+tL7yI=;
        b=B7PAcAM4HsOqHFYrrY4pedJvy7X9vroe5Q8S1fAV7WVj5N09swKpjJJfF3gnP8/reJ
         fVsrxBdLBTz0krOUET53ChIdF5mbVTIFS7fAYzQVuE0G4zVoiCbUp6oDmfC6NacuHOvL
         5azkE3plJDxC9w7+IUCUwSoBwx+3QnNoA+bcS5LihZhXcM3eaBwKsMHJssp9n5HfwHKT
         XxU+kZjw65krvFcJcyKGb/f6wFqEB1IZXDd41Bmlf8BLgtY992wK0z7zt0MpLIFxo+9v
         elPgQc0sBjjCf7YaCd1UsULtfi7TcpBe2ozt6vbyfcigvyUMOupYh5fjS1PWyMiE6JfL
         KYDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=T9Xy6Y7bYT/jvhM2kTPbgpDtWYIyMfhZbMRA2+tL7yI=;
        b=g9kYSsP54irEiSTQnxh3ncSPV6Sf3O3MeW9giHf6zgtaINOzL+7oNsI6yKbwwHa+Kp
         QRGJ1r6pZ20Az9ASuvl0wiSB3DjcrP9jtVbjtrk4miZB6B7WAWM50UeMfLikuOhpJkrZ
         rQxuGd4dG1DJzsIYKO6VgIRAD7a08gX6j1rinbG5EpcgIcenVT59KeSEI3Qxr4kMyGIy
         Zc5R9Su7t3qDdS6mCrO9WtXsL/L8e8SJNvFpzj3+LH3ZZDC2Q1b+tbOvi7NX+2SeYXh6
         o2Rd80coftOms/NoAGYe4iXIcsRNLnQ9CddFFkEcoxKxA7C7WegaPd9mdJvhIcGtf8Hj
         OHuA==
X-Gm-Message-State: AOAM530IAbMpAIpt0ryxqwb9hCDa1ZhUxGXPm736iUIyNe8r0j7jM58l
        SZeL1S19Gdq5kOnHXMAIGuGAyELkZgI=
X-Google-Smtp-Source: ABdhPJx6kmdRm2h0buoVV6HUHf1SRqgqhPTpvh0hIVJbrpV8QWVshsgJq6Q+Nc4d3tpnnfmRdI/PituH1Jk=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:aa8e:b0:158:e948:27 with SMTP id
 d14-20020a170902aa8e00b00158e9480027mr13672768plr.69.1650351440204; Mon, 18
 Apr 2022 23:57:20 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:15 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-10-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 09/38] KVM: arm64: Make ID_AA64ISAR1_EL1 writable
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

This patch adds id_reg_desc for ID_AA64ISAR1_EL1 to make it
writable by userspace.

Return an error if userspace tries to set PTRAUTH related fields
of the register to values that conflict with PTRAUTH configuration,
which was configured by KVM_ARM_VCPU_INIT, for the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 90 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 83 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c01038cbdb31..dd4dcc1e4982 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -271,6 +271,24 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+#define ISAR1_TRAUTH_MASK	(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |	\
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) | \
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |	\
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI))
+
+#define aa64isar1_has_apa(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_APA_SHIFT) >= \
+	 ID_AA64ISAR1_APA_ARCHITECTED)
+#define aa64isar1_has_api(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_API_SHIFT) >= \
+	 ID_AA64ISAR1_API_IMP_DEF)
+#define aa64isar1_has_gpa(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPA_SHIFT) >= \
+	 ID_AA64ISAR1_GPA_ARCHITECTED)
+#define aa64isar1_has_gpi(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
+	 ID_AA64ISAR1_GPI_IMP_DEF)
+
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -448,6 +466,47 @@ static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_desc *id_reg, u64 val)
+{
+	bool has_gpi, has_gpa, has_api, has_apa;
+	bool generic, address, lim_generic, lim_address;
+	u64 lim = id_reg->vcpu_limit_val;
+
+	has_gpi = aa64isar1_has_gpi(val);
+	has_gpa = aa64isar1_has_gpa(val);
+	has_api = aa64isar1_has_api(val);
+	has_apa = aa64isar1_has_apa(val);
+	if ((has_gpi && has_gpa) || (has_api && has_apa))
+		return -EINVAL;
+
+	generic = has_gpi || has_gpa;
+	address = has_api || has_apa;
+	lim_generic = aa64isar1_has_gpi(lim) || aa64isar1_has_gpa(lim);
+	lim_address = aa64isar1_has_api(lim) || aa64isar1_has_apa(lim);
+
+	/*
+	 * When PTRAUTH is configured for the vCPU via KVM_ARM_VCPU_INIT,
+	 * it should mean that userspace wants to expose
+	 * one of ID_AA64ISAR1_EL1.GPI, GPA or ID_AA64ISAR2_EL1.GPA3 and
+	 * one of ID_AA64ISAR1_EL1.API, APA or ID_AA64ISAR2_EL1.APA3 to
+	 * the guest (As per Arm ARM, for generic code authentication
+	 * and address authentication, only one of those field can be
+	 * non-zero).
+	 * Check if there is a conflict in the requested value for
+	 * ID_AA64ISAR1_EL1 with PTRAUTH configuration.
+	 * (When lim_generic/lim_address is 0, generic/address must be
+	 *  also 0, which is checked by arm64_check_features())
+	 */
+	if (lim_generic && (vcpu_has_ptrauth(vcpu) ^ generic))
+		return -EPERM;
+
+	if (lim_address && (vcpu_has_ptrauth(vcpu) ^ address))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -485,6 +544,12 @@ static void init_id_aa64pfr1_el1_desc(struct id_reg_desc *id_reg)
 		id_reg->vcpu_limit_val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
 }
 
+static void init_id_aa64isar1_el1_desc(struct id_reg_desc *id_reg)
+{
+	if (!system_has_full_ptr_auth())
+		id_reg->vcpu_limit_val &= ~ISAR1_TRAUTH_MASK;
+}
+
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
 					 const struct id_reg_desc *idr)
 {
@@ -497,6 +562,12 @@ static u64 vcpu_mask_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu,
 	return kvm_has_mte(vcpu->kvm) ? 0 : (ARM64_FEATURE_MASK(ID_AA64PFR1_MTE));
 }
 
+static u64 vcpu_mask_id_aa64isar1_el1(const struct kvm_vcpu *vcpu,
+					  const struct id_reg_desc *idr)
+{
+	return vcpu_has_ptrauth(vcpu) ? 0 : ISAR1_TRAUTH_MASK;
+}
+
 static int validate_id_reg(struct kvm_vcpu *vcpu,
 			   const struct id_reg_desc *id_reg, u64 val)
 {
@@ -1473,13 +1544,6 @@ static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 
 	val = read_kvm_id_reg(vcpu->kvm, id);
 	switch (id) {
-	case SYS_ID_AA64ISAR1_EL1:
-		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI));
-		break;
 	case SYS_ID_AA64ISAR2_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR2_APA3) |
@@ -3284,6 +3348,17 @@ static struct id_reg_desc id_aa64isar0_el1_desc = {
 	.validate = validate_id_aa64isar0_el1,
 };
 
+static struct id_reg_desc id_aa64isar1_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64ISAR1_EL1),
+	.init = init_id_aa64isar1_el1_desc,
+	.validate = validate_id_aa64isar1_el1,
+	.vcpu_mask = vcpu_mask_id_aa64isar1_el1,
+	.ftr_bits = {
+		U_FTR_BITS(FTR_EXACT, ID_AA64ISAR1_APA_SHIFT, 0),
+		U_FTR_BITS(FTR_EXACT, ID_AA64ISAR1_API_SHIFT, 0),
+	},
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3295,6 +3370,7 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 
 	/* CRm=6 */
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
+	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.36.0.rc0.470.gd361397f0d-goog


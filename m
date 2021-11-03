Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95088443D20
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhKCGao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhKCGao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:44 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F02C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:08 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g26-20020a63521a000000b0029524f04f5aso1039383pgb.5
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=62b24VOqm1GyPCwAwjAOsxxDMNGj6sMpkNWOp6uvxsM=;
        b=XlbO25p2CIQboATiZM796LS9XynMuq0GihpUcYOZrTmQhvJzRJ2W/kjCoQLkW092ux
         iZwcnroXhOVlOrNpwyjrb4W7FhkK+5ur3AYKTrsIPhlnANtJ2ggQfqeJ8k3knJ5xm8NQ
         XQLwJckKsME0PRvn7JU9p+y1maCsQ7z4k+gRpL5u6lRaNtaEz9LsTgchiiQAf5AMGsZI
         oxxvN08C1a91mRWJHpn1VtdIZfTpqaIxzUk+dJP+qAHWgqq9gX7AdZ4Mm6fiVtJvSyJF
         zihzYRwoZJrmBgPEAhtAPegRJl3TYI2CLuDPM/yTxxZJwFHwrvNP0aeFRqM9Yg8gJzpy
         lMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=62b24VOqm1GyPCwAwjAOsxxDMNGj6sMpkNWOp6uvxsM=;
        b=ZClIJhIQN8PEl6rVTiGWFE6EUlis/x5uV4VUP4H+gL9APWFPio+RxP02fYMjjJL6Tq
         RGhFlj24PuJISMg1krAdL/00mslCzIG5NqeBnlOzuQ2I+hsVHtErYh6TzK+Wga+j5Ooy
         Hx1iWEAPN5hjYSxbBnYp+F1QkvSVXMhUwAJj0knbtJ6/GqzLYsvsjIL6clUmNZJcWA0c
         OsR2Lc+F/S2J9jf4T+Yk4uv8SrXkCky5BZx87YpDVg6HQUeTzzWWjQkMIIPLrnvuYswN
         mal2aPo5OsCSJNc8q+Deno/5j1QWA0euTgOozOS//wzdqEVOq+gpCjIjV7HVO2z8jkTN
         cc2w==
X-Gm-Message-State: AOAM5319/D1wVmf5sQOME+YgStspgTqDQY1fEEfthzQTGxG3fx6U7gdX
        IHaZBmqbYPC8u5fNWjVkzksEvCxxBjg=
X-Google-Smtp-Source: ABdhPJyGvMyBr7tNE7aE91Wbj2mvX+2vJq4YTKJKizdjI2txUHQhqgC4yVAz0wHp3y/dUFG7WJDfQgKWMXI=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:b83:b0:47b:fbb3:9265 with SMTP id
 g3-20020a056a000b8300b0047bfbb39265mr41424784pfj.79.1635920887811; Tue, 02
 Nov 2021 23:28:07 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:00 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-9-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 08/28] KVM: arm64: Make ID_AA64ISAR1_EL1 writable
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

This patch adds id_reg_info for ID_AA64ISAR1_EL1 to make it
writable by userspace.

Return an error if userspace tries to set PTRAUTH related fields
of the register to values that conflict with PTRAUTH configuration,
which was configured by KVM_ARM_VCPU_INIT, for the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 79 +++++++++++++++++++++++++++++++++++----
 1 file changed, 72 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7f505853b569..83b05d37afbd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -356,6 +356,24 @@ static int arm64_check_features(u64 check_types, u64 val, u64 lim)
 	return 0;
 }
 
+#define PTRAUTH_MASK	(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |	\
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) | \
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |	\
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI))
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
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 
@@ -460,6 +478,36 @@ static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *id_reg, u64 val)
+{
+	bool has_gpi, has_gpa, has_api, has_apa;
+	bool generic, address;
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
+	/*
+	 * Since the current KVM guest implementation works by enabling
+	 * both address/generic pointer authentication features,
+	 * return an error if they conflict.
+	 */
+	if (generic ^ address)
+		return -EPERM;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_has_ptrauth(vcpu) ^ (generic && address))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -490,6 +538,12 @@ static void init_id_aa64pfr1_el1_info(struct id_reg_info *id_reg)
 		id_reg->vcpu_limit_val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
 }
 
+static void init_id_aa64isar1_el1_info(struct id_reg_info *id_reg)
+{
+	if (!system_has_full_ptr_auth())
+		id_reg->vcpu_limit_val &= ~PTRAUTH_MASK;
+}
+
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     const struct id_reg_info *idr)
 {
@@ -506,6 +560,13 @@ static u64 get_reset_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE)));
 }
 
+static u64 get_reset_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
+				      const struct id_reg_info *idr)
+{
+	return vcpu_has_ptrauth(vcpu) ?
+	       idr->vcpu_limit_val : (idr->vcpu_limit_val & ~PTRAUTH_MASK);
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
@@ -530,6 +591,16 @@ static struct id_reg_info id_aa64isar0_el1_info = {
 	.validate = validate_id_aa64isar0_el1,
 };
 
+static struct id_reg_info id_aa64isar1_el1_info = {
+	.sys_reg = SYS_ID_AA64ISAR1_EL1,
+	.ftr_check_types =
+		U_FCT(ID_AA64ISAR1_API_SHIFT, FCT_EXACT_OR_ZERO_SAFE) |
+		U_FCT(ID_AA64ISAR1_APA_SHIFT, FCT_EXACT_OR_ZERO_SAFE),
+	.init = init_id_aa64isar1_el1_info,
+	.validate = validate_id_aa64isar1_el1,
+	.get_reset_val = get_reset_id_aa64isar1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -542,6 +613,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -1376,13 +1448,6 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
 	switch (id) {
-	case SYS_ID_AA64ISAR1_EL1:
-		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI));
-		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Limit debug to ARMv8.0 */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
-- 
2.33.1.1089.g2158813163f-goog


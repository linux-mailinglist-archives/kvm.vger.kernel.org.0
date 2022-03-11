Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D584C4D5A11
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346391AbiCKEuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346493AbiCKEuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:50:01 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021A2EF0A9
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:52 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id z10-20020a170902708a00b0014fc3888923so3908751plk.22
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a5NZVbIGTYSicQYzOe725Txq1lABLpfJECv3sjtkGuU=;
        b=rZWabE3/DjqFkZZ9yem9BCkI5hKWm8VfpXefmCQaPcTs14QvUZ0vcayO45kMleKK29
         GMp09uKACG3tWlNHVh3GPHV2J0SwJPZCeNrIONstfq05qxdkbiLxCVXxS/XrIwKo4WnA
         AeHEt3sWNHx3yld+TIk/OJY6tevxKHjWwYOQ7AjpX2hbpmhAnpy7wBO2QmW1uQa7QIbs
         OpK+PLPBOAIEvTVYxTTjye4f7GxhrytGEIbBeTpAEaoW3VyZBxElnQ0cYInZQYvlCN2O
         tY3S0V0dkRY4PvNVsk3du41C01mZyzMVDQ4fwQChOKSbCTqvCx4/AWIpb0mUwmpAtiKc
         HsMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a5NZVbIGTYSicQYzOe725Txq1lABLpfJECv3sjtkGuU=;
        b=2IMvFQUZ6eIiz0s3udOyb3GD8vjmHNzecxMGY5XhWJ7pxQ38x2NsjkbK2BNpYqCU8x
         8M6MMxoSbPaba9vTzLF0UIbA16TAFEiBvSoc1PhIB02mqzUzh+mCvipnikd+JcDzjQ/q
         xhF7UIgQpgYJyFBEc98LsEVQdFW4+FDzygfsqVTy2yKxpyw7PrNcg4AylVi2a+cWrJ+g
         F/vyXz6lEO+bg59Xv8f46Z9BBClBCc5G/udqT+nlFHUfLLwLF3dM8D/0jObhWYX1xh5U
         halLLymuYzjOXaR40MUq6i8jN2yOp2skJPxq/0QGgsqskuWq2gg+9Srif3pFUKrTW/Pr
         lTwg==
X-Gm-Message-State: AOAM533is1SAvmaa8hmDxZO1DC9/oid+o4f6s+bnHbOmYGxg1+2T7RQv
        XQzFUxd4wETJxTruLGw/PKUgfOkhIo8=
X-Google-Smtp-Source: ABdhPJzvkmL3IM37HsTGDKBcNfNxa8ZQ40eJ1UsQa3PnTHm4qaAZLEQpv/Muf4haE6tVZuP1eE4Yz/InSqM=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:4d81:b0:1bf:8ce4:4f51 with SMTP id
 oj1-20020a17090b4d8100b001bf8ce44f51mr435697pjb.0.1646974131159; Thu, 10 Mar
 2022 20:48:51 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:47:58 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-13-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 12/25] KVM: arm64: Use id_reg_desc_table for ID registers
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

Use id_reg_desc_table for ID registers instead of sys_reg_descs as
id_reg_desc_table has all ID register entries that sys_reg_descs
has, and remove the ID register entries from sys_reg_descs, which
are no longer used.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 201 +++++++++++++++++---------------------
 1 file changed, 92 insertions(+), 109 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fe2a4de2b8f3..ba851de6486d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -337,6 +337,11 @@ struct id_reg_desc {
 			 const struct id_reg_desc *id_reg);
 };
 
+static inline struct id_reg_desc *sys_to_id_desc(const struct sys_reg_desc *r)
+{
+	return container_of(r, struct id_reg_desc, reg_desc);
+}
+
 static void id_reg_desc_init(struct id_reg_desc *id_reg)
 {
 	u32 id = reg_to_encoding(&id_reg->reg_desc);
@@ -1696,23 +1701,15 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu,
 	return val;
 }
 
-static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
+static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 encoding)
 {
-	u64 val;
-	const struct id_reg_desc *id_reg = get_id_reg_desc(id);
-
-	if (id_reg)
-		val = __read_id_reg(vcpu, id_reg);
-	else
-		val = read_kvm_id_reg(vcpu->kvm, id);
-
-	return val;
+	return __read_id_reg(vcpu, get_id_reg_desc(encoding));
 }
 
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		       struct sys_reg_desc const *r, bool raz)
 {
-	return raz ? 0 : read_id_reg_with_encoding(vcpu, reg_to_encoding(r));
+	return raz ? 0 : __read_id_reg(vcpu, sys_to_id_desc(r));
 }
 
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
@@ -1826,13 +1823,7 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (raz)
 		return -EINVAL;
 
-	/*
-	 * Don't allow to modify the register's value if the register doesn't
-	 * have the id_reg_desc.
-	 */
-	id_reg = get_id_reg_desc(encoding);
-	if (!id_reg)
-		return -EINVAL;
+	id_reg = sys_to_id_desc(rd);
 
 	/*
 	 * Skip the validation of AArch32 ID registers if the system doesn't
@@ -2055,83 +2046,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
 
-	/*
-	 * ID regs: all ID_SANITISED() entries here must have corresponding
-	 * entries in arm64_ftr_regs[].
-	 */
-
-	/* AArch64 mappings of the AArch32 ID registers */
-	/* CRm=1 */
-	ID_SANITISED(ID_PFR0_EL1),
-	ID_SANITISED(ID_PFR1_EL1),
-	ID_SANITISED(ID_DFR0_EL1),
-	ID_HIDDEN(ID_AFR0_EL1),
-	ID_SANITISED(ID_MMFR0_EL1),
-	ID_SANITISED(ID_MMFR1_EL1),
-	ID_SANITISED(ID_MMFR2_EL1),
-	ID_SANITISED(ID_MMFR3_EL1),
-
-	/* CRm=2 */
-	ID_SANITISED(ID_ISAR0_EL1),
-	ID_SANITISED(ID_ISAR1_EL1),
-	ID_SANITISED(ID_ISAR2_EL1),
-	ID_SANITISED(ID_ISAR3_EL1),
-	ID_SANITISED(ID_ISAR4_EL1),
-	ID_SANITISED(ID_ISAR5_EL1),
-	ID_SANITISED(ID_MMFR4_EL1),
-	ID_SANITISED(ID_ISAR6_EL1),
-
-	/* CRm=3 */
-	ID_SANITISED(MVFR0_EL1),
-	ID_SANITISED(MVFR1_EL1),
-	ID_SANITISED(MVFR2_EL1),
-	ID_UNALLOCATED(3,3),
-	ID_SANITISED(ID_PFR2_EL1),
-	ID_HIDDEN(ID_DFR1_EL1),
-	ID_SANITISED(ID_MMFR5_EL1),
-	ID_UNALLOCATED(3,7),
-
-	/* AArch64 ID registers */
-	/* CRm=4 */
-	ID_SANITISED(ID_AA64PFR0_EL1),
-	ID_SANITISED(ID_AA64PFR1_EL1),
-	ID_UNALLOCATED(4,2),
-	ID_UNALLOCATED(4,3),
-	ID_SANITISED(ID_AA64ZFR0_EL1),
-	ID_UNALLOCATED(4,5),
-	ID_UNALLOCATED(4,6),
-	ID_UNALLOCATED(4,7),
-
-	/* CRm=5 */
-	ID_SANITISED(ID_AA64DFR0_EL1),
-	ID_SANITISED(ID_AA64DFR1_EL1),
-	ID_UNALLOCATED(5,2),
-	ID_UNALLOCATED(5,3),
-	ID_HIDDEN(ID_AA64AFR0_EL1),
-	ID_HIDDEN(ID_AA64AFR1_EL1),
-	ID_UNALLOCATED(5,6),
-	ID_UNALLOCATED(5,7),
-
-	/* CRm=6 */
-	ID_SANITISED(ID_AA64ISAR0_EL1),
-	ID_SANITISED(ID_AA64ISAR1_EL1),
-	ID_SANITISED(ID_AA64ISAR2_EL1),
-	ID_UNALLOCATED(6,3),
-	ID_UNALLOCATED(6,4),
-	ID_UNALLOCATED(6,5),
-	ID_UNALLOCATED(6,6),
-	ID_UNALLOCATED(6,7),
-
-	/* CRm=7 */
-	ID_SANITISED(ID_AA64MMFR0_EL1),
-	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
-	ID_UNALLOCATED(7,3),
-	ID_UNALLOCATED(7,4),
-	ID_UNALLOCATED(7,5),
-	ID_UNALLOCATED(7,6),
-	ID_UNALLOCATED(7,7),
-
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
 	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
@@ -2946,12 +2860,38 @@ static bool is_imp_def_sys_reg(struct sys_reg_params *params)
 	return params->Op0 == 3 && (params->CRn & 0b1011) == 0b1011;
 }
 
+static inline const struct sys_reg_desc *
+find_id_reg(const struct sys_reg_params *params)
+{
+	u32 id = reg_to_encoding(params);
+	struct id_reg_desc *idr;
+
+	if (!is_id_reg(id))
+		return NULL;
+
+	idr = get_id_reg_desc(id);
+
+	return idr ? &idr->reg_desc : NULL;
+}
+
+static const struct sys_reg_desc *
+find_sys_reg(const struct sys_reg_params *params)
+{
+	const struct sys_reg_desc *r = NULL;
+
+	r = find_id_reg(params);
+	if (!r)
+		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+
+	return r;
+}
+
 static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *params)
 {
 	const struct sys_reg_desc *r;
 
-	r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	r = find_sys_reg(params);
 
 	if (likely(r)) {
 		perform_access(vcpu, params, r);
@@ -2966,6 +2906,8 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+static void kvm_reset_id_regs(struct kvm_vcpu *vcpu);
+
 /**
  * kvm_reset_sys_regs - sets system registers to reset value
  * @vcpu: The VCPU pointer
@@ -2980,6 +2922,8 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++)
 		if (sys_reg_descs[i].reset)
 			sys_reg_descs[i].reset(vcpu, &sys_reg_descs[i]);
+
+	kvm_reset_id_regs(vcpu);
 }
 
 /**
@@ -3063,7 +3007,7 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	if (!index_to_params(id, &params))
 		return NULL;
 
-	r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	r = find_sys_reg(&params);
 
 	/* Not saved in the sys_reg array and not otherwise accessible? */
 	if (r && !(r->reg || r->get_user))
@@ -3360,6 +3304,8 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind);
+
 /* Assumed ordered tables, see kvm_sys_reg_table_init. */
 static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 {
@@ -3375,6 +3321,12 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 		if (err)
 			return err;
 	}
+
+	err = walk_id_regs(vcpu, uind);
+	if (err < 0)
+		return err;
+
+	total += err;
 	return total;
 }
 
@@ -3625,6 +3577,25 @@ static inline struct id_reg_desc *get_id_reg_desc(u32 id)
 	return id_reg_desc_table[IDREG_IDX(id)];
 }
 
+static int walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
+{
+	const struct sys_reg_desc *sys_reg;
+	int err, i;
+	unsigned int total = 0;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_desc_table); i++) {
+		if (!id_reg_desc_table[i])
+			continue;
+
+		sys_reg = &id_reg_desc_table[i]->reg_desc;
+		err = walk_one_sys_reg(vcpu, sys_reg, &uind, &total);
+		if (err)
+			return err;
+	}
+
+	return total;
+}
+
 static void id_reg_desc_init_all(void)
 {
 	int i;
@@ -3647,23 +3618,35 @@ void set_default_id_regs(struct kvm *kvm)
 {
 	int i;
 	u32 id;
-	const struct sys_reg_desc *rd;
-	u64 val;
 	struct id_reg_desc *idr;
 
-	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
-		rd = &sys_reg_descs[i];
-		if (rd->access != access_id_reg)
-			/* Not ID register, or hidden/reserved ID register */
+	for (i = 0; i < ARRAY_SIZE(id_reg_desc_table); i++) {
+		idr = id_reg_desc_table[i];
+		if (!idr)
+			continue;
+
+		if (idr->flags & (ID_DESC_REG_HIDDEN | ID_DESC_REG_UNALLOC))
+			/* Nothing to do for hidden/unalloc registers */
 			continue;
 
-		id = reg_to_encoding(rd);
-		if (WARN_ON_ONCE(!is_id_reg(id)))
-			/* Shouldn't happen */
+		id = reg_to_encoding(&idr->reg_desc);
+		WARN_ON_ONCE(write_kvm_id_reg(kvm, id, idr->vcpu_limit_val));
+	}
+}
+
+static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
+{
+	int i;
+	const struct sys_reg_desc *r;
+	struct id_reg_desc *id_reg;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_desc_table); i++) {
+		id_reg = (struct id_reg_desc *)id_reg_desc_table[i];
+		if (!id_reg)
 			continue;
 
-		idr = get_id_reg_desc(id);
-		val = idr ? idr->vcpu_limit_val : read_sanitised_ftr_reg(id);
-		WARN_ON_ONCE(write_kvm_id_reg(kvm, id, val));
+		r = &id_reg->reg_desc;
+		if (r->reset)
+			r->reset(vcpu, r);
 	}
 }
-- 
2.35.1.723.g4982287a31-goog


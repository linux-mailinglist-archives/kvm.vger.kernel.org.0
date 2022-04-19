Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B61506518
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349109AbiDSHAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349116AbiDSHAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:24 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E303A2E9FB
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:38 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id i8-20020a17090a2a0800b001cb5c76ea21so10141975pjd.2
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BYNmDR5aS9CIHBUCE54KmU1zVcfj0hKEcHDhO14njTY=;
        b=Rd3OQG2adxkXSrgalrmYqwRA4enRlDXXdjPxUSYSaHT2dWBBuKK0E8aHDuS5ESL9J4
         TZ3Bv1osyFcq4eHT6/SA9wrP1JaZOlZRVjcqTsS519xru7QsPiFkO0IC/zg0g/ZzNvho
         jS5ABHj/nGNsw6WrVJ/XsZH+eEKM2HIOKf2RadJ0gcol1Zb5LHKFhLZo5Z5Xvp/k24zn
         /NFSeOZNHGrXgif6ROqLJ1cOTAW+6AvHg2Yl5wKoBE08+VI8c4gLv5M0Zz8vYao9Mxuo
         W84IC3XbHXuUUxL4EBRv5ieXGWzNg3qOhwynA/6s8/XbHJ/REqwbsvo5SrqNVMjBlZeM
         TVug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BYNmDR5aS9CIHBUCE54KmU1zVcfj0hKEcHDhO14njTY=;
        b=UXB8hjjJmppcvf6mumhaH1HHxeYncTXA5peNeO1P5fSYduoW2Zmw0TZx68WZo5Rm0Q
         No7RG3PgtutVXcBOHtmJasamRn0yPekAkxFr4+tFbQcs8yDKWKNI7uqsLH5yffhtk9CJ
         cnwAIRGkDDgmrY3eAnVy1llFyTGwK11e+KpotQ5bp72ttPVzHa4ApXYx39qJr4ypgVUx
         BkmrWm7XDHT64R/HpjX8aG9/VTRzD//9/Di5ATdL3zTlkR6wwrN3Z081TuC5EOEcEMMh
         iPZVIgH7JoA7RVKvYZkGRPAk5YjeG2OwD9GwJESNLHI4pqFqaKE09FIl/5zLKTashsnN
         TTWQ==
X-Gm-Message-State: AOAM53198KpdOJjbImJmVl9Jb/m9N/b9xAD2ZlnKNA1BZkS2d5cnwrkc
        f9LdVuoxJZ6kmT5DxKUmt2ul37W9gj8=
X-Google-Smtp-Source: ABdhPJysSV5fT+ppkKeqH9Y96RbdCmh9YpcOlscu43gi8Doy318XckzFc1VUDrPpwtYz4XZP/kyrJhwVpoM=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a62:5343:0:b0:4f7:baad:5c22 with SMTP id
 h64-20020a625343000000b004f7baad5c22mr16124535pfb.30.1650351458319; Mon, 18
 Apr 2022 23:57:38 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:26 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-21-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 20/38] KVM: arm64: Use id_reg_desc_table for ID registers
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
 arch/arm64/kvm/sys_regs.c | 213 ++++++++++++++++----------------------
 1 file changed, 92 insertions(+), 121 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 479208dedd79..1045319c474e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -378,6 +378,11 @@ struct id_reg_desc {
 	struct arm64_ftr_bits	ftr_bits[FTR_FIELDS_NUM];
 };
 
+static inline struct id_reg_desc *sys_to_id_desc(const struct sys_reg_desc *r)
+{
+	return container_of(r, struct id_reg_desc, reg_desc);
+}
+
 static void id_reg_desc_init(struct id_reg_desc *id_reg)
 {
 	u32 id = reg_to_encoding(&id_reg->reg_desc);
@@ -2326,23 +2331,15 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu,
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
@@ -2456,13 +2453,7 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (test_bit(KVM_ARCH_FLAG_EL1_32BIT, &vcpu->kvm->arch.flags))
 		return -EPERM;
 
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
@@ -2686,83 +2677,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
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
@@ -3577,12 +3491,38 @@ static bool is_imp_def_sys_reg(struct sys_reg_params *params)
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
@@ -3597,6 +3537,8 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+static void kvm_reset_id_regs(struct kvm_vcpu *vcpu);
+
 /**
  * kvm_reset_sys_regs - sets system registers to reset value
  * @vcpu: The VCPU pointer
@@ -3611,6 +3553,8 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++)
 		if (sys_reg_descs[i].reset)
 			sys_reg_descs[i].reset(vcpu, &sys_reg_descs[i]);
+
+	kvm_reset_id_regs(vcpu);
 }
 
 /**
@@ -3694,7 +3638,7 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	if (!index_to_params(id, &params))
 		return NULL;
 
-	r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	r = find_sys_reg(&params);
 
 	/* Not saved in the sys_reg array and not otherwise accessible? */
 	if (r && !(r->reg || r->get_user))
@@ -3991,6 +3935,8 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind);
+
 /* Assumed ordered tables, see kvm_sys_reg_table_init. */
 static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 {
@@ -4006,6 +3952,12 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
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
 
@@ -4306,6 +4258,25 @@ static inline struct id_reg_desc *get_id_reg_desc(u32 id)
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
 void kvm_ftr_bits_set_default(u8 shift, struct arm64_ftr_bits *ftrp)
 {
 	ftrp->sign = FTR_UNSIGNED;
@@ -4376,35 +4347,35 @@ void set_default_id_regs(struct kvm *kvm)
 {
 	int i;
 	u32 id;
-	const struct sys_reg_desc *rd;
-	u64 val;
 	struct id_reg_desc *idr;
-	struct sys_reg_params params = {
-		Op0(sys_reg_Op0(SYS_ID_PFR0_EL1)),
-		Op1(sys_reg_Op1(SYS_ID_PFR0_EL1)),
-		CRn(sys_reg_CRn(SYS_ID_PFR0_EL1)),
-		CRm(sys_reg_CRm(SYS_ID_PFR0_EL1)),
-		Op2(sys_reg_Op2(SYS_ID_PFR0_EL1)),
-	};
 
-	/*
-	 * Find the first entry of the ID register (ID_PFR0_EL1) from
-	 * sys_reg_descs table, and walk through only the ID register
-	 * entries in the table.
-	 */
-	rd = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
-	for (i = 0; i < KVM_ARM_ID_REG_MAX_NUM; i++, rd++) {
-		id = reg_to_encoding(rd);
-		if (WARN_ON_ONCE(!is_id_reg(id)))
-			/* Shouldn't happen */
+	for (i = 0; i < ARRAY_SIZE(id_reg_desc_table); i++) {
+		idr = id_reg_desc_table[i];
+		if (!idr)
 			continue;
 
-		if (rd->access != access_id_reg)
-			/* Hidden or reserved ID register */
+		if (idr->flags & (ID_DESC_REG_HIDDEN | ID_DESC_REG_UNALLOC))
+			/* Nothing to do for hidden/unalloc registers */
+			continue;
+
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
2.36.0.rc0.470.gd361397f0d-goog


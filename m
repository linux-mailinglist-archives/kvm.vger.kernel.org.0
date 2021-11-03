Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE728443D1B
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhKCGaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhKCGaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:19 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5528EC061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:27:43 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id hg9-20020a17090b300900b001a6aa0b7d8cso504165pjb.2
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=N0SbCRP3FKRRzXxFVtqHEMOI2H4V/KqfiyftI54n7ms=;
        b=nbULxAJVUgSTvzbzYkJpllo4pr/PidHqAwdpNySLT2DDGu33eW12HvREdaiWSWySLk
         wKofZpcvt6GZiUBmFDDtoklSlj7kX/sLAAMJz8jOAYEDgOCHe65nQCWY2bOf9r6sHiQe
         EeBdYkuVUoThWnF3UaaUtW0J6s6y3IhQc3H9s6FOl6Febbdvp1nH8mSeBBXQflsXaLbW
         D0imWPF22I5h3NPC0s/nahlgv+rKBmkKB18Y9VI8Mj81aE/iOkgI1O4AS/YW1hewwYM0
         p8qbIVBpsSr9MTJxnGC+CmlwPsZNowhWWZJs4zm4tzX5syMIxC18NAsinKiwasiRbnob
         4XKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N0SbCRP3FKRRzXxFVtqHEMOI2H4V/KqfiyftI54n7ms=;
        b=Hgf0zlwV57AFgID6HIs19R0tWsdEDzmbWsfGXkzEWjTYUnrjymKrSC6QNZEALVJf2+
         3aTU/C0e7eETeQcYbZ90DHglq81wIXdCO0fvzrZcTJPT63VX4IaO6T1wDcCsb5ddUGP1
         Ltr7KBlcwdWFvF0h4eLMfIOg2dJTEzK3E5Pb+DtZaW0GtvMvidDdk8mzHLd7YztCSF6v
         hs+u3RRT7DFbvqqt8kabPRKogOFp+CmoKv+ffu5Fd6Ssf1qnNcTEJsTFI62EdnizQoZJ
         ODXw1wj9aLS8UAcSKRu6fGYnR8SX3DdtV+XJr7Zm9xPWnL9HBT0HZ2Ra74+6DiLcVh3j
         y+oA==
X-Gm-Message-State: AOAM533ltiDSe00mE0Oy6C4+Z2npn/ettT5tFFJrN3EdfnEIPo/u9UPj
        NMVXc/XixN65SzRtQ68owb2Qgn9+P48=
X-Google-Smtp-Source: ABdhPJzUIdVk2Gmdy05xtv+RbFBPD5/d1DZfMTtRC7rOaY/OLKNJi2PwVTXDzT8OsklcEBZV/tjKvV0G26M=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:810:b0:481:22cc:ed59 with SMTP id
 m16-20020a056a00081000b0048122cced59mr10926037pfk.5.1635920862755; Tue, 02
 Nov 2021 23:27:42 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:24:57 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-6-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 05/28] KVM: arm64: Make ID_AA64PFR0_EL1 writable
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

This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
userspace.

The CSV2/CSV3 fields of the register were already writable and values
that were written for them affected all vCPUs before. Now they only
affect the vCPU.

Return an error if userspace tries to set SVE field of the register
to a value that conflicts with SVE configuration for the guest (via
KVM_ARM_VCPU_INIT).  SIMD/FP/SVE fields of the requested value are
validated according to Arm ARM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   3 -
 arch/arm64/kvm/arm.c              |  18 -----
 arch/arm64/kvm/sys_regs.c         | 122 +++++++++++++++++-------------
 3 files changed, 68 insertions(+), 75 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 69af669308b0..691cb6ee0f5c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -131,9 +131,6 @@ struct kvm_arch {
 	unsigned long *pmu_filter;
 	unsigned int pmuver;
 
-	u8 pfr0_csv2;
-	u8 pfr0_csv3;
-
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
 };
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 83cedd74de73..528058920b64 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -114,22 +114,6 @@ static int kvm_arm_default_max_vcpus(void)
 	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 }
 
-static void set_default_spectre(struct kvm *kvm)
-{
-	/*
-	 * The default is to expose CSV2 == 1 if the HW isn't affected.
-	 * Although this is a per-CPU feature, we make it global because
-	 * asymmetric systems are just a nuisance.
-	 *
-	 * Userspace can override this as long as it doesn't promise
-	 * the impossible.
-	 */
-	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
-		kvm->arch.pfr0_csv2 = 1;
-	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
-		kvm->arch.pfr0_csv3 = 1;
-}
-
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
@@ -155,8 +139,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
-	set_default_spectre(kvm);
-
 	return ret;
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e34351fdc66c..c8d31976414a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -399,6 +399,70 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
 		id_reg->init(id_reg);
 }
 
+static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_info *id_reg, u64 val)
+{
+	int fp, simd;
+	bool vcpu_has_sve = vcpu_has_sve(vcpu);
+	bool pfr0_has_sve = id_aa64pfr0_sve(val);
+
+	simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
+	fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
+	if (simd != fp)
+		return -EINVAL;
+
+	/* fp must be supported when sve is supported */
+	if (pfr0_has_sve && (fp < 0))
+		return -EINVAL;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_has_sve ^ pfr0_has_sve)
+		return -EPERM;
+
+	return 0;
+}
+
+static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
+{
+	u64 limit = id_reg->vcpu_limit_val;
+
+	limit &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_AMU));
+	if (!system_supports_sve())
+		limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
+
+	/*
+	 * The default is to expose CSV2 == 1 and CSV3 == 1 if the HW
+	 * isn't affected.  Userspace can override this as long as it
+	 * doesn't promise the impossible.
+	 */
+	limit &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2) |
+		   ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3));
+
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
+		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), 1);
+	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
+		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), 1);
+
+	id_reg->vcpu_limit_val = limit;
+}
+
+static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *idr)
+{
+	return vcpu_has_sve(vcpu) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64PFR0_SVE)));
+}
+
+static struct id_reg_info id_aa64pfr0_el1_info = {
+	.sys_reg = SYS_ID_AA64PFR0_EL1,
+	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
+			   S_FCT(ID_AA64PFR0_FP_SHIFT, FCT_LOWER_SAFE),
+	.init = init_id_aa64pfr0_el1_info,
+	.validate = validate_id_aa64pfr0_el1,
+	.get_reset_val = get_reset_id_aa64pfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -407,7 +471,9 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
  * validation, etc.)
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
-static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};
+static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
+};
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *rd, u64 val)
@@ -1241,15 +1307,6 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
 	switch (id) {
-	case SYS_ID_AA64PFR0_EL1:
-		if (!vcpu_has_sve(vcpu))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
-		break;
 	case SYS_ID_AA64PFR1_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
 		if (kvm_has_mte(vcpu->kvm)) {
@@ -1366,48 +1423,6 @@ static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
 	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = val;
 }
 
-static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
-			       const struct sys_reg_desc *rd,
-			       const struct kvm_one_reg *reg, void __user *uaddr)
-{
-	const u64 id = sys_reg_to_index(rd);
-	u8 csv2, csv3;
-	int err;
-	u64 val;
-
-	err = reg_from_user(&val, uaddr, id);
-	if (err)
-		return err;
-
-	/*
-	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
-	 * it doesn't promise more than what is actually provided (the
-	 * guest could otherwise be covered in ectoplasmic residue).
-	 */
-	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV2_SHIFT);
-	if (csv2 > 1 ||
-	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
-
-	/* Same thing for CSV3 */
-	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV3_SHIFT);
-	if (csv3 > 1 ||
-	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
-
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd, false);
-	val &= ~((0xFUL << ID_AA64PFR0_CSV2_SHIFT) |
-		 (0xFUL << ID_AA64PFR0_CSV3_SHIFT));
-	if (val)
-		return -EINVAL;
-
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3 ;
-
-	return 0;
-}
-
 /* cpufeature ID register user accessors */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1695,8 +1710,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
+	ID_SANITISED(ID_AA64PFR0_EL1),
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.33.1.1089.g2158813163f-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9042AD862
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 15:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbgKJONQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 09:13:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730200AbgKJONP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 09:13:15 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB7C520809;
        Tue, 10 Nov 2020 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605017595;
        bh=bd+IPKZMKInt675zofeivrm7fgS7ZAV/NpMGLLlvmlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vxWZ+z3r9DnuELPB4xuG6Se1eozAlangS+aLw5Tbkq8CLq/KsnqDaPp+nmWUlkeA
         ZG1GRxrz0S0/jfK20JbWVh/fR54qVfpgc8dZUkNanSm7799ZftvkVZdK17vndyESf7
         n04PUOyzhtT7voe7z8Mn83FD4nQAPN+Mqa0dj4hQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kcUOW-009T8Q-W5; Tue, 10 Nov 2020 14:13:13 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     Peng Liang <liangpeng10@huawei.com>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 1/3] KVM: arm64: Allow setting of ID_AA64PFR0_EL1.CSV2 from userspace
Date:   Tue, 10 Nov 2020 14:13:06 +0000
Message-Id: <20201110141308.451654-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110141308.451654-1-maz@kernel.org>
References: <20201110141308.451654-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, liangpeng10@huawei.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We now expose ID_AA64PFR0_EL1.CSV2=1 to guests running on hosts
that are immune to Spectre-v2, but that don't have this field set,
most likely because they predate the specification.

However, this prevents the migration of guests that have started on
a host the doesn't fake this CSV2 setting to one that does, as KVM
rejects the write to ID_AA64PFR0_EL2 on the grounds that it isn't
what is already there.

In order to fix this, allow userspace to set this field as long as
this doesn't result in a promising more than what is already there
(setting CSV2 to 0 is acceptable, but setting it to 1 when it is
already set to 0 isn't).

Fixes: e1026237f9067 ("KVM: arm64: Set CSV2 for guests on hardware unaffected by Spectre-v2")
Reported-by: Peng Liang <liangpeng10@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 16 ++++++++++++
 arch/arm64/kvm/sys_regs.c         | 42 ++++++++++++++++++++++++++++---
 3 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 781d029b8aa8..0cd9f0f75c13 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -118,6 +118,8 @@ struct kvm_arch {
 	 */
 	unsigned long *pmu_filter;
 	unsigned int pmuver;
+
+	u8 pfr0_csv2;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5750ec34960e..c0ffb019ca8b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -102,6 +102,20 @@ static int kvm_arm_default_max_vcpus(void)
 	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 }
 
+static void set_default_csv2(struct kvm *kvm)
+{
+	/*
+	 * The default is to expose CSV2 == 1 if the HW isn't affected.
+	 * Although this is a per-CPU feature, we make it global because
+	 * asymmetric systems are just a nuisance.
+	 *
+	 * Userspace can override this as long as it doesn't promise
+	 * the impossible.
+	 */
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
+		kvm->arch.pfr0_csv2 = 1;
+}
+
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
@@ -127,6 +141,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
+	set_default_csv2(kvm);
+
 	return ret;
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fb12d3ef423a..24fdb6b9b6d3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1128,9 +1128,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		if (!vcpu_has_sve(vcpu))
 			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
 		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
-		if (!(val & (0xfUL << ID_AA64PFR0_CSV2_SHIFT)) &&
-		    arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
-			val |= (1UL << ID_AA64PFR0_CSV2_SHIFT);
+		val &= ~(0xfUL << ID_AA64PFR0_CSV2_SHIFT);
+		val |= ((u64)vcpu->kvm->arch.pfr0_csv2 << ID_AA64PFR0_CSV2_SHIFT);
 	} else if (id == SYS_ID_AA64PFR1_EL1) {
 		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
 	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
@@ -1260,6 +1259,40 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd,
+			       const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	const u64 id = sys_reg_to_index(rd);
+	int err;
+	u64 val;
+	u8 csv2;
+
+	err = reg_from_user(&val, uaddr, id);
+	if (err)
+		return err;
+
+	/*
+	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
+	 * it doesn't promise more than what is actually provided (the
+	 * guest could otherwise be covered in ectoplasmic residue).
+	 */
+	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV2_SHIFT);
+	if (csv2 > 1 ||
+	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
+		return -EINVAL;
+
+	/* We can only differ with CSV2, and anything else is an error */
+	val ^= read_id_reg(vcpu, rd, false);
+	val &= ~(0xFUL << ID_AA64PFR0_CSV2_SHIFT);
+	if (val)
+		return -EINVAL;
+
+	vcpu->kvm->arch.pfr0_csv2 = csv2;
+
+	return 0;
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -1514,7 +1547,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	ID_SANITISED(ID_AA64PFR0_EL1),
+	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
+	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.28.0


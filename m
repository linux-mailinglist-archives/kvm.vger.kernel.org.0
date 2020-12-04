Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20032CF437
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbgLDSi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:38:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbgLDSi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:38:27 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E2DC22CA1;
        Fri,  4 Dec 2020 18:37:47 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1klFxh-00G3Uh-AZ; Fri, 04 Dec 2020 18:37:45 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Brazdil <dbarzdil@google.com>, kernel-team@android.com
Subject: [PATCH v2 2/2] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV3=1 if the CPUs are Meltdown-safe
Date:   Fri,  4 Dec 2020 18:37:09 +0000
Message-Id: <20201204183709.784533-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204183709.784533-1-maz@kernel.org>
References: <20201204183709.784533-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, dbarzdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cores that predate the introduction of ID_AA64PFR0_EL1.CSV3 to
the ARMv8 architecture have this field set to 0, even of some of
them are not affected by the vulnerability.

The kernel maintains a list of unaffected cores (A53, A55 and a few
others) so that it doesn't impose an expensive mitigation uncessarily.

As we do for CSV2, let's expose the CSV3 property to guests that run
on HW that is effectively not vulnerable. This can be reset to zero
by writing to the ID register from userspace, ensuring that VMs can
be migrated despite the new property being set.

Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  6 ++++--
 arch/arm64/kvm/sys_regs.c         | 16 +++++++++++++---
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0cd9f0f75c13..147347028a20 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -120,6 +120,7 @@ struct kvm_arch {
 	unsigned int pmuver;
 
 	u8 pfr0_csv2;
+	u8 pfr0_csv3;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c0ffb019ca8b..dc3fa6a0f9e5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -102,7 +102,7 @@ static int kvm_arm_default_max_vcpus(void)
 	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 }
 
-static void set_default_csv2(struct kvm *kvm)
+static void set_default_spectre(struct kvm *kvm)
 {
 	/*
 	 * The default is to expose CSV2 == 1 if the HW isn't affected.
@@ -114,6 +114,8 @@ static void set_default_csv2(struct kvm *kvm)
 	 */
 	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
 		kvm->arch.pfr0_csv2 = 1;
+	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
+		kvm->arch.pfr0_csv3 = 1;
 }
 
 /**
@@ -141,7 +143,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
-	set_default_csv2(kvm);
+	set_default_spectre(kvm);
 
 	return ret;
 out_free_stage2_pgd:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c1fac9836af1..5fee43dc66cf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1122,6 +1122,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
 		val &= ~(0xfUL << ID_AA64PFR0_CSV2_SHIFT);
 		val |= ((u64)vcpu->kvm->arch.pfr0_csv2 << ID_AA64PFR0_CSV2_SHIFT);
+		val &= ~(0xfUL << ID_AA64PFR0_CSV3_SHIFT);
+		val |= ((u64)vcpu->kvm->arch.pfr0_csv3 << ID_AA64PFR0_CSV3_SHIFT);
 	} else if (id == SYS_ID_AA64PFR1_EL1) {
 		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
 	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
@@ -1209,9 +1211,9 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct kvm_one_reg *reg, void __user *uaddr)
 {
 	const u64 id = sys_reg_to_index(rd);
+	u8 csv2, csv3;
 	int err;
 	u64 val;
-	u8 csv2;
 
 	err = reg_from_user(&val, uaddr, id);
 	if (err)
@@ -1227,13 +1229,21 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
 		return -EINVAL;
 
-	/* We can only differ with CSV2, and anything else is an error */
+	/* Same thing for CSV3 */
+	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV3_SHIFT);
+	if (csv3 > 1 ||
+	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
+		return -EINVAL;
+
+	/* We can only differ with CSV[23], and anything else is an error */
 	val ^= read_id_reg(vcpu, rd, false);
-	val &= ~(0xFUL << ID_AA64PFR0_CSV2_SHIFT);
+	val &= ~((0xFUL << ID_AA64PFR0_CSV2_SHIFT) |
+		 (0xFUL << ID_AA64PFR0_CSV3_SHIFT));
 	if (val)
 		return -EINVAL;
 
 	vcpu->kvm->arch.pfr0_csv2 = csv2;
+	vcpu->kvm->arch.pfr0_csv3 = csv3;
 
 	return 0;
 }
-- 
2.28.0


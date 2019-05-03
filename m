Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79121306A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 16:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfECOgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 10:36:05 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:35002 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728284AbfECOfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 10:35:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63075165C;
        Fri,  3 May 2019 07:28:03 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8331C3F5C1;
        Fri,  3 May 2019 07:28:01 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Eric Auger <eric.auger@redhat.com>,
        Steven Price <steven.price@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH v6 2/3] KVM: arm/arm64: Add save/restore support for firmware workaround state
Date:   Fri,  3 May 2019 15:27:49 +0100
Message-Id: <20190503142750.252793-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503142750.252793-1-andre.przywara@arm.com>
References: <20190503142750.252793-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM implements the firmware interface for mitigating cache speculation
vulnerabilities. Guests may use this interface to ensure mitigation is
active.
If we want to migrate such a guest to a host with a different support
level for those workarounds, migration might need to fail, to ensure that
critical guests don't loose their protection.

Introduce a way for userland to save and restore the workarounds state.
On restoring we do checks that make sure we don't downgrade our
mitigation level.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h   |  10 ++
 arch/arm/include/uapi/asm/kvm.h      |  12 +++
 arch/arm64/include/asm/kvm_emulate.h |  14 +++
 arch/arm64/include/uapi/asm/kvm.h    |  10 ++
 virt/kvm/arm/psci.c                  | 139 ++++++++++++++++++++++++---
 5 files changed, 170 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 8927cae7c966..663a02d7e6f4 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -283,6 +283,16 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 	return vcpu_cp15(vcpu, c0_MPIDR) & MPIDR_HWID_BITMASK;
 }
 
+static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
+static inline void kvm_arm_set_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu,
+						      bool flag)
+{
+}
+
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 {
 	*vcpu_cpsr(vcpu) |= PSR_E_BIT;
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 4602464ebdfb..a4217c1a5d01 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -214,6 +214,18 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM | KVM_REG_SIZE_U64 | \
 					 KVM_REG_ARM_FW | ((r) & 0xffff))
 #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
+	/* Higher values mean better protection. */
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL		1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED	2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
+	/* Higher values mean better protection. */
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN		1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL		2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED	(1U << 4)
 
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d3842791e1c4..c00c17c9adb6 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -348,6 +348,20 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 	return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
 }
 
+static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.workaround_flags & VCPU_WORKAROUND_2_FLAG;
+}
+
+static inline void kvm_arm_set_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu,
+						      bool flag)
+{
+	if (flag)
+		vcpu->arch.workaround_flags |= VCPU_WORKAROUND_2_FLAG;
+	else
+		vcpu->arch.workaround_flags &= ~VCPU_WORKAROUND_2_FLAG;
+}
+
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 97c3478ee6e7..2179783362a8 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -225,6 +225,16 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
 					 KVM_REG_ARM_FW | ((r) & 0xffff))
 #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL		1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED	2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN		1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL		2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     	(1U << 4)
 
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 900b67c2720f..9d7c0130a156 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -449,42 +449,103 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
-	return 1;		/* PSCI version */
+	return 3;		/* PSCI version and two workaround registers */
 }
 
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices))
+	if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices++))
+		return -EFAULT;
+
+	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1, uindices++))
+		return -EFAULT;
+
+	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, uindices++))
 		return -EFAULT;
 
 	return 0;
 }
 
+#define KVM_REG_FEATURE_LEVEL_WIDTH	4
+#define KVM_REG_FEATURE_LEVEL_MASK	(BIT(KVM_REG_FEATURE_LEVEL_WIDTH) - 1)
+
+/*
+ * Convert the workaround level into an easy-to-compare number, where higher
+ * values mean better protection.
+ */
+static int get_kernel_wa_level(u64 regid)
+{
+	switch (regid) {
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+		switch (kvm_arm_harden_branch_predictor()) {
+		case KVM_BP_HARDEN_UNKNOWN:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
+		case KVM_BP_HARDEN_WA_NEEDED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
+		case KVM_BP_HARDEN_NOT_REQUIRED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED;
+		}
+		return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+		switch (kvm_arm_have_ssbd()) {
+		case KVM_SSBD_FORCE_DISABLE:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
+		case KVM_SSBD_KERNEL:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL;
+		case KVM_SSBD_FORCE_ENABLE:
+		case KVM_SSBD_MITIGATED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
+		case KVM_SSBD_UNKNOWN:
+		default:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN;
+		}
+	}
+
+	return -EINVAL;
+}
+
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
-	if (reg->id == KVM_REG_ARM_PSCI_VERSION) {
-		void __user *uaddr = (void __user *)(long)reg->addr;
-		u64 val;
+	void __user *uaddr = (void __user *)(long)reg->addr;
+	u64 val;
 
+	switch (reg->id) {
+	case KVM_REG_ARM_PSCI_VERSION:
 		val = kvm_psci_version(vcpu, vcpu->kvm);
-		if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
-			return -EFAULT;
+		break;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
+		break;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
 
-		return 0;
+		if (val == KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL &&
+		    kvm_arm_get_vcpu_workaround_2_flag(vcpu))
+			val |= KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED;
+		break;
+	default:
+		return -ENOENT;
 	}
 
-	return -EINVAL;
+	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
 }
 
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
-	if (reg->id == KVM_REG_ARM_PSCI_VERSION) {
-		void __user *uaddr = (void __user *)(long)reg->addr;
-		bool wants_02;
-		u64 val;
+	void __user *uaddr = (void __user *)(long)reg->addr;
+	u64 val;
+	int wa_level;
+
+	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
 
-		if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
-			return -EFAULT;
+	switch (reg->id) {
+	case KVM_REG_ARM_PSCI_VERSION:
+	{
+		bool wants_02;
 
 		wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
 
@@ -501,6 +562,54 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 			vcpu->kvm->arch.psci_version = val;
 			return 0;
 		}
+		break;
+	}
+
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
+			return -EINVAL;
+
+		if (get_kernel_wa_level(reg->id) < val)
+			return -EINVAL;
+
+		return 0;
+
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+		if (val & ~(KVM_REG_FEATURE_LEVEL_MASK |
+			    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
+			return -EINVAL;
+
+		wa_level = val & KVM_REG_FEATURE_LEVEL_MASK;
+
+		if (get_kernel_wa_level(reg->id) < wa_level)
+			return -EINVAL;
+
+		/* The enabled bit must not be set unless the level is AVAIL. */
+		if (wa_level != KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL &&
+		    wa_level != val)
+			return -EINVAL;
+
+		/* Are we finished or do we need to check the enable bit ? */
+		if (kvm_arm_have_ssbd() != KVM_SSBD_KERNEL)
+			return 0;
+
+		/*
+		 * If this kernel supports the workaround to be switched on
+		 * or off, make sure it matches the requested setting.
+		 */
+		switch (wa_level) {
+		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
+			kvm_arm_set_vcpu_workaround_2_flag(vcpu,
+			    val & KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED);
+			break;
+		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
+			kvm_arm_set_vcpu_workaround_2_flag(vcpu, true);
+			break;
+		}
+
+		return 0;
+	default:
+		return -ENOENT;
 	}
 
 	return -EINVAL;
-- 
2.17.1


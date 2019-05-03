Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF5912E14
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfECMqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:04 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60478 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728007AbfECMqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A060F1684;
        Fri,  3 May 2019 05:46:03 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67AAA3F220;
        Fri,  3 May 2019 05:46:00 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 23/56] KVM: arm64/sve: Add pseudo-register for the guest's vector lengths
Date:   Fri,  3 May 2019 13:43:54 +0100
Message-Id: <20190503124427.190206-24-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

This patch adds a new pseudo-register KVM_REG_ARM64_SVE_VLS to
allow userspace to set and query the set of vector lengths visible
to the guest.

In the future, multiple register slices per SVE register may be
visible through the ioctl interface.  Once the set of slices has
been determined we would not be able to allow the vector length set
to be changed any more, in order to avoid userspace seeing
inconsistent sets of registers.  For this reason, this patch adds
support for explicit finalization of the SVE configuration via the
KVM_ARM_VCPU_FINALIZE ioctl.

Finalization is the proper place to allocate the SVE register state
storage in vcpu->arch.sve_state, so this patch adds that as
appropriate.  The data is freed via kvm_arch_vcpu_uninit(), which
was previously a no-op on arm64.

To simplify the logic for determining what vector lengths can be
supported, some code is added to KVM init to work this out, in the
kvm_arm_init_arch_resources() hook.

The KVM_REG_ARM64_SVE_VLS pseudo-register is not exposed yet.
Subsequent patches will allow SVE to be turned on for guest vcpus,
making it visible.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  15 ++--
 arch/arm64/include/uapi/asm/kvm.h |   5 ++
 arch/arm64/kvm/guest.c            | 114 +++++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c            |  89 +++++++++++++++++++++++
 4 files changed, 215 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 98658f7dad68..5475cc4df35c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -23,7 +23,6 @@
 #define __ARM64_KVM_HOST_H__
 
 #include <linux/bitmap.h>
-#include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
 #include <linux/kvm_types.h>
@@ -50,6 +49,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
+/* Will be incremented when KVM_ARM_VCPU_SVE is fully implemented: */
 #define KVM_VCPU_MAX_FEATURES 4
 
 #define KVM_REQ_SLEEP \
@@ -59,10 +59,12 @@
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
-static inline int kvm_arm_init_arch_resources(void) { return 0; }
+extern unsigned int kvm_sve_max_vl;
+int kvm_arm_init_arch_resources(void);
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
 int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
@@ -353,6 +355,7 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
 #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
 #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
+#define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() && \
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
@@ -525,7 +528,6 @@ static inline bool kvm_arch_requires_vhe(void)
 
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
@@ -626,7 +628,10 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 
-#define kvm_arm_vcpu_finalize(vcpu, what) (-EINVAL)
-#define kvm_arm_vcpu_is_finalized(vcpu) true
+int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int what);
+bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
+
+#define kvm_arm_vcpu_sve_finalized(vcpu) \
+	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ced760cc8478..6963b7e8062b 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -102,6 +102,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
 #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
+#define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -243,6 +244,10 @@ struct kvm_vcpu_events {
 					 ((n) << 5) | (i))
 #define KVM_REG_ARM64_SVE_FFR(i)	KVM_REG_ARM64_SVE_PREG(16, i)
 
+/* Vector lengths pseudo-register: */
+#define KVM_REG_ARM64_SVE_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
+					 KVM_REG_SIZE_U512 | 0xffff)
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2aa80a59e2a2..086ab0508d69 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -206,6 +206,73 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return err;
 }
 
+#define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
+#define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
+
+static bool vq_present(
+	const u64 (*const vqs)[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)],
+	unsigned int vq)
+{
+	return (*vqs)[vq_word(vq)] & vq_mask(vq);
+}
+
+static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	unsigned int max_vq, vq;
+	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
+
+	if (WARN_ON(!sve_vl_valid(vcpu->arch.sve_max_vl)))
+		return -EINVAL;
+
+	memset(vqs, 0, sizeof(vqs));
+
+	max_vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
+	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
+		if (sve_vq_available(vq))
+			vqs[vq_word(vq)] |= vq_mask(vq);
+
+	if (copy_to_user((void __user *)reg->addr, vqs, sizeof(vqs)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	unsigned int max_vq, vq;
+	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
+
+	if (kvm_arm_vcpu_sve_finalized(vcpu))
+		return -EPERM; /* too late! */
+
+	if (WARN_ON(vcpu->arch.sve_state))
+		return -EINVAL;
+
+	if (copy_from_user(vqs, (const void __user *)reg->addr, sizeof(vqs)))
+		return -EFAULT;
+
+	max_vq = 0;
+	for (vq = SVE_VQ_MIN; vq <= SVE_VQ_MAX; ++vq)
+		if (vq_present(&vqs, vq))
+			max_vq = vq;
+
+	if (max_vq > sve_vq_from_vl(kvm_sve_max_vl))
+		return -EINVAL;
+
+	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
+		if (vq_present(&vqs, vq) != sve_vq_available(vq))
+			return -EINVAL;
+
+	/* Can't run with no vector lengths at all: */
+	if (max_vq < SVE_VQ_MIN)
+		return -EINVAL;
+
+	/* vcpu->arch.sve_state will be alloc'd by kvm_vcpu_finalize_sve() */
+	vcpu->arch.sve_max_vl = sve_vl_from_vq(max_vq);
+
+	return 0;
+}
+
 #define SVE_REG_SLICE_SHIFT	0
 #define SVE_REG_SLICE_BITS	5
 #define SVE_REG_ID_SHIFT	(SVE_REG_SLICE_SHIFT + SVE_REG_SLICE_BITS)
@@ -296,7 +363,19 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	struct sve_state_reg_region region;
 	char __user *uptr = (char __user *)reg->addr;
 
-	if (!vcpu_has_sve(vcpu) || sve_reg_to_region(&region, vcpu, reg))
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
+	/* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */
+	if (reg->id == KVM_REG_ARM64_SVE_VLS)
+		return get_sve_vls(vcpu, reg);
+
+	/* Otherwise, reg is an architectural SVE register... */
+
+	if (!kvm_arm_vcpu_sve_finalized(vcpu))
+		return -EPERM;
+
+	if (sve_reg_to_region(&region, vcpu, reg))
 		return -ENOENT;
 
 	if (copy_to_user(uptr, vcpu->arch.sve_state + region.koffset,
@@ -312,7 +391,19 @@ static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	struct sve_state_reg_region region;
 	const char __user *uptr = (const char __user *)reg->addr;
 
-	if (!vcpu_has_sve(vcpu) || sve_reg_to_region(&region, vcpu, reg))
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
+	/* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */
+	if (reg->id == KVM_REG_ARM64_SVE_VLS)
+		return set_sve_vls(vcpu, reg);
+
+	/* Otherwise, reg is an architectural SVE register... */
+
+	if (!kvm_arm_vcpu_sve_finalized(vcpu))
+		return -EPERM;
+
+	if (sve_reg_to_region(&region, vcpu, reg))
 		return -ENOENT;
 
 	if (copy_from_user(vcpu->arch.sve_state + region.koffset, uptr,
@@ -426,7 +517,11 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 	if (!vcpu_has_sve(vcpu))
 		return 0;
 
-	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */);
+	/* Policed by KVM_GET_REG_LIST: */
+	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
+
+	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
+		+ 1; /* KVM_REG_ARM64_SVE_VLS */
 }
 
 static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
@@ -441,6 +536,19 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 	if (!vcpu_has_sve(vcpu))
 		return 0;
 
+	/* Policed by KVM_GET_REG_LIST: */
+	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
+
+	/*
+	 * Enumerate this first, so that userspace can save/restore in
+	 * the order reported by KVM_GET_REG_LIST:
+	 */
+	reg = KVM_REG_ARM64_SVE_VLS;
+	if (put_user(reg, uindices++))
+		return -EFAULT;
+
+	++num_regs;
+
 	for (i = 0; i < slices; i++) {
 		for (n = 0; n < SVE_NUM_ZREGS; n++) {
 			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f16a5f8ff2b4..e7f9c06fdbbb 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -23,11 +23,14 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/slab.h>
+#include <linux/types.h>
 
 #include <kvm/arm_arch_timer.h>
 
 #include <asm/cpufeature.h>
 #include <asm/cputype.h>
+#include <asm/fpsimd.h>
 #include <asm/ptrace.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
@@ -99,6 +102,92 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+unsigned int kvm_sve_max_vl;
+
+int kvm_arm_init_arch_resources(void)
+{
+	if (system_supports_sve()) {
+		kvm_sve_max_vl = sve_max_virtualisable_vl;
+
+		/*
+		 * The get_sve_reg()/set_sve_reg() ioctl interface will need
+		 * to be extended with multiple register slice support in
+		 * order to support vector lengths greater than
+		 * SVE_VL_ARCH_MAX:
+		 */
+		if (WARN_ON(kvm_sve_max_vl > SVE_VL_ARCH_MAX))
+			kvm_sve_max_vl = SVE_VL_ARCH_MAX;
+
+		/*
+		 * Don't even try to make use of vector lengths that
+		 * aren't available on all CPUs, for now:
+		 */
+		if (kvm_sve_max_vl < sve_max_vl)
+			pr_warn("KVM: SVE vector length for guests limited to %u bytes\n",
+				kvm_sve_max_vl);
+	}
+
+	return 0;
+}
+
+/*
+ * Finalize vcpu's maximum SVE vector length, allocating
+ * vcpu->arch.sve_state as necessary.
+ */
+static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
+{
+	void *buf;
+	unsigned int vl;
+
+	vl = vcpu->arch.sve_max_vl;
+
+	/*
+	 * Resposibility for these properties is shared between
+	 * kvm_arm_init_arch_resources(), kvm_vcpu_enable_sve() and
+	 * set_sve_vls().  Double-check here just to be sure:
+	 */
+	if (WARN_ON(!sve_vl_valid(vl) || vl > sve_max_virtualisable_vl ||
+		    vl > SVE_VL_ARCH_MAX))
+		return -EIO;
+
+	buf = kzalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl)), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	vcpu->arch.sve_state = buf;
+	vcpu->arch.flags |= KVM_ARM64_VCPU_SVE_FINALIZED;
+	return 0;
+}
+
+int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int what)
+{
+	switch (what) {
+	case KVM_ARM_VCPU_SVE:
+		if (!vcpu_has_sve(vcpu))
+			return -EINVAL;
+
+		if (kvm_arm_vcpu_sve_finalized(vcpu))
+			return -EPERM;
+
+		return kvm_vcpu_finalize_sve(vcpu);
+	}
+
+	return -EINVAL;
+}
+
+bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
+		return false;
+
+	return true;
+}
+
+void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+	kfree(vcpu->arch.sve_state);
+}
+
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
-- 
2.20.1


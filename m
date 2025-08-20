Return-Path: <kvm+bounces-55152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B9114B2E028
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0929D7BF502
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B056335BAF;
	Wed, 20 Aug 2025 14:58:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 035F3321F4F;
	Wed, 20 Aug 2025 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701893; cv=none; b=QZ9g29jBVawIiEKdY4ZfHfXBd0xcCtoaOGEWrwuFcXX1usj0Qt4vPxjS6ZybKFGNSmRvxWRa4s5Fs8UxiRy2eSC2tsjo0d2yyff44dgg3UN+cg6E1ubd6+KkiWoHXcacWdWygt6XjzdGDnFRxG/21ioZiwDfcQDSjEyJhbkd9pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701893; c=relaxed/simple;
	bh=pgoXdcIfge7GJddR3+V3TLB5SSm7c+150y/O/Akv1gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYKvQkm6BbV8K1aDnbN6HyRxVWBvO12R86Fr2oXkG4IkZv+uVP00FlyNNaYC6h8Xg0v+Jy8/C4BsMhQhvXZgzf52An5FPdcXkY7OLHOBy7Vg1rzCB0oysPXA3Tl6emZ0jtDG2tXFqg5MA0LuJhl9l00q+TaOG0yrzq1lVHSXqvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33FCB1D31;
	Wed, 20 Aug 2025 07:58:03 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.2.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8712F3F738;
	Wed, 20 Aug 2025 07:58:05 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v10 13/43] arm64: RME: Support for the VGIC in realms
Date: Wed, 20 Aug 2025 15:55:33 +0100
Message-ID: <20250820145606.180644-14-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820145606.180644-1-steven.price@arm.com>
References: <20250820145606.180644-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM provides emulation of a VGIC to the realm guest but delegates
much of the handling to the host. Implement support in KVM for
saving/restoring state to/from the REC structure.

Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
Changes from v9:
 * Copy gicv3_vmcr from the RMM at the same time as gicv3_hcr rather
   than having to handle that as a special case.
Changes from v8:
 * Propagate gicv3_hcr to from the RMM.
Changes from v5:
 * Handle RMM providing fewer GIC LRs than the hardware supports.
---
 arch/arm64/include/asm/kvm_rme.h |  1 +
 arch/arm64/kvm/arm.c             | 16 ++++++++--
 arch/arm64/kvm/rme.c             |  5 ++++
 arch/arm64/kvm/vgic/vgic-init.c  |  2 +-
 arch/arm64/kvm/vgic/vgic.c       | 50 ++++++++++++++++++++++++++++++--
 5 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 5a0b6a06ebe8..0d2256e4bee4 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -88,6 +88,7 @@ struct realm_rec {
 
 void kvm_init_rme(void);
 u32 kvm_realm_ipa_limit(void);
+u32 kvm_realm_vgic_nr_lr(void);
 
 int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int kvm_init_realm_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 959c363230e2..8d7f4421d8fc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -697,19 +697,24 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
 	}
 
+	kvm_timer_vcpu_put(vcpu);
+	kvm_vgic_put(vcpu);
+
+	vcpu->cpu = -1;
+
+	if (vcpu_is_rec(vcpu))
+		return;
+
 	kvm_vcpu_put_debug(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
 		kvm_vcpu_put_vhe(vcpu);
-	kvm_timer_vcpu_put(vcpu);
-	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_put_hw_mmu(vcpu);
 	kvm_arm_vmid_clear_active();
 
 	vcpu_clear_on_unsupported_cpu(vcpu);
-	vcpu->cpu = -1;
 }
 
 static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
@@ -927,6 +932,11 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
+	if (!irqchip_in_kernel(kvm) && kvm_is_realm(vcpu->kvm)) {
+		/* Userspace irqchip not yet supported with Realms */
+		return -EOPNOTSUPP;
+	}
+
 	mutex_lock(&kvm->arch.config_lock);
 	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
 	mutex_unlock(&kvm->arch.config_lock);
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 893650443604..22d34c39cd5c 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -77,6 +77,11 @@ u32 kvm_realm_ipa_limit(void)
 	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
 }
 
+u32 kvm_realm_vgic_nr_lr(void)
+{
+	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
+}
+
 static int get_start_level(struct realm *realm)
 {
 	/*
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 1e680ad6e863..e0531037f428 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -81,7 +81,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	 * the proper checks already.
 	 */
 	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 &&
-		!kvm_vgic_global_state.can_emulate_gicv2)
+	    (!kvm_vgic_global_state.can_emulate_gicv2 || kvm_is_realm(kvm)))
 		return -ENODEV;
 
 	/*
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index b70bff9a624f..c6f5c30005f9 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -10,7 +10,9 @@
 #include <linux/list_sort.h>
 #include <linux/nospec.h>
 
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_rme.h>
 
 #include "vgic.h"
 
@@ -23,6 +25,8 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
 
 static inline int kvm_vcpu_vgic_nr_lr(struct kvm_vcpu *vcpu)
 {
+	if (unlikely(vcpu_is_rec(vcpu)))
+		return kvm_realm_vgic_nr_lr();
 	return kvm_vgic_global_state.nr_lr;
 }
 
@@ -864,10 +868,26 @@ static inline bool can_access_vgic_from_kernel(void)
 	return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) || has_vhe();
 }
 
+static inline void vgic_rmm_save_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	int i;
+
+	for (i = 0; i < kvm_vcpu_vgic_nr_lr(vcpu); i++) {
+		cpu_if->vgic_lr[i] = vcpu->arch.rec.run->exit.gicv3_lrs[i];
+		vcpu->arch.rec.run->enter.gicv3_lrs[i] = 0;
+	}
+
+	cpu_if->vgic_hcr = vcpu->arch.rec.run->exit.gicv3_hcr;
+	cpu_if->vgic_vmcr = vcpu->arch.rec.run->exit.gicv3_vmcr;
+}
+
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 {
 	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_save_state(vcpu);
+	else if (vcpu_is_rec(vcpu))
+		vgic_rmm_save_state(vcpu);
 	else
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
@@ -903,10 +923,30 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	vgic_prune_ap_list(vcpu);
 }
 
+static inline void vgic_rmm_restore_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	int i;
+
+	for (i = 0; i < kvm_vcpu_vgic_nr_lr(vcpu); i++) {
+		vcpu->arch.rec.run->enter.gicv3_lrs[i] = cpu_if->vgic_lr[i];
+		/*
+		 * Also populate the rec.run->exit copies so that a late
+		 * decision to back out from entering the realm doesn't cause
+		 * the state to be lost
+		 */
+		vcpu->arch.rec.run->exit.gicv3_lrs[i] = cpu_if->vgic_lr[i];
+	}
+
+	vcpu->arch.rec.run->enter.gicv3_hcr = cpu_if->vgic_hcr & RMI_PERMITTED_GICV3_HCR_BITS;
+}
+
 static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_restore_state(vcpu);
+	else if (vcpu_is_rec(vcpu))
+		vgic_rmm_restore_state(vcpu);
 	else
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
@@ -976,7 +1016,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
+	if (unlikely(vcpu_is_rec(vcpu)))
+		return;
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
+		     !vgic_initialized(vcpu->kvm))) {
 		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 			__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
@@ -990,7 +1033,10 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_put(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
+	if (unlikely(vcpu_is_rec(vcpu)))
+		return;
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
+		     !vgic_initialized(vcpu->kvm))) {
 		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 			__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
-- 
2.43.0



Return-Path: <kvm+bounces-66125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A141CC724E
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BB8330B3A37
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42D3E34B437;
	Wed, 17 Dec 2025 10:12:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20FFC34B40A;
	Wed, 17 Dec 2025 10:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966376; cv=none; b=VYpE37009s7+ZcGwliZyHCKQa6HZ+OL/rL9g5LR7SW4pD6OL4AOBVC+sgz+o5rOTXgiaQs9KtV6Mbi6PFHgidJUElVANR/GTFYTq6tRUFnd7NVPwrJR9V1MkiHI6dcj9y1odr9DbnKJum6fpTKPlrt7vg/WbgqEvBCGtKkx2AFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966376; c=relaxed/simple;
	bh=O4mwhiRG6dO/ECrKUyWmucyryFUYvUFRw2q80bSmZs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6NwmpfORieE14OU7noD+HEzWxLsxWvCt9Ur5a0ObdiyRQ9oDmpOk9K9ChfVmuvVPpDGjbpFKS8S+9qQEb1Qyn0eL+CM2Efv8g+xj0roI2HSyTqEIYxr9EoVB25/CsITBQcBwYgOboGWLez5uomMYDVpl79YE/eUTEaiWV9Aeeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B6DE1688;
	Wed, 17 Dec 2025 02:12:47 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 514B63F73B;
	Wed, 17 Dec 2025 02:12:50 -0800 (PST)
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
Subject: [PATCH v12 14/46] arm64: RMI: Support for the VGIC in realms
Date: Wed, 17 Dec 2025 10:10:51 +0000
Message-ID: <20251217101125.91098-15-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
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
---
Changes from v11:
 * Minor changes to align with the previous patches. Note that the VGIC
   handling will change with RMM v2.0.
Changes from v10:
 * Make sure we sync the VGIC v4 state, and only populate valid lrs from
   the list.
Changes from v9:
 * Copy gicv3_vmcr from the RMM at the same time as gicv3_hcr rather
   than having to handle that as a special case.
Changes from v8:
 * Propagate gicv3_hcr to from the RMM.
Changes from v5:
 * Handle RMM providing fewer GIC LRs than the hardware supports.
---
 arch/arm64/include/asm/kvm_rmi.h |  1 +
 arch/arm64/kvm/arm.c             | 11 +++++--
 arch/arm64/kvm/rmi.c             |  5 ++++
 arch/arm64/kvm/vgic/vgic-init.c  |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c    |  6 ++--
 arch/arm64/kvm/vgic/vgic.c       | 49 +++++++++++++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic.h       |  2 ++
 7 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index dbb4b97d5d42..6190d75cc615 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -87,6 +87,7 @@ struct realm_rec {
 
 void kvm_init_rmi(void);
 u32 kvm_realm_ipa_limit(void);
+u32 kvm_realm_vgic_nr_lr(void);
 
 int kvm_init_realm_vm(struct kvm *kvm);
 int kvm_activate_realm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 512d0ec9de60..66f23b8b3144 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -723,19 +723,24 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
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
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 27ecd7d9f757..275b266c6614 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
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
index dc9f9db31026..bb1a876bf298 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -82,7 +82,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	 * the proper checks already.
 	 */
 	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 &&
-		!kvm_vgic_global_state.can_emulate_gicv2)
+	    (!kvm_vgic_global_state.can_emulate_gicv2 || kvm_is_realm(kvm)))
 		return -ENODEV;
 
 	/*
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index c9ff4f90c975..f01dd30330e3 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -982,10 +982,10 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	if (likely(!is_protected_kvm_enabled()))
+	if (likely(!is_protected_kvm_enabled()) && !vcpu_is_rec(vcpu))
 		kvm_call_hyp(__vgic_v3_restore_vmcr_aprs, cpu_if);
 
-	if (has_vhe())
+	if (has_vhe() && !vcpu_is_rec(vcpu))
 		__vgic_v3_activate_traps(cpu_if);
 
 	WARN_ON(vgic_v4_load(vcpu));
@@ -1004,6 +1004,6 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 		kvm_call_hyp(__vgic_v3_save_aprs, cpu_if);
 	WARN_ON(vgic_v4_put(vcpu));
 
-	if (has_vhe())
+	if (has_vhe() && !vcpu_is_rec(vcpu))
 		__vgic_v3_deactivate_traps(cpu_if);
 }
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 2fdcef3d28d1..b317b2a9815f 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -10,6 +10,7 @@
 #include <linux/list_sort.h>
 #include <linux/nospec.h>
 
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
 #include "vgic.h"
@@ -994,10 +995,26 @@ static inline bool can_access_vgic_from_kernel(void)
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
@@ -1032,10 +1049,30 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *vcpu)
 	local_irq_restore(flags);
 }
 
+static inline void vgic_rmm_restore_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	int i;
+
+	for (i = 0; i < cpu_if->used_lrs; i++) {
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
@@ -1088,8 +1125,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
-		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
+		     !vgic_initialized(vcpu->kvm))) {
+		if (has_vhe() && !vcpu_is_rec(vcpu) &&
+		    static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 			__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
 	}
@@ -1102,8 +1141,10 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_put(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
-		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
+		     !vgic_initialized(vcpu->kvm))) {
+		if (has_vhe() && !vcpu_is_rec(vcpu) &&
+		    static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 			__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 55a1142efc6f..282a9701dea6 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -245,6 +245,8 @@ struct ap_list_summary {
 
 static inline int kvm_vcpu_vgic_nr_lr(struct kvm_vcpu *vcpu)
 {
+	if (unlikely(vcpu_is_rec(vcpu)))
+		return kvm_realm_vgic_nr_lr();
 	return kvm_vgic_global_state.nr_lr;
 }
 
-- 
2.43.0



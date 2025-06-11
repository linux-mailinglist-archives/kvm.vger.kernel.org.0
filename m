Return-Path: <kvm+bounces-49003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E10BAD52C8
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43F0F1E06C0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 769842BE7AA;
	Wed, 11 Jun 2025 10:49:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 282D32BEC53;
	Wed, 11 Jun 2025 10:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749638991; cv=none; b=oq6llcmuWZk2FLIAJNdrMsvUb5KrCPgpk2RTNlGeGVITeCa8IRXraqS6BMOhAXpmaRBt+P2YUBdv7cfJot0eLrEN/xCLsc5WHUINdHpSW6VdafgLPUf0m7IBwuZgbqHmEDEvbNrqpCAydktJF2GJlmdAqyrY+K8j6WJqdl51SdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749638991; c=relaxed/simple;
	bh=e/q+auq9WQ5trbNhAtxqRc7yOPUISDZaSH4Q42bhsj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffBWYAChCJR+2uHhQDWlbsHelbnsJPPa3usxrZdWdH7JSA2QxB8F+7l7QXHPE/VpUGYIrH6QQVgmbIYQd5V1AJr8UGexdye5sNVaD0eLdIqPOKwCWflwM1Z1/vLRcWpeoBgdCUb43GSSPR3DjGSFmeo4STg6fsmRtZDbeacVhDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31C3015A1;
	Wed, 11 Jun 2025 03:49:30 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.67.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AF6C3F673;
	Wed, 11 Jun 2025 03:49:46 -0700 (PDT)
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
	Emi Kisanuki <fj0570is@fujitsu.com>
Subject: [PATCH v9 13/43] arm64: RME: Support for the VGIC in realms
Date: Wed, 11 Jun 2025 11:48:10 +0100
Message-ID: <20250611104844.245235-14-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250611104844.245235-1-steven.price@arm.com>
References: <20250611104844.245235-1-steven.price@arm.com>
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
Changes from v8:
 * Propagate gicv3_hcr to from the RMM.
Changes from v5:
 * Handle RMM providing fewer GIC LRs than the hardware supports.
---
 arch/arm64/include/asm/kvm_rme.h |  1 +
 arch/arm64/kvm/arm.c             | 16 +++++++++--
 arch/arm64/kvm/rme.c             |  5 ++++
 arch/arm64/kvm/vgic/vgic-init.c  |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c    |  6 +++-
 arch/arm64/kvm/vgic/vgic.c       | 49 ++++++++++++++++++++++++++++++--
 6 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index f716b890e484..9bcad6ec5dbb 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -92,6 +92,7 @@ struct realm_rec {
 
 void kvm_init_rme(void);
 u32 kvm_realm_ipa_limit(void);
+u32 kvm_realm_vgic_nr_lr(void);
 
 int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int kvm_init_realm_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7be1bdfc5f0b..0cdcc2ca4a88 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -689,19 +689,24 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
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
@@ -922,6 +927,11 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
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
index f094544592b5..25705da6f153 100644
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
index eb1205654ac8..77b4962ebfb6 100644
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
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b0..c10ad817030d 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -8,9 +8,11 @@
 #include <linux/kvm_host.h>
 #include <linux/string_choices.h>
 #include <kvm/arm_vgic.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_asm.h>
+#include <asm/rmi_smc.h>
 
 #include "vgic.h"
 
@@ -758,7 +760,9 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	if (likely(!is_protected_kvm_enabled()))
+	if (vcpu_is_rec(vcpu))
+		cpu_if->vgic_vmcr = vcpu->arch.rec.run->exit.gicv3_vmcr;
+	else if (likely(!is_protected_kvm_enabled()))
 		kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
 	WARN_ON(vgic_v4_put(vcpu));
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index c7aed48c5668..2908b4610c4e 100644
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
 
@@ -864,10 +868,25 @@ static inline bool can_access_vgic_from_kernel(void)
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
@@ -903,10 +922,30 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
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
@@ -976,7 +1015,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
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
@@ -990,7 +1032,10 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 
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



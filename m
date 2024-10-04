Return-Path: <kvm+bounces-27953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F16D990794
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 17:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91974B27023
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 15:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E3FF21D2A8;
	Fri,  4 Oct 2024 15:29:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F9F821C19F;
	Fri,  4 Oct 2024 15:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728055768; cv=none; b=LmgV/x7KX+kJHKjRSDci0TDWgEuhKxF3KSh6qVr3R8jL1aWgdRBRQJcgi63Cc9PtLo97n53F6fiP7+YOvus/QFPbvdEFfpEekkk2ku0V4kRQjlErpoOusZLcUGtd9NZYK9I0iJsZmVByvJ4+YY8GXyqe99SDLpRWBHjn+iWVLpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728055768; c=relaxed/simple;
	bh=d5IssgbFXnysdZUscyXaSocYmp2Xo6mI8F2zMqN2eLU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EVoFYegfuctZoCfi4DAfwOoALOgCWIkTHmsVAnR+OiQF6bxY8SWX2Izu5MJaqZufhv0hLi2l3D4MWIa8Tw+6THIH+9jGLGfVJZszX276pC0RHbP3MLW3SExz6mgZF5WSN/EUOTe65WJ2HNKdUyzbhZ5ROCfF7MxpzPju1+jZz2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 457991063;
	Fri,  4 Oct 2024 08:29:56 -0700 (PDT)
Received: from e122027.cambridge.arm.com (unknown [10.1.25.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 833ED3F640;
	Fri,  4 Oct 2024 08:29:22 -0700 (PDT)
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v5 15/43] arm64: RME: Support for the VGIC in realms
Date: Fri,  4 Oct 2024 16:27:36 +0100
Message-Id: <20241004152804.72508-16-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241004152804.72508-1-steven.price@arm.com>
References: <20241004152804.72508-1-steven.price@arm.com>
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
v5: More changes to adapt to rebasing.
v3: Changes to adapt to rebasing only.
---
 arch/arm64/kvm/arm.c          | 15 ++++++++++---
 arch/arm64/kvm/vgic/vgic-v3.c |  8 ++++++-
 arch/arm64/kvm/vgic/vgic.c    | 41 +++++++++++++++++++++++++++++++++--
 3 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 87aa3f07fae2..ecce40a35cd0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -687,19 +687,24 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_timer_vcpu_put(vcpu);
+	kvm_vgic_put(vcpu);
+
+	vcpu->cpu = -1;
+
+	if (vcpu_is_rec(vcpu))
+		return;
+
 	kvm_arch_vcpu_put_debug_state_flags(vcpu);
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
@@ -907,6 +912,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	}
 
 	if (!irqchip_in_kernel(kvm)) {
+		/* Userspace irqchip not yet supported with Realms */
+		if (kvm_is_realm(vcpu->kvm))
+			return -EOPNOTSUPP;
+
 		/*
 		 * Tell the rest of the code that there are userspace irqchip
 		 * VMs in the wild.
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b217b256853c..ce782f8524cf 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -7,9 +7,11 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_asm.h>
+#include <asm/rmi_smc.h>
 
 #include "vgic.h"
 
@@ -679,7 +681,8 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 			(unsigned long long)info->vcpu.start);
 	} else if (kvm_get_mode() != KVM_MODE_PROTECTED) {
 		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
-		kvm_vgic_global_state.can_emulate_gicv2 = true;
+		if (!static_branch_unlikely(&kvm_rme_is_available))
+			kvm_vgic_global_state.can_emulate_gicv2 = true;
 		ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
 		if (ret) {
 			kvm_err("Cannot register GICv2 KVM device.\n");
@@ -746,6 +749,9 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	if (vcpu_is_rec(vcpu))
+		cpu_if->vgic_vmcr = vcpu->arch.rec.run->exit.gicv3_vmcr;
+
 	kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
 	WARN_ON(vgic_v4_put(vcpu));
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index f50274fd5581..78bf9840a557 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -10,7 +10,9 @@
 #include <linux/list_sort.h>
 #include <linux/nospec.h>
 
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/rmi_smc.h>
 
 #include "vgic.h"
 
@@ -848,10 +850,23 @@ static inline bool can_access_vgic_from_kernel(void)
 	return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) || has_vhe();
 }
 
+static inline void vgic_rmm_save_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	int i;
+
+	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		cpu_if->vgic_lr[i] = vcpu->arch.rec.run->exit.gicv3_lrs[i];
+		vcpu->arch.rec.run->enter.gicv3_lrs[i] = 0;
+	}
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
@@ -878,10 +893,28 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	vgic_prune_ap_list(vcpu);
 }
 
+static inline void vgic_rmm_restore_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	int i;
+
+	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		vcpu->arch.rec.run->enter.gicv3_lrs[i] = cpu_if->vgic_lr[i];
+		/*
+		 * Also populate the rec.run->exit copies so that a late
+		 * decision to back out from entering the realm doesn't cause
+		 * the state to be lost
+		 */
+		vcpu->arch.rec.run->exit.gicv3_lrs[i] = cpu_if->vgic_lr[i];
+	}
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
@@ -922,7 +955,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
+		     !vgic_initialized(vcpu->kvm)) ||
+	    vcpu_is_rec(vcpu)) {
 		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 			__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
@@ -936,7 +971,9 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_put(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
+		     !vgic_initialized(vcpu->kvm)) ||
+	    vcpu_is_rec(vcpu)) {
 		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 			__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
-- 
2.34.1



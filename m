Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AC125C553
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgICP06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbgICP01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:26:27 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9244A2098B;
        Thu,  3 Sep 2020 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599146785;
        bh=8hk5dvN5QgbcKtLB/YnBZWm60piZDPywsqMa1ZLHOg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MqFoI44aTtBOiDxlcpxaLQXprmwYvbATSASgLh2UE49UK8P1sK6oC1JwdaC0GpNzh
         SZ8iX1gmrohGGUzuIE31eXpjhV2vc6cElJBp1je2JUSs+/X0rB+j7kSEWzBxtsPSHu
         BZ+8zxaVUd2w98dcmhOTrIRSjMesuWWn/uk/PGzI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr84-008vT9-08; Thu, 03 Sep 2020 16:26:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 05/23] KVM: arm64: Move GIC model out of the distributor
Date:   Thu,  3 Sep 2020 16:25:52 +0100
Message-Id: <20200903152610.1078827-6-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to allow more than just GIC implementations in the future,
let's move the GIC model outside of the distributor. This also
allows us to back irqchip_in_kernel() with its own irqchip type
(IRQCHIP_USER), removing another field from the distributor.

New helpers are provided as a convenience.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h     |  2 ++
 arch/arm64/include/asm/kvm_irq.h      | 20 ++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-debug.c      |  5 +++--
 arch/arm64/kvm/vgic/vgic-init.c       | 26 ++++++++++++--------------
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 16 ++++++++++++----
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio.c       | 10 ++++------
 arch/arm64/kvm/vgic/vgic-v3.c         | 20 ++++++++------------
 include/kvm/arm_vgic.h                |  5 -----
 9 files changed, 62 insertions(+), 44 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_irq.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e52c927aade5..f0e30e12b523 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -24,6 +24,7 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_irq.h>
 #include <asm/thread_info.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -98,6 +99,7 @@ struct kvm_arch {
 	int max_vcpus;
 
 	/* Interrupt controller */
+	enum kvm_irqchip_type	irqchip_type;
 	struct vgic_dist	vgic;
 
 	/* Mandated version of PSCI */
diff --git a/arch/arm64/include/asm/kvm_irq.h b/arch/arm64/include/asm/kvm_irq.h
new file mode 100644
index 000000000000..46bffb6026f8
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_irq.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2020 - Google LLC
+ * Author: Marc Zyngier <maz@kernel.org>
+ */
+
+#ifndef __ARM64_KVM_IRQ_H__
+#define __ARM64_KVM_IRQ_H__
+
+enum kvm_irqchip_type {
+	IRQCHIP_USER,		/* Implemented in userspace */
+	IRQCHIP_GICv2,		/* v2 on v2, or v2 on v3 */
+	IRQCHIP_GICv3,		/* v3 on v3 */
+};
+
+#define irqchip_in_kernel(k)	((k)->arch.irqchip_type != IRQCHIP_USER)
+#define irqchip_is_gic_v2(k)	((k)->arch.irqchip_type == IRQCHIP_GICv2)
+#define irqchip_is_gic_v3(k)	((k)->arch.irqchip_type == IRQCHIP_GICv3)
+
+#endif
diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index b13a9e3f99dd..2d19fd55fc7b 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -61,7 +61,7 @@ static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
 
 	iter->nr_cpus = nr_cpus;
 	iter->nr_spis = kvm->arch.vgic.nr_spis;
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+	if (irqchip_is_gic_v3(kvm)) {
 		iter->nr_lpis = vgic_copy_lpi_list(kvm, NULL, &iter->lpi_array);
 		if (iter->nr_lpis < 0)
 			iter->nr_lpis = 0;
@@ -142,7 +142,8 @@ static void vgic_debug_stop(struct seq_file *s, void *v)
 
 static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
 {
-	bool v3 = dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3;
+	struct kvm *kvm = container_of(dist, struct kvm, arch.vgic);
+	bool v3 = irqchip_is_gic_v3(kvm);
 
 	seq_printf(s, "Distributor\n");
 	seq_printf(s, "===========\n");
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 32e32d67a127..8157171b8af3 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -106,8 +106,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		goto out_unlock;
 	}
 
-	kvm->arch.vgic.in_kernel = true;
-	kvm->arch.vgic.vgic_model = type;
+	kvm->arch.irqchip_type = (type == KVM_DEV_TYPE_ARM_VGIC_V2 ?
+				  IRQCHIP_GICv2 : IRQCHIP_GICv3);
 
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
@@ -155,12 +155,12 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu0;
 		kref_init(&irq->refcount);
-		switch (dist->vgic_model) {
-		case KVM_DEV_TYPE_ARM_VGIC_V2:
+		switch (kvm->arch.irqchip_type) {
+		case IRQCHIP_GICv2:
 			irq->targets = 0;
 			irq->group = 0;
 			break;
-		case KVM_DEV_TYPE_ARM_VGIC_V3:
+		case IRQCHIP_GICv3:
 			irq->mpidr = 0;
 			irq->group = 1;
 			break;
@@ -185,7 +185,6 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	int ret = 0;
 	int i;
 
@@ -225,7 +224,7 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	 * If we are creating a VCPU with a GICv3 we must also register the
 	 * KVM io device for the redistributor that belongs to this VCPU.
 	 */
-	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+	if (irqchip_is_gic_v3(vcpu->kvm)) {
 		mutex_lock(&vcpu->kvm->lock);
 		ret = vgic_register_redist_iodev(vcpu);
 		mutex_unlock(&vcpu->kvm->lock);
@@ -278,12 +277,12 @@ int vgic_init(struct kvm *kvm)
 
 		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
 			struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
-			switch (dist->vgic_model) {
-			case KVM_DEV_TYPE_ARM_VGIC_V3:
+			switch (kvm->arch.irqchip_type) {
+			case IRQCHIP_GICv3:
 				irq->group = 1;
 				irq->mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
 				break;
-			case KVM_DEV_TYPE_ARM_VGIC_V2:
+			case IRQCHIP_GICv2:
 				irq->group = 0;
 				irq->targets = 1U << idx;
 				break;
@@ -336,7 +335,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	dist->spis = NULL;
 	dist->nr_spis = 0;
 
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+	if (irqchip_is_gic_v3(kvm)) {
 		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list) {
 			list_del(&rdreg->list);
 			kfree(rdreg);
@@ -402,7 +401,7 @@ int vgic_lazy_init(struct kvm *kvm)
 		 * be explicitly initialized once setup with the respective
 		 * KVM device call.
 		 */
-		if (kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V2)
+		if (!irqchip_is_gic_v2(kvm))
 			return -EBUSY;
 
 		mutex_lock(&kvm->lock);
@@ -425,14 +424,13 @@ int vgic_lazy_init(struct kvm *kvm)
  */
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
-	struct vgic_dist *dist = &kvm->arch.vgic;
 	int ret = 0;
 
 	mutex_lock(&kvm->lock);
 	if (!irqchip_in_kernel(kvm))
 		goto out;
 
-	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+	if (irqchip_is_gic_v2(kvm))
 		ret = vgic_v2_map_resources(kvm);
 	else
 		ret = vgic_v3_map_resources(kvm);
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 44419679f91a..928afb224540 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -31,10 +31,18 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 
 static int vgic_check_type(struct kvm *kvm, int type_needed)
 {
-	if (kvm->arch.vgic.vgic_model != type_needed)
-		return -ENODEV;
-	else
-		return 0;
+	switch (type_needed) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		if (irqchip_is_gic_v2(kvm))
+			return 0;
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		if (irqchip_is_gic_v3(kvm))
+			return 0;
+		break;
+	}
+
+	return -ENODEV;
 }
 
 /**
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5c786b915cd3..6234e1409b4d 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -42,7 +42,7 @@ bool vgic_has_its(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+	if (!irqchip_is_gic_v3(kvm))
 		return false;
 
 	return dist->has_its;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index b2d73fc0d1ef..865f12030ab5 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -263,8 +263,7 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 
 static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
-	return (vgic_irq_is_sgi(irq->intid) &&
-		vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2);
+	return (vgic_irq_is_sgi(irq->intid) && irqchip_is_gic_v2(vcpu->kvm));
 }
 
 void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
@@ -450,7 +449,7 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
  */
 static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
 {
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	if (irqchip_is_gic_v3(vcpu->kvm) ||
 	    intid >= VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_halt_guest(vcpu->kvm);
 }
@@ -458,7 +457,7 @@ static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
 /* See vgic_access_active_prepare */
 static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
 {
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	if (irqchip_is_gic_v3(vcpu->kvm) ||
 	    intid >= VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_resume_guest(vcpu->kvm);
 }
@@ -539,7 +538,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 		 */
 		irq->active = false;
 	} else {
-		u32 model = vcpu->kvm->arch.vgic.vgic_model;
 		u8 active_source;
 
 		irq->active = active;
@@ -557,7 +555,7 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 		 */
 		active_source = (requester_vcpu) ? requester_vcpu->vcpu_id : 0;
 
-		if (model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
+		if (irqchip_is_gic_v2(vcpu->kvm) &&
 		    active && vgic_irq_is_sgi(irq->intid))
 			irq->active_source = active_source;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 76e2d85789ed..c6fdb1222453 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -32,7 +32,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
-	u32 model = vcpu->kvm->arch.vgic.vgic_model;
+	bool is_v3 = irqchip_is_gic_v3(vcpu->kvm);
 	int lr;
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
@@ -48,7 +48,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		cpuid = val & GICH_LR_PHYSID_CPUID;
 		cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
 
-		if (model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		if (is_v3) {
 			intid = val & ICH_LR_VIRTUAL_ID_MASK;
 		} else {
 			intid = val & GICH_LR_VIRTUALID;
@@ -117,12 +117,11 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 /* Requires the irq to be locked already */
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 {
-	u32 model = vcpu->kvm->arch.vgic.vgic_model;
+	bool is_v2 = irqchip_is_gic_v2(vcpu->kvm);
 	u64 val = irq->intid;
 	bool allow_pending = true, is_v2_sgi;
 
-	is_v2_sgi = (vgic_irq_is_sgi(irq->intid) &&
-		     model == KVM_DEV_TYPE_ARM_VGIC_V2);
+	is_v2_sgi = (vgic_irq_is_sgi(irq->intid) && is_v2);
 
 	if (irq->active) {
 		val |= ICH_LR_ACTIVE_BIT;
@@ -163,8 +162,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		if (irq->config == VGIC_CONFIG_EDGE)
 			irq->pending_latch = false;
 
-		if (vgic_irq_is_sgi(irq->intid) &&
-		    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+		if (vgic_irq_is_sgi(irq->intid) && is_v2) {
 			u32 src = ffs(irq->source);
 
 			if (WARN_RATELIMIT(!src, "No SGI source for INTID %d\n",
@@ -205,10 +203,9 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	u32 vmcr;
 
-	if (model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+	if (irqchip_is_gic_v2(vcpu->kvm)) {
 		vmcr = (vmcrp->ackctl << ICH_VMCR_ACK_CTL_SHIFT) &
 			ICH_VMCR_ACK_CTL_MASK;
 		vmcr |= (vmcrp->fiqen << ICH_VMCR_FIQ_EN_SHIFT) &
@@ -235,12 +232,11 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	u32 vmcr;
 
 	vmcr = cpu_if->vgic_vmcr;
 
-	if (model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+	if (irqchip_is_gic_v2(vcpu->kvm)) {
 		vmcrp->ackctl = (vmcr & ICH_VMCR_ACK_CTL_MASK) >>
 			ICH_VMCR_ACK_CTL_SHIFT;
 		vmcrp->fiqen = (vmcr & ICH_VMCR_FIQ_EN_MASK) >>
@@ -285,7 +281,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 	 * Also, we don't support any form of IRQ/FIQ bypass.
 	 * This goes with the spec allowing the value to be RAO/WI.
 	 */
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+	if (irqchip_is_gic_v3(vcpu->kvm)) {
 		vgic_v3->vgic_sre = (ICC_SRE_EL1_DIB |
 				     ICC_SRE_EL1_DFB |
 				     ICC_SRE_EL1_SRE);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a8d8fdcd3723..88461ecfa854 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -201,13 +201,9 @@ struct vgic_redist_region {
 };
 
 struct vgic_dist {
-	bool			in_kernel;
 	bool			ready;
 	bool			initialized;
 
-	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
-	u32			vgic_model;
-
 	/* Implementation revision as reported in the GICD_IIDR */
 	u32			implementation_rev;
 
@@ -361,7 +357,6 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
 void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu);
 
-#define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
 #define vgic_ready(k)		((k)->arch.vgic.ready)
 #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
-- 
2.27.0


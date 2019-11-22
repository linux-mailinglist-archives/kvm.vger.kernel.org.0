Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9EF1077A4
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 19:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfKVSv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 13:51:56 -0500
Received: from foss.arm.com ([217.140.110.172]:51192 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfKVSv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 13:51:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E7D0328;
        Fri, 22 Nov 2019 10:51:54 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 497DD3F6C4;
        Fri, 22 Nov 2019 10:51:53 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <maz@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Subject: [PATCH v2] kvm: arm: VGIC: Fix interrupt group enablement
Date:   Fri, 22 Nov 2019 18:51:42 +0000
Message-Id: <20191122185142.65477-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

this is still a bit rough, and only briefly tested, but I wanted to
hear your opinion on the general approach (using a second list in
addition to the ap_list). Some ugly bits come from the fact that the
two lists are not that different, so we have to consider both of them
at times. This is what I wanted to avoid with just one list that gets
filtered on the fly.
Or I am just stupid and don't see how it can be done properly ;-)

Thanks, Andre

---------------
The GIC specification describes support for two distinct interrupt
groups, which can be enabled independently from each other. At the
moment our VGIC emulation does not really honour this, so using
Group0 interrupts with the GICv3 emulation does not work as expected
at the moment.

Fixing this unfortunately requires more than just to provide storage for
a second bit: So far we were treating the "groupX enable bit" as a
global distributor enable bit, preventing interrupts from being entered
into the list registers at all if the whole thing was disabled.
Now with two separate bits we might need to block one IRQ, while needing
to forward another one, so this neat trick does not work anymore.

We solve this by "parking" interrupts that belong to a disabled group
into a separate list, instead of adding them to our ap_list directly.
This way they don't interfere with their group-enabled siblings, and
we also can quickly inject them once their group gets enabled.

For adding pending, but group-disabled interrupts, we slightly tweak our
oracle to ignore the group-enable status completely. Then, in
vgic_queue_irq_unlock(), we add it to one of the lists, depending on its
group status.

When a group status changes, we just scan the "disabled" list for each
VCPU, and move the IRQs, if needed. Since moving interrupts between lists
is a minefield in our locking-rich environment, we rely on our trusted
vgic_prune_ap_list() buddy to do the heavy lifting: It does almost the
right thing already, but just learns how to move an interrupt that is
not on the right list to the other one.

There is a corresponding kvm-unit-test series to test the FIQ
functionality, since Linux itself won't use this.
This has been tested with Linux (for regressions) and with
kvm-unit-tests, on a GICv2/arm, GICv2/arm64 and GICv3/arm64 machine.

The kvm-unit-tests patches can be found here:
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-November/037853.html
or in the following repo:
https://github.com/Andre-ARM/kvm-unit-tests/commits/gic-group0

This series here can also be found at:
git://linux-arm.org/linux-ap.git

Based on kvmarm/next, commit cd7056ae34af.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9d53f545a3d5..8812b9eec13a 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -29,6 +29,10 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
 
+#define GICD_EnableGrp0		(1U << 0)
+#define GICD_EnableGrp1		(1U << 1)
+#define GICD_EnableGrpMask	(GICD_EnableGrp0 | GICD_EnableGrp1)
+
 #define irq_is_ppi(irq) ((irq) >= VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVATE_IRQS)
 #define irq_is_spi(irq) ((irq) >= VGIC_NR_PRIVATE_IRQS && \
 			 (irq) <= VGIC_MAX_SPI)
@@ -227,8 +231,8 @@ struct vgic_dist {
 		struct list_head rd_regions;
 	};
 
-	/* distributor enabled */
-	bool			enabled;
+	/* bitmask to hold the two group enable bits on the distributor level */
+	u8			groups_enable;
 
 	struct vgic_irq		*spis;
 
@@ -308,6 +312,12 @@ struct vgic_cpu {
 	 * VCPU.
 	 */
 	struct list_head ap_list_head;
+	/*
+	 * List of IRQs that could be injected to this VCPU, but have their
+	 * group disabled. We park them here to easily inject all of them
+	 * at once when the group gets enabled.
+	 */
+	struct list_head disabled_grp_list_head;
 
 	/*
 	 * Members below are used with GICv3 emulation only and represent
diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
index cc12fe9b2df3..8845630fa3e4 100644
--- a/virt/kvm/arm/vgic/vgic-debug.c
+++ b/virt/kvm/arm/vgic/vgic-debug.c
@@ -150,7 +150,10 @@ static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
 	seq_printf(s, "nr_spis:\t%d\n", dist->nr_spis);
 	if (v3)
 		seq_printf(s, "nr_lpis:\t%d\n", dist->lpi_list_count);
-	seq_printf(s, "enabled:\t%d\n", dist->enabled);
+	seq_printf(s, "group 0 enabled:\t%d\n",
+		   !!(dist->groups_enable & GICD_EnableGrp0));
+	seq_printf(s, "group 1 enabled:\t%d\n",
+		   !!(dist->groups_enable & GICD_EnableGrp1));
 	seq_printf(s, "\n");
 
 	seq_printf(s, "P=pending_latch, L=line_level, A=active\n");
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index b3c5de48064c..58d40c850e23 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -202,6 +202,7 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	INIT_LIST_HEAD(&vgic_cpu->disabled_grp_list_head);
 	raw_spin_lock_init(&vgic_cpu->ap_list_lock);
 	atomic_set(&vgic_cpu->vgic_v3.its_vpe.vlpi_count, 0);
 
@@ -359,6 +360,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	INIT_LIST_HEAD(&vgic_cpu->disabled_grp_list_head);
 }
 
 /* To be called with kvm->lock held */
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 5945f062d749..8b6fece281f2 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -26,11 +26,14 @@ static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
 {
 	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
-	u32 value;
+	u32 value = 0;
 
 	switch (addr & 0x0c) {
 	case GIC_DIST_CTRL:
-		value = vgic->enabled ? GICD_ENABLE : 0;
+		if (vgic->groups_enable & GICD_EnableGrp0)
+			value |= GICD_EnableGrp0;
+		if (vgic->groups_enable & GICD_EnableGrp1)
+			value |= GICD_EnableGrp1;
 		break;
 	case GIC_DIST_CTR:
 		value = vgic->nr_spis + VGIC_NR_PRIVATE_IRQS;
@@ -42,8 +45,6 @@ static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
 			(vgic->implementation_rev << GICD_IIDR_REVISION_SHIFT) |
 			(IMPLEMENTER_ARM << GICD_IIDR_IMPLEMENTER_SHIFT);
 		break;
-	default:
-		return 0;
 	}
 
 	return value;
@@ -53,14 +54,16 @@ static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
 				    gpa_t addr, unsigned int len,
 				    unsigned long val)
 {
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	bool was_enabled = dist->enabled;
+	struct kvm *kvm = vcpu->kvm;
+	struct vgic_dist *vgic = &kvm->arch.vgic;
 
 	switch (addr & 0x0c) {
 	case GIC_DIST_CTRL:
-		dist->enabled = val & GICD_ENABLE;
-		if (!was_enabled && dist->enabled)
-			vgic_kick_vcpus(vcpu->kvm);
+		vgic->groups_enable = val & GICD_EnableGrpMask;
+
+		/* Check which IRQs need to be forwarded or blocked. */
+		vgic_update_group_enable(kvm);
+
 		break;
 	case GIC_DIST_CTR:
 	case GIC_DIST_IIDR:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 7dfd15dbb308..d7bb95e8b248 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -66,7 +66,9 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 
 	switch (addr & 0x0c) {
 	case GICD_CTLR:
-		if (vgic->enabled)
+		if (vgic->groups_enable & GICD_EnableGrp0)
+			value |= GICD_CTLR_ENABLE_SS_G0;
+                if (vgic->groups_enable & GICD_EnableGrp1)
 			value |= GICD_CTLR_ENABLE_SS_G1;
 		value |= GICD_CTLR_ARE_NS | GICD_CTLR_DS;
 		break;
@@ -85,8 +87,6 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 			(vgic->implementation_rev << GICD_IIDR_REVISION_SHIFT) |
 			(IMPLEMENTER_ARM << GICD_IIDR_IMPLEMENTER_SHIFT);
 		break;
-	default:
-		return 0;
 	}
 
 	return value;
@@ -96,15 +96,16 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 				    gpa_t addr, unsigned int len,
 				    unsigned long val)
 {
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	bool was_enabled = dist->enabled;
+	struct kvm *kvm = vcpu->kvm;
+	struct vgic_dist *vgic = &kvm->arch.vgic;
 
 	switch (addr & 0x0c) {
 	case GICD_CTLR:
-		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
+		vgic->groups_enable = val & GICD_EnableGrpMask;
+
+		/* Check which IRQs need to be forwarded or blocked. */
+		vgic_update_group_enable(kvm);
 
-		if (!was_enabled && dist->enabled)
-			vgic_kick_vcpus(vcpu->kvm);
 		break;
 	case GICD_TYPER:
 	case GICD_IIDR:
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 99b02ca730a8..91d765e46cae 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -148,6 +148,14 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
+static void vgic_remove_irq_from_list(struct vgic_irq *irq)
+{
+	raw_spin_lock(&irq->irq_lock);
+	list_del(&irq->ap_list);
+	irq->vcpu = NULL;
+	raw_spin_unlock(&irq->irq_lock);
+}
+
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
@@ -158,10 +166,15 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		if (irq->intid >= VGIC_MIN_LPI) {
-			raw_spin_lock(&irq->irq_lock);
-			list_del(&irq->ap_list);
-			irq->vcpu = NULL;
-			raw_spin_unlock(&irq->irq_lock);
+			vgic_remove_irq_from_list(irq);
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+	}
+
+	list_for_each_entry_safe(irq, tmp, &vgic_cpu->disabled_grp_list_head,
+				 ap_list) {
+		if (irq->intid >= VGIC_MIN_LPI) {
+			vgic_remove_irq_from_list(irq);
 			vgic_put_irq(vcpu->kvm, irq);
 		}
 	}
@@ -201,6 +214,13 @@ void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active)
 				      active));
 }
 
+static bool vgic_irq_is_grp_enabled(struct kvm *kvm, struct vgic_irq *irq)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	return dist->groups_enable & (1U << irq->group);
+}
+
 /**
  * kvm_vgic_target_oracle - compute the target vcpu for an irq
  *
@@ -223,16 +243,11 @@ static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 	/*
 	 * If the IRQ is not active but enabled and pending, we should direct
 	 * it to its configured target VCPU.
-	 * If the distributor is disabled, pending interrupts shouldn't be
-	 * forwarded.
+	 * The respective interrupt group could be disabled at the distributor
+	 * level, but that needs to be checked by the caller.
 	 */
-	if (irq->enabled && irq_is_pending(irq)) {
-		if (unlikely(irq->target_vcpu &&
-			     !irq->target_vcpu->kvm->arch.vgic.enabled))
-			return NULL;
-
+	if (irq->enabled && irq_is_pending(irq))
 		return irq->target_vcpu;
-	}
 
 	/* If neither active nor pending and enabled, then this IRQ should not
 	 * be queued to any VCPU.
@@ -323,6 +338,17 @@ static bool vgic_validate_injection(struct vgic_irq *irq, bool level, void *owne
 	return false;
 }
 
+static void vgic_irq_add_to_vcpu(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	if (vgic_irq_is_grp_enabled(kvm, irq))
+		list_add_tail(&irq->ap_list, &vgic_cpu->ap_list_head);
+	else
+		list_add_tail(&irq->ap_list, &vgic_cpu->disabled_grp_list_head);
+}
+
 /*
  * Check whether an IRQ needs to (and can) be queued to a VCPU's ap list.
  * Do the queuing if necessary, taking the right locks in the right order.
@@ -405,7 +431,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 	 * now in the ap_list.
 	 */
 	vgic_get_irq_kref(irq);
-	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
+	vgic_irq_add_to_vcpu(vcpu, irq);
 	irq->vcpu = vcpu;
 
 	raw_spin_unlock(&irq->irq_lock);
@@ -608,14 +634,18 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
 }
 
 /**
- * vgic_prune_ap_list - Remove non-relevant interrupts from the list
+ * vgic_prune_ap_list - Remove non-relevant interrupts from a list
  *
  * @vcpu: The VCPU pointer
+ * @head: The list_head to iterate over.
  *
- * Go over the list of "interesting" interrupts, and prune those that we
- * won't have to consider in the near future.
+ * Go over a list of interrupts (ap_list or grp_disabled_list), and prune
+ * those that we won't have to consider in the near future, because:
+ * - they are no longer pending or enabled
+ * - their group-enabled status does not match the list
+ * - their target VCPU has changed and they need to be moved to another VCPU
  */
-static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
+static void vgic_prune_ap_list(struct kvm_vcpu *vcpu, struct list_head *head)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq, *tmp;
@@ -625,7 +655,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 retry:
 	raw_spin_lock(&vgic_cpu->ap_list_lock);
 
-	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
+	list_for_each_entry_safe(irq, tmp, head, ap_list) {
 		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
 		bool target_vcpu_needs_kick = false;
 
@@ -656,7 +686,25 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		}
 
 		if (target_vcpu == vcpu) {
-			/* We're on the right CPU */
+			bool grp_en = vgic_irq_is_grp_enabled(vcpu->kvm, irq);
+
+			/*
+			 * We're on the right CPU.
+			 * Check now that the group-enabled status matches
+			 * the list we are looking at, and move the IRQ
+			 * to the respective other list if it doesn't.
+			 */
+			if (head == &vgic_cpu->ap_list_head && !grp_en) {
+				list_del(&irq->ap_list);
+				list_add_tail(&irq->ap_list,
+					      &vgic_cpu->disabled_grp_list_head);
+			}
+			if (head == &vgic_cpu->disabled_grp_list_head &&
+			    grp_en) {
+				list_del(&irq->ap_list);
+				list_add_tail(&irq->ap_list,
+					      &vgic_cpu->ap_list_head);
+			}
 			raw_spin_unlock(&irq->irq_lock);
 			continue;
 		}
@@ -693,11 +741,9 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		 * changed, so we restart from the beginning.
 		 */
 		if (target_vcpu == vgic_target_oracle(irq)) {
-			struct vgic_cpu *new_cpu = &target_vcpu->arch.vgic_cpu;
-
 			list_del(&irq->ap_list);
 			irq->vcpu = target_vcpu;
-			list_add_tail(&irq->ap_list, &new_cpu->ap_list_head);
+			vgic_irq_add_to_vcpu(target_vcpu, irq);
 			target_vcpu_needs_kick = true;
 		}
 
@@ -716,6 +762,41 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 	raw_spin_unlock(&vgic_cpu->ap_list_lock);
 }
 
+/*
+ * Called when the group enable status at the distributor level could
+ * have changed:
+ * For each VCPU, let vgic_prune_ap_list clean up our grp_disabled list,
+ * which also moves now group-enabled IRQs to the actual ap_list.
+ */
+void vgic_update_group_enable(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int cpuid;
+
+	kvm_for_each_vcpu(cpuid, vcpu, kvm) {
+		struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+		/*
+		 * vgic_prune_ap_list does the heavy lifting for us:
+		 * - removing any no longer pending or enabled IRQs
+		 * - moving IRQs which got their target VCPU changed
+		 * - moving now group-enabled IRQs to the ap_list
+		 * Note: vgic_prune_ap_list() is called during guest exit,
+		 * where IRQs are disabled. Since it relies on this, we
+		 * have to do the same here.
+		 */
+		local_irq_disable();
+		vgic_prune_ap_list(vcpu, &vgic_cpu->disabled_grp_list_head);
+		local_irq_enable();
+
+		/* Now check if there are any new IRQs to consider. */
+		if (kvm_vgic_vcpu_pending_irq(vcpu)) {
+			kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+			kvm_vcpu_kick(vcpu);
+		}
+	}
+}
+
 static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vgic_global_state.type == VGIC_V2)
@@ -810,7 +891,13 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 			break;
 		}
 
-		if (likely(vgic_target_oracle(irq) == vcpu)) {
+		/*
+		 * It the IRQ is still pending on this VCPU, and its
+		 * configured interrupt group is enabled,
+		 * populate a list register with its data.
+		 */
+		if (likely(vgic_target_oracle(irq) == vcpu) &&
+		    vgic_irq_is_grp_enabled(vcpu->kvm, irq)) {
 			vgic_populate_lr(vcpu, irq, count++);
 
 			if (irq->source)
@@ -858,7 +945,7 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
 	/* An empty ap_list_head implies used_lrs == 0 */
-	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
+	if (list_empty(&vgic_cpu->ap_list_head))
 		return;
 
 	if (can_access_vgic_from_kernel())
@@ -866,7 +953,7 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 
 	if (vgic_cpu->used_lrs)
 		vgic_fold_lr_state(vcpu);
-	vgic_prune_ap_list(vcpu);
+	vgic_prune_ap_list(vcpu, &vgic_cpu->ap_list_head);
 }
 
 static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
@@ -949,7 +1036,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
 
-	if (!vcpu->kvm->arch.vgic.enabled)
+	if (!vcpu->kvm->arch.vgic.groups_enable)
 		return false;
 
 	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c7fefd6b1c80..6c3d594de665 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -169,6 +169,8 @@ void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 			   unsigned long flags);
 void vgic_kick_vcpus(struct kvm *kvm);
+void vgic_update_group_enable(struct kvm *kvm);
+
 
 int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 		      phys_addr_t addr, phys_addr_t alignment);
-- 
2.17.1


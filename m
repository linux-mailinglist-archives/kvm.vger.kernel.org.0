Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB10825C5D1
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgICPzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbgICPzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:55:53 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B013F206EB;
        Thu,  3 Sep 2020 15:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599148552;
        bh=aNvBX7+Jljmjdh+CHU7/hx7wbOBWDbXatqazXXJSvAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqpRcPQisoNKI0gVqOggjtNQmLynd8+tjfKG9uUADfE5tsq0FY9PQ13mwDM1cEwox
         48Xij+eNzDjh0i4KLCPw9MVl0UVjHb+6VvBQZU2I6bj/rWr/md3j5mJeu3lTGfI2pT
         z64fSaN4FFDkMSc+ygwazOr3aaj65p+5Ow+nRSH8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr8C-008vT9-E5; Thu, 03 Sep 2020 16:26:32 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 19/23] KVM: arm64: Turn vgic_initialized into irqchip_finalized
Date:   Thu,  3 Sep 2020 16:26:06 +0100
Message-Id: <20200903152610.1078827-20-maz@kernel.org>
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

As we aim to make the core KVM/arm64 code GIC-agnostic, let's
turn vgic_initialized into something more generic, and move the
corresponding flag outside of the vgic data structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h     |  1 +
 arch/arm64/include/asm/kvm_irq.h      |  2 ++
 arch/arm64/kvm/arch_timer.c           |  2 +-
 arch/arm64/kvm/arm.c                  |  4 ++--
 arch/arm64/kvm/pmu-emul.c             |  2 +-
 arch/arm64/kvm/vgic/vgic-debug.c      |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c       | 10 +++++-----
 arch/arm64/kvm/vgic/vgic-irqfd.c      |  2 +-
 arch/arm64/kvm/vgic/vgic-its.c        |  2 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c         |  2 +-
 arch/arm64/kvm/vgic/vgic.c            | 10 +++++-----
 include/kvm/arm_vgic.h                |  2 --
 13 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 52b502f3076f..5dd92873d40f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -100,6 +100,7 @@ struct kvm_arch {
 
 	/* Interrupt controller */
 	enum kvm_irqchip_type	irqchip_type;
+	bool			irqchip_finalized;
 	struct kvm_irqchip_flow	irqchip_flow;
 	struct vgic_dist	vgic;
 
diff --git a/arch/arm64/include/asm/kvm_irq.h b/arch/arm64/include/asm/kvm_irq.h
index d1fc86b54f2d..649b7d4c7e9f 100644
--- a/arch/arm64/include/asm/kvm_irq.h
+++ b/arch/arm64/include/asm/kvm_irq.h
@@ -17,6 +17,8 @@ enum kvm_irqchip_type {
 #define irqchip_is_gic_v2(k)	((k)->arch.irqchip_type == IRQCHIP_GICv2)
 #define irqchip_is_gic_v3(k)	((k)->arch.irqchip_type == IRQCHIP_GICv3)
 
+#define irqchip_finalized(k)	((k)->arch.irqchip_finalized)
+
 struct kvm_irqchip_flow {
 	void (*irqchip_destroy)(struct kvm *);
 	int  (*irqchip_vcpu_init)(struct kvm_vcpu *);
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 706fd0c63273..9b84eb145ccd 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1129,7 +1129,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (!irqchip_in_kernel(vcpu->kvm))
 		goto no_vgic;
 
-	if (!vgic_initialized(vcpu->kvm))
+	if (!irqchip_finalized(vcpu->kvm))
 		return -ENODEV;
 
 	if (!timer_irqs_are_valid(vcpu)) {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 139f4154038b..678533871cfa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -235,7 +235,7 @@ void kvm_arch_free_vm(struct kvm *kvm)
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
-	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
+	if (irqchip_in_kernel(kvm) && irqchip_finalized(kvm))
 		return -EBUSY;
 
 	if (id >= kvm->arch.max_vcpus)
@@ -525,7 +525,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 
 bool kvm_arch_intc_initialized(struct kvm *kvm)
 {
-	return vgic_initialized(kvm);
+	return (irqchip_in_kernel(kvm) && irqchip_finalized(kvm));
 }
 
 void kvm_arm_halt_guest(struct kvm *kvm)
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index d87f71845a64..2ab3b5288503 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -752,7 +752,7 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 		 * implementation, we require the GIC to be already
 		 * initialized when initializing the PMU.
 		 */
-		if (!vgic_initialized(vcpu->kvm))
+		if (!irqchip_finalized(vcpu->kvm))
 			return -ENODEV;
 
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 2d19fd55fc7b..feaccf41e33a 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -241,7 +241,7 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 		return 0;
 	}
 
-	if (!kvm->arch.vgic.initialized)
+	if (!irqchip_finalized(kvm))
 		return 0;
 
 	if (iter->vcpu_id < iter->nr_cpus)
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 6ace624b439d..a3e0389617a3 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -278,7 +278,7 @@ static void kvm_vgic_vcpu_enable(struct kvm_vcpu *vcpu)
  * - the number of vcpus
  * The function is generally called when nr_spis has been explicitly set
  * by the guest through the KVM DEVICE API. If not nr_spis is set to 256.
- * vgic_initialized() returns true when this function has succeeded.
+ * irqchip_finalized() returns true when this function has succeeded.
  * Must be called with kvm->lock held!
  */
 int vgic_init(struct kvm *kvm)
@@ -287,7 +287,7 @@ int vgic_init(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	int ret = 0, i, idx;
 
-	if (vgic_initialized(kvm))
+	if (irqchip_finalized(kvm))
 		return 0;
 
 	/* Are we also in the middle of creating a VCPU? */
@@ -348,7 +348,7 @@ int vgic_init(struct kvm *kvm)
 	vgic_debug_init(kvm);
 
 	dist->implementation_rev = 2;
-	dist->initialized = true;
+	kvm->arch.irqchip_finalized = true;
 
 out:
 	return ret;
@@ -359,8 +359,8 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_redist_region *rdreg, *next;
 
+	kvm->arch.irqchip_finalized = false;
 	dist->ready = false;
-	dist->initialized = false;
 
 	kfree(dist->spis);
 	dist->spis = NULL;
@@ -425,7 +425,7 @@ int vgic_lazy_init(struct kvm *kvm)
 {
 	int ret = 0;
 
-	if (unlikely(!vgic_initialized(kvm))) {
+	if (unlikely(!irqchip_finalized(kvm))) {
 		/*
 		 * We only provide the automatic initialization of the VGIC
 		 * for the legacy case of a GICv2. Any other type must
diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index 79f8899b234c..dbece60c8dc0 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -124,7 +124,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 		 * Injecting SPIs is always possible in atomic context
 		 * as long as the damn vgic is initialized.
 		 */
-		if (unlikely(!vgic_initialized(kvm)))
+		if (unlikely(!irqchip_finalized(kvm)))
 			break;
 		return vgic_irqfd_set_irq(e, kvm, irq_source_id, 1, line_status);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 40cbaca81333..5e715f71991d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1892,7 +1892,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	if (!its)
 		return -ENOMEM;
 
-	if (vgic_initialized(dev->kvm)) {
+	if (irqchip_finalized(dev->kvm)) {
 		int ret = vgic_v4_init(dev->kvm);
 		if (ret < 0) {
 			kfree(its);
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 928afb224540..20654f318646 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -532,7 +532,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
-	if (unlikely(!vgic_initialized(dev->kvm))) {
+	if (unlikely(!irqchip_finalized(dev->kvm))) {
 		ret = -EBUSY;
 		goto out;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index d176ad9bab85..938b73f3f8bf 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -522,7 +522,7 @@ int vgic_v3_map_resources(struct kvm *kvm)
 	 * For a VGICv3 we require the userland to explicitly initialize
 	 * the VGIC before we need to use it.
 	 */
-	if (!vgic_initialized(kvm)) {
+	if (!irqchip_finalized(kvm)) {
 		ret = -EBUSY;
 		goto out;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d676c010e45f..9cbbc24f8a95 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -577,7 +577,7 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
 	struct vgic_irq *irq;
 	unsigned long flags;
 
-	if (!vgic_initialized(vcpu->kvm))
+	if (!irqchip_finalized(vcpu->kvm))
 		return -EAGAIN;
 
 	irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
@@ -607,7 +607,7 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
 	unsigned long flags;
 	int ret = 0;
 
-	if (!vgic_initialized(vcpu->kvm))
+	if (!irqchip_finalized(vcpu->kvm))
 		return -EAGAIN;
 
 	/* SGIs and LPIs cannot be wired up to any device */
@@ -937,7 +937,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
+	if (unlikely(!irqchip_finalized(vcpu->kvm)))
 		return;
 
 	if (kvm_vgic_global_state.type == VGIC_V2)
@@ -948,7 +948,7 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_put(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
+	if (unlikely(!irqchip_finalized(vcpu->kvm)))
 		return;
 
 	if (kvm_vgic_global_state.type == VGIC_V2)
@@ -1044,7 +1044,7 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
 	bool map_is_active;
 	unsigned long flags;
 
-	if (!vgic_initialized(vcpu->kvm))
+	if (!irqchip_finalized(vcpu->kvm))
 		return false;
 
 	irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f753110e24f9..cb1f66d373a4 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -202,7 +202,6 @@ struct vgic_redist_region {
 
 struct vgic_dist {
 	bool			ready;
-	bool			initialized;
 
 	/* Implementation revision as reported in the GICD_IIDR */
 	u32			implementation_rev;
@@ -339,7 +338,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type);
 int kvm_vgic_hyp_init(void);
 void kvm_vgic_init_cpu_hardware(void);
 
-#define vgic_initialized(k)	((k)->arch.vgic.initialized)
 #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
 
-- 
2.27.0


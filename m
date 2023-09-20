Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C088A7A8B79
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjITSRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjITSRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:17:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CACD3
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:17:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4947BC433CA;
        Wed, 20 Sep 2023 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695233859;
        bh=AIB7QxR+Q4HuKb9NJ1RA8vuMiL5T1HL4Ldl3zoQwmAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YN4adlYWS/+B04DaLcnOqBQpX2YDwJyMsuBE+Yq6uuvb170buM38/kzrbE3mzbhJi
         Ec1FnNibcKmpzrLBqU6RyXREX1gpoV0roONyl0Me5mJ5bBSHVAJUwNtOoElhwGftCB
         VS+cyr94cDg22ZIAZFUMyBXBXZEZ6bJ3GluYBbElbr9AJ6jxS1NHkGiDPA97MpsZZS
         A3ip3UMBg/zyY545AAqjzsrMW73Y3J9+gC3c4TrY6nQ7QDkkvOTwv9iZxUJUlLrwAi
         Njfrs921291v2NgUGkslnJcSChsHG1/8Qodjbj5Qm9BjCeJZNPbPJUJqDIO+15P6YP
         cQ3HM1oTCpQrg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qj1lY-00Ejx0-Ug;
        Wed, 20 Sep 2023 19:17:37 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 01/11] KVM: arm64: vgic: Make kvm_vgic_inject_irq() take a vcpu pointer
Date:   Wed, 20 Sep 2023 19:17:21 +0100
Message-Id: <20230920181731.2232453-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230920181731.2232453-1-maz@kernel.org>
References: <20230920181731.2232453-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Passing a vcpu_id to kvm_vgic_inject_irq() is silly for two reasons:

- we often confuse vcpu_id and vcpu_idx
- we eventually have to convert it back to a vcpu
- we can't count

Instead, pass a vcpu pointer, which is unambiguous. A NULL vcpu
is also allowed for interrupts that are not private to a vcpu
(such as SPIs).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c      |  2 +-
 arch/arm64/kvm/arm.c             | 20 ++++++++++----------
 arch/arm64/kvm/pmu-emul.c        |  2 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c |  2 +-
 arch/arm64/kvm/vgic/vgic.c       | 12 +++++-------
 include/kvm/arm_vgic.h           |  4 ++--
 6 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6dcdae4d38cb..1f828f3b854c 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -458,7 +458,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 				   timer_ctx->irq.level);
 
 	if (!userspace_irqchip(vcpu->kvm)) {
-		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
+		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 					  timer_irq(timer_ctx),
 					  timer_ctx->irq.level,
 					  timer_ctx);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4866b3f7b4ea..872679a0cbd7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1134,27 +1134,27 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 			  bool line_status)
 {
 	u32 irq = irq_level->irq;
-	unsigned int irq_type, vcpu_idx, irq_num;
+	unsigned int irq_type, vcpu_id, irq_num;
 	int nrcpus = atomic_read(&kvm->online_vcpus);
 	struct kvm_vcpu *vcpu = NULL;
 	bool level = irq_level->level;
 
 	irq_type = (irq >> KVM_ARM_IRQ_TYPE_SHIFT) & KVM_ARM_IRQ_TYPE_MASK;
-	vcpu_idx = (irq >> KVM_ARM_IRQ_VCPU_SHIFT) & KVM_ARM_IRQ_VCPU_MASK;
-	vcpu_idx += ((irq >> KVM_ARM_IRQ_VCPU2_SHIFT) & KVM_ARM_IRQ_VCPU2_MASK) * (KVM_ARM_IRQ_VCPU_MASK + 1);
+	vcpu_id = (irq >> KVM_ARM_IRQ_VCPU_SHIFT) & KVM_ARM_IRQ_VCPU_MASK;
+	vcpu_id += ((irq >> KVM_ARM_IRQ_VCPU2_SHIFT) & KVM_ARM_IRQ_VCPU2_MASK) * (KVM_ARM_IRQ_VCPU_MASK + 1);
 	irq_num = (irq >> KVM_ARM_IRQ_NUM_SHIFT) & KVM_ARM_IRQ_NUM_MASK;
 
-	trace_kvm_irq_line(irq_type, vcpu_idx, irq_num, irq_level->level);
+	trace_kvm_irq_line(irq_type, vcpu_id, irq_num, irq_level->level);
 
 	switch (irq_type) {
 	case KVM_ARM_IRQ_TYPE_CPU:
 		if (irqchip_in_kernel(kvm))
 			return -ENXIO;
 
-		if (vcpu_idx >= nrcpus)
+		if (vcpu_id >= nrcpus)
 			return -EINVAL;
 
-		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
+		vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
 		if (!vcpu)
 			return -EINVAL;
 
@@ -1166,17 +1166,17 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 		if (!irqchip_in_kernel(kvm))
 			return -ENXIO;
 
-		if (vcpu_idx >= nrcpus)
+		if (vcpu_id >= nrcpus)
 			return -EINVAL;
 
-		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
+		vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
 		if (!vcpu)
 			return -EINVAL;
 
 		if (irq_num < VGIC_NR_SGIS || irq_num >= VGIC_NR_PRIVATE_IRQS)
 			return -EINVAL;
 
-		return kvm_vgic_inject_irq(kvm, vcpu->vcpu_id, irq_num, level, NULL);
+		return kvm_vgic_inject_irq(kvm, vcpu, irq_num, level, NULL);
 	case KVM_ARM_IRQ_TYPE_SPI:
 		if (!irqchip_in_kernel(kvm))
 			return -ENXIO;
@@ -1184,7 +1184,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 		if (irq_num < VGIC_NR_PRIVATE_IRQS)
 			return -EINVAL;
 
-		return kvm_vgic_inject_irq(kvm, 0, irq_num, level, NULL);
+		return kvm_vgic_inject_irq(kvm, NULL, irq_num, level, NULL);
 	}
 
 	return -EINVAL;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6b066e04dc5d..3afb281ed8d2 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -348,7 +348,7 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 	pmu->irq_level = overflow;
 
 	if (likely(irqchip_in_kernel(vcpu->kvm))) {
-		int ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
+		int ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 					      pmu->irq_num, overflow, pmu);
 		WARN_ON(ret);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index 475059bacedf..8c711deb25aa 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -23,7 +23,7 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
 
 	if (!vgic_valid_spi(kvm, spi_id))
 		return -EINVAL;
-	return kvm_vgic_inject_irq(kvm, 0, spi_id, level, NULL);
+	return kvm_vgic_inject_irq(kvm, NULL, spi_id, level, NULL);
 }
 
 /**
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 8be4c1ebdec2..db2a95762b1b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -422,7 +422,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 /**
  * kvm_vgic_inject_irq - Inject an IRQ from a device to the vgic
  * @kvm:     The VM structure pointer
- * @cpuid:   The CPU for PPIs
+ * @vcpu:    The CPU for PPIs or NULL for global interrupts
  * @intid:   The INTID to inject a new state to.
  * @level:   Edge-triggered:  true:  to trigger the interrupt
  *			      false: to ignore the call
@@ -436,24 +436,22 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
  * level-sensitive interrupts.  You can think of the level parameter as 1
  * being HIGH and 0 being LOW and all devices being active-HIGH.
  */
-int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
-			bool level, void *owner)
+int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			unsigned int intid, bool level, void *owner)
 {
-	struct kvm_vcpu *vcpu;
 	struct vgic_irq *irq;
 	unsigned long flags;
 	int ret;
 
-	trace_vgic_update_irq_pending(cpuid, intid, level);
-
 	ret = vgic_lazy_init(kvm);
 	if (ret)
 		return ret;
 
-	vcpu = kvm_get_vcpu(kvm, cpuid);
 	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
 		return -EINVAL;
 
+	trace_vgic_update_irq_pending(vcpu ? vcpu->vcpu_idx : 0, intid, level);
+
 	irq = vgic_get_irq(kvm, vcpu, intid);
 	if (!irq)
 		return -EINVAL;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 5b27f94d4fad..8cc38e836f54 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -375,8 +375,8 @@ int kvm_vgic_map_resources(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
 void kvm_vgic_init_cpu_hardware(void);
 
-int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
-			bool level, void *owner);
+int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			unsigned int intid, bool level, void *owner);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 			  u32 vintid, struct irq_ops *ops);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
-- 
2.34.1


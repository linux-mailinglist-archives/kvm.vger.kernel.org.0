Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270C6667F35
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240210AbjALT31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjALT2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:28:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D133DBEF
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:22:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26C52B82018
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0DAC433D2;
        Thu, 12 Jan 2023 19:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551337;
        bh=jQVOc8xvPxiHcJlpCxIGw/9RM3qx0l3+w2yJ3/B4Vvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcqJ2znWj+nBhagNR7fFH5UGThZBvX7uyMJXbM/euHvm8wK5AdLbNLxrFxoIhqJfV
         +TwCdUK8JKABrevNH1lGnZHtigJ5Lpbpkm3vZSryT8vhDO2ad543nm/F5PXVL0S7Qy
         q8/DogmC/gAQvNWB9gw/V/zQmN18LBWekTlAwhEV38W5P6zV+xeIYFeRjw5nBoXj31
         ad5zMvbfDyowm8h+F0BpiVnr1nNrkjVTZtLMOqrOvIsY8/tQsl/5va+KZz3z+uwS/P
         A1fQ5ACwyiDCzp4SathM2KhVkD/6FCILINm+8PiWgPYoXeRN+DtLv6P5pE56koGRjw
         4d3QKHU8+yf8A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG37Q-001IWu-4G;
        Thu, 12 Jan 2023 19:20:08 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 50/68] KVM: arm64: nv: Implement maintenance interrupt forwarding
Date:   Thu, 12 Jan 2023 19:19:09 +0000
Message-Id: <20230112191927.1814989-51-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we take a maintenance interrupt, we need to decide whether
it is generated on an action from the guest, or if it is something
that needs to be forwarded to the guest hypervisor.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c      | 32 ++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 28 ++++++++++++++++++------
 2 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index e61d9ca01768..7366814d78ec 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -6,10 +6,12 @@
 #include <linux/uaccess.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
+#include <linux/irq.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include "vgic.h"
 
 /*
@@ -222,6 +224,16 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return 0;
 
+	if (vcpu_has_nv(vcpu)) {
+		/* Cope with vintage userspace. Maybe we should fail instead */
+		if (vcpu->kvm->arch.vgic.maint_irq == 0)
+			vcpu->kvm->arch.vgic.maint_irq = kvm_vgic_global_state.maint_irq;
+		ret = kvm_vgic_set_owner(vcpu, vcpu->kvm->arch.vgic.maint_irq,
+					 vcpu);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * If we are creating a VCPU with a GICv3 we must also register the
 	 * KVM io device for the redistributor that belongs to this VCPU.
@@ -480,12 +492,23 @@ static int vgic_init_cpu_dying(unsigned int cpu)
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 {
+	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)data;
+
 	/*
 	 * We cannot rely on the vgic maintenance interrupt to be
 	 * delivered synchronously. This means we can only use it to
 	 * exit the VM, and we perform the handling of EOIed
 	 * interrupts on the exit path (see vgic_fold_lr_state).
 	 */
+
+	/* If not nested, deactivate */
+	if (!vcpu || !vgic_state_is_nested(vcpu)) {
+		irq_set_irqchip_state(irq, IRQCHIP_STATE_ACTIVE, false);
+		return IRQ_HANDLED;
+	}
+
+	/* Assume nested from now */
+	vgic_v3_handle_nested_maint_irq(vcpu);
 	return IRQ_HANDLED;
 }
 
@@ -584,6 +607,15 @@ int kvm_vgic_hyp_init(void)
 		return ret;
 	}
 
+	if (has_mask) {
+		ret = irq_set_vcpu_affinity(kvm_vgic_global_state.maint_irq,
+					    kvm_get_running_vcpus());
+		if (ret) {
+			kvm_err("Error setting vcpu affinity\n");
+			goto out_free_irq;
+		}
+	}
+
 	ret = cpuhp_setup_state(CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
 				"kvm/arm/vgic:starting",
 				vgic_init_cpu_starting, vgic_init_cpu_dying);
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index e88c75e79010..755e4819603a 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -175,10 +175,20 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_irq *irq;
+	unsigned long flags;
 
 	vgic_cpu->shadow_vgic_v3 = vgic_cpu->nested_vgic_v3;
 	vgic_v3_create_shadow_lr(vcpu);
 	__vgic_v3_restore_state(vcpu_shadow_if(vcpu));
+
+	irq = vgic_get_irq(vcpu->kvm, vcpu, vcpu->kvm->arch.vgic.maint_irq);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	if (irq->line_level || irq->active)
+		irq_set_irqchip_state(kvm_vgic_global_state.maint_irq,
+				      IRQCHIP_STATE_ACTIVE, true);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	vgic_put_irq(vcpu->kvm, irq);
 }
 
 void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
@@ -193,20 +203,26 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	 */
 	vgic_v3_fixup_shadow_lr_state(vcpu);
 	vgic_cpu->nested_vgic_v3 = vgic_cpu->shadow_vgic_v3;
+	irq_set_irqchip_state(kvm_vgic_global_state.maint_irq,
+			      IRQCHIP_STATE_ACTIVE, false);
 }
 
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
-
 	/*
 	 * If we exit a nested VM with a pending maintenance interrupt from the
 	 * GIC, then we need to forward this to the guest hypervisor so that it
 	 * can re-sync the appropriate LRs and sample level triggered interrupts
 	 * again.
 	 */
-	if (vgic_state_is_nested(vcpu) &&
-	    (cpu_if->vgic_hcr & ICH_HCR_EN) &&
-	    vgic_v3_get_misr(vcpu))
-		kvm_inject_nested_irq(vcpu);
+	if (vgic_state_is_nested(vcpu)) {
+		struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+		bool state;
+
+		state  = cpu_if->vgic_hcr & ICH_HCR_EN;
+		state &= vgic_v3_get_misr(vcpu);
+
+		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
+				    vcpu->kvm->arch.vgic.maint_irq, state, vcpu);
+	}
 }
-- 
2.34.1


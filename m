Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9F57AFF7C
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 11:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjI0JJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 05:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjI0JJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 05:09:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846AECC
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 02:09:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F36C433C9;
        Wed, 27 Sep 2023 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695805759;
        bh=K+tFfLelIwox1keoN0XKV44DfzHUWb6y5oJTZXZ0HsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfZwNgNtyXwGkBUhaFeS33Vfok8E+Gs8AqUG1xNqdzq0xwE4nLhepHf4tGA57HJ7f
         U3QcmIKLqgZr3DaF6fUQNwuC3cuZtLt1BX/MwJMQFksIMU2n/MhFqVjOsFOVymoyck
         Q1imQaDlpgu1t/FRftxWhKlDYyBSr8Xjzql3mx/dbTTsN31Pr2GebiBkQjWLOC7mAE
         swbeEBmbdIVcmSalTFrP4Zz3lEqzw1jugkm14wAnH4x74Q/iozmuo+rOlAOreA3VkN
         24DU0henqZmBnBZ+Q2oNqIo40FQGtqFmzEZVl5z4s0yZFj20k86iQRLtm9sZkMt7/7
         5DPyCR9CHCv/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qlQXk-00GaLb-QV;
        Wed, 27 Sep 2023 10:09:17 +0100
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
Subject: [PATCH v3 03/11] KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
Date:   Wed, 27 Sep 2023 10:09:03 +0100
Message-Id: <20230927090911.3355209-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927090911.3355209-1-maz@kernel.org>
References: <20230927090911.3355209-1-maz@kernel.org>
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

As we're about to change the way SGIs are sent, start by splitting
out some of the basic functionnality: instead of intermingling
the broadcast and non-broadcast cases with the actual SGI generation,
perform the following cleanups:

- move the SGI queuing into its own helper
- split the broadcast code from the affinity-driven code
- replace the mask/shift combinations with FIELD_GET()
- fix the confusion between vcpu_id and vcpu when handling
  the broadcast case

The result is much more readable, and paves the way for further
optimisations.

Tested-by: Joey Gouly <joey.gouly@arm.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 110 ++++++++++++++++-------------
 1 file changed, 59 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 188d2187eede..88b8d4524854 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -1052,6 +1052,38 @@ static int match_mpidr(u64 sgi_aff, u16 sgi_cpu_mask, struct kvm_vcpu *vcpu)
 	((((reg) & ICC_SGI1R_AFFINITY_## level ##_MASK) \
 	>> ICC_SGI1R_AFFINITY_## level ##_SHIFT) << MPIDR_LEVEL_SHIFT(level))
 
+static void vgic_v3_queue_sgi(struct kvm_vcpu *vcpu, u32 sgi, bool allow_group1)
+{
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, sgi);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+	/*
+	 * An access targeting Group0 SGIs can only generate
+	 * those, while an access targeting Group1 SGIs can
+	 * generate interrupts of either group.
+	 */
+	if (!irq->group || allow_group1) {
+		if (!irq->hw) {
+			irq->pending_latch = true;
+			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+		} else {
+			/* HW SGI? Ask the GIC to inject it */
+			int err;
+			err = irq_set_irqchip_state(irq->host_irq,
+						    IRQCHIP_STATE_PENDING,
+						    true);
+			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		}
+	} else {
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	}
+
+	vgic_put_irq(vcpu->kvm, irq);
+}
+
 /**
  * vgic_v3_dispatch_sgi - handle SGI requests from VCPUs
  * @vcpu: The VCPU requesting a SGI
@@ -1070,19 +1102,30 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu *c_vcpu;
-	u16 target_cpus;
+	unsigned long target_cpus;
 	u64 mpidr;
-	int sgi;
-	int vcpu_id = vcpu->vcpu_id;
-	bool broadcast;
-	unsigned long c, flags;
-
-	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
-	broadcast = reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
-	target_cpus = (reg & ICC_SGI1R_TARGET_LIST_MASK) >> ICC_SGI1R_TARGET_LIST_SHIFT;
+	u32 sgi;
+	unsigned long c;
+
+	sgi = FIELD_GET(ICC_SGI1R_SGI_ID_MASK, reg);
+
+	/* Broadcast */
+	if (unlikely(reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT))) {
+		kvm_for_each_vcpu(c, c_vcpu, kvm) {
+			/* Don't signal the calling VCPU */
+			if (c_vcpu == vcpu)
+				continue;
+
+			vgic_v3_queue_sgi(c_vcpu, sgi, allow_group1);
+		}
+
+		return;
+	}
+
 	mpidr = SGI_AFFINITY_LEVEL(reg, 3);
 	mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
 	mpidr |= SGI_AFFINITY_LEVEL(reg, 1);
+	target_cpus = FIELD_GET(ICC_SGI1R_TARGET_LIST_MASK, reg);
 
 	/*
 	 * We iterate over all VCPUs to find the MPIDRs matching the request.
@@ -1091,54 +1134,19 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
 	 * VCPUs when most of the times we just signal a single VCPU.
 	 */
 	kvm_for_each_vcpu(c, c_vcpu, kvm) {
-		struct vgic_irq *irq;
+		int level0;
 
 		/* Exit early if we have dealt with all requested CPUs */
-		if (!broadcast && target_cpus == 0)
+		if (target_cpus == 0)
 			break;
-
-		/* Don't signal the calling VCPU */
-		if (broadcast && c == vcpu_id)
+		level0 = match_mpidr(mpidr, target_cpus, c_vcpu);
+		if (level0 == -1)
 			continue;
 
-		if (!broadcast) {
-			int level0;
-
-			level0 = match_mpidr(mpidr, target_cpus, c_vcpu);
-			if (level0 == -1)
-				continue;
-
-			/* remove this matching VCPU from the mask */
-			target_cpus &= ~BIT(level0);
-		}
+		/* remove this matching VCPU from the mask */
+		target_cpus &= ~BIT(level0);
 
-		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
-
-		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-
-		/*
-		 * An access targeting Group0 SGIs can only generate
-		 * those, while an access targeting Group1 SGIs can
-		 * generate interrupts of either group.
-		 */
-		if (!irq->group || allow_group1) {
-			if (!irq->hw) {
-				irq->pending_latch = true;
-				vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
-			} else {
-				/* HW SGI? Ask the GIC to inject it */
-				int err;
-				err = irq_set_irqchip_state(irq->host_irq,
-							    IRQCHIP_STATE_PENDING,
-							    true);
-				WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
-				raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-			}
-		} else {
-			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-		}
-
-		vgic_put_irq(vcpu->kvm, irq);
+		vgic_v3_queue_sgi(c_vcpu, sgi, allow_group1);
 	}
 }
 
-- 
2.34.1


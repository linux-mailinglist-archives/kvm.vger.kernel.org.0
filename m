Return-Path: <kvm+bounces-62434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EDE6C443D7
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:17:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B16754E7434
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4089B3090F7;
	Sun,  9 Nov 2025 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Di4slc6a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA1A3081B4;
	Sun,  9 Nov 2025 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708593; cv=none; b=rYk10GYSAja4s1hTI07+nYI9J6SdqOLn4add4cCRlmzqbdS/ksH2DktkQ8Atxj1VFJqwXDOzQYz+MnrKyFps1I6GOjtud7coIn+3HDFZH7Bt8830r7ptIuDtDqXFz9mZAXYqUG4U1cH3TeRQCi6cWhdRbXZKKkv/f6wQsAW83lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708593; c=relaxed/simple;
	bh=uw+h/vEuaUFlbwV3M8u51lUEp4ZgeRN3g5Nz2hQastM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETRO08mjLPEXBsrvRwMUSufCC8BtUPPc0Uk9+iHdF7Vv9vqhLiVmK6IvwbOzh3IYsPjl9wAiG+eawFnPXMdClN+yWpdArjBGIuA74kCR0FZUg5Vod3UK3oP4TKeiMvQ/GxbkQfv9Q7MfEmsgCfTBlkKqZkiIlluE6cxnScBhhp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Di4slc6a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4A1C4CEF7;
	Sun,  9 Nov 2025 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708593;
	bh=uw+h/vEuaUFlbwV3M8u51lUEp4ZgeRN3g5Nz2hQastM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Di4slc6ad9g+0yarQ7Brg7YF1nOs5jKchWpfeqPZsiF1X2zchTeHiceULkluDpVUm
	 pfK5n5LErdwo59rpETgKzdBBrrniD63uEluoRpWCJyTcc7xpXQk06OFwNPWO1jtBmW
	 +VAjvdANu+FXSa1paqN5YKa3R5Y/OTiJCeQGJQtK3DEwfvrOuAkWzdWo774K65Gabh
	 V3mfOguQjowZ6ahttDJ2fzO8HRsFX6Huj4hpzxUJ00ZdpOhQTFxl+twEzRfn04CGOi
	 fmuNos44AwY3zXsSkBS+xbfVfnPfCLd5u14cpaHF+mdxNbxN3nwQXS+/LnxXLNQd7T
	 nHLaL0Q02pftQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91j-00000003exw-0JWN;
	Sun, 09 Nov 2025 17:16:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 12/45] KVM: arm64: GICv3: Extract LR folding primitive
Date: Sun,  9 Nov 2025 17:15:46 +0000
Message-ID: <20251109171619.1507205-13-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are going to need to handle deactivation for interrupts that
are not in the LRs, split vgic_v3_fold_lr_state() into a helper
that deals with a single interrupt, and the function that loops
over the used LRs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 88 +++++++++++++++++------------------
 1 file changed, 43 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 3ede79e381513..0fccfe9e3e8dd 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -33,78 +33,76 @@ static bool lr_signals_eoi_mi(u64 lr_val)
 	       !(lr_val & ICH_LR_HW);
 }
 
-void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
+static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
-	u32 model = vcpu->kvm->arch.vgic.vgic_model;
-	int lr;
-
-	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
-
-	cpuif->vgic_hcr &= ~ICH_HCR_EL2_UIE;
-
-	for (lr = 0; lr < cpuif->used_lrs; lr++) {
-		u64 val = cpuif->vgic_lr[lr];
-		u32 intid, cpuid;
-		struct vgic_irq *irq;
-		bool is_v2_sgi = false;
-		bool deactivated;
-
-		cpuid = val & GICH_LR_PHYSID_CPUID;
-		cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
-
-		if (model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-			intid = val & ICH_LR_VIRTUAL_ID_MASK;
-		} else {
-			intid = val & GICH_LR_VIRTUALID;
-			is_v2_sgi = vgic_irq_is_sgi(intid);
-		}
+	struct vgic_irq *irq;
+	bool is_v2_sgi = false;
+	bool deactivated;
+	u32 intid;
 
-		/* Notify fds when the guest EOI'ed a level-triggered IRQ */
-		if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
-			kvm_notify_acked_irq(vcpu->kvm, 0,
-					     intid - VGIC_NR_PRIVATE_IRQS);
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		intid = val & ICH_LR_VIRTUAL_ID_MASK;
+	} else {
+		intid = val & GICH_LR_VIRTUALID;
+		is_v2_sgi = vgic_irq_is_sgi(intid);
+	}
 
-		irq = vgic_get_vcpu_irq(vcpu, intid);
-		if (!irq)	/* An LPI could have been unmapped. */
-			continue;
+	irq = vgic_get_vcpu_irq(vcpu, intid);
+	if (!irq)	/* An LPI could have been unmapped. */
+		return;
 
-		raw_spin_lock(&irq->irq_lock);
+	/* Notify fds when the guest EOI'ed a level-triggered IRQ */
+	if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
+		kvm_notify_acked_irq(vcpu->kvm, 0,
+				     intid - VGIC_NR_PRIVATE_IRQS);
 
+	scoped_guard(raw_spinlock, &irq->irq_lock) {
 		/* Always preserve the active bit for !LPIs, note deactivation */
 		if (irq->intid >= VGIC_MIN_LPI)
 			val &= ~ICH_LR_ACTIVE_BIT;
 		deactivated = irq->active && !(val & ICH_LR_ACTIVE_BIT);
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
 
-		if (irq->active && is_v2_sgi)
-			irq->active_source = cpuid;
-
 		/* Edge is the only case where we preserve the pending bit */
 		if (irq->config == VGIC_CONFIG_EDGE &&
-		    (val & ICH_LR_PENDING_BIT)) {
+		    (val & ICH_LR_PENDING_BIT))
 			irq->pending_latch = true;
 
-			if (is_v2_sgi)
-				irq->source |= (1 << cpuid);
-		}
-
 		/*
 		 * Clear soft pending state when level irqs have been acked.
 		 */
 		if (irq->config == VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
 			irq->pending_latch = false;
 
+		if (is_v2_sgi) {
+			u8 cpuid = FIELD_GET(GICH_LR_PHYSID_CPUID, val);
+
+			if (irq->active)
+				irq->active_source = cpuid;
+
+			if (val & ICH_LR_PENDING_BIT)
+				irq->source |= BIT(cpuid);
+		}
+
 		/* Handle resampling for mapped interrupts if required */
 		vgic_irq_handle_resampling(irq, deactivated, val & ICH_LR_PENDING_BIT);
 
 		irq->on_lr = false;
-
-		raw_spin_unlock(&irq->irq_lock);
-		vgic_put_irq(vcpu->kvm, irq);
 	}
 
+	vgic_put_irq(vcpu->kvm, irq);
+}
+
+void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
+
+	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
+
+	for (int lr = 0; lr < cpuif->used_lrs; lr++)
+		vgic_v3_fold_lr(vcpu, cpuif->vgic_lr[lr]);
+
 	cpuif->used_lrs = 0;
 }
 
-- 
2.47.3



Return-Path: <kvm+bounces-63932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA51C75B66
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:35:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 25BDA35B9C8
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C06374151;
	Thu, 20 Nov 2025 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPeBfkiM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56AC371DDC;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659559; cv=none; b=En8AwQvpAZUkbuNDNE587L8kshUHkfgzl++L+QIUTxswvNqpZU0YEH9IW6LTlVaScZfZMMVCuE2vMLpT2vp6B+VXA81DYTQ8K/EbbXi8EB+Q7bKvJxr7xtVkFOfBJQbLHYw00icFVTgTjNNHDeR31zIDmkNmYqtfZ15Xz7qZICM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659559; c=relaxed/simple;
	bh=vLlPo3Zk09/KBtF1mv1AED7DUfgLhllH0ekiQOicv9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbR4+yXb19DvqSS1ARz+M4LjMvdBANb7vxpA2mXOzOauQvrjRDM4YuIPy8HvdRUFZHVCkmMqF28RBWT3YyejNUb1CXWfAXbAq2EKi0ZFm1jnqE9o5mPGU/mZXYpcfJycDhhZqxCU/mFlmRnamX59tVwReHN4otR+ENhXPoCTV8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPeBfkiM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B751AC19421;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659559;
	bh=vLlPo3Zk09/KBtF1mv1AED7DUfgLhllH0ekiQOicv9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPeBfkiMnoGTd3J13ZxUYS2+z4XLkFW9wuwj5VrWA8m2iyQ16UPsU6AojttUEfJZz
	 Ekp5JTTJbQtjU8+W1p5Ue1wzjWP+tIkL/MiTq8HFUtPt0NX8/7wVfgN65UvTQFepm1
	 6n+n66OjcTW0on/78Jj3u1+QMJVG0fuAAH/0JwFbjzHbleR3B/HOZfIDBcS1DLTzLo
	 RFSBT9OlSNfM10zNTjS8CFH03oZ1MZwPp8npgY4moLjzJ8A9Dln8NhE43wDnQ6+456
	 PBGq00iD6FigT6mRAyXZq6fbAEQkAkfdOzFY7kylIkMttdeaB9st5/VRkr4FZ0pLrr
	 zdq9DQBxWw6Nw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pt-00000006y6g-43RZ;
	Thu, 20 Nov 2025 17:25:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 17/49] KVM: arm64: GICv2: Extract LR folding primitive
Date: Thu, 20 Nov 2025 17:25:07 +0000
Message-ID: <20251120172540.2267180-18-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are going to need to handle deactivation for interrupts that
are not in the LRs, split vgic_v2_fold_lr_state() into a helper
that deals with a single interrupt, and the function that loops
over the used LRs.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 67 +++++++++++++++++------------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index a0d803c5b08ae..fb8efdd4196b1 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -39,43 +39,23 @@ static bool lr_signals_eoi_mi(u32 lr_val)
 	       !(lr_val & GICH_LR_HW);
 }
 
-/*
- * transfer the content of the LRs back into the corresponding ap_list:
- * - active bit is transferred as is
- * - pending bit is
- *   - transferred as is in case of edge sensitive IRQs
- *   - set to the line-level (resample time) for level sensitive IRQs
- */
-void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
+static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 val)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	struct vgic_v2_cpu_if *cpuif = &vgic_cpu->vgic_v2;
-	int lr;
-
-	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
-
-	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
+	u32 cpuid, intid = val & GICH_LR_VIRTUALID;
+	struct vgic_irq *irq;
+	bool deactivated;
 
-	for (lr = 0; lr < vgic_cpu->vgic_v2.used_lrs; lr++) {
-		u32 val = cpuif->vgic_lr[lr];
-		u32 cpuid, intid = val & GICH_LR_VIRTUALID;
-		struct vgic_irq *irq;
-		bool deactivated;
+	/* Extract the source vCPU id from the LR */
+	cpuid = FIELD_GET(GICH_LR_PHYSID_CPUID, val) & 7;
 
-		/* Extract the source vCPU id from the LR */
-		cpuid = val & GICH_LR_PHYSID_CPUID;
-		cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
-		cpuid &= 7;
+	/* Notify fds when the guest EOI'ed a level-triggered SPI */
+	if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
+		kvm_notify_acked_irq(vcpu->kvm, 0,
+				     intid - VGIC_NR_PRIVATE_IRQS);
 
-		/* Notify fds when the guest EOI'ed a level-triggered SPI */
-		if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
-			kvm_notify_acked_irq(vcpu->kvm, 0,
-					     intid - VGIC_NR_PRIVATE_IRQS);
-
-		irq = vgic_get_vcpu_irq(vcpu, intid);
-
-		raw_spin_lock(&irq->irq_lock);
+	irq = vgic_get_vcpu_irq(vcpu, intid);
 
+	scoped_guard(raw_spinlock, &irq->irq_lock) {
 		/* Always preserve the active bit, note deactivation */
 		deactivated = irq->active && !(val & GICH_LR_ACTIVE_BIT);
 		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
@@ -102,11 +82,28 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		vgic_irq_handle_resampling(irq, deactivated, val & GICH_LR_PENDING_BIT);
 
 		irq->on_lr = false;
-
-		raw_spin_unlock(&irq->irq_lock);
-		vgic_put_irq(vcpu->kvm, irq);
 	}
 
+	vgic_put_irq(vcpu->kvm, irq);
+}
+
+/*
+ * transfer the content of the LRs back into the corresponding ap_list:
+ * - active bit is transferred as is
+ * - pending bit is
+ *   - transferred as is in case of edge sensitive IRQs
+ *   - set to the line-level (resample time) for level sensitive IRQs
+ */
+void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_v2_cpu_if *cpuif = &vgic_cpu->vgic_v2;
+
+	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
+
+	for (int lr = 0; lr < vgic_cpu->vgic_v2.used_lrs; lr++)
+		vgic_v2_fold_lr(vcpu, cpuif->vgic_lr[lr]);
+
 	cpuif->used_lrs = 0;
 }
 
-- 
2.47.3



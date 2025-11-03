Return-Path: <kvm+bounces-61875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BF05C2D4C6
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:57:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 674974E7786
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14593322A29;
	Mon,  3 Nov 2025 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3rDYRmG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67742320393;
	Mon,  3 Nov 2025 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188930; cv=none; b=McrbD6wBFXaeV0wnshHqNUw0WfvqrovWI+a7k9V7T6y337rm2FONMyhaN7L+CBGP8jsE/BBttlp8gpEn+2GlaAINreczyvipJtkJu4SUhY9rY4rgBjXpRjWWjZYvHyVk/c9gtIBqNZfEiwjhzmN7b+PAREpuG4M3uqTBxdd8BBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188930; c=relaxed/simple;
	bh=nnN7zXEZgM6iLHEpVyZS7JUZdXH2ZuFwOkTQRHKZExY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2N+RaA4b7s5F7Qx71J9dYCaWAn3wiXIkfxKml/VrrNuAPXLVTspolX6kWTku9h7hC2yon09NPdKC1kRrLQdfcCZdhhbFtbKTZhHcaqK+SqZ+cYon6HDKdem8r8+uPPQlbTVhsbYyzWCgnKcnCgwmJXW2Zqnvl29RnPp1A9NCiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3rDYRmG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EBBC116D0;
	Mon,  3 Nov 2025 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188930;
	bh=nnN7zXEZgM6iLHEpVyZS7JUZdXH2ZuFwOkTQRHKZExY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3rDYRmGdHt6yY64AkI52+tAlPq5uesSlLExme5It8VyiG4eHjcjlFBHiqXrCclHY
	 6NPKipC6h5Ii02s8PwYRVpEcLTwBl3QkXNLH5R+5GFixPeM0QQFcrXSOyuETpNFgZk
	 zREwT3opybrkQcO5Bvx8n021NCoNjU2eyO9W1OPHtuqhpNymZNwB8zFHVuUkQ7RvGC
	 428rJvlEpzBQ8KBpLLjDnIvDoXk2YoB/vOvAorhvAI9MghW+e+o2gy3AdRuzwCjARK
	 9dwOn9Jk9uJxh1v4qA9I3ZOjXSRfCJjWPBZQhhOBb+be8UCQIot8tDEZB5bvO21S9R
	 H78diWxr+wNUQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq4-000000021VN-28o5;
	Mon, 03 Nov 2025 16:55:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 16/33] KVM: arm64: GICv2: Extract LR folding primitive
Date: Mon,  3 Nov 2025 16:55:00 +0000
Message-ID: <20251103165517.2960148-17-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are going to need to handle deactivation for interrupts that
are not in the LRs, split vgic_v2_fold_lr_state() into a helper
that deals with a single interrupt, and the function that loops
over the used LRs.

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



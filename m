Return-Path: <kvm+bounces-61866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B894FC2D597
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:06:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 179273BA626
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE90531DD82;
	Mon,  3 Nov 2025 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEMLVcAp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E63631B10E;
	Mon,  3 Nov 2025 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188928; cv=none; b=VHAzfr97NXZlQczkEbdZQW0+ZqCj7QyVj+yagPmporU1J1YxcBb5zB3/CfmIPtVm/63bKVTRmy1Nyp5QvBizkgipu/ikZNYq+4AvhpBHG+3IIAv8yGftQQS3YGPPrzB46ssIwcIF1Yd251oYrNHC+5n/UWAUt7qKVRSlLcMS9hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188928; c=relaxed/simple;
	bh=zXQ/Q106vwK8OH63fj9IqtJUIC0Dy3HS8nrP+/NjBZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5m6FhVz/264R48Fs/trn0ingcFGt8BUlefOHjektMnG8K80k6NNawWdOnlWe/HECNlKfnddvWaYNUMzFQNuz5JiYQut51ft8PAMt8y2EKR+QXE+55z3M+LwV/HrtkslgSixfNR2XgCZFuHnRgAKgVOZ+kgNQbQQV2opxiy+ma4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEMLVcAp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB99C116D0;
	Mon,  3 Nov 2025 16:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188928;
	bh=zXQ/Q106vwK8OH63fj9IqtJUIC0Dy3HS8nrP+/NjBZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEMLVcAp9KYhwGZKhfCi5mKO5CxO7FcBsAjy66omesCrujYP+pEiVCdnMFAhtv6SC
	 DyWNWCdNJbHwEtKx6OHlUOa1xVZ/G4CxJ/hgZrgYdPcYIGQJLeEZMA++1P3ZKNzlMU
	 DvTja6gED0d0tHM1OU8dUy75L6ZMs5M1DAjbTgho+0TW+LOEEIfVV5o1/BByHfzABg
	 hmazKc8ELPyC+jEWpd7UBi508kdQu+8CvTLInWsyibJYQ1OMdN7JomEuL/ZoOM3Z95
	 f2RM8AnNNHZ+F3iOFHvYLQnrNbQpo0uO+gz62RW0IeYJ7aDR778DDbEZZa+jpMvkHt
	 lwFvoKNxA4s2g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq2-000000021VN-1ICf;
	Mon, 03 Nov 2025 16:55:26 +0000
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
Subject: [PATCH 07/33] KVM: arm64: Add tracking of vgic_irq being present in a LR
Date: Mon,  3 Nov 2025 16:54:51 +0000
Message-ID: <20251103165517.2960148-8-maz@kernel.org>
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

We currently cannot identify whether an interrupt is queued into
a LR. It wasn't needed until now, but that's about to change.

Add yet another flag to track that state.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 6 ++++++
 arch/arm64/kvm/vgic/vgic-v3.c | 6 ++++++
 include/kvm/arm_vgic.h        | 1 +
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 441efef80d609..74efacba38d42 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -101,6 +101,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		/* Handle resampling for mapped interrupts if required */
 		vgic_irq_handle_resampling(irq, deactivated, val & GICH_LR_PENDING_BIT);
 
+		irq->on_lr = false;
+
 		raw_spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -124,6 +126,8 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	u32 val = irq->intid;
 	bool allow_pending = true;
 
+	WARN_ON(irq->on_lr);
+
 	if (irq->active) {
 		val |= GICH_LR_ACTIVE_BIT;
 		if (vgic_irq_is_sgi(irq->intid))
@@ -194,6 +198,8 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	/* The GICv2 LR only holds five bits of priority. */
 	val |= (irq->priority >> 3) << GICH_LR_PRIORITY_SHIFT;
 
+	irq->on_lr = true;
+
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = val;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index e0c6e03bf9411..c71cf2bcc57c9 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -97,6 +97,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		/* Handle resampling for mapped interrupts if required */
 		vgic_irq_handle_resampling(irq, deactivated, val & ICH_LR_PENDING_BIT);
 
+		irq->on_lr = false;
+
 		raw_spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -111,6 +113,8 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	u64 val = irq->intid;
 	bool allow_pending = true, is_v2_sgi;
 
+	WARN_ON(irq->on_lr);
+
 	is_v2_sgi = (vgic_irq_is_sgi(irq->intid) &&
 		     model == KVM_DEV_TYPE_ARM_VGIC_V2);
 
@@ -185,6 +189,8 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	val |= (u64)irq->priority << ICH_LR_PRIORITY_SHIFT;
 
 	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = val;
+
+	irq->on_lr = true;
 }
 
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index e84a1bc5cf172..ec349c5a4a8b6 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -149,6 +149,7 @@ struct vgic_irq {
 	bool enabled:1;
 	bool active:1;
 	bool hw:1;			/* Tied to HW IRQ */
+	bool on_lr:1;			/* Present in a CPU LR */
 	refcount_t refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	unsigned int host_irq;		/* linux irq corresponding to hwintid */
-- 
2.47.3



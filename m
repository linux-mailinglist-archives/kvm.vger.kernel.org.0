Return-Path: <kvm+bounces-63924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D86EDC75B51
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:35:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4E0574EC3FE
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C66B371A15;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eR/D9bee"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF413751B3;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659558; cv=none; b=VNS+64R7WR36e8wPj9PMgNznFMb3lLgVMAaXAcWG2/0VQpAMSurM17I+4edyyHxPjyvPAorDygcMNuWFHdjVKXAotn176ZxaKJACbuJ8VM0TabIY6Rmlf+3yppyevKEC5gasr5tqE/sCiocBvq45SCg5AVoIw8kTa5NT5z9WjIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659558; c=relaxed/simple;
	bh=HjA9YS8ovI0IGrD1rQBZDdgzzbY6iGzI3p9W+QXTKwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhnSlLtknG/6tdbC2iWM7sA3wwnb4RxIQGANwN2kFEvl42Znfs/KvtSHAukiHffdT2FAtMIKCZDu2X0LfE9kCWG9LVL9OPBlGmMLArAidD+2uev21qhc9DIYEcOhyIdulqW8D/sJRJ1wIsDbiM/FTWKGhwkBFdvBaEn4Foek93g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eR/D9bee; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA896C116C6;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659557;
	bh=HjA9YS8ovI0IGrD1rQBZDdgzzbY6iGzI3p9W+QXTKwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eR/D9beeZ3OZd/Z3VuzOwRP58Rmw9NIRO/xvocAAsP56jumCuD0Qh01HYZ48I0XuJ
	 VvFa+3TBXy1aARdINnXHc4A/3Odo4BJ0EpZ47kbFrBJK3W8yBGlMgJIuaJMjV42Ke9
	 jYgVSwZdIR50OC0JdvHRc9c2SJgjvI2DScIQvML6uIb6t/RFFGbWRumLSTKMFNpxQC
	 z5EQeGVTtrCfCPYVCLYgDOXbSEM47bdUsUdh5zb4nnjcI98cvt6W26KL4ymTvmYbqO
	 0XySgWeAJ78Ab4WO5Ir1cO7o4kBJ9O8+g6gulyUMao/Ox8j2rSnZYV0UnRSf93TM04
	 bEP9fl1eXt7aA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pr-00000006y6g-33Nz;
	Thu, 20 Nov 2025 17:25:55 +0000
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
Subject: [PATCH v4 08/49] KVM: arm64: Add tracking of vgic_irq being present in a LR
Date: Thu, 20 Nov 2025 17:24:58 +0000
Message-ID: <20251120172540.2267180-9-maz@kernel.org>
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

We currently cannot identify whether an interrupt is queued into
a LR. It wasn't needed until now, but that's about to change.

Add yet another flag to track that state.

Tested-by: Fuad Tabba <tabba@google.com>
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
index 1b6c3071ec80f..e3f4b27e0225f 100644
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



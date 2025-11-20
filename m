Return-Path: <kvm+bounces-63944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C3958C75AFD
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 1BC092F99E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D120D3A79DE;
	Thu, 20 Nov 2025 17:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DelMbAld"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C473A5E7C;
	Thu, 20 Nov 2025 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659563; cv=none; b=kVLzFbvddAz4os7BnU0noc0Z05mu3f4LEPP0kTaeK+QAY4/2oqOoH7esgrOlYAr2FFVsbMhDjayFtSDeWdM/pOLg3SJdwUYqKaViTn11bDN/Z3gFWwfCuBZAAgbB7eqHawliEqATQvKJ9WfKp9+qGSxUXINJiV+eYG5uLaqDVeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659563; c=relaxed/simple;
	bh=38+3571SsR3/6Au4qfcW65qDAxFokXCMSe41hn2rqc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gR81jcAM3LkuNoyG3vZIcc0XGlQrTZTOrNayzB7y6RhfQhdJdOFWWduP+COAroJUQNj4LVuSRSPS/b1Q3V5Sq7jOjVdMS8y3cByXcSky/EO1aDuITxPiHk4cK2fWmPLnNKLKdIcVdc8NVJn4+7r3TvrYwkvnBvBzGX4aJ8GoFZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DelMbAld; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5490C4CEF1;
	Thu, 20 Nov 2025 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659562;
	bh=38+3571SsR3/6Au4qfcW65qDAxFokXCMSe41hn2rqc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DelMbAld/iGNCWBlc7SfMxudML3BMl7iIC3SGQ4LzFQNu6L1N53Tw1keIC1k6A3DN
	 1eiGx6ABUgZrtCy8579OIyQYZ05LtUfML4lwwQJ4rGY9BKERKB+KJ58fR+Axb39X/D
	 FaujMsO9DYh2wOlvzkEAlhHNOWW3lMAokfHZvMS5CCoUgHC6ZScQc02UDmPdyPQP2g
	 e5aPAwLHBNG72/YA+0KnrWeilnlYAf9Frcr6K2iWCScNC1WQYI0qngpKPeAmKac8eJ
	 /uP9kTti8xSvqYGL/7+GNMmwXgamEd1XbE9wCdOfTnY+6XlxCBsa5JmrMLgxYqVqnj
	 Hcb9KlKGNYw2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pw-00000006y6g-3yac;
	Thu, 20 Nov 2025 17:26:01 +0000
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
Subject: [PATCH v4 29/49] KVM: arm64: GICv3: Add GICv2 SGI handling to deactivation primitive
Date: Thu, 20 Nov 2025 17:25:19 +0000
Message-ID: <20251120172540.2267180-30-maz@kernel.org>
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

The GICv2 SGIs require additional handling for deactivation, as they
are effectively multiple interrrupts muxed into one. Make sure we
check for the source CPU when deactivating.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index d83edf02d0722..9fcee5121fe5e 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -176,11 +176,20 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
+	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	struct kvm_vcpu *target_vcpu = NULL;
+	bool mmio = false, is_v2_sgi;
 	struct vgic_irq *irq;
 	unsigned long flags;
-	bool mmio = false;
 	u64 lr = 0;
+	u8 cpuid;
+
+	/* Snapshot CPUID, and remove it from the INTID */
+	cpuid = FIELD_GET(GENMASK_ULL(12, 10), val);
+	val &= ~GENMASK_ULL(12, 10);
+
+	is_v2_sgi = (model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
+		     val < VGIC_NR_SGIS);
 
 	/*
 	 * We only deal with DIR when EOIMode==1, and only for SGI,
@@ -216,6 +225,9 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 	 * - Or the irq is active, but not in an LR, and we can
 	 *   directly deactivate it by building a pseudo-LR, fold it,
 	 *   and queue a request to prune the resulting ap_list,
+	 *
+	 * Special care must be taken to match the source CPUID when
+	 * deactivating a GICv2 SGI.
 	 */
 	scoped_guard(raw_spinlock, &irq->irq_lock) {
 		target_vcpu = irq->vcpu;
@@ -233,6 +245,12 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 			goto put;
 		}
 
+		/* GICv2 SGI: check that the cpuid matches */
+		if (is_v2_sgi && irq->active_source != cpuid) {
+			target_vcpu = NULL;
+			goto put;
+		}
+
 		/* (with a Dalek voice) DEACTIVATE!!!! */
 		lr = vgic_v3_compute_lr(vcpu, irq) & ~ICH_LR_ACTIVE_BIT;
 	}
-- 
2.47.3



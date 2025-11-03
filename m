Return-Path: <kvm+bounces-61889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC253C2D51B
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:00:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0D93189C724
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD4C328B40;
	Mon,  3 Nov 2025 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpTI5HEv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA993326D4F;
	Mon,  3 Nov 2025 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188933; cv=none; b=fvJPMIzxWjw6ILRcLjJVDSViAy+y9jyXEzZwBqXw7GnWBJKAOCvcH5R/+h0k2+BCD5SeRTdNDpHMzn5SManlvYFRl/2qqPgSGCLGHyilZWMUjVg+a9a7gv0ouBAqE9L9KcppDSYLJT/tHRCrBIjpqlEZNSehHngZQQXfQoFM1Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188933; c=relaxed/simple;
	bh=rAure+jhA3ps9jseK4OumjiSA/MySxSs2f++MsW1XdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8usDjmNmsZDpie4fs/mZgNWyvqGT6i5AqY+2VzWyxvQn74JLDRn60vqWTH58/r505Y/MkgymmDYzrQsZB06W27qhfeDw/KvKcFhAyR2wY2HIeg2IK6QJS7ydDRaDPzlcd9Q8u5XQavxBLJW46lv1PN/DqR6bWvvg8k2e2da1+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpTI5HEv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A512DC116C6;
	Mon,  3 Nov 2025 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188933;
	bh=rAure+jhA3ps9jseK4OumjiSA/MySxSs2f++MsW1XdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpTI5HEvt8YUA0HntIfBKDxrFyPi07PVFkEbvAAG7xnmYZNYFbeJSVAgwYYbV7jID
	 t1u0NBXyAUPMl45n0eSspR2/kRm4fiKLU6SGkbTeDsX6OH85r7h8DaeDwmfewoYJuH
	 NScf0v5wW+L0VlAs3jq94Nvt4WVYukHru0G9hgN2IyDF1OB4Fxo6IHki2X9jbkF0ii
	 4RhFqNUO7qT0oOUcguuxgnwFdjvmADuSuaCEV3qP+Uy8iFkKnwhcwAxkK0GtcU0RP0
	 HL5RIfXW6O+x9au0ClRvnYugdNNAcfHkV1I31vrOLnEsbXnQgy9zX0z7mQC5mQI0lJ
	 sVcbHTg7ha6QQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq7-000000021VN-3d9d;
	Mon, 03 Nov 2025 16:55:31 +0000
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
Subject: [PATCH 30/33] KVM: arm64: GICv2: Handle LR overflow when EOImode==0
Date: Mon,  3 Nov 2025 16:55:14 +0000
Message-ID: <20251103165517.2960148-31-maz@kernel.org>
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

Similarly to the GICv3 version, handle the EOIcount-driven deactivation
by walking the overflow list.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 9d4702aec454b..0159da5a94412 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -100,6 +100,8 @@ static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 val)
 	vgic_put_irq(vcpu->kvm, irq);
 }
 
+static u32 vgic_v2_compute_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
+
 /*
  * transfer the content of the LRs back into the corresponding ap_list:
  * - active bit is transferred as is
@@ -111,12 +113,37 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_v2_cpu_if *cpuif = &vgic_cpu->vgic_v2;
+	u32 eoicount = FIELD_GET(GICH_HCR_EOICOUNT, cpuif->vgic_hcr);
+	struct vgic_irq *irq;
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
 	for (int lr = 0; lr < vgic_cpu->vgic_v2.used_lrs; lr++)
 		vgic_v2_fold_lr(vcpu, cpuif->vgic_lr[lr]);
 
+	/* See the GICv3 equivalent for the EOIcount handling rationale */
+	list_for_each_entry(irq, &vgic_cpu->overflow_ap_list_head, ap_list) {
+		u32 lr;
+
+		if (!eoicount) {
+			break;
+		} else {
+			guard(raw_spinlock)(&irq->irq_lock);
+
+			if (!(likely(vgic_target_oracle(irq) == vcpu) &&
+			      irq->active))
+				continue;
+
+			lr = vgic_v2_compute_lr(vcpu, irq) & ~GICH_LR_ACTIVE_BIT;
+		}
+
+		if (lr & GICH_LR_HW)
+			writel_relaxed(FIELD_GET(GICH_LR_PHYSID_CPUID, lr),
+				       kvm_vgic_global_state.gicc_base + GIC_CPU_DEACTIVATE);
+		vgic_v2_fold_lr(vcpu, lr);
+		eoicount--;
+	}
+
 	cpuif->used_lrs = 0;
 }
 
-- 
2.47.3



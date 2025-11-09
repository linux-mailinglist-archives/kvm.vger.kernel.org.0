Return-Path: <kvm+bounces-62456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AE77C44434
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 424013B3A97
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC763101A6;
	Sun,  9 Nov 2025 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tiavHW5a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8113730F819;
	Sun,  9 Nov 2025 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708598; cv=none; b=FDNSVajQDb8i8Pu6SP3y2oKA43Fp4vLXDzTWMG6MrTUIAFoD+Ayr6x1x+722ju5Dy5dfrVNp/g2hXRqWUfEePplixJMIui4fOaPHJ8WlSZM8fhGLYHJn8xk000o/aG9iGew0Kk7kI5NzL/op8z29RYH7R18/bh1xOB0lolqd9BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708598; c=relaxed/simple;
	bh=0HS/4qE6qTgeyCBJPAK5i628M7zUg3PGilYhBnFOIe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODLfPb3ehO6tNdhVZJnKg7jjNrOORVF9HzLcBNYkjUOwFUefIl1Vpp4pSDEXGdmSCDFTAbl+SxISS0w4W5gSNIbW3X/n5u3NL5qzMldp56eAsUIL0Cu3XDgcnnjMQtOySSQFtO1gxp7WAIHpbLe+tTNphy9VbbDtBE9NUBzhJFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tiavHW5a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E213AC19422;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708598;
	bh=0HS/4qE6qTgeyCBJPAK5i628M7zUg3PGilYhBnFOIe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiavHW5aQHfrZ534hcNX0458qMjZfxey3WbdPr1F5XaGjzJe1WGVAykBrYYKzIIKh
	 xOZT5rOYm8hQyY2bvIdN2PE0Xgh7wTofS3rQH3bOG+Y2qAjnVReNszoTEw/gffe+4o
	 0L4XvHr0HTNi9DrJyST04KCj2mmGJMB7M3N8+eJ60dY9PASuiN12G8h7J3MlhnLXJT
	 XpofIKweelAOq2igwGtfUPdyisljEY+n2UOM48kQqGqloyVCO3xpYv7o86cIuGQJtb
	 Kxcv7UuJA3zvVcrf8Lbz2errO7xG9J+9uLXV1KJHf+aHuSaXa92bE02TlMa2OvnagU
	 a1s5Aty9rM2Gg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91o-00000003exw-0oGQ;
	Sun, 09 Nov 2025 17:16:36 +0000
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
Subject: [PATCH v2 33/45] KVM: arm64: GICv2: Handle LR overflow when EOImode==0
Date: Sun,  9 Nov 2025 17:16:07 +0000
Message-ID: <20251109171619.1507205-34-maz@kernel.org>
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

Similarly to the GICv3 version, handle the EOIcount-driven deactivation
by walking the overflow list.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 9a2de03f74c30..bbd4d003fde86 100644
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
+	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
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



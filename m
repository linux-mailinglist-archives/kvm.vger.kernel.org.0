Return-Path: <kvm+bounces-62449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D505FC44410
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:20:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 708163B65A8
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797B230E0F1;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/WFmg9p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8F930BF67;
	Sun,  9 Nov 2025 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708596; cv=none; b=ont+zMwM3Uq4+PU2lK12TpSKFi8ezmd7fZUX97Ctd8fKjN0cVeAxDEnkXWctNGemz9kCKYRQqTSuxppwZvWAngp92CYKV1zN/lY2s9lpzSlTG0tvaeiSYayL9AGyUXbr9978gYi+wW4mxzXK01+c0OBlOAhuiv2rLAaEP3csN7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708596; c=relaxed/simple;
	bh=CiJ1PnLwlcVRUivVT2Z2xoI1yiqxdUthVumxqrnUjJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPAKiKoWvdX4vCij07AHjp2c8vlo5XuLVu0xbHozihQq9vj9Hmb3HlttKv8pjmpyRRfrvTUvparZKXLQsfR/1xGPlipyx1rmch7CUAOaixYcN7l0PrvA4Mu7D0JUF82+A17a13F3VwvrP+byamsePiZYMyyMc56SjMZu6BUIOvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/WFmg9p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489C4C16AAE;
	Sun,  9 Nov 2025 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708596;
	bh=CiJ1PnLwlcVRUivVT2Z2xoI1yiqxdUthVumxqrnUjJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/WFmg9piPeSz/SWtLwjRT9icfbPNi26Z6neG8UdC0835KHxiVFG39QL/64f+54PX
	 yJ0eVgdYLFZ+X8YDBQeHqogXJZo9XyU7s7YpCJph9k1/zHKDk8pTE+2dZ/6h9aBmsD
	 K79S0JVh4jjpK3adeq+mvK4gB9269MtID8e3972howRZlqNkINmhnQqwWczmnYswHo
	 E2n9HPfrKLybYI0Fz+bakHnzYtO/cPz9R29urw52hSHHGbjSzn71Eza1orI/Ksy7Fw
	 1VldZzS2xOAqPO8YO/PUUrxe2pprUR2Qy/mvs79InOo1PcpZSQBSPgYFP/NRIRxfHt
	 ww6GicmeC0o0Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91m-00000003exw-1kIb;
	Sun, 09 Nov 2025 17:16:34 +0000
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
Subject: [PATCH v2 26/45] KVM: arm64: GICv3: Handle LR overflow when EOImode==0
Date: Sun,  9 Nov 2025 17:16:00 +0000
Message-ID: <20251109171619.1507205-27-maz@kernel.org>
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

Now that we can identify interrupts that have not made it into the LRs,
it becomes relatively easy to use EOIcount to walk the overflow list.

What is a bit odd is that we compute a fake LR for the original
state of the interrupt, clear the active bit, and feed into the existing
logic for processing. In a way, this is what would have happened if
the interrupt was in an LR.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b5cf68bc1ea9f..e17eefc6a2bb6 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -109,16 +109,62 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
 	vgic_put_irq(vcpu->kvm, irq);
 }
 
+static u64 vgic_v3_compute_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
+
+static void vgic_v3_deactivate_phys(u32 intid)
+{
+	if (cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
+		gic_insn(intid | FIELD_PREP(GICV5_GIC_CDDI_TYPE_MASK, 1), CDDI);
+	else
+		gic_write_dir(intid);
+}
+
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
+	u32 eoicount = FIELD_GET(ICH_HCR_EL2_EOIcount, cpuif->vgic_hcr);
+	struct vgic_irq *irq;
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
 	for (int lr = 0; lr < cpuif->used_lrs; lr++)
 		vgic_v3_fold_lr(vcpu, cpuif->vgic_lr[lr]);
 
+	/*
+	 * EOIMode=0: use EOIcount to emulate deactivation. We are
+	 * guaranteed to deactivate in reverse order of the activation, so
+	 * just pick one active interrupt after the other in the ap_list,
+	 * and replay the deactivation as if the CPU was doing it. We also
+	 * rely on priority drop to have taken place, and the list to be
+	 * sorted by priority.
+	 */
+	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
+		u64 lr;
+
+		/*
+		 * I would have loved to write this using a scoped_guard(),
+		 * but using 'continue' here is a total train wreck.
+		 */
+		if (!eoicount) {
+			break;
+		} else {
+			guard(raw_spinlock)(&irq->irq_lock);
+
+			if (!(likely(vgic_target_oracle(irq) == vcpu) &&
+			      irq->active))
+				continue;
+
+			lr = vgic_v3_compute_lr(vcpu, irq) & ~ICH_LR_ACTIVE_BIT;
+		}
+
+		if (lr & ICH_LR_HW)
+			vgic_v3_deactivate_phys(FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
+
+		vgic_v3_fold_lr(vcpu, lr);
+		eoicount--;
+	}
+
 	cpuif->used_lrs = 0;
 }
 
-- 
2.47.3



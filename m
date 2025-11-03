Return-Path: <kvm+bounces-61884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 225CAC2D5C6
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:09:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 356E43AE449
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64525327203;
	Mon,  3 Nov 2025 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjIb8ziA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA072325486;
	Mon,  3 Nov 2025 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188933; cv=none; b=rcXZnq68dE2KsLjGcwB0i1Y6/QF4CNmpvB3XBAd/v5pCCAC1nRz8OoLaeS8cwT2gf9SLCGgKbvK/ILAznCwNeLJ3x0XG/lxwyQCI/NKO68usZd0E78g4BMPCS2l8DIj8DmDauPFD4mvn6reuyhsYFs7fDJGHaroj31f17azLtB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188933; c=relaxed/simple;
	bh=iqZcVcEEAlkxkd+PUiY5mjGb5FYWhKWCcmecb4qtFAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnpai2BkXYxS0Mycqb8doLvw7AvjneY7ekYvcxpKd32BGfqmmvKTO9TznqY+CKytKambCBaUbd8bX84dCH+B8gi0jg7jS5LwYhVb7f5YHnxlwIFN/dVoVkoZYXUGK38Sy2K7xJfvadpVXcK0DSB2ZIbsJbX1bZHQy2/XHVVylTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjIb8ziA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71F7C116D0;
	Mon,  3 Nov 2025 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188932;
	bh=iqZcVcEEAlkxkd+PUiY5mjGb5FYWhKWCcmecb4qtFAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjIb8ziAti490KyjyrE0X6LDN3hVg2jlPjgzrl+gC4GyYQbNyuNn21HFQaycOnQuE
	 RKDWuaIiFPQdkNJhVD/9PnYrUU/elhQ+VCb66Rp9u7kbl3exIULpxy55VIYvvCMr5W
	 33IuxAQgtC3QjuSZlfuOlMidIc3mXNBd2ke5GkWYcbjee8U3FUvYZiozaoi2mP9AE2
	 0Sazw8BG4JkPM9pE7qU0ydUzz/gp+xV3f7BFZ5I8Uo45I6XKOn1Mhh22FBbyXUrA3y
	 dlLgGE57PZxw/u4ZfeIuNeL/mPqXGWCDtO5TZszHFLcp2kDUfm9ykQr1SnLSsvIM6Z
	 qMh3cW8ueFSqQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq6-000000021VN-3ph0;
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
Subject: [PATCH 26/33] KVM: arm64: GICv3: Handle LR overflow when EOImode==0
Date: Mon,  3 Nov 2025 16:55:10 +0000
Message-ID: <20251103165517.2960148-27-maz@kernel.org>
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

Now that we can identify interrupts that have not made it into the LRs,
it becomes relatively easy to use EOIcount to walk the overflow list.

What is a bit odd is that we compute a fake LR for the original
state of the interrupt, clear the active bit, and feed into the existing
logic for processing. In a way, this is what would have happened if
the interrupt was in an LR.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 45 +++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index e18b13b240492..14b35a62e2981 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -109,16 +109,61 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
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
+	 * just pick one interrupt after the other in the overflow list, and
+	 * replay the deactivation as if the CPU was doing it. We also rely
+	 * on priority drop to have taken place.
+	 */
+	list_for_each_entry(irq, &vgic_cpu->overflow_ap_list_head, ap_list) {
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



Return-Path: <kvm+bounces-63942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 194EAC75AF4
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:32:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id D4AF92CD56
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A3A3A79BB;
	Thu, 20 Nov 2025 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czmBviy6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CDE3A1D03;
	Thu, 20 Nov 2025 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659562; cv=none; b=HCBwKQ+HBeF6gC0rB/1yQjxW1KbiM5MLDz3WSst8Groabd0nWBZE/oQiXoF6IL2oycA+ldxj8MGvXapRDAdMP6HT/zA6o8YHjR+G1lVNXVY1oNTOb0+llwqBMoCMAexP9o73gkWEWan/KnDvHgD/1EnWVc5EQhJ1NMztc613IFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659562; c=relaxed/simple;
	bh=LSmwy/jJoyDN5XNfzlXa3/7NJpRS/mKXF3x0i2bdOsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fw6zNJJYn41s3CyazjolwszvxCqHLMCneD18B3f1WJqmFUU5mIpXJ1VsfVEGbw6VuNmv0mt1tIdRJuwmIfpY9W9RsQoOYmclnF1DBuJJEWVnwiLbXweaHh+bdF4y+xo7nsmOaoLuXCzYe0ww6YfcVaPaelj+IhBrLuxw5UPBBp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czmBviy6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36009C19423;
	Thu, 20 Nov 2025 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659562;
	bh=LSmwy/jJoyDN5XNfzlXa3/7NJpRS/mKXF3x0i2bdOsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czmBviy6N11hv9dSGjba+aCXNF9cOOSvDQ0VmYm4DU+chbr6/u1VF68qlMaMUYKSP
	 ZFXeqI0bjjhXtkMn1DxRH42uer7OVb26C+Sd9Bu4xDH9lcVpYmKDyHcA6XGwbYNrtH
	 2qST+S5LeWrd9ADtOnFk4qZ4nuv1LsgFnNT04o/l6ojMCQ+QBXCgypCCC+N4ZcOOcu
	 2RpITI+YWNIF5xMBJGIMuKkzy6kC3CMsthcgsAXTiEhNSfhmaxh/341wZCMPNOyIkn
	 LiFO2MbEO1vgXXkaY1N/KU0W3+5/Ttb1dPC8bmuHd7WLkKi/JBghwLmWd8A+BZ3+JA
	 AUZEv+O5Tm6NA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pw-00000006y6g-1mMx;
	Thu, 20 Nov 2025 17:26:00 +0000
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
Subject: [PATCH v4 27/49] KVM: arm64: GICv3: Handle LR overflow when EOImode==0
Date: Thu, 20 Nov 2025 17:25:17 +0000
Message-ID: <20251120172540.2267180-28-maz@kernel.org>
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

Now that we can identify interrupts that have not made it into the LRs,
it becomes relatively easy to use EOIcount to walk the overflow list.

What is a bit odd is that we compute a fake LR for the original
state of the interrupt, clear the active bit, and feed into the existing
logic for processing. In a way, this is what would have happened if
the interrupt was in an LR.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 312226cc2565d..d4f27f451c8fb 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -112,16 +112,62 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
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



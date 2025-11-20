Return-Path: <kvm+bounces-63951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F289FC75BA8
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EEE824E374A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B6F53A9BEE;
	Thu, 20 Nov 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFGhjNdM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C0E3A79DD;
	Thu, 20 Nov 2025 17:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659564; cv=none; b=M+LQ0Y8vtDwGgudtVFEe1kVCv7ebFgmzF5Ai1eUMPXnKVmdIlX4QZfCUtONNGt1vOuXesmR24fftU60k+Mo5trsABez8OOFfhbJi6CLlhEWE0h1WbHJVfXkFQIzHjfdow2BnpOWThzpqpTpe2R5/U33HQEM2bgjhW+c+Pwd5Km8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659564; c=relaxed/simple;
	bh=5oclhuOKF2j0jLu4azurZ3vXLPt1EEMSdWiGQPsFMNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nl6vooSQp+Mdq6y+8ifKx2jXvVsZZO8frHJSbsccBBq2xmkLBZy0xCtGmx2ZyKPKep5zqAjG8TJfCYC1vUfRVG+OeznF4+pbjObR+TFT4HKIdYF2k4rQAKHxJTOygx8OneYd71IcUE40yEWNrbG6943CP0oIz9bF3CFhpimuS6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DFGhjNdM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8131C2BC86;
	Thu, 20 Nov 2025 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659564;
	bh=5oclhuOKF2j0jLu4azurZ3vXLPt1EEMSdWiGQPsFMNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFGhjNdMYu8T09FUClS+mVHZk46IFFq1Umw8vuI8VvS79SAdJk7PtLlBzeNYEzIRj
	 +LLPpC0V8OV5tSeHAPZtfPVJ2eBjTJLrr4+SWH1fKbKuA+xhS2HetaQxjfyVG/OVfH
	 q5ncr7kB7joE1Jyycl/iA35Scp7fYhAJ86nhF8Ion8Hue+A56I0yV89hYPLXwAZSqz
	 PvNrYFNaXc/2iqq+xgz1QQYIRHh17vRrEC28EI8oIXGbzMF6VkFm/aWfnqaW12C/tF
	 fBqs6suboaUe62cF+gHo0irQEOANkgWol5kMT+j9Zqw8LRIQ0hhHWPfOJ/v0CQpd6E
	 0dnDhyrw+fedQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Py-00000006y6g-3ygt;
	Thu, 20 Nov 2025 17:26:03 +0000
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
Subject: [PATCH v4 37/49] KVM: arm64: GICv2: Handle LR overflow when EOImode==0
Date: Thu, 20 Nov 2025 17:25:27 +0000
Message-ID: <20251120172540.2267180-38-maz@kernel.org>
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

Similarly to the GICv3 version, handle the EOIcount-driven deactivation
by walking the overflow list.

Tested-by: Fuad Tabba <tabba@google.com>
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



Return-Path: <kvm+bounces-63940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A2BFC75BBA
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:38:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id BB3F232427
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E7737415B;
	Thu, 20 Nov 2025 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlFYuZax"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185453A1CF2;
	Thu, 20 Nov 2025 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659562; cv=none; b=GNaQ8+GHtHPxxF1+WlPaNi0ELGqbWmeadexPLvaurtmRfQHMYVOOatpaL0eUyVQA2QPIvVGNKrnHXgjg3GzHfbJPY/19mHM7OBQ0KTLQURdOLfhyp6M3qb83zGm5gXk7VZKaQzrshA2UYbMcaUZPZClREQmCZwX2GBYd94oYroA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659562; c=relaxed/simple;
	bh=xH9V2OTsZYBTbqtAOuJtdgvZKHJ1R5JUs+/Mzl2/B6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2Gyq0rYCqRvAXJpny987Xd7QIEaXoBHH2dbUSOsQymwIEgWlvySan5atsgl3t+oiMOhtJSN4A9jqT+jM/PjxUkSaMPujFMnaD/7OtBODVuHqkIhigGAWK56jVgigLM6FbAYhwFu+KBjzGkWq2alcIr5a1uW1kJamVsBSBg4sD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlFYuZax; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05E1C4CEF1;
	Thu, 20 Nov 2025 17:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659561;
	bh=xH9V2OTsZYBTbqtAOuJtdgvZKHJ1R5JUs+/Mzl2/B6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlFYuZaxotvJtkq64pBBtMMtG6+HwowDSXapVRyTa/bT+luliRQnd76fni5nbLPee
	 Sfxp7KZf7rIx/k4PA5tUr15+biM7mu4XB08OG3m2qNfUZefO1606nR+7zzDX77IMzC
	 ff5KzOR/oXaXFPmv7zir14wmQOyFPRWNrGixYDYGM2tYNqTRDNRRf+kvZsqev+mL5i
	 /Qq+bGm5FJU6SpfrDEYruYi1hThiCgi3Qp/A0nc1zy/oSaT8LF62M2CCNYPAOySY9Y
	 krK+Q1yC2uZx4BuVz26RJX82QHj91xdvNS2LAsQva1/Jd23ddINececSmtIIvuZE6C
	 gIdEPdzikai8w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pv-00000006y6g-3wtS;
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
Subject: [PATCH v4 25/49] KVM: arm64: Move undeliverable interrupts to the end of ap_list
Date: Thu, 20 Nov 2025 17:25:15 +0000
Message-ID: <20251120172540.2267180-26-maz@kernel.org>
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

Interrupts in the ap_list that cannot be acted upon because they
are not enabled, or that their group is not enabled, shouldn't
make it into the LRs if we are space-constrained.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index c7a5454ac4c9f..abe01c9c6b364 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -265,6 +265,11 @@ struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 	return NULL;
 }
 
+struct vgic_sort_info {
+	struct kvm_vcpu *vcpu;
+	struct vgic_vmcr vmcr;
+};
+
 /*
  * The order of items in the ap_lists defines how we'll pack things in LRs as
  * well, the first items in the list being the first things populated in the
@@ -273,6 +278,7 @@ struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
  * Pending, non-active interrupts must be placed at the head of the list.
  * Otherwise things should be sorted by the priority field and the GIC
  * hardware support will take care of preemption of priority groups etc.
+ * Interrupts that are not deliverable should be at the end of the list.
  *
  * Return negative if "a" sorts before "b", 0 to preserve order, and positive
  * to sort "b" before "a".
@@ -282,6 +288,8 @@ static int vgic_irq_cmp(void *priv, const struct list_head *a,
 {
 	struct vgic_irq *irqa = container_of(a, struct vgic_irq, ap_list);
 	struct vgic_irq *irqb = container_of(b, struct vgic_irq, ap_list);
+	struct vgic_sort_info *info = priv;
+	struct kvm_vcpu *vcpu = info->vcpu;
 	bool penda, pendb;
 	int ret;
 
@@ -295,6 +303,17 @@ static int vgic_irq_cmp(void *priv, const struct list_head *a,
 	raw_spin_lock(&irqa->irq_lock);
 	raw_spin_lock_nested(&irqb->irq_lock, SINGLE_DEPTH_NESTING);
 
+	/* Undeliverable interrupts should be last */
+	ret = (int)(vgic_target_oracle(irqb) == vcpu) - (int)(vgic_target_oracle(irqa) == vcpu);
+	if (ret)
+		goto out;
+
+	/* Same thing for interrupts targeting a disabled group */
+	ret =  (int)(irqb->group ? info->vmcr.grpen1 : info->vmcr.grpen0);
+	ret -= (int)(irqa->group ? info->vmcr.grpen1 : info->vmcr.grpen0);
+	if (ret)
+		goto out;
+
 	penda = irqa->enabled && irq_is_pending(irqa) && !irqa->active;
 	pendb = irqb->enabled && irq_is_pending(irqb) && !irqb->active;
 
@@ -320,10 +339,12 @@ static int vgic_irq_cmp(void *priv, const struct list_head *a,
 static void vgic_sort_ap_list(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_sort_info info = { .vcpu = vcpu, };
 
 	lockdep_assert_held(&vgic_cpu->ap_list_lock);
 
-	list_sort(NULL, &vgic_cpu->ap_list_head, vgic_irq_cmp);
+	vgic_get_vmcr(vcpu, &info.vmcr);
+	list_sort(&info, &vgic_cpu->ap_list_head, vgic_irq_cmp);
 }
 
 /*
-- 
2.47.3



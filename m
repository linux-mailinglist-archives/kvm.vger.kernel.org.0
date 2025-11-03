Return-Path: <kvm+bounces-61882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25D00C2D5BA
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:08:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61A603A7922
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CCDA325717;
	Mon,  3 Nov 2025 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aT1xrAMR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14645322A2E;
	Mon,  3 Nov 2025 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188932; cv=none; b=YNjYGdn3rnpklcrcp8c+SRYMZoAj6/nLCaNiynTMjYu30TPIO1loI2JYwMO9bI0qe4OsB8Vphg76+sVX61g083aXxnwNCXdd2FVIKmcJ8GrxmK9oZelpAZ0314fklmTpRYA0OxHFhudLQZODiJTEDQXhZudwbxmXl2wOrvrO+Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188932; c=relaxed/simple;
	bh=PnttpW5k/sZbVwWIADxCl8IZlSHBNDSq8thM0EUpP/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSw2kJWcJtOj9Qx11/pNVfSysEeSY/Y4zmMRumkPxDo5e5JJFfr6A71R4ePUzBb7wsjqHQnZvmfiyrBRhhcl2YZC8i6HQ/Vi8IsUy6yqNMU0xHRapc0aSbeWTQymn9fGuxkepvxPNPa+MXWC1zwMthk499UVZENNcwuv0nQXbRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aT1xrAMR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BD1C113D0;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188931;
	bh=PnttpW5k/sZbVwWIADxCl8IZlSHBNDSq8thM0EUpP/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aT1xrAMRMQNRyHDOnEcLIz88OfZ3iGHZ5jvhf6RnlO/jq5c6WvTJ6KgyICS/94+kh
	 BVi3HrAW6SXP95M9Xs/ln2r/ab0m6ed7dNwxydPje1rj9AcL4MW7GCvk1cjtNRPHW3
	 iexzxxtZxgFgaSn83JBb6T5fY/+ecmBHl/szNM8HzZzAF2zsIc4pmjMxMFZZln7r6b
	 /RgOmRVBB3XojUdi+lxgYyEjxzUNBE7PgLm0zpldomOuE+hJBmBfK0RB1HQ8pGU3lR
	 gtfbXORyaF35smIf/cn3YCWuuNHCpKBJ332bLAwl0+jI7/eERDELA+C0Lu/W2EqnJR
	 coAmtvSrPVjxQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq6-000000021VN-0cO6;
	Mon, 03 Nov 2025 16:55:30 +0000
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
Subject: [PATCH 23/33] KVM: arm64: Move undeliverable interrupts to the end of ap_list
Date: Mon,  3 Nov 2025 16:55:07 +0000
Message-ID: <20251103165517.2960148-24-maz@kernel.org>
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

Interrupts in the ap_list that cannot be acted upon because they
are not enabled, or that their group is not enabled, shouldn't
make it into the LRs if we are space-constrained.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 56c61e17e1e88..5c9204d18b27d 100644
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



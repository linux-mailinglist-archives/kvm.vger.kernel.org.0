Return-Path: <kvm+bounces-63922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 02606C75B54
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:35:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BE6213598D6
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 041D6371A09;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSEsSJTH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6890368E09;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659557; cv=none; b=sOKz4anN8RWzQvp/1Fd+5Ce0m5aeIAbi6DPCWtpegMMK7ksvNjp3zLe0NZOXIQEkTsTGLu3HPc7981totba1rXNyaZrbDhzEyzMOYBshu8zRFlC1C2NsDa2prE+t5rw/ZoPs8tWFbGyw2kb/uc/nvqLw5n+oZeIPpGRrtISegz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659557; c=relaxed/simple;
	bh=3oc3mE3MKaLJ102yx3fBNAGYLcUCEMpiniOX3bIMiXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/Vrq76kIyRMk2p2REvoSwFkSglQ1Jqnlx33u1TiOYMj66/QWaAtGMv3OdW9fd5G5/8RfrqGHQEOcnGPZWBsNkHtPZOA7UbLB+4IOxGaCQvqbQz2q8ezjbTzm3puWAXY4Ul2jHaauyakgmU+GR7ZJTxHFl89i+/tPdfUsqcCym4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSEsSJTH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764E6C4CEF1;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659557;
	bh=3oc3mE3MKaLJ102yx3fBNAGYLcUCEMpiniOX3bIMiXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSEsSJTHUEDovc5GAoRPzBs1MRGyeLcDqAINpulHxzywUPzMaLi/DUi3cU+dnVCKS
	 k7jQrY/daF6FBlAgAW5jdives9UTUuGZ3/H7pnc4VJ+kia9db7XBYjaVS1lk4s3MC/
	 wyWFNTooRVKNIffXa3fya1mKxd+aWucxtePB8jBPATJobs0b+LBs3EHwRPyMofg/u6
	 KK3L+4xheSoRk6fN2Q2QfJSNgug2Rhnjjq3fOAObU0JbS7uXYeCm46TBeiIGuL83My
	 5t/kKiG+FSIJo50OOYLADakX8wJXfv6QPelF6vLTkQsp+VdtOFoQz0AgtFPR5/pN1z
	 RFdJfqWlrQO2g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pr-00000006y6g-1zaL;
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
Subject: [PATCH v4 07/49] KVM: arm64: Repack struct vgic_irq fields
Date: Thu, 20 Nov 2025 17:24:57 +0000
Message-ID: <20251120172540.2267180-8-maz@kernel.org>
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

struct vgic_irq has grown over the years, in a rather bad way.
Repack it using bitfields so that the individual flags, and move
things around a bit so that it a bit smaller.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v4.c |  5 ++++-
 include/kvm/arm_vgic.h        | 20 ++++++++++----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 548aec9d5a728..09c3e9eb23f89 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -163,6 +163,7 @@ static void vgic_v4_disable_vsgis(struct kvm_vcpu *vcpu)
 		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, i);
 		struct irq_desc *desc;
 		unsigned long flags;
+		bool pending;
 		int ret;
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
@@ -173,9 +174,11 @@ static void vgic_v4_disable_vsgis(struct kvm_vcpu *vcpu)
 		irq->hw = false;
 		ret = irq_get_irqchip_state(irq->host_irq,
 					    IRQCHIP_STATE_PENDING,
-					    &irq->pending_latch);
+					    &pending);
 		WARN_ON(ret);
 
+		irq->pending_latch = pending;
+
 		desc = irq_to_desc(irq->host_irq);
 		irq_domain_deactivate_irq(irq_desc_get_irq_data(desc));
 	unlock:
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 577723f5599bd..e84a1bc5cf172 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -123,6 +123,7 @@ struct irq_ops {
 
 struct vgic_irq {
 	raw_spinlock_t irq_lock;	/* Protects the content of the struct */
+	u32 intid;			/* Guest visible INTID */
 	struct rcu_head rcu;
 	struct list_head ap_list;
 
@@ -137,17 +138,17 @@ struct vgic_irq {
 					 * affinity reg (v3).
 					 */
 
-	u32 intid;			/* Guest visible INTID */
-	bool line_level;		/* Level only */
-	bool pending_latch;		/* The pending latch state used to calculate
-					 * the pending state for both level
-					 * and edge triggered IRQs. */
-	bool active;
-	bool pending_release;		/* Used for LPIs only, unreferenced IRQ
+	bool pending_release:1;		/* Used for LPIs only, unreferenced IRQ
 					 * pending a release */
 
-	bool enabled;
-	bool hw;			/* Tied to HW IRQ */
+	bool pending_latch:1;		/* The pending latch state used to calculate
+					 * the pending state for both level
+					 * and edge triggered IRQs. */
+	enum vgic_irq_config config:1;	/* Level or edge */
+	bool line_level:1;		/* Level only */
+	bool enabled:1;
+	bool active:1;
+	bool hw:1;			/* Tied to HW IRQ */
 	refcount_t refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	unsigned int host_irq;		/* linux irq corresponding to hwintid */
@@ -159,7 +160,6 @@ struct vgic_irq {
 	u8 active_source;		/* GICv2 SGIs only */
 	u8 priority;
 	u8 group;			/* 0 == group 0, 1 == group 1 */
-	enum vgic_irq_config config;	/* Level or edge */
 
 	struct irq_ops *ops;
 
-- 
2.47.3



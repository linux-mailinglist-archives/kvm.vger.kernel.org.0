Return-Path: <kvm+bounces-61867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B3CEC2D596
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76D6C3BC9F3
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA42031D75A;
	Mon,  3 Nov 2025 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRvihzsi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C10F31AF24;
	Mon,  3 Nov 2025 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188928; cv=none; b=sn4b61DJJU+uPHGOftogg5xYovN5HiP/CQwTV1cVK228wG8tBK+oMrUPAZRwvSqy0KnUxrY3kvyrZWfUdW9Cef86SFWsTdHaHfXlKQZ11II0P3UpPagsCwNatLclAvF2dYhk0ecCubQo82TZ0RT2+JV/hu24wV+vkghnj/1dxns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188928; c=relaxed/simple;
	bh=uG/sGiah4ee3+/bxdFax57bVH6y6zvhTVa/pehRU4hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqw67YLL6ULa2C40Ui07AOEvIveW5FiJfC1y2zxYK8ABOsjLbAveac2BvMkdkcrkh4zMky+D+OGaY2BtKOsDZx+UawwNPLEZ5U5AaExuFrQjnY9EAwqeSNsW70uZCv+z/p/4swG0x6O0wmALP7aUI9Bzm0MIGLfujA/Fm7P7qyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRvihzsi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE2CC4CEE7;
	Mon,  3 Nov 2025 16:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188928;
	bh=uG/sGiah4ee3+/bxdFax57bVH6y6zvhTVa/pehRU4hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRvihzsiD5gV/QP8RGA3qdspcojSiKsLZh2kF/N70KhSMAxv2BfV1WC9XfIk/MJti
	 N8P+Jb2I//P/DjfbTWWDd7ACPAjtXKc9F7FtKVFs7ES3bBWcdC10ZI5DAQlBjPbNZh
	 jGIjdZcXh6UCJFvA3iH0kXRKNF+9/A8mtpHa2vpy6hQOOwKaDnbFUqgqmfcPEc4hxj
	 nuS2LFtNx4Tyxsmba+tKeF7zobf7tnCbzieKLZzKo2YO2h77LdUD3SWVfoXF011O+I
	 pA9wS1KAv8xbM/+NwCjvGJ8oy05qD3EfEadmRdp/dZDnowLuXXjwWVFtrL6PYJf+mP
	 WtvjqXyIc5m7g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq2-000000021VN-0LB6;
	Mon, 03 Nov 2025 16:55:26 +0000
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
Subject: [PATCH 06/33] KVM: arm64: Repack struct vgic_irq fields
Date: Mon,  3 Nov 2025 16:54:50 +0000
Message-ID: <20251103165517.2960148-7-maz@kernel.org>
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

struct vgic_irq has grown over the years, in a rather bad way.
Repack it using bitfields so that the individual flags, and move
things around a bit so that it a bit smaller.

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



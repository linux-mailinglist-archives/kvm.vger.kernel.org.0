Return-Path: <kvm+bounces-61886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13802C2D515
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A291718853B6
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4D7328619;
	Mon,  3 Nov 2025 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFGCEY0T"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0F53254BC;
	Mon,  3 Nov 2025 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188933; cv=none; b=ZN66fEM0TiX0tCjgMYuV62kPToncxmBy1egLwofUADQ5eXAPnxLQ4epTUs8S2p8zG2uxuIE+3e6vdw8V5AWj/dTLoFtOisz6LpQq8yj09OqYWQNFOPvGcPvQOlQOvvXbtKKEcspvmhxi2J4W7/5XAz9S2i8dTN689jnh4Bjqaz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188933; c=relaxed/simple;
	bh=ktPDDt0AeT9/A9wvjteRm8cEmxv56YYt5i4uc806DiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHoq5XJbtau+9b12E0luE0naYogUnNiUJAWAJlW0aKLUPRLIbLav/CKRYZ8RqvYXxrZ6gP6Dt0vDVSqNcNfgf/P6bgP9c8cvwgx9vYD7Vl/WIxdgdy9SJk8qEWmoebeZ4NCsDnTjPVe6hvfELPLj5XcaUc2ajG5ulLqWLzw4cds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFGCEY0T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C04C116C6;
	Mon,  3 Nov 2025 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188933;
	bh=ktPDDt0AeT9/A9wvjteRm8cEmxv56YYt5i4uc806DiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFGCEY0TzJrhsO/SMzKka6pUAX9U/A6cax8SBTa9iw+SrYcwTUZnB3qTgxe1CFoll
	 jswIEwAYOC6/5zogOwlSv3+fsFy00Yd3CBd5ZEZ2n8wSHDpTYqItqaAz2z6xWD6liq
	 iCu3MyRNLst74rf4EPW9r0ZSI34vdY6pbHNgpHabSz5FNnL8ErQoLOLjSFHNR6/H5F
	 eBZcUSeHetsqX59Cbc74umaknE3gic+pRt2QztfakQWAUyXZ7jnIauZIe0KwE5VfDw
	 JCMV4EdXXHaHTkAsq3T4gbDsN5CRRtNAVhW36HfgnO0ovrQI35qMXUB+5g2lLyuSb5
	 Wh2pzfP/X7NNQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq7-000000021VN-1gvo;
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
Subject: [PATCH 28/33] KVM: arm64: GICv3: Add GICv2 SGI handling to deactivation primitive
Date: Mon,  3 Nov 2025 16:55:12 +0000
Message-ID: <20251103165517.2960148-29-maz@kernel.org>
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

The GICv2 SGIs require additional handling for deactivation, as they
are effectively multiple interrrupts muxed into one. Make sure we
check for the source CPU when deactivating.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index be8e9f6b1da71..5131a9bfeffb3 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -177,11 +177,20 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
+	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	struct kvm_vcpu *target_vcpu = NULL;
+	bool mmio = false, is_v2_sgi;
 	struct vgic_irq *irq;
 	unsigned long flags;
-	bool mmio = false;
 	u64 lr = 0;
+	u8 cpuid;
+
+	/* Snapshot CPUID, and remove it from the INTID */
+	cpuid = FIELD_GET(GENMASK_ULL(12, 10), val);
+	val &= ~GENMASK_ULL(12, 10);
+
+	is_v2_sgi = (model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
+		     val < VGIC_NR_SGIS);
 
 	/*
 	 * We only deal with DIR when EOIMode==1, and only for SGI,
@@ -214,6 +223,9 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 	 *   and queue a request to prune the resulting ap_list,
 	 *
 	 * - Or the irq is not active, and there is nothing to do.
+	 *
+	 * Special care must be taken to match the source CPUID when
+	 * deactivating a GICv2 SGI.
 	 */
 	scoped_guard(raw_spinlock, &irq->irq_lock) {
 		target_vcpu = vgic_target_oracle(irq);
@@ -237,6 +249,12 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 			goto put;
 		}
 
+		/* GICv2 SGI: check that the cpuid matches */
+		if (is_v2_sgi && irq->active_source != cpuid) {
+			target_vcpu = NULL;
+			goto put;
+		}
+
 		/* (with a Dalek voice) DEACTIVATE!!!! */
 		lr = vgic_v3_compute_lr(vcpu, irq) & ~ICH_LR_ACTIVE_BIT;
 	}
-- 
2.47.3



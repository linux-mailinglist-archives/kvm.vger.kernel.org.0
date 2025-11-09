Return-Path: <kvm+bounces-62452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6519FC443FB
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:19:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4616A4E8DF9
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FB4230EF9F;
	Sun,  9 Nov 2025 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xya2JItG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231FE30DD19;
	Sun,  9 Nov 2025 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708597; cv=none; b=MBqH8+UA/bYkPJrrIxJU037UYn7eSR3kN+MtdUWfiHRHc1fVFZiGhVidsfDME02ns+4Cnvau70nz52oHGDoyH5TClJ4Ms5Y2hblq3U6EhrbhAL93gve036Gd7NhUYZIaroT11oFB/9V6QCHqhDEJ1ai80biijPVJ/eEEEpD1TnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708597; c=relaxed/simple;
	bh=0zksfbp8fETOkMIO13QpM40jEGbVHi37o5/Nfk1X6So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPiT6MVn0uuU5RqSRq4cRZTkYcBVMT5jm3HW7ZpZ4hKK0dLgqq8avDiYC4BMIV5jsGWjS8QI0qnBz8vzU32xewybm4Uv77/amRwiNghtwlSWA0sBl5zG7RMXwFpHt0Uac6cASKzPXcswf5KS+zEMP5jo1nxTqjkrSmqbRNFyw5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xya2JItG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCEEC16AAE;
	Sun,  9 Nov 2025 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708596;
	bh=0zksfbp8fETOkMIO13QpM40jEGbVHi37o5/Nfk1X6So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xya2JItGemMT0Sm+kHAxtnu7gzUw5eHz9+c7GED9S/iHECe9osPDbqJ4GzMADRU7j
	 gDeFx3Agg+DqehRaONyp5gqoPT11VziDyc8dPOJFWMW6syElBYMMlTXzeEzDn5AfaC
	 AAGcId7oAHagLTnkL9fV7u6XqrEyMKE0v5d5fmRhzzq8NPz2vw+f1mm26aISGbq3U+
	 syxDEfKFWBSRyJS983Fazx5dH8MpWFlpeZ4bIxOKM51VOvEW5Mx9H3Foa9gChFvRit
	 2bxs5AKTKblyDF3idWBCYrFen6Xs00tgE7HT0aK46nGGdiFFI2kOkDqAHi4CFabY6c
	 yfLaIejbQJNsA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91m-00000003exw-3d8A;
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
Subject: [PATCH v2 28/45] KVM: arm64: GICv3: Add GICv2 SGI handling to deactivation primitive
Date: Sun,  9 Nov 2025 17:16:02 +0000
Message-ID: <20251109171619.1507205-29-maz@kernel.org>
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

The GICv2 SGIs require additional handling for deactivation, as they
are effectively multiple interrrupts muxed into one. Make sure we
check for the source CPU when deactivating.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index f2e9b96c6b65c..1026031f22ff9 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -173,11 +173,20 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
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
@@ -213,6 +222,9 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 	 * - Or the irq is active, but not in an LR, and we can
 	 *   directly deactivate it by building a pseudo-LR, fold it,
 	 *   and queue a request to prune the resulting ap_list,
+	 *
+	 * Special care must be taken to match the source CPUID when
+	 * deactivating a GICv2 SGI.
 	 */
 	scoped_guard(raw_spinlock, &irq->irq_lock) {
 		target_vcpu = irq->vcpu;
@@ -230,6 +242,12 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
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



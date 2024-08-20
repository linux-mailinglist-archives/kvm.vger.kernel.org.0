Return-Path: <kvm+bounces-24590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE07958392
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C65528883B
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E47418D63B;
	Tue, 20 Aug 2024 10:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qiNIStBM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9520E18E355;
	Tue, 20 Aug 2024 10:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148373; cv=none; b=WTrEmk4SN2Etq2lcXc4TjHhbda5esf0w9+eS8dKY4mA990HhjyysXG5TItXi+kM3dsxxLj0iJqYZMwtUw0mkLcESLu/QJfA98ifHpGkozoQN4GLpqCr7Ie9+zGqsKIsecltfd+AFhfL+9U/xM45Yw3SCfpet9VvNwap86rktyTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148373; c=relaxed/simple;
	bh=BgMzqzNq58JRjfRTd8XVeRoOEDa5+txFhBx+Ocgx4aU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lw50HGH47Wi0Z2Zl318bdQFAcJ1iSjbjlFFjDSaPho1kbiWBdzhbCmjdzsUYGooSU8VYoKODTWmcWcaO63kGMjjflP7mEekAcntgshSpS1xoDzJdWRkuYZDDrzlD+xArOZkYQtrJgjN2BNSEbi99JC/VONUKyd7V4INF4l6gpiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qiNIStBM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CC8C4AF14;
	Tue, 20 Aug 2024 10:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148373;
	bh=BgMzqzNq58JRjfRTd8XVeRoOEDa5+txFhBx+Ocgx4aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiNIStBM2qz4ht1aPbTGPvGEyt75cfhO4mjMhNB32yRGfyZQZULRK31IgbhmqdNI1
	 P1dV7BHN38x9JftRaqT7uUGad5ytY2Zcdj4dDPKBzWYEhW8YoYc9+Pa9hJK4A32tEu
	 jiibS/HVfIaG38n26VoR3LGQidMnOvGd8wowLfstG9+bPWWD2tWA8uEZEruVulUUUF
	 M2Z1V6PDKsrEJTo4xsQsa5z/tBP7ktyeHeq9v+kxLi/ad/n1x8YGSu7M4b5o30b+/I
	 sj2htPRJyB7Mor8NnMxcSZZKRMourSC+esb5ipy2JIKpbWozf1N5yBUfi92oAWN6Wo
	 cIhe+/kFifrpQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLkh-005Dk2-NI;
	Tue, 20 Aug 2024 11:06:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 04/12] KVM: arm64: Force GICv3 traps activa when no irqchip is configured on VHE
Date: Tue, 20 Aug 2024 11:03:41 +0100
Message-Id: <20240820100349.3544850-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820100349.3544850-1-maz@kernel.org>
References: <20240820100349.3544850-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On a VHE system, no GICv3 traps get configured when no irqchip is
present. This is not quite matching the "no GICv3" semantics that
we want to present.

Force such traps to be configured in this case.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 974849ea7101..2caa64415ff3 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -917,10 +917,13 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
+		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
+	}
 
-	if (kvm_vgic_global_state.type == VGIC_V2)
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_load(vcpu);
 	else
 		vgic_v3_load(vcpu);
@@ -928,10 +931,13 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_put(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
+		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
+	}
 
-	if (kvm_vgic_global_state.type == VGIC_V2)
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_put(vcpu);
 	else
 		vgic_v3_put(vcpu);
-- 
2.39.2



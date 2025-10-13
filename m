Return-Path: <kvm+bounces-59880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C6A9BD2111
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 10:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 561CE3C223C
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D8B2F657E;
	Mon, 13 Oct 2025 08:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kb2exZYl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3672F5A3C;
	Mon, 13 Oct 2025 08:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760344339; cv=none; b=mty40eLFD0fGKVjXQJ5UdrG96exvHts0gunTh9YsxLegQvLTepMGgr8dkD2NpGaEypv9K9HLZjTARsCz4EOREDb7FYftPCfA6dFTtxuJJfglWW38uTBUJRFi3+KtM6G4HY6pLJaQKfxNZmu951m05QAeBQlZLv+ytsg+GzakI/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760344339; c=relaxed/simple;
	bh=HFbqiH3fVeEghecXQ5XW07ZfgkipM0nl6smfp7yY2AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLCxZglewrVTzOkN7xPIuU+t1vQeQ4tKJlrWaW68vPt0eVSr7nprwZ/BH7HColx/wJaH4A5BM7FjNJlUN/rtZnmmhCf7M7cSUGCPWlmfm6KVbs2IZby43i+BD5+O5iA7i5OHO45T7fz0gP1eJ2RcFCHhsds4i5RvMMU+PQvEegU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kb2exZYl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16096C4CEFE;
	Mon, 13 Oct 2025 08:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760344339;
	bh=HFbqiH3fVeEghecXQ5XW07ZfgkipM0nl6smfp7yY2AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kb2exZYlc7VgJTXuZjUYTjJcuSv7qO5YyYoE221at/D1Ku+xCdvEMKyH6mFERxDch
	 9HSaCLzS34XpCKKGxb2XcdHKc8lqyZpz1RYi/ESs5DSwZNmp7bcev02GKhFqfbuBXS
	 gMLRJok23MELnXcijcYxxHsiNt2FOiI96Fi/8SdRNQBL5MJhk3Obx1ITRxxRT+lfSC
	 Xugq/VJqbDwbDFbENeBAH12gr03X9UZ6rueBsF/jk0uZowDZVqXldwZLPbUE0bYwQG
	 +FQVZWi8+1sC53JDwuUAmi44zqfuBF3l065N5yEOWwT8dbZDH4xkxL/APydxagXPJp
	 ajLymYjtnrCuA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8Dyb-0000000DRrP-11gd;
	Mon, 13 Oct 2025 08:32:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 3/3] KVM: arm64: Limit clearing of ID_{AA64PFR0,PFR1}_EL1.GIC to userspace irqchip
Date: Mon, 13 Oct 2025 09:32:07 +0100
Message-ID: <20251013083207.518998-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013083207.518998-1-maz@kernel.org>
References: <20251013083207.518998-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that the idreg's GIC field is in sync with the irqchip, limit
the runtime clearing of these fields to the pathological case where
we do not have an in-kernel GIC.

Fixes: 5cb57a1aff755 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 73dcefe51a3e7..25cfd0f9541f5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5494,9 +5494,7 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 
 	guard(mutex)(&kvm->arch.config_lock);
 
-	if (!(static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) &&
-	      irqchip_in_kernel(kvm) &&
-	      kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)) {
+	if (!irqchip_in_kernel(kvm)) {
 		kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] &= ~ID_AA64PFR0_EL1_GIC_MASK;
 		kvm->arch.id_regs[IDREG_IDX(SYS_ID_PFR1_EL1)] &= ~ID_PFR1_EL1_GIC_MASK;
 	}
-- 
2.47.3



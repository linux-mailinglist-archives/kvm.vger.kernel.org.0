Return-Path: <kvm+bounces-61869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB42C2D4CC
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FFDD1899B0D
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66463320390;
	Mon,  3 Nov 2025 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9GVfA/X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3615E31C59F;
	Mon,  3 Nov 2025 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188929; cv=none; b=INC9YaF8Pg5JQ5O29grkdn9jjnRF59nMBf+usGHq8IfarvBx8gSJ7msYzI0JIn8uDlH1CliTMX0/zb+E5RqpTqAbziESYMzTCW3lPkbWo38EazLgAz9b913Ml2vJ+w991k5X+zUlo79+Y36YWZ/AlSA5W8Y4ZL+HTR9kfXuaVQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188929; c=relaxed/simple;
	bh=QMaC0gqBcRF3hw0Xjj6IXI4r1QPU/njBPXxtSLfQ9YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOYuJswrmdbXoUehGqJFTlOOBxYq96kUTqqN80E4q8usA5q7HvCr2uKS1jfysOQYcAeOzBW9pQ7UUPSaTHU+NbXEeTAzvMtQKnraDRfmFymLQLZNTCB7jIFEBghGGQqkQFqgM6Po6mvtQAIc8dsPxs3jesfUVTE8WRm5Sxu0c7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9GVfA/X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1722BC4CEE7;
	Mon,  3 Nov 2025 16:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188929;
	bh=QMaC0gqBcRF3hw0Xjj6IXI4r1QPU/njBPXxtSLfQ9YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9GVfA/XE980ACjtwpBE1/betOQqaRRgRdFcXEk06XZzC/mX2t72dvq0m+fiVoFUr
	 XJbWit+auL6euD7O4eHH//Bp4oVWavirUm/ymL8TUcDySmZ9YSrXiFRnFlXE4lu4dP
	 leNPfDPMTmp8046HgzkHWGscWCdxousrFppWEEGgfCr+QyZB+F+Ivtg8yI0faRRx+p
	 7ugEi/qm66FYV8xR80if/T+zGlDC7YsNW6I2vSnuR27vXI36aRrpAUfgd/dCFZ8TDV
	 2KYohOeBzgUi9A2Vwy61HZs5Ejkia1KAXXhpnjM2E3hDQhy67ANTOZCvbC+Q0rgNa7
	 dhCEdqqAwd1Ww==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq3-000000021VN-0yl1;
	Mon, 03 Nov 2025 16:55:27 +0000
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
Subject: [PATCH 11/33] KVM: arm64: GICv3: Decouple ICH_HCR_EL2 programming from LRs
Date: Mon,  3 Nov 2025 16:54:55 +0000
Message-ID: <20251103165517.2960148-12-maz@kernel.org>
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

Not programming ICH_HCR_EL2 while no LRs are populated is a bit
of an issue, as we otherwise don't see any maintenance interrupt
when the guest interacts with the LRs.

Decouple the two and always program the control register, even when
we don't have to touch the LRs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index aa04cc9cdc1ab..d001b26a21f16 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -219,20 +219,12 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 		}
 	}
 
-	if (used_lrs || cpu_if->its_vpe.its_vm) {
+	if (used_lrs) {
 		int i;
 		u32 elrsr;
 
 		elrsr = read_gicreg(ICH_ELRSR_EL2);
 
-		if (cpu_if->vgic_hcr & ICH_HCR_EL2_LRENPIE) {
-			u64 val = read_gicreg(ICH_HCR_EL2);
-			cpu_if->vgic_hcr &= ~ICH_HCR_EL2_EOIcount;
-			cpu_if->vgic_hcr |= val & ICH_HCR_EL2_EOIcount;
-		}
-
-		write_gicreg(compute_ich_hcr(cpu_if) & ~ICH_HCR_EL2_En, ICH_HCR_EL2);
-
 		for (i = 0; i < used_lrs; i++) {
 			if (elrsr & (1 << i))
 				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
@@ -242,6 +234,14 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 			__gic_v3_set_lr(0, i);
 		}
 	}
+
+	if (cpu_if->vgic_hcr & ICH_HCR_EL2_LRENPIE) {
+		u64 val = read_gicreg(ICH_HCR_EL2);
+		cpu_if->vgic_hcr &= ~ICH_HCR_EL2_EOIcount;
+		cpu_if->vgic_hcr |= val & ICH_HCR_EL2_EOIcount;
+	}
+
+	write_gicreg(compute_ich_hcr(cpu_if) & ~ICH_HCR_EL2_En, ICH_HCR_EL2);
 }
 
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
@@ -249,12 +249,10 @@ void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
 	u64 used_lrs = cpu_if->used_lrs;
 	int i;
 
-	if (used_lrs || cpu_if->its_vpe.its_vm) {
-		write_gicreg(compute_ich_hcr(cpu_if), ICH_HCR_EL2);
+	write_gicreg(compute_ich_hcr(cpu_if), ICH_HCR_EL2);
 
-		for (i = 0; i < used_lrs; i++)
-			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
-	}
+	for (i = 0; i < used_lrs; i++)
+		__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
 
 	/*
 	 * Ensure that writes to the LRs, and on non-VHE systems ensure that
-- 
2.47.3



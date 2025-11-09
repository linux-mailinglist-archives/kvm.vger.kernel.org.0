Return-Path: <kvm+bounces-62433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AE4E5C443C5
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:17:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 127B13420A5
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4250308F14;
	Sun,  9 Nov 2025 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rG2TAFAt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86E9307ACF;
	Sun,  9 Nov 2025 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708592; cv=none; b=T5AfYSrG818Dnob2QeeQfxrI52k/sRF029kzKXStuXRQhqpjLsuowfEmgHBJnbD9PWzUElQsWtkXHSj0eCrX2itH4YKEWa0yZ9eMDWv8C9KvtT9AiyO+iBHtO037movDZbae+hRq7QPjZZd6pI2hn6OIcu2dg4S8Xn2QgA+VNlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708592; c=relaxed/simple;
	bh=QMaC0gqBcRF3hw0Xjj6IXI4r1QPU/njBPXxtSLfQ9YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/pkdtFSum2umuF9HtGM6ABjvjZgo2D/Jn/Y/ZdnG+jJddnhEXEnOfhB4vcjQMLGKwsXt0q1FeNUOoW2beMTC/AVJY6UPQFxtQutDuUC3hj3jPeozdVlbBFqIekMZq6g0tHCULYqglNDxLlYtBY92l8UZgX9z95tOWuW8uQj/Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rG2TAFAt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1A6C19425;
	Sun,  9 Nov 2025 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708592;
	bh=QMaC0gqBcRF3hw0Xjj6IXI4r1QPU/njBPXxtSLfQ9YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rG2TAFAtPki8T2KKuagZgjC1oxOHmYU8T2Ndb0VoZHRNeL0EcEM5VAX6uJqh/1GoE
	 Om4cDIIZzOhdJifZjO7EhN6KKJHaLjSsKwXEl4fTNU/bqlQX7KGfBdfWlBQy/uxtl/
	 cnr+4ydHWorQBK80XXAhHhTxERynlmoupuZn1iYiw+aLAedp2QFXoRrEqU5iyc8kL8
	 /+3HVDMxkMVWXGB0J5s459n3ULU0mid4cqckZNEaP0a803ty3lS/5tAvhST/zNE3+e
	 S9zDlLL95YC8EZU3qusQPtlLfwdavBncOxdrc9khURFe+xzp9C21B+vR2EQdUlZmkO
	 ba9pYZgA8/pyQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91i-00000003exw-3UQl;
	Sun, 09 Nov 2025 17:16:30 +0000
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
Subject: [PATCH v2 11/45] KVM: arm64: GICv3: Decouple ICH_HCR_EL2 programming from LRs
Date: Sun,  9 Nov 2025 17:15:45 +0000
Message-ID: <20251109171619.1507205-12-maz@kernel.org>
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



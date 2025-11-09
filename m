Return-Path: <kvm+bounces-62455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50303C44428
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:20:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CBB83A8BB6
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB4130F95A;
	Sun,  9 Nov 2025 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tfG5h49k"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED02030EF85;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708598; cv=none; b=p4lQexqeiHvAOtgsh7ecixt3TM3resphJBhaWPsP9Cs3JxNL3R7tUENDMorvKWh/2GJUwCX8BIaIwFXyFWtPMC2th/lw0hGNRRVHdTP2fsY5EFruolYaVF6+I5DJevzkapngycuu5a4+98C+VVTVtO/y8OWVpnmHu4bzfLc3xhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708598; c=relaxed/simple;
	bh=SLRiFgk9c+wOGfa2B+I0f696jbLpPaxhNQ3kVExvE1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScTMi58iVq5Wz4Sv+1JYK8cuUHxrsSguj3tMrRRAuDuZglq014lNouKx3AiW+Di6e/r46lX4gz7qSayjrbiwOp7sYZnkawvOaYsVpFDAsxA50dB53A9xXcmtBJr1oUy0JF8cRq36QI+nFtZTRU39ytTZJ404kpTle1IspOiXlFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tfG5h49k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FB8C2BCAF;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708597;
	bh=SLRiFgk9c+wOGfa2B+I0f696jbLpPaxhNQ3kVExvE1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfG5h49kBf1krDdwQH1lptaqNElPI5xEFPDaAzQyPGE8CESvD8UFQHJtMsO+3dLGs
	 Qjs/H6P3jxtSW/FuZhDr419AQeyYeU1Z/IvjPKzaO0g5Eih3OHo82XEX8uA917yTN4
	 Y7Z1TLfhBd3hoMnmiaK8VhAU8bzFBAcBEhvcUBapc7IOln/HphKBpmMYkqehjuxSm1
	 y3S+/HG58oEIxVfuXmhy3QqF52y+AMrg63Bp4jsydk+lCfqSm87nC8T1DvOm/xmU2D
	 dVN6NZyOiKBdQqCJsQenqzB1fWfqBOifXrzunXk1/UcqG/4VO7Sf0af79t7g/01C4H
	 bRzS5wZDJcLnA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91n-00000003exw-3swL;
	Sun, 09 Nov 2025 17:16:36 +0000
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
Subject: [PATCH v2 32/45] KVM: arm64: GICv3: Avoid broadcast kick on CPUs lacking TDIR
Date: Sun,  9 Nov 2025 17:16:06 +0000
Message-ID: <20251109171619.1507205-33-maz@kernel.org>
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

CPUs lacking TDIR always trap ICV_DIR_EL1, no matter what, since
we have ICH_HCR_EL2.TC set permanently. For these CPUs, it is
useless to use a broadcast kick on SPI injection, as the sole
purpose of this is to set TDIR.

We can therefore skip this on these CPUs, which are challenged
enough not to be burdened by extra IPIs. As a consequence,
permanently set the TDIR bit in the shadow state to notify the
fast-path emulation code of the exit reason.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c |  6 +++++-
 arch/arm64/kvm/vgic/vgic.c    | 13 ++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index bf4dde158d516..32654ea51418b 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -50,10 +50,14 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 	 * need to deal with SPIs that can be deactivated on another
 	 * CPU.
 	 *
+	 * On systems that do not implement TDIR, force the bit in the
+	 * shadow state anyway to avoid IPI-ing on these poor sods.
+	 *
 	 * Note that we set the trap irrespective of EOIMode, as that
 	 * can change behind our back without any warning...
 	 */
-	if (irqs_active_outside_lrs(als)		     ||
+	if (!cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDIR) ||
+	    irqs_active_outside_lrs(als)		     ||
 	    atomic_read(&vcpu->kvm->arch.vgic.active_spis))
 		cpuif->vgic_hcr |= ICH_HCR_EL2_TDIR;
 }
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 60bdddf3472e7..a4c42884f1e16 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -370,12 +370,15 @@ static bool vgic_validate_injection(struct vgic_irq *irq, bool level, void *owne
 static bool vgic_model_needs_bcst_kick(struct kvm *kvm)
 {
 	/*
-	 * A GICv3 (or GICv3-like) system exposing a GICv3 to the
-	 * guest needs a broadcast kick to set TDIR globally, even if
-	 * the bit doesn't really exist (we still need to check for
-	 * the shadow bit in the DIR emulation fast-path).
+	 * A GICv3 (or GICv3-like) system exposing a GICv3 to the guest
+	 * needs a broadcast kick to set TDIR globally.
+	 *
+	 * For systems that do not have TDIR (ARM's own v8.0 CPUs), the
+	 * shadow TDIR bit is always set, and so is the register's TC bit,
+	 * so no need to kick the CPUs.
 	 */
-	return (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3);
+	return (cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDIR) &&
+		kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3);
 }
 
 /*
-- 
2.47.3



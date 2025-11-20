Return-Path: <kvm+bounces-63948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DAEE6C75B0A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 3FEA92EBE0
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D977E3A8D78;
	Thu, 20 Nov 2025 17:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3nrJQis"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0154A3A79BC;
	Thu, 20 Nov 2025 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659564; cv=none; b=BkjNY8yR02/Zf3wWvArEyQNDqKLHYFYSvblzjIVqXNmBFxSNOIiWxZixJA5Nj2qpm8Nc1dubV5f8GJ2YjTC24ZDow7Ae8RCGWFUmtK25nksTteRb5MyvSCjicFxzJeTd35SeYqFh9X5vv+4KjbiIBmnJ/w+wb8IOG9e5q8jWbNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659564; c=relaxed/simple;
	bh=I0AskgwDdaf6eWZUGhhy/0YrdanjZQLtxvD9oISnCwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGdy0L/CKeQOoXcfIkenhg3N9HZVGV51lx9XxttzpSyg/jkUb5RFBik8TTadwqDyzuSFjtRqmVrSIvzp0plH2FK+YPhCZhPgnFpMFhjHLbOZDFICL1e/8k6l254PP99otymW33IVII1uQOPtkKyfW1YpFY7MHLhgAi0MNYSwuXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l3nrJQis; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05C2C19422;
	Thu, 20 Nov 2025 17:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659563;
	bh=I0AskgwDdaf6eWZUGhhy/0YrdanjZQLtxvD9oISnCwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3nrJQiszcUvBj/V6/B1mhg7uXJkduR/L7rY9/ujmz5kr26O9FibYpoEOySMatwiq
	 mJURHx9so9jHceq6WOj9DIxH5iJ0Dlu6sUvC9fiOW8v7HVO2phOEXJBSgxLbgmTbBR
	 chetALD7Tmj9LLkDQp5Y/AEVDZM1kHqQBI6nGPStEld4IDkDDzCjC5rY5xdzsdP0Ga
	 TjCLUPP6AXtZwyzdukZJAwxtmhsJmzcHwYDwamLnepuActtcANYm1gyh/MH9KuS5vg
	 7CQ8SG5qRUYoLynR+gQZ9vdC9X2k+FX2PXMSTuWfZh+NHICkDiFOGZqqZJF8iNXGJH
	 /MVW0kU+ssnMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Px-00000006y6g-3xvR;
	Thu, 20 Nov 2025 17:26:02 +0000
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
Subject: [PATCH v4 33/49] KVM: arm64: GICv3: Avoid broadcast kick on CPUs lacking TDIR
Date: Thu, 20 Nov 2025 17:25:23 +0000
Message-ID: <20251120172540.2267180-34-maz@kernel.org>
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

CPUs lacking TDIR always trap ICV_DIR_EL1, no matter what, since
we have ICH_HCR_EL2.TC set permanently. For these CPUs, it is
useless to use a broadcast kick on SPI injection, as the sole
purpose of this is to set TDIR.

We can therefore skip this on these CPUs, which are challenged
enough not to be burdened by extra IPIs. As a consequence,
permanently set the TDIR bit in the shadow state to notify the
fast-path emulation code of the exit reason.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c |  6 +++++-
 arch/arm64/kvm/vgic/vgic.c    | 13 ++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 55847fbad4d0d..968aa9d89be63 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -53,10 +53,14 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
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
index 83969c18ef035..693ec005c996c 100644
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



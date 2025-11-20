Return-Path: <kvm+bounces-63931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7099EC75B7B
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:36:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 65A934E285A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E36374153;
	Thu, 20 Nov 2025 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tBJ/L1nK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10C7371DD8;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659559; cv=none; b=RhBwTLvn33nGcBUeGjcaaXtF2oQwLOnhGDw5J/vy4uW07YDNuV99pYs96UQqDVqphQ23/jqCc/fWlP05mWt+XI8u2MNynJ+ukazsy+1sO7KmM9noW/PenIr07Ah9vPzTZ0RPswDRi1flpiqCbj+dRU44P3DveO0O08MFVv29a18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659559; c=relaxed/simple;
	bh=1no91c3xaDd316LugGksTfsPN/xmo39aJ5Oq84Jki54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKF6+Vg6D8RkoRN9IZjIF/UgfRNwtHosRJtmzLZ8s3nA796gQBCV68+nIwHWQ1RXa5OvR7PvPrmRIif9duj1euVER2XbcdjxyZUhv/XYQgzhHCt6RWA4a/eqzOqN6XYP+rZzJNFX+cPOxoiqf+ig4C7r0tF+ZSwhz8BafmLUmb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tBJ/L1nK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5751FC4CEF1;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659559;
	bh=1no91c3xaDd316LugGksTfsPN/xmo39aJ5Oq84Jki54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBJ/L1nKkInyngz35EAztDHku0prGJOCA4mPp4v203L9Fu4EfbmcMcqYF+M718XtY
	 otC715E4JoMgHSZ9cY/6eM28AzccS9kx20ifC/texdtpPXq2lfG2Ea96xRTtr+yt6d
	 Zob1UJ1c/0unJZXcIT8figMDdg0O/Pl51BoZ4bGUaH+nGwVARDOoKYlMFwurqlsUjd
	 /ENFzKru7mJvPU0MAsEkq13TLaiw3WuJTgJw0V8fmZPMOaCtdQJECXpU2PNtJyKpXo
	 6Wto8Plc7OkrFTEXMDdd9JrbtYC/3KxBXIphNpKh8pGq6vYeXdwOboIg7uXiXSJtm3
	 6Tc3JMq1HvNww==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pt-00000006y6g-1zBE;
	Thu, 20 Nov 2025 17:25:57 +0000
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
Subject: [PATCH v4 15/49] KVM: arm64: GICv2: Preserve EOIcount on exit
Date: Thu, 20 Nov 2025 17:25:05 +0000
Message-ID: <20251120172540.2267180-16-maz@kernel.org>
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

EOIcount is how the virtual CPU interface signals that the guest
is deactivating interrupts outside of the LRs when EOImode==0.

We therefore need to preserve that information so that we can find
out what actually needs deactivating, just like we already do on
GICv3.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 74efacba38d42..5cfbe58983428 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -437,6 +437,12 @@ void vgic_v2_save_state(struct kvm_vcpu *vcpu)
 		return;
 
 	if (used_lrs) {
+		if (vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr & GICH_HCR_LRENPIE) {
+			u32 val = readl_relaxed(base + GICH_HCR);
+
+			vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr &= ~GICH_HCR_EOICOUNT;
+			vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr |= val & GICH_HCR_EOICOUNT;
+		}
 		save_lrs(vcpu, base);
 		writel_relaxed(0, base + GICH_HCR);
 	}
-- 
2.47.3



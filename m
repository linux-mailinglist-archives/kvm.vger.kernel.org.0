Return-Path: <kvm+bounces-63928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C5960C75B9F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 07FE22DCD4
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27E6374120;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StqbXxfv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF514350A26;
	Thu, 20 Nov 2025 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659559; cv=none; b=XrrUw3w6MQQ+h1buvVkjI2U0s37txQSdtw+L/jkcewyDJOtIdomQc+m4djnqSvcd3SWhBO/Jv86NM524L89wQH6kPdF+npJBwbVVi3+gi9LgTArCZfl0vBZxqnvDDi04Wi+cNq+ghdjBvFcPzIXNB08wNHlTRU0089p69o0lr4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659559; c=relaxed/simple;
	bh=Qxm/npw8Uip8/iAEYKriMxuKyP/eZuOgIrz+o31fqa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWYgt1lYAFas/8hPGn+oDPxZzV393AC8YXOs9DIpMD9yzaI4n0+vjbIxhS5lh/BEtPMAllwTp4OpvWGuGcaYcmnzx8HHqYInATrrFY6Pe4QIQxeZrgs4XH8L2ZsfFPJRIhaAmoaXT+kFSdJKHh+RItoXl/MIa9G2yZDfrpsAyKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StqbXxfv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C76EC4CEF1;
	Thu, 20 Nov 2025 17:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659558;
	bh=Qxm/npw8Uip8/iAEYKriMxuKyP/eZuOgIrz+o31fqa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StqbXxfvsYTf5jBozKkGyNWw0Ibq29md401enXy0Ay8R48lfqzaL1JbsJwRPNXrpn
	 Xf3/lIWrWs4l2DizpunyKY/lQv0JgAml1OsRWcliY8I0oK8ASqjUyaKr8Y25p271MX
	 rP4V+a0sGRRRvZY9gwMYZXx4LMJupQDc9OFkLTRJpaBrZfo1+DZreON09mkShGpCyO
	 ID3L1bEFXeUDeu/OuFpcpOlmBK4W5EkJ4L7gK4OT5XHTj/IB4EiirJ2HYW2xwfXT3a
	 NhF6yYJRzD5lo7oINDJHtcoENS72LXYAqaCLU65PB1K4SnHIR+rZFgvlCCLtEghx/B
	 Tj6lWrBMrlcdg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Ps-00000006y6g-20G2;
	Thu, 20 Nov 2025 17:25:56 +0000
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
Subject: [PATCH v4 11/49] KVM: arm64: GICv3: Preserve EOIcount on exit
Date: Thu, 20 Nov 2025 17:25:01 +0000
Message-ID: <20251120172540.2267180-12-maz@kernel.org>
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
out what actually needs deactivating.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index e72d436dd6a36..9bfcbfd91118a 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -225,6 +225,12 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 
 		elrsr = read_gicreg(ICH_ELRSR_EL2);
 
+		if (cpu_if->vgic_hcr & ICH_HCR_EL2_LRENPIE) {
+			u64 val = read_gicreg(ICH_HCR_EL2);
+			cpu_if->vgic_hcr &= ~ICH_HCR_EL2_EOIcount;
+			cpu_if->vgic_hcr |= val & ICH_HCR_EL2_EOIcount;
+		}
+
 		write_gicreg(0, ICH_HCR_EL2);
 
 		for (i = 0; i < used_lrs; i++) {
-- 
2.47.3



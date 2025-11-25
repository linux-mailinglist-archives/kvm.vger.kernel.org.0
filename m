Return-Path: <kvm+bounces-64558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4A0C86FE8
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:18:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6B1024EBA09
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F14F33B974;
	Tue, 25 Nov 2025 20:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9eQXmzQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A52633B6E0;
	Tue, 25 Nov 2025 20:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764101841; cv=none; b=Ep990GY6fWqdN5UZK84yNFJa4ZOWh9H2/JsIiDU+GbAEM+/jkbTz6jwhtAomnccbfdxI3Bre8VpYpjJAWAyEttB8XoSQIaHVSFrDAcXkNdjkJxme1hju4Ggkd8VuMaQiATEasTtwLPBVyxZ+QDU2K0ANq5HazxPA21AZdL18YJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764101841; c=relaxed/simple;
	bh=hzbR14ZISIMAgrKscEtE9O4AxjI+YtVWZFwOy9uJXg8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pvcrIQfO3Niw8dYt5yYzwO5dvDVVh7/8J1nMBym39xBSaHFo/ruCdcdhhlBvKMNUW82ZXdseH+V7tucB+OurPMbfXFDYPTvqDYHRoG9qZgLK8IHet69y1Jvid4zWEOk0tFbIRXNyPdVfSAIW365HADvP3Qpr1QJa07OHUur8cfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9eQXmzQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8301C4CEF1;
	Tue, 25 Nov 2025 20:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764101840;
	bh=hzbR14ZISIMAgrKscEtE9O4AxjI+YtVWZFwOy9uJXg8=;
	h=From:To:Cc:Subject:Date:From;
	b=S9eQXmzQ0b9CochquTo+PVGfqqmazZyHHt6+I/eoi1j9d1AE5pyPqxnPQ3mUHJhbM
	 ncrdnVuaVfDsKuevkOzRYWPefitMvYU7uYBMkofOMoLe+842CXzM1+DDPJVdI3FjLd
	 Bo2gH/+eLkV96ygSzq3Oa8VnTbzna2v8ZRwN6Zr93KQBIcdZoEGkCDVBP2C48xCoJZ
	 rXtBOsnFAk+dMVTh4Rg0XP/t0OqcOwTDMs84a9pBGeMtyJXgHvl9ZPzxxKhcHarkT2
	 eOfioK9DFUpUiDwgPBRGpKI004+yT3I5FzqDc0cJw0l01665bdcaGcXnT5/CWVYSYy
	 983m5Hpdwl0mw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vNzTS-00000008Gpd-3C63;
	Tue, 25 Nov 2025 20:17:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] KVM: arm64: Don't use FIELD_PREP() in initialisers
Date: Tue, 25 Nov 2025 20:17:15 +0000
Message-ID: <20251125201715.1133405-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, nathan@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Nathan reports that compiling with CONFIG_PTDUMP_STAGE2_DEBUGFS
results in a compilation failure, with the compiler moaning about
"braced-group within expression allowed only inside a function"...

Replace FIELD_PREP() with its shifting primitive, which does the
trick here.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Fixes: 81e9fe5c6f25d ("KVM: arm64: Teach ptdump about FEAT_XNX permissions")
Closes: https://lore.kernel.org/r/20251125173929.GA3256322@ax162
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/ptdump.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index bd722383d0e3f..6cbe018fd6fda 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -46,22 +46,22 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
 	},
 	{
 		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
-		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b00),
+		.val	= 0b00UL << __bf_shf(KVM_PTE_LEAF_ATTR_HI_S2_XN),
 		.set	= "px ux ",
 	},
 	{
 		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
-		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b01),
+		.val	= 0b01UL << __bf_shf(KVM_PTE_LEAF_ATTR_HI_S2_XN),
 		.set	= "PXNux ",
 	},
 	{
 		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
-		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10),
+		.val	= 0b10UL << __bf_shf(KVM_PTE_LEAF_ATTR_HI_S2_XN),
 		.set	= "PXNUXN",
 	},
 	{
 		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
-		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b11),
+		.val	= 0b11UL << __bf_shf(KVM_PTE_LEAF_ATTR_HI_S2_XN),
 		.set	= "px UXN",
 	},
 	{
-- 
2.47.3



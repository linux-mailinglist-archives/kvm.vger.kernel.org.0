Return-Path: <kvm+bounces-63029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A8FC59434
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 18:48:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DD8754F34BF
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 17:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421A92EB5B8;
	Thu, 13 Nov 2025 17:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKlg/Txr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9D2281525;
	Thu, 13 Nov 2025 17:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763054731; cv=none; b=fNR28kKZh0wycQBbT3EqNTc3XMY24Qe4k7vA0YGN/vX/Gd6tgj/XqZP8abSaioEy0QDKl1aWpVp9bpJdc1SIziXCrhGgkqGlj4qPG3l+Zm1xbaaFdy/hwxIGi7C6nj9hyMYC4kSFeZCDNFhVCmmsJzQJRyNnjFV94D6cxEDhvgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763054731; c=relaxed/simple;
	bh=MGcf2zVIHQnkSUY5McLemWtDefzifDwz1x3OzNPv4CY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BVLW/IkJLoDPPDZPlRttFU6spCrpUrFp/6wM35tkb0q4Yaz2rlFqODEaglKhD8Tbr9hGRHeG/IG2/qysfmN9UPSQwUIZk/v7XhwpuJvE0m1b3wJ6p8zKZr523cWU2+2O8vWHcGeP/Ui4Zm5W5VPe0cNFVLEQG2cHbNbKf38LwhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKlg/Txr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C55AC4CEF5;
	Thu, 13 Nov 2025 17:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763054730;
	bh=MGcf2zVIHQnkSUY5McLemWtDefzifDwz1x3OzNPv4CY=;
	h=From:To:Cc:Subject:Date:From;
	b=fKlg/TxrqZ9J/vGmga9SZoE7TIeaZuqsEmxyMSIzWzombRjl7vqVjMQQ1wEoQy7JO
	 ntU0myS4O9Qh+/lpm1MQ4Jv38hDKApDPJ/YZia+126dHRJ/1UxUPCgSpyIWtgFMLyB
	 zOZe+ZzEo0HO+4qfo/2Tvt57cH2JAQyG1za+ZhwIsZWZvUIiAPJbTU5YePER+1ceXa
	 wYhBXpQCw7xOOLKy52yHBNUz5IX4IwfTMmsIqAx34wF9leG2kTXiBOs6kGx7UOxlrD
	 7AA0n0rTj38dunjHmLdrTOIDpksBGvPaUOn7CrA3bPx0IUlDBqgvtk76G4VdIYUk7/
	 L76pRuohXdFtQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vJb4a-00000004xKh-0h6Q;
	Thu, 13 Nov 2025 17:25:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] KVM: arm64: GICv3: Check the implementation before accessing ICH_VTR_EL2
Date: Thu, 13 Nov 2025 17:25:24 +0000
Message-ID: <20251113172524.2795158-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, m.szyprowski@samsung.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The ICH_HCR_EL2 patching code is generally GIC implementation agnostic,
except when checking for broken Apple HW, which imposes to read
ICH_VTR_EL2.

It is therefore important to check whether we are running on such
HW before reading this register, as it will otherwise UNDEF when
run on HW that doesn't have GICv3.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: ca30799f7c2d ("KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant")
Closes: https://lore.kernel.org/r/b618732b-fd26-49e0-84c5-bfd54be09cd2@samsung.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index fc7a4cb8e231d..598621b14a30d 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -829,8 +829,8 @@ static const struct midr_range broken_seis[] = {
 static bool vgic_v3_broken_seis(void)
 {
 	return (is_kernel_in_hyp_mode() &&
-		(read_sysreg_s(SYS_ICH_VTR_EL2) & ICH_VTR_EL2_SEIS) &&
-		is_midr_in_range_list(broken_seis));
+		is_midr_in_range_list(broken_seis) &&
+		(read_sysreg_s(SYS_ICH_VTR_EL2) & ICH_VTR_EL2_SEIS));
 }
 
 void noinstr kvm_compute_ich_hcr_trap_bits(struct alt_instr *alt,
-- 
2.47.3



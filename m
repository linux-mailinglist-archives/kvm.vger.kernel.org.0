Return-Path: <kvm+bounces-44752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDC2AA0A7B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91300842F8F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 11:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4DA2D1921;
	Tue, 29 Apr 2025 11:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eef7Ny0N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4482C374B;
	Tue, 29 Apr 2025 11:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745927013; cv=none; b=W8vGelRsGPffuQJGJZtTHwtTQmdsyzUjM6zrhc0ABsHzlAIfKxcG06k1umyabvubPaBh+pjKkyWXug+oRkYJMi04MBOd3wZ8vZjDJ+IvUiR7HYYaFeDcQhR9f4KSk/AW1zAjMOsCnrBHqL7xvtEHPKVCdxlgT1iYekn8/Vc6vpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745927013; c=relaxed/simple;
	bh=9ZzZ2PUUe62ESKAkB2c5E8q80p5NNCf2tGXDF7sXtlA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u+hQhwTyuyXNm4I6JJg8nmdGAGTtWFx2yX6X1x8UWMCut7QPw7OYdPLmG2EZNkoE0gu2LC0QKfpjkW0iJn6dyBbwSCXGMQ907z++NkwQmbKDgihGz8/bukNDPp+FOV49LhgCN28OjeYIkiLtT67RXU7M6vkdm3eaI7tawHuXaB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eef7Ny0N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D4BC4CEE3;
	Tue, 29 Apr 2025 11:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745927011;
	bh=9ZzZ2PUUe62ESKAkB2c5E8q80p5NNCf2tGXDF7sXtlA=;
	h=From:To:Cc:Subject:Date:From;
	b=Eef7Ny0Nw1TSqWdRODz4I099aCTZln80IlK5ML2ODp35P7NV5Z6uBafKBI2BCfT8j
	 tG2CgqLMZlwc4X0do2X9+RG6vD7NwjCs8tHxqGyLJmWaoigZTlntAaqxKcIH72uG/p
	 /r3QtlD3RNShyID2I6kIaC2qUhde7kLVU+DQJt6euHZn+r63H0UAi6J24qKhZ5RNOU
	 95bbx+r3K7t6dbSKnfbZnBrB0DDxybnaSNdCDNDQDNUVmMP2QMS7JHDgBFWFzYqcQG
	 caEGtoF+F3QvYBbQNKAZz/cwsj+ZuXk7Heayg6DOSjtDUU+hZIWHQSNPVl+HpJ2r5K
	 zA3PfYHylyxOA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u9jN3-009t4S-LJ;
	Tue, 29 Apr 2025 12:43:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	D Scott Phillips <scott@os.amperecomputing.com>
Subject: [PATCH v2] KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
Date: Tue, 29 Apr 2025 12:43:26 +0100
Message-Id: <20250429114326.3618875-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, scott@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We keep setting and clearing these bits depending on the role of
the host kernel, mimicking what we do for nVHE. But that's actually
pretty pointless, as we always want physical interrupts to make it
to the host, at EL2.

This has also two problems:

- it prevents IRQs from being taken when these bits are cleared
  if the implementation has chosen to implement these bits as
  masks when HCR_EL2.{TGE,xMO}=={0,0}

- it triggers a bad erratum on the AmpereOne HW, which catches
  fire on clearing these bits while an interrupt is being taken
  (AC03_CPU_36).

Let's kill these two birds with a single stone, and permanently
set the xMO bits when running VHE. This involves a bit of surgery
on code paths that rely on flipping these bits on and off for
other purposes.

Note that the earliest setting of hcr_el2 (in the init_hcr_el2
macro) is left untouched as is runs extremely early, with interrupts
disabled, and soon enough overwritten with the final value containing
the xMO bits.

Reported-by: D Scott Phillips <scott@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h |  2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c  | 36 +++++++++++++++++++-------------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 974d72b5905b8..bba4b0e930915 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -100,7 +100,7 @@
 			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID1)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
-#define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
+#define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H | HCR_AMO | HCR_IMO | HCR_FMO)
 
 #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
 #define MPAMHCR_HOST_FLAGS	0
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index ed363aa3027e5..50aa8dbcae75b 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -429,23 +429,27 @@ u64 __vgic_v3_get_gic_config(void)
 	/*
 	 * To check whether we have a MMIO-based (GICv2 compatible)
 	 * CPU interface, we need to disable the system register
-	 * view. To do that safely, we have to prevent any interrupt
-	 * from firing (which would be deadly).
+	 * view.
 	 *
-	 * Note that this only makes sense on VHE, as interrupts are
-	 * already masked for nVHE as part of the exception entry to
-	 * EL2.
-	 */
-	if (has_vhe())
-		flags = local_daif_save();
-
-	/*
 	 * Table 11-2 "Permitted ICC_SRE_ELx.SRE settings" indicates
 	 * that to be able to set ICC_SRE_EL1.SRE to 0, all the
 	 * interrupt overrides must be set. You've got to love this.
+	 *
+	 * As we always run VHE with HCR_xMO set, no extra xMO
+	 * manipulation is required in that case.
+	 *
+	 * To safely disable SRE, we have to prevent any interrupt
+	 * from firing (which would be deadly). This only makes sense
+	 * on VHE, as interrupts are already masked for nVHE as part
+	 * of the exception entry to EL2.
 	 */
-	sysreg_clear_set(hcr_el2, 0, HCR_AMO | HCR_FMO | HCR_IMO);
-	isb();
+	if (has_vhe()) {
+		flags = local_daif_save();
+	} else {
+		sysreg_clear_set(hcr_el2, 0, HCR_AMO | HCR_FMO | HCR_IMO);
+		isb();
+	}
+
 	write_gicreg(0, ICC_SRE_EL1);
 	isb();
 
@@ -453,11 +457,13 @@ u64 __vgic_v3_get_gic_config(void)
 
 	write_gicreg(sre, ICC_SRE_EL1);
 	isb();
-	sysreg_clear_set(hcr_el2, HCR_AMO | HCR_FMO | HCR_IMO, 0);
-	isb();
 
-	if (has_vhe())
+	if (has_vhe()) {
 		local_daif_restore(flags);
+	} else {
+		sysreg_clear_set(hcr_el2, HCR_AMO | HCR_FMO | HCR_IMO, 0);
+		isb();
+	}
 
 	val  = (val & ICC_SRE_EL1_SRE) ? 0 : (1ULL << 63);
 	val |= read_gicreg(ICH_VTR_EL2);
-- 
2.39.2



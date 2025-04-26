Return-Path: <kvm+bounces-44434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27F21A9DAA4
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACB64178238
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF773253945;
	Sat, 26 Apr 2025 12:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPeQP85j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A9B253344;
	Sat, 26 Apr 2025 12:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670537; cv=none; b=Ny7/Bm4HZ+SUbBhQYSpe4REl/u4AQRJBLSmQNQEhlGy8S6vgbJRkz2OdYYuWHlaCWkkPx88ijwoBhJRdDbrpIlD3fx7ULQUewqeM6eyKF2acVgD/CRFkNFUGv7C1/u7ZFFGUXQfGq0Deo8pKlhcuhbG8sM/LwymdufyvGX30SBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670537; c=relaxed/simple;
	bh=LqwKgDJzzrWXnhuECxO/djlAD9kZbExAEmBWQBVwwpQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tchFCPDS14E3q+hyJA4c7/WdxFHdiGnYTOqLee7+SyWiI2mCPjbJgiLk2EEwsQBU7gmWPkOHdvIrvSInYswczsDgoscI1XmZHHlJPjP9n3q/kWijTcw/tB7kr1Ji/vYh1BAVyoAsxLLMQEBilhwurd9wNAAUJZWDNfvfhoYG24A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPeQP85j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62CAC4CEE2;
	Sat, 26 Apr 2025 12:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670536;
	bh=LqwKgDJzzrWXnhuECxO/djlAD9kZbExAEmBWQBVwwpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPeQP85jwPSu22aevdCz3XoSElrFM3kAXHU+uf4vUiH4Qc/p8Az/+JJlKWUiDUh5p
	 k1FuKysJRAW3GOPMF0dBFgDRK12NEhAe4gik0+c3sA+q7btCQK01NAy+na8Bi8PS+4
	 x0G/jAb788zdPJmzG40Du5DUE9FUk81BYnIkLYaX7JLoLEIeFjFpsdXLLLUZ1fsQm6
	 EZgXCwPdnaGLDuJvpbqeRiZntwCtu4G/9UvkO3duqMAKJbIEVIonPNJNuqaUaDhypo
	 hsP0CmI77Os0Jhx+vxELS7YU+L4WAMCmMkVLdOEGp3TsJ2hpPH+zYzlh6uuzTlDqEB
	 LpE4yKV6UXTEQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeN-0092VH-1f;
	Sat, 26 Apr 2025 13:28:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 23/42] KVM: arm64: Use computed masks as sanitisers for FGT registers
Date: Sat, 26 Apr 2025 13:28:17 +0100
Message-Id: <20250426122836.3341523-24-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have computed RES0 bits, use them to sanitise the
guest view of FGT registers.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 16f6129c70b59..479ffd25eea63 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1137,8 +1137,8 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 		res0 |= HFGRTR_EL2_nS2POR_EL1;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
 		res0 |= (HFGRTR_EL2_nMAIR2_EL1 | HFGRTR_EL2_nAMAIR2_EL1);
-	set_sysreg_masks(kvm, HFGRTR_EL2, res0 | __HFGRTR_EL2_RES0, res1);
-	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | __HFGWTR_EL2_RES0, res1);
+	set_sysreg_masks(kvm, HFGRTR_EL2, res0 | hfgrtr_masks.res0, res1);
+	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | hfgwtr_masks.res0, res1);
 
 	/* HDFG[RW]TR_EL2 */
 	res0 = res1 = 0;
@@ -1176,7 +1176,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 			 HDFGRTR_EL2_nBRBDATA);
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2))
 		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
-	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | HDFGRTR_EL2_RES0, res1);
+	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | hdfgrtr_masks.res0, res1);
 
 	/* Reuse the bits from the read-side and add the write-specific stuff */
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
@@ -1185,10 +1185,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 		res0 |= HDFGWTR_EL2_TRCOSLAR;
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
 		res0 |= HDFGWTR_EL2_TRFCR_EL1;
-	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | HDFGWTR_EL2_RES0, res1);
+	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | hdfgwtr_masks.res0, res1);
 
 	/* HFGITR_EL2 */
-	res0 = HFGITR_EL2_RES0;
+	res0 = hfgitr_masks.res0;
 	res1 = HFGITR_EL2_RES1;
 	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, DPB, DPB2))
 		res0 |= HFGITR_EL2_DCCVADP;
@@ -1222,7 +1222,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	set_sysreg_masks(kvm, HFGITR_EL2, res0, res1);
 
 	/* HAFGRTR_EL2 - not a lot to see here */
-	res0 = HAFGRTR_EL2_RES0;
+	res0 = hafgrtr_masks.res0;
 	res1 = HAFGRTR_EL2_RES1;
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
 		res0 |= ~(res0 | res1);
-- 
2.39.2



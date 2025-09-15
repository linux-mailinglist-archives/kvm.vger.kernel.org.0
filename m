Return-Path: <kvm+bounces-57549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0B8EB578CA
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:45:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 555A73A73FD
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0D52FFDDA;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WI/EZQOE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4944B2FD1B5;
	Mon, 15 Sep 2025 11:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936697; cv=none; b=cPGHhZg8R7p2MDr0JFbonhck9i8zRDlT3LEn1jVKOD3+BEkWiNu4BOWtZ9+nszFC5RSEBYp0wf7vF2UY2vYxzs1dje8gvS2CNIxMxigFW3Xo4QTLVyPGjKlSIFmHOc4aASoWs3OLKi6i3pJ10vATXDmUlgJGUI01XBfEJ3taX+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936697; c=relaxed/simple;
	bh=ZAvEqXSsF8rnvtvXK2ptMKYukFOlYKwTSe9TJILQtKg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VfvPsIr/uOXX2zFDCRWq3Rp0zG315cjQSU5ybWNf/EPVIBD9WfREmkVdoWb31PSY3tvJ2ds1zR8j40jk1aAuXqEc0XA3iDSrO5DmOoqEKIt+XIm4drSsiGENSrZBe53tEBV+ZfIJEOl2XT+G6p0MssqjIzCu1L+Pk0sWiPFASs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WI/EZQOE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D51C4CEF7;
	Mon, 15 Sep 2025 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936697;
	bh=ZAvEqXSsF8rnvtvXK2ptMKYukFOlYKwTSe9TJILQtKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WI/EZQOE55YGB7D/WKKNEvGqsa/JMeEeeCURsAFJSh3duvFO3hS6vLx+DttJOspnK
	 mfQfK7MmUKc+pdgPllEu6Ha49iOMB9ecQLOSCh/UgeU6ZvHpX08t0QphyYRjIydAnO
	 P5iVdfTLBCqzzdDwaA7oJWjRYdTIUH7esVCxl5mbkZEm4t4kslQms4BeL3dyV/o56U
	 /d074gLuqXGTbpbGNi9RArwXWiKGXBhMGNmtUoC0Q2FoEVg/qdYN30ky8AqVKGO0nz
	 57lTTwjMadq70R/Q24lWyJc8xd9fW53uB9Xt2MzAcBCnCKPB1dnS0r2wSeC1VPIYhO
	 Qpk2NfTIGyR4g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7df-00000006MDw-0WZD;
	Mon, 15 Sep 2025 11:44:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 01/16] KVM: arm64: Add helper computing the state of 52bit PA support
Date: Mon, 15 Sep 2025 12:44:36 +0100
Message-Id: <20250915114451.660351-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Track whether the guest is using 52bit PAs, either LPA or LPA2.
This further simplifies the handling of LVA for 4k and 16k pages,
as LPA2 implies LVA in this case.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/at.c                 | 31 ++++++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 7fd76f41c296a..038e35430bb2c 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -299,6 +299,7 @@ struct s1_walk_info {
 	bool			pan;
 	bool	     		be;
 	bool	     		s2;
+	bool			pa52bit;
 };
 
 struct s1_walk_result {
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index d71ca4ddc9d1e..8e275ea68cfa8 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -31,6 +31,29 @@ static bool check_output_size(u64 ipa, struct s1_walk_info *wi)
 	return wi->max_oa_bits < 48 && (ipa & GENMASK_ULL(47, wi->max_oa_bits));
 }
 
+static bool has_52bit_pa(struct kvm_vcpu *vcpu, struct s1_walk_info *wi, u64 tcr)
+{
+	switch (BIT(wi->pgshift)) {
+	case SZ_64K:
+	default:		/* IMPDEF: treat any other value as 64k */
+		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, PARANGE, 52))
+			return false;
+		return ((wi->regime == TR_EL2 ?
+			 FIELD_GET(TCR_EL2_PS_MASK, tcr) :
+			 FIELD_GET(TCR_IPS_MASK, tcr)) == 0b0110);
+	case SZ_16K:
+		if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN16, 52_BIT))
+			return false;
+		break;
+	case SZ_4K:
+		if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN4, 52_BIT))
+			return false;
+		break;
+	}
+
+	return (tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS));
+}
+
 /* Return the translation regime that applies to an AT instruction */
 static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 op)
 {
@@ -232,15 +255,13 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			goto transfault_l0;
 	}
 
+	wi->pa52bit = has_52bit_pa(vcpu, wi, tcr);
+
 	/* R_GTJBY, R_SXWGM */
 	switch (BIT(wi->pgshift)) {
 	case SZ_4K:
-		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN4, 52_BIT);
-		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS);
-		break;
 	case SZ_16K:
-		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN16, 52_BIT);
-		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS);
+		lva = wi->pa52bit;
 		break;
 	case SZ_64K:
 		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, VARange, 52);
-- 
2.39.2



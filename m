Return-Path: <kvm+bounces-55899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80D12B38782
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16A0C17F22F
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F72F35AAA7;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAVRwre2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF91352061;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311050; cv=none; b=Y+SX7FDgNexqepZK985fL58S/9vligwJQaHPRqHedJu4yZc7k3wlnT2nf60q488mqr/IIicIFRVmgC83TdKAJehOvxHElsrCnVlZsVQ29gUAoNKz0ZchBVDPNgk9KPDBQ4U3QphJKXT6Iz3kGaTNQnJPnW+bSnd76zrZ+XipcX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311050; c=relaxed/simple;
	bh=w87rfqe0fgMADYYjpvVVWDQ70sq0JPNkpi0ohmUzjz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=drrmFzTtJ5QhcaAw7MWt9ctFPHStnbrD2w1tNwxhBxnW8UF6j5PghiLonHZ7Sqm4paIygt/Qmn6Q+DyKICbVT4xbJ/WP+fZsLBSV4EUHLr8e3uIaHhw8h0++dX5hUvlIoNyXhq7C8NGPQEJgyOEa2IieCu1G+5Cogfehac8krtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PAVRwre2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB0FC4CEF7;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311050;
	bh=w87rfqe0fgMADYYjpvVVWDQ70sq0JPNkpi0ohmUzjz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAVRwre2dfKRnQbp+5RVkL4OvJancYGXZsrDCd0uRgjgYW1SPDYQ6zUVYYXIl5NFR
	 BQ0iltCxUeI6qNl0fjjtLq7/rnz3kP+SnXLS+DUjv3VNIawfRBrqaXNX8sOVMgQ/hO
	 PbRi++PYGw3lTnfsJRXrKujOXWkYawE92G+2b/LhjajNyoQ+MBNaiwrcwlHaP545cO
	 ja3yGdD/lBdTtydhoUGceyKtu9PuIQjQLg5uYUAZffd+GR0FDZsnvC5nUQF7EK8FTQ
	 aTxQS4q3dEGPKeQdhok8QXHXkKZbXpNoU74hQzO0jBeD41TKdUPZJuLnhgKKQufsEK
	 OqDcdRh8ZRSXQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjY-00000000yGc-1Det;
	Wed, 27 Aug 2025 16:10:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 09/16] KVM: arm64: Report faults from S1 walk setup at the expected start level
Date: Wed, 27 Aug 2025 17:10:31 +0100
Message-Id: <20250827161039.938958-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250827161039.938958-1-maz@kernel.org>
References: <20250827161039.938958-1-maz@kernel.org>
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

Translation faults from TTBR must be reported on the start level,
and not level-0. Enforcing this requires moving quite a lot of
code around so that the start level can be computed early enough
that it is usable.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 103 +++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 49 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index f58dfbb4df891..3bc6cc00ab9a6 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -154,9 +154,6 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	va55 = va & BIT(55);
 
-	if (wi->regime == TR_EL2 && va55)
-		goto addrsz;
-
 	wi->s2 = wi->regime == TR_EL10 && (hcr & (HCR_VM | HCR_DC));
 
 	switch (wi->regime) {
@@ -179,6 +176,46 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		BUG();
 	}
 
+	/* Someone was silly enough to encode TG0/TG1 differently */
+	if (va55 && wi->regime != TR_EL2) {
+		wi->txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
+		tg = FIELD_GET(TCR_TG1_MASK, tcr);
+
+		switch (tg << TCR_TG1_SHIFT) {
+		case TCR_TG1_4K:
+			wi->pgshift = 12;	 break;
+		case TCR_TG1_16K:
+			wi->pgshift = 14;	 break;
+		case TCR_TG1_64K:
+		default:	    /* IMPDEF: treat any other value as 64k */
+			wi->pgshift = 16;	 break;
+		}
+	} else {
+		wi->txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
+		tg = FIELD_GET(TCR_TG0_MASK, tcr);
+
+		switch (tg << TCR_TG0_SHIFT) {
+		case TCR_TG0_4K:
+			wi->pgshift = 12;	 break;
+		case TCR_TG0_16K:
+			wi->pgshift = 14;	 break;
+		case TCR_TG0_64K:
+		default:	    /* IMPDEF: treat any other value as 64k */
+			wi->pgshift = 16;	 break;
+		}
+	}
+
+	wi->pa52bit = has_52bit_pa(vcpu, wi, tcr);
+
+	ia_bits = get_ia_size(wi);
+
+	/* AArch64.S1StartLevel() */
+	stride = wi->pgshift - 3;
+	wi->sl = 3 - (((ia_bits - 1) - wi->pgshift) / stride);
+
+	if (wi->regime == TR_EL2 && va55)
+		goto addrsz;
+
 	tbi = (wi->regime == TR_EL2 ?
 	       FIELD_GET(TCR_EL2_TBI, tcr) :
 	       (va55 ?
@@ -248,46 +285,15 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	/* R_BVXDG */
 	wi->hpd |= (wi->poe || wi->e0poe);
 
-	/* Someone was silly enough to encode TG0/TG1 differently */
-	if (va55) {
-		wi->txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
-		tg = FIELD_GET(TCR_TG1_MASK, tcr);
-
-		switch (tg << TCR_TG1_SHIFT) {
-		case TCR_TG1_4K:
-			wi->pgshift = 12;	 break;
-		case TCR_TG1_16K:
-			wi->pgshift = 14;	 break;
-		case TCR_TG1_64K:
-		default:	    /* IMPDEF: treat any other value as 64k */
-			wi->pgshift = 16;	 break;
-		}
-	} else {
-		wi->txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
-		tg = FIELD_GET(TCR_TG0_MASK, tcr);
-
-		switch (tg << TCR_TG0_SHIFT) {
-		case TCR_TG0_4K:
-			wi->pgshift = 12;	 break;
-		case TCR_TG0_16K:
-			wi->pgshift = 14;	 break;
-		case TCR_TG0_64K:
-		default:	    /* IMPDEF: treat any other value as 64k */
-			wi->pgshift = 16;	 break;
-		}
-	}
-
 	/* R_PLCGL, R_YXNYW */
 	if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, ST, 48_47)) {
 		if (wi->txsz > 39)
-			goto transfault_l0;
+			goto transfault;
 	} else {
 		if (wi->txsz > 48 || (BIT(wi->pgshift) == SZ_64K && wi->txsz > 47))
-			goto transfault_l0;
+			goto transfault;
 	}
 
-	wi->pa52bit = has_52bit_pa(vcpu, wi, tcr);
-
 	/* R_GTJBY, R_SXWGM */
 	switch (BIT(wi->pgshift)) {
 	case SZ_4K:
@@ -300,28 +306,22 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	}
 
 	if ((lva && wi->txsz < 12) || (!lva && wi->txsz < 16))
-		goto transfault_l0;
-
-	ia_bits = get_ia_size(wi);
+		goto transfault;
 
 	/* R_YYVYV, I_THCZK */
 	if ((!va55 && va > GENMASK(ia_bits - 1, 0)) ||
 	    (va55 && va < GENMASK(63, ia_bits)))
-		goto transfault_l0;
+		goto transfault;
 
 	/* I_ZFSYQ */
 	if (wi->regime != TR_EL2 &&
 	    (tcr & (va55 ? TCR_EPD1_MASK : TCR_EPD0_MASK)))
-		goto transfault_l0;
+		goto transfault;
 
 	/* R_BNDVG and following statements */
 	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, E0PD, IMP) &&
 	    wi->as_el0 && (tcr & (va55 ? TCR_E0PD1 : TCR_E0PD0)))
-		goto transfault_l0;
-
-	/* AArch64.S1StartLevel() */
-	stride = wi->pgshift - 3;
-	wi->sl = 3 - (((ia_bits - 1) - wi->pgshift) / stride);
+		goto transfault;
 
 	ps = (wi->regime == TR_EL2 ?
 	      FIELD_GET(TCR_EL2_PS_MASK, tcr) : FIELD_GET(TCR_IPS_MASK, tcr));
@@ -351,12 +351,17 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	return 0;
 
-addrsz:				/* Address Size Fault level 0 */
+addrsz:
+	/*
+	 * Address Size Fault level 0 to indicate it comes from TTBR.
+	 * yes, this is an oddity.
+	 */
 	fail_s1_walk(wr, ESR_ELx_FSC_ADDRSZ_L(0), false);
 	return -EFAULT;
 
-transfault_l0:			/* Translation Fault level 0 */
-	fail_s1_walk(wr, ESR_ELx_FSC_FAULT_L(0), false);
+transfault:
+	/* Translation Fault on start level */
+	fail_s1_walk(wr, ESR_ELx_FSC_FAULT_L(wi->sl), false);
 	return -EFAULT;
 }
 
-- 
2.39.2



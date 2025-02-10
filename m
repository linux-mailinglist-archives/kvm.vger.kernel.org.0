Return-Path: <kvm+bounces-37722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A679A2F790
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:44:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 379D53A1ACE
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D9282580CF;
	Mon, 10 Feb 2025 18:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L7ZvEJc5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750702586EF;
	Mon, 10 Feb 2025 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212922; cv=none; b=fOfKCANpZtLbFXIJ/hShP7teq60nYzkPGcuKHMKSWLDW071gj/osEzwCEsqO4VcTjkdQrjfw2o6ofq9oSyAft8/KoqcmMdUSl/2IhkGfYVRFHxKZ674SXJfaJGpV8eJ2MsD4Ql+Jeu+X09v5nUEZ4mK5h9jtMTIOnxX5Slszf0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212922; c=relaxed/simple;
	bh=fRWfMKtymz9mDUni3zoNkIs0jFSkw9WeSwVj5WK/r38=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u1Iyc5oTmskn20nBProko3o3SS/PldilQBO6xZGbDDuEQxLXYJMS5bWhBYHkQojxoj+nVnBN1C8/XcCrMerVto1Sg4ziV41cSSjNPHWDpehmfKyIsNT/ahfO08B5S2oAZaaf7vSxJKYsSB6FoybOyX5/h55Lh/8C7e6f94cCsA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L7ZvEJc5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2812BC4CEE8;
	Mon, 10 Feb 2025 18:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739212922;
	bh=fRWfMKtymz9mDUni3zoNkIs0jFSkw9WeSwVj5WK/r38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7ZvEJc5K6+OXlTWK5JEqXONEQR5nj8kJye1NWQx9/z/iXrRm35zJw/7og5jJE2Kw
	 23xiPQJ1aQg9++8D5Dn6eJaKGhSe5EoZH/EHlE/34b1W3YPIGCAyzdvgSeHGMrMm+5
	 Egj49MNenlhneDLc2hEStGbGrTj2ZnKpjSRUkY7AHbIm8gZmv17B7UYm/Oiexu0so4
	 Yjf3KkJR2H6kGabm7BNc9XoDgp0vi1ify3AcK7ihZPwAJk/+HPgZ0vAohOEFnoNM8J
	 RtVwdNv5Ab1MvNE3g768TskY6u+N+0U3zMYnUnMmdBpS8ib0akws9XAU/to4nwT73A
	 ANKHAH9jFm7Qw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1thYjI-002g2I-AB;
	Mon, 10 Feb 2025 18:42:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 13/18] KVM: arm64: Remove most hand-crafted masks for FGT registers
Date: Mon, 10 Feb 2025 18:41:44 +0000
Message-Id: <20250210184150.2145093-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250210184150.2145093-1-maz@kernel.org>
References: <20250210184150.2145093-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

These masks are now useless, and can be removed. One notable
exception is __HFGRTR_ONLY_MASK, as the sysreg file conflates
the HFGRTR_EL2 and HFGWTR_EL2 bits in a most unhelpful way.

To be fixed one day...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h        | 42 +------------------------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 19 -----------
 2 files changed, 1 insertion(+), 60 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index e424085f2aaca..af87afae6ca3d 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -314,56 +314,16 @@
 
 /*
  * FGT register definitions
- *
- * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
- * We're not using the generated masks as they are usually ahead of
- * the published ARM ARM, which we use as a reference.
- *
- * Once we get to a point where the two describe the same thing, we'll
- * merge the definitions. One day.
- */
-#define __HFGRTR_EL2_RES0	HFGxTR_EL2_RES0
-#define __HFGRTR_EL2_MASK	GENMASK(49, 0)
-#define __HFGRTR_EL2_nMASK	~(__HFGRTR_EL2_RES0 | __HFGRTR_EL2_MASK)
-
-/*
- * The HFGWTR bits are a subset of HFGRTR bits. To ensure we don't miss any
- * future additions, define __HFGWTR* macros relative to __HFGRTR* ones.
  */
 #define __HFGRTR_ONLY_MASK	(BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
 				 GENMASK(26, 25) | BIT(21) | BIT(18) | \
 				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
-#define __HFGWTR_EL2_RES0	(__HFGRTR_EL2_RES0 | __HFGRTR_ONLY_MASK)
-#define __HFGWTR_EL2_MASK	(__HFGRTR_EL2_MASK & ~__HFGRTR_ONLY_MASK)
-#define __HFGWTR_EL2_nMASK	~(__HFGWTR_EL2_RES0 | __HFGWTR_EL2_MASK)
-
-#define __HFGITR_EL2_RES0	HFGITR_EL2_RES0
-#define __HFGITR_EL2_MASK	(BIT(62) | BIT(60) | GENMASK(54, 0))
-#define __HFGITR_EL2_nMASK	~(__HFGITR_EL2_RES0 | __HFGITR_EL2_MASK)
-
-#define __HDFGRTR_EL2_RES0	HDFGRTR_EL2_RES0
-#define __HDFGRTR_EL2_MASK	(BIT(63) | GENMASK(58, 50) | GENMASK(48, 43) | \
-				 GENMASK(41, 40) | GENMASK(37, 22) | \
-				 GENMASK(19, 9) | GENMASK(7, 0))
-#define __HDFGRTR_EL2_nMASK	~(__HDFGRTR_EL2_RES0 | __HDFGRTR_EL2_MASK)
-
-#define __HDFGWTR_EL2_RES0	HDFGWTR_EL2_RES0
-#define __HDFGWTR_EL2_MASK	(GENMASK(57, 52) | GENMASK(50, 48) | \
-				 GENMASK(46, 44) | GENMASK(42, 41) | \
-				 GENMASK(37, 35) | GENMASK(33, 31) | \
-				 GENMASK(29, 23) | GENMASK(21, 10) | \
-				 GENMASK(8, 7) | GENMASK(5, 0))
-#define __HDFGWTR_EL2_nMASK	~(__HDFGWTR_EL2_RES0 | __HDFGWTR_EL2_MASK)
-
-#define __HAFGRTR_EL2_RES0	HAFGRTR_EL2_RES0
-#define __HAFGRTR_EL2_MASK	(GENMASK(49, 17) | GENMASK(4, 0))
-#define __HAFGRTR_EL2_nMASK	~(__HAFGRTR_EL2_RES0 | __HAFGRTR_EL2_MASK)
 
 /* Because the sysreg file mixes R and W... */
 #define HFGRTR_EL2_RES0		HFGxTR_EL2_RES0
 #define HFGWTR_EL2_RES0		(HFGRTR_EL2_RES0 | __HFGRTR_ONLY_MASK)
 
-/* Similar definitions for HCRX_EL2 */
+/* Polarity masks for HCRX_EL2 */
 #define __HCRX_EL2_RES0         HCRX_EL2_RES0
 #define __HCRX_EL2_MASK		(BIT(6))
 #define __HCRX_EL2_nMASK	~(__HCRX_EL2_RES0 | __HCRX_EL2_MASK)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f9cf5985561ab..a36bcf6ec0d32 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -156,17 +156,6 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 #define update_fgt_traps(hctxt, vcpu, kvm, reg)		\
 	update_fgt_traps_cs(hctxt, vcpu, kvm, reg, 0, 0)
 
-/*
- * Validate the fine grain trap masks.
- * Check that the masks do not overlap and that all bits are accounted for.
- */
-#define CHECK_FGT_MASKS(reg)							\
-	do {									\
-		BUILD_BUG_ON((__ ## reg ## _MASK) & (__ ## reg ## _nMASK));	\
-		BUILD_BUG_ON(~((__ ## reg ## _RES0) ^ (__ ## reg ## _MASK) ^	\
-			       (__ ## reg ## _nMASK)));				\
-	} while(0)
-
 static inline bool cpu_has_amu(void)
 {
        u64 pfr0 = read_sysreg_s(SYS_ID_AA64PFR0_EL1);
@@ -180,14 +169,6 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 
-	CHECK_FGT_MASKS(HFGRTR_EL2);
-	CHECK_FGT_MASKS(HFGWTR_EL2);
-	CHECK_FGT_MASKS(HFGITR_EL2);
-	CHECK_FGT_MASKS(HDFGRTR_EL2);
-	CHECK_FGT_MASKS(HDFGWTR_EL2);
-	CHECK_FGT_MASKS(HAFGRTR_EL2);
-	CHECK_FGT_MASKS(HCRX_EL2);
-
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		return;
 
-- 
2.39.2



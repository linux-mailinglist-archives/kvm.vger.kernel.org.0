Return-Path: <kvm+bounces-38700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D259CA3DBB1
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:50:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7406189F60A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5A81FE46D;
	Thu, 20 Feb 2025 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kf8BbQll"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339F51FBC98;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059355; cv=none; b=QkKJvxYduBp7zzmkLsC7TVLjzqxfOFtuRbBtlnTa3eK5ac+TtmEzkIUQCZMcxrwiM8mOPxPb+OMhyqC4jIZD7c2cQLAZ/HNSfvM4GAlt4JboTmerHBH89VyHOFPjS6ltKdbCQXw+A2mPhhoS+0HhSvjlGG3LIv2HpCWfrYS6ZTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059355; c=relaxed/simple;
	bh=56SIWRxmkIc0NGhh9uSDjlX1Hg9JEfvHAZmk7x9h1hQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HVz8cLMJwbmCVFXQcYsWHcpVLDcDJYOxQIqTWwUqMT8KVcfQwGg+4rJv9Aj1PPHWqM66chnlFmRdph/jdCVpU0wLTXhr7akl8qDWC/WKzO0PrTtTWfyslhS0EN7Pgr0f+CL1hDHBW7UYExpCSvYItxasMiV/kvU7MQomYhQQr6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kf8BbQll; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC56FC4CEE3;
	Thu, 20 Feb 2025 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059355;
	bh=56SIWRxmkIc0NGhh9uSDjlX1Hg9JEfvHAZmk7x9h1hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kf8BbQllYPYbt7gRXKiEdUNhhJc6yd7EGVYzJlR3p0iSwCyMyGcKaeR/Dso1gNEiM
	 KNnuVZxdxNNawXSSe2FKwsZIewHm690uSk39rZWDNP0ZnhbDjbkEn2dUvDYhr2UWfB
	 ye/R0mYnNX2TswLSbQ5enu8SaQaNIQI5khL0w9nJca2cnNlhfu8hwa13+q+rmxZ2LG
	 GAtmR0Xj6/TWf6N5TGYDBBGlMW8F0qcnFZ5R0G0PennML2btfTb1eYTbx4LWIybgH3
	 jD9hkn9OaYK/hLTZkQAfkLHj4+DcSom4WCiU5+WhXIyYupRU1i3BF8OWHkIlD9tze+
	 0bS7MSHiZEKQg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vR-006DXp-6B;
	Thu, 20 Feb 2025 13:49:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH v2 08/14] KVM: arm64: Enforce NV limits on a per-idregs basis
Date: Thu, 20 Feb 2025 13:49:01 +0000
Message-Id: <20250220134907.554085-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250220134907.554085-1-maz@kernel.org>
References: <20250220134907.554085-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are about to change the way the idreg reset values are computed,
move all the NV limits into a function that initialises one register
at a time.

This will be most useful in the upcoming patches. We take this opportunity
to remove the NV_FTR() macro and rely on the generated names instead.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 239 +++++++++++++++++++++++-----------------
 1 file changed, 136 insertions(+), 103 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9f140560a6f5d..2cc82e69ab523 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -16,9 +16,6 @@
 
 #include "sys_regs.h"
 
-/* Protection against the sysreg repainting madness... */
-#define NV_FTR(r, f)		ID_AA64##r##_EL1_##f
-
 /*
  * Ratio of live shadow S2 MMU per vcpu. This is a trade-off between
  * memory usage and potential number of different sets of S2 PTs in
@@ -807,133 +804,169 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
  * This list should get updated as new features get added to the NV
  * support, and new extension to the architecture.
  */
+static u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
+{
+	switch (reg) {
+	case SYS_ID_AA64ISAR0_EL1:
+		/* Support everything but TME */
+		val &= ~ID_AA64ISAR0_EL1_TME;
+		break;
+
+	case SYS_ID_AA64ISAR1_EL1:
+		/* Support everything but LS64 and Spec Invalidation */
+		val &= ~(ID_AA64ISAR1_EL1_LS64	|
+			 ID_AA64ISAR1_EL1_SPECRES);
+		break;
+
+	case SYS_ID_AA64PFR0_EL1:
+		/* No RME, AMU, MPAM, S-EL2, or RAS */
+		val &= ~(ID_AA64PFR0_EL1_RME	|
+			 ID_AA64PFR0_EL1_AMU	|
+			 ID_AA64PFR0_EL1_MPAM	|
+			 ID_AA64PFR0_EL1_SEL2	|
+			 ID_AA64PFR0_EL1_RAS	|
+			 ID_AA64PFR0_EL1_EL3	|
+			 ID_AA64PFR0_EL1_EL2	|
+			 ID_AA64PFR0_EL1_EL1	|
+			 ID_AA64PFR0_EL1_EL0);
+		/* 64bit only at any EL */
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL0, IMP);
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL1, IMP);
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL2, IMP);
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL3, IMP);
+		break;
+
+	case SYS_ID_AA64PFR1_EL1:
+		/* Only support BTI, SSBS, CSV2_frac */
+		val &= (ID_AA64PFR1_EL1_BT	|
+			ID_AA64PFR1_EL1_SSBS	|
+			ID_AA64PFR1_EL1_CSV2_frac);
+		break;
+
+	case SYS_ID_AA64MMFR0_EL1:
+		/* Hide ECV, ExS, Secure Memory */
+		val &= ~(ID_AA64MMFR0_EL1_EVC		|
+			 ID_AA64MMFR0_EL1_EXS		|
+			 ID_AA64MMFR0_EL1_TGRAN4_2	|
+			 ID_AA64MMFR0_EL1_TGRAN16_2	|
+			 ID_AA64MMFR0_EL1_TGRAN64_2	|
+			 ID_AA64MMFR0_EL1_SNSMEM);
+
+		/* Disallow unsupported S2 page sizes */
+		switch (PAGE_SIZE) {
+		case SZ_64K:
+			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16_2, NI);
+			fallthrough;
+		case SZ_16K:
+			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN4_2, NI);
+			fallthrough;
+		case SZ_4K:
+			/* Support everything */
+			break;
+		}
+
+		/*
+		 * Since we can't support a guest S2 page size smaller
+		 * than the host's own page size (due to KVM only
+		 * populating its own S2 using the kernel's page
+		 * size), advertise the limitation using FEAT_GTG.
+		 */
+		switch (PAGE_SIZE) {
+		case SZ_4K:
+			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN4_2, IMP);
+			fallthrough;
+		case SZ_16K:
+			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16_2, IMP);
+			fallthrough;
+		case SZ_64K:
+			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN64_2, IMP);
+			break;
+		}
+
+		/* Cap PARange to 48bits */
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR0_EL1, PARANGE, 48);
+		break;
+
+	case SYS_ID_AA64MMFR1_EL1:
+		val &= (ID_AA64MMFR1_EL1_HCX	|
+			ID_AA64MMFR1_EL1_PAN	|
+			ID_AA64MMFR1_EL1_LO	|
+			ID_AA64MMFR1_EL1_HPDS	|
+			ID_AA64MMFR1_EL1_VH	|
+			ID_AA64MMFR1_EL1_VMIDBits);
+		break;
+
+	case SYS_ID_AA64MMFR2_EL1:
+		val &= ~(ID_AA64MMFR2_EL1_BBM	|
+			 ID_AA64MMFR2_EL1_TTL	|
+			 GENMASK_ULL(47, 44)	|
+			 ID_AA64MMFR2_EL1_ST	|
+			 ID_AA64MMFR2_EL1_CCIDX	|
+			 ID_AA64MMFR2_EL1_VARange);
+
+		/* Force TTL support */
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR2_EL1, TTL, IMP);
+		break;
+
+	case SYS_ID_AA64MMFR4_EL1:
+		val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, E2H0, NI_NV1);
+		break;
+
+	case SYS_ID_AA64DFR0_EL1:
+		/* Only limited support for PMU, Debug, BPs, WPs, and HPMN0 */
+		val &= (ID_AA64DFR0_EL1_PMUVer	|
+			ID_AA64DFR0_EL1_WRPs	|
+			ID_AA64DFR0_EL1_BRPs	|
+			ID_AA64DFR0_EL1_DebugVer|
+			ID_AA64DFR0_EL1_HPMN0);
+
+		/* Cap Debug to ARMv8.1 */
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, VHE);
+		break;
+	}
+
+	return val;
+}
+
 static void limit_nv_id_regs(struct kvm *kvm)
 {
-	u64 val, tmp;
+	u64 val;
 
-	/* Support everything but TME */
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64ISAR0_EL1);
-	val &= ~NV_FTR(ISAR0, TME);
+	val = limit_nv_id_reg(kvm, SYS_ID_AA64ISAR0_EL1, val);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64ISAR0_EL1, val);
 
-	/* Support everything but Spec Invalidation and LS64 */
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64ISAR1_EL1);
-	val &= ~(NV_FTR(ISAR1, LS64)	|
-		 NV_FTR(ISAR1, SPECRES));
+	val = limit_nv_id_reg(kvm, SYS_ID_AA64ISAR1_EL1, val);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64ISAR1_EL1, val);
 
-	/* No AMU, MPAM, S-EL2, or RAS */
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1);
-	val &= ~(GENMASK_ULL(55, 52)	|
-		 NV_FTR(PFR0, AMU)	|
-		 NV_FTR(PFR0, MPAM)	|
-		 NV_FTR(PFR0, SEL2)	|
-		 NV_FTR(PFR0, RAS)	|
-		 NV_FTR(PFR0, EL3)	|
-		 NV_FTR(PFR0, EL2)	|
-		 NV_FTR(PFR0, EL1)	|
-		 NV_FTR(PFR0, EL0));
-	/* 64bit only at any EL */
-	val |= FIELD_PREP(NV_FTR(PFR0, EL0), 0b0001);
-	val |= FIELD_PREP(NV_FTR(PFR0, EL1), 0b0001);
-	val |= FIELD_PREP(NV_FTR(PFR0, EL2), 0b0001);
-	val |= FIELD_PREP(NV_FTR(PFR0, EL3), 0b0001);
+	val = limit_nv_id_reg(kvm, SYS_ID_AA64PFR0_EL1, val);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, val);
 
-	/* Only support BTI, SSBS, CSV2_frac */
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR1_EL1);
-	val &= (NV_FTR(PFR1, BT)	|
-		NV_FTR(PFR1, SSBS)	|
-		NV_FTR(PFR1, CSV2_frac));
+	val = limit_nv_id_reg(kvm, SYS_ID_AA64PFR1_EL1, val);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR1_EL1, val);
 
-	/* Hide ECV, ExS, Secure Memory */
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR0_EL1);
-	val &= ~(NV_FTR(MMFR0, ECV)		|
-		 NV_FTR(MMFR0, EXS)		|
-		 NV_FTR(MMFR0, TGRAN4_2)	|
-		 NV_FTR(MMFR0, TGRAN16_2)	|
-		 NV_FTR(MMFR0, TGRAN64_2)	|
-		 NV_FTR(MMFR0, SNSMEM));
-
-	/* Disallow unsupported S2 page sizes */
-	switch (PAGE_SIZE) {
-	case SZ_64K:
-		val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN16_2), 0b0001);
-		fallthrough;
-	case SZ_16K:
-		val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN4_2), 0b0001);
-		fallthrough;
-	case SZ_4K:
-		/* Support everything */
-		break;
-	}
-	/*
-	 * Since we can't support a guest S2 page size smaller than
-	 * the host's own page size (due to KVM only populating its
-	 * own S2 using the kernel's page size), advertise the
-	 * limitation using FEAT_GTG.
-	 */
-	switch (PAGE_SIZE) {
-	case SZ_4K:
-		val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN4_2), 0b0010);
-		fallthrough;
-	case SZ_16K:
-		val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN16_2), 0b0010);
-		fallthrough;
-	case SZ_64K:
-		val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN64_2), 0b0010);
-		break;
-	}
-	/* Cap PARange to 48bits */
-	tmp = FIELD_GET(NV_FTR(MMFR0, PARANGE), val);
-	if (tmp > 0b0101) {
-		val &= ~NV_FTR(MMFR0, PARANGE);
-		val |= FIELD_PREP(NV_FTR(MMFR0, PARANGE), 0b0101);
-	}
+	val = limit_nv_id_reg(kvm, SYS_ID_AA64MMFR0_EL1, val);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR0_EL1, val);
 
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR1_EL1);
-	val &= (NV_FTR(MMFR1, HCX)	|
-		NV_FTR(MMFR1, PAN)	|
-		NV_FTR(MMFR1, LO)	|
-		NV_FTR(MMFR1, HPDS)	|
-		NV_FTR(MMFR1, VH)	|
-		NV_FTR(MMFR1, VMIDBits));
+	val = limit_nv_id_reg(kvm, SYS_ID_AA64MMFR1_EL1, val);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR1_EL1, val);
 
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR2_EL1);
-	val &= ~(NV_FTR(MMFR2, BBM)	|
-		 NV_FTR(MMFR2, TTL)	|
-		 GENMASK_ULL(47, 44)	|
-		 NV_FTR(MMFR2, ST)	|
-		 NV_FTR(MMFR2, CCIDX)	|
-		 NV_FTR(MMFR2, VARange));
-
-	/* Force TTL support */
-	val |= FIELD_PREP(NV_FTR(MMFR2, TTL), 0b0001);
+	val = limit_nv_id_reg(kvm, SYS_ID_AA64MMFR2_EL1, val);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR2_EL1, val);
 
-	val = 0;
-	if (!cpus_have_final_cap(ARM64_HAS_HCR_NV1))
-		val |= FIELD_PREP(NV_FTR(MMFR4, E2H0),
-				  ID_AA64MMFR4_EL1_E2H0_NI_NV1);
+	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR4_EL1);
+	val = limit_nv_id_reg(kvm, SYS_ID_AA64MMFR4_EL1, val);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR4_EL1, val);
 
-	/* Only limited support for PMU, Debug, BPs, WPs, and HPMN0 */
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
-	val &= (NV_FTR(DFR0, PMUVer)	|
-		NV_FTR(DFR0, WRPs)	|
-		NV_FTR(DFR0, BRPs)	|
-		NV_FTR(DFR0, DebugVer)	|
-		NV_FTR(DFR0, HPMN0));
-
-	/* Cap Debug to ARMv8.1 */
-	tmp = FIELD_GET(NV_FTR(DFR0, DebugVer), val);
-	if (tmp > 0b0111) {
-		val &= ~NV_FTR(DFR0, DebugVer);
-		val |= FIELD_PREP(NV_FTR(DFR0, DebugVer), 0b0111);
-	}
+	val = limit_nv_id_reg(kvm, SYS_ID_AA64DFR0_EL1, val);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1, val);
 }
 
-- 
2.39.2



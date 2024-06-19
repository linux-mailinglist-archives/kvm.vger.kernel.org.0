Return-Path: <kvm+bounces-20008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C6A690F555
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 19:41:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DF86B22738
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E47B215748B;
	Wed, 19 Jun 2024 17:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gDofu2+H"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D12C15746A
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 17:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718818862; cv=none; b=K/yaX+9VpXHdJUgRpXLG9TqnoOqgAjYNKQ5WmpTMKrWfuBJYr5Xu5Gif7RDpL+sz4+Ok4XCjM/j14eWAWtREXX/vdDQFOEF3vq06S196J+WTszxp7b+EnjJJpfarLb1SJP0xMfJMOpPfYnep5yHBo9dc6hRdUSCvRQRdIxNR46Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718818862; c=relaxed/simple;
	bh=AroJPS8xY78Q1mzZn6UE8zUQBI6tZiLsTOA0JjAoqi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SERnNdeVyhgubrP1COtTzmxs7/s+4JEAet++2/B5RqJdPYfqdABgZpbUqI7sBZsHyZomVyC792XmsTCHwi2v52+jio3jjWF8ssbTs1iZBaR4ozqAaT+PAcD4P6vX70gJdzsUJvFB9txKmeNWTdSOD8MGODog2iTyI8BuC1w8TQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gDofu2+H; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718818858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X7R1PM2NWCG7ATjL4uyL64rjqO8DqSk008zeOMwppsQ=;
	b=gDofu2+HQAvne+eEzLECttVrYHoFfSckkXQUX7Vm9UbQXfPim1eziYG/8ORr03lXnELrYI
	jpL1z9lBdK/mgyKuoFnqjIJ0EXbKPtkF+nUr2G0PTJoE05ONeX915/CYuxkBKG6ojFp0H3
	RjLxADYnNZec4vruHNhVrth0xwTru1M=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: sebott@redhat.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: eric.auger@redhat.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 05/10] KVM: arm64: nv: Use accessors for modifying ID registers
Date: Wed, 19 Jun 2024 17:40:31 +0000
Message-ID: <20240619174036.483943-6-oliver.upton@linux.dev>
In-Reply-To: <20240619174036.483943-1-oliver.upton@linux.dev>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In the interest of abstracting away the underlying storage of feature
ID registers, rework the nested code to go through the accessors instead
of directly iterating the id_regs array.

This means we now lose the property that ID registers unknown to the
nested code get zeroed, but we really ought to be handling those
explicitly going forward.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |   1 -
 arch/arm64/kvm/nested.c           | 256 ++++++++++++++----------------
 2 files changed, 122 insertions(+), 135 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 74e7c29364ee..294c78319f58 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -326,7 +326,6 @@ struct kvm_arch {
 	 * Atomic access to multiple idregs are guarded by kvm_arch.config_lock.
 	 */
 #define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
-#define IDX_IDREG(idx)		sys_reg(3, 0, 0, ((idx) >> 3) + 1, (idx) & Op2_mask)
 #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 5db5bc9dd290..44085c13e673 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -23,141 +23,131 @@
  * This list should get updated as new features get added to the NV
  * support, and new extension to the architecture.
  */
-static u64 limit_nv_id_reg(u32 id, u64 val)
+static void limit_nv_id_regs(struct kvm *kvm)
 {
-	u64 tmp;
-
-	switch (id) {
-	case SYS_ID_AA64ISAR0_EL1:
-		/* Support everything but TME, O.S. and Range TLBIs */
-		val &= ~(NV_FTR(ISAR0, TLB)		|
-			 NV_FTR(ISAR0, TME));
-		break;
-
-	case SYS_ID_AA64ISAR1_EL1:
-		/* Support everything but Spec Invalidation */
-		val &= ~(GENMASK_ULL(63, 56)	|
-			 NV_FTR(ISAR1, SPECRES));
-		break;
-
-	case SYS_ID_AA64PFR0_EL1:
-		/* No AMU, MPAM, S-EL2, RAS or SVE */
-		val &= ~(GENMASK_ULL(55, 52)	|
-			 NV_FTR(PFR0, AMU)	|
-			 NV_FTR(PFR0, MPAM)	|
-			 NV_FTR(PFR0, SEL2)	|
-			 NV_FTR(PFR0, RAS)	|
-			 NV_FTR(PFR0, SVE)	|
-			 NV_FTR(PFR0, EL3)	|
-			 NV_FTR(PFR0, EL2)	|
-			 NV_FTR(PFR0, EL1));
-		/* 64bit EL1/EL2/EL3 only */
-		val |= FIELD_PREP(NV_FTR(PFR0, EL1), 0b0001);
-		val |= FIELD_PREP(NV_FTR(PFR0, EL2), 0b0001);
-		val |= FIELD_PREP(NV_FTR(PFR0, EL3), 0b0001);
-		break;
-
-	case SYS_ID_AA64PFR1_EL1:
-		/* Only support SSBS */
-		val &= NV_FTR(PFR1, SSBS);
-		break;
-
-	case SYS_ID_AA64MMFR0_EL1:
-		/* Hide ECV, ExS, Secure Memory */
-		val &= ~(NV_FTR(MMFR0, ECV)		|
-			 NV_FTR(MMFR0, EXS)		|
-			 NV_FTR(MMFR0, TGRAN4_2)	|
-			 NV_FTR(MMFR0, TGRAN16_2)	|
-			 NV_FTR(MMFR0, TGRAN64_2)	|
-			 NV_FTR(MMFR0, SNSMEM));
-
-		/* Disallow unsupported S2 page sizes */
-		switch (PAGE_SIZE) {
-		case SZ_64K:
-			val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN16_2), 0b0001);
-			fallthrough;
-		case SZ_16K:
-			val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN4_2), 0b0001);
-			fallthrough;
-		case SZ_4K:
-			/* Support everything */
-			break;
-		}
-		/*
-		 * Since we can't support a guest S2 page size smaller than
-		 * the host's own page size (due to KVM only populating its
-		 * own S2 using the kernel's page size), advertise the
-		 * limitation using FEAT_GTG.
-		 */
-		switch (PAGE_SIZE) {
-		case SZ_4K:
-			val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN4_2), 0b0010);
-			fallthrough;
-		case SZ_16K:
-			val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN16_2), 0b0010);
-			fallthrough;
-		case SZ_64K:
-			val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN64_2), 0b0010);
-			break;
-		}
-		/* Cap PARange to 48bits */
-		tmp = FIELD_GET(NV_FTR(MMFR0, PARANGE), val);
-		if (tmp > 0b0101) {
-			val &= ~NV_FTR(MMFR0, PARANGE);
-			val |= FIELD_PREP(NV_FTR(MMFR0, PARANGE), 0b0101);
-		}
+	u64 val, tmp;
+
+	/* Support everything but TME, O.S. and Range TLBIs */
+	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64ISAR0_EL1);
+	val &= ~(NV_FTR(ISAR0, TLB)	|
+		 NV_FTR(ISAR0, TME));
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64ISAR0_EL1, val);
+
+	/* Support everything but Spec Invalidation */
+	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64ISAR1_EL1);
+	val &= ~(GENMASK_ULL(63, 56)	|
+		 NV_FTR(ISAR1, SPECRES));
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64ISAR1_EL1, val);
+
+	/* No AMU, MPAM, S-EL2, RAS or SVE */
+	kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1);
+	val &= ~(GENMASK_ULL(55, 52)	|
+		 NV_FTR(PFR0, AMU)	|
+		 NV_FTR(PFR0, MPAM)	|
+		 NV_FTR(PFR0, SEL2)	|
+		 NV_FTR(PFR0, RAS)	|
+		 NV_FTR(PFR0, SVE)	|
+		 NV_FTR(PFR0, EL3)	|
+		 NV_FTR(PFR0, EL2)	|
+		 NV_FTR(PFR0, EL1));
+	/* 64bit EL1/EL2/EL3 only */
+	val |= FIELD_PREP(NV_FTR(PFR0, EL1), 0b0001);
+	val |= FIELD_PREP(NV_FTR(PFR0, EL2), 0b0001);
+	val |= FIELD_PREP(NV_FTR(PFR0, EL3), 0b0001);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, val);
+
+	/* Only support SSBS */
+	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR1_EL1);
+	val &= NV_FTR(PFR1, SSBS);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR1_EL1, val);
+
+	/* Hide ECV, ExS, Secure Memory */
+	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR0_EL1);
+	val &= ~(NV_FTR(MMFR0, ECV)		|
+		 NV_FTR(MMFR0, EXS)		|
+		 NV_FTR(MMFR0, TGRAN4_2)	|
+		 NV_FTR(MMFR0, TGRAN16_2)	|
+		 NV_FTR(MMFR0, TGRAN64_2)	|
+		 NV_FTR(MMFR0, SNSMEM));
+
+	/* Disallow unsupported S2 page sizes */
+	switch (PAGE_SIZE) {
+	case SZ_64K:
+		val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN16_2), 0b0001);
+		fallthrough;
+	case SZ_16K:
+		val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN4_2), 0b0001);
+		fallthrough;
+	case SZ_4K:
+		/* Support everything */
 		break;
-
-	case SYS_ID_AA64MMFR1_EL1:
-		val &= (NV_FTR(MMFR1, HCX)	|
-			NV_FTR(MMFR1, PAN)	|
-			NV_FTR(MMFR1, LO)	|
-			NV_FTR(MMFR1, HPDS)	|
-			NV_FTR(MMFR1, VH)	|
-			NV_FTR(MMFR1, VMIDBits));
-		break;
-
-	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~(NV_FTR(MMFR2, BBM)	|
-			 NV_FTR(MMFR2, TTL)	|
-			 GENMASK_ULL(47, 44)	|
-			 NV_FTR(MMFR2, ST)	|
-			 NV_FTR(MMFR2, CCIDX)	|
-			 NV_FTR(MMFR2, VARange));
-
-		/* Force TTL support */
-		val |= FIELD_PREP(NV_FTR(MMFR2, TTL), 0b0001);
-		break;
-
-	case SYS_ID_AA64MMFR4_EL1:
-		val = 0;
-		if (!cpus_have_final_cap(ARM64_HAS_HCR_NV1))
-			val |= FIELD_PREP(NV_FTR(MMFR4, E2H0),
-					  ID_AA64MMFR4_EL1_E2H0_NI_NV1);
-		break;
-
-	case SYS_ID_AA64DFR0_EL1:
-		/* Only limited support for PMU, Debug, BPs and WPs */
-		val &= (NV_FTR(DFR0, PMUVer)	|
-			NV_FTR(DFR0, WRPs)	|
-			NV_FTR(DFR0, BRPs)	|
-			NV_FTR(DFR0, DebugVer));
-
-		/* Cap Debug to ARMv8.1 */
-		tmp = FIELD_GET(NV_FTR(DFR0, DebugVer), val);
-		if (tmp > 0b0111) {
-			val &= ~NV_FTR(DFR0, DebugVer);
-			val |= FIELD_PREP(NV_FTR(DFR0, DebugVer), 0b0111);
-		}
-		break;
-
-	default:
-		/* Unknown register, just wipe it clean */
-		val = 0;
+	}
+	/*
+	 * Since we can't support a guest S2 page size smaller than
+	 * the host's own page size (due to KVM only populating its
+	 * own S2 using the kernel's page size), advertise the
+	 * limitation using FEAT_GTG.
+	 */
+	switch (PAGE_SIZE) {
+	case SZ_4K:
+		val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN4_2), 0b0010);
+		fallthrough;
+	case SZ_16K:
+		val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN16_2), 0b0010);
+		fallthrough;
+	case SZ_64K:
+		val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN64_2), 0b0010);
 		break;
 	}
-
-	return val;
+	/* Cap PARange to 48bits */
+	tmp = FIELD_GET(NV_FTR(MMFR0, PARANGE), val);
+	if (tmp > 0b0101) {
+		val &= ~NV_FTR(MMFR0, PARANGE);
+		val |= FIELD_PREP(NV_FTR(MMFR0, PARANGE), 0b0101);
+	}
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR0_EL1, val);
+
+	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR1_EL1);
+	val &= (NV_FTR(MMFR1, HCX)	|
+		NV_FTR(MMFR1, PAN)	|
+		NV_FTR(MMFR1, LO)	|
+		NV_FTR(MMFR1, HPDS)	|
+		NV_FTR(MMFR1, VH)	|
+		NV_FTR(MMFR1, VMIDBits));
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR1_EL1, val);
+
+	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR2_EL1);
+	val &= ~(NV_FTR(MMFR2, BBM)	|
+		 NV_FTR(MMFR2, TTL)	|
+		 GENMASK_ULL(47, 44)	|
+		 NV_FTR(MMFR2, ST)	|
+		 NV_FTR(MMFR2, CCIDX)	|
+		 NV_FTR(MMFR2, VARange));
+
+	/* Force TTL support */
+	val |= FIELD_PREP(NV_FTR(MMFR2, TTL), 0b0001);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR2_EL1, val);
+
+	val = 0;
+	if (!cpus_have_final_cap(ARM64_HAS_HCR_NV1))
+		val |= FIELD_PREP(NV_FTR(MMFR4, E2H0),
+				  ID_AA64MMFR4_EL1_E2H0_NI_NV1);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR4_EL1, val);
+
+	/* Only limited support for PMU, Debug, BPs and WPs */
+	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
+	val &= (NV_FTR(DFR0, PMUVer)	|
+		NV_FTR(DFR0, WRPs)	|
+		NV_FTR(DFR0, BRPs)	|
+		NV_FTR(DFR0, DebugVer));
+
+	/* Cap Debug to ARMv8.1 */
+	tmp = FIELD_GET(NV_FTR(DFR0, DebugVer), val);
+	if (tmp > 0b0111) {
+		val &= ~NV_FTR(DFR0, DebugVer);
+		val |= FIELD_PREP(NV_FTR(DFR0, DebugVer), 0b0111);
+	}
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1, val);
 }
 
 u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
@@ -202,9 +192,7 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		goto out;
 	}
 
-	for (int i = 0; i < KVM_ARM_ID_REG_NUM; i++)
-		kvm_set_vm_id_reg(kvm, IDX_IDREG(i), limit_nv_id_reg(IDX_IDREG(i),
-								     kvm->arch.id_regs[i]));
+	limit_nv_id_regs(kvm);
 
 	/* VTTBR_EL2 */
 	res0 = res1 = 0;
-- 
2.45.2.627.g7a2c4fd464-goog



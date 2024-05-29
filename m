Return-Path: <kvm+bounces-18314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE1B8D3A0D
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:57:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 950B51C217ED
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA92181CE9;
	Wed, 29 May 2024 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0s76aj1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9201802AA;
	Wed, 29 May 2024 14:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716994596; cv=none; b=Gq0nMPLJMZ68fDR9vi30szGLTX4kaMWKbEzZpYoyxMXYUEuBAAgzAWPG9DAcltXuYf6T/QzNbhjVXj5FvZVaWPxWHndDI/mzDKiE1DJ+AwShbeOlfZ2Hst8UWtRk0OJSN62ucyDTF+QVYxqSXkWBMRuwtUKz5ex6xoh3Mtyf7I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716994596; c=relaxed/simple;
	bh=4IZXzu3rQAVEda6waRiG3BsL6vwsphd7VFNvseeZWxY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RcGnKrBedHT6K2Xa+6v11BQwv6VMXOmRGVybJDSHy5IGSNBfwPM6C7XoP/Q07q92wftvPrOuGKgQltKx8I9/vDv2sGK3H2PdHPJN/z8W4tJzqkYvCl9sCeo4vAWyWO8xYH3dTa1KY5VyqtkW6UhPQQeCJ0gB86dOcLf/QxhfaT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0s76aj1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF362C4AF09;
	Wed, 29 May 2024 14:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716994595;
	bh=4IZXzu3rQAVEda6waRiG3BsL6vwsphd7VFNvseeZWxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0s76aj1qVnQlGa1F8liFDnJGSdt4Iz5JdQMbpKkZOlzR/GzwBpa2r+1w35ab4HD1
	 evDys900QF5nwmMrkhS4NCaIZXQMUxDcWGWmahvU/LbfIvs/7cxcib0g0ETd9HJFzl
	 uYxE2zCwtlE1VliZh16kouq6aGhBL8BOLHQUCC4YaNRH9mk5e6M8yLnmXUcnwATa1z
	 zP2dk9KjF+vRY06ok5PbP4NVZNKU7s9Nl6nNeI9SsUj6sI6DcRvpWMEg8epwlyvXVd
	 KOXS2T+aUxSqg6E0xHdxpcjb/yplsT5f92tkrYm5x2spWgibfXVHrwhoUzCZHLBCRS
	 oJq9faa/PVU1A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sCKjB-00GekF-W5;
	Wed, 29 May 2024 15:56:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 10/16] KVM: arm64: nv: Handle TLBI IPAS2E1{,IS} operations
Date: Wed, 29 May 2024 15:56:22 +0100
Message-Id: <20240529145628.3272630-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240529145628.3272630-1-maz@kernel.org>
References: <20240529145628.3272630-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

TLBI IPAS2E1* are the last class of TLBI instructions we need
to handle. For each matching S2 MMU context, we invalidate a
range corresponding to the largest possible mapping for that
context.

At this stage, we don't handle TTL, which means we are likely
over-invalidating. Further patches will aim at making this
a bit better.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 96 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d8d6380b7c66..06963f1d206e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2780,6 +2780,31 @@ static bool handle_alle1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool kvm_supported_tlbi_ipas2_op(struct kvm_vcpu *vpcu, u32 instr)
+{
+	struct kvm *kvm = vpcu->kvm;
+	u8 CRm = sys_reg_CRm(instr);
+	u8 Op2 = sys_reg_Op2(instr);
+
+	if (sys_reg_CRn(instr) == TLBI_CRn_nXS &&
+	    !kvm_has_feat(kvm, ID_AA64ISAR1_EL1, XS, IMP))
+		return false;
+
+	if (CRm == TLBI_CRm_IPAIS && (Op2 == 2 || Op2 == 6) &&
+	    !kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
+		return false;
+
+	if (CRm == TLBI_CRm_IPAONS && (Op2 == 0 || Op2 == 4) &&
+	    !kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
+		return false;
+
+	if (CRm == TLBI_CRm_IPAONS && (Op2 == 3 || Op2 == 7) &&
+	    !kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
+		return false;
+
+	return true;
+}
+
 /* Only defined here as this is an internal "abstraction" */
 union tlbi_info {
 	struct {
@@ -2829,6 +2854,72 @@ static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static void s2_mmu_unmap_ipa(struct kvm_s2_mmu *mmu,
+			     const union tlbi_info *info)
+{
+	unsigned long max_size;
+	u64 base_addr;
+
+	/*
+	 * We drop a number of things from the supplied value:
+	 *
+	 * - NS bit: we're non-secure only.
+	 *
+	 * - TTL field: We already have the granule size from the
+	 *   VTCR_EL2.TG0 field, and the level is only relevant to the
+	 *   guest's S2PT.
+	 *
+	 * - IPA[51:48]: We don't support 52bit IPA just yet...
+	 *
+	 * And of course, adjust the IPA to be on an actual address.
+	 */
+	base_addr = (info->ipa.addr & GENMASK_ULL(35, 0)) << 12;
+
+	/* Compute the maximum extent of the invalidation */
+	switch (mmu->tlb_vtcr & VTCR_EL2_TG0_MASK) {
+	case VTCR_EL2_TG0_4K:
+		max_size = SZ_1G;
+		break;
+	case VTCR_EL2_TG0_16K:
+		max_size = SZ_32M;
+		break;
+	case VTCR_EL2_TG0_64K:
+	default:	    /* IMPDEF: treat any other value as 64k */
+		/*
+		 * No, we do not support 52bit IPA in nested yet. Once
+		 * we do, this should be 4TB.
+		 */
+		max_size = SZ_512M;
+		break;
+	}
+
+	base_addr &= ~(max_size - 1);
+
+	kvm_stage2_unmap_range(mmu, base_addr, max_size);
+}
+
+static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+
+	if (!kvm_supported_tlbi_ipas2_op(vcpu, sys_encoding)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
+				   &(union tlbi_info) {
+					   .ipa = {
+						   .addr = p->regval,
+					   },
+				   },
+				   s2_mmu_unmap_ipa);
+
+	return true;
+}
+
 static void s2_mmu_tlbi_s1e1(struct kvm_s2_mmu *mmu,
 			     const union tlbi_info *info)
 {
@@ -2903,8 +2994,13 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VALE1, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAALE1, handle_tlbi_el1),
 
+	SYS_INSN(TLBI_IPAS2E1IS, handle_ipas2e1is),
+	SYS_INSN(TLBI_IPAS2LE1IS, handle_ipas2e1is),
+
 	SYS_INSN(TLBI_ALLE1IS, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1IS, handle_vmalls12e1is),
+	SYS_INSN(TLBI_IPAS2E1, handle_ipas2e1is),
+	SYS_INSN(TLBI_IPAS2LE1, handle_ipas2e1is),
 	SYS_INSN(TLBI_ALLE1, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1, handle_vmalls12e1is),
 };
-- 
2.39.2



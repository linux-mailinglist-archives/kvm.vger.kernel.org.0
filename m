Return-Path: <kvm+bounces-18320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D47438D3A10
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 044751C215B1
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF751836D8;
	Wed, 29 May 2024 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbZrmafX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8556C181D0C;
	Wed, 29 May 2024 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716994597; cv=none; b=GplJjAMs1brCXE9b5YICyzF2By1FTWaCOmOLihLRs15ovyu39KkodxmKAlaH/AFPJljAqWfz9b89wiLTAzyFYAA/ivYutgCsmhw3W8dFywmMPzgGATnjCL6uC1xFn9aLU2AVGIz2PrARgeJG1K6fW4h4pElwJifLCu15/eX/LgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716994597; c=relaxed/simple;
	bh=cLV4mIW1eIAa0/CdAxkYAY2q2y1j43sKCrnl6h01er4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kcu2sAdJI/hh6gomKZHAuD3BOd6VKYOrGukhFTW2MlfFArXRxjd0U5LX4ntn3SD+343ONf+Jn8pWwT/NzpY+2sEYKhJcmnxS2lN/lo6A9vc1FZC7mlLRNSQ/rJx4gvt3RLulQZ6MtuLc7/BQu9AJ2Dwy5GXGcvZimRQh8lC5Y7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbZrmafX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0D0C113CC;
	Wed, 29 May 2024 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716994597;
	bh=cLV4mIW1eIAa0/CdAxkYAY2q2y1j43sKCrnl6h01er4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbZrmafXucphUuU+CU4NaBhu5RdxRIVtNNnqqr7OzCChUo1bNOZQVUy7X3+kfdEue
	 UWcn7UJ1nlLEUU5yLM6quM1WusUGzxou3fCDZJkRBq+6IvsKwY5WNdc+qesvKXjgRM
	 ZkYeuwcNWcsCROjB+VPe/q8sLqdArMMjSKsoy3neJ2LCfv51D8E9XXDkeZuIUp9a6A
	 kjtHRgevI74urd8PUX+gKaKVjNeI3yfziiIK9OnavBbljNnel4RHl2qEH2sSiSOzkp
	 lhdomaMdVateA6f8j+lO7jpON03mjjmrqM6W1OjmD4kqr0FF8T50UynsZNsXi4NUbQ
	 vSh4FwBPtWbmA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sCKjD-00GekF-0b;
	Wed, 29 May 2024 15:56:35 +0100
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
Subject: [PATCH v2 15/16] KVM: arm64: nv: Add handling of range-based TLBI operations
Date: Wed, 29 May 2024 15:56:27 +0100
Message-Id: <20240529145628.3272630-16-maz@kernel.org>
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

We already support some form of range operation by handling FEAT_TTL,
but so far the "arbitrary" range operations are unsupported.

Let's fix that.

For EL2 S1, this is simple enough: we just map both NSH, ISH and OSH
instructions onto the ISH version for EL1.

For TLBI instructions affecting EL1 S1, we use the same model as
their non-range counterpart to invalidate in the context of the
correct VMID.

For TLBI instructions affecting S2, we interpret the data passed
by the guest to compute the range and use that to tear-down part
of the shadow S2 range and invalidate the TLBs.

Finally, we advertise FEAT_TLBIRANGE if the host supports it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/tlb.c | 26 ++++++++++++
 arch/arm64/kvm/nested.c      |  8 +---
 arch/arm64/kvm/sys_regs.c    | 80 ++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 85db6ffd9d9d..18e30f03f3f5 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -283,6 +283,32 @@ int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
 	case OP_TLBI_VAALE1OS:
 		__tlbi(vaale1is, va);
 		break;
+	case OP_TLBI_RVAE2:
+	case OP_TLBI_RVAE2IS:
+	case OP_TLBI_RVAE2OS:
+	case OP_TLBI_RVAE1:
+	case OP_TLBI_RVAE1IS:
+	case OP_TLBI_RVAE1OS:
+		__tlbi(rvae1is, va);
+		break;
+	case OP_TLBI_RVALE2:
+	case OP_TLBI_RVALE2IS:
+	case OP_TLBI_RVALE2OS:
+	case OP_TLBI_RVALE1:
+	case OP_TLBI_RVALE1IS:
+	case OP_TLBI_RVALE1OS:
+		__tlbi(rvale1is, va);
+		break;
+	case OP_TLBI_RVAAE1:
+	case OP_TLBI_RVAAE1IS:
+	case OP_TLBI_RVAAE1OS:
+		__tlbi(rvaae1is, va);
+		break;
+	case OP_TLBI_RVAALE1:
+	case OP_TLBI_RVAALE1IS:
+	case OP_TLBI_RVAALE1OS:
+		__tlbi(rvaale1is, va);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 981c879ba79a..9e237249a3dc 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -804,12 +804,8 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
 
 	switch (id) {
 	case SYS_ID_AA64ISAR0_EL1:
-		/* Support everything but TME and Range TLBIs */
-		tmp = FIELD_GET(NV_FTR(ISAR0, TLB), val);
-		tmp = min(tmp, ID_AA64ISAR0_EL1_TLB_OS);
-		val &= ~(NV_FTR(ISAR0, TLB)		|
-			 NV_FTR(ISAR0, TME));
-		val |= FIELD_PREP(NV_FTR(ISAR0, TLB), tmp);
+		/* Support everything but TME */
+		val &= ~NV_FTR(ISAR0, TME);
 		break;
 
 	case SYS_ID_AA64ISAR1_EL1:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7dec7da167f6..f6edcb863577 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2854,6 +2854,57 @@ static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool handle_ripas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+	u64 base, range, tg, num, scale;
+	int shift;
+
+	if (!kvm_supported_tlbi_ipas2_op(vcpu, sys_encoding)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	/*
+	 * Because the shadow S2 structure doesn't necessarily reflect that
+	 * of the guest's S2 (different base granule size, for example), we
+	 * decide to ignore TTL and only use the described range.
+	 */
+	tg	= FIELD_GET(GENMASK(47, 46), p->regval);
+	scale	= FIELD_GET(GENMASK(45, 44), p->regval);
+	num	= FIELD_GET(GENMASK(43, 39), p->regval);
+	base	= p->regval & GENMASK(36, 0);
+
+	switch(tg) {
+	case 1:
+		shift = 12;
+		break;
+	case 2:
+		shift = 14;
+		break;
+	case 3:
+	default:		/* IMPDEF: handle tg==0 as 64k */
+		shift = 16;
+		break;
+	}
+
+	base <<= shift;
+	range = __TLBI_RANGE_PAGES(num, scale) << shift;
+
+	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
+				   &(union tlbi_info) {
+					   .range = {
+						   .start = base,
+						   .size = range,
+					   },
+				   },
+				   s2_mmu_unmap_range);
+
+	return true;
+}
+
 static void s2_mmu_unmap_ipa(struct kvm_s2_mmu *mmu,
 			     const union tlbi_info *info)
 {
@@ -2966,12 +3017,28 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VALE1OS, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAALE1OS, handle_tlbi_el1),
 
+	SYS_INSN(TLBI_RVAE1IS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAAE1IS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVALE1IS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAALE1IS, handle_tlbi_el1),
+
 	SYS_INSN(TLBI_VMALLE1IS, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAE1IS, handle_tlbi_el1),
 	SYS_INSN(TLBI_ASIDE1IS, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAAE1IS, handle_tlbi_el1),
 	SYS_INSN(TLBI_VALE1IS, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAALE1IS, handle_tlbi_el1),
+
+	SYS_INSN(TLBI_RVAE1OS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAAE1OS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVALE1OS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAALE1OS, handle_tlbi_el1),
+
+	SYS_INSN(TLBI_RVAE1, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAAE1, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVALE1, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAALE1, handle_tlbi_el1),
+
 	SYS_INSN(TLBI_VMALLE1, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAE1, handle_tlbi_el1),
 	SYS_INSN(TLBI_ASIDE1, handle_tlbi_el1),
@@ -2980,7 +3047,9 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VAALE1, handle_tlbi_el1),
 
 	SYS_INSN(TLBI_IPAS2E1IS, handle_ipas2e1is),
+	SYS_INSN(TLBI_RIPAS2E1IS, handle_ripas2e1is),
 	SYS_INSN(TLBI_IPAS2LE1IS, handle_ipas2e1is),
+	SYS_INSN(TLBI_RIPAS2LE1IS, handle_ripas2e1is),
 
 	SYS_INSN(TLBI_ALLE2OS, trap_undef),
 	SYS_INSN(TLBI_VAE2OS, trap_undef),
@@ -2988,12 +3057,23 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VALE2OS, trap_undef),
 	SYS_INSN(TLBI_VMALLS12E1OS, handle_vmalls12e1is),
 
+	SYS_INSN(TLBI_RVAE2IS, trap_undef),
+	SYS_INSN(TLBI_RVALE2IS, trap_undef),
+
 	SYS_INSN(TLBI_ALLE1IS, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1IS, handle_vmalls12e1is),
 	SYS_INSN(TLBI_IPAS2E1OS, handle_ipas2e1is),
 	SYS_INSN(TLBI_IPAS2E1, handle_ipas2e1is),
+	SYS_INSN(TLBI_RIPAS2E1, handle_ripas2e1is),
+	SYS_INSN(TLBI_RIPAS2E1OS, handle_ripas2e1is),
 	SYS_INSN(TLBI_IPAS2LE1OS, handle_ipas2e1is),
 	SYS_INSN(TLBI_IPAS2LE1, handle_ipas2e1is),
+	SYS_INSN(TLBI_RIPAS2LE1, handle_ripas2e1is),
+	SYS_INSN(TLBI_RIPAS2LE1OS, handle_ripas2e1is),
+	SYS_INSN(TLBI_RVAE2OS, trap_undef),
+	SYS_INSN(TLBI_RVALE2OS, trap_undef),
+	SYS_INSN(TLBI_RVAE2, trap_undef),
+	SYS_INSN(TLBI_RVALE2, trap_undef),
 	SYS_INSN(TLBI_ALLE1, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1, handle_vmalls12e1is),
 };
-- 
2.39.2



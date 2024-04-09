Return-Path: <kvm+bounces-14025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8117589E1F5
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB40A1F21E8C
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BFC157A74;
	Tue,  9 Apr 2024 17:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNrz2I1h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E795515748B;
	Tue,  9 Apr 2024 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712685325; cv=none; b=nM5lR2oXET+J0/hcwjJdPZ3OxhGPj6Y6JkqVOAZUXN3yxRkzgWI6Z7KVwgP4hbxH9Q8mNcUq4ckWAD1vHJSH4yYUxz5HWuTatPWpQ1z8MHJh04TQ/KyLjwpaT/plKxQqSQfQuejyB8gQYmQoSw5Lmmg9SjEeYO0vSv1LWzIbn9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712685325; c=relaxed/simple;
	bh=TsgnlT751P+1Jo9hrCuGBawkRkgBuC5aRdyjDEl0Cjk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=be0MNO8AeyfYMmD0r/kMzzp4/UyXlytJgQ/LZ3FUCgCSlUgARpXBJ2WLQgYV0/JrHxYqGuuWzhn+DnsLmc9FJD+/2FI2eLeiVGKOVnbkoHsv3grHIlidoR03P4k8p2RWdoo+GRCXlx55JTqxsmfpURf6sq3HM/Fjp7Us1otXoII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNrz2I1h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FEAC433C7;
	Tue,  9 Apr 2024 17:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712685324;
	bh=TsgnlT751P+1Jo9hrCuGBawkRkgBuC5aRdyjDEl0Cjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNrz2I1hS4hNjZHqNe+UqDgqFcAAp4oaiSNlX1WSo57N3prmkCKLUxfQvfO6EDKG3
	 QZkXGfYhlqqd9E+VfGWuvPErubPyZS4dcQN8UaYKqoppU4XTWtvfSwi+66Ph1JArxn
	 vKMKgoxDYmoo5xmiANJqiW8GjW+py0oRz2ESOg0fGL46CU5kG3citv7xYTZCyJIqgJ
	 F/iXQlzxleZHJY35rGIOWqQYQPynmb2CbCeMvaK5pmO8TgxY1XG3jrbX6+1GrNWBfP
	 TQmCi2o7PYCFv2rlz6JDkHYl2WZ0SJ69SDvs3FL1a2cHMkmSOHLLCdoNqbp1v6sAWO
	 F3Pn07/B5IrtA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ruFgo-002szC-O1;
	Tue, 09 Apr 2024 18:55:22 +0100
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
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 15/16] KVM: arm64: nv: Add handling of range-based TLBI operations
Date: Tue,  9 Apr 2024 18:54:47 +0100
Message-Id: <20240409175448.3507472-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240409175448.3507472-1-maz@kernel.org>
References: <20240409175448.3507472-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com
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
index a5e6c01ccdde..8afaa237f5d4 100644
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
index f9487c04840a..c63824479647 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -791,12 +791,8 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
 
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
index a7c5fa320cda..6d7f043d892c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2841,6 +2841,57 @@ static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
+				   s2_mmu_unmap_stage2_range);
+
+	return true;
+}
+
 static void s2_mmu_unmap_stage2_ipa(struct kvm_s2_mmu *mmu,
 				    const union tlbi_info *info)
 {
@@ -2953,12 +3004,28 @@ static struct sys_reg_desc sys_insn_descs[] = {
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
@@ -2967,7 +3034,9 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VAALE1, handle_tlbi_el1),
 
 	SYS_INSN(TLBI_IPAS2E1IS, handle_ipas2e1is),
+	SYS_INSN(TLBI_RIPAS2E1IS, handle_ripas2e1is),
 	SYS_INSN(TLBI_IPAS2LE1IS, handle_ipas2e1is),
+	SYS_INSN(TLBI_RIPAS2LE1IS, handle_ripas2e1is),
 
 	SYS_INSN(TLBI_ALLE2OS, trap_undef),
 	SYS_INSN(TLBI_VAE2OS, trap_undef),
@@ -2975,12 +3044,23 @@ static struct sys_reg_desc sys_insn_descs[] = {
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



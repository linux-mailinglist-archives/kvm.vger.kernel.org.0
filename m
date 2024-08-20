Return-Path: <kvm+bounces-24621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56CE59584D2
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13A6228A050
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EFE18FDA9;
	Tue, 20 Aug 2024 10:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1pTev5T"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF7118FC9B;
	Tue, 20 Aug 2024 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150291; cv=none; b=pv73GO9IOKvjnoJS91/nYDuz4aZG7/PvdggVAcz2t74vntUsMbZZlfrUrjDLFZSGQCeSba6Rij7x0foI4pMY8D2S7P8P6SB1AMW4Avu5Bf8crC/pBCII/40bXsEpFNbg5i6uZUrT6bBTg4kKadiEAwPyv5Bb5+k00sB4Wn5PrMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150291; c=relaxed/simple;
	bh=OPZZu5/a0DZAyaCFsKFqOH6VKRtf5E6Cfkltar7mQ/w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pFOH4jIaNgdlift6AB/83DQlSxhtizYw8kuMey7eIsAO0cPF/pevwWl8H88WtzTI7XQGqeB/p+dvK+CTjiTh372E+01mUwFiTvzdQAu/j3VHFAt0vW3S2H3Lx34p0OhmVr5CNNHTjhNOJM5opsOhYhs0ZKWgbhQPhbtN8RAaKcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1pTev5T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F0BC4AF15;
	Tue, 20 Aug 2024 10:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150289;
	bh=OPZZu5/a0DZAyaCFsKFqOH6VKRtf5E6Cfkltar7mQ/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1pTev5TOb907fLkcCsNYTPc0ixhdUIz/nNeUlQ5trEl0lj3/3KoWGRwgk1pBGnv2
	 3UvF29Fd8Nb676L4WIqM5v/jfNeV72bJe8x3GHJWBNySITOzPDRkW0OCES/75apiBe
	 bKDVxu5dgayD+bqKg2JOaxH+yIkpCEqKTAIzqZrFqDl3XtQosfbze/kHjnORp2ng7R
	 mpWCD2Vb8ys53UY/A0IOrlyzLqDtfsXRjUES9RTyPvYRqAvLX05iu7shwCUgEHmhBM
	 8xIVTuqmasxNxcdQoguAw8sG6h8JemKsFfa5tWGnW9x57U2P6qP9eQkPhXhtSN9Tij
	 xjLjV/h1C5XhQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFb-005Ea3-Rh;
	Tue, 20 Aug 2024 11:38:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v4 18/18] KVM: arm64: nv: Add support for FEAT_ATS1A
Date: Tue, 20 Aug 2024 11:37:56 +0100
Message-Id: <20240820103756.3545976-19-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
References: <20240820103756.3545976-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Handling FEAT_ATS1A (which provides the AT S1E{1,2}A instructions)
is pretty easy, as it is just the usual AT without the permission
check.

This basically amounts to plumbing the instructions in the various
dispatch tables, and handling FEAT_ATS1A being disabled in the
ID registers.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 arch/arm64/kvm/at.c             | 10 ++++++++++
 arch/arm64/kvm/emulate-nested.c |  2 ++
 arch/arm64/kvm/sys_regs.c       | 11 +++++++++++
 4 files changed, 24 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index a2787091d5a0..bc161f160854 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -673,6 +673,7 @@
 #define OP_AT_S12E1W	sys_insn(AT_Op0, 4, AT_CRn, 8, 5)
 #define OP_AT_S12E0R	sys_insn(AT_Op0, 4, AT_CRn, 8, 6)
 #define OP_AT_S12E0W	sys_insn(AT_Op0, 4, AT_CRn, 8, 7)
+#define OP_AT_S1E2A	sys_insn(AT_Op0, 4, AT_CRn, 9, 2)
 
 /* TLBI instructions */
 #define TLBI_Op0	1
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 60f1ca3a897d..39f0e87a340e 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -78,6 +78,7 @@ static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 o
 	switch (op) {
 	case OP_AT_S1E2R:
 	case OP_AT_S1E2W:
+	case OP_AT_S1E2A:
 		return vcpu_el2_e2h_is_set(vcpu) ? TR_EL20 : TR_EL2;
 		break;
 	default:
@@ -852,6 +853,9 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	case OP_AT_S1E0W:
 		perm_fail = !uw;
 		break;
+	case OP_AT_S1E1A:
+	case OP_AT_S1E2A:
+		break;
 	default:
 		BUG();
 	}
@@ -935,6 +939,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	case OP_AT_S1E0W:
 		fail = __kvm_at(OP_AT_S1E0W, vaddr);
 		break;
+	case OP_AT_S1E1A:
+		fail = __kvm_at(OP_AT_S1E1A, vaddr);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		fail = true;
@@ -1010,6 +1017,9 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		case OP_AT_S1E2W:
 			fail = __kvm_at(OP_AT_S1E1W, vaddr);
 			break;
+		case OP_AT_S1E2A:
+			fail = __kvm_at(OP_AT_S1E1A, vaddr);
+			break;
 		default:
 			WARN_ON_ONCE(1);
 			fail = true;
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05166eccea0a..dbbae64c642c 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -786,6 +786,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(OP_AT_S12E1W,		CGT_HCR_NV),
 	SR_TRAP(OP_AT_S12E0R,		CGT_HCR_NV),
 	SR_TRAP(OP_AT_S12E0W,		CGT_HCR_NV),
+	SR_TRAP(OP_AT_S1E2A,		CGT_HCR_NV),
 	SR_TRAP(OP_TLBI_IPAS2E1,	CGT_HCR_NV),
 	SR_TRAP(OP_TLBI_RIPAS2E1,	CGT_HCR_NV),
 	SR_TRAP(OP_TLBI_IPAS2LE1,	CGT_HCR_NV),
@@ -867,6 +868,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(OP_AT_S1E0W, 		CGT_HCR_AT),
 	SR_TRAP(OP_AT_S1E1RP, 		CGT_HCR_AT),
 	SR_TRAP(OP_AT_S1E1WP, 		CGT_HCR_AT),
+	SR_TRAP(OP_AT_S1E1A,		CGT_HCR_AT),
 	SR_TRAP(SYS_ERXPFGF_EL1,	CGT_HCR_nFIEN),
 	SR_TRAP(SYS_ERXPFGCTL_EL1,	CGT_HCR_nFIEN),
 	SR_TRAP(SYS_ERXPFGCDN_EL1,	CGT_HCR_nFIEN),
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9f3cf82e5231..5ab0b2799393 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2818,6 +2818,13 @@ static bool handle_at_s1e2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u32 op = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 
+	/* There is no FGT associated with AT S1E2A :-( */
+	if (op == OP_AT_S1E2A &&
+	    !kvm_has_feat(vcpu->kvm, ID_AA64ISAR2_EL1, ATS1A, IMP)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
 	__kvm_at_s1e2(vcpu, op, p->regval);
 
 	return true;
@@ -3188,6 +3195,7 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(AT_S12E1W, handle_at_s12),
 	SYS_INSN(AT_S12E0R, handle_at_s12),
 	SYS_INSN(AT_S12E0W, handle_at_s12),
+	SYS_INSN(AT_S1E2A, handle_at_s1e2),
 
 	SYS_INSN(TLBI_IPAS2E1IS, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2E1IS, handle_ripas2e1is),
@@ -4645,6 +4653,9 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 						HFGITR_EL2_TLBIRVAAE1OS	|
 						HFGITR_EL2_TLBIRVAE1OS);
 
+	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, ATS1A, IMP))
+		kvm->arch.fgu[HFGITR_GROUP] |= HFGITR_EL2_ATS1E1A;
+
 	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN2))
 		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_ATS1E1RP |
 						HFGITR_EL2_ATS1E1WP);
-- 
2.39.2



Return-Path: <kvm+bounces-23973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3AC7950226
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:12:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DD00B2AF49
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0238C19D07A;
	Tue, 13 Aug 2024 10:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3CMw2pE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAC419D066;
	Tue, 13 Aug 2024 10:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543589; cv=none; b=WcVmKH3TmPExEWcR0ykCtVIW6sFeET5x6H8W7UgHyBbzRzQJclmpKd8pu1LQpFp2wY5r2x2YMjWenkJGHNJhWRmT/UQ2mMmO1Gh1aMHMwwohn6kI/lPS/FS4MLTjj+bColJIx/HLZxomF7UP7k4UlKC1mNMK6UWXMLi98u9Lkj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543589; c=relaxed/simple;
	bh=XIoXnrnAarn70eltNbWTEbJ4za+AVZpJDRGiMJMnLZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bz3BzITnYPB2A7B+Bw4Bu7Gx3B8CZ6+YxqbbCq27TyuSyqVA8Z3U87C5Mh5lltn95doT2Bkbvv7g0lQgVRnWt89aDvtfhjaMUeoc9clS2U4SwQv096OmQ5BeRQWhFJzbUz/ggNQLFpdtBjFwtOvDD1FsBJusB2sx1qT0tnyA6cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3CMw2pE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D48C4AF10;
	Tue, 13 Aug 2024 10:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543588;
	bh=XIoXnrnAarn70eltNbWTEbJ4za+AVZpJDRGiMJMnLZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3CMw2pEEcykmg3Tzcc3LNzWX/Pmz+yAYsJv3z6t2HexdJq4TfXCtMcaktqC57uWe
	 TrtD39cvmBfzj5JqXGmie5JseiGikCP8WJh6pWWSjGSkACATIrqZ9q8pE/O5nst4Kz
	 w81eTkO1TFGCKQ0CPtLZSKoxfdnXGAdU+TbiAY+3jzlv5y2upHFN/hE4wGOCS2byCK
	 EZhn9t3rjy50MrQFSMpq4yvpHcfMiOX65JOh++FLNTJ0Vctu4MHKoQZ8mAE7XxWB+f
	 Wmq4vrrALHsKeFN9VVHjjzNbviV864UE6E+aKQtMRHdKlNjCl9QbBHZ0P6sAbjS25J
	 106ZfBPM8uyZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoQ6-003INM-EO;
	Tue, 13 Aug 2024 11:06:26 +0100
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
Subject: [PATCH v3 18/18] KVM: arm64: nv: Add support for FEAT_ATS1A
Date: Tue, 13 Aug 2024 11:05:40 +0100
Message-Id: <20240813100540.1955263-19-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813100540.1955263-1-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
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
index c134bcd0338d..ff8a24a2d3d6 100644
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
@@ -849,6 +850,9 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	case OP_AT_S1E0W:
 		perm_fail = !uw;
 		break;
+	case OP_AT_S1E1A:
+	case OP_AT_S1E2A:
+		break;
 	default:
 		BUG();
 	}
@@ -932,6 +936,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	case OP_AT_S1E0W:
 		fail = __kvm_at(OP_AT_S1E0W, vaddr);
 		break;
+	case OP_AT_S1E1A:
+		fail = __kvm_at(OP_AT_S1E1A, vaddr);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		fail = true;
@@ -1007,6 +1014,9 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
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



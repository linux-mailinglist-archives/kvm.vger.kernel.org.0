Return-Path: <kvm+bounces-21114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E141992A7BB
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 18:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1038A1C21101
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 16:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB84148FEE;
	Mon,  8 Jul 2024 16:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6uZBWca"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754E31487C5;
	Mon,  8 Jul 2024 16:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720457890; cv=none; b=pOR5fyxcF6KsZSwFx+CpirEAV6u6RIOiV4s5hPMXSKmMx4bf9qDeyrrw5bLb5HtKpWgWNwKo3GGNLJVj9fD3IJSyDND85BLdUTgcqPw4t94ty1lFsONHZaot6dxhTG0R3/jKLVFr5aapGgrKhOKDsVHD9N59Pjs8uFeoga3rLm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720457890; c=relaxed/simple;
	bh=UBQp9Bke6cyie441wh33sIArUOtqMteq33hP74aLxOo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qKN6M3HKiKWhPvMuJxLuFxICwCG2xSg/3tspoRHA6kdFntBVZzR/AM3tHASj+RD8DJpJfCqnJy9eVVQ38L0iaa79h667PN4J77q7uI91nGiuMrCFbRgGRSfKRU9oFqoPCFdKAHoLcJ7tUfiUc9Y6RkE9EhzCdT2wI0TDwgTZ7eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6uZBWca; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE4DC4AF0C;
	Mon,  8 Jul 2024 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720457890;
	bh=UBQp9Bke6cyie441wh33sIArUOtqMteq33hP74aLxOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6uZBWcaDhlnB5bd+Dyl/g87653RP4Ez2mRDqMKmw07BvsWbenz/6nU1/ldzF6rxM
	 UYKC2bu2okmrjurKBuKE1gWdJqe0nVE+CO3qi8Dw34mei3VJej20OARdN5lc9f5xf5
	 VMmIXJpKUSMWHs6ad9YlDemDvJbotg189OAi19SzecSIiWcfVVqt8PbZaVZk9oom0/
	 NcORtX2R3mfFF4f/Mh1F6/zGGFv0KgKWG2AbFzAYr+Drw3lGJOITNBxzunASpOoQ1g
	 egNpm2EqBbIsz8KNz3WLjThaWbuxLI/5RIVdRnI8cfB53mS3aj5H7VOIkKq7Gl/MlY
	 c3MmDsA8/YIaw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sQrgm-00AfMX-7R;
	Mon, 08 Jul 2024 17:58:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 12/12] KVM: arm64: nv: Add support for FEAT_ATS1A
Date: Mon,  8 Jul 2024 17:58:00 +0100
Message-Id: <20240708165800.1220065-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240708165800.1220065-1-maz@kernel.org>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
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
 arch/arm64/kvm/at.c             |  9 +++++++++
 arch/arm64/kvm/emulate-nested.c |  2 ++
 arch/arm64/kvm/sys_regs.c       | 11 +++++++++++
 4 files changed, 23 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 15c073359c9e9..73fa79b5a51d1 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -670,6 +670,7 @@
 #define OP_AT_S12E1W	sys_insn(AT_Op0, 4, AT_CRn, 8, 5)
 #define OP_AT_S12E0R	sys_insn(AT_Op0, 4, AT_CRn, 8, 6)
 #define OP_AT_S12E0W	sys_insn(AT_Op0, 4, AT_CRn, 8, 7)
+#define OP_AT_S1E2A	sys_insn(AT_Op0, 4, AT_CRn, 9, 2)
 
 /* TLBI instructions */
 #define TLBI_Op0	1
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 8452273cbff6d..1e1255d244712 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -682,6 +682,9 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	case OP_AT_S1E0W:
 		perm_fail |= !uw;
 		break;
+	case OP_AT_S1E1A:
+	case OP_AT_S1E2A:
+		break;
 	default:
 		BUG();
 	}
@@ -794,6 +797,9 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	case OP_AT_S1E0W:
 		fail = __kvm_at(OP_AT_S1E0W, vaddr);
 		break;
+	case OP_AT_S1E1A:
+		fail = __kvm_at(OP_AT_S1E1A, vaddr);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		fail = true;
@@ -912,6 +918,9 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	case OP_AT_S1E2W:
 		fail = __kvm_at(OP_AT_S1E1W, vaddr);
 		break;
+	case OP_AT_S1E2A:
+		fail = __kvm_at(OP_AT_S1E1A, vaddr);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		fail = true;
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 96b837fe51562..b5ac298f76705 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -774,6 +774,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(OP_AT_S12E1W,		CGT_HCR_NV),
 	SR_TRAP(OP_AT_S12E0R,		CGT_HCR_NV),
 	SR_TRAP(OP_AT_S12E0W,		CGT_HCR_NV),
+	SR_TRAP(OP_AT_S1E2A,		CGT_HCR_NV),
 	SR_TRAP(OP_TLBI_IPAS2E1,	CGT_HCR_NV),
 	SR_TRAP(OP_TLBI_RIPAS2E1,	CGT_HCR_NV),
 	SR_TRAP(OP_TLBI_IPAS2LE1,	CGT_HCR_NV),
@@ -855,6 +856,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(OP_AT_S1E0W, 		CGT_HCR_AT),
 	SR_TRAP(OP_AT_S1E1RP, 		CGT_HCR_AT),
 	SR_TRAP(OP_AT_S1E1WP, 		CGT_HCR_AT),
+	SR_TRAP(OP_AT_S1E1A,		CGT_HCR_AT),
 	SR_TRAP(SYS_ERXPFGF_EL1,	CGT_HCR_nFIEN),
 	SR_TRAP(SYS_ERXPFGCTL_EL1,	CGT_HCR_nFIEN),
 	SR_TRAP(SYS_ERXPFGCDN_EL1,	CGT_HCR_nFIEN),
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d8dadcb9b5e3f..834893e461451 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2812,6 +2812,13 @@ static bool handle_at_s1e2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
@@ -3182,6 +3189,7 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(AT_S12E1W, handle_at_s12),
 	SYS_INSN(AT_S12E0R, handle_at_s12),
 	SYS_INSN(AT_S12E0W, handle_at_s12),
+	SYS_INSN(AT_S1E2A, handle_at_s1e2),
 
 	SYS_INSN(TLBI_IPAS2E1IS, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2E1IS, handle_ripas2e1is),
@@ -4630,6 +4638,9 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
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



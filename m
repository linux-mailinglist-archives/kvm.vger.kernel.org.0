Return-Path: <kvm+bounces-73119-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHMuBKcLq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73119-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:15:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F7A9225C4D
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 23D203003800
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5995F4301CA;
	Fri,  6 Mar 2026 17:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3CYEuul"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894AF41325C;
	Fri,  6 Mar 2026 17:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817040; cv=none; b=pOAzE6CQfSCytzA4OX8dACitnFk0qAxXhmppgZqlCCEPOUvddxhOTQjNWGgPr2valdC0vmeB9S8xeG74JvWnIsLRysyfmQ4r/26OBiegjmPkk1taP+ymZb1LLfENfKNB0H3f5Hm1fm5fDv3u7PaUfwoh5vZH0dEVqdzZdLXn/v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817040; c=relaxed/simple;
	bh=J5EO1xviE9VFn8+583CTCxibzcT4/ZQErwlFsDHecNo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=D8QazppkRo2so5o5w7GgDRCEFG49SFhnKnkWWD7T/y4C39B1tf2dkQaUc9wgMCMiT7Bb0MzZ0/VKt6KxEkWRC5uVyr1txTcV757T/xVEpgrz1ieUj0WQFZN27s7AcLgIJRzYEV2BOSMarGxwt9sJlQJebenuJq+Cv9MBUx+viPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3CYEuul; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6B4C4CEF7;
	Fri,  6 Mar 2026 17:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817040;
	bh=J5EO1xviE9VFn8+583CTCxibzcT4/ZQErwlFsDHecNo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=N3CYEuulJ177qjcAiexiehYsjLv27xJdXImip3kWt1Ls0CIgth/rFiO4/E0074UlE
	 TawWME1xl2L0dv2aCw0UKe3vMwFIJiDGvBHnkOxKUrwzEJGBXMf41eRh0RTipU5uso
	 ZKiSuoq4wMyoYQ2/vBl8MwWElpUrgOIereqoYjsooJIWuOayFaS8tOifUJGXToyJs6
	 /bSIMqWScyOWV+/4jq9StHbcjQKnB/99RpzvHIzyRCrbcXJJUkvpeWW/Ya4ija3K5n
	 JBHquZmUV6KsUuSeEbQCrd9VKgsNFIwaAnMjltAJji/z/HNONpHSnWahod+XtLuy95
	 /fIgG3PlGXliw==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:09 +0000
Subject: [PATCH v10 17/30] KVM: arm64: Support SME identification registers
 for guests
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-17-43f7683a0fb7@kernel.org>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
In-Reply-To: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-6ac23
X-Developer-Signature: v=1; a=openpgp-sha256; l=9360; i=broonie@kernel.org;
 h=from:subject:message-id; bh=J5EO1xviE9VFn8+583CTCxibzcT4/ZQErwlFsDHecNo=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwo1Th/KwCxjeHYiBvJe4lfMxXEt4BCdSWywn
 Gls9WVy/BOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKNQAKCRAk1otyXVSH
 0IEWB/9G92L2v8rdlgm6PYPvbFHf2la7m/pZwFrtfTC1OhfGoak0JPTVgs2nORdQGwyTRdMYIqf
 06yOw4MF4zclyeOSUIlbf9al7pe3Ix8Qg6YrMmqB/IIe6iW3ThkpMCUJLz+asI6/e7Xx0M4rNT0
 h1r89kDaD2swaL5rcKws9Q+HR2OwjFytZAGlH74Dt5EgXjfyPqx+q+Sl/l/m6j/nq1rgV5a5UI8
 TeyLSItp9rTtYng4Hg2qP3aRqi+cCg9c8cL5HDwhqP/2lQAXVewi2bkdE9Ix2vsA86tNvqb9mL9
 7nBETCjD1vJuUk1dG8qxzvSz6fw81BVNsu/gkCF0iznAm8ga
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 8F7A9225C4D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73119-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.918];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

The primary register for identifying SME is ID_AA64PFR1_EL1.SME.  This
is hidden from guests unless SME is enabled by the VMM.
When it is visible it is writable and can be used to control the
availability of SME2.

There is also a new register ID_AA64SMFR0_EL1 which we make writable,
forcing it to all bits 0 if SME is disabled.  This includes the field
SMEver giving the SME version, userspace is responsible for ensuring
the value is consistent with ID_AA64PFR1_EL1.SME.  It also includes
FA64, a separately enableable extension which provides the full FPSIMD
and SVE instruction set including FFR in streaming mode.  Userspace can
control the availability of FA64 by writing to this field.  The other
features enumerated there only add new instructions, there are no
architectural controls for these.

There is a further identification register SMIDR_EL1 which provides a
basic description of the SME microarchitecture, in a manner similar to
MIDR_EL1 for the PE.  It also describes support for priority management
and a basic affinity description for shared SME units, plus some RES0
space.  We do not support priority management for guests so this is
hidden from guests, along with any new fields.

As for MIDR_EL1 and REVIDR_EL1 we expose the implementer and revision
information to guests with the raw value from the CPU we are running on,
this may present issues for asymmetric systems or for migration as it
does for the existing registers.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/config.c           |  8 +-----
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  4 ++-
 arch/arm64/kvm/sys_regs.c         | 60 +++++++++++++++++++++++++++++++++++----
 4 files changed, 61 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ec1ede0c3c12..b8f9ab8fadd4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -397,6 +397,7 @@ struct kvm_arch {
 	u64 revidr_el1;
 	u64 aidr_el1;
 	u64 ctr_el0;
+	u64 smidr_el1;
 
 	/* Masks for VNCR-backed and general EL2 sysregs */
 	struct kvm_sysreg_masks	*sysreg_masks;
@@ -1568,6 +1569,8 @@ static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
 		return &ka->revidr_el1;
 	case SYS_AIDR_EL1:
 		return &ka->aidr_el1;
+	case SYS_SMIDR_EL1:
+		return &ka->smidr_el1;
 	default:
 		WARN_ON_ONCE(1);
 		return NULL;
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index d9f553cbf9df..57df8d0c38c4 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -281,14 +281,8 @@ static bool feat_anerr(struct kvm *kvm)
 
 static bool feat_sme_smps(struct kvm *kvm)
 {
-	/*
-	 * Revists this if KVM ever supports SME -- this really should
-	 * look at the guest's view of SMIDR_EL1. Funnily enough, this
-	 * is not captured in the JSON file, but only as a note in the
-	 * ARM ARM.
-	 */
 	return (kvm_has_feat(kvm, FEAT_SME) &&
-		(read_sysreg_s(SYS_SMIDR_EL1) & SMIDR_EL1_SMPS));
+		(kvm_read_vm_id_reg(kvm, SYS_SMIDR_EL1) & SMIDR_EL1_SMPS));
 }
 
 static bool feat_spe_fds(struct kvm *kvm)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 399968cf570e..2757833c4396 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -348,8 +348,10 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 			    host_kvm->arch.vcpu_features,
 			    KVM_VCPU_MAX_FEATURES);
 
-		if (test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &host_arch_flags))
+		if (test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &host_arch_flags)) {
 			hyp_vm->kvm.arch.midr_el1 = host_kvm->arch.midr_el1;
+			hyp_vm->kvm.arch.smidr_el1 = host_kvm->arch.smidr_el1;
+		}
 
 		return;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 66248fd48a7d..15854947de61 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1893,7 +1893,11 @@ static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 
 	switch (id) {
 	case SYS_ID_AA64ZFR0_EL1:
-		if (!vcpu_has_sve(vcpu))
+		if (!vcpu_has_sve(vcpu) && !vcpu_has_sme(vcpu))
+			return REG_RAZ;
+		break;
+	case SYS_ID_AA64SMFR0_EL1:
+		if (!vcpu_has_sme(vcpu))
 			return REG_RAZ;
 		break;
 	}
@@ -1923,6 +1927,18 @@ static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
 
 /* cpufeature ID register access trap handlers */
 
+static bool hidden_id_reg(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	switch (reg_to_encoding(r)) {
+	case SYS_SMIDR_EL1:
+		return !vcpu_has_sme(vcpu);
+	default:
+		return false;
+	}
+}
+
 static bool access_id_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
@@ -2015,7 +2031,9 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val)
 	      SYS_FIELD_GET(ID_AA64PFR0_EL1, RAS, pfr0) == ID_AA64PFR0_EL1_RAS_IMP))
 		val &= ~ID_AA64PFR1_EL1_RAS_frac;
 
-	val &= ~ID_AA64PFR1_EL1_SME;
+	if (!kvm_has_sme(vcpu->kvm))
+		val &= ~ID_AA64PFR1_EL1_SME;
+
 	val &= ~ID_AA64PFR1_EL1_RNDR_trap;
 	val &= ~ID_AA64PFR1_EL1_NMI;
 	val &= ~ID_AA64PFR1_EL1_GCS;
@@ -3026,6 +3044,9 @@ static bool access_imp_id_reg(struct kvm_vcpu *vcpu,
 			      struct sys_reg_params *p,
 			      const struct sys_reg_desc *r)
 {
+	if (hidden_id_reg(vcpu, p, r))
+		return bad_trap(vcpu, p, r, "write to hidden ID register");
+
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
@@ -3037,8 +3058,11 @@ static bool access_imp_id_reg(struct kvm_vcpu *vcpu,
 		return access_id_reg(vcpu, p, r);
 
 	/*
-	 * Otherwise, fall back to the old behavior of returning the value of
-	 * the current CPU.
+	 * Otherwise, fall back to the old behavior of returning the
+	 * value of the current CPU for REVIDR_EL1 and AIDR_EL1, or
+	 * use whatever the sanitised reset value we have is for other
+	 * registers not exposed prior to writability support for
+	 * these registers.
 	 */
 	switch (reg_to_encoding(r)) {
 	case SYS_REVIDR_EL1:
@@ -3047,6 +3071,9 @@ static bool access_imp_id_reg(struct kvm_vcpu *vcpu,
 	case SYS_AIDR_EL1:
 		p->regval = read_sysreg(aidr_el1);
 		break;
+	case SYS_SMIDR_EL1:
+		p->regval = r->val;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 	}
@@ -3057,12 +3084,15 @@ static bool access_imp_id_reg(struct kvm_vcpu *vcpu,
 static u64 __ro_after_init boot_cpu_midr_val;
 static u64 __ro_after_init boot_cpu_revidr_val;
 static u64 __ro_after_init boot_cpu_aidr_val;
+static u64 __ro_after_init boot_cpu_smidr_val;
 
 static void init_imp_id_regs(void)
 {
 	boot_cpu_midr_val = read_sysreg(midr_el1);
 	boot_cpu_revidr_val = read_sysreg(revidr_el1);
 	boot_cpu_aidr_val = read_sysreg(aidr_el1);
+	if (system_supports_sme())
+		boot_cpu_smidr_val = read_sysreg_s(SYS_SMIDR_EL1);
 }
 
 static u64 reset_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
@@ -3074,6 +3104,8 @@ static u64 reset_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		return boot_cpu_revidr_val;
 	case SYS_AIDR_EL1:
 		return boot_cpu_aidr_val;
+	case SYS_SMIDR_EL1:
+		return boot_cpu_smidr_val;
 	default:
 		KVM_BUG_ON(1, vcpu->kvm);
 		return 0;
@@ -3122,6 +3154,16 @@ static int set_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	.val = mask,					\
 	}
 
+#define IMPLEMENTATION_ID_FILTERED(reg, mask, reg_visibility) {	\
+	SYS_DESC(SYS_##reg),				\
+	.access = access_imp_id_reg,			\
+	.get_user = get_id_reg,				\
+	.set_user = set_imp_id_reg,			\
+	.reset = reset_imp_id_reg,			\
+	.visibility = reg_visibility,				\
+	.val = mask,					\
+	}
+
 static u64 reset_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	__vcpu_assign_sys_reg(vcpu, r->reg, vcpu->kvm->arch.nr_pmu_counters);
@@ -3238,7 +3280,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				       ID_AA64PFR1_EL1_MTE_frac |
 				       ID_AA64PFR1_EL1_NMI |
 				       ID_AA64PFR1_EL1_RNDR_trap |
-				       ID_AA64PFR1_EL1_SME |
 				       ID_AA64PFR1_EL1_RES0 |
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_MTE)),
@@ -3248,7 +3289,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    ID_AA64PFR2_EL1_MTESTOREONLY),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
-	ID_HIDDEN(ID_AA64SMFR0_EL1),
+	ID_WRITABLE(ID_AA64SMFR0_EL1, ~ID_AA64SMFR0_EL1_RES0),
 	ID_UNALLOCATED(4,6),
 	ID_WRITABLE(ID_AA64FPFR0_EL1, ~ID_AA64FPFR0_EL1_RES0),
 
@@ -3454,6 +3495,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
 	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
+	IMPLEMENTATION_ID_FILTERED(SMIDR_EL1,
+				   (SMIDR_EL1_NSMC | SMIDR_EL1_HIP |
+				    SMIDR_EL1_AFFINITY2 |
+				    SMIDR_EL1_IMPLEMENTER |
+				    SMIDR_EL1_REVISION | SMIDR_EL1_SH |
+				    SMIDR_EL1_AFFINITY),
+				   sme_visibility),
 	IMPLEMENTATION_ID(AIDR_EL1, GENMASK_ULL(63, 0)),
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	ID_FILTERED(CTR_EL0, ctr_el0,

-- 
2.47.3



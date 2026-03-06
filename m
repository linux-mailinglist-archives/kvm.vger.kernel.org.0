Return-Path: <kvm+bounces-73123-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iF/TNWcMq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73123-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:18:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 43B0C225D2C
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:18:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2424C31B03BB
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F9AF43E9C3;
	Fri,  6 Mar 2026 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jy0PsE97"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F37441163E;
	Fri,  6 Mar 2026 17:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817058; cv=none; b=VjgtF23cazc+hg4QmUn8hVODFUWP4HnS4w+VDN3eDG7vlgUl441nKyBwbOvF+jaWqPuG2M2VCfRkbG1kPD+XIV0mlkDtoYybBfnVl9omLH8Nl5tOHQWzW51zH3Gr/qHZcjK+G1zvdnHSfwic2nC4TPbfSl8n8uM7MeTofVAYjek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817058; c=relaxed/simple;
	bh=XMWKLA20ZJQ2D0jPmK3pGEr/rR365kxTEGOE8CBcYKo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=snsshCUEvPoRmsm/j8HLgn93o6tsMUidW82KWX3Hh9UpvLpe2SKAzDzZag2j/PnPlgd9G3lyS0JOjD/bzturjuOM+A17N7WpCBAKsAck77aXCLJqlWYrMmvvTtWKiD+LMxn1t46hXApxheisyvCk8tVnGHPuHt0VReFSFo5lCeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jy0PsE97; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2888BC2BC86;
	Fri,  6 Mar 2026 17:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817058;
	bh=XMWKLA20ZJQ2D0jPmK3pGEr/rR365kxTEGOE8CBcYKo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jy0PsE97fdBos7uFwCnhSEbAKskXM3/fhbc94U6zjtBirw/7zesavv4H3JUyxDjgd
	 VjP3km3gjW4kbshvFPiBwPcgcylOsjOPUZBPz7QZfESvzku8RAGmxbO4E0lZsNuQGC
	 lS+URgG2cQ7rx5qXEtFbraOCAGKJQAYxBWZekZqOAywsUg6Wjbm7rgYhCyfKiKvfwh
	 ude9dLjYYOXY8otXWL/n/AqjD/rTYZBhCHf4lSq07yCaV6TxnxlrgcI0yRXiRsjXA9
	 Ubj1XpZeaO10NZpxYgYpB+ZAvlvQBQVPzXwA+rqT+522WdDBbp14OXVnXHOvFkcQUo
	 iL12G1WtBl/jw==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:13 +0000
Subject: [PATCH v10 21/30] KVM: arm64: Flush register state on writes to
 SVCR.SM and SVCR.ZA
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-21-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4405; i=broonie@kernel.org;
 h=from:subject:message-id; bh=XMWKLA20ZJQ2D0jPmK3pGEr/rR365kxTEGOE8CBcYKo=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwo4QB0GzEXtABB8d+AGe7mHIeS5KOZQ4FwqN
 ejgafKoNX2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKOAAKCRAk1otyXVSH
 0NycB/97X0uK9f1azHuOQ9RQ6KvzB3F7lsfXwATUwgISCKtgmoBQo3Yp3RnWqW/dP7qv49ubFVB
 2uQhPj8uIT4fw5JT9uWAZWzcMsLnROShZjCgiyuiwYxrl76n/yBdkTnRgSbSfoii6+1aOLOEe/t
 0E2DbQnv0pI/DamIUJSWsuoY0Uh34MJ8ULaz+j6YEPYZX0j0Kh1C5ejLVkdVKxBrSZLrNfy/siO
 x+CMlqhO2/d/N42MYLdqL0y0vSosxDw+HRDAQUaiIsS2oj4o/4kVmA3q/THepzr8xnvfMMZX9U0
 fwFXvt4nyPydtfHvdhDqiUy8HmmNwzzdM+jC/OrMQxyCSFVq
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 43B0C225D2C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73123-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.916];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[svcr.sm:url,pstate.sm:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Writes to the physical SVCR.SM and SVCR.ZA change the state of PSTATE.SM
and PSTATE.ZA, causing other floating point state to reset. Emulate this
behaviour for writes done via the KVM userspace ABI.

Setting PSTATE.ZA to 1 causes ZA and ZT0 to be reset to 0, these are stored
in sme_state. Setting PSTATE.ZA to 0 causes ZA and ZT0 to become inaccessible
so no reset is needed.

Any change in PSTATE.SM causes the V, Z, P, FFR and FPMR registers to be
reset to 0 and FPSR to be reset to 0x800009f.

Rather than introduce a requirement that the vector configuration be
finalised before writing to SVCR we check for this before updating the
SVE and SME specific state, when finalisation happens they will be
allocated with an initial state of 0.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 24 ++++++++++++++++++++++++
 arch/arm64/include/asm/sysreg.h   |  2 ++
 arch/arm64/kvm/sys_regs.c         | 30 +++++++++++++++++++++++++++++-
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 094cbf8e7022..aa0817eb1b48 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1172,6 +1172,30 @@ struct kvm_vcpu_arch {
 
 #define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.max_vl[ARM64_VEC_SVE])
 
+#define vcpu_sme_state(vcpu) (kern_hyp_va((vcpu)->arch.sme_state))
+
+#define sme_state_size_from_vl(vl, sme2) ({				\
+	size_t __size_ret;						\
+	unsigned int __vq;						\
+									\
+	if (WARN_ON(!sve_vl_valid(vl))) {				\
+		__size_ret = 0;						\
+	} else {							\
+		__vq = sve_vq_from_vl(vl);				\
+		__size_ret = ZA_SIG_REGS_SIZE(__vq);			\
+		if (sme2)						\
+			__size_ret += ZT_SIG_REG_SIZE;			\
+	}								\
+									\
+	__size_ret;							\
+})
+
+#define vcpu_sme_state_size(vcpu) ({					\
+	unsigned long __vl;						\
+	__vl = (vcpu)->arch.max_vl[ARM64_VEC_SME];			\
+	sme_state_size_from_vl(__vl, vcpu_has_sme2(vcpu));		\
+})
+
 /*
  * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
  * memory backed version of a register, and not the one most recently
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index f4436ecc630c..90d398429d80 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1101,6 +1101,8 @@
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
 
+#define FPSR_RESET_VALUE	0x800009f
+
 #ifdef __ASSEMBLER__
 
 	.macro	mrs_s, rt, sreg
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0ddb89723819..8a9fd8d69d6e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -927,6 +927,34 @@ static unsigned int hidden_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static int set_svcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		    u64 val)
+{
+	u64 old = __vcpu_sys_reg(vcpu, rd->reg);
+
+	if (val & SVCR_RES0)
+		return -EINVAL;
+
+	if ((val & SVCR_ZA) && !(old & SVCR_ZA) &&
+	    kvm_arm_vcpu_vec_finalized(vcpu))
+		memset(vcpu->arch.sme_state, 0, vcpu_sme_state_size(vcpu));
+
+	if ((val & SVCR_SM) != (old & SVCR_SM)) {
+		memset(vcpu->arch.ctxt.fp_regs.vregs, 0,
+		       sizeof(vcpu->arch.ctxt.fp_regs.vregs));
+
+		if (kvm_arm_vcpu_vec_finalized(vcpu))
+			memset(vcpu->arch.sve_state, 0,
+			       vcpu_sve_state_size(vcpu));
+
+		__vcpu_assign_sys_reg(vcpu, FPMR, 0);
+		vcpu->arch.ctxt.fp_regs.fpsr = FPSR_RESET_VALUE;
+	}
+
+	__vcpu_assign_sys_reg(vcpu, rd->reg, val);
+	return 0;
+}
+
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *r)
 {
@@ -3535,7 +3563,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    CTR_EL0_DminLine_MASK |
 		    CTR_EL0_L1Ip_MASK |
 		    CTR_EL0_IminLine_MASK),
-	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
+	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility, .set_user = set_svcr },
 	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,

-- 
2.47.3



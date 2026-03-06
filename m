Return-Path: <kvm+bounces-73125-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qAT0DkkMq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73125-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:18:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1725D225D07
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CCCF93065032
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FF6425CCD;
	Fri,  6 Mar 2026 17:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1lLl5M5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5259041323D;
	Fri,  6 Mar 2026 17:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817067; cv=none; b=BFhQKrOVQHlhLeyukSn2tW67Y3zP3r88WD+bZ4mIiY/8fCKHH/NX7ej6GOQV5YNDls44w3uoqZ/u7UBikrbbl2npz2rhmM0aSpQkSsEdZbWEkA32jW2nJq02x9VsvBtV8ifZ6eCE1BeOFry8a62+EHGMx2Hju723ElZ9w/aoLJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817067; c=relaxed/simple;
	bh=8fclKZDnoWtyS0nblev56P0iXdl9hH24A3+WWsGkR1E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qS+fZ5YbKtswzYcKsMPDj+odxU+Tm2GoiXlEgRhcLAb7gyo/KtmclitOc2vXs43PBGo94cK9PDhmORLlnH5d8fSAB/01jBpyv/CjnB1nfxYl18geO6gh3xeoqGvOxdzth3ciFpBhvlR0Hh1eJK1Aix4u2KHwDzDHSMj7WQeQzdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1lLl5M5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C47C19425;
	Fri,  6 Mar 2026 17:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817067;
	bh=8fclKZDnoWtyS0nblev56P0iXdl9hH24A3+WWsGkR1E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=S1lLl5M5xezHI47qHl4Bsw80LWTwY6hQmUbzajw/hZhN5D4KuVReJfY9xHFGNQHqE
	 G+LpNAZmP3HFic5s0t8NRCqXj+N6ijvNjG1PxnbpgFlv7YsGLTIWi8TvwCznSG+DuC
	 yuOrymmUZuSaNIX1spwV3aSJv5Gx2qkaaTYLmaIcFcUfyOf+XF7JTipwOCKbjgprHt
	 nopRqlXQm7y6mY8j9/iheYZEA5dIwiUli4n8k3Ju/9H8ejGG+mHrOyquFC9dLhwFl0
	 W+fptYi8KSHCAp5M+blEwTmU9wKOL16zRkuvKLbxwZvWkayDTkxXWNVjyRQi0zxKZv
	 YVd/ByLEEhS+Q==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:15 +0000
Subject: [PATCH v10 23/30] KVM: arm64: Context switch SME state for guests
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-23-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=18895; i=broonie@kernel.org;
 h=from:subject:message-id; bh=8fclKZDnoWtyS0nblev56P0iXdl9hH24A3+WWsGkR1E=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwo6O1B/v56CmOocLRwl1WcAZjWteSD7r0gSV
 CCuSeE6+AGJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKOgAKCRAk1otyXVSH
 0HN/B/0S6R4ELZmartGXkJf5zpP8JaDIdylH1R4LOoUdqq3OpmrU/Xf2gYmWJEm/CD1AAsK3Th2
 wbweq3fQ7rakV9Dokn80Ih8P9B1wkDtNiF8c2haznUUCVQE752b/4ckoNAWrW2lgy88Qle1LtEi
 kv+zg2o48azhZD1LQUedX2HimqP6vtqDBFvcrkt9gFT9PSeNL31QRrKwH59NjwZQEKQxno9FJ2v
 INsCl8MbZ4uOnmNpMsp17us83C0mGV8sNtzpLhDIazkVCPV6uYJ6fZRIYoMtYNDzt7mOu2OxNsR
 ZH5404vTQ/rngjD+WrhagKZIiCHWD7QTw9eZ4W2qC/Ss9i8Z
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 1725D225D07
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73125-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.915];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fp_state.st:url,pstate.sm:url,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

If the guest has SME state we need to context switch that state, provide
support for that for normal guests.

SME has three sets of registers, ZA, ZT (only present for SME2) and also
streaming SVE which replaces the standard floating point registers when
active. The first two are fairly straightforward, they are accessible only
when PSTATE.ZA is set and we can reuse the assembly from the host to save
and load them from a single contiguous buffer. When PSTATE.ZA is not set
then these registers are inaccessible, when the guest enables PSTATE.ZA
all bits will be set to 0 by that and nothing is required on restore.

Streaming mode is slightly more complicated, when enabled via PSTATE.SM it
provides a version of the SVE registers using the SME vector length and may
optionally omit the FFR register. SME may also be present without SVE. The
register state is stored in sve_state as for non-streaming SVE mode, we
make an initial selection of registers to update based on the guest SVE
support and then override this when loading SVCR if streaming mode is
enabled.

A further complication is that when the hardware is in streaming mode
guest operations that are invalid in in streaming mode will generate SME
exceptions. There are also subfeature exceptions for SME2 controlled via
SMCR which generate distinct exception codes. In many situations these
exceptions are routed directly to the lower ELs with no opportunity for
the hypervisor to intercept. So that guests do not see unexpected
exception types due to the actual hardware configuration not being what
the guest configured we update the SMCRs and SVCR even if the guest does
not own the registers.

Since in order to avoid duplication with SME we now restore the register
state outside of the SVE specific restore function we need to move the
restore of the effective VL for nested guests to a separate restore
function run after loading the floating point register state, along with
the similar handling required for SME.

The selection of which vector length to use is handled by vcpu_sve_pffr().

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h         |  10 ++
 arch/arm64/include/asm/kvm_host.h       |   4 +
 arch/arm64/kvm/fpsimd.c                 |  25 ++++-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 157 ++++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 107 ++++++++++++++++++----
 5 files changed, 274 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 05566bbfa4d4..f891261a5c91 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -448,6 +448,15 @@ static inline size_t sme_state_size(struct task_struct const *task)
 			write_sysreg_s(__new, (reg));		\
 	} while (0)
 
+#define sme_cond_update_smcr_vq(val, reg)			\
+	do {							\
+		u64 __smcr = read_sysreg_s((reg));		\
+		u64 __new = __smcr & ~SMCR_ELx_LEN_MASK;	\
+		__new |= (val) & SMCR_ELx_LEN_MASK;		\
+		if (__smcr != __new)				\
+			write_sysreg_s(__new, (reg));		\
+	} while (0)
+
 #else
 
 static inline void sme_user_disable(void) { BUILD_BUG(); }
@@ -477,6 +486,7 @@ static inline size_t sme_state_size(struct task_struct const *task)
 }
 
 #define sme_cond_update_smcr(val, fa64, zt0, reg) do { } while (0)
+#define sme_cond_update_smcr_vq(val, reg) do { } while (0)
 
 #endif /* ! CONFIG_ARM64_SME */
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index aa0817eb1b48..f804cf160b1e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -760,6 +760,7 @@ struct kvm_host_data {
 
 	/* Used by pKVM only. */
 	u64	fpmr;
+	u64	smcr_el1;
 
 	/* Ownership of the FP regs */
 	enum {
@@ -1156,6 +1157,9 @@ struct kvm_vcpu_arch {
 #define vcpu_sve_zcr_elx(vcpu)						\
 	(unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
 
+#define vcpu_sme_smcr_elx(vcpu)						\
+	(unlikely(is_hyp_ctxt(vcpu)) ? SMCR_EL2 : SMCR_EL1)
+
 #define sve_state_size_from_vl(sve_max_vl) ({				\
 	size_t __size_ret;						\
 	unsigned int __vq;						\
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 1f4fcc8b5554..8fb8c55e50b3 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -69,19 +69,25 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (guest_owns_fp_regs()) {
-		/*
-		 * Currently we do not support SME guests so SVCR is
-		 * always 0 and we just need a variable to point to.
-		 */
 		fp_state.st = &vcpu->arch.ctxt.fp_regs;
 		fp_state.sve_state = vcpu->arch.sve_state;
 		fp_state.sve_vl = vcpu->arch.max_vl[ARM64_VEC_SVE];
-		fp_state.sme_state = NULL;
+		fp_state.sme_state = vcpu->arch.sme_state;
+		fp_state.sme_vl = vcpu->arch.max_vl[ARM64_VEC_SME];
 		fp_state.svcr = __ctxt_sys_reg(&vcpu->arch.ctxt, SVCR);
 		fp_state.fpmr = __ctxt_sys_reg(&vcpu->arch.ctxt, FPMR);
 		fp_state.fp_type = &vcpu->arch.fp_type;
+
 		fp_state.sme_features = 0;
+		if (kvm_has_fa64(vcpu->kvm))
+			fp_state.sme_features |= SMCR_ELx_FA64;
+		if (kvm_has_sme2(vcpu->kvm))
+			fp_state.sme_features |= SMCR_ELx_EZT0;
 
+		/*
+		 * For SME only hosts fpsimd_save() will override the
+		 * state selection if we are in streaming mode.
+		 */
 		if (vcpu_has_sve(vcpu))
 			fp_state.to_save = FP_STATE_SVE;
 		else
@@ -90,6 +96,15 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 		fpsimd_bind_state_to_cpu(&fp_state);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
+	} else {
+		/*
+		 * We might have enabled SME to configure traps but
+		 * insist the host doesn't run the hypervisor with SME
+		 * enabled, ensure it's disabled again.
+		 */
+		if (system_supports_sme()) {
+			sme_smstop();
+		}
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5b99aa479c59..7312b8f34c7a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -429,6 +429,22 @@ static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static inline void __hyp_sme_restore_guest(struct kvm_vcpu *vcpu,
+					   bool *restore_sve,
+					   bool *restore_ffr)
+{
+	bool has_fa64 = vcpu_has_fa64(vcpu);
+	bool has_sme2 = vcpu_has_sme2(vcpu);
+
+	if (vcpu_in_streaming_mode(vcpu)) {
+		*restore_sve = true;
+		*restore_ffr = has_fa64;
+	}
+
+	if (vcpu_za_enabled(vcpu))
+		__sme_restore_state(vcpu_sme_state(vcpu), has_sme2);
+}
+
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -436,19 +452,25 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	 * vCPU. Start off with the max VL so we can load the SVE state.
 	 */
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
-	__sve_restore_state(vcpu_sve_pffr(vcpu),
-			    &vcpu->arch.ctxt.fp_regs.fpsr,
-			    true);
 
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)), SYS_ZCR);
+}
+
+static inline void __hyp_nv_restore_guest_vls(struct kvm_vcpu *vcpu)
+{
 	/*
 	 * The effective VL for a VM could differ from the max VL when running a
 	 * nested guest, as the guest hypervisor could select a smaller VL. Slap
 	 * that into hardware before wrapping up.
 	 */
-	if (is_nested_ctxt(vcpu))
+	if (!is_nested_ctxt(vcpu))
+		return;
+
+	if (vcpu_has_sve(vcpu))
 		sve_cond_update_zcr_vq(__vcpu_sys_reg(vcpu, ZCR_EL2), SYS_ZCR_EL2);
 
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)), SYS_ZCR);
+	if (vcpu_has_sme(vcpu))
+		sme_cond_update_smcr_vq(__vcpu_sys_reg(vcpu, SMCR_EL2), SYS_SMCR_EL2);
 }
 
 static inline void __hyp_sve_save_host(void)
@@ -462,10 +484,46 @@ static inline void __hyp_sve_save_host(void)
 			 true);
 }
 
+static inline void kvm_sme_configure_traps(struct kvm_vcpu *vcpu)
+{
+	u64 smcr_el1, smcr_el2;
+	u64 svcr;
+
+	if (!vcpu_has_sme(vcpu))
+		return;
+
+	/* A guest hypervisor may restrict the effective max VL. */
+	if (is_nested_ctxt(vcpu))
+		smcr_el2 = __vcpu_sys_reg(vcpu, SMCR_EL2);
+	else
+		smcr_el2 = vcpu_sme_max_vq(vcpu) - 1;
+
+	if (vcpu_has_fa64(vcpu))
+		smcr_el2 |= SMCR_ELx_FA64;
+	if (vcpu_has_sme2(vcpu))
+		smcr_el2 |= SMCR_ELx_EZT0;
+
+	write_sysreg_el2(smcr_el2, SYS_SMCR);
+
+	smcr_el1 = __vcpu_sys_reg(vcpu, vcpu_sme_smcr_elx(vcpu));
+	write_sysreg_el1(smcr_el1, SYS_SMCR);
+
+	svcr = __vcpu_sys_reg(vcpu, SVCR);
+	write_sysreg_s(svcr, SYS_SVCR);
+}
+
 static inline void fpsimd_lazy_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	u64 zcr_el1, zcr_el2;
 
+	/*
+	 * We always load the SME control registers that affect traps
+	 * since if they are not configured as expected by the guest
+	 * then it may have exceptions that it does not expect
+	 * directly delivered.
+	 */
+	kvm_sme_configure_traps(vcpu);
+
 	if (!guest_owns_fp_regs())
 		return;
 
@@ -519,8 +577,57 @@ static inline void sve_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 	}
 }
 
+static inline void sme_lazy_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	u64 smcr_el1, smcr_el2;
+
+	if (!vcpu_has_sme(vcpu))
+		return;
+
+	/*
+	 * __deactivate_cptr_traps() disabled traps, but there hasn't
+	 * necessarily been a context synchronization event yet.
+	 */
+	isb();
+
+	smcr_el1 = read_sysreg_el1(SYS_SMCR);
+	__vcpu_assign_sys_reg(vcpu, vcpu_sme_smcr_elx(vcpu), smcr_el1);
+
+	smcr_el2 = 0;
+	if (system_supports_fa64())
+		smcr_el2 |= SMCR_ELx_FA64;
+	if (system_supports_sme2())
+		smcr_el2 |= SMCR_ELx_EZT0;
+
+	/*
+	 * The guest's state is always saved using the guest's max VL.
+	 * Ensure that the host has the guest's max VL active such
+	 * that the host can save the guest's state lazily, but don't
+	 * artificially restrict the host to the guest's max VL.
+	 */
+	if (has_vhe()) {
+		smcr_el2 |= vcpu_sme_max_vq(vcpu) - 1;
+		write_sysreg_el2(smcr_el2, SYS_SMCR);
+	} else {
+		smcr_el1 = smcr_el2;
+		smcr_el2 |= sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SME]) - 1;
+		write_sysreg_el2(smcr_el2, SYS_SMCR);
+
+		smcr_el1 |= vcpu_sme_max_vq(vcpu) - 1;
+		write_sysreg_el1(smcr_el1, SYS_SMCR);
+	}
+
+	__vcpu_assign_sys_reg(vcpu, SVCR, read_sysreg_s(SYS_SVCR));
+}
+
 static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * We always load the control registers for the guest so we
+	 * always restore state for the host.
+	 */
+	sme_lazy_switch_to_host(vcpu);
+
 	if (!guest_owns_fp_regs())
 		return;
 
@@ -529,6 +636,16 @@ static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * The hypervisor refuses to run if streaming mode or ZA is
+	 * enabled, we only need to save SMCR_EL1 for SME.  For pKVM
+	 * we will restore this, reset SMCR_EL2 to a fixed value and
+	 * disable streaming mode and ZA to avoid any state being
+	 * leaked.
+	 */
+	if (system_supports_sme())
+		*host_data_ptr(smcr_el1) = read_sysreg_el1(SYS_SMCR);
+
 	/*
 	 * Non-protected kvm relies on the host restoring its sve state.
 	 * Protected kvm restores the host's sve state as not to reveal that
@@ -553,14 +670,17 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
  */
 static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	bool sve_guest;
-	u8 esr_ec;
+	bool restore_sve, restore_ffr;
+	bool sve_guest, sme_guest;
+	u8 esr_ec, esr_iss_smtc;
 
 	if (!system_supports_fpsimd())
 		return false;
 
 	sve_guest = vcpu_has_sve(vcpu);
+	sme_guest = vcpu_has_sme(vcpu);
 	esr_ec = kvm_vcpu_trap_get_class(vcpu);
+	esr_iss_smtc = ESR_ELx_SME_ISS_SMTC((kvm_vcpu_get_esr(vcpu)));
 
 	/* Only handle traps the vCPU can support here: */
 	switch (esr_ec) {
@@ -579,6 +699,15 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 		if (guest_hyp_sve_traps_enabled(vcpu))
 			return false;
 		break;
+	case ESR_ELx_EC_SME:
+		if (!sme_guest)
+			return false;
+		if (guest_hyp_sme_traps_enabled(vcpu))
+			return false;
+		if (!kvm_has_sme2(vcpu->kvm) &&
+		    (esr_iss_smtc == ESR_ELx_SME_ISS_SMTC_ZT_DISABLED))
+			return false;
+		break;
 	default:
 		return false;
 	}
@@ -594,8 +723,20 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 		kvm_hyp_save_fpsimd_host(vcpu);
 
 	/* Restore the guest state */
+
+	/* These may be overridden for a SME guest */
+	restore_sve = sve_guest;
+	restore_ffr = sve_guest;
+
 	if (sve_guest)
 		__hyp_sve_restore_guest(vcpu);
+	if (sme_guest)
+		__hyp_sme_restore_guest(vcpu, &restore_sve, &restore_ffr);
+
+	if (restore_sve)
+		__sve_restore_state(vcpu_sve_pffr(vcpu),
+				    &vcpu->arch.ctxt.fp_regs.fpsr,
+				    restore_ffr);
 	else
 		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
 
@@ -606,6 +747,8 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
 		write_sysreg(__vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
 
+	__hyp_nv_restore_guest_vls(vcpu);
+
 	*host_data_ptr(fp_owner) = FP_STATE_GUEST_OWNED;
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f4da7a452964..c00fbade1feb 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -26,15 +26,27 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
 static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 {
-	__vcpu_assign_sys_reg(vcpu, ZCR_EL1, read_sysreg_el1(SYS_ZCR));
-	/*
-	 * On saving/restoring guest sve state, always use the maximum VL for
-	 * the guest. The layout of the data when saving the sve state depends
-	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
-	 */
-	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
-	__sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fpsr, true);
-	write_sysreg_s(sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1, SYS_ZCR_EL2);
+	bool save_ffr = !vcpu_in_streaming_mode(vcpu) || vcpu_has_fa64(vcpu);
+
+	if (vcpu_has_sve(vcpu)) {
+		__vcpu_assign_sys_reg(vcpu, ZCR_EL1, read_sysreg_el1(SYS_ZCR));
+
+		/*
+		 * On saving/restoring guest sve state, always use the
+		 * maximum VL for the guest. The layout of the data
+		 * when saving the sve state depends on the VL, so use
+		 * a consistent (i.e., the maximum) guest VL.
+		 */
+		sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	}
+
+	/* Ensure ZCR/SMCR updates for VL are seen */
+	isb();
+	__sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fpsr, save_ffr);
+
+	if (system_supports_sve())
+		write_sysreg_s(sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1,
+			       SYS_ZCR_EL2);
 }
 
 static void __hyp_sve_restore_host(void)
@@ -57,9 +69,65 @@ static void __hyp_sve_restore_host(void)
 	write_sysreg_el1(sve_state->zcr_el1, SYS_ZCR);
 }
 
-static void fpsimd_sve_flush(void)
+static void __hyp_sme_save_guest(struct kvm_vcpu *vcpu)
 {
-	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
+	__vcpu_assign_sys_reg(vcpu, SMCR_EL1, read_sysreg_el1(SYS_SMCR));
+	__vcpu_assign_sys_reg(vcpu, SVCR, read_sysreg_s(SYS_SVCR));
+
+	/*
+	 * On saving/restoring guest sve state, always use the maximum VL for
+	 * the guest. The layout of the data when saving the sve state depends
+	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
+	 *
+	 * We restore the FA64 and SME2 enables for the host since we
+	 * will always restore the host configuration so if host and
+	 * guest VLs are the same we might suppress an update.
+	 */
+	sme_cond_update_smcr(vcpu_sme_max_vq(vcpu) - 1, system_supports_fa64(),
+			     system_supports_sme2(), SYS_SMCR_EL2);
+
+	if (vcpu_za_enabled(vcpu)) {
+		isb();
+		__sme_save_state(vcpu_sme_state(vcpu), vcpu_has_sme2(vcpu));
+	}
+}
+
+static void __hyp_sme_restore_host(void)
+{
+	/*
+	 * The hypervisor refuses to run if we are in streaming mode
+	 * or have ZA enabled so there is no SME specific state to
+	 * restore other than the system registers.
+	 *
+	 * Note that this constrains the PE to the maximum shared VL
+	 * that was discovered, if we wish to use larger VLs this will
+	 * need to be revisited.
+	 */
+	sme_cond_update_smcr(sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SME]) - 1,
+			     cpus_have_final_cap(ARM64_SME_FA64),
+			     cpus_have_final_cap(ARM64_SME2), SYS_SMCR_EL2);
+
+	write_sysreg_el1(*host_data_ptr(smcr_el1), SYS_SMCR);
+
+	sme_smstop();
+}
+
+static void fpsimd_sve_flush(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If the guest has SME then we need to restore the trap
+	 * controls in SMCR and mode in SVCR in order to ensure that
+	 * traps generated directly to EL1 have the correct types,
+	 * otherwise we can defer until we load the guest state.
+	 */
+	if (vcpu_has_sme(vcpu)) {
+		kvm_hyp_save_fpsimd_host(vcpu);
+		kvm_sme_configure_traps(vcpu);
+
+		*host_data_ptr(fp_owner) = FP_STATE_FREE;
+	} else {
+		*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
+	}
 }
 
 static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
@@ -75,7 +143,10 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	 */
 	isb();
 
-	if (vcpu_has_sve(vcpu))
+	if (vcpu_has_sme(vcpu))
+		__hyp_sme_save_guest(vcpu);
+
+	if (vcpu_has_sve(vcpu) || vcpu_in_streaming_mode(vcpu))
 		__hyp_sve_save_guest(vcpu);
 	else
 		__fpsimd_save_state(&vcpu->arch.ctxt.fp_regs);
@@ -84,6 +155,9 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	if (has_fpmr)
 		__vcpu_assign_sys_reg(vcpu, FPMR, read_sysreg_s(SYS_FPMR));
 
+	if (system_supports_sme())
+		__hyp_sme_restore_host();
+
 	if (system_supports_sve())
 		__hyp_sve_restore_host();
 	else
@@ -121,7 +195,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 
-	fpsimd_sve_flush();
+	fpsimd_sve_flush(host_vcpu);
 	flush_debug_state(hyp_vcpu);
 
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
@@ -207,10 +281,9 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 		struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 
 		/*
-		 * KVM (and pKVM) doesn't support SME guests for now, and
-		 * ensures that SME features aren't enabled in pstate when
-		 * loading a vcpu. Therefore, if SME features enabled the host
-		 * is misbehaving.
+		 * KVM (and pKVM) refuses to run if PSTATE.{SM,ZA} are
+		 * enabled. Therefore, if SME features enabled the
+		 * host is misbehaving.
 		 */
 		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR))) {
 			ret = -EINVAL;

-- 
2.47.3



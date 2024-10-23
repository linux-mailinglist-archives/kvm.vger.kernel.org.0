Return-Path: <kvm+bounces-29529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6EA9ACDE2
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69780283EA9
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBEFD2010EF;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ha0RKobK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEC21CF7DC;
	Wed, 23 Oct 2024 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695233; cv=none; b=mauucWCOBPV7HV2adYt8XblsVEkFTFrY07ZJ9D4gYBRMjUUrrpsDsKGlwJI06YCmnqI1pqJkoDHZfyKNHoYsDK3VmHL0U/N0LfS+iJEZAFngxE0hoUMjDsnK78c44rsK+ZsVZCwNPCXHPVfLSx/sa6fLQ1luKpPqBzOUJjB2oe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695233; c=relaxed/simple;
	bh=4MjW/EuSls0e+SIBQM5USomwvafVfpHapjN7NOaVjCY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=su/OgdyzJ31zdGzxPH+Nsq26fdY0yBWpuvAmFIPqEVaTAq71ObYZ4jvm13b2tBJATVCuBAsch90q5GYdMaKT6ONgNZmBk2VA3ZS0/CUlhfHaeW7fr/2P8nBJzp/8wy8s3YqoQZiyDuqB6dh4q1uZlhWCmVRv7tua9noPie0QSt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ha0RKobK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB512C4CEE8;
	Wed, 23 Oct 2024 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695233;
	bh=4MjW/EuSls0e+SIBQM5USomwvafVfpHapjN7NOaVjCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ha0RKobKwM19ZDEAqvORYXjc+FXtzm0nPhKleUqIsrOKP8YxJ+HCCd4b+6MI9NChA
	 AJGwkpy5zmbyPJddYSAgEPWWiKGm2uJ7qa33rfwO/i8OQBz0CbEHHAo4N4mpWfMlYE
	 9LRVmrneK+D6OSw1aaMK1GvqLX5a/91DyCWL/5IQYS/qF9B8ApFd7LnSM+EvHXCC7n
	 yMnOmf04aIMUQwdHDig+g6rl7IwaQA3fVMeghPZSJR/1WJhnbAYg+Oa0CAWR+VETDU
	 dW39fGAUrb6CM3WztZF7EL92Hb0SqVk+XKJVbRDN1w6oZsayfL/eXnFCNSxmswyvYk
	 Q0PnyX97k3K/g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckA-0068vz-ST;
	Wed, 23 Oct 2024 15:53:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 07/37] KVM: arm64: nv: Save/Restore vEL2 sysregs
Date: Wed, 23 Oct 2024 15:53:15 +0100
Message-Id: <20241023145345.1613824-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Whenever we need to restore the guest's system registers to the CPU, we
now need to take care of the EL2 system registers as well. Most of them
are accessed via traps only, but some have an immediate effect and also
a guest running in VHE mode would expect them to be accessible via their
EL1 encoding, which we do not trap.

For vEL2 we write the virtual EL2 registers with an identical format directly
into their EL1 counterpart, and translate the few registers that have a
different format for the same effect on the execution when running a
non-VHE guest guest hypervisor.

Based on an initial patch from Andre Przywara, rewritten many times
since.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   5 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c        |   2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 136 ++++++++++++++++++++-
 3 files changed, 138 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 1579a3c08a36b..d67628d01bf5e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -152,9 +152,10 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),	tpidrro_el0);
 }
 
-static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
+static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
+					      u64 mpidr)
 {
-	write_sysreg(ctxt_sys_reg(ctxt, MPIDR_EL1),	vmpidr_el2);
+	write_sysreg(mpidr,				vmpidr_el2);
 
 	if (has_vhe() ||
 	    !cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
index 29305022bc048..dba101565de36 100644
--- a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
@@ -28,7 +28,7 @@ void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 
 void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_restore_el1_state(ctxt);
+	__sysreg_restore_el1_state(ctxt, ctxt_sys_reg(ctxt, MPIDR_EL1));
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
 	__sysreg_restore_el2_return_state(ctxt);
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index e12bd7d6d2dce..922aac39b021b 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -15,6 +15,107 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_nested.h>
 
+static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
+{
+	/* These registers are common with EL1 */
+	__vcpu_sys_reg(vcpu, PAR_EL1)	= read_sysreg(par_el1);
+	__vcpu_sys_reg(vcpu, TPIDR_EL1)	= read_sysreg(tpidr_el1);
+
+	__vcpu_sys_reg(vcpu, ESR_EL2)	= read_sysreg_el1(SYS_ESR);
+	__vcpu_sys_reg(vcpu, AFSR0_EL2)	= read_sysreg_el1(SYS_AFSR0);
+	__vcpu_sys_reg(vcpu, AFSR1_EL2)	= read_sysreg_el1(SYS_AFSR1);
+	__vcpu_sys_reg(vcpu, FAR_EL2)	= read_sysreg_el1(SYS_FAR);
+	__vcpu_sys_reg(vcpu, MAIR_EL2)	= read_sysreg_el1(SYS_MAIR);
+	__vcpu_sys_reg(vcpu, VBAR_EL2)	= read_sysreg_el1(SYS_VBAR);
+	__vcpu_sys_reg(vcpu, CONTEXTIDR_EL2) = read_sysreg_el1(SYS_CONTEXTIDR);
+	__vcpu_sys_reg(vcpu, AMAIR_EL2)	= read_sysreg_el1(SYS_AMAIR);
+
+	/*
+	 * In VHE mode those registers are compatible between EL1 and EL2,
+	 * and the guest uses the _EL1 versions on the CPU naturally.
+	 * So we save them into their _EL2 versions here.
+	 * For nVHE mode we trap accesses to those registers, so our
+	 * _EL2 copy in sys_regs[] is always up-to-date and we don't need
+	 * to save anything here.
+	 */
+	if (vcpu_el2_e2h_is_set(vcpu)) {
+		u64 val;
+
+		/*
+		 * We don't save CPTR_EL2, as accesses to CPACR_EL1
+		 * are always trapped, ensuring that the in-memory
+		 * copy is always up-to-date. A small blessing...
+		 */
+		__vcpu_sys_reg(vcpu, SCTLR_EL2)	= read_sysreg_el1(SYS_SCTLR);
+		__vcpu_sys_reg(vcpu, TTBR0_EL2)	= read_sysreg_el1(SYS_TTBR0);
+		__vcpu_sys_reg(vcpu, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
+		__vcpu_sys_reg(vcpu, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
+
+		/*
+		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
+		 * the interesting CNTHCTL_EL2 bits live. So preserve these
+		 * bits when reading back the guest-visible value.
+		 */
+		val = read_sysreg_el1(SYS_CNTKCTL);
+		val &= CNTKCTL_VALID_BITS;
+		__vcpu_sys_reg(vcpu, CNTHCTL_EL2) &= ~CNTKCTL_VALID_BITS;
+		__vcpu_sys_reg(vcpu, CNTHCTL_EL2) |= val;
+	}
+
+	__vcpu_sys_reg(vcpu, SP_EL2)	= read_sysreg(sp_el1);
+	__vcpu_sys_reg(vcpu, ELR_EL2)	= read_sysreg_el1(SYS_ELR);
+	__vcpu_sys_reg(vcpu, SPSR_EL2)	= read_sysreg_el1(SYS_SPSR);
+}
+
+static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	/* These registers are common with EL1 */
+	write_sysreg(__vcpu_sys_reg(vcpu, PAR_EL1),	par_el1);
+	write_sysreg(__vcpu_sys_reg(vcpu, TPIDR_EL1),	tpidr_el1);
+
+	write_sysreg(__vcpu_sys_reg(vcpu, MPIDR_EL1),		vmpidr_el2);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, MAIR_EL2),	SYS_MAIR);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, VBAR_EL2),	SYS_VBAR);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, CONTEXTIDR_EL2),	SYS_CONTEXTIDR);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, AMAIR_EL2),	SYS_AMAIR);
+
+	if (vcpu_el2_e2h_is_set(vcpu)) {
+		/*
+		 * In VHE mode those registers are compatible between
+		 * EL1 and EL2.
+		 */
+		write_sysreg_el1(__vcpu_sys_reg(vcpu, SCTLR_EL2),   SYS_SCTLR);
+		write_sysreg_el1(__vcpu_sys_reg(vcpu, CPTR_EL2),    SYS_CPACR);
+		write_sysreg_el1(__vcpu_sys_reg(vcpu, TTBR0_EL2),   SYS_TTBR0);
+		write_sysreg_el1(__vcpu_sys_reg(vcpu, TTBR1_EL2),   SYS_TTBR1);
+		write_sysreg_el1(__vcpu_sys_reg(vcpu, TCR_EL2),	    SYS_TCR);
+		write_sysreg_el1(__vcpu_sys_reg(vcpu, CNTHCTL_EL2), SYS_CNTKCTL);
+	} else {
+		/*
+		 * CNTHCTL_EL2 only affects EL1 when running nVHE, so
+		 * no need to restore it.
+		 */
+		val = translate_sctlr_el2_to_sctlr_el1(__vcpu_sys_reg(vcpu, SCTLR_EL2));
+		write_sysreg_el1(val, SYS_SCTLR);
+		val = translate_cptr_el2_to_cpacr_el1(__vcpu_sys_reg(vcpu, CPTR_EL2));
+		write_sysreg_el1(val, SYS_CPACR);
+		val = translate_ttbr0_el2_to_ttbr0_el1(__vcpu_sys_reg(vcpu, TTBR0_EL2));
+		write_sysreg_el1(val, SYS_TTBR0);
+		val = translate_tcr_el2_to_tcr_el1(__vcpu_sys_reg(vcpu, TCR_EL2));
+		write_sysreg_el1(val, SYS_TCR);
+	}
+
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, ESR_EL2),		SYS_ESR);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, AFSR0_EL2),	SYS_AFSR0);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, AFSR1_EL2),	SYS_AFSR1);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, FAR_EL2),		SYS_FAR);
+	write_sysreg(__vcpu_sys_reg(vcpu, SP_EL2),		sp_el1);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, ELR_EL2),		SYS_ELR);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, SPSR_EL2),	SYS_SPSR);
+}
+
 /*
  * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and
  * pstate, which are handled as part of the el2 return state) on every
@@ -66,6 +167,7 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
+	u64 mpidr;
 
 	host_ctxt = host_data_ptr(host_ctxt);
 	__sysreg_save_user_state(host_ctxt);
@@ -89,7 +191,29 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 	 */
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_user_state(guest_ctxt);
-	__sysreg_restore_el1_state(guest_ctxt);
+
+	if (unlikely(__is_hyp_ctxt(guest_ctxt))) {
+		__sysreg_restore_vel2_state(vcpu);
+	} else {
+		if (vcpu_has_nv(vcpu)) {
+			/*
+			 * Use the guest hypervisor's VPIDR_EL2 when in a
+			 * nested state. The hardware value of MIDR_EL1 gets
+			 * restored on put.
+			 */
+			write_sysreg(ctxt_sys_reg(guest_ctxt, VPIDR_EL2), vpidr_el2);
+
+			/*
+			 * As we're restoring a nested guest, set the value
+			 * provided by the guest hypervisor.
+			 */
+			mpidr = ctxt_sys_reg(guest_ctxt, VMPIDR_EL2);
+		} else {
+			mpidr = ctxt_sys_reg(guest_ctxt, MPIDR_EL1);
+		}
+
+		__sysreg_restore_el1_state(guest_ctxt, mpidr);
+	}
 
 	vcpu_set_flag(vcpu, SYSREGS_ON_CPU);
 }
@@ -112,12 +236,20 @@ void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
 
 	host_ctxt = host_data_ptr(host_ctxt);
 
-	__sysreg_save_el1_state(guest_ctxt);
+	if (unlikely(__is_hyp_ctxt(guest_ctxt)))
+		__sysreg_save_vel2_state(vcpu);
+	else
+		__sysreg_save_el1_state(guest_ctxt);
+
 	__sysreg_save_user_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 
 	/* Restore host user state */
 	__sysreg_restore_user_state(host_ctxt);
 
+	/* If leaving a nesting guest, restore MIDR_EL1 default view */
+	if (vcpu_has_nv(vcpu))
+		write_sysreg(read_cpuid_id(),	vpidr_el2);
+
 	vcpu_clear_flag(vcpu, SYSREGS_ON_CPU);
 }
-- 
2.39.2



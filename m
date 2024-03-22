Return-Path: <kvm+bounces-12514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F5A98871BB
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:11:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 530D21C21B43
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 879B45D752;
	Fri, 22 Mar 2024 17:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEMLzY5p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98741604B4;
	Fri, 22 Mar 2024 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127411; cv=none; b=k+dHQoIZ+IUKa+6UvQ2YLKh7+Qs+NXQyloKCMc4Yt4Ex0Tty7fM9XZ5Fp/rbfC1jB/Wc7K0vToAPLuCazU1+uFFI8Lofzds+YygZ3H+3LfsDhm8NkUlMH0WnIMOlZATMC/crkDzrWW9hIBuwl22r5tVdlESBsCRPSjougLESMBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127411; c=relaxed/simple;
	bh=vNl8TpxqEEXGTIuRtykJcORfkjV0eBnFzrmko49Lv7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BYwCz+l/V/UBh4dG/kDy0cyhFNyKTtmFc19B3QXnNe9eofROx3HhMXXQcPJY/DqCRHUCFxu1J9ZXswDULyWEL4LdUYbV1VESrLawlrJY7+cugML9jY/qm2WlNd22gexfqmb9aiLY2zBg9n3q/vTxYXyjfBq0JVuBiitGVGmP1zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEMLzY5p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CC9C43394;
	Fri, 22 Mar 2024 17:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711127411;
	bh=vNl8TpxqEEXGTIuRtykJcORfkjV0eBnFzrmko49Lv7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEMLzY5pq9/GAu1dIKRhD7QfGVPLZEI27rl5Uvt6d8+ij0mnjiU71tu4+7DnzlaqA
	 hbjrn33wl/l5WAq60w5HaRXdYWDwbc6xtVZUUo+dinHsGwtabvMmXlJzkPYtXDcdY3
	 MCdalz8o7hbrZh6GrwjHEzvTI8RogdWpm3UsQK5DK3oRzjlN7l+XsUwTgCoiSK8Dfo
	 VhKJMkOmjNmJV2ZO1in8M5FJuXPvIz9gJOZMcjI0UzyrpgYJRZKa0V2y+GTZj+kqby
	 isTR0F5UgM5LMsvJr7+Xoo+HG+4XuSdR9Z/5752TFDX97kWwq4b52OmyjfeTVZtv+A
	 5XeyHY4IdWSKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rniPA-00EZPz-0B;
	Fri, 22 Mar 2024 17:10:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH v2 5/5] KVM: arm64: Exclude FP ownership from kvm_vcpu_arch
Date: Fri, 22 Mar 2024 17:09:45 +0000
Message-Id: <20240322170945.3292593-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240322170945.3292593-1-maz@kernel.org>
References: <20240322170945.3292593-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.clark@arm.com, anshuman.khandual@arm.com, broonie@kernel.org, dongli.zhang@oracle.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In retrospect, it is fairly obvious that the FP state ownership
is only meaningful for a given CPU, and that locating this
information in the vcpu was just a mistake.

Move the ownership tracking into the host data structure, and
rename it from fp_state to fp_owner, which is a better description
(name suggested by Mark Brown).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h    |  4 ++--
 arch/arm64/include/asm/kvm_host.h       | 14 +++++++-------
 arch/arm64/kvm/arm.c                    |  6 ------
 arch/arm64/kvm/fpsimd.c                 | 10 +++++-----
 arch/arm64/kvm/hyp/include/hyp/switch.h |  6 +++---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  2 --
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 8 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index debc3753d2ef..b17f2269fb81 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -594,7 +594,7 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN);
 
 		if (!vcpu_has_sve(vcpu) ||
-		    (vcpu->arch.fp_state != FP_STATE_GUEST_OWNED))
+		    (*host_data_ptr(fp_owner) != FP_STATE_GUEST_OWNED))
 			val |= CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN;
 		if (cpus_have_final_cap(ARM64_SME))
 			val |= CPACR_EL1_SMEN_EL1EN | CPACR_EL1_SMEN_EL0EN;
@@ -602,7 +602,7 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 		val = CPTR_NVHE_EL2_RES1;
 
 		if (vcpu_has_sve(vcpu) &&
-		    (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED))
+		    (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED))
 			val |= CPTR_EL2_TZ;
 		if (cpus_have_final_cap(ARM64_SME))
 			val &= ~CPTR_EL2_TSM;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 838cdee2ecf7..951303e976de 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -545,6 +545,13 @@ struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
 	struct user_fpsimd_state *fpsimd_state;	/* hyp VA */
 
+	/* Ownership of the FP regs */
+	enum {
+		FP_STATE_FREE,
+		FP_STATE_HOST_OWNED,
+		FP_STATE_GUEST_OWNED,
+	} fp_owner;
+
 	/*
 	 * host_debug_state contains the host registers which are
 	 * saved and restored during world switches.
@@ -621,13 +628,6 @@ struct kvm_vcpu_arch {
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
-	/* Ownership of the FP regs */
-	enum {
-		FP_STATE_FREE,
-		FP_STATE_HOST_OWNED,
-		FP_STATE_GUEST_OWNED,
-	} fp_state;
-
 	/* Configuration flags, set once and for all before the vcpu can run */
 	u8 cflags;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a24287c3ba99..66d8112da268 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -378,12 +378,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
-	/*
-	 * Default value for the FP state, will be overloaded at load
-	 * time if we support FP (pretty likely)
-	 */
-	vcpu->arch.fp_state = FP_STATE_FREE;
-
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
 
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index e6bd99358615..98f8b9272e24 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -84,7 +84,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	 * guest in kvm_arch_vcpu_ctxflush_fp() and override this to
 	 * FP_STATE_FREE if the flag set.
 	 */
-	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
+	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 	*host_data_ptr(fpsimd_state) = kern_hyp_va(&current->thread.uw.fpsimd_state);
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
@@ -109,7 +109,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 		 * been saved, this is very unlikely to happen.
 		 */
 		if (read_sysreg_s(SYS_SVCR) & (SVCR_SM_MASK | SVCR_ZA_MASK)) {
-			vcpu->arch.fp_state = FP_STATE_FREE;
+			*host_data_ptr(fp_owner) = FP_STATE_FREE;
 			fpsimd_save_and_flush_cpu_state();
 		}
 	}
@@ -125,7 +125,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
 {
 	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
-		vcpu->arch.fp_state = FP_STATE_FREE;
+		*host_data_ptr(fp_owner) = FP_STATE_FREE;
 }
 
 /*
@@ -141,7 +141,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED) {
+	if (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED) {
 
 		/*
 		 * Currently we do not support SME guests so SVCR is
@@ -194,7 +194,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		isb();
 	}
 
-	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED) {
+	if (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED) {
 		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6def6ad8dd48..2629420d0659 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -42,7 +42,7 @@ extern struct kvm_exception_table_entry __stop___kvm_ex_table;
 /* Check whether the FP regs are owned by the guest */
 static inline bool guest_owns_fp_regs(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.fp_state == FP_STATE_GUEST_OWNED;
+	return *host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED;
 }
 
 /* Save the 32-bit only FPSIMD system register state */
@@ -376,7 +376,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	isb();
 
 	/* Write out the host state if it's in the registers */
-	if (vcpu->arch.fp_state == FP_STATE_HOST_OWNED)
+	if (*host_data_ptr(fp_owner) == FP_STATE_HOST_OWNED)
 		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
 
 	/* Restore the guest state */
@@ -389,7 +389,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
 		write_sysreg(__vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
 
-	vcpu->arch.fp_state = FP_STATE_GUEST_OWNED;
+	*host_data_ptr(fp_owner) = FP_STATE_GUEST_OWNED;
 
 	return true;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index c5f625dc1f07..26561c562f7a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -39,7 +39,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_vcpu->vcpu.arch.cptr_el2	= host_vcpu->arch.cptr_el2;
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
-	hyp_vcpu->vcpu.arch.fp_state	= host_vcpu->arch.fp_state;
 
 	hyp_vcpu->vcpu.arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
 
@@ -63,7 +62,6 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
 
 	host_vcpu->arch.iflags		= hyp_vcpu->vcpu.arch.iflags;
-	host_vcpu->arch.fp_state	= hyp_vcpu->vcpu.arch.fp_state;
 
 	host_cpu_if->vgic_hcr		= hyp_cpu_if->vgic_hcr;
 	for (i = 0; i < hyp_cpu_if->used_lrs; ++i)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 544a419b9a39..1f82d531a494 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -337,7 +337,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED)
+	if (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED)
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 14b7a6bc5909..b92f9fe2d50e 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -258,7 +258,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED)
+	if (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED)
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
-- 
2.39.2



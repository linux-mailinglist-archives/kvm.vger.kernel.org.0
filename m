Return-Path: <kvm+bounces-12509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F84A8871B6
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 925D11C20B23
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C5E6025F;
	Fri, 22 Mar 2024 17:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0/51jr8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F575FBAD;
	Fri, 22 Mar 2024 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127409; cv=none; b=LaPdgpGXfoCnJuAifZG00UB4+LwFe1JbCaMVWjNbfe3JhdpI7xxIyeMCMCNRs+P5MW1n02ubkhI9bd3r7EaZyuNa3OEypnEkJ33yW8CwmtHMOiWd+IBUwv2exFex6+fFZKAw49SXt1KZq3kFxVQ2Bm8lctielja72fvmFm5GWXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127409; c=relaxed/simple;
	bh=UmGeprALYDxmpHfoUvKrsAu49FnOJc68wdOBJBGqwT4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ww/nmo4qDvSfp9+a8Zpy9pmmT6eUCQiXHw2q1SMARRfPK4GLXTGbRS15ZLA/S+ONNa4SgL3BVphsHWouCY5erJc7mMCOpJnJFEln0XpPjYQwTehIHoQgRJAR4k8jzFIeGQhFFRldo0yOXmJGMVx7FRkj9pH+sKU0Zmer69SaC8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0/51jr8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1484BC43390;
	Fri, 22 Mar 2024 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711127409;
	bh=UmGeprALYDxmpHfoUvKrsAu49FnOJc68wdOBJBGqwT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0/51jr8a1OAO9bl+deDcdb36pXaDt5BdPktEcDTFXo54hN2X+UmCc1HX3EqoChI+
	 CzjhplKDOdmYZOgsqIAI/K1uYWWgLsFAYxVnq9RPZhiI/K69c0Jm8h1OcVFZzfiY83
	 fX9M31IewjGJ/5ePuRYapAZ1Itvtly5QKG73CkHqbM6jP6l86VEDjZs8mWuModusnE
	 y8LA2mpwX+Hj2NTjBMeOWWY5wFbN0aTF0Uduw1Oe3CVfS0/PYMvK9rfRYn/7o9T4gM
	 l8a++QQ2nFjA1HObJsqxg3Bk/TIKIL8cPcvO82GW4o7nSw2bkzvWQTyu46Z3520PWN
	 e5aw5knuzpkcg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rniP9-00EZPz-3g;
	Fri, 22 Mar 2024 17:10:07 +0000
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
Subject: [PATCH v2 1/5] KVM: arm64: Add accessor for per-CPU state
Date: Fri, 22 Mar 2024 17:09:41 +0000
Message-Id: <20240322170945.3292593-2-maz@kernel.org>
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

In order to facilitate the introduction of new per-CPU state,
add a new host_data_ptr() helped that hides some of the per-CPU
verbosity, and make it easier to move that state around in the
future.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h         | 37 +++++++++++++++++++++++
 arch/arm64/kvm/arm.c                      |  2 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  4 +--
 arch/arm64/kvm/hyp/include/hyp/switch.h   |  8 ++---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c      |  2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c           |  3 +-
 arch/arm64/kvm/hyp/nvhe/switch.c          |  4 +--
 arch/arm64/kvm/hyp/vhe/switch.c           |  4 +--
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |  4 +--
 arch/arm64/kvm/pmu.c                      |  2 +-
 10 files changed, 53 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6883963bbc3a..ca6ef663950d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -530,6 +530,17 @@ struct kvm_cpu_context {
 	u64 *vncr_array;
 };
 
+/*
+ * This structure is instantiated on a per-CPU basis, and contains
+ * data that is:
+ *
+ * - tied to a single physical CPU, and
+ * - either have a lifetime that does not extend past vcpu_put()
+ * - or is an invariant for the lifetime of the system
+ *
+ * Use host_data_ptr(field) as a way to access a pointer to such a
+ * field.
+ */
 struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
 };
@@ -1167,6 +1178,32 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
 DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
 
+/*
+ * How we access per-CPU host data depends on the where we access it from,
+ * and the mode we're in:
+ *
+ * - VHE and nVHE hypervisor bits use their locally defined instance
+ *
+ * - the rest of the kernel use either the VHE or nVHE one, depending on
+ *   the mode we're running in.
+ *
+ *   Unless we're in protected mode, fully deprivileged, and the nVHE
+ *   per-CPU stuff is exclusively accessible to the protected EL2 code.
+ *   In this case, the EL1 code uses the *VHE* data as its private state
+ *   (which makes sense in a way as there shouldn't be any shared state
+ *   between the host and the hypervisor).
+ *
+ * Yes, this is all totally trivial. Shoot me now.
+ */
+#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
+#define host_data_ptr(f)	(&this_cpu_ptr(&kvm_host_data)->f)
+#else
+#define host_data_ptr(f)						\
+	(static_branch_unlikely(&kvm_protected_mode_initialized) ?	\
+	 &this_cpu_ptr(&kvm_host_data)->f :				\
+	 &this_cpu_ptr_hyp_sym(kvm_host_data)->f)
+#endif
+
 static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 {
 	/* The host's MPIDR is immutable, so let's set it up at boot time */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3dee5490eea9..a24287c3ba99 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1971,7 +1971,7 @@ static void cpu_set_hyp_vector(void)
 
 static void cpu_hyp_init_context(void)
 {
-	kvm_init_host_cpu_context(&this_cpu_ptr_hyp_sym(kvm_host_data)->host_ctxt);
+	kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
 
 	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 961bbef104a6..eec0f8ccda56 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -135,7 +135,7 @@ static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
 	if (!vcpu_get_flag(vcpu, DEBUG_DIRTY))
 		return;
 
-	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	host_ctxt = host_data_ptr(host_ctxt);
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
@@ -154,7 +154,7 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 	if (!vcpu_get_flag(vcpu, DEBUG_DIRTY))
 		return;
 
-	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	host_ctxt = host_data_ptr(host_ctxt);
 	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e3fcf8c4d5b4..ae198b84ca01 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -155,7 +155,7 @@ static inline bool cpu_has_amu(void)
 
 static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 
 	CHECK_FGT_MASKS(HFGRTR_EL2);
@@ -191,7 +191,7 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 
 static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -226,7 +226,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 
 		write_sysreg(0, pmselr_el0);
 
-		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+		hctxt = host_data_ptr(host_ctxt);
 		ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 		vcpu_set_flag(vcpu, PMUSERENR_ON_CPU);
@@ -260,7 +260,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	if (kvm_arm_support_pmu_v3()) {
 		struct kvm_cpu_context *hctxt;
 
-		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+		hctxt = host_data_ptr(host_ctxt);
 		write_sysreg(ctxt_sys_reg(hctxt, PMUSERENR_EL0), pmuserenr_el0);
 		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index d57bcb6ab94d..dfe8fe0f7eaf 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -205,7 +205,7 @@ asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
 	struct psci_boot_args *boot_args;
 	struct kvm_cpu_context *host_ctxt;
 
-	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	host_ctxt = host_data_ptr(host_ctxt);
 
 	if (is_cpu_on)
 		boot_args = this_cpu_ptr(&cpu_on_args);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index bc58d1b515af..ae00dfa80801 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -257,8 +257,7 @@ static int fix_hyp_pgtable_refcnt(void)
 
 void __noreturn __pkvm_init_finalise(void)
 {
-	struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
-	struct kvm_cpu_context *host_ctxt = &host_data->host_ctxt;
+	struct kvm_cpu_context *host_ctxt = host_data_ptr(host_ctxt);
 	unsigned long nr_pages, reserved_pages, pfn;
 	int ret;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c50f8459e4fc..544a419b9a39 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -264,7 +264,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		pmr_sync();
 	}
 
-	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	host_ctxt = host_data_ptr(host_ctxt);
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
@@ -367,7 +367,7 @@ asmlinkage void __noreturn hyp_panic(void)
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 
-	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	host_ctxt = host_data_ptr(host_ctxt);
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
 	if (vcpu) {
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1581df6aec87..14b7a6bc5909 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -221,7 +221,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
 
-	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	host_ctxt = host_data_ptr(host_ctxt);
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
@@ -306,7 +306,7 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 
-	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	host_ctxt = host_data_ptr(host_ctxt);
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
 	__deactivate_traps(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index a8b9ea496706..e12bd7d6d2dc 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -67,7 +67,7 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
-	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	host_ctxt = host_data_ptr(host_ctxt);
 	__sysreg_save_user_state(host_ctxt);
 
 	/*
@@ -110,7 +110,7 @@ void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
-	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	host_ctxt = host_data_ptr(host_ctxt);
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index a243934c5568..329819806096 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -232,7 +232,7 @@ bool kvm_set_pmuserenr(u64 val)
 	if (!vcpu || !vcpu_get_flag(vcpu, PMUSERENR_ON_CPU))
 		return false;
 
-	hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	hctxt = host_data_ptr(host_ctxt);
 	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
 	return true;
 }
-- 
2.39.2



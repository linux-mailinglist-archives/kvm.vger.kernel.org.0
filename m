Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDD652D495
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239178AbiESNpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiESNpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFE85AECE
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77E98617A6
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD13C34100;
        Thu, 19 May 2022 13:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967911;
        bh=So7rm6Tk+3JDsp2nyZRUfORf5bgPaTvoKJpTBE65TBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7oo7Dt9WSdR4M4KCK8NwiGvSwIctkA7BYQHR5Hm2iAW1kBJVYZazmFQsLtNa5+r4
         GX51iCYucDoOKNJM5z8jZEpT21YUO/NXfCLPrFaiT87dE6ddC7edaYk8JupWQChh1J
         IXMThUyd++V0AoyOcun4BTIFFrOppzZr/+do3SHGDcn6rZikKWhVH5EqsY1pnSEIij
         a4ADm0nfmhNaeUshaqInPdeFcYUTuegdvIcnC7xBNJL1fOtqGTwH/ux8B6PFpwx7Df
         EiCZ4znq2tHikyMuA7h7u5SFUknAIzzjyUbUQV20frj/fhx0wMfWpVKUSS/Gh86ewH
         GRiPpQ6baksRw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 42/89] KVM: arm64: Simplify vgic-v3 hypercalls
Date:   Thu, 19 May 2022 14:41:17 +0100
Message-Id: <20220519134204.5379-43-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

Consolidate the GICv3 VMCR accessor hypercalls into the APR save/restore
hypercalls so that all of the EL2 GICv3 state is covered by a single pair
of hypercalls.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h   |  8 ++------
 arch/arm64/include/asm/kvm_hyp.h   |  4 ++--
 arch/arm64/kvm/arm.c               |  7 +++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 24 ++++++------------------
 arch/arm64/kvm/hyp/vgic-v3-sr.c    | 27 +++++++++++++++++++++++----
 arch/arm64/kvm/vgic/vgic-v2.c      |  9 +--------
 arch/arm64/kvm/vgic/vgic-v3.c      | 26 ++++----------------------
 arch/arm64/kvm/vgic/vgic.c         | 17 +++--------------
 arch/arm64/kvm/vgic/vgic.h         |  6 ++----
 include/kvm/arm_vgic.h             |  3 +--
 10 files changed, 47 insertions(+), 84 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 35b9d590bb74..22b5ee9f2b5c 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -73,11 +73,9 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_shadow,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_shadow,
 };
@@ -218,8 +216,6 @@ extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
 
 extern u64 __vgic_v3_get_gic_config(void);
-extern u64 __vgic_v3_read_vmcr(void);
-extern void __vgic_v3_write_vmcr(u32 vmcr);
 extern void __vgic_v3_init_lrs(void);
 
 extern u64 __kvm_get_mdcr_el2(void);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 6797eafe7890..4adf7c2a77bd 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -61,8 +61,8 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if);
-void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
-void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_save_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 07d2ac6a5aff..c9b8e2ca5cb5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -440,7 +440,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	if (has_vhe())
 		kvm_vcpu_put_sysregs_vhe(vcpu);
 	kvm_timer_vcpu_put(vcpu);
-	kvm_vgic_put(vcpu);
+	kvm_vgic_put(vcpu, false);
 	kvm_vcpu_pmu_restore_host(vcpu);
 	kvm_arm_vmid_clear_active();
 
@@ -656,15 +656,14 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	 * doorbells to be signalled, should an interrupt become pending.
 	 */
 	preempt_disable();
-	kvm_vgic_vmcr_sync(vcpu);
-	vgic_v4_put(vcpu, true);
+	kvm_vgic_put(vcpu, true);
 	preempt_enable();
 
 	kvm_vcpu_halt(vcpu);
 	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 
 	preempt_disable();
-	vgic_v4_load(vcpu);
+	kvm_vgic_load(vcpu);
 	preempt_enable();
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 245d267064b3..5b46742d9f9b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -205,16 +205,6 @@ static void handle___vgic_v3_get_gic_config(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __vgic_v3_get_gic_config();
 }
 
-static void handle___vgic_v3_read_vmcr(struct kvm_cpu_context *host_ctxt)
-{
-	cpu_reg(host_ctxt, 1) = __vgic_v3_read_vmcr();
-}
-
-static void handle___vgic_v3_write_vmcr(struct kvm_cpu_context *host_ctxt)
-{
-	__vgic_v3_write_vmcr(cpu_reg(host_ctxt, 1));
-}
-
 static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
 {
 	__vgic_v3_init_lrs();
@@ -225,18 +215,18 @@ static void handle___kvm_get_mdcr_el2(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __kvm_get_mdcr_el2();
 }
 
-static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
+static void handle___vgic_v3_save_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
 
-	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
+	__vgic_v3_save_vmcr_aprs(kern_hyp_va(cpu_if));
 }
 
-static void handle___vgic_v3_restore_aprs(struct kvm_cpu_context *host_ctxt)
+static void handle___vgic_v3_restore_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
 
-	__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
+	__vgic_v3_restore_vmcr_aprs(kern_hyp_va(cpu_if));
 }
 
 static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
@@ -349,11 +339,9 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
-	HANDLE_FUNC(__vgic_v3_read_vmcr),
-	HANDLE_FUNC(__vgic_v3_write_vmcr),
-	HANDLE_FUNC(__vgic_v3_save_aprs),
-	HANDLE_FUNC(__vgic_v3_restore_aprs),
 	HANDLE_FUNC(__pkvm_vcpu_init_traps),
+	HANDLE_FUNC(__vgic_v3_save_vmcr_aprs),
+	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__pkvm_init_shadow),
 	HANDLE_FUNC(__pkvm_teardown_shadow),
 };
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 4fb419f7b8b6..d5a51ea5459c 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -330,7 +330,7 @@ void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
 		write_gicreg(0, ICH_HCR_EL2);
 }
 
-void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
+static void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
 	u64 val;
 	u32 nr_pre_bits;
@@ -363,7 +363,7 @@ void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
 	}
 }
 
-void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if)
+static void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
 	u64 val;
 	u32 nr_pre_bits;
@@ -455,16 +455,35 @@ u64 __vgic_v3_get_gic_config(void)
 	return val;
 }
 
-u64 __vgic_v3_read_vmcr(void)
+static u64 __vgic_v3_read_vmcr(void)
 {
 	return read_gicreg(ICH_VMCR_EL2);
 }
 
-void __vgic_v3_write_vmcr(u32 vmcr)
+static void __vgic_v3_write_vmcr(u32 vmcr)
 {
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
 
+void __vgic_v3_save_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if)
+{
+	__vgic_v3_save_aprs(cpu_if);
+	if (cpu_if->vgic_sre)
+		cpu_if->vgic_vmcr = __vgic_v3_read_vmcr();
+}
+
+void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if)
+{
+	/*
+	 * If dealing with a GICv2 emulation on GICv3, VMCR_EL2.VFIQen
+	 * is dependent on ICC_SRE_EL1.SRE, and we have to perform the
+	 * VMCR_EL2 save/restore in the world switch.
+	 */
+	if (cpu_if->vgic_sre)
+		__vgic_v3_write_vmcr(cpu_if->vgic_vmcr);
+	__vgic_v3_restore_aprs(cpu_if);
+}
+
 static int __vgic_v3_bpr_min(void)
 {
 	/* See Pseudocode for VPriorityGroup */
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 645648349c99..4e8bb90bd96f 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -470,17 +470,10 @@ void vgic_v2_load(struct kvm_vcpu *vcpu)
 		       kvm_vgic_global_state.vctrl_base + GICH_APR);
 }
 
-void vgic_v2_vmcr_sync(struct kvm_vcpu *vcpu)
+void vgic_v2_put(struct kvm_vcpu *vcpu, bool blocking)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 
 	cpu_if->vgic_vmcr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VMCR);
-}
-
-void vgic_v2_put(struct kvm_vcpu *vcpu)
-{
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-
-	vgic_v2_vmcr_sync(vcpu);
 	cpu_if->vgic_apr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_APR);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b549af8b1dc2..18b7fda8d59c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -720,15 +720,7 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	/*
-	 * If dealing with a GICv2 emulation on GICv3, VMCR_EL2.VFIQen
-	 * is dependent on ICC_SRE_EL1.SRE, and we have to perform the
-	 * VMCR_EL2 save/restore in the world switch.
-	 */
-	if (likely(cpu_if->vgic_sre))
-		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
-
-	kvm_call_hyp(__vgic_v3_restore_aprs, cpu_if);
+	kvm_call_hyp(__vgic_v3_restore_vmcr_aprs, cpu_if);
 
 	if (has_vhe())
 		__vgic_v3_activate_traps(cpu_if);
@@ -736,23 +728,13 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 	WARN_ON(vgic_v4_load(vcpu));
 }
 
-void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
+void vgic_v3_put(struct kvm_vcpu *vcpu, bool blocking)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	if (likely(cpu_if->vgic_sre))
-		cpu_if->vgic_vmcr = kvm_call_hyp_ret(__vgic_v3_read_vmcr);
-}
-
-void vgic_v3_put(struct kvm_vcpu *vcpu)
-{
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-
-	WARN_ON(vgic_v4_put(vcpu, false));
-
-	vgic_v3_vmcr_sync(vcpu);
+	WARN_ON(vgic_v4_put(vcpu, blocking));
 
-	kvm_call_hyp(__vgic_v3_save_aprs, cpu_if);
+	kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
 
 	if (has_vhe())
 		__vgic_v3_deactivate_traps(cpu_if);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d97e6080b421..6189ad969675 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -931,26 +931,15 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 		vgic_v3_load(vcpu);
 }
 
-void kvm_vgic_put(struct kvm_vcpu *vcpu)
+void kvm_vgic_put(struct kvm_vcpu *vcpu, bool blocking)
 {
 	if (unlikely(!vgic_initialized(vcpu->kvm)))
 		return;
 
 	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_put(vcpu);
+		vgic_v2_put(vcpu, blocking);
 	else
-		vgic_v3_put(vcpu);
-}
-
-void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu)
-{
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
-		return;
-
-	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_vmcr_sync(vcpu);
-	else
-		vgic_v3_vmcr_sync(vcpu);
+		vgic_v3_put(vcpu, blocking);
 }
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 3fd6c86a7ef3..947985b3b03e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -196,8 +196,7 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 
 void vgic_v2_init_lrs(void);
 void vgic_v2_load(struct kvm_vcpu *vcpu);
-void vgic_v2_put(struct kvm_vcpu *vcpu);
-void vgic_v2_vmcr_sync(struct kvm_vcpu *vcpu);
+void vgic_v2_put(struct kvm_vcpu *vcpu, bool blocking);
 
 void vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void vgic_v2_restore_state(struct kvm_vcpu *vcpu);
@@ -227,8 +226,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
 bool vgic_v3_check_base(struct kvm *kvm);
 
 void vgic_v3_load(struct kvm_vcpu *vcpu);
-void vgic_v3_put(struct kvm_vcpu *vcpu);
-void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu);
+void vgic_v3_put(struct kvm_vcpu *vcpu, bool blocking);
 
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index bb30a6803d9f..65e09c3924be 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -380,8 +380,7 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu);
-void kvm_vgic_put(struct kvm_vcpu *vcpu);
-void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu);
+void kvm_vgic_put(struct kvm_vcpu *vcpu, bool blocking);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-- 
2.36.1.124.g0e6072fb45-goog


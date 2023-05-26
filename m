Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182BB7128E7
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 16:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243864AbjEZOsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 10:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243829AbjEZOsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 10:48:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E740B10D0
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 07:47:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 468DF6509D
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FF4C433D2;
        Fri, 26 May 2023 14:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685112416;
        bh=hSQy5gLZCuoxx57GR79Suj/ypECkMBpuktFZ/OH29A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSV9HG2WMLidZhOqVkX14dvISCMGINHGi/ePjCT+tLL/OGuAOV+58zi3qReiz+uYJ
         fvO5sqUvQRz9X3iMrGu7+who8YVx7aQTZv7m4i86u3El2Iqsw0R31TfY7lZ7ADe4sM
         jhCP9PNwQUBuo3pChROyaDi4FaznZx/zE4BG/iudJHyov2V4l4OPwAPzmdK/puUYfy
         zoWkpbSC/P+3Bow0oxwWsyIn8+uz+O2uTnQYeXvzspHULPHb5QeuebkjZ2SKjya5By
         xU2fyV6LRiHdPQfaRTtZTmb8q7SX9FpzMF4CmDtdY5SYImGwT/cIJF9xgwgsynX38J
         xC2iVAtR+KTjQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q2YVv-000aHS-M2;
        Fri, 26 May 2023 15:33:55 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 17/17] KVM: arm64: Terrible timer hack for M1 with hVHE
Date:   Fri, 26 May 2023 15:33:48 +0100
Message-Id: <20230526143348.4072074-18-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526143348.4072074-1-maz@kernel.org>
References: <20230526143348.4072074-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As our M1 friend doesn't have a GIC, it relies on a special hack
to deal with masking the guest timers, in the form of an IMPDEF
system register.

Unfortunately, this sysreg is EL2-only, which means that the kernel
cannot mask the interrupts itself, but has to kindly ask EL2 to do
it. Yes, this is terrible, but we should be used to it by now.

Add a M1-specific hypercall to deal with this. No, I'm not seriously
suggesting we merge this crap.

Not-seriously-suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/arch_timer.h |  8 +++++
 arch/arm64/include/asm/kvm_asm.h    |  1 +
 arch/arm64/kernel/image-vars.h      |  3 ++
 arch/arm64/kvm/arch_timer.c         |  5 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c  | 11 +++++++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c  |  9 ++++++
 drivers/irqchip/irq-apple-aic.c     | 50 +++++++++++++++++++++++++++--
 7 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index af1fafbe7e1d..3817e923f52c 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -232,4 +232,12 @@ static inline bool arch_timer_have_evtstrm_feature(void)
 {
 	return cpu_have_named_feature(EVTSTRM);
 }
+
+#ifdef CONFIG_APPLE_AIC
+#define SYS_IMP_APL_VM_TMR_FIQ_ENA_EL2	sys_reg(3, 5, 15, 1, 3)
+DECLARE_STATIC_KEY_FALSE(aic_impdef_timer_control);
+#endif
+
+void __aic_timer_fiq_clear_set(u64 clear, u64 set);
+
 #endif
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 43c3bc0f9544..a9e1444fe1d4 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -75,6 +75,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs,
+	__KVM_HOST_SMCCC_FUNC___aic_timer_fiq_clear_set,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 35f3c7959513..3f40f7188acc 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -106,6 +106,9 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
 /* pKVM static key */
 KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
 
+/* Hack for M1 timer control in hVHE mode */
+KVM_NVHE_ALIAS(aic_impdef_timer_control);
+
 #endif /* CONFIG_KVM */
 
 #ifdef CONFIG_EFI_ZBOOT
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 05b022be885b..370e820ecadb 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1259,6 +1259,11 @@ static int timer_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
 	return 0;
 }
 
+void __aic_timer_fiq_clear_set(u64 clear, u64 set)
+{
+	kvm_call_hyp_nvhe(__aic_timer_fiq_clear_set, clear, set);
+}
+
 static int timer_irq_set_irqchip_state(struct irq_data *d,
 				       enum irqchip_irq_state which, bool val)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index ce602f9e93eb..555294aacfc9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -192,6 +192,16 @@ static void handle___vgic_v3_restore_aprs(struct kvm_cpu_context *host_ctxt)
 	__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
 }
 
+#define SYS_IMP_APL_VM_TMR_FIQ_ENA_EL2	sys_reg(3, 5, 15, 1, 3)
+
+static void handle___aic_timer_fiq_clear_set(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, clear, host_ctxt, 1);
+	DECLARE_REG(u64, set, host_ctxt, 2);
+
+	__aic_timer_fiq_clear_set(clear, set);
+}
+
 static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
@@ -322,6 +332,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_write_vmcr),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_aprs),
+	HANDLE_FUNC(__aic_timer_fiq_clear_set),
 	HANDLE_FUNC(__pkvm_vcpu_init_traps),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 3aaab20ae5b4..9335dbee88e5 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -60,3 +60,12 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 
 	sysreg_clear_set(cnthctl_el2, clr, set);
 }
+
+
+void __aic_timer_fiq_clear_set(u64 clear, u64 set)
+{
+#ifdef CONFIG_APPLE_AIC
+	if (has_hvhe() && static_branch_likely(&aic_impdef_timer_control))
+		sysreg_clear_set_s(SYS_IMP_APL_VM_TMR_FIQ_ENA_EL2, clear, set);
+#endif
+}
diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index 5c534d9fd2b0..acd47f475f36 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -180,7 +180,6 @@
 #define IPI_SR_PENDING			BIT(0)
 
 /* Guest timer FIQ enable register */
-#define SYS_IMP_APL_VM_TMR_FIQ_ENA_EL2	sys_reg(3, 5, 15, 1, 3)
 #define VM_TMR_FIQ_ENABLE_V		BIT(0)
 #define VM_TMR_FIQ_ENABLE_P		BIT(1)
 
@@ -236,6 +235,8 @@ enum fiq_hwirq {
 
 static DEFINE_STATIC_KEY_TRUE(use_fast_ipi);
 
+DEFINE_STATIC_KEY_FALSE(aic_impdef_timer_control);
+
 struct aic_info {
 	int version;
 
@@ -458,6 +459,40 @@ static unsigned long aic_fiq_get_idx(struct irq_data *d)
 	return AIC_HWIRQ_IRQ(irqd_to_hwirq(d));
 }
 
+void __weak __aic_timer_fiq_clear_set(u64 clear, u64 set) { }
+
+static bool aic_check_timer_enabled(int timer)
+{
+	if (IS_ENABLED(CONFIG_KVM) &&
+	    static_branch_unlikely(&aic_impdef_timer_control))
+		return __this_cpu_read(aic_fiq_unmasked) & BIT(timer);
+	return true;
+}
+
+static void aic_hvhe_timer_mask(int timer, bool mask)
+{
+	u64 clr, set, bit;
+
+	if (!(IS_ENABLED(CONFIG_KVM) &&
+	      static_branch_unlikely(&aic_impdef_timer_control)))
+		return;
+
+	if (timer == AIC_TMR_EL0_VIRT)
+		bit = VM_TMR_FIQ_ENABLE_V;
+	else
+	        bit = VM_TMR_FIQ_ENABLE_P;
+
+	if (mask) {
+		clr = bit;
+		set = 0;
+	} else {
+		clr = 0;
+		set = bit;
+	}
+
+	__aic_timer_fiq_clear_set(clr, set);
+}
+
 static void aic_fiq_set_mask(struct irq_data *d)
 {
 	/* Only the guest timers have real mask bits, unfortunately. */
@@ -470,6 +505,9 @@ static void aic_fiq_set_mask(struct irq_data *d)
 		sysreg_clear_set_s(SYS_IMP_APL_VM_TMR_FIQ_ENA_EL2, VM_TMR_FIQ_ENABLE_V, 0);
 		isb();
 		break;
+	case AIC_TMR_EL0_VIRT:
+		aic_hvhe_timer_mask(AIC_TMR_EL0_VIRT, true);
+		break;
 	default:
 		break;
 	}
@@ -486,6 +524,9 @@ static void aic_fiq_clear_mask(struct irq_data *d)
 		sysreg_clear_set_s(SYS_IMP_APL_VM_TMR_FIQ_ENA_EL2, 0, VM_TMR_FIQ_ENABLE_V);
 		isb();
 		break;
+	case AIC_TMR_EL0_VIRT:
+		aic_hvhe_timer_mask(AIC_TMR_EL0_VIRT, false);
+		break;
 	default:
 		break;
 	}
@@ -545,7 +586,8 @@ static void __exception_irq_entry aic_handle_fiq(struct pt_regs *regs)
 		generic_handle_domain_irq(aic_irqc->hw_domain,
 					  AIC_FIQ_HWIRQ(AIC_TMR_EL0_PHYS));
 
-	if (TIMER_FIRING(read_sysreg(cntv_ctl_el0)))
+	if (TIMER_FIRING(read_sysreg(cntv_ctl_el0)) &&
+	    aic_check_timer_enabled(AIC_TMR_EL0_VIRT))
 		generic_handle_domain_irq(aic_irqc->hw_domain,
 					  AIC_FIQ_HWIRQ(AIC_TMR_EL0_VIRT));
 
@@ -1041,6 +1083,10 @@ static int __init aic_of_ic_init(struct device_node *node, struct device_node *p
 	if (static_branch_likely(&use_fast_ipi))
 		pr_info("Using Fast IPIs");
 
+	/* Caps are not final at this stage :-/ */
+	if (cpus_have_cap(ARM64_KVM_HVHE))
+		static_branch_enable(&aic_impdef_timer_control);
+
 	cpuhp_setup_state(CPUHP_AP_IRQ_APPLE_AIC_STARTING,
 			  "irqchip/apple-aic/ipi:starting",
 			  aic_init_cpu, NULL);
-- 
2.34.1


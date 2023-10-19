Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFA37CEC10
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 01:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbjJRXcd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 19:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjJRXcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 19:32:32 -0400
Received: from out-197.mta1.migadu.com (out-197.mta1.migadu.com [IPv6:2001:41d0:203:375::c5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DF0113
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 16:32:29 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697671947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kj9Yf9Pl6gAO++FRNANBIVJ/cRmie6HUdzlsYKLH/EQ=;
        b=iftY0My9cU9eZ82XCAAkmYbbqQ9GP4KYKtjHQihVhQxbDgtJ4fzwtbHdivPnjeKJI5fbS5
        0uJNWrECKtNPHf3SHDRBEAv30jOwCYuRFM5fSmFzLT4I2IpPVbFb6HKEPAR1cPhEwKNNxA
        ntbxJU+tqaSO2/Hv6SsMkiYL977U2BM=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 4/5] KVM: arm64: Rename helpers for VHE vCPU load/put
Date:   Wed, 18 Oct 2023 23:32:11 +0000
Message-ID: <20231018233212.2888027-5-oliver.upton@linux.dev>
In-Reply-To: <20231018233212.2888027-1-oliver.upton@linux.dev>
References: <20231018233212.2888027-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The names for the helpers we expose to the 'generic' KVM code are a bit
imprecise; we switch the EL0 + EL1 sysreg context and setup trap
controls that do not need to change for every guest entry/exit. Rename +
shuffle things around a bit in preparation for loading the stage-2 MMU
context on vcpu_load().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h  |  4 ++--
 arch/arm64/include/asm/kvm_hyp.h   |  7 ++-----
 arch/arm64/kvm/arm.c               |  4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c    | 18 +++++++++++++++---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 11 ++++-------
 5 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index be0ab101c557..759adee42018 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1109,8 +1109,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
 }
 #endif
 
-void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
-void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu);
+void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
+void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu);
 
 int __init kvm_set_ipa_limit(void);
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 66efd67ea7e8..145ce73fc16c 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -93,6 +93,8 @@ void __timer_disable_traps(struct kvm_vcpu *vcpu);
 void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt);
 #else
+void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu);
+void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu);
 void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt);
@@ -111,11 +113,6 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 void __sve_restore_state(void *sve_pffr, u32 *fpsr);
 
-#ifndef __KVM_NVHE_HYPERVISOR__
-void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
-void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
-#endif
-
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt, u32 func_id);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3ab904adbd64..584be562b1d4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -448,7 +448,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
 	if (has_vhe())
-		kvm_vcpu_load_sysregs_vhe(vcpu);
+		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
@@ -472,7 +472,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_put_debug_state_flags(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
-		kvm_vcpu_put_sysregs_vhe(vcpu);
+		kvm_vcpu_put_vhe(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 6537f58b1a8c..d05b6a08dcde 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -93,12 +93,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 NOKPROBE_SYMBOL(__deactivate_traps);
 
 /*
- * Disable IRQs in {activate,deactivate}_traps_vhe_{load,put}() to
+ * Disable IRQs in __vcpu_{load,put}_{activate,deactivate}_traps() to
  * prevent a race condition between context switching of PMUSERENR_EL0
  * in __{activate,deactivate}_traps_common() and IPIs that attempts to
  * update PMUSERENR_EL0. See also kvm_set_pmuserenr().
  */
-void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
+static void __vcpu_load_activate_traps(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
 
@@ -107,7 +107,7 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 	local_irq_restore(flags);
 }
 
-void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
+static void __vcpu_put_deactivate_traps(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
 
@@ -116,6 +116,18 @@ void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 	local_irq_restore(flags);
 }
 
+void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
+{
+	__vcpu_load_switch_sysregs(vcpu);
+	__vcpu_load_activate_traps(vcpu);
+}
+
+void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
+{
+	__vcpu_put_deactivate_traps(vcpu);
+	__vcpu_put_switch_sysregs(vcpu);
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index b35a178e7e0d..8e1e0d5033b6 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -52,7 +52,7 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
 NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
 
 /**
- * kvm_vcpu_load_sysregs_vhe - Load guest system registers to the physical CPU
+ * __vcpu_load_switch_sysregs - Load guest system registers to the physical CPU
  *
  * @vcpu: The VCPU pointer
  *
@@ -62,7 +62,7 @@ NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
  * and loading system register state early avoids having to load them on
  * every entry to the VM.
  */
-void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
+void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
@@ -92,12 +92,10 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 	__sysreg_restore_el1_state(guest_ctxt);
 
 	vcpu_set_flag(vcpu, SYSREGS_ON_CPU);
-
-	activate_traps_vhe_load(vcpu);
 }
 
 /**
- * kvm_vcpu_put_sysregs_vhe - Restore host system registers to the physical CPU
+ * __vcpu_put_switch_syregs - Restore host system registers to the physical CPU
  *
  * @vcpu: The VCPU pointer
  *
@@ -107,13 +105,12 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
  * and deferring saving system register state until we're no longer running the
  * VCPU avoids having to save them on every exit from the VM.
  */
-void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
+void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	deactivate_traps_vhe_put(vcpu);
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
-- 
2.42.0.655.g421f12c284-goog


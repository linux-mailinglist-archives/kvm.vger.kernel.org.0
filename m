Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87B9536C90
	for <lists+kvm@lfdr.de>; Sat, 28 May 2022 13:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiE1Liq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 May 2022 07:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbiE1Lik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 May 2022 07:38:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE48167EA
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 04:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46F4A60EA8
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 11:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8461AC34100;
        Sat, 28 May 2022 11:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653737917;
        bh=Z8nXDSZRBjJUAVfiOgIWAj0JFE7jDZW8xW+9I20JbIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcbMFArcjg11R5ZKeIwdvgLKr5rugdZjuNblGruWEpGNcvyMNRDPcvZ6BfXgUkrmY
         90uzvrfszfgIbmiTwMqoNrNhL9UFc2ON+zIWTIgnEGD46AFtQ1g8o/p6G7ld+Gqlk0
         EqDWNMesTYDakgizWAwO2C+F3skuzrl7fXRU5i7PudW4AAsWFgnvhRzBAublL+Bp69
         WVzWxshe7HIygSs1skwMquzQI4+tnZ0+2Ud8cDdI8VUi8VckSLZ4apoxbmutOUCB9J
         rv/F3ZqT1MwSUg1Pif9CUk4Xal0vkDyzhFSQTNVdsrPNcrQuORYcC4u5Gl0yTpWtBl
         VIX7J2YOET7dA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nuumB-00EEGh-IM; Sat, 28 May 2022 12:38:35 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com
Subject: [PATCH 09/18] KVM: arm64: Move vcpu debug/SPE/TRBE flags to the input flag set
Date:   Sat, 28 May 2022 12:38:19 +0100
Message-Id: <20220528113829.1043361-10-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The three debug flags (which deal with the debug registers, SPE and
TRBE) all are input flags to the hypervisor code.

Move them into the input set and convert them to the new accessors.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h          |  9 ++++++---
 arch/arm64/kvm/debug.c                     | 22 +++++++++++-----------
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  6 +++---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  8 ++++----
 arch/arm64/kvm/sys_regs.c                  |  8 ++++----
 6 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 078567f5709c..a426cd3aaa74 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -500,6 +500,12 @@ struct kvm_vcpu_arch {
 #define EXCEPT_AA64_EL2_IRQ	__vcpu_except_flags(5)
 #define EXCEPT_AA64_EL2_FIQ	__vcpu_except_flags(6)
 #define EXCEPT_AA64_EL2_SERR	__vcpu_except_flags(7)
+/* Guest debug is live */
+#define DEBUG_DIRTY		__vcpu_single_flag(iflags, BIT(4))
+/* Save SPE context if active  */
+#define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
+/* Save TRBE context if active  */
+#define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -522,10 +528,7 @@ struct kvm_vcpu_arch {
 })
 
 /* vcpu_arch flags field values: */
-#define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
 #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
-#define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
-#define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
 #define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
 #define KVM_ARM64_HOST_SME_ENABLED	(1 << 16) /* SME enabled for EL0 */
 #define KVM_ARM64_WFIT			(1 << 17) /* WFIT instruction trapped */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 4fd5c216c4bb..c5c4c1837bf3 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -104,11 +104,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 * Trap debug register access when one of the following is true:
 	 *  - Userspace is using the hardware to debug the guest
 	 *  (KVM_GUESTDBG_USE_HW is set).
-	 *  - The guest is not using debug (KVM_ARM64_DEBUG_DIRTY is clear).
+	 *  - The guest is not using debug (DEBUG_DIRTY clear).
 	 *  - The guest has enabled the OS Lock (debug exceptions are blocked).
 	 */
 	if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW) ||
-	    !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY) ||
+	    !vcpu_get_flag(vcpu, DEBUG_DIRTY) ||
 	    kvm_vcpu_os_lock_enabled(vcpu))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
 
@@ -147,8 +147,8 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
  * debug related registers.
  *
  * Additionally, KVM only traps guest accesses to the debug registers if
- * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
- * flag on vcpu->arch.flags).  Since the guest must not interfere
+ * the guest is not actively using them (see the DEBUG_DIRTY
+ * flag on vcpu->arch.iflags).  Since the guest must not interfere
  * with the hardware state when debugging the guest, we must ensure that
  * trapping is enabled whenever we are debugging the guest using the
  * debug registers.
@@ -205,7 +205,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		 *
 		 * We simply switch the debug_ptr to point to our new
 		 * external_debug_state which has been populated by the
-		 * debug ioctl. The existing KVM_ARM64_DEBUG_DIRTY
+		 * debug ioctl. The existing KVM_ARM64_IFLAG_DEBUG_DIRTY
 		 * mechanism ensures the registers are updated on the
 		 * world switch.
 		 */
@@ -216,7 +216,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 
 			vcpu->arch.debug_ptr = &vcpu->arch.external_debug_state;
-			vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
+			vcpu_set_flag(vcpu, DEBUG_DIRTY);
 
 			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
 						&vcpu->arch.debug_ptr->dbg_bcr[0],
@@ -246,7 +246,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
+		vcpu_set_flag(vcpu, DEBUG_DIRTY);
 
 	/* Write mdcr_el2 changes since vcpu_load on VHE systems */
 	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
@@ -298,16 +298,16 @@ void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu)
 	 */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_PMSVER_SHIFT) &&
 	    !(read_sysreg_s(SYS_PMBIDR_EL1) & BIT(SYS_PMBIDR_EL1_P_SHIFT)))
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_STATE_SAVE_SPE;
+		vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_SPE);
 
 	/* Check if we have TRBE implemented and available at the host */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_TRBE_SHIFT) &&
 	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_PROG))
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_STATE_SAVE_TRBE;
+		vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
 }
 
 void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.flags &= ~(KVM_ARM64_DEBUG_STATE_SAVE_SPE |
-			      KVM_ARM64_DEBUG_STATE_SAVE_TRBE);
+	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
+	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 4ebe9f558f3a..961bbef104a6 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -132,7 +132,7 @@ static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+	if (!vcpu_get_flag(vcpu, DEBUG_DIRTY))
 		return;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
@@ -151,7 +151,7 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+	if (!vcpu_get_flag(vcpu, DEBUG_DIRTY))
 		return;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
@@ -162,7 +162,7 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 	__debug_save_state(guest_dbg, guest_ctxt);
 	__debug_restore_state(host_dbg, host_ctxt);
 
-	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
+	vcpu_clear_flag(vcpu, DEBUG_DIRTY);
 }
 
 #endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 7ecca8b07851..baa5b9b3dde5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -195,7 +195,7 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	__vcpu_sys_reg(vcpu, DACR32_EL2) = read_sysreg(dacr32_el2);
 	__vcpu_sys_reg(vcpu, IFSR32_EL2) = read_sysreg(ifsr32_el2);
 
-	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || vcpu_get_flag(vcpu, DEBUG_DIRTY))
 		__vcpu_sys_reg(vcpu, DBGVCR32_EL2) = read_sysreg(dbgvcr32_el2);
 }
 
@@ -212,7 +212,7 @@ static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	write_sysreg(__vcpu_sys_reg(vcpu, DACR32_EL2), dacr32_el2);
 	write_sysreg(__vcpu_sys_reg(vcpu, IFSR32_EL2), ifsr32_el2);
 
-	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || vcpu_get_flag(vcpu, DEBUG_DIRTY))
 		write_sysreg(__vcpu_sys_reg(vcpu, DBGVCR32_EL2), dbgvcr32_el2);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index df361d839902..e17455773b98 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -84,10 +84,10 @@ static void __debug_restore_trace(u64 trfcr_el1)
 void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	/* Disable and flush SPE data generation */
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_SPE)
+	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
 		__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
 	/* Disable and flush Self-Hosted Trace generation */
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_TRBE)
+	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
 		__debug_save_trace(&vcpu->arch.host_debug_state.trfcr_el1);
 }
 
@@ -98,9 +98,9 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_SPE)
+	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
 		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_TRBE)
+	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
 		__debug_restore_trace(vcpu->arch.host_debug_state.trfcr_el1);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d77be152cbd5..d6a55ed9ff10 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -387,7 +387,7 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 {
 	if (p->is_write) {
 		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
+		vcpu_set_flag(vcpu, DEBUG_DIRTY);
 	} else {
 		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
 	}
@@ -403,8 +403,8 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
  * A 32 bit write to a debug register leave top bits alone
  * A 32 bit read from a debug register only returns the bottom bits
  *
- * All writes will set the KVM_ARM64_DEBUG_DIRTY flag to ensure the
- * hyp.S code switches between host and guest values in future.
+ * All writes will set the DEBUG_DIRTY flag to ensure the hyp code
+ * switches between host and guest values in future.
  */
 static void reg_to_dbg(struct kvm_vcpu *vcpu,
 		       struct sys_reg_params *p,
@@ -420,7 +420,7 @@ static void reg_to_dbg(struct kvm_vcpu *vcpu,
 	val |= (p->regval & (mask >> shift)) << shift;
 	*dbg_reg = val;
 
-	vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
+	vcpu_set_flag(vcpu, DEBUG_DIRTY);
 }
 
 static void dbg_to_reg(struct kvm_vcpu *vcpu,
-- 
2.34.1


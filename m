Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF54B52D4D5
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239053AbiESNrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiESNqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:46:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789CA5590
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:45:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E93A6179F
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13976C34115;
        Thu, 19 May 2022 13:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967955;
        bh=Us5TydH7WI/rZV15ZTqLlCPi3fuqooPfs40Aq0JtCjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idXjjs+cpv/cEMpS4QA91l1Pgcfz2v1VjEvHh9BL67YQCcesyaUttuJo+z+Q6SVUe
         3ZkjlmSs3h/L3Mok08eil9KrEZoHjBeOL+zF6jYlGcO0sk4BPtni2QOlcpMBiaWdBN
         QFSUT/1vIn0niNb6oYpXUbBDCNbkVj2E1OEJM4Nd1jzQgZvF7U93cdVqFJhNM23/do
         gYCalGkUEUp5J0V9R39BrUvhWHbo8uO1YK4TInERx3eL37WRcCkJwDq9/ue7suyF+7
         pBqbs67lF+Ew9WYrG4u9ug70FpO4cNjD2iUPOXdFo0Yxiati2SyILe5k5MSTGhPSZx
         vON2IWksQBZuA==
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
Subject: [PATCH 53/89] KVM: arm64: Lazy host FP save/restore
Date:   Thu, 19 May 2022 14:41:28 +0100
Message-Id: <20220519134204.5379-54-will@kernel.org>
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

Implement lazy save/restore of the host FPSIMD register state at EL2.
This allows us to save/restore guest FPSIMD registers without involving
the host and means that we can avoid having to repopulate the shadow
register state on every flush.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 57 ++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2a12d6f710ef..228736a9ab40 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -20,6 +20,14 @@
 
 #include <linux/irqchip/arm-gic-v3.h>
 
+/*
+ * Host FPSIMD state. Written to when the guest accesses its own FPSIMD state,
+ * and read when the guest state is live and we need to switch back to the host.
+ *
+ * Only valid when the KVM_ARM64_FP_ENABLED flag is set in the shadow structure.
+ */
+static DEFINE_PER_CPU(struct user_fpsimd_state, loaded_host_fpsimd_state);
+
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
@@ -195,10 +203,8 @@ static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 
 	shadow_vcpu->arch.hcr_el2	= host_vcpu->arch.hcr_el2;
 	shadow_vcpu->arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
-	shadow_vcpu->arch.cptr_el2	= host_vcpu->arch.cptr_el2;
 
 	shadow_vcpu->arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
-	shadow_vcpu->arch.host_fpsimd_state = host_vcpu->arch.host_fpsimd_state;
 
 	shadow_vcpu->arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
@@ -235,7 +241,6 @@ static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state,
 	host_vcpu->arch.ctxt		= shadow_vcpu->arch.ctxt;
 
 	host_vcpu->arch.hcr_el2		= shadow_vcpu->arch.hcr_el2;
-	host_vcpu->arch.cptr_el2	= shadow_vcpu->arch.cptr_el2;
 
 	sync_vgic_state(host_vcpu, shadow_vcpu);
 	sync_timer_state(shadow_state);
@@ -262,6 +267,27 @@ static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state,
 	shadow_state->exit_code = exit_reason;
 }
 
+static void fpsimd_host_restore(void)
+{
+	sysreg_clear_set(cptr_el2, CPTR_EL2_TZ | CPTR_EL2_TFP, 0);
+	isb();
+
+	if (unlikely(is_protected_kvm_enabled())) {
+		struct kvm_shadow_vcpu_state *shadow_state = pkvm_loaded_shadow_vcpu_state();
+		struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
+		struct user_fpsimd_state *host_fpsimd_state = this_cpu_ptr(&loaded_host_fpsimd_state);
+
+		__fpsimd_save_state(&shadow_vcpu->arch.ctxt.fp_regs);
+		__fpsimd_restore_state(host_fpsimd_state);
+
+		shadow_vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
+		shadow_vcpu->arch.flags |= KVM_ARM64_FP_HOST;
+	}
+
+	if (system_supports_sve())
+		sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+}
+
 static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(unsigned int, shadow_handle, host_ctxt, 1);
@@ -291,6 +317,9 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 		*last_ran = shadow_vcpu->vcpu_id;
 	}
 
+	shadow_vcpu->arch.host_fpsimd_state = this_cpu_ptr(&loaded_host_fpsimd_state);
+	shadow_vcpu->arch.flags |= KVM_ARM64_FP_HOST;
+
 	if (shadow_state_is_protected(shadow_state)) {
 		/* Propagate WFx trapping flags, trap ptrauth */
 		shadow_vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI |
@@ -310,6 +339,10 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
 
 	if (shadow_state) {
 		struct kvm_vcpu *host_vcpu = shadow_state->host_vcpu;
+		struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
+
+		if (shadow_vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
+			fpsimd_host_restore();
 
 		if (!shadow_state_is_protected(shadow_state) &&
 			!(READ_ONCE(host_vcpu->arch.flags) & KVM_ARM64_PKVM_STATE_DIRTY))
@@ -377,6 +410,19 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 		ret = __kvm_vcpu_run(&shadow_state->shadow_vcpu);
 
 		sync_shadow_state(shadow_state, ret);
+
+		if (shadow_state->shadow_vcpu.arch.flags & KVM_ARM64_FP_ENABLED) {
+			/*
+			 * The guest has used the FP, trap all accesses
+			 * from the host (both FP and SVE).
+			 */
+			u64 reg = CPTR_EL2_TFP;
+
+			if (system_supports_sve())
+				reg |= CPTR_EL2_TZ;
+
+			sysreg_clear_set(cptr_el2, 0, reg);
+		}
 	} else {
 		ret = __kvm_vcpu_run(vcpu);
 	}
@@ -707,10 +753,9 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	case ESR_ELx_EC_SMC64:
 		handle_host_smc(host_ctxt);
 		break;
+	case ESR_ELx_EC_FP_ASIMD:
 	case ESR_ELx_EC_SVE:
-		sysreg_clear_set(cptr_el2, CPTR_EL2_TZ, 0);
-		isb();
-		sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+		fpsimd_host_restore();
 		break;
 	case ESR_ELx_EC_IABT_LOW:
 	case ESR_ELx_EC_DABT_LOW:
-- 
2.36.1.124.g0e6072fb45-goog


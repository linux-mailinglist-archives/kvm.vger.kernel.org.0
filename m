Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3963454624E
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348638AbiFJJan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349163AbiFJJaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:30:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3BF14AF7F
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2FB1B83352
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 09:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F267C341C8;
        Fri, 10 Jun 2022 09:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654853336;
        bh=VVm8O93Wa9y/j8r2xYGArbTB/FwzuehUfZVszKy40mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjUuiZ2PjM0k+LIXsxREgrTuze0QE/IJn9TvVYswN5AuekQersvgpziMZHvszjXwi
         yepZs2z7ERId5bp4gMRkMEK1Y9x9jUPkcS/PqJ0vbXbFKioD81VSLMl0tQTFBUNI/d
         CGQRLk8Kb8tXc97aHXrQAajXrlPFKQESp8JFl7iWmGNpyQXmvIqGzimZdntF5ajPle
         YUBt633zzxKZZwmEqpAvAuPXp4OSZyTjaeYN0EYN4TTqv7b70pnZNVvJUN8m1VGChT
         6spxiAZNBKsGKEITsklOySByxUFjImeDQcEt8qGJVCIDXkBIBK3VvLmhMfcVE8g8HH
         IKXdq7hD06S5A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nzawo-00H6Dt-MJ; Fri, 10 Jun 2022 10:28:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>,
        Reiji Watanabe <reijiw@google.com>, kernel-team@android.com
Subject: [PATCH v2 04/19] KVM: arm64: Move FP state ownership from flag to a tristate
Date:   Fri, 10 Jun 2022 10:28:23 +0100
Message-Id: <20220610092838.1205755-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, reijiw@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM FP code uses a pair of flags to denote three states:

- FP_ENABLED set: the guest owns the FP state
- FP_HOST set: the host owns the FP state
- FP_ENABLED and FP_HOST clear: nobody owns the FP state at all

and both flags set is an illegal state, which nothing ever checks
for...

As it turns out, this isn't really a good match for flags, and
we'd be better off if this was a simpler tristate, each state
having a name that actually reflect the state:

- FP_STATE_FREE
- FP_STATE_HOST_OWNED
- FP_STATE_GUEST_OWNED

Kill the two flags, and move over to an enum encoding these
three states. This results in less confusing code, and less risk of
ending up in the uncharted territory of a 4th state if we forget
to clear one of the two flags.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  9 +++++++--
 arch/arm64/kvm/fpsimd.c                 | 14 ++++++--------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  8 +++-----
 arch/arm64/kvm/hyp/nvhe/switch.c        |  4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 5 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 63103cc1bdc4..372c5642cfab 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -325,6 +325,13 @@ struct kvm_vcpu_arch {
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
+	/* Ownership of the FP regs */
+	enum {
+		FP_STATE_FREE,
+		FP_STATE_HOST_OWNED,
+		FP_STATE_GUEST_OWNED,
+	} fp_state;
+
 	/* Miscellaneous vcpu state flags */
 	u64 flags;
 
@@ -430,8 +437,6 @@ struct kvm_vcpu_arch {
 
 /* vcpu_arch flags field values: */
 #define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
-#define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
-#define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
 #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
 #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
 #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index edbc0183c89b..d397efe1a378 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -77,8 +77,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	BUG_ON(!current->mm);
 	BUG_ON(test_thread_flag(TIF_SVE));
 
-	vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
-	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
+	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
 
 	vcpu->arch.flags &= ~KVM_ARM64_HOST_SVE_ENABLED;
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
@@ -98,9 +97,8 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
 			vcpu->arch.flags |= KVM_ARM64_HOST_SME_ENABLED;
 
-		if (read_sysreg_s(SYS_SVCR) &
-		    (SVCR_SM_MASK | SVCR_ZA_MASK)) {
-			vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
+		if (read_sysreg_s(SYS_SVCR) & (SVCR_SM_MASK | SVCR_ZA_MASK)) {
+			vcpu->arch.fp_state = FP_STATE_FREE;
 			fpsimd_save_and_flush_cpu_state();
 		}
 	}
@@ -119,7 +117,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
 {
 	if (!system_supports_fpsimd() || test_thread_flag(TIF_FOREIGN_FPSTATE))
-		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_FP_HOST);
+		vcpu->arch.fp_state = FP_STATE_FREE;
 }
 
 /*
@@ -133,7 +131,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 {
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED) {
 		/*
 		 * Currently we do not support SME guests so SVCR is
 		 * always 0 and we just need a variable to point to.
@@ -176,7 +174,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 					 CPACR_EL1_SMEN_EL1EN);
 	}
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED) {
 		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e54320384943..6cbbb6c02f66 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -40,7 +40,7 @@ extern struct kvm_exception_table_entry __stop___kvm_ex_table;
 /* Check whether the FP regs are owned by the guest */
 static inline bool guest_owns_fp_regs(struct kvm_vcpu *vcpu)
 {
-	return !!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
+	return vcpu->arch.fp_state == FP_STATE_GUEST_OWNED;
 }
 
 /* Save the 32-bit only FPSIMD system register state */
@@ -179,10 +179,8 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	isb();
 
 	/* Write out the host state if it's in the registers */
-	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
+	if (vcpu->arch.fp_state == FP_STATE_HOST_OWNED)
 		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
-		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
-	}
 
 	/* Restore the guest state */
 	if (sve_guest)
@@ -194,7 +192,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
 		write_sysreg(__vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
 
-	vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
+	vcpu->arch.fp_state = FP_STATE_GUEST_OWNED;
 
 	return true;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index a6b9f1186577..764bdc423cb8 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -123,7 +123,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	}
 
 	cptr = CPTR_EL2_DEFAULT;
-	if (vcpu_has_sve(vcpu) && (vcpu->arch.flags & KVM_ARM64_FP_ENABLED))
+	if (vcpu_has_sve(vcpu) && (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED))
 		cptr |= CPTR_EL2_TZ;
 	if (cpus_have_final_cap(ARM64_SME))
 		cptr &= ~CPTR_EL2_TSM;
@@ -335,7 +335,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
+	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED)
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 46f365254e9f..bce7fc51f9a1 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -175,7 +175,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
+	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED)
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
-- 
2.34.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BDC605AE7
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJTJQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiJTJQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:16:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC4B172B5D
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:16:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DBEE61A88
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0D9C433D6;
        Thu, 20 Oct 2022 09:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666257398;
        bh=JD0zvy1tn0V1G/ozgRXVc6Foq7wOYdMtERGSmxQjoHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjTT2MuyuWQUkY9iJeK5gt8KZ3YxNJW4yfgwqWXAZs1hploWP8ksa9VZz9FMJmyEh
         i7yASZahHdelgJIxvsRVYR1fQVeh3OyE3qwnpa7wnw/VFBNZ3ib2jPeDgtERgiZODF
         ri/O7le2NfsGd+tZ+yBNcgywVWTw6WPNGRGGVjjlu6qC+rro13vvcre/EDyjwH+AS8
         zxPS/pxlIu+kv8pEAbAEpSbuEVNN4Sm+x0nGmBeo3WeoY0tV2B8V2uwQmPrk1kNMey
         9LuRhzDvGyVv1/Ezj/8yex1EwZ7XElSDmJArS3judxySvLnyUL6XxP+0f5ktKh1e1E
         QzrVsb8L8jHPQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1olRWb-000Buf-Rf;
        Thu, 20 Oct 2022 10:07:37 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH 13/17] KVM: arm64: Rework CPTR_EL2 programming for HVHE configuration
Date:   Thu, 20 Oct 2022 10:07:23 +0100
Message-Id: <20221020090727.3669908-14-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just like we repainted the early arm64 code, we need to update
the CPTR_EL2 accesses that are taking place in the nVHE code
when hVHE is used, making them look as if they were CPACR_EL1
accesses. Just like the VHE code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h        |  3 ---
 arch/arm64/include/asm/kvm_emulate.h    | 31 +++++++++++++++++++++++++
 arch/arm64/kvm/arm.c                    |  2 +-
 arch/arm64/kvm/fpsimd.c                 |  4 ++--
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 ++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 24 ++++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/switch.c        | 28 ++++++++++++----------
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 9 files changed, 75 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8aa8492dafc0..e187f84cef2c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -284,7 +284,6 @@
 #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
 #define CPTR_EL2_TZ	(1 << 8)
 #define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
-#define CPTR_EL2_DEFAULT	CPTR_NVHE_EL2_RES1
 #define CPTR_NVHE_EL2_RES0	(GENMASK(63, 32) |	\
 				 GENMASK(29, 21) |	\
 				 GENMASK(19, 14) |	\
@@ -358,7 +357,5 @@
 	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
 
 #define CPACR_EL1_TTA		(1 << 28)
-#define CPACR_EL1_DEFAULT	(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |\
-				 CPACR_EL1_ZEN_EL1EN)
 
 #endif /* __ARM64_KVM_ARM_H__ */
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 9bdba47f7e14..82a9af885f2e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -490,4 +490,35 @@ static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
 	return test_bit(feature, vcpu->arch.features);
 }
 
+static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	if (has_vhe()) {
+		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
+		       CPACR_EL1_ZEN_EL1EN);
+	} else if (has_hvhe()) {
+		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN);
+	} else {
+		val = CPTR_NVHE_EL2_RES1;
+
+		if (vcpu_has_sve(vcpu) &&
+		    (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED))
+			val |= CPTR_EL2_TZ;
+		if (cpus_have_final_cap(ARM64_SME))
+			val &= ~CPTR_EL2_TSM;
+	}
+
+	return val;
+}
+
+static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
+{
+	u64 val = kvm_get_reset_cptr_el2(vcpu);
+
+	if (has_vhe() || has_hvhe())
+		write_sysreg(val, cpacr_el1);
+	else
+		write_sysreg(val, cptr_el2);
+}
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cf0f15f4d69a..b6c9bfa8492f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1194,7 +1194,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
-	vcpu->arch.cptr_el2 = CPTR_EL2_DEFAULT;
+	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
 
 	/*
 	 * Handle the "start in power-off" case.
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index ec8e4494873d..15bbde102d06 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -160,7 +160,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	/*
 	 * If we have VHE then the Hyp code will reset CPACR_EL1 to
-	 * CPACR_EL1_DEFAULT and we need to reenable SME.
+	 * the default value and we need to reenable SME.
 	 */
 	if (has_vhe() && system_supports_sme()) {
 		/* Also restore EL0 state seen on entry */
@@ -189,7 +189,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		/*
 		 * The FPSIMD/SVE state in the CPU has not been touched, and we
 		 * have SVE (and VHE): CPACR_EL1 (alias CPTR_EL2) has been
-		 * reset to CPACR_EL1_DEFAULT by the Hyp code, disabling SVE
+		 * reset by kvm_reset_cptr_el2() in the Hyp code, disabling SVE
 		 * for EL0.  To avoid spurious traps, restore the trap state
 		 * seen by kvm_arch_vcpu_load_fp():
 		 */
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6cbbb6c02f66..9dc7197dca4f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -163,7 +163,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	/* Valid trap.  Switch the context: */
 
 	/* First disable enough traps to allow us to update the registers */
-	if (has_vhe()) {
+	if (has_vhe() || has_hvhe()) {
 		reg = CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN;
 		if (sve_guest)
 			reg |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 3cea4b6ac23e..14695e29a2be 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -286,7 +286,11 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		handle_host_smc(host_ctxt);
 		break;
 	case ESR_ELx_EC_SVE:
-		sysreg_clear_set(cptr_el2, CPTR_EL2_TZ, 0);
+		if (has_hvhe())
+			sysreg_clear_set(cpacr_el1, 0, (CPACR_EL1_ZEN_EL1EN |
+							CPACR_EL1_ZEN_EL0EN));
+		else
+			sysreg_clear_set(cptr_el2, CPTR_EL2_TZ, 0);
 		isb();
 		sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
 		break;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 85d3b7ae720f..d58314461595 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -18,6 +18,7 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	u64 hcr_set = HCR_RW;
 	u64 hcr_clear = 0;
 	u64 cptr_set = 0;
+	u64 cptr_clear = 0;
 
 	/* Protected KVM does not support AArch32 guests. */
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0),
@@ -48,12 +49,17 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	}
 
 	/* Trap SVE */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), feature_ids))
-		cptr_set |= CPTR_EL2_TZ;
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), feature_ids)) {
+		if (has_hvhe())
+			cptr_clear |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
+		else
+			cptr_set |= CPTR_EL2_TZ;
+	}
 
 	vcpu->arch.hcr_el2 |= hcr_set;
 	vcpu->arch.hcr_el2 &= ~hcr_clear;
 	vcpu->arch.cptr_el2 |= cptr_set;
+	vcpu->arch.cptr_el2 &= ~cptr_clear;
 }
 
 /*
@@ -111,8 +117,12 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 		mdcr_set |= MDCR_EL2_TTRF;
 
 	/* Trap Trace */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), feature_ids))
-		cptr_set |= CPTR_EL2_TTA;
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), feature_ids)) {
+		if (has_hvhe())
+			cptr_set |= CPACR_EL1_TTA;
+		else
+			cptr_set |= CPTR_EL2_TTA;
+	}
 
 	vcpu->arch.mdcr_el2 |= mdcr_set;
 	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
@@ -167,8 +177,10 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 	/* Clear res0 and set res1 bits to trap potential new features. */
 	vcpu->arch.hcr_el2 &= ~(HCR_RES0);
 	vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_RES0);
-	vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
-	vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
+	if (!has_hvhe()) {
+		vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
+		vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
+	}
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 8e9d49a964be..d0b27c33af56 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -44,13 +44,24 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	__activate_traps_common(vcpu);
 
 	val = vcpu->arch.cptr_el2;
-	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
+	val |= CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
+	val |= has_hvhe() ? CPACR_EL1_TTA : CPTR_EL2_TTA;
+	if (cpus_have_final_cap(ARM64_SME)) {
+		if (has_hvhe())
+			val &= ~(CPACR_EL1_SMEN_EL1EN | CPACR_EL1_SMEN_EL0EN);
+		else
+			val |= CPTR_EL2_TSM;
+	}
+
 	if (!guest_owns_fp_regs(vcpu)) {
-		val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
+		if (has_hvhe())
+			val &= ~(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
+				 CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN);
+		else
+			val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
+
 		__activate_traps_fpsimd32(vcpu);
 	}
-	if (cpus_have_final_cap(ARM64_SME))
-		val |= CPTR_EL2_TSM;
 
 	write_sysreg(val, cptr_el2);
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
@@ -85,7 +96,6 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 static void __deactivate_traps(struct kvm_vcpu *vcpu)
 {
 	extern char __kvm_hyp_host_vector[];
-	u64 cptr;
 
 	___deactivate_traps(vcpu);
 
@@ -124,13 +134,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 		write_sysreg_s(val, SYS_HFGWTR_EL2);
 	}
 
-	cptr = CPTR_EL2_DEFAULT;
-	if (vcpu_has_sve(vcpu) && (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED))
-		cptr |= CPTR_EL2_TZ;
-	if (cpus_have_final_cap(ARM64_SME))
-		cptr &= ~CPTR_EL2_TSM;
-
-	write_sysreg(cptr, cptr_el2);
+	kvm_reset_cptr_el2(vcpu);
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
 }
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7acb87eaa092..7e7f7112e174 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -92,7 +92,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 		write_sysreg(read_sysreg(sctlr_el2) | SCTLR_ELx_ENTP2,
 			     sctlr_el2);
 
-	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
+	kvm_reset_cptr_el2(vcpu);
 
 	if (!arm64_kernel_unmapped_at_el0())
 		host_vectors = __this_cpu_read(this_cpu_vector);
-- 
2.34.1


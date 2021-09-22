Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C451741497C
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbhIVMsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbhIVMso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:48:44 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD19CC061756
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:13 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h4-20020a05620a244400b004334ede5036so9916304qkn.13
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CNIg0Z/y3l4EkHt/waE/OlJsRp9j4iTUXMTTmpM3yUM=;
        b=q+BZ0wa823wy5XPLOi0/rBFrYVDOcxn7q7aab0MQd5lwHCb2m3a298W6/lwcxi1KvT
         4nAOPtElTq1RzB5+NboqXxzBlzOoRCW7OiPMWqVimmmz+aATsrHiaNVjDhepvyNVI8P5
         NSp1ltOWcO2qXhH0gYjsVmE6RR6OIQlGetuixTcEELL5jZbw3ztnRDZHzvJgKvN635C3
         BvFXWkpUkBv4/krJCm0n++aNgOXm60Nl/hG9NS6jo/hkvXtP+kx/F51ajSXovIblfc15
         tjqZqr8udvh6XjUq+El9NQlFXP5pC4ov6DUhOqP9QVITwoEl/K9xUYE9x7AD4Sybu4W6
         w6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CNIg0Z/y3l4EkHt/waE/OlJsRp9j4iTUXMTTmpM3yUM=;
        b=Tc1CprUPLNccqmSZ3GYdYiFoz3u9y6fXc+eYWn8h4/tD785Urib/cz89bYApWU4n6B
         VsjW9RPco90LhQK6VbLYfKe7rVkWyFdeS0uFeCNXvBryeIJ3AHU+xYaL+I5i6+hr7S5n
         dWpX47vKw+O9FHmdhs3rEaY7xENc+OTy0/0KgAZ3J+JOd5murJm+BHaO3SCPeGOBbZaK
         0rAOseBQRruIVOgNwyXQwaFZW5wRPdgKKutneFkgwXzcX9kUBzNA0amfQh2oStLJd0gT
         xwzbRC8nkz3KANEq87Yjpyp5fIrhpeNkoxe7Y0wCIaB8cY8rlwitMPNcLeckbs1wdNKd
         ESkQ==
X-Gm-Message-State: AOAM533zA8AsNrQX9wcPQnzF1fnU6LhPCrQv2WH3oGlyLiGCfKoXdbW6
        a43ICdhpa5IRLFW3yJD7dVYvnr+OVQ==
X-Google-Smtp-Source: ABdhPJzOzxDncRyNDkp6CnLPon8viWc4tKadnPqLgmuGDubBlNsdaMJQ6Mx0DqekESIfQ+uNmBdqHwoeQg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:122e:: with SMTP id
 p14mr36432921qvv.57.1632314833014; Wed, 22 Sep 2021 05:47:13 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:46:55 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-4-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 03/12] KVM: arm64: Move early handlers to per-EC handlers
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

Simplify the early exception handling by slicing the gigantic decoding
tree into a more manageable set of functions, similar to what we have
in handle_exit.c.

This will also make the structure reusable for pKVM's own early exit
handling.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 160 ++++++++++++++----------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  17 +++
 arch/arm64/kvm/hyp/vhe/switch.c         |  17 +++
 3 files changed, 126 insertions(+), 68 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 54abc8298ec3..0397606c0951 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -136,16 +136,7 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 
 static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 {
-	u8 ec;
-	u64 esr;
-
-	esr = vcpu->arch.fault.esr_el2;
-	ec = ESR_ELx_EC(esr);
-
-	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
-		return true;
-
-	return __get_fault_info(esr, &vcpu->arch.fault);
+	return __get_fault_info(vcpu->arch.fault.esr_el2, &vcpu->arch.fault);
 }
 
 static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
@@ -166,8 +157,13 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
-/* Check for an FPSIMD/SVE trap and handle as appropriate */
-static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
+/*
+ * We trap the first access to the FP/SIMD to save the host context and
+ * restore the guest context lazily.
+ * If FP/SIMD is not implemented, handle the trap and inject an undefined
+ * instruction exception to the guest. Similarly for trapped SVE accesses.
+ */
+static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	bool sve_guest, sve_host;
 	u8 esr_ec;
@@ -185,9 +181,6 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	}
 
 	esr_ec = kvm_vcpu_trap_get_class(vcpu);
-	if (esr_ec != ESR_ELx_EC_FP_ASIMD &&
-	    esr_ec != ESR_ELx_EC_SVE)
-		return false;
 
 	/* Don't handle SVE traps for non-SVE vcpus here: */
 	if (!sve_guest && esr_ec != ESR_ELx_EC_FP_ASIMD)
@@ -325,7 +318,7 @@ static inline bool esr_is_ptrauth_trap(u32 esr)
 
 DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 
-static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
+static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	struct kvm_cpu_context *ctxt;
 	u64 val;
@@ -350,6 +343,87 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
+	    handle_tx2_tvm(vcpu))
+		return true;
+
+	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
+	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
+		return true;
+
+	return false;
+}
+
+static bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
+	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
+		return true;
+
+	return false;
+}
+
+static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (!__populate_fault_info(vcpu))
+		return true;
+
+	return false;
+}
+
+static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (!__populate_fault_info(vcpu))
+		return true;
+
+	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
+		bool valid;
+
+		valid = kvm_vcpu_trap_get_fault_type(vcpu) == FSC_FAULT &&
+			kvm_vcpu_dabt_isvalid(vcpu) &&
+			!kvm_vcpu_abt_issea(vcpu) &&
+			!kvm_vcpu_abt_iss1tw(vcpu);
+
+		if (valid) {
+			int ret = __vgic_v2_perform_cpuif_access(vcpu);
+
+			if (ret == 1)
+				return true;
+
+			/* Promote an illegal access to an SError.*/
+			if (ret == -1)
+				*exit_code = ARM_EXCEPTION_EL1_SERROR;
+		}
+	}
+
+	return false;
+}
+
+typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
+
+static const exit_handler_fn *kvm_get_exit_handler_array(void);
+
+/*
+ * Allow the hypervisor to handle the exit with an exit handler if it has one.
+ *
+ * Returns true if the hypervisor handled the exit, and control should go back
+ * to the guest, or false if it hasn't.
+ */
+static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	const exit_handler_fn *handlers = kvm_get_exit_handler_array();
+	exit_handler_fn fn;
+
+	fn = handlers[kvm_vcpu_trap_get_class(vcpu)];
+
+	if (fn)
+		return fn(vcpu, exit_code);
+
+	return false;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -384,59 +458,9 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (*exit_code != ARM_EXCEPTION_TRAP)
 		goto exit;
 
-	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
-	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
-	    handle_tx2_tvm(vcpu))
+	/* Check if there's an exit handler and allow it to handle the exit. */
+	if (kvm_hyp_handle_exit(vcpu, exit_code))
 		goto guest;
-
-	/*
-	 * We trap the first access to the FP/SIMD to save the host context
-	 * and restore the guest context lazily.
-	 * If FP/SIMD is not implemented, handle the trap and inject an
-	 * undefined instruction exception to the guest.
-	 * Similarly for trapped SVE accesses.
-	 */
-	if (__hyp_handle_fpsimd(vcpu))
-		goto guest;
-
-	if (__hyp_handle_ptrauth(vcpu))
-		goto guest;
-
-	if (!__populate_fault_info(vcpu))
-		goto guest;
-
-	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
-		bool valid;
-
-		valid = kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW &&
-			kvm_vcpu_trap_get_fault_type(vcpu) == FSC_FAULT &&
-			kvm_vcpu_dabt_isvalid(vcpu) &&
-			!kvm_vcpu_abt_issea(vcpu) &&
-			!kvm_vcpu_abt_iss1tw(vcpu);
-
-		if (valid) {
-			int ret = __vgic_v2_perform_cpuif_access(vcpu);
-
-			if (ret == 1)
-				goto guest;
-
-			/* Promote an illegal access to an SError.*/
-			if (ret == -1)
-				*exit_code = ARM_EXCEPTION_EL1_SERROR;
-
-			goto exit;
-		}
-	}
-
-	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
-	    (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 ||
-	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_CP15_32)) {
-		int ret = __vgic_v3_perform_cpuif_access(vcpu);
-
-		if (ret == 1)
-			goto guest;
-	}
-
 exit:
 	/* Return to the host kernel and handle the exit */
 	return false;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index a34b01cc8ab9..c52d580708e0 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -158,6 +158,23 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+static const exit_handler_fn hyp_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_CP15_64]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg,
+	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
+	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
+	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
+	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
+};
+
+static const exit_handler_fn *kvm_get_exit_handler_array(void)
+{
+	return hyp_exit_handlers;
+}
+
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index ded2c66675f0..0e0d342358f7 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -96,6 +96,23 @@ void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 	__deactivate_traps_common(vcpu);
 }
 
+static const exit_handler_fn hyp_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_CP15_64]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg,
+	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
+	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
+	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
+	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
+};
+
+static const exit_handler_fn *kvm_get_exit_handler_array(void)
+{
+	return hyp_exit_handlers;
+}
+
 /* Switch to the guest for VHE systems running in EL2 */
 static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
-- 
2.33.0.464.g1972c5931b-goog


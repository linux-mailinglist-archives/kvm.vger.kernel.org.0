Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61A2426E35
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243210AbhJHQAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhJHQAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:00:37 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE25C061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:58:41 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id c19-20020ac81e93000000b002a71180fd3dso8074946qtm.1
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ggCms3/HNX7c/KS1nwwEKEZy7phtvlo/XJOcqPY/Coc=;
        b=dj0FbJrW9qR3HI7ycwWBz5odoQBshr7lO2MNiWvqDlQbLTLiI5qaI3pL6rKyP/XkMv
         Pj0+Dl9esUMlXc74/+/bJASkOUMEYzIGRoFRVZJl219IsZUYR/84TsFGpCYLsLAxijPR
         XaeXwywiDw7qmvGK7uWLT//3i3+oRvnzhIQq5jCn1mIwrP+shSQRq4xHEgOJTvR53oXX
         IYsgne2lMUeHNj4M64mcWkdZBQ73q0j6iJjUSuWLxviar8bOL7LJtCqPMlGG9dxL3V/0
         Q+vWdPOv1kU+Li3aCifDiJVt2PFEVen4jKwKSp0KzTlABgKxY2PQecVJMWqBt1g/Hv6V
         e0cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ggCms3/HNX7c/KS1nwwEKEZy7phtvlo/XJOcqPY/Coc=;
        b=qXKHdIG3xPnXigHwWpT8IfdPEc9sloId0RIInhRrWqRxzLTwI3dGV+Mc8FzXuEQmZA
         H/iUDvPlc5GaJX5wHffdtT00OuOZ4pK36PYqIzeWWk7l6BOySilKrOfumHRCXA7cOO/c
         UaoRyo1f0W1pOe1fa4GbWZnk6EkFA6cnjAszg1f6g3l18/ULGu0udExMG2zNXBWMorgZ
         yoAAKw5ErThdTmqhp0HNVWLYS0sSVrOzS4lnfXKZ5sp6tWEmHjfIe/7jK09j6TEcOeQB
         eOqE6qCF/7/XgkBTHHx4ZygzKkR4nT5uptz9atMIag2JkloZNuKJi7tRPLEZ/HtPLeTs
         /ABg==
X-Gm-Message-State: AOAM533eWq2LtklWVWUsMzj+CUeRSF4eEuvl+idVJUyq8FPP9tgRJlhS
        iFBbgBv90XaSCcutLaS7kF8ZZ3c1qQ==
X-Google-Smtp-Source: ABdhPJxO+qsJkrxL2sW6c9i/7v+FQbqDmwKSD0sbxZx6FeIWMv28mjjL0bpnzaGQnGxpdo7MlweMk/GxiA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:622a:1646:: with SMTP id
 y6mr12541246qtj.146.1633708720872; Fri, 08 Oct 2021 08:58:40 -0700 (PDT)
Date:   Fri,  8 Oct 2021 16:58:24 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-4-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 03/11] KVM: arm64: Move early handlers to per-EC handlers
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
 arch/arm64/kvm/hyp/nvhe/switch.c        |  16 +++
 arch/arm64/kvm/hyp/vhe/switch.c         |  16 +++
 3 files changed, 124 insertions(+), 68 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 54abc8298ec3..1e4177322be7 100644
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
+static bool kvm_hyp_handle_cp15_32(struct kvm_vcpu *vcpu, u64 *exit_code)
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
index a34b01cc8ab9..4f3992a1aabd 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -158,6 +158,22 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+static const exit_handler_fn hyp_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
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
index ded2c66675f0..9aedc8afc8b9 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -96,6 +96,22 @@ void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 	__deactivate_traps_common(vcpu);
 }
 
+static const exit_handler_fn hyp_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
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
2.33.0.882.g93a45727a2-goog


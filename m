Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00928127CDB
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 15:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfLTOas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 09:30:48 -0500
Received: from foss.arm.com ([217.140.110.172]:51232 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbfLTOaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:46 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CFB930E;
        Fri, 20 Dec 2019 06:30:45 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C12B3F718;
        Fri, 20 Dec 2019 06:30:43 -0800 (PST)
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 06/18] arm64: KVM: split debug save restore across vm/traps activation
Date:   Fri, 20 Dec 2019 14:30:13 +0000
Message-Id: <20191220143025.33853-7-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

If we enable profiling buffer controls at EL1 generate a trap exception
to EL2, it also changes profiling buffer to use EL1&0 stage 1 translation
regime in case of VHE. To support SPE both in the guest and host, we
need to first stop profiling and flush the profiling buffers before
we activate/switch vm or enable/disable the traps.

In prepartion to do that, lets split the debug save restore functionality
into 4 steps:
1. debug_save_host_context - saves the host context
2. debug_restore_guest_context - restore the guest context
3. debug_save_guest_context - saves the guest context
4. debug_restore_host_context - restores the host context

Lets rename existing __debug_switch_to_{host,guest} to make sure it's
aligned to the above and just add the place holders for new ones getting
added here as we need them to support SPE in guests.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  6 ++++--
 arch/arm64/kvm/hyp/debug-sr.c    | 25 ++++++++++++++++---------
 arch/arm64/kvm/hyp/switch.c      | 12 ++++++++----
 3 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 97f21cc66657..011e7963f772 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -69,8 +69,10 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
 void __sysreg32_save_state(struct kvm_vcpu *vcpu);
 void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
-void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
-void __debug_switch_to_host(struct kvm_vcpu *vcpu);
+void __debug_save_host_context(struct kvm_vcpu *vcpu);
+void __debug_restore_guest_context(struct kvm_vcpu *vcpu);
+void __debug_save_guest_context(struct kvm_vcpu *vcpu);
+void __debug_restore_host_context(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 98be2f11c16c..c803daebd596 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -168,20 +168,13 @@ static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
 	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
 }
 
-void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+void __hyp_text __debug_restore_guest_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	/*
-	 * Non-VHE: Disable and flush SPE data generation
-	 * VHE: The vcpu can run, but it can't hide.
-	 */
-	if (!has_vhe())
-		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
-
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
@@ -194,7 +187,7 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
 }
 
-void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
+void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -218,6 +211,20 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
+void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Non-VHE: Disable and flush SPE data generation
+	 * VHE: The vcpu can run, but it can't hide.
+	 */
+	if (!has_vhe())
+		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
+}
+
+void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
+{
+}
+
 u32 __hyp_text __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 250f13910882..67b7c160f65b 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -626,6 +626,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	sysreg_save_host_state_vhe(host_ctxt);
+	__debug_save_host_context(vcpu);
 
 	/*
 	 * ARM erratum 1165522 requires us to configure both stage 1 and
@@ -642,7 +643,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__activate_traps(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
-	__debug_switch_to_guest(vcpu);
+	__debug_restore_guest_context(vcpu);
 
 	__set_guest_arch_workaround_state(vcpu);
 
@@ -656,6 +657,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__set_host_arch_workaround_state(vcpu);
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
+	__debug_save_guest_context(vcpu);
 
 	__deactivate_traps(vcpu);
 
@@ -664,7 +666,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
-	__debug_switch_to_host(vcpu);
+	__debug_restore_host_context(vcpu);
 
 	return exit_code;
 }
@@ -698,6 +700,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
 
 	__sysreg_save_state_nvhe(host_ctxt);
+	__debug_save_host_context(vcpu);
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
@@ -716,7 +719,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps(vcpu);
 
-	__debug_switch_to_guest(vcpu);
+	__debug_restore_guest_context(vcpu);
 
 	__set_guest_arch_workaround_state(vcpu);
 
@@ -730,6 +733,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__set_host_arch_workaround_state(vcpu);
 
 	__sysreg_save_state_nvhe(guest_ctxt);
+	__debug_save_guest_context(vcpu);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
@@ -746,7 +750,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_switch_to_host(vcpu);
+	__debug_restore_host_context(vcpu);
 
 	if (pmu_switch_needed)
 		__pmu_switch_to_host(host_ctxt);
-- 
2.21.0


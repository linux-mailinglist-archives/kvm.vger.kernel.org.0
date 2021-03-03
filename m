Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8986F32C68B
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355496AbhCDA3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234325AbhCCQqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 11:46:54 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD85E64EBB;
        Wed,  3 Mar 2021 16:45:11 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lHUcX-00H3NQ-JX; Wed, 03 Mar 2021 16:45:09 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     kernel-team@android.com, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH] KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
Date:   Wed,  3 Mar 2021 16:45:05 +0000
Message-Id: <20210303164505.68492-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It recently became apparent that the ARMv8 architecture has interesting
rules regarding attributes being used when fetching instructions
if the MMU is off at Stage-1.

In this situation, the CPU is allowed to fetch from the PoC and
allocate into the I-cache (unless the memory is mapped with
the XN attribute at Stage-2).

If we transpose this to vcpus sharing a single physical CPU,
it is possible for a vcpu running with its MMU off to influence
another vcpu running with its MMU on, as the latter is expected to
fetch from the PoU (and self-patching code doesn't flush below that
level).

In order to solve this, reuse the vcpu-private TLB invalidation
code to apply the same policy to the I-cache, nuking it every time
the vcpu runs on a physical CPU that ran another vcpu of the same
VM in the past.

This involve renaming __kvm_tlb_flush_local_vmid() to
__kvm_flush_cpu_context(), and inserting a local i-cache invalidation
there.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h   | 4 ++--
 arch/arm64/kvm/arm.c               | 7 ++++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 +++---
 arch/arm64/kvm/hyp/nvhe/tlb.c      | 3 ++-
 arch/arm64/kvm/hyp/vhe/tlb.c       | 3 ++-
 5 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9c0e396dd03f..a7ab84f781f7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -47,7 +47,7 @@
 #define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		2
 #define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		3
 #define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		4
-#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_local_vmid	5
+#define __KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context		5
 #define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		6
 #define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			7
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config		8
@@ -183,10 +183,10 @@ DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
 #define __bp_harden_hyp_vecs	CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
 
 extern void __kvm_flush_vm_context(void);
+extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fc4c95dd2d26..7f06ba76698d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -385,11 +385,16 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
 	/*
+	 * We guarantee that both TLBs and I-cache are private to each
+	 * vcpu. If detecting that a vcpu from the same VM has
+	 * previously run on the same physical CPU, call into the
+	 * hypervisor code to nuke the relevant contexts.
+	 *
 	 * We might get preempted before the vCPU actually runs, but
 	 * over-invalidation doesn't affect correctness.
 	 */
 	if (*last_ran != vcpu->vcpu_id) {
-		kvm_call_hyp(__kvm_tlb_flush_local_vmid, mmu);
+		kvm_call_hyp(__kvm_flush_cpu_context, mmu);
 		*last_ran = vcpu->vcpu_id;
 	}
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 8f129968204e..936328207bde 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -46,11 +46,11 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 }
 
-static void handle___kvm_tlb_flush_local_vmid(struct kvm_cpu_context *host_ctxt)
+static void handle___kvm_flush_cpu_context(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
 
-	__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
+	__kvm_flush_cpu_context(kern_hyp_va(mmu));
 }
 
 static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
@@ -115,7 +115,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
-	HANDLE_FUNC(__kvm_tlb_flush_local_vmid),
+	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__kvm_enable_ssbs),
 	HANDLE_FUNC(__vgic_v3_get_gic_config),
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index fbde89a2c6e8..229b06748c20 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -123,7 +123,7 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
+void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
@@ -131,6 +131,7 @@ void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalle1);
+	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index fd7895945bbc..66f17349f0c3 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -127,7 +127,7 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
+void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
@@ -135,6 +135,7 @@ void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalle1);
+	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 
-- 
2.30.0


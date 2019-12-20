Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97FBD127D4B
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 15:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfLTOav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 09:30:51 -0500
Received: from foss.arm.com ([217.140.110.172]:51258 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbfLTOau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDD54106F;
        Fri, 20 Dec 2019 06:30:49 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 113893F718;
        Fri, 20 Dec 2019 06:30:47 -0800 (PST)
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 08/18] arm64: KVM: add support to save/restore SPE profiling buffer controls
Date:   Fri, 20 Dec 2019 14:30:15 +0000
Message-Id: <20191220143025.33853-9-andrew.murray@arm.com>
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

Currently since we don't support profiling using SPE in the guests,
we just save the PMSCR_EL1, flush the profiling buffers and disable
sampling. However in order to support simultaneous sampling both in
the host and guests, we need to save and reatore the complete SPE
profiling buffer controls' context.

Let's add the support for the same and keep it disabled for now.
We can enable it conditionally only if guests are allowed to use
SPE.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
[ Clear PMBSR bit when saving state to prevent spurious interrupts ]
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/kvm/hyp/debug-sr.c | 51 +++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 8a70a493345e..12429b212a3a 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -85,7 +85,8 @@
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
+static void __hyp_text
+__debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
 {
 	u64 reg;
 
@@ -102,22 +103,46 @@ static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
 	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
 		return;
 
-	/* No; is the host actually using the thing? */
-	reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
-	if (!(reg & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)))
+	/* Save the control register and disable data generation */
+	ctxt->sys_regs[PMSCR_EL1] = read_sysreg_el1(SYS_PMSCR);
+
+	if (!ctxt->sys_regs[PMSCR_EL1])
 		return;
 
 	/* Yes; save the control register and disable data generation */
-	ctxt->sys_regs[PMSCR_EL1] = read_sysreg_el1(SYS_PMSCR);
 	write_sysreg_el1(0, SYS_PMSCR);
 	isb();
 
 	/* Now drain all buffered data to memory */
 	psb_csync();
 	dsb(nsh);
+
+	if (!full_ctxt)
+		return;
+
+	ctxt->sys_regs[PMBLIMITR_EL1] = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	write_sysreg_s(0, SYS_PMBLIMITR_EL1);
+
+	/*
+	 * As PMBSR is conditionally restored when returning to the host we
+	 * must ensure the service bit is unset here to prevent a spurious
+	 * host SPE interrupt from being raised.
+	 */
+	ctxt->sys_regs[PMBSR_EL1] = read_sysreg_s(SYS_PMBSR_EL1);
+	write_sysreg_s(0, SYS_PMBSR_EL1);
+
+	isb();
+
+	ctxt->sys_regs[PMSICR_EL1] = read_sysreg_s(SYS_PMSICR_EL1);
+	ctxt->sys_regs[PMSIRR_EL1] = read_sysreg_s(SYS_PMSIRR_EL1);
+	ctxt->sys_regs[PMSFCR_EL1] = read_sysreg_s(SYS_PMSFCR_EL1);
+	ctxt->sys_regs[PMSEVFR_EL1] = read_sysreg_s(SYS_PMSEVFR_EL1);
+	ctxt->sys_regs[PMSLATFR_EL1] = read_sysreg_s(SYS_PMSLATFR_EL1);
+	ctxt->sys_regs[PMBPTR_EL1] = read_sysreg_s(SYS_PMBPTR_EL1);
 }
 
-static void __hyp_text __debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt)
+static void __hyp_text
+__debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
 {
 	if (!ctxt->sys_regs[PMSCR_EL1])
 		return;
@@ -126,6 +151,16 @@ static void __hyp_text __debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt)
 	isb();
 
 	/* Re-enable data generation */
+	if (full_ctxt) {
+		write_sysreg_s(ctxt->sys_regs[PMBPTR_EL1], SYS_PMBPTR_EL1);
+		write_sysreg_s(ctxt->sys_regs[PMBLIMITR_EL1], SYS_PMBLIMITR_EL1);
+		write_sysreg_s(ctxt->sys_regs[PMSFCR_EL1], SYS_PMSFCR_EL1);
+		write_sysreg_s(ctxt->sys_regs[PMSEVFR_EL1], SYS_PMSEVFR_EL1);
+		write_sysreg_s(ctxt->sys_regs[PMSLATFR_EL1], SYS_PMSLATFR_EL1);
+		write_sysreg_s(ctxt->sys_regs[PMSIRR_EL1], SYS_PMSIRR_EL1);
+		write_sysreg_s(ctxt->sys_regs[PMSICR_EL1], SYS_PMSICR_EL1);
+		write_sysreg_s(ctxt->sys_regs[PMBSR_EL1], SYS_PMBSR_EL1);
+	}
 	write_sysreg_el1(ctxt->sys_regs[PMSCR_EL1], SYS_PMSCR);
 }
 
@@ -198,7 +233,7 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	if (!has_vhe())
-		__debug_restore_spe_nvhe(host_ctxt);
+		__debug_restore_spe_nvhe(host_ctxt, false);
 
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
@@ -222,7 +257,7 @@ void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
 
 	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
 	if (!has_vhe())
-		__debug_save_spe_nvhe(host_ctxt);
+		__debug_save_spe_nvhe(host_ctxt, false);
 }
 
 void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
-- 
2.21.0


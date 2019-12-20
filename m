Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D237C127D55
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 15:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfLTOc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 09:32:58 -0500
Received: from foss.arm.com ([217.140.110.172]:51246 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbfLTOas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:48 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B549531B;
        Fri, 20 Dec 2019 06:30:47 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DCF893F718;
        Fri, 20 Dec 2019 06:30:45 -0800 (PST)
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 07/18] arm64: KVM/debug: drop pmscr_el1 and use sys_regs[PMSCR_EL1] in kvm_cpu_context
Date:   Fri, 20 Dec 2019 14:30:14 +0000
Message-Id: <20191220143025.33853-8-andrew.murray@arm.com>
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

kvm_cpu_context now has support to stash the complete SPE buffer control
context. We no longer need the pmscr_el1 kvm_vcpu_arch and it can be
dropped.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/hyp/debug-sr.c     | 26 +++++++++++++++-----------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9eb85f14df90..333c6491bec7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -307,8 +307,6 @@ struct kvm_vcpu_arch {
 	struct {
 		/* {Break,watch}point registers */
 		struct kvm_guest_debug_arch regs;
-		/* Statistical profiling extension */
-		u64 pmscr_el1;
 	} host_debug_state;
 
 	/* VGIC state */
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index c803daebd596..8a70a493345e 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -85,19 +85,19 @@
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
+static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
 {
 	u64 reg;
 
 	/* Clear pmscr in case of early return */
-	*pmscr_el1 = 0;
+	ctxt->sys_regs[PMSCR_EL1] = 0;
 
 	/* SPE present on this CPU? */
 	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
 						  ID_AA64DFR0_PMSVER_SHIFT))
 		return;
 
-	/* Yes; is it owned by EL3? */
+	/* Yes; is it owned by higher EL? */
 	reg = read_sysreg_s(SYS_PMBIDR_EL1);
 	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
 		return;
@@ -108,7 +108,7 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 		return;
 
 	/* Yes; save the control register and disable data generation */
-	*pmscr_el1 = read_sysreg_el1(SYS_PMSCR);
+	ctxt->sys_regs[PMSCR_EL1] = read_sysreg_el1(SYS_PMSCR);
 	write_sysreg_el1(0, SYS_PMSCR);
 	isb();
 
@@ -117,16 +117,16 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 	dsb(nsh);
 }
 
-static void __hyp_text __debug_restore_spe_nvhe(u64 pmscr_el1)
+static void __hyp_text __debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt)
 {
-	if (!pmscr_el1)
+	if (!ctxt->sys_regs[PMSCR_EL1])
 		return;
 
 	/* The host page table is installed, but not yet synchronised */
 	isb();
 
 	/* Re-enable data generation */
-	write_sysreg_el1(pmscr_el1, SYS_PMSCR);
+	write_sysreg_el1(ctxt->sys_regs[PMSCR_EL1], SYS_PMSCR);
 }
 
 static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
@@ -194,14 +194,15 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	guest_ctxt = &vcpu->arch.ctxt;
+
 	if (!has_vhe())
-		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
+		__debug_restore_spe_nvhe(host_ctxt);
 
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
-	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
 
@@ -217,8 +218,11 @@ void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
 	 * Non-VHE: Disable and flush SPE data generation
 	 * VHE: The vcpu can run, but it can't hide.
 	 */
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
 	if (!has_vhe())
-		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
+		__debug_save_spe_nvhe(host_ctxt);
 }
 
 void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
-- 
2.21.0


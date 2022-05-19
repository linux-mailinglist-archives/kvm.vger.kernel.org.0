Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE4E52D4EB
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbiESNr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236927AbiESNrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:47:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1243029820
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 930AA6179E
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E55C34115;
        Thu, 19 May 2022 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968011;
        bh=CGHMgaYd98aExBB2QN4A0HjGqijaiRCqy9ZKGnJWM2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vu8hMY4BNL+I7rSqNG7qlHHdiQsxFHJziw4u0r/YWV9n7VNCmU6E+R3DXhKztX+co
         jWKQKJtZHk17dPYa6kErbrLU1POxBtqh06pl4HU4ZXWj6YgTF4g7Cs5CRro6Si+NVj
         VR+M/DoZ33hDxyQxhnUuLtkicQ1p8mvM3E8jiQs4EW+g417IV2IZIho7shTCQQ2d/Q
         N9XKrpIVPAZGC/oGY5CsZc1awf4Zl5gov+mYnY/8dLbBkXuroST6I9hFOd4E0b2rF3
         Zn+S/Sl7G+YsQAJ4ukF6bgJc7RWHw1MNYQDxayl8v3AJ0EHi0zJP5OgH6lWGrUhx/O
         ocgXBbSBAgP+Q==
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
Subject: [PATCH 67/89] KVM: arm64: Add EL2 entry/exit handlers for pKVM guests
Date:   Thu, 19 May 2022 14:41:42 +0100
Message-Id: <20220519134204.5379-68-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Introduce separate El2 entry/exit handlers for protected and
non-protected guests under pKVM and hook up the protected handlers to
expose the minimum amount of data to the host required for EL1 handling.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 230 ++++++++++++++++++++++++++++-
 1 file changed, 228 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e987f34641dd..692576497ed9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -20,6 +20,8 @@
 
 #include <linux/irqchip/arm-gic-v3.h>
 
+#include "../../sys_regs.h"
+
 /*
  * Host FPSIMD state. Written to when the guest accesses its own FPSIMD state,
  * and read when the guest state is live and we need to switch back to the host.
@@ -34,6 +36,207 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
 typedef void (*shadow_entry_exit_handler_fn)(struct kvm_vcpu *, struct kvm_vcpu *);
 
+static void handle_pvm_entry_wfx(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+{
+	shadow_vcpu->arch.flags |= READ_ONCE(host_vcpu->arch.flags) &
+				   KVM_ARM64_INCREMENT_PC;
+}
+
+static void handle_pvm_entry_sys64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+{
+	unsigned long host_flags;
+
+	host_flags = READ_ONCE(host_vcpu->arch.flags);
+
+	/* Exceptions have priority on anything else */
+	if (host_flags & KVM_ARM64_PENDING_EXCEPTION) {
+		/* Exceptions caused by this should be undef exceptions. */
+		u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
+
+		__vcpu_sys_reg(shadow_vcpu, ESR_EL1) = esr;
+		shadow_vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
+					     KVM_ARM64_EXCEPT_MASK);
+		shadow_vcpu->arch.flags |= (KVM_ARM64_PENDING_EXCEPTION |
+					    KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
+					    KVM_ARM64_EXCEPT_AA64_EL1);
+
+		return;
+	}
+
+	if (host_flags & KVM_ARM64_INCREMENT_PC) {
+		shadow_vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
+					     KVM_ARM64_EXCEPT_MASK);
+		shadow_vcpu->arch.flags |= KVM_ARM64_INCREMENT_PC;
+	}
+
+	if (!esr_sys64_to_params(shadow_vcpu->arch.fault.esr_el2).is_write) {
+		/* r0 as transfer register between the guest and the host. */
+		u64 rt_val = READ_ONCE(host_vcpu->arch.ctxt.regs.regs[0]);
+		int rt = kvm_vcpu_sys_get_rt(shadow_vcpu);
+
+		vcpu_set_reg(shadow_vcpu, rt, rt_val);
+	}
+}
+
+static void handle_pvm_entry_iabt(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+{
+	unsigned long cpsr = *vcpu_cpsr(shadow_vcpu);
+	unsigned long host_flags;
+	u32 esr = ESR_ELx_IL;
+
+	host_flags = READ_ONCE(host_vcpu->arch.flags);
+
+	if (!(host_flags & KVM_ARM64_PENDING_EXCEPTION))
+		return;
+
+	/*
+	 * If the host wants to inject an exception, get syndrom and
+	 * fault address.
+	 */
+	if ((cpsr & PSR_MODE_MASK) == PSR_MODE_EL0t)
+		esr |= (ESR_ELx_EC_IABT_LOW << ESR_ELx_EC_SHIFT);
+	else
+		esr |= (ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT);
+
+	esr |= ESR_ELx_FSC_EXTABT;
+
+	__vcpu_sys_reg(shadow_vcpu, ESR_EL1) = esr;
+	__vcpu_sys_reg(shadow_vcpu, FAR_EL1) = kvm_vcpu_get_hfar(shadow_vcpu);
+
+	/* Tell the run loop that we want to inject something */
+	shadow_vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
+				     KVM_ARM64_EXCEPT_MASK);
+	shadow_vcpu->arch.flags |= (KVM_ARM64_PENDING_EXCEPTION |
+				    KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
+				    KVM_ARM64_EXCEPT_AA64_EL1);
+}
+
+static void handle_pvm_entry_dabt(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+{
+	unsigned long host_flags;
+	bool rd_update;
+
+	host_flags = READ_ONCE(host_vcpu->arch.flags);
+
+	/* Exceptions have priority over anything else */
+	if (host_flags & KVM_ARM64_PENDING_EXCEPTION) {
+		unsigned long cpsr = *vcpu_cpsr(shadow_vcpu);
+		u32 esr = ESR_ELx_IL;
+
+		if ((cpsr & PSR_MODE_MASK) == PSR_MODE_EL0t)
+			esr |= (ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT);
+		else
+			esr |= (ESR_ELx_EC_DABT_CUR << ESR_ELx_EC_SHIFT);
+
+		esr |= ESR_ELx_FSC_EXTABT;
+
+		__vcpu_sys_reg(shadow_vcpu, ESR_EL1) = esr;
+		__vcpu_sys_reg(shadow_vcpu, FAR_EL1) = kvm_vcpu_get_hfar(shadow_vcpu);
+		/* Tell the run loop that we want to inject something */
+		shadow_vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
+					     KVM_ARM64_EXCEPT_MASK);
+		shadow_vcpu->arch.flags |= (KVM_ARM64_PENDING_EXCEPTION |
+					    KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
+					    KVM_ARM64_EXCEPT_AA64_EL1);
+
+		/* Cancel potential in-flight MMIO */
+		shadow_vcpu->mmio_needed = false;
+		return;
+	}
+
+	/* Handle PC increment on MMIO */
+	if ((host_flags & KVM_ARM64_INCREMENT_PC) && shadow_vcpu->mmio_needed) {
+		shadow_vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
+					     KVM_ARM64_EXCEPT_MASK);
+		shadow_vcpu->arch.flags |= KVM_ARM64_INCREMENT_PC;
+	}
+
+	/* If we were doing an MMIO read access, update the register*/
+	rd_update = (shadow_vcpu->mmio_needed &&
+		     (host_flags & KVM_ARM64_INCREMENT_PC));
+	rd_update &= !kvm_vcpu_dabt_iswrite(shadow_vcpu);
+
+	if (rd_update) {
+		/* r0 as transfer register between the guest and the host. */
+		u64 rd_val = READ_ONCE(host_vcpu->arch.ctxt.regs.regs[0]);
+		int rd = kvm_vcpu_dabt_get_rd(shadow_vcpu);
+
+		vcpu_set_reg(shadow_vcpu, rd, rd_val);
+	}
+
+	shadow_vcpu->mmio_needed = false;
+}
+
+static void handle_pvm_exit_wfx(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+{
+	WRITE_ONCE(host_vcpu->arch.ctxt.regs.pstate,
+		   shadow_vcpu->arch.ctxt.regs.pstate & PSR_MODE_MASK);
+	WRITE_ONCE(host_vcpu->arch.fault.esr_el2,
+		   shadow_vcpu->arch.fault.esr_el2);
+}
+
+static void handle_pvm_exit_sys64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+{
+	u32 esr_el2 = shadow_vcpu->arch.fault.esr_el2;
+
+	/* r0 as transfer register between the guest and the host. */
+	WRITE_ONCE(host_vcpu->arch.fault.esr_el2,
+		   esr_el2 & ~ESR_ELx_SYS64_ISS_RT_MASK);
+
+	/* The mode is required for the host to emulate some sysregs */
+	WRITE_ONCE(host_vcpu->arch.ctxt.regs.pstate,
+		   shadow_vcpu->arch.ctxt.regs.pstate & PSR_MODE_MASK);
+
+	if (esr_sys64_to_params(esr_el2).is_write) {
+		int rt = kvm_vcpu_sys_get_rt(shadow_vcpu);
+		u64 rt_val = vcpu_get_reg(shadow_vcpu, rt);
+
+		WRITE_ONCE(host_vcpu->arch.ctxt.regs.regs[0], rt_val);
+	}
+}
+
+static void handle_pvm_exit_iabt(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+{
+	WRITE_ONCE(host_vcpu->arch.fault.esr_el2,
+		   shadow_vcpu->arch.fault.esr_el2);
+	WRITE_ONCE(host_vcpu->arch.fault.hpfar_el2,
+		   shadow_vcpu->arch.fault.hpfar_el2);
+}
+
+static void handle_pvm_exit_dabt(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+{
+	/*
+	 * For now, we treat all data aborts as MMIO since we have no knowledge
+	 * of the memslot configuration at EL2.
+	 */
+	shadow_vcpu->mmio_needed = true;
+
+	if (shadow_vcpu->mmio_needed) {
+		/* r0 as transfer register between the guest and the host. */
+		WRITE_ONCE(host_vcpu->arch.fault.esr_el2,
+			   shadow_vcpu->arch.fault.esr_el2 & ~ESR_ELx_SRT_MASK);
+
+		if (kvm_vcpu_dabt_iswrite(shadow_vcpu)) {
+			int rt = kvm_vcpu_dabt_get_rd(shadow_vcpu);
+			u64 rt_val = vcpu_get_reg(shadow_vcpu, rt);
+
+			WRITE_ONCE(host_vcpu->arch.ctxt.regs.regs[0], rt_val);
+		}
+	} else {
+		WRITE_ONCE(host_vcpu->arch.fault.esr_el2,
+			   shadow_vcpu->arch.fault.esr_el2 & ~ESR_ELx_ISV);
+	}
+
+	WRITE_ONCE(host_vcpu->arch.ctxt.regs.pstate,
+		   shadow_vcpu->arch.ctxt.regs.pstate & PSR_MODE_MASK);
+	WRITE_ONCE(host_vcpu->arch.fault.far_el2,
+		   shadow_vcpu->arch.fault.far_el2 & GENMASK(11, 0));
+	WRITE_ONCE(host_vcpu->arch.fault.hpfar_el2,
+		   shadow_vcpu->arch.fault.hpfar_el2);
+	WRITE_ONCE(__vcpu_sys_reg(host_vcpu, SCTLR_EL1),
+		   __vcpu_sys_reg(shadow_vcpu, SCTLR_EL1) & (SCTLR_ELx_EE | SCTLR_EL1_E0E));
+}
+
 static void handle_vm_entry_generic(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
 {
 	unsigned long host_flags = READ_ONCE(host_vcpu->arch.flags);
@@ -67,6 +270,22 @@ static void handle_vm_exit_abt(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shad
 		   shadow_vcpu->arch.fault.disr_el1);
 }
 
+static const shadow_entry_exit_handler_fn entry_pvm_shadow_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_WFx]		= handle_pvm_entry_wfx,
+	[ESR_ELx_EC_SYS64]		= handle_pvm_entry_sys64,
+	[ESR_ELx_EC_IABT_LOW]		= handle_pvm_entry_iabt,
+	[ESR_ELx_EC_DABT_LOW]		= handle_pvm_entry_dabt,
+};
+
+static const shadow_entry_exit_handler_fn exit_pvm_shadow_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_WFx]		= handle_pvm_exit_wfx,
+	[ESR_ELx_EC_SYS64]		= handle_pvm_exit_sys64,
+	[ESR_ELx_EC_IABT_LOW]		= handle_pvm_exit_iabt,
+	[ESR_ELx_EC_DABT_LOW]		= handle_pvm_exit_dabt,
+};
+
 static const shadow_entry_exit_handler_fn entry_vm_shadow_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= handle_vm_entry_generic,
 };
@@ -219,9 +438,13 @@ static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 		break;
 	case ARM_EXCEPTION_TRAP:
 		esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(shadow_vcpu));
-		ec_handler = entry_vm_shadow_handlers[esr_ec];
+		if (shadow_state_is_protected(shadow_state))
+			ec_handler = entry_pvm_shadow_handlers[esr_ec];
+		else
+			ec_handler = entry_vm_shadow_handlers[esr_ec];
 		if (ec_handler)
 			ec_handler(host_vcpu, shadow_vcpu);
+
 		break;
 	default:
 		BUG();
@@ -251,7 +474,10 @@ static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state,
 		break;
 	case ARM_EXCEPTION_TRAP:
 		esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(shadow_vcpu));
-		ec_handler = exit_vm_shadow_handlers[esr_ec];
+		if (shadow_state_is_protected(shadow_state))
+			ec_handler = exit_pvm_shadow_handlers[esr_ec];
+		else
+			ec_handler = exit_vm_shadow_handlers[esr_ec];
 		if (ec_handler)
 			ec_handler(host_vcpu, shadow_vcpu);
 		break;
-- 
2.36.1.124.g0e6072fb45-goog


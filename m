Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D3F1596D6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgBKRv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730345AbgBKRvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:55 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A10120578;
        Tue, 11 Feb 2020 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443514;
        bh=BVvwjLMYZVm7q18m99ri4igIk6u8itMAhMuWbJme6zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNA8U5qzuds0iaK+s1BHhLSVjmDMx3qEPwngRkQux8elYfDSmnI9G+Pz3OR5pwb/b
         0utYORagW5GDM/Lzv8khaDRPGq9fu1PC5cNYfYrTAmwMdLT8bEKCff+/tX+ZrWBBL5
         dwfzDsE4KdBkRCQ4rgDQnp5TDgVIbkjSiKDDJ6fg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgO-004O7k-C5; Tue, 11 Feb 2020 17:50:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 93/94] KVM: arm64: nv: Fast-track 'InHost' exception returns
Date:   Tue, 11 Feb 2020 17:49:37 +0000
Message-Id: <20200211174938.27809-94-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A significant part of the ARMv8.3-NV extension is to trap ERET
instructions so that the hypervisor gets a chance to switch
from a vEL2 L1 guest to an EL1 L2 guest.

But this also has the unfortunate consequence of trapping ERET
in unsuspecting circumstances, such as staying at vEL2 (interrupt
handling while being in the guest hypervisor), or returning to host
userspace in the case of a VHE guest.

Although we already make some effort to handle these ERET quicker
by not doing the put/load dance, it is still way too far down the
line for it to be efficient enough.

For these cases, it would ideal to ERET directly, no question asked.
Of course, we can't do that. But the next best thing is to do it as
early as possible, in fixup_guest_exit(), much as we would handle
FPSIMD exceptions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 26 ++--------------
 arch/arm64/kvm/hyp/switch.c     | 54 +++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 97af080b9b52..eef7394e5256 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -78,8 +78,7 @@ static u64 get_el2_except_vector(struct kvm_vcpu *vcpu,
 
 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 {
-	u64 spsr, elr, mode;
-	bool direct_eret;
+	u64 spsr, elr;
 
 	/*
 	 * Forward this trap to the virtual EL2 if the virtual
@@ -88,31 +87,10 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	if (forward_nv_traps(vcpu))
 		return;
 
-	/*
-	 * Going through the whole put/load motions is a waste of time
-	 * if this is a VHE guest hypervisor returning to its own
-	 * userspace, or the hypervisor performing a local exception
-	 * return. No need to save/restore registers, no need to
-	 * switch S2 MMU. Just do the canonical ERET.
-	 */
-	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
-	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
-
-	direct_eret  = (mode == PSR_MODE_EL0t &&
-			vcpu_el2_e2h_is_set(vcpu) &&
-			vcpu_el2_tge_is_set(vcpu));
-	direct_eret |= (mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t);
-
-	if (direct_eret) {
-		*vcpu_pc(vcpu) = vcpu_read_sys_reg(vcpu, ELR_EL2);
-		*vcpu_cpsr(vcpu) = spsr;
-		trace_kvm_nested_eret(vcpu, *vcpu_pc(vcpu), spsr);
-		return;
-	}
-
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
 
+	spsr = __vcpu_sys_reg(vcpu, SPSR_EL2);
 	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
 
 	trace_kvm_nested_eret(vcpu, elr, spsr);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 2eca04ca96b6..d8aae4b5f089 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -489,6 +489,57 @@ static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool __hyp_text __hyp_handle_eret(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+	u64 spsr, mode;
+
+	/*
+	 * Going through the whole put/load motions is a waste of time
+	 * if this is a VHE guest hypervisor returning to its own
+	 * userspace, or the hypervisor performing a local exception
+	 * return. No need to save/restore registers, no need to
+	 * switch S2 MMU. Just do the canonical ERET. Unless the trap
+	 * has to be forwarded further down the line, of course...
+	 */
+	if (kvm_vcpu_trap_get_class(vcpu) != ESR_ELx_EC_ERET)
+		return false;
+
+	/*
+	 * Let the trap forwarding be handled by the normal exception
+	 * handling code.
+	 */
+	if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV)
+		return false;
+
+	spsr = read_sysreg_el1(SYS_SPSR);
+	spsr = __fixup_spsr_el2_read(ctxt, spsr);
+	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
+
+	switch (mode) {
+	case PSR_MODE_EL0t:
+		if (!(vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)))
+			return false;
+		break;
+	case PSR_MODE_EL2t:
+		mode = PSR_MODE_EL1t;
+		break;
+	case PSR_MODE_EL2h:
+		mode = PSR_MODE_EL1h;
+		break;
+	default:
+		return false;
+	}
+
+	spsr = (spsr & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
+
+	write_sysreg_el2(spsr, SYS_SPSR);
+	write_sysreg_el2(read_sysreg_el1(SYS_ELR), SYS_ELR);
+
+	return true;
+}
+
+
 static bool __hyp_text handle_tx2_tvm(struct kvm_vcpu *vcpu)
 {
 	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_hsr(vcpu));
@@ -615,6 +666,9 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code,
 	if (__hyp_handle_fpsimd(vcpu))
 		return true;
 
+	if (__hyp_handle_eret(vcpu))
+		return true;
+
 	if (!__populate_fault_info(vcpu))
 		return true;
 
-- 
2.20.1


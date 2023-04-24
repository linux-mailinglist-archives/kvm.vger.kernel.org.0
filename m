Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F86D827A
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbjDEPsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239096AbjDEPsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:48:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D105FC3
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:47:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6EFB63F08
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A48EC433D2;
        Wed,  5 Apr 2023 15:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709610;
        bh=C193qCDjqiF5HkfsJlWly9Jsvkj9TvtpD7IYpBzHGpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZhoGiNOz1zaYAHslZ7h8cxSWTX0VfnaxUr3yFPWPMcMo8gTO6iGqwGPdbx61fSb4
         HnxtJ7xUxnRn5fuEnaisKTd/gLcBfnxaay8TWrIa3g5K8r9eTiJSyUWy00q+Truz+C
         KvSCbt2s3YACaxWuru0JozSu4s6cATY4GaEqGTTGcq15lyHsKSJ9lJnmmmq38lLS/F
         uGhIG1epigcI9mz9klLeje8ZXADc6dn6Xb/749CzBVZIkKW1pCShddFRatJEGJbdcl
         2LLbUTekm4WpAzfzS80X9fJth7r888gaOsUr0cuXiU0+yUsssCG3v1notbwoPCJhNH
         BBDhHG0dthOPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk5Fv-0062PV-UY;
        Wed, 05 Apr 2023 16:41:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v9 47/50] KVM: arm64: nv: Fast-track 'InHost' exception returns
Date:   Wed,  5 Apr 2023 16:40:05 +0100
Message-Id: <20230405154008.3552854-48-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230405154008.3552854-1-maz@kernel.org>
References: <20230405154008.3552854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 arch/arm64/kvm/emulate-nested.c | 29 +++------------------
 arch/arm64/kvm/hyp/vhe/switch.c | 46 +++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 555771e1260d..e2d23f624115 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -79,8 +79,7 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 
 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 {
-	u64 spsr, elr, mode;
-	bool direct_eret;
+	u64 spsr, elr;
 
 	/*
 	 * Forward this trap to the virtual EL2 if the virtual
@@ -89,33 +88,11 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
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
-	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
-
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
+	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
 	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
 
 	trace_kvm_nested_eret(vcpu, elr, spsr);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7682d2f13eaa..238c6613cf47 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -168,6 +168,51 @@ void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 	__deactivate_traps_common(vcpu);
 }
 
+static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+	u64 spsr, mode;
+
+	/*
+	 * Going through the whole put/load motions is a waste of time
+	 * if this is a VHE guest hypervisor returning to its own
+	 * userspace, or the hypervisor performing a local exception
+	 * return. No need to save/restore registers, no need to
+	 * switch S2 MMU. Just do the canonical ERET.
+	 *
+	 * Unless the trap has to be forwarded further down the line,
+	 * of course...
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
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
@@ -177,6 +222,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
+	[ESR_ELx_EC_ERET]		= kvm_hyp_handle_eret,
 };
 
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
-- 
2.34.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC4B1B44D1
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 14:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgDVMVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 08:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728480AbgDVMV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 08:21:26 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9531C221EB;
        Wed, 22 Apr 2020 12:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587558085;
        bh=w1KXX+6GQ7cFF1e8qmsBxy/daj02ed6N9gs8z88iNaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvbCvVFoWA8wdN7bYhHfDz+qVy9XmuiwXlaj+4iuz9iRlZTmaExStENHW7BUMfrYZ
         1uQeAjPpmi6SDLikBGz6QBGkX5BPP2ocl+W5FHHJt+YN3NzuaJpgLcXfLnxRDvbA5j
         UoUjWtcfVCUNnCiWoDlCBjiZPNy0jW6ElK/6rOpc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRE47-005UI7-VB; Wed, 22 Apr 2020 13:01:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 26/26] KVM: arm64: Parametrize exception entry with a target EL
Date:   Wed, 22 Apr 2020 13:00:50 +0100
Message-Id: <20200422120050.3693593-27-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We currently assume that an exception is delivered to EL1, always.
Once we emulate EL2, this no longer will be the case. To prepare
for this, add a target_mode parameter.

While we're at it, merge the computing of the target PC and PSTATE in
a single function that updates both PC and CPSR after saving their
previous values in the corresponding ELR/SPSR. This ensures that they
are updated in the correct order (a pretty common source of bugs...).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/inject_fault.c | 75 ++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index d3ebf8bca4b89..3dbcbc839b9c3 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -26,28 +26,12 @@ enum exception_type {
 	except_type_serror	= 0x180,
 };
 
-static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
-{
-	u64 exc_offset;
-
-	switch (*vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
-	case PSR_MODE_EL1t:
-		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
-		break;
-	case PSR_MODE_EL1h:
-		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
-		break;
-	case PSR_MODE_EL0t:
-		exc_offset = LOWER_EL_AArch64_VECTOR;
-		break;
-	default:
-		exc_offset = LOWER_EL_AArch32_VECTOR;
-	}
-
-	return vcpu_read_sys_reg(vcpu, VBAR_EL1) + exc_offset + type;
-}
-
 /*
+ * This performs the exception entry at a given EL (@target_mode), stashing PC
+ * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
+ * The EL passed to this function *must* be a non-secure, privileged mode with
+ * bit 0 being set (PSTATE.SP == 1).
+ *
  * When an exception is taken, most PSTATE fields are left unchanged in the
  * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
  * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
@@ -59,10 +43,35 @@ static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
  * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
  * MSB to LSB.
  */
-static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
+static void enter_exception(struct kvm_vcpu *vcpu, unsigned long target_mode,
+			    enum exception_type type)
 {
-	unsigned long sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
-	unsigned long old, new;
+	unsigned long sctlr, vbar, old, new, mode;
+	u64 exc_offset;
+
+	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
+
+	if      (mode == target_mode)
+		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
+	else if ((mode | 1) == target_mode)
+		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
+	else if (!(mode & PSR_MODE32_BIT))
+		exc_offset = LOWER_EL_AArch64_VECTOR;
+	else
+		exc_offset = LOWER_EL_AArch32_VECTOR;
+
+	switch (target_mode) {
+	case PSR_MODE_EL1h:
+		vbar = vcpu_read_sys_reg(vcpu, VBAR_EL1);
+		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
+		break;
+	default:
+		/* Don't do that */
+		BUG();
+	}
+
+	*vcpu_pc(vcpu) = vbar + exc_offset + type;
 
 	old = *vcpu_cpsr(vcpu);
 	new = 0;
@@ -105,9 +114,10 @@ static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
 	new |= PSR_I_BIT;
 	new |= PSR_F_BIT;
 
-	new |= PSR_MODE_EL1h;
+	new |= target_mode;
 
-	return new;
+	*vcpu_cpsr(vcpu) = new;
+	vcpu_write_spsr(vcpu, old);
 }
 
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
@@ -116,11 +126,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
-	vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
-	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
-
-	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
-	vcpu_write_spsr(vcpu, cpsr);
+	enter_exception(vcpu, PSR_MODE_EL1h, except_type_sync);
 
 	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
 
@@ -148,14 +154,9 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
-	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
-	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
-
-	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
-	vcpu_write_spsr(vcpu, cpsr);
+	enter_exception(vcpu, PSR_MODE_EL1h, except_type_sync);
 
 	/*
 	 * Build an unknown exception, depending on the instruction
-- 
2.26.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE70D159713
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgBKRwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:52:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbgBKRwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:52:50 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A4C4206D7;
        Tue, 11 Feb 2020 17:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443569;
        bh=uVpX/vFvfITJoEOTo3o/dRYhdnpA6CypgkaOmt8XOro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sr7BShg8r0uT6nqgL7R6MI/R+V05NAMbQFvBjYID+AFPqKlXBQPjnTHemmmMw3zqD
         efeSjMw8JR8+6GeQYAOOMoZBqmAyHgfz+YmlFVozZbAaF2mfUA3mrQaJ40xaFF2+UJ
         NT5R67NtSCEQzm7GfKkZIpR7MuAqURivYJAr8Ric=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zfg-004O7k-IA; Tue, 11 Feb 2020 17:50:04 +0000
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
Subject: [PATCH v2 19/94] KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
Date:   Tue, 11 Feb 2020 17:48:23 +0000
Message-Id: <20200211174938.27809-20-maz@kernel.org>
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

From: Christoffer Dall <christoffer.dall@linaro.org>

When running in virtual EL2 mode, we actually run the hardware in EL1
and therefore have to use the EL1 registers to ensure correct operation.

By setting the HCR.TVM and HCR.TVRM we ensure that the virtual EL2 mode
doesn't shoot itself in the foot when setting up what it believes to be
a different mode's system register state (for example when preparing to
switch to a VM).

We can leverage the existing sysregs infrastructure to support trapped
accesses to these registers.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/switch.c |  4 ++++
 arch/arm64/kvm/sys_regs.c   | 18 +++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index dfe8dd172512..48e738e90966 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -149,6 +149,10 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	if (cpus_have_const_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
 		hcr |= HCR_TVM;
 
+	/* Trap VM sysreg accesses if an EL2 guest is not using VHE. */
+	if (vcpu_mode_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
+		hcr |= HCR_TVM | HCR_TRVM;
+
 	write_sysreg(hcr, hcr_el2);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9b29ac37829b..702692f064f4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -440,8 +440,15 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
- * is set. If the guest enables the MMU, we stop trapping the VM
- * sys_regs and leave it in complete control of the caches.
+ * is set.
+ *
+ * This is set in two cases: either (1) we're running at vEL2, or (2)
+ * we're running at EL1 and the guest has its MMU off.
+ *
+ * (1) TVM is always set, as we need to virtualise some of the VM
+ * registers for the guest hypervisor
+ * (2) Oncethe guest enables the MMU, we stop trapping the VM sys_regs
+ * and leave it in complete control of the caches.
  */
 static bool access_vm_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
@@ -451,7 +458,12 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	u64 val;
 	int reg = r->reg;
 
-	BUG_ON(!p->is_write);
+	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
+
+	if (!p->is_write) {
+		p->regval = vcpu_read_sys_reg(vcpu, reg);
+		return true;
+	}
 
 	/* See the 32bit mapping in kvm_host.h */
 	if (p->is_aarch32)
-- 
2.20.1


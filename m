Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390692D612C
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392293AbgLJQG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:06:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390276AbgLJQF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 11:05:58 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA77A23EB0;
        Thu, 10 Dec 2020 16:05:31 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knON1-0008Di-9p; Thu, 10 Dec 2020 16:00:44 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v3 17/66] KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
Date:   Thu, 10 Dec 2020 15:59:13 +0000
Message-Id: <20201210160002.1407373-18-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

We can no longer blindly copy the VCPU's PSTATE into SPSR_EL2 and return
to the guest and vice versa when taking an exception to the hypervisor,
because we emulate virtual EL2 in EL1 and therefore have to translate
the mode field from EL2 to EL1 and vice versa.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 43 +++++++++++++++++++++-
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index e3901c73893e..92715fa01e88 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -51,10 +51,32 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, SPSR_EL1)	= read_sysreg_el1(SYS_SPSR);
 }
 
+static inline u64 from_hw_pstate(const struct kvm_cpu_context *ctxt)
+{
+	u64 reg = read_sysreg_el2(SYS_SPSR);
+
+	if (__is_hyp_ctxt(ctxt)) {
+		u64 mode = reg & (PSR_MODE_MASK | PSR_MODE32_BIT);
+
+		switch (mode) {
+		case PSR_MODE_EL1t:
+			mode = PSR_MODE_EL2t;
+			break;
+		case PSR_MODE_EL1h:
+			mode = PSR_MODE_EL2h;
+			break;
+		}
+
+		return (reg & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
+	}
+
+	return reg;
+}
+
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
-	ctxt->regs.pstate		= read_sysreg_el2(SYS_SPSR);
+	ctxt->regs.pstate		= from_hw_pstate(ctxt);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
 		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
@@ -131,9 +153,26 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
 	write_sysreg_el1(ctxt_sys_reg(ctxt, SPSR_EL1),	SYS_SPSR);
 }
 
+/* Read the VCPU state's PSTATE, but translate (v)EL2 to EL1. */
+static inline u64 to_hw_pstate(const struct kvm_cpu_context *ctxt)
+{
+	u64 mode = ctxt->regs.pstate & (PSR_MODE_MASK | PSR_MODE32_BIT);
+
+	switch (mode) {
+	case PSR_MODE_EL2t:
+		mode = PSR_MODE_EL1t;
+		break;
+	case PSR_MODE_EL2h:
+		mode = PSR_MODE_EL1h;
+		break;
+	}
+
+	return (ctxt->regs.pstate & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
+}
+
 static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 {
-	u64 pstate = ctxt->regs.pstate;
+	u64 pstate = to_hw_pstate(ctxt);
 	u64 mode = pstate & PSR_AA32_MODE_MASK;
 
 	/*
-- 
2.29.2


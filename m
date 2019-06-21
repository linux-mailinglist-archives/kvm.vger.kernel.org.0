Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D804E3E8
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfFUJjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:39:40 -0400
Received: from foss.arm.com ([217.140.110.172]:53994 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbfFUJjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:39:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 300FA147A;
        Fri, 21 Jun 2019 02:39:39 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFDFC3F246;
        Fri, 21 Jun 2019 02:39:37 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 17/59] KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
Date:   Fri, 21 Jun 2019 10:38:01 +0100
Message-Id: <20190621093843.220980-18-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

We can no longer blindly copy the VCPU's PSTATE into SPSR_EL2 and return
to the guest and vice versa when taking an exception to the hypervisor,
because we emulate virtual EL2 in EL1 and therefore have to translate
the mode field from EL2 to EL1 and vice versa.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 41 ++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 2abb9c3ff24f..ea800eed811d 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -120,10 +120,32 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 		__sysreg_save_vel1_state(ctxt);
 }
 
+static u64 __hyp_text from_hw_pstate(const struct kvm_cpu_context *ctxt)
+{
+	u64 reg = read_sysreg_el2(SYS_SPSR);
+
+	if (__is_hyp_ctxt(ctxt)) {
+		u64 mode = reg & PSR_MODE_MASK;
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
+		return (reg & ~PSR_MODE_MASK) | mode;
+	}
+
+	return reg;
+}
+
 static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->gp_regs.regs.pc		= read_sysreg_el2(SYS_ELR);
-	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(SYS_SPSR);
+	ctxt->gp_regs.regs.pstate	= from_hw_pstate(ctxt);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
 		ctxt->sys_regs[DISR_EL1] = read_sysreg_s(SYS_VDISR_EL2);
@@ -288,10 +310,25 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 		__sysreg_restore_vel1_state(ctxt);
 }
 
+/* Read the VCPU state's PSTATE, but translate (v)EL2 to EL1. */
+static u64 __hyp_text to_hw_pstate(const struct kvm_cpu_context *ctxt)
+{
+	u64 mode = ctxt->gp_regs.regs.pstate & PSR_MODE_MASK;
+
+	switch (mode) {
+	case PSR_MODE_EL2t:
+		mode = PSR_MODE_EL1t;
+	case PSR_MODE_EL2h:
+		mode = PSR_MODE_EL1h;
+	}
+
+	return (ctxt->gp_regs.regs.pstate & ~PSR_MODE_MASK) | mode;
+}
+
 static void __hyp_text
 __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 {
-	u64 pstate = ctxt->gp_regs.regs.pstate;
+	u64 pstate = to_hw_pstate(ctxt);
 	u64 mode = pstate & PSR_AA32_MODE_MASK;
 
 	/*
-- 
2.20.1


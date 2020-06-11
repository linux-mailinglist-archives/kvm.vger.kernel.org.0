Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4D91F6459
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 11:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgFKJKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 05:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgFKJKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 05:10:11 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2041520835;
        Thu, 11 Jun 2020 09:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591866611;
        bh=yOm45AD9t0v2jikTpfEmX/BTUdf7/lOJLGc3lka2zE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6dqOHtIIKA2gHtH04eKiOqlfR6ESJ+c79VJUglnFaf3w2scE1BB6IbDiTI6cJN71
         aKCCcBsNmSa+Ho/eV+3DmDmS/YRGTnZY2GEvmZpyNRvtV1zLNXASV3+KTHaQ5r4GeH
         +xRa4KPDBUoZSMCHob1h1eQjKLOufH4lqGpeYUfo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jjJDt-0022ZT-M6; Thu, 11 Jun 2020 10:10:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/11] KVM: arm64: Stop save/restoring ACTLR_EL1
Date:   Thu, 11 Jun 2020 10:09:49 +0100
Message-Id: <20200611090956.1537104-5-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611090956.1537104-1-maz@kernel.org>
References: <20200611090956.1537104-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, ascull@google.com, james.morse@arm.com, mark.rutland@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: James Morse <james.morse@arm.com>

KVM sets HCR_EL2.TACR via HCR_GUEST_FLAGS. This means ACTLR* accesses
from the guest are always trapped, and always return the value in the
sys_regs array.

The guest can't change the value of these registers, so we are
save restoring the reset value, which came from the host.

Stop save/restoring this register. Keep the storage for this register
in sys_regs[] as this is how the value is exposed to user-space,
removing it would break migration.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200529150656.7339-4-james.morse@arm.com
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 2 --
 arch/arm64/kvm/sys_regs.c      | 2 --
 2 files changed, 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 6d2df9fe0b5d..0d60e6ee96b2 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -39,7 +39,6 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
 	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(SYS_SCTLR);
-	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
 	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(SYS_CPACR);
 	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(SYS_TTBR0);
 	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(SYS_TTBR1);
@@ -122,7 +121,6 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 		isb();
 	}
 
-	write_sysreg(ctxt->sys_regs[ACTLR_EL1],		actlr_el1);
 	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	SYS_CPACR);
 	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
 	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 12f8d57a3cb8..dfb966f3863a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -78,7 +78,6 @@ static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	switch (reg) {
 	case CSSELR_EL1:	*val = read_sysreg_s(SYS_CSSELR_EL1);	break;
 	case SCTLR_EL1:		*val = read_sysreg_s(SYS_SCTLR_EL12);	break;
-	case ACTLR_EL1:		*val = read_sysreg_s(SYS_ACTLR_EL1);	break;
 	case CPACR_EL1:		*val = read_sysreg_s(SYS_CPACR_EL12);	break;
 	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
 	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
@@ -118,7 +117,6 @@ static bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	switch (reg) {
 	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	break;
 	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	break;
-	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	break;
 	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	break;
 	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
 	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
-- 
2.26.2


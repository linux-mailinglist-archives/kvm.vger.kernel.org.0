Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6506F3C71AA
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 15:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbhGMOB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236693AbhGMOB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 10:01:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDACD60C3E;
        Tue, 13 Jul 2021 13:59:06 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m3IwD-00D5p8-D6; Tue, 13 Jul 2021 14:59:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>, kernel-team@android.com
Subject: [PATCH 2/3] KVM: arm64: Drop unnecessary masking of PMU registers
Date:   Tue, 13 Jul 2021 14:58:59 +0100
Message-Id: <20210713135900.1473057-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210713135900.1473057-1-maz@kernel.org>
References: <20210713135900.1473057-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, alexandre.chartre@oracle.com, robin.murphy@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We always sanitise our PMU sysreg on the write side, so there
is no need to do it on the read side as well.

Drop the unnecessary masking.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 3 +--
 arch/arm64/kvm/sys_regs.c | 6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f33825c995cb..fae4e95b586c 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -373,7 +373,6 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
-		reg &= kvm_pmu_valid_counter_mask(vcpu);
 	}
 
 	return reg;
@@ -569,7 +568,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
-		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
+		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
 	} else {
 		kvm_pmu_disable_counter_mask(vcpu, mask);
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 95ccb8f45409..7ead93a8d67f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -883,7 +883,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			kvm_pmu_disable_counter_mask(vcpu, val);
 		}
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
+		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 	}
 
 	return true;
@@ -907,7 +907,7 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			/* accessing PMINTENCLR_EL1 */
 			__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= ~val;
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
+		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 	}
 
 	return true;
@@ -929,7 +929,7 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			/* accessing PMOVSCLR_EL0 */
 			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~(p->regval & mask);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
+		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 	}
 
 	return true;
-- 
2.30.2


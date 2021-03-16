Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9824833DB85
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239362AbhCPRyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239369AbhCPRxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:53:38 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E0CD65104;
        Tue, 16 Mar 2021 17:53:38 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lMDmG-0021ao-9X; Tue, 16 Mar 2021 17:46:44 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
Subject: [PATCH 10/11] irqchip/apple-aic: Initialise SYS_APL_VM_TMR_FIQ_ENA_EL1 at boot time
Date:   Tue, 16 Mar 2021 17:46:15 +0000
Message-Id: <20210316174617.173033-11-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316174617.173033-1-maz@kernel.org>
References: <20210316174617.173033-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st, mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of masking the guest timer at the source, take advantage of
the SYS_APL_VM_TMR_FIQ_ENA_EL1 register and properly mask the
timers at init time.

For a good measure, add the missing ISB that synchronises all
the previous sysreg accesses.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-apple-aic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index 447c9e87f13a..26ee149dbae3 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -622,8 +622,8 @@ static int aic_init_cpu(unsigned int cpu)
 	/* Timer FIQs */
 	sysreg_clear_set(cntp_ctl_el0, 0, ARCH_TIMER_CTRL_IT_MASK);
 	sysreg_clear_set(cntv_ctl_el0, 0, ARCH_TIMER_CTRL_IT_MASK);
-	sysreg_clear_set_s(SYS_CNTP_CTL_EL02, 0, ARCH_TIMER_CTRL_IT_MASK);
-	sysreg_clear_set_s(SYS_CNTV_CTL_EL02, 0, ARCH_TIMER_CTRL_IT_MASK);
+	sysreg_clear_set_s(SYS_APL_VM_TMR_FIQ_ENA_EL1,
+			   VM_TMR_FIQ_ENABLE_V | VM_TMR_FIQ_ENABLE_P, 0);
 
 	/* PMC FIQ */
 	sysreg_clear_set_s(SYS_APL_PMCR0_EL1, PMCR0_IMODE | PMCR0_IACT,
@@ -633,6 +633,9 @@ static int aic_init_cpu(unsigned int cpu)
 	sysreg_clear_set_s(SYS_APL_UPMCR0_EL1, UPMCR0_IMODE,
 			   FIELD_PREP(UPMCR0_IMODE, UPMCR0_IMODE_OFF));
 
+	/* Commit all of the above */
+	isb();
+
 	/*
 	 * Make sure the kernel's idea of logical CPU order is the same as AIC's
 	 * If we ever end up with a mismatch here, we will have to introduce
-- 
2.29.2


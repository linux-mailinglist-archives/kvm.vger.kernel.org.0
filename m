Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F263233DB58
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbhCPRrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239239AbhCPRqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:46:45 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 707D665120;
        Tue, 16 Mar 2021 17:46:45 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lMDmF-0021ao-Nw; Tue, 16 Mar 2021 17:46:43 +0000
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
Subject: [PATCH 09/11] irqchip/apple-aic: Fix [un]masking of guest timers
Date:   Tue, 16 Mar 2021 17:46:14 +0000
Message-Id: <20210316174617.173033-10-maz@kernel.org>
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

As the enabling of the guest timer interrupts is done by
accessing a system register, make sure the access is correctly
synchronised.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-apple-aic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index ddc0856f36a5..447c9e87f13a 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -242,9 +242,11 @@ static void aic_fiq_mask(struct irq_data *d)
 	switch (d->hwirq) {
 	case AIC_TMR_GUEST_PHYS:
 		sysreg_clear_set_s(SYS_APL_VM_TMR_FIQ_ENA_EL1, VM_TMR_FIQ_ENABLE_P, 0);
+		isb();
 		break;
 	case AIC_TMR_GUEST_VIRT:
 		sysreg_clear_set_s(SYS_APL_VM_TMR_FIQ_ENA_EL1, VM_TMR_FIQ_ENABLE_V, 0);
+		isb();
 		break;
 	}
 }
@@ -254,9 +256,11 @@ static void aic_fiq_unmask(struct irq_data *d)
 	switch (d->hwirq) {
 	case AIC_TMR_GUEST_PHYS:
 		sysreg_clear_set_s(SYS_APL_VM_TMR_FIQ_ENA_EL1, 0, VM_TMR_FIQ_ENABLE_P);
+		isb();
 		break;
 	case AIC_TMR_GUEST_VIRT:
 		sysreg_clear_set_s(SYS_APL_VM_TMR_FIQ_ENA_EL1, 0, VM_TMR_FIQ_ENABLE_V);
+		isb();
 		break;
 	}
 }
-- 
2.29.2


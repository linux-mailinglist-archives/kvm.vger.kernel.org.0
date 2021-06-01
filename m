Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C0D3971B1
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 12:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhFAKmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 06:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233584AbhFAKl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 06:41:57 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57A90613B6;
        Tue,  1 Jun 2021 10:40:16 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lo1ok-004nNs-Kk; Tue, 01 Jun 2021 11:40:14 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
Subject: [PATCH v4 7/9] KVM: arm64: timer: Refactor IRQ configuration
Date:   Tue,  1 Jun 2021 11:40:03 +0100
Message-Id: <20210601104005.81332-8-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601104005.81332-1-maz@kernel.org>
References: <20210601104005.81332-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st, mark.rutland@arm.com, yuzenghui@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we are about to add some more things to the timer IRQ
configuration, move this code out of the main timer init code
into its own set of functions.

No functional changes.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 57 +++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index e2288b6bf435..3cd170388d88 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -973,6 +973,35 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
 	return 0;
 }
 
+static void kvm_irq_fixup_flags(unsigned int virq, u32 *flags)
+{
+	*flags = irq_get_trigger_type(virq);
+	if (*flags != IRQF_TRIGGER_HIGH && *flags != IRQF_TRIGGER_LOW) {
+		kvm_err("Invalid trigger for timer IRQ%d, assuming level low\n",
+			virq);
+		*flags = IRQF_TRIGGER_LOW;
+	}
+}
+
+static int kvm_irq_init(struct arch_timer_kvm_info *info)
+{
+	if (info->virtual_irq <= 0) {
+		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
+			info->virtual_irq);
+		return -ENODEV;
+	}
+
+	host_vtimer_irq = info->virtual_irq;
+	kvm_irq_fixup_flags(host_vtimer_irq, &host_vtimer_irq_flags);
+
+	if (info->physical_irq > 0) {
+		host_ptimer_irq = info->physical_irq;
+		kvm_irq_fixup_flags(host_ptimer_irq, &host_ptimer_irq_flags);
+	}
+
+	return 0;
+}
+
 int kvm_timer_hyp_init(bool has_gic)
 {
 	struct arch_timer_kvm_info *info;
@@ -986,22 +1015,11 @@ int kvm_timer_hyp_init(bool has_gic)
 		return -ENODEV;
 	}
 
-	/* First, do the virtual EL1 timer irq */
-
-	if (info->virtual_irq <= 0) {
-		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
-			info->virtual_irq);
-		return -ENODEV;
-	}
-	host_vtimer_irq = info->virtual_irq;
+	err = kvm_irq_init(info);
+	if (err)
+		return err;
 
-	host_vtimer_irq_flags = irq_get_trigger_type(host_vtimer_irq);
-	if (host_vtimer_irq_flags != IRQF_TRIGGER_HIGH &&
-	    host_vtimer_irq_flags != IRQF_TRIGGER_LOW) {
-		kvm_err("Invalid trigger for vtimer IRQ%d, assuming level low\n",
-			host_vtimer_irq);
-		host_vtimer_irq_flags = IRQF_TRIGGER_LOW;
-	}
+	/* First, do the virtual EL1 timer irq */
 
 	err = request_percpu_irq(host_vtimer_irq, kvm_arch_timer_handler,
 				 "kvm guest vtimer", kvm_get_running_vcpus());
@@ -1027,15 +1045,6 @@ int kvm_timer_hyp_init(bool has_gic)
 	/* Now let's do the physical EL1 timer irq */
 
 	if (info->physical_irq > 0) {
-		host_ptimer_irq = info->physical_irq;
-		host_ptimer_irq_flags = irq_get_trigger_type(host_ptimer_irq);
-		if (host_ptimer_irq_flags != IRQF_TRIGGER_HIGH &&
-		    host_ptimer_irq_flags != IRQF_TRIGGER_LOW) {
-			kvm_err("Invalid trigger for ptimer IRQ%d, assuming level low\n",
-				host_ptimer_irq);
-			host_ptimer_irq_flags = IRQF_TRIGGER_LOW;
-		}
-
 		err = request_percpu_irq(host_ptimer_irq, kvm_arch_timer_handler,
 					 "kvm guest ptimer", kvm_get_running_vcpus());
 		if (err) {
-- 
2.30.2


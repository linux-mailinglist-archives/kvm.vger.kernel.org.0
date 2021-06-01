Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCAA3971B6
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 12:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhFAKmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 06:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233632AbhFAKl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 06:41:58 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88DF2613C1;
        Tue,  1 Jun 2021 10:40:17 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lo1ol-004nNs-TW; Tue, 01 Jun 2021 11:40:16 +0100
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
Subject: [PATCH v4 9/9] irqchip/apple-aic: Advertise some level of vGICv3 compatibility
Date:   Tue,  1 Jun 2021 11:40:05 +0100
Message-Id: <20210601104005.81332-10-maz@kernel.org>
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

The CPUs in the Apple M1 SoC partially implement a virtual GICv3
CPU interface, although one that is incapable of HW deactivation
of interrupts, nor masking the maintenance interrupt.

Advertise the support to KVM.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-apple-aic.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index c179e27062fd..b8c06bd8659e 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -50,6 +50,7 @@
 #include <linux/cpuhotplug.h>
 #include <linux/io.h>
 #include <linux/irqchip.h>
+#include <linux/irqchip/arm-vgic-info.h>
 #include <linux/irqdomain.h>
 #include <linux/limits.h>
 #include <linux/of_address.h>
@@ -787,6 +788,12 @@ static int aic_init_cpu(unsigned int cpu)
 	return 0;
 }
 
+static struct gic_kvm_info vgic_info __initdata = {
+	.type			= GIC_V3,
+	.no_maint_irq_mask	= true,
+	.no_hw_deactivation	= true,
+};
+
 static int __init aic_of_ic_init(struct device_node *node, struct device_node *parent)
 {
 	int i;
@@ -843,6 +850,8 @@ static int __init aic_of_ic_init(struct device_node *node, struct device_node *p
 			  "irqchip/apple-aic/ipi:starting",
 			  aic_init_cpu, NULL);
 
+	vgic_set_kvm_info(&vgic_info);
+
 	pr_info("Initialized with %d IRQs, %d FIQs, %d vIPIs\n",
 		irqc->nr_hw, AIC_NR_FIQ, AIC_NR_SWIPI);
 
-- 
2.30.2


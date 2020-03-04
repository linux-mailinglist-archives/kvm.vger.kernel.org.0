Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 924D3179A1E
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 21:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388453AbgCDUgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 15:36:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388388AbgCDUge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 15:36:34 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40D902465D;
        Wed,  4 Mar 2020 20:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583354193;
        bh=n0pcf7YcYxmyQlB4S+lYiDAk0Lna0wYAp0XT2ZXgOkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dw9bBzcrzT2Jaf+4pBxkr/a9ZSZuLPeMgGnGRI9Jphqvu3McjWRo8rRkzz6VIKhtx
         J68JA08a2+ZbIW/DsX1vUkLLrL83C8zvlrzylcvVaBHrnWyJvCNJsyxkRDSEyDjjKu
         63BoyR2xzFV0L7N5fEVd4//pilVfzF+5l95b7gHM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j9aj8-00A59R-Hw; Wed, 04 Mar 2020 20:34:46 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 11/23] irqchip/gic-v4.1: Plumb get/set_irqchip_state SGI callbacks
Date:   Wed,  4 Mar 2020 20:33:18 +0000
Message-Id: <20200304203330.4967-12-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304203330.4967-1-maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To implement the get/set_irqchip_state callbacks (limited to the
PENDING state), we have to use a particular set of hacks:

- Reading the pending state is done by using a pair of new redistributor
  registers (GICR_VSGIR, GICR_VSGIPENDR), which allow the 16 interrupts
  state to be retrieved.
- Setting the pending state is done by generating it as we'd otherwise do
  for a guest (writing to GITS_SGIR).
- Clearing the pending state is done by emiting a VSGI command with the
  "clear" bit set.

This requires some interesting locking though:
- When talking to the redistributor, we must make sure that the VPE
  affinity doesn't change, hence taking the VPE lock.
- At the same time, we must ensure that nobody accesses the same
  redistributor's GICR_VSGI*R registers for a different VPE, which
  would corrupt the reading of the pending bits. We thus take the
  per-RD spinlock. Much fun.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 73 ++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v3.h | 14 ++++++
 2 files changed, 87 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index c93f178914ee..fb2b836c31ff 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3962,11 +3962,84 @@ static int its_sgi_set_affinity(struct irq_data *d,
 	return -EINVAL;
 }
 
+static int its_sgi_set_irqchip_state(struct irq_data *d,
+				     enum irqchip_irq_state which,
+				     bool state)
+{
+	if (which != IRQCHIP_STATE_PENDING)
+		return -EINVAL;
+
+	if (state) {
+		struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+		struct its_node *its = find_4_1_its();
+		u64 val;
+
+		val  = FIELD_PREP(GITS_SGIR_VPEID, vpe->vpe_id);
+		val |= FIELD_PREP(GITS_SGIR_VINTID, d->hwirq);
+		writeq_relaxed(val, its->sgir_base + GITS_SGIR - SZ_128K);
+	} else {
+		its_configure_sgi(d, true);
+	}
+
+	return 0;
+}
+
+static int its_sgi_get_irqchip_state(struct irq_data *d,
+				     enum irqchip_irq_state which, bool *val)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+	void __iomem *base;
+	unsigned long flags;
+	u32 count = 1000000;	/* 1s! */
+	u32 status;
+	int cpu;
+
+	if (which != IRQCHIP_STATE_PENDING)
+		return -EINVAL;
+
+	/*
+	 * Locking galore! We can race against two different events:
+	 *
+	 * - Concurent vPE affinity change: we must make sure it cannot
+         *   happen, or we'll talk to the wrong redistributor. This is
+         *   identical to what happens with vLPIs.
+	 *
+	 * - Concurrent VSGIPENDR access: As it involves accessing two
+         *   MMIO registers, this must be made atomic one way or another.
+	 */
+	cpu = vpe_to_cpuid_lock(vpe, &flags);
+	raw_spin_lock(&gic_data_rdist_cpu(cpu)->rd_lock);
+	base = gic_data_rdist_cpu(cpu)->rd_base + SZ_128K;
+	writel_relaxed(vpe->vpe_id, base + GICR_VSGIR);
+	do {
+		status = readl_relaxed(base + GICR_VSGIPENDR);
+		if (!(status & GICR_VSGIPENDR_BUSY))
+			goto out;
+
+		count--;
+		if (!count) {
+			pr_err_ratelimited("Unable to get SGI status\n");
+			goto out;
+		}
+		cpu_relax();
+		udelay(1);
+	} while(count);
+
+out:
+	raw_spin_unlock(&gic_data_rdist_cpu(cpu)->rd_lock);
+	vpe_to_cpuid_unlock(vpe, flags);
+	*val = !!(status & (1 << d->hwirq));
+
+	return 0;
+}
+
 static struct irq_chip its_sgi_irq_chip = {
 	.name			= "GICv4.1-sgi",
 	.irq_mask		= its_sgi_mask_irq,
 	.irq_unmask		= its_sgi_unmask_irq,
 	.irq_set_affinity	= its_sgi_set_affinity,
+	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
+	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
 };
 
 static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index fd3be49ac9a5..830d2abf14b3 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -345,6 +345,15 @@
 #define GICR_VPENDBASER_4_1_VGRP1EN	(1ULL << 58)
 #define GICR_VPENDBASER_4_1_VPEID	GENMASK_ULL(15, 0)
 
+#define GICR_VSGIR			0x0080
+
+#define GICR_VSGIR_VPEID		GENMASK(15, 0)
+
+#define GICR_VSGIPENDR			0x0088
+
+#define GICR_VSGIPENDR_BUSY		(1U << 31)
+#define GICR_VSGIPENDR_PENDING		GENMASK(15, 0)
+
 /*
  * ITS registers, offsets from ITS_base
  */
@@ -368,6 +377,11 @@
 
 #define GITS_TRANSLATER			0x10040
 
+#define GITS_SGIR			0x20020
+
+#define GITS_SGIR_VPEID			GENMASK_ULL(47, 32)
+#define GITS_SGIR_VINTID		GENMASK_ULL(7, 0)
+
 #define GITS_CTLR_ENABLE		(1U << 0)
 #define GITS_CTLR_ImDe			(1U << 1)
 #define	GITS_CTLR_ITS_NUMBER_SHIFT	4
-- 
2.20.1


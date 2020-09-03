Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4790F25C547
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgICP0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbgICP0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:26:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBEFB208B3;
        Thu,  3 Sep 2020 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599146783;
        bh=7LhuvEdZhLPAHAyHA7l/m2l3Ifej9lF2CP2ElSpnsoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/l55asM97OjhFg1PYSYfZXX6sGk97GlTvUiCkdOz9Cle8jaVkX2sdKgEzLQKlPHy
         KPrpqm6OGGWKJEBFax6WBjzwghI7kdB5fDF3OVwak9lDOQ1UcocaT/Mf4j5pAGJ586
         HEoetApPvUe3rMQqRsWkaljLJ2QuX/v4KvaZSu1M=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr82-008vT9-4G; Thu, 03 Sep 2020 16:26:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 02/23] irqchip/rvic: Add support for untrusted interrupt allocation
Date:   Thu,  3 Sep 2020 16:25:49 +0100
Message-Id: <20200903152610.1078827-3-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-rvic.c | 47 +++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-rvic.c b/drivers/irqchip/irq-rvic.c
index 6f37aa4318b6..2747a452202f 100644
--- a/drivers/irqchip/irq-rvic.c
+++ b/drivers/irqchip/irq-rvic.c
@@ -37,6 +37,8 @@ static DEFINE_PER_CPU(unsigned long *, trusted_masked);
 struct rvic_data {
 	struct fwnode_handle	*fwnode;
 	struct irq_domain	*domain;
+	unsigned long 		*bitmap;
+	struct mutex		lock;
 	unsigned int		nr_trusted;
 	unsigned int		nr_untrusted;
 };
@@ -356,9 +358,26 @@ static int rvic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 	irq_hw_number_t hwirq;
 	int i, ret;
 
-	ret = irq_domain_translate_twocell(domain, fwspec, &hwirq, &type);
-	if (ret)
-		return ret;
+	if (fwspec) {
+		ret = irq_domain_translate_twocell(domain, fwspec,
+						   &hwirq, &type);
+		if (ret)
+			return ret;
+	} else {
+		/* rVID wants untrusted interrupts */
+		mutex_lock(&rvic.lock);
+		hwirq = bitmap_find_next_zero_area(rvic.bitmap,
+						   rvic.nr_untrusted,
+						   0, nr_irqs, 0);
+		if (hwirq < rvic.nr_untrusted)
+			bitmap_set(rvic.bitmap, hwirq, nr_irqs);
+		mutex_unlock(&rvic.lock);
+
+		if (hwirq >= rvic.nr_untrusted)
+			return -ENOSPC;
+
+		hwirq += rvic.nr_trusted;
+	}
 
 	for (i = 0; i < nr_irqs; i++) {
 		unsigned int intid = hwirq + i;
@@ -376,6 +395,12 @@ static int rvic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 					    domain->host_data,
 					    handle_percpu_devid_irq,
 					    NULL, NULL);
+		} else if (intid < (rvic.nr_trusted + rvic.nr_untrusted)) {
+			irqd_set_single_target(irq_desc_get_irq_data(irq_to_desc(irq)));
+			irq_domain_set_info(domain, irq, intid, &rvic_chip,
+					    domain->host_data,
+					    handle_fasteoi_irq,
+					    NULL, NULL);
 		} else {
 			return -EINVAL;
 		}
@@ -391,6 +416,11 @@ static void rvic_irq_domain_free(struct irq_domain *domain, unsigned int virq,
 
 	for (i = 0; i < nr_irqs; i++) {
 		struct irq_data *d = irq_domain_get_irq_data(domain, virq + i);
+		if (d->hwirq >= rvic.nr_trusted) {
+			mutex_lock(&rvic.lock);
+			__clear_bit(d->hwirq, rvic.bitmap);
+			mutex_unlock(&rvic.lock);
+		}
 		irq_set_handler(virq + i, NULL);
 		irq_domain_reset_irq_data(d);
 	}
@@ -523,6 +553,12 @@ static int __init rvic_init(struct device_node *node,
 		return -ENOMEM;
 	}
 
+	rvic.bitmap = bitmap_alloc(rvic.nr_untrusted, GFP_KERNEL | __GFP_ZERO);
+	if (!rvic.bitmap) {
+		pr_warn("Failed to allocate untrusted bitmap\n");
+		goto free_domain;
+	}
+
 	for_each_possible_cpu(cpu) {
 		unsigned long *map = bitmap_alloc(rvic.nr_trusted, GFP_KERNEL);
 
@@ -537,6 +573,8 @@ static int __init rvic_init(struct device_node *node,
 		per_cpu(trusted_masked, cpu) = map;
 	}
 
+	mutex_init(&rvic.lock);
+
 	rvic_smp_init(rvic.fwnode);
 	set_handle_irq(rvic_handle_irq);
 
@@ -546,6 +584,9 @@ static int __init rvic_init(struct device_node *node,
 	for_each_possible_cpu(cpu)
 		kfree(per_cpu(trusted_masked, cpu));
 
+	kfree(rvic.bitmap);
+
+free_domain:
 	irq_domain_remove(rvic.domain);
 
 	return -ENOMEM;
-- 
2.27.0


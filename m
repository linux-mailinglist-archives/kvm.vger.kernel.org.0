Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410F4283B44
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 17:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgJEPks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 11:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbgJEP3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:10 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A603EC0613AD;
        Mon,  5 Oct 2020 08:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9X9x96P6+npWyg0gx9B1UAwiuJCvc5Y9h8UrX/LH4UU=; b=EFFJ8Am3fJf4TuqV/8S0XbN9OF
        H0depyFkplbOkt2skOOM/wy9P2C6QXW3eemD4lgJOGv2+t4VswR1aoVa2VyYg2YuWwfU15XMZwPTf
        M/JokO96FKxWd7mSuqrvR3PQl2XNOooe7+UQwJGxyOpNO3borWMNKWFBdVS2s1sIDQKsEhVVO8/yk
        koYl13KsgP6USxPyUv5YEY0//nR4vKGJQoXdcZPdpjfC7JHD6B025f3DelZXAHy3p14T7sHl1r9ZR
        PiuoImmg7z0IYrFIJ492E9B7xB5NknzaVlJCTkkBAfCIYEYVLzejiSYcAJURz9n2DUGpGGEyQoWG/
        hdfdYsCg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPSQ5-0004MO-Gc; Mon, 05 Oct 2020 15:28:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kPSQ4-0045R4-Fy; Mon, 05 Oct 2020 16:28:56 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 12/13] iommu/irq_remapping: Kill most of hyperv-iommu.c now it's redundant
Date:   Mon,  5 Oct 2020 16:28:55 +0100
Message-Id: <20201005152856.974112-12-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005152856.974112-1-dwmw2@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
 <20201005152856.974112-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

It took me a while to realise that this "IRQ remapping" driver exists
not to actually remap interrupts, but to return -EINVAL if anyone ever
tries to set the affinity to a set of CPUs which can't be reached
*without* remapping. Having fixed the core IRQ domain code to handle
such limited, all this hackery can now die.

I haven't deleted it entirely because its existence still causes the
kernel to use X2APIC in cluster mode not physical. I'm not sure we
*want* that, but it wants further thought and testing before ripping
it out too.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/iommu/hyperv-iommu.c | 149 +----------------------------------
 1 file changed, 1 insertion(+), 148 deletions(-)

diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index e09e2d734c57..46a794d34f57 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -24,156 +24,12 @@
 #include "irq_remapping.h"
 
 #ifdef CONFIG_IRQ_REMAP
-
-/*
- * According 82093AA IO-APIC spec , IO APIC has a 24-entry Interrupt
- * Redirection Table. Hyper-V exposes one single IO-APIC and so define
- * 24 IO APIC remmapping entries.
- */
-#define IOAPIC_REMAPPING_ENTRY 24
-
-static cpumask_t ioapic_max_cpumask = { CPU_BITS_NONE };
-static struct irq_domain *ioapic_ir_domain;
-
-static int hyperv_ir_set_affinity(struct irq_data *data,
-		const struct cpumask *mask, bool force)
-{
-	struct irq_data *parent = data->parent_data;
-	struct irq_cfg *cfg = irqd_cfg(data);
-	struct IO_APIC_route_entry *entry;
-	int ret;
-
-	/* Return error If new irq affinity is out of ioapic_max_cpumask. */
-	if (!cpumask_subset(mask, &ioapic_max_cpumask))
-		return -EINVAL;
-
-	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
-		return ret;
-
-	entry = data->chip_data;
-	entry->dest = cfg->dest_apicid;
-	entry->vector = cfg->vector;
-	send_cleanup_vector(cfg);
-
-	return 0;
-}
-
-static struct irq_chip hyperv_ir_chip = {
-	.name			= "HYPERV-IR",
-	.irq_ack		= apic_ack_irq,
-	.irq_set_affinity	= hyperv_ir_set_affinity,
-};
-
-static int hyperv_irq_remapping_alloc(struct irq_domain *domain,
-				     unsigned int virq, unsigned int nr_irqs,
-				     void *arg)
-{
-	struct irq_alloc_info *info = arg;
-	struct irq_data *irq_data;
-	struct irq_desc *desc;
-	int ret = 0;
-
-	if (!info || info->type != X86_IRQ_ALLOC_TYPE_IOAPIC || nr_irqs > 1)
-		return -EINVAL;
-
-	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
-	if (ret < 0)
-		return ret;
-
-	irq_data = irq_domain_get_irq_data(domain, virq);
-	if (!irq_data) {
-		irq_domain_free_irqs_common(domain, virq, nr_irqs);
-		return -EINVAL;
-	}
-
-	irq_data->chip = &hyperv_ir_chip;
-
-	/*
-	 * If there is interrupt remapping function of IOMMU, setting irq
-	 * affinity only needs to change IRTE of IOMMU. But Hyper-V doesn't
-	 * support interrupt remapping function, setting irq affinity of IO-APIC
-	 * interrupts still needs to change IO-APIC registers. But ioapic_
-	 * configure_entry() will ignore value of cfg->vector and cfg->
-	 * dest_apicid when IO-APIC's parent irq domain is not the vector
-	 * domain.(See ioapic_configure_entry()) In order to setting vector
-	 * and dest_apicid to IO-APIC register, IO-APIC entry pointer is saved
-	 * in the chip_data and hyperv_irq_remapping_activate()/hyperv_ir_set_
-	 * affinity() set vector and dest_apicid directly into IO-APIC entry.
-	 */
-	irq_data->chip_data = info->ioapic.entry;
-
-	/*
-	 * Hypver-V IO APIC irq affinity should be in the scope of
-	 * ioapic_max_cpumask because no irq remapping support.
-	 */
-	desc = irq_data_to_desc(irq_data);
-	cpumask_copy(desc->irq_common_data.affinity, &ioapic_max_cpumask);
-
-	return 0;
-}
-
-static void hyperv_irq_remapping_free(struct irq_domain *domain,
-				 unsigned int virq, unsigned int nr_irqs)
-{
-	irq_domain_free_irqs_common(domain, virq, nr_irqs);
-}
-
-static int hyperv_irq_remapping_activate(struct irq_domain *domain,
-			  struct irq_data *irq_data, bool reserve)
-{
-	struct irq_cfg *cfg = irqd_cfg(irq_data);
-	struct IO_APIC_route_entry *entry = irq_data->chip_data;
-
-	entry->dest = cfg->dest_apicid;
-	entry->vector = cfg->vector;
-
-	return 0;
-}
-
-static const struct irq_domain_ops hyperv_ir_domain_ops = {
-	.alloc = hyperv_irq_remapping_alloc,
-	.free = hyperv_irq_remapping_free,
-	.activate = hyperv_irq_remapping_activate,
-};
-
 static int __init hyperv_prepare_irq_remapping(void)
 {
-	struct fwnode_handle *fn;
-	int i;
-
 	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV) ||
 	    !x2apic_supported())
 		return -ENODEV;
 
-	fn = irq_domain_alloc_named_id_fwnode("HYPERV-IR", 0);
-	if (!fn)
-		return -ENOMEM;
-
-	ioapic_ir_domain =
-		irq_domain_create_hierarchy(arch_get_ir_parent_domain(),
-				0, IOAPIC_REMAPPING_ENTRY, fn,
-				&hyperv_ir_domain_ops, NULL);
-
-	if (!ioapic_ir_domain) {
-		irq_domain_free_fwnode(fn);
-		return -ENOMEM;
-	}
-
-	/*
-	 * Hyper-V doesn't provide irq remapping function for
-	 * IO-APIC and so IO-APIC only accepts 8-bit APIC ID.
-	 * Cpu's APIC ID is read from ACPI MADT table and APIC IDs
-	 * in the MADT table on Hyper-v are sorted monotonic increasingly.
-	 * APIC ID reflects cpu topology. There maybe some APIC ID
-	 * gaps when cpu number in a socket is not power of two. Prepare
-	 * max cpu affinity for IOAPIC irqs. Scan cpu 0-255 and set cpu
-	 * into ioapic_max_cpumask if its APIC ID is less than 256.
-	 */
-	for (i = min_t(unsigned int, num_possible_cpus() - 1, 255); i >= 0; i--)
-		if (cpu_physical_id(i) < 256)
-			cpumask_set_cpu(i, &ioapic_max_cpumask);
-
 	return 0;
 }
 
@@ -184,10 +40,7 @@ static int __init hyperv_enable_irq_remapping(void)
 
 static struct irq_domain *hyperv_get_irq_domain(struct irq_alloc_info *info)
 {
-	if (info->type == X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT)
-		return ioapic_ir_domain;
-	else
-		return NULL;
+	return NULL;
 }
 
 struct irq_remap_ops hyperv_irq_remap_ops = {
-- 
2.26.2


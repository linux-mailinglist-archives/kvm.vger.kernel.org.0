Return-Path: <kvm+bounces-53176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF827B0E850
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 03:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F9121C84C92
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 01:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D35018FDD2;
	Wed, 23 Jul 2025 01:50:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02BC1FB3
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 01:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753235453; cv=none; b=GChONFiL6CUgc7mfFmYpzhPRqp3ER5S6Y+7YLND8svkRynsPq9tJ8dL5Ti1R1tu5HZ8NEmP1Buh6f8TfBHc6K1jGiVd2EH7opGdcqwJJdFwBmNfGfgkp/NjftDkDo0duRlst6rYCbWXq8JjWbMX1p5haK3sgowtu+XOc/6i3M3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753235453; c=relaxed/simple;
	bh=aM2fsrHv8BfNI2bw0i/Hi2e08V87NtEJ2/MKjGRUvWY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VLAzw9fcPziZ3aoP/TgxLuRq0kpNnnkPEkYGxum3M3nY3BsjB6bvLlV9oZ9Sj7X7Sg4yM0K5ksdQdidaIK0y6XU8DfyRe5KHSNWFOECv8MsKboliWJzqeCZ2ocPg+EO4OQJsTHfckx9MJI9gEUzOWt1RpvpI0gH1Y1v6VPz7jS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bmxnT66Mzz2Cfv6;
	Wed, 23 Jul 2025 09:46:37 +0800 (CST)
Received: from kwepemf200012.china.huawei.com (unknown [7.202.181.238])
	by mail.maildlp.com (Postfix) with ESMTPS id D4155140257;
	Wed, 23 Jul 2025 09:50:47 +0800 (CST)
Received: from localhost (10.173.124.246) by kwepemf200012.china.huawei.com
 (7.202.181.238) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 23 Jul
 2025 09:50:47 +0800
From: Hogan Wang <hogan.wang@huawei.com>
To: <x86@kernel.org>, <dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>,
	<alex.williamson@redhat.com>
CC: <weidong.huang@huawei.com>, <yechuan@huawei.com>, <hogan.wang@huawei.com>,
	<wangxinxin.wang@huawei.com>, <jianjay.zhou@huawei.com>,
	<wangjie88@huawei.com>
Subject: [PATCH] x86/irq: introduce repair_irq try to repair CPU vector
Date: Wed, 23 Jul 2025 09:50:45 +0800
Message-ID: <20250723015045.1701-1-hogan.wang@huawei.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf200012.china.huawei.com (7.202.181.238)

When the VM irqbalance service adjusts interrupt affinity
frequently, the VM repeatedly masks MSI-x interrupts.
During the guest kernel masking MSI-x interrupts, VM exits
to the Hypervisor.

The Qemu emulator implements the switching between
kvm_interrupt and qemu_interrupt to achieve MSI-x PBA
capability.

When the Qemu emulator calls the vfio_msi_set_vector_signal
interface to switch the kvm_interrupt and qemu_interrupt
eventfd, it releases and requests IRQs, and correspondingly
clears and initializes the CPU Vector.

When initializing the CPU Vector, if an unhandled interrupt
in the APIC is delivered to the kernel, the __common_interrupt
function is called to handle the interrupt.

Since the call_irq_handler function assigns vector_irq[vector]
to VECTOR_UNUSED without lock protection, the assignment of
vector_irq[vector] and the initialization of the CPU Vector
are concurrent, leading to vector_irq[vector] being mistakenly
set to VECTOR_UNUSED.

This ultimately results in the inability of VFIO passthrough
device interrupts to be delivered, causing packet loss in
network devices or IO hangs in disk devices.

This patch detects and repairs vector_irq[vector] after the
interrupt initialization is completed, ensuring that
vector_irq[vector] can be corrected if it is mistakenly set
to VECTOR_UNUSED.

Signed-off-by: Hogan Wang <hogan.wang@huawei.com>
---
 arch/x86/kernel/apic/vector.c     | 18 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_intrs.c |  2 ++
 include/linux/interrupt.h         |  3 +++
 include/linux/irqdomain.h         |  3 +++
 kernel/irq/irqdomain.c            | 27 +++++++++++++++++++++++++++
 kernel/irq/manage.c               | 18 ++++++++++++++++++
 6 files changed, 71 insertions(+)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 93069b13d3af..20164a9ce63b 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -396,6 +396,23 @@ static void x86_vector_deactivate(struct irq_domain *dom, struct irq_data *irqd)
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 }
 
+static void x86_vector_repair(struct irq_domain *dom, struct irq_data *irqd)
+{
+	struct apic_chip_data *apicd = apic_chip_data(irqd);
+	struct irq_desc *desc = irq_data_to_desc(irqd);
+	unsigned int vector = apicd->vector;
+	unsigned int cpu = apicd->cpu;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	if (per_cpu(vector_irq, cpu)[vector] != desc) {
+		per_cpu(vector_irq, cpu)[vector] = desc;
+		pr_warn("irq %u: repair vector %u.%u\n",
+			irqd->irq, cpu, vector);
+	}
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+}
+
 static int activate_reserved(struct irq_data *irqd)
 {
 	struct apic_chip_data *apicd = apic_chip_data(irqd);
@@ -703,6 +720,7 @@ static const struct irq_domain_ops x86_vector_domain_ops = {
 	.free		= x86_vector_free_irqs,
 	.activate	= x86_vector_activate,
 	.deactivate	= x86_vector_deactivate,
+	.repair		= x86_vector_repair,
 #ifdef CONFIG_GENERIC_IRQ_DEBUGFS
 	.debug_show	= x86_vector_debug_show,
 #endif
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 565966351dfa..6ea34a52878c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -517,6 +517,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	}
 	ctx->trigger = trigger;
 
+	repair_irq(irq);
+
 	return 0;
 
 out_put_eventfd_ctx:
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 51b6484c0493..c5f6172ae1cd 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -203,6 +203,9 @@ extern void free_percpu_irq(unsigned int, void __percpu *);
 extern const void *free_nmi(unsigned int irq, void *dev_id);
 extern void free_percpu_nmi(unsigned int irq, void __percpu *percpu_dev_id);
 
+extern void repair_irq(unsigned int irq);
+
+
 struct device;
 
 extern int __must_check
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 7387d183029b..10538a13addc 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -69,6 +69,7 @@ void of_phandle_args_to_fwspec(struct device_node *np, const u32 *args,
  * @translate:	Given @fwspec, decode the hardware irq number (@out_hwirq) and
  *		linux irq type value (@out_type). This is a generalised @xlate
  *		(over struct irq_fwspec) and is preferred if provided.
+ * @repair: repair one interrupt (@irqd).
  * @debug_show:	For domains to show specific data for an interrupt in debugfs.
  *
  * Functions below are provided by the driver and called whenever a new mapping
@@ -96,6 +97,7 @@ struct irq_domain_ops {
 	void	(*deactivate)(struct irq_domain *d, struct irq_data *irq_data);
 	int	(*translate)(struct irq_domain *d, struct irq_fwspec *fwspec,
 			     unsigned long *out_hwirq, unsigned int *out_type);
+	void (*repair)(struct irq_domain *d, struct irq_data *irqd);
 #endif
 #ifdef CONFIG_GENERIC_IRQ_DEBUGFS
 	void	(*debug_show)(struct seq_file *m, struct irq_domain *d,
@@ -563,6 +565,7 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base, unsigned in
 void irq_domain_free_irqs(unsigned int virq, unsigned int nr_irqs);
 int irq_domain_activate_irq(struct irq_data *irq_data, bool early);
 void irq_domain_deactivate_irq(struct irq_data *irq_data);
+void irq_domain_repair_irq(struct irq_data *irq_data);
 
 /**
  * irq_domain_alloc_irqs - Allocate IRQs from domain
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index c8b6de09047b..d9c2aaa6247d 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1921,6 +1921,18 @@ void irq_domain_free_irqs_parent(struct irq_domain *domain,
 }
 EXPORT_SYMBOL_GPL(irq_domain_free_irqs_parent);
 
+static void __irq_domain_repair_irq(struct irq_data *irq_data)
+{
+	if (irq_data && irq_data->domain) {
+		struct irq_domain *domain = irq_data->domain;
+
+		if (domain->ops->repair)
+			domain->ops->repair(domain, irq_data);
+		if (irq_data->parent_data)
+			__irq_domain_repair_irq(irq_data->parent_data);
+	}
+}
+
 static void __irq_domain_deactivate_irq(struct irq_data *irq_data)
 {
 	if (irq_data && irq_data->domain) {
@@ -1989,6 +2001,21 @@ void irq_domain_deactivate_irq(struct irq_data *irq_data)
 	}
 }
 
+/**
+ * irq_domain_repair_irq - Call domain_ops->repair recursively to
+ *			       repair interrupt
+ * @irq_data: outermost irq_data associated with interrupt
+ *
+ * It calls domain_ops->repair to program interrupt controllers to repair
+ * interrupt delivery.
+ */
+void irq_domain_repair_irq(struct irq_data *irq_data)
+{
+	if (irqd_is_activated(irq_data))
+		__irq_domain_repair_irq(irq_data);
+}
+
+
 static void irq_domain_check_hierarchy(struct irq_domain *domain)
 {
 	/* Hierarchy irq_domains must implement callback alloc() */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c94837382037..f2e6bed02f98 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1418,6 +1418,24 @@ setup_irq_thread(struct irqaction *new, unsigned int irq, bool secondary)
 	return 0;
 }
 
+
+void repair_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+
+	mutex_lock(&desc->request_mutex);
+	chip_bus_lock(desc);
+	raw_spin_lock_irqsave(&desc->lock, flags);
+
+	irq_domain_repair_irq(irq_desc_get_irq_data(desc));
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(desc);
+	mutex_unlock(&desc->request_mutex);
+}
+EXPORT_SYMBOL(repair_irq);
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
-- 
2.45.1



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F4730E494
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 22:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhBCVCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 16:02:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:45270 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232831AbhBCU6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:58:32 -0500
IronPort-SDR: bMzPtbJcVsXP0h/g+lR/99OeqtXolQWog0IUvX0Bdi8a8yoCCVOCXx6sguKOgdOlsWrn/BJ44M
 eQHwVsT1fTrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="245191306"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="245191306"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 12:57:30 -0800
IronPort-SDR: z24OHgspgXrmUufwOeutvV6tlHGf9al7sBOIJbNf8aGLHBQtLiLTIBb2vJCFLQOMgpXsLQm86z
 uHnTQ4xRdMlA==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="372510575"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 03 Feb 2021 12:57:30 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [PATCH 08/12] genirq: Set auxiliary data for an interrupt
Date:   Wed,  3 Feb 2021 12:56:41 -0800
Message-Id: <1612385805-3412-9-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612385805-3412-1-git-send-email-megha.dey@intel.com>
References: <1612385805-3412-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new function pointer in the irq_chip structure(irq_set_auxdata)
which is responsible for updating data which is stored in a shared register
or data storage. For example, the idxd driver uses the auxiliary data API
to enable/set and disable PASID field that is in the IMS entry (introduced
in a later patch) and that data are not typically present in MSI entry.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 include/linux/interrupt.h |  2 ++
 include/linux/irq.h       |  4 ++++
 kernel/irq/manage.c       | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index bb8ff90..d3f419b 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -496,6 +496,8 @@ extern int irq_get_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 extern int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 				 bool state);
 
+int irq_set_auxdata(unsigned int irq, unsigned int which, u64 val);
+
 #ifdef CONFIG_IRQ_FORCED_THREADING
 # ifdef CONFIG_PREEMPT_RT
 #  define force_irqthreads	(true)
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 4aeb1c4..568cdf5 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -491,6 +491,8 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  *				irq_request_resources
  * @irq_compose_msi_msg:	optional to compose message content for MSI
  * @irq_write_msi_msg:	optional to write message content for MSI
+ * @irq_set_auxdata:	Optional function to update auxiliary data e.g. in
+ *			shared registers
  * @irq_get_irqchip_state:	return the internal state of an interrupt
  * @irq_set_irqchip_state:	set the internal state of a interrupt
  * @irq_set_vcpu_affinity:	optional to target a vCPU in a virtual machine
@@ -538,6 +540,8 @@ struct irq_chip {
 	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 
+	int		(*irq_set_auxdata)(struct irq_data *data, unsigned int which, u64 auxval);
+
 	int		(*irq_get_irqchip_state)(struct irq_data *data, enum irqchip_irq_state which, bool *state);
 	int		(*irq_set_irqchip_state)(struct irq_data *data, enum irqchip_irq_state which, bool state);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 85ede4e..68ff559 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -2860,3 +2860,35 @@ bool irq_check_status_bit(unsigned int irq, unsigned int bitmask)
 	return res;
 }
 EXPORT_SYMBOL_GPL(irq_check_status_bit);
+
+/**
+ * irq_set_auxdata - Set auxiliary data
+ * @irq:	Interrupt to update
+ * @which:	Selector which data to update
+ * @auxval:	Auxiliary data value
+ *
+ * Function to update auxiliary data for an interrupt, e.g. to update data
+ * which is stored in a shared register or data storage (e.g. IMS).
+ */
+int irq_set_auxdata(unsigned int irq, unsigned int which, u64 val)
+{
+	struct irq_desc *desc;
+	struct irq_data *data;
+	unsigned long flags;
+	int res = -ENODEV;
+
+	desc = irq_get_desc_buslock(irq, &flags, 0);
+	if (!desc)
+		return -EINVAL;
+
+	for (data = &desc->irq_data; data; data = irqd_get_parent_data(data)) {
+		if (data->chip->irq_set_auxdata) {
+			res = data->chip->irq_set_auxdata(data, which, val);
+			break;
+		}
+	}
+
+	irq_put_desc_busunlock(desc, flags);
+	return res;
+}
+EXPORT_SYMBOL_GPL(irq_set_auxdata);
-- 
2.7.4


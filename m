Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E403438D259
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhEVAVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:21:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:2497 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230453AbhEVAVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:21:01 -0400
IronPort-SDR: ZST9NzzDWewFL+dJuRf36MAnlAW0nqIUSg7wQWLXbafANl37D84p4wTHAQs7Be9ALK4HnpPXek
 7AY68KTau92g==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="188728094"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="188728094"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:37 -0700
IronPort-SDR: cI0DdXQZFyMKhXSMOe9LhovWqziGOmqOHS/1A1y191XgQEJdy3YUJKlmyG/H5syc1GqUKAdHRr
 Ou2XKxGfL1Jg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="628864430"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:36 -0700
Subject: [PATCH v6 05/20] vfio: mdev: common lib code for setting up Interrupt
 Message Store
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     Jason Gunthorpe <jgg@nvidia.com>, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:19:36 -0700
Message-ID: <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add common helper code to setup IMS once the MSI domain has been
setup by the device driver. The main helper function is
mdev_ims_set_msix_trigger() that is called by the VFIO ioctl
VFIO_DEVICE_SET_IRQS. The function deals with the setup and
teardown of emulated and IMS backed eventfd that gets exported
to the guest kernel via VFIO as MSIX vectors.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/vfio/mdev/Kconfig     |   12 ++
 drivers/vfio/mdev/Makefile    |    3 
 drivers/vfio/mdev/mdev_irqs.c |  318 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mdev.h          |   51 +++++++
 4 files changed, 384 insertions(+)
 create mode 100644 drivers/vfio/mdev/mdev_irqs.c

diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index 763c877a1318..82f79d99a7db 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -9,3 +9,15 @@ config VFIO_MDEV
 	  See Documentation/driver-api/vfio-mediated-device.rst for more details.
 
 	  If you don't know what do here, say N.
+
+config VFIO_MDEV_IRQS
+	bool "Mediated device driver common lib code for interrupts"
+	depends on VFIO_MDEV
+	select IMS_MSI_ARRAY
+	select IRQ_BYPASS_MANAGER
+	default n
+	help
+	  Provide common library code to deal with IMS interrupts for mediated
+	  devices.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/mdev/Makefile b/drivers/vfio/mdev/Makefile
index 7c236ba1b90e..c3f160cae192 100644
--- a/drivers/vfio/mdev/Makefile
+++ b/drivers/vfio/mdev/Makefile
@@ -2,4 +2,7 @@
 
 mdev-y := mdev_core.o mdev_sysfs.o mdev_driver.o
 
+mdev-$(CONFIG_VFIO_MDEV_IRQS) += mdev_irqs.o
+
 obj-$(CONFIG_VFIO_MDEV) += mdev.o
+
diff --git a/drivers/vfio/mdev/mdev_irqs.c b/drivers/vfio/mdev/mdev_irqs.c
new file mode 100644
index 000000000000..ed2d11a7c729
--- /dev/null
+++ b/drivers/vfio/mdev/mdev_irqs.c
@@ -0,0 +1,318 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Mediate device IMS library code
+ *
+ * Copyright (c) 2021 Intel Corp. All rights reserved.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/irqchip/irq-ims-msi.h>
+#include <linux/eventfd.h>
+#include <linux/irqreturn.h>
+#include <linux/msi.h>
+#include <linux/vfio.h>
+#include <linux/irqbypass.h>
+#include <linux/mdev.h>
+
+static irqreturn_t mdev_irq_handler(int irq, void *arg)
+{
+	struct eventfd_ctx *trigger = arg;
+
+	eventfd_signal(trigger, 1);
+	return IRQ_HANDLED;
+}
+
+/*
+ * Common helper routine to send signal to the eventfd that has been setup.
+ *
+ * @mdev_irq [in]		: struct mdev_irq context
+ * @vector [in]			: vector index for eventfd
+ *
+ * No return value.
+ */
+void mdev_msix_send_signal(struct mdev_device *mdev, int vector)
+{
+	struct mdev_irq *mdev_irq = &mdev->mdev_irq;
+	struct eventfd_ctx *trigger = mdev_irq->irq_entries[vector].trigger;
+
+	if (!mdev_irq->irq_entries || !trigger) {
+		dev_warn(&mdev->dev, "EventFD %d trigger not setup, can't send!\n", vector);
+		return;
+	}
+	mdev_irq_handler(0, (void *)trigger);
+}
+EXPORT_SYMBOL_GPL(mdev_msix_send_signal);
+
+static int mdev_msix_set_vector_signal(struct mdev_irq *mdev_irq, int vector, int fd)
+{
+	int rc, irq;
+	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
+	struct mdev_irq_entry *entry;
+	struct device *dev = &mdev->dev;
+	struct eventfd_ctx *trigger;
+	char *name;
+	bool pasid_en;
+	u32 auxval;
+
+	if (vector < 0 || vector >= mdev_irq->num)
+		return -EINVAL;
+
+	entry = &mdev_irq->irq_entries[vector];
+
+	if (entry->ims)
+		irq = dev_msi_irq_vector(dev, entry->ims_id);
+	else
+		irq = 0;
+
+	pasid_en = mdev_irq->pasid != INVALID_IOASID ? true : false;
+
+	/* IMS and invalid pasid is not a valid configuration */
+	if (entry->ims && !pasid_en)
+		return -EINVAL;
+
+	if (entry->trigger) {
+		if (irq) {
+			irq_bypass_unregister_producer(&entry->producer);
+			free_irq(irq, entry->trigger);
+			if (pasid_en) {
+				auxval = ims_ctrl_pasid_aux(0, false);
+				irq_set_auxdata(irq, IMS_AUXDATA_CONTROL_WORD, auxval);
+			}
+		}
+		kfree(entry->name);
+		eventfd_ctx_put(entry->trigger);
+		entry->trigger = NULL;
+	}
+
+	if (fd < 0)
+		return 0;
+
+	name = kasprintf(GFP_KERNEL, "vfio-mdev-irq[%d](%s)", vector, dev_name(dev));
+	if (!name)
+		return -ENOMEM;
+
+	trigger = eventfd_ctx_fdget(fd);
+	if (IS_ERR(trigger)) {
+		kfree(name);
+		return PTR_ERR(trigger);
+	}
+
+	entry->name = name;
+	entry->trigger = trigger;
+
+	if (!irq)
+		return 0;
+
+	if (pasid_en) {
+		auxval = ims_ctrl_pasid_aux(mdev_irq->pasid, true);
+		rc = irq_set_auxdata(irq, IMS_AUXDATA_CONTROL_WORD, auxval);
+		if (rc < 0)
+			goto err;
+	}
+
+	rc = request_irq(irq, mdev_irq_handler, 0, name, trigger);
+	if (rc < 0)
+		goto irq_err;
+
+	entry->producer.token = trigger;
+	entry->producer.irq = irq;
+	rc = irq_bypass_register_producer(&entry->producer);
+	if (unlikely(rc)) {
+		dev_warn(dev, "irq bypass producer (token %p) registration fails: %d\n",
+			 &entry->producer.token, rc);
+		entry->producer.token = NULL;
+	}
+
+	return 0;
+
+ irq_err:
+	if (pasid_en) {
+		auxval = ims_ctrl_pasid_aux(0, false);
+		irq_set_auxdata(irq, IMS_AUXDATA_CONTROL_WORD, auxval);
+	}
+ err:
+	kfree(name);
+	eventfd_ctx_put(trigger);
+	entry->trigger = NULL;
+	return rc;
+}
+
+static int mdev_msix_set_vector_signals(struct mdev_irq *mdev_irq, unsigned int start,
+					unsigned int count, int *fds)
+{
+	int i, j, rc = 0;
+
+	if (start >= mdev_irq->num || start + count > mdev_irq->num)
+		return -EINVAL;
+
+	for (i = 0, j = start; j < count && !rc; i++, j++) {
+		int fd = fds ? fds[i] : -1;
+
+		rc = mdev_msix_set_vector_signal(mdev_irq, j, fd);
+	}
+
+	if (rc) {
+		for (--j; j >= (int)start; j--)
+			mdev_msix_set_vector_signal(mdev_irq, j, -1);
+	}
+
+	return rc;
+}
+
+static int mdev_msix_enable(struct mdev_irq *mdev_irq, int nvec)
+{
+	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
+	struct device *dev;
+	int rc;
+
+	if (nvec != mdev_irq->num)
+		return -EINVAL;
+
+	if (mdev_irq->ims_num) {
+		dev = &mdev->dev;
+		rc = msi_domain_alloc_irqs(dev_get_msi_domain(dev), dev, mdev_irq->ims_num);
+		if (rc < 0)
+			return rc;
+	}
+
+	mdev_irq->irq_type = VFIO_PCI_MSIX_IRQ_INDEX;
+	return 0;
+}
+
+static int mdev_msix_disable(struct mdev_irq *mdev_irq)
+{
+	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
+	struct device *dev = &mdev->dev;
+	struct irq_domain *irq_domain;
+
+	mdev_msix_set_vector_signals(mdev_irq, 0, mdev_irq->num, NULL);
+	irq_domain = dev_get_msi_domain(&mdev->dev);
+	if (irq_domain)
+		msi_domain_free_irqs(irq_domain, dev);
+	mdev_irq->irq_type = VFIO_PCI_NUM_IRQS;
+	return 0;
+}
+
+/*
+ * Common helper function that sets up the MSIX vectors for the mdev device that are
+ * Interrupt Message Store (IMS) backed. Certain mdev devices can have the first
+ * vector emulated rather than backed by IMS.
+ *
+ *  @mdev [in]		: mdev device
+ *  @index [in]		: type of VFIO vectors to setup
+ *  @start [in]		: start position of the vector index
+ *  @count [in]		: number of vectors
+ *  @flags [in]		: VFIO_IRQ action to be taken
+ *  @data [in]		: data accompanied for the call
+ *  Return error code on failure or 0 on success.
+ */
+
+int mdev_set_msix_trigger(struct mdev_device *mdev, unsigned int index,
+			  unsigned int start, unsigned int count, u32 flags,
+			  void *data)
+{
+	struct mdev_irq *mdev_irq = &mdev->mdev_irq;
+	int i, rc = 0;
+
+	if (count > mdev_irq->num)
+		count = mdev_irq->num;
+
+	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
+		mdev_msix_disable(mdev_irq);
+		return 0;
+	}
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		int *fds = data;
+
+		if (mdev_irq->irq_type == index)
+			return mdev_msix_set_vector_signals(mdev_irq, start, count, fds);
+
+		rc = mdev_msix_enable(mdev_irq, start + count);
+		if (rc < 0)
+			return rc;
+
+		rc = mdev_msix_set_vector_signals(mdev_irq, start, count, fds);
+		if (rc < 0)
+			mdev_msix_disable(mdev_irq);
+
+		return rc;
+	}
+
+	if (start + count > mdev_irq->num)
+		return -EINVAL;
+
+	for (i = start; i < start + count; i++) {
+		if (!mdev_irq->irq_entries[i].trigger)
+			continue;
+		if (flags & VFIO_IRQ_SET_DATA_NONE) {
+			eventfd_signal(mdev_irq->irq_entries[i].trigger, 1);
+		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+			u8 *bools = data;
+
+			if (bools[i - start])
+				eventfd_signal(mdev_irq->irq_entries[i].trigger, 1);
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mdev_set_msix_trigger);
+
+void mdev_irqs_set_pasid(struct mdev_device *mdev, u32 pasid)
+{
+	mdev->mdev_irq.pasid = pasid;
+}
+EXPORT_SYMBOL_GPL(mdev_irqs_set_pasid);
+
+/*
+ * Initialize and setup the mdev_irq context under mdev.
+ *
+ * @mdev [in]		: mdev device
+ * @num [in]		: number of vectors
+ * @ims_map [in]	: bool array that indicates whether a guest MSIX vector is
+ *			  backed by an IMS vector or emulated
+ * Return error code on failure or 0 on success.
+ */
+int mdev_irqs_init(struct mdev_device *mdev, int num, bool *ims_map)
+{
+	struct mdev_irq *mdev_irq = &mdev->mdev_irq;
+	int i;
+
+	if (num < 1)
+		return -EINVAL;
+
+	mdev_irq->irq_type = VFIO_PCI_NUM_IRQS;
+	mdev_irq->num = num;
+	mdev_irq->pasid = INVALID_IOASID;
+
+	mdev_irq->irq_entries = kcalloc(num, sizeof(*mdev_irq->irq_entries), GFP_KERNEL);
+	if (!mdev_irq->irq_entries)
+		return -ENOMEM;
+
+	for (i = 0; i < num; i++) {
+		mdev_irq->irq_entries[i].ims = ims_map[i];
+		if (ims_map[i]) {
+			mdev_irq->irq_entries[i].ims_id = mdev_irq->ims_num;
+			mdev_irq->ims_num++;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mdev_irqs_init);
+
+/*
+ * Free allocated memory in mdev_irq
+ *
+ * @mdev [in]		: mdev device
+ */
+void mdev_irqs_free(struct mdev_device *mdev)
+{
+	kfree(mdev->mdev_irq.irq_entries);
+	memset(&mdev->mdev_irq, 0, sizeof(mdev->mdev_irq));
+}
+EXPORT_SYMBOL_GPL(mdev_irqs_free);
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 0cd8db2d3422..035c021e8068 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -10,8 +10,26 @@
 #ifndef MDEV_H
 #define MDEV_H
 
+#include <linux/irqbypass.h>
+
 struct mdev_type;
 
+struct mdev_irq_entry {
+	struct eventfd_ctx *trigger;
+	struct irq_bypass_producer producer;
+	char *name;
+	bool ims;
+	int ims_id;
+};
+
+struct mdev_irq {
+	struct mdev_irq_entry *irq_entries;
+	int num;
+	int ims_num;
+	int irq_type;
+	int pasid;
+};
+
 struct mdev_device {
 	struct device dev;
 	guid_t uuid;
@@ -19,8 +37,14 @@ struct mdev_device {
 	struct mdev_type *type;
 	struct device *iommu_device;
 	struct mutex creation_lock;
+	struct mdev_irq mdev_irq;
 };
 
+static inline struct mdev_device *irq_to_mdev(struct mdev_irq *mdev_irq)
+{
+	return container_of(mdev_irq, struct mdev_device, mdev_irq);
+}
+
 static inline struct mdev_device *to_mdev_device(struct device *dev)
 {
 	return container_of(dev, struct mdev_device, dev);
@@ -99,4 +123,31 @@ static inline struct mdev_device *mdev_from_dev(struct device *dev)
 	return dev->bus == &mdev_bus_type ? to_mdev_device(dev) : NULL;
 }
 
+#if IS_ENABLED(CONFIG_VFIO_MDEV_IRQS)
+int mdev_set_msix_trigger(struct mdev_device *mdev, unsigned int index,
+			  unsigned int start, unsigned int count, u32 flags,
+			  void *data);
+void mdev_msix_send_signal(struct mdev_device *mdev, int vector);
+int mdev_irqs_init(struct mdev_device *mdev, int num, bool *ims_map);
+void mdev_irqs_free(struct mdev_device *mdev);
+void mdev_irqs_set_pasid(struct mdev_device *mdev, u32 pasid);
+#else
+static inline int mdev_set_msix_trigger(struct mdev_device *mdev, unsigned int index,
+					unsigned int start, unsigned int count, u32 flags,
+					void *data)
+{
+	return -EOPNOTSUPP;
+}
+
+void mdev_msix_send_signal(struct mdev_device *mdev, int vector) {}
+
+static inline int mdev_irqs_init(struct mdev_device *mdev, int num, bool *ims_map)
+{
+	return -EOPNOTSUPP;
+}
+
+void mdev_irqs_free(struct mdev_device *mdev) {}
+void mdev_irqs_set_pasid(struct mdev_device *mdev, u32 pasid) {}
+#endif /* CONFIG_VFIO_MDEV_IMS */
+
 #endif /* MDEV_H */



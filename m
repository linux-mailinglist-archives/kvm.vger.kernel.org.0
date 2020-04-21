Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478D21B3373
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDUXi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:38:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:32297 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbgDUXi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:38:26 -0400
IronPort-SDR: hoeCV73boYUffI+wRzfZbhuDl42WVSLMivtYHlmemNyP2oqvQEYv+D51q5V6U0siW7fo7asOfy
 fE+HPzqxXSUw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:35:10 -0700
IronPort-SDR: hodVW9VvG+CS5iFg6Z1WxtbE9gR3mKlOEom+PKawBJ8eKb+n6kd8Y6dkWaFuifSOw+P/i9cCgb
 nib0bWfsehEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="456286451"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga005.fm.intel.com with ESMTP; 21 Apr 2020 16:35:08 -0700
Subject: [PATCH RFC 13/15] dmaengine: idxd: add support for VFIO mediated
 device
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Apr 2020 16:35:08 -0700
Message-ID: <158751210879.36773.4070933531991265762.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add enabling code that provide VFIO mediated device. A mediated device
allows hardware to export resources to guests with significantly less
dedicated hardware versus the SR-IOV implementation. For DSA devices
through mdev enabling, we can emulate a virtual DSA device in the guest
by exporting one or more workqueues to the guest and exposed as DSA
device(s). The software emulates PCI config and MMIO accesses. The I/O
submission path however is accessed directly to the hardware. A submission
portal is mmap'd to the guest in order to allow direct submission of
descriptors.

The creation of a mediated device will generate a UUID. The UUID can be
retrieved from one of the VFIO sysfs attributes. This UUID must be
provided to the idxd driver via sysfs in order to tie the specific mdev to
the relevant workqueue. Given the various ways a wq can be configured and
grouped on a device, this allows the system admin to directly associate a
specifically configured wq to be exported to the guest that is desired. The
hope is that this design choice provides the max configurability and
flexibility.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/Kconfig          |    3 
 drivers/dma/idxd/Makefile    |    2 
 drivers/dma/idxd/device.c    |   36 +
 drivers/dma/idxd/dma.c       |    9 
 drivers/dma/idxd/idxd.h      |   23 +
 drivers/dma/idxd/init.c      |   10 
 drivers/dma/idxd/irq.c       |    2 
 drivers/dma/idxd/mdev.c      | 1558 ++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/mdev.h      |   23 +
 drivers/dma/idxd/registers.h |   10 
 drivers/dma/idxd/submit.c    |   28 +
 drivers/dma/idxd/sysfs.c     |  143 ++++
 drivers/dma/idxd/vdev.c      |  570 +++++++++++++++
 drivers/dma/idxd/vdev.h      |   42 +
 14 files changed, 2418 insertions(+), 41 deletions(-)
 create mode 100644 drivers/dma/idxd/vdev.c
 create mode 100644 drivers/dma/idxd/vdev.h

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 9e7d9eafb1f5..e39e04309587 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -291,6 +291,9 @@ config INTEL_IDXD
 	select PCI_PASID
 	select PCI_IOV
 	select MSI_IMS
+	select VFIO_PCI
+	select VFIO_MDEV
+	select VFIO_MDEV_DEVICE
 	help
 	  Enable support for the Intel(R) data accelerators present
 	  in Intel Xeon CPU.
diff --git a/drivers/dma/idxd/Makefile b/drivers/dma/idxd/Makefile
index 308e12869f96..bb1fb771f6b5 100644
--- a/drivers/dma/idxd/Makefile
+++ b/drivers/dma/idxd/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_INTEL_IDXD) += idxd.o
-idxd-y := init.o irq.o device.o sysfs.o submit.o dma.o cdev.o mdev.o
+idxd-y := init.o irq.o device.o sysfs.o submit.o dma.o cdev.o mdev.o vdev.o
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 830aa5859646..b92cb1ca20d3 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -223,11 +223,11 @@ void idxd_wq_free_resources(struct idxd_wq *wq)
 	sbitmap_free(&wq->sbmap);
 }
 
-int idxd_wq_enable(struct idxd_wq *wq)
+int idxd_wq_enable(struct idxd_wq *wq, u32 *status)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
-	u32 status;
+	u32 stat;
 	int rc;
 
 	lockdep_assert_held(&idxd->dev_lock);
@@ -240,13 +240,16 @@ int idxd_wq_enable(struct idxd_wq *wq)
 	rc = idxd_cmd_send(idxd, IDXD_CMD_ENABLE_WQ, wq->id);
 	if (rc < 0)
 		return rc;
-	rc = idxd_cmd_wait(idxd, &status, IDXD_REG_TIMEOUT);
+	rc = idxd_cmd_wait(idxd, &stat, IDXD_REG_TIMEOUT);
 	if (rc < 0)
 		return rc;
 
-	if (status != IDXD_CMDSTS_SUCCESS &&
-	    status != IDXD_CMDSTS_ERR_WQ_ENABLED) {
-		dev_dbg(dev, "WQ enable failed: %#x\n", status);
+	if (status)
+		*status = stat;
+
+	if (stat != IDXD_CMDSTS_SUCCESS &&
+	    stat != IDXD_CMDSTS_ERR_WQ_ENABLED) {
+		dev_dbg(dev, "WQ enable failed: %#x\n", stat);
 		return -ENXIO;
 	}
 
@@ -255,11 +258,11 @@ int idxd_wq_enable(struct idxd_wq *wq)
 	return 0;
 }
 
-int idxd_wq_disable(struct idxd_wq *wq)
+int idxd_wq_disable(struct idxd_wq *wq, u32 *status)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
-	u32 status, operand;
+	u32 stat, operand;
 	int rc;
 
 	lockdep_assert_held(&idxd->dev_lock);
@@ -274,12 +277,15 @@ int idxd_wq_disable(struct idxd_wq *wq)
 	rc = idxd_cmd_send(idxd, IDXD_CMD_DISABLE_WQ, operand);
 	if (rc < 0)
 		return rc;
-	rc = idxd_cmd_wait(idxd, &status, IDXD_REG_TIMEOUT);
+	rc = idxd_cmd_wait(idxd, &stat, IDXD_REG_TIMEOUT);
 	if (rc < 0)
 		return rc;
 
-	if (status != IDXD_CMDSTS_SUCCESS) {
-		dev_dbg(dev, "WQ disable failed: %#x\n", status);
+	if (status)
+		*status = stat;
+
+	if (stat != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(dev, "WQ disable failed: %#x\n", stat);
 		return -ENXIO;
 	}
 
@@ -362,7 +368,7 @@ int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid)
 
 	lockdep_assert_held(&idxd->dev_lock);
 
-	rc = idxd_wq_disable(wq);
+	rc = idxd_wq_disable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -373,7 +379,7 @@ int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid)
 	wqcfg.pasid = pasid;
 	iowrite32(wqcfg.bits[2], idxd->reg_base + offset);
 
-	rc = idxd_wq_enable(wq);
+	rc = idxd_wq_enable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -389,7 +395,7 @@ int idxd_wq_disable_pasid(struct idxd_wq *wq)
 
 	lockdep_assert_held(&idxd->dev_lock);
 
-	rc = idxd_wq_disable(wq);
+	rc = idxd_wq_disable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -399,7 +405,7 @@ int idxd_wq_disable_pasid(struct idxd_wq *wq)
 	wqcfg.pasid = 0;
 	iowrite32(wqcfg.bits[2], idxd->reg_base + offset);
 
-	rc = idxd_wq_enable(wq);
+	rc = idxd_wq_enable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index 9a4f78519e57..a49d4f303d7d 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -61,8 +61,6 @@ static inline void idxd_prep_desc_common(struct idxd_wq *wq,
 					 u64 addr_f1, u64 addr_f2, u64 len,
 					 u64 compl, u32 flags)
 {
-	struct idxd_device *idxd = wq->idxd;
-
 	hw->flags = flags;
 	hw->opcode = opcode;
 	hw->src_addr = addr_f1;
@@ -70,13 +68,6 @@ static inline void idxd_prep_desc_common(struct idxd_wq *wq,
 	hw->xfer_size = len;
 	hw->priv = !!(wq->type == IDXD_WQT_KERNEL);
 	hw->completion_addr = compl;
-
-	/*
-	 * Descriptor completion vectors are 1-8 for MSIX. We will round
-	 * robin through the 8 vectors.
-	 */
-	wq->vec_ptr = (wq->vec_ptr % idxd->num_wq_irqs) + 1;
-	hw->int_handle =  wq->vec_ptr;
 }
 
 static struct dma_async_tx_descriptor *
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 9b56a4c7f3fc..92a9718daa15 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -8,6 +8,10 @@
 #include <linux/percpu-rwsem.h>
 #include <linux/wait.h>
 #include <linux/cdev.h>
+#include <linux/pci.h>
+#include <linux/irq.h>
+#include <linux/idxd.h>
+#include <linux/uuid.h>
 #include "registers.h"
 
 #define IDXD_DRIVER_VERSION	"1.00"
@@ -66,6 +70,7 @@ enum idxd_wq_type {
 	IDXD_WQT_NONE = 0,
 	IDXD_WQT_KERNEL,
 	IDXD_WQT_USER,
+	IDXD_WQT_MDEV,
 };
 
 struct idxd_cdev {
@@ -75,6 +80,11 @@ struct idxd_cdev {
 	struct wait_queue_head err_queue;
 };
 
+struct idxd_wq_uuid {
+	guid_t uuid;
+	struct list_head list;
+};
+
 #define IDXD_ALLOCATED_BATCH_SIZE	128U
 #define WQ_NAME_SIZE   1024
 #define WQ_TYPE_SIZE   10
@@ -119,6 +129,9 @@ struct idxd_wq {
 	struct percpu_rw_semaphore submit_lock;
 	wait_queue_head_t submit_waitq;
 	char name[WQ_NAME_SIZE + 1];
+	struct list_head uuid_list;
+	int uuids;
+	struct list_head vdcm_list;
 };
 
 struct idxd_engine {
@@ -200,6 +213,7 @@ struct idxd_device {
 	atomic_t num_allocated_ims;
 	struct sbitmap ims_sbmap;
 	int *int_handles;
+	struct mutex mdev_lock; /* mdev creation lock */
 };
 
 /* IDXD software descriptor */
@@ -282,6 +296,7 @@ void idxd_cleanup_sysfs(struct idxd_device *idxd);
 int idxd_register_driver(void);
 void idxd_unregister_driver(void);
 struct bus_type *idxd_get_bus_type(struct idxd_device *idxd);
+bool is_idxd_wq_mdev(struct idxd_wq *wq);
 
 /* device interrupt control */
 irqreturn_t idxd_irq_handler(int vec, void *data);
@@ -310,8 +325,8 @@ int idxd_device_request_int_handle(struct idxd_device *idxd,
 /* work queue control */
 int idxd_wq_alloc_resources(struct idxd_wq *wq);
 void idxd_wq_free_resources(struct idxd_wq *wq);
-int idxd_wq_enable(struct idxd_wq *wq);
-int idxd_wq_disable(struct idxd_wq *wq);
+int idxd_wq_enable(struct idxd_wq *wq, u32 *status);
+int idxd_wq_disable(struct idxd_wq *wq, u32 *status);
 int idxd_wq_map_portal(struct idxd_wq *wq);
 void idxd_wq_unmap_portal(struct idxd_wq *wq);
 int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid);
@@ -344,4 +359,8 @@ int idxd_cdev_get_major(struct idxd_device *idxd);
 int idxd_wq_add_cdev(struct idxd_wq *wq);
 void idxd_wq_del_cdev(struct idxd_wq *wq);
 
+/* mdev */
+int idxd_mdev_host_init(struct idxd_device *idxd);
+void idxd_mdev_host_release(struct idxd_device *idxd);
+
 #endif
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index babe6e614087..b0f99a794e91 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -218,6 +218,8 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 		mutex_init(&wq->wq_lock);
 		atomic_set(&wq->dq_count, 0);
 		init_waitqueue_head(&wq->submit_waitq);
+		INIT_LIST_HEAD(&wq->uuid_list);
+		INIT_LIST_HEAD(&wq->vdcm_list);
 		wq->idxd_cdev.minor = -1;
 		rc = percpu_init_rwsem(&wq->submit_lock);
 		if (rc < 0) {
@@ -347,6 +349,7 @@ static struct idxd_device *idxd_alloc(struct pci_dev *pdev)
 
 	idxd->pdev = pdev;
 	spin_lock_init(&idxd->dev_lock);
+	mutex_init(&idxd->mdev_lock);
 	atomic_set(&idxd->num_allocated_ims, 0);
 
 	return idxd;
@@ -509,6 +512,12 @@ static int idxd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENODEV;
 	}
 
+	rc = idxd_mdev_host_init(idxd);
+	if (rc < 0) {
+		dev_err(dev, "VFIO mdev init failed\n");
+		return rc;
+	}
+
 	rc = idxd_setup_sysfs(idxd);
 	if (rc) {
 		dev_err(dev, "IDXD sysfs setup failed\n");
@@ -584,6 +593,7 @@ static void idxd_remove(struct pci_dev *pdev)
 	dev_dbg(&pdev->dev, "%s called\n", __func__);
 	idxd_cleanup_sysfs(idxd);
 	idxd_shutdown(pdev);
+	idxd_mdev_host_release(idxd);
 	idxd_wqs_free_lock(idxd);
 	idxd_disable_system_pasid(idxd);
 	mutex_lock(&idxd_idr_lock);
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 37ad927d6944..bc634dc4e485 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -77,7 +77,7 @@ static int idxd_restart(struct idxd_device *idxd)
 		struct idxd_wq *wq = &idxd->wqs[i];
 
 		if (wq->state == IDXD_WQ_ENABLED) {
-			rc = idxd_wq_enable(wq);
+			rc = idxd_wq_enable(wq, NULL);
 			if (rc < 0) {
 				dev_warn(&idxd->pdev->dev,
 					 "Unable to re-enable wq %s\n",
diff --git a/drivers/dma/idxd/mdev.c b/drivers/dma/idxd/mdev.c
index 2cf0cdf149b7..b222ce00a9db 100644
--- a/drivers/dma/idxd/mdev.c
+++ b/drivers/dma/idxd/mdev.c
@@ -1,19 +1,76 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2019,2020 Intel Corporation. All rights rsvd. */
+/* Copyright(c) 2019 Intel Corporation. All rights rsvd. */
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/device.h>
+#include <linux/sched/task.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
-#include <linux/msi.h>
-#include <linux/mdev.h>
+#include <linux/mm.h>
+#include <linux/mmu_context.h>
 #include <linux/vfio.h>
-#include "../../vfio/pci/vfio_pci_private.h"
+#include <linux/mdev.h>
+#include <linux/msi.h>
+#include <linux/intel-iommu.h>
+#include <linux/intel-svm.h>
+#include <linux/kvm_host.h>
+#include <linux/eventfd.h>
+#include <linux/circ_buf.h>
 #include <uapi/linux/idxd.h>
 #include "registers.h"
 #include "idxd.h"
+#include "../../vfio/pci/vfio_pci_private.h"
 #include "mdev.h"
+#include "vdev.h"
+
+static u64 idxd_pci_config[] = {
+	0x001000000b258086ULL,
+	0x0080000008800000ULL,
+	0x000000000000000cULL,
+	0x000000000000000cULL,
+	0x0000000000000000ULL,
+	0x2010808600000000ULL,
+	0x0000004000000000ULL,
+	0x000000ff00000000ULL,
+	0x0000060000005011ULL, /* MSI-X capability */
+	0x0000070000000000ULL,
+	0x0000000000920010ULL, /* PCIe capability */
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0070001000000000ULL,
+	0x0000000000000000ULL,
+};
+
+static u64 idxd_pci_ext_cap[] = {
+	0x000000611101000fULL, /* ATS capability */
+	0x0000000000000000ULL,
+	0x8100000012010013ULL, /* Page Request capability */
+	0x0000000000000001ULL,
+	0x000014040001001bULL, /* PASID capability */
+	0x0000000000000000ULL,
+	0x0181808600010023ULL, /* Scalable IOV capability */
+	0x0000000100000005ULL,
+	0x0000000000000001ULL,
+	0x0000000000000000ULL,
+};
+
+static u64 idxd_cap_ctrl_reg[] = {
+	0x0000000000000100ULL,
+	0x0000000000000000ULL,
+	0x00000001013f038fULL, /* gencap */
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000004004ULL, /* grpcap */
+	0x0000000000000004ULL, /* engcap */
+	0x00000001003f03ffULL, /* opcap */
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL, /* offsets */
+};
 
 static void idxd_free_ims_index(struct idxd_device *idxd,
 				unsigned long ims_idx)
@@ -124,7 +181,11 @@ static struct platform_msi_ops idxd_ims_ops  = {
 
 static irqreturn_t idxd_guest_wq_completion_interrupt(int irq, void *data)
 {
-	/* send virtual interrupt */
+	struct ims_irq_entry *irq_entry = data;
+	struct vdcm_idxd *vidxd = irq_entry->vidxd;
+	int msix_idx = irq_entry->int_src;
+
+	vidxd_send_interrupt(vidxd, msix_idx + 1);
 	return IRQ_HANDLED;
 }
 
@@ -177,3 +238,1490 @@ static int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
 
 	return 0;
 }
+
+static inline bool handle_valid(unsigned long handle)
+{
+	return !!(handle & ~0xff);
+}
+
+static void idxd_vdcm_reinit(struct vdcm_idxd *vidxd)
+{
+	struct idxd_wq *wq;
+	struct idxd_device *idxd;
+	unsigned long flags;
+
+	memset(vidxd->cfg, 0, VIDXD_MAX_CFG_SPACE_SZ);
+	memset(&vidxd->bar0, 0, sizeof(struct vdcm_idxd_pci_bar0));
+
+	memcpy(vidxd->cfg, idxd_pci_config, sizeof(idxd_pci_config));
+	memcpy(vidxd->cfg + 0x100, idxd_pci_ext_cap,
+	       sizeof(idxd_pci_ext_cap));
+
+	memcpy(vidxd->bar0.cap_ctrl_regs, idxd_cap_ctrl_reg,
+	       sizeof(idxd_cap_ctrl_reg));
+
+	/* Set the MSI-X table size */
+	vidxd->cfg[VIDXD_MSIX_TBL_SZ_OFFSET] = 1;
+	idxd = vidxd->idxd;
+	wq = vidxd->wq;
+
+	if (wq_dedicated(wq)) {
+		spin_lock_irqsave(&idxd->dev_lock, flags);
+		idxd_wq_disable(wq, NULL);
+		spin_unlock_irqrestore(&idxd->dev_lock, flags);
+	}
+
+	vidxd_mmio_init(vidxd);
+}
+
+struct vfio_region {
+	u32 type;
+	u32 subtype;
+	size_t size;
+	u32 flags;
+};
+
+struct kvmidxd_guest_info {
+	struct kvm *kvm;
+	struct vdcm_idxd *vidxd;
+};
+
+static int kvmidxd_guest_init(struct mdev_device *mdev)
+{
+	struct kvmidxd_guest_info *info;
+	struct vdcm_idxd *vidxd;
+	struct kvm *kvm;
+	struct device *dev = mdev_dev(mdev);
+
+	vidxd = mdev_get_drvdata(mdev);
+	if (handle_valid(vidxd->handle))
+		return -EEXIST;
+
+	kvm = vidxd->vdev.kvm;
+	if (!kvm || kvm->mm != current->mm) {
+		dev_err(dev, "KVM is required to use Intel vIDXD\n");
+		return -ESRCH;
+	}
+
+	info = vzalloc(sizeof(*info));
+	if (!info)
+		return -ENOMEM;
+
+	vidxd->handle = (unsigned long)info;
+	info->vidxd = vidxd;
+	info->kvm = kvm;
+
+	return 0;
+}
+
+static bool kvmidxd_guest_exit(unsigned long handle)
+{
+	if (handle == 0)
+		return false;
+
+	vfree((void *)handle);
+
+	return true;
+}
+
+static void __idxd_vdcm_release(struct vdcm_idxd *vidxd)
+{
+	int rc;
+	struct device *dev = &vidxd->idxd->pdev->dev;
+
+	if (atomic_cmpxchg(&vidxd->vdev.released, 0, 1))
+		return;
+
+	if (!handle_valid(vidxd->handle))
+		return;
+
+	/* Re-initialize the VIDXD to a pristine state for re-use */
+	rc = vfio_unregister_notifier(mdev_dev(vidxd->vdev.mdev),
+				      VFIO_GROUP_NOTIFY,
+				      &vidxd->vdev.group_notifier);
+	if (rc < 0)
+		dev_warn(dev, "vfio_unregister_notifier group failed: %d\n",
+			 rc);
+
+	kvmidxd_guest_exit(vidxd->handle);
+	vidxd_free_ims_entries(vidxd);
+
+	vidxd->vdev.kvm = NULL;
+	vidxd->handle = 0;
+	idxd_vdcm_reinit(vidxd);
+}
+
+static void idxd_vdcm_release(struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	struct device *dev = mdev_dev(mdev);
+
+	dev_dbg(dev, "vdcm_idxd_release %d\n", vidxd->type->type);
+	__idxd_vdcm_release(vidxd);
+}
+
+static void idxd_vdcm_release_work(struct work_struct *work)
+{
+	struct vdcm_idxd *vidxd = container_of(work, struct vdcm_idxd,
+					       vdev.release_work);
+
+	__idxd_vdcm_release(vidxd);
+}
+
+static bool idxd_wq_match_uuid(struct idxd_wq *wq, const guid_t *uuid)
+{
+	struct idxd_wq_uuid *entry;
+	bool found = false;
+
+	list_for_each_entry(entry, &wq->uuid_list, list) {
+		if (guid_equal(&entry->uuid, uuid)) {
+			found = true;
+			break;
+		}
+	}
+
+	return found;
+}
+
+static struct idxd_wq *find_wq_by_uuid(struct idxd_device *idxd,
+				       const guid_t *uuid)
+{
+	int i;
+	struct idxd_wq *wq;
+	bool found = false;
+
+	for (i = 0; i < idxd->max_wqs; i++) {
+		wq = &idxd->wqs[i];
+		found = idxd_wq_match_uuid(wq, uuid);
+		if (found)
+			return wq;
+	}
+
+	return NULL;
+}
+
+static struct vdcm_idxd *vdcm_vidxd_create(struct idxd_device *idxd,
+					   struct mdev_device *mdev,
+					   struct vdcm_idxd_type *type)
+{
+	struct vdcm_idxd *vidxd;
+	unsigned long flags;
+	struct idxd_wq *wq = NULL;
+	struct device *dev = mdev_dev(mdev);
+
+	wq = find_wq_by_uuid(idxd, mdev_uuid(mdev));
+	if (!wq) {
+		dev_dbg(dev, "No WQ found\n");
+		return NULL;
+	}
+
+	if (wq->state != IDXD_WQ_ENABLED)
+		return NULL;
+
+	vidxd = kzalloc(sizeof(*vidxd), GFP_KERNEL);
+	if (!vidxd)
+		return NULL;
+
+	vidxd->idxd = idxd;
+	vidxd->vdev.mdev = mdev;
+	vidxd->wq = wq;
+	mdev_set_drvdata(mdev, vidxd);
+	vidxd->type = type;
+	vidxd->num_wqs = 1;
+
+	mutex_lock(&wq->wq_lock);
+	if (wq_dedicated(wq)) {
+		/* disable wq. will be enabled by the VM */
+		spin_lock_irqsave(&vidxd->idxd->dev_lock, flags);
+		idxd_wq_disable(vidxd->wq, NULL);
+		spin_unlock_irqrestore(&vidxd->idxd->dev_lock, flags);
+	}
+
+	/* Initialize virtual PCI resources if it is an MDEV type for a VM */
+	memcpy(vidxd->cfg, idxd_pci_config, sizeof(idxd_pci_config));
+	memcpy(vidxd->cfg + 0x100, idxd_pci_ext_cap,
+	       sizeof(idxd_pci_ext_cap));
+	memcpy(vidxd->bar0.cap_ctrl_regs, idxd_cap_ctrl_reg,
+	       sizeof(idxd_cap_ctrl_reg));
+
+	/* Set the MSI-X table size */
+	vidxd->cfg[VIDXD_MSIX_TBL_SZ_OFFSET] = 1;
+	vidxd->bar_size[0] = VIDXD_BAR0_SIZE;
+	vidxd->bar_size[1] = VIDXD_BAR2_SIZE;
+
+	vidxd_mmio_init(vidxd);
+
+	INIT_WORK(&vidxd->vdev.release_work, idxd_vdcm_release_work);
+
+	idxd_wq_get(wq);
+	mutex_unlock(&wq->wq_lock);
+
+	return vidxd;
+}
+
+static struct vdcm_idxd_type idxd_mdev_types[IDXD_MDEV_TYPES] = {
+	{
+		.name = "wq",
+		.description = "IDXD MDEV workqueue",
+		.type = IDXD_MDEV_TYPE_WQ,
+	},
+};
+
+static struct vdcm_idxd_type *idxd_vdcm_find_vidxd_type(struct device *dev,
+							const char *name)
+{
+	int i;
+	char dev_name[IDXD_MDEV_NAME_LEN];
+
+	for (i = 0; i < IDXD_MDEV_TYPES; i++) {
+		snprintf(dev_name, IDXD_MDEV_NAME_LEN, "idxd-%s",
+			 idxd_mdev_types[i].name);
+
+		if (!strncmp(name, dev_name, IDXD_MDEV_NAME_LEN))
+			return &idxd_mdev_types[i];
+	}
+
+	return NULL;
+}
+
+static int idxd_vdcm_create(struct kobject *kobj, struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd;
+	struct vdcm_idxd_type *type;
+	struct device *dev, *parent;
+	struct idxd_device *idxd;
+	int rc = 0;
+
+	parent = mdev_parent_dev(mdev);
+	idxd = dev_get_drvdata(parent);
+	dev = mdev_dev(mdev);
+
+	mdev_set_iommu_device(dev, parent);
+	mutex_lock(&idxd->mdev_lock);
+	type = idxd_vdcm_find_vidxd_type(dev, kobject_name(kobj));
+	if (!type) {
+		dev_err(dev, "failed to find type %s to create\n",
+			kobject_name(kobj));
+		rc = -EINVAL;
+		goto out;
+	}
+
+	vidxd = vdcm_vidxd_create(idxd, mdev, type);
+	if (IS_ERR_OR_NULL(vidxd)) {
+		rc = !vidxd ? -ENOMEM : PTR_ERR(vidxd);
+		dev_err(dev, "failed to create vidxd: %d\n", rc);
+		goto out;
+	}
+
+	list_add(&vidxd->list, &vidxd->wq->vdcm_list);
+	dev_dbg(dev, "mdev creation success: %s\n", dev_name(mdev_dev(mdev)));
+
+ out:
+	mutex_unlock(&idxd->mdev_lock);
+	return rc;
+}
+
+static void vdcm_vidxd_remove(struct vdcm_idxd *vidxd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	struct idxd_wq *wq = vidxd->wq;
+
+	dev_dbg(dev, "%s: removing for wq %d\n", __func__, vidxd->wq->id);
+
+	mutex_lock(&wq->wq_lock);
+	list_del(&vidxd->list);
+	idxd_wq_put(wq);
+	mutex_unlock(&wq->wq_lock);
+	kfree(vidxd);
+}
+
+static int idxd_vdcm_remove(struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+
+	if (handle_valid(vidxd->handle))
+		return -EBUSY;
+
+	vdcm_vidxd_remove(vidxd);
+	return 0;
+}
+
+static int idxd_vdcm_group_notifier(struct notifier_block *nb,
+				    unsigned long action, void *data)
+{
+	struct vdcm_idxd *vidxd = container_of(nb, struct vdcm_idxd,
+			vdev.group_notifier);
+
+	/* The only action we care about */
+	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
+		vidxd->vdev.kvm = data;
+
+		if (!data)
+			schedule_work(&vidxd->vdev.release_work);
+	}
+
+	return NOTIFY_OK;
+}
+
+static int idxd_vdcm_open(struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	unsigned long events;
+	int rc;
+	struct vdcm_idxd_type *type = vidxd->type;
+	struct device *dev = mdev_dev(mdev);
+
+	dev_dbg(dev, "%s: type: %d\n", __func__, type->type);
+
+	vidxd->vdev.group_notifier.notifier_call = idxd_vdcm_group_notifier;
+	events = VFIO_GROUP_NOTIFY_SET_KVM;
+	rc = vfio_register_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
+				    &events, &vidxd->vdev.group_notifier);
+	if (rc < 0) {
+		dev_err(dev, "vfio_register_notifier for group failed: %d\n",
+			rc);
+		return rc;
+	}
+
+	/* allocate and setup IMS entries */
+	rc = vidxd_setup_ims_entries(vidxd);
+	if (rc < 0)
+		goto undo_group;
+
+	rc = kvmidxd_guest_init(mdev);
+	if (rc)
+		goto undo_ims;
+
+	atomic_set(&vidxd->vdev.released, 0);
+
+	return rc;
+
+ undo_ims:
+	vidxd_free_ims_entries(vidxd);
+ undo_group:
+	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
+				 &vidxd->vdev.group_notifier);
+	return rc;
+}
+
+static int vdcm_vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf,
+				 unsigned int size)
+{
+	u32 offset = pos & (vidxd->bar_size[0] - 1);
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	struct device *dev = mdev_dev(vidxd->vdev.mdev);
+
+	dev_WARN_ONCE(dev, (size & (size - 1)) != 0, "%s\n", __func__);
+	dev_WARN_ONCE(dev, size > 8, "%s\n", __func__);
+	dev_WARN_ONCE(dev, (offset & (size - 1)) != 0, "%s\n", __func__);
+
+	dev_dbg(dev, "vidxd mmio W %d %x %x: %llx\n", vidxd->wq->id, size,
+		offset, get_reg_val(buf, size));
+
+	/* If we don't limit this, we potentially can write out of bound */
+	if (size > 8)
+		size = 8;
+
+	switch (offset) {
+	case IDXD_GENCFG_OFFSET ... IDXD_GENCFG_OFFSET + 7:
+		/* Write only when device is disabled. */
+		if (vidxd_state(vidxd) == IDXD_DEVICE_STATE_DISABLED)
+			memcpy(&bar0->cap_ctrl_regs[offset], buf, size);
+		break;
+
+	case IDXD_GENCTRL_OFFSET:
+		memcpy(&bar0->cap_ctrl_regs[offset], buf, size);
+		break;
+
+	case IDXD_INTCAUSE_OFFSET:
+		bar0->cap_ctrl_regs[offset] &= ~(get_reg_val(buf, 1) & 0x0f);
+		break;
+
+	case IDXD_CMD_OFFSET:
+		if (size == 4) {
+			u8 *cap_ctrl = &bar0->cap_ctrl_regs[0];
+			unsigned long *cmdsts =
+				(unsigned long *)&cap_ctrl[IDXD_CMDSTS_OFFSET];
+			u32 val = get_reg_val(buf, size);
+
+			/* Check and set device active */
+			if (test_and_set_bit(31, cmdsts) == 0) {
+				*(u32 *)cmdsts = 1 << 31;
+				vidxd_do_command(vidxd, val);
+			}
+		}
+		break;
+
+	case IDXD_SWERR_OFFSET:
+		/* W1C */
+		bar0->cap_ctrl_regs[offset] &= ~(get_reg_val(buf, 1) & 3);
+		break;
+
+	case VIDXD_WQCFG_OFFSET ... VIDXD_WQCFG_OFFSET + VIDXD_WQ_CTRL_SZ - 1: {
+		union wqcfg *wqcfg;
+		int wq_id = (offset - VIDXD_WQCFG_OFFSET) / 0x20;
+		struct idxd_wq *wq;
+		int subreg = offset & 0x1c;
+		u32 new_val;
+
+		if (wq_id >= 1)
+			break;
+		wq = vidxd->wq;
+		wqcfg = (union wqcfg *)&bar0->wq_ctrl_regs[wq_id * 0x20];
+		if (size >= 4) {
+			new_val = get_reg_val(buf, 4);
+		} else {
+			u32 tmp1, tmp2, shift, mask;
+
+			switch (subreg) {
+			case 4:
+				tmp1 = wqcfg->bits[1]; break;
+			case 8:
+				tmp1 = wqcfg->bits[2]; break;
+			case 12:
+				tmp1 = wqcfg->bits[3]; break;
+			case 16:
+				tmp1 = wqcfg->bits[4]; break;
+			case 20:
+				tmp1 = wqcfg->bits[5]; break;
+			default:
+				tmp1 = 0;
+			}
+
+			tmp2 = get_reg_val(buf, size);
+			shift = (offset & 0x03U) * 8;
+			mask = ((1U << size * 8) - 1u) << shift;
+			new_val = (tmp1 & ~mask) | (tmp2 << shift);
+		}
+
+		if (subreg == 8) {
+			if (wqcfg->wq_state == 0) {
+				wqcfg->bits[2] &= 0xfe;
+				wqcfg->bits[2] |= new_val & 0xffffff01;
+			}
+		}
+
+		break;
+	}
+
+	case VIDXD_MSIX_TABLE_OFFSET ...
+		VIDXD_MSIX_TABLE_OFFSET + VIDXD_MSIX_TBL_SZ - 1: {
+		int index = (offset - VIDXD_MSIX_TABLE_OFFSET) / 0x10;
+		u8 *msix_entry = &bar0->msix_table[index * 0x10];
+		u8 *msix_perm = &bar0->msix_perm_table[index * 8];
+		int end;
+
+		/* Upper bound checking to stop overflow */
+		end = VIDXD_MSIX_TABLE_OFFSET + VIDXD_MSIX_TBL_SZ;
+		if (offset + size > end)
+			size = end - offset;
+
+		memcpy(msix_entry + (offset & 0xf), buf, size);
+		/* check mask and pba */
+		if ((msix_entry[12] & 1) == 0) {
+			*(u32 *)msix_perm &= ~3U;
+			if (test_and_clear_bit(index, &bar0->msix_pba))
+				vidxd_send_interrupt(vidxd, index);
+		} else {
+			*(u32 *)msix_perm |= 1;
+		}
+		break;
+	}
+
+	case VIDXD_MSIX_PERM_OFFSET ...
+		VIDXD_MSIX_PERM_OFFSET + VIDXD_MSIX_PERM_TBL_SZ - 1:
+		if ((offset & 7) == 0 && size == 4) {
+			int index = (offset - VIDXD_MSIX_PERM_OFFSET) / 8;
+			u32 *msix_perm =
+				(u32 *)&bar0->msix_perm_table[index * 8];
+			u8 *msix_entry = &bar0->msix_table[index * 0x10];
+			u32 val = get_reg_val(buf, size) & 0xfffff00d;
+
+			if (index > 0)
+				vidxd_setup_ims_entry(vidxd, index - 1, val);
+
+			if (val & 1) {
+				msix_entry[12] |= 1;
+				if (bar0->msix_pba & (1ULL << index))
+					val |= 2;
+			} else {
+				msix_entry[12] &= ~1u;
+				if (test_and_clear_bit(index,
+						       &bar0->msix_pba))
+					vidxd_send_interrupt(vidxd, index);
+			}
+			*msix_perm = val;
+		}
+		break;
+	}
+
+	return 0;
+}
+
+static int vdcm_vidxd_mmio_read(struct vdcm_idxd *vidxd, u64 pos, void *buf,
+				unsigned int size)
+{
+	u32 offset = pos & (vidxd->bar_size[0] - 1);
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	u8 *reg_addr, *msix_table, *msix_perm_table;
+	struct device *dev = mdev_dev(vidxd->vdev.mdev);
+	u32 end;
+
+	dev_WARN_ONCE(dev, (size & (size - 1)) != 0, "%s\n", __func__);
+	dev_WARN_ONCE(dev, size > 8, "%s\n", __func__);
+	dev_WARN_ONCE(dev, (offset & (size - 1)) != 0, "%s\n", __func__);
+
+	/* If we don't limit this, we potentially can write out of bound */
+	if (size > 8)
+		size = 8;
+
+	switch (offset) {
+	case 0 ... VIDXD_CAP_CTRL_SZ - 1:
+		end = VIDXD_CAP_CTRL_SZ;
+		if (offset + 8 > end)
+			size = end - offset;
+		reg_addr = &bar0->cap_ctrl_regs[offset];
+		break;
+
+	case VIDXD_GRPCFG_OFFSET ...
+		VIDXD_GRPCFG_OFFSET + VIDXD_GRP_CTRL_SZ - 1:
+		end = VIDXD_GRPCFG_OFFSET + VIDXD_GRP_CTRL_SZ;
+		if (offset + 8 > end)
+			size = end - offset;
+		reg_addr = &bar0->grp_ctrl_regs[offset - VIDXD_GRPCFG_OFFSET];
+		break;
+
+	case VIDXD_WQCFG_OFFSET ... VIDXD_WQCFG_OFFSET + VIDXD_WQ_CTRL_SZ - 1:
+		end = VIDXD_WQCFG_OFFSET + VIDXD_WQ_CTRL_SZ;
+		if (offset + 8 > end)
+			size = end - offset;
+		reg_addr = &bar0->wq_ctrl_regs[offset - VIDXD_WQCFG_OFFSET];
+		break;
+
+	case VIDXD_MSIX_TABLE_OFFSET ...
+		VIDXD_MSIX_TABLE_OFFSET + VIDXD_MSIX_TBL_SZ - 1:
+		end = VIDXD_MSIX_TABLE_OFFSET + VIDXD_MSIX_TBL_SZ;
+		if (offset + 8 > end)
+			size = end - offset;
+		msix_table = &bar0->msix_table[0];
+		reg_addr = &msix_table[offset - VIDXD_MSIX_TABLE_OFFSET];
+		break;
+
+	case VIDXD_MSIX_PBA_OFFSET ... VIDXD_MSIX_PBA_OFFSET + 7:
+		end = VIDXD_MSIX_PBA_OFFSET + 8;
+		if (offset + 8 > end)
+			size = end - offset;
+		reg_addr = (u8 *)&bar0->msix_pba;
+		break;
+
+	case VIDXD_MSIX_PERM_OFFSET ...
+		VIDXD_MSIX_PERM_OFFSET + VIDXD_MSIX_PERM_TBL_SZ - 1:
+		end = VIDXD_MSIX_PERM_OFFSET + VIDXD_MSIX_PERM_TBL_SZ;
+		if (offset + 8 > end)
+			size = end - offset;
+		msix_perm_table = &bar0->msix_perm_table[0];
+		reg_addr = &msix_perm_table[offset - VIDXD_MSIX_PERM_OFFSET];
+		break;
+
+	default:
+		reg_addr = NULL;
+		break;
+	}
+
+	if (reg_addr)
+		memcpy(buf, reg_addr, size);
+	else
+		memset(buf, 0, size);
+
+	dev_dbg(dev, "vidxd mmio R %d %x %x: %llx\n",
+		vidxd->wq->id, size, offset, get_reg_val(buf, size));
+	return 0;
+}
+
+static int vdcm_vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos,
+			       void *buf, unsigned int count)
+{
+	u32 offset = pos & 0xfff;
+	struct device *dev = mdev_dev(vidxd->vdev.mdev);
+
+	memcpy(buf, &vidxd->cfg[offset], count);
+
+	dev_dbg(dev, "vidxd pci R %d %x %x: %llx\n",
+		vidxd->wq->id, count, offset, get_reg_val(buf, count));
+
+	return 0;
+}
+
+static int vdcm_vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos,
+				void *buf, unsigned int size)
+{
+	u32 offset = pos & 0xfff;
+	u64 val;
+	u8 *cfg = vidxd->cfg;
+	u8 *bar0 = vidxd->bar0.cap_ctrl_regs;
+	struct device *dev = mdev_dev(vidxd->vdev.mdev);
+
+	dev_dbg(dev, "vidxd pci W %d %x %x: %llx\n", vidxd->wq->id, size,
+		offset, get_reg_val(buf, size));
+
+	switch (offset) {
+	case PCI_COMMAND: { /* device control */
+		bool bme;
+
+		memcpy(&cfg[offset], buf, size);
+		bme = cfg[offset] & PCI_COMMAND_MASTER;
+		if (!bme &&
+		    ((*(u32 *)&bar0[IDXD_GENSTATS_OFFSET]) & 0x3) != 0) {
+			*(u32 *)(&bar0[IDXD_SWERR_OFFSET]) = 0x51u << 8;
+			*(u32 *)(&bar0[IDXD_GENSTATS_OFFSET]) = 0;
+		}
+
+		if (size < 4)
+			break;
+		offset += 2;
+		buf = buf + 2;
+		size -= 2;
+	}
+	/* fall through */
+
+	case PCI_STATUS: { /* device status */
+		u16 nval = get_reg_val(buf, size) << (offset & 1) * 8;
+
+		nval &= 0xf900;
+		*(u16 *)&cfg[offset] = *((u16 *)&cfg[offset]) & ~nval;
+		break;
+	}
+
+	case PCI_CACHE_LINE_SIZE:
+	case PCI_INTERRUPT_LINE:
+		memcpy(&cfg[offset], buf, size);
+		break;
+
+	case PCI_BASE_ADDRESS_0: /* BAR0 */
+	case PCI_BASE_ADDRESS_1: /* BAR1 */
+	case PCI_BASE_ADDRESS_2: /* BAR2 */
+	case PCI_BASE_ADDRESS_3: /* BAR3 */ {
+		unsigned int bar_id, bar_offset;
+		u64 bar, bar_size;
+
+		bar_id = (offset - PCI_BASE_ADDRESS_0) / 8;
+		bar_size = vidxd->bar_size[bar_id];
+		bar_offset = PCI_BASE_ADDRESS_0 + bar_id * 8;
+
+		val = get_reg_val(buf, size);
+		bar = *(u64 *)&cfg[bar_offset];
+		memcpy((u8 *)&bar + (offset & 0x7), buf, size);
+		bar &= ~(bar_size - 1);
+
+		*(u64 *)&cfg[bar_offset] = bar |
+			PCI_BASE_ADDRESS_MEM_TYPE_64 |
+			PCI_BASE_ADDRESS_MEM_PREFETCH;
+
+		if (val == -1U || val == -1ULL)
+			break;
+		if (bar == 0 || bar == -1ULL - -1U)
+			break;
+		if (bar == (-1U & ~(bar_size - 1)))
+			break;
+		if (bar == (-1ULL & ~(bar_size - 1)))
+			break;
+		if (bar == vidxd->bar_val[bar_id])
+			break;
+
+		vidxd->bar_val[bar_id] = bar;
+		break;
+	}
+
+	case VIDXD_ATS_OFFSET + 4:
+		if (size < 4)
+			break;
+		offset += 2;
+		buf = buf + 2;
+		size -= 2;
+		/* fall through */
+
+	case VIDXD_ATS_OFFSET + 6:
+		memcpy(&cfg[offset], buf, size);
+		break;
+
+	case VIDXD_PRS_OFFSET + 4: {
+		u8 old_val, new_val;
+
+		val = get_reg_val(buf, 1);
+		old_val = cfg[VIDXD_PRS_OFFSET + 4];
+		new_val = val & 1;
+
+		cfg[offset] = new_val;
+		if (old_val == 0 && new_val == 1) {
+			/*
+			 * Clear Stopped, Response Failure,
+			 * and Unexpected Response.
+			 */
+			*(u16 *)&cfg[VIDXD_PRS_OFFSET + 6] &= ~(u16)(0x0103);
+		}
+
+		if (size < 4)
+			break;
+
+		offset += 2;
+		buf = (u8 *)buf + 2;
+		size -= 2;
+	}
+	/* fall through */
+
+	case VIDXD_PRS_OFFSET + 6:
+		cfg[offset] &= ~(get_reg_val(buf, 1) & 3);
+		break;
+	case VIDXD_PRS_OFFSET + 12 ... VIDXD_PRS_OFFSET + 15:
+		memcpy(&cfg[offset], buf, size);
+		break;
+
+	case VIDXD_PASID_OFFSET + 4:
+		if (size < 4)
+			break;
+		offset += 2;
+		buf = buf + 2;
+		size -= 2;
+		/* fall through */
+	case VIDXD_PASID_OFFSET + 6:
+		cfg[offset] = get_reg_val(buf, 1) & 5;
+		break;
+	}
+
+	return 0;
+}
+
+static ssize_t idxd_vdcm_rw(struct mdev_device *mdev, char *buf,
+			    size_t count, loff_t *ppos, enum idxd_vdcm_rw mode)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	struct device *dev = mdev_dev(mdev);
+	int rc = -EINVAL;
+
+	if (index >= VFIO_PCI_NUM_REGIONS) {
+		dev_err(dev, "invalid index: %u\n", index);
+		return -EINVAL;
+	}
+
+	switch (index) {
+	case VFIO_PCI_CONFIG_REGION_INDEX:
+		if (mode == IDXD_VDCM_WRITE)
+			rc = vdcm_vidxd_cfg_write(vidxd, pos, buf, count);
+		else
+			rc = vdcm_vidxd_cfg_read(vidxd, pos, buf, count);
+		break;
+	case VFIO_PCI_BAR0_REGION_INDEX:
+	case VFIO_PCI_BAR1_REGION_INDEX:
+		if (mode == IDXD_VDCM_WRITE)
+			rc = vdcm_vidxd_mmio_write(vidxd,
+						   vidxd->bar_val[0] + pos, buf,
+						   count);
+		else
+			rc = vdcm_vidxd_mmio_read(vidxd,
+						  vidxd->bar_val[0] + pos, buf,
+						  count);
+		break;
+	case VFIO_PCI_BAR2_REGION_INDEX:
+	case VFIO_PCI_BAR3_REGION_INDEX:
+	case VFIO_PCI_BAR4_REGION_INDEX:
+	case VFIO_PCI_BAR5_REGION_INDEX:
+	case VFIO_PCI_VGA_REGION_INDEX:
+	case VFIO_PCI_ROM_REGION_INDEX:
+	default:
+		dev_err(dev, "unsupported region: %u\n", index);
+	}
+
+	return rc == 0 ? count : rc;
+}
+
+static ssize_t idxd_vdcm_read(struct mdev_device *mdev, char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	unsigned int done = 0;
+	int rc;
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 8 && !(*ppos % 8)) {
+			u64 val;
+
+			rc = idxd_vdcm_rw(mdev, (char *)&val, sizeof(val),
+					  ppos, IDXD_VDCM_READ);
+			if (rc <= 0)
+				goto read_err;
+
+			if (copy_to_user(buf, &val, sizeof(val)))
+				goto read_err;
+
+			filled = 8;
+		} else if (count >= 4 && !(*ppos % 4)) {
+			u32 val;
+
+			rc = idxd_vdcm_rw(mdev, (char *)&val, sizeof(val),
+					  ppos, IDXD_VDCM_READ);
+			if (rc <= 0)
+				goto read_err;
+
+			if (copy_to_user(buf, &val, sizeof(val)))
+				goto read_err;
+
+			filled = 4;
+		} else if (count >= 2 && !(*ppos % 2)) {
+			u16 val;
+
+			rc = idxd_vdcm_rw(mdev, (char *)&val, sizeof(val),
+					  ppos, IDXD_VDCM_READ);
+			if (rc <= 0)
+				goto read_err;
+
+			if (copy_to_user(buf, &val, sizeof(val)))
+				goto read_err;
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			rc = idxd_vdcm_rw(mdev, &val, sizeof(val), ppos,
+					  IDXD_VDCM_READ);
+			if (rc <= 0)
+				goto read_err;
+
+			if (copy_to_user(buf, &val, sizeof(val)))
+				goto read_err;
+
+			filled = 1;
+		}
+
+		count -= filled;
+		done += filled;
+		*ppos += filled;
+		buf += filled;
+	}
+
+	return done;
+
+ read_err:
+	return -EFAULT;
+}
+
+static ssize_t idxd_vdcm_write(struct mdev_device *mdev,
+			       const char __user *buf, size_t count,
+			       loff_t *ppos)
+{
+	unsigned int done = 0;
+	int rc;
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 8 && !(*ppos % 8)) {
+			u64 val;
+
+			if (copy_from_user(&val, buf, sizeof(val)))
+				goto write_err;
+
+			rc = idxd_vdcm_rw(mdev, (char *)&val, sizeof(val),
+					  ppos, IDXD_VDCM_WRITE);
+			if (rc <= 0)
+				goto write_err;
+
+			filled = 8;
+		} else if (count >= 4 && !(*ppos % 4)) {
+			u32 val;
+
+			if (copy_from_user(&val, buf, sizeof(val)))
+				goto write_err;
+
+			rc = idxd_vdcm_rw(mdev, (char *)&val, sizeof(val),
+					  ppos, IDXD_VDCM_WRITE);
+			if (rc <= 0)
+				goto write_err;
+
+			filled = 4;
+		} else if (count >= 2 && !(*ppos % 2)) {
+			u16 val;
+
+			if (copy_from_user(&val, buf, sizeof(val)))
+				goto write_err;
+
+			rc = idxd_vdcm_rw(mdev, (char *)&val,
+					  sizeof(val), ppos, IDXD_VDCM_WRITE);
+			if (rc <= 0)
+				goto write_err;
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			if (copy_from_user(&val, buf, sizeof(val)))
+				goto write_err;
+
+			rc = idxd_vdcm_rw(mdev, &val, sizeof(val),
+					  ppos, IDXD_VDCM_WRITE);
+			if (rc <= 0)
+				goto write_err;
+
+			filled = 1;
+		}
+
+		count -= filled;
+		done += filled;
+		*ppos += filled;
+		buf += filled;
+	}
+
+	return done;
+write_err:
+	return -EFAULT;
+}
+
+static int check_vma(struct idxd_wq *wq, struct vm_area_struct *vma,
+		     const char *func)
+{
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int idxd_vdcm_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
+{
+	unsigned int wq_idx, rc;
+	unsigned long req_size, pgoff = 0, offset;
+	pgprot_t pg_prot;
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	struct idxd_wq *wq = vidxd->wq;
+	struct idxd_device *idxd = vidxd->idxd;
+	enum idxd_portal_prot virt_limited, phys_limited;
+	phys_addr_t base = pci_resource_start(idxd->pdev, IDXD_WQ_BAR);
+	struct device *dev = mdev_dev(mdev);
+
+	rc = check_vma(wq, vma, __func__);
+	if (rc)
+		return rc;
+
+	pg_prot = vma->vm_page_prot;
+	req_size = vma->vm_end - vma->vm_start;
+	vma->vm_flags |= VM_DONTCOPY;
+
+	offset = (vma->vm_pgoff << PAGE_SHIFT) &
+		 ((1ULL << VFIO_PCI_OFFSET_SHIFT) - 1);
+
+	wq_idx = offset >> (PAGE_SHIFT + 2);
+	if (wq_idx >= 1) {
+		dev_err(dev, "mapping invalid wq %d off %lx\n",
+			wq_idx, offset);
+		return -EINVAL;
+	}
+
+	virt_limited = ((offset >> PAGE_SHIFT) & 0x3) == 1;
+	phys_limited = IDXD_PORTAL_LIMITED;
+
+	if (virt_limited == IDXD_PORTAL_UNLIMITED && wq_dedicated(wq))
+		phys_limited = IDXD_PORTAL_UNLIMITED;
+
+	/* We always map IMS portals to the guest */
+	pgoff = (base +
+		idxd_get_wq_portal_full_offset(wq->id, phys_limited,
+					       IDXD_IRQ_IMS)) >> PAGE_SHIFT;
+
+	dev_dbg(dev, "mmap %lx %lx %lx %lx\n", vma->vm_start, pgoff, req_size,
+		pgprot_val(pg_prot));
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_private_data = mdev;
+	vma->vm_pgoff = pgoff;
+	vma->vm_private_data = mdev;
+
+	return remap_pfn_range(vma, vma->vm_start, pgoff, req_size, pg_prot);
+}
+
+static int idxd_vdcm_get_irq_count(struct vdcm_idxd *vidxd, int type)
+{
+	if (type == VFIO_PCI_MSI_IRQ_INDEX ||
+	    type == VFIO_PCI_MSIX_IRQ_INDEX)
+		return vidxd->num_wqs + 1;
+
+	return 0;
+}
+
+static int vdcm_idxd_set_msix_trigger(struct vdcm_idxd *vidxd,
+				      unsigned int index, unsigned int start,
+				      unsigned int count, uint32_t flags,
+				      void *data)
+{
+	struct eventfd_ctx *trigger;
+	int i, rc = 0;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	if (count > VIDXD_MAX_MSIX_ENTRIES - 1)
+		count = VIDXD_MAX_MSIX_ENTRIES - 1;
+
+	if (count == 0 && (flags & VFIO_IRQ_SET_DATA_NONE)) {
+		/* Disable all MSIX entries */
+		for (i = 0; i < VIDXD_MAX_MSIX_ENTRIES; i++) {
+			if (vidxd->vdev.msix_trigger[i]) {
+				dev_dbg(dev, "disable MSIX entry %d\n", i);
+				eventfd_ctx_put(vidxd->vdev.msix_trigger[i]);
+				vidxd->vdev.msix_trigger[i] = 0;
+
+				if (i) {
+					rc = vidxd_free_ims_entry(vidxd, i - 1);
+					if (rc)
+						return rc;
+				}
+			}
+		}
+		return 0;
+	}
+
+	for (i = 0; i < count; i++) {
+		if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+			u32 fd = *(u32 *)(data + i * sizeof(u32));
+
+			dev_dbg(dev, "enable MSIX entry %d\n", i);
+			trigger = eventfd_ctx_fdget(fd);
+			if (IS_ERR(trigger)) {
+				pr_err("eventfd_ctx_fdget failed %d\n", i);
+				return PTR_ERR(trigger);
+			}
+			vidxd->vdev.msix_trigger[i] = trigger;
+			/*
+			 * Allocate a vector from the OS and set in the IMS
+			 * entry
+			 */
+			if (i) {
+				rc = vidxd_setup_ims_entry(vidxd, i - 1, 0);
+				if (rc)
+					return rc;
+			}
+			fd++;
+		} else if (flags & VFIO_IRQ_SET_DATA_NONE) {
+			dev_dbg(dev, "disable MSIX entry %d\n", i);
+			eventfd_ctx_put(vidxd->vdev.msix_trigger[i]);
+			vidxd->vdev.msix_trigger[i] = 0;
+
+			if (i) {
+				rc = vidxd_free_ims_entry(vidxd, i - 1);
+				if (rc)
+					return rc;
+			}
+		}
+	}
+	return rc;
+}
+
+static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags,
+			      unsigned int index, unsigned int start,
+			      unsigned int count, void *data)
+{
+	int (*func)(struct vdcm_idxd *vidxd, unsigned int index,
+		    unsigned int start, unsigned int count, uint32_t flags,
+		    void *data) = NULL;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	int msixcnt = pci_msix_vec_count(vidxd->idxd->pdev);
+
+	if (msixcnt < 0)
+		return -ENXIO;
+
+	switch (index) {
+	case VFIO_PCI_INTX_IRQ_INDEX:
+		dev_warn(dev, "intx interrupts not supported.\n");
+		break;
+	case VFIO_PCI_MSI_IRQ_INDEX:
+		dev_dbg(dev, "msi interrupt.\n");
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_MASK:
+		case VFIO_IRQ_SET_ACTION_UNMASK:
+			break;
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			func = vdcm_idxd_set_msix_trigger;
+			break;
+		}
+		break;
+	case VFIO_PCI_MSIX_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_MASK:
+		case VFIO_IRQ_SET_ACTION_UNMASK:
+			break;
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			func = vdcm_idxd_set_msix_trigger;
+			break;
+		}
+		break;
+	default:
+		return -ENOTTY;
+	}
+
+	if (!func)
+		return -ENOTTY;
+
+	return func(vidxd, index, start, count, flags, data);
+}
+
+static void vidxd_vdcm_reset(struct vdcm_idxd *vidxd)
+{
+	vidxd_reset(vidxd);
+}
+
+static long idxd_vdcm_ioctl(struct mdev_device *mdev, unsigned int cmd,
+			    unsigned long arg)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	unsigned long minsz;
+	int rc = -EINVAL;
+	struct device *dev = mdev_dev(mdev);
+
+	dev_dbg(dev, "vidxd %lx ioctl, cmd: %d\n", vidxd->handle, cmd);
+
+	if (cmd == VFIO_DEVICE_GET_INFO) {
+		struct vfio_device_info info;
+
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		info.flags = VFIO_DEVICE_FLAGS_PCI;
+		info.flags |= VFIO_DEVICE_FLAGS_RESET;
+		info.num_regions = VFIO_PCI_NUM_REGIONS;
+		info.num_irqs = VFIO_PCI_NUM_IRQS;
+
+		return copy_to_user((void __user *)arg, &info, minsz) ?
+			-EFAULT : 0;
+
+	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+		struct vfio_region_info info;
+		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+		int i;
+		struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
+		size_t size;
+		int nr_areas = 1;
+		int cap_type_id = 0;
+
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		switch (info.index) {
+		case VFIO_PCI_CONFIG_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = VIDXD_MAX_CFG_SPACE_SZ;
+			info.flags = VFIO_REGION_INFO_FLAG_READ |
+				     VFIO_REGION_INFO_FLAG_WRITE;
+			break;
+		case VFIO_PCI_BAR0_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = vidxd->bar_size[info.index];
+			if (!info.size) {
+				info.flags = 0;
+				break;
+			}
+
+			info.flags = VFIO_REGION_INFO_FLAG_READ |
+				     VFIO_REGION_INFO_FLAG_WRITE;
+			break;
+		case VFIO_PCI_BAR1_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = 0;
+			info.flags = 0;
+			break;
+		case VFIO_PCI_BAR2_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.flags = VFIO_REGION_INFO_FLAG_CAPS |
+				VFIO_REGION_INFO_FLAG_MMAP |
+				VFIO_REGION_INFO_FLAG_READ |
+				VFIO_REGION_INFO_FLAG_WRITE;
+			info.size = vidxd->bar_size[1];
+
+			/*
+			 * Every WQ has two areas for unlimited and limited
+			 * MSI-X portals. IMS portals are not reported
+			 */
+			nr_areas = 2;
+
+			size = sizeof(*sparse) +
+				(nr_areas * sizeof(*sparse->areas));
+			sparse = kzalloc(size, GFP_KERNEL);
+			if (!sparse)
+				return -ENOMEM;
+
+			sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+			sparse->header.version = 1;
+			sparse->nr_areas = nr_areas;
+			cap_type_id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+
+			sparse->areas[0].offset = 0;
+			sparse->areas[0].size = PAGE_SIZE;
+
+			sparse->areas[1].offset = PAGE_SIZE;
+			sparse->areas[1].size = PAGE_SIZE;
+			break;
+
+		case VFIO_PCI_BAR3_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = 0;
+			info.flags = 0;
+			dev_dbg(dev, "get region info bar:%d\n", info.index);
+			break;
+
+		case VFIO_PCI_ROM_REGION_INDEX:
+		case VFIO_PCI_VGA_REGION_INDEX:
+			dev_dbg(dev, "get region info index:%d\n",
+				info.index);
+			break;
+		default: {
+			struct vfio_region_info_cap_type cap_type = {
+				.header.id = VFIO_REGION_INFO_CAP_TYPE,
+				.header.version = 1
+			};
+
+			if (info.index >= VFIO_PCI_NUM_REGIONS +
+					vidxd->vdev.num_regions)
+				return -EINVAL;
+
+			i = info.index - VFIO_PCI_NUM_REGIONS;
+
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = vidxd->vdev.region[i].size;
+			info.flags = vidxd->vdev.region[i].flags;
+
+			cap_type.type = vidxd->vdev.region[i].type;
+			cap_type.subtype = vidxd->vdev.region[i].subtype;
+
+			rc = vfio_info_add_capability(&caps, &cap_type.header,
+						      sizeof(cap_type));
+			if (rc)
+				return rc;
+		} /* default */
+		} /* info.index switch */
+
+		if ((info.flags & VFIO_REGION_INFO_FLAG_CAPS) && sparse) {
+			if (cap_type_id == VFIO_REGION_INFO_CAP_SPARSE_MMAP) {
+				rc = vfio_info_add_capability(&caps,
+							      &sparse->header,
+							      sizeof(*sparse) +
+							      (sparse->nr_areas *
+							      sizeof(*sparse->areas)));
+				kfree(sparse);
+				if (rc)
+					return rc;
+			}
+		}
+
+		if (caps.size) {
+			if (info.argsz < sizeof(info) + caps.size) {
+				info.argsz = sizeof(info) + caps.size;
+				info.cap_offset = 0;
+			} else {
+				vfio_info_cap_shift(&caps, sizeof(info));
+				if (copy_to_user((void __user *)arg +
+						 sizeof(info), caps.buf,
+						 caps.size)) {
+					kfree(caps.buf);
+					return -EFAULT;
+				}
+				info.cap_offset = sizeof(info);
+			}
+
+			kfree(caps.buf);
+		}
+
+		return copy_to_user((void __user *)arg, &info, minsz) ?
+				    -EFAULT : 0;
+	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
+		struct vfio_irq_info info;
+
+		minsz = offsetofend(struct vfio_irq_info, count);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
+			return -EINVAL;
+
+		switch (info.index) {
+		case VFIO_PCI_MSI_IRQ_INDEX:
+		case VFIO_PCI_MSIX_IRQ_INDEX:
+		default:
+			return -EINVAL;
+		} /* switch(info.index) */
+
+		info.flags = VFIO_IRQ_INFO_EVENTFD | VFIO_IRQ_INFO_NORESIZE;
+		info.count = idxd_vdcm_get_irq_count(vidxd, info.index);
+
+		return copy_to_user((void __user *)arg, &info, minsz) ?
+			-EFAULT : 0;
+	} else if (cmd == VFIO_DEVICE_SET_IRQS) {
+		struct vfio_irq_set hdr;
+		u8 *data = NULL;
+		size_t data_size = 0;
+
+		minsz = offsetofend(struct vfio_irq_set, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE)) {
+			int max = idxd_vdcm_get_irq_count(vidxd, hdr.index);
+
+			rc = vfio_set_irqs_validate_and_prepare(&hdr, max,
+								VFIO_PCI_NUM_IRQS,
+								&data_size);
+			if (rc) {
+				dev_err(dev, "intel:vfio_set_irqs_validate_and_prepare failed\n");
+				return -EINVAL;
+			}
+			if (data_size) {
+				data = memdup_user((void __user *)(arg + minsz),
+						   data_size);
+				if (IS_ERR(data))
+					return PTR_ERR(data);
+			}
+		}
+
+		if (!data)
+			return -EINVAL;
+
+		rc = idxd_vdcm_set_irqs(vidxd, hdr.flags, hdr.index,
+					hdr.start, hdr.count, data);
+		kfree(data);
+		return rc;
+	} else if (cmd == VFIO_DEVICE_RESET) {
+		vidxd_vdcm_reset(vidxd);
+		return 0;
+	}
+
+	return rc;
+}
+
+static ssize_t name_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	struct vdcm_idxd_type *type;
+
+	type = idxd_vdcm_find_vidxd_type(dev, kobject_name(kobj));
+
+	if (type)
+		return sprintf(buf, "%s\n", type->description);
+
+	return -EINVAL;
+}
+static MDEV_TYPE_ATTR_RO(name);
+
+static int find_available_mdev_instances(struct idxd_device *idxd)
+{
+	int count = 0, i;
+
+	for (i = 0; i < idxd->max_wqs; i++) {
+		struct idxd_wq *wq;
+
+		wq = &idxd->wqs[i];
+		if (!is_idxd_wq_mdev(wq))
+			continue;
+
+		if ((idxd_wq_refcount(wq) <= 1 && wq_dedicated(wq)) ||
+		    !wq_dedicated(wq))
+			count++;
+	}
+
+	return count;
+}
+
+static ssize_t available_instances_show(struct kobject *kobj,
+					struct device *dev, char *buf)
+{
+	int count;
+	struct idxd_device *idxd = dev_get_drvdata(dev);
+	struct vdcm_idxd_type *type;
+
+	type = idxd_vdcm_find_vidxd_type(dev, kobject_name(kobj));
+	if (!type)
+		return -EINVAL;
+
+	count = find_available_mdev_instances(idxd);
+
+	return sprintf(buf, "%d\n", count);
+}
+static MDEV_TYPE_ATTR_RO(available_instances);
+
+static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
+			       char *buf)
+{
+	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
+}
+static MDEV_TYPE_ATTR_RO(device_api);
+
+static struct attribute *idxd_mdev_types_attrs[] = {
+	&mdev_type_attr_name.attr,
+	&mdev_type_attr_device_api.attr,
+	&mdev_type_attr_available_instances.attr,
+	NULL,
+};
+
+static struct attribute_group idxd_mdev_type_group0 = {
+	.name  = "wq",
+	.attrs = idxd_mdev_types_attrs,
+};
+
+static struct attribute_group *idxd_mdev_type_groups[] = {
+	&idxd_mdev_type_group0,
+	NULL,
+};
+
+static const struct mdev_parent_ops idxd_vdcm_ops = {
+	.supported_type_groups	= idxd_mdev_type_groups,
+	.create			= idxd_vdcm_create,
+	.remove			= idxd_vdcm_remove,
+	.open			= idxd_vdcm_open,
+	.release		= idxd_vdcm_release,
+	.read			= idxd_vdcm_read,
+	.write			= idxd_vdcm_write,
+	.mmap			= idxd_vdcm_mmap,
+	.ioctl			= idxd_vdcm_ioctl,
+};
+
+int idxd_mdev_host_init(struct idxd_device *idxd)
+{
+	struct device *dev = &idxd->pdev->dev;
+	int rc;
+
+	if (iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_AUX)) {
+		rc = iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_AUX);
+		if (rc < 0)
+			dev_warn(dev, "Failed to enable aux-domain: %d\n",
+				 rc);
+	} else {
+		dev_dbg(dev, "No aux-domain feature.\n");
+	}
+
+	return mdev_register_device(dev, &idxd_vdcm_ops);
+}
+
+void idxd_mdev_host_release(struct idxd_device *idxd)
+{
+	struct device *dev = &idxd->pdev->dev;
+	int rc;
+
+	if (iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_AUX)) {
+		rc = iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
+		if (rc < 0)
+			dev_warn(dev, "Failed to disable aux-domain: %d\n",
+				 rc);
+	}
+
+	mdev_unregister_device(dev);
+}
diff --git a/drivers/dma/idxd/mdev.h b/drivers/dma/idxd/mdev.h
index 5b05b6cb2b7b..0b3a4c9822d4 100644
--- a/drivers/dma/idxd/mdev.h
+++ b/drivers/dma/idxd/mdev.h
@@ -48,6 +48,8 @@ struct ims_irq_entry {
 
 struct idxd_vdev {
 	struct mdev_device *mdev;
+	struct vfio_region *region;
+	int num_regions;
 	struct eventfd_ctx *msix_trigger[VIDXD_MAX_MSIX_ENTRIES];
 	struct notifier_block group_notifier;
 	struct kvm *kvm;
@@ -79,4 +81,25 @@ static inline struct vdcm_idxd *to_vidxd(struct idxd_vdev *vdev)
 	return container_of(vdev, struct vdcm_idxd, vdev);
 }
 
+#define IDXD_MDEV_NAME_LEN 16
+#define IDXD_MDEV_DESCRIPTION_LEN 64
+
+enum idxd_mdev_type {
+	IDXD_MDEV_TYPE_WQ = 0,
+};
+
+#define IDXD_MDEV_TYPES 1
+
+struct vdcm_idxd_type {
+	char name[IDXD_MDEV_NAME_LEN];
+	char description[IDXD_MDEV_DESCRIPTION_LEN];
+	enum idxd_mdev_type type;
+	unsigned int avail_instance;
+};
+
+enum idxd_vdcm_rw {
+	IDXD_VDCM_READ = 0,
+	IDXD_VDCM_WRITE,
+};
+
 #endif
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index a39e7ae6b3d9..043cf825a71f 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -137,6 +137,8 @@ enum idxd_device_status_state {
 	IDXD_DEVICE_STATE_HALT,
 };
 
+#define IDXD_GENSTATS_MASK		0x03
+
 enum idxd_device_reset_type {
 	IDXD_DEVICE_RESET_SOFTWARE = 0,
 	IDXD_DEVICE_RESET_FLR,
@@ -160,6 +162,7 @@ union idxd_command_reg {
 	};
 	u32 bits;
 } __packed;
+#define IDXD_CMD_INT_MASK		0x80000000
 
 enum idxd_cmd {
 	IDXD_CMD_ENABLE_DEVICE = 1,
@@ -333,4 +336,11 @@ union wqcfg {
 	};
 	u32 bits[8];
 } __packed;
+
+enum idxd_wq_hw_state {
+	IDXD_WQ_DEV_DISABLED = 0,
+	IDXD_WQ_DEV_ENABLED,
+	IDXD_WQ_DEV_BUSY,
+};
+
 #endif
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index bdcac933bb28..ee976b51b88d 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -57,6 +57,21 @@ struct idxd_desc *idxd_alloc_desc(struct idxd_wq *wq,
 	desc = wq->descs[idx];
 	memset(desc->hw, 0, sizeof(struct dsa_hw_desc));
 	memset(desc->completion, 0, sizeof(struct dsa_completion_record));
+
+	if (idxd->pasid_enabled)
+		desc->hw->pasid = idxd->pasid;
+
+	/*
+	 * Descriptor completion vectors are 1-8 for MSIX. We will round
+	 * robin through the 8 vectors.
+	 */
+	if (!idxd->int_handles) {
+		wq->vec_ptr = (wq->vec_ptr % idxd->num_wq_irqs) + 1;
+		desc->hw->int_handle =  wq->vec_ptr;
+	} else {
+		desc->hw->int_handle = idxd->int_handles[wq->id];
+	}
+
 	return desc;
 }
 
@@ -115,7 +130,6 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc,
 		     enum idxd_op_type optype)
 {
 	struct idxd_device *idxd = wq->idxd;
-	int vec = desc->hw->int_handle;
 	int rc;
 	void __iomem *portal;
 
@@ -143,9 +157,19 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc,
 	 * Pending the descriptor to the lockless list for the irq_entry
 	 * that we designated the descriptor to.
 	 */
-	if (desc->hw->flags & IDXD_OP_FLAG_RCI)
+	if (desc->hw->flags & IDXD_OP_FLAG_RCI) {
+		int vec;
+
+		/*
+		 * If the driver is on host kernel, it would be the value
+		 * assigned to interrupt handle, which is index for MSIX
+		 * vector. If it's guest then we'll set it to 1 for now
+		 * since only 1 workqueue is exported.
+		 */
+		vec = !idxd->int_handles ? desc->hw->int_handle : 1;
 		llist_add(&desc->llnode,
 			  &idxd->irq_entries[vec].pending_llist);
+	}
 
 	return 0;
 }
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 07bad4f6c7fb..a175c2381e0e 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/uuid.h>
 #include <linux/device.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <uapi/linux/idxd.h>
@@ -14,6 +15,7 @@ static char *idxd_wq_type_names[] = {
 	[IDXD_WQT_NONE]		= "none",
 	[IDXD_WQT_KERNEL]	= "kernel",
 	[IDXD_WQT_USER]		= "user",
+	[IDXD_WQT_MDEV]		= "mdev",
 };
 
 static void idxd_conf_device_release(struct device *dev)
@@ -69,6 +71,11 @@ static inline bool is_idxd_wq_cdev(struct idxd_wq *wq)
 	return wq->type == IDXD_WQT_USER;
 }
 
+inline bool is_idxd_wq_mdev(struct idxd_wq *wq)
+{
+	return wq->type == IDXD_WQT_MDEV ? true : false;
+}
+
 static int idxd_config_bus_match(struct device *dev,
 				 struct device_driver *drv)
 {
@@ -205,6 +212,13 @@ static int idxd_config_bus_probe(struct device *dev)
 				mutex_unlock(&wq->wq_lock);
 				return -EINVAL;
 			}
+
+			/* This check is added until we have SVM support for mdev */
+			if (wq->type == IDXD_WQT_MDEV) {
+				dev_warn(dev, "Shared MDEV unsupported.");
+				mutex_unlock(&wq->wq_lock);
+				return -EINVAL;
+			}
 		}
 
 		rc = idxd_wq_alloc_resources(wq);
@@ -237,7 +251,7 @@ static int idxd_config_bus_probe(struct device *dev)
 			}
 		}
 
-		rc = idxd_wq_enable(wq);
+		rc = idxd_wq_enable(wq, NULL);
 		if (rc < 0) {
 			spin_unlock_irqrestore(&idxd->dev_lock, flags);
 			mutex_unlock(&wq->wq_lock);
@@ -250,7 +264,7 @@ static int idxd_config_bus_probe(struct device *dev)
 		rc = idxd_wq_map_portal(wq);
 		if (rc < 0) {
 			dev_warn(dev, "wq portal mapping failed: %d\n", rc);
-			rc = idxd_wq_disable(wq);
+			rc = idxd_wq_disable(wq, NULL);
 			if (rc < 0)
 				dev_warn(dev, "IDXD wq disable failed\n");
 			spin_unlock_irqrestore(&idxd->dev_lock, flags);
@@ -311,7 +325,7 @@ static void disable_wq(struct idxd_wq *wq)
 	idxd_wq_unmap_portal(wq);
 
 	spin_lock_irqsave(&idxd->dev_lock, flags);
-	rc = idxd_wq_disable(wq);
+	rc = idxd_wq_disable(wq, NULL);
 	spin_unlock_irqrestore(&idxd->dev_lock, flags);
 
 	idxd_wq_free_resources(wq);
@@ -1106,6 +1120,100 @@ static ssize_t wq_threshold_store(struct device *dev,
 static struct device_attribute dev_attr_wq_threshold =
 		__ATTR(threshold, 0644, wq_threshold_show, wq_threshold_store);
 
+static ssize_t wq_uuid_store(struct device *dev,
+			     struct device_attribute *attr, const char *buf,
+			     size_t count)
+{
+	char *str;
+	int rc;
+	struct idxd_wq_uuid *entry, *n;
+	struct idxd_wq_uuid *wq_uuid;
+	struct idxd_wq *wq = container_of(dev, struct idxd_wq, conf_dev);
+	struct device *ddev = &wq->idxd->pdev->dev;
+
+	if (wq->type != IDXD_WQT_MDEV)
+		return -EPERM;
+
+	if (count < UUID_STRING_LEN || (count > UUID_STRING_LEN + 1))
+		return -EINVAL;
+
+	str = kstrndup(buf, count, GFP_KERNEL);
+	if (!str)
+		return -ENOMEM;
+
+	wq_uuid = devm_kzalloc(ddev, sizeof(struct idxd_wq_uuid), GFP_KERNEL);
+	if (!wq_uuid) {
+		kfree(str);
+		return -ENOMEM;
+	}
+
+	rc = guid_parse(str, &wq_uuid->uuid);
+	kfree(str);
+	if (rc)
+		return rc;
+
+	mutex_lock(&wq->wq_lock);
+	/* If user writes 0, erase entire list. */
+	if (guid_is_null(&wq_uuid->uuid)) {
+		list_for_each_entry_safe(entry, n, &wq->uuid_list, list) {
+			list_del(&entry->list);
+			devm_kfree(ddev, entry);
+			wq->uuids--;
+		}
+
+		mutex_unlock(&wq->wq_lock);
+		return count;
+	}
+
+	/* If uuid already exists, remove the old uuid. */
+	list_for_each_entry_safe(entry, n, &wq->uuid_list, list) {
+		if (guid_equal(&wq_uuid->uuid, &entry->uuid)) {
+			list_del(&entry->list);
+			devm_kfree(ddev, entry);
+			wq->uuids--;
+			mutex_unlock(&wq->wq_lock);
+			return count;
+		}
+	}
+
+	/*
+	 * At this point, we are only adding, and the wq must be on in order
+	 * to do so. A disabled wq type is ambiguous.
+	 */
+	if (wq->state != IDXD_WQ_ENABLED)
+		return -EPERM;
+	/*
+	 * If wq is shared or wq is dedicated and list empty,
+	 * put uuid into list.
+	 */
+	if (!wq_dedicated(wq) || list_empty(&wq->uuid_list)) {
+		wq->uuids++;
+		list_add(&wq_uuid->list, &wq->uuid_list);
+	} else {
+		mutex_unlock(&wq->wq_lock);
+		return -EPERM;
+	}
+
+	mutex_unlock(&wq->wq_lock);
+	return count;
+}
+
+static ssize_t wq_uuid_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct idxd_wq *wq = container_of(dev, struct idxd_wq, conf_dev);
+	struct idxd_wq_uuid *entry;
+	int out = 0;
+
+	list_for_each_entry(entry, &wq->uuid_list, list)
+		out += sprintf(buf + out, "%pUl\n", &entry->uuid);
+
+	return out;
+}
+
+static struct device_attribute dev_attr_wq_uuid =
+		__ATTR(uuid, 0644, wq_uuid_show, wq_uuid_store);
+
 static ssize_t wq_type_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
@@ -1116,8 +1224,9 @@ static ssize_t wq_type_show(struct device *dev,
 		return sprintf(buf, "%s\n",
 			       idxd_wq_type_names[IDXD_WQT_KERNEL]);
 	case IDXD_WQT_USER:
-		return sprintf(buf, "%s\n",
-			       idxd_wq_type_names[IDXD_WQT_USER]);
+		return sprintf(buf, "%s\n", idxd_wq_type_names[IDXD_WQT_USER]);
+	case IDXD_WQT_MDEV:
+		return sprintf(buf, "%s\n", idxd_wq_type_names[IDXD_WQT_MDEV]);
 	case IDXD_WQT_NONE:
 	default:
 		return sprintf(buf, "%s\n",
@@ -1127,6 +1236,20 @@ static ssize_t wq_type_show(struct device *dev,
 	return -EINVAL;
 }
 
+static void wq_clear_uuids(struct idxd_wq *wq)
+{
+	struct idxd_wq_uuid *entry, *n;
+	struct device *dev = &wq->idxd->pdev->dev;
+
+	mutex_lock(&wq->wq_lock);
+	list_for_each_entry_safe(entry, n, &wq->uuid_list, list) {
+		list_del(&entry->list);
+		devm_kfree(dev, entry);
+		wq->uuids--;
+	}
+	mutex_unlock(&wq->wq_lock);
+}
+
 static ssize_t wq_type_store(struct device *dev,
 			     struct device_attribute *attr, const char *buf,
 			     size_t count)
@@ -1144,13 +1267,20 @@ static ssize_t wq_type_store(struct device *dev,
 		wq->type = IDXD_WQT_KERNEL;
 	else if (sysfs_streq(buf, idxd_wq_type_names[IDXD_WQT_USER]))
 		wq->type = IDXD_WQT_USER;
+	else if (sysfs_streq(buf, idxd_wq_type_names[IDXD_WQT_MDEV]))
+		wq->type = IDXD_WQT_MDEV;
 	else
 		return -EINVAL;
 
 	/* If we are changing queue type, clear the name */
-	if (wq->type != old_type)
+	if (wq->type != old_type) {
 		memset(wq->name, 0, WQ_NAME_SIZE + 1);
 
+		/* If changed out of MDEV type, clear uuids */
+		if (wq->type != IDXD_WQT_MDEV)
+			wq_clear_uuids(wq);
+	}
+
 	return count;
 }
 
@@ -1218,6 +1348,7 @@ static struct attribute *idxd_wq_attributes[] = {
 	&dev_attr_wq_type.attr,
 	&dev_attr_wq_name.attr,
 	&dev_attr_wq_cdev_minor.attr,
+	&dev_attr_wq_uuid.attr,
 	NULL,
 };
 
diff --git a/drivers/dma/idxd/vdev.c b/drivers/dma/idxd/vdev.c
new file mode 100644
index 000000000000..d2a15f1dae6a
--- /dev/null
+++ b/drivers/dma/idxd/vdev.c
@@ -0,0 +1,570 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2019 Intel Corporation. All rights rsvd. */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/sched/task.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/mm.h>
+#include <linux/mmu_context.h>
+#include <linux/vfio.h>
+#include <linux/mdev.h>
+#include <linux/msi.h>
+#include <linux/intel-iommu.h>
+#include <linux/intel-svm.h>
+#include <linux/kvm_host.h>
+#include <linux/eventfd.h>
+#include <uapi/linux/idxd.h>
+#include "registers.h"
+#include "idxd.h"
+#include "../../vfio/pci/vfio_pci_private.h"
+#include "mdev.h"
+#include "vdev.h"
+
+static int idxd_get_mdev_pasid(struct mdev_device *mdev)
+{
+	struct iommu_domain *domain;
+	struct device *dev = mdev_dev(mdev);
+
+	domain = mdev_get_iommu_domain(dev);
+	if (!domain)
+		return -EINVAL;
+
+	return iommu_aux_get_pasid(domain, dev->parent);
+}
+
+int vidxd_send_interrupt(struct vdcm_idxd *vidxd, int msix_idx)
+{
+	int rc = -1;
+	struct device *dev = &vidxd->idxd->pdev->dev;
+
+	/*
+	 * We need to check MSIX mask bit only for entry 0 because that is
+	 * the only virtual interrupt. Other interrupts are physical
+	 * interrupts, and they are setup such that we receive them only
+	 * when guest wants to receive them.
+	 */
+	if (msix_idx == 0) {
+		u8 *msix_perm = &vidxd->bar0.msix_perm_table[0];
+
+		if (msix_perm[0] & 1) {
+			set_bit(0, (unsigned long *)&vidxd->bar0.msix_pba);
+			set_bit(1, (unsigned long *)msix_perm);
+		}
+		return 1;
+	}
+
+	if (!vidxd->vdev.msix_trigger[msix_idx]) {
+		dev_warn(dev, "%s: intr evtfd not found %d\n",
+			 __func__, msix_idx);
+		return -EINVAL;
+	}
+
+	rc = eventfd_signal(vidxd->vdev.msix_trigger[msix_idx], 1);
+	if (rc != 1)
+		dev_err(dev, "eventfd signal failed (%d)\n", rc);
+	else
+		dev_dbg(dev, "vidxd interrupt triggered wq(%d) %d\n",
+			vidxd->wq->id, msix_idx);
+
+	return rc;
+}
+
+static void vidxd_mmio_init_grpcfg(struct vdcm_idxd *vidxd,
+				   struct grpcfg *grpcfg)
+{
+	struct idxd_wq *wq = vidxd->wq;
+	struct idxd_group *group = wq->group;
+	int i;
+
+	/*
+	 * At this point, we are only exporting a single workqueue for
+	 * each mdev. So we need to just fake it as first workqueue
+	 * and also mark the available engines in this group.
+	 */
+
+	/* Set single workqueue and the first one */
+	grpcfg->wqs[0] = 0x1;
+	grpcfg->engines = 0;
+	for (i = 0; i < group->num_engines; i++)
+		grpcfg->engines |= BIT(i);
+	grpcfg->flags.bits = group->grpcfg.flags.bits;
+}
+
+void vidxd_mmio_init(struct vdcm_idxd *vidxd)
+{
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	struct idxd_device *idxd = vidxd->idxd;
+	struct idxd_wq *wq = vidxd->wq;
+	union wqcfg *wqcfg;
+	struct grpcfg *grpcfg;
+	union wq_cap_reg *wq_cap;
+	union offsets_reg *offsets;
+
+	/* setup wqcfg */
+	wqcfg = (union wqcfg *)&bar0->wq_ctrl_regs[0];
+	grpcfg = (struct grpcfg *)&bar0->grp_ctrl_regs[0];
+
+	wqcfg->wq_size = wq->size;
+	wqcfg->wq_thresh = wq->threshold;
+
+	if (wq_dedicated(wq))
+		wqcfg->mode = 1;
+
+	if (idxd->hw.gen_cap.block_on_fault &&
+	    test_bit(WQ_FLAG_BOF, &wq->flags))
+		wqcfg->bof = 1;
+
+	wqcfg->priority = wq->priority;
+	wqcfg->max_xfer_shift = idxd->hw.gen_cap.max_xfer_shift;
+	wqcfg->max_batch_shift = idxd->hw.gen_cap.max_batch_shift;
+	/* make mode change read-only */
+	wqcfg->mode_support = 0;
+
+	/* setup grpcfg */
+	vidxd_mmio_init_grpcfg(vidxd, grpcfg);
+
+	/* setup wqcap */
+	wq_cap = (union wq_cap_reg *)&bar0->cap_ctrl_regs[IDXD_WQCAP_OFFSET];
+	memset(wq_cap, 0, sizeof(union wq_cap_reg));
+	wq_cap->total_wq_size = wq->size;
+	wq_cap->num_wqs = 1;
+	if (wq_dedicated(wq))
+		wq_cap->dedicated_mode = 1;
+	else
+		wq_cap->shared_mode = 1;
+
+	offsets = (union offsets_reg *)&bar0->cap_ctrl_regs[IDXD_TABLE_OFFSET];
+	offsets->grpcfg = VIDXD_GRPCFG_OFFSET / 0x100;
+	offsets->wqcfg = VIDXD_WQCFG_OFFSET / 0x100;
+	offsets->msix_perm = VIDXD_MSIX_PERM_OFFSET / 0x100;
+
+	/* Clear MSI-X permissions table */
+	memset(bar0->msix_perm_table, 0, 2 * 8);
+}
+
+static void idxd_complete_command(struct vdcm_idxd *vidxd,
+				  enum idxd_cmdsts_err val)
+{
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	u32 *cmd = (u32 *)&bar0->cap_ctrl_regs[IDXD_CMD_OFFSET];
+	u32 *cmdsts = (u32 *)&bar0->cap_ctrl_regs[IDXD_CMDSTS_OFFSET];
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	*cmdsts = val;
+	dev_dbg(dev, "%s: cmd: %#x  status: %#x\n", __func__, *cmd, val);
+
+	if (*cmd & IDXD_CMD_INT_MASK) {
+		bar0->cap_ctrl_regs[IDXD_INTCAUSE_OFFSET] |= IDXD_INTC_CMD;
+		vidxd_send_interrupt(vidxd, 0);
+	}
+}
+
+static void vidxd_enable(struct vdcm_idxd *vidxd)
+{
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	bool ats = (*(u16 *)&vidxd->cfg[VIDXD_ATS_OFFSET + 6]) & (1U << 15);
+	bool prs = (*(u16 *)&vidxd->cfg[VIDXD_PRS_OFFSET + 4]) & 1U;
+	bool pasid = (*(u16 *)&vidxd->cfg[VIDXD_PASID_OFFSET + 6]) & 1U;
+	u32 vdev_state = *(u32 *)&bar0->cap_ctrl_regs[IDXD_GENSTATS_OFFSET] &
+			 IDXD_GENSTATS_MASK;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (vdev_state == IDXD_DEVICE_STATE_ENABLED)
+		return idxd_complete_command(vidxd,
+					     IDXD_CMDSTS_ERR_DEV_ENABLED);
+
+	/* Check PCI configuration */
+	if (!(vidxd->cfg[PCI_COMMAND] & PCI_COMMAND_MASTER))
+		return idxd_complete_command(vidxd,
+					     IDXD_CMDSTS_ERR_BUSMASTER_EN);
+
+	if (pasid != prs || (pasid && !ats))
+		return idxd_complete_command(vidxd,
+					     IDXD_CMDSTS_ERR_BUSMASTER_EN);
+
+	bar0->cap_ctrl_regs[IDXD_GENSTATS_OFFSET] = IDXD_DEVICE_STATE_ENABLED;
+
+	return idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_disable(struct vdcm_idxd *vidxd)
+{
+	int rc;
+	struct idxd_wq *wq;
+	union wqcfg *wqcfg;
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	u32 vdev_state = *(u32 *)&bar0->cap_ctrl_regs[IDXD_GENSTATS_OFFSET] &
+			 IDXD_GENSTATS_MASK;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (vdev_state == IDXD_DEVICE_STATE_DISABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DIS_DEV_EN);
+		return;
+	}
+
+	wqcfg = (union wqcfg *)&bar0->wq_ctrl_regs[0];
+	wq = vidxd->wq;
+
+	/* If it is a DWQ, need to disable the DWQ as well */
+	rc = idxd_wq_drain(wq);
+	if (rc < 0)
+		dev_warn(dev, "vidxd drain wq %d failed: %d\n",
+			 wq->id, rc);
+
+	if (wq_dedicated(wq)) {
+		rc = idxd_wq_disable(wq, NULL);
+		if (rc < 0)
+			dev_warn(dev, "vidxd disable wq %d failed: %d\n",
+				 wq->id, rc);
+	}
+
+	wqcfg->wq_state = 0;
+	bar0->cap_ctrl_regs[IDXD_GENSTATS_OFFSET] = IDXD_DEVICE_STATE_DISABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_drain(struct vdcm_idxd *vidxd)
+{
+	int rc;
+	struct idxd_wq *wq;
+	union wqcfg *wqcfg;
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	u32 vdev_state = *(u32 *)&bar0->cap_ctrl_regs[IDXD_GENSTATS_OFFSET] &
+			 IDXD_GENSTATS_MASK;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (vdev_state == IDXD_DEVICE_STATE_DISABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DEV_NOT_EN);
+		return;
+	}
+
+	wqcfg = (union wqcfg *)&bar0->wq_ctrl_regs[0];
+	wq = vidxd->wq;
+
+	rc = idxd_wq_drain(wq);
+	if (rc < 0)
+		dev_warn(dev, "wq %d drain failed: %d\n", wq->id, rc);
+
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_abort(struct vdcm_idxd *vidxd)
+{
+	int rc;
+	struct idxd_wq *wq;
+	union wqcfg *wqcfg;
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	u32 vdev_state = *(u32 *)&bar0->cap_ctrl_regs[IDXD_GENSTATS_OFFSET] &
+			 IDXD_GENSTATS_MASK;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (vdev_state == IDXD_DEVICE_STATE_DISABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DEV_NOT_EN);
+		return;
+	}
+
+	wqcfg = (union wqcfg *)&bar0->wq_ctrl_regs[0];
+	wq = vidxd->wq;
+
+	rc = idxd_wq_abort(wq);
+	if (rc < 0)
+		dev_warn(dev, "wq %d drain failed: %d\n", wq->id, rc);
+
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_wq_drain(struct vdcm_idxd *vidxd, int val)
+{
+	vidxd_drain(vidxd);
+}
+
+static void vidxd_wq_abort(struct vdcm_idxd *vidxd, int val)
+{
+	vidxd_abort(vidxd);
+}
+
+void vidxd_reset(struct vdcm_idxd *vidxd)
+{
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	int rc;
+	struct idxd_wq *wq;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	*(u32 *)&bar0->cap_ctrl_regs[IDXD_GENSTATS_OFFSET] =
+		IDXD_DEVICE_STATE_DRAIN;
+
+	wq = vidxd->wq;
+
+	rc = idxd_wq_drain(wq);
+	if (rc < 0)
+		dev_warn(dev, "wq %d drain failed: %d\n", wq->id, rc);
+
+	/* If it is a DWQ, need to disable the DWQ as well */
+	if (wq_dedicated(wq)) {
+		rc = idxd_wq_disable(wq, NULL);
+		if (rc < 0)
+			dev_warn(dev, "vidxd disable wq %d failed: %d\n",
+				 wq->id, rc);
+	}
+
+	vidxd_mmio_init(vidxd);
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_alloc_int_handle(struct vdcm_idxd *vidxd, int vidx)
+{
+	bool ims = (vidx >> 16) & 1;
+	u32 cmdsts;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	vidx = vidx & 0xffff;
+
+	dev_dbg(dev, "allocating int handle for %x\n", vidx);
+
+	if (vidx != 1) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_INVAL_INT_IDX);
+		return;
+	}
+
+	if (ims) {
+		dev_warn(dev, "IMS allocation is not implemented yet\n");
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_NO_HANDLE);
+	} else {
+		vidx--; /* MSIX idx 0 is a slow path interrupt */
+		cmdsts = vidxd->ims_index[vidx] << 8;
+		dev_dbg(dev, "int handle %d:%lld\n", vidx,
+			vidxd->ims_index[vidx]);
+		idxd_complete_command(vidxd, cmdsts);
+	}
+}
+
+static void vidxd_wq_enable(struct vdcm_idxd *vidxd, int wq_id)
+{
+	struct idxd_wq *wq;
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	union wq_cap_reg *wqcap;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	struct idxd_device *idxd;
+	union wqcfg *vwqcfg, *wqcfg;
+	unsigned long flags;
+	int rc;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (wq_id >= 1) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_INVAL_WQIDX);
+		return;
+	}
+
+	idxd = vidxd->idxd;
+	wq = vidxd->wq;
+
+	dev_dbg(dev, "%s: wq %u:%u\n", __func__, wq_id, wq->id);
+
+	vwqcfg = (union wqcfg *)&bar0->wq_ctrl_regs[wq_id];
+	wqcap = (union wq_cap_reg *)&bar0->cap_ctrl_regs[IDXD_WQCAP_OFFSET];
+	wqcfg = &wq->wqcfg;
+
+	if (vidxd_state(vidxd) != IDXD_DEVICE_STATE_ENABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DEV_NOTEN);
+		return;
+	}
+
+	if (vwqcfg->wq_state != IDXD_WQ_DEV_DISABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_WQ_ENABLED);
+		return;
+	}
+
+	if (vwqcfg->wq_size == 0) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_WQ_SIZE);
+		return;
+	}
+
+	if ((!wq_dedicated(wq) && wqcap->shared_mode == 0) ||
+	    (wq_dedicated(wq) && wqcap->dedicated_mode == 0)) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_WQ_MODE);
+		return;
+	}
+
+	if (wq_dedicated(wq)) {
+		int wq_pasid;
+		u32 status;
+		int priv;
+
+		wq_pasid = idxd_get_mdev_pasid(mdev);
+		priv = 1;
+
+		if (wq_pasid >= 0) {
+			wqcfg->bits[2] &= ~0x3fffff00;
+			wqcfg->priv = priv;
+			wqcfg->pasid_en = 1;
+			wqcfg->pasid = wq_pasid;
+			dev_dbg(dev, "program pasid %d in wq %d\n",
+				wq_pasid, wq->id);
+                        spin_lock_irqsave(&idxd->dev_lock, flags);
+                        idxd_wq_update_pasid(wq, wq_pasid);
+                        idxd_wq_update_priv(wq, priv);
+                        rc = idxd_wq_enable(wq, &status);
+                        spin_unlock_irqrestore(&idxd->dev_lock, flags);
+			if (rc < 0) {
+				dev_err(dev, "vidxd enable wq %d failed\n", wq->id);
+				idxd_complete_command(vidxd, status);
+				return;
+			}
+                } else {
+                        dev_err(dev,
+                                "idxd pasid setup failed wq %d wq_pasid %d\n",
+                                wq->id, wq_pasid);
+			idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_PASID_EN);
+			return;
+		}
+	}
+
+	vwqcfg->wq_state = IDXD_WQ_DEV_ENABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_wq_disable(struct vdcm_idxd *vidxd, int wq_id_mask)
+{
+	struct idxd_wq *wq;
+	union wqcfg *wqcfg;
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	int rc;
+
+	wq = vidxd->wq;
+
+	if (!(wq_id_mask & BIT(0))) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_INVAL_WQIDX);
+		return;
+	}
+
+	dev_dbg(dev, "vidxd disable wq %u:%u\n", 0, wq->id);
+
+	wqcfg = (union wqcfg *)&bar0->wq_ctrl_regs[0];
+	if (wqcfg->wq_state != IDXD_WQ_DEV_ENABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DEV_NOT_EN);
+		return;
+	}
+
+	if (wq_dedicated(wq)) {
+		u32 status;
+
+		rc = idxd_wq_disable(wq, &status);
+		if (rc < 0) {
+			dev_err(dev, "vidxd disable wq %d failed\n", wq->id);
+			idxd_complete_command(vidxd, status);
+			return;
+		}
+	}
+
+	wqcfg->wq_state = IDXD_WQ_DEV_DISABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val)
+{
+	union idxd_command_reg *reg =
+		(union idxd_command_reg *)&vidxd->bar0.cap_ctrl_regs[IDXD_CMD_OFFSET];
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	reg->bits = val;
+
+	dev_dbg(dev, "%s: cmd code: %u reg: %x\n", __func__, reg->cmd,
+		reg->bits);
+
+	switch (reg->cmd) {
+	case IDXD_CMD_ENABLE_DEVICE:
+		vidxd_enable(vidxd);
+		break;
+	case IDXD_CMD_DISABLE_DEVICE:
+		vidxd_disable(vidxd);
+		break;
+	case IDXD_CMD_DRAIN_ALL:
+		vidxd_drain(vidxd);
+		break;
+	case IDXD_CMD_ABORT_ALL:
+		vidxd_abort(vidxd);
+		break;
+	case IDXD_CMD_RESET_DEVICE:
+		vidxd_reset(vidxd);
+		break;
+	case IDXD_CMD_ENABLE_WQ:
+		vidxd_wq_enable(vidxd, reg->operand);
+		break;
+	case IDXD_CMD_DISABLE_WQ:
+		vidxd_wq_disable(vidxd, reg->operand);
+		break;
+	case IDXD_CMD_DRAIN_WQ:
+		vidxd_wq_drain(vidxd, reg->operand);
+		break;
+	case IDXD_CMD_ABORT_WQ:
+		vidxd_wq_abort(vidxd, reg->operand);
+		break;
+	case IDXD_CMD_REQUEST_INT_HANDLE:
+		vidxd_alloc_int_handle(vidxd, reg->operand);
+		break;
+	default:
+		idxd_complete_command(vidxd, IDXD_CMDSTS_INVAL_CMD);
+		break;
+	}
+}
+
+int vidxd_setup_ims_entry(struct vdcm_idxd *vidxd, int ims_idx, u32 val)
+{
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	int pasid;
+	unsigned int ims_offset;
+
+	/*
+	 * Current implementation limits to 1 WQ for the vdev and therefore
+	 * also only 1 IMS interrupt for that vdev.
+	 */
+	if (ims_idx >= VIDXD_MAX_WQS) {
+		dev_warn(dev, "ims_idx greater than vidxd allowed: %d\n",
+			 ims_idx);
+		return -EINVAL;
+	}
+
+	/* Setup the PASID filtering */
+	pasid = idxd_get_mdev_pasid(mdev);
+
+	if (pasid >= 0) {
+		val = (1 << 3) | (pasid << 12) | (val & 7);
+		ims_offset = vidxd->idxd->ims_offset +
+			     vidxd->ims_index[ims_idx] * 0x10;
+		iowrite32(val, vidxd->idxd->reg_base + ims_offset + 12);
+	} else {
+		dev_warn(dev, "pasid setup failed for ims entry %lld\n",
+			 vidxd->ims_index[ims_idx]);
+	}
+
+	return 0;
+}
+
+int vidxd_free_ims_entry(struct vdcm_idxd *vidxd, int msix_idx)
+{
+	return 0;
+}
diff --git a/drivers/dma/idxd/vdev.h b/drivers/dma/idxd/vdev.h
new file mode 100644
index 000000000000..3dfff6d0f641
--- /dev/null
+++ b/drivers/dma/idxd/vdev.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2019 Intel Corporation. All rights rsvd. */
+
+#ifndef _IDXD_VDEV_H_
+#define _IDXD_VDEV_H_
+
+static inline u64 get_reg_val(void *buf, int size)
+{
+	u64 val = 0;
+
+	switch (size) {
+	case 8:
+		val = *(uint64_t *)buf;
+		break;
+	case 4:
+		val = *(uint32_t *)buf;
+		break;
+	case 2:
+		val = *(uint16_t *)buf;
+		break;
+	case 1:
+		val = *(uint8_t *)buf;
+		break;
+	}
+
+	return val;
+}
+
+static inline u8 vidxd_state(struct vdcm_idxd *vidxd)
+{
+	return vidxd->bar0.cap_ctrl_regs[IDXD_GENSTATS_OFFSET]
+		& IDXD_GENSTATS_MASK;
+}
+
+void vidxd_mmio_init(struct vdcm_idxd *vidxd);
+int vidxd_free_ims_entry(struct vdcm_idxd *vidxd, int msix_idx);
+int vidxd_setup_ims_entry(struct vdcm_idxd *vidxd, int ims_idx, u32 val);
+int vidxd_send_interrupt(struct vdcm_idxd *vidxd, int msix_idx);
+void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val);
+void vidxd_reset(struct vdcm_idxd *vidxd);
+
+#endif


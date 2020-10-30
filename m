Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733CA2A0DFC
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgJ3Sxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:53:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:10513 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbgJ3Sx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:53:29 -0400
IronPort-SDR: vI1QbNRJO5rQgSoT8f6KP/TgwiIMuNcJee3ktnzA1MyMiGn/deCO5WX/IUE4O8smXNFsGbOfTP
 877VywADkjLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="168781964"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="168781964"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:27 -0700
IronPort-SDR: NhlgJn489O9QulgVEROoMY+MoNSpZbLLUFSYR9kZ6vZDeNQ1uhzXbtPEqLref3lVwBHUMaZRAr
 lIe7bo3rHS/A==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="319408331"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:25 -0700
Subject: [PATCH v4 05/17] dmaengine: idxd: add interrupt handle request
 support
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 30 Oct 2020 11:51:25 -0700
Message-ID: <160408388556.912050.3620822104414694832.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for requesting interrupt handle from the device. The interrupt
handle is put in the interrupt handle field of a descriptor for the device
to determine which interrupt vector to use be it MSI-X or IMS. On the host
device, the interrupt handle is indexed to the MSI-X table. This allows a
descriptor to program the interrupt handle 1:1 with the MSI-X index without
getting it from the request interrupt handle device command. For a guest
device, the index can be any index that the host assigned for the IMS
table, and therefore it must be requested from the virtual device during
MSI-X setup by the driver running on the guest.

On the actual hardware the MSIX vector 0 is misc interrupt and handles
events such as administrative command completion, error reporting,
performance monitor overflow, and etc. The MSIX vectors 1...N
are used for descriptor completion interrupts. On the guest kernel,
the MSIX interrupts are backed by the mediated device through emulation
or IMS vectors. Vector 0 is handled through emulation by the host vdcm.
It only requires the host driver to send the signal to qemu. The vector 1
(and more may be supported later) is backed by IMS.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/device.c    |   58 ++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/idxd.h      |   13 +++++++++
 drivers/dma/idxd/init.c      |   48 +++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/registers.h |    9 ++++++-
 drivers/dma/idxd/submit.c    |   29 ++++++++++++++++-----
 5 files changed, 149 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 7003884cd8ad..a9ae970db0a4 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -532,6 +532,64 @@ void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid)
 	dev_dbg(dev, "pasid %d drained\n", pasid);
 }
 
+int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
+				   enum idxd_interrupt_type irq_type)
+{
+	struct device *dev = &idxd->pdev->dev;
+	u32 operand, status;
+
+	if (!(idxd->hw.cmd_cap & BIT(IDXD_CMD_REQUEST_INT_HANDLE)))
+		return -EOPNOTSUPP;
+
+	dev_dbg(dev, "get int handle, idx %d\n", idx);
+
+	operand = idx & GENMASK(15, 0);
+	if (irq_type == IDXD_IRQ_IMS)
+		operand |= CMD_INT_HANDLE_IMS;
+
+	dev_dbg(dev, "cmd: %u operand: %#x\n", IDXD_CMD_REQUEST_INT_HANDLE, operand);
+
+	idxd_cmd_exec(idxd, IDXD_CMD_REQUEST_INT_HANDLE, operand, &status);
+
+	if ((status & IDXD_CMDSTS_ERR_MASK) != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(dev, "request int handle failed: %#x\n", status);
+		return -ENXIO;
+	}
+
+	*handle = (status >> IDXD_CMDSTS_RES_SHIFT) & GENMASK(15, 0);
+
+	dev_dbg(dev, "int handle acquired: %u\n", *handle);
+	return 0;
+}
+
+int idxd_device_release_int_handle(struct idxd_device *idxd, int handle,
+				   enum idxd_interrupt_type irq_type)
+{
+	struct device *dev = &idxd->pdev->dev;
+	u32 operand, status;
+
+	if (!(idxd->hw.cmd_cap & BIT(IDXD_CMD_RELEASE_INT_HANDLE)))
+		return -EOPNOTSUPP;
+
+	dev_dbg(dev, "release int handle, handle %d\n", handle);
+
+	operand = handle & GENMASK(15, 0);
+	if (irq_type == IDXD_IRQ_IMS)
+		operand |= CMD_INT_HANDLE_IMS;
+
+	dev_dbg(dev, "cmd: %u operand: %#x\n", IDXD_CMD_RELEASE_INT_HANDLE, operand);
+
+	idxd_cmd_exec(idxd, IDXD_CMD_RELEASE_INT_HANDLE, operand, &status);
+
+	if ((status & IDXD_CMDSTS_ERR_MASK) != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(dev, "release int handle failed: %#x\n", status);
+		return -ENXIO;
+	}
+
+	dev_dbg(dev, "int handle released.\n");
+	return 0;
+}
+
 /* Device configuration bits */
 static void idxd_group_config_write(struct idxd_group *group)
 {
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 1afc34be4ed0..a506a16c83ee 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -140,6 +140,7 @@ struct idxd_hw {
 	union group_cap_reg group_cap;
 	union engine_cap_reg engine_cap;
 	struct opcap opcap;
+	u32 cmd_cap;
 };
 
 enum idxd_device_state {
@@ -205,6 +206,8 @@ struct idxd_device {
 	struct dma_device dma_dev;
 	struct workqueue_struct *wq;
 	struct work_struct work;
+
+	int *int_handles;
 };
 
 /* IDXD software descriptor */
@@ -218,6 +221,7 @@ struct idxd_desc {
 	struct list_head list;
 	int id;
 	int cpu;
+	unsigned int vector;
 	struct idxd_wq *wq;
 };
 
@@ -253,6 +257,11 @@ enum idxd_portal_prot {
 	IDXD_PORTAL_LIMITED,
 };
 
+enum idxd_interrupt_type {
+	IDXD_IRQ_MSIX = 0,
+	IDXD_IRQ_IMS,
+};
+
 static inline int idxd_get_wq_portal_offset(enum idxd_portal_prot prot)
 {
 	return prot * 0x1000;
@@ -318,6 +327,10 @@ int idxd_device_config(struct idxd_device *idxd);
 void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
 int idxd_device_load_config(struct idxd_device *idxd);
+int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
+				   enum idxd_interrupt_type irq_type);
+int idxd_device_release_int_handle(struct idxd_device *idxd, int handle,
+				   enum idxd_interrupt_type irq_type);
 
 /* work queue control */
 int idxd_wq_alloc_resources(struct idxd_wq *wq);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 98b1091181bb..c136216e19e8 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -133,6 +133,22 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
 		}
 		dev_dbg(dev, "Allocated idxd-msix %d for vector %d\n",
 			i, msix->vector);
+
+		if (idxd->hw.cmd_cap & BIT(IDXD_CMD_REQUEST_INT_HANDLE)) {
+			/*
+			 * The MSIX vector enumeration starts at 1 with vector 0 being the
+			 * misc interrupt that handles non I/O completion events. The
+			 * interrupt handles are for IMS enumeration on guest. The misc
+			 * interrupt vector does not require a handle and therefore we start
+			 * the int_handles at index 0. Since 'i' starts at 1, the first
+			 * int_handles index will be 0.
+			 */
+			rc = idxd_device_request_int_handle(idxd, i, &idxd->int_handles[i - 1],
+							    IDXD_IRQ_MSIX);
+			if (rc < 0)
+				goto err_no_irq;
+			dev_dbg(dev, "int handle requested: %u\n", idxd->int_handles[i - 1]);
+		}
 	}
 
 	idxd_unmask_error_interrupts(idxd);
@@ -160,6 +176,13 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 	int i;
 
 	init_waitqueue_head(&idxd->cmd_waitq);
+
+	if (idxd->hw.cmd_cap & BIT(IDXD_CMD_REQUEST_INT_HANDLE)) {
+		idxd->int_handles = devm_kcalloc(dev, idxd->max_wqs, sizeof(int), GFP_KERNEL);
+		if (!idxd->int_handles)
+			return -ENOMEM;
+	}
+
 	idxd->groups = devm_kcalloc(dev, idxd->max_groups,
 				    sizeof(struct idxd_group), GFP_KERNEL);
 	if (!idxd->groups)
@@ -233,6 +256,12 @@ static void idxd_read_caps(struct idxd_device *idxd)
 	/* reading generic capabilities */
 	idxd->hw.gen_cap.bits = ioread64(idxd->reg_base + IDXD_GENCAP_OFFSET);
 	dev_dbg(dev, "gen_cap: %#llx\n", idxd->hw.gen_cap.bits);
+
+	if (idxd->hw.gen_cap.cmd_cap) {
+		idxd->hw.cmd_cap = ioread32(idxd->reg_base + IDXD_CMDCAP_OFFSET);
+		dev_dbg(dev, "cmd_cap: %#x\n", idxd->hw.cmd_cap);
+	}
+
 	idxd->max_xfer_bytes = 1ULL << idxd->hw.gen_cap.max_xfer_shift;
 	dev_dbg(dev, "max xfer size: %llu bytes\n", idxd->max_xfer_bytes);
 	idxd->max_batch_size = 1U << idxd->hw.gen_cap.max_batch_shift;
@@ -471,6 +500,24 @@ static void idxd_flush_work_list(struct idxd_irq_entry *ie)
 	}
 }
 
+static void idxd_release_int_handles(struct idxd_device *idxd)
+{
+	struct device *dev = &idxd->pdev->dev;
+	int i, rc;
+
+	for (i = 0; i < idxd->num_wq_irqs; i++) {
+		if (idxd->hw.cmd_cap & BIT(IDXD_CMD_RELEASE_INT_HANDLE)) {
+			rc = idxd_device_release_int_handle(idxd, idxd->int_handles[i],
+							    IDXD_IRQ_MSIX);
+			if (rc < 0)
+				dev_warn(dev, "irq handle %d release failed\n",
+					 idxd->int_handles[i]);
+			else
+				dev_dbg(dev, "int handle requested: %u\n", idxd->int_handles[i]);
+		}
+	}
+}
+
 static void idxd_shutdown(struct pci_dev *pdev)
 {
 	struct idxd_device *idxd = pci_get_drvdata(pdev);
@@ -495,6 +542,7 @@ static void idxd_shutdown(struct pci_dev *pdev)
 		idxd_flush_work_list(irq_entry);
 	}
 
+	idxd_release_int_handles(idxd);
 	destroy_workqueue(idxd->wq);
 }
 
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index d29a58ee2651..d02fd59a8e39 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -23,8 +23,8 @@ union gen_cap_reg {
 		u64 overlap_copy:1;
 		u64 cache_control_mem:1;
 		u64 cache_control_cache:1;
+		u64 cmd_cap:1;
 		u64 rsvd:3;
-		u64 int_handle_req:1;
 		u64 dest_readback:1;
 		u64 drain_readback:1;
 		u64 rsvd2:6;
@@ -179,8 +179,11 @@ enum idxd_cmd {
 	IDXD_CMD_DRAIN_PASID,
 	IDXD_CMD_ABORT_PASID,
 	IDXD_CMD_REQUEST_INT_HANDLE,
+	IDXD_CMD_RELEASE_INT_HANDLE,
 };
 
+#define CMD_INT_HANDLE_IMS		0x10000
+
 #define IDXD_CMDSTS_OFFSET		0xa8
 union cmdsts_reg {
 	struct {
@@ -192,6 +195,8 @@ union cmdsts_reg {
 	u32 bits;
 } __packed;
 #define IDXD_CMDSTS_ACTIVE		0x80000000
+#define IDXD_CMDSTS_ERR_MASK		0xff
+#define IDXD_CMDSTS_RES_SHIFT		8
 
 enum idxd_cmdsts_err {
 	IDXD_CMDSTS_SUCCESS = 0,
@@ -227,6 +232,8 @@ enum idxd_cmdsts_err {
 	IDXD_CMDSTS_ERR_NO_HANDLE,
 };
 
+#define IDXD_CMDCAP_OFFSET		0xb0
+
 #define IDXD_SWERR_OFFSET		0xc0
 #define IDXD_SWERR_VALID		0x00000001
 #define IDXD_SWERR_OVERFLOW		0x00000002
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index efca5d8468a6..cdea5d37ef24 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -22,11 +22,17 @@ static struct idxd_desc *__get_desc(struct idxd_wq *wq, int idx, int cpu)
 		desc->hw->pasid = idxd->pasid;
 
 	/*
-	 * Descriptor completion vectors are 1-8 for MSIX. We will round
-	 * robin through the 8 vectors.
+	 * Descriptor completion vectors are 1...N for MSIX. We will round
+	 * robin through the N vectors.
 	 */
 	wq->vec_ptr = (wq->vec_ptr % idxd->num_wq_irqs) + 1;
-	desc->hw->int_handle = wq->vec_ptr;
+	if (!idxd->int_handles) {
+		desc->hw->int_handle = wq->vec_ptr;
+	} else {
+		desc->vector = wq->vec_ptr;
+		desc->hw->int_handle = idxd->int_handles[desc->vector];
+	}
+
 	return desc;
 }
 
@@ -79,7 +85,6 @@ void idxd_free_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 {
 	struct idxd_device *idxd = wq->idxd;
-	int vec = desc->hw->int_handle;
 	void __iomem *portal;
 	int rc;
 
@@ -112,9 +117,19 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 	 * Pending the descriptor to the lockless list for the irq_entry
 	 * that we designated the descriptor to.
 	 */
-	if (desc->hw->flags & IDXD_OP_FLAG_RCI)
-		llist_add(&desc->llnode,
-			  &idxd->irq_entries[vec].pending_llist);
+	if (desc->hw->flags & IDXD_OP_FLAG_RCI) {
+		int vec;
+
+		/*
+		 * If the driver is on host kernel, it would be the value
+		 * assigned to interrupt handle, which is index for MSIX
+		 * vector. If it's guest then can't use the int_handle since
+		 * that is the index to IMS for the entire device. The guest
+		 * device local index will be used.
+		 */
+		vec = !idxd->int_handles ? desc->hw->int_handle : desc->vector;
+		llist_add(&desc->llnode, &idxd->irq_entries[vec].pending_llist);
+	}
 
 	return 0;
 }



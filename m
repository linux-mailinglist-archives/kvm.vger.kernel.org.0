Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BD1228491
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbgGUQC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:02:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:23714 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730140AbgGUQC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:02:56 -0400
IronPort-SDR: kbCCVJltOLY8VGmPSxWdZPWScdMb0etBSijwkv2NRGVzzfIaaO5v4nRSvNCdFS4YwhK7fcxqQH
 M/fGnOvuV+9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="149317914"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="149317914"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:02:56 -0700
IronPort-SDR: TzPGTcZN9zlLB4fucHhhO1H9cnoXBW7xAE2Mbe+z2aDFCVbwFodYlgtqbeblCcXecZ2xQPB7uY
 yCxSAnwHxaug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="310293518"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jul 2020 09:02:54 -0700
Subject: [PATCH RFC v2 06/18] dmaengine: idxd: add interrupt handle request
 support
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, jgg@mellanox.com,
        rafael@kernel.org, dave.hansen@intel.com, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Jul 2020 09:02:54 -0700
Message-ID: <159534737478.28840.15476839290532682395.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/dma/idxd/device.c    |   30 ++++++++++++++++++++++++++++++
 drivers/dma/idxd/idxd.h      |   11 +++++++++++
 drivers/dma/idxd/init.c      |   29 +++++++++++++++++++++++++++++
 drivers/dma/idxd/registers.h |    4 +++-
 drivers/dma/idxd/submit.c    |   29 ++++++++++++++++++++++-------
 5 files changed, 95 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 7531ed9c1b81..2b4e8ab99ebd 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -502,6 +502,36 @@ void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid)
 	dev_dbg(dev, "pasid %d drained\n", pasid);
 }
 
+#define INT_HANDLE_IMS_TABLE	0x10000
+int idxd_device_request_int_handle(struct idxd_device *idxd, int idx,
+				   int *handle, enum idxd_interrupt_type irq_type)
+{
+	struct device *dev = &idxd->pdev->dev;
+	u32 operand, status;
+
+	if (!(idxd->hw.cmd_cap & BIT(IDXD_CMD_REQUEST_INT_HANDLE)))
+		return -EOPNOTSUPP;
+
+	dev_dbg(dev, "get int handle, idx %d\n", idx);
+
+	operand = idx & 0xffff;
+	if (irq_type == IDXD_IRQ_IMS)
+		operand |= INT_HANDLE_IMS_TABLE;
+	dev_dbg(dev, "cmd: %u operand: %#x\n",
+		IDXD_CMD_REQUEST_INT_HANDLE, operand);
+	idxd_cmd_exec(idxd, IDXD_CMD_REQUEST_INT_HANDLE, operand, &status);
+
+	if ((status & 0xff) != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(dev, "request int handle failed: %#x\n", status);
+		return -ENXIO;
+	}
+
+	*handle = (status >> 8) & 0xffff;
+
+	dev_dbg(dev, "int handle acquired: %u\n", *handle);
+	return 0;
+}
+
 /* Device configuration bits */
 static void idxd_group_config_write(struct idxd_group *group)
 {
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index fcea8bc060f5..2cd190a3da73 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -138,6 +138,7 @@ struct idxd_hw {
 	union group_cap_reg group_cap;
 	union engine_cap_reg engine_cap;
 	struct opcap opcap;
+	u32 cmd_cap;
 };
 
 enum idxd_device_state {
@@ -201,6 +202,8 @@ struct idxd_device {
 	struct dma_device dma_dev;
 	struct workqueue_struct *wq;
 	struct work_struct work;
+
+	int *int_handles;
 };
 
 /* IDXD software descriptor */
@@ -214,6 +217,7 @@ struct idxd_desc {
 	struct list_head list;
 	int id;
 	int cpu;
+	unsigned int vec_ptr;
 	struct idxd_wq *wq;
 };
 
@@ -242,6 +246,11 @@ enum idxd_portal_prot {
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
@@ -307,6 +316,8 @@ int idxd_device_config(struct idxd_device *idxd);
 void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
 int idxd_device_load_config(struct idxd_device *idxd);
+int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
+				   enum idxd_interrupt_type irq_type);
 
 /* work queue control */
 int idxd_wq_alloc_resources(struct idxd_wq *wq);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 50c68de6b4ab..9fd505a03444 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -132,6 +132,22 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
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
@@ -159,6 +175,13 @@ static int idxd_setup_internals(struct idxd_device *idxd)
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
@@ -230,6 +253,12 @@ static void idxd_read_caps(struct idxd_device *idxd)
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
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index a0df4f3fe1fb..ace7248ee195 100644
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
@@ -223,6 +223,8 @@ enum idxd_cmdsts_err {
 	IDXD_CMDSTS_ERR_NO_HANDLE,
 };
 
+#define IDXD_CMDCAP_OFFSET		0xb0
+
 #define IDXD_SWERR_OFFSET		0xc0
 #define IDXD_SWERR_VALID		0x00000001
 #define IDXD_SWERR_OVERFLOW		0x00000002
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 3e63d820a98e..70c7703a4495 100644
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
+		desc->vec_ptr = wq->vec_ptr;
+		desc->hw->int_handle = idxd->int_handles[desc->vec_ptr];
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
 
 	if (idxd->state != IDXD_DEV_ENABLED)
@@ -110,9 +115,19 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
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
+		vec = !idxd->int_handles ? desc->hw->int_handle : desc->vec_ptr;
+		llist_add(&desc->llnode, &idxd->irq_entries[vec].pending_llist);
+	}
 
 	return 0;
 }


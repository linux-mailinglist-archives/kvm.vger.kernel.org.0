Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9992A0DD2
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgJ3Swd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:52:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:35185 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgJ3Swa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:52:30 -0400
IronPort-SDR: c8C4y+7gdM2Wn+cFte6Js/0UEpgIcZyKUS0rg6Rp5cJL2QKjhhmhCYMGn7xdXU/MTK3GCcqQo6
 L1pI79aH1pvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="147936863"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="147936863"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:39 -0700
IronPort-SDR: CCoamM27cI/mm2k/OA1RJJpAX7t21eMH6nG1FMiRF9gZSd7zTfdtQ858C9hTnAeNnrVT0Ot6qh
 q4t4dS8FVDSw==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="527210084"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:38 -0700
Subject: [PATCH v4 07/17] dmaengine: idxd: add IMS support in base driver
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
Date:   Fri, 30 Oct 2020 11:51:38 -0700
Message-ID: <160408389855.912050.5169538738792960557.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for support of VFIO mediated device for idxd driver, the
enabling for Interrupt Message Store (IMS) interrupts is added for the idxd
With IMS support the idxd driver can dynamically allocate interrupts on a
per mdev basis based on how many IMS vectors that are mapped to the mdev
device. This commit only provides the support functions in the base driver
and not the VFIO mdev code utilization.

The commit has some portal related changes. A "portal" is a special
location within the MMIO BAR2 of the DSA device where descriptors are
submitted via the CPU command MOVDIR64B or ENQCMD(S). The offset for the
portal address determines whether the submitted descriptor is for MSI-X
or IMS notification.

See Intel SIOV spec for more details:
https://software.intel.com/en-us/download/intel-scalable-io-virtualization-technical-specification

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ABI/stable/sysfs-driver-dma-idxd |    6 ++++++
 drivers/dma/idxd/cdev.c                        |    4 ++--
 drivers/dma/idxd/idxd.h                        |   13 +++++++++----
 drivers/dma/idxd/init.c                        |   19 +++++++++++++++++++
 drivers/dma/idxd/submit.c                      |   10 ++++++++--
 drivers/dma/idxd/sysfs.c                       |    9 +++++++++
 6 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-dma-idxd b/Documentation/ABI/stable/sysfs-driver-dma-idxd
index 5ea81ffd3c1a..ed5aeecf7015 100644
--- a/Documentation/ABI/stable/sysfs-driver-dma-idxd
+++ b/Documentation/ABI/stable/sysfs-driver-dma-idxd
@@ -129,6 +129,12 @@ KernelVersion:	5.10.0
 Contact:	dmaengine@vger.kernel.org
 Description:	The last executed device administrative command's status/error.
 
+What:		/sys/bus/dsa/devices/dsa<m>/ims_size
+Date:		Oct 15, 2020
+KernelVersion:	5.11.0
+Contact:	dmaengine@vger.kernel.org
+Description:	The total number of vectors available for Interrupt Message Store.
+
 What:		/sys/bus/dsa/devices/wq<m>.<n>/block_on_fault
 Date:		Oct 27, 2020
 KernelVersion:	5.11.0
diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 010b820d8f74..b774bf336347 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -204,8 +204,8 @@ static int idxd_cdev_mmap(struct file *filp, struct vm_area_struct *vma)
 		return rc;
 
 	vma->vm_flags |= VM_DONTCOPY;
-	pfn = (base + idxd_get_wq_portal_full_offset(wq->id,
-				IDXD_PORTAL_LIMITED)) >> PAGE_SHIFT;
+	pfn = (base + idxd_get_wq_portal_full_offset(wq->id, IDXD_PORTAL_LIMITED,
+						     IDXD_IRQ_MSIX)) >> PAGE_SHIFT;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_private_data = ctx;
 
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index a506a16c83ee..549426bfb443 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -154,6 +154,7 @@ enum idxd_device_flag {
 	IDXD_FLAG_CONFIGURABLE = 0,
 	IDXD_FLAG_CMD_RUNNING,
 	IDXD_FLAG_PASID_ENABLED,
+	IDXD_FLAG_SIOV_SUPPORTED,
 };
 
 struct idxd_device {
@@ -181,6 +182,7 @@ struct idxd_device {
 
 	int num_groups;
 
+	u32 ims_offset;
 	u32 msix_perm_offset;
 	u32 wqcfg_offset;
 	u32 grpcfg_offset;
@@ -188,6 +190,7 @@ struct idxd_device {
 
 	u64 max_xfer_bytes;
 	u32 max_batch_size;
+	int ims_size;
 	int max_groups;
 	int max_engines;
 	int max_tokens;
@@ -262,15 +265,17 @@ enum idxd_interrupt_type {
 	IDXD_IRQ_IMS,
 };
 
-static inline int idxd_get_wq_portal_offset(enum idxd_portal_prot prot)
+static inline int idxd_get_wq_portal_offset(enum idxd_portal_prot prot,
+					    enum idxd_interrupt_type irq_type)
 {
-	return prot * 0x1000;
+	return prot * 0x1000 + irq_type * 0x2000;
 }
 
 static inline int idxd_get_wq_portal_full_offset(int wq_id,
-						 enum idxd_portal_prot prot)
+						 enum idxd_portal_prot prot,
+						 enum idxd_interrupt_type irq_type)
 {
-	return ((wq_id * 4) << PAGE_SHIFT) + idxd_get_wq_portal_offset(prot);
+	return ((wq_id * 4) << PAGE_SHIFT) + idxd_get_wq_portal_offset(prot, irq_type);
 }
 
 static inline void idxd_set_type(struct idxd_device *idxd)
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index c136216e19e8..4a21c2a17a62 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -16,6 +16,7 @@
 #include <linux/idr.h>
 #include <linux/intel-svm.h>
 #include <linux/iommu.h>
+#include <linux/pci-siov.h>
 #include <uapi/linux/idxd.h>
 #include <linux/dmaengine.h>
 #include "../dmaengine.h"
@@ -244,10 +245,27 @@ static void idxd_read_table_offsets(struct idxd_device *idxd)
 	dev_dbg(dev, "IDXD Work Queue Config Offset: %#x\n", idxd->wqcfg_offset);
 	idxd->msix_perm_offset = offsets.msix_perm * IDXD_TABLE_MULT;
 	dev_dbg(dev, "IDXD MSIX Permission Offset: %#x\n", idxd->msix_perm_offset);
+	idxd->ims_offset = offsets.ims * IDXD_TABLE_MULT;
+	dev_dbg(dev, "IDXD IMS Offset: %#x\n", idxd->ims_offset);
 	idxd->perfmon_offset = offsets.perfmon * IDXD_TABLE_MULT;
 	dev_dbg(dev, "IDXD Perfmon Offset: %#x\n", idxd->perfmon_offset);
 }
 
+static void idxd_check_siov(struct idxd_device *idxd)
+{
+	struct pci_dev *pdev = idxd->pdev;
+
+	if (pci_ims_supported(idxd->pdev) && idxd->hw.gen_cap.max_ims_mult) {
+		idxd->ims_size = idxd->hw.gen_cap.max_ims_mult * 256ULL;
+		dev_dbg(&pdev->dev, "IMS size: %u\n", idxd->ims_size);
+		set_bit(IDXD_FLAG_SIOV_SUPPORTED, &idxd->flags);
+		dev_dbg(&pdev->dev, "IMS supported for device\n");
+		return;
+	}
+
+	dev_dbg(&pdev->dev, "SIOV unsupported for device\n");
+}
+
 static void idxd_read_caps(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
@@ -266,6 +284,7 @@ static void idxd_read_caps(struct idxd_device *idxd)
 	dev_dbg(dev, "max xfer size: %llu bytes\n", idxd->max_xfer_bytes);
 	idxd->max_batch_size = 1U << idxd->hw.gen_cap.max_batch_shift;
 	dev_dbg(dev, "max batch size: %u\n", idxd->max_batch_size);
+	idxd_check_siov(idxd);
 	if (idxd->hw.gen_cap.config_en)
 		set_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags);
 
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index cdea5d37ef24..f76d154d1dbd 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -30,7 +30,13 @@ static struct idxd_desc *__get_desc(struct idxd_wq *wq, int idx, int cpu)
 		desc->hw->int_handle = wq->vec_ptr;
 	} else {
 		desc->vector = wq->vec_ptr;
-		desc->hw->int_handle = idxd->int_handles[desc->vector];
+		/*
+		 * int_handles are only for descriptor completion. However for device
+		 * MSIX enumeration, vec 0 is used for misc interrupts. Therefore even
+		 * though we are rotating through 1...N for descriptor interrupts, we
+		 * need to acqurie the int_handles from 0..N-1.
+		 */
+		desc->hw->int_handle = idxd->int_handles[desc->vector - 1];
 	}
 
 	return desc;
@@ -91,7 +97,7 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 	if (idxd->state != IDXD_DEV_ENABLED)
 		return -EIO;
 
-	portal = wq->portal + idxd_get_wq_portal_offset(IDXD_PORTAL_LIMITED);
+	portal = wq->portal + idxd_get_wq_portal_offset(IDXD_PORTAL_LIMITED, IDXD_IRQ_MSIX);
 
 	/*
 	 * The wmb() flushes writes to coherent DMA data before
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 304eb2cf532e..17f13ebae028 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1353,6 +1353,14 @@ static ssize_t numa_node_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(numa_node);
 
+static ssize_t ims_size_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct idxd_device *idxd = container_of(dev, struct idxd_device, conf_dev);
+
+	return sprintf(buf, "%u\n", idxd->ims_size);
+}
+static DEVICE_ATTR_RO(ims_size);
+
 static ssize_t max_batch_size_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -1548,6 +1556,7 @@ static struct attribute *idxd_device_attributes[] = {
 	&dev_attr_max_work_queues_size.attr,
 	&dev_attr_max_engines.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_ims_size.attr,
 	&dev_attr_max_batch_size.attr,
 	&dev_attr_max_transfer_size.attr,
 	&dev_attr_op_cap.attr,



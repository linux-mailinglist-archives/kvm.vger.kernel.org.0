Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C49331133A
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 22:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhBEVPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 16:15:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:36319 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233580AbhBETLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:11:21 -0500
IronPort-SDR: o1CebUpBRUMW728vh3sclPQDolHlG40Nfj0eUZeKDNsncjfdyZYL2mklupHr9b+l/oJzYpCghZ
 SaqyYo99jVOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="168606260"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="168606260"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:06 -0800
IronPort-SDR: DhzVfB6V8LUBAZ2D+uT2lfqLGg+JhbtV0es1K/BU8hZchskavCUKdehpYTiM4k2uTc5my5Pmaj
 zyigBoeI4A6Q==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="373680385"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:06 -0800
Subject: [PATCH v5 02/14] dmaengine: idxd: add IMS detection in base driver
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        jgg@mellanox.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, parav@mellanox.com, netanelg@mellanox.com,
        shahafs@mellanox.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 05 Feb 2021 13:53:05 -0700
Message-ID: <161255838583.339900.1371114106574605023.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
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
device. This commit only provides the detection functions in the base driver
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
 drivers/dma/idxd/device.c                      |    2 +-
 drivers/dma/idxd/idxd.h                        |   13 +++++++++----
 drivers/dma/idxd/init.c                        |   19 +++++++++++++++++++
 drivers/dma/idxd/registers.h                   |    7 +++++++
 drivers/dma/idxd/sysfs.c                       |    9 +++++++++
 7 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-dma-idxd b/Documentation/ABI/stable/sysfs-driver-dma-idxd
index 55285c136cf0..95cd7975f488 100644
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
index 0db9b82ed8cf..b1518106434f 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -205,8 +205,8 @@ static int idxd_cdev_mmap(struct file *filp, struct vm_area_struct *vma)
 		return rc;
 
 	vma->vm_flags |= VM_DONTCOPY;
-	pfn = (base + idxd_get_wq_portal_full_offset(wq->id,
-				IDXD_PORTAL_LIMITED)) >> PAGE_SHIFT;
+	pfn = (base + idxd_get_wq_portal_full_offset(wq->id, IDXD_PORTAL_LIMITED,
+						     IDXD_IRQ_MSIX)) >> PAGE_SHIFT;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_private_data = ctx;
 
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 205156afeb54..d6c447d09a6f 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -290,7 +290,7 @@ int idxd_wq_map_portal(struct idxd_wq *wq)
 	resource_size_t start;
 
 	start = pci_resource_start(pdev, IDXD_WQ_BAR);
-	start += idxd_get_wq_portal_full_offset(wq->id, IDXD_PORTAL_LIMITED);
+	start += idxd_get_wq_portal_full_offset(wq->id, IDXD_PORTAL_LIMITED, IDXD_IRQ_MSIX);
 
 	wq->portal = devm_ioremap(dev, start, IDXD_PORTAL_SIZE);
 	if (!wq->portal)
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index a9386a66ab72..90c9458903e1 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -163,6 +163,7 @@ enum idxd_device_flag {
 	IDXD_FLAG_CONFIGURABLE = 0,
 	IDXD_FLAG_CMD_RUNNING,
 	IDXD_FLAG_PASID_ENABLED,
+	IDXD_FLAG_IMS_SUPPORTED,
 };
 
 struct idxd_device {
@@ -190,6 +191,7 @@ struct idxd_device {
 
 	int num_groups;
 
+	u32 ims_offset;
 	u32 msix_perm_offset;
 	u32 wqcfg_offset;
 	u32 grpcfg_offset;
@@ -197,6 +199,7 @@ struct idxd_device {
 
 	u64 max_xfer_bytes;
 	u32 max_batch_size;
+	int ims_size;
 	int max_groups;
 	int max_engines;
 	int max_tokens;
@@ -279,15 +282,17 @@ enum idxd_interrupt_type {
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
index 0c982337ef84..ee56b92108d8 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -254,10 +254,28 @@ static void idxd_read_table_offsets(struct idxd_device *idxd)
 	dev_dbg(dev, "IDXD Work Queue Config Offset: %#x\n", idxd->wqcfg_offset);
 	idxd->msix_perm_offset = offsets.msix_perm * IDXD_TABLE_MULT;
 	dev_dbg(dev, "IDXD MSIX Permission Offset: %#x\n", idxd->msix_perm_offset);
+	idxd->ims_offset = offsets.ims * IDXD_TABLE_MULT;
+	dev_dbg(dev, "IDXD IMS Offset: %#x\n", idxd->ims_offset);
 	idxd->perfmon_offset = offsets.perfmon * IDXD_TABLE_MULT;
 	dev_dbg(dev, "IDXD Perfmon Offset: %#x\n", idxd->perfmon_offset);
 }
 
+static void idxd_check_ims(struct idxd_device *idxd)
+{
+	struct pci_dev *pdev = idxd->pdev;
+
+	/* verify that we have IMS vectors supported by device */
+	if (idxd->hw.gen_cap.max_ims_mult) {
+		idxd->ims_size = idxd->hw.gen_cap.max_ims_mult * 256ULL;
+		dev_dbg(&pdev->dev, "IMS size: %u\n", idxd->ims_size);
+		set_bit(IDXD_FLAG_IMS_SUPPORTED, &idxd->flags);
+		dev_dbg(&pdev->dev, "IMS supported for device\n");
+		return;
+	}
+
+	dev_dbg(&pdev->dev, "IMS unsupported for device\n");
+}
+
 static void idxd_read_caps(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
@@ -276,6 +294,7 @@ static void idxd_read_caps(struct idxd_device *idxd)
 	dev_dbg(dev, "max xfer size: %llu bytes\n", idxd->max_xfer_bytes);
 	idxd->max_batch_size = 1U << idxd->hw.gen_cap.max_batch_shift;
 	dev_dbg(dev, "max batch size: %u\n", idxd->max_batch_size);
+	idxd_check_ims(idxd);
 	if (idxd->hw.gen_cap.config_en)
 		set_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags);
 
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index 5cbf368c7367..c97f700bcf34 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -385,4 +385,11 @@ union wqcfg {
 #define GRPENGCFG_OFFSET(idxd_dev, n) ((idxd_dev)->grpcfg_offset + (n) * GRPCFG_SIZE + 32)
 #define GRPFLGCFG_OFFSET(idxd_dev, n) ((idxd_dev)->grpcfg_offset + (n) * GRPCFG_SIZE + 40)
 
+#define PCI_EXT_CAP_ID_DVSEC		0x23	/* Designated Vendor-Specific */
+#define PCI_DVSEC_HEADER1		0x4	/* Designated Vendor-Specific Header1 */
+#define PCI_DVSEC_HEADER2		0x8	/* Designated Vendor-Specific Header2 */
+#define PCI_DVSEC_ID_INTEL_SIOV		0x0005
+#define PCI_DVSEC_INTEL_SIOV_CAP	0x0014
+#define PCI_DVSEC_INTEL_SIOV_CAP_IMS	0X00000001
+
 #endif
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 21c1e23cdf23..ab5c76e1226b 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1444,6 +1444,14 @@ static ssize_t numa_node_show(struct device *dev,
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
@@ -1639,6 +1647,7 @@ static struct attribute *idxd_device_attributes[] = {
 	&dev_attr_max_work_queues_size.attr,
 	&dev_attr_max_engines.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_ims_size.attr,
 	&dev_attr_max_batch_size.attr,
 	&dev_attr_max_transfer_size.attr,
 	&dev_attr_op_cap.attr,



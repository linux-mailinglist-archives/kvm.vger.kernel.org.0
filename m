Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A98E26B4A2
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 01:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgIOX2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 19:28:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:39712 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgIOX2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 19:28:14 -0400
IronPort-SDR: NlXem3MpnGD5pw5CJ8DtIWGudIj3kwNErP/dGOz57QKr7w3/ygqDn/gz+xSifXptTcpzGBwwhI
 JSzy5QbJggvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="160300147"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="160300147"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:28:13 -0700
IronPort-SDR: 9tDc0neWsLd7p+7S+64+T2UCIfcqrzQ9sd+AcAJXLT8WfzVlhMaYyskSs+w50LKufd+cFQJ+dO
 ik5+GAXHWU7w==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="451619449"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:28:10 -0700
Subject: [PATCH v3 05/18] dmaengine: idxd: add IMS support in base driver
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
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 15 Sep 2020 16:28:09 -0700
Message-ID: <160021248979.67751.3799965857372703876.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
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
 drivers/dma/idxd/cdev.c   |    4 ++-
 drivers/dma/idxd/idxd.h   |   14 +++++++++---
 drivers/dma/idxd/init.c   |   52 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/submit.c |   11 ++++++++--
 drivers/dma/idxd/sysfs.c  |   11 ++++++++++
 5 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index c3976156db2f..06fed39ff17f 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -157,8 +157,8 @@ static int idxd_cdev_mmap(struct file *filp, struct vm_area_struct *vma)
 		return rc;
 
 	vma->vm_flags |= VM_DONTCOPY;
-	pfn = (base + idxd_get_wq_portal_full_offset(wq->id,
-				IDXD_PORTAL_LIMITED)) >> PAGE_SHIFT;
+	pfn = (base + idxd_get_wq_portal_full_offset(wq->id, IDXD_PORTAL_LIMITED,
+						     IDXD_IRQ_MSIX)) >> PAGE_SHIFT;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_private_data = ctx;
 
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 2cd541c5faab..acc444ad9db6 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -146,6 +146,7 @@ enum idxd_device_state {
 enum idxd_device_flag {
 	IDXD_FLAG_CONFIGURABLE = 0,
 	IDXD_FLAG_CMD_RUNNING,
+	IDXD_FLAG_SIOV_SUPPORTED,
 };
 
 struct idxd_device {
@@ -170,6 +171,7 @@ struct idxd_device {
 
 	int num_groups;
 
+	u32 ims_offset;
 	u32 msix_perm_offset;
 	u32 wqcfg_offset;
 	u32 grpcfg_offset;
@@ -177,6 +179,7 @@ struct idxd_device {
 
 	u64 max_xfer_bytes;
 	u32 max_batch_size;
+	int ims_size;
 	int max_groups;
 	int max_engines;
 	int max_tokens;
@@ -196,6 +199,7 @@ struct idxd_device {
 	struct work_struct work;
 
 	int *int_handles;
+	struct sbitmap ims_sbmap;
 };
 
 /* IDXD software descriptor */
@@ -233,15 +237,17 @@ enum idxd_interrupt_type {
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
index fb8b1001d35a..7d08f2b92de7 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -231,10 +231,51 @@ static void idxd_read_table_offsets(struct idxd_device *idxd)
 	idxd->msix_perm_offset = offsets.msix_perm * 0x100;
 	dev_dbg(dev, "IDXD MSIX Permission Offset: %#x\n",
 		idxd->msix_perm_offset);
+	idxd->ims_offset = offsets.ims * 0x100;
+	dev_dbg(dev, "IDXD IMS Offset: %#x\n", idxd->ims_offset);
 	idxd->perfmon_offset = offsets.perfmon * 0x100;
 	dev_dbg(dev, "IDXD Perfmon Offset: %#x\n", idxd->perfmon_offset);
 }
 
+#define PCI_DEVSEC_CAP		0x23
+#define SIOVDVSEC1(offset)	((offset) + 0x4)
+#define SIOVDVSEC2(offset)	((offset) + 0x8)
+#define DVSECID			0x5
+#define SIOVCAP(offset)		((offset) + 0x14)
+
+static void idxd_check_siov(struct idxd_device *idxd)
+{
+	struct pci_dev *pdev = idxd->pdev;
+	struct device *dev = &pdev->dev;
+	int dvsec;
+	u16 val16;
+	u32 val32;
+
+	dvsec = pci_find_ext_capability(pdev, PCI_DEVSEC_CAP);
+	pci_read_config_word(pdev, SIOVDVSEC1(dvsec), &val16);
+	if (val16 != PCI_VENDOR_ID_INTEL) {
+		dev_dbg(&pdev->dev, "DVSEC vendor id is not Intel\n");
+		return;
+	}
+
+	pci_read_config_word(pdev, SIOVDVSEC2(dvsec), &val16);
+	if (val16 != DVSECID) {
+		dev_dbg(&pdev->dev, "DVSEC ID is not SIOV\n");
+		return;
+	}
+
+	pci_read_config_dword(pdev, SIOVCAP(dvsec), &val32);
+	if ((val32 & 0x1) && idxd->hw.gen_cap.max_ims_mult) {
+		idxd->ims_size = idxd->hw.gen_cap.max_ims_mult * 256ULL;
+		dev_dbg(dev, "IMS size: %u\n", idxd->ims_size);
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
@@ -253,6 +294,7 @@ static void idxd_read_caps(struct idxd_device *idxd)
 	dev_dbg(dev, "max xfer size: %llu bytes\n", idxd->max_xfer_bytes);
 	idxd->max_batch_size = 1U << idxd->hw.gen_cap.max_batch_shift;
 	dev_dbg(dev, "max batch size: %u\n", idxd->max_batch_size);
+	idxd_check_siov(idxd);
 	if (idxd->hw.gen_cap.config_en)
 		set_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags);
 
@@ -347,9 +389,19 @@ static int idxd_probe(struct idxd_device *idxd)
 
 	idxd->major = idxd_cdev_get_major(idxd);
 
+	if (idxd->ims_size) {
+		rc = sbitmap_init_node(&idxd->ims_sbmap, idxd->ims_size, -1,
+				       GFP_KERNEL, dev_to_node(dev));
+		if (rc < 0)
+			goto sbitmap_fail;
+	}
 	dev_dbg(dev, "IDXD device %d probed successfully\n", idxd->id);
 	return 0;
 
+ sbitmap_fail:
+	mutex_lock(&idxd_idr_lock);
+	idr_remove(&idxd_idrs[idxd->type], idxd->id);
+	mutex_unlock(&idxd_idr_lock);
  err_idr_fail:
 	idxd_mask_error_interrupts(idxd);
 	idxd_mask_msix_vectors(idxd);
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 2b3c2f132af7..8dd72cf3c838 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -27,7 +27,13 @@ static struct idxd_desc *__get_desc(struct idxd_wq *wq, int idx, int cpu)
 		desc->hw->int_handle = wq->vec_ptr;
 	} else {
 		desc->vec_ptr = wq->vec_ptr;
-		desc->hw->int_handle = idxd->int_handles[desc->vec_ptr];
+		/*
+		 * int_handles are only for descriptor completion. However for device
+		 * MSIX enumeration, vec 0 is used for misc interrupts. Therefore even
+		 * though we are rotating through 1...N for descriptor interrupts, we
+		 * need to acqurie the int_handles from 0..N-1.
+		 */
+		desc->hw->int_handle = idxd->int_handles[desc->vec_ptr - 1];
 	}
 
 	return desc;
@@ -87,7 +93,8 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 	if (idxd->state != IDXD_DEV_ENABLED)
 		return -EIO;
 
-	portal = wq->dportal + idxd_get_wq_portal_offset(IDXD_PORTAL_UNLIMITED);
+	portal = wq->dportal + idxd_get_wq_portal_offset(IDXD_PORTAL_LIMITED, IDXD_IRQ_MSIX);
+
 	/*
 	 * The wmb() flushes writes to coherent DMA data before possibly
 	 * triggering a DMA read. The wmb() is necessary even on UP because
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 00d2347399bb..4914316ae493 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1237,6 +1237,16 @@ static ssize_t numa_node_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(numa_node);
 
+static ssize_t ims_size_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct idxd_device *idxd =
+		container_of(dev, struct idxd_device, conf_dev);
+
+	return sprintf(buf, "%u\n", idxd->ims_size);
+}
+static DEVICE_ATTR_RO(ims_size);
+
 static ssize_t max_batch_size_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -1422,6 +1432,7 @@ static struct attribute *idxd_device_attributes[] = {
 	&dev_attr_max_work_queues_size.attr,
 	&dev_attr_max_engines.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_ims_size.attr,
 	&dev_attr_max_batch_size.attr,
 	&dev_attr_max_transfer_size.attr,
 	&dev_attr_op_cap.attr,


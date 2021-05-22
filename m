Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B5C38D271
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhEVAWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:22:20 -0400
Received: from mga03.intel.com ([134.134.136.65]:39211 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231182AbhEVAVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:21:52 -0400
IronPort-SDR: NmYsiFG81xNMSl8MsvGmvVwGbkdqNrCPwGLgffem87SWbYsLqxhXcEe2x/PnUaONWK3RoTxpYy
 H7aNd7OI6FYQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="201652798"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="201652798"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:27 -0700
IronPort-SDR: uC8BZWOEfkuBojiC6NjuVOcuTKOcQVY9U9Q4dvrPV28Db5SA5VQXIa0a+F2ikPriOP7K9MVYaJ
 VkpwMH5evsJA==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="406873835"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:26 -0700
Subject: [PATCH v6 13/20] vfio/mdev: idxd: add mdev driver registration and
 helper functions
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:20:26 -0700
Message-ID: <162164282601.261970.10405911922092921185.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a mediated device through the VFIO mediated device framework. The
mdev framework allows creation of an mediated device by the driver with
portion of the device's resources. The driver will emulate the slow path
such as the PCI config space, MMIO bar, and the command registers. The
descriptor submission portal(s) will be mmaped to the guest in order to
submit descriptors directly by the guest kernel or apps. The mediated
device support code in the idxd will be referred to as the Virtual
Device Composition Module (vdcm). Add basic plumbing to fill out the
mdev_parent_ops struct that VFIO mdev requires to support a mediated
device.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/idxd.h       |    1 
 drivers/vfio/mdev/idxd/mdev.c |  638 +++++++++++++++++++++++++++++++++++++++++
 drivers/vfio/mdev/idxd/mdev.h |   25 ++
 3 files changed, 664 insertions(+)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 4d2532175705..0d9e2710fc76 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -198,6 +198,7 @@ struct idxd_wq {
 	u64 max_xfer_bytes;
 	u32 max_batch_size;
 	bool ats_dis;
+	struct vdcm_idxd *vidxd;
 };
 
 struct idxd_engine {
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 25cd62b803f8..e484095baeea 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -41,12 +41,650 @@ int idxd_mdev_get_pasid(struct mdev_device *mdev, struct vfio_device *vdev, u32
 	return 0;
 }
 
+static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags,
+			      unsigned int index, unsigned int start,
+			      unsigned int count, void *data);
+
+static int idxd_vdcm_get_irq_count(struct vfio_device *vdev, int type)
+{
+	if (type == VFIO_PCI_MSIX_IRQ_INDEX)
+		return VIDXD_MAX_MSIX_VECS;
+
+	return 0;
+}
+
+static struct vdcm_idxd *vdcm_vidxd_create(struct idxd_device *idxd, struct mdev_device *mdev,
+					   struct vdcm_idxd_type *type)
+{
+	struct vdcm_idxd *vidxd;
+	struct idxd_wq *wq = NULL;
+
+	if (!wq)
+		return ERR_PTR(-ENODEV);
+
+	vidxd = kzalloc(sizeof(*vidxd), GFP_KERNEL);
+	if (!vidxd)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&vidxd->dev_lock);
+	vidxd->idxd = idxd;
+	vidxd->mdev = mdev;
+	vidxd->type = type;
+	vidxd->num_wqs = VIDXD_MAX_WQS;
+
+	mutex_lock(&wq->wq_lock);
+	idxd_wq_get(wq);
+	wq->vidxd = vidxd;
+	vidxd->wq = wq;
+	mutex_unlock(&wq->wq_lock);
+	vidxd_init(vidxd);
+
+	return vidxd;
+}
+
+static struct vdcm_idxd_type idxd_mdev_types[IDXD_MDEV_TYPES];
+
+static struct vdcm_idxd_type *idxd_vdcm_get_type(struct mdev_device *mdev)
+{
+	return &idxd_mdev_types[mdev_get_type_group_id(mdev)];
+}
+
+static const struct vfio_device_ops idxd_mdev_ops;
+
+static int idxd_vdcm_probe(struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd;
+	struct vdcm_idxd_type *type;
+	struct device *dev, *parent;
+	struct idxd_device *idxd;
+	bool ims_map[VIDXD_MAX_MSIX_VECS];
+	int rc;
+
+	parent = mdev_parent_dev(mdev);
+	idxd = dev_get_drvdata(parent);
+	dev = &mdev->dev;
+	mdev_set_iommu_device(mdev, parent);
+	type = idxd_vdcm_get_type(mdev);
+
+	vidxd = vdcm_vidxd_create(idxd, mdev, type);
+	if (IS_ERR(vidxd)) {
+		dev_err(dev, "failed to create vidxd: %ld\n", PTR_ERR(vidxd));
+		return PTR_ERR(vidxd);
+	}
+
+	vfio_init_group_dev(&vidxd->vdev, &mdev->dev, &idxd_mdev_ops);
+
+	ims_map[0] = 0;
+	ims_map[1] = 1;
+	rc = mdev_irqs_init(mdev, VIDXD_MAX_MSIX_VECS, ims_map);
+	if (rc < 0)
+		goto err;
+
+	rc = vfio_register_group_dev(&vidxd->vdev);
+	if (rc < 0)
+		goto err_group_register;
+	dev_set_drvdata(dev, vidxd);
+
+	return 0;
+
+err_group_register:
+	mdev_irqs_free(mdev);
+err:
+	kfree(vidxd);
+	return rc;
+}
+
+static void idxd_vdcm_remove(struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd = dev_get_drvdata(&mdev->dev);
+	struct idxd_wq *wq = vidxd->wq;
+
+	vfio_unregister_group_dev(&vidxd->vdev);
+	mdev_irqs_free(mdev);
+	mutex_lock(&wq->wq_lock);
+	idxd_wq_put(wq);
+	mutex_unlock(&wq->wq_lock);
+
+	kfree(vidxd);
+}
+
+static int idxd_vdcm_open(struct vfio_device *vdev)
+{
+	return 0;
+}
+
+static void idxd_vdcm_close(struct vfio_device *vdev)
+{
+	struct vdcm_idxd *vidxd = vdev_to_vidxd(vdev);
+
+	mutex_lock(&vidxd->dev_lock);
+	idxd_vdcm_set_irqs(vidxd, VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER,
+			   VFIO_PCI_MSIX_IRQ_INDEX, 0, 0, NULL);
+
+	/* Re-initialize the VIDXD to a pristine state for re-use */
+	vidxd_init(vidxd);
+	mutex_unlock(&vidxd->dev_lock);
+}
+
+static ssize_t idxd_vdcm_rw(struct vfio_device *vdev, char *buf, size_t count, loff_t *ppos,
+			    enum idxd_vdcm_rw mode)
+{
+	struct vdcm_idxd *vidxd = vdev_to_vidxd(vdev);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	struct device *dev = vdev->dev;
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
+			rc = vidxd_cfg_write(vidxd, pos, buf, count);
+		else
+			rc = vidxd_cfg_read(vidxd, pos, buf, count);
+		break;
+	case VFIO_PCI_BAR0_REGION_INDEX:
+	case VFIO_PCI_BAR1_REGION_INDEX:
+		if (mode == IDXD_VDCM_WRITE)
+			rc = vidxd_mmio_write(vidxd, vidxd->bar_val[0] + pos, buf, count);
+		else
+			rc = vidxd_mmio_read(vidxd, vidxd->bar_val[0] + pos, buf, count);
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
+static ssize_t idxd_vdcm_read(struct vfio_device *vdev, char __user *buf, size_t count,
+			      loff_t *ppos)
+{
+	struct vdcm_idxd *vidxd = vdev_to_vidxd(vdev);
+	unsigned int done = 0;
+	int rc;
+
+	mutex_lock(&vidxd->dev_lock);
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(*ppos % 4)) {
+			u32 val;
+
+			rc = idxd_vdcm_rw(vdev, (char *)&val, sizeof(val),
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
+			rc = idxd_vdcm_rw(vdev, (char *)&val, sizeof(val),
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
+			rc = idxd_vdcm_rw(vdev, &val, sizeof(val), ppos,
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
+	mutex_unlock(&vidxd->dev_lock);
+	return done;
+
+ read_err:
+	mutex_unlock(&vidxd->dev_lock);
+	return -EFAULT;
+}
+
+static ssize_t idxd_vdcm_write(struct vfio_device *vdev, const char __user *buf, size_t count,
+			       loff_t *ppos)
+{
+	struct vdcm_idxd *vidxd = vdev_to_vidxd(vdev);
+	unsigned int done = 0;
+	int rc;
+
+	mutex_lock(&vidxd->dev_lock);
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(*ppos % 4)) {
+			u32 val;
+
+			if (copy_from_user(&val, buf, sizeof(val)))
+				goto write_err;
+
+			rc = idxd_vdcm_rw(vdev, (char *)&val, sizeof(val),
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
+			rc = idxd_vdcm_rw(vdev, (char *)&val,
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
+			rc = idxd_vdcm_rw(vdev, &val, sizeof(val),
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
+	mutex_unlock(&vidxd->dev_lock);
+	return done;
+
+write_err:
+	mutex_unlock(&vidxd->dev_lock);
+	return -EFAULT;
+}
+
+static int idxd_vdcm_mmap(struct vfio_device *vdev, struct vm_area_struct *vma)
+{
+	unsigned int wq_idx;
+	unsigned long req_size, pgoff = 0, offset;
+	pgprot_t pg_prot;
+	struct vdcm_idxd *vidxd = vdev_to_vidxd(vdev);
+	struct idxd_wq *wq = vidxd->wq;
+	struct idxd_device *idxd = vidxd->idxd;
+	enum idxd_portal_prot virt_portal, phys_portal;
+	phys_addr_t base = pci_resource_start(idxd->pdev, IDXD_WQ_BAR);
+	struct device *dev = vdev->dev;
+
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	pg_prot = vma->vm_page_prot;
+	req_size = vma->vm_end - vma->vm_start;
+	if (req_size > PAGE_SIZE)
+		return -EINVAL;
+
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
+	/*
+	 * Check and see if the guest wants to map to the limited or unlimited portal.
+	 * The driver will allow mapping to unlimited portal only if the wq is a
+	 * dedicated wq. Otherwise, it goes to limited.
+	 */
+	virt_portal = ((offset >> PAGE_SHIFT) & 0x3) == 1;
+	phys_portal = IDXD_PORTAL_LIMITED;
+	if (virt_portal == IDXD_PORTAL_UNLIMITED && wq_dedicated(wq))
+		phys_portal = IDXD_PORTAL_UNLIMITED;
+
+	/* We always map IMS portals to the guest */
+	pgoff = (base + idxd_get_wq_portal_offset(wq->id, phys_portal,
+						  IDXD_IRQ_IMS)) >> PAGE_SHIFT;
+
+	dev_dbg(dev, "mmap %lx %lx %lx %lx\n", vma->vm_start, pgoff, req_size,
+		pgprot_val(pg_prot));
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_pgoff = pgoff;
+
+	return remap_pfn_range(vma, vma->vm_start, pgoff, req_size, pg_prot);
+}
+
+static void vidxd_vdcm_reset(struct vdcm_idxd *vidxd)
+{
+	vidxd_reset(vidxd);
+}
+
+static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags,
+			      unsigned int index, unsigned int start,
+			      unsigned int count, void *data)
+{
+	struct mdev_device *mdev = vidxd->mdev;
+
+	switch (index) {
+	case VFIO_PCI_INTX_IRQ_INDEX:
+	case VFIO_PCI_MSI_IRQ_INDEX:
+		break;
+	case VFIO_PCI_MSIX_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_MASK:
+		case VFIO_IRQ_SET_ACTION_UNMASK:
+			break;
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			return mdev_set_msix_trigger(mdev, index, start, count, flags, data);
+		}
+		break;
+	}
+
+	return -ENOTTY;
+}
+
+static long idxd_vdcm_ioctl(struct vfio_device *vdev, unsigned int cmd, unsigned long arg)
+{
+	struct vdcm_idxd *vidxd = vdev_to_vidxd(vdev);
+	unsigned long minsz;
+	int rc = -EINVAL;
+	struct device *dev = vdev->dev;
+
+	dev_dbg(dev, "vidxd %p ioctl, cmd: %d\n", vidxd, cmd);
+
+	mutex_lock(&vidxd->dev_lock);
+	if (cmd == VFIO_DEVICE_GET_INFO) {
+		struct vfio_device_info info;
+
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz)) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (info.argsz < minsz) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		info.flags = VFIO_DEVICE_FLAGS_PCI;
+		info.flags |= VFIO_DEVICE_FLAGS_RESET;
+		info.num_regions = VFIO_PCI_NUM_REGIONS;
+		info.num_irqs = VFIO_PCI_NUM_IRQS;
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			rc = -EFAULT;
+		else
+			rc = 0;
+		goto out;
+	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+		struct vfio_region_info info;
+		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+		struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
+		size_t size;
+		int nr_areas = 1;
+		int cap_type_id = 0;
+
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz)) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (info.argsz < minsz) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		switch (info.index) {
+		case VFIO_PCI_CONFIG_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = VIDXD_MAX_CFG_SPACE_SZ;
+			info.flags = VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE;
+			break;
+		case VFIO_PCI_BAR0_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = vidxd->bar_size[info.index];
+			if (!info.size) {
+				info.flags = 0;
+				break;
+			}
+
+			info.flags = VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE;
+			break;
+		case VFIO_PCI_BAR1_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = 0;
+			info.flags = 0;
+			break;
+		case VFIO_PCI_BAR2_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.flags = VFIO_REGION_INFO_FLAG_CAPS | VFIO_REGION_INFO_FLAG_MMAP |
+				     VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE;
+			info.size = vidxd->bar_size[1];
+
+			/*
+			 * Every WQ has two areas for unlimited and limited
+			 * MSI-X portals. IMS portals are not reported
+			 */
+			nr_areas = 2;
+
+			size = sizeof(*sparse) + (nr_areas * sizeof(*sparse->areas));
+			sparse = kzalloc(size, GFP_KERNEL);
+			if (!sparse) {
+				rc = -ENOMEM;
+				goto out;
+			}
+
+			sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+			sparse->header.version = 1;
+			sparse->nr_areas = nr_areas;
+			cap_type_id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+
+			/* Unlimited portal */
+			sparse->areas[0].offset = 0;
+			sparse->areas[0].size = PAGE_SIZE;
+
+			/* Limited portal */
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
+			dev_dbg(dev, "get region info index:%d\n", info.index);
+			break;
+		default: {
+			if (info.index >= VFIO_PCI_NUM_REGIONS)
+				rc = -EINVAL;
+			else
+				rc = 0;
+			goto out;
+		} /* default */
+		} /* info.index switch */
+
+		if ((info.flags & VFIO_REGION_INFO_FLAG_CAPS) && sparse) {
+			if (cap_type_id == VFIO_REGION_INFO_CAP_SPARSE_MMAP) {
+				rc = vfio_info_add_capability(&caps, &sparse->header,
+							      sizeof(*sparse) + (sparse->nr_areas *
+							      sizeof(*sparse->areas)));
+				kfree(sparse);
+				if (rc)
+					goto out;
+			}
+		}
+
+		if (caps.size) {
+			if (info.argsz < sizeof(info) + caps.size) {
+				info.argsz = sizeof(info) + caps.size;
+				info.cap_offset = 0;
+			} else {
+				vfio_info_cap_shift(&caps, sizeof(info));
+				if (copy_to_user((void __user *)arg + sizeof(info),
+						 caps.buf, caps.size)) {
+					kfree(caps.buf);
+					rc = -EFAULT;
+					goto out;
+				}
+				info.cap_offset = sizeof(info);
+			}
+
+			kfree(caps.buf);
+		}
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			rc = -EFAULT;
+		else
+			rc = 0;
+		goto out;
+	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
+		struct vfio_irq_info info;
+		u32 pasid;
+
+		rc = idxd_mdev_get_pasid(vidxd->mdev, vdev, &pasid);
+		if (rc < 0)
+			goto out;
+		mdev_irqs_set_pasid(vidxd->mdev, pasid);
+
+		minsz = offsetofend(struct vfio_irq_info, count);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz)) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		info.flags = VFIO_IRQ_INFO_EVENTFD;
+
+		switch (info.index) {
+		case VFIO_PCI_MSIX_IRQ_INDEX:
+			info.flags |= VFIO_IRQ_INFO_NORESIZE;
+			break;
+		default:
+			rc = -EINVAL;
+			goto out;
+		} /* switch(info.index) */
+
+		info.flags = VFIO_IRQ_INFO_EVENTFD | VFIO_IRQ_INFO_NORESIZE;
+		info.count = idxd_vdcm_get_irq_count(vdev, info.index);
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			rc = -EFAULT;
+		else
+			rc = 0;
+		goto out;
+	} else if (cmd == VFIO_DEVICE_SET_IRQS) {
+		struct vfio_irq_set hdr;
+		u8 *data = NULL;
+		size_t data_size = 0;
+
+		minsz = offsetofend(struct vfio_irq_set, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz)) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE)) {
+			int max = idxd_vdcm_get_irq_count(vdev, hdr.index);
+
+			rc = vfio_set_irqs_validate_and_prepare(&hdr, max, VFIO_PCI_NUM_IRQS,
+								&data_size);
+			if (rc) {
+				dev_err(dev, "intel:vfio_set_irqs_validate_and_prepare failed\n");
+				rc = -EINVAL;
+				goto out;
+			}
+
+			if (data_size) {
+				data = memdup_user((void __user *)(arg + minsz), data_size);
+				if (IS_ERR(data)) {
+					rc = PTR_ERR(data);
+					goto out;
+				}
+			}
+		}
+
+		if (!data) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		rc = idxd_vdcm_set_irqs(vidxd, hdr.flags, hdr.index, hdr.start, hdr.count, data);
+		kfree(data);
+		goto out;
+	} else if (cmd == VFIO_DEVICE_RESET) {
+		vidxd_vdcm_reset(vidxd);
+	}
+
+ out:
+	mutex_unlock(&vidxd->dev_lock);
+	return rc;
+}
+
+static const struct vfio_device_ops idxd_mdev_ops = {
+	.name = "vfio-mdev",
+	.open = idxd_vdcm_open,
+	.release = idxd_vdcm_close,
+	.read = idxd_vdcm_read,
+	.write = idxd_vdcm_write,
+	.mmap = idxd_vdcm_mmap,
+	.ioctl = idxd_vdcm_ioctl,
+};
+
 static struct mdev_driver idxd_vdcm_driver = {
 	.driver = {
 		.name = "idxd-mdev",
 		.owner = THIS_MODULE,
 		.mod_name = KBUILD_MODNAME,
 	},
+	.probe = idxd_vdcm_probe,
+	.remove = idxd_vdcm_remove,
 };
 
 static int idxd_mdev_drv_probe(struct device *dev)
diff --git a/drivers/vfio/mdev/idxd/mdev.h b/drivers/vfio/mdev/idxd/mdev.h
index f696fe38e374..dd4290bce772 100644
--- a/drivers/vfio/mdev/idxd/mdev.h
+++ b/drivers/vfio/mdev/idxd/mdev.h
@@ -30,11 +30,26 @@
 #define VIDXD_MAX_MSIX_ENTRIES		VIDXD_MAX_MSIX_VECS
 #define VIDXD_MAX_WQS			1
 
+#define IDXD_MDEV_NAME_LEN		64
+#define IDXD_MDEV_TYPES			2
+
+enum idxd_mdev_type {
+	IDXD_MDEV_TYPE_DSA_1_DWQ = 0,
+	IDXD_MDEV_TYPE_IAX_1_DWQ,
+};
+
+struct vdcm_idxd_type {
+	const char *name;
+	enum idxd_mdev_type type;
+	unsigned int avail_instance;
+};
+
 struct vdcm_idxd {
 	struct vfio_device vdev;
 	struct idxd_device *idxd;
 	struct idxd_wq *wq;
 	struct mdev_device *mdev;
+	struct vdcm_idxd_type *type;
 	int num_wqs;
 
 	u64 bar_val[VIDXD_MAX_BARS];
@@ -44,6 +59,16 @@ struct vdcm_idxd {
 	struct mutex dev_lock; /* lock for vidxd resources */
 };
 
+enum idxd_vdcm_rw {
+	IDXD_VDCM_READ = 0,
+	IDXD_VDCM_WRITE,
+};
+
+static inline struct vdcm_idxd *vdev_to_vidxd(struct vfio_device *vdev)
+{
+	return container_of(vdev, struct vdcm_idxd, vdev);
+}
+
 static inline u64 get_reg_val(void *buf, int size)
 {
 	u64 val = 0;



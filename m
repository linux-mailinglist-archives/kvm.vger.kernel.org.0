Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849FA1D6F3C
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 05:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgERDEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 23:04:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:21859 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgERDEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 23:04:04 -0400
IronPort-SDR: W/FQOQOyUBGA7wZqZbjkcYderdlSfLBHjmVvQd5BR5b0jR88PLXi82D1Mo550mDrf3I2aLqmj4
 o5a2B39YBtjw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 20:03:56 -0700
IronPort-SDR: AqAXxl2Q+vwSd+sRpwBU79HD5r++WP5aak5eaF/O8uGHoMIMBVI6inKp9LVglc6/nMMtlXlUte
 5siBD9lJv4Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="411106351"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 17 May 2020 20:03:51 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v4 09/10] i40e/vf_migration: register a migration vendor region
Date:   Sun, 17 May 2020 22:54:00 -0400
Message-Id: <20200518025400.14547-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200518024202.13996-1-yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch let the vendor driver register a migration region, so that
the migration detection code in userspace will be able to see this
region and triggers the migration flow according to VFIO migration
protocol.

This migration region works based on VFIO migration series with some
minor fixes:
[1] kernel v17: https://patchwork.kernel.org/cover/11466129/
[2] qemu v16: https://patchwork.kernel.org/cover/11456557/

Cc: Shaopeng He <shaopeng.he@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 .../ethernet/intel/i40e/i40e_vf_migration.c   | 429 +++++++++++++++++-
 .../ethernet/intel/i40e/i40e_vf_migration.h   |  34 ++
 2 files changed, 460 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
index 96026dcf5c9d..107a291909b3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
@@ -17,6 +17,351 @@
 
 #define VERSION_STRING  "0.1"
 #define DRIVER_AUTHOR   "Intel Corporation"
+#define TEST_DIRTY_IOVA_PFN 0
+
+static int i40e_vf_iommu_notifier(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	if (action == VFIO_IOMMU_NOTIFY_DMA_UNMAP) {
+		struct vfio_iommu_type1_dma_unmap *unmap = data;
+		unsigned long iova_pfn, end_iova_pfn;
+
+		iova_pfn = unmap->iova >> PAGE_SHIFT;
+		end_iova_pfn = iova_pfn + unmap->size / PAGE_SIZE;
+
+		pr_info("DMA UNMAP iova_pfn=%lx, end=%lx\n", iova_pfn,
+			end_iova_pfn);
+	}
+
+	return NOTIFY_OK;
+}
+
+/* transient pinning a page
+ */
+static int i40e_vf_set_page_dirty(struct i40e_vf_migration *i40e_vf_dev,
+				  unsigned long dirty_iova_pfn)
+{
+	unsigned long dirty_pfn, cnt = 1;
+	int ret;
+
+	ret = vfio_group_pin_pages(i40e_vf_dev->vfio_group,
+				   &dirty_iova_pfn, cnt,
+				   IOMMU_READ | IOMMU_WRITE, &dirty_pfn);
+	if (ret != cnt) {
+		pr_err("failed to track dirty of page of iova pfn %lx\n",
+		       dirty_iova_pfn);
+		return ret < 0 ? ret : -EFAULT;
+	}
+
+	vfio_group_unpin_pages(i40e_vf_dev->vfio_group, &dirty_iova_pfn, cnt);
+
+	return 0;
+}
+
+/* alloc dirty page tracking resources and
+ * do the first round dirty page scanning
+ */
+static int i40e_vf_prepare_dirty_track(struct i40e_vf_migration *i40e_vf_dev)
+{
+	struct vfio_group *vfio_group;
+	unsigned long events;
+	int ret;
+	struct device *dev = &i40e_vf_dev->vf_dev->dev;
+
+	if (i40e_vf_dev->in_dirty_track) {
+		pr_warn("%s, previous dirty track resources found\n",
+			__func__);
+		return 0;
+	}
+
+	i40e_vf_dev->iommu_notifier.notifier_call = i40e_vf_iommu_notifier;
+
+	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
+	ret = vfio_register_notifier(dev, VFIO_IOMMU_NOTIFY, &events,
+				     &i40e_vf_dev->iommu_notifier);
+	if (ret) {
+		pr_err("failed to register vfio iommu notifier\n");
+		return ret;
+	}
+
+	vfio_group = vfio_group_get_external_user_from_dev(dev);
+	if (IS_ERR_OR_NULL(vfio_group)) {
+		ret = PTR_ERR(vfio_group);
+		pr_err("failed to get vfio group from dev\n");
+		goto out;
+	}
+
+	i40e_vf_dev->vfio_group = vfio_group;
+
+	ret = i40e_vf_set_page_dirty(i40e_vf_dev, TEST_DIRTY_IOVA_PFN);
+
+	if (ret) {
+		pr_err("failed to set dirty for test page\n");
+		goto out_group;
+	}
+
+	i40e_vf_dev->in_dirty_track = true;
+	return 0;
+
+out_group:
+	vfio_unregister_notifier(dev, VFIO_IOMMU_NOTIFY,
+				 &i40e_vf_dev->iommu_notifier);
+out:
+	vfio_group_put_external_user(i40e_vf_dev->vfio_group);
+	return ret;
+}
+
+static void i40e_vf_stop_dirty_track(struct i40e_vf_migration *i40e_vf_dev)
+{
+	if (!i40e_vf_dev->in_dirty_track)
+		return;
+
+	vfio_unregister_notifier(&i40e_vf_dev->vf_dev->dev,
+				 VFIO_IOMMU_NOTIFY,
+				 &i40e_vf_dev->iommu_notifier);
+	vfio_group_put_external_user(i40e_vf_dev->vfio_group);
+	i40e_vf_dev->in_dirty_track = false;
+}
+
+static size_t i40e_vf_set_device_state(struct i40e_vf_migration *i40e_vf_dev,
+				       u32 state)
+{
+	int ret = 0;
+	struct vfio_device_migration_info *mig_ctl = i40e_vf_dev->mig_ctl;
+
+	if (state == mig_ctl->device_state)
+		return 0;
+
+	switch (state) {
+	case VFIO_DEVICE_STATE_RUNNING:
+		break;
+	case VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING:
+		ret = i40e_vf_prepare_dirty_track(i40e_vf_dev);
+		break;
+	case VFIO_DEVICE_STATE_SAVING:
+		// do the last round of dirty page scanning
+		break;
+	case VFIO_DEVICE_STATE_STOP:
+		// release dirty page tracking resources
+		if (mig_ctl->device_state == VFIO_DEVICE_STATE_SAVING)
+			i40e_vf_stop_dirty_track(i40e_vf_dev);
+		break;
+	case VFIO_DEVICE_STATE_RESUMING:
+		break;
+	default:
+		ret = -EFAULT;
+	}
+
+	if (!ret)
+		mig_ctl->device_state = state;
+
+	return ret;
+}
+
+static
+ssize_t i40e_vf_region_migration_rw(struct i40e_vf_migration *i40e_vf_dev,
+				    char __user *buf, size_t count,
+				    loff_t *ppos, bool iswrite)
+{
+#define VDM_OFFSET(x) offsetof(struct vfio_device_migration_info, x)
+	struct vfio_device_migration_info *mig_ctl = i40e_vf_dev->mig_ctl;
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	int ret = 0;
+
+	switch (pos) {
+	case VDM_OFFSET(device_state):
+		if (count != sizeof(mig_ctl->device_state)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (iswrite) {
+			u32 device_state;
+
+			if (copy_from_user(&device_state, buf, count)) {
+				ret = -EFAULT;
+				break;
+			}
+
+			ret = i40e_vf_set_device_state(i40e_vf_dev,
+						       device_state) ?
+						       ret : count;
+		} else {
+			ret = copy_to_user(buf, &mig_ctl->device_state,
+					   count) ? -EFAULT : count;
+		}
+		break;
+
+	case VDM_OFFSET(reserved):
+		ret = -EFAULT;
+		break;
+
+	case VDM_OFFSET(pending_bytes):
+		{
+			if (count != sizeof(mig_ctl->pending_bytes)) {
+				ret = -EINVAL;
+				break;
+			}
+
+			if (iswrite)
+				ret = -EFAULT;
+			else
+				ret = copy_to_user(buf,
+						   &mig_ctl->pending_bytes,
+						   count) ? -EFAULT : count;
+
+			break;
+		}
+
+	case VDM_OFFSET(data_offset):
+		{
+			/* as we don't support device internal dirty data
+			 * and our pending_bytes is always 0,
+			 * return error here.
+			 */
+			ret = -EFAULT;
+			break;
+		}
+	case VDM_OFFSET(data_size):
+		if (count != sizeof(mig_ctl->data_size)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (iswrite)
+			ret = copy_from_user(&mig_ctl->data_size, buf, count) ?
+					     -EFAULT : count;
+		else
+			ret = copy_to_user(buf, &mig_ctl->data_size, count) ?
+					   -EFAULT : count;
+		break;
+
+	default:
+		ret = -EFAULT;
+		break;
+	}
+	return ret;
+}
+
+static
+int i40e_vf_region_migration_mmap(struct i40e_vf_migration *i40e_vf_dev,
+				  struct i40e_vf_region *region,
+				  struct vm_area_struct *vma)
+{
+	return -EFAULT;
+}
+
+static
+void i40e_vf_region_migration_release(struct i40e_vf_migration *i40e_vf_dev,
+				      struct i40e_vf_region *region)
+{
+	kfree(i40e_vf_dev->mig_ctl);
+	i40e_vf_dev->mig_ctl = NULL;
+}
+
+static const struct i40e_vf_region_ops i40e_vf_region_ops_migration = {
+	.rw		= i40e_vf_region_migration_rw,
+	.release	= i40e_vf_region_migration_release,
+	.mmap		= i40e_vf_region_migration_mmap,
+};
+
+static int i40e_vf_register_region(struct i40e_vf_migration *i40e_vf_dev,
+				   unsigned int type, unsigned int subtype,
+				   const struct i40e_vf_region_ops *ops,
+				   size_t size, u32 flags, void *data)
+{
+	struct i40e_vf_region *regions;
+
+	regions = krealloc(i40e_vf_dev->regions,
+			   (i40e_vf_dev->num_regions + 1) * sizeof(*regions),
+			   GFP_KERNEL);
+	if (!regions)
+		return -ENOMEM;
+
+	i40e_vf_dev->regions = regions;
+	regions[i40e_vf_dev->num_regions].type = type;
+	regions[i40e_vf_dev->num_regions].subtype = subtype;
+	regions[i40e_vf_dev->num_regions].ops = ops;
+	regions[i40e_vf_dev->num_regions].size = size;
+	regions[i40e_vf_dev->num_regions].flags = flags;
+	regions[i40e_vf_dev->num_regions].data = data;
+	i40e_vf_dev->num_regions++;
+	return 0;
+}
+
+static long i40e_vf_get_region_info(void *device_data,
+				    unsigned int cmd, unsigned long arg)
+{
+	struct vfio_region_info info;
+	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+	int index, ret;
+	struct vfio_region_info_cap_type cap_type = {
+		.header.id = VFIO_REGION_INFO_CAP_TYPE,
+		.header.version = 1 };
+	struct i40e_vf_region *regions;
+	int num_vdev_regions = vfio_pci_num_regions(device_data);
+	unsigned long minsz;
+	struct i40e_vf_migration *i40e_vf_dev =
+		vfio_pci_vendor_data(device_data);
+
+	minsz = offsetofend(struct vfio_region_info, offset);
+
+	if (cmd != VFIO_DEVICE_GET_REGION_INFO)
+		return -EINVAL;
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+	if (info.argsz < minsz)
+		return -EINVAL;
+	if (info.index < VFIO_PCI_NUM_REGIONS + num_vdev_regions)
+		goto default_handle;
+
+	index = info.index - VFIO_PCI_NUM_REGIONS - num_vdev_regions;
+	if (index > i40e_vf_dev->num_regions)
+		return -EINVAL;
+
+	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+	regions = i40e_vf_dev->regions;
+	info.size = regions[index].size;
+	info.flags = regions[index].flags;
+	cap_type.type = regions[index].type;
+	cap_type.subtype = regions[index].subtype;
+
+	ret = vfio_info_add_capability(&caps, &cap_type.header,
+				       sizeof(cap_type));
+	if (ret)
+		return ret;
+
+	if (regions[index].ops->add_cap) {
+		ret = regions[index].ops->add_cap(i40e_vf_dev,
+				&regions[index], &caps);
+		if (ret)
+			return ret;
+	}
+
+	if (caps.size) {
+		info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
+		if (info.argsz < sizeof(info) + caps.size) {
+			info.argsz = sizeof(info) + caps.size;
+			info.cap_offset = 0;
+		} else {
+			vfio_info_cap_shift(&caps, sizeof(info));
+			if (copy_to_user((void __user *)arg + sizeof(info),
+					 caps.buf, caps.size)) {
+				kfree(caps.buf);
+				return -EFAULT;
+			}
+			info.cap_offset = sizeof(info);
+		}
+
+		kfree(caps.buf);
+	}
+
+	return copy_to_user((void __user *)arg, &info, minsz) ?
+		-EFAULT : 0;
+
+default_handle:
+	return vfio_pci_ioctl(device_data, cmd, arg);
+}
 
 static int i40e_vf_open(void *device_data)
 {
@@ -30,7 +375,26 @@ static int i40e_vf_open(void *device_data)
 
 	mutex_lock(&i40e_vf_dev->reflock);
 	if (!i40e_vf_dev->refcnt) {
-		vfio_pci_set_vendor_regions(device_data, 0);
+		mig_ctl = kzalloc(sizeof(*mig_ctl), GFP_KERNEL);
+		if (!mig_ctl) {
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		ret = i40e_vf_register_region(i40e_vf_dev,
+					      VFIO_REGION_TYPE_MIGRATION,
+					      VFIO_REGION_SUBTYPE_MIGRATION,
+					      &i40e_vf_region_ops_migration,
+					      MIGRATION_REGION_SZ,
+					      VFIO_REGION_INFO_FLAG_READ |
+					      VFIO_REGION_INFO_FLAG_WRITE,
+					      NULL);
+		if (ret)
+			goto error;
+
+		i40e_vf_dev->mig_ctl = mig_ctl;
+		vfio_pci_set_vendor_regions(device_data,
+					    i40e_vf_dev->num_regions);
 		vfio_pci_set_vendor_irqs(device_data, 0);
 	}
 
@@ -43,6 +407,10 @@ static int i40e_vf_open(void *device_data)
 	return 0;
 error:
 	if (!i40e_vf_dev->refcnt) {
+		kfree(mig_ctl);
+		kfree(i40e_vf_dev->regions);
+		i40e_vf_dev->num_regions = 0;
+		i40e_vf_dev->regions = NULL;
 		vfio_pci_set_vendor_regions(device_data, 0);
 		vfio_pci_set_vendor_irqs(device_data, 0);
 	}
@@ -56,8 +424,17 @@ void i40e_vf_release(void *device_data)
 	struct i40e_vf_migration *i40e_vf_dev =
 		vfio_pci_vendor_data(device_data);
 
+	i40e_vf_stop_dirty_track(i40e_vf_dev);
 	mutex_lock(&i40e_vf_dev->reflock);
 	if (!--i40e_vf_dev->refcnt) {
+		int i;
+
+		for (i = 0; i < i40e_vf_dev->num_regions; i++)
+			i40e_vf_dev->regions[i].ops->release(i40e_vf_dev,
+						&i40e_vf_dev->regions[i]);
+		i40e_vf_dev->num_regions = 0;
+		kfree(i40e_vf_dev->regions);
+		i40e_vf_dev->regions = NULL;
 		vfio_pci_set_vendor_regions(device_data, 0);
 		vfio_pci_set_vendor_irqs(device_data, 0);
 	}
@@ -69,19 +446,65 @@ void i40e_vf_release(void *device_data)
 static long i40e_vf_ioctl(void *device_data,
 			  unsigned int cmd, unsigned long arg)
 {
+	if (cmd == VFIO_DEVICE_GET_REGION_INFO)
+		return i40e_vf_get_region_info(device_data, cmd, arg);
+
 	return vfio_pci_ioctl(device_data, cmd, arg);
 }
 
 static ssize_t i40e_vf_read(void *device_data, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
-	return vfio_pci_read(device_data, buf, count, ppos);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct i40e_vf_migration *i40e_vf_dev =
+		vfio_pci_vendor_data(device_data);
+	struct i40e_vf_region *region;
+	int num_vdev_regions = vfio_pci_num_regions(device_data);
+	int num_vendor_region = i40e_vf_dev->num_regions;
+
+	if (index < VFIO_PCI_NUM_REGIONS + num_vdev_regions)
+		return vfio_pci_read(device_data, buf, count, ppos);
+	else if (index >= VFIO_PCI_NUM_REGIONS + num_vdev_regions +
+			num_vendor_region)
+		return -EINVAL;
+
+	index -= VFIO_PCI_NUM_REGIONS + num_vdev_regions;
+
+	region = &i40e_vf_dev->regions[index];
+	if (!region->ops->rw)
+		return -EINVAL;
+
+	return region->ops->rw(i40e_vf_dev, buf, count, ppos, false);
 }
 
 static ssize_t i40e_vf_write(void *device_data, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
-	return vfio_pci_write(device_data, buf, count, ppos);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct i40e_vf_migration *i40e_vf_dev =
+		vfio_pci_vendor_data(device_data);
+	struct i40e_vf_region *region;
+	int num_vdev_regions = vfio_pci_num_regions(device_data);
+	int num_vendor_region = i40e_vf_dev->num_regions;
+
+	if (index == VFIO_PCI_BAR0_REGION_INDEX)
+		;// scan dirty pages
+
+	if (index < VFIO_PCI_NUM_REGIONS + num_vdev_regions)
+		return vfio_pci_write(device_data, buf, count, ppos);
+	else if (index >= VFIO_PCI_NUM_REGIONS + num_vdev_regions +
+			num_vendor_region)
+		return -EINVAL;
+
+	index -= VFIO_PCI_NUM_REGIONS + num_vdev_regions;
+
+	region = &i40e_vf_dev->regions[index];
+
+	if (!region->ops->rw)
+		return -EINVAL;
+
+	return region->ops->rw(i40e_vf_dev, (char __user *)buf,
+			       count, ppos, true);
 }
 
 static int i40e_vf_mmap(void *device_data, struct vm_area_struct *vma)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
index 696d40601ec3..918ba275d5b5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
@@ -17,6 +17,8 @@
 #define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
 #define VFIO_PCI_OFFSET_MASK    (((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
 
+#define MIGRATION_REGION_SZ (sizeof(struct vfio_device_migration_info))
+
 /* Single Root I/O Virtualization */
 struct pci_sriov {
 	int		pos;		/* Capability position */
@@ -53,6 +55,38 @@ struct i40e_vf_migration {
 	int				vf_id;
 	int				refcnt;
 	struct				mutex reflock; /*mutex protect refcnt */
+
+	struct vfio_device_migration_info *mig_ctl;
+	bool				in_dirty_track;
+
+	struct i40e_vf_region		*regions;
+	int				num_regions;
+	struct notifier_block		iommu_notifier;
+	struct vfio_group		*vfio_group;
+
+};
+
+struct i40e_vf_region_ops {
+	ssize_t	(*rw)(struct i40e_vf_migration *i40e_vf_dev,
+		      char __user *buf, size_t count,
+		      loff_t *ppos, bool iswrite);
+	void	(*release)(struct i40e_vf_migration *i40e_vf_dev,
+			   struct i40e_vf_region *region);
+	int	(*mmap)(struct i40e_vf_migration *i40e_vf_dev,
+			struct i40e_vf_region *region,
+			struct vm_area_struct *vma);
+	int	(*add_cap)(struct i40e_vf_migration *i40e_vf_dev,
+			   struct i40e_vf_region *region,
+			   struct vfio_info_cap *caps);
+};
+
+struct i40e_vf_region {
+	u32				type;
+	u32				subtype;
+	size_t				size;
+	u32				flags;
+	const struct i40e_vf_region_ops	*ops;
+	void				*data;
 };
 
 #endif /* I40E_MIG_H */
-- 
2.17.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC2E5113A7B
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 04:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfLEDfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 22:35:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:22313 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbfLEDfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 22:35:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 19:35:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,279,1571727600"; 
   d="scan'208";a="243095279"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.9])
  by fmsmga002.fm.intel.com with ESMTP; 04 Dec 2019 19:35:52 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, qemu-devel@nongnu.org, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 8/9] i40e/vf_migration: mediate migration region
Date:   Wed,  4 Dec 2019 22:27:41 -0500
Message-Id: <20191205032741.29983-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191205032419.29606-1-yan.y.zhao@intel.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

in vfio_pci_mediate_ops->get_region_info(), migration region's len and
flags are overridden and its region index is saved.

vfio_pci_mediate_ops->rw() and vfio_pci_mediate_ops->mmap() overrides
default rw/mmap for migration region.

This is only a sample implementation in i440 vf migration to demonstrate
how vf migration code will look like. The actual dirty page tracking and
device state retrieving code would be sent in future. Currently only
comments are used as placeholders.

It's based on QEMU vfio migration code v8:
(https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05542.html).

Cc: Shaopeng He <shaopeng.he@intel.com>

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 .../ethernet/intel/i40e/i40e_vf_migration.c   | 335 +++++++++++++++++-
 .../ethernet/intel/i40e/i40e_vf_migration.h   |  14 +
 2 files changed, 345 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
index b2d913459600..5bb509fed66e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
@@ -14,6 +14,55 @@ static long open_device_bits[MAX_OPEN_DEVICE / BITS_PER_LONG + 1];
 static DEFINE_MUTEX(device_bit_lock);
 static struct i40e_vf_migration *i40e_vf_dev_array[MAX_OPEN_DEVICE];
 
+static bool is_handle_valid(int handle)
+{
+	mutex_lock(&device_bit_lock);
+
+	if (handle >= MAX_OPEN_DEVICE || !i40e_vf_dev_array[handle] ||
+	    !test_bit(handle, open_device_bits)) {
+		pr_err("%s: handle mismatch, please check interaction with vfio-pci module\n",
+		       __func__);
+		mutex_unlock(&device_bit_lock);
+		return false;
+	}
+	mutex_unlock(&device_bit_lock);
+	return true;
+}
+
+static size_t set_device_state(struct i40e_vf_migration *i40e_vf_dev, u32 state)
+{
+	int ret = 0;
+	struct vfio_device_migration_info *mig_ctl = i40e_vf_dev->mig_ctl;
+
+	if (state == mig_ctl->device_state)
+		return ret;
+
+	switch (state) {
+	case VFIO_DEVICE_STATE_RUNNING:
+		break;
+	case VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING:
+		// alloc dirty page tracking resources and
+		// do the first round dirty page scanning
+		break;
+	case VFIO_DEVICE_STATE_SAVING:
+		// do the last round of dirty page scanning
+		break;
+	case ~VFIO_DEVICE_STATE_MASK & VFIO_DEVICE_STATE_MASK:
+		// release dirty page tracking resources
+		//if (mig_ctl->device_state == VFIO_DEVICE_STATE_SAVING)
+		//	i40e_release_scan_resources(i40e_vf_dev);
+		break;
+	case VFIO_DEVICE_STATE_RESUMING:
+		break;
+	default:
+		ret = -EFAULT;
+	}
+
+	mig_ctl->device_state = state;
+
+	return ret;
+}
+
 int i40e_vf_migration_open(struct pci_dev *pdev, u64 *caps, u32 *dm_handle)
 {
 	int i, ret = 0;
@@ -24,6 +73,8 @@ int i40e_vf_migration_open(struct pci_dev *pdev, u64 *caps, u32 *dm_handle)
 	struct i40e_vf *vf;
 	unsigned int vf_devfn, devfn;
 	int vf_id = -1;
+	struct vfio_device_migration_info *mig_ctl = NULL;
+	void *dirty_bitmap_base = NULL;
 
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
@@ -68,18 +119,41 @@ int i40e_vf_migration_open(struct pci_dev *pdev, u64 *caps, u32 *dm_handle)
 	i40e_vf_dev->vf_dev = vf_dev;
 	i40e_vf_dev->handle = handle;
 
-	pr_info("%s: device %x %x, vf id %d, handle=%x\n",
-		__func__, pdev->vendor, pdev->device, vf_id, handle);
+	mig_ctl = kzalloc(sizeof(*mig_ctl), GFP_KERNEL);
+	if (!mig_ctl) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	dirty_bitmap_base = vmalloc_user(MIGRATION_DIRTY_BITMAP_SIZE);
+	if (!dirty_bitmap_base) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	i40e_vf_dev->dirty_bitmap = dirty_bitmap_base;
+	i40e_vf_dev->mig_ctl = mig_ctl;
+	i40e_vf_dev->migration_region_size = DIRTY_BITMAP_OFFSET +
+		MIGRATION_DIRTY_BITMAP_SIZE;
+	i40e_vf_dev->migration_region_index = -1;
+
+	vf = &pf->vf[vf_id];
 
 	i40e_vf_dev_array[handle] = i40e_vf_dev;
 	set_bit(handle, open_device_bits);
-	vf = &pf->vf[vf_id];
 	*dm_handle = handle;
+
+	*caps |= VFIO_PCI_DEVICE_CAP_MIGRATION;
+
+	pr_info("%s: device %x %x, vf id %d, handle=%x\n",
+		__func__, pdev->vendor, pdev->device, vf_id, handle);
 error:
 	mutex_unlock(&device_bit_lock);
 
 	if (ret < 0) {
 		module_put(THIS_MODULE);
+		kfree(mig_ctl);
+		vfree(dirty_bitmap_base);
 		kfree(i40e_vf_dev);
 	}
 
@@ -112,32 +186,285 @@ void i40e_vf_migration_release(int handle)
 		i40e_vf_dev->vf_vendor, i40e_vf_dev->vf_device,
 		i40e_vf_dev->vf_id);
 
+	kfree(i40e_vf_dev->mig_ctl);
+	vfree(i40e_vf_dev->dirty_bitmap);
 	kfree(i40e_vf_dev);
+
 	module_put(THIS_MODULE);
 }
 
+static void migration_region_sparse_mmap_cap(struct vfio_info_cap *caps)
+{
+	struct vfio_region_info_cap_sparse_mmap *sparse;
+	size_t size;
+	int nr_areas = 1;
+
+	size = sizeof(*sparse) + (nr_areas * sizeof(*sparse->areas));
+
+	sparse = kzalloc(size, GFP_KERNEL);
+	if (!sparse)
+		return;
+
+	sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+	sparse->header.version = 1;
+	sparse->nr_areas = nr_areas;
+
+	sparse->areas[0].offset = DIRTY_BITMAP_OFFSET;
+	sparse->areas[0].size = MIGRATION_DIRTY_BITMAP_SIZE;
+
+	vfio_info_add_capability(caps, &sparse->header, size);
+	kfree(sparse);
+}
+
 static void
 i40e_vf_migration_get_region_info(int handle,
 				  struct vfio_region_info *info,
 				  struct vfio_info_cap *caps,
 				  struct vfio_region_info_cap_type *cap_type)
 {
+	if (!is_handle_valid(handle))
+		return;
+
+	switch (info->index) {
+	case VFIO_PCI_BAR0_REGION_INDEX:
+		info->flags = VFIO_REGION_INFO_FLAG_READ |
+			VFIO_REGION_INFO_FLAG_WRITE;
+
+		break;
+	case VFIO_PCI_BAR1_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
+	case VFIO_PCI_CONFIG_REGION_INDEX:
+	case VFIO_PCI_ROM_REGION_INDEX:
+	case VFIO_PCI_VGA_REGION_INDEX:
+		break;
+	default:
+		if (cap_type->type == VFIO_REGION_TYPE_MIGRATION &&
+		    cap_type->subtype == VFIO_REGION_SUBTYPE_MIGRATION) {
+			struct i40e_vf_migration *i40e_vf_dev;
+
+			i40e_vf_dev = i40e_vf_dev_array[handle];
+			i40e_vf_dev->migration_region_index = info->index;
+			info->size = i40e_vf_dev->migration_region_size;
+
+			info->flags = VFIO_REGION_INFO_FLAG_CAPS |
+				VFIO_REGION_INFO_FLAG_READ |
+				VFIO_REGION_INFO_FLAG_WRITE |
+				VFIO_REGION_INFO_FLAG_MMAP;
+			migration_region_sparse_mmap_cap(caps);
+		}
+	}
+}
+
+static
+ssize_t i40e_vf_migration_region_rw(struct i40e_vf_migration *i40e_vf_dev,
+				    char __user *buf, size_t count,
+				    loff_t *ppos, bool iswrite, bool *pt)
+{
+#define VDM_OFFSET(x) offsetof(struct vfio_device_migration_info, x)
+	struct vfio_device_migration_info *mig_ctl = i40e_vf_dev->mig_ctl;
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	ssize_t ret = 0;
+
+	*pt = false;
+	switch (pos) {
+	case VDM_OFFSET(device_state):
+		if (count != sizeof(mig_ctl->device_state))
+			return -EINVAL;
+
+		if (iswrite) {
+			u32 device_state;
+
+			if (copy_from_user(&device_state, buf, count))
+				return -EFAULT;
+
+			set_device_state(i40e_vf_dev, device_state);
+			ret = count;
+		} else {
+			ret = -EFAULT;
+		}
+		break;
+
+	case VDM_OFFSET(reserved):
+		ret = -EFAULT;
+		break;
+
+	case VDM_OFFSET(pending_bytes):
+		if (count != sizeof(mig_ctl->pending_bytes))
+			return -EINVAL;
+
+		if (iswrite) {
+			ret = -EFAULT;
+		} else {
+			u64 p_bytes = 0;
+
+			ret = copy_to_user(buf, &p_bytes, count) ?
+				-EFAULT : count;
+		}
+		break;
+
+	case VDM_OFFSET(data_offset):
+		if (count != sizeof(mig_ctl->data_offset))
+			return -EINVAL;
+
+		if (iswrite) {
+			ret = -EFAULT;
+		} else {
+			u64 d_off = DIRTY_BITMAP_OFFSET;
+			/* always return dirty bitmap offset
+			 * here as we don't support device
+			 * internal dirty data
+			 * and our pending_bytes always return 0
+			 */
+			ret = copy_to_user(buf, &d_off, count) ?
+					-EFAULT : count;
+		}
+		break;
+
+	case VDM_OFFSET(data_size):
+		if (count != sizeof(mig_ctl->data_size))
+			return -EINVAL;
+
+		if (iswrite)
+			ret = copy_from_user(&mig_ctl->data_size, buf,
+					     count) ? -EFAULT : count;
+		else
+			ret = copy_to_user(buf, &mig_ctl->data_size,
+					   count) ? -EFAULT : count;
+		break;
+
+	case VDM_OFFSET(start_pfn):
+		if (count != sizeof(mig_ctl->start_pfn))
+			return -EINVAL;
+
+		if (iswrite)
+			ret = copy_from_user(&mig_ctl->start_pfn, buf,
+					     count) ? -EFAULT : count;
+		else
+			ret = -EFAULT;
+		break;
+
+	case VDM_OFFSET(page_size):
+		if (count != sizeof(mig_ctl->page_size))
+			return -EINVAL;
+
+		if (iswrite)
+			ret = copy_from_user(&mig_ctl->page_size, buf,
+					     count) ? -EFAULT : count;
+		else
+			ret = -EFAULT;
+		break;
+
+	case VDM_OFFSET(total_pfns):
+		if (count != sizeof(mig_ctl->total_pfns))
+			return -EINVAL;
+
+		if (iswrite) {
+			if (copy_from_user(&mig_ctl->total_pfns, buf, count))
+				return -EFAULT;
+
+			//calc dirty page bitmap
+			ret = count;
+		} else {
+			ret = -EFAULT;
+		}
+		break;
+
+	case VDM_OFFSET(copied_pfns):
+		if (count != sizeof(mig_ctl->copied_pfns))
+			return -EINVAL;
+
+		if (iswrite)
+			ret = -EFAULT;
+		else
+			ret = copy_to_user(buf, &mig_ctl->copied_pfns,
+					   count) ? -EFAULT : count;
+		break;
+
+	case DIRTY_BITMAP_OFFSET:
+		if (count > MIGRATION_DIRTY_BITMAP_SIZE || count < 0)
+			return -EINVAL;
+
+		if (iswrite)
+			ret = -EFAULT;
+		else
+			ret = copy_to_user(buf, i40e_vf_dev->dirty_bitmap,
+					   count) ? -EFAULT : count;
+		break;
+	default:
+		ret = -EFAULT;
+		break;
+	}
+	return ret;
 }
 
 static ssize_t i40e_vf_migration_rw(int handle, char __user *buf,
 				    size_t count, loff_t *ppos,
 				    bool iswrite, bool *pt)
 {
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct i40e_vf_migration *i40e_vf_dev;
+
 	*pt = true;
 
+	if (!is_handle_valid(handle))
+		return 0;
+
+	i40e_vf_dev = i40e_vf_dev_array[handle];
+
+	switch (index) {
+	case VFIO_PCI_BAR0_REGION_INDEX:
+		// scan dirty pages
+		break;
+	case VFIO_PCI_BAR1_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
+	case VFIO_PCI_CONFIG_REGION_INDEX:
+	case VFIO_PCI_ROM_REGION_INDEX:
+	case VFIO_PCI_VGA_REGION_INDEX:
+		break;
+	default:
+		if (index == i40e_vf_dev->migration_region_index) {
+			return i40e_vf_migration_region_rw(i40e_vf_dev, buf,
+					count, ppos, iswrite, pt);
+		}
+	}
 	return 0;
 }
 
 static int i40e_vf_migration_mmap(int handle, struct vm_area_struct *vma,
 				  bool *pt)
 {
+	unsigned int index;
+	struct i40e_vf_migration *i40e_vf_dev;
+	unsigned long pgoff = 0;
+	void *base;
+
+	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+
 	*pt = true;
-	return 0;
+	if (!is_handle_valid(handle))
+		return -EINVAL;
+
+	i40e_vf_dev = i40e_vf_dev_array[handle];
+
+	if (index != i40e_vf_dev->migration_region_index)
+		return 0;
+
+	*pt = false;
+	base = i40e_vf_dev->dirty_bitmap;
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+
+	if (pgoff != DIRTY_BITMAP_OFFSET / PAGE_SIZE)
+		return -EINVAL;
+
+	pr_info("%s, handle=%d, vf_id=%d, pgoff %lx\n", __func__,
+		handle, i40e_vf_dev->vf_id, pgoff);
+	return remap_vmalloc_range(vma, base, 0);
 }
 
 static struct vfio_pci_mediate_ops i40e_vf_migration_ops = {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
index b195399b6788..b31b500b3cd6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
@@ -11,8 +11,16 @@
 #include "i40e.h"
 #include "i40e_txrx.h"
 
+/* helper macros copied from vfio-pci */
+#define VFIO_PCI_OFFSET_SHIFT   40
+#define VFIO_PCI_OFFSET_TO_INDEX(off)   ((off) >> VFIO_PCI_OFFSET_SHIFT)
+#define VFIO_PCI_OFFSET_MASK    (((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
 #define MAX_OPEN_DEVICE 1024
 
+#define DIRTY_BITMAP_OFFSET \
+		PAGE_ALIGN(sizeof(struct vfio_device_migration_info))
+#define MIGRATION_DIRTY_BITMAP_SIZE (64 * 1024UL)
+
 /* Single Root I/O Virtualization */
 struct pci_sriov {
 	int		pos;		/* Capability position */
@@ -47,6 +55,12 @@ struct i40e_vf_migration {
 	struct pci_dev *pf_dev;
 	struct pci_dev *vf_dev;
 	int vf_id;
+
+	__u64 migration_region_index;
+	__u64 migration_region_size;
+
+	struct vfio_device_migration_info *mig_ctl;
+	void *dirty_bitmap;
 };
 #endif /* I40E_MIG_H */
 
-- 
2.17.1


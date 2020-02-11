Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B28158CA7
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 11:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgBKKZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 05:25:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:9947 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbgBKKZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 05:25:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 02:25:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="221889155"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga007.jf.intel.com with ESMTP; 11 Feb 2020 02:25:04 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v3 9/9] i40e/vf_migration: vfio-pci vendor driver for VF live migration
Date:   Tue, 11 Feb 2020 05:15:43 -0500
Message-Id: <20200211101543.21238-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211095727.20426-1-yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio pci operates on regions
(1) 0 ~ VFIO_PCI_NUM_REGIONS - 1
(2) VFIO_PCI_NUM_REGIONS ~ VFIO_PCI_NUM_REGIONS + vdev->num_regions -1

vf_migration operates on regions
VFIO_PCI_NUM_REGIONS + vdev->num_regions ~
VFIO_PCI_NUM_REGIONS + vdev->num_regions + vdev->num_vendor_regions

vf_migration also intercept BAR0 write operation.

Cc: Shaopeng He <shaopeng.he@intel.com>

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/net/ethernet/intel/Kconfig            |  10 +
 drivers/net/ethernet/intel/i40e/Makefile      |   2 +
 drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
 .../ethernet/intel/i40e/i40e_vf_migration.c   | 635 ++++++++++++++++++
 .../ethernet/intel/i40e/i40e_vf_migration.h   |  92 +++
 5 files changed, 741 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.h

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 154e2e818ec6..fee0e70e6164 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -264,6 +264,16 @@ config I40E_DCB
 
 	  If unsure, say N.
 
+config I40E_VF_MIGRATION
+	tristate "XL710 Family VF live migration support -- loadable modules only"
+	depends on I40E && VFIO_PCI && m
+	help
+	  Say m if you want to enable live migration of
+	  Virtual Functions of Intel(R) Ethernet Controller XL710
+	  Family of devices. It must be a module.
+	  This module serves as vendor module of module vfio_pci.
+	  VFs bind to module vfio_pci directly.
+
 # this is here to allow seamless migration from I40EVF --> IAVF name
 # so that CONFIG_IAVF symbol will always mirror the state of CONFIG_I40EVF
 config IAVF
diff --git a/drivers/net/ethernet/intel/i40e/Makefile b/drivers/net/ethernet/intel/i40e/Makefile
index 2f21b3e89fd0..b80c224c2602 100644
--- a/drivers/net/ethernet/intel/i40e/Makefile
+++ b/drivers/net/ethernet/intel/i40e/Makefile
@@ -27,3 +27,5 @@ i40e-objs := i40e_main.o \
 	i40e_xsk.o
 
 i40e-$(CONFIG_I40E_DCB) += i40e_dcb.o i40e_dcb_nl.o
+
+obj-$(CONFIG_I40E_VF_MIGRATION) += i40e_vf_migration.o
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 2af9f6308f84..0141c94b835f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1162,4 +1162,6 @@ int i40e_add_del_cloud_filter(struct i40e_vsi *vsi,
 int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 				      struct i40e_cloud_filter *filter,
 				      bool add);
+int i40e_vf_migration_register(void);
+void i40e_vf_migration_unregister(void);
 #endif /* _I40E_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
new file mode 100644
index 000000000000..64517d54e81d
--- /dev/null
+++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
@@ -0,0 +1,635 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/vfio.h>
+#include <linux/pci.h>
+#include <linux/eventfd.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sysfs.h>
+#include <linux/file.h>
+#include <linux/pci.h>
+
+#include "i40e.h"
+#include "i40e_vf_migration.h"
+
+#define VERSION_STRING  "0.1"
+#define DRIVER_AUTHOR   "Intel Corporation"
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
+		//      i40e_release_scan_resources(i40e_vf_dev);
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
+		{
+		u64 p_bytes = 0;
+
+		if (count != sizeof(mig_ctl->pending_bytes)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (iswrite)
+			ret = -EFAULT;
+		else
+			ret = copy_to_user(buf, &p_bytes, count) ?
+					   -EFAULT : count;
+
+		break;
+		}
+
+	case VDM_OFFSET(data_offset):
+		{
+		u64 d_off = DIRTY_BITMAP_OFFSET;
+
+		if (count != sizeof(mig_ctl->data_offset)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (iswrite) {
+			ret = -EFAULT;
+			break;
+		}
+
+		/* always return dirty bitmap offset here as we don't support
+		 * device internal dirty data and our pending_bytes always
+		 * return 0
+		 */
+		ret = copy_to_user(buf, &d_off, count) ? -EFAULT : count;
+		break;
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
+	case VDM_OFFSET(start_pfn):
+		if (count != sizeof(mig_ctl->start_pfn)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (iswrite)
+			ret = copy_from_user(&mig_ctl->start_pfn, buf, count) ?
+					     -EFAULT : count;
+		else
+			ret = -EFAULT;
+		break;
+
+	case VDM_OFFSET(page_size):
+		if (count != sizeof(mig_ctl->page_size)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (iswrite)
+			ret = copy_from_user(&mig_ctl->page_size, buf,	count) ?
+					     -EFAULT : count;
+		else
+			ret = -EFAULT;
+		break;
+
+	case VDM_OFFSET(total_pfns):
+		if (count != sizeof(mig_ctl->total_pfns)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (iswrite) {
+			if (copy_from_user(&mig_ctl->total_pfns, buf, count)) {
+				ret = -EFAULT;
+				break;
+			}
+			//calc dirty page bitmap
+			ret = count;
+		} else {
+			ret = -EFAULT;
+		}
+		break;
+
+	case VDM_OFFSET(copied_pfns):
+		if (count != sizeof(mig_ctl->copied_pfns)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (iswrite)
+			ret = -EFAULT;
+		else
+			ret = copy_to_user(buf, &mig_ctl->copied_pfns, count) ?
+					   -EFAULT : count;
+		break;
+
+	case DIRTY_BITMAP_OFFSET:
+		if (count > MIGRATION_DIRTY_BITMAP_SIZE || count < 0) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (iswrite)
+			ret = -EFAULT;
+		else
+			ret = copy_to_user(buf, i40e_vf_dev->dirty_bitmap,
+					   count) ? -EFAULT : count;
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
+int i40e_vf_region_migration_add_cap(struct i40e_vf_migration *i40e_vf_dev,
+				     struct i40e_vf_region *region,
+				     struct vfio_info_cap *caps)
+{
+	struct vfio_region_info_cap_sparse_mmap *sparse;
+	size_t size;
+	int nr_areas = 1;
+
+	size = sizeof(*sparse) + (nr_areas * sizeof(*sparse->areas));
+
+	sparse = kzalloc(size, GFP_KERNEL);
+	if (!sparse)
+		return -ENOMEM;
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
+	return 0;
+}
+
+static
+int i40e_vf_region_migration_mmap(struct i40e_vf_migration *i40e_vf_dev,
+				  struct i40e_vf_region *region,
+				  struct vm_area_struct *vma)
+{
+	unsigned long pgoff = 0;
+	void *base;
+
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
+	return remap_vmalloc_range(vma, base, 0);
+}
+
+static
+void i40e_vf_region_migration_release(struct i40e_vf_migration *i40e_vf_dev,
+				      struct i40e_vf_region *region)
+{
+	if (i40e_vf_dev->dirty_bitmap) {
+		vfree(i40e_vf_dev->dirty_bitmap);
+		i40e_vf_dev->dirty_bitmap = NULL;
+	}
+	kfree(i40e_vf_dev->mig_ctl);
+	i40e_vf_dev->mig_ctl = NULL;
+}
+
+static const struct i40e_vf_region_ops i40e_vf_region_ops_migration = {
+	.rw		= i40e_vf_region_migration_rw,
+	.release	= i40e_vf_region_migration_release,
+	.mmap		= i40e_vf_region_migration_mmap,
+	.add_cap	= i40e_vf_region_migration_add_cap
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
+void *i40e_vf_probe(struct pci_dev *pdev)
+{
+	struct i40e_vf_migration *i40e_vf_dev = NULL;
+	struct pci_dev *pf_dev, *vf_dev;
+	struct i40e_pf *pf;
+	struct i40e_vf *vf;
+	unsigned int vf_devfn, devfn;
+	int vf_id = -1;
+	int i;
+
+	pf_dev = pdev->physfn;
+	pf = pci_get_drvdata(pf_dev);
+	vf_dev = pdev;
+	vf_devfn = vf_dev->devfn;
+
+	for (i = 0; i < pci_num_vf(pf_dev); i++) {
+		devfn = (pf_dev->devfn + pf_dev->sriov->offset +
+			 pf_dev->sriov->stride * i) & 0xff;
+		if (devfn == vf_devfn) {
+			vf_id = i;
+			break;
+		}
+	}
+
+	if (vf_id == -1)
+		return ERR_PTR(-EINVAL);
+
+	i40e_vf_dev = kzalloc(sizeof(*i40e_vf_dev), GFP_KERNEL);
+
+	if (!i40e_vf_dev)
+		return ERR_PTR(-ENOMEM);
+
+	i40e_vf_dev->vf_id = vf_id;
+	i40e_vf_dev->vf_vendor = pdev->vendor;
+	i40e_vf_dev->vf_device = pdev->device;
+	i40e_vf_dev->pf_dev = pf_dev;
+	i40e_vf_dev->vf_dev = vf_dev;
+	mutex_init(&i40e_vf_dev->reflock);
+
+	vf = &pf->vf[vf_id];
+
+	return i40e_vf_dev;
+}
+
+static void i40e_vf_remove(void *vendor_data)
+{
+	struct i40e_vf_migration *i40e_vf_dev =
+				(struct i40e_vf_migration *)vendor_data;
+	kfree(i40e_vf_dev);
+}
+
+static int i40e_vf_open(void *device_data)
+{
+	struct vfio_pci_device *vdev = device_data;
+	struct i40e_vf_migration *i40e_vf_dev =
+				(struct i40e_vf_migration *)vdev->vendor_data;
+	int ret;
+	struct vfio_device_migration_info *mig_ctl = NULL;
+	void *dirty_bitmap_base = NULL;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	mutex_lock(&i40e_vf_dev->reflock);
+	if (!i40e_vf_dev->refcnt) {
+		mig_ctl = kzalloc(sizeof(*mig_ctl), GFP_KERNEL);
+		if (!mig_ctl) {
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		dirty_bitmap_base = vmalloc_user(MIGRATION_DIRTY_BITMAP_SIZE);
+		if (!dirty_bitmap_base) {
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		ret = i40e_vf_register_region(i40e_vf_dev,
+					      VFIO_REGION_TYPE_MIGRATION,
+					      VFIO_REGION_SUBTYPE_MIGRATION,
+					      &i40e_vf_region_ops_migration,
+					      DIRTY_BITMAP_OFFSET +
+					      MIGRATION_DIRTY_BITMAP_SIZE,
+					      VFIO_REGION_INFO_FLAG_CAPS |
+					      VFIO_REGION_INFO_FLAG_READ |
+					      VFIO_REGION_INFO_FLAG_WRITE |
+					      VFIO_REGION_INFO_FLAG_MMAP,
+					      NULL);
+		if (ret)
+			goto error;
+
+		i40e_vf_dev->dirty_bitmap = dirty_bitmap_base;
+		i40e_vf_dev->mig_ctl = mig_ctl;
+		vdev->num_vendor_regions = i40e_vf_dev->num_regions;
+	}
+
+	ret = vfio_pci_open(vdev);
+	if (ret)
+		goto error;
+
+	i40e_vf_dev->refcnt++;
+	mutex_unlock(&i40e_vf_dev->reflock);
+	return 0;
+error:
+	if (!i40e_vf_dev->refcnt) {
+		kfree(mig_ctl);
+		vfree(dirty_bitmap_base);
+		kfree(i40e_vf_dev->regions);
+		i40e_vf_dev->num_regions = 0;
+		i40e_vf_dev->regions = NULL;
+		vdev->num_vendor_regions = 0;
+	}
+	module_put(THIS_MODULE);
+	mutex_unlock(&i40e_vf_dev->reflock);
+	return ret;
+ }
+
+void i40e_vf_release(void *device_data)
+{
+	struct vfio_pci_device *vdev = device_data;
+	struct i40e_vf_migration *i40e_vf_dev =
+				(struct i40e_vf_migration *)vdev->vendor_data;
+
+	mutex_lock(&i40e_vf_dev->reflock);
+	if (!--i40e_vf_dev->refcnt) {
+		int i;
+
+		for (i = 0; i < i40e_vf_dev->num_regions; i++)
+			i40e_vf_dev->regions[i].ops->release(i40e_vf_dev,
+						&i40e_vf_dev->regions[i]);
+		i40e_vf_dev->num_regions = 0;
+		kfree(i40e_vf_dev->regions);
+		i40e_vf_dev->regions = NULL;
+		vdev->num_vendor_regions = 0;
+	}
+	mutex_unlock(&i40e_vf_dev->reflock);
+	vfio_pci_release(vdev);
+	module_put(THIS_MODULE);
+}
+
+static long i40e_vf_ioctl(void *device_data,
+			  unsigned int cmd, unsigned long arg)
+{
+	struct vfio_pci_device *vdev = device_data;
+	struct i40e_vf_migration *i40e_vf_dev =
+				(struct i40e_vf_migration *)vdev->vendor_data;
+	unsigned long minsz;
+
+	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+		struct vfio_region_info info;
+		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+		int index, ret;
+		struct vfio_region_info_cap_type cap_type = {
+			.header.id = VFIO_REGION_INFO_CAP_TYPE,
+			.header.version = 1 };
+		struct i40e_vf_region *regions;
+
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+		if (info.argsz < minsz)
+			return -EINVAL;
+		if (info.index < VFIO_PCI_NUM_REGIONS + vdev->num_regions)
+			goto default_handle;
+
+		index = info.index - VFIO_PCI_NUM_REGIONS - vdev->num_regions;
+		if (index > i40e_vf_dev->num_regions)
+			return -EINVAL;
+
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		regions = i40e_vf_dev->regions;
+		info.size = regions[index].size;
+		info.flags = regions[index].flags;
+		cap_type.type = regions[index].type;
+		cap_type.subtype = regions[index].subtype;
+
+		ret = vfio_info_add_capability(&caps, &cap_type.header,
+					       sizeof(cap_type));
+		if (ret)
+			return ret;
+
+		if (regions[index].ops->add_cap) {
+			ret = regions[index].ops->add_cap(i40e_vf_dev,
+						&regions[index], &caps);
+				if (ret)
+					return ret;
+		}
+
+		if (caps.size) {
+			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
+			if (info.argsz < sizeof(info) + caps.size) {
+				info.argsz = sizeof(info) + caps.size;
+				info.cap_offset = 0;
+			} else {
+				vfio_info_cap_shift(&caps, sizeof(info));
+				if (copy_to_user((void __user *)arg +
+						  sizeof(info), caps.buf,
+						  caps.size)) {
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
+			-EFAULT : 0;
+	}
+
+default_handle:
+	return vfio_pci_ioctl(vdev, cmd, arg);
+}
+
+static ssize_t i40e_vf_read(void *device_data, char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct vfio_pci_device *vdev = device_data;
+	struct i40e_vf_migration *i40e_vf_dev =
+				(struct i40e_vf_migration *)vdev->vendor_data;
+	struct i40e_vf_region *region;
+
+	if (index < VFIO_PCI_NUM_REGIONS + vdev->num_regions)
+		return vfio_pci_read(vdev, buf, count, ppos);
+	else if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions +
+			vdev->num_vendor_regions)
+		return -EINVAL;
+
+	index -= VFIO_PCI_NUM_REGIONS + vdev->num_regions;
+
+	region = &i40e_vf_dev->regions[index];
+	if (!region->ops->rw)
+		return -EINVAL;
+
+	return region->ops->rw(i40e_vf_dev, buf, count, ppos, false);
+}
+
+static ssize_t i40e_vf_write(void *device_data, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct vfio_pci_device *vdev = device_data;
+	struct i40e_vf_migration *i40e_vf_dev =
+				(struct i40e_vf_migration *)vdev->vendor_data;
+	struct i40e_vf_region *region;
+
+	if (index == VFIO_PCI_BAR0_REGION_INDEX) {
+		;// scan dirty pages
+	}
+
+	if (index < VFIO_PCI_NUM_REGIONS + vdev->num_regions)
+		return vfio_pci_write(vdev, buf, count, ppos);
+	else if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions +
+			vdev->num_vendor_regions)
+		return -EINVAL;
+
+	index -= VFIO_PCI_NUM_REGIONS + vdev->num_regions;
+
+	region = &i40e_vf_dev->regions[index];
+
+	if (!region->ops->rw)
+		return -EINVAL;
+
+	return region->ops->rw(i40e_vf_dev, (char __user *)buf,
+			       count, ppos, true);
+}
+
+static int i40e_vf_mmap(void *device_data, struct vm_area_struct *vma)
+{
+	struct vfio_pci_device *vdev = device_data;
+	struct i40e_vf_migration *i40e_vf_dev =
+				(struct i40e_vf_migration *)vdev->vendor_data;
+	unsigned int index;
+	struct i40e_vf_region *region;
+
+	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	if (index < VFIO_PCI_NUM_REGIONS + vdev->num_regions)
+		return vfio_pci_mmap(vdev, vma);
+	else if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions +
+			vdev->num_vendor_regions)
+		return -EINVAL;
+
+	index -= VFIO_PCI_NUM_REGIONS + vdev->num_regions;
+
+	region = &i40e_vf_dev->regions[index];
+	if (!region->ops->mmap)
+		return -EINVAL;
+
+	return region->ops->mmap(i40e_vf_dev, region, vma);
+}
+
+static void i40e_vf_request(void *device_data, unsigned int count)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	vfio_pci_request(vdev, count);
+}
+
+static struct vfio_device_ops i40e_vf_device_ops_node = {
+	.name		= "i40e_vf",
+	.open		= i40e_vf_open,
+	.release	= i40e_vf_release,
+	.ioctl		= i40e_vf_ioctl,
+	.read		= i40e_vf_read,
+	.write		= i40e_vf_write,
+	.mmap		= i40e_vf_mmap,
+	.request	= i40e_vf_request,
+};
+
+#define i40e_vf_device_ops (&i40e_vf_device_ops_node)
+module_vfio_pci_register_vendor_handler("I40E VF", i40e_vf_probe,
+					i40e_vf_remove, i40e_vf_device_ops);
+
+MODULE_ALIAS("vfio-pci:8086-154c");
+MODULE_LICENSE("GPL v2");
+MODULE_INFO(supported, "Vendor driver of vfio pci to support VF live migration");
+MODULE_VERSION(VERSION_STRING);
+MODULE_AUTHOR(DRIVER_AUTHOR);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
new file mode 100644
index 000000000000..4d804f8cb032
--- /dev/null
+++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
+
+#ifndef I40E_MIG_H
+#define I40E_MIG_H
+
+#include <linux/pci.h>
+#include <linux/vfio.h>
+#include <linux/mdev.h>
+
+#include "i40e.h"
+#include "i40e_txrx.h"
+
+/* helper macros copied from vfio-pci */
+#define VFIO_PCI_OFFSET_SHIFT   40
+#define VFIO_PCI_OFFSET_TO_INDEX(off)   ((off) >> VFIO_PCI_OFFSET_SHIFT)
+#define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
+#define VFIO_PCI_OFFSET_MASK    (((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
+#define DIRTY_BITMAP_OFFSET \
+			PAGE_ALIGN(sizeof(struct vfio_device_migration_info))
+#define MIGRATION_DIRTY_BITMAP_SIZE (64 * 1024UL)
+
+/* Single Root I/O Virtualization */
+struct pci_sriov {
+	int		pos;		/* Capability position */
+	int		nres;		/* Number of resources */
+	u32		cap;		/* SR-IOV Capabilities */
+	u16		ctrl;		/* SR-IOV Control */
+	u16		total_VFs;	/* Total VFs associated with the PF */
+	u16		initial_VFs;	/* Initial VFs associated with the PF */
+	u16		num_VFs;	/* Number of VFs available */
+	u16		offset;		/* First VF Routing ID offset */
+	u16		stride;		/* Following VF stride */
+	u16		vf_device;	/* VF device ID */
+	u32		pgsz;		/* Page size for BAR alignment */
+	u8		link;		/* Function Dependency Link */
+	u8		max_VF_buses;	/* Max buses consumed by VFs */
+	u16		driver_max_VFs;	/* Max num VFs driver supports */
+	struct pci_dev	*dev;		/* Lowest numbered PF */
+	struct pci_dev	*self;		/* This PF */
+	u32		cfg_size;	/* VF config space size */
+	u32		class;		/* VF device */
+	u8		hdr_type;	/* VF header type */
+	u16		subsystem_vendor; /* VF subsystem vendor */
+	u16		subsystem_device; /* VF subsystem device */
+	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
+	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
+};
+
+struct i40e_vf_migration {
+	__u32				vf_vendor;
+	__u32				vf_device;
+	__u32				handle;
+	struct pci_dev			*pf_dev;
+	struct pci_dev			*vf_dev;
+	int				vf_id;
+	int				refcnt;
+	struct				mutex reflock; /*mutex protect refcnt */
+
+	struct vfio_device_migration_info *mig_ctl;
+	void				*dirty_bitmap;
+
+	struct i40e_vf_region		*regions;
+	int				num_regions;
+};
+
+struct i40e_vf_region;
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
+};
+
+#endif /* I40E_MIG_H */
+
-- 
2.17.1


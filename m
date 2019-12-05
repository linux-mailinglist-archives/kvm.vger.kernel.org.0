Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F380113A69
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 04:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfLEDd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 22:33:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:22205 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbfLEDd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 22:33:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 19:33:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,279,1571727600"; 
   d="scan'208";a="243094895"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.9])
  by fmsmga002.fm.intel.com with ESMTP; 04 Dec 2019 19:33:56 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, qemu-devel@nongnu.org, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 1/9] vfio/pci: introduce mediate ops to intercept vfio-pci ops
Date:   Wed,  4 Dec 2019 22:25:36 -0500
Message-Id: <20191205032536.29653-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191205032419.29606-1-yan.y.zhao@intel.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

when vfio-pci is bound to a physical device, almost all the hardware
resources are passthroughed.
Sometimes, vendor driver of this physcial device may want to mediate some
hardware resource access for a short period of time, e.g. dirty page
tracking during live migration.

Here we introduce mediate ops in vfio-pci for this purpose.

Vendor driver can register a mediate ops to vfio-pci.
But rather than directly bind to the passthroughed device, the
vendor driver is now either a module that does not bind to any device or
a module binds to other device.
E.g. when passing through a VF device that is bound to vfio-pci modules,
PF driver that binds to PF device can register to vfio-pci to mediate
VF's regions, hence supporting VF live migration.

The sequence goes like this:
1. Vendor driver register its vfio_pci_mediate_ops to vfio-pci driver

2. vfio-pci maintains a list of those registered vfio_pci_mediate_ops

3. Whenever vfio-pci opens a device, it searches the list and call
vfio_pci_mediate_ops->open() to check whether a vendor driver supports
mediating this device.
Upon a success return value of from vfio_pci_mediate_ops->open(),
vfio-pci will stop list searching and store a mediate handle to
represent this open into vendor driver.
(so if multiple vendor drivers support mediating a device through
vfio_pci_mediate_ops, only one will win, depending on their registering
sequence)

4. Whenever a VFIO_DEVICE_GET_REGION_INFO ioctl is received in vfio-pci
ops, it will chain into vfio_pci_mediate_ops->get_region_info(), so that
vendor driver is able to override a region's default flags and caps,
e.g. adding a sparse mmap cap to passthrough only sub-regions of a whole
region.

5. vfio_pci_rw()/vfio_pci_mmap() first calls into
vfio_pci_mediate_ops->rw()/vfio_pci_mediate_ops->mmaps().
if pt=true is rteturned, vfio_pci_rw()/vfio_pci_mmap() will further
passthrough this read/write/mmap to physical device, otherwise it just
returns without touch physical device.

6. When vfio-pci closes a device, vfio_pci_release() chains into
vfio_pci_mediate_ops->release() to close the reference in vendor driver.

7. Vendor driver unregister its vfio_pci_mediate_ops when driver exits

Cc: Kevin Tian <kevin.tian@intel.com>

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 146 ++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |   2 +
 include/linux/vfio.h                |  16 +++
 3 files changed, 164 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 02206162eaa9..55080ff29495 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -54,6 +54,14 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(disable_idle_d3,
 		 "Disable using the PCI D3 low power state for idle, unused devices");
 
+static LIST_HEAD(mediate_ops_list);
+static DEFINE_MUTEX(mediate_ops_list_lock);
+struct vfio_pci_mediate_ops_list_entry {
+	struct vfio_pci_mediate_ops	*ops;
+	int				refcnt;
+	struct list_head		next;
+};
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -472,6 +480,10 @@ static void vfio_pci_release(void *device_data)
 	if (!(--vdev->refcnt)) {
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
+		if (vdev->mediate_ops && vdev->mediate_ops->release) {
+			vdev->mediate_ops->release(vdev->mediate_handle);
+			vdev->mediate_ops = NULL;
+		}
 	}
 
 	mutex_unlock(&vdev->reflck->lock);
@@ -483,6 +495,7 @@ static int vfio_pci_open(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
 	int ret = 0;
+	struct vfio_pci_mediate_ops_list_entry *mentry;
 
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
@@ -495,6 +508,30 @@ static int vfio_pci_open(void *device_data)
 			goto error;
 
 		vfio_spapr_pci_eeh_open(vdev->pdev);
+		mutex_lock(&mediate_ops_list_lock);
+		list_for_each_entry(mentry, &mediate_ops_list, next) {
+			u64 caps;
+			u32 handle;
+
+			memset(&caps, 0, sizeof(caps));
+			ret = mentry->ops->open(vdev->pdev, &caps, &handle);
+			if (!ret)  {
+				vdev->mediate_ops = mentry->ops;
+				vdev->mediate_handle = handle;
+
+				pr_info("vfio pci found mediate_ops %s, caps=%llx, handle=%x for %x:%x\n",
+						vdev->mediate_ops->name, caps,
+						handle, vdev->pdev->vendor,
+						vdev->pdev->device);
+				/*
+				 * only find the first matching mediate_ops,
+				 * and add its refcnt
+				 */
+				mentry->refcnt++;
+				break;
+			}
+		}
+		mutex_unlock(&mediate_ops_list_lock);
 	}
 	vdev->refcnt++;
 error:
@@ -736,6 +773,14 @@ static long vfio_pci_ioctl(void *device_data,
 			info.size = pdev->cfg_size;
 			info.flags = VFIO_REGION_INFO_FLAG_READ |
 				     VFIO_REGION_INFO_FLAG_WRITE;
+
+			if (vdev->mediate_ops &&
+					vdev->mediate_ops->get_region_info) {
+				vdev->mediate_ops->get_region_info(
+						vdev->mediate_handle,
+						&info, &caps, NULL);
+			}
+
 			break;
 		case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
 			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
@@ -756,6 +801,13 @@ static long vfio_pci_ioctl(void *device_data,
 				}
 			}
 
+			if (vdev->mediate_ops &&
+					vdev->mediate_ops->get_region_info) {
+				vdev->mediate_ops->get_region_info(
+						vdev->mediate_handle,
+						&info, &caps, NULL);
+			}
+
 			break;
 		case VFIO_PCI_ROM_REGION_INDEX:
 		{
@@ -794,6 +846,14 @@ static long vfio_pci_ioctl(void *device_data,
 			}
 
 			pci_write_config_word(pdev, PCI_COMMAND, orig_cmd);
+
+			if (vdev->mediate_ops &&
+					vdev->mediate_ops->get_region_info) {
+				vdev->mediate_ops->get_region_info(
+						vdev->mediate_handle,
+						&info, &caps, NULL);
+			}
+
 			break;
 		}
 		case VFIO_PCI_VGA_REGION_INDEX:
@@ -805,6 +865,13 @@ static long vfio_pci_ioctl(void *device_data,
 			info.flags = VFIO_REGION_INFO_FLAG_READ |
 				     VFIO_REGION_INFO_FLAG_WRITE;
 
+			if (vdev->mediate_ops &&
+					vdev->mediate_ops->get_region_info) {
+				vdev->mediate_ops->get_region_info(
+						vdev->mediate_handle,
+						&info, &caps, NULL);
+			}
+
 			break;
 		default:
 		{
@@ -839,6 +906,13 @@ static long vfio_pci_ioctl(void *device_data,
 				if (ret)
 					return ret;
 			}
+
+			if (vdev->mediate_ops &&
+					vdev->mediate_ops->get_region_info) {
+				vdev->mediate_ops->get_region_info(
+						vdev->mediate_handle,
+						&info, &caps, &cap_type);
+			}
 		}
 		}
 
@@ -1151,6 +1225,16 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
 
+	if (vdev->mediate_ops && vdev->mediate_ops->rw) {
+		int ret;
+		bool pt = true;
+
+		ret = vdev->mediate_ops->rw(vdev->mediate_handle,
+				buf, count, ppos, iswrite, &pt);
+		if (!pt)
+			return ret;
+	}
+
 	switch (index) {
 	case VFIO_PCI_CONFIG_REGION_INDEX:
 		return vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
@@ -1200,6 +1284,15 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	u64 phys_len, req_len, pgoff, req_start;
 	int ret;
 
+	if (vdev->mediate_ops && vdev->mediate_ops->mmap) {
+		int ret;
+		bool pt = true;
+
+		ret = vdev->mediate_ops->mmap(vdev->mediate_handle, vma, &pt);
+		if (!pt)
+			return ret;
+	}
+
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
 	if (vma->vm_end < vma->vm_start)
@@ -1629,8 +1722,17 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 
 static void __exit vfio_pci_cleanup(void)
 {
+	struct vfio_pci_mediate_ops_list_entry *mentry, *n;
+
 	pci_unregister_driver(&vfio_pci_driver);
 	vfio_pci_uninit_perm_bits();
+
+	mutex_lock(&mediate_ops_list_lock);
+	list_for_each_entry_safe(mentry, n,  &mediate_ops_list, next) {
+		list_del(&mentry->next);
+		kfree(mentry);
+	}
+	mutex_unlock(&mediate_ops_list_lock);
 }
 
 static void __init vfio_pci_fill_ids(void)
@@ -1697,6 +1799,50 @@ static int __init vfio_pci_init(void)
 	return ret;
 }
 
+int vfio_pci_register_mediate_ops(struct vfio_pci_mediate_ops *ops)
+{
+	struct vfio_pci_mediate_ops_list_entry *mentry;
+
+	mutex_lock(&mediate_ops_list_lock);
+	mentry = kzalloc(sizeof(*mentry), GFP_KERNEL);
+	if (!mentry) {
+		mutex_unlock(&mediate_ops_list_lock);
+		return -ENOMEM;
+	}
+
+	mentry->ops = ops;
+	mentry->refcnt = 0;
+	list_add(&mentry->next, &mediate_ops_list);
+
+	pr_info("registered dm ops %s\n", ops->name);
+	mutex_unlock(&mediate_ops_list_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(vfio_pci_register_mediate_ops);
+
+void vfio_pci_unregister_mediate_ops(struct vfio_pci_mediate_ops *ops)
+{
+	struct vfio_pci_mediate_ops_list_entry *mentry, *n;
+
+	mutex_lock(&mediate_ops_list_lock);
+	list_for_each_entry_safe(mentry, n,  &mediate_ops_list, next) {
+		if (mentry->ops != ops)
+			continue;
+
+		mentry->refcnt--;
+		if (!mentry->refcnt) {
+			list_del(&mentry->next);
+			kfree(mentry);
+		} else
+			pr_err("vfio_pci unregister mediate ops %s error\n",
+					mentry->ops->name);
+	}
+	mutex_unlock(&mediate_ops_list_lock);
+
+}
+EXPORT_SYMBOL(vfio_pci_unregister_mediate_ops);
+
 module_init(vfio_pci_init);
 module_exit(vfio_pci_cleanup);
 
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index ee6ee91718a4..bad4a254360e 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -122,6 +122,8 @@ struct vfio_pci_device {
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
+	struct vfio_pci_mediate_ops *mediate_ops;
+	u32			 mediate_handle;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e42a711a2800..0265e779acd1 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -195,4 +195,20 @@ extern int vfio_virqfd_enable(void *opaque,
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
+struct vfio_pci_mediate_ops {
+	char	*name;
+	int	(*open)(struct pci_dev *pdev, u64 *caps, u32 *handle);
+	void	(*release)(int handle);
+	void	(*get_region_info)(int handle,
+			struct vfio_region_info *info,
+			struct vfio_info_cap *caps,
+			struct vfio_region_info_cap_type *cap_type);
+	ssize_t	(*rw)(int handle, char __user *buf,
+			   size_t count, loff_t *ppos, bool iswrite, bool *pt);
+	int	(*mmap)(int handle, struct vm_area_struct *vma, bool *pt);
+
+};
+extern int vfio_pci_register_mediate_ops(struct vfio_pci_mediate_ops *ops);
+extern void vfio_pci_unregister_mediate_ops(struct vfio_pci_mediate_ops *ops);
+
 #endif /* VFIO_H */
-- 
2.17.1


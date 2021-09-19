Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FBB410A42
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhISGnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:43:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:41280 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235995AbhISGnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:43:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="219805436"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="219805436"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:42:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510701940"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:41:56 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@intel.com, yi.l.liu@linux.intel.com, jun.j.tian@intel.com,
        hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: [RFC 05/20] vfio/pci: Register device to /dev/vfio/devices
Date:   Sun, 19 Sep 2021 14:38:33 +0800
Message-Id: <20210919063848.1476776-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch exposes the device-centric interface for vfio-pci devices. To
be compatiable with existing users, vfio-pci exposes both legacy group
interface and device-centric interface.

As explained in last patch, this change doesn't apply to devices which
cannot be forced to snoop cache by their upstream iommu. Such devices
are still expected to be opened via the legacy group interface.

When the device is opened via /dev/vfio/devices, vfio-pci should prevent
the user from accessing the assigned device because the device is still
attached to the default domain which may allow user-initiated DMAs to
touch arbitrary place. The user access must be blocked until the device
is later bound to an iommufd (see patch 08). The binding acts as the
contract for putting the device in a security context which ensures user-
initiated DMAs via this device cannot harm the rest of the system.

This patch introduces a vdev->block_access flag for this purpose. It's set
when the device is opened via /dev/vfio/devices and cleared after binding
to iommufd succeeds. mmap and r/w handlers check this flag to decide whether
user access should be blocked or not.

An alternative option is to use a dummy fops when the device is opened and
then switch to the real fops (replace_fops()) after binding. Appreciate
inputs on which option is better.

The legacy group interface doesn't have this problem. Its uAPI requires the
user to first put the device into a security context via container/group
attaching process, before opening the device through the groupfd.

Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 25 +++++++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 drivers/vfio/vfio.c                 |  3 ++-
 include/linux/vfio.h                |  1 +
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 318864d52837..145addde983b 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -572,6 +572,10 @@ static int vfio_pci_open(struct vfio_device *core_vdev)
 
 		vfio_spapr_pci_eeh_open(vdev->pdev);
 		vfio_pci_vf_token_user_add(vdev, 1);
+		if (!vfio_device_in_container(core_vdev))
+			atomic_set(&vdev->block_access, 1);
+		else
+			atomic_set(&vdev->block_access, 0);
 	}
 	vdev->refcnt++;
 error:
@@ -1374,6 +1378,9 @@ static ssize_t vfio_pci_rw(struct vfio_pci_device *vdev, char __user *buf,
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 
+	if (atomic_read(&vdev->block_access))
+		return -ENODEV;
+
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
 
@@ -1640,6 +1647,9 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
 	u64 phys_len, req_len, pgoff, req_start;
 	int ret;
 
+	if (atomic_read(&vdev->block_access))
+		return -ENODEV;
+
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
@@ -1978,6 +1988,8 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct vfio_pci_device *vdev;
 	struct iommu_group *group;
 	int ret;
+	u32 flags;
+	bool snoop = false;
 
 	if (vfio_pci_is_denylisted(pdev))
 		return -EINVAL;
@@ -2046,9 +2058,18 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
 
-	ret = vfio_register_group_dev(&vdev->vdev);
-	if (ret)
+	flags = VFIO_DEVNODE_GROUP;
+	ret = iommu_device_get_info(&pdev->dev,
+				    IOMMU_DEV_INFO_FORCE_SNOOP, &snoop);
+	if (!ret && snoop)
+		flags |= VFIO_DEVNODE_NONGROUP;
+
+	ret = vfio_register_device(&vdev->vdev, flags);
+	if (ret) {
+		pr_debug("Failed to register device interface\n");
 		goto out_power;
+	}
+
 	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 5a36272cecbf..f12012e30b53 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -143,6 +143,7 @@ struct vfio_pci_device {
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
 	struct rw_semaphore	memory_lock;
+	atomic_t		block_access;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 1e87b25962f1..22851747e92c 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1789,10 +1789,11 @@ static int vfio_device_fops_open(struct inode *inode, struct file *filep)
 	return ret;
 }
 
-static bool vfio_device_in_container(struct vfio_device *device)
+bool vfio_device_in_container(struct vfio_device *device)
 {
 	return !!(device->group && device->group->container);
 }
+EXPORT_SYMBOL_GPL(vfio_device_in_container);
 
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 9448b751b663..fd0629acb948 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -81,6 +81,7 @@ enum vfio_iommu_notify_type {
 
 extern int vfio_register_device(struct vfio_device *device, u32 flags);
 extern void vfio_unregister_device(struct vfio_device *device);
+extern bool vfio_device_in_container(struct vfio_device *device);
 
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7950410A62
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238233AbhISGpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:45:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:46216 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236140AbhISGoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:44:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="245397304"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="245397304"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:43:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510702110"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:43:05 -0700
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
Subject: [RFC 15/20] vfio/pci: Add VFIO_DEVICE_[DE]ATTACH_IOASID
Date:   Sun, 19 Sep 2021 14:38:43 +0800
Message-Id: <20210919063848.1476776-16-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds interface for userspace to attach device to specified
IOASID.

Note:
One device can only be attached to one IOASID in this version. This is
on par with what vfio provides today. In the future this restriction can
be relaxed when multiple I/O address spaces are supported per device

Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 82 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 include/linux/iommufd.h             |  1 +
 include/uapi/linux/vfio.h           | 26 +++++++++
 4 files changed, 110 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 20006bb66430..5b1fda333122 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -557,6 +557,11 @@ static void vfio_pci_release(struct vfio_device *core_vdev)
 		if (vdev->videv) {
 			struct vfio_iommufd_device *videv = vdev->videv;
 
+			if (videv->ioasid != IOMMUFD_INVALID_IOASID) {
+				iommufd_device_detach_ioasid(videv->idev,
+							     videv->ioasid);
+				videv->ioasid = IOMMUFD_INVALID_IOASID;
+			}
 			vdev->videv = NULL;
 			iommufd_unbind_device(videv->idev);
 			kfree(videv);
@@ -839,6 +844,7 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 		}
 		videv->idev = idev;
 		videv->iommu_fd = bind_data.iommu_fd;
+		videv->ioasid = IOMMUFD_INVALID_IOASID;
 		/*
 		 * A security context has been established. Unblock
 		 * user access.
@@ -848,6 +854,82 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 		vdev->videv = videv;
 		mutex_unlock(&vdev->videv_lock);
 
+		return 0;
+	} else if (cmd == VFIO_DEVICE_ATTACH_IOASID) {
+		struct vfio_device_attach_ioasid attach;
+		unsigned long minsz;
+		struct vfio_iommufd_device *videv;
+		int ret = 0;
+
+		/* not allowed if the device is opened in legacy interface */
+		if (vfio_device_in_container(core_vdev))
+			return -ENOTTY;
+
+		minsz = offsetofend(struct vfio_device_attach_ioasid, ioasid);
+		if (copy_from_user(&attach, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (attach.argsz < minsz || attach.flags ||
+		    attach.iommu_fd < 0 || attach.ioasid < 0)
+			return -EINVAL;
+
+		mutex_lock(&vdev->videv_lock);
+
+		videv = vdev->videv;
+		if (!videv || videv->iommu_fd != attach.iommu_fd) {
+			mutex_unlock(&vdev->videv_lock);
+			return -EINVAL;
+		}
+
+		/* Currently only allows one IOASID attach */
+		if (videv->ioasid != IOMMUFD_INVALID_IOASID) {
+			mutex_unlock(&vdev->videv_lock);
+			return -EBUSY;
+		}
+
+		ret = __pci_iommufd_device_attach_ioasid(vdev->pdev,
+							 videv->idev,
+							 attach.ioasid);
+		if (!ret)
+			videv->ioasid = attach.ioasid;
+		mutex_unlock(&vdev->videv_lock);
+
+		return ret;
+	} else if (cmd == VFIO_DEVICE_DETACH_IOASID) {
+		struct vfio_device_attach_ioasid attach;
+		unsigned long minsz;
+		struct vfio_iommufd_device *videv;
+
+		/* not allowed if the device is opened in legacy interface */
+		if (vfio_device_in_container(core_vdev))
+			return -ENOTTY;
+
+		minsz = offsetofend(struct vfio_device_attach_ioasid, ioasid);
+		if (copy_from_user(&attach, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (attach.argsz < minsz || attach.flags ||
+		    attach.iommu_fd < 0 || attach.ioasid < 0)
+			return -EINVAL;
+
+		mutex_lock(&vdev->videv_lock);
+
+		videv = vdev->videv;
+		if (!videv || videv->iommu_fd != attach.iommu_fd) {
+			mutex_unlock(&vdev->videv_lock);
+			return -EINVAL;
+		}
+
+		if (videv->ioasid == IOMMUFD_INVALID_IOASID ||
+		    videv->ioasid != attach.ioasid) {
+			mutex_unlock(&vdev->videv_lock);
+			return -EINVAL;
+		}
+
+		videv->ioasid = IOMMUFD_INVALID_IOASID;
+		iommufd_device_detach_ioasid(videv->idev, attach.ioasid);
+		mutex_unlock(&vdev->videv_lock);
+
 		return 0;
 	} else if (cmd == VFIO_DEVICE_GET_INFO) {
 		struct vfio_device_info info;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index bd784accac35..daa0f08ac835 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -103,6 +103,7 @@ struct vfio_pci_mmap_vma {
 struct vfio_iommufd_device {
 	struct iommufd_device *idev;
 	int iommu_fd;
+	int ioasid;
 };
 
 struct vfio_pci_device {
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 01a4fe934143..36d8d2fd22bb 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -17,6 +17,7 @@
 
 #define IOMMUFD_IOASID_MAX	((unsigned int)(0x7FFFFFFF))
 #define IOMMUFD_IOASID_MIN	0
+#define IOMMUFD_INVALID_IOASID	-1
 
 #define IOMMUFD_DEVID_MAX	((unsigned int)(0x7FFFFFFF))
 #define IOMMUFD_DEVID_MIN	0
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index c902abd60339..61493ab03038 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -220,6 +220,32 @@ struct vfio_device_iommu_bind_data {
 
 #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
 
+/*
+ * VFIO_DEVICE_ATTACH_IOASID - _IOW(VFIO_TYPE, VFIO_BASE + 21,
+ *				struct vfio_device_attach_ioasid)
+ *
+ * Attach a vfio device to the specified IOASID
+ *
+ * Multiple vfio devices can be attached to the same IOASID. One device can
+ * be attached to only one ioasid at this point.
+ *
+ * @argsz:	user filled size of this data.
+ * @flags:	reserved for future extension.
+ * @iommu_fd:	iommufd where the ioasid comes from.
+ * @ioasid:	target I/O address space.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_attach_ioasid {
+	__u32	argsz;
+	__u32	flags;
+	__s32	iommu_fd;
+	__s32	ioasid;
+};
+
+#define VFIO_DEVICE_ATTACH_IOASID	_IO(VFIO_TYPE, VFIO_BASE + 20)
+#define VFIO_DEVICE_DETACH_IOASID	_IO(VFIO_TYPE, VFIO_BASE + 21)
+
 /**
  * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
  *						struct vfio_device_info)
-- 
2.25.1


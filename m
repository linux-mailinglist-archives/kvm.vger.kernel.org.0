Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C1D410A6E
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbhISGqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:46:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:28921 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236937AbhISGqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:46:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="202493466"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="202493466"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:43:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510702171"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:43:25 -0700
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
Subject: [RFC 18/20] iommu/iommufd: Add IOMMU_[UN]MAP_DMA on IOASID
Date:   Sun, 19 Sep 2021 14:38:46 +0800
Message-Id: <20210919063848.1476776-19-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[HACK. will fix in v2]

This patch introduces vfio type1v2-equivalent interface to userspace. Due
to aforementioned hack, iommufd currently calls exported vfio symbols to
handle map/unmap requests from the user.

Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/iommufd.c | 104 ++++++++++++++++++++++++++++++++
 include/uapi/linux/iommu.h      |  29 +++++++++
 2 files changed, 133 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd.c b/drivers/iommu/iommufd/iommufd.c
index cbf5e30062a6..f5f2274d658c 100644
--- a/drivers/iommu/iommufd/iommufd.c
+++ b/drivers/iommu/iommufd/iommufd.c
@@ -55,6 +55,7 @@ struct iommufd_ioas {
 	struct mutex lock;
 	struct list_head device_list;
 	struct iommu_domain *domain;
+	struct vfio_iommu *vfio_iommu; /* FIXME: added for reusing vfio_iommu_type1 code */
 };
 
 /*
@@ -158,6 +159,7 @@ static void ioas_put_locked(struct iommufd_ioas *ioas)
 		return;
 
 	WARN_ON(!list_empty(&ioas->device_list));
+	vfio_iommu_type1_release(ioas->vfio_iommu); /* FIXME: reused vfio code */
 	xa_erase(&ictx->ioasid_xa, ioasid);
 	iommufd_ctx_put(ictx);
 	kfree(ioas);
@@ -185,6 +187,7 @@ static int iommufd_ioasid_alloc(struct iommufd_ctx *ictx, unsigned long arg)
 	struct iommufd_ioas *ioas;
 	unsigned long minsz;
 	int ioasid, ret;
+	struct vfio_iommu *vfio_iommu;
 
 	minsz = offsetofend(struct iommu_ioasid_alloc, addr_width);
 
@@ -211,6 +214,18 @@ static int iommufd_ioasid_alloc(struct iommufd_ctx *ictx, unsigned long arg)
 		return ret;
 	}
 
+	/* FIXME: get a vfio_iommu object for dma map/unmap management */
+	vfio_iommu = vfio_iommu_type1_open(VFIO_TYPE1v2_IOMMU);
+	if (IS_ERR(vfio_iommu)) {
+		pr_err_ratelimited("Failed to get vfio_iommu object\n");
+		mutex_lock(&ictx->lock);
+		xa_erase(&ictx->ioasid_xa, ioasid);
+		mutex_unlock(&ictx->lock);
+		kfree(ioas);
+		return PTR_ERR(vfio_iommu);
+	}
+	ioas->vfio_iommu = vfio_iommu;
+
 	ioas->ioasid = ioasid;
 
 	/* only supports kernel managed I/O page table so far */
@@ -383,6 +398,49 @@ static int iommufd_get_device_info(struct iommufd_ctx *ictx,
 	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 }
 
+static int iommufd_process_dma_op(struct iommufd_ctx *ictx,
+				  unsigned long arg, bool map)
+{
+	struct iommu_ioasid_dma_op dma;
+	unsigned long minsz;
+	struct iommufd_ioas *ioas = NULL;
+	int ret;
+
+	minsz = offsetofend(struct iommu_ioasid_dma_op, padding);
+
+	if (copy_from_user(&dma, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (dma.argsz < minsz || dma.flags || dma.ioasid < 0)
+		return -EINVAL;
+
+	ioas = ioasid_get_ioas(ictx, dma.ioasid);
+	if (!ioas) {
+		pr_err_ratelimited("unkonwn IOASID %u\n", dma.ioasid);
+		return -EINVAL;
+	}
+
+	mutex_lock(&ioas->lock);
+
+	/*
+	 * Needs to block map/unmap request from userspace before IOASID
+	 * is attached to any device.
+	 */
+	if (list_empty(&ioas->device_list)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (map)
+		ret = vfio_iommu_type1_map_dma(ioas->vfio_iommu, arg + minsz);
+	else
+		ret = vfio_iommu_type1_unmap_dma(ioas->vfio_iommu, arg + minsz);
+out:
+	mutex_unlock(&ioas->lock);
+	ioas_put(ioas);
+	return ret;
+};
+
 static long iommufd_fops_unl_ioctl(struct file *filep,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -409,6 +467,12 @@ static long iommufd_fops_unl_ioctl(struct file *filep,
 	case IOMMU_IOASID_FREE:
 		ret = iommufd_ioasid_free(ictx, arg);
 		break;
+	case IOMMU_MAP_DMA:
+		ret = iommufd_process_dma_op(ictx, arg, true);
+		break;
+	case IOMMU_UNMAP_DMA:
+		ret = iommufd_process_dma_op(ictx, arg, false);
+		break;
 	default:
 		pr_err_ratelimited("unsupported cmd %u\n", cmd);
 		break;
@@ -478,6 +542,39 @@ static int ioas_check_device_compatibility(struct iommufd_ioas *ioas,
 	return 0;
 }
 
+/* HACK:
+ * vfio_iommu_add/remove_device() is hacky implementation for
+ * this version to add the device/group to vfio iommu type1.
+ */
+static int vfio_iommu_add_device(struct vfio_iommu *vfio_iommu,
+				 struct device *dev,
+				 struct iommu_domain *domain)
+{
+	struct iommu_group *group;
+	int ret;
+
+	group = iommu_group_get(dev);
+	if (!group)
+		return -EINVAL;
+
+	ret = vfio_iommu_add_group(vfio_iommu, group, domain);
+	iommu_group_put(group);
+	return ret;
+}
+
+static void vfio_iommu_remove_device(struct vfio_iommu *vfio_iommu,
+				     struct device *dev)
+{
+	struct iommu_group *group;
+
+	group = iommu_group_get(dev);
+	if (!group)
+		return;
+
+	vfio_iommu_remove_group(vfio_iommu, group);
+	iommu_group_put(group);
+}
+
 /**
  * iommufd_device_attach_ioasid - attach device to an ioasid
  * @idev: [in] Pointer to struct iommufd_device.
@@ -539,11 +636,17 @@ int iommufd_device_attach_ioasid(struct iommufd_device *idev, int ioasid)
 	if (ret)
 		goto out_domain;
 
+	ret = vfio_iommu_add_device(ioas->vfio_iommu, idev->dev, domain);
+	if (ret)
+		goto out_detach;
+
 	ioas_dev->idev = idev;
 	list_add(&ioas_dev->next, &ioas->device_list);
 	mutex_unlock(&ioas->lock);
 
 	return 0;
+out_detach:
+	iommu_detach_device(domain, idev->dev);
 out_domain:
 	ioas_free_domain_if_empty(ioas);
 out_free:
@@ -579,6 +682,7 @@ void iommufd_device_detach_ioasid(struct iommufd_device *idev, int ioasid)
 	}
 
 	list_del(&ioas_dev->next);
+	vfio_iommu_remove_device(ioas->vfio_iommu, idev->dev);
 	iommu_detach_device(ioas->domain, idev->dev);
 	ioas_free_domain_if_empty(ioas);
 	kfree(ioas_dev);
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index f408ad3c8ade..fe815cc1f665 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -141,6 +141,35 @@ struct iommu_ioasid_alloc {
 
 #define IOMMU_IOASID_FREE		_IO(IOMMU_TYPE, IOMMU_BASE + 3)
 
+/*
+ * Map/unmap process virtual addresses to I/O virtual addresses.
+ *
+ * Provide VFIO type1 equivalent semantics. Start with the same
+ * restriction e.g. the unmap size should match those used in the
+ * original mapping call.
+ *
+ * @argsz:	user filled size of this data.
+ * @flags:	reserved for future extension.
+ * @ioasid:	the handle of target I/O address space.
+ * @data:	the operation payload, refer to vfio_iommu_type1_dma_{un}map.
+ *
+ * FIXME:
+ *	userspace needs to include uapi/vfio.h as well as interface reuses
+ *	the map/unmap logic from vfio iommu type1.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct iommu_ioasid_dma_op {
+	__u32	argsz;
+	__u32	flags;
+	__s32	ioasid;
+	__u32	padding;
+	__u8	data[];
+};
+
+#define IOMMU_MAP_DMA	_IO(IOMMU_TYPE, IOMMU_BASE + 4)
+#define IOMMU_UNMAP_DMA	_IO(IOMMU_TYPE, IOMMU_BASE + 5)
+
 #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
 #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
 #define IOMMU_FAULT_PERM_EXEC	(1 << 2) /* exec */
-- 
2.25.1


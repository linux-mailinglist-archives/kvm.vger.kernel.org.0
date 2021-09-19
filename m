Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4159410A60
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238965AbhISGo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:44:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:46210 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238600AbhISGo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:44:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="245397297"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="245397297"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:43:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510702097"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:42:58 -0700
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
Subject: [RFC 14/20] iommu/iommufd: Add iommufd_device_[de]attach_ioasid()
Date:   Sun, 19 Sep 2021 14:38:42 +0800
Message-Id: <20210919063848.1476776-15-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An I/O address space takes effect in the iommu only after it's attached
by a device. This patch provides iommufd_device_[de/at]tach_ioasid()
helpers for this purpose. One device can be only attached to one ioasid
at this point, but one ioasid can be attached by multiple devices.

The caller specifies the iommufd_device (returned at binding time) and
the target ioasid when calling the helper function. Upon request, iommufd
installs the specified I/O page table to the correct place in the IOMMU,
according to the routing information (struct device* which represents
RID) recorded in iommufd_device. Future variants could allow the caller
to specify additional routing information (e.g. pasid/ssid) when multiple
I/O address spaces are supported per device.

Open:
Per Jason's comment in below link, bus-specific wrappers are recommended.
This RFC implements one wrapper for pci device. But it looks that struct
pci_device is not used at all since iommufd_ device already carries all
necessary info. So want to have another discussion on its necessity, e.g.
whether making more sense to have bus-specific wrappers for binding, while
leaving a common attaching helper per iommufd_device.
https://lore.kernel.org/linux-iommu/20210528233649.GB3816344@nvidia.com/

TODO:
When multiple devices are attached to a same ioasid, the permitted iova
ranges and supported pgsize bitmap on this ioasid should be a common
subset of all attached devices. iommufd needs to track such info per
ioasid and update it every time when a new device is attached to the
ioasid. This has not been done in this version yet, due to the temporary
hack adopted in patch 16-18. The hack reuses vfio type1 driver which
already includes the necessary logic for iova ranges and pgsize bitmap.
Once we get a clear direction for those patches, that logic will be moved
to this patch.

Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/iommufd.c | 226 ++++++++++++++++++++++++++++++++
 include/linux/iommufd.h         |  29 ++++
 2 files changed, 255 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd.c b/drivers/iommu/iommufd/iommufd.c
index e45d76359e34..25373a0e037a 100644
--- a/drivers/iommu/iommufd/iommufd.c
+++ b/drivers/iommu/iommufd/iommufd.c
@@ -51,6 +51,19 @@ struct iommufd_ioas {
 	bool enforce_snoop;
 	struct iommufd_ctx *ictx;
 	refcount_t refs;
+	struct mutex lock;
+	struct list_head device_list;
+	struct iommu_domain *domain;
+};
+
+/*
+ * An ioas_device_info object is created per each successful attaching
+ * request. A list of objects are maintained per ioas when the address
+ * space is shared by multiple devices.
+ */
+struct ioas_device_info {
+	struct iommufd_device *idev;
+	struct list_head next;
 };
 
 static int iommufd_fops_open(struct inode *inode, struct file *filep)
@@ -119,6 +132,21 @@ static void iommufd_ctx_put(struct iommufd_ctx *ictx)
 	kfree(ictx);
 }
 
+static struct iommufd_ioas *ioasid_get_ioas(struct iommufd_ctx *ictx, int ioasid)
+{
+	struct iommufd_ioas *ioas;
+
+	if (ioasid < 0)
+		return NULL;
+
+	mutex_lock(&ictx->lock);
+	ioas = xa_load(&ictx->ioasid_xa, ioasid);
+	if (ioas)
+		refcount_inc(&ioas->refs);
+	mutex_unlock(&ictx->lock);
+	return ioas;
+}
+
 /* Caller should hold ictx->lock */
 static void ioas_put_locked(struct iommufd_ioas *ioas)
 {
@@ -128,11 +156,28 @@ static void ioas_put_locked(struct iommufd_ioas *ioas)
 	if (!refcount_dec_and_test(&ioas->refs))
 		return;
 
+	WARN_ON(!list_empty(&ioas->device_list));
 	xa_erase(&ictx->ioasid_xa, ioasid);
 	iommufd_ctx_put(ictx);
 	kfree(ioas);
 }
 
+/*
+ * Caller should hold a ictx reference when calling this function
+ * otherwise ictx might be freed in ioas_put_locked() then the last
+ * unlock becomes problematic. Alternatively we could have a fresh
+ * implementation of ioas_put instead of calling the locked function.
+ * In this case it can ensure ictx is freed after mutext_unlock().
+ */
+static void ioas_put(struct iommufd_ioas *ioas)
+{
+	struct iommufd_ctx *ictx = ioas->ictx;
+
+	mutex_lock(&ictx->lock);
+	ioas_put_locked(ioas);
+	mutex_unlock(&ictx->lock);
+}
+
 static int iommufd_ioasid_alloc(struct iommufd_ctx *ictx, unsigned long arg)
 {
 	struct iommu_ioasid_alloc req;
@@ -178,6 +223,9 @@ static int iommufd_ioasid_alloc(struct iommufd_ctx *ictx, unsigned long arg)
 	iommufd_ctx_get(ictx);
 	ioas->ictx = ictx;
 
+	mutex_init(&ioas->lock);
+	INIT_LIST_HEAD(&ioas->device_list);
+
 	refcount_set(&ioas->refs, 1);
 
 	return ioasid;
@@ -344,6 +392,166 @@ static struct miscdevice iommu_misc_dev = {
 	.mode = 0666,
 };
 
+/* Caller should hold ioas->lock */
+static struct ioas_device_info *ioas_find_device(struct iommufd_ioas *ioas,
+						 struct iommufd_device *idev)
+{
+	struct ioas_device_info *ioas_dev;
+
+	list_for_each_entry(ioas_dev, &ioas->device_list, next) {
+		if (ioas_dev->idev == idev)
+			return ioas_dev;
+	}
+
+	return NULL;
+}
+
+static void ioas_free_domain_if_empty(struct iommufd_ioas *ioas)
+{
+	if (list_empty(&ioas->device_list)) {
+		iommu_domain_free(ioas->domain);
+		ioas->domain = NULL;
+	}
+}
+
+static int ioas_check_device_compatibility(struct iommufd_ioas *ioas,
+					   struct device *dev)
+{
+	bool snoop = false;
+	u32 addr_width;
+	int ret;
+
+	/*
+	 * currently we only support I/O page table with iommu enforce-snoop
+	 * format. Attaching a device which doesn't support this format in its
+	 * upstreaming iommu is rejected.
+	 */
+	ret = iommu_device_get_info(dev, IOMMU_DEV_INFO_FORCE_SNOOP, &snoop);
+	if (ret || !snoop)
+		return -EINVAL;
+
+	ret = iommu_device_get_info(dev, IOMMU_DEV_INFO_ADDR_WIDTH, &addr_width);
+	if (ret || addr_width < ioas->addr_width)
+		return -EINVAL;
+
+	/* TODO: also need to check permitted iova ranges and pgsize bitmap */
+
+	return 0;
+}
+
+/**
+ * iommufd_device_attach_ioasid - attach device to an ioasid
+ * @idev: [in] Pointer to struct iommufd_device.
+ * @ioasid: [in] ioasid points to an I/O address space.
+ *
+ * Returns 0 for successful attach, otherwise returns error.
+ *
+ */
+int iommufd_device_attach_ioasid(struct iommufd_device *idev, int ioasid)
+{
+	struct iommufd_ioas *ioas;
+	struct ioas_device_info *ioas_dev;
+	struct iommu_domain *domain;
+	int ret;
+
+	ioas = ioasid_get_ioas(idev->ictx, ioasid);
+	if (!ioas) {
+		pr_err_ratelimited("Trying to attach illegal or unkonwn IOASID %u\n", ioasid);
+		return -EINVAL;
+	}
+
+	mutex_lock(&ioas->lock);
+
+	/* Check for duplicates */
+	if (ioas_find_device(ioas, idev)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ret = ioas_check_device_compatibility(ioas, idev->dev);
+	if (ret)
+		goto out_unlock;
+
+	ioas_dev = kzalloc(sizeof(*ioas_dev), GFP_KERNEL);
+	if (!ioas_dev) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	/*
+	 * Each ioas is backed by an iommu domain, which is allocated
+	 * when the ioas is attached for the first time and then shared
+	 * by following devices.
+	 */
+	if (list_empty(&ioas->device_list)) {
+		struct iommu_domain *d;
+
+		d = iommu_domain_alloc(idev->dev->bus);
+		if (!d) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+		ioas->domain = d;
+	}
+	domain = ioas->domain;
+
+	/* Install the I/O page table to the iommu for this device */
+	ret = iommu_attach_device(domain, idev->dev);
+	if (ret)
+		goto out_domain;
+
+	ioas_dev->idev = idev;
+	list_add(&ioas_dev->next, &ioas->device_list);
+	mutex_unlock(&ioas->lock);
+
+	return 0;
+out_domain:
+	ioas_free_domain_if_empty(ioas);
+out_free:
+	kfree(ioas_dev);
+out_unlock:
+	mutex_unlock(&ioas->lock);
+	ioas_put(ioas);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommufd_device_attach_ioasid);
+
+/**
+ * iommufd_device_detach_ioasid - Detach an ioasid from a device.
+ * @idev: [in] Pointer to struct iommufd_device.
+ * @ioasid: [in] ioasid points to an I/O address space.
+ *
+ */
+void iommufd_device_detach_ioasid(struct iommufd_device *idev, int ioasid)
+{
+	struct iommufd_ioas *ioas;
+	struct ioas_device_info *ioas_dev;
+
+	ioas = ioasid_get_ioas(idev->ictx, ioasid);
+	if (!ioas)
+		return;
+
+	mutex_lock(&ioas->lock);
+	ioas_dev = ioas_find_device(ioas, idev);
+	if (!ioas_dev) {
+		mutex_unlock(&ioas->lock);
+		goto out;
+	}
+
+	list_del(&ioas_dev->next);
+	iommu_detach_device(ioas->domain, idev->dev);
+	ioas_free_domain_if_empty(ioas);
+	kfree(ioas_dev);
+	mutex_unlock(&ioas->lock);
+
+	/* release the reference acquired at the start of this function */
+	ioas_put(ioas);
+out:
+	ioas_put(ioas);
+}
+EXPORT_SYMBOL_GPL(iommufd_device_detach_ioasid);
+
 /**
  * iommufd_bind_device - Bind a physical device marked by a device
  *			 cookie to an iommu fd.
@@ -426,8 +634,26 @@ EXPORT_SYMBOL_GPL(iommufd_bind_device);
 void iommufd_unbind_device(struct iommufd_device *idev)
 {
 	struct iommufd_ctx *ictx = idev->ictx;
+	struct iommufd_ioas *ioas;
+	unsigned long index;
 
 	mutex_lock(&ictx->lock);
+	xa_for_each(&ictx->ioasid_xa, index, ioas) {
+		struct ioas_device_info *ioas_dev;
+
+		mutex_lock(&ioas->lock);
+		ioas_dev = ioas_find_device(ioas, idev);
+		if (!ioas_dev) {
+			mutex_unlock(&ioas->lock);
+			continue;
+		}
+		list_del(&ioas_dev->next);
+		iommu_detach_device(ioas->domain, idev->dev);
+		ioas_free_domain_if_empty(ioas);
+		kfree(ioas_dev);
+		mutex_unlock(&ioas->lock);
+		ioas_put_locked(ioas);
+	}
 	xa_erase(&ictx->device_xa, idev->id);
 	mutex_unlock(&ictx->lock);
 	/* Exit the security context */
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 1dd6515e7816..01a4fe934143 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/device.h>
+#include <linux/pci.h>
 
 #define IOMMUFD_IOASID_MAX	((unsigned int)(0x7FFFFFFF))
 #define IOMMUFD_IOASID_MIN	0
@@ -27,6 +28,16 @@ struct iommufd_device *
 iommufd_bind_device(int fd, struct device *dev, u64 dev_cookie);
 void iommufd_unbind_device(struct iommufd_device *idev);
 
+int iommufd_device_attach_ioasid(struct iommufd_device *idev, int ioasid);
+void iommufd_device_detach_ioasid(struct iommufd_device *idev, int ioasid);
+
+static inline int
+__pci_iommufd_device_attach_ioasid(struct pci_dev *pdev,
+				   struct iommufd_device *idev, int ioasid)
+{
+	return iommufd_device_attach_ioasid(idev, ioasid);
+}
+
 #else /* !CONFIG_IOMMUFD */
 static inline struct iommufd_device *
 iommufd_bind_device(int fd, struct device *dev, u64 dev_cookie)
@@ -37,5 +48,23 @@ iommufd_bind_device(int fd, struct device *dev, u64 dev_cookie)
 static inline void iommufd_unbind_device(struct iommufd_device *idev)
 {
 }
+
+static inline int iommufd_device_attach_ioasid(struct iommufd_device *idev,
+					       int ioasid)
+{
+	return -ENODEV;
+}
+
+static inline void iommufd_device_detach_ioasid(struct iommufd_device *idev,
+						int ioasid)
+{
+}
+
+static inline int
+__pci_iommufd_device_attach_ioasid(struct pci_dev *pdev,
+				   struct iommufd_device *idev, int ioasid)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_IOMMUFD */
 #endif /* __LINUX_IOMMUFD_H */
-- 
2.25.1


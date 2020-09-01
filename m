Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C782C258656
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 05:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgIADkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 23:40:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:62487 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgIADkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 23:40:16 -0400
IronPort-SDR: Qdzp17WSKunMvCE+OdArXgFE75BvhNgSdsLBQNxp96BDdIKK7tFcqJzAfRiR3QP9NYkpHM0EQZ
 TE5f2w3g9XPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="136620924"
X-IronPort-AV: E=Sophos;i="5.76,377,1592895600"; 
   d="scan'208";a="136620924"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 20:40:15 -0700
IronPort-SDR: 4Co08nlHc/zVxmusrGa+DSn9WKA5VBcnQpNmnKAzdiSxYQUayrhB3xOj4IFDgG1jn6P0DQH9Fe
 6+R4aYolmWGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,377,1592895600"; 
   d="scan'208";a="325180875"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga004.fm.intel.com with ESMTP; 31 Aug 2020 20:40:12 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v4 2/5] iommu: Add iommu_at(de)tach_subdev_group()
Date:   Tue,  1 Sep 2020 11:34:19 +0800
Message-Id: <20200901033422.22249-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901033422.22249-1-baolu.lu@linux.intel.com>
References: <20200901033422.22249-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds two new APIs for the use cases like vfio/mdev where subdevices
derived from physical devices are created and put in an iommu_group. The
new IOMMU API interfaces mimic the vfio_mdev_at(de)tach_domain() directly,
testing whether the resulting device supports IOMMU_DEV_FEAT_AUX and using
an aux vs non-aux at(de)tach.

By doing this we could

- Set the iommu_group.domain. The iommu_group.domain is private to iommu
  core (therefore vfio code cannot set it), but we need it set in order
  for iommu_get_domain_for_dev() to work with a group attached to an aux
  domain.

- Prefer to use the _attach_group() interfaces while the _attach_device()
  interfaces are relegated to special cases.

Link: https://lore.kernel.org/linux-iommu/20200730134658.44c57a67@x1.home/
Link: https://lore.kernel.org/linux-iommu/20200730151703.5daf8ad4@x1.home/
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 136 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/iommu.h |  20 +++++++
 2 files changed, 156 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 38cdfeb887e1..fb21c2ff4861 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2757,6 +2757,142 @@ int iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_aux_get_pasid);
 
+static int __iommu_aux_attach_device(struct iommu_domain *domain,
+				     struct device *phys_dev,
+				     struct device *sub_dev)
+{
+	int ret;
+
+	if (unlikely(!domain->ops->aux_attach_dev))
+		return -ENODEV;
+
+	ret = domain->ops->aux_attach_dev(domain, phys_dev, sub_dev);
+	if (!ret)
+		trace_attach_device_to_domain(sub_dev);
+
+	return ret;
+}
+
+static void __iommu_aux_detach_device(struct iommu_domain *domain,
+				      struct device *phys_dev,
+				      struct device *sub_dev)
+{
+	if (unlikely(!domain->ops->aux_detach_dev))
+		return;
+
+	domain->ops->aux_detach_dev(domain, phys_dev, sub_dev);
+	trace_detach_device_from_domain(sub_dev);
+}
+
+static int __iommu_attach_subdev_group(struct iommu_domain *domain,
+				       struct iommu_group *group,
+				       iommu_device_lookup_t fn)
+{
+	struct group_device *device;
+	struct device *phys_dev;
+	int ret = -ENODEV;
+
+	list_for_each_entry(device, &group->devices, list) {
+		phys_dev = fn(device->dev);
+		if (!phys_dev) {
+			ret = -ENODEV;
+			break;
+		}
+
+		if (iommu_dev_feature_enabled(phys_dev, IOMMU_DEV_FEAT_AUX))
+			ret = __iommu_aux_attach_device(domain, phys_dev,
+							device->dev);
+		else
+			ret = __iommu_attach_device(domain, phys_dev);
+
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static void __iommu_detach_subdev_group(struct iommu_domain *domain,
+					struct iommu_group *group,
+					iommu_device_lookup_t fn)
+{
+	struct group_device *device;
+	struct device *phys_dev;
+
+	list_for_each_entry(device, &group->devices, list) {
+		phys_dev = fn(device->dev);
+		if (!phys_dev)
+			break;
+
+		if (iommu_dev_feature_enabled(phys_dev, IOMMU_DEV_FEAT_AUX))
+			__iommu_aux_detach_device(domain, phys_dev, device->dev);
+		else
+			__iommu_detach_device(domain, phys_dev);
+	}
+}
+
+/**
+ * iommu_attach_subdev_group - attach domain to an iommu_group which
+ *			       contains subdevices.
+ *
+ * @domain: domain
+ * @group:  iommu_group which contains subdevices
+ * @fn:     callback for each subdevice in the @iommu_group to retrieve the
+ *          physical device where the subdevice was created from.
+ *
+ * Returns 0 on success, or an error value.
+ */
+int iommu_attach_subdev_group(struct iommu_domain *domain,
+			      struct iommu_group *group,
+			      iommu_device_lookup_t fn)
+{
+	int ret = -ENODEV;
+
+	mutex_lock(&group->mutex);
+	if (group->domain) {
+		ret = -EBUSY;
+		goto unlock_out;
+	}
+
+	ret = __iommu_attach_subdev_group(domain, group, fn);
+	if (ret)
+		__iommu_detach_subdev_group(domain, group, fn);
+	else
+		group->domain = domain;
+
+unlock_out:
+	mutex_unlock(&group->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_attach_subdev_group);
+
+/**
+ * iommu_detach_subdev_group - detach domain from an iommu_group which
+ *			       contains subdevices
+ *
+ * @domain: domain
+ * @group:  iommu_group which contains subdevices
+ * @fn:     callback for each subdevice in the @iommu_group to retrieve the
+ *          physical device where the subdevice was created from.
+ *
+ * The domain must have been attached to @group via iommu_attach_subdev_group().
+ */
+void iommu_detach_subdev_group(struct iommu_domain *domain,
+			       struct iommu_group *group,
+			       iommu_device_lookup_t fn)
+{
+	mutex_lock(&group->mutex);
+	if (!group->domain)
+		goto unlock_out;
+
+	__iommu_detach_subdev_group(domain, group, fn);
+	group->domain = NULL;
+
+unlock_out:
+	mutex_unlock(&group->mutex);
+}
+EXPORT_SYMBOL_GPL(iommu_detach_subdev_group);
+
 /**
  * iommu_sva_bind_device() - Bind a process address space to a device
  * @dev: the device
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 871267104915..b9df8b510d4f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -48,6 +48,7 @@ struct iommu_fault_event;
 typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
 			struct device *, unsigned long, int, void *);
 typedef int (*iommu_dev_fault_handler_t)(struct iommu_fault *, void *);
+typedef struct device *(*iommu_device_lookup_t)(struct device *);
 
 struct iommu_domain_geometry {
 	dma_addr_t aperture_start; /* First address that can be mapped    */
@@ -631,6 +632,12 @@ bool iommu_dev_feature_enabled(struct device *dev, enum iommu_dev_features f);
 int iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev);
 void iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev);
 int iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev);
+int iommu_attach_subdev_group(struct iommu_domain *domain,
+			      struct iommu_group *group,
+			      iommu_device_lookup_t fn);
+void iommu_detach_subdev_group(struct iommu_domain *domain,
+			       struct iommu_group *group,
+			       iommu_device_lookup_t fn);
 
 struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 					struct mm_struct *mm,
@@ -1019,6 +1026,19 @@ iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev)
 	return -ENODEV;
 }
 
+static inline int
+iommu_attach_subdev_group(struct iommu_domain *domain, struct iommu_group *group,
+			  iommu_device_lookup_t fn)
+{
+	return -ENODEV;
+}
+
+static inline void
+iommu_detach_subdev_group(struct iommu_domain *domain, struct iommu_group *group,
+			  iommu_device_lookup_t fn)
+{
+}
+
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void *drvdata)
 {
-- 
2.17.1


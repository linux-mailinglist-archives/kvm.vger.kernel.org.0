Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF1525864D
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 05:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgIADkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 23:40:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:62487 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbgIADkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 23:40:20 -0400
IronPort-SDR: vL6N2OcbuYhC7tUuqY9DG4fvHqeRjCs4YOGVnGZr3lleM/fAw1scES0Cq9c77jWBHjQb6A3v+R
 qPtB4P6fQcQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="136620927"
X-IronPort-AV: E=Sophos;i="5.76,377,1592895600"; 
   d="scan'208";a="136620927"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 20:40:19 -0700
IronPort-SDR: Uny4FzJVSCQSqgN74qadmFaEVq0jXOHDJs5Rw8/0OyW8mPY7F0J5iFfI4/WGMAUCuxwk0CA2ju
 mt5Y1hThFPPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,377,1592895600"; 
   d="scan'208";a="325180890"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga004.fm.intel.com with ESMTP; 31 Aug 2020 20:40:15 -0700
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
Subject: [PATCH v4 3/5] iommu: Add iommu_aux_get_domain_for_dev()
Date:   Tue,  1 Sep 2020 11:34:20 +0800
Message-Id: <20200901033422.22249-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901033422.22249-1-baolu.lu@linux.intel.com>
References: <20200901033422.22249-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The device driver needs an API to get its aux-domain. A typical usage
scenario is:

        unsigned long pasid;
        struct iommu_domain *domain;
        struct device *dev = mdev_dev(mdev);
        struct device *iommu_device = vfio_mdev_get_iommu_device(dev);

        domain = iommu_aux_get_domain_for_dev(dev);
        if (!domain)
                return -ENODEV;

        pasid = iommu_aux_get_pasid(domain, iommu_device);
        if (pasid <= 0)
                return -EINVAL;

         /* Program the device context */
         ....

This adds an API for such use case.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Link: https://lore.kernel.org/linux-iommu/20200708130749.1b1e1421@x1.home/
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 18 ++++++++++++++++++
 include/linux/iommu.h | 20 ++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fb21c2ff4861..8fd93a5b8764 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2893,6 +2893,24 @@ void iommu_detach_subdev_group(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_detach_subdev_group);
 
+struct iommu_domain *iommu_aux_get_domain_for_dev(struct device *subdev)
+{
+	struct iommu_domain *domain = NULL;
+	struct iommu_group *group;
+
+	group = iommu_group_get(subdev);
+	if (!group || !group->domain)
+		return NULL;
+
+	if (domain_is_aux(group->domain, subdev))
+		domain = group->domain;
+
+	iommu_group_put(group);
+
+	return domain;
+}
+EXPORT_SYMBOL_GPL(iommu_aux_get_domain_for_dev);
+
 /**
  * iommu_sva_bind_device() - Bind a process address space to a device
  * @dev: the device
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index b9df8b510d4f..ea660a887dbf 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -120,6 +120,7 @@ enum iommu_attr {
 	DOMAIN_ATTR_NESTING,	/* two stages of translation */
 	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
 	DOMAIN_ATTR_MAX,
+	DOMAIN_ATTR_IS_AUX,
 };
 
 /* These are the possible reserved region types */
@@ -622,6 +623,12 @@ static inline void dev_iommu_priv_set(struct device *dev, void *priv)
 	dev->iommu->priv = priv;
 }
 
+static inline bool
+domain_is_aux(struct iommu_domain *domain, struct device *subdev)
+{
+	return iommu_domain_get_attr(domain, DOMAIN_ATTR_IS_AUX, subdev);
+}
+
 int iommu_probe_device(struct device *dev);
 void iommu_release_device(struct device *dev);
 
@@ -638,6 +645,7 @@ int iommu_attach_subdev_group(struct iommu_domain *domain,
 void iommu_detach_subdev_group(struct iommu_domain *domain,
 			       struct iommu_group *group,
 			       iommu_device_lookup_t fn);
+struct iommu_domain *iommu_aux_get_domain_for_dev(struct device *subdev);
 
 struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 					struct mm_struct *mm,
@@ -1039,6 +1047,18 @@ iommu_detach_subdev_group(struct iommu_domain *domain, struct iommu_group *group
 {
 }
 
+static inline bool
+domain_is_aux(struct iommu_domain *domain, struct device *subdev)
+{
+	return false;
+}
+
+static inline struct iommu_domain *
+iommu_aux_get_domain_for_dev(struct device *subdev)
+{
+	return NULL;
+}
+
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void *drvdata)
 {
-- 
2.17.1


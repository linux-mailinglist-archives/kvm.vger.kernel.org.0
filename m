Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A9F21E7D1
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 08:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgGNGCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 02:02:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:3745 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgGNGB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 02:01:59 -0400
IronPort-SDR: 9l8++kve+6QLYogvl0JoKe7YgS/6+iumvfZIyNsOKcuyNt/a4nr1ztYd8NH9XKWF82sU4XC+UI
 ek89B4FycrkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="148812785"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="148812785"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 23:01:58 -0700
IronPort-SDR: rTEgJcSxIi++CMfnT+nngPUTP0N3kw4b1QGT3C0ZWXgc/CTL1WEwNKTMFvxK2405AHpjNDZaEM
 B0fV5qZj/pcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="324450203"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jul 2020 23:01:55 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v3 3/4] iommu: Add iommu_aux_get_domain_for_dev()
Date:   Tue, 14 Jul 2020 13:57:02 +0800
Message-Id: <20200714055703.5510-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714055703.5510-1-baolu.lu@linux.intel.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
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
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 18 ++++++++++++++++++
 include/linux/iommu.h |  7 +++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index cad5a19ebf22..434bf42b6b9b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2817,6 +2817,24 @@ void iommu_aux_detach_group(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_aux_detach_group);
 
+struct iommu_domain *iommu_aux_get_domain_for_dev(struct device *dev)
+{
+	struct iommu_domain *domain = NULL;
+	struct iommu_group *group;
+
+	group = iommu_group_get(dev);
+	if (!group)
+		return NULL;
+
+	if (group->aux_domain_attached)
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
index 9506551139ab..cda6cef7579e 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -639,6 +639,7 @@ int iommu_aux_attach_group(struct iommu_domain *domain,
 			   struct iommu_group *group, struct device *dev);
 void iommu_aux_detach_group(struct iommu_domain *domain,
 			   struct iommu_group *group, struct device *dev);
+struct iommu_domain *iommu_aux_get_domain_for_dev(struct device *dev);
 
 struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 					struct mm_struct *mm,
@@ -1040,6 +1041,12 @@ iommu_aux_detach_group(struct iommu_domain *domain,
 {
 }
 
+static inline struct iommu_domain *
+iommu_aux_get_domain_for_dev(struct device *dev)
+{
+	return NULL;
+}
+
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void *drvdata)
 {
-- 
2.17.1


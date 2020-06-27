Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5446520BDE3
	for <lists+kvm@lfdr.de>; Sat, 27 Jun 2020 05:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgF0DTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 23:19:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:37086 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgF0DTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 23:19:48 -0400
IronPort-SDR: MnVQEjqkoRRnYkuYIadoevUmLARBv/B0tr8n1nL0Ue8DWZiPZJ0eC7O8da03FEcr0a0VMQbKFH
 XQM/Yzxg15qA==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="163598208"
X-IronPort-AV: E=Sophos;i="5.75,286,1589266800"; 
   d="scan'208";a="163598208"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 20:19:47 -0700
IronPort-SDR: qY7Jeb0gjAhCYKqtByIdcIK5OQ+iplSWB3X3cDvSESt7Dti7Yy0tRrjx9TsUe4kK0esTBPdZ6f
 m+bf/00U1rBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,286,1589266800"; 
   d="scan'208";a="302510424"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jun 2020 20:19:45 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 1/2] iommu: Add iommu_group_get/set_domain()
Date:   Sat, 27 Jun 2020 11:15:31 +0800
Message-Id: <20200627031532.28046-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hardware assistant vfio mediated device is a use case of iommu
aux-domain. The interactions between vfio/mdev and iommu during mdev
creation and passthr are:

- Create a group for mdev with iommu_group_alloc();
- Add the device to the group with
        group = iommu_group_alloc();
        if (IS_ERR(group))
                return PTR_ERR(group);

        ret = iommu_group_add_device(group, &mdev->dev);
        if (!ret)
                dev_info(&mdev->dev, "MDEV: group_id = %d\n",
                         iommu_group_id(group));
- Allocate an aux-domain
	iommu_domain_alloc()
- Attach the aux-domain to the physical device from which the mdev is
  created.
	iommu_aux_attach_device()

In the whole process, an iommu group was allocated for the mdev and an
iommu domain was attached to the group, but the group->domain leaves
NULL. As the result, iommu_get_domain_for_dev() doesn't work anymore.

This adds iommu_group_get/set_domain() so that group->domain could be
managed whenever a domain is attached or detached through the aux-domain
api's.

Fixes: 7bd50f0cd2fd5 ("vfio/type1: Add domain at(de)taching group helpers")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 28 ++++++++++++++++++++++++++++
 include/linux/iommu.h | 14 ++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d43120eb1dc5..e2b665303d70 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -715,6 +715,34 @@ int iommu_group_set_name(struct iommu_group *group, const char *name)
 }
 EXPORT_SYMBOL_GPL(iommu_group_set_name);
 
+/**
+ * iommu_group_get_domain - get domain of a group
+ * @group: the group
+ *
+ * This is called to get the domain of a group.
+ */
+struct iommu_domain *iommu_group_get_domain(struct iommu_group *group)
+{
+	return group->domain;
+}
+EXPORT_SYMBOL_GPL(iommu_group_get_domain);
+
+/**
+ * iommu_group_set_domain - set domain for a group
+ * @group: the group
+ * @domain: iommu domain
+ *
+ * This is called to set the domain for a group. In aux-domain case, a domain
+ * might attach or detach to an iommu group through the aux-domain apis, but
+ * the group->domain doesn't get a chance to be updated there.
+ */
+void iommu_group_set_domain(struct iommu_group *group,
+			    struct iommu_domain *domain)
+{
+	group->domain = domain;
+}
+EXPORT_SYMBOL_GPL(iommu_group_set_domain);
+
 static int iommu_create_device_direct_mappings(struct iommu_group *group,
 					       struct device *dev)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 5f0b7859d2eb..ff88d548a870 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -496,6 +496,9 @@ extern void iommu_group_set_iommudata(struct iommu_group *group,
 				      void *iommu_data,
 				      void (*release)(void *iommu_data));
 extern int iommu_group_set_name(struct iommu_group *group, const char *name);
+extern struct iommu_domain *iommu_group_get_domain(struct iommu_group *group);
+extern void iommu_group_set_domain(struct iommu_group *group,
+				   struct iommu_domain *domain);
 extern int iommu_group_add_device(struct iommu_group *group,
 				  struct device *dev);
 extern void iommu_group_remove_device(struct device *dev);
@@ -840,6 +843,17 @@ static inline int iommu_group_set_name(struct iommu_group *group,
 	return -ENODEV;
 }
 
+static inline
+struct iommu_domain *iommu_group_get_domain(struct iommu_group *group)
+{
+	return NULL;
+}
+
+static inline void iommu_group_set_domain(struct iommu_group *group,
+					  struct iommu_domain *domain)
+{
+}
+
 static inline int iommu_group_add_device(struct iommu_group *group,
 					 struct device *dev)
 {
-- 
2.17.1


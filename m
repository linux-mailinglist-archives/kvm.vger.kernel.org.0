Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544CD63629D
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 16:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbiKWPBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 10:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236424AbiKWPBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 10:01:42 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6209927DD5
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 07:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669215701; x=1700751701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HLSmZ52KFOm/uxYU2tK2+8QrtyaMvwoRAe/xLc44es4=;
  b=BlerCjyIQAY1x0zVOYp6iCADg0QiIZWOF0E/zBBcSsdRrvzmuBb6ChzE
   UpBUB5pYo6Z3BUzauY3kabEeVVQP9Bhwy/BQINn3DGVIY8wyIZNIbVYiR
   RRY8j5n2cRBvAU0KA0lZzTzOdj1FaU+NLmBYt9C7pPTAybsCZlRXhfFvZ
   Oijf7BkDJdZE2oi2oKEF/72MKItVfN6kfNxgyNGLQkL8/4uXDOOiOq0yq
   xGXCJDYipN6X9rE50PM3tzuRSNVLoM9fhnDJ7fSHIBsZ3kbLCJigs2EtH
   raMHhWbE98IBLLtLYTh/xYYwSjXEkovGnEkH8hiU8MhfH3H0EbsIntRjq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301642929"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301642929"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:01:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674750880"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674750880"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 07:01:17 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC 02/10] vfio: Move the sanity check of the group to vfio_create_group()
Date:   Wed, 23 Nov 2022 07:01:05 -0800
Message-Id: <20221123150113.670399-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123150113.670399-1-yi.l.liu@intel.com>
References: <20221123150113.670399-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

This avoids opening group specific code in __vfio_register_dev() for the
sanity check if an (existing) group is not corrupted by having two copies
of the same struct device in it. It also simplifies the error unwind for
this sanity check since the failure can be detected in the group allocation.

This also prepares for moving the group specific code into separate group.c.

Grabbed from:
https://lore.kernel.org/kvm/20220922152338.2a2238fe.alex.williamson@redhat.com/

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 62 ++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 37 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 02f344441ddf..bd45b8907311 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -146,7 +146,7 @@ EXPORT_SYMBOL_GPL(vfio_device_set_open_count);
  * Group objects - create, release, get, put, search
  */
 static struct vfio_group *
-vfio_group_get_from_iommu(struct iommu_group *iommu_group)
+vfio_group_find_from_iommu(struct iommu_group *iommu_group)
 {
 	struct vfio_group *group;
 
@@ -157,10 +157,8 @@ vfio_group_get_from_iommu(struct iommu_group *iommu_group)
 	 * under the vfio.group_lock.
 	 */
 	list_for_each_entry(group, &vfio.group_list, vfio_next) {
-		if (group->iommu_group == iommu_group) {
-			refcount_inc(&group->drivers);
+		if (group->iommu_group == iommu_group)
 			return group;
-		}
 	}
 	return NULL;
 }
@@ -310,23 +308,6 @@ static bool vfio_device_try_get_registration(struct vfio_device *device)
 	return refcount_inc_not_zero(&device->refcount);
 }
 
-static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
-						 struct device *dev)
-{
-	struct vfio_device *device;
-
-	mutex_lock(&group->device_lock);
-	list_for_each_entry(device, &group->device_list, group_next) {
-		if (device->dev == dev &&
-		    vfio_device_try_get_registration(device)) {
-			mutex_unlock(&group->device_lock);
-			return device;
-		}
-	}
-	mutex_unlock(&group->device_lock);
-	return NULL;
-}
-
 /*
  * VFIO driver API
  */
@@ -470,6 +451,21 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
 	return ERR_PTR(ret);
 }
 
+static bool vfio_group_has_device(struct vfio_group *group, struct device *dev)
+{
+	struct vfio_device *device;
+
+	mutex_lock(&group->device_lock);
+	list_for_each_entry(device, &group->device_list, group_next) {
+		if (device->dev == dev) {
+			mutex_unlock(&group->device_lock);
+			return true;
+		}
+	}
+	mutex_unlock(&group->device_lock);
+	return false;
+}
+
 static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 {
 	struct iommu_group *iommu_group;
@@ -505,9 +501,15 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	}
 
 	mutex_lock(&vfio.group_lock);
-	group = vfio_group_get_from_iommu(iommu_group);
-	if (!group)
+	group = vfio_group_find_from_iommu(iommu_group);
+	if (group) {
+		if (WARN_ON(vfio_group_has_device(group, dev)))
+			group = ERR_PTR(-EINVAL);
+		else
+			refcount_inc(&group->drivers);
+	} else {
 		group = vfio_create_group(iommu_group, VFIO_IOMMU);
+	}
 	mutex_unlock(&vfio.group_lock);
 
 	/* The vfio_group holds a reference to the iommu_group */
@@ -518,7 +520,6 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 static int __vfio_register_dev(struct vfio_device *device,
 		struct vfio_group *group)
 {
-	struct vfio_device *existing_device;
 	int ret;
 
 	/*
@@ -540,19 +541,6 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
 
-	existing_device = vfio_group_get_device(group, device->dev);
-	if (existing_device) {
-		/*
-		 * group->iommu_group is non-NULL because we hold the drivers
-		 * refcount.
-		 */
-		dev_WARN(device->dev, "Device already exists on group %d\n",
-			 iommu_group_id(group->iommu_group));
-		vfio_device_put_registration(existing_device);
-		ret = -EBUSY;
-		goto err_out;
-	}
-
 	/* Our reference on group is moved to the device */
 	device->group = group;
 
-- 
2.34.1


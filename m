Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4FD63F333
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiLAOzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiLAOzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:55:41 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E0EBD882
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 06:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669906540; x=1701442540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W6kwcqoDJrsE/+z7BVQzEKof0kbL3QZJtQKWBKKal/I=;
  b=L+NOqGsIZ+U1SwPu+Rg1l5psLsB6BF51LYfB3j1BBeUSrEG1C+MX7s4g
   /VbDmE+t69zd9AekM2v8RBUyM+QLh/h+qLG8tNn5mYj7jueG4a494nISm
   Tve1JKk0RgDvr8XJ9aZIuf302uEGMDWM0bfje65l0wn+mZZ5mlMOsUKfy
   b4nLAEQ/aKzJ4lKhwxgiOa7PizyLwqP8Z7r6tpXXjUQnobw+nbXG25cSI
   Gq4eT2d9n5aGUxtcLKJNYwin8LY3CJndiZs+Ui5zR5zx/B+3XKGZC+v9F
   OwWQ/oewSdtkas7czjWszYV1Z24anDNuzYmyBxtCqrXCgaOHPGztdZabq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317569287"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="317569287"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 06:55:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708095153"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="708095153"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 06:55:39 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com
Subject: [PATCH 02/10] vfio: Move the sanity check of the group to vfio_create_group()
Date:   Thu,  1 Dec 2022 06:55:27 -0800
Message-Id: <20221201145535.589687-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221201145535.589687-1-yi.l.liu@intel.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 62 ++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 37 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 0e66eb40992b..9f05dab0fab5 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -130,7 +130,7 @@ static void vfio_release_device_set(struct vfio_device *device)
  * Group objects - create, release, get, put, search
  */
 static struct vfio_group *
-vfio_group_get_from_iommu(struct iommu_group *iommu_group)
+vfio_group_find_from_iommu(struct iommu_group *iommu_group)
 {
 	struct vfio_group *group;
 
@@ -141,10 +141,8 @@ vfio_group_get_from_iommu(struct iommu_group *iommu_group)
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
@@ -294,23 +292,6 @@ static bool vfio_device_try_get_registration(struct vfio_device *device)
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
@@ -440,6 +421,21 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
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
@@ -475,9 +471,15 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
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
@@ -488,7 +490,6 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 static int __vfio_register_dev(struct vfio_device *device,
 		struct vfio_group *group)
 {
-	struct vfio_device *existing_device;
 	int ret;
 
 	/*
@@ -510,19 +511,6 @@ static int __vfio_register_dev(struct vfio_device *device,
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


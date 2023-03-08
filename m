Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4446B092C
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbjCHNc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjCHNca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:32:30 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0D748E1B;
        Wed,  8 Mar 2023 05:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282260; x=1709818260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XeiR8haIZIHcl7wUZyWGU+A/6RExf6z0n7ntzoVlizo=;
  b=SMC+B9felPG2hFm26m+lhVOkpN226p75VNk4qwGLPd0E/qB5a74CZ/E6
   EpqZ5Bw0PimIgI5PxhuK9luFQwxhnIuLVy3Rotx+zvfdFNvB4OgoilZgg
   XYQb1LX7E88RDjyz48so9n866Rg4AQV3btZdHHAz6iIYchDRhnD815568
   uUnN3vZ+8lzfCoFRo91HMDl+w/Y7nxvBoe0M7/Ozf/bH45lEjYLw9baoT
   e/Hds984GeFauuS1HiEZPGckgKES4cMN1r4X7LjvUnHphhAtcIaWlG1KU
   95Oaq4u2IhLc+3Qf7UTRLoeFP2Tuu/2ihf3i8QCGI1fMm/t2ACjRE1hPj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="336165275"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="336165275"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:29:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922789419"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="922789419"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2023 05:29:33 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH v6 16/24] vfio: Make vfio_device_first_open() to cover the noiommu mode in cdev path
Date:   Wed,  8 Mar 2023 05:28:55 -0800
Message-Id: <20230308132903.465159-17-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308132903.465159-1-yi.l.liu@intel.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_device_first_open() now covers the below two cases:

1) user uses iommufd (e.g. the group path in iommufd compat mode);
2) user uses container (e.g. the group path in legacy mode);

The above two paths have their own noiommu mode support accordingly.

The cdev path also uses iommufd, so for the case user provides a valid
iommufd, this helper is able to support it. But for noiommu mode, the
cdev path just provides a NULL iommufd. So this needs to be able to cover
it. As there is no special things to do for the cdev path in noiommu
mode, it can be covered by simply differentiate it from the container
case. If user is not using iommufd nor container, it is the noiommu
mode.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 15 +++++++++++++++
 drivers/vfio/vfio.h      |  1 +
 drivers/vfio/vfio_main.c | 21 +++++++++++++++++----
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index f067a6a7bbd2..51c027134814 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -780,6 +780,21 @@ void vfio_device_group_unregister(struct vfio_device *device)
 	mutex_unlock(&device->group->device_lock);
 }
 
+/*
+ * This shall be used without group lock as group and group->container
+ * should be fixed before group is set to df->group.
+ */
+bool vfio_device_group_uses_container(struct vfio_device_file *df)
+{
+	/*
+	 * Use the df->group instead of the df->device->group as no
+	 * lock is acquired here.
+	 */
+	if (WARN_ON(!df->group))
+		return false;
+	return READ_ONCE(df->group->container);
+}
+
 int vfio_device_group_use_iommu(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 11397cc95e0b..615ffd58562b 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -95,6 +95,7 @@ int vfio_device_set_group(struct vfio_device *device,
 void vfio_device_remove_group(struct vfio_device *device);
 void vfio_device_group_register(struct vfio_device *device);
 void vfio_device_group_unregister(struct vfio_device *device);
+bool vfio_device_group_uses_container(struct vfio_device_file *df);
 int vfio_device_group_use_iommu(struct vfio_device *device);
 void vfio_device_group_unuse_iommu(struct vfio_device *device);
 void vfio_device_group_close(struct vfio_device_file *df);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index aa31aae33407..8c73df1a400e 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -423,16 +423,29 @@ static int vfio_device_first_open(struct vfio_device_file *df)
 {
 	struct vfio_device *device = df->device;
 	struct iommufd_ctx *iommufd = df->iommufd;
-	int ret;
+	int ret = 0;
 
 	lockdep_assert_held(&device->dev_set->lock);
 
 	if (!try_module_get(device->dev->driver->owner))
 		return -ENODEV;
 
+	/*
+	 * The handling here depends on what the user is using.
+	 *
+	 * If user uses iommufd in the group compat mode or the
+	 * cdev path, call vfio_iommufd_bind().
+	 *
+	 * If user uses container in the group legacy mode, call
+	 * vfio_device_group_use_iommu().
+	 *
+	 * If user doesn't use iommufd nor container, this is
+	 * the noiommufd mode in the cdev path, nothing needs
+	 * to be done here just go ahead to open device.
+	 */
 	if (iommufd)
 		ret = vfio_iommufd_bind(device, iommufd);
-	else
+	else if (vfio_device_group_uses_container(df))
 		ret = vfio_device_group_use_iommu(device);
 	if (ret)
 		goto err_module_put;
@@ -447,7 +460,7 @@ static int vfio_device_first_open(struct vfio_device_file *df)
 err_unuse_iommu:
 	if (iommufd)
 		vfio_iommufd_unbind(device);
-	else
+	else if (vfio_device_group_uses_container(df))
 		vfio_device_group_unuse_iommu(device);
 err_module_put:
 	module_put(device->dev->driver->owner);
@@ -465,7 +478,7 @@ static void vfio_device_last_close(struct vfio_device_file *df)
 		device->ops->close_device(device);
 	if (iommufd)
 		vfio_iommufd_unbind(device);
-	else
+	else if (vfio_device_group_uses_container(df))
 		vfio_device_group_unuse_iommu(device);
 	module_put(device->dev->driver->owner);
 }
-- 
2.34.1


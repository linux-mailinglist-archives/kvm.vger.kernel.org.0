Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD20E6378D9
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiKXM1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiKXM1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:27:20 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2B5E1216
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669292837; x=1700828837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oxgyYQP0+Q0A0+c6ptQqj4nNOOglluK2b2+WB3Fm4ZQ=;
  b=lwq1tmNCGhBKWmp8dHUqWWJ1Q3sD4lhZCLW1anosPrqAPUrUH7793D1w
   a+mcz/52CJYEg61PMPUuum5Hac92ZOhzzYEFeUIn4kvkRj7w0fgCH47ao
   fAxdELxr0gX4vSnDPHeR4PFkC/Zpujd+Uo21wRV97LB7JHaM/5yR3BmqS
   L0V3gFgxXkyj3SeB8BvkAhVER9LcBroVyNwmnHcQCgGFMx7jIQrcZGhh+
   U9KgPEB9CmOfuvEsrpKqhctjeEJ1IW8jZeKM6DS+UhGlXRxa7FxLXGTmU
   BwGLxpkISSuMk+nE9duwYVmNHnBvur2b9ZbWJkFUr+QamxHg5niOCyxBw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297649643"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="297649643"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:27:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642337191"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642337191"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 04:27:16 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC v2 07/11] vfio: Swap order of vfio_device_container_register() and open_device()
Date:   Thu, 24 Nov 2022 04:26:58 -0800
Message-Id: <20221124122702.26507-8-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124122702.26507-1-yi.l.liu@intel.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes the DMA unmap callback registration to container be consistent
across the vfio iommufd compat mode and the legacy container mode.

In the vfio iommufd compat mode, this registration is done in the
vfio_iommufd_bind() when creating access which has an unmap callback. This
is prior to calling the open_device() op provided by mdev driver. While,
in the vfio legacy mode, the registration is done by
vfio_device_container_register() and it is after open_device(). By swapping
the order of vfio_device_container_register() and open_device(), the two
modes have the consistent order for the DMA unmap callback registration.

This also prepares for further splitting group specific code.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index c3d58cbc2aa9..af5908455cfc 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -799,6 +799,7 @@ static int vfio_device_first_open(struct vfio_device *device)
 		ret = vfio_group_use_container(device->group);
 		if (ret)
 			goto err_module_put;
+		vfio_device_container_register(device);
 	} else if (device->group->iommufd) {
 		ret = vfio_iommufd_bind(device, device->group->iommufd);
 		if (ret)
@@ -811,17 +812,17 @@ static int vfio_device_first_open(struct vfio_device *device)
 		if (ret)
 			goto err_container;
 	}
-	if (device->group->container)
-		vfio_device_container_register(device);
 	mutex_unlock(&device->group->group_lock);
 	return 0;
 
 err_container:
 	device->kvm = NULL;
-	if (device->group->container)
+	if (device->group->container) {
+		vfio_device_container_unregister(device);
 		vfio_group_unuse_container(device->group);
-	else if (device->group->iommufd)
+	} else if (device->group->iommufd) {
 		vfio_iommufd_unbind(device);
+	}
 err_module_put:
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
@@ -833,15 +834,15 @@ static void vfio_device_last_close(struct vfio_device *device)
 	lockdep_assert_held(&device->dev_set->lock);
 
 	mutex_lock(&device->group->group_lock);
-	if (device->group->container)
-		vfio_device_container_unregister(device);
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
-	if (device->group->container)
+	if (device->group->container) {
+		vfio_device_container_unregister(device);
 		vfio_group_unuse_container(device->group);
-	else if (device->group->iommufd)
+	} else if (device->group->iommufd) {
 		vfio_iommufd_unbind(device);
+	}
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 }
-- 
2.34.1


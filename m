Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36EE6378DD
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiKXM1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiKXM1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:27:21 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A10E3D1C
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669292839; x=1700828839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ogi0blWVeoyQEx0JQn165xozuvcciWF1GvRIZLXLG0g=;
  b=TTc8skwgNJiWeUQ7rsxYdAHJuRqxuIeWjw3uHxEHaI6BLLkKCB+M/fuF
   8IxRH6ryHveLQeRAoYFY3IuUZoHPuBXJE87NrIIaXVaQhq+sTQqwWAA45
   ZPnKwB5Xabc1tuG4IXR6HTVnLzdygKrkvOjXSeewSvtl9S0Kzl/KDBsUI
   2JsrIQmlxrLR94wy5P4RGlc2TDW+h9zZj39S/wBHyssclH0PngR6/+wqn
   OMxZniD1BrdDKH6MqNyAnbsEu8ZpG3rLXge1N55V5UTP7HdGvFWnSEp/C
   sDYS4GNfJwpMQ1FcpVzd9149DeJXSUO0H/nSFJ5E1pVW/oSH5jGbhLRD8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297649646"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="297649646"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:27:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642337197"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642337197"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 04:27:17 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC v2 08/11] vfio: Refactor vfio_device_first_open() and _last_close()
Date:   Thu, 24 Nov 2022 04:26:59 -0800
Message-Id: <20221124122702.26507-9-yi.l.liu@intel.com>
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

To prepare for moving group specific code out from vfio_main.c.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 93 ++++++++++++++++++++++++++++------------
 1 file changed, 65 insertions(+), 28 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index af5908455cfc..45f96515c05e 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -775,14 +775,9 @@ static bool vfio_assert_device_open(struct vfio_device *device)
 	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }
 
-static int vfio_device_first_open(struct vfio_device *device)
+static int vfio_device_group_use_iommu(struct vfio_device *device)
 {
-	int ret;
-
-	lockdep_assert_held(&device->dev_set->lock);
-
-	if (!try_module_get(device->dev->driver->owner))
-		return -ENODEV;
+	int ret = 0;
 
 	/*
 	 * Here we pass the KVM pointer with the group under the lock.  If the
@@ -792,39 +787,88 @@ static int vfio_device_first_open(struct vfio_device *device)
 	mutex_lock(&device->group->group_lock);
 	if (!vfio_group_has_iommu(device->group)) {
 		ret = -EINVAL;
-		goto err_module_put;
+		goto out_unlock;
 	}
 
 	if (device->group->container) {
 		ret = vfio_group_use_container(device->group);
 		if (ret)
-			goto err_module_put;
+			goto out_unlock;
 		vfio_device_container_register(device);
 	} else if (device->group->iommufd) {
 		ret = vfio_iommufd_bind(device, device->group->iommufd);
-		if (ret)
-			goto err_module_put;
 	}
 
-	device->kvm = device->group->kvm;
+out_unlock:
+	mutex_unlock(&device->group->group_lock);
+	return ret;
+}
+
+static void vfio_device_group_unuse_iommu(struct vfio_device *device)
+{
+	mutex_lock(&device->group->group_lock);
+	if (device->group->container) {
+		vfio_device_container_unregister(device);
+		vfio_group_unuse_container(device->group);
+	} else if (device->group->iommufd) {
+		vfio_iommufd_unbind(device);
+	}
+	mutex_unlock(&device->group->group_lock);
+}
+
+static struct kvm *vfio_device_get_group_kvm(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+
+	mutex_lock(&group->group_lock);
+	if (!group->kvm) {
+		mutex_unlock(&group->group_lock);
+		return NULL;
+	}
+	/* group_lock is released in the vfio_device_put_group_kvm() */
+	return group->kvm;
+}
+
+static void vfio_device_put_group_kvm(struct vfio_device *device)
+{
+	mutex_unlock(&device->group->group_lock);
+}
+
+static int vfio_device_first_open(struct vfio_device *device)
+{
+	struct kvm *kvm;
+	int ret;
+
+	lockdep_assert_held(&device->dev_set->lock);
+
+	if (!try_module_get(device->dev->driver->owner))
+		return -ENODEV;
+
+	ret = vfio_device_group_use_iommu(device);
+	if (ret)
+		goto err_module_put;
+
+	kvm = vfio_device_get_group_kvm(device);
+	if (!kvm) {
+		ret = -EINVAL;
+		goto err_unuse_iommu;
+	}
+
+	device->kvm = kvm;
 	if (device->ops->open_device) {
 		ret = device->ops->open_device(device);
 		if (ret)
 			goto err_container;
 	}
-	mutex_unlock(&device->group->group_lock);
+	vfio_device_put_group_kvm(device);
 	return 0;
 
 err_container:
 	device->kvm = NULL;
-	if (device->group->container) {
-		vfio_device_container_unregister(device);
-		vfio_group_unuse_container(device->group);
-	} else if (device->group->iommufd) {
-		vfio_iommufd_unbind(device);
-	}
+	vfio_device_put_group_kvm(device);
+err_unuse_iommu:
+	vfio_device_group_unuse_iommu(device);
 err_module_put:
-	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 	return ret;
 }
@@ -833,17 +877,10 @@ static void vfio_device_last_close(struct vfio_device *device)
 {
 	lockdep_assert_held(&device->dev_set->lock);
 
-	mutex_lock(&device->group->group_lock);
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
-	if (device->group->container) {
-		vfio_device_container_unregister(device);
-		vfio_group_unuse_container(device->group);
-	} else if (device->group->iommufd) {
-		vfio_iommufd_unbind(device);
-	}
-	mutex_unlock(&device->group->group_lock);
+	vfio_device_group_unuse_iommu(device);
 	module_put(device->dev->driver->owner);
 }
 
-- 
2.34.1


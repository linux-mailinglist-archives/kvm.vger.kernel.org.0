Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6116378D5
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiKXM1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiKXM1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:27:19 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950CBE06A4
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669292835; x=1700828835;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B1FZvM3bKi7qx4KpOGLjSoGbjfF1FCrbbv0WQ1aL6jM=;
  b=kGCl4COOl4LBeOiPRMWgljL/8vcNGyxQjnbD2U3MerHp/of5RF242X+a
   HTLXmcBZn1/0J2szuCePEymxpJJ/v9oIHw4GiqIbV3agu/jTiL/dNQoJ7
   bfk0OsbHuj8NNMiYptBzZ0MuNJsjaB7V/FvForJgzTnetAlSZ/sBuXDVw
   ZnsDDClJ9TARjoHSYJY5GbWF/dzuLDZ1m5ogVcEpktZdVCEffW1uXxf8V
   viM2AkfeeSwrOA0RS4+w3b8vx9V4hWCLUmBGGc8wp6vHPG2uF8FHMxX/y
   tSN4j302kKD/aaC6XGRm60QAy5pLQ4gH71uAS9IGbKKxISOWQOeHhBJko
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297649632"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="297649632"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:27:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642337165"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642337165"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 04:27:14 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC v2 03/11] vfio: Set device->group in helper function
Date:   Thu, 24 Nov 2022 04:26:54 -0800
Message-Id: <20221124122702.26507-4-yi.l.liu@intel.com>
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

This avoids referencing device->group in __vfio_register_dev()

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 52 +++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7a78256a650e..4980b8acf5d3 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -503,10 +503,15 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	return group;
 }
 
-static int __vfio_register_dev(struct vfio_device *device,
-		struct vfio_group *group)
+static int vfio_device_set_group(struct vfio_device *device,
+				 enum vfio_group_type type)
 {
-	int ret;
+	struct vfio_group *group;
+
+	if (type == VFIO_IOMMU)
+		group = vfio_group_find_or_alloc(device->dev);
+	else
+		group = vfio_noiommu_group_alloc(device->dev, type);
 
 	/*
 	 * In all cases group is the output of one of the group allocation
@@ -515,6 +520,16 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (IS_ERR(group))
 		return PTR_ERR(group);
 
+	/* Our reference on group is moved to the device */
+	device->group = group;
+	return 0;
+}
+
+static int __vfio_register_dev(struct vfio_device *device,
+			       enum vfio_group_type type)
+{
+	int ret;
+
 	if (WARN_ON(device->ops->bind_iommufd &&
 		    (!device->ops->unbind_iommufd ||
 		     !device->ops->attach_ioas)))
@@ -527,34 +542,33 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
 
-	/* Our reference on group is moved to the device */
-	device->group = group;
-
 	ret = dev_set_name(&device->device, "vfio%d", device->index);
 	if (ret)
-		goto err_out;
+		return ret;
 
-	ret = device_add(&device->device);
+	ret = vfio_device_set_group(device, type);
 	if (ret)
-		goto err_out;
+		return ret;
+
+	ret = device_add(&device->device);
+	if (ret) {
+		vfio_device_remove_group(device);
+		return ret;
+	}
 
 	/* Refcounting can't start until the driver calls register */
 	refcount_set(&device->refcount, 1);
 
-	mutex_lock(&group->device_lock);
-	list_add(&device->group_next, &group->device_list);
-	mutex_unlock(&group->device_lock);
+	mutex_lock(&device->group->device_lock);
+	list_add(&device->group_next, &device->group->device_list);
+	mutex_unlock(&device->group->device_lock);
 
 	return 0;
-err_out:
-	vfio_device_remove_group(device);
-	return ret;
 }
 
 int vfio_register_group_dev(struct vfio_device *device)
 {
-	return __vfio_register_dev(device,
-		vfio_group_find_or_alloc(device->dev));
+	return __vfio_register_dev(device, VFIO_IOMMU);
 }
 EXPORT_SYMBOL_GPL(vfio_register_group_dev);
 
@@ -564,8 +578,7 @@ EXPORT_SYMBOL_GPL(vfio_register_group_dev);
  */
 int vfio_register_emulated_iommu_dev(struct vfio_device *device)
 {
-	return __vfio_register_dev(device,
-		vfio_noiommu_group_alloc(device->dev, VFIO_EMULATED_IOMMU));
+	return __vfio_register_dev(device, VFIO_EMULATED_IOMMU);
 }
 EXPORT_SYMBOL_GPL(vfio_register_emulated_iommu_dev);
 
@@ -638,6 +651,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	/* Balances device_add in register path */
 	device_del(&device->device);
 
+	/* Balances vfio_device_set_group in register path */
 	vfio_device_remove_group(device);
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
-- 
2.34.1


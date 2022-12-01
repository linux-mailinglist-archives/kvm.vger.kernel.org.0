Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E31363F335
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiLAOzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiLAOzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:55:42 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403CABB7EF
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 06:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669906542; x=1701442542;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YK1f7TX6jPBOaz7dP+hzjNaSEoA6+RID/uuqF/NX/2M=;
  b=YFBUbWyup2vm6LaU6luDWgLRQMqYfgdhL8pEEkgSfoiSDDbGL1EPLl3f
   0nBIWWkbFtxZ7160wdj32QNXs7wWQu7RsdEycATS3+Ucg9vY8OObH5a3C
   VvE9Hz4W8gzvyTAK7Mr/VP60N9/DLmb1BQ+hcRq0B4j4tyQ1ErO5V3Tb1
   4PNDMoEFEBhbqMUn9/tbNtv5XALPteKEvoOb0wXITkHUw2T1XvD/W76Lp
   vaHTX7CJFlQDLTUxCucTRo2Y0PtAU6eolHEfwAyjj3gTBOze870x8+zzT
   W3yWNK3s1UPoo+YP2Jh+xsQKgDgU2WYuFt7NBqVuSfwI6Q5P8YT0dwzBz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317569298"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="317569298"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 06:55:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708095167"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="708095167"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 06:55:41 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com
Subject: [PATCH 04/10] vfio: Set device->group in helper function
Date:   Thu,  1 Dec 2022 06:55:29 -0800
Message-Id: <20221201145535.589687-5-yi.l.liu@intel.com>
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

This avoids referencing device->group in __vfio_register_dev().

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 41 +++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7017d3da6e6f..d1e8e5d2a1bc 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -501,18 +501,29 @@ static void vfio_device_group_unregister(struct vfio_device *device)
 	mutex_unlock(&device->group->device_lock);
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
 
-	/*
-	 * In all cases group is the output of one of the group allocation
-	 * functions and we have group->drivers incremented for us.
-	 */
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
@@ -525,12 +536,13 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
 
-	/* Our reference on group is moved to the device */
-	device->group = group;
-
 	ret = dev_set_name(&device->device, "vfio%d", device->index);
 	if (ret)
-		goto err_out;
+		return ret;
+
+	ret = vfio_device_set_group(device, type);
+	if (ret)
+		return ret;
 
 	ret = device_add(&device->device);
 	if (ret)
@@ -549,8 +561,7 @@ static int __vfio_register_dev(struct vfio_device *device,
 
 int vfio_register_group_dev(struct vfio_device *device)
 {
-	return __vfio_register_dev(device,
-		vfio_group_find_or_alloc(device->dev));
+	return __vfio_register_dev(device, VFIO_IOMMU);
 }
 EXPORT_SYMBOL_GPL(vfio_register_group_dev);
 
@@ -560,8 +571,7 @@ EXPORT_SYMBOL_GPL(vfio_register_group_dev);
  */
 int vfio_register_emulated_iommu_dev(struct vfio_device *device)
 {
-	return __vfio_register_dev(device,
-		vfio_noiommu_group_alloc(device->dev, VFIO_EMULATED_IOMMU));
+	return __vfio_register_dev(device, VFIO_EMULATED_IOMMU);
 }
 EXPORT_SYMBOL_GPL(vfio_register_emulated_iommu_dev);
 
@@ -631,6 +641,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	/* Balances device_add in register path */
 	device_del(&device->device);
 
+	/* Balances vfio_device_set_group in register path */
 	vfio_device_remove_group(device);
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
-- 
2.34.1


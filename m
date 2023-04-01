Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13CF6D3230
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 17:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjDAPTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 11:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjDAPSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 11:18:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244562544E;
        Sat,  1 Apr 2023 08:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680362324; x=1711898324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UokUYeM4rR64gCGp21F4Z3uW+9LSpKJiXFcdGNm8PF0=;
  b=XH1U+Or0M10A2MHxcheowBs+2RxgERYiXT7YPWToIBIHWOwvTAf/tBkW
   gNkTszD9T6Hz94/tKnstaLiaNmSzeyDtCGWdqmfBbuhxZI+w9b3Og4FC2
   7hSPBumXwtdCbFzYCHCTJqo5ZUiShtUug0GRw/xLFJR/gP5crpGDmost4
   TpoWW9pEZCQ4B1mcOv16QeTGXMie8TheS53rvXllzmXu1ADc59JJJawzh
   nww00sxkMkZL+SNAaIQE0mW1LDWqAQrtdMYNwvy0Xg19Xsvc9y3jcALz7
   2SWWaXBeH6nw2urQGTugGRKMCx0pQqpppjMwM7vUtfC7f4T0yKSi1mGUD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="404411276"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="404411276"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 08:18:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="678937193"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="678937193"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 01 Apr 2023 08:18:41 -0700
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: [PATCH v9 11/25] vfio: Make vfio_device_first_open() to accept NULL iommufd for noiommu
Date:   Sat,  1 Apr 2023 08:18:19 -0700
Message-Id: <20230401151833.124749-12-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401151833.124749-1-yi.l.liu@intel.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_device_first_open() requires the caller to provide either a valid
iommufd (the group path in iommufd compat mode) or a valid container
(the group path in legacy container mode). As preparation for noiommu
support in device cdev path it's extended to allow both being NULL. The
caller is expected to verify noiommu permission before passing NULL
to this function.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     |  6 ++++++
 drivers/vfio/vfio.h      |  1 +
 drivers/vfio/vfio_main.c | 12 ++++++++----
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 1af4b9e012a7..63a4bf06ab9f 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -771,6 +771,12 @@ void vfio_device_group_unregister(struct vfio_device *device)
 	mutex_unlock(&device->group->device_lock);
 }
 
+/* No group lock since df->group and df->group->container cannot change */
+bool vfio_device_group_uses_container(struct vfio_device_file *df)
+{
+	return df->group && READ_ONCE(df->group->container);
+}
+
 int vfio_device_group_use_iommu(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index f1a448f9d067..7d4108cbc185 100644
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
index c8721d5d05fa..f4c9c27c7d74 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -423,16 +423,20 @@ static int vfio_device_first_open(struct vfio_device_file *df)
 {
 	struct vfio_device *device = df->device;
 	struct iommufd_ctx *iommufd = df->iommufd;
-	int ret;
+	int ret = 0;
 
 	lockdep_assert_held(&device->dev_set->lock);
 
 	if (!try_module_get(device->dev->driver->owner))
 		return -ENODEV;
 
+	/*
+	 * if neither iommufd nor container is used the device is in
+	 * noiommu mode then just go ahead to open it.
+	 */
 	if (iommufd)
 		ret = vfio_iommufd_bind(device, iommufd);
-	else
+	else if (vfio_device_group_uses_container(df))
 		ret = vfio_device_group_use_iommu(device);
 	if (ret)
 		goto err_module_put;
@@ -447,7 +451,7 @@ static int vfio_device_first_open(struct vfio_device_file *df)
 err_unuse_iommu:
 	if (iommufd)
 		vfio_iommufd_unbind(device);
-	else
+	else if (vfio_device_group_uses_container(df))
 		vfio_device_group_unuse_iommu(device);
 err_module_put:
 	module_put(device->dev->driver->owner);
@@ -465,7 +469,7 @@ static void vfio_device_last_close(struct vfio_device_file *df)
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F9C6D3179
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 16:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjDAOok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 10:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjDAOog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 10:44:36 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFF61E700;
        Sat,  1 Apr 2023 07:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680360275; x=1711896275;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z99ZnPiTmiMZImt4QS5DbgD7eZm064znhj0YZmEXafY=;
  b=NgiJmcJnDT4HeWv6o4l4XPJ/9Ml0oME94Ov9peuThCD3+7ur0GJ8T4kw
   gk62yd76sKgdgzFVsszYEOJgPDucXb7hlqvDcaCo/enO8nXQzKx6yPOFy
   sscnDiA7ke2xHI9OKsUF8SeKKHnhda7kyA/vq15AMGFvcQqKan+nXGkJr
   6W7rwFEqjzTPbHWcqw4DmYj8UDf2OSV3jSzlFtmi081MQVgp6jma/frV6
   N2DVGy6L4TTWUXBvssc8jpJU2tSNqEB1bJwFnxfiyS+l9N55iz/preSBs
   /NuJ64nlX5U7zW/4QfsqZlkMhBq3S/RO7245kv7IaQU9Z4qH3PSy2sQOU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="340385100"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="340385100"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 07:44:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="662705827"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="662705827"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 01 Apr 2023 07:44:33 -0700
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
Subject: [PATCH v3 04/12] vfio-iommufd: Add helper to retrieve iommufd_ctx and devid for vfio_device
Date:   Sat,  1 Apr 2023 07:44:21 -0700
Message-Id: <20230401144429.88673-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401144429.88673-1-yi.l.liu@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
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

This is needed by the vfio-pci driver to report affected devices in the
hot reset for a given device.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c | 12 ++++++++++++
 drivers/vfio/iommufd.c         | 14 ++++++++++++++
 include/linux/iommufd.h        |  3 +++
 include/linux/vfio.h           | 13 +++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 25115d401d8f..04a57aa1ae2c 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -131,6 +131,18 @@ void iommufd_device_unbind(struct iommufd_device *idev)
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
 
+struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev)
+{
+	return idev->ictx;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_to_ictx, IOMMUFD);
+
+u32 iommufd_device_to_id(struct iommufd_device *idev)
+{
+	return idev->obj.id;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
+
 static int iommufd_device_setup_msi(struct iommufd_device *idev,
 				    struct iommufd_hw_pagetable *hwpt,
 				    phys_addr_t sw_msi_start)
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 88b00c501015..809f2dd73b9e 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -66,6 +66,20 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 		vdev->ops->unbind_iommufd(vdev);
 }
 
+struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev)
+{
+	if (!vdev->iommufd_device)
+		return NULL;
+	return iommufd_device_to_ictx(vdev->iommufd_device);
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_ictx);
+
+void vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id)
+{
+	if (vdev->iommufd_device)
+		*id = iommufd_device_to_id(vdev->iommufd_device);
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_devid);
 /*
  * The physical standard ops mean that the iommufd_device is bound to the
  * physical device vdev->dev that was provided to vfio_init_group_dev(). Drivers
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 1129a36a74c4..ac96df406833 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -24,6 +24,9 @@ void iommufd_device_unbind(struct iommufd_device *idev);
 int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
 void iommufd_device_detach(struct iommufd_device *idev);
 
+struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
+u32 iommufd_device_to_id(struct iommufd_device *idev);
+
 struct iommufd_access_ops {
 	u8 needs_pin_pages : 1;
 	void (*unmap)(void *data, unsigned long iova, unsigned long length);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 3188d8a374bd..97a1174b922f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -113,6 +113,8 @@ struct vfio_device_ops {
 };
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
+struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev);
+void vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id);
 int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
@@ -122,6 +124,17 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
 int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 #else
+static inline struct iommufd_ctx *
+vfio_iommufd_physical_ictx(struct vfio_device *vdev)
+{
+	return NULL;
+}
+
+static inline void
+vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id)
+{
+}
+
 #define vfio_iommufd_physical_bind                                      \
 	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
 		  u32 *out_device_id)) NULL)
-- 
2.34.1


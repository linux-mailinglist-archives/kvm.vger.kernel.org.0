Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB327016F7
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 15:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbjEMNVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 May 2023 09:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbjEMNVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 May 2023 09:21:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B42A3C1E;
        Sat, 13 May 2023 06:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683984107; x=1715520107;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g4siJIBkFf/5Ervds9HnSwWatbMCuAZl2/EsF9oUoBE=;
  b=S1bFJOBGKG09KtOo/SyzxLShaLx0TNWcLzoW2ewTpKbD8AnLPp9oSEHH
   Mr3M2D0QKNDLG7xI9oVUeDRk4w7GbmK/68oZhlSZPgimXWxZVj2t/LsYv
   zcUX8n1nL20ZcUxwsxoMNQID+eZzev6GhMF6g1X5cB+CWLAWeZJBvwBs9
   2OFUn5Soyrgv7eJv3Nzhltm2GV8h0wCiSlBSwwz1qul0QCLfTEq3V1X23
   O2N7/mFVAse9aM5s0Kl6ElmKABNpxj5OrxCjFvGCOF6dDJw5me++iJbvk
   hEYfhR05o7OwLRBuw7Sjuczcj9WzuapliwWgg22/N76gZWHmU+ifdy1we
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="416599007"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="416599007"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 06:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="790126460"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="790126460"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by FMSMGA003.fm.intel.com with ESMTP; 13 May 2023 06:21:46 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v5 06/10] vfio-iommufd: Add helper to retrieve iommufd_ctx and devid for vfio_device
Date:   Sat, 13 May 2023 06:21:32 -0700
Message-Id: <20230513132136.15021-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230513132136.15021-1-yi.l.liu@intel.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is needed by the vfio-pci driver to report affected devices in the
hot reset for a given device.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c | 24 ++++++++++++++++++++++++
 drivers/vfio/iommufd.c         | 20 ++++++++++++++++++++
 include/linux/iommufd.h        |  6 ++++++
 include/linux/vfio.h           | 14 ++++++++++++++
 4 files changed, 64 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 4f9b2142274c..81466b97023f 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -116,6 +116,18 @@ void iommufd_device_unbind(struct iommufd_device *idev)
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
@@ -463,6 +475,18 @@ void iommufd_access_destroy(struct iommufd_access *access)
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_access_destroy, IOMMUFD);
 
+struct iommufd_ctx *iommufd_access_to_ictx(struct iommufd_access *access)
+{
+	return access->ictx;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_access_to_ictx, IOMMUFD);
+
+u32 iommufd_access_to_id(struct iommufd_access *access)
+{
+	return access->obj.id;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_access_to_id, IOMMUFD);
+
 int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
 {
 	struct iommufd_ioas *new_ioas;
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index c1379e826052..a18e920be164 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -105,6 +105,26 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 		vdev->ops->unbind_iommufd(vdev);
 }
 
+struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev)
+{
+	if (vdev->iommufd_device)
+		return iommufd_device_to_ictx(vdev->iommufd_device);
+	if (vdev->noiommu_access)
+		return iommufd_access_to_ictx(vdev->noiommu_access);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_ictx);
+
+int vfio_iommufd_physical_devid(struct vfio_device *vdev)
+{
+	if (vdev->iommufd_device)
+		return iommufd_device_to_id(vdev->iommufd_device);
+	if (vdev->noiommu_access)
+		return iommufd_access_to_id(vdev->noiommu_access);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_physical_devid);
+
 /*
  * The physical standard ops mean that the iommufd_device is bound to the
  * physical device vdev->dev that was provided to vfio_init_group_dev(). Drivers
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 1129a36a74c4..68cd65274e28 100644
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
@@ -45,6 +48,9 @@ iommufd_access_create(struct iommufd_ctx *ictx,
 void iommufd_access_destroy(struct iommufd_access *access);
 int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id);
 
+struct iommufd_ctx *iommufd_access_to_ictx(struct iommufd_access *access);
+u32 iommufd_access_to_id(struct iommufd_access *access);
+
 void iommufd_ctx_get(struct iommufd_ctx *ictx);
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index a61130bc06a2..fcbe084b18c8 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -115,6 +115,8 @@ struct vfio_device_ops {
 };
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
+struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev);
+int vfio_iommufd_physical_devid(struct vfio_device *vdev);
 int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
@@ -124,6 +126,18 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
 int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 #else
+static inline struct iommufd_ctx *
+vfio_iommufd_physical_ictx(struct vfio_device *vdev)
+{
+	return NULL;
+}
+
+static inline int
+vfio_iommufd_physical_devid(struct vfio_device *vdev)
+{
+	return -EOPNOTSUPP;
+}
+
 #define vfio_iommufd_physical_bind                                      \
 	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
 		  u32 *out_device_id)) NULL)
-- 
2.34.1


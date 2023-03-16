Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DD66BCF2A
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCPMPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjCPMPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:15:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1174262FFB;
        Thu, 16 Mar 2023 05:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678968931; x=1710504931;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LylctBNPn6Ia5HGzTinxDoCCLNEoFcLFW6Mz/3oYHs0=;
  b=Pz2l8M9+vTGoUmxHLodlTUt5E0bri20vcgygx5wjFMdIV0ymtA9P3/Gx
   Riqzi/M3n/CAVn8MFeZbs1ppj8i/SN9E4SomaLfblo73Z0liy2swzuT6U
   nRIN5mrNNTKOb6oikCi/zUkovZ55EUPVzFeVF5W0I4lso4+Cr5POFiaXy
   D6fn0r3PSA6XANr3MbKpuIy4ghYtubxlYCM0/7hiZPyOjx92w0bSAPFCt
   xWhRg+1B/zi+Mb/EdReK3bU9GVpEACgYbrWud+DtOkXmew/hIw2PKskgy
   FTZ401EGx1u/hDYFx38mRJPVlCn62mXoCzh4Ul7Bx4UpJBZT7HTI0Fffu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="336661390"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336661390"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:15:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="679874215"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="679874215"
Received: from unknown (HELO 984fee00a4c6.jf.intel.com) ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 05:15:29 -0700
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
Subject: [PATCH v2 3/5] vfio-iommufd: Make vfio_iommufd_emulated_bind() return iommufd_access ID
Date:   Thu, 16 Mar 2023 05:15:24 -0700
Message-Id: <20230316121526.5644-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316121526.5644-1-yi.l.liu@intel.com>
References: <20230316121526.5644-1-yi.l.liu@intel.com>
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

vfio device cdev needs to return iommufd_access ID to userspace if
bind_iommufd succeeds.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c   | 4 +++-
 drivers/iommu/iommufd/selftest.c | 3 ++-
 drivers/vfio/iommufd.c           | 2 +-
 include/linux/iommufd.h          | 2 +-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 99d34c81d786..0295140dd384 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -426,6 +426,7 @@ void iommufd_access_destroy_object(struct iommufd_object *obj)
  * @ioas_id: ID for a IOMMUFD_OBJ_IOAS
  * @ops: Driver's ops to associate with the access
  * @data: Opaque data to pass into ops functions
+ * @id: Output ID number to return to userspace for this access
  *
  * An iommufd_access allows a driver to read/write to the IOAS without using
  * DMA. The underlying CPU memory can be accessed using the
@@ -435,7 +436,7 @@ void iommufd_access_destroy_object(struct iommufd_object *obj)
  */
 struct iommufd_access *
 iommufd_access_create(struct iommufd_ctx *ictx,
-		      const struct iommufd_access_ops *ops, void *data)
+		      const struct iommufd_access_ops *ops, void *data, u32 *id)
 {
 	struct iommufd_access *access;
 
@@ -460,6 +461,7 @@ iommufd_access_create(struct iommufd_ctx *ictx,
 	access->ictx = ictx;
 	iommufd_ctx_get(ictx);
 	iommufd_object_finalize(ictx, &access->obj);
+	*id = access->obj.id;
 	return access;
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_access_create, IOMMUFD);
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 0eabda430c9f..65e3bdaadd67 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -554,6 +554,7 @@ static int iommufd_test_create_access(struct iommufd_ucmd *ucmd,
 	struct iommu_test_cmd *cmd = ucmd->cmd;
 	struct selftest_access *staccess;
 	struct iommufd_access *access;
+	u32 id;
 	int fdno;
 	int rc;
 
@@ -575,7 +576,7 @@ static int iommufd_test_create_access(struct iommufd_ucmd *ucmd,
 		(flags & MOCK_FLAGS_ACCESS_CREATE_NEEDS_PIN_PAGES) ?
 			&selftest_access_ops_pin :
 			&selftest_access_ops,
-		staccess);
+		staccess, &id);
 	if (IS_ERR(access)) {
 		rc = PTR_ERR(access);
 		goto out_put_fdno;
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index b576d4c7b79b..e40c0e9fea30 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -142,7 +142,7 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	user = iommufd_access_create(ictx, &vfio_user_ops, vdev);
+	user = iommufd_access_create(ictx, &vfio_user_ops, vdev, out_device_id);
 	if (IS_ERR(user))
 		return PTR_ERR(user);
 	vdev->iommufd_access = user;
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 155d3630aedc..1129a36a74c4 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -41,7 +41,7 @@ enum {
 
 struct iommufd_access *
 iommufd_access_create(struct iommufd_ctx *ictx,
-		      const struct iommufd_access_ops *ops, void *data);
+		      const struct iommufd_access_ops *ops, void *data, u32 *id);
 void iommufd_access_destroy(struct iommufd_access *access);
 int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id);
 
-- 
2.34.1


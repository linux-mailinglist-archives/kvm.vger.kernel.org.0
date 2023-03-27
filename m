Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079C46C9FB2
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 11:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbjC0Jep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 05:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbjC0Je1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 05:34:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE362737;
        Mon, 27 Mar 2023 02:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679909660; x=1711445660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qedyzAr3ZT/2tq4uIb2AV1+jHBg7xabozASdmKvcQSU=;
  b=hx4IhA/hkqjo9B7vP0ltoNIVfYnKaXYvFh9KFTtpYU8myhwzQFKXU3P3
   srEsWHK9ugnRI2ozL6fW+dqo7J9nLdODgkJmSzOgD00m/mwnJXKdqs+7f
   r3c0FtN/jdF1hw2xBRmcUqHGrEg3OVyw21/aXPOhoVWrFuOtuSlghCiIA
   dyCXQbFSJn8im5BcAt7dsiuJK3BoVcgWihAAZKCjy/S6DdicwLPFghOTq
   7f42k4xe9Bjaw8QfRxKgCBLuOxXeZfN8gyG5VVgul7Q3f5QtF2RPL9sfN
   mTEflo9OvhZqCpAx5zWw1fdnWns1H7dNdxBnGpT3ASN+a8W0b5YNW6rKp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="402817943"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="402817943"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 02:33:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="685908086"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="685908086"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 27 Mar 2023 02:33:57 -0700
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
Subject: [PATCH v3 4/6] vfio-iommufd: Make vfio_iommufd_emulated_bind() return iommufd_access ID
Date:   Mon, 27 Mar 2023 02:33:49 -0700
Message-Id: <20230327093351.44505-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327093351.44505-1-yi.l.liu@intel.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
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

vfio device cdev needs to return iommufd_access ID to userspace if
bind_iommufd succeeds.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c   | 4 +++-
 drivers/iommu/iommufd/selftest.c | 3 ++-
 drivers/vfio/iommufd.c           | 2 +-
 include/linux/iommufd.h          | 2 +-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 6999a10b5496..25115d401d8f 100644
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
index 1e89e1a8c5f0..e6e04dceffe3 100644
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
index 78e2486586d7..1ee558c0be25 100644
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


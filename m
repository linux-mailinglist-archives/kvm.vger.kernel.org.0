Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE766BCF2D
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCPMPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjCPMPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:15:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6346487F;
        Thu, 16 Mar 2023 05:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678968929; x=1710504929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HRt/jhmEWktmeQl2Z3qMgDPXRjAq6O/tlsvEz+Xv+nc=;
  b=IVnd41yobdyMjbKQubrkIA3dSJLs9SNWTV332OHJ86Ppd/kIPk6Aj4eD
   ARhiZinAaHJyp3kBZfoh3pmNwsYlZ/Trc0I5GXCliIuKLaHcA67f/1vLe
   J0ACUeXDT9uLWtqkIQspPkvpbyS1GnqvQFFKXfPn522dYOi4FnpdTT3Mz
   E6raMyIS/dAJfxYWtOcIjQ4chYw5NGT2R87Dc+T13gcNPFeXqsByzG3Pm
   f1Epp8APrJQP//PRleUPXvjcERFpKqK1gGBXfUAy3hkcExgj+wXBunrCA
   GExA5dehUA0sjJdAnN+VN5RVbPE4dcRbZhlh7oXmSMiZ1vWRpEbAfBVLG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="336661367"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336661367"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:15:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="679874208"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="679874208"
Received: from unknown (HELO 984fee00a4c6.jf.intel.com) ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 05:15:28 -0700
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
Subject: [PATCH v2 1/5] iommufd: Create access in vfio_iommufd_emulated_bind()
Date:   Thu, 16 Mar 2023 05:15:22 -0700
Message-Id: <20230316121526.5644-2-yi.l.liu@intel.com>
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

From: Nicolin Chen <nicolinc@nvidia.com>

There are needs to created iommufd_access prior to have an IOAS and set
IOAS later. Like the vfio device cdev needs to have an iommufd object
to represent the bond (iommufd_access) and IOAS replacement.

Moves the iommufd_access_create() call into vfio_iommufd_emulated_bind(),
making it symmetric with the __vfio_iommufd_access_destroy() call in the
vfio_iommufd_emulated_unbind(). This means an access is created/destroyed
by the bind()/unbind(), and the vfio_iommufd_emulated_attach_ioas() only
updates the access->ioas pointer.

Since vfio_iommufd_emulated_bind() does not provide ioas_id, drop it from
the argument list of iommufd_access_create(). Instead, add a new access
API iommufd_access_attach() to set the access->ioas pointer. Also, set
vdev->iommufd_attached accordingly, similar to the physical pathway.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c   | 53 +++++++++++++++++++-------------
 drivers/iommu/iommufd/selftest.c |  5 ++-
 drivers/vfio/iommufd.c           | 28 ++++++++++++-----
 include/linux/iommufd.h          |  3 +-
 4 files changed, 59 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index a0c66f47a65a..99d34c81d786 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -412,9 +412,12 @@ void iommufd_access_destroy_object(struct iommufd_object *obj)
 	struct iommufd_access *access =
 		container_of(obj, struct iommufd_access, obj);
 
-	iopt_remove_access(&access->ioas->iopt, access);
+	if (access->ioas) {
+		iopt_remove_access(&access->ioas->iopt, access);
+		refcount_dec(&access->ioas->obj.users);
+		access->ioas = NULL;
+	}
 	iommufd_ctx_put(access->ictx);
-	refcount_dec(&access->ioas->obj.users);
 }
 
 /**
@@ -431,12 +434,10 @@ void iommufd_access_destroy_object(struct iommufd_object *obj)
  * The provided ops are required to use iommufd_access_pin_pages().
  */
 struct iommufd_access *
-iommufd_access_create(struct iommufd_ctx *ictx, u32 ioas_id,
+iommufd_access_create(struct iommufd_ctx *ictx,
 		      const struct iommufd_access_ops *ops, void *data)
 {
 	struct iommufd_access *access;
-	struct iommufd_object *obj;
-	int rc;
 
 	/*
 	 * There is no uAPI for the access object, but to keep things symmetric
@@ -449,21 +450,10 @@ iommufd_access_create(struct iommufd_ctx *ictx, u32 ioas_id,
 	access->data = data;
 	access->ops = ops;
 
-	obj = iommufd_get_object(ictx, ioas_id, IOMMUFD_OBJ_IOAS);
-	if (IS_ERR(obj)) {
-		rc = PTR_ERR(obj);
-		goto out_abort;
-	}
-	access->ioas = container_of(obj, struct iommufd_ioas, obj);
-	iommufd_ref_to_users(obj);
-
 	if (ops->needs_pin_pages)
 		access->iova_alignment = PAGE_SIZE;
 	else
 		access->iova_alignment = 1;
-	rc = iopt_add_access(&access->ioas->iopt, access);
-	if (rc)
-		goto out_put_ioas;
 
 	/* The calling driver is a user until iommufd_access_destroy() */
 	refcount_inc(&access->obj.users);
@@ -471,11 +461,6 @@ iommufd_access_create(struct iommufd_ctx *ictx, u32 ioas_id,
 	iommufd_ctx_get(ictx);
 	iommufd_object_finalize(ictx, &access->obj);
 	return access;
-out_put_ioas:
-	refcount_dec(&access->ioas->obj.users);
-out_abort:
-	iommufd_object_abort(ictx, &access->obj);
-	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_access_create, IOMMUFD);
 
@@ -494,6 +479,32 @@ void iommufd_access_destroy(struct iommufd_access *access)
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_access_destroy, IOMMUFD);
 
+int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
+{
+	struct iommufd_ioas *new_ioas;
+	struct iommufd_object *obj;
+	int rc = 0;
+
+	if (access->ioas != NULL && access->ioas->obj.id != ioas_id)
+		return -EINVAL;
+
+	obj = iommufd_get_object(access->ictx, ioas_id, IOMMUFD_OBJ_IOAS);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+	new_ioas = container_of(obj, struct iommufd_ioas, obj);
+
+	rc = iopt_add_access(&new_ioas->iopt, access);
+	if (rc) {
+		iommufd_put_object(obj);
+		return rc;
+	}
+	iommufd_ref_to_users(obj);
+
+	access->ioas = new_ioas;
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_access_attach, IOMMUFD);
+
 /**
  * iommufd_access_notify_unmap - Notify users of an iopt to stop using it
  * @iopt: iopt to work on
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index cfb5fe9a5e0e..0eabda430c9f 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -571,7 +571,7 @@ static int iommufd_test_create_access(struct iommufd_ucmd *ucmd,
 	}
 
 	access = iommufd_access_create(
-		ucmd->ictx, ioas_id,
+		ucmd->ictx,
 		(flags & MOCK_FLAGS_ACCESS_CREATE_NEEDS_PIN_PAGES) ?
 			&selftest_access_ops_pin :
 			&selftest_access_ops,
@@ -580,6 +580,9 @@ static int iommufd_test_create_access(struct iommufd_ucmd *ucmd,
 		rc = PTR_ERR(access);
 		goto out_put_fdno;
 	}
+	rc = iommufd_access_attach(access, ioas_id);
+	if (rc)
+		goto out_destroy;
 	cmd->create_access.out_access_fd = fdno;
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 	if (rc)
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index db4efbd56042..6b4b495b24c4 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -138,10 +138,18 @@ static const struct iommufd_access_ops vfio_user_ops = {
 int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id)
 {
+	struct iommufd_access *user;
+
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	vdev->iommufd_ictx = ictx;
 	iommufd_ctx_get(ictx);
+	user = iommufd_access_create(ictx, &vfio_user_ops, vdev);
+	if (IS_ERR(user)) {
+		iommufd_ctx_put(ictx);
+		return PTR_ERR(user);
+	}
+	vdev->iommufd_access = user;
+	vdev->iommufd_ictx = ictx;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_bind);
@@ -152,6 +160,7 @@ void vfio_iommufd_emulated_unbind(struct vfio_device *vdev)
 
 	if (vdev->iommufd_access) {
 		iommufd_access_destroy(vdev->iommufd_access);
+		vdev->iommufd_attached = false;
 		vdev->iommufd_access = NULL;
 	}
 	iommufd_ctx_put(vdev->iommufd_ictx);
@@ -161,15 +170,20 @@ EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_unbind);
 
 int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 {
-	struct iommufd_access *user;
+	int rc;
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	user = iommufd_access_create(vdev->iommufd_ictx, *pt_id, &vfio_user_ops,
-				     vdev);
-	if (IS_ERR(user))
-		return PTR_ERR(user);
-	vdev->iommufd_access = user;
+	if (WARN_ON(!vdev->iommufd_ictx))
+		return -EINVAL;
+	if (WARN_ON(!vdev->iommufd_access))
+		return -ENOENT;
+	if (vdev->iommufd_attached)
+		return -EBUSY;
+	rc = iommufd_access_attach(vdev->iommufd_access, *pt_id);
+	if (rc)
+		return rc;
+	vdev->iommufd_attached = true;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_attach_ioas);
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index c0b5b3ac34f1..155d3630aedc 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -40,9 +40,10 @@ enum {
 };
 
 struct iommufd_access *
-iommufd_access_create(struct iommufd_ctx *ictx, u32 ioas_id,
+iommufd_access_create(struct iommufd_ctx *ictx,
 		      const struct iommufd_access_ops *ops, void *data);
 void iommufd_access_destroy(struct iommufd_access *access);
+int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id);
 
 void iommufd_ctx_get(struct iommufd_ctx *ictx);
 
-- 
2.34.1


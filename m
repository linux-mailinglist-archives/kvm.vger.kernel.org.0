Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CCF6B0880
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjCHNUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbjCHNUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:20:04 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40C6C5600;
        Wed,  8 Mar 2023 05:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678281381; x=1709817381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=orhBmr8BRwp6o5biW3bryky9mUz7L+UcOv8AJ7UhNN8=;
  b=efIcmj8jQ/CnqHoW4I0WNoPx3lwZt1OCAtPS0UpfH+8godvoWNzz7V1r
   O07b1s25NN3OeoIJeEmuWH4vcCYh+XugUCplSqmVU+ij9kDtuttTSrnQj
   rV4TnFh0yPhaqf600M0cHKYa15YKH5YSve/lANSsTgihs+WsT80Gr4UR6
   0GCJNdHZ3V+Q+SRXy8xtXTqTIk5wCanXg8pv8Rvdoa9+5NrTBCGJufSRD
   7QXTvlOpgxL50Z7/Pp5Zf1N5oXKqAYSd40IvA5Zkpr9THdLkaP/3L9IPD
   7TkcYR0IzfK3Rl9XSR2eag365cMg9R5v64ZWxLRYkqKkk6SHnQMyE6QLg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338474815"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="338474815"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:13:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="670330914"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="670330914"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 08 Mar 2023 05:13:43 -0800
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
Subject: [PATCH v1 2/5] vfio-iommufd: No need to record iommufd_ctx in vfio_device
Date:   Wed,  8 Mar 2023 05:13:37 -0800
Message-Id: <20230308131340.459224-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308131340.459224-1-yi.l.liu@intel.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

iommufd_ctx is stored in vfio_device for emulated devices per bind_iommufd.
However, as iommufd_access is created in bind, no more need to stored it
since iommufd_access implicitly stores it.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c | 10 +---------
 include/linux/vfio.h   |  1 -
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 1f87294c1931..b55f94271cc7 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -142,14 +142,10 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	iommufd_ctx_get(ictx);
 	user = iommufd_access_create(ictx, &vfio_user_ops, vdev);
-	if (IS_ERR(user)) {
-		iommufd_ctx_put(ictx);
+	if (IS_ERR(user))
 		return PTR_ERR(user);
-	}
 	vdev->iommufd_access = user;
-	vdev->iommufd_ictx = ictx;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_bind);
@@ -162,8 +158,6 @@ void vfio_iommufd_emulated_unbind(struct vfio_device *vdev)
 		iommufd_access_destroy(vdev->iommufd_access);
 		vdev->iommufd_access = NULL;
 	}
-	iommufd_ctx_put(vdev->iommufd_ictx);
-	vdev->iommufd_ictx = NULL;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_unbind);
 
@@ -171,8 +165,6 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (!vdev->iommufd_ictx)
-		return -EINVAL;
 	if (!vdev->iommufd_access)
 		return -ENOENT;
 	return iommufd_access_set_ioas(vdev->iommufd_access, *pt_id);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 93134b023968..3188d8a374bd 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -60,7 +60,6 @@ struct vfio_device {
 	void (*put_kvm)(struct kvm *kvm);
 #if IS_ENABLED(CONFIG_IOMMUFD)
 	struct iommufd_device *iommufd_device;
-	struct iommufd_ctx *iommufd_ictx;
 	bool iommufd_attached;
 #endif
 };
-- 
2.34.1


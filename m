Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18F16C9FB4
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 11:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbjC0Jer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 05:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjC0Je1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 05:34:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0D32D76;
        Mon, 27 Mar 2023 02:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679909660; x=1711445660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=okGxzd81Q5tsYlJwDdxwAay9Wu2nwtxEkgJJaf6riOA=;
  b=FAe9+dVV+nlOmfZGJNZVzfAzdj30BAjmiMLBXXcsBHLl6y7h6yXvjp61
   jMiDbEdwqAuutVIB1x8cxXAGorsh6H3c41gej9y7Z4IhLuYzBwZRIy970
   TfR+ji7wtIgmYDpnNU4WD6NiL/vbG6UKVpl0/xTaZzkdrL5nWw9XhVnnH
   H32Xl4whZG2ODyYXCNmn3v+6NFE7lK+OSPNcnRyDR76pDHmo7YdnvHDPA
   MYn6lwYD66VX26UxNP5G8vj6mvOLUjTl5yL2IBvm+YOchfPpCPKZSRA96
   JTHYMscNwzwZVCL0agw63++IqZcY+RGAMyiQZ8eKYvtXgplESKt4a4Ely
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="402817931"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="402817931"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 02:33:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="685908082"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="685908082"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 27 Mar 2023 02:33:56 -0700
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
Subject: [PATCH v3 3/6] vfio-iommufd: No need to record iommufd_ctx in vfio_device
Date:   Mon, 27 Mar 2023 02:33:48 -0700
Message-Id: <20230327093351.44505-4-yi.l.liu@intel.com>
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

iommufd_ctx is stored in vfio_device for emulated devices per bind_iommufd.
However, as iommufd_access is created in bind, no more need to stored it
since iommufd_access implicitly stores it.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c | 8 +-------
 include/linux/vfio.h   | 1 -
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 0695a06db30d..78e2486586d7 100644
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
@@ -163,8 +159,6 @@ void vfio_iommufd_emulated_unbind(struct vfio_device *vdev)
 		vdev->iommufd_attached = false;
 		vdev->iommufd_access = NULL;
 	}
-	iommufd_ctx_put(vdev->iommufd_ictx);
-	vdev->iommufd_ictx = NULL;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_unbind);
 
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81C1757EB9
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 15:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbjGRN6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 09:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbjGRN6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 09:58:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB9519A0;
        Tue, 18 Jul 2023 06:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688663; x=1721224663;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YaRGpjj7I+GMXdcc3KIUaOmLLrRW7d35dueJ3AuGdR4=;
  b=Dbe+DLt23zfnsD8yvXFVJTLWiTV2T7sKLob5j/s2jEG2J6+hsDvwOqXV
   gxg6nfZXw/vja64NXSkQX26TLO1H1NFnfQLVI9QtuaMY8/JqJkt1eN1WT
   3smhSxJYDfwlHwITI0EXhUjnBz27ryEhfqVcdBzPK150q05XlYRIIHvaR
   vbPlMesfXftIb/BcyrPSybOTKUqzlSV2UuFQ28oR5oiqPBDTOaoEBq/VK
   tWewe7ghxiVBxGIbs/+ukIbg6OFwBO1tVtyw5YqOZvexweeZ8lLut3u+T
   3bbox71kk8a1dw9LeCUkZ01DU3F5hQDNzPF469oMbqU+A0SCbMOtBE5Nd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="452590770"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="452590770"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:56:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="970251076"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="970251076"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jul 2023 06:56:08 -0700
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
Subject: [PATCH v15 19/26] vfio: Test kvm pointer in _vfio_device_get_kvm_safe()
Date:   Tue, 18 Jul 2023 06:55:44 -0700
Message-Id: <20230718135551.6592-20-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230718135551.6592-1-yi.l.liu@intel.com>
References: <20230718135551.6592-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This saves some lines when adding the kvm get logic for the vfio_device
cdev path.

This also renames _vfio_device_get_kvm_safe() to be vfio_device_get_kvm_safe().

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 7 +------
 drivers/vfio/vfio.h      | 6 +++---
 drivers/vfio/vfio_main.c | 5 ++++-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 41a09a2df690..5c17ad812313 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -160,12 +160,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 static void vfio_device_group_get_kvm_safe(struct vfio_device *device)
 {
 	spin_lock(&device->group->kvm_ref_lock);
-	if (!device->group->kvm)
-		goto unlock;
-
-	_vfio_device_get_kvm_safe(device, device->group->kvm);
-
-unlock:
+	vfio_device_get_kvm_safe(device, device->group->kvm);
 	spin_unlock(&device->group->kvm_ref_lock);
 }
 
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index fb8f2fac3d23..c2aa65382592 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -340,11 +340,11 @@ enum { vfio_noiommu = false };
 #endif
 
 #ifdef CONFIG_HAVE_KVM
-void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm);
+void vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm);
 void vfio_device_put_kvm(struct vfio_device *device);
 #else
-static inline void _vfio_device_get_kvm_safe(struct vfio_device *device,
-					     struct kvm *kvm)
+static inline void vfio_device_get_kvm_safe(struct vfio_device *device,
+					    struct kvm *kvm)
 {
 }
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 8a9ebcc6980b..5f7c3151d8c0 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -373,7 +373,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
 #ifdef CONFIG_HAVE_KVM
-void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
+void vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
 {
 	void (*pfn)(struct kvm *kvm);
 	bool (*fn)(struct kvm *kvm);
@@ -381,6 +381,9 @@ void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
 
 	lockdep_assert_held(&device->dev_set->lock);
 
+	if (!kvm)
+		return;
+
 	pfn = symbol_get(kvm_put_kvm);
 	if (WARN_ON(!pfn))
 		return;
-- 
2.34.1


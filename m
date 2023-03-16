Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4846BCF30
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjCPMPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCPMPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:15:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05B265079;
        Thu, 16 Mar 2023 05:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678968931; x=1710504931;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ed/7XLQtYPRpjbI2Jc0ve/djdP1J5ibXosRcrYxHLiE=;
  b=gKHWqSM+hT9TgIStbpXVDRAnqms0N5lMgDSBn7NDLa4yu7x7YRFP089i
   AQvdOVP+kEWCFJo8WL4cdONXttoltNuDHfnAkLQVg3By4GU2Iaw552o2n
   nrO6t25DiBQbvP/p6swBbMRNZED2NbwfKZhWtaAU4m6S4q0iBjDQTtdtP
   IrfYTXCBBhnjDDa3ybvyMH1M3GyYsOFSlOLMTNWjPswpcvsFhyhXWxtT8
   lKyCaYtjwnwIcfw3WOVwV53BtwrzMbPG1ZaKqda3Q9AnV+qt2+VOH5xZK
   b4mnjUnksVDc2EgsFffgl3sWmiV8i2Blhe8OgeQB6MlwI5EDHetujtbka
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="336661414"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336661414"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:15:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="679874221"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="679874221"
Received: from unknown (HELO 984fee00a4c6.jf.intel.com) ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 05:15:31 -0700
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
Subject: [PATCH v2 5/5] vfio: Check the presence for iommufd callbacks in __vfio_register_dev()
Date:   Thu, 16 Mar 2023 05:15:26 -0700
Message-Id: <20230316121526.5644-6-yi.l.liu@intel.com>
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

After making the no-DMA drivers (samples/vfio-mdev) providing iommufd
callbacks, __vfio_register_dev() should check the presence of the iommufd
callbacks if CONFIG_IOMMUFD is enabled.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c   | 3 ---
 drivers/vfio/vfio_main.c | 5 +++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 345ff8cf29e7..9aabd8b31c15 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -32,9 +32,6 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 		return 0;
 	}
 
-	if (WARN_ON(!vdev->ops->bind_iommufd))
-		return -ENODEV;
-
 	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
 	if (ret)
 		return ret;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 43bd6b76e2b6..89497c933490 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -255,8 +255,9 @@ static int __vfio_register_dev(struct vfio_device *device,
 {
 	int ret;
 
-	if (WARN_ON(device->ops->bind_iommufd &&
-		    (!device->ops->unbind_iommufd ||
+	if (WARN_ON(IS_ENABLED(CONFIG_IOMMUFD) &&
+		    (!device->ops->bind_iommufd ||
+		     !device->ops->unbind_iommufd ||
 		     !device->ops->attach_ioas)))
 		return -EINVAL;
 
-- 
2.34.1


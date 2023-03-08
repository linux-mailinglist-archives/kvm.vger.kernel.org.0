Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B396B087C
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjCHNUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbjCHNUJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:20:09 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F456C5AD1;
        Wed,  8 Mar 2023 05:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678281387; x=1709817387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I4ZHZJ2nBj+QYHW15O+NDNV8pctYQs6rpbUtyAnlFrI=;
  b=NWeFGlMxl9kAQQ8CDkKwFaqs1X3Hj8xeyIulim6enlLWdsvlMLS+Wafw
   Kfrs250JHgbS/Vd1EXmA9pNurczM3juNskNqVvA/aU/QQSKrz4QG20T4i
   eoZJpWAH4Gcy9G0cPvme1GeiB++BCdgt+WE2BaaHKq5905Fd9fGWj5STb
   e6oqO8XtN1+7oA2WMGPJkoLhmlyAAp0O2RvCj8V1sFvRbrUj660m9bA5M
   QmwE1eKt1qbmjfCExAuU6ujc71oY4ncjTr+aMv0qYcvTIDyV7emeLFZL7
   nwshRj5OZTHQWRHPykH8oXuJ+5cDM5DvizGEAefAC9YfSFo/tCMjQg4eo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338474825"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="338474825"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:13:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="670330949"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="670330949"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 08 Mar 2023 05:13:46 -0800
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
Subject: [PATCH v1 5/5] vfio: Check the presence for iommufd callbacks in __vfio_register_dev()
Date:   Wed,  8 Mar 2023 05:13:40 -0800
Message-Id: <20230308131340.459224-6-yi.l.liu@intel.com>
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

After making the no-DMA drivers (samples/vfio-mdev) providing iommufd
callbacks, __vfio_register_dev() should check the presence of the iommufd
callbacks if CONFIG_IOMMUFD is enabled.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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


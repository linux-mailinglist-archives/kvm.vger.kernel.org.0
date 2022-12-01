Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967F663F336
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiLAOzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiLAOzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:55:44 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6840CBB7EF
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 06:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669906543; x=1701442543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z+Q4dQMheTtvysUziD70OZAtgOgFjTm9BwB7mPOsGrk=;
  b=ddcUuD0g9bOgPQ0+NbiD8tUpw3qXWCj78A277jcm2tKo75xZEQGQF1Z+
   LLBCUEwxVoaEb2QGPTfCL82S4Tqo3QDkWXqNaoK8Pv/tsbWjjPK9o+A++
   BiVXlEd/N3m86zSmMZU/IHQUpzxKlQCEDjnKFauiWay8hnJSOUenh9bO4
   XEgLo4dXTeJHKi8jkaSIbx8KN1b798BFm+kmRsEyfoNEV8pK3v8r+t+Pt
   diXXOl+78rt89MsQqqgyQS68W2L+ZCq2BkgNrIXZH2+o7wFtMzjUqpWfp
   dzmRFGo8JH8NQKwiy+HD//nXKoV8TE8Ogy7VfuQW8lXJ9LBThQM2IpFtA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317569307"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="317569307"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 06:55:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708095172"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="708095172"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 06:55:42 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com
Subject: [PATCH 05/10] vfio: Swap order of vfio_device_container_register() and open_device()
Date:   Thu,  1 Dec 2022 06:55:30 -0800
Message-Id: <20221201145535.589687-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221201145535.589687-1-yi.l.liu@intel.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
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

This makes the DMA unmap callback registration to container be consistent
across the vfio iommufd compat mode and the legacy container mode.

In the vfio iommufd compat mode, this registration is done in the
vfio_iommufd_bind() when creating access which has an unmap callback. This
is prior to calling the open_device() op. The existing mdev drivers have
been converted to be OK with this order. So it is ok to swap the order of
vfio_device_container_register() and open_device() for legacy mode.

This also prepares for further moving group specific code into separate
source file.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index d1e8e5d2a1bc..4f2d32d4a3d0 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -780,6 +780,7 @@ static int vfio_device_first_open(struct vfio_device *device)
 		ret = vfio_group_use_container(device->group);
 		if (ret)
 			goto err_module_put;
+		vfio_device_container_register(device);
 	} else if (device->group->iommufd) {
 		ret = vfio_iommufd_bind(device, device->group->iommufd);
 		if (ret)
@@ -792,17 +793,17 @@ static int vfio_device_first_open(struct vfio_device *device)
 		if (ret)
 			goto err_container;
 	}
-	if (device->group->container)
-		vfio_device_container_register(device);
 	mutex_unlock(&device->group->group_lock);
 	return 0;
 
 err_container:
 	device->kvm = NULL;
-	if (device->group->container)
+	if (device->group->container) {
+		vfio_device_container_unregister(device);
 		vfio_group_unuse_container(device->group);
-	else if (device->group->iommufd)
+	} else if (device->group->iommufd) {
 		vfio_iommufd_unbind(device);
+	}
 err_module_put:
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
@@ -814,15 +815,15 @@ static void vfio_device_last_close(struct vfio_device *device)
 	lockdep_assert_held(&device->dev_set->lock);
 
 	mutex_lock(&device->group->group_lock);
-	if (device->group->container)
-		vfio_device_container_unregister(device);
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
-	if (device->group->container)
+	if (device->group->container) {
+		vfio_device_container_unregister(device);
 		vfio_group_unuse_container(device->group);
-	else if (device->group->iommufd)
+	} else if (device->group->iommufd) {
 		vfio_iommufd_unbind(device);
+	}
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 }
-- 
2.34.1


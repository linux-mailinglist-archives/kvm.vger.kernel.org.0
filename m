Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058606362A3
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 16:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbiKWPBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 10:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbiKWPBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 10:01:44 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2552AC4A
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 07:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669215703; x=1700751703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z5hUn4QgC/v6l6C/F7geUbtIWTFQlAym9Q3AOe2ru24=;
  b=EXDg12DDpMPa38MWPTL4h3UpCYypghStKU8HimxuLquT0bLWnj5Y6vaK
   27xR0Kp17LHXO41TWOMHBMnNcvyDNoxXpzMliUNfzuGE3tt0cimXM2Tpx
   nCnLMDoOg8ZyprelvMKa03NTFg9umAjBuXIH8bHEnUN+Y3wJulrVuaWqg
   3u+wwczCNrD48CvYi3Q+/juljIIXbqSTPg8BAFKUvt1Oh4IZRuwjKLgSB
   7yh8ws+/aHpvGqG9yIucUjBF4MibPBLyXsaDtbMBpyqQak2B5CTrz2/xX
   L8NEhFhuAhrralTEVU4FFNB3ee9SeFuB3tPt2vn6osJx9GUQAkca95Jpd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301642965"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301642965"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:01:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674750916"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674750916"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 07:01:23 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC 06/10] vfio: Swap order of vfio_device_container_register() and open_device()
Date:   Wed, 23 Nov 2022 07:01:09 -0800
Message-Id: <20221123150113.670399-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123150113.670399-1-yi.l.liu@intel.com>
References: <20221123150113.670399-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes the DMA unmap callback registration to container be consistent
across the vfio iommufd compat mode and the legacy container mode.

In the vfio iommufd compat mode, this registration is done in the
vfio_iommufd_bind() when creating access which has an unmap callback. This
is prior to calling the open_device() op provided by mdev driver. While,
in the vfio legacy mode, the registration is done by
vfio_device_container_register(), and it is after open_device(). By swapping
the order of vfio_device_container_register() and open_device(), the two
modes have the consistent order for the DMA unmap callback registration.

This also prepares for further splitting group specific code.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6ed5c2426464..00c961897d20 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -799,6 +799,7 @@ static int vfio_device_first_open(struct vfio_device *device)
 		ret = vfio_group_use_container(device->group);
 		if (ret)
 			goto err_module_put;
+		vfio_device_container_register(device);
 	} else if (device->group->iommufd) {
 		ret = vfio_iommufd_bind(device, device->group->iommufd);
 		if (ret)
@@ -811,17 +812,17 @@ static int vfio_device_first_open(struct vfio_device *device)
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
@@ -833,15 +834,15 @@ static void vfio_device_last_close(struct vfio_device *device)
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


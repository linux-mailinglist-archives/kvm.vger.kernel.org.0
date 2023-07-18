Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C61757EB4
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 15:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbjGRN5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 09:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbjGRN5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 09:57:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0682712F;
        Tue, 18 Jul 2023 06:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688650; x=1721224650;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tro7ldK39c/D+P73wAYl8xylrR+MAx9kksAZpQYgz6M=;
  b=fUYhLrKUN+FAtp1OYoDn386VTl/nEHvJOKg8p4h6MsmcRb27IGvCq6yY
   Ste1aQtWOSV0UWDaXag823yeOSpDmN+CsI2RpexgK+o0VmUU0fOdV3ryx
   +UkCxtNBRxW7YRk13TGYvTT/PWmY6gtWZCCjoLH0IAluuilUCk1IPx9AY
   Md7CRcNXmje8tcQvxZadXii2LEcGZzBBeckPdy4MoXGHonUvOhDRcgUe5
   H0TyV5KUvF6a7eWjdDK/RF4G3mbEJrSfuO0zIZrg1S7CAOP7lhl0VCfAV
   SDFq0MlZCkie7znG6gY08ma7+2QotARER8CxFWugRt+DHXEnDCRexS0Io
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="452590740"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="452590740"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:56:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="970251060"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="970251060"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jul 2023 06:56:06 -0700
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
Subject: [PATCH v15 17/26] vfio: Move device_del() before waiting for the last vfio_device registration refcount
Date:   Tue, 18 Jul 2023 06:55:42 -0700
Message-Id: <20230718135551.6592-18-yi.l.liu@intel.com>
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

device_del() destroys the vfio-dev/vfioX under the sysfs for vfio_device.
There is no reason to keep it while the device is going to be unregistered.

This movement is also a preparation for adding vfio_device cdev. Kernel
should remove the cdev node of the vfio_device to avoid new registration
refcount increment while the device is going to be unregistered.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6d45caa1f9a0..294bb5ecfc1c 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -338,6 +338,9 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	 */
 	vfio_device_group_unregister(device);
 
+	/* Balances device_add in register path */
+	device_del(&device->device);
+
 	vfio_device_put_registration(device);
 	rc = try_wait_for_completion(&device->comp);
 	while (rc <= 0) {
@@ -361,9 +364,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 		}
 	}
 
-	/* Balances device_add in register path */
-	device_del(&device->device);
-
 	/* Balances vfio_device_set_group in register path */
 	vfio_device_remove_group(device);
 }
-- 
2.34.1


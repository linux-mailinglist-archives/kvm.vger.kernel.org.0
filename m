Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF587201D5
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 14:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbjFBMRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 08:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235253AbjFBMRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 08:17:18 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F9DE41;
        Fri,  2 Jun 2023 05:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685708236; x=1717244236;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LDpum0gyrhY92rh1Sf5oxFrVD6xqaXKz9c9zNny5DxE=;
  b=GaO8knOjs/xbX4socOCSrHwdl54R8446zM9D9H73xntjE3/ZLgcLfKLm
   kMdVYAlfocLAkJITUpnDNSFu8sAKlIgfp/RDSxvpU9wuIzdyZqnJtk15c
   xH5tkAxcHGP/utqpHspKeoHFnlsiHGeWwit0s9pc8HzAY6QI7W4J6YguL
   P1fGQ61AcG/kQCLf6dR8Uloc49AL2+rkdS3bRxoT/gwXjg/sX1AMmcq/Y
   jX/JXHmSMy/O1sNVNMpAGsIzKRjvRE6yYbqo6Rwayq3E4/NgGgk3qI/8K
   lqaAbJ+PaqZYrzdUQkUImy8Tdvv+9eWnc7TT6Jzj0dOGeAABOrJlPQECc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="384136672"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="384136672"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 05:17:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="1037947387"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="1037947387"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jun 2023 05:17:15 -0700
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
Subject: [PATCH v12 16/24] vfio: Move vfio_device_group_unregister() to be the first operation in unregister
Date:   Fri,  2 Jun 2023 05:16:45 -0700
Message-Id: <20230602121653.80017-17-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230602121653.80017-1-yi.l.liu@intel.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This avoids endless vfio_device refcount increasement by userspace,
which would keep blocking the vfio_unregister_group_dev().

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index df4f3e37268d..f00ba7603351 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -332,6 +332,12 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	bool interrupted = false;
 	long rc;
 
+	/*
+	 * Prevent new device opened by userspace via the
+	 * VFIO_GROUP_GET_DEVICE_FD in the group path.
+	 */
+	vfio_device_group_unregister(device);
+
 	vfio_device_put_registration(device);
 	rc = try_wait_for_completion(&device->comp);
 	while (rc <= 0) {
@@ -355,8 +361,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 		}
 	}
 
-	vfio_device_group_unregister(device);
-
 	/* Balances device_add in register path */
 	device_del(&device->device);
 
-- 
2.34.1


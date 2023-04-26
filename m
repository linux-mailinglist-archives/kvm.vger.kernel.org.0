Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F386EF765
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 17:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241396AbjDZPE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 11:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241493AbjDZPEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 11:04:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F2476A5;
        Wed, 26 Apr 2023 08:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682521455; x=1714057455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rNbdnFNXhsfKnZiSnsZQt++FoYI+cmxvGCKsSVRHz8M=;
  b=SVMuhqHpw8by+FA19dyAdNziMNPX+7++hxYzvEkVVH7OMxXmzxhfN7jS
   aQEmLjEts8q/s5bWFQ5jANODJFm1s9A8IQZ2hBkblb2sZv5KLpPRB10jy
   K2mAvJQg1uzPcMYIEh+OIs9QFY7s6vI2xZ0+ZqxMte1gVAamXGqUw6bZv
   r9lwDtaTZU+uBcbv+ATFEbwAHP3fnDYNMs0+8DbOmZYG05N4FdluQY2y+
   vydANGnpbDZwPBeKIqy3Cb45FVl9GQ7osj7NVRGBDmd+9MB1vACKUknhh
   Uf1jGWQLTIk7fAcNcfDZYWABqPCFIusBJTdd4kAvan3wXiVnYKxYFw4qk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="349944644"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="349944644"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 08:03:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="805544283"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="805544283"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 26 Apr 2023 08:03:55 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com
Subject: [PATCH v10 17/22] vfio: Move vfio_device_group_unregister() to be the first operation in unregister
Date:   Wed, 26 Apr 2023 08:03:16 -0700
Message-Id: <20230426150321.454465-18-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426150321.454465-1-yi.l.liu@intel.com>
References: <20230426150321.454465-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This can avoid endless vfio_device refcount increasement by userspace,
which would keep blocking the vfio_unregister_group_dev().

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index c0459872d79a..c3263cb2ea75 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -322,6 +322,12 @@ void vfio_unregister_group_dev(struct vfio_device *device)
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
@@ -345,8 +351,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 		}
 	}
 
-	vfio_device_group_unregister(device);
-
 	/* Balances device_add in register path */
 	device_del(&device->device);
 
-- 
2.34.1


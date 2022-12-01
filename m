Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1273363F334
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiLAOzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiLAOzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:55:42 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C35BB7FB
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 06:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669906541; x=1701442541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C4orkMOfRqw6618gMklzJXFD/AmQira52FZhUFGsbSg=;
  b=OhG2NkcFLItzdTa+hLSrDfaND+D+HGc0Tw6616fngN2Y29Bh/0Ydxkk6
   7OJs5bPuDJJDzF1aYFGo/fOXHT4mzLFEccwFObP7H9Dr1Vbd0IZkd2s8g
   umD4/I570aeUQVkI2E+D0D+fCM4bNQ9v8TBKvSuBLe5eoCqaU1mtR2iga
   z1hkmXOkuJJwUHuheBA0ySKbE7l2bcbrmAU70YLNbxXUOd2lVmZwELwC7
   NezGTov+N05zYj4nP5Ft6HyBuOFg/Ew951/1qmtQajFhuzbGrvkSrCDn4
   N5XgVRhfJ33w1dWV78glWo+OnDY76C/j6QvEDAinAcbD3l6L951K6PhwZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317569293"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="317569293"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 06:55:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708095161"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="708095161"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 06:55:40 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com
Subject: [PATCH 03/10] vfio: Create wrappers for group register/unregister
Date:   Thu,  1 Dec 2022 06:55:28 -0800
Message-Id: <20221201145535.589687-4-yi.l.liu@intel.com>
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

This avoids decoding group fields in the common functions used by
vfio_device registration, and prepares for further moving the vfio group
specific code into separate file.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 9f05dab0fab5..7017d3da6e6f 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -487,6 +487,20 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	return group;
 }
 
+static void vfio_device_group_register(struct vfio_device *device)
+{
+	mutex_lock(&device->group->device_lock);
+	list_add(&device->group_next, &device->group->device_list);
+	mutex_unlock(&device->group->device_lock);
+}
+
+static void vfio_device_group_unregister(struct vfio_device *device)
+{
+	mutex_lock(&device->group->device_lock);
+	list_del(&device->group_next);
+	mutex_unlock(&device->group->device_lock);
+}
+
 static int __vfio_register_dev(struct vfio_device *device,
 		struct vfio_group *group)
 {
@@ -525,9 +539,7 @@ static int __vfio_register_dev(struct vfio_device *device,
 	/* Refcounting can't start until the driver calls register */
 	refcount_set(&device->refcount, 1);
 
-	mutex_lock(&group->device_lock);
-	list_add(&device->group_next, &group->device_list);
-	mutex_unlock(&group->device_lock);
+	vfio_device_group_register(device);
 
 	return 0;
 err_out:
@@ -587,7 +599,6 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
  * removed.  Open file descriptors for the device... */
 void vfio_unregister_group_dev(struct vfio_device *device)
 {
-	struct vfio_group *group = device->group;
 	unsigned int i = 0;
 	bool interrupted = false;
 	long rc;
@@ -615,9 +626,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 		}
 	}
 
-	mutex_lock(&group->device_lock);
-	list_del(&device->group_next);
-	mutex_unlock(&group->device_lock);
+	vfio_device_group_unregister(device);
 
 	/* Balances device_add in register path */
 	device_del(&device->device);
-- 
2.34.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACEF6362A5
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 16:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiKWPCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 10:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236736AbiKWPBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 10:01:46 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D1C27DD5
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 07:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669215705; x=1700751705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V4Q4SIpvyzTBZ87hj9MVBJJmf+gBS9mAYL6R1mY7JKc=;
  b=eHZIgh4G//7jzScmv1/nhLk1p2kNWrGhN7ML08sSqWiaJbDBJzk7XVSK
   57YVmfYOaIOCjub1qTwb6E11r1Lb1FPWYnWke35gSLPn8wuj7wOGnP8TR
   T2HSV/15dCjZ+zli9ZrYFhvc27svGGqUKVYfSqUw3rrZTpzB1MY7Jgmcc
   znwL2loHbbjoBl/KYGkDmvibE2EFtu4X5ORgkdHI3d9bOovVBBwv5Cl5j
   URNNNrbMOOtH/9PiJ5zmJot185dePDjADo1w7BFiVkZVe7yw5p7fPvcqT
   ef5KdyVuI1FavuFHvLtGnulhwxg0L/1v460YZt1u5m1+Z4pV18/oUAi4n
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301642981"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301642981"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:01:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674750951"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674750951"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 07:01:26 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC 08/10] vfio: Wrap vfio group module init/clean code into helpers
Date:   Wed, 23 Nov 2022 07:01:11 -0800
Message-Id: <20221123150113.670399-9-yi.l.liu@intel.com>
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

This wraps the init/clean code of vfio group global variable to be helpers,
and prepares for further moving vfio group specific code into separate file.

As container is used by group, so vfio_container_init/cleanup() is moved
into vfio_group_init/cleanup().

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 56 ++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 71108f3707c3..cde258f4ea17 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -2053,12 +2053,11 @@ static char *vfio_devnode(struct device *dev, umode_t *mode)
 	return kasprintf(GFP_KERNEL, "vfio/%s", dev_name(dev));
 }
 
-static int __init vfio_init(void)
+static int __init vfio_group_init(void)
 {
 	int ret;
 
 	ida_init(&vfio.group_ida);
-	ida_init(&vfio.device_ida);
 	mutex_init(&vfio.group_lock);
 	INIT_LIST_HEAD(&vfio.group_list);
 
@@ -2075,24 +2074,12 @@ static int __init vfio_init(void)
 
 	vfio.class->devnode = vfio_devnode;
 
-	/* /sys/class/vfio-dev/vfioX */
-	vfio.device_class = class_create(THIS_MODULE, "vfio-dev");
-	if (IS_ERR(vfio.device_class)) {
-		ret = PTR_ERR(vfio.device_class);
-		goto err_dev_class;
-	}
-
 	ret = alloc_chrdev_region(&vfio.group_devt, 0, MINORMASK + 1, "vfio");
 	if (ret)
 		goto err_alloc_chrdev;
-
-	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	return 0;
 
 err_alloc_chrdev:
-	class_destroy(vfio.device_class);
-	vfio.device_class = NULL;
-err_dev_class:
 	class_destroy(vfio.class);
 	vfio.class = NULL;
 err_group_class:
@@ -2100,18 +2087,47 @@ static int __init vfio_init(void)
 	return ret;
 }
 
-static void __exit vfio_cleanup(void)
+static void vfio_group_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
-
-	ida_destroy(&vfio.device_ida);
 	ida_destroy(&vfio.group_ida);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
-	class_destroy(vfio.device_class);
-	vfio.device_class = NULL;
 	class_destroy(vfio.class);
-	vfio_container_cleanup();
 	vfio.class = NULL;
+	vfio_container_cleanup();
+}
+
+static int __init vfio_init(void)
+{
+	int ret;
+
+	ida_init(&vfio.device_ida);
+
+	ret = vfio_group_init();
+	if (ret)
+		return ret;
+
+	/* /sys/class/vfio-dev/vfioX */
+	vfio.device_class = class_create(THIS_MODULE, "vfio-dev");
+	if (IS_ERR(vfio.device_class)) {
+		ret = PTR_ERR(vfio.device_class);
+		goto err_dev_class;
+	}
+
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	return 0;
+
+err_dev_class:
+	vfio_group_cleanup();
+	return ret;
+}
+
+static void __exit vfio_cleanup(void)
+{
+	ida_destroy(&vfio.device_ida);
+	class_destroy(vfio.device_class);
+	vfio.device_class = NULL;
+	vfio_group_cleanup();
 	xa_destroy(&vfio_device_set_xa);
 }
 
-- 
2.34.1


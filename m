Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D14263F339
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiLAOzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiLAOzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:55:47 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67955BD895
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 06:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669906546; x=1701442546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fb8Y1Swxw5mauQqBDTEwmn9jPcwSdo1NITP8s6Ie23I=;
  b=UsMjJh4DD1n9jt6bBt4ShAMymMZJnC6ed8qM60bc/Jxyol5/lYRcKAF8
   1zDQX+POA1K+OORMIAsFTnjdkMuNH683ltNrID2hnCLyqA29D8NSaB0f6
   zSkf8DGtnCjgrp2FGZhZ7DfAoWgABDKeKnvdgiQ5p8J0F2fEG5cY+eCkA
   qC0ZxQv8DnV/teDqXpeVULtIEqGFdu4A+SgmdQSVfB3vZUWp+7TBe5Brb
   1/9Aa5YElV5nmDNGS+mtflr8ra2LAykptbufJoOLW776FBnPh0pcCaRIx
   22kn1PQ6seB1hemQaPiWDxBMS+2naRLi7QKrIwTI2CpmYeEInEK2aB8B2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317569325"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="317569325"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 06:55:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708095200"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="708095200"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 06:55:45 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com
Subject: [PATCH 08/10] vfio: Wrap vfio group module init/clean code into helpers
Date:   Thu,  1 Dec 2022 06:55:33 -0800
Message-Id: <20221201145535.589687-9-yi.l.liu@intel.com>
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

This wraps the init/clean code of vfio group global variable to be helpers,
and prepares for further moving vfio group specific code into separate
file.

As container is used by group, so vfio_container_init/cleanup() is moved
into vfio_group_init/cleanup().

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 56 ++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6906aa099c0e..6e7daed47e97 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -2071,12 +2071,11 @@ static char *vfio_devnode(struct device *dev, umode_t *mode)
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
 
@@ -2093,24 +2092,12 @@ static int __init vfio_init(void)
 
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
@@ -2118,18 +2105,47 @@ static int __init vfio_init(void)
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9E46378DC
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiKXM1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiKXM1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:27:21 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E395ED92E8
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669292839; x=1700828839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s+wTJM6B3/exnkZw60rs9SQVEwJdeaJmH1pTbUWuRUw=;
  b=cNAeH9CaunnaQNrNnQhLJKIskOEWbCxIKhcWUVvZRmDOD6Jk+ScG3+9A
   pskAMqxnfKfcsYfrqSHdCf7DdlxlpQNiTAzVuzGFZbpzzWMNm3J/2i2bL
   V5sHlHXykb0PJM1rqjfGNrHUO0kLlaDw3zQrU8G+UwS2lQkMl/NfY2mQ2
   2WG7NIsQvZRknRQDfuVZTP2Z/rqGnpKH5QKJONtfIbwZ5AXt87uAZE5Ki
   R2dZKfcAdk08AKTj492X8saQxchchTGhZ0Mv12s+fbL64rlJZLyWHj2xy
   KEwNZPBd0xPfypIWElPPtJJZZJtn3N9cy0sQ87tNJivDlVTPsNfgEnSx5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297649647"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="297649647"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:27:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642337202"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642337202"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 04:27:17 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC v2 09/11] vfio: Wrap vfio group module init/clean code into helpers
Date:   Thu, 24 Nov 2022 04:27:00 -0800
Message-Id: <20221124122702.26507-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124122702.26507-1-yi.l.liu@intel.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 56 ++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 45f96515c05e..a0c699b3e3d9 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -2087,12 +2087,11 @@ static char *vfio_devnode(struct device *dev, umode_t *mode)
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
 
@@ -2109,24 +2108,12 @@ static int __init vfio_init(void)
 
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
@@ -2134,18 +2121,47 @@ static int __init vfio_init(void)
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


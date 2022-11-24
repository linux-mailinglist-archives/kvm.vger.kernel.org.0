Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31816378DB
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiKXM1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKXM1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:27:20 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96CFE0740
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669292837; x=1700828837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gg2XiNRl+cfbOqThwNtjEqfqdDucImGzrmJ5MAPjwP8=;
  b=MA3DI2N/0vTTbO3sQiMbPEep3BAlIHfE2F25Hn5YwVTiqAKwMc5NhvKo
   l3f2FgHij1jWWtnaUyN7sgmoLo+TTvoF5SJBUTvbwIQVxHIWgWHkjrZyz
   4FTbwVKmrAWaWTs1M4zMwINNW9Zz6r5cVGwufXdkaO49C7+L5ESURf3Hr
   J4KOZUyfCCg/LBUIGDLdII+JG7mlcT1LSKLjvYoLm0E5O9HO7CLJS2pD7
   b+PdJMt2EiUy3GiLpIIp+HyGp35o/eBGhkvmGnAf4HEXrsVVuf9JmyLLG
   +AzFgczMAGeBy3DWomtIQ8iqXNa2yQ9PHz16zZALc47SN98c420jmNgbp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297649639"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="297649639"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:27:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642337184"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642337184"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 04:27:16 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC v2 06/11] vfio: Move device open/close code to be helpfers
Date:   Thu, 24 Nov 2022 04:26:57 -0800
Message-Id: <20221124122702.26507-7-yi.l.liu@intel.com>
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

This makes the device open and close be in paired helpers.

vfio_device_open(), and vfio_device_close() handles the open_count, and
calls vfio_device_first_open(), and vfio_device_last_close() when
open_count condition is met. This also helps to avoid open code for device
in the vfio_group_ioctl_get_device_fd(), and prepares for further moving
vfio group specific code into separate file.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 46 +++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index fcb9f778fc9b..c3d58cbc2aa9 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -846,20 +846,41 @@ static void vfio_device_last_close(struct vfio_device *device)
 	module_put(device->dev->driver->owner);
 }
 
-static struct file *vfio_device_open(struct vfio_device *device)
+static int vfio_device_open(struct vfio_device *device)
 {
-	struct file *filep;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&device->dev_set->lock);
 	device->open_count++;
 	if (device->open_count == 1) {
 		ret = vfio_device_first_open(device);
 		if (ret)
-			goto err_unlock;
+			device->open_count--;
 	}
 	mutex_unlock(&device->dev_set->lock);
 
+	return ret;
+}
+
+static void vfio_device_close(struct vfio_device *device)
+{
+	mutex_lock(&device->dev_set->lock);
+	vfio_assert_device_open(device);
+	if (device->open_count == 1)
+		vfio_device_last_close(device);
+	device->open_count--;
+	mutex_unlock(&device->dev_set->lock);
+}
+
+static struct file *vfio_device_open_file(struct vfio_device *device)
+{
+	struct file *filep;
+	int ret;
+
+	ret = vfio_device_open(device);
+	if (ret)
+		goto err_out;
+
 	/*
 	 * We can't use anon_inode_getfd() because we need to modify
 	 * the f_mode flags directly to allow more than just ioctls
@@ -885,12 +906,8 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	return filep;
 
 err_close_device:
-	mutex_lock(&device->dev_set->lock);
-	if (device->open_count == 1)
-		vfio_device_last_close(device);
-err_unlock:
-	device->open_count--;
-	mutex_unlock(&device->dev_set->lock);
+	vfio_device_close(device);
+err_out:
 	return ERR_PTR(ret);
 }
 
@@ -918,7 +935,7 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
 		goto err_put_device;
 	}
 
-	filep = vfio_device_open(device);
+	filep = vfio_device_open_file(device);
 	if (IS_ERR(filep)) {
 		ret = PTR_ERR(filep);
 		goto err_put_fdno;
@@ -1105,12 +1122,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
 
-	mutex_lock(&device->dev_set->lock);
-	vfio_assert_device_open(device);
-	if (device->open_count == 1)
-		vfio_device_last_close(device);
-	device->open_count--;
-	mutex_unlock(&device->dev_set->lock);
+	vfio_device_close(device);
 
 	vfio_device_put_registration(device);
 
-- 
2.34.1


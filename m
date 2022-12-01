Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F5E63F337
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiLAOzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbiLAOzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:55:45 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5514DBB7F6
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 06:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669906544; x=1701442544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+NfiZxfAURr6gwL49sSoMOfx10ZR+7t+83iCxhXkCeQ=;
  b=fovuS5erp2NNpPD9BvcQxsAsWdp5MTE6Cck4iQT+fb+lS6bYEbMpHQqV
   esHs4oi943NvBm+K7ayLBdXOcCuTxncjdJtvgpMVbcv1UJEtqq8BQFoN8
   8p8qlOX8lQbw3GAkb5QavAM8QqX20x6Vn4hw+HFfEo+HZOvUzwKKwHpio
   LZMKzPKz5i44MK3dDmrzVqjnxKP93kXs9sDPBaM+gIuZdgguCgQcwRwIN
   63GY3MSL+kzL3U51Dfezl0fBrZFX1yGpdSKCyIWnJnk0Pd/W9t6FW1OgP
   02+nZJrUlH5zwz4fPNmetLKxZ1OLcsbjBSdFoBOkEGO7kTpZ6CsdA3nux
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317569310"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="317569310"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 06:55:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708095179"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="708095179"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 06:55:43 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com
Subject: [PATCH 06/10] vfio: Move device open/close code to be helpfers
Date:   Thu,  1 Dec 2022 06:55:31 -0800
Message-Id: <20221201145535.589687-7-yi.l.liu@intel.com>
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

This makes vfio_device_open/close() to be the top level helpers for device
open and close. It handles the open_count, and vfio_device_first_open()
vfio_device_last_close() do the container/iommufd use/unuse and the device
open.

Current vfio_device_open() handles the device open and the device file
open which is group specific. After this change, the group specific code
is in the vfio_device_open_file() which would be moved to separate group
source code in future.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 46 +++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 4f2d32d4a3d0..964d44a35624 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -828,20 +828,41 @@ static void vfio_device_last_close(struct vfio_device *device)
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
@@ -870,12 +891,8 @@ static struct file *vfio_device_open(struct vfio_device *device)
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
 
@@ -903,7 +920,7 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
 		goto err_put_device;
 	}
 
-	filep = vfio_device_open(device);
+	filep = vfio_device_open_file(device);
 	if (IS_ERR(filep)) {
 		ret = PTR_ERR(filep);
 		goto err_put_fdno;
@@ -1086,12 +1103,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
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


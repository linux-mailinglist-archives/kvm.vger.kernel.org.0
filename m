Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6566362A0
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 16:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbiKWPBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 10:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236848AbiKWPBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 10:01:43 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C817B27DD5
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 07:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669215702; x=1700751702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b6wiWLV9q3GQ5pI74MN2xqdsB2udrYRw0N4e68cjsRM=;
  b=hbfuoJ7bk5bsNlSHaLZfAOCFE7vPJUtFWahGS+sdrqa2gkXuqzQdd0T1
   in8jEwBDDd7QLudGgD+E1g9Cd9pY3GLQLdoWlKPx3xrJUxg10AYHFnyDR
   yMWR+ymsqox4ysT1B6kbX0dIU7lTm5ItegpfB+6tSAzRvqmBLBe7MJDiQ
   VxcaL1oYB/wplULO7B4WDTrgntA0r0mp8P10IhuK0DeMGf/iSquvlwoO2
   NPKoz1q16YCaMtYXamCBX4zBspdf6/tV3PrUPHtO11JpwBuJzB2+PNH57
   jPfD0mKF+0GRhaDFmWtb0u+Y/KH2gDXVaUTws/LEwT2P1uH5855QUoJGp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301642955"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301642955"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:01:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674750903"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674750903"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 07:01:20 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC 05/10] vfio: Move device open/close code to be helpfers
Date:   Wed, 23 Nov 2022 07:01:08 -0800
Message-Id: <20221123150113.670399-6-yi.l.liu@intel.com>
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

This makes the device open and close be in paired helpers.

vfio_device_open(), and vfio_device_close() handles the open_count, and
calls vfio_device_first_open(), and vfio_device_last_close() when open_count
condition is met. This also helps to avoid open code for device in the
vfio_group_ioctl_get_device_fd(), and prepares for further moving vfio group
specific code into separate file.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 46 +++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5e1e509e6477..6ed5c2426464 100644
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


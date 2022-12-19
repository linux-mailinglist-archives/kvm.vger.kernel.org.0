Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235B16508C5
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 09:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiLSIsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 03:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiLSIrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 03:47:45 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54436371
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 00:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671439664; x=1702975664;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2FrGgQkV/YfTTAKXEj7uizSnEbP/rfVuMpMaa1mGG+8=;
  b=a4Z8D3b9WHSJzKBKzAIfMWAkc1kwXc3i3ujfc88DBrtI4MypQxDvkq44
   eO2v+I+I37rb2MH/eObedyOh5HSn4ByY+5f/IgUChbzeS7q/34mCNMa0d
   z9OtEIekGYkOP9p+AYkmFE1evlpgRcCC4nDiWEeAUapkLz7oMXF+eup3F
   MPuYv57eC91m5RkQ58nXNNPiBiuxe5uEOmRyvpDb3A5ekZOKt6fUQowzE
   xCMGBhrEdL2TsD3Ql+kGWmUfsh6cvQEsYDfBaaBQaHMXEXi0D8RB/Qgea
   JD8QF0c64MQQFWw4j1QOre9vaerqdZmPa+AWtOOVByCVhO8m0q2OXVj9C
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="381528479"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="381528479"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 00:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="628233789"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="628233789"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 19 Dec 2022 00:47:44 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com
Subject: [RFC 09/12] vfio: Make vfio_device_open() exclusive between group path and device cdev path
Date:   Mon, 19 Dec 2022 00:47:15 -0800
Message-Id: <20221219084718.9342-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219084718.9342-1-yi.l.liu@intel.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
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

VFIO group has historically allowed multi-open of the device FD. This
was made secure because the "open" was executed via an ioctl to the
group FD which is itself only single open.

No know use of multiple device FDs is known. It is kind of a strange
thing to do because new device FDs can naturally be created via dup().

When we implement the new device uAPI there is no natural way to allow
the device itself from being multi-opened in a secure manner. Without
the group FD we cannot prove the security context of the opener.

Thus, when moving to the new uAPI we block the ability to multi-open
the device. This also makes the cdev path exclusive with group path.

This is done by adding a single_open flag in struct vfio_device_file and
a same flag in struct vfio_device_file. vfio_device_file::single_open is
set per the vfio_device_file allocation. Its value is propagated to struct
vfio_device after device is opened.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     |  2 +-
 drivers/vfio/vfio.h      |  6 +++++-
 drivers/vfio/vfio_main.c | 25 ++++++++++++++++++++++---
 include/linux/vfio.h     |  1 +
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index c4d0564874f2..0b08a277cd0e 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -216,7 +216,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 	struct file *filep;
 	int ret;
 
-	df = vfio_allocate_device_file(device);
+	df = vfio_allocate_device_file(device, false);
 	if (IS_ERR(df)) {
 		ret = PTR_ERR(df);
 		goto err_out;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index c099aa4e7d78..058d7a19dada 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -17,7 +17,11 @@ struct vfio_device;
 struct vfio_container;
 
 struct vfio_device_file {
+	/* static fields, init per allocation */
 	struct vfio_device *device;
+	bool single_open;
+
+	/* fields set after allocation */
 	struct kvm *kvm;
 	struct iommufd_ctx *iommufd;
 	bool access_granted;
@@ -30,7 +34,7 @@ int vfio_device_open(struct vfio_device_file *df,
 void vfio_device_close(struct vfio_device_file *device);
 
 struct vfio_device_file *
-vfio_allocate_device_file(struct vfio_device *device);
+vfio_allocate_device_file(struct vfio_device *device, bool single_open);
 
 extern const struct file_operations vfio_device_fops;
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 304633eee589..1bda847e9f10 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -359,7 +359,7 @@ static bool vfio_assert_device_open(struct vfio_device *device)
 }
 
 struct vfio_device_file *
-vfio_allocate_device_file(struct vfio_device *device)
+vfio_allocate_device_file(struct vfio_device *device, bool single_open)
 {
 	struct vfio_device_file *df;
 
@@ -368,6 +368,7 @@ vfio_allocate_device_file(struct vfio_device *device)
 		return ERR_PTR(-ENOMEM);
 
 	df->device = device;
+	df->single_open = single_open;
 
 	return df;
 }
@@ -435,6 +436,16 @@ int vfio_device_open(struct vfio_device_file *df,
 
 	lockdep_assert_held(&device->dev_set->lock);
 
+	/*
+	 * Device cdev path cannot support multiple device open since
+	 * it doesn't have a secure way for it. So a second device
+	 * open attempt should be failed if the caller is from a cdev
+	 * path or the device has already been opened by a cdev path.
+	 */
+	if (device->open_count != 0 &&
+	    (df->single_open || device->single_open))
+		return -EINVAL;
+
 	device->open_count++;
 	if (device->open_count == 1) {
 		int ret;
@@ -444,6 +455,7 @@ int vfio_device_open(struct vfio_device_file *df,
 			device->open_count--;
 			return ret;
 		}
+		device->single_open = df->single_open;
 	}
 
 	/*
@@ -465,8 +477,10 @@ void vfio_device_close(struct vfio_device_file *df)
 	 */
 	smp_store_release(&df->access_granted, false);
 	vfio_assert_device_open(device);
-	if (device->open_count == 1)
+	if (device->open_count == 1) {
 		vfio_device_last_close(df);
+		device->single_open = false;
+	}
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
 }
@@ -512,7 +526,12 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
-	vfio_device_group_close(df);
+	/*
+	 * group path supports multiple device open, while cdev doesn't.
+	 * So use vfio_device_group_close() for !singel_open case.
+	 */
+	if (!df->single_open)
+		vfio_device_group_close(df);
 	kfree(df);
 	vfio_device_put_registration(device);
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 9e3b9b5c8c8b..5465e29a8a83 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -63,6 +63,7 @@ struct vfio_device {
 	struct iommufd_ctx *iommufd_ictx;
 	bool iommufd_attached;
 #endif
+	bool single_open;
 };
 
 /**
-- 
2.34.1


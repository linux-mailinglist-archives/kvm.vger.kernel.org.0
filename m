Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD9B66DF5B
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjAQNul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjAQNuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:50:04 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35DA3B642
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673963397; x=1705499397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q2k1LfO8Uc9ntNmEOhY9d6Fb175r8XpfB3BBbjS4Xus=;
  b=ILXpmlsEM1BViiCNKHhF8PhWz1JfnkdYGvjW+FlKrstdEZhjaZqexC2E
   Df6dQOtzRmv7v4Si1uNYAlpH1urY4uP2sAiL5Z68GwUmXgQ8H5X8eaQOm
   OukJSWhtF6dpUIWwWyXEEmS+lyC2fY8hCx6WBb927NLrJNNTPyIswEVJh
   66c4OJQVCHQZilyoKfC/STDBErbHOeX+bRTEy3fg4rK0bgmM1NfTm8lnP
   18GLa4Q4rWkK3IJcu043DaOOzntlNg3vCftbzAmb5uaoddGCsw5jJHbRt
   6iCjjuN5McwOnPxelT/1/AiohzlqZ99jFSfzxg/eryuvbgYsShEt8noSl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="326766458"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326766458"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 05:49:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="652551077"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652551077"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 05:49:57 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between group path and device cdev path
Date:   Tue, 17 Jan 2023 05:49:39 -0800
Message-Id: <20230117134942.101112-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117134942.101112-1-yi.l.liu@intel.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
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

The main logic is in the vfio_device_open(). It needs to sustain both
the legacy behavior i.e. multi-open in the group path and the new
behavior i.e. single-open in the cdev path. This mixture leads to the
introduction of a new single_open flag stored both in struct vfio_device
and vfio_device_file. vfio_device_file::single_open is set per the
vfio_device_file allocation. Its value is propagated to struct vfio_device
after device is opened successfully.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     |  2 +-
 drivers/vfio/vfio.h      |  6 +++++-
 drivers/vfio/vfio_main.c | 25 ++++++++++++++++++++++---
 include/linux/vfio.h     |  1 +
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 9484bb1c54a9..57ebe5e1a7e6 100644
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
index fe0fcfa78710..bdcf9762521d 100644
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
index 90174a9015c4..78725c28b933 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -345,7 +345,7 @@ static bool vfio_assert_device_open(struct vfio_device *device)
 }
 
 struct vfio_device_file *
-vfio_allocate_device_file(struct vfio_device *device)
+vfio_allocate_device_file(struct vfio_device *device, bool single_open)
 {
 	struct vfio_device_file *df;
 
@@ -354,6 +354,7 @@ vfio_allocate_device_file(struct vfio_device *device)
 		return ERR_PTR(-ENOMEM);
 
 	df->device = device;
+	df->single_open = single_open;
 
 	return df;
 }
@@ -421,6 +422,16 @@ int vfio_device_open(struct vfio_device_file *df,
 
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
@@ -430,6 +441,7 @@ int vfio_device_open(struct vfio_device_file *df,
 			device->open_count--;
 			return ret;
 		}
+		device->single_open = df->single_open;
 	}
 
 	/*
@@ -446,8 +458,10 @@ void vfio_device_close(struct vfio_device_file *df)
 
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
-	if (device->open_count == 1)
+	if (device->open_count == 1) {
 		vfio_device_last_close(df);
+		device->single_open = false;
+	}
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
 }
@@ -493,7 +507,12 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
-	vfio_device_group_close(df);
+	/*
+	 * group path supports multiple device open, while cdev doesn't.
+	 * So use vfio_device_group_close() for !singel_open case.
+	 */
+	if (!df->single_open)
+		vfio_device_group_close(df);
 
 	vfio_device_put_registration(device);
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 46edd6e6c0ba..300318f0d448 100644
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


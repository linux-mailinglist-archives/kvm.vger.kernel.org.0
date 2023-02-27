Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5356A404A
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 12:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjB0LMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 06:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjB0LMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 06:12:10 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C7F1E1C9;
        Mon, 27 Feb 2023 03:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677496316; x=1709032316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S9kGZ5rf4tbPiAQVbmwVPQqiKdbambEtt1XUmIOW9yw=;
  b=AphvTvdH5x8D9wAJvJ6Gp22ck71JANy/k+gjmoJMZ8Xo0mV13tu2mg2n
   sNPdmE6RE+QbU9yH5kIeJs/UStFE46POvvEulqbY1R0hF+p8DbjufO0Rr
   raoaM/TRj4BsfRP1kCJ4orZmNPg59rIJ0j6EUzgEbh0jZX2OeE+V/ED6N
   YVpq6FO752izCaLyd6BhNOIa+DBB8+DDHEIwSF8/IYYXeklwY/L9PlCx9
   QkYCXJCkuMbZjLEDT3ornBxA4KM8ZBtxGxBN0VhqlBz3OCXswh0Qm62a/
   m3h+P7GhAi1Ko3I64S6d1wUYOLSTkURPV7QveuPb8XOXGWngKd4gDhYM4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="420097738"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="420097738"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 03:11:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651189577"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651189577"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 03:11:47 -0800
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH v5 14/19] vfio: Make vfio_device_open() single open for device cdev path
Date:   Mon, 27 Feb 2023 03:11:30 -0800
Message-Id: <20230227111135.61728-15-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230227111135.61728-1-yi.l.liu@intel.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
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

However, no known use of multiple device FDs today. It is kind of a
strange thing to do because new device FDs can naturally be created
via dup().

When we implement the new device uAPI (only used in cdev path) there is
no natural way to allow the device itself from being multi-opened in a
secure manner. Without the group FD we cannot prove the security context
of the opener.

Thus, when moving to the new uAPI we block the ability to multi-open
the device. Old group path still allows it.

vfio_device_open() needs to sustain both the legacy behavior i.e. multi-open
in the group path and the new behavior i.e. single-open in the cdev path.
This mixture leads to the introduction of a new is_cdev_device flag in struct
vfio_device_file.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio.h      |  2 ++
 drivers/vfio/vfio_main.c | 10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index a61d4df30716..54a48c8596f7 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -18,6 +18,8 @@ struct vfio_container;
 
 struct vfio_device_file {
 	struct vfio_device *device;
+	bool is_cdev_device;
+
 	bool access_granted;
 	spinlock_t kvm_ref_lock; /* protect kvm field */
 	struct kvm *kvm;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a51c0a0e8a1a..5b485d3bb67e 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -472,6 +472,13 @@ int vfio_device_open(struct vfio_device_file *df,
 
 	lockdep_assert_held(&device->dev_set->lock);
 
+	/*
+	 * Device cdev path cannot support multiple device open since
+	 * it doesn't have a secure way for it.
+	 */
+	if (device->open_count != 0 && df->is_cdev_device)
+		return -EINVAL;
+
 	device->open_count++;
 	if (device->open_count == 1) {
 		ret = vfio_device_first_open(df, dev_id, pt_id);
@@ -535,7 +542,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
-	vfio_device_group_close(df);
+	if (!df->is_cdev_device)
+		vfio_device_group_close(df);
 
 	vfio_device_put_registration(device);
 
-- 
2.34.1


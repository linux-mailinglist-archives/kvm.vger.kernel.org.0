Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC8E6378D3
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiKXM1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiKXM1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:27:19 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8D2E0B68
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669292836; x=1700828836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zqCdsTMNMGb+jNWFkruQkcfB8vQOj3LnlKjk6DmlRUY=;
  b=ib0zLkdcxYGSjEa626xf05gOFADUvVpiJ+OlGhORg7mcoPbfF/jO+dz3
   wEW2cwSbKLEUvMHAlbDUvuYpIAyyLcTqD/Is8fLoteX08rA7ertgY2D10
   bHSHCzoHok9vdkTp0MUltpQ06D7qrBb25w5JYyvAbGnwBoDWz6nrBDV0o
   W1WkSO6KQEiAtJPBY0o7OoVCaZz/MxYe4CC/AlQZPBwVSq3VJu6JmbbLc
   LLdulK/D8qQunJyh1R200V5xDNsFh7uSIC9NZhY9H8gXLsR6Eo84fVYTm
   CUepB68g3qmP1Xjk3W62w9PGxfd2dH1E6UYUfwhYYuwaMJOzXnQcbFBSN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297649636"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="297649636"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:27:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642337170"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642337170"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 04:27:15 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC v2 04/11] vfio: Wrap group codes to be helpers for __vfio_register_dev() and unregister
Date:   Thu, 24 Nov 2022 04:26:55 -0800
Message-Id: <20221124122702.26507-5-yi.l.liu@intel.com>
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

This avoids to decode group fields in the common functions used by
vfio_device registration, and prepares for further moving vfio group
specific code into separate file.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 4980b8acf5d3..edcfa8a61096 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -525,6 +525,20 @@ static int vfio_device_set_group(struct vfio_device *device,
 	return 0;
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
 			       enum vfio_group_type type)
 {
@@ -559,9 +573,7 @@ static int __vfio_register_dev(struct vfio_device *device,
 	/* Refcounting can't start until the driver calls register */
 	refcount_set(&device->refcount, 1);
 
-	mutex_lock(&device->group->device_lock);
-	list_add(&device->group_next, &device->group->device_list);
-	mutex_unlock(&device->group->device_lock);
+	vfio_device_group_register(device);
 
 	return 0;
 }
@@ -616,7 +628,6 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
  * removed.  Open file descriptors for the device... */
 void vfio_unregister_group_dev(struct vfio_device *device)
 {
-	struct vfio_group *group = device->group;
 	unsigned int i = 0;
 	bool interrupted = false;
 	long rc;
@@ -644,9 +655,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
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


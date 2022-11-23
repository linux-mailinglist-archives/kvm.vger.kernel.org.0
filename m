Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA10863629E
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 16:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbiKWPBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 10:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236736AbiKWPBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 10:01:42 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B18E23168
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 07:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669215702; x=1700751702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/4NqrCmiQnItIOE9y3mIIwqfr6MTi/GnS27F2G38uAc=;
  b=edBhqesLZ4Sb9jamRAJCnXEyzuNYJJyfaMSkBTPJwr2/0tBj8E67Se/Q
   6Res5nRxkkLTUyT5wQVjQ/JyV9zfHTP3jUYKzQ+GNMUEx0b9K2Bfh5iAG
   LqPAEKDdm8OwQrZgYwzDSeLFGHkRJ0Rr0G0gGpkKqzprbkUATeapWvvjg
   eenVXBw0AA0FDphf7SxywgLDqM8ECPIQTrNcS6kRwTCfKztQn9Mddu4eE
   hFEZwVLMAvKEMeZ+NWcAN7mXFJBMZeW8TD4kMRUdTwjWW4PCZKEcEXX8/
   FEq7ELJLsYyze8sGW9tZiPbSV7cbZKq88xvTVTsCAzcLTGuJ/X3W5ec5x
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301642939"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301642939"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:01:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674750886"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674750886"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 07:01:18 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC 03/10] vfio: Wrap group codes to be helpers for __vfio_register_dev() and unregister
Date:   Wed, 23 Nov 2022 07:01:06 -0800
Message-Id: <20221123150113.670399-4-yi.l.liu@intel.com>
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

This avoids to decode group fields in the common functions used by
vfio_device registration, and prepares for further moving vfio group
specific code into separate file.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index bd45b8907311..f4af3afcb26f 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -517,6 +517,20 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	return group;
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
 		struct vfio_group *group)
 {
@@ -555,9 +569,7 @@ static int __vfio_register_dev(struct vfio_device *device,
 	/* Refcounting can't start until the driver calls register */
 	refcount_set(&device->refcount, 1);
 
-	mutex_lock(&group->device_lock);
-	list_add(&device->group_next, &group->device_list);
-	mutex_unlock(&group->device_lock);
+	vfio_device_group_register(device);
 
 	return 0;
 err_out:
@@ -617,7 +629,6 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
  * removed.  Open file descriptors for the device... */
 void vfio_unregister_group_dev(struct vfio_device *device)
 {
-	struct vfio_group *group = device->group;
 	unsigned int i = 0;
 	bool interrupted = false;
 	long rc;
@@ -645,9 +656,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
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


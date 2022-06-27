Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC42055C5D3
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbiF0HlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 03:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiF0HlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 03:41:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA0960E4
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 00:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656315683; x=1687851683;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DZ3+pBN+PPtG/ijYbnS0EYC87YFjcrU2gS3NBzyw/2c=;
  b=CZlUrol3XAw6RINv2bT7EBHy5JueCfHnp91IHgbs8mZaPL+n4RNQrzuP
   usnQloLwv2WTO0Dy8jlF/wjId4zp7G+rNs41NDnhHi3/S1xwjDOwpzClW
   UC2xFwZw7FaGtr6pkcJIyJCJsHlLt7BeR8j1lJml3mUCKVMDZkUZgXcPl
   r1yTOrm4CMt13tVAdFJw8Btgh/33Xw+l1N6c71akIeZIv1eY2zEuWWsxY
   WZMO4HWVwo9tVKgoJBc8cOj95W9LhpofKAEb6FuAd9z0vkRlPHYNEBFAm
   N2GR7ZAhWRdsHSAt4UlrtAr9PVYr6PvlPHQYD8E1Dqj5PVA1bkrdwmaSa
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="282120596"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="282120596"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 00:41:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="587344273"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 27 Jun 2022 00:41:20 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com
Cc:     yi.l.liu@intel.com, kevin.tian@intel.com, kvm@vger.kernel.org,
        jgg@nvidia.com, Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH v2] vfio: Move "device->open_count--" out of group_rwsem in vfio_device_open()
Date:   Mon, 27 Jun 2022 00:41:19 -0700
Message-Id: <20220627074119.523274-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We do not protect the vfio_device::open_count with group_rwsem elsewhere (see
vfio_device_fops_release as a comparison, where we already drop group_rwsem
before open_count--). So move the group_rwsem unlock prior to open_count--.

This change now also drops group_rswem before setting device->kvm = NULL,
but that's also OK (again, just like vfio_device_fops_release). The setting
of device->kvm before open_device is technically done while holding the
group_rwsem, this is done to protect the group kvm value we are copying from,
and we should not be relying on that to protect the contents of device->kvm;
instead we assume this value will not change until after the device is closed
and while under the dev_set->lock.

Cc: Matthew Rosato <mjrosato@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---
v2:
- Remove Fixes tag (Kevin)
- Add detailed description in commit message (Matthew, Jason)
- Fix patch format (Jason)
- Add r-b from Matthew
 
v1:
https://lore.kernel.org/kvm/20220620085459.200015-2-yi.l.liu@intel.com/
---

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 61e71c1154be..44c3bf8023ac 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1146,10 +1146,10 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	if (device->open_count == 1 && device->ops->close_device)
 		device->ops->close_device(device);
 err_undo_count:
+	up_read(&device->group->group_rwsem);
 	device->open_count--;
 	if (device->open_count == 0 && device->kvm)
 		device->kvm = NULL;
-	up_read(&device->group->group_rwsem);
 	mutex_unlock(&device->dev_set->lock);
 	module_put(device->dev->driver->owner);
 err_unassign_container:
-- 
2.27.0


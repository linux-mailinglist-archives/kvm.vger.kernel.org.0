Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CD055137D
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 10:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240332AbiFTIzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 04:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240342AbiFTIzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 04:55:21 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E7F6241
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 01:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655715320; x=1687251320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EjvmJGb9WqmBIvjEVatOotkX/ZbBGMzRMBL3aNS7huQ=;
  b=OOOg2qJ+yGJIunpQQ8cqptVjDyjEB9GdJb4UIcnQirGF54sOG1YlnuTa
   K45PbKG6QSSUQskYz3q6JyfwKthVjEW+A0V320SAyXj4vFazGKzk72U+Q
   aGKelEX/qvqn0tVfISnharpvc2jK2LA4SMf6A7u8DWsXz5bETWebokEhM
   XE4ABZp9ql5xYGm5q554oxu3JngCsHKb3bZ3apv/EQN4aQC0fevqNDDp3
   3yub6mzNbmp2rckpwM46+olLerxppXb7Sgn6ZOGSwn5cBIxmklegsG/cs
   D6cRSbG5nqCZkvJC4CSLegcAjyFeYeNu2gO/v1hJeYo2qNjzWVLz3SGbb
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280572549"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="280572549"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 01:55:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="913563715"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 20 Jun 2022 01:55:19 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com
Cc:     yi.l.liu@intel.com, kevin.tian@intel.com, kvm@vger.kernel.org,
        jgg@nvidia.com, Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [Patch 1/1] vfio: Move "device->open_count--" out of group_rwsem in vfio_device_open()
Date:   Mon, 20 Jun 2022 01:54:59 -0700
Message-Id: <20220620085459.200015-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220620085459.200015-1-yi.l.liu@intel.com>
References: <20220620085459.200015-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need to protect open_count with group_rwsem

Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")

cc: Matthew Rosato <mjrosato@linux.ibm.com>
cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


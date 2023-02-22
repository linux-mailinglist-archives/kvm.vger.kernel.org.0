Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F7269EFEC
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 09:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjBVINq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 03:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjBVINp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 03:13:45 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42793AD12;
        Wed, 22 Feb 2023 00:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677053622; x=1708589622;
  h=from:to:cc:subject:date:message-id;
  bh=qJcai1HxyJhUZs8xkP6Kzc6D6zv9YtIedUROjHo5Cc0=;
  b=nyTmJWdX2Qm6/3B3MBojmuchqjHvsLHDTGDBsUhRAr2Qb+l4Co8WXdm7
   13VwuxdkMTrTuq4OPMS4GtYrknWBUKOUwGs1T/Qj87K/SN90dTMUXARZU
   NrFJEF8wqt1hzBrsE365jE0wF9sG/GN+5dCQDA6Xqi2D+uKWJO/EaUeED
   +eStav9eryPu7ILPs8g9OnGhuT86tBRsdvWepzXPO2GDqjPzNyzGJRXnf
   ojKApsflX5yPWNIdgy1cEih5Rz0WMP1V3n2Qz6fntHuHuICRcEK7OmeNY
   i0v24lP7Ekh1YKb4n4xeQOLviRXhbvrTulh84nKO2/dQJGDYkuAwjgvi0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="395346717"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="395346717"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 00:13:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="649471253"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="649471253"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 00:13:39 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     yi.l.liu@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] vfio: Fix NULL pointer dereference caused by uninitialized group->iommufd
Date:   Wed, 22 Feb 2023 15:49:38 +0800
Message-Id: <20230222074938.13681-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

group->iommufd is not initialized for the iommufd_ctx_put()

[20018.331541] BUG: kernel NULL pointer dereference, address: 0000000000000000
[20018.377508] RIP: 0010:iommufd_ctx_put+0x5/0x10 [iommufd]
...
[20018.476483] Call Trace:
[20018.479214]  <TASK>
[20018.481555]  vfio_group_fops_unl_ioctl+0x506/0x690 [vfio]
[20018.487586]  __x64_sys_ioctl+0x6a/0xb0
[20018.491773]  ? trace_hardirqs_on+0xc5/0xe0
[20018.496347]  do_syscall_64+0x67/0x90
[20018.500340]  entry_SYSCALL_64_after_hwframe+0x4b/0xb5

Fixes: 9eefba8002c2 ("vfio: Move vfio group specific code into group.c")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/group.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 57ebe5e1a7e6..8649f85f3be4 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -137,7 +137,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 
 		ret = iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
 		if (ret) {
-			iommufd_ctx_put(group->iommufd);
+			iommufd_ctx_put(iommufd);
 			goto out_unlock;
 		}
 
-- 
2.17.1


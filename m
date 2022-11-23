Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EDE63629F
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 16:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbiKWPBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 10:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236825AbiKWPBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 10:01:43 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2C827DCA
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 07:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669215702; x=1700751702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PwiAs86ZLrf+mIJnYP/07vQN3vXUZ7vvcIxFyZKtgCU=;
  b=LUNRsVHL76txGnGZFh33xkoLK/jTJEuF38JnLCpYaNYot9gaWoRldrLc
   HqxcV3C7Xa/eTPEnUXiqYqCjiGRhVyO08KGTYU44ZsvDuHdm88meG9uwh
   dSh5DZKNOcYSVSn5msu70sRHcYyPYB7Mfi0VDOfbozWb/PlPfra0La4vY
   ZpUX7Ph/3NKKFbDAXnI7kMCAefh20JqGjINSOK8fTi2ocrqMZpIJ92CQl
   K4mKmM87l4+TOsN2CPu+fUd0Y1BVIlYBrGCZWbF5t2BiiOjg83EzQkEeA
   aBjZYIYnowaCb6OsMnfd9uZ3CdA03fPEeAeuDLgH+wXmYgX5fwbGMo/Cw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301642950"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301642950"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:01:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674750897"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674750897"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 07:01:19 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC 04/10] vfio: Make vfio_device_open() group agnostic
Date:   Wed, 23 Nov 2022 07:01:07 -0800
Message-Id: <20221123150113.670399-5-yi.l.liu@intel.com>
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

This prepares for moving group specific code to separate file.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f4af3afcb26f..5e1e509e6477 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -878,9 +878,6 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	 */
 	filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
 
-	if (device->group->type == VFIO_NO_IOMMU)
-		dev_warn(device->dev, "vfio-noiommu device opened by user "
-			 "(%s:%d)\n", current->comm, task_pid_nr(current));
 	/*
 	 * On success the ref of device is moved to the file and
 	 * put in vfio_device_fops_release()
@@ -927,6 +924,10 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
 		goto err_put_fdno;
 	}
 
+	if (group->type == VFIO_NO_IOMMU)
+		dev_warn(device->dev, "vfio-noiommu device opened by user "
+			 "(%s:%d)\n", current->comm, task_pid_nr(current));
+
 	fd_install(fdno, filep);
 	return fdno;
 
-- 
2.34.1


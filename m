Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881296378DA
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiKXM12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiKXM1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:27:20 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420A1E0DE2
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669292837; x=1700828837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MrptOv6NFZ/R8UhvjeEKSvqSN/6m+HdF5dplvW64VCM=;
  b=mWT8vIaRJud0yX1KCTI2AYwAQTEuSTgm8krJ3JjWCP1ZWo01FY0BXbKx
   pp6KeuOrGVIAybzVQxH9kl2Drr8jdF+oDAjW29/iSu+4nnVMdTHgnTgap
   BzIyniZCyycN4Mc1BFG4E6czPI9i0K4K3hMoVs9H8u52VJtc42VXvdCNU
   Q7HRhwnYAhQZXR7y/9acTspHecaSHYRQM3mWj81ii8ENwGwtEfoJb5pe6
   MHZgJ/ScQLxTrKS9DubjT6F2Gql3DkSEzJJtJ7SEFPSGE2qSGhkgmjeCY
   aFQMrAnw/1oBqcmhj0rmIu+OrBd4nbIuz6ZUvRf/VRKVmlZYOr8KsGZ8S
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297649638"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="297649638"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:27:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642337177"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642337177"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 04:27:15 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC v2 05/11] vfio: Make vfio_device_open() group agnostic
Date:   Thu, 24 Nov 2022 04:26:56 -0800
Message-Id: <20221124122702.26507-6-yi.l.liu@intel.com>
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

This prepares for moving group specific code to separate file.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index edcfa8a61096..fcb9f778fc9b 100644
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


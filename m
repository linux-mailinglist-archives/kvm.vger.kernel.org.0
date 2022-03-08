Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF4A4D0F6A
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 06:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbiCHFsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 00:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344431AbiCHFsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 00:48:03 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826EF3BF9D;
        Mon,  7 Mar 2022 21:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646718423; x=1678254423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K4d6QHEKwzTDQ/LYRt9IgEhDxSN9f2FvweDjvEliLbM=;
  b=n5QVQZY03D8wZmFDWBpKnevmQn+HgDEnC4BZmLPhbgJ07D1/fip+pBlR
   2/NZQFCBJGc/ItWKo0TkrIW9fDakLo0+4lXx3JYy7g0rmQbjO2OneYPqu
   cmFO1VHM++1iecT9xDdHn5A0prebc/weF1pJNuTpNaz5RxzstnacQitOg
   ifdQRwAn1I7doCWjNMDomYPmNWYbiJh2bf2L2q3HdNb0ogtA/FmjbNed2
   0XwKMjCm9XCzPuHsg555lld39bcABa5lmdM++bURN8R9UyEvNWOYNBXH8
   MyfrTcE0SsJIXoeVfQwlGlc0orQsviaFmfOX90EckMOWltdXChSI9MldF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254539437"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254539437"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 21:47:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="537430267"
Received: from allen-box.sh.intel.com ([10.239.159.48])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2022 21:46:55 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v8 08/11] vfio: Remove use of vfio_group_viable()
Date:   Tue,  8 Mar 2022 13:44:18 +0800
Message-Id: <20220308054421.847385-9-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308054421.847385-1-baolu.lu@linux.intel.com>
References: <20220308054421.847385-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As DMA ownership is claimed for the iommu group when a VFIO group is
added to a VFIO container, the VFIO group viability is guaranteed as long
as group->container_users > 0. Remove those unnecessary group viability
checks which are only hit when group->container_users is not zero.

The only remaining reference is in GROUP_GET_STATUS, which could be called
at any time when group fd is valid. Here we just replace the
vfio_group_viable() by directly calling IOMMU core to get viability status.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index df9d4b60e5ae..73034446e03f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1313,12 +1313,6 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	return ret;
 }
 
-static bool vfio_group_viable(struct vfio_group *group)
-{
-	return (iommu_group_for_each_dev(group->iommu_group,
-					 group, vfio_dev_viable) == 0);
-}
-
 static int vfio_group_add_container_user(struct vfio_group *group)
 {
 	if (!atomic_inc_not_zero(&group->container_users))
@@ -1328,7 +1322,7 @@ static int vfio_group_add_container_user(struct vfio_group *group)
 		atomic_dec(&group->container_users);
 		return -EPERM;
 	}
-	if (!group->container->iommu_driver || !vfio_group_viable(group)) {
+	if (!group->container->iommu_driver) {
 		atomic_dec(&group->container_users);
 		return -EINVAL;
 	}
@@ -1346,7 +1340,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	int ret = 0;
 
 	if (0 == atomic_read(&group->container_users) ||
-	    !group->container->iommu_driver || !vfio_group_viable(group))
+	    !group->container->iommu_driver)
 		return -EINVAL;
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
@@ -1438,11 +1432,11 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 
 		status.flags = 0;
 
-		if (vfio_group_viable(group))
-			status.flags |= VFIO_GROUP_FLAGS_VIABLE;
-
 		if (group->container)
-			status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET;
+			status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
+					VFIO_GROUP_FLAGS_VIABLE;
+		else if (!iommu_group_dma_owner_claimed(group->iommu_group))
+			status.flags |= VFIO_GROUP_FLAGS_VIABLE;
 
 		if (copy_to_user((void __user *)arg, &status, minsz))
 			return -EFAULT;
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA5244FD02
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 03:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbhKOCQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 21:16:28 -0500
Received: from mga05.intel.com ([192.55.52.43]:53956 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236317AbhKOCOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Nov 2021 21:14:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="319573956"
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="319573956"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2021 18:11:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="505714687"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2021 18:11:03 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 08/11] vfio: Remove use of vfio_group_viable()
Date:   Mon, 15 Nov 2021 10:05:49 +0800
Message-Id: <20211115020552.2378167-9-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As DMA_OWNER_USER is claimed for the iommu group when a vfio group is
added to a vfio container, the vfio group viability is guaranteed as
long as group->container_users > 0. Remove those unnecessary group
viability checks which are only hit when group->container_users is not
zero.

The only remaining reference is in GROUP_GET_STATUS, which could be
called at any time when group fd is valid. Here we just replace the
vfio_group_viable() by directly calling iommu core to get viability
status.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/vfio.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 4e21b37e0ea8..6847117fac6a 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1315,12 +1315,6 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
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
@@ -1330,7 +1324,7 @@ static int vfio_group_add_container_user(struct vfio_group *group)
 		atomic_dec(&group->container_users);
 		return -EPERM;
 	}
-	if (!group->container->iommu_driver || !vfio_group_viable(group)) {
+	if (!group->container->iommu_driver) {
 		atomic_dec(&group->container_users);
 		return -EINVAL;
 	}
@@ -1348,7 +1342,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	int ret = 0;
 
 	if (0 == atomic_read(&group->container_users) ||
-	    !group->container->iommu_driver || !vfio_group_viable(group))
+	    !group->container->iommu_driver)
 		return -EINVAL;
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
@@ -1440,11 +1434,11 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 
 		status.flags = 0;
 
-		if (vfio_group_viable(group))
-			status.flags |= VFIO_GROUP_FLAGS_VIABLE;
-
 		if (group->container)
-			status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET;
+			status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
+					VFIO_GROUP_FLAGS_VIABLE;
+		else if (iommu_group_dma_owner_unclaimed(group->iommu_group))
+			status.flags |= VFIO_GROUP_FLAGS_VIABLE;
 
 		if (copy_to_user((void __user *)arg, &status, minsz))
 			return -EFAULT;
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D84244FD0A
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 03:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhKOCRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 21:17:45 -0500
Received: from mga17.intel.com ([192.55.52.151]:40570 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236341AbhKOCNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Nov 2021 21:13:52 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="214088760"
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="214088760"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2021 18:10:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="505714599"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2021 18:10:47 -0800
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
Subject: [PATCH 05/11] iommu: Add security context management for assigned devices
Date:   Mon, 15 Nov 2021 10:05:46 +0800
Message-Id: <20211115020552.2378167-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an iommu group has DMA_OWNER_USER set for the first time, it is a
contract that the group could be assigned to userspace from now on. It
must be detached from the default iommu domain and all devices in this
group are blocked from doing DMA until it is attached to a user I/O
address space. Vice versa, the default domain should be re-attached to
the group after the last DMA_OWNER_USER is released.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 39493b1b3edf..916a4d448150 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -293,7 +293,11 @@ int iommu_probe_device(struct device *dev)
 	mutex_lock(&group->mutex);
 	iommu_alloc_default_domain(group, dev);
 
-	if (group->default_domain) {
+	/*
+	 * If any device in the group has been initialized for user dma,
+	 * avoid attaching the default domain.
+	 */
+	if (group->default_domain && group->dma_owner != DMA_OWNER_USER) {
 		ret = __iommu_attach_device(group->default_domain, dev);
 		if (ret) {
 			mutex_unlock(&group->mutex);
@@ -2325,7 +2329,7 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 {
 	int ret;
 
-	if (group->default_domain && group->domain != group->default_domain)
+	if (group->domain && group->domain != group->default_domain)
 		return -EBUSY;
 
 	ret = __iommu_group_for_each_dev(group, domain,
@@ -2362,7 +2366,11 @@ static void __iommu_detach_group(struct iommu_domain *domain,
 {
 	int ret;
 
-	if (!group->default_domain) {
+	/*
+	 * If any device in the group has been initialized for user dma,
+	 * avoid re-attaching the default domain.
+	 */
+	if (!group->default_domain || group->dma_owner == DMA_OWNER_USER) {
 		__iommu_group_for_each_dev(group, domain,
 					   iommu_group_do_detach_device);
 		group->domain = NULL;
@@ -3377,6 +3385,21 @@ static int __iommu_group_set_dma_owner(struct iommu_group *group,
 		refcount_set(&group->owner_cnt, 1);
 
 		if (owner == DMA_OWNER_USER) {
+			/*
+			 * The UNMANAGED domain shouldn't be attached before
+			 * claiming the USER ownership for the first time.
+			 */
+			if (group->domain) {
+				if (group->domain != group->default_domain) {
+					group->dma_owner = DMA_OWNER_NONE;
+					refcount_set(&group->owner_cnt, 0);
+
+					return -EBUSY;
+				}
+
+				__iommu_detach_group(group->domain, group);
+			}
+
 			get_file(user_file);
 			group->owner_user_file = user_file;
 		}
@@ -3397,6 +3420,13 @@ static void __iommu_group_release_dma_owner(struct iommu_group *group,
 		if (owner == DMA_OWNER_USER) {
 			fput(group->owner_user_file);
 			group->owner_user_file = NULL;
+
+			/*
+			 * The UNMANAGED domain should be detached before all USER
+			 * owners have been released.
+			 */
+			if (!WARN_ON(group->domain) && group->default_domain)
+				__iommu_attach_group(group->default_domain, group);
 		}
 	}
 }
-- 
2.25.1


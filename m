Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9B3460335
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 03:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351513AbhK1C5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 21:57:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:64278 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239838AbhK1CzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 21:55:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10181"; a="235619889"
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="235619889"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2021 18:52:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="652489062"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 27 Nov 2021 18:51:59 -0800
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
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 09/17] iommu: Add security context management for assigned devices
Date:   Sun, 28 Nov 2021 10:50:43 +0800
Message-Id: <20211128025051.355578-10-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211128025051.355578-1-baolu.lu@linux.intel.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an iommu group has DMA_OWNER_PRIVATE_DOMAIN_USER set for the first
time, it is a contract that the group could be assigned to userspace from
now on. The group must be detached from the default iommu domain and all
devices in this group are blocked from doing DMA until it is attached to a
user controlled iommu_domain. Correspondingly, the default domain should
be reattached after the last DMA_OWNER_USER is released.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1de520a07518..0cba04a8ea3b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -292,7 +292,12 @@ int iommu_probe_device(struct device *dev)
 	mutex_lock(&group->mutex);
 	iommu_alloc_default_domain(group, dev);
 
-	if (group->default_domain) {
+	/*
+	 * If any device in the group has been initialized for user dma,
+	 * avoid attaching the default domain.
+	 */
+	if (group->default_domain &&
+	    group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN_USER) {
 		ret = __iommu_attach_device(group->default_domain, dev);
 		if (ret) {
 			mutex_unlock(&group->mutex);
@@ -2324,7 +2329,7 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 {
 	int ret;
 
-	if (group->default_domain && group->domain != group->default_domain)
+	if (group->domain && group->domain != group->default_domain)
 		return -EBUSY;
 
 	ret = __iommu_group_for_each_dev(group, domain,
@@ -2361,7 +2366,12 @@ static void __iommu_detach_group(struct iommu_domain *domain,
 {
 	int ret;
 
-	if (!group->default_domain) {
+	/*
+	 * If any device in the group has been initialized for user dma,
+	 * avoid re-attaching the default domain.
+	 */
+	if (!group->default_domain ||
+	    group->dma_owner == DMA_OWNER_PRIVATE_DOMAIN_USER) {
 		__iommu_group_for_each_dev(group, domain,
 					   iommu_group_do_detach_device);
 		group->domain = NULL;
@@ -3371,6 +3381,23 @@ static int __iommu_group_set_dma_owner(struct iommu_group *group,
 	}
 
 	group->dma_owner = owner;
+
+	/*
+	 * We must ensure that any device DMAs issued after this call
+	 * are discarded. DMAs can only reach real memory once someone
+	 * has attached a real domain.
+	 */
+	if (owner == DMA_OWNER_PRIVATE_DOMAIN_USER) {
+		if (group->domain) {
+			if (group->domain != group->default_domain) {
+				group->dma_owner = DMA_OWNER_NONE;
+				return -EBUSY;
+			}
+
+			__iommu_detach_group(group->domain, group);
+		}
+	}
+
 	group->owner_cookie = owner_cookie;
 	refcount_set(&group->owner_cnt, 1);
 
@@ -3387,6 +3414,15 @@ static void __iommu_group_release_dma_owner(struct iommu_group *group,
 		return;
 
 	group->dma_owner = DMA_OWNER_NONE;
+
+	/*
+	 * The UNMANAGED domain should be detached before all USER
+	 * owners have been released.
+	 */
+	if (owner == DMA_OWNER_PRIVATE_DOMAIN_USER) {
+		if (!WARN_ON(group->domain) && group->default_domain)
+			__iommu_attach_group(group->default_domain, group);
+	}
 }
 
 /**
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCACD485E94
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 03:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344703AbiAFCWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 21:22:06 -0500
Received: from mga18.intel.com ([134.134.136.126]:45646 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbiAFCWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 21:22:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641435723; x=1672971723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6YLQxZeVjKNGLWHBhbTA2BZXJ8CXUGVnJDAzUyu/JQ8=;
  b=dOXqKwqh645TYN6QVRP1EvlzKn3p/ZxwzbGR1je8o52TWuj9c6JGh4Bp
   LOJSaDkAsUfcmqJ/LvYwHqKKDmOzsvOeEe6b41tHBIgQpe1zaf7bm4ZbC
   gVWIyt+cm/379z5QpOvJtDBnx9wZI00MRvo5F5N40gXAwL0diuhIfHtPH
   u/CULbfEknDes6fH25QxGT3kr76zkRMTtyQ7Tch8AAVKVywsxI52wl1Wq
   yHwg5JAKMiL+I5mPSWuNBPywD/+lA0ocEUPNQ9S2P5Sds8LtIszk66ts9
   qkmfO1OWqrckuv7Er00IdoEr8aN5MFMN8swYX2Q52SCESbIjG+Yr8AEpx
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229389174"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="229389174"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 18:22:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526794313"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 18:21:56 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
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
Subject: [PATCH v1 2/8] vfio/type1: Use iommu_group_replace_domain()
Date:   Thu,  6 Jan 2022 10:20:47 +0800
Message-Id: <20220106022053.2406748-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After an IOMMU group is placed in a vfio container, the domain attachment
may be deferred. During this process, other kernel modules can attach
another domain simply in the following way:

	group = iommu_group_get(dev);
	iommu_attach_group(domain, group);

Replace the iommu_attach/detach_group() with iommu_group_replace_domain()
and prohibit use of iommu_attach/detach_group() in other kernel drivers
can solve this problem.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f17490ab238f..25276a5db737 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2213,7 +2213,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			goto out_domain;
 	}
 
-	ret = iommu_attach_group(domain->domain, group->iommu_group);
+	ret = iommu_group_replace_domain(group->iommu_group, NULL,
+					 domain->domain);
 	if (ret)
 		goto out_domain;
 
@@ -2280,19 +2281,14 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		if (d->domain->ops == domain->domain->ops &&
 		    d->prot == domain->prot) {
-			iommu_detach_group(domain->domain, group->iommu_group);
-			if (!iommu_attach_group(d->domain,
-						group->iommu_group)) {
+			if (!iommu_group_replace_domain(group->iommu_group,
+							domain->domain,
+							d->domain)) {
 				list_add(&group->next, &d->group_list);
 				iommu_domain_free(domain->domain);
 				kfree(domain);
 				goto done;
 			}
-
-			ret = iommu_attach_group(domain->domain,
-						 group->iommu_group);
-			if (ret)
-				goto out_domain;
 		}
 	}
 
@@ -2327,7 +2323,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	return 0;
 
 out_detach:
-	iommu_detach_group(domain->domain, group->iommu_group);
+	iommu_group_replace_domain(group->iommu_group, domain->domain, NULL);
 out_domain:
 	iommu_domain_free(domain->domain);
 	vfio_iommu_iova_free(&iova_copy);
@@ -2488,7 +2484,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		if (!group)
 			continue;
 
-		iommu_detach_group(domain->domain, group->iommu_group);
+		iommu_group_replace_domain(group->iommu_group,
+					   domain->domain, NULL);
 		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
 		kfree(group);
@@ -2577,7 +2574,8 @@ static void vfio_release_domain(struct vfio_domain *domain)
 
 	list_for_each_entry_safe(group, group_tmp,
 				 &domain->group_list, next) {
-		iommu_detach_group(domain->domain, group->iommu_group);
+		iommu_group_replace_domain(group->iommu_group,
+					   domain->domain, NULL);
 		list_del(&group->next);
 		kfree(group);
 	}
-- 
2.25.1


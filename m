Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E15264471
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgIJKoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:44:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:21877 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbgIJKoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:44:08 -0400
IronPort-SDR: khcOLJyjDHHlkb7Vh1LCHM6nv8+jLFfwglwCBmwZvQwE34e9hNOOueJwV8IZE6i8baTqdorKez
 0aLDjvCOlQpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="220066282"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="220066282"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 03:43:34 -0700
IronPort-SDR: Wm6FZY+c24JMeV7DD2tnSCPCxuoFzo+6aCH6CABB8r5jBMJ8MkH/rihbgYvZ/LseNNsevjVo/q
 t/iTb5uzcGyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="334137186"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 03:43:34 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH v7 03/16] vfio/type1: Report iommu nesting info to userspace
Date:   Thu, 10 Sep 2020 03:45:20 -0700
Message-Id: <1599734733-6431-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch exports iommu nesting capability info to user space through
VFIO. Userspace is expected to check this info for supported uAPIs (e.g.
PASID alloc/free, bind page table, and cache invalidation) and the vendor
specific format information for first level/stage page table that will be
bound to.

The nesting info is available only after container set to be NESTED type.
Current implementation imposes one limitation - one nesting container
should include at most one iommu group. The philosophy of vfio container
is having all groups/devices within the container share the same IOMMU
context. When vSVA is enabled, one IOMMU context could include one 2nd-
level address space and multiple 1st-level address spaces. While the
2nd-level address space is reasonably sharable by multiple groups, blindly
sharing 1st-level address spaces across all groups within the container
might instead break the guest expectation. In the future sub/super container
concept might be introduced to allow partial address space sharing within
an IOMMU context. But for now let's go with this restriction by requiring
singleton container for using nesting iommu features. Below link has the
related discussion about this decision.

https://lore.kernel.org/kvm/20200515115924.37e6996d@w520.home/

This patch also changes the NESTING type container behaviour. Something
that would have succeeded before will now fail: Before this series, if
user asked for a VFIO_IOMMU_TYPE1_NESTING, it would have succeeded even
if the SMMU didn't support stage-2, as the driver would have silently
fallen back on stage-1 mappings (which work exactly the same as stage-2
only since there was no nesting supported). After the series, we do check
for DOMAIN_ATTR_NESTING so if user asks for VFIO_IOMMU_TYPE1_NESTING and
the SMMU doesn't support stage-2, the ioctl fails. But it should be a good
fix and completely harmless. Detail can be found in below link as well.

https://lore.kernel.org/kvm/20200717090900.GC4850@myrica/

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
v6 -> v7:
*) using vfio_info_add_capability() for adding nesting cap per suggestion
   from Eric.

v5 -> v6:
*) address comments against v5 from Eric Auger.
*) don't report nesting cap to userspace if the nesting_info->format is
   invalid.

v4 -> v5:
*) address comments from Eric Auger.
*) return struct iommu_nesting_info for VFIO_IOMMU_TYPE1_INFO_CAP_NESTING as
   cap is much "cheap", if needs extension in future, just define another cap.
   https://lore.kernel.org/kvm/20200708132947.5b7ee954@x1.home/

v3 -> v4:
*) address comments against v3.

v1 -> v2:
*) added in v2
---
 drivers/vfio/vfio_iommu_type1.c | 92 +++++++++++++++++++++++++++++++++++------
 include/uapi/linux/vfio.h       | 19 +++++++++
 2 files changed, 99 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c992973..3c0048b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -62,18 +62,20 @@ MODULE_PARM_DESC(dma_entry_limit,
 		 "Maximum number of user DMA mappings per container (65535).");
 
 struct vfio_iommu {
-	struct list_head	domain_list;
-	struct list_head	iova_list;
-	struct vfio_domain	*external_domain; /* domain for external user */
-	struct mutex		lock;
-	struct rb_root		dma_list;
-	struct blocking_notifier_head notifier;
-	unsigned int		dma_avail;
-	uint64_t		pgsize_bitmap;
-	bool			v2;
-	bool			nesting;
-	bool			dirty_page_tracking;
-	bool			pinned_page_dirty_scope;
+	struct list_head		domain_list;
+	struct list_head		iova_list;
+	/* domain for external user */
+	struct vfio_domain		*external_domain;
+	struct mutex			lock;
+	struct rb_root			dma_list;
+	struct blocking_notifier_head	notifier;
+	unsigned int			dma_avail;
+	uint64_t			pgsize_bitmap;
+	bool				v2;
+	bool				nesting;
+	bool				dirty_page_tracking;
+	bool				pinned_page_dirty_scope;
+	struct iommu_nesting_info	*nesting_info;
 };
 
 struct vfio_domain {
@@ -130,6 +132,9 @@ struct vfio_regions {
 #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
 					(!list_empty(&iommu->domain_list))
 
+#define CONTAINER_HAS_DOMAIN(iommu)	(((iommu)->external_domain) || \
+					 (!list_empty(&(iommu)->domain_list)))
+
 #define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
 
 /*
@@ -1992,6 +1997,13 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 
 	list_splice_tail(iova_copy, iova);
 }
+
+static void vfio_iommu_release_nesting_info(struct vfio_iommu *iommu)
+{
+	kfree(iommu->nesting_info);
+	iommu->nesting_info = NULL;
+}
+
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 					 struct iommu_group *iommu_group)
 {
@@ -2022,6 +2034,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		}
 	}
 
+	/* Nesting type container can include only one group */
+	if (iommu->nesting && CONTAINER_HAS_DOMAIN(iommu)) {
+		mutex_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!group || !domain) {
@@ -2092,6 +2110,25 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_domain;
 
+	/* Nesting cap info is available only after attaching */
+	if (iommu->nesting) {
+		int size = sizeof(struct iommu_nesting_info);
+
+		iommu->nesting_info = kzalloc(size, GFP_KERNEL);
+		if (!iommu->nesting_info) {
+			ret = -ENOMEM;
+			goto out_detach;
+		}
+
+		/* Now get the nesting info */
+		iommu->nesting_info->argsz = size;
+		ret = iommu_domain_get_attr(domain->domain,
+					    DOMAIN_ATTR_NESTING,
+					    iommu->nesting_info);
+		if (ret)
+			goto out_detach;
+	}
+
 	/* Get aperture info */
 	iommu_domain_get_attr(domain->domain, DOMAIN_ATTR_GEOMETRY, &geo);
 
@@ -2201,6 +2238,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	return 0;
 
 out_detach:
+	vfio_iommu_release_nesting_info(iommu);
 	vfio_iommu_detach_group(domain, group);
 out_domain:
 	iommu_domain_free(domain->domain);
@@ -2401,6 +2439,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 					vfio_iommu_unmap_unpin_all(iommu);
 				else
 					vfio_iommu_unmap_unpin_reaccount(iommu);
+
+				vfio_iommu_release_nesting_info(iommu);
 			}
 			iommu_domain_free(domain->domain);
 			list_del(&domain->next);
@@ -2609,6 +2649,32 @@ static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
 	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
 }
 
+static int vfio_iommu_add_nesting_cap(struct vfio_iommu *iommu,
+				      struct vfio_info_cap *caps)
+{
+	struct vfio_iommu_type1_info_cap_nesting nesting_cap;
+	size_t size;
+
+	/* when nesting_info is null, no need to go further */
+	if (!iommu->nesting_info)
+		return 0;
+
+	/* when @format of nesting_info is 0, fail the call */
+	if (iommu->nesting_info->format == 0)
+		return -ENOENT;
+
+	size = offsetof(struct vfio_iommu_type1_info_cap_nesting, info) +
+	       iommu->nesting_info->argsz;
+
+	nesting_cap.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_NESTING;
+	nesting_cap.header.version = 1;
+
+	memcpy(&nesting_cap.info, iommu->nesting_info,
+	       iommu->nesting_info->argsz);
+
+	return vfio_info_add_capability(caps, &nesting_cap.header, size);
+}
+
 static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
 				     unsigned long arg)
 {
@@ -2644,6 +2710,8 @@ static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
 	if (!ret)
 		ret = vfio_iommu_iova_build_caps(iommu, &caps);
 
+	ret = vfio_iommu_add_nesting_cap(iommu, &caps);
+
 	mutex_unlock(&iommu->lock);
 
 	if (ret)
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9204705..ff40f9e 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/iommu.h>
 
 #define VFIO_API_VERSION	0
 
@@ -1039,6 +1040,24 @@ struct vfio_iommu_type1_info_cap_migration {
 	__u64	max_dirty_bitmap_size;		/* in bytes */
 };
 
+/*
+ * The nesting capability allows to report the related capability
+ * and info for nesting iommu type.
+ *
+ * The structures below define version 1 of this capability.
+ *
+ * Nested capabilities should be checked by the userspace after
+ * setting VFIO_TYPE1_NESTING_IOMMU.
+ *
+ * @info: the nesting info provided by IOMMU driver.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  3
+
+struct vfio_iommu_type1_info_cap_nesting {
+	struct	vfio_info_cap_header header;
+	struct	iommu_nesting_info info;
+};
+
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
 
 /**
-- 
2.7.4


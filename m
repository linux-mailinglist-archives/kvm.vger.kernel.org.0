Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A126378DE
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiKXM1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiKXM1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:27:21 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADD1E6360
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669292840; x=1700828840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ul5zAyyc+tqp2fcGoW6ytw1FlRddrB0yf21hmWtq06Y=;
  b=lBkrlhswRFy9mKQYIdJ7tLN8OoQIvK9iDcgD4sljSfSLXQoMCV6fA0GX
   hh6oA0pUOy/n9SATlFxI/4x9cwv0j3x0UoxjK8RkggK5Eccvoi896aD+I
   xh+BxFkBYrRWeWZBmUJhHuMPpxfMJRafFjF9WTFW9NEsY3RHwfvX3wtnr
   /9p/xmRzYI8QINgKMnCj112g3DPjF5iyqN0RscXWfOmKgILRFZyPByfws
   FD1gH3Xu77hJSQG5PyENFWUOpRQVMHHl8XOuuegF4ticegR7vqKAg3t4K
   vJXQiG/Yll6g72Yrrg3hm1bBJShIe7Qnp0v7N0mZxp01ZNPIkMwU2ixY5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297649648"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="297649648"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:27:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642337206"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642337206"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 04:27:17 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC v2 10/11] vfio: Refactor dma APIs for emulated devices
Date:   Thu, 24 Nov 2022 04:27:01 -0800
Message-Id: <20221124122702.26507-11-yi.l.liu@intel.com>
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

To use group helpers instead of opening group related code in the
API. This prepares moving group specific code out of vfio_main.c.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/container.c | 20 +++++++++++++-------
 drivers/vfio/vfio.h      | 32 ++++++++++++++++----------------
 drivers/vfio/vfio_main.c | 25 ++++++++++++++-----------
 3 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index 6b362d97d682..b7a9560ab25e 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -540,10 +540,12 @@ void vfio_group_unuse_container(struct vfio_group *group)
 	fput(group->opened_file);
 }
 
-int vfio_container_pin_pages(struct vfio_container *container,
-			     struct iommu_group *iommu_group, dma_addr_t iova,
-			     int npage, int prot, struct page **pages)
+int vfio_device_container_pin_pages(struct vfio_device *device,
+				    dma_addr_t iova, int npage,
+				    int prot, struct page **pages)
 {
+	struct vfio_container *container = device->group->container;
+	struct iommu_group *iommu_group = device->group->iommu_group;
 	struct vfio_iommu_driver *driver = container->iommu_driver;
 
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
@@ -555,9 +557,11 @@ int vfio_container_pin_pages(struct vfio_container *container,
 				      npage, prot, pages);
 }
 
-void vfio_container_unpin_pages(struct vfio_container *container,
-				dma_addr_t iova, int npage)
+void vfio_device_container_unpin_pages(struct vfio_device *device,
+				       dma_addr_t iova, int npage)
 {
+	struct vfio_container *container = device->group->container;
+
 	if (WARN_ON(npage <= 0 || npage > VFIO_PIN_PAGES_MAX_ENTRIES))
 		return;
 
@@ -565,9 +569,11 @@ void vfio_container_unpin_pages(struct vfio_container *container,
 						  npage);
 }
 
-int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
-			  void *data, size_t len, bool write)
+int vfio_device_container_dma_rw(struct vfio_device *device,
+				 dma_addr_t iova, void *data,
+				 size_t len, bool write)
 {
+	struct vfio_container *container = device->group->container;
 	struct vfio_iommu_driver *driver = container->iommu_driver;
 
 	if (unlikely(!driver || !driver->ops->dma_rw))
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 3378714a7462..d7c631b43ac1 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -122,13 +122,14 @@ int vfio_container_attach_group(struct vfio_container *container,
 void vfio_group_detach_container(struct vfio_group *group);
 void vfio_device_container_register(struct vfio_device *device);
 void vfio_device_container_unregister(struct vfio_device *device);
-int vfio_container_pin_pages(struct vfio_container *container,
-			     struct iommu_group *iommu_group, dma_addr_t iova,
-			     int npage, int prot, struct page **pages);
-void vfio_container_unpin_pages(struct vfio_container *container,
-				dma_addr_t iova, int npage);
-int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
-			  void *data, size_t len, bool write);
+int vfio_device_container_pin_pages(struct vfio_device *device,
+				    dma_addr_t iova, int npage,
+				    int prot, struct page **pages);
+void vfio_device_container_unpin_pages(struct vfio_device *device,
+				       dma_addr_t iova, int npage);
+int vfio_device_container_dma_rw(struct vfio_device *device,
+				 dma_addr_t iova, void *data,
+				 size_t len, bool write);
 
 int __init vfio_container_init(void);
 void vfio_container_cleanup(void);
@@ -166,22 +167,21 @@ static inline void vfio_device_container_unregister(struct vfio_device *device)
 {
 }
 
-static inline int vfio_container_pin_pages(struct vfio_container *container,
-					   struct iommu_group *iommu_group,
-					   dma_addr_t iova, int npage, int prot,
-					   struct page **pages)
+static inline int vfio_device_container_pin_pages(struct vfio_group *group,
+						  dma_addr_t iova, int npage,
+						  int prot, struct page **pages)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void vfio_container_unpin_pages(struct vfio_container *container,
-					      dma_addr_t iova, int npage)
+static inline void vfio_device_container_unpin_pages(struct vfio_group *group,
+						     dma_addr_t iova, int npage)
 {
 }
 
-static inline int vfio_container_dma_rw(struct vfio_container *container,
-					dma_addr_t iova, void *data, size_t len,
-					bool write)
+static inline int vfio_device_container_dma_rw(struct vfio_device *device,
+					       dma_addr_t iova, void *data,
+					       size_t len, bool write)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a0c699b3e3d9..b6353b054899 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1959,6 +1959,11 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 }
 EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
 
+static bool vfio_device_has_container(struct vfio_device *device)
+{
+	return device->group->container;
+}
+
 /*
  * Pin contiguous user pages and return their associated host pages for local
  * domain only.
@@ -1971,7 +1976,7 @@ EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
  * Return error or number of pages pinned.
  *
  * A driver may only call this function if the vfio_device was created
- * by vfio_register_emulated_iommu_dev() due to vfio_container_pin_pages().
+ * by vfio_register_emulated_iommu_dev() due to vfio_device_container_pin_pages().
  */
 int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 		   int npage, int prot, struct page **pages)
@@ -1979,10 +1984,9 @@ int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 	/* group->container cannot change while a vfio device is open */
 	if (!pages || !npage || WARN_ON(!vfio_assert_device_open(device)))
 		return -EINVAL;
-	if (device->group->container)
-		return vfio_container_pin_pages(device->group->container,
-						device->group->iommu_group,
-						iova, npage, prot, pages);
+	if (vfio_device_has_container(device))
+		return vfio_device_container_pin_pages(device, iova,
+						       npage, prot, pages);
 	if (device->iommufd_access) {
 		int ret;
 
@@ -2018,9 +2022,8 @@ void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
 	if (WARN_ON(!vfio_assert_device_open(device)))
 		return;
 
-	if (device->group->container) {
-		vfio_container_unpin_pages(device->group->container, iova,
-					   npage);
+	if (vfio_device_has_container(device)) {
+		vfio_device_container_unpin_pages(device, iova, npage);
 		return;
 	}
 	if (device->iommufd_access) {
@@ -2057,9 +2060,9 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
 	if (!data || len <= 0 || !vfio_assert_device_open(device))
 		return -EINVAL;
 
-	if (device->group->container)
-		return vfio_container_dma_rw(device->group->container, iova,
-					     data, len, write);
+	if (vfio_device_has_container(device))
+		return vfio_device_container_dma_rw(device, iova,
+						    data, len, write);
 
 	if (device->iommufd_access) {
 		unsigned int flags = 0;
-- 
2.34.1


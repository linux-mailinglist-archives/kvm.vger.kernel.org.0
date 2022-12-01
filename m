Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D295A63F33A
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiLAOzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiLAOzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:55:48 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23429BB7FB
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 06:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669906547; x=1701442547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ocJMWCXygOKnLgkenfWX6hqL5niJuF2MvULJmoNtGE4=;
  b=Wsm+ulGVE1YszcG3YPFt3niG2h1ZC5QKg1y+0Q2gYwYJ+yRbPOFn2kX3
   pKovOICmflcUzyCZmDZnIBam1VQ5ulRRtbf5O5LMuDwTgWKlAkV9UTBSW
   4w6mQ9Olqi115R/LiVjrsNxUwbHmqol2X1P6wJVbge0d7OUSXT5QGpzuf
   Hc01LpKgcZiEy2/pN1dZOdK5d8jBVwyUpMHd0KTt9CoswdtXASSkfgD7V
   VZiLVRukNQeBq1IjHhddQ8gDGQ0bkWmovzT465WWOG4fubb3fkKwWltFH
   KsmupkXlpmrOFXfqJYPtibPwFAr/fI0IeICvwxYaUe4TuYx/V2Fv/LnFR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317569332"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="317569332"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 06:55:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708095206"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="708095206"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 06:55:46 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com
Subject: [PATCH 09/10] vfio: Refactor dma APIs for emulated devices
Date:   Thu,  1 Dec 2022 06:55:34 -0800
Message-Id: <20221201145535.589687-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221201145535.589687-1-yi.l.liu@intel.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To use group helpers instead of opening group related code in the
API. This prepares moving group specific code out of vfio_main.c.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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
index ce5fe3fc493b..a112e8f2b291 100644
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
+static inline int vfio_device_container_pin_pages(struct vfio_device *device,
+						  dma_addr_t iova, int npage,
+						  int prot, struct page **pages)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void vfio_container_unpin_pages(struct vfio_container *container,
-					      dma_addr_t iova, int npage)
+static inline void vfio_device_container_unpin_pages(struct vfio_device *device,
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
index 6e7daed47e97..11fe044e8703 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1943,6 +1943,11 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
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
@@ -1955,7 +1960,7 @@ EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
  * Return error or number of pages pinned.
  *
  * A driver may only call this function if the vfio_device was created
- * by vfio_register_emulated_iommu_dev() due to vfio_container_pin_pages().
+ * by vfio_register_emulated_iommu_dev() due to vfio_device_container_pin_pages().
  */
 int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 		   int npage, int prot, struct page **pages)
@@ -1963,10 +1968,9 @@ int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
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
 
@@ -2002,9 +2006,8 @@ void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
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
@@ -2041,9 +2044,9 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
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


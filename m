Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747E36362A7
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 16:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbiKWPCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 10:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237444AbiKWPBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 10:01:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814132A71A
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 07:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669215706; x=1700751706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CIG3qrVgjfcwcMIBHh6yG/d8zRKEnj7ywsh8A3TPKaY=;
  b=FZEmYackG4XudWACUeneeozNhKQJAxneuQDmvHrb6K+hqXdSW++gXjIH
   sGi5dQq1Cxifj42a/ggilra+DXql2Cwikdm2xoQv7wFG2+/2r+KGuHlOJ
   n3criGwWeWAMYQCuvqRG1d/22x51q6rM69EN3Qov9/7UmAtI8XnRuXVJs
   JE7taTKezAA41Ecjfu14uhpQ9nENiPng4YSaRHfs0COiUkM8mDo8EFYkX
   iOBptm1wgjB/r5bfXNVD3pkj3iB3ApV6fDLxL7OubXxMI9Gma9F+pTdkY
   GuvozniB1WYf99tQy4VKJzZUbrt9MU2ZFPfnXYjaXpFOitnIxxIwrz8IG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301642999"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301642999"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:01:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674750983"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674750983"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 07:01:29 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC 09/10] vfio: Refactor dma APIs for emulated devices
Date:   Wed, 23 Nov 2022 07:01:12 -0800
Message-Id: <20221123150113.670399-10-yi.l.liu@intel.com>
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

To use group helpers instead of opening group related code in the
API. This prepares moving group specific code out of vfio_main.c.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/container.c | 20 +++++++++++++-------
 drivers/vfio/vfio.h      | 32 ++++++++++++++++----------------
 drivers/vfio/vfio_main.c | 26 +++++++++++++++-----------
 3 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index 6b362d97d682..e0d11ab7229a 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -540,11 +540,13 @@ void vfio_group_unuse_container(struct vfio_group *group)
 	fput(group->opened_file);
 }
 
-int vfio_container_pin_pages(struct vfio_container *container,
-			     struct iommu_group *iommu_group, dma_addr_t iova,
-			     int npage, int prot, struct page **pages)
+int vfio_group_container_pin_pages(struct vfio_group *group,
+				   dma_addr_t iova, int npage,
+				   int prot, struct page **pages)
 {
+	struct vfio_container *container = group->container;
 	struct vfio_iommu_driver *driver = container->iommu_driver;
+	struct iommu_group *iommu_group = group->iommu_group;
 
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
@@ -555,9 +557,11 @@ int vfio_container_pin_pages(struct vfio_container *container,
 				      npage, prot, pages);
 }
 
-void vfio_container_unpin_pages(struct vfio_container *container,
-				dma_addr_t iova, int npage)
+void vfio_group_container_unpin_pages(struct vfio_group *group,
+				      dma_addr_t iova, int npage)
 {
+	struct vfio_container *container = group->container;
+
 	if (WARN_ON(npage <= 0 || npage > VFIO_PIN_PAGES_MAX_ENTRIES))
 		return;
 
@@ -565,9 +569,11 @@ void vfio_container_unpin_pages(struct vfio_container *container,
 						  npage);
 }
 
-int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
-			  void *data, size_t len, bool write)
+int vfio_group_container_dma_rw(struct vfio_group *group,
+				dma_addr_t iova, void *data,
+				size_t len, bool write)
 {
+	struct vfio_container *container = group->container;
 	struct vfio_iommu_driver *driver = container->iommu_driver;
 
 	if (unlikely(!driver || !driver->ops->dma_rw))
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 3378714a7462..d6b6bc20406b 100644
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
+int vfio_group_container_pin_pages(struct vfio_group *group,
+				   dma_addr_t iova, int npage,
+				   int prot, struct page **pages);
+void vfio_group_container_unpin_pages(struct vfio_group *group,
+				      dma_addr_t iova, int npage);
+int vfio_group_container_dma_rw(struct vfio_group *group,
+				dma_addr_t iova, void *data,
+				size_t len, bool write);
 
 int __init vfio_container_init(void);
 void vfio_container_cleanup(void);
@@ -166,22 +167,21 @@ static inline void vfio_device_container_unregister(struct vfio_device *device)
 {
 }
 
-static inline int vfio_container_pin_pages(struct vfio_container *container,
-					   struct iommu_group *iommu_group,
-					   dma_addr_t iova, int npage, int prot,
-					   struct page **pages)
+static inline int vfio_group_container_pin_pages(struct vfio_group *group,
+						 dma_addr_t iova, int npage,
+						 int prot, struct page **pages)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void vfio_container_unpin_pages(struct vfio_container *container,
-					      dma_addr_t iova, int npage)
+static inline void vfio_group_container_unpin_pages(struct vfio_group *group,
+						    dma_addr_t iova, int npage)
 {
 }
 
-static inline int vfio_container_dma_rw(struct vfio_container *container,
-					dma_addr_t iova, void *data, size_t len,
-					bool write)
+static inline int vfio_group_container_dma_rw(struct vfio_group *group,
+					      dma_addr_t iova, void *data,
+					      size_t len, bool write)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index cde258f4ea17..b6d3cb35a523 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1925,6 +1925,11 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 }
 EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
 
+static bool vfio_group_has_container(struct vfio_group *group)
+{
+	return group->container;
+}
+
 /*
  * Pin contiguous user pages and return their associated host pages for local
  * domain only.
@@ -1937,7 +1942,7 @@ EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
  * Return error or number of pages pinned.
  *
  * A driver may only call this function if the vfio_device was created
- * by vfio_register_emulated_iommu_dev() due to vfio_container_pin_pages().
+ * by vfio_register_emulated_iommu_dev() due to vfio_group_container_pin_pages().
  */
 int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 		   int npage, int prot, struct page **pages)
@@ -1945,10 +1950,9 @@ int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 	/* group->container cannot change while a vfio device is open */
 	if (!pages || !npage || WARN_ON(!vfio_assert_device_open(device)))
 		return -EINVAL;
-	if (device->group->container)
-		return vfio_container_pin_pages(device->group->container,
-						device->group->iommu_group,
-						iova, npage, prot, pages);
+	if (vfio_group_has_container(device->group))
+		return vfio_group_container_pin_pages(device->group, iova,
+						      npage, prot, pages);
 	if (device->iommufd_access) {
 		int ret;
 
@@ -1984,9 +1988,9 @@ void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
 	if (WARN_ON(!vfio_assert_device_open(device)))
 		return;
 
-	if (device->group->container) {
-		vfio_container_unpin_pages(device->group->container, iova,
-					   npage);
+	if (vfio_group_has_container(device->group)) {
+		vfio_group_container_unpin_pages(device->group, iova,
+						 npage);
 		return;
 	}
 	if (device->iommufd_access) {
@@ -2023,9 +2027,9 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
 	if (!data || len <= 0 || !vfio_assert_device_open(device))
 		return -EINVAL;
 
-	if (device->group->container)
-		return vfio_container_dma_rw(device->group->container, iova,
-					     data, len, write);
+	if (vfio_group_has_container(device->group))
+		return vfio_group_container_dma_rw(device->group, iova,
+						   data, len, write);
 
 	if (device->iommufd_access) {
 		unsigned int flags = 0;
-- 
2.34.1


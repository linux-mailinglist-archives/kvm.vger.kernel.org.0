Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042C364635F
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 22:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLGVqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 16:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiLGVqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 16:46:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7CF813B1
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 13:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670449524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9uhlYnElzG32n0kpLT3r3Nj+B8bG3NU+6VBSLsvbX1E=;
        b=Aa55buIjuiINHfR80OBJBdvUnVIHlnrTZGKPGT9aXUf+SbLKJiKlyDdNDfVGiHXoH/+70R
        6ppcJn2A4ec36wJJgJ0sgWmx9cSFDFnS40p8JAUEmljlfoTxBrdhLy9H49I7yFtt0dccIL
        g85pHpzbRDjPt287Pls1H6tav2gvql8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-yVS1u0_TM82Po_vMi2yRBw-1; Wed, 07 Dec 2022 16:45:21 -0500
X-MC-Unique: yVS1u0_TM82Po_vMi2yRBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E92BB101A595;
        Wed,  7 Dec 2022 21:45:20 +0000 (UTC)
Received: from [172.30.42.193] (unknown [10.22.33.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83E512027061;
        Wed,  7 Dec 2022 21:45:20 +0000 (UTC)
Subject: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update fragments
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org, alex.williamson@redhat.com
Cc:     steven.sistare@oracle.com, jgg@ziepe.ca
Date:   Wed, 07 Dec 2022 14:45:18 -0700
Message-ID: <167044909523.3885870.619291306425395938.stgit@omen>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix several loose ends relative to reverting support for vaddr removal
and update.  Mark feature and ioctl flags as deprecated, restore local
variable scope in pin pages, remove remaining support in the mapping
code.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

This applies on top of Steve's patch[1] to fully remove and deprecate
this feature in the short term, following the same methodology we used
for the v1 migration interface removal.  The intention would be to pick
Steve's patch and this follow-on for v6.2 given that existing support
exposes vulnerabilities and no known upstream userspaces make use of
this feature.

[1]https://lore.kernel.org/all/1670363753-249738-2-git-send-email-steven.sistare@oracle.com/

 drivers/vfio/vfio_iommu_type1.c |   23 ++++-------------------
 include/uapi/linux/vfio.h       |    7 ++++---
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 02c6ea3bed69..731d8d4b6524 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -790,7 +790,6 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	unsigned long remote_vaddr;
 	struct vfio_dma *dma;
 	bool do_accounting;
-	dma_addr_t iova;
 
 	if (!iommu || !pages)
 		return -EINVAL;
@@ -815,6 +814,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	do_accounting = list_empty(&iommu->domain_list);
 
 	for (i = 0; i < npage; i++) {
+		dma_addr_t iova;
 		unsigned long phys_pfn;
 		struct vfio_pfn *vpfn;
 
@@ -1467,7 +1467,6 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
-	bool set_vaddr = map->flags & VFIO_DMA_MAP_FLAG_VADDR;
 	dma_addr_t iova = map->iova;
 	unsigned long vaddr = map->vaddr;
 	size_t size = map->size;
@@ -1485,16 +1484,13 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
 		prot |= IOMMU_READ;
 
-	if ((prot && set_vaddr) || (!prot && !set_vaddr))
-		return -EINVAL;
-
 	mutex_lock(&iommu->lock);
 
 	pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
 
 	WARN_ON((pgsize - 1) & PAGE_MASK);
 
-	if (!size || (size | iova | vaddr) & (pgsize - 1)) {
+	if (!prot || !size || (size | iova | vaddr) & (pgsize - 1)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -1505,17 +1501,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		goto out_unlock;
 	}
 
-	dma = vfio_find_dma(iommu, iova, size);
-	if (set_vaddr) {
-		if (!dma) {
-			ret = -ENOENT;
-		} else if (dma->iova != iova || dma->size != size) {
-			ret = -EINVAL;
-		} else {
-			dma->vaddr = vaddr;
-		}
-		goto out_unlock;
-	} else if (dma) {
+	if (vfio_find_dma(iommu, iova, size)) {
 		ret = -EEXIST;
 		goto out_unlock;
 	}
@@ -2727,8 +2713,7 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
 {
 	struct vfio_iommu_type1_dma_map map;
 	unsigned long minsz;
-	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
-			VFIO_DMA_MAP_FLAG_VADDR;
+	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
 
 	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 04d944c8941d..800ca94aafb3 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -49,8 +49,8 @@
 /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
 #define VFIO_UNMAP_ALL			9
 
-/* Obsolete, not supported by any IOMMU. */
-#define VFIO_UPDATE_VADDR		10
+/* Probe for reverted vaddr removal and update support */
+#define VFIO_UPDATE_VADDR_DEPRECATED	10
 
 /*
  * The IOCTL interface is designed for extensibility by embedding the
@@ -1348,7 +1348,7 @@ struct vfio_iommu_type1_dma_map {
 	__u32	flags;
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
-#define VFIO_DMA_MAP_FLAG_VADDR (1 << 2)
+#define VFIO_DMA_MAP_FLAG_VADDR_DEPRECATED (1 << 2) /* prior vaddr remapping */
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
@@ -1390,6 +1390,7 @@ struct vfio_iommu_type1_dma_unmap {
 	__u32	flags;
 #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
 #define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
+#define VFIO_DMA_UNMAP_FLAG_VADDR_DEPRECATED (1 << 2) /* prior vaddr removal */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
 	__u8    data[];



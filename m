Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8B13319A0
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhCHVtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:49:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37634 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230231AbhCHVtR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:49:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IbjMpnj13fwUb/rx8DtXEyIkPIQYznulLJxpmyYS3Gc=;
        b=KXFPM1MIEyUfxq7zw10UMkQqT9ZUBmZjZjhkF8jUWexBDUiU9nIrUiX/9mByY4C+FYDqR9
        GZN+taTNf5JlE1j99Ays8MrG5wXYdrk92icM3T1BRKF8GsxM8RhtOO/ubnXOk0oSipJLFJ
        tRB0MDJlSciKs1UopO2ssEUkUqO13rY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-Q_p4JOItNDyS9YGDIhbOIg-1; Mon, 08 Mar 2021 16:49:14 -0500
X-MC-Unique: Q_p4JOItNDyS9YGDIhbOIg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA909184214D;
        Mon,  8 Mar 2021 21:49:13 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D05215D9CD;
        Mon,  8 Mar 2021 21:49:06 +0000 (UTC)
Subject: [PATCH v1 10/14] vfio/type1: Pass iommu and dma objects through to
 vaddr_get_pfn
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:49:06 -0700
Message-ID: <161524014647.3480.9320948215446571524.stgit@gimli.home>
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We'll need these to track vfio device mappings.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f7d35a114354..f22c07a40521 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -579,15 +579,16 @@ static int unmap_dma_pfn_list(struct vfio_iommu *iommu, struct vfio_dma *dma,
  * Returns the positive number of pfns successfully obtained or a negative
  * error code.
  */
-static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
-			  long npages, int prot, unsigned long *pfn,
+static int vaddr_get_pfns(struct vfio_iommu *iommu, struct vfio_dma *dma,
+			  struct mm_struct *mm, unsigned long vaddr,
+			  long npages, unsigned long *pfn,
 			  struct page **pages)
 {
 	struct vm_area_struct *vma;
 	unsigned int flags = 0;
 	int ret;
 
-	if (prot & IOMMU_WRITE)
+	if (dma->prot & IOMMU_WRITE)
 		flags |= FOLL_WRITE;
 
 	mmap_read_lock(mm);
@@ -604,7 +605,8 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
+		ret = follow_fault_pfn(vma, mm, vaddr, pfn,
+				       dma->prot & IOMMU_WRITE);
 		if (ret == -EAGAIN)
 			goto retry;
 
@@ -680,7 +682,8 @@ static int vfio_wait_all_valid(struct vfio_iommu *iommu)
  * the iommu can only map chunks of consecutive pfns anyway, so get the
  * first page and all consecutive pages with the same locking.
  */
-static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
+static long vfio_pin_pages_remote(struct vfio_iommu *iommu,
+				  struct vfio_dma *dma, unsigned long vaddr,
 				  long npage, unsigned long *pfn_base,
 				  unsigned long limit, struct vfio_batch *batch)
 {
@@ -708,7 +711,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 			/* Empty batch, so refill it. */
 			long req_pages = min_t(long, npage, batch->capacity);
 
-			ret = vaddr_get_pfns(mm, vaddr, req_pages, dma->prot,
+			ret = vaddr_get_pfns(iommu, dma, mm, vaddr, req_pages,
 					     &pfn, batch->pages);
 			if (ret < 0)
 				goto unpin_out;
@@ -806,7 +809,8 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 	return unlocked;
 }
 
-static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
+static int vfio_pin_page_external(struct vfio_iommu *iommu,
+				  struct vfio_dma *dma, unsigned long vaddr,
 				  unsigned long *pfn_base, bool do_accounting)
 {
 	struct page *pages[1];
@@ -817,7 +821,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	if (!mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
+	ret = vaddr_get_pfns(iommu, dma, mm, vaddr, 1, pfn_base, pages);
 	if (ret == 1 && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
@@ -925,8 +929,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		}
 
 		remote_vaddr = dma->vaddr + (iova - dma->iova);
-		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
-					     do_accounting);
+		ret = vfio_pin_page_external(iommu, dma, remote_vaddr,
+					     &phys_pfn[i], do_accounting);
 		if (ret)
 			goto pin_unwind;
 
@@ -1497,7 +1501,7 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 
 	while (size) {
 		/* Pin a contiguous chunk of memory */
-		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
+		npage = vfio_pin_pages_remote(iommu, dma, vaddr + dma->size,
 					      size >> PAGE_SHIFT, &pfn, limit,
 					      &batch);
 		if (npage <= 0) {
@@ -1759,7 +1763,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				size_t n = dma->iova + dma->size - iova;
 				long npage;
 
-				npage = vfio_pin_pages_remote(dma, vaddr,
+				npage = vfio_pin_pages_remote(iommu, dma, vaddr,
 							      n >> PAGE_SHIFT,
 							      &pfn, limit,
 							      &batch);


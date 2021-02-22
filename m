Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCB1321D7F
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 17:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhBVQyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 11:54:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231636AbhBVQx5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 11:53:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614012750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FrHO8JCB3HL7LGX42UvL1nk10weStu84JHRB4yOtxDY=;
        b=Z9Tw48RojmXql6EaYDvmPjsjvqNRj+akQqjPtChalmk/n++BE0AxDHDLUcM0hIvfx3kcX6
        dSHmmViRgJ38adz1mNWMiz7vfIVeiTkEy35UTNOsE6KIZ1LyaA7fAaAYcxx5RSxXYBzJNS
        IktimORKoHw0TTnJPinj4YnOynel4QI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-UUHXrAgAMcGGC1bHaDV4kg-1; Mon, 22 Feb 2021 11:52:28 -0500
X-MC-Unique: UUHXrAgAMcGGC1bHaDV4kg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B045E1934103;
        Mon, 22 Feb 2021 16:52:27 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 921E95C1BD;
        Mon, 22 Feb 2021 16:52:20 +0000 (UTC)
Subject: [RFC PATCH 09/10] vfio/type1: Pass iommu and dma objects through to
 vaddr_get_pfn
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 22 Feb 2021 09:52:20 -0700
Message-ID: <161401274019.16443.9688799433041636464.stgit@gimli.home>
In-Reply-To: <161401167013.16443.8389863523766611711.stgit@gimli.home>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We'll need these to track vfio device mappings.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5099b3c9dce0..b34ee4b96a4a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -517,15 +517,16 @@ static int unmap_dma_pfn_list(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	return 0;
 }
 
-static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
-			 int prot, unsigned long *pfn)
+static int vaddr_get_pfn(struct vfio_iommu *iommu, struct vfio_dma *dma,
+			 struct mm_struct *mm, unsigned long vaddr,
+			 unsigned long *pfn)
 {
 	struct page *page[1];
 	struct vm_area_struct *vma;
 	unsigned int flags = 0;
 	int ret;
 
-	if (prot & IOMMU_WRITE)
+	if (dma->prot & IOMMU_WRITE)
 		flags |= FOLL_WRITE;
 
 	mmap_read_lock(mm);
@@ -543,7 +544,8 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
+		ret = follow_fault_pfn(vma, mm, vaddr, pfn,
+				       dma->prot & IOMMU_WRITE);
 		if (ret == -EAGAIN)
 			goto retry;
 
@@ -615,7 +617,8 @@ static int vfio_wait_all_valid(struct vfio_iommu *iommu)
  * the iommu can only map chunks of consecutive pfns anyway, so get the
  * first page and all consecutive pages with the same locking.
  */
-static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
+static long vfio_pin_pages_remote(struct vfio_iommu *iommu,
+				  struct vfio_dma *dma, unsigned long vaddr,
 				  long npage, unsigned long *pfn_base,
 				  unsigned long limit)
 {
@@ -628,7 +631,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	if (!current->mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfn(iommu, dma, current->mm, vaddr, pfn_base);
 	if (ret)
 		return ret;
 
@@ -655,7 +658,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	/* Lock all the consecutive pages from pfn_base */
 	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
 	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
-		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
+		ret = vaddr_get_pfn(iommu, dma, current->mm, vaddr, &pfn);
 		if (ret)
 			break;
 
@@ -715,7 +718,8 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 	return unlocked;
 }
 
-static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
+static int vfio_pin_page_external(struct vfio_iommu *iommu,
+				  struct vfio_dma *dma, unsigned long vaddr,
 				  unsigned long *pfn_base, bool do_accounting)
 {
 	struct mm_struct *mm;
@@ -725,7 +729,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	if (!mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfn(iommu, dma, mm, vaddr, pfn_base);
 	if (!ret && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
@@ -833,8 +837,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		}
 
 		remote_vaddr = dma->vaddr + (iova - dma->iova);
-		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
-					     do_accounting);
+		ret = vfio_pin_page_external(iommu, dma, remote_vaddr,
+					     &phys_pfn[i], do_accounting);
 		if (ret)
 			goto pin_unwind;
 
@@ -1404,7 +1408,7 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 
 	while (size) {
 		/* Pin a contiguous chunk of memory */
-		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
+		npage = vfio_pin_pages_remote(iommu, dma, vaddr + dma->size,
 					      size >> PAGE_SHIFT, &pfn, limit);
 		if (npage <= 0) {
 			WARN_ON(!npage);
@@ -1660,7 +1664,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				size_t n = dma->iova + dma->size - iova;
 				long npage;
 
-				npage = vfio_pin_pages_remote(dma, vaddr,
+				npage = vfio_pin_pages_remote(iommu, dma, vaddr,
 							      n >> PAGE_SHIFT,
 							      &pfn, limit);
 				if (npage <= 0) {


Return-Path: <kvm+bounces-37415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3064EA29D76
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 00:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05242188213E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 23:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE158221DB1;
	Wed,  5 Feb 2025 23:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ggHQO599"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8B6220697
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 23:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738797502; cv=none; b=ZbcdYEPSVm1O1gXumHRTeWLb6BlFVLhZS2YAXrpPcqtBNXZ5yUYUHtsFg+1oXvGpOGJP5AKEbd8YLJkEKugHLXEJODG3R/KKmXr9Kr8IeA3Ky//EfzpN0R31BMAUvfVtm/n5xiLrZnlY3z8kdj6wSJUWL8PktrB84r4utT2k1C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738797502; c=relaxed/simple;
	bh=EprKxhsvdDeHA1fgEvU9ySyUBwYUYyI/rOqpttHkhNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bH2jcKfhiWdgOQ2eUqq4DjVpiH4U2wP2fCM+95NST2KqWUrUP+hjPu3QjgsbqvGLS0zeVctzeZwK19g1XI3Vlf8z7Epb04+xrpLS5ncnITLGBADuJmoB6XXtkyLBCTqrZR3OHjBNpY5Q66rSZpp1xoUiQwQd+d8iM9VOnSXzGK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ggHQO599; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738797499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g2j42eQCCBuQmnjQswePvigH68JWZO03KTko7vdI09E=;
	b=ggHQO599DiEqKUtMYBFZVX+fmVylKzAO/4kvUwR/tpF+to17+kCmEKN8u53nz/vGf1gcBo
	YvhFNlHn65walGpGCNboeClw6pe3JYB17w4kXaM8tf6J5wnnJWo/YAnHXroHvMEq3NZcw7
	RaBu5NQcJ/o//kTDXzYeWkOsyeKc2oo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-374-5dX5pGO4PoK0hz4TmypS8A-1; Wed,
 05 Feb 2025 18:18:15 -0500
X-MC-Unique: 5dX5pGO4PoK0hz4TmypS8A-1
X-Mimecast-MFC-AGG-ID: 5dX5pGO4PoK0hz4TmypS8A
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B890180087B;
	Wed,  5 Feb 2025 23:18:14 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.81.141])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B1DFE1800570;
	Wed,  5 Feb 2025 23:18:12 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	peterx@redhat.com,
	mitchell.augustin@canonical.com,
	clg@redhat.com
Subject: [PATCH 3/5] vfio/type1: Use vfio_batch for vaddr_get_pfns()
Date: Wed,  5 Feb 2025 16:17:19 -0700
Message-ID: <20250205231728.2527186-4-alex.williamson@redhat.com>
In-Reply-To: <20250205231728.2527186-1-alex.williamson@redhat.com>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Passing the vfio_batch to vaddr_get_pfns() allows for greater
distinction between page backed pfns and pfnmaps.  In the case of page
backed pfns, vfio_batch.size is set to a positive value matching the
number of pages filled in vfio_batch.pages.  For a pfnmap,
vfio_batch.size remains zero as vfio_batch.pages are not used.  In both
cases the return value continues to indicate the number of pfns and the
provided pfn arg is set to the initial pfn value.

This allows us to shortcut the pfnmap case, which is detected by the
zero vfio_batch.size.  pfnmaps do not contribute to locked memory
accounting, therefore we can update counters and continue directly,
which also enables a future where vaddr_get_pfns() can return a value
greater than one for consecutive pfnmaps.

NB. Now that we're not guessing whether the initial pfn is page backed
or pfnmap, we no longer need to special case the put_pfn() and batch
size reset.  It's safe for vfio_batch_unpin() to handle this case.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 62 ++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2e95f5f4d881..939920454da7 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -555,12 +555,16 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 
 /*
  * Returns the positive number of pfns successfully obtained or a negative
- * error code.
+ * error code.  The initial pfn is stored in the pfn arg.  For page-backed
+ * pfns, the provided batch is also updated to indicate the filled pages and
+ * initial offset.  For VM_PFNMAP pfns, only the returned number of pfns and
+ * returned initial pfn are provided; subsequent pfns are contiguous.
  */
 static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 			  long npages, int prot, unsigned long *pfn,
-			  struct page **pages)
+			  struct vfio_batch *batch)
 {
+	long pin_pages = min_t(long, npages, batch->capacity);
 	struct vm_area_struct *vma;
 	unsigned int flags = 0;
 	int ret;
@@ -569,10 +573,12 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 		flags |= FOLL_WRITE;
 
 	mmap_read_lock(mm);
-	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
-				    pages, NULL);
+	ret = pin_user_pages_remote(mm, vaddr, pin_pages, flags | FOLL_LONGTERM,
+				    batch->pages, NULL);
 	if (ret > 0) {
-		*pfn = page_to_pfn(pages[0]);
+		*pfn = page_to_pfn(batch->pages[0]);
+		batch->size = ret;
+		batch->offset = 0;
 		goto done;
 	} else if (!ret) {
 		ret = -EFAULT;
@@ -628,32 +634,41 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 		*pfn_base = 0;
 	}
 
+	if (unlikely(disable_hugepages))
+		npage = 1;
+
 	while (npage) {
 		if (!batch->size) {
 			/* Empty batch, so refill it. */
-			long req_pages = min_t(long, npage, batch->capacity);
-
-			ret = vaddr_get_pfns(mm, vaddr, req_pages, dma->prot,
-					     &pfn, batch->pages);
+			ret = vaddr_get_pfns(mm, vaddr, npage, dma->prot,
+					     &pfn, batch);
 			if (ret < 0)
 				goto unpin_out;
 
-			batch->size = ret;
-			batch->offset = 0;
-
 			if (!*pfn_base) {
 				*pfn_base = pfn;
 				rsvd = is_invalid_reserved_pfn(*pfn_base);
 			}
+
+			/* Handle pfnmap */
+			if (!batch->size) {
+				if (pfn != *pfn_base + pinned || !rsvd)
+					goto out;
+
+				pinned += ret;
+				npage -= ret;
+				vaddr += (PAGE_SIZE * ret);
+				iova += (PAGE_SIZE * ret);
+				continue;
+			}
 		}
 
 		/*
-		 * pfn is preset for the first iteration of this inner loop and
-		 * updated at the end to handle a VM_PFNMAP pfn.  In that case,
-		 * batch->pages isn't valid (there's no struct page), so allow
-		 * batch->pages to be touched only when there's more than one
-		 * pfn to check, which guarantees the pfns are from a
-		 * !VM_PFNMAP vma.
+		 * pfn is preset for the first iteration of this inner loop due to the
+		 * fact that vaddr_get_pfns() needs to provide the initial pfn for pfnmaps.
+		 * Therefore to reduce redundancy, the next pfn is fetched at the end of
+		 * the loop.  A PageReserved() page could still qualify as page backed and
+		 * rsvd here, and therefore continues to use the batch.
 		 */
 		while (true) {
 			if (pfn != *pfn_base + pinned ||
@@ -688,21 +703,12 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 
 			pfn = page_to_pfn(batch->pages[batch->offset]);
 		}
-
-		if (unlikely(disable_hugepages))
-			break;
 	}
 
 out:
 	ret = vfio_lock_acct(dma, lock_acct, false);
 
 unpin_out:
-	if (batch->size == 1 && !batch->offset) {
-		/* May be a VM_PFNMAP pfn, which the batch can't remember. */
-		put_pfn(pfn, dma->prot);
-		batch->size = 0;
-	}
-
 	if (ret < 0) {
 		if (pinned && !rsvd) {
 			for (pfn = *pfn_base ; pinned ; pfn++, pinned--)
@@ -750,7 +756,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 
 	vfio_batch_init_single(&batch);
 
-	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, batch.pages);
+	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, &batch);
 	if (ret != 1)
 		goto out;
 
-- 
2.47.1



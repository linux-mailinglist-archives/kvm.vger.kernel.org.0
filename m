Return-Path: <kvm+bounces-38503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B941FA3AB9B
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 23:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7319718897D0
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CA411DE4D9;
	Tue, 18 Feb 2025 22:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b89IZLI1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3911DE3AC
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 22:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739917358; cv=none; b=bz3kJbTcKGJtFfMAq+Yta5V1V5amSUeb1mvLk9LZKJju0GaTIL+nZGmo1RTlZZ3oHYtfDKuKO/2VR8YIu8h2FoTWE/G9JwWPIir0nE8tM4xepX7ome6jFkfWsKWo3Y0pAJixoSu3nEfp5r2ykC678rPKfypw2WZ34BXxdVVk2DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739917358; c=relaxed/simple;
	bh=smR5j7mr7NCBKqFW+ijihL1Yythw0728BzIgi2gtTWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7C7/R7+Sd51bcsUpzrKyqghbFdkHW0M2zr4g2pp/b+2ywNYgQDZM9T98PWlycB2LtUciPqS8NQR9T8PYl7As8lhV8Ah31yjCL8SUDgAcuigQXqkbmAilH/QoIkmkI+tj1wE46yqUZX/OIoeNcvx3FebIG/g+8B6IZ3F63cKqGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b89IZLI1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739917355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y50YBJiD0QUWKJiH9oMv1Fk/Dv9+zovo8IalJtkvn1w=;
	b=b89IZLI1Tus3OcF3xBzJ/nlbvnLgMJXrycneZafHH3Gby3PDV4smOEm1Q/Z7suTUMnFCxV
	GvMUffJG2Dwe4j8GntwBb6ylrRtNa2s1o4nVhDIGmR2FBhhZQt70EHOcaVorQDrrn8VclY
	xrbZm5jIFfQzvmPRsAMJx8Egx+Il4B4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-37-g9vmJ1x2MKCzjrR-ygYzqQ-1; Tue,
 18 Feb 2025 17:22:31 -0500
X-MC-Unique: g9vmJ1x2MKCzjrR-ygYzqQ-1
X-Mimecast-MFC-AGG-ID: g9vmJ1x2MKCzjrR-ygYzqQ_1739917350
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B2D0180056F;
	Tue, 18 Feb 2025 22:22:30 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.88.77])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 18A2930001A5;
	Tue, 18 Feb 2025 22:22:27 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	peterx@redhat.com,
	mitchell.augustin@canonical.com,
	clg@redhat.com,
	jgg@nvidia.com
Subject: [PATCH v2 4/6] vfio/type1: Use consistent types for page counts
Date: Tue, 18 Feb 2025 15:22:04 -0700
Message-ID: <20250218222209.1382449-5-alex.williamson@redhat.com>
In-Reply-To: <20250218222209.1382449-1-alex.williamson@redhat.com>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Page count should more consistently be an unsigned long when passed as
an argument while functions returning a number of pages should use a
signed long to allow for -errno.

vaddr_get_pfns() can therefore be upgraded to return long, though in
practice it's currently limited by the batch capacity.  In fact, the
batch indexes are noted to never hold negative values, so while it
doesn't make sense to bloat the structure with unsigned longs in this
case, it does make sense to specify these as unsigned.

No change in behavior expected.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index fafd8af125c7..ce661f03f139 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -103,9 +103,9 @@ struct vfio_dma {
 struct vfio_batch {
 	struct page		**pages;	/* for pin_user_pages_remote */
 	struct page		*fallback_page; /* if pages alloc fails */
-	int			capacity;	/* length of pages array */
-	int			size;		/* of batch currently */
-	int			offset;		/* of next entry in pages */
+	unsigned int		capacity;	/* length of pages array */
+	unsigned int		size;		/* of batch currently */
+	unsigned int		offset;		/* of next entry in pages */
 };
 
 struct vfio_iommu_group {
@@ -560,14 +560,14 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
  * initial offset.  For VM_PFNMAP pfns, only the returned number of pfns and
  * returned initial pfn are provided; subsequent pfns are contiguous.
  */
-static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
-			  long npages, int prot, unsigned long *pfn,
-			  struct vfio_batch *batch)
+static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
+			   unsigned long npages, int prot, unsigned long *pfn,
+			   struct vfio_batch *batch)
 {
-	long pin_pages = min_t(long, npages, batch->capacity);
+	unsigned long pin_pages = min_t(unsigned long, npages, batch->capacity);
 	struct vm_area_struct *vma;
 	unsigned int flags = 0;
-	int ret;
+	long ret;
 
 	if (prot & IOMMU_WRITE)
 		flags |= FOLL_WRITE;
@@ -612,7 +612,7 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
  * first page and all consecutive pages with the same locking.
  */
 static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
-				  long npage, unsigned long *pfn_base,
+				  unsigned long npage, unsigned long *pfn_base,
 				  unsigned long limit, struct vfio_batch *batch)
 {
 	unsigned long pfn;
@@ -724,7 +724,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 }
 
 static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
-				    unsigned long pfn, long npage,
+				    unsigned long pfn, unsigned long npage,
 				    bool do_accounting)
 {
 	long unlocked = 0, locked = 0;
-- 
2.48.1



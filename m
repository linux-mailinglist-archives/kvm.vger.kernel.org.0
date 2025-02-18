Return-Path: <kvm+bounces-38499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5AFA3AB94
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 23:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E7493A546D
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1962A1D9A50;
	Tue, 18 Feb 2025 22:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W/HPxvC3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D9D28629B
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 22:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739917351; cv=none; b=V7Rp3+i/B6RPh5fZ2pmwKZckz0Yf2oT4XEvk3HckzWytdi1mweUIZ7RA31PKhV6/Ho6wIWRRf/VgXHVIBZhgSvNadOshgbpFkfQlUtKVHrFsN5DSFxuyN6YzBMqYt6gpHYtB9Iy7F+5UEUSHq7AnGkqt4o2iHep56WDNHpjEuFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739917351; c=relaxed/simple;
	bh=wz3yzYejx/8v4irersUarogzfJY+Deu6ePxVH2PlB2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrYqi/a8gWdAo87m64WCvO0d9h+Eytv/Xu3FAHySGhcRR3N55Mriwdz1zRir9+Z6Mpjv+mc2rONfxcQezF34BhcCQdFVzPaDP1aFl0agGWLCJZu36af6NB30M7eiyZU2LSUdT+Kia0c1OoeV7r6HTfM3u6wjU9tdtKdlcmVXjqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W/HPxvC3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739917348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDNwQ6cJzqO/P0dW5wK2COewyumLqAUhMRnX8cwH+GU=;
	b=W/HPxvC38MpERWzipgGLL7BNWOt4sA5DniXMG6WK3Gm+t3av1EYIwwuEIJtA1QlWYb9yTw
	FJAt/u8lR82TVhav17TFfxPqORyIDlkMSY3KhCMvdlEbI6kgTyJuzEM1BCmrcILL+ytf6R
	20I9VFXty8+sOFHliNiac81EpFoK2Co=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-cTjyOuWhM3StQl89hVlG0w-1; Tue,
 18 Feb 2025 17:22:26 -0500
X-MC-Unique: cTjyOuWhM3StQl89hVlG0w-1
X-Mimecast-MFC-AGG-ID: cTjyOuWhM3StQl89hVlG0w_1739917345
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F397B1800874;
	Tue, 18 Feb 2025 22:22:24 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.88.77])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 08A9830001A5;
	Tue, 18 Feb 2025 22:22:22 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	peterx@redhat.com,
	mitchell.augustin@canonical.com,
	clg@redhat.com,
	jgg@nvidia.com
Subject: [PATCH v2 2/6] vfio/type1: Convert all vaddr_get_pfns() callers to use vfio_batch
Date: Tue, 18 Feb 2025 15:22:02 -0700
Message-ID: <20250218222209.1382449-3-alex.williamson@redhat.com>
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

This is a step towards passing the structure to vaddr_get_pfns()
directly in order to provide greater distinction between page backed
pfns and pfnmaps.

Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 119cf886d8c0..2e95f5f4d881 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -471,12 +471,12 @@ static int put_pfn(unsigned long pfn, int prot)
 
 #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
 
-static void vfio_batch_init(struct vfio_batch *batch)
+static void __vfio_batch_init(struct vfio_batch *batch, bool single)
 {
 	batch->size = 0;
 	batch->offset = 0;
 
-	if (unlikely(disable_hugepages))
+	if (single || unlikely(disable_hugepages))
 		goto fallback;
 
 	batch->pages = (struct page **) __get_free_page(GFP_KERNEL);
@@ -491,6 +491,16 @@ static void vfio_batch_init(struct vfio_batch *batch)
 	batch->capacity = 1;
 }
 
+static void vfio_batch_init(struct vfio_batch *batch)
+{
+	__vfio_batch_init(batch, false);
+}
+
+static void vfio_batch_init_single(struct vfio_batch *batch)
+{
+	__vfio_batch_init(batch, true);
+}
+
 static void vfio_batch_unpin(struct vfio_batch *batch, struct vfio_dma *dma)
 {
 	while (batch->size) {
@@ -730,7 +740,7 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 				  unsigned long *pfn_base, bool do_accounting)
 {
-	struct page *pages[1];
+	struct vfio_batch batch;
 	struct mm_struct *mm;
 	int ret;
 
@@ -738,7 +748,9 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	if (!mmget_not_zero(mm))
 		return -ENODEV;
 
-	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
+	vfio_batch_init_single(&batch);
+
+	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, batch.pages);
 	if (ret != 1)
 		goto out;
 
@@ -757,6 +769,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	}
 
 out:
+	vfio_batch_fini(&batch);
 	mmput(mm);
 	return ret;
 }
-- 
2.48.1



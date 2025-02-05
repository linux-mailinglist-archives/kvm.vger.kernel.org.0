Return-Path: <kvm+bounces-37413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98DA4A29D70
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 00:18:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 948C61881A4E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 23:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F0222068F;
	Wed,  5 Feb 2025 23:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HVaQe0SQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE0521D003
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 23:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738797499; cv=none; b=MW1s2P12Cs3fRhvGeiQ6Pkn+7N+0239woIO4J3nsNA5t99auTPbJt+dFTKtiHo94XoNVs3nEmUxm77FCmBVVp09NklWfzFpSTaUDjks9xb2xL4AwN+OB53sFQkcQFz5pPhrvnvck6ELvMc/BpKSsv9JoNIe0CQjGW9bwwNXCmzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738797499; c=relaxed/simple;
	bh=4QmfjawvTW7/JuBzJw2fN4Til1n8dAtbherJt5RYjtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsJ4H04XmpeJwPvSZWfHDv5KA7eFSjdDCiMtYbtcplXvWtC5iZ0RkWjPYtUj7wQM/F6jaChW7CcjmVsyJ9lZ1EdGeUsSPQJ4hzNkgXpknnVVVPl3Ipi8ROtKXckdkqgzJw30g/Dgl3juTonR2JUSsgk+Z5vYcKy3Fi2nnyHLpUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HVaQe0SQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738797496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JL6vZNRbPmBlHb8nArQ9k01zTpT4aI26y7m8102a0EY=;
	b=HVaQe0SQDAdMSgCd6B+QBk2iwMq279Z1hLzPANoidLNkR/bfPNXXRgT5AKXW7MkUMxZ00l
	QoBYJwiLPONjV4z0jZ3OxNUpX9CGMTTNbjP1z5UiuGMfyuS38PUrkcP6g+0Qpy5D8VSoy/
	yoa3CBVV/hQYr2HgDmZJsnXOgVxeb2o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-MHVeKkGdMVO6MwCp5BIpSA-1; Wed,
 05 Feb 2025 18:18:13 -0500
X-MC-Unique: MHVeKkGdMVO6MwCp5BIpSA-1
X-Mimecast-MFC-AGG-ID: MHVeKkGdMVO6MwCp5BIpSA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D6201956094;
	Wed,  5 Feb 2025 23:18:12 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.81.141])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 16BB61800570;
	Wed,  5 Feb 2025 23:18:10 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	peterx@redhat.com,
	mitchell.augustin@canonical.com,
	clg@redhat.com
Subject: [PATCH 2/5] vfio/type1: Convert all vaddr_get_pfns() callers to use vfio_batch
Date: Wed,  5 Feb 2025 16:17:18 -0700
Message-ID: <20250205231728.2527186-3-alex.williamson@redhat.com>
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

This is a step towards passing the structure to vaddr_get_pfns()
directly in order to provide greater distinction between page backed
pfns and pfnmaps.

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
2.47.1



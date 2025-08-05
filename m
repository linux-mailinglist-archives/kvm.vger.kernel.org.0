Return-Path: <kvm+bounces-53955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B12BB1ABFE
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 03:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 746451888825
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 01:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADDE194C75;
	Tue,  5 Aug 2025 01:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UaQ8rYRz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BDB189905
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 01:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754357113; cv=none; b=Wqb9rx68jPQH0G7cAzbAH00hPwn+tpgSWKxnQrij2b0eaHuoyaijSphmMwCiEf/T/2XVkHPjP0U6vgGKnnxzEKhdu1Msuk5ncz5u/plMcv1z0aexcNDEaJxghECuZhLzK36beJScrhAYPGPPzfxshNSYDyljzIvCDLxQ0tAjvhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754357113; c=relaxed/simple;
	bh=KxHd8+9CWHQ2ZbmxWgo7OCrgPV8lKqKLLboCnpHUBZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CPGo6M1WWv76FOy9XKtYlwq+M70se7NfIksIkWsjuqSRkPFlKMA6Z36NTpTQyhTxZDuuV7mN/kJM98umjt1X1mw8U/b7vHcPPD46AJlv9r3olidF3ORLJDU0cnFAAGueXgONY5GKVNvBK+zPy3nOPXl5f32hWP4P4xXwGRHl04M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UaQ8rYRz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754357110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lxi9BkaMKXEnw5UUlY0VTlyL8QHOke3LrCc4LhFY+dU=;
	b=UaQ8rYRzWXG8vxk5nHO8rFBYF2IlBA/SMEz+yj7FdYws0SLKbTbMCMBSNm0HAF5GY4K50u
	rGGpgJ81gSbUZrW5a0fG4c1rxXnm+mwRQnonheQsQq/QbF5+GoA/vuC4LL/jgzAiskh0It
	2/Dgk0aiXL4m4u2Rs/tVkROSpnZGFF8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-660-LZC_2HJINLaOFmRGnQdpPQ-1; Mon,
 04 Aug 2025 21:25:09 -0400
X-MC-Unique: LZC_2HJINLaOFmRGnQdpPQ-1
X-Mimecast-MFC-AGG-ID: LZC_2HJINLaOFmRGnQdpPQ_1754357108
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4278D19560B5;
	Tue,  5 Aug 2025 01:25:08 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.66.8])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BC76B1800D84;
	Tue,  5 Aug 2025 01:25:06 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com,
	kvm@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Li Zhe <lizhe.67@bytedance.com>
Subject: [PATCH] vfio/type1: Absorb num_pages_contiguous()
Date: Mon,  4 Aug 2025 19:24:40 -0600
Message-ID: <20250805012442.3285276-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Objections were raised to adding this helper to common code with only a
single user and dubious generalism.  Pull it back into subsystem code.

Link: https://lore.kernel.org/all/CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 22 ++++++++++++++++++++++
 include/linux/mm.h              | 23 -----------------------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 33384a8c152d..3f06a8d937fa 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -659,6 +659,28 @@ static long vpfn_pages(struct vfio_dma *dma,
 	return ret;
 }
 
+/*
+ * num_pages_contiguous() - determine the number of contiguous pages
+ * starting from the first page.
+ *
+ * Pages are contiguous if they represent contiguous PFNs. Depending on
+ * the memory model, this can mean that the addresses of the "struct page"s
+ * are not contiguous.
+ *
+ * @pages: an array of page pointers
+ * @nr_pages: length of the array
+ */
+static unsigned long num_pages_contiguous(struct page **pages, size_t nr_pages)
+{
+	size_t i;
+
+	for (i = 1; i < nr_pages; i++)
+		if (pages[i] != nth_page(pages[0], i))
+			break;
+
+	return i;
+}
+
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fae82df6d7d7..0ef2ba0c667a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1761,29 +1761,6 @@ static inline unsigned long page_to_section(const struct page *page)
 }
 #endif
 
-/*
- * num_pages_contiguous() - determine the number of contiguous pages
- * starting from the first page.
- *
- * Pages are contiguous if they represent contiguous PFNs. Depending on
- * the memory model, this can mean that the addresses of the "struct page"s
- * are not contiguous.
- *
- * @pages: an array of page pointers
- * @nr_pages: length of the array
- */
-static inline unsigned long num_pages_contiguous(struct page **pages,
-						 size_t nr_pages)
-{
-	size_t i;
-
-	for (i = 1; i < nr_pages; i++)
-		if (pages[i] != nth_page(pages[0], i))
-			break;
-
-	return i;
-}
-
 /**
  * folio_pfn - Return the Page Frame Number of a folio.
  * @folio: The folio.
-- 
2.50.1



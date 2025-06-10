Return-Path: <kvm+bounces-48778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 432DCAD2CED
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 06:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD0491892282
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 04:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B624025E813;
	Tue, 10 Jun 2025 04:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="k4/pTVwY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED85A22B5AC
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 04:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749531488; cv=none; b=Wb2z8vlZMt5uPgSMIj3Sqp1yPEe2HBJmQ3asNWLI+ufF/kYE+DogPJHDPse8Xci1hRlCD+a4kuPs0o87rvewx2Mgc2pveWQa3pj4WlWpPHrhiW4tP5qOEXyFtd9qwphIQbB3MSv7Oo4lpjY8kK/Zm70/THxv48W1GyJ4jQCi6KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749531488; c=relaxed/simple;
	bh=01hdTf8O0DdEHladn6IEz6BWtaQbTZBfrj2t0P0Wg/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J41zbqHsEsBV42Z4OfWX52KmsPs+Ek9SxV9KZbHtnqNWED42h3nh2BEDCerdfZELFU0o8oTsqLwXwIAartGh29yK7G5SnM3peP7gzq2KIf7g4BqyFzPfrlZD/AGmJ+Z4fSIe+LW8Q6elwAcb+6ei16SzZ/3IFsuae9eHqTn6ER0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=k4/pTVwY; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-234d366e5f2so57052115ad.1
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 21:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1749531486; x=1750136286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HE/lloDxCFBh4QBDkfEJkgJnUlMqb+VAfBzAqcIIAtI=;
        b=k4/pTVwY9YuynNHEGeIWzeLtmlkZWIOxyMqTjm0WcNWXYM6WeARVm5ZjCanERzG/QE
         Q2ZskmfE2d7dm4kUsOfm1W8JGum0oKQ51mGKQRNUqHcEdurlXYCi9v66/Mrbl08RMvPB
         NxMiqM9QTfffbBpSINEoEJ4Qixtw91jel6SgoOMjcd6CINMfRuQAwBHCnSpFhJyWHMTd
         YsvkmW6gLwSK3J/mdGz+6FQAqdfLTj+m14T2vLKJzxEkgNAMZ8cM4paImMbLfpKlvSKe
         fDC9LY/nniqCBHj8nE6RR+Nw81Wa5GABGQtk4MoiBFYE26rDG7HESXzuToqN+bd9JS+C
         QuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749531486; x=1750136286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HE/lloDxCFBh4QBDkfEJkgJnUlMqb+VAfBzAqcIIAtI=;
        b=h2DWNkZDd7TBmnxuozedh7OL4EVbYNtCzOeEgDeQ/v7HWK6XQ83z5tOusSxR/2D6fT
         OLUwi8VMzloTjg7bIiuiw0nsNZV1CkYAu/5wnU/CXcHYVKNDbJR6zQ/i1NITNgOZAGp2
         58GWIG4witcaQIbaipHu3tQLdI/jUKjHfetFKcNVOi8MhnPILXLr191J8usLd9kYTeg0
         JtM+CHy0itjXCXt4F1GPaWUN3tty9f2dE/4vVmMLo61HTiAFqMYn+eicjh5Tj5lY3c0c
         J8MkVpGygo+y/E8JnP6dwcTkUXDmNvHSKeNLIdTL59rGBT0LSDJ9LvY6LyORhP+iJXax
         7H4w==
X-Gm-Message-State: AOJu0YwY7crbA949gjYJua0Eu+UzBaPk5SpHOYLY52xsNu2Qx3g6BBcl
	0mhOhzMtp8e5mJLCnx6H95ToL3p1zCL9H2DxftK5nh79nl23y6kGeeU9Eyx3thQiawE=
X-Gm-Gg: ASbGncuzEVTV2oOyRjUV5nWwLc5V7Gdi6FLvgksAXdWJk3EcMgBKBz83inpyphyQW+T
	7MTO5T5UeFBUbRyiLgA9Nj5LscUP8gToz1Gkj/3qiIw8DngzcJnbqjD9pkm/0ucyyiGt1GBzs2x
	okyIBoTq4lqLlmqs/J/NI6oWV1x+PO+ga4i8DxKO6rlIYdc88qC1Lx/c4EBqvbzj7zZnqWlqUOU
	gqwmDM55m8FLyjqgRpvVjJP5EpdVA/MFq3LL7E2CXGFcVHQ73URHboN1Wufc/uRocUqLyZ+IfbT
	YjCfPBuVooa8PJltwB1XRG2LwuL6RtlK3VqRWc0dcBAR7EVumfoqZG21+WOqVWnUKkDWOg/jKvr
	roajkrm4CAo5k
X-Google-Smtp-Source: AGHT+IFivQkyqAO2dh5O2UoBGDcVLCQlm9QDKUwL52j1PsV1wYGm/l7MlPEMGV7J6kWpBVrpS1Nt/g==
X-Received: by 2002:a17:903:1247:b0:22e:3c2:d477 with SMTP id d9443c01a7336-23601d25c36mr248229945ad.25.1749531486236;
        Mon, 09 Jun 2025 21:58:06 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-236034059besm62721975ad.174.2025.06.09.21.58.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Jun 2025 21:58:05 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com
Subject: [RFC v2] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Tue, 10 Jun 2025 12:57:53 +0800
Message-ID: <20250610045753.6405-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

This patch is based on patch 'vfio/type1: optimize vfio_pin_pages_remote()
for large folios'[1].

When vfio_unpin_pages_remote() is called with a range of addresses that
includes large folios, the function currently performs individual
put_pfn() operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of pages.

This patch optimize this process by batching the put_pfn() operations.

The performance test results, based on v6.15, for completing the 16G VFIO
IOMMU DMA unmapping, obtained through unit test[2] with slight
modifications[3], are as follows.

Base(v6.15):
./vfio-pci-mem-dma-map 0000:03:00.0 16
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.048 s (331.3 GB/s)
VFIO UNMAP DMA in 0.138 s (116.1 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.281 s (57.0 GB/s)
VFIO UNMAP DMA in 0.313 s (51.1 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.053 s (301.2 GB/s)
VFIO UNMAP DMA in 0.139 s (115.2 GB/s)

Map[1] + This patches:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.028 s (578.4 GB/s)
VFIO UNMAP DMA in 0.049 s (324.8 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.293 s (54.6 GB/s)
VFIO UNMAP DMA in 0.308 s (51.9 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.032 s (494.5 GB/s)
VFIO UNMAP DMA in 0.050 s (322.8 GB/s)

For large folio, we achieve an approximate 64% performance improvement
in the VFIO UNMAP DMA item. For small folios, the performance test
results appear to show no significant changes.

[1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
[2]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
[3]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
Changelogs:

v1->v2:
- Refactor the implementation of the optimized code

v1 patch: https://lore.kernel.org/all/20250605124923.21896-1-lizhe.67@bytedance.com/

 drivers/vfio/vfio_iommu_type1.c | 53 +++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 28ee4b8d39ae..2f6c0074d7b3 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -469,17 +469,28 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
 	return true;
 }
 
-static int put_pfn(unsigned long pfn, int prot)
+static inline void _put_pfns(struct page *page, int npages, int prot)
 {
-	if (!is_invalid_reserved_pfn(pfn)) {
-		struct page *page = pfn_to_page(pfn);
+	unpin_user_page_range_dirty_lock(page, npages, prot & IOMMU_WRITE);
+}
 
-		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
-		return 1;
+/*
+ * The caller must ensure that these npages PFNs belong to the same folio.
+ */
+static inline int put_pfns(unsigned long pfn, int npages, int prot)
+{
+	if (!is_invalid_reserved_pfn(pfn)) {
+		_put_pfns(pfn_to_page(pfn), npages, prot);
+		return npages;
 	}
 	return 0;
 }
 
+static inline int put_pfn(unsigned long pfn, int prot)
+{
+	return put_pfns(pfn, 1, prot);
+}
+
 #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
 
 static void __vfio_batch_init(struct vfio_batch *batch, bool single)
@@ -805,15 +816,33 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 				    unsigned long pfn, unsigned long npage,
 				    bool do_accounting)
 {
-	long unlocked = 0, locked = 0;
-	long i;
+	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
 
-	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
-		if (put_pfn(pfn++, dma->prot)) {
-			unlocked++;
-			if (vfio_find_vpfn(dma, iova))
-				locked++;
+	while (npage) {
+		struct folio *folio;
+		struct page *page;
+		long step = 1;
+
+		if (is_invalid_reserved_pfn(pfn))
+			goto next;
+
+		page = pfn_to_page(pfn);
+		folio = page_folio(page);
+
+		if (!folio_test_large(folio)) {
+			_put_pfns(page, 1, dma->prot);
+		} else {
+			step = min_t(long, npage,
+				folio_nr_pages(folio) -
+				folio_page_idx(folio, page));
+			_put_pfns(page, step, dma->prot);
 		}
+
+		unlocked += step;
+next:
+		pfn += step;
+		iova += PAGE_SIZE * step;
+		npage -= step;
 	}
 
 	if (do_accounting)
-- 
2.20.1



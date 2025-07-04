Return-Path: <kvm+bounces-51546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9F82AF87FA
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:27:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7064F3BE6BA
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136A6248881;
	Fri,  4 Jul 2025 06:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="hDWAGzAD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2101DE4D2
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 06:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751610417; cv=none; b=LJYgPAIBrX1lxtwvpcdN4IH7AxyjRSVwuXKLAap/cgePp2d9TjYVr8iNAOzBpFv6ngmdI1B9dK788nwej6tMzSkO3DCseMSfIdQBigsjUv8WZUEDTjnPJrk9Q73k9ff32STPC6JhlqgNwE1D+1f0IH+eQVv2RTjYxJvMJZAVqBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751610417; c=relaxed/simple;
	bh=fb6co8jrIb0ye1DMUwvR0cGT/E/Yrsdll1Jah3tS+yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vF8Z0Zs+aNQwMdaCW1QHa1+MtQ4JNfwxiUibHVJ/qrbRMLw2XpRYwRumvWkrlRi1DB19ADztGiRkiZ3kmNS1xHbBOC8K0PzVx72XUFs5QNYlc7quqddC5+Bko2BAyCVEldsfkoxiKsPzVn3GzP+7B7hZS9K4XACWOVen35QXAmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=hDWAGzAD; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-748e63d4b05so402112b3a.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 23:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751610415; x=1752215215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8Cadi1skh4P1ApGM+PqU48O5jgE1uMvu2URGbuzsOs=;
        b=hDWAGzADIs12fKOuKp1YQk8/cmpW8Wy8feJUMGY8L1ky4VsHkAAh+Ur/+Xfbhy8EdQ
         QxjWqPi7Ft1sxr/dssAI5S2b6wKqq0Q457kkv19utarqRUpFljfvNrD8yy9ppSNHCoyq
         EDw80HoHfDo2SVwU8m5PcVD+BsHtmd3mSy4Sr/hlzHC/DpfAUsgtHgtqQ0/knfgNqFlD
         Jlczyw4gTrSf+ihu51OfJhideDzLmPl6xq2BLLdSMj26op3j+lwk4OJkk7QeMz5cLex4
         qsnlCrGb1u2hTirvVzvIiVhbIw8xq7/xrZd1UJ6+xOABpfH93aCA0dZmfMHS8kro5cfP
         LpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751610415; x=1752215215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8Cadi1skh4P1ApGM+PqU48O5jgE1uMvu2URGbuzsOs=;
        b=ZhZymlQQoISYLoxM2hLmxeOK2QlLHwdVPDwvpxIHea3JYnQSzUrFLuB3m7X6LmAx4N
         dhVWsCo6PX+XDbZp0b3hRglUr0LWYNmkP5XWyXeTc4nF4tVw3bZZWcxJ76SrOqSk+Pxn
         uqEp5DaZaHyHnr7l+CcyzQVFJqO/nj/umWk3CI87xPPNbg4cdHoO45lNry6J+LUjQAGM
         lsuuqmA5/7u8Jy9hQqZBM+VVKxteRK2XTWthL2/d1G/fXv8eNO/nVCc1F3RO3CiqZzrv
         O2MTkkZZ4t5Q94LFxYwGkjdsPatrg/wFYpuu4CkGhu+Q3GCeE91m6klLXSbQY/weiOQF
         9T7Q==
X-Gm-Message-State: AOJu0YytxjFzddM/SiAAf5qbl6Si6Owvm8AodBzhDiVSYdUf6XoNO6wg
	va+9jjHshnyx3U5uy2qg7G7dzA/EICOsdZo9PoFDAoEffV0LMf26vUbwPuMNYEYsKGQ=
X-Gm-Gg: ASbGncsBWkYcfNLaKNfZ4b3PY5MrQippd9nNThzYB4ADmUzsxRAVDmrsfZstbRcK8Kp
	oTekRirQ9fFh186kPzM4xOb5nn++GkVzQ0m8iEmvkKvKstStBXu0pLJFyUZIbhJaesGsJVeatDb
	zV9Enud0dOrL+FGbNyipM+b/OEFTNWIG4cGCmu+AyB/xUaJ9ndrPVckCJ7jGfR5GrSphqWcElmG
	u5STSzyJgi/IczLYt7tbF3zroyboB0/qEKlCbC4Z5QWeUYr//URn/3Z/dPRYcRkI7C2zT9LGcij
	CFq+BNZsnLBzTIpnhCJSNfgCO639qIfcniBhOs+QBwWm4uDkDPXXonyE8h7FTzaD7nQFPAS9TQv
	XYDejz5gXEOnb
X-Google-Smtp-Source: AGHT+IHFaMJdkIhohSafckGbE8EHuJ/2ezNmEPpqd4C13bAJDIW+YKMzKbMEQKLN3/tjGWY/2GuvOw==
X-Received: by 2002:a05:6a21:3a85:b0:204:4573:d855 with SMTP id adf61e73a8af0-226092b0ea7mr1255567637.9.1751610414723;
        Thu, 03 Jul 2025 23:26:54 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee5f643dsm1183240a12.37.2025.07.03.23.26.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 23:26:54 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	peterx@redhat.com,
	jgg@ziepe.ca
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v2 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Date: Fri,  4 Jul 2025 14:25:59 +0800
Message-ID: <20250704062602.33500-3-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250704062602.33500-1-lizhe.67@bytedance.com>
References: <20250704062602.33500-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

When vfio_pin_pages_remote() is called with a range of addresses that
includes large folios, the function currently performs individual
statistics counting operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of pages.
Batch processing of statistical counting operations can effectively enhance
performance.

In addition, the pages obtained through longterm GUP are neither invalid
nor reserved. Therefore, we can reduce the overhead associated with some
calls to function is_invalid_reserved_pfn().

The performance test results for completing the 16G VFIO IOMMU DMA mapping
are as follows.

Base(v6.16-rc4):
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.047 s (340.2 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.280 s (57.2 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.052 s (310.5 GB/s)

With this patch:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.027 s (602.1 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.257 s (62.4 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.031 s (517.4 GB/s)

For large folio, we achieve an over 40% performance improvement.
For small folios, the performance test results indicate a
slight improvement.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 83 ++++++++++++++++++++++++++++-----
 1 file changed, 71 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 1136d7ac6b59..03fce54e1372 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -318,7 +318,13 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
 /*
  * Helper Functions for host iova-pfn list
  */
-static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
+
+/*
+ * Find the highest vfio_pfn that overlapping the range
+ * [iova_start, iova_end) in rb tree.
+ */
+static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
+		dma_addr_t iova_start, dma_addr_t iova_end)
 {
 	struct vfio_pfn *vpfn;
 	struct rb_node *node = dma->pfn_list.rb_node;
@@ -326,9 +332,9 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 	while (node) {
 		vpfn = rb_entry(node, struct vfio_pfn, node);
 
-		if (iova < vpfn->iova)
+		if (iova_end <= vpfn->iova)
 			node = node->rb_left;
-		else if (iova > vpfn->iova)
+		else if (iova_start > vpfn->iova)
 			node = node->rb_right;
 		else
 			return vpfn;
@@ -336,6 +342,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 	return NULL;
 }
 
+static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
+{
+	return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
+}
+
 static void vfio_link_pfn(struct vfio_dma *dma,
 			  struct vfio_pfn *new)
 {
@@ -614,6 +625,39 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	return ret;
 }
 
+
+static long vpfn_pages(struct vfio_dma *dma,
+		dma_addr_t iova_start, long nr_pages)
+{
+	dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
+	struct vfio_pfn *top = vfio_find_vpfn_range(dma, iova_start, iova_end);
+	long ret = 1;
+	struct vfio_pfn *vpfn;
+	struct rb_node *prev;
+	struct rb_node *next;
+
+	if (likely(!top))
+		return 0;
+
+	prev = next = &top->node;
+
+	while ((prev = rb_prev(prev))) {
+		vpfn = rb_entry(prev, struct vfio_pfn, node);
+		if (vpfn->iova < iova_start)
+			break;
+		ret++;
+	}
+
+	while ((next = rb_next(next))) {
+		vpfn = rb_entry(next, struct vfio_pfn, node);
+		if (vpfn->iova >= iova_end)
+			break;
+		ret++;
+	}
+
+	return ret;
+}
+
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
@@ -680,32 +724,47 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 		 * and rsvd here, and therefore continues to use the batch.
 		 */
 		while (true) {
+			long nr_pages, acct_pages = 0;
+
 			if (pfn != *pfn_base + pinned ||
 			    rsvd != is_invalid_reserved_pfn(pfn))
 				goto out;
 
+			/*
+			 * Using GUP with the FOLL_LONGTERM in
+			 * vaddr_get_pfns() will not return invalid
+			 * or reserved pages.
+			 */
+			nr_pages = num_pages_contiguous(
+					&batch->pages[batch->offset],
+					batch->size);
+			if (!rsvd) {
+				acct_pages = nr_pages;
+				acct_pages -= vpfn_pages(dma, iova, nr_pages);
+			}
+
 			/*
 			 * Reserved pages aren't counted against the user,
 			 * externally pinned pages are already counted against
 			 * the user.
 			 */
-			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
+			if (acct_pages) {
 				if (!dma->lock_cap &&
-				    mm->locked_vm + lock_acct + 1 > limit) {
+						mm->locked_vm + lock_acct + acct_pages > limit) {
 					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
 						__func__, limit << PAGE_SHIFT);
 					ret = -ENOMEM;
 					goto unpin_out;
 				}
-				lock_acct++;
+				lock_acct += acct_pages;
 			}
 
-			pinned++;
-			npage--;
-			vaddr += PAGE_SIZE;
-			iova += PAGE_SIZE;
-			batch->offset++;
-			batch->size--;
+			pinned += nr_pages;
+			npage -= nr_pages;
+			vaddr += PAGE_SIZE * nr_pages;
+			iova += PAGE_SIZE * nr_pages;
+			batch->offset += nr_pages;
+			batch->size -= nr_pages;
 
 			if (!batch->size)
 				break;
-- 
2.20.1



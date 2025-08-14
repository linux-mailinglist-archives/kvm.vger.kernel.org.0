Return-Path: <kvm+bounces-54644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ABAEEB25C31
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 08:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6D535C651C
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 06:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284B025B67D;
	Thu, 14 Aug 2025 06:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="glzjYCDr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F15A259C87
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 06:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755154078; cv=none; b=MaHdn778jlip+uoksmNdp6C6R61jOtbqLlnv9XA7O/V0c+bu1OAQ5NPrKmiAbJVhOpiIwGwsyHb3z/w2Domo+0+Gx+Gxsz2T2RXKXiQJvGQfulU9DjnmRQS7Z5Mfl9rduDE8OHX7BJogMRINzjooZieHMllWiE0JZPahJH+xJDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755154078; c=relaxed/simple;
	bh=mFXSz2Siy1Pew6CwdV4LSZSeW4M2WdAZEH2DPNRaKBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNTnazyYuVZVEsJphs1S2D+R3+K7H/Y1cwf9PUR6WWWU7fRDY9xYvZsfvcuwUJkdkhhXvR6DvGhEniq8l9tXqT/eYtg9dRYExMl5A8A4HgF3nNKSzluXC4V86cZugDJZnSA6Tl2xMPWytps4hSrub5NXVlZfFQmsiMyXo9V1TuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=glzjYCDr; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4717554c29so331530a12.3
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 23:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154075; x=1755758875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZcBk9MwxaNuqr2vt/at3ZKHAG+m/Z6cGsV80XrjtvQ=;
        b=glzjYCDrFHltZuRwLJMywHNr/pDmtTS3Kq9OL8jhbXaSywUF5eE+IPmcN4SZpEx/h9
         q82Js4PqtCNcdeUTemesAhgI9j6sX5uvzGSH0rBqyQO90vv246EUviE2v3rcH9lzGnXz
         YBIexR6JWaHDesxZz+sRwU45Fiisq5n8zIWYGu8m2iQBXh+QS1uo/3IRz8nHVDGDkGa/
         /xj+mGGF1ceDIlAJitSJ7slWK+auaIHdzm4tENOujG0ZfQqlodMmBEb82uD2AGwZxxt7
         WWuRs74XFqhxPdfwkXQa1ACnN98fT0rVpYG4EZMd2ObUV/cwLCrpbw3eS9Gcsz8hAjsO
         fQyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154075; x=1755758875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bZcBk9MwxaNuqr2vt/at3ZKHAG+m/Z6cGsV80XrjtvQ=;
        b=QZGLmRWhbYnVgIAOaN34Ax5F5xAL+zSW8ab5LIr1jn6LdNNtYDTVvycbe5EO2xjDMJ
         W3l4aK11wm3T/WJ5azwqljcK69TKnV7OQxP3u5dfQrXDcUyAxolq4xQJvoxG7iXsrRnl
         nMPS79mVStykZaWpaYP9RN50NEqJxM+l3vBFlDZUvmYN/rZlRNKOMNNQ9lrLxJVIeoqC
         LMhzcSsrmpuG8obbhZNL4qvctS0a7UYMV3uDOJQIKXA8Ki0Dn87f83MUvYw7TYqpqi/0
         yHaa7fmF+yeApM9Cwg6Gq1t34iXXJB1+sswnweTZC9SUikD5HFpVozLYjZpK0Z/6tM1d
         /PTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVIL5sfY++z+HrT8mELbCqLIz78t+0gLP/UoO6FPuoQGBiWDbvifzySgXPzF2g8KBtZMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT+ghbyo5QkxBag24gVyRHDH2Vkx73sgcYLZA6ldc7W/IH9bL7
	XaGQf1n8/b/k1a2XBDuoKtbeseIRdSyZ3FZWYqUMXbwV71WbdcdS+XnrhYiX7lxif8I=
X-Gm-Gg: ASbGnct7xDRInLbhr3VXAQRn9/eR51k8Wix9+iQIrDMGNycNL9y++MLMb8mrFAXuUng
	bBzgEBNDJxiJKil7kZ3luABhXJdphktXnfe/nCqiJy7zlQeWxFvuoJbGXEUNKGwnFPvmTDE4Bw9
	/PQV7tNGZ1faH5ziAFmodldSuNsjCTDb5SD06TIlTJ8i9qtXcOB4KSPWKu+LO8p6wop3G3rlvHw
	D6dmi6eXilj7OdkIiAMwQVOBF57oNIX05aD/p5+ROVhRzBTMfNjfN0MXqKTHmShxu2BLZcEZTVj
	KF7FWf70C90ZG1Y8xeWywRHeeIKTxVehlV2X5ct/35NMoWt4ek1wTb5USgRIhcsByeJSAQBgvEM
	vJIjkK2fU/mq+GtdQINNSi4Njd/h7khj1YEjQuUIO1d3NCA4a2g==
X-Google-Smtp-Source: AGHT+IH9qrcfN2simXDC/Z63ef3bhTYTOIKfZnDbd2f4Qsyxb3uglYIKUxcaUW+tnmMMPP5XmPrYhQ==
X-Received: by 2002:a17:902:f54b:b0:240:6766:ac01 with SMTP id d9443c01a7336-244589fd923mr33944065ad.2.1755154075409;
        Wed, 13 Aug 2025 23:47:55 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.47.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:47:55 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com
Subject: [PATCH v5 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Date: Thu, 14 Aug 2025 14:47:11 +0800
Message-ID: <20250814064714.56485-3-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
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

Base(v6.16):
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.049 s (328.5 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.268 s (59.6 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.051 s (310.9 GB/s)

With this patch:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.025 s (629.8 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.253 s (63.1 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.030 s (530.5 GB/s)

For large folio, we achieve an over 40% performance improvement.
For small folios, the performance test results indicate a
slight improvement.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/vfio/vfio_iommu_type1.c | 84 ++++++++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f8d68fe77b41..7829b5e268c2 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -37,6 +37,7 @@
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
+#include <linux/mm_inline.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -318,7 +319,13 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
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
@@ -326,9 +333,9 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
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
@@ -336,6 +343,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 	return NULL;
 }
 
+static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
+{
+	return vfio_find_vpfn_range(dma, iova, iova + 1);
+}
+
 static void vfio_link_pfn(struct vfio_dma *dma,
 			  struct vfio_pfn *new)
 {
@@ -614,6 +626,39 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
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
@@ -687,32 +732,47 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
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
+				    mm->locked_vm + lock_acct + acct_pages > limit) {
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



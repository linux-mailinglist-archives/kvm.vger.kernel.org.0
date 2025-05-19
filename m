Return-Path: <kvm+bounces-46960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25DD2ABB58A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 09:04:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1892F188DA41
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 07:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B10A266592;
	Mon, 19 May 2025 07:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="fn+5gbl5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89417226CE7
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 07:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747638277; cv=none; b=V6nhEMYb9bqFaXEgtXbWC0gfHCa5wJTawG8DLGk1cuUVRB29LVKYfLiSrvdJZhwRo8KCg4xTKjeUl+VDAHbhozueX6Hi7OZdDuvVYb9oXWivd2tX24Z1k4Ps3IBi3XmMa4BJTidMu4AdfgD3rDPeyoAIFl1IOjxuINuz19M0S3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747638277; c=relaxed/simple;
	bh=jNpcLC0d4VeqFu4NSt6w1xQs2p2sDlXibUipW0sqWcY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E4DcHh1FZmL2z+7v0KmuLe2K+3WZumXUvcfV68q9pkzquRrcifh5jsU23JkJq3p3zDvAiJ2hUtdp6Euw7e+3xkANW/X4NQAyhWKTs3j2MgXMIwCVvMvICM/H7kiIQ5pXO8uIVd278lqYBBaT9iFCPnw+W2b/wTEUzqCHTFF7yXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=fn+5gbl5; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-231fc83a33aso15431535ad.0
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 00:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1747638274; x=1748243074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6d/ek44Izp7b1CTMn95Qx6TcP2XC5XBAPS8Ee7ZMNyQ=;
        b=fn+5gbl5SbO5/ckLPxROn/e4XSn905ubLlRhUtuwuqAYcB68Tb/rfPZ1ho/6bJPZt0
         VfbJbIAwf5mZf0wXa6HshRcy7u1EwsoXIVMECMsf2t06urm06fL74J3icKyP8/JvLKF3
         va11uxxfsiq9D5KtWwl7lXbneLBLp7U20UBipYKDWzlyauwY/f6nimWDLR/QfaWRrm4h
         b1S2PbZdXL3iwHk11ZdtgZpMrv9n7hqIGOdAhmGrgbqu7P3hSe1ygfE8Am7So+6UTyqd
         KMMfSkpZi111u1BIrJghMYp/hMBW58aW5eVeNbLgJkhpJYh4NHLYLxzZhD4z795eJUH3
         mEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747638274; x=1748243074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6d/ek44Izp7b1CTMn95Qx6TcP2XC5XBAPS8Ee7ZMNyQ=;
        b=JWZRDSOGYh0ReF0jPXdkwxP9cZrmOE93vV5wR67FfIw90+fl8CDbh8m+DuP2mNosrG
         u/i9V52GuzOMbudcRG/HrAPbygLOo5Dle4pzSmNOJztg/DgOQb3D80sm3NfZ7ccY9esG
         W8AuNjmSm2brtOp7JXjBUxKSUlVLguIVcAHxok1Jm3LTDEIErEkuz6LjMCYvLjHqIqAc
         WWpa9ExJ5kz7RofPhMMw9UqaGPjr5U9ZwtFDnTSdpe3vf0+BvM5dR7sTfpiBjve08/T7
         GeaiRbHHw0jvHGVFv+btJ8Wp1Xl41snQc6LNhtQfewVHuTQ1Ud7x0aGiPzvOtoqCE4Fg
         7mUQ==
X-Gm-Message-State: AOJu0YxuhkfgUVSvU5khy8SHLiNYad+ILhkRW7rdgnMV0+zhbuPwj12M
	LEqKlTn/4CPnba2pgnGTI+XveheF725A71QEJrNMEHY7fsRp8Ol3a2RDSpmnh8YPb9Y=
X-Gm-Gg: ASbGncutYnbQvZSNKUYyi1BzRwtx0JuzX4dgYZPVf8IiN5UU9A1mbcUiGCi8X/ESgHz
	ynJer9V3ZhT9PSVqaV/CaZt3Ol0YaGopUKA5rXT6lvF7SG9gYYakDOsuRV83/VaHT7Kb9LW3luD
	2KgTm2hqD8HKNMmx+VHrem9nH9oFXYVjlvfFkgjU97hthZkB7jhQ7DLBiECSYqVZWHEjVVaN8ah
	N85CfuTr+OtBF2mbSXN7uRrVbhrKsSgFFD+WrmXhPJnU4/WzeV22WUDe8BfKj13EcpWmSUkgGcy
	SmoxECPfWihk5eIg7zVMTE/GPhsXY0x97T+x4wBnsZQgsD2JedLiAqFicH6sLCj5qsKLrQichL5
	0zPZAzN16wDUFMA==
X-Google-Smtp-Source: AGHT+IE707WZW3U3CzUUmYTZA/TqN9Y+hyC9+BbaPCwRSTgcY5/GPuoe9uiaAnWeKPpyFnc7JnFXqg==
X-Received: by 2002:a17:903:22ca:b0:22f:c530:102 with SMTP id d9443c01a7336-231de376f89mr160450355ad.31.1747638273616;
        Mon, 19 May 2025 00:04:33 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e988c3sm53140175ad.120.2025.05.19.00.04.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 May 2025 00:04:33 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	muchun.song@linux.dev
Subject: [PATCH v2] vfio/type1: optimize vfio_pin_pages_remote() for hugetlbfs folio
Date: Mon, 19 May 2025 15:04:19 +0800
Message-ID: <20250519070419.25827-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

When vfio_pin_pages_remote() is called with a range of addresses that
includes hugetlbfs folios, the function currently performs individual
statistics counting operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of pages.

This patch optimize this process by batching the statistics counting
operations.

The performance test results for completing the 8G VFIO IOMMU DMA mapping,
obtained through trace-cmd, are as follows. In this case, the 8G virtual
address space has been mapped to physical memory using hugetlbfs with
pagesize=2M.

Before this patch:
funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();

After this patch:
funcgraph_entry:      # 15635.055 us |  vfio_pin_map_dma();

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
Changelogs:

v1->v2:
- Fix some issues in comments and formatting.
- Consolidate vfio_find_vpfn_range() and vfio_find_vpfn().
- Move the processing logic for hugetlbfs folio into the while(true) loop
  and use a variable with a default value of 1 to indicate the number of
  consecutive pages.

v1 patch: https://lore.kernel.org/all/20250513035730.96387-1-lizhe.67@bytedance.com/

 drivers/vfio/vfio_iommu_type1.c | 70 +++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0ac56072af9f..2218ca415366 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -317,17 +317,20 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
 }
 
 /*
- * Helper Functions for host iova-pfn list
+ * Find the first vfio_pfn that overlapping the range
+ * [iova, iova + PAGE_SIZE * npage) in rb tree
  */
-static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
+static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
+		dma_addr_t iova, unsigned long npage)
 {
 	struct vfio_pfn *vpfn;
 	struct rb_node *node = dma->pfn_list.rb_node;
+	dma_addr_t end_iova = iova + PAGE_SIZE * npage;
 
 	while (node) {
 		vpfn = rb_entry(node, struct vfio_pfn, node);
 
-		if (iova < vpfn->iova)
+		if (end_iova <= vpfn->iova)
 			node = node->rb_left;
 		else if (iova > vpfn->iova)
 			node = node->rb_right;
@@ -337,6 +340,14 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 	return NULL;
 }
 
+/*
+ * Helper Functions for host iova-pfn list
+ */
+static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
+{
+	return vfio_find_vpfn_range(dma, iova, 1);
+}
+
 static void vfio_link_pfn(struct vfio_dma *dma,
 			  struct vfio_pfn *new)
 {
@@ -681,32 +692,67 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 		 * and rsvd here, and therefore continues to use the batch.
 		 */
 		while (true) {
+			int page_step = 1;
+			long lock_acct_step = 1;
+			struct folio *folio = page_folio(batch->pages[batch->offset]);
+			bool found_vpfn;
+
 			if (pfn != *pfn_base + pinned ||
 			    rsvd != is_invalid_reserved_pfn(pfn))
 				goto out;
 
+			/* Handle hugetlbfs page */
+			if (folio_test_hugetlb(folio)) {
+				unsigned long start_pfn = PHYS_PFN(vaddr);
+
+				/*
+				 * Note: The current page_step does not achieve the optimal
+				 * performance in scenarios where folio_nr_pages() exceeds
+				 * batch->capacity. It is anticipated that future enhancements
+				 * will address this limitation.
+				 */
+				page_step = min(batch->size,
+					ALIGN(start_pfn + 1, folio_nr_pages(folio)) - start_pfn);
+				found_vpfn = !!vfio_find_vpfn_range(dma, iova, page_step);
+				if (rsvd || !found_vpfn) {
+					lock_acct_step = page_step;
+				} else {
+					dma_addr_t tmp_iova = iova;
+					int i;
+
+					lock_acct_step = 0;
+					for (i = 0; i < page_step; ++i, tmp_iova += PAGE_SIZE)
+						if (!vfio_find_vpfn(dma, tmp_iova))
+							lock_acct_step++;
+					if (lock_acct_step)
+						found_vpfn = false;
+				}
+			} else {
+				found_vpfn = vfio_find_vpfn(dma, iova);
+			}
+
 			/*
 			 * Reserved pages aren't counted against the user,
 			 * externally pinned pages are already counted against
 			 * the user.
 			 */
-			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
+			if (!rsvd && !found_vpfn) {
 				if (!dma->lock_cap &&
-				    mm->locked_vm + lock_acct + 1 > limit) {
+				    mm->locked_vm + lock_acct + lock_acct_step > limit) {
 					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
 						__func__, limit << PAGE_SHIFT);
 					ret = -ENOMEM;
 					goto unpin_out;
 				}
-				lock_acct++;
+				lock_acct += lock_acct_step;
 			}
 
-			pinned++;
-			npage--;
-			vaddr += PAGE_SIZE;
-			iova += PAGE_SIZE;
-			batch->offset++;
-			batch->size--;
+			pinned += page_step;
+			npage -= page_step;
+			vaddr += PAGE_SIZE * page_step;
+			iova += PAGE_SIZE * page_step;
+			batch->offset += page_step;
+			batch->size -= page_step;
 
 			if (!batch->size)
 				break;
-- 
2.20.1



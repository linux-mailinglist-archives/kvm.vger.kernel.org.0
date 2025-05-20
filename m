Return-Path: <kvm+bounces-47080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4337ABCFFF
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 09:00:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 256383BEE0A
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 07:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A7F25CC7A;
	Tue, 20 May 2025 07:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="dGTVK3LK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9BB20E6
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 07:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747724437; cv=none; b=f3Np27MW3DSdeXBIc5MvZaBsdRyTTClKDwKnQFEOHlrRSCbVkC/rn7qjdqpFDiZ0QYR+DZ1MCj2mhrQdz72/8tQSdVbvIu4ryg+lKuSwTfFalMlKj/g+DwRc/V8h7F8rCYnUmoOZDaWLupE9gcpwzV/SSgJbs/tHWJzAmpyjzAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747724437; c=relaxed/simple;
	bh=7NxhdigZ82QnVowEcqj++dSX/lzsiiQrLwTIFBW5fE0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sVOaaQPDUHL4tn3PKQCJKca/gPiXPKHyy15vzmz5PU3A/hlvIEhc7W+SFjZN7VXkn2ncNHwvMcIRjIKpqbfZrDRyxOHCn1RcomeSJpyQC/VYseDwiz3KLXi51psGK+N1K9G8NCzjDzksVTI0ddFuddI1IRnHiUgyF+Z8fELvswA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=dGTVK3LK; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso6716376b3a.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 00:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1747724435; x=1748329235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ff9F/0DQJXXOaC1XJzAjuzNhvSsUDESXc6O/jTJ6rOQ=;
        b=dGTVK3LKrXIw7306sE7sbcHpd/wTL6vrqNDUjGQiDW8L/clLylm7RgfWxgssc36zTY
         MTePwao5dOclrWqYrQoZe0IpCxmM8DtpNpmsRSos9VQ0HpVjy6/Ha4ea9LSviy2dWzGv
         nUWiQQCIGP1uBlF08raghpdfcT9lt9bd/TzKBbsaxwg97sDbO6bCK5goQOBIwsVVbYZE
         vhQZC4rzL2OKjGzoXwrqzktAOG7VUYnNWUYo9cHszwFHmQo34jXBJsrXk9nckuYiOZA5
         wFuXlLEYEzEpsvr451HCdgM4RtarF5N4thJxLmQWezfAprg80OPAVvYmzCfuM+fiHBG5
         mszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747724435; x=1748329235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ff9F/0DQJXXOaC1XJzAjuzNhvSsUDESXc6O/jTJ6rOQ=;
        b=Z7oT4MPvrvbBKz/8qR4/WqFtc+dLvS+5t1ysc3gy+LuYUAwndUFqLyndyJ6Bv4ebEj
         xddC05CCv2KmxFAOZWTtW5B14vqxINvEYmUMGxYPC26jQpXB4of8IOGXgwyw7OCAd+Fl
         NDpu5H72ZeKE32JqUQlzvNWSG9zu/vNfW1hzN3Y6xCG3D57W2rg7akO//nDnpOCRiARH
         3py+ulzBcD84iSQmw5ICGyq5gpw/Z+7RTD2SEI37i47MR4dKrJfiL5uGJfYTbq1CI1Wm
         voWYV0C8Lb9TCuMuKuGEmTJG8sLtXNTlCnCUsX5XJjAborxHX2uNpqVlpXOJufYYjpxu
         lOQQ==
X-Gm-Message-State: AOJu0YxJS2FjpSF4rp1ue7enuvqJ87x7s3xIPUu9vvRQFieDLoSU6NfA
	Di1e7T52A4VDp8qC3dJ/4qVwJgT66WJmJfy3uHjSDlDoOGL4CbywyyXXFHGd0SY3B84=
X-Gm-Gg: ASbGncuC4iSEdO4WFZwqPCPIJr+dVxq57WwFkWCk0QIiA8CkCW0a+cWoQXP3JOCCshi
	pu36nIf8q7/GNaJAeRvD+MDATaEimOR9kddf9mUiooVtLybOKNeEHsLODgotCMwT+b/Q1Bdw12A
	GSbCmTGgv51TyFNgUkV8ZVrao0Gf7zYO3Eqs3iFOAph14dqIOR8bZOLOl5hp4AuqjaFLxXGwBlZ
	ieWKos70N57NqtOswCw0YV+wLGRbZDwnEo0U1+///T1oIAbaSp0E6H7b+/68eYn1qC0MVJlRdLy
	PEDndSMbsAs/5QDd0mnPss6RdgVyBzwqFc7KDDhLTgTpw4flukJ8Nmk2w5BAkjVgWpkHQaN3sDc
	iWQ==
X-Google-Smtp-Source: AGHT+IE2UUD5R4s/WvPiXuoKLU/Iu/dG3zcz5OVyolIzRJsK9e7kKmhBl42IJ6kwx4IBjwk0q4Rmeg==
X-Received: by 2002:a05:6a21:1089:b0:1f5:6b36:f56c with SMTP id adf61e73a8af0-2170ce39a55mr20972295637.39.1747724434707;
        Tue, 20 May 2025 00:00:34 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eaf5a441sm7325968a12.8.2025.05.20.00.00.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 May 2025 00:00:34 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	muchun.song@linux.dev
Subject: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge folio
Date: Tue, 20 May 2025 15:00:20 +0800
Message-ID: <20250520070020.6181-1-lizhe.67@bytedance.com>
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
includes huge folios, the function currently performs individual
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
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
Changelogs:

v2->v3:
- Code simplification.
- Fix some issues in comments.

v1->v2:
- Fix some issues in comments and formatting.
- Consolidate vfio_find_vpfn_range() and vfio_find_vpfn().
- Move the processing logic for huge folio into the while(true) loop
  and use a variable with a default value of 1 to indicate the number
  of consecutive pages.

v2 patch: https://lore.kernel.org/all/20250519070419.25827-1-lizhe.67@bytedance.com/
v1 patch: https://lore.kernel.org/all/20250513035730.96387-1-lizhe.67@bytedance.com/

 drivers/vfio/vfio_iommu_type1.c | 48 +++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0ac56072af9f..48f06ce0e290 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -319,15 +319,22 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
 /*
  * Helper Functions for host iova-pfn list
  */
-static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
+
+/*
+ * Find the first vfio_pfn that overlapping the range
+ * [iova, iova + PAGE_SIZE * npage) in rb tree.
+ */
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
@@ -337,6 +344,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 	return NULL;
 }
 
+static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
+{
+	return vfio_find_vpfn_range(dma, iova, 1);
+}
+
 static void vfio_link_pfn(struct vfio_dma *dma,
 			  struct vfio_pfn *new)
 {
@@ -681,32 +693,46 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 		 * and rsvd here, and therefore continues to use the batch.
 		 */
 		while (true) {
+			struct folio *folio = page_folio(batch->pages[batch->offset]);
+			long nr_pages;
+
 			if (pfn != *pfn_base + pinned ||
 			    rsvd != is_invalid_reserved_pfn(pfn))
 				goto out;
 
+			/*
+			 * Note: The current nr_pages does not achieve the optimal
+			 * performance in scenarios where folio_nr_pages() exceeds
+			 * batch->capacity. It is anticipated that future enhancements
+			 * will address this limitation.
+			 */
+			nr_pages = min((long)batch->size, folio_nr_pages(folio) -
+						folio_page_idx(folio, batch->pages[batch->offset]));
+			if (nr_pages > 1 && vfio_find_vpfn_range(dma, iova, nr_pages))
+				nr_pages = 1;
+
 			/*
 			 * Reserved pages aren't counted against the user,
 			 * externally pinned pages are already counted against
 			 * the user.
 			 */
-			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
+			if (!rsvd && (nr_pages > 1 || !vfio_find_vpfn(dma, iova))) {
 				if (!dma->lock_cap &&
-				    mm->locked_vm + lock_acct + 1 > limit) {
+				    mm->locked_vm + lock_acct + nr_pages > limit) {
 					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
 						__func__, limit << PAGE_SHIFT);
 					ret = -ENOMEM;
 					goto unpin_out;
 				}
-				lock_acct++;
+				lock_acct += nr_pages;
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



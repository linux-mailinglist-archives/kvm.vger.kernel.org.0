Return-Path: <kvm+bounces-43629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD28A932C8
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 08:56:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CE2F1887594
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 06:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14DAC28F527;
	Fri, 18 Apr 2025 06:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8xsLgZW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AC0288C9A;
	Fri, 18 Apr 2025 06:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744958947; cv=none; b=sEycMnU2YGQncIPHf0seDpMIJ8yqGgKSj/eDrhl+mw7iMXOughY5Fy54TD2u1qJL4jQFmE/b90Z17bSwsq2hnFZjyyN4hMkVIEMD7F6doQYsgnkmHwir6mfkCTT0SE2YcUJkiEhGtcMAhZEb7b0LqiDT0IT1pLkyDdnTvhZXS+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744958947; c=relaxed/simple;
	bh=FGXDsNA0sR7G/5v+LnwSm5/sUMLhEeMj7l+/Osc6L2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcrnMYX7vITvb7EFBQzW/0z2F4CO23yKmS44+dhO60t/vTExC9YrnRyt5IENfBCD+eeiqkh+WBd7lA2lEgQiI2zLBpbw63ayTr/S98j7iVxeIMWE4o4phSMFg8xeKfcdmvEFS0WVSi7lEbyiw0Pmfmtv+/Q/12yUPhYQTUYd8gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8xsLgZW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B367C4CEE7;
	Fri, 18 Apr 2025 06:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744958946;
	bh=FGXDsNA0sR7G/5v+LnwSm5/sUMLhEeMj7l+/Osc6L2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8xsLgZWIx/US9R6pj3eRnpqPtX+d8I55kJMo6U7/IDuuX/AwydFE+tN8fIDWjOc9
	 Dn8YJI4xhLUzIwm4/jrvXHxnREOauqrN77cGM+D6lLNrik5e+pWaW9422xm1PN5a92
	 x4i7bARpGCzIWHO5ftNP5UUMQYq5y3ulySQeGmD1qdncWWC4KQMUR7pme/1Kp2YqRv
	 pROXVYAzPeSUUbddwd5uuRoY8QX+1ASGEgfB0jZL/K0F0itHqPMAAl+356idT0cdWF
	 sEBLLpbayG4diDeAAyf3NCNHSxdfVNqMn/DkttF2SHa9pZVtwnBoTacdQ9+sd1SHQe
	 ENtJZuoTsdpVQ==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH v8 18/24] block: share more code for bio addition helper
Date: Fri, 18 Apr 2025 09:47:48 +0300
Message-ID: <753430b79ac788786ea065dac648fa662d4666b9.1744825142.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1744825142.git.leon@kernel.org>
References: <cover.1744825142.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

__bio_iov_iter_get_pages currently open codes adding pages to the bio,
which duplicates a lot of code from bio_add_page. Add bio_add_page_int
helper that pass down the same_page output argument so that
__bio_iov_iter_get_pages can reuse the main add bio to page helpers.

Note that I'd normally call these helper __bio_add_page, but the former
is already taken for an exported API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/bio.c | 68 +++++++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 36 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4e6c85a33d74..3047fa3f4b32 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -989,20 +989,9 @@ void __bio_add_page(struct bio *bio, struct page *page,
 }
 EXPORT_SYMBOL_GPL(__bio_add_page);
 
-/**
- *	bio_add_page	-	attempt to add page(s) to bio
- *	@bio: destination bio
- *	@page: start page to add
- *	@len: vec entry length, may cross pages
- *	@offset: vec entry offset relative to @page, may cross pages
- *
- *	Attempt to add page(s) to the bio_vec maplist. This will only fail
- *	if either bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.
- */
-int bio_add_page(struct bio *bio, struct page *page,
-		 unsigned int len, unsigned int offset)
+static int bio_add_page_int(struct bio *bio, struct page *page,
+		 unsigned int len, unsigned int offset, bool *same_page)
 {
-	bool same_page = false;
 
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return 0;
@@ -1011,7 +1000,7 @@ int bio_add_page(struct bio *bio, struct page *page,
 
 	if (bio->bi_vcnt > 0 &&
 	    bvec_try_merge_page(&bio->bi_io_vec[bio->bi_vcnt - 1],
-				page, len, offset, &same_page)) {
+				page, len, offset, same_page)) {
 		bio->bi_iter.bi_size += len;
 		return len;
 	}
@@ -1021,6 +1010,24 @@ int bio_add_page(struct bio *bio, struct page *page,
 	__bio_add_page(bio, page, len, offset);
 	return len;
 }
+
+/**
+ * bio_add_page	- attempt to add page(s) to bio
+ * @bio: destination bio
+ * @page: start page to add
+ * @len: vec entry length, may cross pages
+ * @offset: vec entry offset relative to @page, may cross pages
+ *
+ * Attempt to add page(s) to the bio_vec maplist.  Will only fail if the
+ * bio is full, or it is incorrectly used on a cloned bio.
+ */
+int bio_add_page(struct bio *bio, struct page *page,
+		 unsigned int len, unsigned int offset)
+{
+	bool same_page = false;
+
+	return bio_add_page_int(bio, page, len, offset, &same_page);
+}
 EXPORT_SYMBOL(bio_add_page);
 
 void bio_add_folio_nofail(struct bio *bio, struct folio *folio, size_t len,
@@ -1088,27 +1095,6 @@ void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter)
 	bio_set_flag(bio, BIO_CLONED);
 }
 
-static int bio_iov_add_folio(struct bio *bio, struct folio *folio, size_t len,
-			     size_t offset)
-{
-	bool same_page = false;
-
-	if (WARN_ON_ONCE(bio->bi_iter.bi_size > UINT_MAX - len))
-		return -EIO;
-
-	if (bio->bi_vcnt > 0 &&
-	    bvec_try_merge_page(&bio->bi_io_vec[bio->bi_vcnt - 1],
-				folio_page(folio, 0), len, offset,
-				&same_page)) {
-		bio->bi_iter.bi_size += len;
-		if (same_page && bio_flagged(bio, BIO_PAGE_PINNED))
-			unpin_user_folio(folio, 1);
-		return 0;
-	}
-	bio_add_folio_nofail(bio, folio, len, offset);
-	return 0;
-}
-
 static unsigned int get_contig_folio_len(unsigned int *num_pages,
 					 struct page **pages, unsigned int i,
 					 struct folio *folio, size_t left,
@@ -1203,6 +1189,8 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	for (left = size, i = 0; left > 0; left -= len, i += num_pages) {
 		struct page *page = pages[i];
 		struct folio *folio = page_folio(page);
+		struct page *first_page = folio_page(folio, 0);
+		bool same_page = false;
 
 		folio_offset = ((size_t)folio_page_idx(folio, page) <<
 			       PAGE_SHIFT) + offset;
@@ -1215,7 +1203,15 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 			len = get_contig_folio_len(&num_pages, pages, i,
 						   folio, left, offset);
 
-		bio_iov_add_folio(bio, folio, len, folio_offset);
+		if (bio_add_page_int(bio, first_page, len, folio_offset,
+				     &same_page) != len) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (same_page && bio_flagged(bio, BIO_PAGE_PINNED))
+			unpin_user_folio(folio, 1);
+
 		offset = 0;
 	}
 
-- 
2.49.0



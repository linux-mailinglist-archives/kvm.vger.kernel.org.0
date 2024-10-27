Return-Path: <kvm+bounces-29784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85CA69B1E8E
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 15:29:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB6C7B217E1
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 14:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 106A11D86C3;
	Sun, 27 Oct 2024 14:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r+zfRmfg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F751D7982;
	Sun, 27 Oct 2024 14:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730038969; cv=none; b=Ar+H5hl/RApJrhwcAbNpDUQVriV9mc55cXOvc/Pp1ySu/3IpJU5E0aLLqgDC9eF2CBR0akIWKGEK1NVC/CbSaSLAWmgCDO20ZQ588HNozTSgfkPrYidC+rkHJvPfCZNnPzULbL8TexXiFv/OWouIAR21+deO5iVAuHGroOE8Gio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730038969; c=relaxed/simple;
	bh=Ig+DtUOzk0wRj0C/EWVGPiHozm6V2fkXLKm30AePHJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E848eaVbWLg/dF2Vbi1V/H9qFbWffFFk5RkUaMhfgVRCy2KhPRKEOV0qbhl4Sezh7u9xve8NB/kagsVPGhzWLF3n7jzKpP49JMyaoVA3EGaEBBEO6IQB1HX4wY4STBLZ0CC87llyvzXXlOX+Y8gg3j4PeOoG3ywnJBoPIswH5lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r+zfRmfg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270F5C4CEC3;
	Sun, 27 Oct 2024 14:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730038968;
	bh=Ig+DtUOzk0wRj0C/EWVGPiHozm6V2fkXLKm30AePHJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+zfRmfgUjBdKG0sjFH7EFWB14iiJjvEXA1eTMDEC2NPGsxgK3GK1ozAFere43Kk3
	 Olw8VnLKVDFHXG1xCYeSjKw7t2cyNGOGv1SB0qzIaO7Hjg9oYHlDJVIAPTr9/UTSPh
	 iBN4VQUVqSBI7htWJrXD6Vj/LvGOfrORvquuGrGjQyhyT4sD/QndXQDzjQPGyamfu0
	 9FwwvLYJyeH8muOh/ZbuS9SltR1FQiEn/M9pPcFgU0ARzo04FYi2f55G1NgIoF90fU
	 gugpxORRZ1GMtHC/dWj350ZIJ+YXqS8sneoRix0wJR8tDnk8guw7Mz4U+sUsPYyPVa
	 1pQyQWXPE7NcA==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/7] block: share more code for bio addition helpers
Date: Sun, 27 Oct 2024 16:21:54 +0200
Message-ID: <e6be9d87a3ca1a2f9c27bce73fbab559c21c765f.1730037261.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730037261.git.leon@kernel.org>
References: <cover.1730037261.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

__bio_iov_iter_get_pages currently open codes adding pages to the bio,
which duplicates a lot of code from bio_add_page and
bio_add_zone_append_page.  Add bio_add_page_int and
bio_add_zone_append_page_int helpers that pass down the same_page
output argument so that __bio_iov_iter_get_pages can reuse the main
add bio to page helpers.

Note that I'd normally call these helpers __bio_add_page and
__bio_add_zone_append_page, but the former is already taken for an
exported API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/bio.c | 114 +++++++++++++++++++++++-----------------------------
 1 file changed, 51 insertions(+), 63 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ac4d77c88932..2d3bc8bfb071 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1064,6 +1064,19 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio,
 }
 EXPORT_SYMBOL(bio_add_pc_page);
 
+static int bio_add_zone_append_page_int(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int offset, bool *same_page)
+{
+	struct block_device *bdev = bio->bi_bdev;
+
+	if (WARN_ON_ONCE(bio_op(bio) != REQ_OP_ZONE_APPEND))
+		return 0;
+	if (WARN_ON_ONCE(!bdev_is_zoned(bdev)))
+		return 0;
+	return bio_add_hw_page(bdev_get_queue(bdev), bio, page, len, offset,
+			bdev_max_zone_append_sectors(bdev), same_page);
+}
+
 /**
  * bio_add_zone_append_page - attempt to add page to zone-append bio
  * @bio: destination bio
@@ -1083,17 +1096,9 @@ EXPORT_SYMBOL(bio_add_pc_page);
 int bio_add_zone_append_page(struct bio *bio, struct page *page,
 			     unsigned int len, unsigned int offset)
 {
-	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	bool same_page = false;
 
-	if (WARN_ON_ONCE(bio_op(bio) != REQ_OP_ZONE_APPEND))
-		return 0;
-
-	if (WARN_ON_ONCE(!bdev_is_zoned(bio->bi_bdev)))
-		return 0;
-
-	return bio_add_hw_page(q, bio, page, len, offset,
-			       queue_max_zone_append_sectors(q), &same_page);
+	return bio_add_zone_append_page_int(bio, page, len, offset, &same_page);
 }
 EXPORT_SYMBOL_GPL(bio_add_zone_append_page);
 
@@ -1119,20 +1124,9 @@ void __bio_add_page(struct bio *bio, struct page *page,
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
@@ -1141,7 +1135,7 @@ int bio_add_page(struct bio *bio, struct page *page,
 
 	if (bio->bi_vcnt > 0 &&
 	    bvec_try_merge_page(&bio->bi_io_vec[bio->bi_vcnt - 1],
-				page, len, offset, &same_page)) {
+				page, len, offset, same_page)) {
 		bio->bi_iter.bi_size += len;
 		return len;
 	}
@@ -1151,6 +1145,24 @@ int bio_add_page(struct bio *bio, struct page *page,
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
@@ -1224,41 +1236,6 @@ void bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter)
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
-static int bio_iov_add_zone_append_folio(struct bio *bio, struct folio *folio,
-					 size_t len, size_t offset)
-{
-	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	bool same_page = false;
-
-	if (bio_add_hw_folio(q, bio, folio, len, offset,
-			queue_max_zone_append_sectors(q), &same_page) != len)
-		return -EINVAL;
-	if (same_page && bio_flagged(bio, BIO_PAGE_PINNED))
-		unpin_user_folio(folio, 1);
-	return 0;
-}
-
 static unsigned int get_contig_folio_len(unsigned int *num_pages,
 					 struct page **pages, unsigned int i,
 					 struct folio *folio, size_t left,
@@ -1353,6 +1330,8 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	for (left = size, i = 0; left > 0; left -= len, i += num_pages) {
 		struct page *page = pages[i];
 		struct folio *folio = page_folio(page);
+		struct page *first_page = folio_page(folio, 0);
+		bool same_page = false;
 
 		folio_offset = ((size_t)folio_page_idx(folio, page) <<
 			       PAGE_SHIFT) + offset;
@@ -1366,12 +1345,21 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 						   folio, left, offset);
 
 		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
-			ret = bio_iov_add_zone_append_folio(bio, folio, len,
-					folio_offset);
-			if (ret)
+			if (bio_add_zone_append_page_int(bio, first_page, len,
+					folio_offset, &same_page) != len) {
+				ret = -EINVAL;
+				break;
+			}
+		} else {
+			if (bio_add_page_int(bio, folio_page(folio, 0), len,
+					folio_offset, &same_page) != len) {
+				ret = -EINVAL;
 				break;
-		} else
-			bio_iov_add_folio(bio, folio, len, folio_offset);
+			}
+		}
+
+		if (same_page && bio_flagged(bio, BIO_PAGE_PINNED))
+			unpin_user_folio(folio, 1);
 
 		offset = 0;
 	}
-- 
2.46.2



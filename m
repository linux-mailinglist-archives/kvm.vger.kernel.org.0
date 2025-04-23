Return-Path: <kvm+bounces-43901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A16DA98329
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:25:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF3D75A2C67
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 08:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05D028DEF8;
	Wed, 23 Apr 2025 08:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZwAGDANF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03A228D833;
	Wed, 23 Apr 2025 08:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396123; cv=none; b=ILThK8izSiTkcn1R498RVShlhCRI9KN32YnwWBj5UDL2HXc7LBJbW723/ocTUhKFmExHaorlspazvlG4UWqedKNIUR/ogszPF4ZaUIVfT5ng0kdLUIVsXyTOHw/2QE2efUoNG+TwTtM53xW0bgwoIL2zo2+hnBf77mpPQw7iJPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396123; c=relaxed/simple;
	bh=cn4ZAo5vXix5AGqKt4IWuh2vUXjY6lms9OP/AMjOBBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X71FUXCx7FBxmMNMgd8cJU+fWVJ5KEBrWRF20D8fGEfRQXKjtEvPiqOKWyMKD4qwKvcfKk88fXfUtuEcSB+zUlvPmtWgnbSoR9Hjl73npgooQiM1lxmjfL+VliUROBlluW/SZ5if0eMMrE7zQ2m2PJ8UDOE9og3holnQXra+lKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZwAGDANF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D29EC4CEE2;
	Wed, 23 Apr 2025 08:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745396122;
	bh=cn4ZAo5vXix5AGqKt4IWuh2vUXjY6lms9OP/AMjOBBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwAGDANFggif/hHltTNo8DS7CSr4dJ00Q3R5ZRUxc8p6YRcxW2Lj6kWmBx7/8c9H5
	 wmgLi7E2a+XY5LiJhP/LXoYgUKAVzP/ZwN9ZbtltMq0H2j+AaS9vTpeLltvOHxxZd9
	 LAYummtSsqYqrS/KPLAK9W81c7AHdR5yPznv1Dj/FWGoRDi5PXKtpEGeP32BPmjmr+
	 0DUEf0vS1i4dlH62ffr2h5zPpj4Wk3O87mudPGw+9SKBWNHKijyJW/JJP49Ottbcx8
	 negOOECUXtCMloS2LE0IiNlcf09HlES8p5G+10r0swXnI90B/uaeAfr8qqFaRD+LQD
	 Hxx5CHvagu3pQ==
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
Subject: [PATCH v9 19/24] block: don't merge different kinds of P2P transfers in a single bio
Date: Wed, 23 Apr 2025 11:13:10 +0300
Message-ID: <cef56f0527beaf7022c1a743f332d46035ca612c.1745394536.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1745394536.git.leon@kernel.org>
References: <cover.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

To get out of the dma mapping helpers having to check every segment for
it's P2P status, ensure that bios either contain P2P transfers or non-P2P
transfers, and that a P2P bio only contains ranges from a single device.

This means we do the page zone access in the bio add path where it should
be still page hot, and will only have do the fairly expensive P2P topology
lookup once per bio down in the dma mapping path, and only for already
marked bios.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/bio.c               | 17 ++++++++++-------
 block/blk-merge.c         | 17 +++++++++++------
 include/linux/blk_types.h |  2 ++
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 3047fa3f4b32..279eac2396bf 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -928,8 +928,6 @@ static bool bvec_try_merge_page(struct bio_vec *bv, struct page *page,
 		return false;
 	if (xen_domain() && !xen_biovec_phys_mergeable(bv, page))
 		return false;
-	if (!zone_device_pages_have_same_pgmap(bv->bv_page, page))
-		return false;
 
 	*same_page = ((vec_end_addr & PAGE_MASK) == ((page_addr + off) &
 		     PAGE_MASK));
@@ -998,11 +996,16 @@ static int bio_add_page_int(struct bio *bio, struct page *page,
 	if (bio->bi_iter.bi_size > UINT_MAX - len)
 		return 0;
 
-	if (bio->bi_vcnt > 0 &&
-	    bvec_try_merge_page(&bio->bi_io_vec[bio->bi_vcnt - 1],
-				page, len, offset, same_page)) {
-		bio->bi_iter.bi_size += len;
-		return len;
+	if (bio->bi_vcnt > 0) {
+		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+		if (bvec_try_merge_page(bv, page, len, offset, same_page)) {
+			bio->bi_iter.bi_size += len;
+			return len;
+		}
+	} else {
+		if (is_pci_p2pdma_page(page))
+			bio->bi_opf |= REQ_P2PDMA | REQ_NOMERGE;
 	}
 
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index fdd4efb54c6c..d9691e900cc6 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -320,12 +320,17 @@ int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
 	unsigned nsegs = 0, bytes = 0;
 
 	bio_for_each_bvec(bv, bio, iter) {
-		/*
-		 * If the queue doesn't support SG gaps and adding this
-		 * offset would create a gap, disallow it.
-		 */
-		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv.bv_offset))
-			goto split;
+		if (bvprvp) {
+			/*
+			 * If the queue doesn't support SG gaps and adding this
+			 * offset would create a gap, disallow it.
+			 */
+			if (bvec_gap_to_prev(lim, bvprvp, bv.bv_offset))
+				goto split;
+		} else {
+			if (is_pci_p2pdma_page(bv.bv_page))
+				bio->bi_opf |= REQ_P2PDMA | REQ_NOMERGE;
+		}
 
 		if (nsegs < lim->max_segments &&
 		    bytes + bv.bv_len <= max_bytes &&
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index dce7615c35e7..94cf146e8ce6 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -378,6 +378,7 @@ enum req_flag_bits {
 	__REQ_DRV,		/* for driver use */
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
 	__REQ_ATOMIC,		/* for atomic write operations */
+	__REQ_P2PDMA,		/* contains P2P DMA pages */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -410,6 +411,7 @@ enum req_flag_bits {
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
+#define REQ_P2PDMA	(__force blk_opf_t)(1ULL << __REQ_P2PDMA)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
 
-- 
2.49.0



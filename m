Return-Path: <kvm+bounces-20841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0999A923985
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0733282758
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F6B156C6B;
	Tue,  2 Jul 2024 09:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6hNK7RX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8C1156C40;
	Tue,  2 Jul 2024 09:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911471; cv=none; b=I6QDvszvIPMhiy+qerqlw/ono6Ik3lnxdaPj01J0IBNd2q55TuoXLiaZ+rtz9MlBEqzWydLkhWT977/E/A0otiZ/TZUytAnMmbtmGcRCk1Z77zpNYnihQZFvo9Mb68tEwe/1lH3dun3ZcM9AKa6OnpnSOILEF56ZfNx9Lc/+Z80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911471; c=relaxed/simple;
	bh=rWwAHyiwmax8yvMjrwSRAusPbIB/KT92oJ4QN5II8o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uwuB1V+B4RBmHYgt06nUppznL3i1GWUtiAZK1O7I6jMl1foclbL8svmqvcxWqC+NzFkACaUmq4xpqjNpkn4g2OZ7DA1pbKbi97/PwgOYzaHl4cTCeDuEKvFLQZnvEyKSohBxuH3JWTEhQYeo7SIz5iIPSnZntXZsbLuznuZshK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6hNK7RX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336E6C116B1;
	Tue,  2 Jul 2024 09:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719911470;
	bh=rWwAHyiwmax8yvMjrwSRAusPbIB/KT92oJ4QN5II8o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6hNK7RXDkaA/i33kcQvJ4JKz8/yPjpD5lRL7DqV5Xmj2oQvXnyGYAQ2epTmINygy
	 0y19irtGTGWm+OtjW5NkAItWfTaPfLe+Fvzo6XpXK70xytP//3+E0opt8r1DuIjpCG
	 8r0JXPXWB2Z4hDwHlXlzcZ3/Bm1gsukpVrzK5gOHjyumUYCJ6hIXV0+iG4nt9CDCbA
	 AVvnWwKND922egkc2IkGqZ7kYK3GZ63NIoDvDrhXUVUjhoQqnTcoiujq6cCinieq+O
	 VSwcXGDkFUwWonCqIjy2AUNt+QmmYZvJX5fJ8Y5c5HTLjsPFdIJ2jHoXuGkDlZv1PP
	 3XgJzr2OB4ILA==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1 18/18] nvme-pci: use new dma API
Date: Tue,  2 Jul 2024 12:09:48 +0300
Message-ID: <47eb0510b0a6aa52d9f5665d75fa7093dd6af53f.1719909395.git.leon@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1719909395.git.leon@kernel.org>
References: <cover.1719909395.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chaitanya Kulkarni <kch@nvidia.com>

Introduce a new structure, iod_dma_map, to hold the DMA mapping for each
I/O. This includes the iova state and mapped addresses from
dma_link_range() or dma_map_page_attrs(). Replace the existing sg_table
in nvme_iod with struct dma_map. The size difference between :-

struct nvme_iod with struct sg_table :- 184
struct nvme_iod with struct dma_map  :- 176

In nvme_map_data(), allocate dma_map from mempool and iova using
dma_alloc_iova(). Obtain the memory type from the first bvec of the
first bio of the request and use that to decide whether we want to use
iova or not. In the newly added function nvme_rq_dma_map(), perform DMA
mapping for the bvec pages using nvme_dma_link_page(). Additionally,
if NVMe SGL is provided, build SGL entry inline while creating this
mapping to avoid extra traversal.

Call nvme_rq_dma_map() from nvme_pci_setup_prps() and
nvme_pci_setup_sgls(). For NVME SGL case, nvme_rq_dma_map() will handle
building SGL inline. To build PRPs, use iod->dma_map->dma_link_address
in nvme_pci_setup_prps() and increment the counter appropriately to
retrieve the next set of DMA addresses.

This demonstrates how the new DMA API can fit into the NVMe driver and
replace the old DMA APIs.

As this is an RFC, I expect more robust error handling, optimizations,
and in-depth testing for the final version once we agree on DMA API
architecture.

Following is the performance comparision for existing DMA API case
with sg_table and with dma_map, once we have agreement on the new DMA
API design I intend to get similar profiling numbers for new DMA API.

sgl (sg_table + old dma API ) vs no_sgl (iod_dma_map + new DMA API) :-

block size                               IOPS (k) Average of 3

4K
--------------------------------------------------------------
sg-list-fio-perf.bs-4k-1.fio:             68.6
sg-list-fio-perf.bs-4k-2.fio:             68       68.36
sg-list-fio-perf.bs-4k-3.fio:             68.5

no-sg-list-fio-perf.bs-4k-1.fio:          68.7
no-sg-list-fio-perf.bs-4k-2.fio:          68.5     68.43
no-sg-list-fio-perf.bs-4k-3.fio:          68.1

% Change default vs new DMA API =       +0.0975%

8K
--------------------------------------------------------------
sg-list-fio-perf.bs-8k-1.fio:             67
sg-list-fio-perf.bs-8k-2.fio:             67.1     67.03
sg-list-fio-perf.bs-8k-3.fio:             67

no-sg-list-fio-perf.bs-8k-1.fio:          66.7
no-sg-list-fio-perf.bs-8k-2.fio:          66.7     66.7
no-sg-list-fio-perf.bs-8k-3.fio:          66.7

% Change default vs new DMA API =       +0.4993%

16K
--------------------------------------------------------------
sg-list-fio-perf.bs-16k-1.fio:            63.8
sg-list-fio-perf.bs-16k-2.fio:            63.4     63.5
sg-list-fio-perf.bs-16k-3.fio:            63.3

no-sg-list-fio-perf.bs-16k-1.fio:         63.5
no-sg-list-fio-perf.bs-16k-2.fio:         63.4     63.33
no-sg-list-fio-perf.bs-16k-3.fio:         63.1

% Change default vs new DMA API =       -0.2632%

32K
--------------------------------------------------------------
sg-list-fio-perf.bs-32k-1.fio:            59.3
sg-list-fio-perf.bs-32k-2.fio:            59.3     59.36
sg-list-fio-perf.bs-32k-3.fio:            59.5

no-sg-list-fio-perf.bs-32k-1.fio:         59.5
no-sg-list-fio-perf.bs-32k-2.fio:         59.6     59.43
no-sg-list-fio-perf.bs-32k-3.fio:         59.2

% Change default vs new DMA API =       +0.1122%

64K
--------------------------------------------------------------
sg-list-fio-perf.bs-64k-1.fio:            53.7
sg-list-fio-perf.bs-64k-2.fio:            53.4     53.56
sg-list-fio-perf.bs-64k-3.fio:            53.6

no-sg-list-fio-perf.bs-64k-1.fio:         53.5
no-sg-list-fio-perf.bs-64k-2.fio:         53.8     53.63
no-sg-list-fio-perf.bs-64k-3.fio:         53.6

% Change default vs new DMA API =        +0.1246%

128K
--------------------------------------------------------------
sg-list-fio-perf/bs-128k-1.fio:           48
sg-list-fio-perf/bs-128k-2.fio:           46.4     47.13
sg-list-fio-perf/bs-128k-3.fio:           47

no-sg-list-fio-perf/bs-128k-1.fio:        46.6
no-sg-list-fio-perf/bs-128k-2.fio:        47        46.9
no-sg-list-fio-perf/bs-128k-3.fio:        47.1

% Change default vs new DMA API =       −0.495%

256K
--------------------------------------------------------------
sg-list-fio-perf/bs-256k-1.fio:           37
sg-list-fio-perf/bs-256k-2.fio:           41        39.93
sg-list-fio-perf/bs-256k-3.fio:           41.8

no-sg-list-fio-perf/bs-256k-1.fio:        37.5
no-sg-list-fio-perf/bs-256k-2.fio:        41.4      40.5
no-sg-list-fio-perf/bs-256k-3.fio:        42.6

% Change default vs new DMA API =       +1.42%

512K
--------------------------------------------------------------
sg-list-fio-perf/bs-512k-1.fio:           28.5
sg-list-fio-perf/bs-512k-2.fio:           28.2      28.4
sg-list-fio-perf/bs-512k-3.fio:           28.5

no-sg-list-fio-perf/bs-512k-1.fio:        28.7
no-sg-list-fio-perf/bs-512k-2.fio:        28.6      28.7
no-sg-list-fio-perf/bs-512k-3.fio:        28.8

% Change default vs new DMA API =       +1.06%

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 283 ++++++++++++++++++++++++++++++----------
 1 file changed, 213 insertions(+), 70 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 102a9fb0c65f..53a71b03c794 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -221,6 +221,16 @@ union nvme_descriptor {
 	__le64			*prp_list;
 };
 
+struct iod_dma_map {
+	bool use_iova;
+	struct dma_iova_state state;
+	struct dma_memory_type type;
+	struct dma_iova_attrs iova;
+	dma_addr_t dma_link_address[NVME_MAX_SEGS];
+	u32 len[NVME_MAX_SEGS];
+	u16 nr_dma_link_address;
+};
+
 /*
  * The nvme_iod describes the data in an I/O.
  *
@@ -236,7 +246,7 @@ struct nvme_iod {
 	unsigned int dma_len;	/* length of single DMA segment mapping */
 	dma_addr_t first_dma;
 	dma_addr_t meta_dma;
-	struct sg_table sgt;
+	struct iod_dma_map *dma_map;
 	union nvme_descriptor list[NVME_MAX_NR_ALLOCATIONS];
 };
 
@@ -521,6 +531,26 @@ static inline bool nvme_pci_use_sgls(struct nvme_dev *dev, struct request *req,
 	return true;
 }
 
+static inline void nvme_dma_unlink_range(struct nvme_iod *iod)
+{
+	struct dma_iova_attrs *iova = &iod->dma_map->iova;
+	dma_addr_t addr;
+	u16 len;
+	u32 i;
+
+	if (iod->dma_map->use_iova) {
+		dma_unlink_range(&iod->dma_map->state);
+		return;
+	}
+
+	for (i = 0; i < iod->dma_map->nr_dma_link_address; i++) {
+		addr = iod->dma_map->dma_link_address[i];
+		len = iod->dma_map->len[i];
+		dma_unmap_page_attrs(iova->dev, addr, len,
+				     iova->dir, iova->attrs);
+	}
+}
+
 static void nvme_free_prps(struct nvme_dev *dev, struct request *req)
 {
 	const int last_prp = NVME_CTRL_PAGE_SIZE / sizeof(__le64) - 1;
@@ -547,9 +577,7 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 		return;
 	}
 
-	WARN_ON_ONCE(!iod->sgt.nents);
-
-	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
+	nvme_dma_unlink_range(iod);
 
 	if (iod->nr_allocations == 0)
 		dma_pool_free(dev->prp_small_pool, iod->list[0].sg_list,
@@ -559,21 +587,123 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 			      iod->first_dma);
 	else
 		nvme_free_prps(dev, req);
-	mempool_free(iod->sgt.sgl, dev->iod_mempool);
+
+	dma_free_iova(&iod->dma_map->iova);
+	mempool_free(iod->dma_map, dev->iod_mempool);
 }
 
-static void nvme_print_sgl(struct scatterlist *sgl, int nents)
+static inline dma_addr_t nvme_dma_link_page(struct page *page,
+					   unsigned int poffset,
+					   unsigned int len,
+					   struct nvme_iod *iod)
 {
-	int i;
-	struct scatterlist *sg;
+	struct dma_iova_attrs *iova = &iod->dma_map->iova;
+	struct dma_iova_state *state = &iod->dma_map->state;
+	dma_addr_t dma_addr;
+	int ret;
+
+	if (iod->dma_map->use_iova) {
+		phys_addr_t phys = page_to_phys(page) + poffset;
+
+		dma_addr = state->iova->addr + state->range_size;
+		ret = dma_link_range(&iod->dma_map->state, phys, len);
+		if (ret)
+			return DMA_MAPPING_ERROR;
+	} else {
+		dma_addr = dma_map_page_attrs(iova->dev, page, poffset, len,
+					      iova->dir, iova->attrs);
+	}
+	return dma_addr;
+}
+
+static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
+				 dma_addr_t dma_addr,
+				 unsigned int dma_len);
+
+static int __nvme_rq_dma_map(struct request *req, struct nvme_iod *iod,
+		struct nvme_sgl_desc *sgl_list)
+{
+	struct dma_iova_attrs *iova = &iod->dma_map->iova;
+	struct req_iterator iter;
+	struct bio_vec bv;
+	int cnt = 0;
+	dma_addr_t addr;
+
+	iod->dma_map->nr_dma_link_address = 0;
+	rq_for_each_bvec(bv, req, iter) {
+		unsigned nbytes = bv.bv_len;
+		unsigned total = 0;
+		unsigned offset, len;
+
+		if (bv.bv_offset + bv.bv_len <= PAGE_SIZE) {
+			addr = nvme_dma_link_page(bv.bv_page, bv.bv_offset,
+						  bv.bv_len, iod);
+			if (dma_mapping_error(iova->dev, addr)) {
+				pr_err("dma_mapping_error %d\n",
+					dma_mapping_error(iova->dev, addr));
+				return -ENOMEM;
+			}
+
+			iod->dma_map->dma_link_address[cnt] = addr;
+			iod->dma_map->len[cnt] = bv.bv_len;
+			iod->dma_map->nr_dma_link_address++;
+
+			if (sgl_list)
+				nvme_pci_sgl_set_data(&sgl_list[cnt], addr,
+						      bv.bv_len);
+			cnt++;
+			continue;
+		}
+		while (nbytes > 0) {
+			struct page *page = bv.bv_page;
+
+			offset = bv.bv_offset + total;
+			len = min(get_max_segment_size(&req->q->limits, page,
+						       offset), nbytes);
+
+			page += (offset >> PAGE_SHIFT);
+			offset &= ~PAGE_MASK;
+
+			addr = nvme_dma_link_page(page, offset, len, iod);
+			if (dma_mapping_error(iova->dev, addr)) {
+				pr_err("dma_mapping_error2 %d\n",
+					dma_mapping_error(iova->dev, addr));
+				return -ENOMEM;
+			}
+
+			iod->dma_map->dma_link_address[cnt] = addr;
+			iod->dma_map->len[cnt] = len;
+			iod->dma_map->nr_dma_link_address++;
 
-	for_each_sg(sgl, sg, nents, i) {
-		dma_addr_t phys = sg_phys(sg);
-		pr_warn("sg[%d] phys_addr:%pad offset:%d length:%d "
-			"dma_address:%pad dma_length:%d\n",
-			i, &phys, sg->offset, sg->length, &sg_dma_address(sg),
-			sg_dma_len(sg));
+			if (sgl_list)
+				nvme_pci_sgl_set_data(&sgl_list[cnt], addr, len);
+
+			total += len;
+			nbytes -= len;
+			cnt++;
+		}
+	}
+	return cnt;
+}
+
+static int nvme_rq_dma_map(struct request *req, struct nvme_iod *iod,
+			   struct nvme_sgl_desc *sgl_list)
+{
+	int ret;
+
+	if (iod->dma_map->use_iova) {
+		ret = dma_start_range(&iod->dma_map->state);
+		if (ret) {
+			pr_err("dma_start_dange_failed %d", ret);
+			return ret;
+		}
+
+		ret = __nvme_rq_dma_map(req, iod, sgl_list);
+		dma_end_range(&iod->dma_map->state);
+		return ret;
 	}
+
+	return __nvme_rq_dma_map(req, iod, sgl_list);
 }
 
 static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
@@ -582,13 +712,23 @@ static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	struct dma_pool *pool;
 	int length = blk_rq_payload_bytes(req);
-	struct scatterlist *sg = iod->sgt.sgl;
-	int dma_len = sg_dma_len(sg);
-	u64 dma_addr = sg_dma_address(sg);
-	int offset = dma_addr & (NVME_CTRL_PAGE_SIZE - 1);
+	u16 dma_addr_cnt = 0;
+	int dma_len;
+	u64 dma_addr;
+	int offset;
 	__le64 *prp_list;
 	dma_addr_t prp_dma;
 	int nprps, i;
+	int ret;
+
+	ret = nvme_rq_dma_map(req, iod, NULL);
+	if (ret < 0)
+		return errno_to_blk_status(ret);
+
+	dma_len = iod->dma_map->len[dma_addr_cnt];
+	dma_addr = iod->dma_map->dma_link_address[dma_addr_cnt];
+	offset = dma_addr & (NVME_CTRL_PAGE_SIZE - 1);
+	dma_addr_cnt++;
 
 	length -= (NVME_CTRL_PAGE_SIZE - offset);
 	if (length <= 0) {
@@ -600,9 +740,9 @@ static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
 	if (dma_len) {
 		dma_addr += (NVME_CTRL_PAGE_SIZE - offset);
 	} else {
-		sg = sg_next(sg);
-		dma_addr = sg_dma_address(sg);
-		dma_len = sg_dma_len(sg);
+		dma_addr = iod->dma_map->dma_link_address[dma_addr_cnt];
+		dma_len = iod->dma_map->len[dma_addr_cnt];
+		dma_addr_cnt++;
 	}
 
 	if (length <= NVME_CTRL_PAGE_SIZE) {
@@ -646,31 +786,29 @@ static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
 			break;
 		if (dma_len > 0)
 			continue;
-		if (unlikely(dma_len < 0))
-			goto bad_sgl;
-		sg = sg_next(sg);
-		dma_addr = sg_dma_address(sg);
-		dma_len = sg_dma_len(sg);
+		if (dma_addr_cnt >= iod->dma_map->nr_dma_link_address)
+			pr_err_ratelimited("dma_addr_cnt exceeded %u and %u\n",
+					   dma_addr_cnt,
+					   iod->dma_map->nr_dma_link_address);
+		dma_addr = iod->dma_map->dma_link_address[dma_addr_cnt];
+		dma_len = iod->dma_map->len[dma_addr_cnt];
+		dma_addr_cnt++;
 	}
 done:
-	cmnd->dptr.prp1 = cpu_to_le64(sg_dma_address(iod->sgt.sgl));
+	cmnd->dptr.prp1 = cpu_to_le64(iod->dma_map->dma_link_address[0]);
 	cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma);
+
 	return BLK_STS_OK;
 free_prps:
 	nvme_free_prps(dev, req);
 	return BLK_STS_RESOURCE;
-bad_sgl:
-	WARN(DO_ONCE(nvme_print_sgl, iod->sgt.sgl, iod->sgt.nents),
-			"Invalid SGL for payload:%d nents:%d\n",
-			blk_rq_payload_bytes(req), iod->sgt.nents);
-	return BLK_STS_IOERR;
 }
 
 static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
-		struct scatterlist *sg)
+		dma_addr_t dma_addr, unsigned int dma_len)
 {
-	sge->addr = cpu_to_le64(sg_dma_address(sg));
-	sge->length = cpu_to_le32(sg_dma_len(sg));
+	sge->addr = cpu_to_le64(dma_addr);
+	sge->length = cpu_to_le32(dma_len);
 	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
 }
 
@@ -685,22 +823,16 @@ static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
 static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 		struct request *req, struct nvme_rw_command *cmd)
 {
+	unsigned int entries = blk_rq_nr_phys_segments(req);
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct dma_pool *pool;
 	struct nvme_sgl_desc *sg_list;
-	struct scatterlist *sg = iod->sgt.sgl;
-	unsigned int entries = iod->sgt.nents;
+	struct dma_pool *pool;
 	dma_addr_t sgl_dma;
-	int i = 0;
+	int ret;
 
 	/* setting the transfer type as SGL */
 	cmd->flags = NVME_CMD_SGL_METABUF;
 
-	if (entries == 1) {
-		nvme_pci_sgl_set_data(&cmd->dptr.sgl, sg);
-		return BLK_STS_OK;
-	}
-
 	if (entries <= (256 / sizeof(struct nvme_sgl_desc))) {
 		pool = dev->prp_small_pool;
 		iod->nr_allocations = 0;
@@ -718,12 +850,11 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 	iod->list[0].sg_list = sg_list;
 	iod->first_dma = sgl_dma;
 
-	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, entries);
-	do {
-		nvme_pci_sgl_set_data(&sg_list[i++], sg);
-		sg = sg_next(sg);
-	} while (--entries > 0);
+	ret = nvme_rq_dma_map(req, iod, sg_list);
+	if (ret < 0)
+		return errno_to_blk_status(ret);
 
+	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, ret);
 	return BLK_STS_OK;
 }
 
@@ -791,34 +922,47 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 	}
 
 	iod->dma_len = 0;
-	iod->sgt.sgl = mempool_alloc(dev->iod_mempool, GFP_ATOMIC);
-	if (!iod->sgt.sgl)
+	iod->dma_map = mempool_alloc(dev->iod_mempool, GFP_ATOMIC);
+	if (!iod->dma_map)
 		return BLK_STS_RESOURCE;
-	sg_init_table(iod->sgt.sgl, blk_rq_nr_phys_segments(req));
-	iod->sgt.orig_nents = blk_rq_map_sg(req->q, req, iod->sgt.sgl);
-	if (!iod->sgt.orig_nents)
-		goto out_free_sg;
 
-	rc = dma_map_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req),
-			     DMA_ATTR_NO_WARN);
-	if (rc) {
-		if (rc == -EREMOTEIO)
-			ret = BLK_STS_TARGET;
-		goto out_free_sg;
-	}
+	iod->dma_map->state.range_size = 0;
+	iod->dma_map->iova.dev = dev->dev;
+	iod->dma_map->iova.dir = rq_dma_dir(req);
+	iod->dma_map->iova.attrs = DMA_ATTR_NO_WARN;
+	iod->dma_map->iova.size = blk_rq_payload_bytes(req);
+	if (!iod->dma_map->iova.size)
+		goto free_iod_map;
+
+	rc = dma_alloc_iova(&iod->dma_map->iova);
+	if (rc)
+		goto free_iod_map;
+
+	/*
+	 * Following call assumes that all the biovecs belongs to this request
+	 * are of the same type.
+	 */
+	dma_get_memory_type(req->bio->bi_io_vec[0].bv_page,
+			    &iod->dma_map->type);
+	iod->dma_map->state.iova = &iod->dma_map->iova;
+	iod->dma_map->state.type = &iod->dma_map->type;
+
+	iod->dma_map->use_iova =
+		dma_can_use_iova(&iod->dma_map->state,
+				 req->bio->bi_io_vec[0].bv_len);
 
-	if (nvme_pci_use_sgls(dev, req, iod->sgt.nents))
+	if (nvme_pci_use_sgls(dev, req, blk_rq_nr_phys_segments(req)))
 		ret = nvme_pci_setup_sgls(dev, req, &cmnd->rw);
 	else
 		ret = nvme_pci_setup_prps(dev, req, &cmnd->rw);
 	if (ret != BLK_STS_OK)
-		goto out_unmap_sg;
+		goto free_iova;
 	return BLK_STS_OK;
 
-out_unmap_sg:
-	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
-out_free_sg:
-	mempool_free(iod->sgt.sgl, dev->iod_mempool);
+free_iova:
+	dma_free_iova(&iod->dma_map->iova);
+free_iod_map:
+	mempool_free(iod->dma_map, dev->iod_mempool);
 	return ret;
 }
 
@@ -842,7 +986,6 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 
 	iod->aborted = false;
 	iod->nr_allocations = -1;
-	iod->sgt.nents = 0;
 
 	ret = nvme_setup_cmd(req->q->queuedata, req);
 	if (ret)
@@ -2670,7 +2813,7 @@ static void nvme_release_prp_pools(struct nvme_dev *dev)
 
 static int nvme_pci_alloc_iod_mempool(struct nvme_dev *dev)
 {
-	size_t alloc_size = sizeof(struct scatterlist) * NVME_MAX_SEGS;
+	size_t alloc_size = sizeof(struct iod_dma_map);
 
 	dev->iod_mempool = mempool_create_node(1,
 			mempool_kmalloc, mempool_kfree,
-- 
2.45.2



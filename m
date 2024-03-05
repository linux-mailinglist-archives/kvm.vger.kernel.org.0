Return-Path: <kvm+bounces-10923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDFE871B2D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:30:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54037282E0A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E934A664CF;
	Tue,  5 Mar 2024 10:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTFmI4f2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C4765BCD;
	Tue,  5 Mar 2024 10:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709633800; cv=none; b=pm/8+RHCkrDJc4m+/Bv8/azxpY1JZoe8O04FgDsRRmSgJuDCAWCEVvtg00Re3graXm6ZgWrhCdaFAJ1CLO4I9+sdZjikhDT5EdSqHGnmVyM8jBBvI2D1301enhNZ3A8+H6WgMtMQ095lSo4PwQtL3ExPD6cV/TvOmos3HE67igM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709633800; c=relaxed/simple;
	bh=POBXmxmfWLR3OdaBK59TZEAySmTXPtp10vl7hcXrrqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlYmsCcekUZjcloG/5j8XnVfQUhCXfqremZB+4bfACXLF4Rj+FdOSToJRO/hiDmd7cPu6wvq3vLCXOcETxR1vNcDMCSX2t7zWkxbqKiuqVHCZXk4KE/KgGuj+IySrBlBjTgL6IVaqVw97lwZfeSuSn23dfbWRs02IJPMH35kytc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTFmI4f2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF3AC43609;
	Tue,  5 Mar 2024 10:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709633799;
	bh=POBXmxmfWLR3OdaBK59TZEAySmTXPtp10vl7hcXrrqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTFmI4f2DZvwdpBpwsbb8kyrGjVIZbcmQOHHwyDR0biw0twpPzx4NpvjUFpX0Gk7H
	 C+sCQE7uq7qTB93P3sS7irPKFFCb4FaZKw01WlmNm+yE4jyYDqLuTxfuHM30FE2Vui
	 Rmm/rt4Jlyczdj/X3Q5fhaAG/XRTQ6z7sGUWipQF7MSYaWU3wWmjSLDXZNLL2taYuH
	 7FpJt98diCoAw4a6AcuAWxMCiyTyNswR2gsDQO8ylGptyoFGStdREYbJ8zwj4mRDSA
	 cg7RNSBRvoxHUvBB7jmw+w5OM9WUOmUhppGWLdgrC40bIvxrdiZPOEWuM3g4409p0e
	 dytDSDKhAxIYA==
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
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
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [RFC 16/16] nvme-pci: use blk_rq_dma_map() for NVMe SGL
Date: Tue,  5 Mar 2024 12:15:26 +0200
Message-ID: <016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709631413.git.leon@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <a77609c9c9a09214e38b04133e44eee67fe50ab0.1709631413.git.leon@kernel.org>
References: <a77609c9c9a09214e38b04133e44eee67fe50ab0.1709631413.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chaitanya Kulkarni <kch@nvidia.com>

Update nvme_iod structure to hold iova, list of DMA linked addresses and
total linked count, first one is needed in the request submission path
to create a request to DMA mapping and last two are needed in the
request completion path to remove the DMA mapping. In nvme_map_data()
initialize iova with device, direction, and iova dma length with the
help of blk_rq_get_dma_length(). Allocate iova using dma_alloc_iova().
and call in nvme_pci_setup_sgls().

Call newly added blk_rq_dma_map() to create request to DMA mapping and
provide a callback function nvme_pci_sgl_map(). In the callback
function initialize NVMe SGL dma addresses.

Finally in nvme_unmap_data() unlink the dma address and free iova.

Full disclosure:-
-----------------

This is an RFC to demonstrate the newly added DMA APIs can be used to
map/unmap bvecs without the use of sg list, hence I've modified the pci
code to only handle SGLs for now. Once we have some agreement on the
structure of new DMA API I'll add support for PRPs along with all the
optimization that I've removed from the code for this RFC for NVMe SGLs
and PRPs.

I was able to run fio verification job successfully :-

$ fio fio/verify.fio --ioengine=io_uring --filename=/dev/nvme0n1
                     --loops=10
write-and-verify: (g=0): rw=randwrite, bs=(R) 8192B-8192B, (W) 8192B-8192B,
	(T) 8192B-8192B, ioengine=io_uring, iodepth=16
fio-3.36
Starting 1 process
Jobs: 1 (f=1): [V(1)][81.6%][r=12.2MiB/s][r=1559 IOPS][eta 03m:00s]
write-and-verify: (groupid=0, jobs=1): err= 0: pid=4435: Mon Mar  4 20:54:48 2024
  read: IOPS=2789, BW=21.8MiB/s (22.9MB/s)(6473MiB/297008msec)
    slat (usec): min=4, max=5124, avg=356.51, stdev=604.30
    clat (nsec): min=1593, max=23376k, avg=5377076.99, stdev=2039189.93
     lat (usec): min=493, max=23407, avg=5733.58, stdev=2103.22
    clat percentiles (usec):
     |  1.00th=[ 1172],  5.00th=[ 2114], 10.00th=[ 2835], 20.00th=[ 3654],
     | 30.00th=[ 4228], 40.00th=[ 4752], 50.00th=[ 5276], 60.00th=[ 5800],
     | 70.00th=[ 6325], 80.00th=[ 7046], 90.00th=[ 8094], 95.00th=[ 8979],
     | 99.00th=[10421], 99.50th=[11076], 99.90th=[12780], 99.95th=[14222],
     | 99.99th=[16909]
  write: IOPS=2608, BW=20.4MiB/s (21.4MB/s)(10.0GiB/502571msec); 0 zone resets
    slat (usec): min=4, max=5787, avg=382.68, stdev=649.01
    clat (nsec): min=521, max=23650k, avg=5751363.17, stdev=2676065.35
     lat (usec): min=95, max=23674, avg=6134.04, stdev=2813.48
    clat percentiles (usec):
     |  1.00th=[  709],  5.00th=[ 1270], 10.00th=[ 1958], 20.00th=[ 3261],
     | 30.00th=[ 4228], 40.00th=[ 5014], 50.00th=[ 5800], 60.00th=[ 6521],
     | 70.00th=[ 7373], 80.00th=[ 8225], 90.00th=[ 9241], 95.00th=[ 9896],
     | 99.00th=[11469], 99.50th=[11863], 99.90th=[13960], 99.95th=[15270],
     | 99.99th=[17695]
   bw (  KiB/s): min= 1440, max=132496, per=99.28%, avg=20715.88, stdev=13123.13, samples=1013
   iops        : min=  180, max=16562, avg=2589.34, stdev=1640.39, samples=1013
  lat (nsec)   : 750=0.01%
  lat (usec)   : 2=0.01%, 4=0.01%, 100=0.01%, 250=0.01%, 500=0.07%
  lat (usec)   : 750=0.79%, 1000=1.22%
  lat (msec)   : 2=5.94%, 4=18.87%, 10=69.53%, 20=3.58%, 50=0.01%
  cpu          : usr=1.01%, sys=98.95%, ctx=1591, majf=0, minf=2286
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=828524,1310720,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=21.8MiB/s (22.9MB/s), 21.8MiB/s-21.8MiB/s (22.9MB/s-22.9MB/s),
	io=6473MiB (6787MB), run=297008-297008msec
  WRITE: bw=20.4MiB/s (21.4MB/s), 20.4MiB/s-20.4MiB/s (21.4MB/s-21.4MB/s),
	io=10.0GiB (10.7GB), run=502571-502571msec

Disk stats (read/write):
  nvme0n1: ios=829189/1310720, sectors=13293416/20971520, merge=0/0,
	ticks=836561/1340351, in_queue=2176913, util=99.30%

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 220 +++++++++-------------------------------
 1 file changed, 49 insertions(+), 171 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e6267a6aa380..140939228409 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -236,7 +236,9 @@ struct nvme_iod {
 	unsigned int dma_len;	/* length of single DMA segment mapping */
 	dma_addr_t first_dma;
 	dma_addr_t meta_dma;
-	struct sg_table sgt;
+	struct dma_iova_attrs iova;
+	dma_addr_t dma_link_address[128];
+	u16 nr_dma_link_address;
 	union nvme_descriptor list[NVME_MAX_NR_ALLOCATIONS];
 };
 
@@ -521,25 +523,10 @@ static inline bool nvme_pci_use_sgls(struct nvme_dev *dev, struct request *req,
 	return true;
 }
 
-static void nvme_free_prps(struct nvme_dev *dev, struct request *req)
-{
-	const int last_prp = NVME_CTRL_PAGE_SIZE / sizeof(__le64) - 1;
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	dma_addr_t dma_addr = iod->first_dma;
-	int i;
-
-	for (i = 0; i < iod->nr_allocations; i++) {
-		__le64 *prp_list = iod->list[i].prp_list;
-		dma_addr_t next_dma_addr = le64_to_cpu(prp_list[last_prp]);
-
-		dma_pool_free(dev->prp_page_pool, prp_list, dma_addr);
-		dma_addr = next_dma_addr;
-	}
-}
-
 static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	u16 i;
 
 	if (iod->dma_len) {
 		dma_unmap_page(dev->dev, iod->first_dma, iod->dma_len,
@@ -547,9 +534,8 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 		return;
 	}
 
-	WARN_ON_ONCE(!iod->sgt.nents);
-
-	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
+	for (i = 0; i < iod->nr_dma_link_address; i++)
+		dma_unlink_range(&iod->iova, iod->dma_link_address[i]);
 
 	if (iod->nr_allocations == 0)
 		dma_pool_free(dev->prp_small_pool, iod->list[0].sg_list,
@@ -557,120 +543,15 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 	else if (iod->nr_allocations == 1)
 		dma_pool_free(dev->prp_page_pool, iod->list[0].sg_list,
 			      iod->first_dma);
-	else
-		nvme_free_prps(dev, req);
-	mempool_free(iod->sgt.sgl, dev->iod_mempool);
-}
-
-static void nvme_print_sgl(struct scatterlist *sgl, int nents)
-{
-	int i;
-	struct scatterlist *sg;
-
-	for_each_sg(sgl, sg, nents, i) {
-		dma_addr_t phys = sg_phys(sg);
-		pr_warn("sg[%d] phys_addr:%pad offset:%d length:%d "
-			"dma_address:%pad dma_length:%d\n",
-			i, &phys, sg->offset, sg->length, &sg_dma_address(sg),
-			sg_dma_len(sg));
-	}
-}
-
-static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
-		struct request *req, struct nvme_rw_command *cmnd)
-{
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct dma_pool *pool;
-	int length = blk_rq_payload_bytes(req);
-	struct scatterlist *sg = iod->sgt.sgl;
-	int dma_len = sg_dma_len(sg);
-	u64 dma_addr = sg_dma_address(sg);
-	int offset = dma_addr & (NVME_CTRL_PAGE_SIZE - 1);
-	__le64 *prp_list;
-	dma_addr_t prp_dma;
-	int nprps, i;
-
-	length -= (NVME_CTRL_PAGE_SIZE - offset);
-	if (length <= 0) {
-		iod->first_dma = 0;
-		goto done;
-	}
-
-	dma_len -= (NVME_CTRL_PAGE_SIZE - offset);
-	if (dma_len) {
-		dma_addr += (NVME_CTRL_PAGE_SIZE - offset);
-	} else {
-		sg = sg_next(sg);
-		dma_addr = sg_dma_address(sg);
-		dma_len = sg_dma_len(sg);
-	}
-
-	if (length <= NVME_CTRL_PAGE_SIZE) {
-		iod->first_dma = dma_addr;
-		goto done;
-	}
-
-	nprps = DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE);
-	if (nprps <= (256 / 8)) {
-		pool = dev->prp_small_pool;
-		iod->nr_allocations = 0;
-	} else {
-		pool = dev->prp_page_pool;
-		iod->nr_allocations = 1;
-	}
-
-	prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
-	if (!prp_list) {
-		iod->nr_allocations = -1;
-		return BLK_STS_RESOURCE;
-	}
-	iod->list[0].prp_list = prp_list;
-	iod->first_dma = prp_dma;
-	i = 0;
-	for (;;) {
-		if (i == NVME_CTRL_PAGE_SIZE >> 3) {
-			__le64 *old_prp_list = prp_list;
-			prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
-			if (!prp_list)
-				goto free_prps;
-			iod->list[iod->nr_allocations++].prp_list = prp_list;
-			prp_list[0] = old_prp_list[i - 1];
-			old_prp_list[i - 1] = cpu_to_le64(prp_dma);
-			i = 1;
-		}
-		prp_list[i++] = cpu_to_le64(dma_addr);
-		dma_len -= NVME_CTRL_PAGE_SIZE;
-		dma_addr += NVME_CTRL_PAGE_SIZE;
-		length -= NVME_CTRL_PAGE_SIZE;
-		if (length <= 0)
-			break;
-		if (dma_len > 0)
-			continue;
-		if (unlikely(dma_len < 0))
-			goto bad_sgl;
-		sg = sg_next(sg);
-		dma_addr = sg_dma_address(sg);
-		dma_len = sg_dma_len(sg);
-	}
-done:
-	cmnd->dptr.prp1 = cpu_to_le64(sg_dma_address(iod->sgt.sgl));
-	cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma);
-	return BLK_STS_OK;
-free_prps:
-	nvme_free_prps(dev, req);
-	return BLK_STS_RESOURCE;
-bad_sgl:
-	WARN(DO_ONCE(nvme_print_sgl, iod->sgt.sgl, iod->sgt.nents),
-			"Invalid SGL for payload:%d nents:%d\n",
-			blk_rq_payload_bytes(req), iod->sgt.nents);
-	return BLK_STS_IOERR;
+	dma_free_iova(&iod->iova);
 }
 
 static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
-		struct scatterlist *sg)
+				 dma_addr_t dma_addr,
+				 unsigned int dma_len)
 {
-	sge->addr = cpu_to_le64(sg_dma_address(sg));
-	sge->length = cpu_to_le32(sg_dma_len(sg));
+	sge->addr = cpu_to_le64(dma_addr);
+	sge->length = cpu_to_le32(dma_len);
 	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
 }
 
@@ -682,25 +563,37 @@ static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
 	sge->type = NVME_SGL_FMT_LAST_SEG_DESC << 4;
 }
 
+struct nvme_pci_sgl_map_data {
+	struct nvme_iod *iod;
+	struct nvme_sgl_desc *sgl_list;
+};
+
+static void nvme_pci_sgl_map(void *data, u32 cnt, dma_addr_t dma_addr,
+			    dma_addr_t offset, u32 len)
+{
+	struct nvme_pci_sgl_map_data *d = data;
+	struct nvme_sgl_desc *sgl_list = d->sgl_list;
+	struct nvme_iod *iod = d->iod;
+
+	nvme_pci_sgl_set_data(&sgl_list[cnt], dma_addr, len);
+	iod->dma_link_address[cnt] = offset;
+	iod->nr_dma_link_address++;
+}
+
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
+	int linked_count;
+	struct nvme_pci_sgl_map_data data;
 
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
@@ -718,11 +611,13 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 	iod->list[0].sg_list = sg_list;
 	iod->first_dma = sgl_dma;
 
-	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, entries);
-	do {
-		nvme_pci_sgl_set_data(&sg_list[i++], sg);
-		sg = sg_next(sg);
-	} while (--entries > 0);
+	data.iod = iod;
+	data.sgl_list = sg_list;
+
+	linked_count = blk_rq_dma_map(req, nvme_pci_sgl_map, &data,
+				       &iod->iova);
+
+	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, linked_count);
 
 	return BLK_STS_OK;
 }
@@ -788,36 +683,20 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 							     &cmnd->rw, &bv);
 		}
 	}
-
-	iod->dma_len = 0;
-	iod->sgt.sgl = mempool_alloc(dev->iod_mempool, GFP_ATOMIC);
-	if (!iod->sgt.sgl)
+	iod->iova.dev = dev->dev;
+	iod->iova.dir = rq_dma_dir(req);
+	iod->iova.attrs = DMA_ATTR_NO_WARN;
+	iod->iova.size = blk_rq_get_dma_length(req);
+	if (!iod->iova.size)
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
+	rc = dma_alloc_iova(&iod->iova);
+	if (rc)
+		return BLK_STS_RESOURCE;
 
-	if (nvme_pci_use_sgls(dev, req, iod->sgt.nents))
-		ret = nvme_pci_setup_sgls(dev, req, &cmnd->rw);
-	else
-		ret = nvme_pci_setup_prps(dev, req, &cmnd->rw);
-	if (ret != BLK_STS_OK)
-		goto out_unmap_sg;
-	return BLK_STS_OK;
+	iod->dma_len = 0;
 
-out_unmap_sg:
-	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
-out_free_sg:
-	mempool_free(iod->sgt.sgl, dev->iod_mempool);
+	ret = nvme_pci_setup_sgls(dev, req, &cmnd->rw);
 	return ret;
 }
 
@@ -841,7 +720,6 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 
 	iod->aborted = false;
 	iod->nr_allocations = -1;
-	iod->sgt.nents = 0;
 
 	ret = nvme_setup_cmd(req->q->queuedata, req);
 	if (ret)
-- 
2.44.0



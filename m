Return-Path: <kvm+bounces-16519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB40F8BAF20
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 16:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 392681F220DF
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 14:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4CBF46B80;
	Fri,  3 May 2024 14:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ED4hSxZI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D895379E5;
	Fri,  3 May 2024 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714747287; cv=none; b=Gqj8DAQjrTBRg/jjumaVzUlmPcgdrB/tOqbBumQcFjOXRH6sxto8TYtJzSfxqJRZtDo2mVrZ0FA58si5DdV+IYoGYSdc9EJbmwTYE5Y6wNYU5TpmzLqjdgbo4ese2EERBvqHJaILOi9oKz1Ub55u4HO6XyeGVy5xk8CJIg7fBbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714747287; c=relaxed/simple;
	bh=zlHjK/PxE1TRXjUMhkONFHt7Y6Ilexx1/gDIujwhsOw=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=UN0h+TguRxctk4Rk86+wRgEBLXill/8yVivDEnoKnaZJJGz+HItN7C7Ec780CCg1BOqJcdPyRmn0VzsIHLgHqek7V0fHq+FvhTpNb5HN/aQXwe++HrixWkN0Fva7DpsssjmA9Q/ctVaiP6YVWeNW9HVXNyvme2V5QxHG9NM2z/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ED4hSxZI; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-41ba1ba55e8so54843065e9.1;
        Fri, 03 May 2024 07:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714747283; x=1715352083; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=azRagsGySzV5eAEs8d+ON6g73h2e/RJB1Lcdlw2LC84=;
        b=ED4hSxZI+3Cya7T3tRTfOZH0S7rJHdy+gGD+IljMlvQdce3a18AafrVdmCd7eC6af6
         3bMtf2SvPeZpaqfdAOPQqL5L0RaSNpWebClyfPn6QQNaj4Yn/VJF4LYCIsryb65s/Ott
         orJ/FjvKHvd6XU27Hq2g9AACrrr+Pq60S1oBUZoMhSJqv4wGuSLmZAFX6kCwiVgMy30C
         8U9Xbzoo5FOTgJJnizGoedvAJC4JwhWCbwr4awXadspxBeVQb2fdZKoqHKWCyNuJa6Hi
         T+0lKk5wjplDIsohlNrKuZ7PQICged/MmFXSdIm/muf5wNWLC9HE3YFr4LGWh7R4mpOj
         ywvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714747283; x=1715352083;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=azRagsGySzV5eAEs8d+ON6g73h2e/RJB1Lcdlw2LC84=;
        b=Xddk0T2sZ7fHYahJ6ZhA+OVYQE2bNN6tzcnkSpv4A2ROWWCkm/WooMg6jpfw8QzVZ5
         QRerhFrrrdhGYWhxXOn+rf+nbthBs+a4rO64FF3+fff+kRvhGAvbL0T7CpQdyOHwWFi1
         TSQjTwcX97vNRoDEoYqtjzRRpbJJbG882nYBlO5cNtDMB6rsN/1HfLdoJh4AqwZyiK1l
         CuE3Tas1poswUZdHLT5Iojn3Cqmj67YwoHTJpWysxgmJiqZYeHvvixlShnLiMq/5MC8W
         VXS3uLXlc06kyaK9a//2P9NDsdd+1FDC8mVu2fBlqoI+rNMK3bw1QQbGXid8Jilx1EaX
         B24Q==
X-Forwarded-Encrypted: i=1; AJvYcCUBtsTF8MhuOH/K/4Wy56ICFZYaOEdYSgQrdYUKgD1Fk+LZRyBBSioYomlNxupIGL4g9lkNmBnrCn+zGGB0HbL465sfw3+0RIFAdqqLHlU4oEyvNdIXYQriTjCy+zgLmeBJO1mLDGLvKscbF/nas7qfEpGOfxE0hI/Jugk/k2SzJfFEgayMKH8JXwqcQPxYY0ezodPd8n1s5OMppr8asXIzBufgXlPf6vKDjyfS8BofnP7Pob/B
X-Gm-Message-State: AOJu0YxIVdfTg5NIxTPqYlY6xcAdJEQTjNtpBd+c/9mcggBXXhBuH/r8
	pk4PjLTjBQieaowS3FtGa3VuU4RLsap2OBVaPGigXkdntRE/6rmy
X-Google-Smtp-Source: AGHT+IFwwDzx7kiKOowz9Bq/5p6VLgEK7705r0A4XgwNwtMoQjgzKV8U7tRiQEBrFzAOa1zNKfTrDw==
X-Received: by 2002:a05:600c:458e:b0:41c:83aa:18b7 with SMTP id r14-20020a05600c458e00b0041c83aa18b7mr2241241wmo.33.1714747282852;
        Fri, 03 May 2024 07:41:22 -0700 (PDT)
Received: from [10.16.124.60] ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id p12-20020adfe60c000000b0034ccd06a6a3sm3935256wrm.18.2024.05.03.07.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 07:41:22 -0700 (PDT)
From: Zhu Yanjun <zyjzyj2000@gmail.com>
X-Google-Original-From: Zhu Yanjun <yanjun.zhu@linux.dev>
Message-ID: <c9f9e29e-c2e1-4f99-b359-db0babd41dec@linux.dev>
Date: Fri, 3 May 2024 16:41:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND 16/16] nvme-pci: use blk_rq_dma_map() for NVMe SGL
To: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Robin Murphy <robin.murphy@arm.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 linux-nvme@lists.infradead.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 Bart Van Assche <bvanassche@acm.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Amir Goldstein <amir73il@gmail.com>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 Dan Williams <dan.j.williams@intel.com>, "jack@suse.com" <jack@suse.com>,
 Leon Romanovsky <leonro@nvidia.com>, Zhu Yanjun <zyjzyj2000@gmail.com>
References: <cover.1709635535.git.leon@kernel.org>
 <016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org>
Content-Language: en-US
In-Reply-To: <016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.03.24 12:18, Leon Romanovsky wrote:
> From: Chaitanya Kulkarni <kch@nvidia.com>
> 
> Update nvme_iod structure to hold iova, list of DMA linked addresses and
> total linked count, first one is needed in the request submission path
> to create a request to DMA mapping and last two are needed in the
> request completion path to remove the DMA mapping. In nvme_map_data()
> initialize iova with device, direction, and iova dma length with the
> help of blk_rq_get_dma_length(). Allocate iova using dma_alloc_iova().
> and call in nvme_pci_setup_sgls().
> 
> Call newly added blk_rq_dma_map() to create request to DMA mapping and
> provide a callback function nvme_pci_sgl_map(). In the callback
> function initialize NVMe SGL dma addresses.
> 
> Finally in nvme_unmap_data() unlink the dma address and free iova.
> 
> Full disclosure:-
> -----------------
> 
> This is an RFC to demonstrate the newly added DMA APIs can be used to
> map/unmap bvecs without the use of sg list, hence I've modified the pci
> code to only handle SGLs for now. Once we have some agreement on the
> structure of new DMA API I'll add support for PRPs along with all the
> optimization that I've removed from the code for this RFC for NVMe SGLs
> and PRPs.
> 
> I was able to run fio verification job successfully :-
> 
> $ fio fio/verify.fio --ioengine=io_uring --filename=/dev/nvme0n1
>                       --loops=10
> write-and-verify: (g=0): rw=randwrite, bs=(R) 8192B-8192B, (W) 8192B-8192B,
> 	(T) 8192B-8192B, ioengine=io_uring, iodepth=16
> fio-3.36
> Starting 1 process
> Jobs: 1 (f=1): [V(1)][81.6%][r=12.2MiB/s][r=1559 IOPS][eta 03m:00s]
> write-and-verify: (groupid=0, jobs=1): err= 0: pid=4435: Mon Mar  4 20:54:48 2024
>    read: IOPS=2789, BW=21.8MiB/s (22.9MB/s)(6473MiB/297008msec)
>      slat (usec): min=4, max=5124, avg=356.51, stdev=604.30
>      clat (nsec): min=1593, max=23376k, avg=5377076.99, stdev=2039189.93
>       lat (usec): min=493, max=23407, avg=5733.58, stdev=2103.22
>      clat percentiles (usec):
>       |  1.00th=[ 1172],  5.00th=[ 2114], 10.00th=[ 2835], 20.00th=[ 3654],
>       | 30.00th=[ 4228], 40.00th=[ 4752], 50.00th=[ 5276], 60.00th=[ 5800],
>       | 70.00th=[ 6325], 80.00th=[ 7046], 90.00th=[ 8094], 95.00th=[ 8979],
>       | 99.00th=[10421], 99.50th=[11076], 99.90th=[12780], 99.95th=[14222],
>       | 99.99th=[16909]
>    write: IOPS=2608, BW=20.4MiB/s (21.4MB/s)(10.0GiB/502571msec); 0 zone resets
>      slat (usec): min=4, max=5787, avg=382.68, stdev=649.01
>      clat (nsec): min=521, max=23650k, avg=5751363.17, stdev=2676065.35
>       lat (usec): min=95, max=23674, avg=6134.04, stdev=2813.48
>      clat percentiles (usec):
>       |  1.00th=[  709],  5.00th=[ 1270], 10.00th=[ 1958], 20.00th=[ 3261],
>       | 30.00th=[ 4228], 40.00th=[ 5014], 50.00th=[ 5800], 60.00th=[ 6521],
>       | 70.00th=[ 7373], 80.00th=[ 8225], 90.00th=[ 9241], 95.00th=[ 9896],
>       | 99.00th=[11469], 99.50th=[11863], 99.90th=[13960], 99.95th=[15270],
>       | 99.99th=[17695]
>     bw (  KiB/s): min= 1440, max=132496, per=99.28%, avg=20715.88, stdev=13123.13, samples=1013
>     iops        : min=  180, max=16562, avg=2589.34, stdev=1640.39, samples=1013
>    lat (nsec)   : 750=0.01%
>    lat (usec)   : 2=0.01%, 4=0.01%, 100=0.01%, 250=0.01%, 500=0.07%
>    lat (usec)   : 750=0.79%, 1000=1.22%
>    lat (msec)   : 2=5.94%, 4=18.87%, 10=69.53%, 20=3.58%, 50=0.01%
>    cpu          : usr=1.01%, sys=98.95%, ctx=1591, majf=0, minf=2286
>    IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued rwts: total=828524,1310720,0,0 short=0,0,0,0 dropped=0,0,0,0
>       latency   : target=0, window=0, percentile=100.00%, depth=16
> 
> Run status group 0 (all jobs):
>     READ: bw=21.8MiB/s (22.9MB/s), 21.8MiB/s-21.8MiB/s (22.9MB/s-22.9MB/s),
> 	io=6473MiB (6787MB), run=297008-297008msec
>    WRITE: bw=20.4MiB/s (21.4MB/s), 20.4MiB/s-20.4MiB/s (21.4MB/s-21.4MB/s),
> 	io=10.0GiB (10.7GB), run=502571-502571msec
> 
> Disk stats (read/write):
>    nvme0n1: ios=829189/1310720, sectors=13293416/20971520, merge=0/0,
> 	ticks=836561/1340351, in_queue=2176913, util=99.30%
> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   drivers/nvme/host/pci.c | 220 +++++++++-------------------------------
>   1 file changed, 49 insertions(+), 171 deletions(-)
> 
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index e6267a6aa380..140939228409 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -236,7 +236,9 @@ struct nvme_iod {
>   	unsigned int dma_len;	/* length of single DMA segment mapping */
>   	dma_addr_t first_dma;
>   	dma_addr_t meta_dma;
> -	struct sg_table sgt;
> +	struct dma_iova_attrs iova;
> +	dma_addr_t dma_link_address[128];

Why the length of this array is 128? Can we increase this length of the 
array?

Thanks,
Zhu Yanjun

> +	u16 nr_dma_link_address;
>   	union nvme_descriptor list[NVME_MAX_NR_ALLOCATIONS];
>   };
>   
> @@ -521,25 +523,10 @@ static inline bool nvme_pci_use_sgls(struct nvme_dev *dev, struct request *req,
>   	return true;
>   }
>   
> -static void nvme_free_prps(struct nvme_dev *dev, struct request *req)
> -{
> -	const int last_prp = NVME_CTRL_PAGE_SIZE / sizeof(__le64) - 1;
> -	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> -	dma_addr_t dma_addr = iod->first_dma;
> -	int i;
> -
> -	for (i = 0; i < iod->nr_allocations; i++) {
> -		__le64 *prp_list = iod->list[i].prp_list;
> -		dma_addr_t next_dma_addr = le64_to_cpu(prp_list[last_prp]);
> -
> -		dma_pool_free(dev->prp_page_pool, prp_list, dma_addr);
> -		dma_addr = next_dma_addr;
> -	}
> -}
> -
>   static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
>   {
>   	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> +	u16 i;
>   
>   	if (iod->dma_len) {
>   		dma_unmap_page(dev->dev, iod->first_dma, iod->dma_len,
> @@ -547,9 +534,8 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
>   		return;
>   	}
>   
> -	WARN_ON_ONCE(!iod->sgt.nents);
> -
> -	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
> +	for (i = 0; i < iod->nr_dma_link_address; i++)
> +		dma_unlink_range(&iod->iova, iod->dma_link_address[i]);
>   
>   	if (iod->nr_allocations == 0)
>   		dma_pool_free(dev->prp_small_pool, iod->list[0].sg_list,
> @@ -557,120 +543,15 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
>   	else if (iod->nr_allocations == 1)
>   		dma_pool_free(dev->prp_page_pool, iod->list[0].sg_list,
>   			      iod->first_dma);
> -	else
> -		nvme_free_prps(dev, req);
> -	mempool_free(iod->sgt.sgl, dev->iod_mempool);
> -}
> -
> -static void nvme_print_sgl(struct scatterlist *sgl, int nents)
> -{
> -	int i;
> -	struct scatterlist *sg;
> -
> -	for_each_sg(sgl, sg, nents, i) {
> -		dma_addr_t phys = sg_phys(sg);
> -		pr_warn("sg[%d] phys_addr:%pad offset:%d length:%d "
> -			"dma_address:%pad dma_length:%d\n",
> -			i, &phys, sg->offset, sg->length, &sg_dma_address(sg),
> -			sg_dma_len(sg));
> -	}
> -}
> -
> -static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
> -		struct request *req, struct nvme_rw_command *cmnd)
> -{
> -	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> -	struct dma_pool *pool;
> -	int length = blk_rq_payload_bytes(req);
> -	struct scatterlist *sg = iod->sgt.sgl;
> -	int dma_len = sg_dma_len(sg);
> -	u64 dma_addr = sg_dma_address(sg);
> -	int offset = dma_addr & (NVME_CTRL_PAGE_SIZE - 1);
> -	__le64 *prp_list;
> -	dma_addr_t prp_dma;
> -	int nprps, i;
> -
> -	length -= (NVME_CTRL_PAGE_SIZE - offset);
> -	if (length <= 0) {
> -		iod->first_dma = 0;
> -		goto done;
> -	}
> -
> -	dma_len -= (NVME_CTRL_PAGE_SIZE - offset);
> -	if (dma_len) {
> -		dma_addr += (NVME_CTRL_PAGE_SIZE - offset);
> -	} else {
> -		sg = sg_next(sg);
> -		dma_addr = sg_dma_address(sg);
> -		dma_len = sg_dma_len(sg);
> -	}
> -
> -	if (length <= NVME_CTRL_PAGE_SIZE) {
> -		iod->first_dma = dma_addr;
> -		goto done;
> -	}
> -
> -	nprps = DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE);
> -	if (nprps <= (256 / 8)) {
> -		pool = dev->prp_small_pool;
> -		iod->nr_allocations = 0;
> -	} else {
> -		pool = dev->prp_page_pool;
> -		iod->nr_allocations = 1;
> -	}
> -
> -	prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
> -	if (!prp_list) {
> -		iod->nr_allocations = -1;
> -		return BLK_STS_RESOURCE;
> -	}
> -	iod->list[0].prp_list = prp_list;
> -	iod->first_dma = prp_dma;
> -	i = 0;
> -	for (;;) {
> -		if (i == NVME_CTRL_PAGE_SIZE >> 3) {
> -			__le64 *old_prp_list = prp_list;
> -			prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
> -			if (!prp_list)
> -				goto free_prps;
> -			iod->list[iod->nr_allocations++].prp_list = prp_list;
> -			prp_list[0] = old_prp_list[i - 1];
> -			old_prp_list[i - 1] = cpu_to_le64(prp_dma);
> -			i = 1;
> -		}
> -		prp_list[i++] = cpu_to_le64(dma_addr);
> -		dma_len -= NVME_CTRL_PAGE_SIZE;
> -		dma_addr += NVME_CTRL_PAGE_SIZE;
> -		length -= NVME_CTRL_PAGE_SIZE;
> -		if (length <= 0)
> -			break;
> -		if (dma_len > 0)
> -			continue;
> -		if (unlikely(dma_len < 0))
> -			goto bad_sgl;
> -		sg = sg_next(sg);
> -		dma_addr = sg_dma_address(sg);
> -		dma_len = sg_dma_len(sg);
> -	}
> -done:
> -	cmnd->dptr.prp1 = cpu_to_le64(sg_dma_address(iod->sgt.sgl));
> -	cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma);
> -	return BLK_STS_OK;
> -free_prps:
> -	nvme_free_prps(dev, req);
> -	return BLK_STS_RESOURCE;
> -bad_sgl:
> -	WARN(DO_ONCE(nvme_print_sgl, iod->sgt.sgl, iod->sgt.nents),
> -			"Invalid SGL for payload:%d nents:%d\n",
> -			blk_rq_payload_bytes(req), iod->sgt.nents);
> -	return BLK_STS_IOERR;
> +	dma_free_iova(&iod->iova);
>   }
>   
>   static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
> -		struct scatterlist *sg)
> +				 dma_addr_t dma_addr,
> +				 unsigned int dma_len)
>   {
> -	sge->addr = cpu_to_le64(sg_dma_address(sg));
> -	sge->length = cpu_to_le32(sg_dma_len(sg));
> +	sge->addr = cpu_to_le64(dma_addr);
> +	sge->length = cpu_to_le32(dma_len);
>   	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
>   }
>   
> @@ -682,25 +563,37 @@ static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
>   	sge->type = NVME_SGL_FMT_LAST_SEG_DESC << 4;
>   }
>   
> +struct nvme_pci_sgl_map_data {
> +	struct nvme_iod *iod;
> +	struct nvme_sgl_desc *sgl_list;
> +};
> +
> +static void nvme_pci_sgl_map(void *data, u32 cnt, dma_addr_t dma_addr,
> +			    dma_addr_t offset, u32 len)
> +{
> +	struct nvme_pci_sgl_map_data *d = data;
> +	struct nvme_sgl_desc *sgl_list = d->sgl_list;
> +	struct nvme_iod *iod = d->iod;
> +
> +	nvme_pci_sgl_set_data(&sgl_list[cnt], dma_addr, len);
> +	iod->dma_link_address[cnt] = offset;
> +	iod->nr_dma_link_address++;
> +}
> +
>   static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
>   		struct request *req, struct nvme_rw_command *cmd)
>   {
> +	unsigned int entries = blk_rq_nr_phys_segments(req);
>   	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> -	struct dma_pool *pool;
>   	struct nvme_sgl_desc *sg_list;
> -	struct scatterlist *sg = iod->sgt.sgl;
> -	unsigned int entries = iod->sgt.nents;
> +	struct dma_pool *pool;
>   	dma_addr_t sgl_dma;
> -	int i = 0;
> +	int linked_count;
> +	struct nvme_pci_sgl_map_data data;
>   
>   	/* setting the transfer type as SGL */
>   	cmd->flags = NVME_CMD_SGL_METABUF;
>   
> -	if (entries == 1) {
> -		nvme_pci_sgl_set_data(&cmd->dptr.sgl, sg);
> -		return BLK_STS_OK;
> -	}
> -
>   	if (entries <= (256 / sizeof(struct nvme_sgl_desc))) {
>   		pool = dev->prp_small_pool;
>   		iod->nr_allocations = 0;
> @@ -718,11 +611,13 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
>   	iod->list[0].sg_list = sg_list;
>   	iod->first_dma = sgl_dma;
>   
> -	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, entries);
> -	do {
> -		nvme_pci_sgl_set_data(&sg_list[i++], sg);
> -		sg = sg_next(sg);
> -	} while (--entries > 0);
> +	data.iod = iod;
> +	data.sgl_list = sg_list;
> +
> +	linked_count = blk_rq_dma_map(req, nvme_pci_sgl_map, &data,
> +				       &iod->iova);
> +
> +	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, linked_count);
>   
>   	return BLK_STS_OK;
>   }
> @@ -788,36 +683,20 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
>   							     &cmnd->rw, &bv);
>   		}
>   	}
> -
> -	iod->dma_len = 0;
> -	iod->sgt.sgl = mempool_alloc(dev->iod_mempool, GFP_ATOMIC);
> -	if (!iod->sgt.sgl)
> +	iod->iova.dev = dev->dev;
> +	iod->iova.dir = rq_dma_dir(req);
> +	iod->iova.attrs = DMA_ATTR_NO_WARN;
> +	iod->iova.size = blk_rq_get_dma_length(req);
> +	if (!iod->iova.size)
>   		return BLK_STS_RESOURCE;
> -	sg_init_table(iod->sgt.sgl, blk_rq_nr_phys_segments(req));
> -	iod->sgt.orig_nents = blk_rq_map_sg(req->q, req, iod->sgt.sgl);
> -	if (!iod->sgt.orig_nents)
> -		goto out_free_sg;
>   
> -	rc = dma_map_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req),
> -			     DMA_ATTR_NO_WARN);
> -	if (rc) {
> -		if (rc == -EREMOTEIO)
> -			ret = BLK_STS_TARGET;
> -		goto out_free_sg;
> -	}
> +	rc = dma_alloc_iova(&iod->iova);
> +	if (rc)
> +		return BLK_STS_RESOURCE;
>   
> -	if (nvme_pci_use_sgls(dev, req, iod->sgt.nents))
> -		ret = nvme_pci_setup_sgls(dev, req, &cmnd->rw);
> -	else
> -		ret = nvme_pci_setup_prps(dev, req, &cmnd->rw);
> -	if (ret != BLK_STS_OK)
> -		goto out_unmap_sg;
> -	return BLK_STS_OK;
> +	iod->dma_len = 0;
>   
> -out_unmap_sg:
> -	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
> -out_free_sg:
> -	mempool_free(iod->sgt.sgl, dev->iod_mempool);
> +	ret = nvme_pci_setup_sgls(dev, req, &cmnd->rw);
>   	return ret;
>   }
>   
> @@ -841,7 +720,6 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
>   
>   	iod->aborted = false;
>   	iod->nr_allocations = -1;
> -	iod->sgt.nents = 0;
>   
>   	ret = nvme_setup_cmd(req->q->queuedata, req);
>   	if (ret)



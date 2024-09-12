Return-Path: <kvm+bounces-26613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A30D9761CA
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 08:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 022121F2334D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 06:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9D818BC14;
	Thu, 12 Sep 2024 06:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Hh6GKdfh"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B9818A6BB
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 06:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726123582; cv=none; b=JIPI6xOQjmSPmUqma19XZ92rc8/keyvyJwAFQhrW2QsnSMDm0HnEqAO+QHxa6S3erBNnFh3xJBnS/XmlPCJy3hFwA1NZKEMWk8IIOQwR5KYxcCtrWUAvu0UAUC82QVchpFQ3QantbVA3qo+WIWDBNDxIxq7zDIlSdW3fzY2ouME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726123582; c=relaxed/simple;
	bh=7jY8oP7FjkGP/Vbb74It8bscPdbV1QxXX7FppSloi38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=tH0fBNhaWQZnZpwvkrl+upg8nc9w+uBetWKfyo6nIEC0piqLU88lr2UoMzfXDV5IYQdoSXYMiKFWmOqsXurX5o1nSmnsH1mPQNmZ5rSg3lyGJ19zCwJlnkfSuOpRTYxK8IEsKzZr+Q5exmyvMm0cbIZLfNBYyg78NQ+bsISm+wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Hh6GKdfh; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240912064618euoutp0283cb7d54c4c9ab1366434731fdb49a8f~0bD_9Vwsa0992209922euoutp02a
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 06:46:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240912064618euoutp0283cb7d54c4c9ab1366434731fdb49a8f~0bD_9Vwsa0992209922euoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1726123578;
	bh=j+Dw+Ui5IxdXI5xZcqr4hL+uJIzFPW2iK8RxG60NsZU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Hh6GKdfhzDnH26BugSGpsskuwuULyrn7Ulfg1adBVYsEh/HTYPLq39VA0Yz4BYgA0
	 fh7+IfAiyW7KrTkW2sxVJz4pGlfGKbVxIBGgUiOERYExZxWrDucsG6Jk1KUBCups8Y
	 b40yJaDuPB3B7UoAVkrNjEtEWftIE0bIe/bo4raA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240912064617eucas1p14a579005b9d8e332fb0fff049673e339~0bD_sZFi70683906839eucas1p1_;
	Thu, 12 Sep 2024 06:46:17 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 5E.54.09875.93E82E66; Thu, 12
	Sep 2024 07:46:17 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a~0bD_NtoU_0683906839eucas1p19;
	Thu, 12 Sep 2024 06:46:17 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240912064617eusmtrp26c9415ac96c35e6c2cb14d1cedd59cea~0bD_Mqfsg2568425684eusmtrp2S;
	Thu, 12 Sep 2024 06:46:17 +0000 (GMT)
X-AuditID: cbfec7f4-11bff70000002693-84-66e28e39b7b8
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id EF.F5.19096.93E82E66; Thu, 12
	Sep 2024 07:46:17 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240912064616eusmtip177bd770224fae56f6bfedbdfbe2397cc~0bD9eTICf1711017110eusmtip1p;
	Thu, 12 Sep 2024 06:46:16 +0000 (GMT)
Message-ID: <fb28ea61-4e94-498e-9caa-c8b7786d437a@samsung.com>
Date: Thu, 12 Sep 2024 08:46:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] virtio_blk: implement init_hctx MQ operation
To: Max Gurtovoy <mgurtovoy@nvidia.com>, stefanha@redhat.com,
	virtualization@lists.linux.dev, mst@redhat.com, axboe@kernel.dk
Cc: kvm@vger.kernel.org, linux-block@vger.kernel.org, oren@nvidia.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20240807224129.34237-1-mgurtovoy@nvidia.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsWy7djPc7qWfY/SDNa3aVqsvtvPZjFnaqHF
	3lvaFlvnf2ay+P/rFavFg0uT2C1eT/rPanF0+0pWBw6Py2dLPV5snsno0dv8js3j/b6rbB6f
	N8kFsEZx2aSk5mSWpRbp2yVwZRy9sJi94LNZxd0tXA2MR3S6GDk5JARMJE5MvMraxcjFISSw
	glHi4Y4djBDOF0aJl+uPsEA4nxklvs3tY4Zp2XmriQkisZxRYkLnSaj+j4wSb3Z9ZwWp4hWw
	kzj1rw2sg0VAVeLem1VQcUGJkzOfsIDYogLyEvdvzWAHsYUFXCSmrG8Ci4sI1Et07z0CZjML
	uEp86O1kg7DFJW49mc8EYrMJGEp0ve0Ci3MKWEks2noDql5eonnrbGaQgyQEbnBIvFjcww5x
	tovE4i872CBsYYlXx7dAxWUk/u+czwTR0M4oseD3fShnAqNEw/NbjBBV1hJ3zv0C6uYAWqEp
	sX6XPkTYUaKlZQE7SFhCgE/ixltBiCP4JCZtm84MEeaV6GgTgqhWk5h1fB3c2oMXLjFPYFSa
	hRQss5C8OQvJO7MQ9i5gZFnFKJ5aWpybnlpslJdarlecmFtcmpeul5yfu4kRmIhO/zv+ZQfj
	8lcf9Q4xMnEwHmKU4GBWEuGdxPYoTYg3JbGyKrUoP76oNCe1+BCjNAeLkjivaop8qpBAemJJ
	anZqakFqEUyWiYNTqoFp4cOJC5TYpn9i/SU3a22iyI0bVTaeaeLy6qrHOz9vUXRmN2Iv4v5z
	4HKEz1s1t8TVxxybxDeek2V5dtnxvvj5+SdOKkXuM0z33pr4xOY8Y1aVnajQ7Ihmp1vMPz/Z
	m342dhMtdU4+9CdBy1G65UzAfb8Jio2npAL5dBaUnappXdSRtuH7n/kB3S8Zj77YlBu14B0j
	/++9097ryukp39sq/suIW2hjbc1O46ndQfv/6S46utb19drMAwkXq8yWznmpVL3oR0PWt4cp
	karxS1M2iMqvOHfERnHa7/76WMfZDm/Pnz/JsCS6XyFq+ldnHy9ZiwRd63tfGhunCWVPzf38
	a1aqe3n23cKw34HVJfOVWIozEg21mIuKEwGd82aIswMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t/xu7qWfY/SDDY181isvtvPZjFnaqHF
	3lvaFlvnf2ay+P/rFavFg0uT2C1eT/rPanF0+0pWBw6Py2dLPV5snsno0dv8js3j/b6rbB6f
	N8kFsEbp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXo
	ZRy9sJi94LNZxd0tXA2MR3S6GDk5JARMJHbeamLqYuTiEBJYyiixtvEtK0RCRuLktAYoW1ji
	z7UuNoii94wScxb1M4EkeAXsJE79a2MGsVkEVCXuvVnFChEXlDg58wkLiC0qIC9x/9YMdhBb
	WMBFYsr6JrC4iEC9RPOODrA4s4CrxIfeTjYQW0jAUmJf0y8WiLi4xK0n88F2sQkYSnS97QKr
	4RSwkli09QZUjZlE19YuRghbXqJ562zmCYxCs5CcMQvJqFlIWmYhaVnAyLKKUSS1tDg3PbfY
	SK84Mbe4NC9dLzk/dxMjMO62Hfu5ZQfjylcf9Q4xMnEwHmKU4GBWEuGdxPYoTYg3JbGyKrUo
	P76oNCe1+BCjKTAsJjJLiSbnAyM/ryTe0MzA1NDEzNLA1NLMWEmcl+3K+TQhgfTEktTs1NSC
	1CKYPiYOTqkGJsmdL3MOZi9yOHB1jl/N7obpsxXiWz0PNM58tKRtZ0hiu+DeC4YXWX8Fdqxb
	tjRwit6ayxZbvNekttk1Mz3d3qNTu3Dvwx1nwrhjlvlMlpfxPXVWX7oxyaD9olSy99PWK22W
	z/8/P/BZ/8qbay9z2K975e04YmgS0u34Ovp8yZmy3z3LTKfEJ24yFEs6bjwz7dC5zYbVrB5y
	u0zeSTfpZFxMqlFcPSPw3tFpiUcSzj3mOZnxb8oCqyAOdzZRvs3rOZKPlNRXeVcLKcq8bbht
	WHcg5oSI/XrHCyafbK+GRxxrua0pm5/xqNrkfLfmq3w7HrblTk5VW7fqLdiqcmbHL87L5vad
	fuJKS7Z6C5svUWIpzkg01GIuKk4EAPFqa5pEAwAA
X-CMS-MailID: 20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a
References: <20240807224129.34237-1-mgurtovoy@nvidia.com>
	<CGME20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a@eucas1p1.samsung.com>

Dear All,

On 08.08.2024 00:41, Max Gurtovoy wrote:
> Set the driver data of the hardware context (hctx) to point directly to
> the virtio block queue. This cleanup improves code readability and
> reduces the number of dereferences in the fast path.
>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>   drivers/block/virtio_blk.c | 42 ++++++++++++++++++++------------------
>   1 file changed, 22 insertions(+), 20 deletions(-)

This patch landed in recent linux-next as commit 8d04556131c1 
("virtio_blk: implement init_hctx MQ operation"). In my tests I found 
that it introduces a regression in system suspend/resume operation. From 
time to time system crashes during suspend/resume cycle. Reverting this 
patch on top of next-20240911 fixes this problem.

I've even managed to catch a kernel panic log of this problem on QEMU's 
ARM64 'virt' machine:

root@target:~# time rtcwake -s10 -mmem
rtcwake: wakeup from "mem" using /dev/rtc0 at Thu Sep 12 07:11:52 2024
Unable to handle kernel NULL pointer dereference at virtual address 
0000000000000090
Mem abort info:
   ESR = 0x0000000096000046
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
   FSC = 0x06: level 2 translation fault
Data abort info:
   ISV = 0, ISS = 0x00000046, ISS2 = 0x00000000
   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000046bbb000
...
Internal error: Oops: 0000000096000046 [#1] PREEMPT SMP
Modules linked in: bluetooth ecdh_generic ecc rfkill ipv6
CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0H Not tainted 6.11.0-rc6+ #9024
Hardware name: linux,dummy-virt (DT)
Workqueue: kblockd blk_mq_requeue_work
pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : virtqueue_add_split+0x458/0x63c
lr : virtqueue_add_split+0x1d0/0x63c
...
Call trace:
  virtqueue_add_split+0x458/0x63c
  virtqueue_add_sgs+0xc4/0xec
  virtblk_add_req+0x8c/0xf4
  virtio_queue_rq+0x6c/0x1bc
  blk_mq_dispatch_rq_list+0x21c/0x714
  __blk_mq_sched_dispatch_requests+0xb4/0x58c
  blk_mq_sched_dispatch_requests+0x30/0x6c
  blk_mq_run_hw_queue+0x14c/0x40c
  blk_mq_run_hw_queues+0x64/0x124
  blk_mq_requeue_work+0x188/0x1bc
  process_one_work+0x20c/0x608
  worker_thread+0x238/0x370
  kthread+0x124/0x128
  ret_from_fork+0x10/0x20
Code: f9404282 79401c21 b9004a81 f94047e1 (f8206841)
---[ end trace 0000000000000000 ]---
note: kworker/0:0H[9] exited with irqs disabled
note: kworker/0:0H[9] exited with preempt_count 1


> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 2351f411fa46..35a7a586f6f5 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -129,14 +129,6 @@ static inline blk_status_t virtblk_result(u8 status)
>   	}
>   }
>   
> -static inline struct virtio_blk_vq *get_virtio_blk_vq(struct blk_mq_hw_ctx *hctx)
> -{
> -	struct virtio_blk *vblk = hctx->queue->queuedata;
> -	struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
> -
> -	return vq;
> -}
> -
>   static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr)
>   {
>   	struct scatterlist out_hdr, in_hdr, *sgs[3];
> @@ -377,8 +369,7 @@ static void virtblk_done(struct virtqueue *vq)
>   
>   static void virtio_commit_rqs(struct blk_mq_hw_ctx *hctx)
>   {
> -	struct virtio_blk *vblk = hctx->queue->queuedata;
> -	struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
> +	struct virtio_blk_vq *vq = hctx->driver_data;
>   	bool kick;
>   
>   	spin_lock_irq(&vq->lock);
> @@ -428,10 +419,10 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>   			   const struct blk_mq_queue_data *bd)
>   {
>   	struct virtio_blk *vblk = hctx->queue->queuedata;
> +	struct virtio_blk_vq *vq = hctx->driver_data;
>   	struct request *req = bd->rq;
>   	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>   	unsigned long flags;
> -	int qid = hctx->queue_num;
>   	bool notify = false;
>   	blk_status_t status;
>   	int err;
> @@ -440,26 +431,26 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	if (unlikely(status))
>   		return status;
>   
> -	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
> -	err = virtblk_add_req(vblk->vqs[qid].vq, vbr);
> +	spin_lock_irqsave(&vq->lock, flags);
> +	err = virtblk_add_req(vq->vq, vbr);
>   	if (err) {
> -		virtqueue_kick(vblk->vqs[qid].vq);
> +		virtqueue_kick(vq->vq);
>   		/* Don't stop the queue if -ENOMEM: we may have failed to
>   		 * bounce the buffer due to global resource outage.
>   		 */
>   		if (err == -ENOSPC)
>   			blk_mq_stop_hw_queue(hctx);
> -		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
> +		spin_unlock_irqrestore(&vq->lock, flags);
>   		virtblk_unmap_data(req, vbr);
>   		return virtblk_fail_to_queue(req, err);
>   	}
>   
> -	if (bd->last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
> +	if (bd->last && virtqueue_kick_prepare(vq->vq))
>   		notify = true;
> -	spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
> +	spin_unlock_irqrestore(&vq->lock, flags);
>   
>   	if (notify)
> -		virtqueue_notify(vblk->vqs[qid].vq);
> +		virtqueue_notify(vq->vq);
>   	return BLK_STS_OK;
>   }
>   
> @@ -504,7 +495,7 @@ static void virtio_queue_rqs(struct request **rqlist)
>   	struct request *requeue_list = NULL;
>   
>   	rq_list_for_each_safe(rqlist, req, next) {
> -		struct virtio_blk_vq *vq = get_virtio_blk_vq(req->mq_hctx);
> +		struct virtio_blk_vq *vq = req->mq_hctx->driver_data;
>   		bool kick;
>   
>   		if (!virtblk_prep_rq_batch(req)) {
> @@ -1164,6 +1155,16 @@ static const struct attribute_group *virtblk_attr_groups[] = {
>   	NULL,
>   };
>   
> +static int virtblk_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +		unsigned int hctx_idx)
> +{
> +	struct virtio_blk *vblk = data;
> +	struct virtio_blk_vq *vq = &vblk->vqs[hctx_idx];
> +
> +	hctx->driver_data = vq;
> +	return 0;
> +}
> +
>   static void virtblk_map_queues(struct blk_mq_tag_set *set)
>   {
>   	struct virtio_blk *vblk = set->driver_data;
> @@ -1205,7 +1206,7 @@ static void virtblk_complete_batch(struct io_comp_batch *iob)
>   static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
>   {
>   	struct virtio_blk *vblk = hctx->queue->queuedata;
> -	struct virtio_blk_vq *vq = get_virtio_blk_vq(hctx);
> +	struct virtio_blk_vq *vq = hctx->driver_data;
>   	struct virtblk_req *vbr;
>   	unsigned long flags;
>   	unsigned int len;
> @@ -1236,6 +1237,7 @@ static const struct blk_mq_ops virtio_mq_ops = {
>   	.queue_rqs	= virtio_queue_rqs,
>   	.commit_rqs	= virtio_commit_rqs,
>   	.complete	= virtblk_request_done,
> +	.init_hctx	= virtblk_init_hctx,
>   	.map_queues	= virtblk_map_queues,
>   	.poll		= virtblk_poll,
>   };

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland



Return-Path: <kvm+bounces-27047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7863597B10F
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 16:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1BBC1F21F77
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 14:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 639D517623F;
	Tue, 17 Sep 2024 14:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bG+c27IT"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970DE19BBA
	for <kvm@vger.kernel.org>; Tue, 17 Sep 2024 14:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726582174; cv=none; b=cfOxRmNfxAm6tG0AE0iuWl428Y/dV7qndqFQGwL8SgSPRph741KAopIuQcPgCCGmFNy/Q+4s/tTcToOYCoqmJrR8U2F81n0wPuXseEcIJZW5E26p5dJ9ddD6xxfrCkPhkknsRcmIihnkb0YMQKtxB1BsHLtlFyobRXj5RxVQhY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726582174; c=relaxed/simple;
	bh=C5sNu/tIzMKqgI7iIqHP/fw5VObg8bg/2Hy9Hbgm2r8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=VDE45fyMKCyq7dUptCvuAth+dLNneYiyXhn0LKi4J6/aFgRcyVsLDCli18OUIIQ1QE3ANsAMxIfe0NQlBjb1wH8MESVtJP84IGGhqShWmNDR7D6DRKr8HNYKQ3n3y9OqFPlkgb3CV5HT8e3fXRGGnIPJMiWUxN6ZhfaM3lWSTrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bG+c27IT; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240917140924euoutp020864c1ce572a3510b2f8121113b8ac2b~2DVSjCAyf2125121251euoutp02N
	for <kvm@vger.kernel.org>; Tue, 17 Sep 2024 14:09:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240917140924euoutp020864c1ce572a3510b2f8121113b8ac2b~2DVSjCAyf2125121251euoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1726582164;
	bh=FTIlmpeK+gBJgWWEUm8TuxmGeJbEdLRQW3w4HeVHoXg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=bG+c27ITlCkTt0V1filw+4a1LMWEhRAfOA1iRLQyMFKScmaAJBQRbYQctxH5TM01x
	 r8Dd7i318psd5LEvSj5mJEqSZbdJyIgRwLlWcSBDLwa59Duw6DTi9J8/zcbvwTeABE
	 ogpTBI9P6UjHXl6e35HqEqN/5V7GS7r9lMhoeflk=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240917140923eucas1p1c65e333bfc8d613440d0f0b0e4601fa1~2DVSQGnPl2001520015eucas1p1r;
	Tue, 17 Sep 2024 14:09:23 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id F6.65.09620.39D89E66; Tue, 17
	Sep 2024 15:09:23 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240917140923eucas1p1c76055978d586d06cb567c722a8c98f5~2DVRvnjz50876708767eucas1p1B;
	Tue, 17 Sep 2024 14:09:23 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240917140923eusmtrp2426373454546511046418e41b3dca3df~2DVRuw79Q2089320893eusmtrp2G;
	Tue, 17 Sep 2024 14:09:23 +0000 (GMT)
X-AuditID: cbfec7f5-d31ff70000002594-4c-66e98d9390d2
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 31.6A.14621.39D89E66; Tue, 17
	Sep 2024 15:09:23 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240917140922eusmtip1defa6801fe0fe60bba142fca23bd80ab~2DVRGlimf1227312273eusmtip1S;
	Tue, 17 Sep 2024 14:09:22 +0000 (GMT)
Message-ID: <5e051c18-bd96-4543-abeb-4ed245f16f9e@samsung.com>
Date: Tue, 17 Sep 2024 16:09:21 +0200
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
In-Reply-To: <b2408b1b-67e7-4935-83b4-1a2850e07374@nvidia.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsWy7djP87qTe1+mGZycY2Cx+m4/m8WcqYUW
	e29pW2yd/5nJ4v+vV6wWDy5NYrd4Pek/q8XR7StZHTg8Lp8t9XixeSajR2/zOzaP9/uusnl8
	3iQXwBrFZZOSmpNZllqkb5fAlfHpyw32gvt+FTPfL2VrYNzr1MXIwSEhYCKxYmNKFyMXh5DA
	CkaJpg+tzBDOF0aJD20NjBDOZ0aJx48PADmcYB1f191lhUgsZ5RY8qqZHcL5yCjx5cFtVpC5
	vAJ2EvemRoM0sAioSnTubmUDsXkFBCVOznzCAmKLCshL3L81gx3EFhZwkZiyvgksLiJQL9G9
	9wiYzSzgKvGht5MNwhaXuPVkPhOIzSZgKNH1tgsszgm0aumyaVD18hLNW2eDvSAh8IBD4uy0
	jUwQV7tIzL13mRnCFpZ4dXwLO4QtI/F/J8hQkIZ2RokFv+9DORMYJRqe34L62VrizrlfbCCf
	MQtoSqzfpQ8RdpRoaVnADglIPokbbwUhjuCTmLRtOjNEmFeio00IolpNYtbxdXBrD164xDyB
	UWkWUrDMQvLmLCTvzELYu4CRZRWjeGppcW56arFxXmq5XnFibnFpXrpecn7uJkZgGjr97/jX
	HYwrXn3UO8TIxMF4iFGCg1lJhNf299M0Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4ryqKfKpQgLp
	iSWp2ampBalFMFkmDk6pBqaSN5/ipbcs7QtN8l7/Xmyn8jWjnXwO+VdEo4pLwt7OnXfY9qlj
	G4eCQjLPrfQvvhPTtu9wei9k86Ymxjf+ZcjSH5O7Tz+655Hw5522osmaI0vUj92xurLfU5lr
	to7FyVbdOzdPfz42JVtWS/DjD6He7ZPb/x7uPt/lp/vhs83PiCmTNpfHZbKszLsg+Z5XnPfT
	TxGVE+/a6t/5BCQnnK6c1TLvw4HXJvPWH0p6UtZdxzNd1rJVNFlgdvxmS55jvLVyMl5fY2un
	3tWNCK/exmV5NGVX24TULVMVsto9qn6ofhVJ+SAw/enjf5/enrWpU3FVnCH8+aqeTIZjYE5W
	tK2V1y2dFCvZfMtPlgeDviqxFGckGmoxFxUnAgA4LwZ7sgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t/xu7qTe1+mGTQvF7VYfbefzWLO1EKL
	vbe0LbbO/8xk8f/XK1aLB5cmsVu8nvSf1eLo9pWsDhwel8+WerzYPJPRo7f5HZvH+31X2Tw+
	b5ILYI3SsynKLy1JVcjILy6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQ
	y/j05QZ7wX2/ipnvl7I1MO516mLk5JAQMJH4uu4uaxcjF4eQwFJGiUP/FjFDJGQkTk5rYIWw
	hSX+XOtigyh6zyjx8tQF9i5GDg5eATuJe1OjQWpYBFQlOne3soHYvAKCEidnPmEBsUUF5CXu
	35rBDmILC7hITFnfBBYXEaiXaN7RARZnFnCV+NDbCTX/G6NE04tmqIS4xK0n85lAbDYBQ4mu
	t11gCziB9i5dNo0FosZMomtrFyOELS/RvHU28wRGoVlI7piFZNQsJC2zkLQsYGRZxSiSWlqc
	m55bbKhXnJhbXJqXrpecn7uJERh524793LyDcd6rj3qHGJk4GA8xSnAwK4nw2v5+mibEm5JY
	WZValB9fVJqTWnyI0RQYGBOZpUST84Gxn1cSb2hmYGpoYmZpYGppZqwkzut2+XyakEB6Yklq
	dmpqQWoRTB8TB6dUAxPv4vU7knttzvv+3ayopMVVKJS313XOmzu3nrtUestu8La+uVhlksMf
	I2WJK+s2V/9mm/qUSbikSD3jP7/WgWYFHuFrrqaOvkk9PYk8wd/y9ydmhj7/v9VVeJpmpb2r
	rI3iouX+HxSsX4sEPKv+s/TLrifNNgemTHDccLX+DrfGA1lbc90tF/9Offi6ZKZs/ooH1+5e
	1G7vW+Tad+rRtoPOGw4e3lhvF7lco8IoVaJIakV+Qs2xXyZ7TmRe70opC5t7zl194cWNl6Zl
	ZmvfSFrDntlp/2xd7d9f9hYJt0xrq/9FxQfc472z8bBOU/aL3LD9S3oEry0Jio9YmDjRV3xu
	4s7fASmpXMdeHTSceVWJpTgj0VCLuag4EQDXaQl2RQMAAA==
X-CMS-MailID: 20240917140923eucas1p1c76055978d586d06cb567c722a8c98f5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a
References: <20240807224129.34237-1-mgurtovoy@nvidia.com>
	<CGME20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a@eucas1p1.samsung.com>
	<fb28ea61-4e94-498e-9caa-c8b7786d437a@samsung.com>
	<b2408b1b-67e7-4935-83b4-1a2850e07374@nvidia.com>

Hi Max,

On 17.09.2024 00:06, Max Gurtovoy wrote:
>
> On 12/09/2024 9:46, Marek Szyprowski wrote:
>> Dear All,
>>
>> On 08.08.2024 00:41, Max Gurtovoy wrote:
>>> Set the driver data of the hardware context (hctx) to point directly to
>>> the virtio block queue. This cleanup improves code readability and
>>> reduces the number of dereferences in the fast path.
>>>
>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>> ---
>>>    drivers/block/virtio_blk.c | 42 
>>> ++++++++++++++++++++------------------
>>>    1 file changed, 22 insertions(+), 20 deletions(-)
>> This patch landed in recent linux-next as commit 8d04556131c1
>> ("virtio_blk: implement init_hctx MQ operation"). In my tests I found
>> that it introduces a regression in system suspend/resume operation. From
>> time to time system crashes during suspend/resume cycle. Reverting this
>> patch on top of next-20240911 fixes this problem.
>
> Could you please provide a detailed explanation of the system 
> suspend/resume operation and the specific testing methodology employed?

In my tests I just call the 'rtcwake -s10 -mmem' command many times in a 
loop. I use standard Debian image under QEMU/ARM64. Nothing really special.

>
> The occurrence of a kernel panic from this commit is unexpected, given 
> that it primarily involves pointer reassignment without altering the 
> lifecycle of vblk/vqs.
>
> In the virtqueue_add_split function, which pointer is becoming null 
> and causing the issue? A detailed analysis would be helpful.
>
> The report indicates that the crash occurs sporadically rather than 
> consistently.
>
> is it possible that this is a race condition introduced by a different 
> commit? How can we rule out this possibility?
This is the commit pointed by bisecting between v6.11-rc1 and 
next-20240911. The problem is reproducible, it just need a few calls to 
the rtcwake command.
>
> Prior to applying this commit, what were the test results? 
> Specifically, out of 100 test runs, how many passed successfully?

All 100 were successful, see https://pastebin.com/3yETvXK9 (kernel is 
compiled from 6d17035a7402, which is a parent of $subject in linux-next).

>
> After applying this commit, what are the updated test results? Again, 
> out of 100 test runs, how many passed successfully?

Usually it freezes or panics after the second try, see 
https://pastebin.com/u5n9K1Dz (kernel compiled from 8d04556131c1, which 
is $subject in linux-next).

>
>>
>> I've even managed to catch a kernel panic log of this problem on QEMU's
>> ARM64 'virt' machine:
>>
>> root@target:~# time rtcwake -s10 -mmem
>> rtcwake: wakeup from "mem" using /dev/rtc0 at Thu Sep 12 07:11:52 2024
>> Unable to handle kernel NULL pointer dereference at virtual address
>> 0000000000000090
>> Mem abort info:
>>     ESR = 0x0000000096000046
>>     EC = 0x25: DABT (current EL), IL = 32 bits
>>     SET = 0, FnV = 0
>>     EA = 0, S1PTW = 0
>>     FSC = 0x06: level 2 translation fault
>> Data abort info:
>>     ISV = 0, ISS = 0x00000046, ISS2 = 0x00000000
>>     CM = 0, WnR = 1, TnD = 0, TagAccess = 0
>>     GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>> user pgtable: 4k pages, 48-bit VAs, pgdp=0000000046bbb000
>> ...
>> Internal error: Oops: 0000000096000046 [#1] PREEMPT SMP
>> Modules linked in: bluetooth ecdh_generic ecc rfkill ipv6
>> CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0H Not tainted 6.11.0-rc6+ #9024
>> Hardware name: linux,dummy-virt (DT)
>> Workqueue: kblockd blk_mq_requeue_work
>> pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : virtqueue_add_split+0x458/0x63c
>> lr : virtqueue_add_split+0x1d0/0x63c
>> ...
>> Call trace:
>>    virtqueue_add_split+0x458/0x63c
>>    virtqueue_add_sgs+0xc4/0xec
>>    virtblk_add_req+0x8c/0xf4
>>    virtio_queue_rq+0x6c/0x1bc
>>    blk_mq_dispatch_rq_list+0x21c/0x714
>>    __blk_mq_sched_dispatch_requests+0xb4/0x58c
>>    blk_mq_sched_dispatch_requests+0x30/0x6c
>>    blk_mq_run_hw_queue+0x14c/0x40c
>>    blk_mq_run_hw_queues+0x64/0x124
>>    blk_mq_requeue_work+0x188/0x1bc
>>    process_one_work+0x20c/0x608
>>    worker_thread+0x238/0x370
>>    kthread+0x124/0x128
>>    ret_from_fork+0x10/0x20
>> Code: f9404282 79401c21 b9004a81 f94047e1 (f8206841)
>> ---[ end trace 0000000000000000 ]---
>> note: kworker/0:0H[9] exited with irqs disabled
>> note: kworker/0:0H[9] exited with preempt_count 1
>>
>>
>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>> index 2351f411fa46..35a7a586f6f5 100644
>>> --- a/drivers/block/virtio_blk.c
>>> +++ b/drivers/block/virtio_blk.c
>>> @@ -129,14 +129,6 @@ static inline blk_status_t virtblk_result(u8 
>>> status)
>>>        }
>>>    }
>>>    -static inline struct virtio_blk_vq *get_virtio_blk_vq(struct 
>>> blk_mq_hw_ctx *hctx)
>>> -{
>>> -    struct virtio_blk *vblk = hctx->queue->queuedata;
>>> -    struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>>> -
>>> -    return vq;
>>> -}
>>> -
>>>    static int virtblk_add_req(struct virtqueue *vq, struct 
>>> virtblk_req *vbr)
>>>    {
>>>        struct scatterlist out_hdr, in_hdr, *sgs[3];
>>> @@ -377,8 +369,7 @@ static void virtblk_done(struct virtqueue *vq)
>>>       static void virtio_commit_rqs(struct blk_mq_hw_ctx *hctx)
>>>    {
>>> -    struct virtio_blk *vblk = hctx->queue->queuedata;
>>> -    struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>>> +    struct virtio_blk_vq *vq = hctx->driver_data;
>>>        bool kick;
>>>           spin_lock_irq(&vq->lock);
>>> @@ -428,10 +419,10 @@ static blk_status_t virtio_queue_rq(struct 
>>> blk_mq_hw_ctx *hctx,
>>>                   const struct blk_mq_queue_data *bd)
>>>    {
>>>        struct virtio_blk *vblk = hctx->queue->queuedata;
>>> +    struct virtio_blk_vq *vq = hctx->driver_data;
>>>        struct request *req = bd->rq;
>>>        struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>>>        unsigned long flags;
>>> -    int qid = hctx->queue_num;
>>>        bool notify = false;
>>>        blk_status_t status;
>>>        int err;
>>> @@ -440,26 +431,26 @@ static blk_status_t virtio_queue_rq(struct 
>>> blk_mq_hw_ctx *hctx,
>>>        if (unlikely(status))
>>>            return status;
>>>    -    spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
>>> -    err = virtblk_add_req(vblk->vqs[qid].vq, vbr);
>>> +    spin_lock_irqsave(&vq->lock, flags);
>>> +    err = virtblk_add_req(vq->vq, vbr);
>>>        if (err) {
>>> -        virtqueue_kick(vblk->vqs[qid].vq);
>>> +        virtqueue_kick(vq->vq);
>>>            /* Don't stop the queue if -ENOMEM: we may have failed to
>>>             * bounce the buffer due to global resource outage.
>>>             */
>>>            if (err == -ENOSPC)
>>>                blk_mq_stop_hw_queue(hctx);
>>> -        spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>>> +        spin_unlock_irqrestore(&vq->lock, flags);
>>>            virtblk_unmap_data(req, vbr);
>>>            return virtblk_fail_to_queue(req, err);
>>>        }
>>>    -    if (bd->last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
>>> +    if (bd->last && virtqueue_kick_prepare(vq->vq))
>>>            notify = true;
>>> -    spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>>> +    spin_unlock_irqrestore(&vq->lock, flags);
>>>           if (notify)
>>> -        virtqueue_notify(vblk->vqs[qid].vq);
>>> +        virtqueue_notify(vq->vq);
>>>        return BLK_STS_OK;
>>>    }
>>>    @@ -504,7 +495,7 @@ static void virtio_queue_rqs(struct request 
>>> **rqlist)
>>>        struct request *requeue_list = NULL;
>>>           rq_list_for_each_safe(rqlist, req, next) {
>>> -        struct virtio_blk_vq *vq = get_virtio_blk_vq(req->mq_hctx);
>>> +        struct virtio_blk_vq *vq = req->mq_hctx->driver_data;
>>>            bool kick;
>>>               if (!virtblk_prep_rq_batch(req)) {
>>> @@ -1164,6 +1155,16 @@ static const struct attribute_group 
>>> *virtblk_attr_groups[] = {
>>>        NULL,
>>>    };
>>>    +static int virtblk_init_hctx(struct blk_mq_hw_ctx *hctx, void 
>>> *data,
>>> +        unsigned int hctx_idx)
>>> +{
>>> +    struct virtio_blk *vblk = data;
>>> +    struct virtio_blk_vq *vq = &vblk->vqs[hctx_idx];
>>> +
>>> +    hctx->driver_data = vq;
>>> +    return 0;
>>> +}
>>> +
>>>    static void virtblk_map_queues(struct blk_mq_tag_set *set)
>>>    {
>>>        struct virtio_blk *vblk = set->driver_data;
>>> @@ -1205,7 +1206,7 @@ static void virtblk_complete_batch(struct 
>>> io_comp_batch *iob)
>>>    static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct 
>>> io_comp_batch *iob)
>>>    {
>>>        struct virtio_blk *vblk = hctx->queue->queuedata;
>>> -    struct virtio_blk_vq *vq = get_virtio_blk_vq(hctx);
>>> +    struct virtio_blk_vq *vq = hctx->driver_data;
>>>        struct virtblk_req *vbr;
>>>        unsigned long flags;
>>>        unsigned int len;
>>> @@ -1236,6 +1237,7 @@ static const struct blk_mq_ops virtio_mq_ops = {
>>>        .queue_rqs    = virtio_queue_rqs,
>>>        .commit_rqs    = virtio_commit_rqs,
>>>        .complete    = virtblk_request_done,
>>> +    .init_hctx    = virtblk_init_hctx,
>>>        .map_queues    = virtblk_map_queues,
>>>        .poll        = virtblk_poll,
>>>    };
>> Best regards
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland



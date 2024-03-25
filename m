Return-Path: <kvm+bounces-12562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94ABD88A11C
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:12:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63195BC4305
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B481304B9;
	Mon, 25 Mar 2024 08:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ukYZTjjr"
X-Original-To: kvm@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C8514F9F6;
	Mon, 25 Mar 2024 06:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711346637; cv=none; b=cQCISauqLhTqp4tl3qd/1GI1EnaettVebp4OkUEbADsuaWGGUTQoQ8Tsv/lrX3UYabozxCZOeQLoI/XIREBill9ltlK245MmSne0ctxs7+8an3BeidTdblhGh4Cgyh83ZzV3yTocaD8RNfwxcUjfxxgt5JR1rfS/oWOpJTPffcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711346637; c=relaxed/simple;
	bh=nh7RRQLuaSddz65FK3Wb9wuNv3HNQBBH9TtjgCZM/8o=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=A7tIcPQgNaob80xGsfi49mwhPIEy9qh+e11mL2LDg86SBDYW5+/xwjZxvLjsOr+Z+vAD3wp6qEs3csOvsxJ+ahw9QGtS2mmPpM4I79HAVUmGjoEGV4LyNDbdvGQAlyvtznWY9CY3mslAR8jFIv4YDsyhJTTLmedVgTxEA9WT9VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ukYZTjjr; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711346627; h=Message-ID:Subject:Date:From:To;
	bh=2wvKbE33fAJ4kNFKPB3UPmddRQV+uumgQtNtBaMBvfA=;
	b=ukYZTjjrjHhX2o2r+fAJbe9hE47/vJ9QzoRWspS7blS1koKFCbZ/3vknAEdHiAOdkxI0NGp7J15hs7NNdAWXCrjRsk6vxaknMn9fbB8cczRF4NlXPEeJ6SQnYf4V2twbyf6PJYHNFsk6xh2rS8qJURNumzjj/nRgcttCQ+imAIE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W39d4bX_1711346625;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W39d4bX_1711346625)
          by smtp.aliyun-inc.com;
          Mon, 25 Mar 2024 14:03:46 +0800
Message-ID: <1711346600.0136697-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v4 1/6] virtio_balloon: remove the dependence where names[] is null
Date: Mon, 25 Mar 2024 14:03:20 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: David Hildenbrand <david@redhat.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Hans de Goede <hdegoede@redhat.com>,
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 virtualization@lists.linux.dev
References: <20240321101532.59272-1-xuanzhuo@linux.alibaba.com>
 <20240321101532.59272-2-xuanzhuo@linux.alibaba.com>
 <3620be9c-e288-4ff2-a7be-1fcf806e6e6e@redhat.com>
In-Reply-To: <3620be9c-e288-4ff2-a7be-1fcf806e6e6e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Fri, 22 Mar 2024 12:56:46 +0100, David Hildenbrand <david@redhat.com> wrote:
> On 21.03.24 11:15, Xuan Zhuo wrote:
> > Currently, the init_vqs function within the virtio_balloon driver relies
> > on the condition that certain names array entries are null in order to
> > skip the initialization of some virtual queues (vqs). This behavior is
> > unique to this part of the codebase. In an upcoming commit, we plan to
> > eliminate this dependency by removing the function entirely. Therefore,
> > with this change, we are ensuring that the virtio_balloon no longer
> > depends on the aforementioned function.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_balloon.c | 41 +++++++++++++++------------------
> >   1 file changed, 19 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index 1f5b3dd31fcf..becc12a05407 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -531,49 +531,46 @@ static int init_vqs(struct virtio_balloon *vb)
> >   	struct virtqueue *vqs[VIRTIO_BALLOON_VQ_MAX];
> >   	vq_callback_t *callbacks[VIRTIO_BALLOON_VQ_MAX];
> >   	const char *names[VIRTIO_BALLOON_VQ_MAX];
> > -	int err;
> > +	int err, nvqs, idx;
> >
> > -	/*
> > -	 * Inflateq and deflateq are used unconditionally. The names[]
> > -	 * will be NULL if the related feature is not enabled, which will
> > -	 * cause no allocation for the corresponding virtqueue in find_vqs.
> > -	 */
> >   	callbacks[VIRTIO_BALLOON_VQ_INFLATE] = balloon_ack;
> >   	names[VIRTIO_BALLOON_VQ_INFLATE] = "inflate";
> >   	callbacks[VIRTIO_BALLOON_VQ_DEFLATE] = balloon_ack;
> >   	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
>
> I'd remove the static dependencies here completely and do it
> consistently:
>
> nvqs = 0;
>
> callbacks[nvqs] = balloon_ack;
> names[nvqs++] = "inflate";
> callbacks[nvqs] = balloon_ack;
> names[nvqs++] = "deflate";
>
>
> > -	callbacks[VIRTIO_BALLOON_VQ_STATS] = NULL;
> > -	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
> > -	callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> > -	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> > -	names[VIRTIO_BALLOON_VQ_REPORTING] = NULL;
> > +
> > +	nvqs = VIRTIO_BALLOON_VQ_DEFLATE + 1;
> >
> >   	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > -		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
> > -		callbacks[VIRTIO_BALLOON_VQ_STATS] = stats_request;
> > +		names[nvqs] = "stats";
> > +		callbacks[nvqs] = stats_request;
> > +		++nvqs;
>
> callbacks[nvqs++] = stats_request;
>
> If you prefer to keep it separate, "nvqs++" please.
>
> ... same here:
>
> idx = 0;
> vb->inflate_vq = vqs[idx++];
> vb->deflate_vq = vqs[idx++];
>
> ...
>
> >
> >   	vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
> >   	vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
> > +
> > +	idx = VIRTIO_BALLOON_VQ_DEFLATE + 1;
> > +
> >   	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> >   		struct scatterlist sg;
> >   		unsigned int num_stats;
> > -		vb->stats_vq = vqs[VIRTIO_BALLOON_VQ_STATS];
> > +		vb->stats_vq = vqs[idx++];
> >
> >   		/*
> >   		 * Prime this virtqueue with one buffer so the hypervisor can
> > @@ -593,10 +590,10 @@ static int init_vqs(struct virtio_balloon *vb)
> >   	}
> >
> >   	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> > -		vb->free_page_vq = vqs[VIRTIO_BALLOON_VQ_FREE_PAGE];
> > +		vb->free_page_vq = vqs[idx++];
> >
> >   	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > -		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
> > +		vb->reporting_vq = vqs[idx++];
> >
>
> Apart from that LGTM

Will fix in next version.

Thanks.


>
> --
> Cheers,
>
> David / dhildenb
>


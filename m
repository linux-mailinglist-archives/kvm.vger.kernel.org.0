Return-Path: <kvm+bounces-20057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CB5910034
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 11:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B353B2815A2
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 09:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61CC1A00D5;
	Thu, 20 Jun 2024 09:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PEIbrbmu"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9864AEE9;
	Thu, 20 Jun 2024 09:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718875377; cv=none; b=ZWLdCXXuAcYrbNd+v0a3Mq2B5bnnXmYBXoGhdqFgk+teFKtHVQphlXv0uGQ7+FfLKX5oVBqFfIX8XERHh63fB8fLyVfTxQy61jxeZu7ZHYSnzE349y8o99GzlgZMX24C2/Uwkkhl7e+HqR4d1LCqKqppY6WzlBW0nCUQw7F5pI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718875377; c=relaxed/simple;
	bh=0NDh1twCkDYHtf9esiX7Ztx85TJA3bCRvkBv9woillc=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=Drj5jQFWFU43WWAx086QZYHBycelRgzFd7APvM9fJ9nt0kEOpSbiVBMYN5buWQc8pvRyf76djOoFOS3zIonOceeQmwl54lCFO534s+SJdjiyDbdjsbreK0021Xuv4qWzUORlYyJhvdw+QU+/w/GJYVSJvPsVFq4l9NUkQn0mDf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PEIbrbmu; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718875372; h=Message-ID:Subject:Date:From:To;
	bh=c2UyGUAnU9MppByM5/160z/h1FZQF4H8b3fhx9biUXw=;
	b=PEIbrbmuyjiqx8aoq+/JkHzBALmKo491kktGU9ZKQw2wsLw2HVafGwb5OyGYIBTmxN16W8WfCRzLhKNPASZk6ILRz2U1k+gYWGY/bfkrXmuXKb95VQvXX328xKFrRGq2N3Bnbk/hyWBu+0jOrCC4W/+nzDP18qhQmCXX3OTnWIU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032014031;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W8rDkyX_1718875370;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W8rDkyX_1718875370)
          by smtp.aliyun-inc.com;
          Thu, 20 Jun 2024 17:22:50 +0800
Message-ID: <1718875249.1787696-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v9 3/6] virtio: find_vqs: pass struct instead of multi parameters
Date: Thu, 20 Jun 2024 17:20:49 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
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
 David Hildenbrand <david@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240424091533.86949-4-xuanzhuo@linux.alibaba.com>
 <20240620034823-mutt-send-email-mst@kernel.org>
 <1718874049.457552-1-xuanzhuo@linux.alibaba.com>
 <20240620050545-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240620050545-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 20 Jun 2024 05:14:24 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Jun 20, 2024 at 05:00:49PM +0800, Xuan Zhuo wrote:
> > > > @@ -226,21 +248,37 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
> > > >
> > > >  static inline
> > > >  int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> > > > -			struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > > > -			const char * const names[],
> > > > -			struct irq_affinity *desc)
> > > > +		    struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > > > +		    const char * const names[],
> > > > +		    struct irq_affinity *desc)
> > > >  {
> > > > -	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL, desc);
> > > > +	struct virtio_vq_config cfg = {};
> > > > +
> > > > +	cfg.nvqs = nvqs;
> > > > +	cfg.vqs = vqs;
> > > > +	cfg.callbacks = callbacks;
> > > > +	cfg.names = (const char **)names;
> > >
> > >
> > > Casting const away? Not safe.
> >
> >
> >
> > Because the vp_modern_create_avq() use the "const char *names[]",
> > and the virtio_uml.c changes the name in the subsequent commit, so
> > change the "names" inside the virtio_vq_config from "const char *const
> > *names" to "const char **names".
>
> I'm not sure I understand which commit you mean,
> and this kind of change needs to be documented, but it does not matter.
> Don't cast away const.


Do you mean change the virtio_find_vqs(), from
const char * const names[] to const char *names[].

And update the caller?

If we do not cast the const, we need to update all the caller to remove the
const.

Right?

Thanks.

>
> --
> MST
>


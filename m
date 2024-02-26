Return-Path: <kvm+bounces-9853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3FC867455
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 13:07:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09ED428299B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71AFF5FF04;
	Mon, 26 Feb 2024 12:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aOJBKvOm"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BB25A7A6;
	Mon, 26 Feb 2024 12:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708949198; cv=none; b=Qn4auyXHwOt2xEM8rtABC2RDvqXDoedIrYhg0lZd9Xm/ky20AzDhA260pqE0vaJxbtYnHZtHYZCEJgenf849SxKWsb7oEcezL/hG8m4qIKIne0Xe8qqfchIozvVCrOTuKN+M/ha71sqIjCxZ/I1NsmxYAPC85xOJY7ueCDxQEuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708949198; c=relaxed/simple;
	bh=qV7uaIbrZ2+vk5WGbpu94SlEYzCjGtK3QVKfY7QOhAE=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=f5i0EZx1yA8NZou/3KVe/1iZd4abObTi55Yeb37yHmv1pf8tyJGKFkj7QfLc9mP0p+Q3rxP9aPSWZ4OmBqxQ5UcnwpmYweEWcEgvtO0lcze4u3uLqISIbuzpoM9LmmHLcnRhrjqW2Db8LoDTbPUuNEhfitwojBIyRWP8eq6P3Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aOJBKvOm; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708949192; h=Message-ID:Subject:Date:From:To;
	bh=mh5I4GCxt/ZTY2nu4KYLIfaFGNU1YmGIejbkntTuIBM=;
	b=aOJBKvOmvU5SghCs88KAxTYuUS4kKpi8KhlCEEJeQQbxcwEaUeP0GML2C/LZwnTLCO/urf7zPxws1X7mg13tsnmh3+SA4AF1T/s4AgI4m6pYcUzaLn0XLOqI2kUWTJXGApUod+B+Fd69YhxFJDA8/LugLW4M9GTwi6K2vzq8VOo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=35;SR=0;TI=SMTPD_---0W1Iu-rX_1708949189;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W1Iu-rX_1708949189)
          by smtp.aliyun-inc.com;
          Mon, 26 Feb 2024 20:06:30 +0800
Message-ID: <1708949183.5224328-4-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v2 19/19] virtio_net: sq support premapped mode
Date: Mon, 26 Feb 2024 20:06:23 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
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
 Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 linux-um@lists.infradead.org,
 netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 bpf@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20240223082726.52915-1-xuanzhuo@linux.alibaba.com>
 <20240223082726.52915-20-xuanzhuo@linux.alibaba.com>
 <20240225032330-mutt-send-email-mst@kernel.org>
 <1708946440.799724-1-xuanzhuo@linux.alibaba.com>
 <20240226063120-mutt-send-email-mst@kernel.org>
 <1708947209.1148863-1-xuanzhuo@linux.alibaba.com>
 <20240226063532-mutt-send-email-mst@kernel.org>
 <1708947549.7906592-2-xuanzhuo@linux.alibaba.com>
 <20240226065709-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240226065709-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Mon, 26 Feb 2024 06:57:17 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Feb 26, 2024 at 07:39:09PM +0800, Xuan Zhuo wrote:
> > On Mon, 26 Feb 2024 06:36:53 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Mon, Feb 26, 2024 at 07:33:29PM +0800, Xuan Zhuo wrote:
> > > > > what is dma_map_direct? can't find it in the tree.
> > > >
> > > > YES.
> > > >
> > > >
> > > > diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> > > > index 58db8fd70471..5a8f7a927aa1 100644
> > > > --- a/kernel/dma/mapping.c
> > > > +++ b/kernel/dma/mapping.c
> > > > @@ -144,6 +144,18 @@ static inline bool dma_map_direct(struct device *dev,
> > > >         return dma_go_direct(dev, *dev->dma_mask, ops);
> > > >  }
> > > >
> > > > +bool dma_is_direct(struct device *dev)
> > > > +{
> > > > +       if (!dma_map_direct(dev, ops))
> > > > +               return false;
> > > > +
> > > > +       if (is_swiotlb_force_bounce(dev))
> > > > +               return false;
> > > > +
> > > > +       return true;
> > > > +}
> > > > +EXPORT_SYMBOL(dma_unmap_page_attrs);
> > > > +
> > > >
> > > > Thanks.
> > >
> > >
> > > where is it? linux-next?
> >
> >
> > I see it in the vhost branch kernel/dma/mapping.c.
> >
> > Maybe you miss it.
> >
> > Thanks.
> >
>
> which hash?

fd0b29af02bb75acc94eb08c06e2c10cbce2ea67

>
> > >
> > > --
> > > MST
> > >
>


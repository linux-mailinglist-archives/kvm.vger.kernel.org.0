Return-Path: <kvm+bounces-9848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3D1867393
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:41:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10FD71F2C79E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D6022626;
	Mon, 26 Feb 2024 11:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Dqh52m5K"
X-Original-To: kvm@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881781EB27;
	Mon, 26 Feb 2024 11:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708947609; cv=none; b=AVG5u1xEpl7YcyiGqEGEyd4dbXBeZkg2tgRIu+5xXb96rMNf78BdkYpF8lXg664I8EXr8PoNT4UYdh+BLbAcuyJJiHPzHpH/HZ1jpsrzzFXvDYNKnDCGtWRFA/xtzjZqIFsyKj4r8Bd6JWhjHb689rVBWT1IT74qcrdS86aqndM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708947609; c=relaxed/simple;
	bh=G2bB9eikTNkisR6fLI4bSn7xHLF5pTWvzIkiHv+Jhcw=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=I3e41r+FWKPfgt9EzSyCzaK+vMlDQldud1vBVlidpcx23ulGRCrGKxzMNQHLcpMUxtXu7ioGsjWQabioDc4/OcH8jZmvtDWKDKDuYIr2dEcWnV5PHGEPMe95FRNSa5nIjdgpa5Qv/UYZS3t+L2gryRBNy/2Q0qiAcbE6MOdlAOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Dqh52m5K; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708947602; h=Message-ID:Subject:Date:From:To;
	bh=TxVGf/coUZ5OmjL3SRz1RS1u1/x5/bUIT0IsdytHcS0=;
	b=Dqh52m5Kmh2VA6xYlpJI1C2HZo1dnmSROrACRSlvvFfOTjkLeQ5eFGlJqTgObHdvrlwUrZygNt2wERKVmgL7OhrsUSkc7ScyYpyC1XhNWtzOV04ByXGiNDmfssOUBuf+E8vB9zhhUo62+3JvjvWFRSqfb3ZxSLlIvG6jKT+ugHU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=35;SR=0;TI=SMTPD_---0W1IoY8c_1708947599;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W1IoY8c_1708947599)
          by smtp.aliyun-inc.com;
          Mon, 26 Feb 2024 19:40:00 +0800
Message-ID: <1708947549.7906592-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v2 19/19] virtio_net: sq support premapped mode
Date: Mon, 26 Feb 2024 19:39:09 +0800
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
In-Reply-To: <20240226063532-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Mon, 26 Feb 2024 06:36:53 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Feb 26, 2024 at 07:33:29PM +0800, Xuan Zhuo wrote:
> > > what is dma_map_direct? can't find it in the tree.
> >
> > YES.
> >
> >
> > diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> > index 58db8fd70471..5a8f7a927aa1 100644
> > --- a/kernel/dma/mapping.c
> > +++ b/kernel/dma/mapping.c
> > @@ -144,6 +144,18 @@ static inline bool dma_map_direct(struct device *dev,
> >         return dma_go_direct(dev, *dev->dma_mask, ops);
> >  }
> >
> > +bool dma_is_direct(struct device *dev)
> > +{
> > +       if (!dma_map_direct(dev, ops))
> > +               return false;
> > +
> > +       if (is_swiotlb_force_bounce(dev))
> > +               return false;
> > +
> > +       return true;
> > +}
> > +EXPORT_SYMBOL(dma_unmap_page_attrs);
> > +
> >
> > Thanks.
>
>
> where is it? linux-next?


I see it in the vhost branch kernel/dma/mapping.c.

Maybe you miss it.

Thanks.


>
> --
> MST
>


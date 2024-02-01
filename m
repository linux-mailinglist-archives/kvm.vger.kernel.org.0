Return-Path: <kvm+bounces-7666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D12F84511A
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 07:01:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C97871C268AA
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 06:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9241182898;
	Thu,  1 Feb 2024 06:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="v8wHP4Kw"
X-Original-To: kvm@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C079079DAF;
	Thu,  1 Feb 2024 06:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706767268; cv=none; b=BbdWgXhkMZbFO4mFV2EQMG7slYisZu9sBEabul8IV5+emCWMtWXRxyKHeJWRQNYUHr7iqaXI2P6CwycVhLduSFwYbD39QfMeJ5+iEyLdQ+7/vnGWWMHQMxkN6ZwXbEtBHSIPwFZAEP7RGevABLuU6xboLBxy2NetOTOXChPgzKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706767268; c=relaxed/simple;
	bh=OSfWm0Cv54Tjo1qbzali/LaPJkHOmXhcoj7cbZQForM=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=aDdbuVo2ItesQNAQ9OkX9VVePLWzEYCtnhref9FySUWLuUNr82p3HHzJoPxIvh7U6kxD8wl0J0UTTu93fM7pVToacqTKkpmShfEoh5yhRalhJonuyWexhYgVLWiPVgCH4qXWAKlU7GXGuqiuVHZwLSCLJUx7ngbULrVPgC7pNhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=v8wHP4Kw; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706767262; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=+X9URvqMFwi5HlX6CS16ZlVcfG6G7YCThFlcfQTyeJk=;
	b=v8wHP4Kw6A2J4H7xoBcINDCL6DAde0IfksikeDWIE8cOGbTIiLtKWEhpVwQ6ZJvx6ZAVJXR3+6L1wnFEffYu7vbPR0uDaeLMVm280raQHODVqS/YM2jqOfwpFACip11JZ7olJ8MfSPAmLE4uolOgWBtHE4izt+9CYB7PvYZnYH0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W.obMGn_1706767259;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.obMGn_1706767259)
          by smtp.aliyun-inc.com;
          Thu, 01 Feb 2024 14:01:00 +0800
Message-ID: <1706766995.312187-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 17/17] virtio_net: sq support premapped mode
Date: Thu, 1 Feb 2024 13:56:35 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 "Michael S. Tsirkin" <mst@redhat.com>,
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
 Benjamin Berg <benjamin.berg@intel.com>,
 Yang Li <yang.lee@linux.alibaba.com>,
 linux-um@lists.infradead.org,
 netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 bpf@vger.kernel.org
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
 <20240130114224.86536-18-xuanzhuo@linux.alibaba.com>
 <CACGkMEv2cyuesaTx899hwZt7uDdqwmAwXJ8fZDv00W9FbVbTpw@mail.gmail.com>
 <1706757660.3554723-2-xuanzhuo@linux.alibaba.com>
 <CACGkMEtwWAijrLOrdgJ9ZPx5VjSfJtwVm1k1U8fsg9+tvgRHxg@mail.gmail.com>
In-Reply-To: <CACGkMEtwWAijrLOrdgJ9ZPx5VjSfJtwVm1k1U8fsg9+tvgRHxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 1 Feb 2024 13:36:46 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Thu, Feb 1, 2024 at 11:28=E2=80=AFAM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > On Wed, 31 Jan 2024 17:12:47 +0800, Jason Wang <jasowang@redhat.com> wr=
ote:
> > > On Tue, Jan 30, 2024 at 7:43=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.ali=
baba.com> wrote:
> > > >
> > > > If the xsk is enabling, the xsk tx will share the send queue.
> > > > But the xsk requires that the send queue use the premapped mode.
> > > > So the send queue must support premapped mode.
> > > >
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > ---
> > > >  drivers/net/virtio_net.c | 167 +++++++++++++++++++++++++++++++++++=
+++-
> > > >  1 file changed, 163 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 226ab830870e..cf0c67380b07 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -46,6 +46,7 @@ module_param(napi_tx, bool, 0644);
> > > >  #define VIRTIO_XDP_REDIR       BIT(1)
> > > >
> > > >  #define VIRTIO_XDP_FLAG        BIT(0)
> > > > +#define VIRTIO_DMA_FLAG        BIT(1)
> > > >
> > > >  /* RX packet size EWMA. The average packet size is used to determi=
ne the packet
> > > >   * buffer size when refilling RX rings. As the entire RX ring may =
be refilled
> > > > @@ -140,6 +141,21 @@ struct virtnet_rq_dma {
> > > >         u16 need_sync;
> > > >  };
> > > >
> > > > +struct virtnet_sq_dma {
> > > > +       union {
> > > > +               struct virtnet_sq_dma *next;
> > > > +               void *data;
> > > > +       };
> > > > +       dma_addr_t addr;
> > > > +       u32 len;
> > > > +       bool is_tail;
> > > > +};
> > > > +
> > > > +struct virtnet_sq_dma_head {
> > > > +       struct virtnet_sq_dma *free;
> > > > +       struct virtnet_sq_dma *head;
> > >
> > > Any reason the head must be a pointer instead of a simple index?
> >
> >
> > The head is used for kfree.
> > Maybe I need to rename it.
> >
> > About the index(next) of the virtnet_sq_dma.
> > If we use the index, the struct will be:
> >
> > struct virtnet_sq_dma {
> >        dma_addr_t addr;
> >        u32 len;
> >
> >        u32 next;
> >        void *data
> > };
> >
> > The size of virtnet_sq_dma is same.
>
> Ok.
>
> >
> >
> > >
> > > > +};
> > > > +
> > > >  /* Internal representation of a send virtqueue */
> > > >  struct send_queue {
> > > >         /* Virtqueue associated with this send _queue */
> > > > @@ -159,6 +175,8 @@ struct send_queue {
> > > >
> > > >         /* Record whether sq is in reset state. */
> > > >         bool reset;
> > > > +
> > > > +       struct virtnet_sq_dma_head dmainfo;
> > > >  };
> > > >
> >
> > ....
> >
> > > > +
> > > > +static int virtnet_sq_init_dma_mate(struct send_queue *sq)
> > > > +{
> > > > +       struct virtnet_sq_dma *d;
> > > > +       int size, i;
> > > > +
> > > > +       size =3D virtqueue_get_vring_size(sq->vq);
> > > > +
> > > > +       size +=3D MAX_SKB_FRAGS + 2;
> > >
> > > Is this enough for the case where an indirect descriptor is used?
> >
> >
> > This is for the case, when the ring is full, the xmit_skb is called.
> >
> > I will add comment.
>
> Just to make sure we are at the same page.
>
> I meant, we could have more pending #sg than allocated here.
>
> For example, we can have up to (vring_size - 2 - MAX_SKB_FRAGS) *
> MAX_SKB_FRAGS number of pending sgs?
>

Oh, my was wrong.

But the max value a
But shouldn't the maximum value be vring_size * (2 + MAX_SKB_FRAGS)?

And for the reason above, we should allocate (vring_size + 1) * (2 + MAX_SK=
B_FRAGS);

Thanks.


> Thanks
>
> >
> > Thanks.
> >
> >
> > >
> > > Thanks
> > >
> >
>


Return-Path: <kvm+bounces-7556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BC7843B9A
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:00:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF6EC1F282D7
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E4869DEC;
	Wed, 31 Jan 2024 10:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Kvqz6s9K"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC8769D02;
	Wed, 31 Jan 2024 10:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706695212; cv=none; b=k3jlRdBqI2T0+JbT1SrSn+9SIh3JDb7ZxpTwCmj1Qy1KM4Udi9OwEybUaqQ/JBVBpFI9reN1DOHbfLd5TB9+/hrXqS6wUhqY/wm0a/HXgTlHKvWY5IuA311Mdo9J+x0o8wXlaRAIbJre0PqRpfVH/Uh0BGrtPnNO6gli1vBb/SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706695212; c=relaxed/simple;
	bh=3YYnMFWaHlPJ60dfD6efY57fsxADccjN5zhuuAuHkMY=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=T4udq8sQWJhFjHwlAQNKgorkfLCrn64sw3YmqM6qjz8UyRuwdqZKhowFEJCvVGa9EAkYxxYphuoEcqJuCocmm5/zethPXiritSv8+ZcJtrEQ8bWp8qIEuZTGAbHan1r79ZDRL2kMuxOdqABUqZNMEe1fe5eVx5GXzdNW3XW3EEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Kvqz6s9K; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706695205; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=S+Pxc9YcDST59bqyXfYiPF01ckRIlykMvVP5/58u+kg=;
	b=Kvqz6s9K9t2X2u2Ok9+bppkcPILNGun3TxFOeQwJEVuCFaz6iZ/KJKPzI7PpeLSuBhzv00ryi2cX7e8FMDpfEGQOjwhx8cwT0ztO6igE4kMGBJWwv41XiN33spoG3g0WipdxrZ5M1KC3ln9vFv9mU8V+j1vzdgzfSxkp9aPnd1c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W.jFUFC_1706695202;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.jFUFC_1706695202)
          by smtp.aliyun-inc.com;
          Wed, 31 Jan 2024 18:00:03 +0800
Message-ID: <1706695107.9558825-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 02/17] virtio_ring: packed: remove double check of the unmap ops
Date: Wed, 31 Jan 2024 17:58:27 +0800
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
 <20240130114224.86536-3-xuanzhuo@linux.alibaba.com>
 <CACGkMEvmqVpcXCaF6f24N6gTN2yHJOeu0bL4JBYL4Zmyg8C2sQ@mail.gmail.com>
In-Reply-To: <CACGkMEvmqVpcXCaF6f24N6gTN2yHJOeu0bL4JBYL4Zmyg8C2sQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Wed, 31 Jan 2024 17:12:19 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Jan 30, 2024 at 7:42=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > In the functions vring_unmap_extra_packed and vring_unmap_desc_packed,
> > multiple checks are made whether unmap is performed and whether it is
> > INDIRECT.
> >
> > These two functions are usually called in a loop, and we should put the
> > check outside the loop.
> >
> > And we unmap the descs with VRING_DESC_F_INDIRECT on the same path with
> > other descs, that make the thing more complex. If we distinguish the
> > descs with VRING_DESC_F_INDIRECT before unmap, thing will be clearer.
> >
> > 1. only one desc of the desc table is used, we do not need the loop
> > 2. the called unmap api is difference from the other desc
> > 3. the vq->premapped is not needed to check
> > 4. the vq->indirect is not needed to check
> > 5. the state->indir_desc must not be null
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/virtio/virtio_ring.c | 76 ++++++++++++++++++------------------
> >  1 file changed, 39 insertions(+), 37 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 4677831e6c26..7280a1706cca 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -1220,6 +1220,7 @@ static u16 packed_last_used(u16 last_used_idx)
> >         return last_used_idx & ~(-(1 << VRING_PACKED_EVENT_F_WRAP_CTR));
> >  }
> >
> > +/* caller must check vring_need_unmap_buffer() */
> >  static void vring_unmap_extra_packed(const struct vring_virtqueue *vq,
> >                                      const struct vring_desc_extra *ext=
ra)
> >  {
> > @@ -1227,33 +1228,18 @@ static void vring_unmap_extra_packed(const stru=
ct vring_virtqueue *vq,
> >
> >         flags =3D extra->flags;
> >
> > -       if (flags & VRING_DESC_F_INDIRECT) {
> > -               if (!vq->use_dma_api)
> > -                       return;
> > -
> > -               dma_unmap_single(vring_dma_dev(vq),
> > -                                extra->addr, extra->len,
> > -                                (flags & VRING_DESC_F_WRITE) ?
> > -                                DMA_FROM_DEVICE : DMA_TO_DEVICE);
> > -       } else {
> > -               if (!vring_need_unmap_buffer(vq))
> > -                       return;
> > -
> > -               dma_unmap_page(vring_dma_dev(vq),
> > -                              extra->addr, extra->len,
> > -                              (flags & VRING_DESC_F_WRITE) ?
> > -                              DMA_FROM_DEVICE : DMA_TO_DEVICE);
> > -       }
> > +       dma_unmap_page(vring_dma_dev(vq),
> > +                      extra->addr, extra->len,
> > +                      (flags & VRING_DESC_F_WRITE) ?
> > +                      DMA_FROM_DEVICE : DMA_TO_DEVICE);
> >  }
> >
> > +/* caller must check vring_need_unmap_buffer() */
> >  static void vring_unmap_desc_packed(const struct vring_virtqueue *vq,
> >                                     const struct vring_packed_desc *des=
c)
> >  {
> >         u16 flags;
> >
> > -       if (!vring_need_unmap_buffer(vq))
> > -               return;
> > -
> >         flags =3D le16_to_cpu(desc->flags);
> >
> >         dma_unmap_page(vring_dma_dev(vq),
> > @@ -1329,7 +1315,7 @@ static int virtqueue_add_indirect_packed(struct v=
ring_virtqueue *vq,
> >                         total_sg * sizeof(struct vring_packed_desc),
> >                         DMA_TO_DEVICE);
> >         if (vring_mapping_error(vq, addr)) {
> > -               if (vq->premapped)
> > +               if (!vring_need_unmap_buffer(vq))
> >                         goto free_desc;
> >
> >                 goto unmap_release;
> > @@ -1344,10 +1330,11 @@ static int virtqueue_add_indirect_packed(struct=
 vring_virtqueue *vq,
> >                 vq->packed.desc_extra[id].addr =3D addr;
> >                 vq->packed.desc_extra[id].len =3D total_sg *
> >                                 sizeof(struct vring_packed_desc);
> > -               vq->packed.desc_extra[id].flags =3D VRING_DESC_F_INDIRE=
CT |
> > -                                                 vq->packed.avail_used=
_flags;
> >         }
> >
> > +       vq->packed.desc_extra[id].flags =3D VRING_DESC_F_INDIRECT |
> > +               vq->packed.avail_used_flags;
>
> Is this a bug fix? Or if we only need to check _F_INDIRECT, we can
> simply avoid doing this by checking vq->indirect && state->indir_desc?
>
> > +
> >         /*
> >          * A driver MUST NOT make the first descriptor in the list
> >          * available before all subsequent descriptors comprising
> > @@ -1388,6 +1375,8 @@ static int virtqueue_add_indirect_packed(struct v=
ring_virtqueue *vq,
> >  unmap_release:
> >         err_idx =3D i;
> >
> > +       WARN_ON(!vring_need_unmap_buffer(vq));
>
> Nitpick, using BUG_ON might be better as it may lead to unexpected
> results which we can't recover from.

the checkpatch.pl does not like BUG_ON.
I have not preference.


>
> > +
> >         for (i =3D 0; i < err_idx; i++)
> >                 vring_unmap_desc_packed(vq, &desc[i]);
> >
> > @@ -1484,9 +1473,10 @@ static inline int virtqueue_add_packed(struct vi=
rtqueue *_vq,
> >                         if (unlikely(vring_need_unmap_buffer(vq))) {
> >                                 vq->packed.desc_extra[curr].addr =3D ad=
dr;
> >                                 vq->packed.desc_extra[curr].len =3D sg-=
>length;
> > -                               vq->packed.desc_extra[curr].flags =3D
> > -                                       le16_to_cpu(flags);
> >                         }
> > +
> > +                       vq->packed.desc_extra[curr].flags =3D le16_to_c=
pu(flags);
> > +
> >                         prev =3D curr;
> >                         curr =3D vq->packed.desc_extra[curr].next;
> >
> > @@ -1536,6 +1526,8 @@ static inline int virtqueue_add_packed(struct vir=
tqueue *_vq,
> >
> >         vq->packed.avail_used_flags =3D avail_used_flags;
> >
> > +       WARN_ON(!vring_need_unmap_buffer(vq));
> > +
> >         for (n =3D 0; n < total_sg; n++) {
> >                 if (i =3D=3D err_idx)
> >                         break;
> > @@ -1605,7 +1597,9 @@ static void detach_buf_packed(struct vring_virtqu=
eue *vq,
> >         struct vring_desc_state_packed *state =3D NULL;
> >         struct vring_packed_desc *desc;
> >         unsigned int i, curr;
> > +       u16 flags;
> >
> > +       flags =3D vq->packed.desc_extra[id].flags;
> >         state =3D &vq->packed.desc_state[id];
> >
> >         /* Clear data ptr. */
> > @@ -1615,22 +1609,32 @@ static void detach_buf_packed(struct vring_virt=
queue *vq,
> >         vq->free_head =3D id;
> >         vq->vq.num_free +=3D state->num;
> >
> > -       if (unlikely(vring_need_unmap_buffer(vq))) {
> > -               curr =3D id;
> > -               for (i =3D 0; i < state->num; i++) {
> > -                       vring_unmap_extra_packed(vq,
> > -                                                &vq->packed.desc_extra=
[curr]);
> > -                       curr =3D vq->packed.desc_extra[curr].next;
> > +       if (!(flags & VRING_DESC_F_INDIRECT)) {
> > +               if (vring_need_unmap_buffer(vq)) {
> > +                       curr =3D id;
> > +                       for (i =3D 0; i < state->num; i++) {
> > +                               vring_unmap_extra_packed(vq,
> > +                                                        &vq->packed.de=
sc_extra[curr]);
> > +                               curr =3D vq->packed.desc_extra[curr].ne=
xt;
> > +                       }
>
> So before the change, we had:
>
>         if (unlikely(vq->do_unmap)) {
>                 curr =3D id;
>                 for (i =3D 0; i < state->num; i++) {
>                         vring_unmap_extra_packed(vq,
>                                                  &vq->packed.desc_extra[c=
urr]);
>                         curr =3D vq->packed.desc_extra[curr].next;
>                 }
>         }
>
> This looks like a bug as we should unmap the indirect descriptor
> regradless of whether do_unmap is true or false.
>
> If yes, we need a independent fix instead of squashing it in this patch?


YES. I noticed this.
I will post a fix to the stable branch.

Thanks.


>
> >                 }
> > -       }
> >
> > -       if (vq->indirect) {
> > +               if (ctx)
> > +                       *ctx =3D state->indir_desc;
> > +       } else {
> > +               const struct vring_desc_extra *extra;
> >                 u32 len;
> >
> > +               if (vq->use_dma_api) {
> > +                       extra =3D &vq->packed.desc_extra[id];
> > +                       dma_unmap_single(vring_dma_dev(vq),
> > +                                        extra->addr, extra->len,
> > +                                        (flags & VRING_DESC_F_WRITE) ?
> > +                                        DMA_FROM_DEVICE : DMA_TO_DEVIC=
E);
> > +               }
> > +
>
> Thanks
>


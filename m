Return-Path: <kvm+bounces-7670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C92B184519A
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 07:48:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3EC3B255B6
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 06:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB961586CD;
	Thu,  1 Feb 2024 06:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RpNvQwqg"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACDA2B9D1;
	Thu,  1 Feb 2024 06:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706770099; cv=none; b=qrzPLID90LjgcM1YJqR7gInocdjnBqLoenrOukG1MRBRmHN/TbS+2RH0RRuIktElPTbHPcrWzgHHk6fjAraHOQ91NVNXJ47QChDf0dfz0yf7OozNJIAQFjQ2L9cZqmryCwPpgMfuTCPaKXv/JTRbIqjIXnh7b7ISjzYgoKw/e7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706770099; c=relaxed/simple;
	bh=/IVd0rrF2KtB3FVvceo+CBZZI6gkOZlP17o00V0cGH0=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=HQpNwXGMCpGy4Yj9edVJdN2qWV8qVCFOY/XQuiOF9pNNFvmDtpRdHC/qz4/4VesalnXHyh9Et1BQJ7DMvHNwTFos+XGICVpEjnAvQyUZDEtw4EmNrl13q5jUgZpvjhv7HwNYJ/svCc4X2er+FfH+R68Wq1HO0vYD41Su+eBXF9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RpNvQwqg; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706770092; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=TWr1CQEd6xDFjrk3l/xQeYg2YrwKV9kMpWG3h49S4As=;
	b=RpNvQwqgUfd72kbGTTKiD7twUlcwT+90WNVJuZqk9kV6hNiZwQglR/iDryXfWiX47nsLiHXtabYqu8LXpD6WKaVPbk/9sV5fscoFkqZM6blJKhAkvP3EfoXWeGQePnq01X4kt8r3P+vGpjvfEBMvD0HaawNFfqTOh9Z6KJNgM/Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W.pYjzd_1706770089;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.pYjzd_1706770089)
          by smtp.aliyun-inc.com;
          Thu, 01 Feb 2024 14:48:10 +0800
Message-ID: <1706769826.0586398-4-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 04/17] virtio_ring: split: remove double check of the unmap ops
Date: Thu, 1 Feb 2024 14:43:46 +0800
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
 <20240130114224.86536-5-xuanzhuo@linux.alibaba.com>
 <CACGkMEs-wUa_z_tGYEwBf7EVJAtuJdkX4HAdjqMXHEM1ys-gKQ@mail.gmail.com>
In-Reply-To: <CACGkMEs-wUa_z_tGYEwBf7EVJAtuJdkX4HAdjqMXHEM1ys-gKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Wed, 31 Jan 2024 17:12:22 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Jan 30, 2024 at 7:42=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > In the functions vring_unmap_one_split and
> > vring_unmap_one_split_indirect,
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
> >  drivers/virtio/virtio_ring.c | 80 ++++++++++++++++++------------------
> >  1 file changed, 39 insertions(+), 41 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index dd03bc5a81fe..2b41fdbce975 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -452,9 +452,6 @@ static void vring_unmap_one_split_indirect(const st=
ruct vring_virtqueue *vq,
> >  {
> >         u16 flags;
> >
> > -       if (!vring_need_unmap_buffer(vq))
> > -               return;
> > -
> >         flags =3D virtio16_to_cpu(vq->vq.vdev, desc->flags);
> >
> >         dma_unmap_page(vring_dma_dev(vq),
> > @@ -472,27 +469,12 @@ static unsigned int vring_unmap_one_split(const s=
truct vring_virtqueue *vq,
> >
> >         flags =3D extra[i].flags;
> >
> > -       if (flags & VRING_DESC_F_INDIRECT) {
> > -               if (!vq->use_dma_api)
> > -                       goto out;
> > -
> > -               dma_unmap_single(vring_dma_dev(vq),
> > -                                extra[i].addr,
> > -                                extra[i].len,
> > -                                (flags & VRING_DESC_F_WRITE) ?
> > -                                DMA_FROM_DEVICE : DMA_TO_DEVICE);
> > -       } else {
> > -               if (!vring_need_unmap_buffer(vq))
> > -                       goto out;
> > -
> > -               dma_unmap_page(vring_dma_dev(vq),
> > -                              extra[i].addr,
> > -                              extra[i].len,
> > -                              (flags & VRING_DESC_F_WRITE) ?
> > -                              DMA_FROM_DEVICE : DMA_TO_DEVICE);
> > -       }
> > +       dma_unmap_page(vring_dma_dev(vq),
> > +                      extra[i].addr,
> > +                      extra[i].len,
> > +                      (flags & VRING_DESC_F_WRITE) ?
> > +                      DMA_FROM_DEVICE : DMA_TO_DEVICE);
> >
> > -out:
> >         return extra[i].next;
> >  }
> >
> > @@ -660,7 +642,7 @@ static inline int virtqueue_add_split(struct virtqu=
eue *_vq,
> >                         vq, desc, total_sg * sizeof(struct vring_desc),
> >                         DMA_TO_DEVICE);
> >                 if (vring_mapping_error(vq, addr)) {
> > -                       if (vq->premapped)
> > +                       if (!vring_need_unmap_buffer(vq))
> >                                 goto free_indirect;
> >
> >                         goto unmap_release;
> > @@ -713,6 +695,9 @@ static inline int virtqueue_add_split(struct virtqu=
eue *_vq,
> >         return 0;
> >
> >  unmap_release:
> > +
> > +       WARN_ON(!vring_need_unmap_buffer(vq));
> > +
> >         err_idx =3D i;
> >
> >         if (indirect)
> > @@ -774,34 +759,42 @@ static void detach_buf_split(struct vring_virtque=
ue *vq, unsigned int head,
> >  {
> >         unsigned int i, j;
> >         __virtio16 nextflag =3D cpu_to_virtio16(vq->vq.vdev, VRING_DESC=
_F_NEXT);
> > +       u16 flags;
> >
> >         /* Clear data ptr. */
> >         vq->split.desc_state[head].data =3D NULL;
> > +       flags =3D vq->split.desc_extra[head].flags;
> >
> >         /* Put back on free list: unmap first-level descriptors and fin=
d end */
> >         i =3D head;
> >
> > -       while (vq->split.vring.desc[i].flags & nextflag) {
> > -               vring_unmap_one_split(vq, i);
> > -               i =3D vq->split.desc_extra[i].next;
> > -               vq->vq.num_free++;
> > -       }
> > -
> > -       vring_unmap_one_split(vq, i);
> > -       vq->split.desc_extra[i].next =3D vq->free_head;
> > -       vq->free_head =3D head;
> > +       if (!(flags & VRING_DESC_F_INDIRECT)) {
>
> So during add we do:
>
>         if (!indirect && vring_need_unmap_buffer(vq))
>                 vq->split.desc_extra[prev & (vq->split.vring.num - 1)].fl=
ags &=3D
>                         ~VRING_DESC_F_NEXT;


This does not affect this patch.

1. this just considers the VRING_DESC_F_NEXT of desc_extra.flags
2. the desc_extra.flags is updated by virtqueue_add_desc_split()

So for desc_extra.flags & VRING_DESC_F_INDIRECT, that is right.

Thanks.


>
> Then using flags here unconditionally seems not reliable.
>
> I post a patch to store flags unconditionally at:
>
> https://lore.kernel.org/all/20220224122655-mutt-send-email-mst@kernel.org/
>
> > +               while (vq->split.vring.desc[i].flags & nextflag) {
> > +                       if (vring_need_unmap_buffer(vq))
> > +                               vring_unmap_one_split(vq, i);
> > +                       i =3D vq->split.desc_extra[i].next;
> > +                       vq->vq.num_free++;
> > +               }
> >
> > -       /* Plus final descriptor */
> > -       vq->vq.num_free++;
> > +               if (vring_need_unmap_buffer(vq))
> > +                       vring_unmap_one_split(vq, i);
> >
> > -       if (vq->indirect) {
> > +               if (ctx)
> > +                       *ctx =3D vq->split.desc_state[head].indir_desc;
> > +       } else {
> >                 struct vring_desc *indir_desc =3D
> >                                 vq->split.desc_state[head].indir_desc;
> >                 u32 len;
> >
> > -               /* Free the indirect table, if any, now that it's unmap=
ped. */
> > -               if (!indir_desc)
> > -                       return;
> > +               if (vq->use_dma_api) {
> > +                       struct vring_desc_extra *extra =3D vq->split.de=
sc_extra;
> > +
> > +                       dma_unmap_single(vring_dma_dev(vq),
> > +                                        extra[i].addr,
> > +                                        extra[i].len,
> > +                                        (flags & VRING_DESC_F_WRITE) ?
> > +                                        DMA_FROM_DEVICE : DMA_TO_DEVIC=
E);
> > +               }
>
> Note that there's a following
>
> BUG_ON(!(vq->split.desc_extra[head].flags &
>                                 VRING_DESC_F_INDIRECT));
>
> Which I think we can remove.
>
> Thanks
>


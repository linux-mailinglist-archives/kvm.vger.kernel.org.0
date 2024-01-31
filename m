Return-Path: <kvm+bounces-7567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C887843BB1
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14B9B1F2C75D
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C409D6A02F;
	Wed, 31 Jan 2024 10:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dPIX2M37"
X-Original-To: kvm@vger.kernel.org
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF58469D03;
	Wed, 31 Jan 2024 10:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706695285; cv=none; b=s3bLZ2piCyAaOBLI7LmN/q5nR0D5QymVKk4YcJQ07OGHqk8QuzDNIDol6DA9uozB8V9gZFvZRFJ1Rc8Rh6QfIFWHjvogq4q1w0OouqWWR3XErcIdsmvc5IJUSFmriCcPMFrafdzN8XqDXE2f1Qn0OmsClNBXRPE39LcbRqvpJ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706695285; c=relaxed/simple;
	bh=5GPX+NAbxn+D9MTBLeCfhGrK6GLGqIjJb9fk23SfNg8=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=XQ2h41ijn1NJalRRObaj/khsFb/4bROnzlR9UVou1rbi9u7BW2a+nwCByBOJpBtYYn4zGD72JLcixYK5ZADYSJSt0Es9ALMpPST9ZGR/KhOpE2FCYv7LioW47GjYhnCi3mUO7G6cUX9TQj/lPP4oZupgHVaT0AqSWL9VVDL8QIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dPIX2M37; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706695273; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=hNzHtzVpBU2+0miP3b1vKMXJO0IZm/151kGzW+L2WI0=;
	b=dPIX2M37FXzeuLvu/e7vAhw16m76USR7dwEXKk+PZrc9aEf2ot/6S6xUjYvDN8i9LLAQHAygyTsPkNWxAjyNkTUxy2YMzd+WpprVJeHLhBBXTtGa8aC3CClZl41W2CoZHoAb3Oih0ZsNq6T+b2V6+q4cqERNCPoRnkYhzWbOBXQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W.j9ASw_1706695270;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.j9ASw_1706695270)
          by smtp.aliyun-inc.com;
          Wed, 31 Jan 2024 18:01:11 +0800
Message-ID: <1706695212.333408-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 03/17] virtio_ring: packed: structure the indirect desc table
Date: Wed, 31 Jan 2024 18:00:12 +0800
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
 <20240130114224.86536-4-xuanzhuo@linux.alibaba.com>
 <CACGkMEvz55WO+TN2KCv+KLvdT-ZxLike81maahBeVanrCk_Lrg@mail.gmail.com>
In-Reply-To: <CACGkMEvz55WO+TN2KCv+KLvdT-ZxLike81maahBeVanrCk_Lrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Wed, 31 Jan 2024 17:12:10 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Jan 30, 2024 at 7:42=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > This commit structure the indirect desc table.
> > Then we can get the desc num directly when doing unmap.
> >
> > And save the dma info to the struct, then the indirect
> > will not use the dma fields of the desc_extra. The subsequent
> > commits will make the dma fields are optional. But for
> > the indirect case, we must record the dma info.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/virtio/virtio_ring.c | 63 ++++++++++++++++++++----------------
> >  1 file changed, 35 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 7280a1706cca..dd03bc5a81fe 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -72,9 +72,16 @@ struct vring_desc_state_split {
> >         struct vring_desc *indir_desc;  /* Indirect descriptor, if any.=
 */
> >  };
> >
> > +struct vring_packed_desc_indir {
> > +       dma_addr_t addr;                /* Descriptor Array DMA addr. */
> > +       u32 len;                        /* Descriptor Array length. */
> > +       u32 num;
> > +       struct vring_packed_desc desc[];
> > +};
> > +
> >  struct vring_desc_state_packed {
> >         void *data;                     /* Data for callback. */
> > -       struct vring_packed_desc *indir_desc; /* Indirect descriptor, i=
f any. */
> > +       struct vring_packed_desc_indir *indir_desc; /* Indirect descrip=
tor, if any. */
> >         u16 num;                        /* Descriptor list length. */
> >         u16 last;                       /* The last desc state in a lis=
t. */
> >  };
> > @@ -1249,10 +1256,13 @@ static void vring_unmap_desc_packed(const struc=
t vring_virtqueue *vq,
> >                        DMA_FROM_DEVICE : DMA_TO_DEVICE);
> >  }
> >
> > -static struct vring_packed_desc *alloc_indirect_packed(unsigned int to=
tal_sg,
> > +static struct vring_packed_desc_indir *alloc_indirect_packed(unsigned =
int total_sg,
> >                                                        gfp_t gfp)
> >  {
> > -       struct vring_packed_desc *desc;
> > +       struct vring_packed_desc_indir *in_desc;
> > +       u32 size;
> > +
> > +       size =3D struct_size(in_desc, desc, total_sg);
> >
> >         /*
> >          * We require lowmem mappings for the descriptors because
> > @@ -1261,9 +1271,10 @@ static struct vring_packed_desc *alloc_indirect_=
packed(unsigned int total_sg,
> >          */
> >         gfp &=3D ~__GFP_HIGHMEM;
> >
> > -       desc =3D kmalloc_array(total_sg, sizeof(struct vring_packed_des=
c), gfp);
> >
> > -       return desc;
> > +       in_desc =3D kmalloc(size, gfp);
> > +
> > +       return in_desc;
> >  }
> >
> >  static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
> > @@ -1274,6 +1285,7 @@ static int virtqueue_add_indirect_packed(struct v=
ring_virtqueue *vq,
> >                                          void *data,
> >                                          gfp_t gfp)
> >  {
> > +       struct vring_packed_desc_indir *in_desc;
> >         struct vring_packed_desc *desc;
> >         struct scatterlist *sg;
> >         unsigned int i, n, err_idx;
> > @@ -1281,10 +1293,12 @@ static int virtqueue_add_indirect_packed(struct=
 vring_virtqueue *vq,
> >         dma_addr_t addr;
> >
> >         head =3D vq->packed.next_avail_idx;
> > -       desc =3D alloc_indirect_packed(total_sg, gfp);
> > -       if (!desc)
> > +       in_desc =3D alloc_indirect_packed(total_sg, gfp);
> > +       if (!in_desc)
> >                 return -ENOMEM;
> >
> > +       desc =3D in_desc->desc;
> > +
> >         if (unlikely(vq->vq.num_free < 1)) {
> >                 pr_debug("Can't add buf len 1 - avail =3D 0\n");
> >                 kfree(desc);
> > @@ -1321,17 +1335,15 @@ static int virtqueue_add_indirect_packed(struct=
 vring_virtqueue *vq,
> >                 goto unmap_release;
> >         }
> >
> > +       in_desc->num =3D i;
> > +       in_desc->addr =3D addr;
> > +       in_desc->len =3D total_sg * sizeof(struct vring_packed_desc);
>
> It looks to me if we don't use dma_api we don't even need these steps?

YES


>
> > +
> >         vq->packed.vring.desc[head].addr =3D cpu_to_le64(addr);
> >         vq->packed.vring.desc[head].len =3D cpu_to_le32(total_sg *
> >                                 sizeof(struct vring_packed_desc));
> >         vq->packed.vring.desc[head].id =3D cpu_to_le16(id);
> >
> > -       if (vring_need_unmap_buffer(vq)) {
> > -               vq->packed.desc_extra[id].addr =3D addr;
> > -               vq->packed.desc_extra[id].len =3D total_sg *
> > -                               sizeof(struct vring_packed_desc);
> > -       }
> > -
> >         vq->packed.desc_extra[id].flags =3D VRING_DESC_F_INDIRECT |
> >                 vq->packed.avail_used_flags;
> >
> > @@ -1362,7 +1374,7 @@ static int virtqueue_add_indirect_packed(struct v=
ring_virtqueue *vq,
> >         /* Store token and indirect buffer state. */
> >         vq->packed.desc_state[id].num =3D 1;
> >         vq->packed.desc_state[id].data =3D data;
> > -       vq->packed.desc_state[id].indir_desc =3D desc;
> > +       vq->packed.desc_state[id].indir_desc =3D in_desc;
> >         vq->packed.desc_state[id].last =3D id;
> >
> >         vq->num_added +=3D 1;
> > @@ -1381,7 +1393,7 @@ static int virtqueue_add_indirect_packed(struct v=
ring_virtqueue *vq,
> >                 vring_unmap_desc_packed(vq, &desc[i]);
> >
> >  free_desc:
> > -       kfree(desc);
> > +       kfree(in_desc);
> >
> >         END_USE(vq);
> >         return -ENOMEM;
> > @@ -1595,7 +1607,6 @@ static void detach_buf_packed(struct vring_virtqu=
eue *vq,
> >                               unsigned int id, void **ctx)
> >  {
> >         struct vring_desc_state_packed *state =3D NULL;
> > -       struct vring_packed_desc *desc;
> >         unsigned int i, curr;
> >         u16 flags;
> >
> > @@ -1621,28 +1632,24 @@ static void detach_buf_packed(struct vring_virt=
queue *vq,
> >
> >                 if (ctx)
> >                         *ctx =3D state->indir_desc;
> > +
>
> Unnecessary changes.


Could you say more?
You do not like this patch?

Thanks.



>
> Thanks
>


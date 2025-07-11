Return-Path: <kvm+bounces-52080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D78AFB010E5
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 03:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CEBC7647C5
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 01:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6035F14EC62;
	Fri, 11 Jul 2025 01:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HWQdNZfB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA3E12C499
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 01:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752198269; cv=none; b=M9oyrtSPdfJ2FbAn6uQi/5TxhVtajKBnaEeX8Xn+CdNmxTF1mrDsF/ZlIwFOmVz3/jT0lukugAH1Q3rq+i5z/afOoo7glMHxndBuK8J8ctR3A3IZ88ODN9oZ22AmoE8ueEhNN2g7QUj7Ipc8wFgYknp2Os/gFUEoJYlu0EXUxZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752198269; c=relaxed/simple;
	bh=wjSWkTPeBXW2tx1Qqi01hbov7H8psV4kqgnpKsfLW5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mL57rTQ23u3Pn+CfcYLDtY3/YlxETX7a4N3wB/vWQOrwILmsqePf7kRX6QQTtCq37xtEZdNHx2l+MHkUXrpStbGMByDrHh+9Jevs2FRNIrTe/i3CNW6LYji3HagPvOEkpZ6AZuBydP4j3/nor3ruWHuu7fdkGz4gEl6q2p1X9/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HWQdNZfB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752198265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zt3KlbbLlIb9ntQo8ZxiuXNPWEVPbSNN/c/T7N+f2kQ=;
	b=HWQdNZfBkxcWqoDAtxO9LtnSgmWtPLrRl2wQ8eJHvGG4yedcDhr3SYNzWRxG1gxFrcGIPw
	GLLcM1Mh972OSxiAKyG2hFaAc38fA8WPe2hMJAw++QIpd6pT4Bh4hsJgFT2UP32oAwz+xl
	ZhYZSqIl6IUFR5zumdYdcibR5BGTP0c=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-XfmglyxsN06mOrNZihBnBQ-1; Thu, 10 Jul 2025 21:44:24 -0400
X-MC-Unique: XfmglyxsN06mOrNZihBnBQ-1
X-Mimecast-MFC-AGG-ID: XfmglyxsN06mOrNZihBnBQ_1752198263
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-312df02acf5so2192127a91.1
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 18:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752198263; x=1752803063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zt3KlbbLlIb9ntQo8ZxiuXNPWEVPbSNN/c/T7N+f2kQ=;
        b=OhjEHtYwQgUYRB5mA2YMcYl9pC4WRpoazLk0lsyVAJ1YnZLiVqdjxBxyWjXS8lkkcb
         +sHB3yWHzYh4YDmhLOsxgKe+YgfRqfZ80Cq/EyzKuqNne3d1HrD23sMJc14oo22bpkSW
         GeXTuQRYsbXqB40VjToNnSgK+QNRyI3rPuVaIPK4bzl1d6h+y+MyIsj+t/pQPmv/RtKL
         n4Uu4QCTmeFaXW/6VlBh4QObOKZ2e1e6Yiw1KTkeCZoPDynbH5EP9tjY8JuQdnhmcOAY
         sNjTa+RxAoeACTcf1jcXX7BvP3J2w7sdryIWhn8+XvsWQqs3lJVCHkSr3zHaGG4d4VG5
         R4+w==
X-Forwarded-Encrypted: i=1; AJvYcCWBh+ymdMTjvqOXFV9w7V4cTEf69HD5dxrQ58SF+g81c+ubz4oqiBWsqQfXF5EF0RqLkd4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzklaF57xQVclHE3dKjKb0OPWqxcDpteWIKuHHxM2kT8WAKASgc
	abeRb+uZ98u9nSrqpNUHJRXm+DWFC4ZUKuis8RSTi6OH5cJQDcRArQs8D0gDRYxZFbJaFAHH4sS
	rgv8CEKo+7bvefnlODMNPEfgTyEL50CNa9LH2nQa0xVlZfmDFOwnSPTahzYP3xbLcQTyOrlzYYJ
	IQY5IipW3RgQcyGrHV9ifx9yAynGgaNY6+gEimS14=
X-Gm-Gg: ASbGncuHBeboCg0b4/3pvj9nhO6lQn2DLYqoLQpvUnVExmmcafGYQQBEmt1Ek0VmOP7
	LmdX8JE4BTITfuIAMl+TphWMu54Ex7eOkZ3fEzIGMT2eSTekKEk/zy500XWKwpeuRfBqM27MW+t
	1GBN8NypuyjqTycXKM6dViGg==
X-Received: by 2002:a17:90b:2b50:b0:30e:6a9d:d78b with SMTP id 98e67ed59e1d1-31c4d4d0740mr1758427a91.12.1752198262162;
        Thu, 10 Jul 2025 18:44:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHL234yEKg6y0H6Ijdjo4ts3kRRF1EGyNEU+iyI8kqrhvv7V667xAFdlSjti5l3dkuKayZfNJBLadnJF0UJNi0=
X-Received: by 2002:a17:90b:2b50:b0:30e:6a9d:d78b with SMTP id
 98e67ed59e1d1-31c4d4d0740mr1758370a91.12.1752198261372; Thu, 10 Jul 2025
 18:44:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250708064819.35282-1-jasowang@redhat.com> <20250708064819.35282-2-jasowang@redhat.com>
 <CAJaqyWd4K7tHHg+GCCN9+q3HdhkRdQ0R4iW+RXTP_6=xrP53VA@mail.gmail.com>
In-Reply-To: <CAJaqyWd4K7tHHg+GCCN9+q3HdhkRdQ0R4iW+RXTP_6=xrP53VA@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 11 Jul 2025 09:44:10 +0800
X-Gm-Features: Ac12FXzCFXEOlFdgCE9DKyHNbB7BgzuEFmQmUph58wsDb-dgqx-v3RY_-YznhXs
Message-ID: <CACGkMEuL4YGa+d7yjopv1nchwdqU4BCP9_-8Ur1L4CKU+8R5Wg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] vhost: basic in order support
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: mst@redhat.com, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jonah.palmer@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2025 at 5:05=E2=80=AFPM Eugenio Perez Martin
<eperezma@redhat.com> wrote:
>
> On Tue, Jul 8, 2025 at 8:48=E2=80=AFAM Jason Wang <jasowang@redhat.com> w=
rote:
> >
> > This patch adds basic in order support for vhost. Two optimizations
> > are implemented in this patch:
> >
> > 1) Since driver uses descriptor in order, vhost can deduce the next
> >    avail ring head by counting the number of descriptors that has been
> >    used in next_avail_head. This eliminate the need to access the
> >    available ring in vhost.
> >
> > 2) vhost_add_used_and_singal_n() is extended to accept the number of
> >    batched buffers per used elem. While this increases the times of
> >    usersapce memory access but it helps to reduce the chance of
>
> s/usersapce/userspace/
>
> >    used ring access of both the driver and vhost.
> >
> > Vhost-net will be the first user for this.
> >
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/vhost/net.c   |   6 ++-
> >  drivers/vhost/vhost.c | 121 +++++++++++++++++++++++++++++++++++-------
> >  drivers/vhost/vhost.h |   8 ++-
> >  3 files changed, 111 insertions(+), 24 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index 7cbfc7d718b3..4f9c67f17b49 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -374,7 +374,8 @@ static void vhost_zerocopy_signal_used(struct vhost=
_net *net,
> >         while (j) {
> >                 add =3D min(UIO_MAXIOV - nvq->done_idx, j);
> >                 vhost_add_used_and_signal_n(vq->dev, vq,
> > -                                           &vq->heads[nvq->done_idx], =
add);
> > +                                           &vq->heads[nvq->done_idx],
> > +                                           NULL, add);
> >                 nvq->done_idx =3D (nvq->done_idx + add) % UIO_MAXIOV;
> >                 j -=3D add;
> >         }
> > @@ -457,7 +458,8 @@ static void vhost_net_signal_used(struct vhost_net_=
virtqueue *nvq)
> >         if (!nvq->done_idx)
> >                 return;
> >
> > -       vhost_add_used_and_signal_n(dev, vq, vq->heads, nvq->done_idx);
> > +       vhost_add_used_and_signal_n(dev, vq, vq->heads, NULL,
> > +                                   nvq->done_idx);
> >         nvq->done_idx =3D 0;
> >  }
> >
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 3a5ebb973dba..c7ed069fc49e 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -364,6 +364,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
> >         vq->avail =3D NULL;
> >         vq->used =3D NULL;
> >         vq->last_avail_idx =3D 0;
> > +       vq->next_avail_head =3D 0;
> >         vq->avail_idx =3D 0;
> >         vq->last_used_idx =3D 0;
> >         vq->signalled_used =3D 0;
> > @@ -455,6 +456,8 @@ static void vhost_vq_free_iovecs(struct vhost_virtq=
ueue *vq)
> >         vq->log =3D NULL;
> >         kfree(vq->heads);
> >         vq->heads =3D NULL;
> > +       kfree(vq->nheads);
> > +       vq->nheads =3D NULL;
> >  }
> >
> >  /* Helper to allocate iovec buffers for all vqs. */
> > @@ -472,7 +475,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev=
 *dev)
> >                                         GFP_KERNEL);
> >                 vq->heads =3D kmalloc_array(dev->iov_limit, sizeof(*vq-=
>heads),
> >                                           GFP_KERNEL);
> > -               if (!vq->indirect || !vq->log || !vq->heads)
> > +               vq->nheads =3D kmalloc_array(dev->iov_limit, sizeof(*vq=
->nheads),
> > +                                          GFP_KERNEL);
> > +               if (!vq->indirect || !vq->log || !vq->heads || !vq->nhe=
ads)
> >                         goto err_nomem;
> >         }
> >         return 0;
> > @@ -1990,14 +1995,15 @@ long vhost_vring_ioctl(struct vhost_dev *d, uns=
igned int ioctl, void __user *arg
> >                         break;
> >                 }
> >                 if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED)) {
> > -                       vq->last_avail_idx =3D s.num & 0xffff;
> > +                       vq->next_avail_head =3D vq->last_avail_idx =3D
> > +                                             s.num & 0xffff;
> >                         vq->last_used_idx =3D (s.num >> 16) & 0xffff;
> >                 } else {
> >                         if (s.num > 0xffff) {
> >                                 r =3D -EINVAL;
> >                                 break;
> >                         }
> > -                       vq->last_avail_idx =3D s.num;
> > +                       vq->next_avail_head =3D vq->last_avail_idx =3D =
s.num;
>
> Why not just reuse last_avail_idx instead of creating next_avail_head?
>
> At first glance it seemed to me that it was done this way to support
> rewinding, but in_order path will happily reuse next_avail_head
> without checking for last_avail_idx except for checking if the ring is
> empty. Am I missing something?

Because the driver can submit a batch of available buffers so
last_avail_idx is not necessarily equal to next_avail_head.

>
> >                 }
> >                 /* Forget the cached index value. */
> >                 vq->avail_idx =3D vq->last_avail_idx;
> > @@ -2590,11 +2596,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *v=
q,
> >                       unsigned int *out_num, unsigned int *in_num,
> >                       struct vhost_log *log, unsigned int *log_num)
> >  {
> > +       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> >         struct vring_desc desc;
> >         unsigned int i, head, found =3D 0;
> >         u16 last_avail_idx =3D vq->last_avail_idx;
> >         __virtio16 ring_head;
> > -       int ret, access;
> > +       int ret, access, c =3D 0;
> >
> >         if (vq->avail_idx =3D=3D vq->last_avail_idx) {
> >                 ret =3D vhost_get_avail_idx(vq);
> > @@ -2605,17 +2612,21 @@ int vhost_get_vq_desc(struct vhost_virtqueue *v=
q,
> >                         return vq->num;
> >         }
> >
> > -       /* Grab the next descriptor number they're advertising, and inc=
rement
> > -        * the index we've seen. */
> > -       if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_id=
x))) {
> > -               vq_err(vq, "Failed to read head: idx %d address %p\n",
> > -                      last_avail_idx,
> > -                      &vq->avail->ring[last_avail_idx % vq->num]);
> > -               return -EFAULT;
> > +       if (in_order)
> > +               head =3D vq->next_avail_head & (vq->num - 1);
> > +       else {
> > +               /* Grab the next descriptor number they're
> > +                * advertising, and increment the index we've seen. */
> > +               if (unlikely(vhost_get_avail_head(vq, &ring_head,
> > +                                                 last_avail_idx))) {
> > +                       vq_err(vq, "Failed to read head: idx %d address=
 %p\n",
> > +                               last_avail_idx,
> > +                               &vq->avail->ring[last_avail_idx % vq->n=
um]);
> > +                       return -EFAULT;
> > +               }
> > +               head =3D vhost16_to_cpu(vq, ring_head);
> >         }
> >
> > -       head =3D vhost16_to_cpu(vq, ring_head);
> > -
> >         /* If their number is silly, that's an error. */
> >         if (unlikely(head >=3D vq->num)) {
> >                 vq_err(vq, "Guest says index %u > %u is available",
> > @@ -2658,6 +2669,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> >                                                 "in indirect descriptor=
 at idx %d\n", i);
> >                                 return ret;
> >                         }
> > +                       ++c;
> >                         continue;
> >                 }
> >
> > @@ -2693,10 +2705,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *v=
q,
> >                         }
> >                         *out_num +=3D ret;
> >                 }
> > +               ++c;
> >         } while ((i =3D next_desc(vq, &desc)) !=3D -1);
> >
> >         /* On success, increment avail index. */
> >         vq->last_avail_idx++;
> > +       vq->next_avail_head +=3D c;
> >
> >         /* Assume notifications from guest are disabled at this point,
> >          * if they aren't we would need to update avail_event index. */
> > @@ -2720,8 +2734,9 @@ int vhost_add_used(struct vhost_virtqueue *vq, un=
signed int head, int len)
> >                 cpu_to_vhost32(vq, head),
> >                 cpu_to_vhost32(vq, len)
> >         };
> > +       u16 nheads =3D 1;
> >
> > -       return vhost_add_used_n(vq, &heads, 1);
> > +       return vhost_add_used_n(vq, &heads, &nheads, 1);
> >  }
> >  EXPORT_SYMBOL_GPL(vhost_add_used);
> >
> > @@ -2757,10 +2772,10 @@ static int __vhost_add_used_n(struct vhost_virt=
queue *vq,
> >         return 0;
> >  }
> >
> > -/* After we've used one of their buffers, we tell them about it.  We'l=
l then
> > - * want to notify the guest, using eventfd. */
> > -int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_ele=
m *heads,
> > -                    unsigned count)
> > +static int vhost_add_used_n_ooo(struct vhost_virtqueue *vq,
> > +                               struct vring_used_elem *heads,
> > +                               u16 *nheads,
> > +                               unsigned count)
>
> nheads is not used in this function and it is checked to be NULL in
> the caller, should we remove it from the parameter list?

Exactly.

>
> >  {
> >         int start, n, r;
> >
> > @@ -2775,6 +2790,70 @@ int vhost_add_used_n(struct vhost_virtqueue *vq,=
 struct vring_used_elem *heads,
> >         }
> >         r =3D __vhost_add_used_n(vq, heads, count);
> >
> > +       return r;
>
> Nit: We can merge with the previous statement and do "return
> __vhost_add_used_n(vq, heads, count);"

Right.

>
> > +}
> > +
> > +static int vhost_add_used_n_in_order(struct vhost_virtqueue *vq,
> > +                                    struct vring_used_elem *heads,
> > +                                    u16 *nheads,
>
> Nit: we can const-ify nheads, and do the same for _in_order variant
> and vhost_add_used_n. Actually we can do it with heads too but it
> requires more changes to existing code. I think it would be nice to
> constify *nheads if you need to respin.

Let me do that.

>
> > +                                    unsigned count)
> > +{
> > +       vring_used_elem_t __user *used;
> > +       u16 old, new =3D vq->last_used_idx;
> > +       int start, i;
> > +
> > +       if (!nheads)
> > +               return -EINVAL;
> > +
> > +       start =3D vq->last_used_idx & (vq->num - 1);
> > +       used =3D vq->used->ring + start;
> > +
> > +       for (i =3D 0; i < count; i++) {
> > +               if (vhost_put_used(vq, &heads[i], start, 1)) {
> > +                       vq_err(vq, "Failed to write used");
> > +                       return -EFAULT;
> > +               }
> > +               start +=3D nheads[i];
> > +               new +=3D nheads[i];
> > +               if (start >=3D vq->num)
> > +                       start -=3D vq->num;
> > +       }
> > +
> > +       if (unlikely(vq->log_used)) {
> > +               /* Make sure data is seen before log. */
> > +               smp_wmb();
> > +               /* Log used ring entry write. */
> > +               log_used(vq, ((void __user *)used - (void __user *)vq->=
used),
> > +                        (vq->num - start) * sizeof *used);
> > +               if (start + count > vq->num)
> > +                       log_used(vq, 0,
> > +                                (start + count - vq->num) * sizeof *us=
ed);
> > +       }
> > +
> > +       old =3D vq->last_used_idx;
> > +       vq->last_used_idx =3D new;
> > +       /* If the driver never bothers to signal in a very long while,
> > +        * used index might wrap around. If that happens, invalidate
> > +        * signalled_used index we stored. TODO: make sure driver
> > +        * signals at least once in 2^16 and remove this. */
> > +       if (unlikely((u16)(new - vq->signalled_used) < (u16)(new - old)=
))
> > +               vq->signalled_used_valid =3D false;
> > +       return 0;
> > +}
> > +
> > +/* After we've used one of their buffers, we tell them about it.  We'l=
l then
> > + * want to notify the guest, using eventfd. */
> > +int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_ele=
m *heads,
> > +                    u16 *nheads, unsigned count)
> > +{
> > +       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > +       int r;
> > +
> > +       if (!in_order || !nheads)
> > +               r =3D vhost_add_used_n_ooo(vq, heads, nheads, count);
> > +       else
> > +               r =3D vhost_add_used_n_in_order(vq, heads, nheads, coun=
t);
> > +
>
> I just realized the original code didn't do it either, but we should
> return if r < 0 here. Otherwise, used->ring[] has a random value and
> used->idx is incremented covering these values. This should be
> triggable in a guest that set used->idx valid but used->ring[]
> invalid, for example.

This looks like a bug, I will send an independent fix.

>
> >         /* Make sure buffer is written before we update index. */
> >         smp_wmb();
> >         if (vhost_put_used_idx(vq)) {
> > @@ -2853,9 +2932,11 @@ EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
> >  /* multi-buffer version of vhost_add_used_and_signal */
> >  void vhost_add_used_and_signal_n(struct vhost_dev *dev,
> >                                  struct vhost_virtqueue *vq,
> > -                                struct vring_used_elem *heads, unsigne=
d count)
> > +                                struct vring_used_elem *heads,
> > +                                u16 *nheads,
> > +                                unsigned count)
> >  {
> > -       vhost_add_used_n(vq, heads, count);
> > +       vhost_add_used_n(vq, heads, nheads, count);
> >         vhost_signal(dev, vq);
> >  }
> >  EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index bb75a292d50c..dca9f309d396 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -103,6 +103,8 @@ struct vhost_virtqueue {
> >          * Values are limited to 0x7fff, and the high bit is used as
> >          * a wrap counter when using VIRTIO_F_RING_PACKED. */
> >         u16 last_avail_idx;
> > +       /* Next avail ring head when VIRTIO_F_IN_ORDER is neogitated */
>
> s/neogitated/negotiated/

Will fix it.

>
> > +       u16 next_avail_head;
> >
> >         /* Caches available index value from user. */
> >         u16 avail_idx;
> > @@ -129,6 +131,7 @@ struct vhost_virtqueue {
> >         struct iovec iotlb_iov[64];
> >         struct iovec *indirect;
> >         struct vring_used_elem *heads;
> > +       u16 *nheads;
> >         /* Protected by virtqueue mutex. */
> >         struct vhost_iotlb *umem;
> >         struct vhost_iotlb *iotlb;
> > @@ -213,11 +216,12 @@ bool vhost_vq_is_setup(struct vhost_virtqueue *vq=
);
> >  int vhost_vq_init_access(struct vhost_virtqueue *);
> >  int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int le=
n);
> >  int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem =
*heads,
> > -                    unsigned count);
> > +                    u16 *nheads, unsigned count);
> >  void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqu=
eue *,
> >                                unsigned int id, int len);
> >  void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virt=
queue *,
> > -                              struct vring_used_elem *heads, unsigned =
count);
> > +                                struct vring_used_elem *heads, u16 *nh=
eads,
> > +                                unsigned count);
> >  void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
> >  void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *=
);
> >  bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *=
);
> > --
> > 2.31.1
> >
>

Thanks



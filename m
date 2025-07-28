Return-Path: <kvm+bounces-53547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A7FCB13D1E
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E68BD3A9CB5
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 14:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7A626FD9D;
	Mon, 28 Jul 2025 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chqbFK3F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9CB26D4F9
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 14:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753712860; cv=none; b=ugZ06+HokBPm7kUop80H/qYpxXNG2qj01Lyfp1XYf4xQ2RMfFcbABjY8FQCEIPRoHKqlyQXyaOl5CNxXvhaztDQWeVJGZzraW5YBxkYRVIecRlddvUniAhpL9xy2hRJnQxH7lh69cbm3tKloxzDHYb0ldVxmtuaXhzcwXmp4CEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753712860; c=relaxed/simple;
	bh=FIz6tbF/4zKwYvK+Wffv/9PVUBHzSHp35+pYXD4XPIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hzouCy+Gu8CY7JJhRtC2mMTpwr0+zrSgwsWQsaRLN9lDHBrgrKzpU88WL7AoZz8xHUbsIoqZvIFvKaEFbUv1WAREgvvwBhM0LkItO2GEt2oXGO+svKgsVz8PZZ24ADE+xL/e8eAac3vFCh05RPpy8Z8cqm/qYEAjH0/gWIYXIoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chqbFK3F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753712857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pWJrD4sOtOT78I0bCqmI6Q0ItpmaIPlep/EDqa/nXBg=;
	b=chqbFK3FAh0688DOZDIOsZrSDrQT5Hy43L6hRW49zbzW+3g8OXspJvEBAnq2CLxNcDkz8g
	SM84iqp2QVJmJvN/j6AVteDy6MFXnJF2/8abuJhOQhBOk2S5jf36ioWphCjgzKg7gCB1Er
	S1spuzEOU+VRC19j1SYqTm/mRj6kT6U=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-IhIMkYSsPXy-l8RLXCitig-1; Mon, 28 Jul 2025 10:27:35 -0400
X-MC-Unique: IhIMkYSsPXy-l8RLXCitig-1
X-Mimecast-MFC-AGG-ID: IhIMkYSsPXy-l8RLXCitig_1753712855
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-313d346dc8dso7700455a91.1
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 07:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753712855; x=1754317655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pWJrD4sOtOT78I0bCqmI6Q0ItpmaIPlep/EDqa/nXBg=;
        b=KBQqje5b5HX/g/fnVXrCM5aRrd7wUZ8dSTqNWoUQoGQcjM1kMoEIC9aZSWi3A1IM9c
         Gu+3MiO/PuTAxXNDNgHKvdNCKZr+UGmRCqAaiPs6psoD6ccvCqSxx0Wa5eGNlRRBmYLX
         9SKm6d1Z0mYQgWIFa1l/7OuNXj8VM4uqN50/hhJuEfL/9pBB3REZETWfAhvrS1WDcHab
         K4lLGfv6JuKCzbJ7I7rUkVHToJM+HxDpQpKmv2AGSR9VgibMEGqIniPflS8uGisiQV/4
         bDhQX0fD6Tx5dNfVyQThmDBX28FZNFgMFeHp5qHApJjm+se+fdXxpG9QhgRYxo2bnzLJ
         DAXw==
X-Forwarded-Encrypted: i=1; AJvYcCXlVyuJiT/sXJNqlOlr/SInXN5Sl0cnzDtJS+ISEpOc4+Ft7pIxmiT9j6XopxntBIN4H70=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+rgV1veC7hTutTUpsjOVFW52aBNnc6acPJ36Qe6quROHVflH7
	ix5XPAxgupOLy/Ag28B71aRvvS6bme5H/0ITFZuQlmK8krnrxThC4ze1bnUiVjernMWQ+RnJZth
	raoF6RE4NBKq9uWVQBs8vj15vu/UhYTSaGrt3PtWyQ6Skn1L+F71hmZFyCTnoZBZTbmChLY+ygd
	eY3R9GJVQQ9ucETLnrog+2+g7JhKC5
X-Gm-Gg: ASbGnctaS7Co1VtCpX99WJFKRjpwyE9XQFgW+9wH+rC91LRuCJnC+K8XfBZo02k7EVN
	d2xv9+tzZsD/gPJCnDklbCas0j+cLVjEAahpj2gMYSBgcHA/voaZgue68jKY11UhYZcnGBNo79T
	Fm9i6FKVZP4ZHxaaqB/IYk
X-Received: by 2002:a17:90b:4f46:b0:31f:3c3:947c with SMTP id 98e67ed59e1d1-31f03c395camr3237817a91.10.1753712854596;
        Mon, 28 Jul 2025 07:27:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEq0NOPfenE+AwlEIxYIR7tX4RNIhhvrLhaR0YjnMFL5P+k6b8VHjPuy4E6vWNbGei3GliqSTc0RpqEkI/k0fw=
X-Received: by 2002:a17:90b:4f46:b0:31f:3c3:947c with SMTP id
 98e67ed59e1d1-31f03c395camr3237763a91.10.1753712853953; Mon, 28 Jul 2025
 07:27:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250714084755.11921-1-jasowang@redhat.com> <20250714084755.11921-3-jasowang@redhat.com>
In-Reply-To: <20250714084755.11921-3-jasowang@redhat.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 28 Jul 2025 16:26:56 +0200
X-Gm-Features: Ac12FXx3yPOz5-IObuxoTbOiDP301Ft2YtXt7fINo6iR8-0FWHKBtt29lQ7Bmmc
Message-ID: <CAJaqyWfJQEdXg=5Nj=fBj_nRj4RogeeO8LAp3dAkSAyXhMN0Kw@mail.gmail.com>
Subject: Re: [PATCH net-next V2 2/3] vhost: basic in order support
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jonah.palmer@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2025 at 10:48=E2=80=AFAM Jason Wang <jasowang@redhat.com> w=
rote:
>
> This patch adds basic in order support for vhost. Two optimizations
> are implemented in this patch:
>
> 1) Since driver uses descriptor in order, vhost can deduce the next
>    avail ring head by counting the number of descriptors that has been
>    used in next_avail_head. This eliminate the need to access the
>    available ring in vhost.
>
> 2) vhost_add_used_and_singal_n() is extended to accept the number of
>    batched buffers per used elem. While this increases the times of
>    userspace memory access but it helps to reduce the chance of
>    used ring access of both the driver and vhost.
>
> Vhost-net will be the first user for this.
>
> Acked-by: Jonah Palmer <jonah.palmer@oracle.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/net.c   |   6 ++-
>  drivers/vhost/vhost.c | 120 ++++++++++++++++++++++++++++++++++--------
>  drivers/vhost/vhost.h |   8 ++-
>  3 files changed, 109 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 9dbd88eb9ff4..2199ba3b191e 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -374,7 +374,8 @@ static void vhost_zerocopy_signal_used(struct vhost_n=
et *net,
>         while (j) {
>                 add =3D min(UIO_MAXIOV - nvq->done_idx, j);
>                 vhost_add_used_and_signal_n(vq->dev, vq,
> -                                           &vq->heads[nvq->done_idx], ad=
d);
> +                                           &vq->heads[nvq->done_idx],
> +                                           NULL, add);
>                 nvq->done_idx =3D (nvq->done_idx + add) % UIO_MAXIOV;
>                 j -=3D add;
>         }
> @@ -457,7 +458,8 @@ static void vhost_net_signal_used(struct vhost_net_vi=
rtqueue *nvq)
>         if (!nvq->done_idx)
>                 return;
>
> -       vhost_add_used_and_signal_n(dev, vq, vq->heads, nvq->done_idx);
> +       vhost_add_used_and_signal_n(dev, vq, vq->heads, NULL,
> +                                   nvq->done_idx);
>         nvq->done_idx =3D 0;
>  }
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index d1d3912f4804..dd7963eb6cf0 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -364,6 +364,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>         vq->avail =3D NULL;
>         vq->used =3D NULL;
>         vq->last_avail_idx =3D 0;
> +       vq->next_avail_head =3D 0;
>         vq->avail_idx =3D 0;
>         vq->last_used_idx =3D 0;
>         vq->signalled_used =3D 0;
> @@ -455,6 +456,8 @@ static void vhost_vq_free_iovecs(struct vhost_virtque=
ue *vq)
>         vq->log =3D NULL;
>         kfree(vq->heads);
>         vq->heads =3D NULL;
> +       kfree(vq->nheads);
> +       vq->nheads =3D NULL;
>  }
>
>  /* Helper to allocate iovec buffers for all vqs. */
> @@ -472,7 +475,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *=
dev)
>                                         GFP_KERNEL);
>                 vq->heads =3D kmalloc_array(dev->iov_limit, sizeof(*vq->h=
eads),
>                                           GFP_KERNEL);
> -               if (!vq->indirect || !vq->log || !vq->heads)
> +               vq->nheads =3D kmalloc_array(dev->iov_limit, sizeof(*vq->=
nheads),
> +                                          GFP_KERNEL);
> +               if (!vq->indirect || !vq->log || !vq->heads || !vq->nhead=
s)
>                         goto err_nomem;
>         }
>         return 0;
> @@ -1990,14 +1995,15 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsig=
ned int ioctl, void __user *arg
>                         break;
>                 }
>                 if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED)) {
> -                       vq->last_avail_idx =3D s.num & 0xffff;
> +                       vq->next_avail_head =3D vq->last_avail_idx =3D
> +                                             s.num & 0xffff;
>                         vq->last_used_idx =3D (s.num >> 16) & 0xffff;
>                 } else {
>                         if (s.num > 0xffff) {
>                                 r =3D -EINVAL;
>                                 break;
>                         }
> -                       vq->last_avail_idx =3D s.num;
> +                       vq->next_avail_head =3D vq->last_avail_idx =3D s.=
num;
>                 }
>                 /* Forget the cached index value. */
>                 vq->avail_idx =3D vq->last_avail_idx;
> @@ -2590,11 +2596,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>                       unsigned int *out_num, unsigned int *in_num,
>                       struct vhost_log *log, unsigned int *log_num)
>  {
> +       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
>         struct vring_desc desc;
>         unsigned int i, head, found =3D 0;
>         u16 last_avail_idx =3D vq->last_avail_idx;
>         __virtio16 ring_head;
> -       int ret, access;
> +       int ret, access, c =3D 0;
>
>         if (vq->avail_idx =3D=3D vq->last_avail_idx) {
>                 ret =3D vhost_get_avail_idx(vq);
> @@ -2605,17 +2612,21 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>                         return vq->num;
>         }
>
> -       /* Grab the next descriptor number they're advertising, and incre=
ment
> -        * the index we've seen. */
> -       if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx)=
)) {
> -               vq_err(vq, "Failed to read head: idx %d address %p\n",
> -                      last_avail_idx,
> -                      &vq->avail->ring[last_avail_idx % vq->num]);
> -               return -EFAULT;
> +       if (in_order)
> +               head =3D vq->next_avail_head & (vq->num - 1);
> +       else {
> +               /* Grab the next descriptor number they're
> +                * advertising, and increment the index we've seen. */
> +               if (unlikely(vhost_get_avail_head(vq, &ring_head,
> +                                                 last_avail_idx))) {
> +                       vq_err(vq, "Failed to read head: idx %d address %=
p\n",
> +                               last_avail_idx,
> +                               &vq->avail->ring[last_avail_idx % vq->num=
]);
> +                       return -EFAULT;
> +               }
> +               head =3D vhost16_to_cpu(vq, ring_head);
>         }
>
> -       head =3D vhost16_to_cpu(vq, ring_head);
> -
>         /* If their number is silly, that's an error. */
>         if (unlikely(head >=3D vq->num)) {
>                 vq_err(vq, "Guest says index %u > %u is available",
> @@ -2658,6 +2669,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>                                                 "in indirect descriptor a=
t idx %d\n", i);
>                                 return ret;
>                         }
> +                       ++c;
>                         continue;
>                 }
>
> @@ -2693,10 +2705,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>                         }
>                         *out_num +=3D ret;
>                 }
> +               ++c;
>         } while ((i =3D next_desc(vq, &desc)) !=3D -1);
>
>         /* On success, increment avail index. */
>         vq->last_avail_idx++;
> +       vq->next_avail_head +=3D c;
>
>         /* Assume notifications from guest are disabled at this point,
>          * if they aren't we would need to update avail_event index. */
> @@ -2720,8 +2734,9 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsi=
gned int head, int len)
>                 cpu_to_vhost32(vq, head),
>                 cpu_to_vhost32(vq, len)
>         };
> +       u16 nheads =3D 1;
>
> -       return vhost_add_used_n(vq, &heads, 1);
> +       return vhost_add_used_n(vq, &heads, &nheads, 1);
>  }
>  EXPORT_SYMBOL_GPL(vhost_add_used);
>
> @@ -2757,10 +2772,9 @@ static int __vhost_add_used_n(struct vhost_virtque=
ue *vq,
>         return 0;
>  }
>
> -/* After we've used one of their buffers, we tell them about it.  We'll =
then
> - * want to notify the guest, using eventfd. */
> -int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem =
*heads,
> -                    unsigned count)
> +static int vhost_add_used_n_ooo(struct vhost_virtqueue *vq,
> +                               struct vring_used_elem *heads,
> +                               unsigned count)
>  {
>         int start, n, r;
>
> @@ -2773,7 +2787,69 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, s=
truct vring_used_elem *heads,
>                 heads +=3D n;
>                 count -=3D n;
>         }
> -       r =3D __vhost_add_used_n(vq, heads, count);
> +       return __vhost_add_used_n(vq, heads, count);
> +}
> +
> +static int vhost_add_used_n_in_order(struct vhost_virtqueue *vq,
> +                                    struct vring_used_elem *heads,
> +                                    const u16 *nheads,
> +                                    unsigned count)
> +{
> +       vring_used_elem_t __user *used;
> +       u16 old, new =3D vq->last_used_idx;
> +       int start, i;
> +
> +       if (!nheads)
> +               return -EINVAL;
> +
> +       start =3D vq->last_used_idx & (vq->num - 1);
> +       used =3D vq->used->ring + start;
> +
> +       for (i =3D 0; i < count; i++) {
> +               if (vhost_put_used(vq, &heads[i], start, 1)) {
> +                       vq_err(vq, "Failed to write used");
> +                       return -EFAULT;
> +               }
> +               start +=3D nheads[i];
> +               new +=3D nheads[i];
> +               if (start >=3D vq->num)
> +                       start -=3D vq->num;
> +       }
> +
> +       if (unlikely(vq->log_used)) {
> +               /* Make sure data is seen before log. */
> +               smp_wmb();
> +               /* Log used ring entry write. */
> +               log_used(vq, ((void __user *)used - (void __user *)vq->us=
ed),
> +                        (vq->num - start) * sizeof *used);
> +               if (start + count > vq->num)
> +                       log_used(vq, 0,
> +                                (start + count - vq->num) * sizeof *used=
);
> +       }
> +
> +       old =3D vq->last_used_idx;
> +       vq->last_used_idx =3D new;
> +       /* If the driver never bothers to signal in a very long while,
> +        * used index might wrap around. If that happens, invalidate
> +        * signalled_used index we stored. TODO: make sure driver
> +        * signals at least once in 2^16 and remove this. */
> +       if (unlikely((u16)(new - vq->signalled_used) < (u16)(new - old)))
> +               vq->signalled_used_valid =3D false;
> +       return 0;
> +}
> +
> +/* After we've used one of their buffers, we tell them about it.  We'll =
then
> + * want to notify the guest, using eventfd. */
> +int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem =
*heads,
> +                    u16 *nheads, unsigned count)
> +{
> +       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> +       int r;
> +
> +       if (!in_order || !nheads)
> +               r =3D vhost_add_used_n_ooo(vq, heads, count);
> +       else
> +               r =3D vhost_add_used_n_in_order(vq, heads, nheads, count)=
;
>
>         if (r < 0)
>                 return r;
> @@ -2856,9 +2932,11 @@ EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
>  /* multi-buffer version of vhost_add_used_and_signal */
>  void vhost_add_used_and_signal_n(struct vhost_dev *dev,
>                                  struct vhost_virtqueue *vq,
> -                                struct vring_used_elem *heads, unsigned =
count)
> +                                struct vring_used_elem *heads,
> +                                u16 *nheads,
> +                                unsigned count)
>  {
> -       vhost_add_used_n(vq, heads, count);
> +       vhost_add_used_n(vq, heads, nheads, count);
>         vhost_signal(dev, vq);
>  }
>  EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index bb75a292d50c..e714ebf9da57 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -103,6 +103,8 @@ struct vhost_virtqueue {
>          * Values are limited to 0x7fff, and the high bit is used as
>          * a wrap counter when using VIRTIO_F_RING_PACKED. */
>         u16 last_avail_idx;
> +       /* Next avail ring head when VIRTIO_F_IN_ORDER is negoitated */
> +       u16 next_avail_head;
>
>         /* Caches available index value from user. */
>         u16 avail_idx;
> @@ -129,6 +131,7 @@ struct vhost_virtqueue {
>         struct iovec iotlb_iov[64];
>         struct iovec *indirect;
>         struct vring_used_elem *heads;
> +       u16 *nheads;
>         /* Protected by virtqueue mutex. */
>         struct vhost_iotlb *umem;
>         struct vhost_iotlb *iotlb;
> @@ -213,11 +216,12 @@ bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
>  int vhost_vq_init_access(struct vhost_virtqueue *);
>  int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len)=
;
>  int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *h=
eads,
> -                    unsigned count);
> +                    u16 *nheads, unsigned count);
>  void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueu=
e *,
>                                unsigned int id, int len);
>  void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqu=
eue *,
> -                              struct vring_used_elem *heads, unsigned co=
unt);
> +                                struct vring_used_elem *heads, u16 *nhea=
ds,
> +                                unsigned count);
>  void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
>  void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
>  bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *);
> --
> 2.39.5
>



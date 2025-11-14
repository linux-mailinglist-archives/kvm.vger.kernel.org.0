Return-Path: <kvm+bounces-63174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 53709C5AF4B
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 02:53:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0099A353380
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB0526B777;
	Fri, 14 Nov 2025 01:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="itiGtl/t";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ok1lFe9w"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2AE256C71
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 01:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763085213; cv=none; b=JJ2xspbDCH/WmiC1ery4HBxJwS+c7tF9inWA1uKWoDgLBjIODZBZwg3OBwPh/n1jwiwVccLQyzhHklEtjkOdUs7dmeamYAJ/DCVKatRxBHvo3TRNDhiwDBBOucEsWgCUAmVahdR0ky15ApWgI3Mh9tE+doYiCFgZCP0ZJbyxl3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763085213; c=relaxed/simple;
	bh=Awws8R4kLxno71Ww/C1b/8XEQs9G2TQlSJABmhgARIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZiRtxBTGeygw8OWnN4iN6M/zn+dPtnhcdUQqFEZ4wUmptguGfWWa5T0SkSiOzsaPXPwdxB3hUQ9YnCf8UFFBhiitvsmDuSuvwSAj5QWx7SSpGn3/l5MjqjXpf836BNWi8wMRvyKJVxz88gAEAihgiMEbgyGqANrthXzebOvc7js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=itiGtl/t; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ok1lFe9w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763085209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/GM6TuE+pbLu/BRydyFwXgd8kT0R50hEwZmdNFk2QQ=;
	b=itiGtl/twXENbJfRTMRs65+4jpQN9h7updfRrIsEJifPVZTYpn5+KfADe/5G9PGQidNqJx
	9ePECcYhBvwppud9FJCv58uOtwNWUruvnqFE4pOWFG8sh7fGIWOAQ+AJptbUB/Co79CzFR
	BpAomoor5K5RunBvAMKvFDOHb9+7gDk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-pI2iQn7XNpmyowBsj_-knw-1; Thu, 13 Nov 2025 20:53:26 -0500
X-MC-Unique: pI2iQn7XNpmyowBsj_-knw-1
X-Mimecast-MFC-AGG-ID: pI2iQn7XNpmyowBsj_-knw_1763085205
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3437863d0easo1538022a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 17:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763085205; x=1763690005; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/GM6TuE+pbLu/BRydyFwXgd8kT0R50hEwZmdNFk2QQ=;
        b=ok1lFe9wuuUczwB+35xR+GCHDHeij5d2OAJ2cdpZ/qMqZCoe4+suvH/6vEbD0fYIZk
         iGtI1OGccwkFJPnhXFnDRP4KRZK0F+i/3JI5f7WJe2Fi8FnCkm26cC1DvMm4Rh8cpBQQ
         BsQ8oqf+TBlXWTh7RGeFXoD/zttBeyphYK2GquifOtOCVYLRRCKMyWVI6IKHtcUig/hD
         Hgga1AcH+ZsEdzbfA6Yg2rqD1LIPJPg1UoFfJgV+z++GoElsIW5ns6qnOE9xmLgjigQG
         dlXetAhsH1amBZl7VRi+wC1nzlQgoiM/9YXYcBKRcRQqL+XbYTlVqVWwTl8gJNPTHNjm
         1HqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763085205; x=1763690005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y/GM6TuE+pbLu/BRydyFwXgd8kT0R50hEwZmdNFk2QQ=;
        b=bMNyR0GbWvILbhjLFA/timHkzcJxvCtaHQIpcPFCiMbdMrQS9pgFOHwXVMnFMwdJdB
         fae2w+cYWohccqTg7KafFKEZL6tzlNnMTdtH7cyGSv4koDxUg2UQ6tGZ2QVDU3epslLE
         37g7hsA4o2acuudCMr2bTgUOXcfMJ0aLmlSHl4x4caiF6t8jjX/RB5EtRPHciqbPcGmH
         UYUvmsleVc5/mVjz8RsZNiBs+N7dilrIFnAoNxPqdYRFkEd/BrtrcE2OdVgkH71GM49t
         XVjRGWMLOLg6aA2vkENtWJvrMILNSpMeapKpjXNZFmFfRN7Y6hJGqPebZ2L0kQpqFWbL
         n0gw==
X-Gm-Message-State: AOJu0YwSk0CqqddCiEvPsRVKZBHvNxq43TJnmIWHIMK6jpmgXy/Dwr85
	Oa6LijnnBFUx4A/6TrQROKpg44gEakZDKyg5wjrmB+84RBiVcO/EWFro/HF3mcYH/ymUeUmmm1K
	gsU8VEN/Hz9h55nee7+Jjhpvn8bPNeNTd/4fMllBCN1R1i2WNc152KGHB/BoRwKXMmr4Ne2Di4L
	ms6Nf9E2exrOkIHEvu/10WVDsFB6R4
X-Gm-Gg: ASbGncthK7ddgEiF4bqs1/cxWCjULbUhI7BEdAbbdLXYTmy9tIIDypNpzLoDyHYXPqH
	4L+AfiSkiDyZHHgfdQO2PHBY7PU2b1X80C3s6wZFaiWjO77xuU6eun+wv8re8Kv8UoZRYWoRYJc
	B6rErealw3/81fghxFQNHhnC4X7Buj9CfZfc2Pc4L+/dtsfZwbWkZsZY5dl0U+xQ+r
X-Received: by 2002:a17:90a:da8d:b0:341:a9e7:e5f9 with SMTP id 98e67ed59e1d1-343f99c41admr1419513a91.0.1763085205134;
        Thu, 13 Nov 2025 17:53:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH69c7+xYy6+cmViuzdzdNFE72opG0TdAVIwjcq26cdeNfygUXcIwROXoC/EFJNVeOke0YzaY3sAJxU1a9cl4s=
X-Received: by 2002:a17:90a:da8d:b0:341:a9e7:e5f9 with SMTP id
 98e67ed59e1d1-343f99c41admr1419487a91.0.1763085204603; Thu, 13 Nov 2025
 17:53:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113015420.3496-1-jasowang@redhat.com> <20251113030230-mutt-send-email-mst@kernel.org>
In-Reply-To: <20251113030230-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 14 Nov 2025 09:53:12 +0800
X-Gm-Features: AWmQ_blN5fCa4J683fyiTZDH36Ozek1kVWjWXP-B3dv1rReeqdnmD9i12BE5U-M
Message-ID: <CACGkMEtnihOt=g+zs0gVQ=wnx8_YF_F=QSuLQ4RGWBVuOeFi7w@mail.gmail.com>
Subject: Re: [PATCH net] vhost: rewind next_avail_head while discarding descriptors
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 4:13=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Thu, Nov 13, 2025 at 09:54:20AM +0800, Jason Wang wrote:
> > When discarding descriptors with IN_ORDER, we should rewind
> > next_avail_head otherwise it would run out of sync with
> > last_avail_idx. This would cause driver to report
> > "id X is not a head".
> >
> > Fixing this by returning the number of descriptors that is used for
> > each buffer via vhost_get_vq_desc_n() so caller can use the value
> > while discarding descriptors.
> >
> > Fixes: 67a873df0c41 ("vhost: basic in order support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
>
> Wow that change really caused a lot of fallout.
>
> Thanks for the patch! Yet something to improve:
>
>
> > ---
> >  drivers/vhost/net.c   | 53 ++++++++++++++++++++++++++-----------------
> >  drivers/vhost/vhost.c | 43 ++++++++++++++++++++++++-----------
> >  drivers/vhost/vhost.h |  9 +++++++-
> >  3 files changed, 70 insertions(+), 35 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index 35ded4330431..8f7f50acb6d6 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -592,14 +592,15 @@ static void vhost_net_busy_poll(struct vhost_net =
*net,
> >  static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
> >                                   struct vhost_net_virtqueue *tnvq,
> >                                   unsigned int *out_num, unsigned int *=
in_num,
> > -                                 struct msghdr *msghdr, bool *busyloop=
_intr)
> > +                                 struct msghdr *msghdr, bool *busyloop=
_intr,
> > +                                 unsigned int *ndesc)
> >  {
> >       struct vhost_net_virtqueue *rnvq =3D &net->vqs[VHOST_NET_VQ_RX];
> >       struct vhost_virtqueue *rvq =3D &rnvq->vq;
> >       struct vhost_virtqueue *tvq =3D &tnvq->vq;
> >
> > -     int r =3D vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
> > -                               out_num, in_num, NULL, NULL);
> > +     int r =3D vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(tvq->iov)=
,
> > +                                 out_num, in_num, NULL, NULL, ndesc);
> >
> >       if (r =3D=3D tvq->num && tvq->busyloop_timeout) {
> >               /* Flush batched packets first */
> > @@ -610,8 +611,8 @@ static int vhost_net_tx_get_vq_desc(struct vhost_ne=
t *net,
> >
> >               vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, false);
> >
> > -             r =3D vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->io=
v),
> > -                                   out_num, in_num, NULL, NULL);
> > +             r =3D vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(tvq->=
iov),
> > +                                     out_num, in_num, NULL, NULL, ndes=
c);
> >       }
> >
> >       return r;
> > @@ -642,12 +643,14 @@ static int get_tx_bufs(struct vhost_net *net,
> >                      struct vhost_net_virtqueue *nvq,
> >                      struct msghdr *msg,
> >                      unsigned int *out, unsigned int *in,
> > -                    size_t *len, bool *busyloop_intr)
> > +                    size_t *len, bool *busyloop_intr,
> > +                    unsigned int *ndesc)
> >  {
> >       struct vhost_virtqueue *vq =3D &nvq->vq;
> >       int ret;
> >
> > -     ret =3D vhost_net_tx_get_vq_desc(net, nvq, out, in, msg, busyloop=
_intr);
> > +     ret =3D vhost_net_tx_get_vq_desc(net, nvq, out, in, msg,
> > +                                    busyloop_intr, ndesc);
> >
> >       if (ret < 0 || ret =3D=3D vq->num)
> >               return ret;
> > @@ -766,6 +769,7 @@ static void handle_tx_copy(struct vhost_net *net, s=
truct socket *sock)
> >       int sent_pkts =3D 0;
> >       bool sock_can_batch =3D (sock->sk->sk_sndbuf =3D=3D INT_MAX);
> >       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > +     unsigned int ndesc =3D 0;
> >
> >       do {
> >               bool busyloop_intr =3D false;
> > @@ -774,7 +778,7 @@ static void handle_tx_copy(struct vhost_net *net, s=
truct socket *sock)
> >                       vhost_tx_batch(net, nvq, sock, &msg);
> >
> >               head =3D get_tx_bufs(net, nvq, &msg, &out, &in, &len,
> > -                                &busyloop_intr);
> > +                                &busyloop_intr, &ndesc);
> >               /* On error, stop handling until the next kick. */
> >               if (unlikely(head < 0))
> >                       break;
> > @@ -806,7 +810,7 @@ static void handle_tx_copy(struct vhost_net *net, s=
truct socket *sock)
> >                               goto done;
> >                       } else if (unlikely(err !=3D -ENOSPC)) {
> >                               vhost_tx_batch(net, nvq, sock, &msg);
> > -                             vhost_discard_vq_desc(vq, 1);
> > +                             vhost_discard_vq_desc(vq, 1, ndesc);
> >                               vhost_net_enable_vq(net, vq);
> >                               break;
> >                       }
> > @@ -829,7 +833,7 @@ static void handle_tx_copy(struct vhost_net *net, s=
truct socket *sock)
> >               err =3D sock->ops->sendmsg(sock, &msg, len);
> >               if (unlikely(err < 0)) {
> >                       if (err =3D=3D -EAGAIN || err =3D=3D -ENOMEM || e=
rr =3D=3D -ENOBUFS) {
> > -                             vhost_discard_vq_desc(vq, 1);
> > +                             vhost_discard_vq_desc(vq, 1, ndesc);
> >                               vhost_net_enable_vq(net, vq);
> >                               break;
> >                       }
> > @@ -868,6 +872,7 @@ static void handle_tx_zerocopy(struct vhost_net *ne=
t, struct socket *sock)
> >       int err;
> >       struct vhost_net_ubuf_ref *ubufs;
> >       struct ubuf_info_msgzc *ubuf;
> > +     unsigned int ndesc =3D 0;
> >       bool zcopy_used;
> >       int sent_pkts =3D 0;
> >
> > @@ -879,7 +884,7 @@ static void handle_tx_zerocopy(struct vhost_net *ne=
t, struct socket *sock)
> >
> >               busyloop_intr =3D false;
> >               head =3D get_tx_bufs(net, nvq, &msg, &out, &in, &len,
> > -                                &busyloop_intr);
> > +                                &busyloop_intr, &ndesc);
> >               /* On error, stop handling until the next kick. */
> >               if (unlikely(head < 0))
> >                       break;
> > @@ -941,7 +946,7 @@ static void handle_tx_zerocopy(struct vhost_net *ne=
t, struct socket *sock)
> >                                       vq->heads[ubuf->desc].len =3D VHO=
ST_DMA_DONE_LEN;
> >                       }
> >                       if (retry) {
> > -                             vhost_discard_vq_desc(vq, 1);
> > +                             vhost_discard_vq_desc(vq, 1, ndesc);
> >                               vhost_net_enable_vq(net, vq);
> >                               break;
> >                       }
> > @@ -1045,11 +1050,12 @@ static int get_rx_bufs(struct vhost_net_virtque=
ue *nvq,
> >                      unsigned *iovcount,
> >                      struct vhost_log *log,
> >                      unsigned *log_num,
> > -                    unsigned int quota)
> > +                    unsigned int quota,
> > +                    unsigned int *ndesc)
> >  {
> >       struct vhost_virtqueue *vq =3D &nvq->vq;
> >       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > -     unsigned int out, in;
> > +     unsigned int out, in, desc_num, n =3D 0;
> >       int seg =3D 0;
> >       int headcount =3D 0;
> >       unsigned d;
> > @@ -1064,9 +1070,9 @@ static int get_rx_bufs(struct vhost_net_virtqueue=
 *nvq,
> >                       r =3D -ENOBUFS;
> >                       goto err;
> >               }
> > -             r =3D vhost_get_vq_desc(vq, vq->iov + seg,
> > -                                   ARRAY_SIZE(vq->iov) - seg, &out,
> > -                                   &in, log, log_num);
> > +             r =3D vhost_get_vq_desc_n(vq, vq->iov + seg,
> > +                                     ARRAY_SIZE(vq->iov) - seg, &out,
> > +                                     &in, log, log_num, &desc_num);
> >               if (unlikely(r < 0))
> >                       goto err;
> >
> > @@ -1093,6 +1099,7 @@ static int get_rx_bufs(struct vhost_net_virtqueue=
 *nvq,
> >               ++headcount;
> >               datalen -=3D len;
> >               seg +=3D in;
> > +             n +=3D desc_num;
> >       }
> >
> >       *iovcount =3D seg;
> > @@ -1113,9 +1120,11 @@ static int get_rx_bufs(struct vhost_net_virtqueu=
e *nvq,
> >               nheads[0] =3D headcount;
> >       }
> >
> > +     *ndesc =3D n;
> > +
> >       return headcount;
> >  err:
> > -     vhost_discard_vq_desc(vq, headcount);
> > +     vhost_discard_vq_desc(vq, headcount, n);
>
> So here ndesc and n are the same, but below in vhost_discard_vq_desc
> they are different. Fun.

Not necessarily the same, a buffer could contain more than 1 descriptor.

>
> >       return r;
> >  }
> >
> > @@ -1151,6 +1160,7 @@ static void handle_rx(struct vhost_net *net)
> >       struct iov_iter fixup;
> >       __virtio16 num_buffers;
> >       int recv_pkts =3D 0;
> > +     unsigned int ndesc;
> >
> >       mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_RX);
> >       sock =3D vhost_vq_get_backend(vq);
> > @@ -1182,7 +1192,8 @@ static void handle_rx(struct vhost_net *net)
> >               headcount =3D get_rx_bufs(nvq, vq->heads + count,
> >                                       vq->nheads + count,
> >                                       vhost_len, &in, vq_log, &log,
> > -                                     likely(mergeable) ? UIO_MAXIOV : =
1);
> > +                                     likely(mergeable) ? UIO_MAXIOV : =
1,
> > +                                     &ndesc);
> >               /* On error, stop handling until the next kick. */
> >               if (unlikely(headcount < 0))
> >                       goto out;
> > @@ -1228,7 +1239,7 @@ static void handle_rx(struct vhost_net *net)
> >               if (unlikely(err !=3D sock_len)) {
> >                       pr_debug("Discarded rx packet: "
> >                                " len %d, expected %zd\n", err, sock_len=
);
> > -                     vhost_discard_vq_desc(vq, headcount);
> > +                     vhost_discard_vq_desc(vq, headcount, ndesc);
> >                       continue;
> >               }
> >               /* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR */
> > @@ -1252,7 +1263,7 @@ static void handle_rx(struct vhost_net *net)
> >                   copy_to_iter(&num_buffers, sizeof num_buffers,
> >                                &fixup) !=3D sizeof num_buffers) {
> >                       vq_err(vq, "Failed num_buffers write");
> > -                     vhost_discard_vq_desc(vq, headcount);
> > +                     vhost_discard_vq_desc(vq, headcount, ndesc);
> >                       goto out;
> >               }
> >               nvq->done_idx +=3D headcount;
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 8570fdf2e14a..b56568807588 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -2792,18 +2792,11 @@ static int get_indirect(struct vhost_virtqueue =
*vq,
> >       return 0;
> >  }
> >
> > -/* This looks in the virtqueue and for the first available buffer, and=
 converts
> > - * it to an iovec for convenient access.  Since descriptors consist of=
 some
> > - * number of output then some number of input descriptors, it's actual=
ly two
> > - * iovecs, but we pack them into one and note how many of each there w=
ere.
> > - *
> > - * This function returns the descriptor number found, or vq->num (whic=
h is
> > - * never a valid descriptor number) if none was found.  A negative cod=
e is
> > - * returned on error. */
>
> A new module API with no docs at all is not good.
> Please add documentation to this one. vhost_get_vq_desc
> is a subset and could refer to it.

Fixed.

>
> > -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> > -                   struct iovec iov[], unsigned int iov_size,
> > -                   unsigned int *out_num, unsigned int *in_num,
> > -                   struct vhost_log *log, unsigned int *log_num)
> > +int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
> > +                     struct iovec iov[], unsigned int iov_size,
> > +                     unsigned int *out_num, unsigned int *in_num,
> > +                     struct vhost_log *log, unsigned int *log_num,
> > +                     unsigned int *ndesc)
>
> >  {
> >       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> >       struct vring_desc desc;
> > @@ -2921,16 +2914,40 @@ int vhost_get_vq_desc(struct vhost_virtqueue *v=
q,
> >       vq->last_avail_idx++;
> >       vq->next_avail_head +=3D c;
> >
> > +     if (ndesc)
> > +             *ndesc =3D c;
> > +
> >       /* Assume notifications from guest are disabled at this point,
> >        * if they aren't we would need to update avail_event index. */
> >       BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
> >       return head;
> >  }
> > +EXPORT_SYMBOL_GPL(vhost_get_vq_desc_n);
> > +
> > +/* This looks in the virtqueue and for the first available buffer, and=
 converts
> > + * it to an iovec for convenient access.  Since descriptors consist of=
 some
> > + * number of output then some number of input descriptors, it's actual=
ly two
> > + * iovecs, but we pack them into one and note how many of each there w=
ere.
> > + *
> > + * This function returns the descriptor number found, or vq->num (whic=
h is
> > + * never a valid descriptor number) if none was found.  A negative cod=
e is
> > + * returned on error.
> > + */
> > +int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> > +                   struct iovec iov[], unsigned int iov_size,
> > +                   unsigned int *out_num, unsigned int *in_num,
> > +                   struct vhost_log *log, unsigned int *log_num)
> > +{
> > +     return vhost_get_vq_desc_n(vq, iov, iov_size, out_num, in_num,
> > +                                log, log_num, NULL);
> > +}
> >  EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
> >
> >  /* Reverse the effect of vhost_get_vq_desc. Useful for error handling.=
 */
> > -void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
> > +void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n,
> > +                        unsigned int ndesc)
>
> ndesc is number of descriptors? And n is what, in that case?

The semantic of n is not changed which is the number of buffers, ndesc
is the number of descriptors.

>
>
> >  {
> > +     vq->next_avail_head -=3D ndesc;
> >       vq->last_avail_idx -=3D n;
> >  }
> >  EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index 621a6d9a8791..69a39540df3d 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -230,7 +230,14 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
> >                     struct iovec iov[], unsigned int iov_size,
> >                     unsigned int *out_num, unsigned int *in_num,
> >                     struct vhost_log *log, unsigned int *log_num);
> > -void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
> > +
> > +int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
> > +                     struct iovec iov[], unsigned int iov_size,
> > +                     unsigned int *out_num, unsigned int *in_num,
> > +                     struct vhost_log *log, unsigned int *log_num,
> > +                     unsigned int *ndesc);
> > +
> > +void vhost_discard_vq_desc(struct vhost_virtqueue *, int n, unsigned i=
nt ndesc);
> >
> >  bool vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work=
 *work);
> >  bool vhost_vq_has_work(struct vhost_virtqueue *vq);
> > --
> > 2.31.1
>

Thanks



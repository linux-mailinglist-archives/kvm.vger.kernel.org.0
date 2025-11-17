Return-Path: <kvm+bounces-63328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E5B9C6250D
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 05:29:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 45F1634DCD4
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 04:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA22314D39;
	Mon, 17 Nov 2025 04:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VM2+9tvy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dUeGfwYf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABFA3115B1
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 04:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763353632; cv=none; b=l8IIvKialgwIZmq/AvfquKfsE76E9KVYb8MUZyfVg6rpnz9P3njiX3ZoIj6ET2SB1OEPBbKxt2TBRaSq4yxwoSkRpu77TJDgUyzLxhJbv5IK1f1lH//MqU1iy4YdZi4TsIqbLlRsQA8BVnNjCuP1A6S91xDdLiCwRcwdczBBQ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763353632; c=relaxed/simple;
	bh=JB3oes8rU4iWF1V98lypxHDPAnOmrLwFYkQGNNHHUcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BjS3w74LEgnX7ysuk6m5T9W2d1QUyQY3TPx0eMb3Thkjz8Ylygc2VPpf4GG8lEKIhuWxF+CLljWL1ZusbWSkN7fabJVoyKVBwD9Rmo3ZpDK4gkj9WLabIYDBfwcuv1b4wEFIrgGvplx1FBv8eblnewNE7P/3nV9S405TQoZNKYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VM2+9tvy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dUeGfwYf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763353629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fco7fLuAvrWXDCMzilyr/TSfazpGIOyASl9jp9XrHTM=;
	b=VM2+9tvyOc+z1fTaD1B9YaCGafplOTqm8FLLcTuiFpM5n+LfksY7JbzqcnALGMgUt9iwnI
	tO5TZvgkULAP9cQcp+Wf2M7iA7F2YVQPpsjnA+ywj6QVC2SMGi1k/wnhlAMER6ZZLbpVEr
	LuxdT2vMW8/Lw9Wt1CDgyLkZ561y6zQ=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-AYIAvwOEM-yu5GvcN-_utQ-1; Sun, 16 Nov 2025 23:27:07 -0500
X-MC-Unique: AYIAvwOEM-yu5GvcN-_utQ-1
X-Mimecast-MFC-AGG-ID: AYIAvwOEM-yu5GvcN-_utQ_1763353627
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-341cd35b0f3so5664677a91.0
        for <kvm@vger.kernel.org>; Sun, 16 Nov 2025 20:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763353627; x=1763958427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fco7fLuAvrWXDCMzilyr/TSfazpGIOyASl9jp9XrHTM=;
        b=dUeGfwYf44qcAmP4L0KpBnSnUkhSSqGQzVrdtaCinq5xyeANq3VUsBl99wQ9xeyP2T
         3tpIttQ1Yef7gP6PQ2GpIdId/4OX80LegmO48jil4lc1x+uSIN++Lb1Kw3PMny8l1CM7
         Fg4cDPiyvYEyzc/a+En87EdINkcHK5YTYnL1F4rdr4O1zCMhDmdwClY0HVwn0yzGiJN4
         NIKf4zivrKnmoGfoe7IwxwLwqOSgb0iMWvVfdvR82vy4duxHrU434dcznIZo38C2bQTX
         EMKZSEHLKwxCOnn8Y/IDbkoRpW39uljpQqBK913aFrAVkjyBECDCQ2dzdNUzzDYXPYMM
         OneQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763353627; x=1763958427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fco7fLuAvrWXDCMzilyr/TSfazpGIOyASl9jp9XrHTM=;
        b=G10FvdCpYAOZZ9M3uEtiTxb8hwgU0gksKTLbFVswQprt9l94KQ7TaUQAoDgwilvk9z
         zwht8VLp2w+Z2dZf4AS4Zp2ck40Uw9LTxQbsBUWfvpO+RL8RfG7TtCDU3BWI+jIgPqu1
         sKLrrhR9oGKv1I3pbdIpmFlchfmW4qFyr2lxa8Oj2AvApfFpyPMOoFpewnFgXTtGey8L
         EmxSEzuEPV8cfR2H1YoAUR3+30enJGK4FPBMJlbB3dStzTpRzU6L2UQRxBeb0V5KAWYd
         Zlu2EomCXrXznUctK/vKQAnHfQu2/Fsq8zjrwdrQqM/Xbn64WqILjlWkpU+8bD5ctsN+
         v/0w==
X-Gm-Message-State: AOJu0YzDwOaaI6BR66zM5wfaRqBA/bNYOfvVShRyJLFIQYibm9ILlGHM
	GDpE8NY3cKi/e/alFQ6xyFYaPEWfW5gQDn10bsxm4QAG14aaDWk99r32wAIA94Lr+QxxFS/N53z
	2yTSdeX9g2QgqL0taPCopUxxEQ4YBMS7gpXtnXLiNunndDdFZ2wCwRdTuvtivzV3aYUwbDB5zPs
	htqZLckihbObaojKyN/zeeQqbYXrTS
X-Gm-Gg: ASbGnctr0+PK7MPcpWxjyhM/FHCYJl7JzaSM4qlJqvXyTdX+8PlpqSTcyo4WgbYw7AW
	Gd4J5QP8PGwZOoMm9Vh1qz42bxLFLtZcePmFuqFntKSeWqHttXc3y7Rg0u+h2xtHD9iZVI7HELu
	oruLuydU7EKVcN908P91q4agJoYfALVpOwPv40aRyyjKIRx8G7pBJEtcNwExf6QLNXPSs=
X-Received: by 2002:a17:90b:518e:b0:340:bfcd:6af9 with SMTP id 98e67ed59e1d1-343f8a2adafmr10896174a91.3.1763353626548;
        Sun, 16 Nov 2025 20:27:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHGY1dscO6Xe9SOSdOqlb2nb/lYLm/7p73G0VelFDzZ+HLc/gqvCEjpOh7wQrp52uKFBlWFxaM0OW24/iq/weQ=
X-Received: by 2002:a17:90b:518e:b0:340:bfcd:6af9 with SMTP id
 98e67ed59e1d1-343f8a2adafmr10896139a91.3.1763353625569; Sun, 16 Nov 2025
 20:27:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113015420.3496-1-jasowang@redhat.com> <20251113030230-mutt-send-email-mst@kernel.org>
 <CACGkMEtnihOt=g+zs0gVQ=wnx8_YF_F=QSuLQ4RGWBVuOeFi7w@mail.gmail.com> <20251114012141-mutt-send-email-mst@kernel.org>
In-Reply-To: <20251114012141-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 17 Nov 2025 12:26:51 +0800
X-Gm-Features: AWmQ_blg00kmnhxjLNzkJTSIFhRm84dnHz6f92lrWbvQ-ixamzXWt3kVm2vR8QQ
Message-ID: <CACGkMEuqPtrCotXRcP2kzdaJ50L3oY7U-LVAKNuXOFJP_h1_PQ@mail.gmail.com>
Subject: Re: [PATCH net] vhost: rewind next_avail_head while discarding descriptors
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 2:25=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, Nov 14, 2025 at 09:53:12AM +0800, Jason Wang wrote:
> > On Thu, Nov 13, 2025 at 4:13=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Thu, Nov 13, 2025 at 09:54:20AM +0800, Jason Wang wrote:
> > > > When discarding descriptors with IN_ORDER, we should rewind
> > > > next_avail_head otherwise it would run out of sync with
> > > > last_avail_idx. This would cause driver to report
> > > > "id X is not a head".
> > > >
> > > > Fixing this by returning the number of descriptors that is used for
> > > > each buffer via vhost_get_vq_desc_n() so caller can use the value
> > > > while discarding descriptors.
> > > >
> > > > Fixes: 67a873df0c41 ("vhost: basic in order support")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > >
> > > Wow that change really caused a lot of fallout.
> > >
> > > Thanks for the patch! Yet something to improve:
> > >
> > >
> > > > ---
> > > >  drivers/vhost/net.c   | 53 ++++++++++++++++++++++++++-------------=
----
> > > >  drivers/vhost/vhost.c | 43 ++++++++++++++++++++++++-----------
> > > >  drivers/vhost/vhost.h |  9 +++++++-
> > > >  3 files changed, 70 insertions(+), 35 deletions(-)
> > > >
> > > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > > index 35ded4330431..8f7f50acb6d6 100644
> > > > --- a/drivers/vhost/net.c
> > > > +++ b/drivers/vhost/net.c
> > > > @@ -592,14 +592,15 @@ static void vhost_net_busy_poll(struct vhost_=
net *net,
> > > >  static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
> > > >                                   struct vhost_net_virtqueue *tnvq,
> > > >                                   unsigned int *out_num, unsigned i=
nt *in_num,
> > > > -                                 struct msghdr *msghdr, bool *busy=
loop_intr)
> > > > +                                 struct msghdr *msghdr, bool *busy=
loop_intr,
> > > > +                                 unsigned int *ndesc)
> > > >  {
> > > >       struct vhost_net_virtqueue *rnvq =3D &net->vqs[VHOST_NET_VQ_R=
X];
> > > >       struct vhost_virtqueue *rvq =3D &rnvq->vq;
> > > >       struct vhost_virtqueue *tvq =3D &tnvq->vq;
> > > >
> > > > -     int r =3D vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->io=
v),
> > > > -                               out_num, in_num, NULL, NULL);
> > > > +     int r =3D vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(tvq->=
iov),
> > > > +                                 out_num, in_num, NULL, NULL, ndes=
c);
> > > >
> > > >       if (r =3D=3D tvq->num && tvq->busyloop_timeout) {
> > > >               /* Flush batched packets first */
> > > > @@ -610,8 +611,8 @@ static int vhost_net_tx_get_vq_desc(struct vhos=
t_net *net,
> > > >
> > > >               vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, fal=
se);
> > > >
> > > > -             r =3D vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq=
->iov),
> > > > -                                   out_num, in_num, NULL, NULL);
> > > > +             r =3D vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(t=
vq->iov),
> > > > +                                     out_num, in_num, NULL, NULL, =
ndesc);
> > > >       }
> > > >
> > > >       return r;
> > > > @@ -642,12 +643,14 @@ static int get_tx_bufs(struct vhost_net *net,
> > > >                      struct vhost_net_virtqueue *nvq,
> > > >                      struct msghdr *msg,
> > > >                      unsigned int *out, unsigned int *in,
> > > > -                    size_t *len, bool *busyloop_intr)
> > > > +                    size_t *len, bool *busyloop_intr,
> > > > +                    unsigned int *ndesc)
> > > >  {
> > > >       struct vhost_virtqueue *vq =3D &nvq->vq;
> > > >       int ret;
> > > >
> > > > -     ret =3D vhost_net_tx_get_vq_desc(net, nvq, out, in, msg, busy=
loop_intr);
> > > > +     ret =3D vhost_net_tx_get_vq_desc(net, nvq, out, in, msg,
> > > > +                                    busyloop_intr, ndesc);
> > > >
> > > >       if (ret < 0 || ret =3D=3D vq->num)
> > > >               return ret;
> > > > @@ -766,6 +769,7 @@ static void handle_tx_copy(struct vhost_net *ne=
t, struct socket *sock)
> > > >       int sent_pkts =3D 0;
> > > >       bool sock_can_batch =3D (sock->sk->sk_sndbuf =3D=3D INT_MAX);
> > > >       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > > > +     unsigned int ndesc =3D 0;
> > > >
> > > >       do {
> > > >               bool busyloop_intr =3D false;
> > > > @@ -774,7 +778,7 @@ static void handle_tx_copy(struct vhost_net *ne=
t, struct socket *sock)
> > > >                       vhost_tx_batch(net, nvq, sock, &msg);
> > > >
> > > >               head =3D get_tx_bufs(net, nvq, &msg, &out, &in, &len,
> > > > -                                &busyloop_intr);
> > > > +                                &busyloop_intr, &ndesc);
> > > >               /* On error, stop handling until the next kick. */
> > > >               if (unlikely(head < 0))
> > > >                       break;
> > > > @@ -806,7 +810,7 @@ static void handle_tx_copy(struct vhost_net *ne=
t, struct socket *sock)
> > > >                               goto done;
> > > >                       } else if (unlikely(err !=3D -ENOSPC)) {
> > > >                               vhost_tx_batch(net, nvq, sock, &msg);
> > > > -                             vhost_discard_vq_desc(vq, 1);
> > > > +                             vhost_discard_vq_desc(vq, 1, ndesc);
> > > >                               vhost_net_enable_vq(net, vq);
> > > >                               break;
> > > >                       }
> > > > @@ -829,7 +833,7 @@ static void handle_tx_copy(struct vhost_net *ne=
t, struct socket *sock)
> > > >               err =3D sock->ops->sendmsg(sock, &msg, len);
> > > >               if (unlikely(err < 0)) {
> > > >                       if (err =3D=3D -EAGAIN || err =3D=3D -ENOMEM =
|| err =3D=3D -ENOBUFS) {
> > > > -                             vhost_discard_vq_desc(vq, 1);
> > > > +                             vhost_discard_vq_desc(vq, 1, ndesc);
> > > >                               vhost_net_enable_vq(net, vq);
> > > >                               break;
> > > >                       }
> > > > @@ -868,6 +872,7 @@ static void handle_tx_zerocopy(struct vhost_net=
 *net, struct socket *sock)
> > > >       int err;
> > > >       struct vhost_net_ubuf_ref *ubufs;
> > > >       struct ubuf_info_msgzc *ubuf;
> > > > +     unsigned int ndesc =3D 0;
> > > >       bool zcopy_used;
> > > >       int sent_pkts =3D 0;
> > > >
> > > > @@ -879,7 +884,7 @@ static void handle_tx_zerocopy(struct vhost_net=
 *net, struct socket *sock)
> > > >
> > > >               busyloop_intr =3D false;
> > > >               head =3D get_tx_bufs(net, nvq, &msg, &out, &in, &len,
> > > > -                                &busyloop_intr);
> > > > +                                &busyloop_intr, &ndesc);
> > > >               /* On error, stop handling until the next kick. */
> > > >               if (unlikely(head < 0))
> > > >                       break;
> > > > @@ -941,7 +946,7 @@ static void handle_tx_zerocopy(struct vhost_net=
 *net, struct socket *sock)
> > > >                                       vq->heads[ubuf->desc].len =3D=
 VHOST_DMA_DONE_LEN;
> > > >                       }
> > > >                       if (retry) {
> > > > -                             vhost_discard_vq_desc(vq, 1);
> > > > +                             vhost_discard_vq_desc(vq, 1, ndesc);
> > > >                               vhost_net_enable_vq(net, vq);
> > > >                               break;
> > > >                       }
> > > > @@ -1045,11 +1050,12 @@ static int get_rx_bufs(struct vhost_net_vir=
tqueue *nvq,
> > > >                      unsigned *iovcount,
> > > >                      struct vhost_log *log,
> > > >                      unsigned *log_num,
> > > > -                    unsigned int quota)
> > > > +                    unsigned int quota,
> > > > +                    unsigned int *ndesc)
> > > >  {
> > > >       struct vhost_virtqueue *vq =3D &nvq->vq;
> > > >       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > > > -     unsigned int out, in;
> > > > +     unsigned int out, in, desc_num, n =3D 0;
> > > >       int seg =3D 0;
> > > >       int headcount =3D 0;
> > > >       unsigned d;
> > > > @@ -1064,9 +1070,9 @@ static int get_rx_bufs(struct vhost_net_virtq=
ueue *nvq,
> > > >                       r =3D -ENOBUFS;
> > > >                       goto err;
> > > >               }
> > > > -             r =3D vhost_get_vq_desc(vq, vq->iov + seg,
> > > > -                                   ARRAY_SIZE(vq->iov) - seg, &out=
,
> > > > -                                   &in, log, log_num);
> > > > +             r =3D vhost_get_vq_desc_n(vq, vq->iov + seg,
> > > > +                                     ARRAY_SIZE(vq->iov) - seg, &o=
ut,
> > > > +                                     &in, log, log_num, &desc_num)=
;
> > > >               if (unlikely(r < 0))
> > > >                       goto err;
> > > >
> > > > @@ -1093,6 +1099,7 @@ static int get_rx_bufs(struct vhost_net_virtq=
ueue *nvq,
> > > >               ++headcount;
> > > >               datalen -=3D len;
> > > >               seg +=3D in;
> > > > +             n +=3D desc_num;
> > > >       }
> > > >
> > > >       *iovcount =3D seg;
> > > > @@ -1113,9 +1120,11 @@ static int get_rx_bufs(struct vhost_net_virt=
queue *nvq,
> > > >               nheads[0] =3D headcount;
> > > >       }
> > > >
> > > > +     *ndesc =3D n;
> > > > +
> > > >       return headcount;
> > > >  err:
> > > > -     vhost_discard_vq_desc(vq, headcount);
> > > > +     vhost_discard_vq_desc(vq, headcount, n);
> > >
> > > So here ndesc and n are the same, but below in vhost_discard_vq_desc
> > > they are different. Fun.
> >
> > Not necessarily the same, a buffer could contain more than 1 descriptor=
.
>
>
> *ndesc =3D n kinda guarantees it's the same, no?

I misread your comment, in the error path the ndesc is left unused.
Would this be a problem?

>
> > >
> > > >       return r;
> > > >  }
> > > >
> > > > @@ -1151,6 +1160,7 @@ static void handle_rx(struct vhost_net *net)
> > > >       struct iov_iter fixup;
> > > >       __virtio16 num_buffers;
> > > >       int recv_pkts =3D 0;
> > > > +     unsigned int ndesc;
> > > >
> > > >       mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_RX);
> > > >       sock =3D vhost_vq_get_backend(vq);
> > > > @@ -1182,7 +1192,8 @@ static void handle_rx(struct vhost_net *net)
> > > >               headcount =3D get_rx_bufs(nvq, vq->heads + count,
> > > >                                       vq->nheads + count,
> > > >                                       vhost_len, &in, vq_log, &log,
> > > > -                                     likely(mergeable) ? UIO_MAXIO=
V : 1);
> > > > +                                     likely(mergeable) ? UIO_MAXIO=
V : 1,
> > > > +                                     &ndesc);
> > > >               /* On error, stop handling until the next kick. */
> > > >               if (unlikely(headcount < 0))
> > > >                       goto out;
> > > > @@ -1228,7 +1239,7 @@ static void handle_rx(struct vhost_net *net)
> > > >               if (unlikely(err !=3D sock_len)) {
> > > >                       pr_debug("Discarded rx packet: "
> > > >                                " len %d, expected %zd\n", err, sock=
_len);
> > > > -                     vhost_discard_vq_desc(vq, headcount);
> > > > +                     vhost_discard_vq_desc(vq, headcount, ndesc);
> > > >                       continue;
> > > >               }
> > > >               /* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HD=
R */
> > > > @@ -1252,7 +1263,7 @@ static void handle_rx(struct vhost_net *net)
> > > >                   copy_to_iter(&num_buffers, sizeof num_buffers,
> > > >                                &fixup) !=3D sizeof num_buffers) {
> > > >                       vq_err(vq, "Failed num_buffers write");
> > > > -                     vhost_discard_vq_desc(vq, headcount);
> > > > +                     vhost_discard_vq_desc(vq, headcount, ndesc);
> > > >                       goto out;
> > > >               }
> > > >               nvq->done_idx +=3D headcount;
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index 8570fdf2e14a..b56568807588 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -2792,18 +2792,11 @@ static int get_indirect(struct vhost_virtqu=
eue *vq,
> > > >       return 0;
> > > >  }
> > > >
> > > > -/* This looks in the virtqueue and for the first available buffer,=
 and converts
> > > > - * it to an iovec for convenient access.  Since descriptors consis=
t of some
> > > > - * number of output then some number of input descriptors, it's ac=
tually two
> > > > - * iovecs, but we pack them into one and note how many of each the=
re were.
> > > > - *
> > > > - * This function returns the descriptor number found, or vq->num (=
which is
> > > > - * never a valid descriptor number) if none was found.  A negative=
 code is
> > > > - * returned on error. */
> > >
> > > A new module API with no docs at all is not good.
> > > Please add documentation to this one. vhost_get_vq_desc
> > > is a subset and could refer to it.
> >
> > Fixed.
> >
> > >
> > > > -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> > > > -                   struct iovec iov[], unsigned int iov_size,
> > > > -                   unsigned int *out_num, unsigned int *in_num,
> > > > -                   struct vhost_log *log, unsigned int *log_num)
> > > > +int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
> > > > +                     struct iovec iov[], unsigned int iov_size,
> > > > +                     unsigned int *out_num, unsigned int *in_num,
> > > > +                     struct vhost_log *log, unsigned int *log_num,
> > > > +                     unsigned int *ndesc)
> > >
> > > >  {
> > > >       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > > >       struct vring_desc desc;
> > > > @@ -2921,16 +2914,40 @@ int vhost_get_vq_desc(struct vhost_virtqueu=
e *vq,
> > > >       vq->last_avail_idx++;
> > > >       vq->next_avail_head +=3D c;
> > > >
> > > > +     if (ndesc)
> > > > +             *ndesc =3D c;
> > > > +
> > > >       /* Assume notifications from guest are disabled at this point=
,
> > > >        * if they aren't we would need to update avail_event index. =
*/
> > > >       BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
> > > >       return head;
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(vhost_get_vq_desc_n);
> > > > +
> > > > +/* This looks in the virtqueue and for the first available buffer,=
 and converts
> > > > + * it to an iovec for convenient access.  Since descriptors consis=
t of some
> > > > + * number of output then some number of input descriptors, it's ac=
tually two
> > > > + * iovecs, but we pack them into one and note how many of each the=
re were.
> > > > + *
> > > > + * This function returns the descriptor number found, or vq->num (=
which is
> > > > + * never a valid descriptor number) if none was found.  A negative=
 code is
> > > > + * returned on error.
> > > > + */
> > > > +int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> > > > +                   struct iovec iov[], unsigned int iov_size,
> > > > +                   unsigned int *out_num, unsigned int *in_num,
> > > > +                   struct vhost_log *log, unsigned int *log_num)
> > > > +{
> > > > +     return vhost_get_vq_desc_n(vq, iov, iov_size, out_num, in_num=
,
> > > > +                                log, log_num, NULL);
> > > > +}
> > > >  EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
> > > >
> > > >  /* Reverse the effect of vhost_get_vq_desc. Useful for error handl=
ing. */
> > > > -void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
> > > > +void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n,
> > > > +                        unsigned int ndesc)
> > >
> > > ndesc is number of descriptors? And n is what, in that case?
> >
> > The semantic of n is not changed which is the number of buffers, ndesc
> > is the number of descriptors.
>
> History is not that relevant. To make the core readable pls
> change the names to readable ones.
>
> Specifically n is really nbufs, maybe?

Right.

Thanks



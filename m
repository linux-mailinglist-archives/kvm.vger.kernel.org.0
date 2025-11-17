Return-Path: <kvm+bounces-63336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5809EC62F76
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:50:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2312C4E6052
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 08:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64028320A02;
	Mon, 17 Nov 2025 08:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EjezVKuA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mRAASKZH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CFE31DD86
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 08:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763369380; cv=none; b=nFMY3M3yr0Srf1KpYf7S6cBt+RDu8RIZ3qkZQ71ujBPsCyZqIA1rzF1kBX4g2FK7G6ziCk5ikzNOhDvOdAbWC3R3MRYVJt01NcOSNNt63q3u5jJ425QiNZg6OW4FOSynqRXORMHpivArJw/PYr0Ij+WGy5gefH1hx/CDKdQth5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763369380; c=relaxed/simple;
	bh=Y5s7Sh/WpuEO+yxTBGl+vwDiEC7tAzHgg7xAmSsL+Mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3mqzZXD8UT+sPUZtPTO1v1x0qNDlaw3TJ4jVw/nUvOuDhor8x2oMHolmtTE8upLvFBnontmdwGOR1asVHeCF3VVw75phvYQXyWWuywyGoytADHYzaSOqgPjn1v0O+hxMRkDdIOlG+IaBn8xJPdSwUgMFdCA63qIOL0z4hzibkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EjezVKuA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mRAASKZH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763369373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ka5BRyNKWE0cRIvBqPPrv0MZSymv3LuUVDvyEiDL9D4=;
	b=EjezVKuAyKaJW6ZrDqUsMi+6FmoZDO4DXGmynagW7JeMCoAWrHi6PYbemY4lUq4rHNBHYE
	JwZtKMEca5D1Fx1lqD/Ao543CprkBZnIndRD20Mhg4eYVN1R3OyhQFpxJpAzAbFD4YEq3h
	BKJuTo9QqunegGrE9RUDBj2lqGIbkCA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-fbyrM_dqPhypl5bNu7iuGQ-1; Mon, 17 Nov 2025 03:49:29 -0500
X-MC-Unique: fbyrM_dqPhypl5bNu7iuGQ-1
X-Mimecast-MFC-AGG-ID: fbyrM_dqPhypl5bNu7iuGQ_1763369368
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4775d110fabso31484485e9.1
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 00:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763369368; x=1763974168; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ka5BRyNKWE0cRIvBqPPrv0MZSymv3LuUVDvyEiDL9D4=;
        b=mRAASKZHUOwfB/+a3H4WfZyHJvqQPmd3ZvrLgYJdG0jEWEwnf2o3V8M7cwQs65athj
         VHoAgsGKOSWMa6AExBRoE985txmXixif83zlp0pj2L3+CYfRrmJEtOjmczNh+9Z/EKsL
         0XgIIs3HHZq9WPrv9p3KyT1p8S/SYMaYJrMJfP5gaH/wU1fQKwDALSdrMxL1mReG2Bkm
         OMpAB8Jkc80W3CRiM38JW/4nAzYLycAIllTpWR97IlnX8FyO3TV84NZglVA3Hh5yUXiZ
         RUYZWOwd1KCggnZ9ama5r9ylyGg5iEhjt6mGASd74EigihQIifyR86mhX4FJZwPISSEb
         bZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763369368; x=1763974168;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ka5BRyNKWE0cRIvBqPPrv0MZSymv3LuUVDvyEiDL9D4=;
        b=LcJVPg1W64rxL6FZyPi37W4vM/84MVfKVcRoUBgdoDydZ8iojWBDcqphCaKtV0ZPiH
         VxyeJrVr8mImGIu4qPPJvdyK2g14OBAvWXyM+9pPzwOyWY01a9BSeOrrxHyfxnn1qmF8
         i7HZ8w+PohQNe3amYKUGQR3PL68sauz+S/0NNo+aKAtorguRv3BVdLYALD/j1NUioHi2
         1AkP0a/Vwi3ovlHwKHxSgQ0kQJeQkdijEf+zYODMC1Ot6nYAE0yAKmARuCVgEQQ1yZwb
         QNqxmjyfKCLoT7+t7EGjD1F5FRj2299tZbx7mu12HCHGO3VgTC7bOs8m+mftaXUatd6R
         rR3w==
X-Gm-Message-State: AOJu0YzGSjReRva9y5f2nh7e61PaaAVaIyTpvnz9nlx4XoyLz0HL0dBP
	ZV2Nzv7VwROPBsJD7bjv4fYTq5kr7ofXwOzId/Xuv+pKM5Iuq6axi/cVfRz+tcgVrGcFIFILUqy
	E08O8PvagfYufVrX/ZQp+eawK3Fw/RN9SQGPn5/PxzB3G/wCsZkVBjvjUTJo1GA==
X-Gm-Gg: ASbGncsuEsNKUWLoJej495DCDDEUGL9JKtJ1WJyNtXwOz3SdazGcKTg/NZUonU5VgJ9
	NI7FAISl9Yx+PW24wGfqkoMScQ9IfbjxU2QVqBa/wdDEykkrx7Hg831j8KxZ6xNJ6nI7HqzQP+q
	rC2Ya4Gddf34ZZY5YF5cGU4EmmcnGv4OWOrti2LtUwQqbbxGnHx1AILXZQds8pyCbe2CzCJSCYv
	IvnEVZHxBu5ezDq7a0p/doFp96fwxiFuZC9TofJB6L2Lh0juK9F/v2wpYxX7vh2vznJqJp6yCFu
	OSl/7IoJLQIRzORoNygizPfjkNcBTSXYDf2vGhiuStEqFgMbRXhAs5To2SidrB9AVE8rCc1b17L
	3Z2imSAWKyy3zeaYJwWo=
X-Received: by 2002:a05:600c:190b:b0:471:131f:85aa with SMTP id 5b1f17b1804b1-4778fe4a039mr91199965e9.13.1763369367915;
        Mon, 17 Nov 2025 00:49:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHaCDWYACHwzpfY4KOeRRYGUIbq2/4W1nJU5HGIEYm7EIY1k+PwDRLJ/xzEhDXKHeADbPRKsQ==
X-Received: by 2002:a05:600c:190b:b0:471:131f:85aa with SMTP id 5b1f17b1804b1-4778fe4a039mr91199695e9.13.1763369367257;
        Mon, 17 Nov 2025 00:49:27 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4779cb19c00sm45872455e9.15.2025.11.17.00.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 00:49:26 -0800 (PST)
Date: Mon, 17 Nov 2025 03:49:22 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] vhost: rewind next_avail_head while discarding
 descriptors
Message-ID: <20251117034446-mutt-send-email-mst@kernel.org>
References: <20251113015420.3496-1-jasowang@redhat.com>
 <20251113030230-mutt-send-email-mst@kernel.org>
 <CACGkMEtnihOt=g+zs0gVQ=wnx8_YF_F=QSuLQ4RGWBVuOeFi7w@mail.gmail.com>
 <20251114012141-mutt-send-email-mst@kernel.org>
 <CACGkMEuqPtrCotXRcP2kzdaJ50L3oY7U-LVAKNuXOFJP_h1_PQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEuqPtrCotXRcP2kzdaJ50L3oY7U-LVAKNuXOFJP_h1_PQ@mail.gmail.com>

On Mon, Nov 17, 2025 at 12:26:51PM +0800, Jason Wang wrote:
> On Fri, Nov 14, 2025 at 2:25 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Nov 14, 2025 at 09:53:12AM +0800, Jason Wang wrote:
> > > On Thu, Nov 13, 2025 at 4:13 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Thu, Nov 13, 2025 at 09:54:20AM +0800, Jason Wang wrote:
> > > > > When discarding descriptors with IN_ORDER, we should rewind
> > > > > next_avail_head otherwise it would run out of sync with
> > > > > last_avail_idx. This would cause driver to report
> > > > > "id X is not a head".
> > > > >
> > > > > Fixing this by returning the number of descriptors that is used for
> > > > > each buffer via vhost_get_vq_desc_n() so caller can use the value
> > > > > while discarding descriptors.
> > > > >
> > > > > Fixes: 67a873df0c41 ("vhost: basic in order support")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > >
> > > > Wow that change really caused a lot of fallout.
> > > >
> > > > Thanks for the patch! Yet something to improve:
> > > >
> > > >
> > > > > ---
> > > > >  drivers/vhost/net.c   | 53 ++++++++++++++++++++++++++-----------------
> > > > >  drivers/vhost/vhost.c | 43 ++++++++++++++++++++++++-----------
> > > > >  drivers/vhost/vhost.h |  9 +++++++-
> > > > >  3 files changed, 70 insertions(+), 35 deletions(-)
> > > > >
> > > > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > > > index 35ded4330431..8f7f50acb6d6 100644
> > > > > --- a/drivers/vhost/net.c
> > > > > +++ b/drivers/vhost/net.c
> > > > > @@ -592,14 +592,15 @@ static void vhost_net_busy_poll(struct vhost_net *net,
> > > > >  static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
> > > > >                                   struct vhost_net_virtqueue *tnvq,
> > > > >                                   unsigned int *out_num, unsigned int *in_num,
> > > > > -                                 struct msghdr *msghdr, bool *busyloop_intr)
> > > > > +                                 struct msghdr *msghdr, bool *busyloop_intr,
> > > > > +                                 unsigned int *ndesc)
> > > > >  {
> > > > >       struct vhost_net_virtqueue *rnvq = &net->vqs[VHOST_NET_VQ_RX];
> > > > >       struct vhost_virtqueue *rvq = &rnvq->vq;
> > > > >       struct vhost_virtqueue *tvq = &tnvq->vq;
> > > > >
> > > > > -     int r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
> > > > > -                               out_num, in_num, NULL, NULL);
> > > > > +     int r = vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
> > > > > +                                 out_num, in_num, NULL, NULL, ndesc);
> > > > >
> > > > >       if (r == tvq->num && tvq->busyloop_timeout) {
> > > > >               /* Flush batched packets first */
> > > > > @@ -610,8 +611,8 @@ static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
> > > > >
> > > > >               vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, false);
> > > > >
> > > > > -             r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
> > > > > -                                   out_num, in_num, NULL, NULL);
> > > > > +             r = vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
> > > > > +                                     out_num, in_num, NULL, NULL, ndesc);
> > > > >       }
> > > > >
> > > > >       return r;
> > > > > @@ -642,12 +643,14 @@ static int get_tx_bufs(struct vhost_net *net,
> > > > >                      struct vhost_net_virtqueue *nvq,
> > > > >                      struct msghdr *msg,
> > > > >                      unsigned int *out, unsigned int *in,
> > > > > -                    size_t *len, bool *busyloop_intr)
> > > > > +                    size_t *len, bool *busyloop_intr,
> > > > > +                    unsigned int *ndesc)
> > > > >  {
> > > > >       struct vhost_virtqueue *vq = &nvq->vq;
> > > > >       int ret;
> > > > >
> > > > > -     ret = vhost_net_tx_get_vq_desc(net, nvq, out, in, msg, busyloop_intr);
> > > > > +     ret = vhost_net_tx_get_vq_desc(net, nvq, out, in, msg,
> > > > > +                                    busyloop_intr, ndesc);
> > > > >
> > > > >       if (ret < 0 || ret == vq->num)
> > > > >               return ret;
> > > > > @@ -766,6 +769,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > > > >       int sent_pkts = 0;
> > > > >       bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
> > > > >       bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > > > > +     unsigned int ndesc = 0;
> > > > >
> > > > >       do {
> > > > >               bool busyloop_intr = false;
> > > > > @@ -774,7 +778,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > > > >                       vhost_tx_batch(net, nvq, sock, &msg);
> > > > >
> > > > >               head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
> > > > > -                                &busyloop_intr);
> > > > > +                                &busyloop_intr, &ndesc);
> > > > >               /* On error, stop handling until the next kick. */
> > > > >               if (unlikely(head < 0))
> > > > >                       break;
> > > > > @@ -806,7 +810,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > > > >                               goto done;
> > > > >                       } else if (unlikely(err != -ENOSPC)) {
> > > > >                               vhost_tx_batch(net, nvq, sock, &msg);
> > > > > -                             vhost_discard_vq_desc(vq, 1);
> > > > > +                             vhost_discard_vq_desc(vq, 1, ndesc);
> > > > >                               vhost_net_enable_vq(net, vq);
> > > > >                               break;
> > > > >                       }
> > > > > @@ -829,7 +833,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> > > > >               err = sock->ops->sendmsg(sock, &msg, len);
> > > > >               if (unlikely(err < 0)) {
> > > > >                       if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
> > > > > -                             vhost_discard_vq_desc(vq, 1);
> > > > > +                             vhost_discard_vq_desc(vq, 1, ndesc);
> > > > >                               vhost_net_enable_vq(net, vq);
> > > > >                               break;
> > > > >                       }
> > > > > @@ -868,6 +872,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> > > > >       int err;
> > > > >       struct vhost_net_ubuf_ref *ubufs;
> > > > >       struct ubuf_info_msgzc *ubuf;
> > > > > +     unsigned int ndesc = 0;
> > > > >       bool zcopy_used;
> > > > >       int sent_pkts = 0;
> > > > >
> > > > > @@ -879,7 +884,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> > > > >
> > > > >               busyloop_intr = false;
> > > > >               head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
> > > > > -                                &busyloop_intr);
> > > > > +                                &busyloop_intr, &ndesc);
> > > > >               /* On error, stop handling until the next kick. */
> > > > >               if (unlikely(head < 0))
> > > > >                       break;
> > > > > @@ -941,7 +946,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> > > > >                                       vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
> > > > >                       }
> > > > >                       if (retry) {
> > > > > -                             vhost_discard_vq_desc(vq, 1);
> > > > > +                             vhost_discard_vq_desc(vq, 1, ndesc);
> > > > >                               vhost_net_enable_vq(net, vq);
> > > > >                               break;
> > > > >                       }
> > > > > @@ -1045,11 +1050,12 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
> > > > >                      unsigned *iovcount,
> > > > >                      struct vhost_log *log,
> > > > >                      unsigned *log_num,
> > > > > -                    unsigned int quota)
> > > > > +                    unsigned int quota,
> > > > > +                    unsigned int *ndesc)
> > > > >  {
> > > > >       struct vhost_virtqueue *vq = &nvq->vq;
> > > > >       bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > > > > -     unsigned int out, in;
> > > > > +     unsigned int out, in, desc_num, n = 0;
> > > > >       int seg = 0;
> > > > >       int headcount = 0;
> > > > >       unsigned d;
> > > > > @@ -1064,9 +1070,9 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
> > > > >                       r = -ENOBUFS;
> > > > >                       goto err;
> > > > >               }
> > > > > -             r = vhost_get_vq_desc(vq, vq->iov + seg,
> > > > > -                                   ARRAY_SIZE(vq->iov) - seg, &out,
> > > > > -                                   &in, log, log_num);
> > > > > +             r = vhost_get_vq_desc_n(vq, vq->iov + seg,
> > > > > +                                     ARRAY_SIZE(vq->iov) - seg, &out,
> > > > > +                                     &in, log, log_num, &desc_num);
> > > > >               if (unlikely(r < 0))
> > > > >                       goto err;
> > > > >
> > > > > @@ -1093,6 +1099,7 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
> > > > >               ++headcount;
> > > > >               datalen -= len;
> > > > >               seg += in;
> > > > > +             n += desc_num;
> > > > >       }
> > > > >
> > > > >       *iovcount = seg;
> > > > > @@ -1113,9 +1120,11 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
> > > > >               nheads[0] = headcount;
> > > > >       }
> > > > >
> > > > > +     *ndesc = n;
> > > > > +
> > > > >       return headcount;
> > > > >  err:
> > > > > -     vhost_discard_vq_desc(vq, headcount);
> > > > > +     vhost_discard_vq_desc(vq, headcount, n);
> > > >
> > > > So here ndesc and n are the same, but below in vhost_discard_vq_desc
> > > > they are different. Fun.
> > >
> > > Not necessarily the same, a buffer could contain more than 1 descriptor.
> >
> >
> > *ndesc = n kinda guarantees it's the same, no?
> 
> I misread your comment, in the error path the ndesc is left unused.




> Would this be a problem?
> >
> > > >
> > > > >       return r;
> > > > >  }
> > > > >
> > > > > @@ -1151,6 +1160,7 @@ static void handle_rx(struct vhost_net *net)
> > > > >       struct iov_iter fixup;
> > > > >       __virtio16 num_buffers;
> > > > >       int recv_pkts = 0;
> > > > > +     unsigned int ndesc;
> > > > >
> > > > >       mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_RX);
> > > > >       sock = vhost_vq_get_backend(vq);
> > > > > @@ -1182,7 +1192,8 @@ static void handle_rx(struct vhost_net *net)
> > > > >               headcount = get_rx_bufs(nvq, vq->heads + count,
> > > > >                                       vq->nheads + count,
> > > > >                                       vhost_len, &in, vq_log, &log,
> > > > > -                                     likely(mergeable) ? UIO_MAXIOV : 1);
> > > > > +                                     likely(mergeable) ? UIO_MAXIOV : 1,
> > > > > +                                     &ndesc);
> > > > >               /* On error, stop handling until the next kick. */
> > > > >               if (unlikely(headcount < 0))
> > > > >                       goto out;
> > > > > @@ -1228,7 +1239,7 @@ static void handle_rx(struct vhost_net *net)
> > > > >               if (unlikely(err != sock_len)) {
> > > > >                       pr_debug("Discarded rx packet: "
> > > > >                                " len %d, expected %zd\n", err, sock_len);
> > > > > -                     vhost_discard_vq_desc(vq, headcount);
> > > > > +                     vhost_discard_vq_desc(vq, headcount, ndesc);
> > > > >                       continue;
> > > > >               }
> > > > >               /* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR */
> > > > > @@ -1252,7 +1263,7 @@ static void handle_rx(struct vhost_net *net)
> > > > >                   copy_to_iter(&num_buffers, sizeof num_buffers,
> > > > >                                &fixup) != sizeof num_buffers) {
> > > > >                       vq_err(vq, "Failed num_buffers write");
> > > > > -                     vhost_discard_vq_desc(vq, headcount);
> > > > > +                     vhost_discard_vq_desc(vq, headcount, ndesc);
> > > > >                       goto out;
> > > > >               }
> > > > >               nvq->done_idx += headcount;
> > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > > index 8570fdf2e14a..b56568807588 100644
> > > > > --- a/drivers/vhost/vhost.c
> > > > > +++ b/drivers/vhost/vhost.c
> > > > > @@ -2792,18 +2792,11 @@ static int get_indirect(struct vhost_virtqueue *vq,
> > > > >       return 0;
> > > > >  }
> > > > >
> > > > > -/* This looks in the virtqueue and for the first available buffer, and converts
> > > > > - * it to an iovec for convenient access.  Since descriptors consist of some
> > > > > - * number of output then some number of input descriptors, it's actually two
> > > > > - * iovecs, but we pack them into one and note how many of each there were.
> > > > > - *
> > > > > - * This function returns the descriptor number found, or vq->num (which is
> > > > > - * never a valid descriptor number) if none was found.  A negative code is
> > > > > - * returned on error. */
> > > >
> > > > A new module API with no docs at all is not good.
> > > > Please add documentation to this one. vhost_get_vq_desc
> > > > is a subset and could refer to it.
> > >
> > > Fixed.
> > >
> > > >
> > > > > -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> > > > > -                   struct iovec iov[], unsigned int iov_size,
> > > > > -                   unsigned int *out_num, unsigned int *in_num,
> > > > > -                   struct vhost_log *log, unsigned int *log_num)
> > > > > +int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
> > > > > +                     struct iovec iov[], unsigned int iov_size,
> > > > > +                     unsigned int *out_num, unsigned int *in_num,
> > > > > +                     struct vhost_log *log, unsigned int *log_num,
> > > > > +                     unsigned int *ndesc)
> > > >
> > > > >  {
> > > > >       bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> > > > >       struct vring_desc desc;
> > > > > @@ -2921,16 +2914,40 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> > > > >       vq->last_avail_idx++;
> > > > >       vq->next_avail_head += c;
> > > > >
> > > > > +     if (ndesc)
> > > > > +             *ndesc = c;
> > > > > +
> > > > >       /* Assume notifications from guest are disabled at this point,
> > > > >        * if they aren't we would need to update avail_event index. */
> > > > >       BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
> > > > >       return head;
> > > > >  }
> > > > > +EXPORT_SYMBOL_GPL(vhost_get_vq_desc_n);
> > > > > +
> > > > > +/* This looks in the virtqueue and for the first available buffer, and converts
> > > > > + * it to an iovec for convenient access.  Since descriptors consist of some
> > > > > + * number of output then some number of input descriptors, it's actually two
> > > > > + * iovecs, but we pack them into one and note how many of each there were.
> > > > > + *
> > > > > + * This function returns the descriptor number found, or vq->num (which is
> > > > > + * never a valid descriptor number) if none was found.  A negative code is
> > > > > + * returned on error.
> > > > > + */
> > > > > +int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> > > > > +                   struct iovec iov[], unsigned int iov_size,
> > > > > +                   unsigned int *out_num, unsigned int *in_num,
> > > > > +                   struct vhost_log *log, unsigned int *log_num)
> > > > > +{
> > > > > +     return vhost_get_vq_desc_n(vq, iov, iov_size, out_num, in_num,
> > > > > +                                log, log_num, NULL);
> > > > > +}
> > > > >  EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
> > > > >
> > > > >  /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
> > > > > -void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
> > > > > +void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n,
> > > > > +                        unsigned int ndesc)
> > > >
> > > > ndesc is number of descriptors? And n is what, in that case?
> > >
> > > The semantic of n is not changed which is the number of buffers, ndesc
> > > is the number of descriptors.
> >
> > History is not that relevant. To make the core readable pls
> > change the names to readable ones.
> >
> > Specifically n is really nbufs, maybe?
> 
> Right.
> 
> Thanks

All I am asking for is that in the API the parameter is named in a way
that makes it clear what it is counting.

vhost_get_vq_desc_n is the function you want to document, making it
clear what is returned in ndesc and how it's different from the return
value.



-- 
MST



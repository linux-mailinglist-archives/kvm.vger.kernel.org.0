Return-Path: <kvm+bounces-7304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F0E83FC85
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 04:05:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0A0C2832DF
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 03:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B61DFC1D;
	Mon, 29 Jan 2024 03:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PaxRgdLS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10929F9EF
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 03:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706497541; cv=none; b=BvLsJ1qZ9msZ0TuA76OzMkt98YvsiVjYehFfpJxmuTm6WsM4hq2IcVen48e6qnAAjtLYPB35v4HtpdUmYjAW+w/jNBjXtcZ2Gdywy/2CYsLQ7Cj/Gl3q8CyMjsdqju69/Lx7i8LvpRcuuzaMC9laA0PMHKUxRoJefbuVqNKqMmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706497541; c=relaxed/simple;
	bh=YtumUDa9xISoGxbg6DJBDnOO+Rukg7wlbjEEjxfD3UY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EVworRXE+mr/jymVDlRNw54VQV3fNnUEkurO/6xdxkjyb4FuBqMKB9KWXu6HdBRE9ZloXpYea/q3OX6hdircE+2M48s74MgEiXMGzjuZpAHfKtMo+L3iPcjbPPzfiESO3CHKNquXnZkyETr+DiL0Z/Yx5/U7ctvs5/R1Ui1k/+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PaxRgdLS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706497539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RxcHXDna7cKu/U9+4vXe/vVpNtUCeHUKRMCX5kQ7Mpk=;
	b=PaxRgdLSeZeHpPt3MDz4uwN8/MfvNAklAcNE9SLZ6LVZ6YB+IZZFQ+4qQSvszz4h+WH3sL
	BFOhwCJdgyguoJJCJpxN93Qn4LSvnLePukurR7BRGBQ8c0gbVoShEipa6vZhIDQ/2BOLqs
	Rc0X04PSsdlNpcRf4nc+WcvDPLFXuIk=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-jWiTb6ZOO0iKtBsaMo9YxQ-1; Sun, 28 Jan 2024 22:05:37 -0500
X-MC-Unique: jWiTb6ZOO0iKtBsaMo9YxQ-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3bd3bdcd87fso3298340b6e.3
        for <kvm@vger.kernel.org>; Sun, 28 Jan 2024 19:05:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706497536; x=1707102336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RxcHXDna7cKu/U9+4vXe/vVpNtUCeHUKRMCX5kQ7Mpk=;
        b=HzNKP9YQJIEViA8jARus0Inq/nP2dp4zsY2mKZc5wos5dF1swo+6+dsWX0UFkmE2Pl
         KayfZlQI/rRFqX7ltHioDVzGcH7RzLCHPLEzdz2e2etMrvYN1pJxKs4FWWFCQcqQNZL3
         sx6zaWd85zzDJLtTF9cNStKZrGew+upUKLkdckQMaodPIlG3G1PSwGxICXw3OHgmmMrW
         aI87VHTUbcYTmni3/pl/PkE/4Kjs9OY6i1sXSzh6pn0fZoen1hT4Eo8V5JzEiLZflEGH
         23PEskA+demVaIWyMMxdCFAORlFrgfc5sNw1EGpkrEblfVRu8jqTAXB8s4LN1e14FoPy
         BUlw==
X-Gm-Message-State: AOJu0Yyve69Sd1DyPcycgjad3fniKxdpWVPiDE7AFYzSLo4zWVQhE2CV
	qD2774N/acFlqkYf8jSuBWVioJu5ZkYR9bj4h2eYk5BvGop3NowRy8l68qmUOc5tfJyK87mftom
	Rs9i5tz+iV5pxrDw2RdUud+Ji9ojq6h/sNIPtpNf24S3P6ZQgtpqge4C9w6g2wjTiF9aCN8NDB3
	Od1RWK1AjbbZywnXF8Y4TKjAT6
X-Received: by 2002:a05:6808:2096:b0:3be:68bf:f811 with SMTP id s22-20020a056808209600b003be68bff811mr445571oiw.20.1706497536646;
        Sun, 28 Jan 2024 19:05:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwSYFKtOFj1s4WRiGoVdbQaT36N6KL4HDrAVc5wEDiWUARymRb8voEFpf5mPyhonR8JwLBNdJn84fdszA4rAo=
X-Received: by 2002:a05:6808:2096:b0:3be:68bf:f811 with SMTP id
 s22-20020a056808209600b003be68bff811mr445564oiw.20.1706497536445; Sun, 28 Jan
 2024 19:05:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
 <CACGkMEu5PaBgh37X4KysoF9YB8qy6jM5W4G6sm+8fjrnK36KXA@mail.gmail.com>
 <ad74a361d5084c62a89f7aa276273649@huawei.com> <156030296fea4f7abef6ab7155ba2e32@huawei.com>
In-Reply-To: <156030296fea4f7abef6ab7155ba2e32@huawei.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 29 Jan 2024 11:05:25 +0800
Message-ID: <CACGkMEuMTdr3NS=XdkN+XDRqiXouL2tWcXEk6-qTvOsm0JCc9Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
To: wangyunjian <wangyunjian@huawei.com>
Cc: "mst@redhat.com" <mst@redhat.com>, 
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>, "kuba@kernel.org" <kuba@kernel.org>, 
	"davem@davemloft.net" <davem@davemloft.net>, 
	"magnus.karlsson@intel.com" <magnus.karlsson@intel.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, xudingke <xudingke@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 27, 2024 at 5:34=E2=80=AFPM wangyunjian <wangyunjian@huawei.com=
> wrote:
>
> > > -----Original Message-----
> > > From: Jason Wang [mailto:jasowang@redhat.com]
> > > Sent: Thursday, January 25, 2024 12:49 PM
> > > To: wangyunjian <wangyunjian@huawei.com>
> > > Cc: mst@redhat.com; willemdebruijn.kernel@gmail.com; kuba@kernel.org;
> > > davem@davemloft.net; magnus.karlsson@intel.com;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > kvm@vger.kernel.org; virtualization@lists.linux.dev; xudingke
> > > <xudingke@huawei.com>
> > > Subject: Re: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
> > >
> > > On Wed, Jan 24, 2024 at 5:38=E2=80=AFPM Yunjian Wang
> > <wangyunjian@huawei.com>
> > > wrote:
> > > >
> > > > Now the zero-copy feature of AF_XDP socket is supported by some
> > > > drivers, which can reduce CPU utilization on the xdp program.
> > > > This patch set allows tun to support AF_XDP Rx zero-copy feature.
> > > >
> > > > This patch tries to address this by:
> > > > - Use peek_len to consume a xsk->desc and get xsk->desc length.
> > > > - When the tun support AF_XDP Rx zero-copy, the vq's array maybe em=
pty.
> > > > So add a check for empty vq's array in vhost_net_buf_produce().
> > > > - add XDP_SETUP_XSK_POOL and ndo_xsk_wakeup callback support
> > > > - add tun_put_user_desc function to copy the Rx data to VM
> > >
> > > Code explains themselves, let's explain why you need to do this.
> > >
> > > 1) why you want to use peek_len
> > > 2) for "vq's array", what does it mean?
> > > 3) from the view of TUN/TAP tun_put_user_desc() is the TX path, so I
> > > guess you meant TX zerocopy instead of RX (as I don't see codes for
> > > RX?)
> >
> > OK, I agree and use TX zerocopy instead of RX zerocopy. I meant RX zero=
copy
> > from the view of vhost-net.
> >
> > >
> > > A big question is how could you handle GSO packets from userspace/gue=
sts?
> >
> > Now by disabling VM's TSO and csum feature. XDP does not support GSO
> > packets.
> > However, this feature can be added once XDP supports it in the future.
> >
> > >
> > > >
> > > > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > > > ---
> > > >  drivers/net/tun.c   | 165
> > > +++++++++++++++++++++++++++++++++++++++++++-
> > > >  drivers/vhost/net.c |  18 +++--
> > > >  2 files changed, 176 insertions(+), 7 deletions(-)
>
> [...]
>
> > > >
> > > >  static int peek_head_len(struct vhost_net_virtqueue *rvq, struct
> > > > sock
> > > > *sk)  {
> > > > +       struct socket *sock =3D sk->sk_socket;
> > > >         struct sk_buff *head;
> > > >         int len =3D 0;
> > > >         unsigned long flags;
> > > >
> > > > -       if (rvq->rx_ring)
> > > > -               return vhost_net_buf_peek(rvq);
> > > > +       if (rvq->rx_ring) {
> > > > +               len =3D vhost_net_buf_peek(rvq);
> > > > +               if (likely(len))
> > > > +                       return len;
> > > > +       }
> > > > +
> > > > +       if (sock->ops->peek_len)
> > > > +               return sock->ops->peek_len(sock);
> > >
> > > What prevents you from reusing the ptr_ring here? Then you don't need
> > > the above tricks.
> >
> > Thank you for your suggestion. I will consider how to reuse the ptr_rin=
g.
>
> If ptr_ring is used to transfer xdp_descs, there is a problem: After some
> xdp_descs are obtained through xsk_tx_peek_desc(), the descs may fail
> to be added to ptr_ring. However, no API is available to implement the
> rollback function.

I don't understand, this issue seems to exist in the physical NIC as well?

We get more descriptors than the free slots in the NIC ring.

How did other NIC solve this issue?

Thanks

>
> Thanks
>
> >
> > >
> > > Thanks
> > >
> > >
> > > >
> > > >         spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
> > > >         head =3D skb_peek(&sk->sk_receive_queue);
> > > > --
> > > > 2.33.0
> > > >
>



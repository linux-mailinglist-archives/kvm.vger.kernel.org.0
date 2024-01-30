Return-Path: <kvm+bounces-7407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BF484198A
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 03:49:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6D7F1C21D34
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 02:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F5D37159;
	Tue, 30 Jan 2024 02:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TwJRPVlz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252E7364DC
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 02:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706582939; cv=none; b=PlyWB7HeKq+PgMdp169y3lnQh0EvisQb4wfk4rv9YyR4Ws9z3Ax9h/y7agciTDVk8AatJSSoGxmCsUvf9+J102/7mnvoBV3eJzuBBcovn42cXHAJ4JSsw61IlMhctTY8okputpC6BmsTIfzbF69j0M9wjZx52PEL+Li0OnsQnx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706582939; c=relaxed/simple;
	bh=RLrbN+jjPHHaYWcRfFc4XP7MVZtSqRQZj3eLTMKo3no=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iaS3BiRNljiM0silJ0Yd8ZY8FMUFJjxdwkV39Ny9fJSsTqkP5FBk30MMHRTq7rF7tZbEgBDdNRQZ0z8yvKSU91S+ydFmvNk3rO3Ll8BZluPCZFSNBkBRMcapM1SxSG+Y9c4Zu51ptjs+fTIgdt9cUVtuU9jTAIIbZgSg3ddVjaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TwJRPVlz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706582936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P5cO6FStwdwziZKKBXyLpCsTpVBHHFcr/YapoZkDLqM=;
	b=TwJRPVlz/CN5UqTDNyKdfj3jYNAFAPiXPDZE3XOBRubz5b4oBj9ayUjY56DMrnE7EUN09r
	NQiQ3GcKgwRL6JcMPang+tsvgjDYJMM3o9DLjLTbQAuP6DTtN7Gn1eJx4WchFZV4SNexGq
	ZafAg62oz1CH1NgFEtpUblt2tyAY/OQ=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-6wgXSjcHOeSZbIB6Z4W_rg-1; Mon, 29 Jan 2024 21:48:54 -0500
X-MC-Unique: 6wgXSjcHOeSZbIB6Z4W_rg-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-59823dbe921so4079475eaf.1
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 18:48:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706582934; x=1707187734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P5cO6FStwdwziZKKBXyLpCsTpVBHHFcr/YapoZkDLqM=;
        b=Jkx2KXC0yt2qZqKKt5cbLvzU1tgzdQfQffdaQje+GChMKtR2GYkZ/W24Hzpq4mZehA
         fe+yxosk0+q2Jz8Juthu3JnAYaQQB+tYVKTOEzzuh7R9GeMCNcE9TQMil6OhitMIzzcL
         J/OmTeWu/VGCfJZ4OviUFlA8NH5orBQWMTEe05FPyhy5gbz3EFnDF/d0R/tt8CH60a8z
         Z6Yx2tPWXqdDqX4VBFtyCoCz0DLf4Nj3rWqdRbS2eGpxOvg7ijtPMLpqMwbHOwqE9Tcu
         0ayEqMywPu2aO7Y0ebq19zNzO5oI64pfu4GV3uQ1hOFh7dWmGmRU0WbOpJlpcTn8Hhny
         eqVw==
X-Gm-Message-State: AOJu0Yxj2D4edTEz9vIndLTJ+mg4ZZ76frilLReHI7YJlfMOSg1MG/aQ
	selBRUOrNWuKTuAf4KRxQBSv9cFrlDfImG6d2IL9ce4ZUchlUtKrPkzZVZ2Ds1CqGsHcLo5Ybx4
	9guAZDqNMg7hlSumuSfVpp45atoYk3wl461O23CQLiVTzIbB92gLgZ/Ctcrfl/MpW28/ds3RbL7
	ljr2ZyTMkMWfFhgjG0LPMYia/m
X-Received: by 2002:a05:6358:718c:b0:178:7807:4bb2 with SMTP id t12-20020a056358718c00b0017878074bb2mr2446235rwt.55.1706582933768;
        Mon, 29 Jan 2024 18:48:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFzxTpuO41EyUV2Zka33ihWGOtyrg5rppOWYknnW+1g0hIHW+zOCEVGnP7hTrZBcaRoa9j3a2mKPgn4Ftj/RFk=
X-Received: by 2002:a05:6358:718c:b0:178:7807:4bb2 with SMTP id
 t12-20020a056358718c00b0017878074bb2mr2446226rwt.55.1706582933528; Mon, 29
 Jan 2024 18:48:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
 <CACGkMEu5PaBgh37X4KysoF9YB8qy6jM5W4G6sm+8fjrnK36KXA@mail.gmail.com>
 <ad74a361d5084c62a89f7aa276273649@huawei.com> <156030296fea4f7abef6ab7155ba2e32@huawei.com>
 <CACGkMEuMTdr3NS=XdkN+XDRqiXouL2tWcXEk6-qTvOsm0JCc9Q@mail.gmail.com> <506f483f07eb41d0bbea58333ae0c933@huawei.com>
In-Reply-To: <506f483f07eb41d0bbea58333ae0c933@huawei.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 30 Jan 2024 10:48:42 +0800
Message-ID: <CACGkMEt6fvqrCLFhiPQU8cpXvOGhKj2Rg2sw1f39exCzW9fkSQ@mail.gmail.com>
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

On Mon, Jan 29, 2024 at 7:10=E2=80=AFPM wangyunjian <wangyunjian@huawei.com=
> wrote:
>
> > -----Original Message-----
> > From: Jason Wang [mailto:jasowang@redhat.com]
> > Sent: Monday, January 29, 2024 11:05 AM
> > To: wangyunjian <wangyunjian@huawei.com>
> > Cc: mst@redhat.com; willemdebruijn.kernel@gmail.com; kuba@kernel.org;
> > davem@davemloft.net; magnus.karlsson@intel.com; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> > virtualization@lists.linux.dev; xudingke <xudingke@huawei.com>
> > Subject: Re: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
> >
> > On Sat, Jan 27, 2024 at 5:34=E2=80=AFPM wangyunjian <wangyunjian@huawei=
.com>
> > wrote:
> > >
> > > > > -----Original Message-----
> > > > > From: Jason Wang [mailto:jasowang@redhat.com]
> > > > > Sent: Thursday, January 25, 2024 12:49 PM
> > > > > To: wangyunjian <wangyunjian@huawei.com>
> > > > > Cc: mst@redhat.com; willemdebruijn.kernel@gmail.com;
> > > > > kuba@kernel.org; davem@davemloft.net; magnus.karlsson@intel.com;
> > > > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > > > kvm@vger.kernel.org; virtualization@lists.linux.dev; xudingke
> > > > > <xudingke@huawei.com>
> > > > > Subject: Re: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy suppor=
t
> > > > >
> > > > > On Wed, Jan 24, 2024 at 5:38=E2=80=AFPM Yunjian Wang
> > > > <wangyunjian@huawei.com>
> > > > > wrote:
> > > > > >
> > > > > > Now the zero-copy feature of AF_XDP socket is supported by some
> > > > > > drivers, which can reduce CPU utilization on the xdp program.
> > > > > > This patch set allows tun to support AF_XDP Rx zero-copy featur=
e.
> > > > > >
> > > > > > This patch tries to address this by:
> > > > > > - Use peek_len to consume a xsk->desc and get xsk->desc length.
> > > > > > - When the tun support AF_XDP Rx zero-copy, the vq's array mayb=
e
> > empty.
> > > > > > So add a check for empty vq's array in vhost_net_buf_produce().
> > > > > > - add XDP_SETUP_XSK_POOL and ndo_xsk_wakeup callback support
> > > > > > - add tun_put_user_desc function to copy the Rx data to VM
> > > > >
> > > > > Code explains themselves, let's explain why you need to do this.
> > > > >
> > > > > 1) why you want to use peek_len
> > > > > 2) for "vq's array", what does it mean?
> > > > > 3) from the view of TUN/TAP tun_put_user_desc() is the TX path, s=
o
> > > > > I guess you meant TX zerocopy instead of RX (as I don't see codes
> > > > > for
> > > > > RX?)
> > > >
> > > > OK, I agree and use TX zerocopy instead of RX zerocopy. I meant RX
> > > > zerocopy from the view of vhost-net.
> > > >
> > > > >
> > > > > A big question is how could you handle GSO packets from
> > userspace/guests?
> > > >
> > > > Now by disabling VM's TSO and csum feature. XDP does not support GS=
O
> > > > packets.
> > > > However, this feature can be added once XDP supports it in the futu=
re.
> > > >
> > > > >
> > > > > >
> > > > > > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > > > > > ---
> > > > > >  drivers/net/tun.c   | 165
> > > > > +++++++++++++++++++++++++++++++++++++++++++-
> > > > > >  drivers/vhost/net.c |  18 +++--
> > > > > >  2 files changed, 176 insertions(+), 7 deletions(-)
> > >
> > > [...]
> > >
> > > > > >
> > > > > >  static int peek_head_len(struct vhost_net_virtqueue *rvq,
> > > > > > struct sock
> > > > > > *sk)  {
> > > > > > +       struct socket *sock =3D sk->sk_socket;
> > > > > >         struct sk_buff *head;
> > > > > >         int len =3D 0;
> > > > > >         unsigned long flags;
> > > > > >
> > > > > > -       if (rvq->rx_ring)
> > > > > > -               return vhost_net_buf_peek(rvq);
> > > > > > +       if (rvq->rx_ring) {
> > > > > > +               len =3D vhost_net_buf_peek(rvq);
> > > > > > +               if (likely(len))
> > > > > > +                       return len;
> > > > > > +       }
> > > > > > +
> > > > > > +       if (sock->ops->peek_len)
> > > > > > +               return sock->ops->peek_len(sock);
> > > > >
> > > > > What prevents you from reusing the ptr_ring here? Then you don't
> > > > > need the above tricks.
> > > >
> > > > Thank you for your suggestion. I will consider how to reuse the ptr=
_ring.
> > >
> > > If ptr_ring is used to transfer xdp_descs, there is a problem: After
> > > some xdp_descs are obtained through xsk_tx_peek_desc(), the descs may
> > > fail to be added to ptr_ring. However, no API is available to
> > > implement the rollback function.
> >
> > I don't understand, this issue seems to exist in the physical NIC as we=
ll?
> >
> > We get more descriptors than the free slots in the NIC ring.
> >
> > How did other NIC solve this issue?
>
> Currently, physical NICs such as i40e, ice, ixgbe, igc, and mlx5 obtains
> available NIC descriptors and then retrieve the same number of xsk
> descriptors for processing.

Any reason we can't do the same? ptr_ring should be much simpler than
NIC ring anyhow.

Thanks

>
> Thanks
>
> >
> > Thanks
> >
> > >
> > > Thanks
> > >
> > > >
> > > > >
> > > > > Thanks
> > > > >
> > > > >
> > > > > >
> > > > > >         spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
> > > > > >         head =3D skb_peek(&sk->sk_receive_queue);
> > > > > > --
> > > > > > 2.33.0
> > > > > >
> > >
>



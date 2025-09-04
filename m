Return-Path: <kvm+bounces-56720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FEAB42FFD
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:48:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78C187B357E
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 02:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583BA13D891;
	Thu,  4 Sep 2025 02:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZYtYqqZz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C5B3A8F7
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 02:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756954069; cv=none; b=R6DrJs2DcACh0Af9VWiKg0LDj37B6OaXsm3LV9tN7lv8WFspqkNk0y4/6HzMlSknSwrdoKKEHo9aHFETmvD7BliNTiTdqPFydJBd6LT9kNP1jp2wjENQevO7RQbJ+HngHKILHYSeW3v3CoLRVunehWqNjnG0L0CUcqim5/hebSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756954069; c=relaxed/simple;
	bh=Jq8qiDws42tS3DgBZxRymrwfYw1lrOAh8NEvTO9bXLM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N5/54JeinNNZwPG2RWN1MMkmiQtsFXP6UOL0okIqINrCrKqEXWTqR4ubmfYGKyJ8+kTlrEhlLR5ydvRBoYsmkTUXXisAMSkOZgUNGdljhgD/LZ5t8PYm161uknuuTjxF9OGdBgp0f2Cu9+ELhn8HiI3O07GWchEe3MAcLEqyJSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZYtYqqZz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756954067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nPuBzO5sFF7pz/Em0FpS2T39kkMf6PUBGHFAt6g8pC0=;
	b=ZYtYqqZzV2tKrE75TECDH5DU3YG1oNHyx2jQ1JnuVrsxo9p2QBsBWQhaLdrGC5eESUjq4k
	YqP/qA++mxxNiG3i/UTBqRJJhDvig+5xLRyQqxq49uAGj7ISjFAvcsA73E1J8A1Xm72Zro
	NS1sEwR3S6E/M1DgA45WTacL+65lakk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-9Zj2bF-BNKKHTuvnHiv59w-1; Wed, 03 Sep 2025 22:47:45 -0400
X-MC-Unique: 9Zj2bF-BNKKHTuvnHiv59w-1
X-Mimecast-MFC-AGG-ID: 9Zj2bF-BNKKHTuvnHiv59w_1756954065
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-324e41e946eso799011a91.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 19:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756954065; x=1757558865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPuBzO5sFF7pz/Em0FpS2T39kkMf6PUBGHFAt6g8pC0=;
        b=dqIubz/NXXC9hYEuA5AJw00ZmLaame6o2HSqXKbNjyIrHgKFoM5Mz2FST/S4l/qbN+
         xxeP6q1rucUOXVoOx9kWpy6cHjB1+9gVSCD8NxOYrsDPkoGASvl2YYujs7p/kgGT+hnp
         B4xnkGeVqGwi/8mvbiFY0C/PI530z5Kzas5UXq/6UazuRgcuR25oNPONMNHc+yMXYkj9
         6ZpjOLPonULcWN7itKUVJByI2avpnAFHDg2GuKUQnNdFXavaYNr11IKDHXY2G85gxI6M
         FJrH3P9DYoEmFcrycMNIElKEgdElmJKexfRMICji/Y5NOyCME53JwsU2BdmF4OUjlZPu
         u4iw==
X-Forwarded-Encrypted: i=1; AJvYcCX/np6XntiWv57B7cyry6zgcYMT/FmIU5gIP4H1M4GuQqhLKqW8b4B5LRL8fel6/XJP0V0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoUWlWGSVl6HuEf4eyRUMSWcqBHm+QIoSP7tqGZvyoQMqjZIPM
	KGomF+McehoG5gpA46T/gC2FERPROqPkLEWEjrdbB4/evdXdohzwgfwCatGeY6uZ4i6dPGqJ97T
	0OjDw6S2LJyVXbYnxXxycgs8A2TtdNPX/dwiRCSjiNeZxcg+105r+CBtZtTlzsIDB5HaJaL4rHA
	jK/1+ahbtEkwpR3vpGl3nVDrc3v/LI
X-Gm-Gg: ASbGncvz4qMshEid1kq+WhiMi2G8+qdnofo0fwzvpSealnsy2/cQIxGsg7rUbendbqp
	dclEgSIENA+ItBOHK5TWk4OgyH6Vx0fbPKkbAQv0flaX1PBo+WPUSH0a7FHMjeUOaeq7Ug5dKAN
	7nWJTy719+n+M/gtt+jTc=
X-Received: by 2002:a17:90b:2ecc:b0:329:e3dc:db6c with SMTP id 98e67ed59e1d1-329e3dcdc0bmr10993116a91.23.1756954064578;
        Wed, 03 Sep 2025 19:47:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkDHqgDH/M72TzEiUNO4/wpezo4wquRaQJWXdohPpca0lZdT3tIFYzQxV00AK8Pp2pJZe1TcsVp6WvFKCncjI=
X-Received: by 2002:a17:90b:2ecc:b0:329:e3dc:db6c with SMTP id
 98e67ed59e1d1-329e3dcdc0bmr10993085a91.23.1756954064125; Wed, 03 Sep 2025
 19:47:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-5-simon.schippers@tu-dortmund.de> <willemdebruijn.kernel.251eacee11eca@gmail.com>
 <CACGkMEshZGJfh+Og_xrPeZYoWkBAcvqW8e93_DCr7ix4oOaP8Q@mail.gmail.com> <willemdebruijn.kernel.372e97487ad8b@gmail.com>
In-Reply-To: <willemdebruijn.kernel.372e97487ad8b@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 4 Sep 2025 10:47:30 +0800
X-Gm-Features: Ac12FXxK8G6F5K9kP9hZAbVWxKTcqMiuodU5d2Yu_6h48rhPlNy4xjY3e_hnfFc
Message-ID: <CACGkMEtv+TKu+yBc_+WQsUj3UKqrRPvOVMGFDr7mB3zPHsW=wQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] netdev queue flow control for vhost_net
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>, mst@redhat.com, eperezma@redhat.com, 
	stephen@networkplumber.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, Tim Gebauer <tim.gebauer@tu-dortmund.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 3, 2025 at 9:52=E2=80=AFPM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Jason Wang wrote:
> > On Wed, Sep 3, 2025 at 5:31=E2=80=AFAM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > Simon Schippers wrote:
> > > > Stopping the queue is done in tun_net_xmit.
> > > >
> > > > Waking the queue is done by calling one of the helpers,
> > > > tun_wake_netdev_queue and tap_wake_netdev_queue. For that, in
> > > > get_wake_netdev_queue, the correct method is determined and saved i=
n the
> > > > function pointer wake_netdev_queue of the vhost_net_virtqueue. Then=
, each
> > > > time after consuming a batch in vhost_net_buf_produce, wake_netdev_=
queue
> > > > is called.
> > > >
> > > > Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > > > Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > > > Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> > > > ---
> > > >  drivers/net/tap.c      |  6 ++++++
> > > >  drivers/net/tun.c      |  6 ++++++
> > > >  drivers/vhost/net.c    | 34 ++++++++++++++++++++++++++++------
> > > >  include/linux/if_tap.h |  2 ++
> > > >  include/linux/if_tun.h |  3 +++
> > > >  5 files changed, 45 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> > > > index 4d874672bcd7..0bad9e3d59af 100644
> > > > --- a/drivers/net/tap.c
> > > > +++ b/drivers/net/tap.c
> > > > @@ -1198,6 +1198,12 @@ struct socket *tap_get_socket(struct file *f=
ile)
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(tap_get_socket);
> > > >
> > > > +void tap_wake_netdev_queue(struct file *file)
> > > > +{
> > > > +     wake_netdev_queue(file->private_data);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(tap_wake_netdev_queue);
> > > > +
> > > >  struct ptr_ring *tap_get_ptr_ring(struct file *file)
> > > >  {
> > > >       struct tap_queue *q;
> > > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > > index 735498e221d8..e85589b596ac 100644
> > > > --- a/drivers/net/tun.c
> > > > +++ b/drivers/net/tun.c
> > > > @@ -3739,6 +3739,12 @@ struct socket *tun_get_socket(struct file *f=
ile)
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(tun_get_socket);
> > > >
> > > > +void tun_wake_netdev_queue(struct file *file)
> > > > +{
> > > > +     wake_netdev_queue(file->private_data);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(tun_wake_netdev_queue);
> > >
> > > Having multiple functions with the same name is tad annoying from a
> > > cscape PoV, better to call the internal functions
> > > __tun_wake_netdev_queue, etc.
> > >
> > > > +
> > > >  struct ptr_ring *tun_get_tx_ring(struct file *file)
> > > >  {
> > > >       struct tun_file *tfile;
> > > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > > index 6edac0c1ba9b..e837d3a334f1 100644
> > > > --- a/drivers/vhost/net.c
> > > > +++ b/drivers/vhost/net.c
> > > > @@ -130,6 +130,7 @@ struct vhost_net_virtqueue {
> > > >       struct vhost_net_buf rxq;
> > > >       /* Batched XDP buffs */
> > > >       struct xdp_buff *xdp;
> > > > +     void (*wake_netdev_queue)(struct file *f);
> > >
> > > Indirect function calls are expensive post spectre. Probably
> > > preferable to just have a branch.
> > >
> > > A branch in `file->f_op !=3D &tun_fops` would be expensive still as i=
t
> > > may touch a cold cacheline.
> > >
> > > How about adding a bit in struct ptr_ring itself. Pahole shows plenty
> > > of holes. Jason, WDYT?
> > >
> >
> > I'm not sure I get the idea, did you mean a bit for classifying TUN
> > and TAP? If this is, I'm not sure it's a good idea as ptr_ring should
> > have no knowledge of its user.
>
> That is what I meant.
>
> > Consider there were still indirect calls to sock->ops, maybe we can
> > start from the branch.
>
> What do you mean?
>
> Tangential: if indirect calls really are needed in a hot path, e.g.,
> to maintain this isolation of ptr_ring from its users, then
> INDIRECT_CALL wrappers can be used to avoid the cost.
>
> That too effectively breaks the isolation between caller and callee.
> But only for the most important N callers that are listed in the
> INDIRECT_CALL_? wrapper.

Yes, I mean we can try to store the flag for example vhost_virtqueue struct=
.

Thanks

>



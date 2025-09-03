Return-Path: <kvm+bounces-56688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B939B4227A
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 15:52:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4792316AEB4
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 13:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE1F30DED8;
	Wed,  3 Sep 2025 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V6mqssND"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DDB308F02;
	Wed,  3 Sep 2025 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756907519; cv=none; b=ffvKM75vO6CZ2HQJLz2PhF34NVjeRyDfg5ERshyFENWJRc4v8zaeJjev5CicDJFtEOafOnUYGs8AhfW3piSDdzWzGlI5wNilgkxQnHA2EUBhFMCI+o31qLU+HI9dYMWVoem1M1oY1UeU8iFnz6+m2GbHVu05ybZ+YeRuAFd8Gt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756907519; c=relaxed/simple;
	bh=7C7Vprc6WxqGCYsdl0EetVroGpHV19XxLdEBnU9vA14=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=T7Gt/uptHiBsRP2N1b4Pn2cYHPJ0rmVc1+66bGNr97NKmI551xdh6O1toBRL8dboIoR88BUClap4t+B2fx6DxYVfXS46wT+cD2lKgTpQXVXme7iaehS/IeD3wEFpric3M2h7KNu9UZpJMcTsyiXMXw8276AJBDUfCXleloVGjNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V6mqssND; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7f6f367a248so571100585a.3;
        Wed, 03 Sep 2025 06:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756907517; x=1757512317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPdtlv7HxzVylpclcQP0fll3az3xTGmJG0SNLO2peok=;
        b=V6mqssNDj7gXkAgDGid9rgfECju6BO8jHITkLc28tlj4lyvoKS0okIK7pm9ieGH1sP
         kPZFQ5geActg5CTUrjsA7/f9IFW4nHMCcpegS8JICb0hA6tqA8ypg920m7JKmPiaPcdM
         7cA3yzQ4qwkS7YW+q0w47Ijoz4qefiBR+uG9INKw/VLlaf2Sm3L5MAdS8gX79F7eh3oV
         K8ZgDxeSq6bIlX9PzBG7RMO2934UbvJK7HaUS5Z/94fBuxOQYlsWcY5BWYbLP8W07dHO
         h9AKPI7QNvnBL04btI/SPGBCP8sAHZ0N4FCoZx+cctVTYcbNPmlUHgfA8PT1PqkO8iaS
         2qrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756907517; x=1757512317;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oPdtlv7HxzVylpclcQP0fll3az3xTGmJG0SNLO2peok=;
        b=Q0U99rsmTthWBrb1OGzg/w866SZi9NKZevtZPoftyyJ6oZgNtLxQ+LkRU7tQ3Cs4HR
         UuMVncu9q9uH/M5XYVyiEAFfJve1QAnfen4mWai2lKuCldGbRt3dFTuSiNMX1v5m4vZC
         Lzno1HQiq1LspuB7WVMZLocSVZmawerhYoU+e2seETTOgbzsZCBycSDWkuuYNDIgpNKi
         3xlYKwn+5gRiMqhFbqrLV88LRMgRfK0gazZWj3Wc/jf8nrlmznMEQxoMQWswfN7Q2OFQ
         5Kc6oWVTHqgDa0y7PJBz5bics7f2cZMaeOCL3e3ailBEu/Srg40LN9peIRMSwWrc8xVB
         Vqvg==
X-Forwarded-Encrypted: i=1; AJvYcCUaYpXp5SKsIrebVW5By+T50DXq9yXcJZS+JAH7h7eZoH8tH1XKkiYzQvd+y/8LpmB4Ln4=@vger.kernel.org, AJvYcCVREW1nUf8u3CVH8K3czEPl/IR/nhAsqtyYeT9XZwqrmQoECvGZiC9w1rpebfurog9wgrkTN2Y0@vger.kernel.org, AJvYcCWflvp6g36ZkIl1aJ2pWcddAFDB28iap0u6nFzWQHEgWFtxXgbPCYg+bioY3feZSA5gSc57GyAr040nHExA@vger.kernel.org
X-Gm-Message-State: AOJu0YxbJyRiBB6JRAfLqIGa/eHjxp+KKN0/V8EUELpBmN5BiBJJCnT/
	B3CWPzQVmQ1txFJxxLpLjYPd9h4Cps3knXO05kxe6xPXOM+xkH9OmF0o
X-Gm-Gg: ASbGnctwP/4oD9syq2gAj1zrOao/rEyNA9pkANLkTm3HvJEEKyUmY69sOMmHek6dhJD
	4bPcRkoYl6angxi8+/dC7YEFqtofJEHP3XDWz8WIFeHQT2uZIx0LALmCuUbWaplXnfYVuxxIV3p
	JlUl1oqbUPQ4rfvdF1d78GzrLQc5L5XK+LPZgZAvotH/7pZPPL8IxKmIB6xUMjaUEtu/uYG32d3
	H7EA9UBg/JPqFzGI+HpU/mW1Q2uZNx3xlWSmoNrUgxKUM7WgZLpy1BiWjcO5PhhaLOq/qQEjz3z
	y3nephMvYNLGTWN7/ZXZSk0e3+Nr5g+lWKgwwJ0EaSqx9XnbHBRmoThydAdIpzmdi1QxKdn8yfJ
	DGhpc5KmuB1S8HT4i/fDAwPAHo4zY1BKYXMuGtFhAn1axVRuSGf2XoHt/l/NRHCGTSWRdLVcUj9
	tgbNOqAxRGtYAT
X-Google-Smtp-Source: AGHT+IHd5QO8rXHYKVepHmXV1bdJPpjQGcBtqXOELN9+bo/yCZVPywfEO7HQeg7wtxFmypA4bZ1CMQ==
X-Received: by 2002:a05:620a:1a21:b0:7f3:62f3:32b1 with SMTP id af79cd13be357-7ff26eaadf7mr1574330785a.1.1756907516825;
        Wed, 03 Sep 2025 06:51:56 -0700 (PDT)
Received: from gmail.com (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-80aa78f2affsm108414785a.30.2025.09.03.06.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 06:51:56 -0700 (PDT)
Date: Wed, 03 Sep 2025 09:51:55 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Jason Wang <jasowang@redhat.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>, 
 mst@redhat.com, 
 eperezma@redhat.com, 
 stephen@networkplumber.org, 
 netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 virtualization@lists.linux.dev, 
 kvm@vger.kernel.org, 
 Tim Gebauer <tim.gebauer@tu-dortmund.de>
Message-ID: <willemdebruijn.kernel.372e97487ad8b@gmail.com>
In-Reply-To: <CACGkMEshZGJfh+Og_xrPeZYoWkBAcvqW8e93_DCr7ix4oOaP8Q@mail.gmail.com>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-5-simon.schippers@tu-dortmund.de>
 <willemdebruijn.kernel.251eacee11eca@gmail.com>
 <CACGkMEshZGJfh+Og_xrPeZYoWkBAcvqW8e93_DCr7ix4oOaP8Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] netdev queue flow control for vhost_net
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jason Wang wrote:
> On Wed, Sep 3, 2025 at 5:31=E2=80=AFAM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > Simon Schippers wrote:
> > > Stopping the queue is done in tun_net_xmit.
> > >
> > > Waking the queue is done by calling one of the helpers,
> > > tun_wake_netdev_queue and tap_wake_netdev_queue. For that, in
> > > get_wake_netdev_queue, the correct method is determined and saved i=
n the
> > > function pointer wake_netdev_queue of the vhost_net_virtqueue. Then=
, each
> > > time after consuming a batch in vhost_net_buf_produce, wake_netdev_=
queue
> > > is called.
> > >
> > > Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > > Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > > Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> > > ---
> > >  drivers/net/tap.c      |  6 ++++++
> > >  drivers/net/tun.c      |  6 ++++++
> > >  drivers/vhost/net.c    | 34 ++++++++++++++++++++++++++++------
> > >  include/linux/if_tap.h |  2 ++
> > >  include/linux/if_tun.h |  3 +++
> > >  5 files changed, 45 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> > > index 4d874672bcd7..0bad9e3d59af 100644
> > > --- a/drivers/net/tap.c
> > > +++ b/drivers/net/tap.c
> > > @@ -1198,6 +1198,12 @@ struct socket *tap_get_socket(struct file *f=
ile)
> > >  }
> > >  EXPORT_SYMBOL_GPL(tap_get_socket);
> > >
> > > +void tap_wake_netdev_queue(struct file *file)
> > > +{
> > > +     wake_netdev_queue(file->private_data);
> > > +}
> > > +EXPORT_SYMBOL_GPL(tap_wake_netdev_queue);
> > > +
> > >  struct ptr_ring *tap_get_ptr_ring(struct file *file)
> > >  {
> > >       struct tap_queue *q;
> > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > index 735498e221d8..e85589b596ac 100644
> > > --- a/drivers/net/tun.c
> > > +++ b/drivers/net/tun.c
> > > @@ -3739,6 +3739,12 @@ struct socket *tun_get_socket(struct file *f=
ile)
> > >  }
> > >  EXPORT_SYMBOL_GPL(tun_get_socket);
> > >
> > > +void tun_wake_netdev_queue(struct file *file)
> > > +{
> > > +     wake_netdev_queue(file->private_data);
> > > +}
> > > +EXPORT_SYMBOL_GPL(tun_wake_netdev_queue);
> >
> > Having multiple functions with the same name is tad annoying from a
> > cscape PoV, better to call the internal functions
> > __tun_wake_netdev_queue, etc.
> >
> > > +
> > >  struct ptr_ring *tun_get_tx_ring(struct file *file)
> > >  {
> > >       struct tun_file *tfile;
> > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > index 6edac0c1ba9b..e837d3a334f1 100644
> > > --- a/drivers/vhost/net.c
> > > +++ b/drivers/vhost/net.c
> > > @@ -130,6 +130,7 @@ struct vhost_net_virtqueue {
> > >       struct vhost_net_buf rxq;
> > >       /* Batched XDP buffs */
> > >       struct xdp_buff *xdp;
> > > +     void (*wake_netdev_queue)(struct file *f);
> >
> > Indirect function calls are expensive post spectre. Probably
> > preferable to just have a branch.
> >
> > A branch in `file->f_op !=3D &tun_fops` would be expensive still as i=
t
> > may touch a cold cacheline.
> >
> > How about adding a bit in struct ptr_ring itself. Pahole shows plenty=

> > of holes. Jason, WDYT?
> >
> =

> I'm not sure I get the idea, did you mean a bit for classifying TUN
> and TAP? If this is, I'm not sure it's a good idea as ptr_ring should
> have no knowledge of its user.

That is what I meant.
 =

> Consider there were still indirect calls to sock->ops, maybe we can
> start from the branch.

What do you mean?

Tangential: if indirect calls really are needed in a hot path, e.g.,
to maintain this isolation of ptr_ring from its users, then
INDIRECT_CALL wrappers can be used to avoid the cost.

That too effectively breaks the isolation between caller and callee.
But only for the most important N callers that are listed in the
INDIRECT_CALL_? wrapper.


Return-Path: <kvm+bounces-56657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2810B4130A
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 05:42:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F2E57B3A23
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 03:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D572D0621;
	Wed,  3 Sep 2025 03:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DXzUqY8a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD7B2C3757
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 03:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756870938; cv=none; b=dO54zw9xMxD9KyFdPlMqZQ9SgDO/yFU3FCBB1bQAJITeryNhk2zqMe9jkXC49zU002EaB/heDWm0Shw1vlVkYevu4LZkEYETJnmGBt76vc/QOArqgi9hZTOOZlGOs7sC+hBd7esG13WcKqAA6UqoOip3rzBLgEVOwa/iS/Q46YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756870938; c=relaxed/simple;
	bh=9ESXmPmINNSXqQlz86ZJuKHZQigQluf5ycGSPQZVgNM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fNijzZjZCtvr7pEjmVhji+AJlzZ3Q7czLHN7EadGyJV0bwWhF3mLMxtbL2thW1UOZlfAuP9AYBWLkkNzzyAKik+p36aWF55hy9mOPirMUabWx2w04nCJCYkw0P6qK5SuHObpQWwWNJJdl67c5KsE/xXvZqp/n3sE5WGID5oghzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DXzUqY8a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756870935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=21HGKhCy/iaEYJrBJUDnVhz1RoV8QBoCOIAY2Tt+uVI=;
	b=DXzUqY8alLSdhoFs2wccPZYGcjhKa8AO8R0MW/kFruP192xAQkxXnfWlcXLeyUTdWotay4
	SHbaZkzMaovIF4BjWE0XGIGaDLo6htNppWVnwIxH5NlaT+mSteQWm/+AbJKib79Qp/pw7U
	DfD4zj5kNt+ht82lQSIKBCg9v+b6sIQ=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-he2AnJQ2NLq9cW9mE5sCzQ-1; Tue, 02 Sep 2025 23:42:14 -0400
X-MC-Unique: he2AnJQ2NLq9cW9mE5sCzQ-1
X-Mimecast-MFC-AGG-ID: he2AnJQ2NLq9cW9mE5sCzQ_1756870933
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-76e2eb787f2so6661737b3a.3
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 20:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756870933; x=1757475733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21HGKhCy/iaEYJrBJUDnVhz1RoV8QBoCOIAY2Tt+uVI=;
        b=DX+bsWO817FcNeNlf2rSpKeV7Bv1ulmiPV5Xb3e4zGQD/v38ZnyTIZydlRW018YJWh
         fNu2j+uBSYjYwNRuyxosGHeLzIymi1Xdgdk+mtnrzTpoOWI99NuJZ8te7DSL/ZDkVQup
         XMXXHTJS2jEXpKiiZvSta+rQ4TGWcVbHaylJUd+7lyFaXWrUtMmwwS5pLoZ2dVpmW5Ng
         YqkxS2SoXXGlTeVdd0SDMb5YqQ4LbfqwPDfzZC7PTmZP6m4lU4fsIs3vwVyyDe3ioyOb
         jRJPJVwi+KTT+MGiHFyAnBS4ofZIOgXV16LBWT0gzU/YZIbov+q651weJVTbJQ/xwBJb
         J9iw==
X-Forwarded-Encrypted: i=1; AJvYcCVOLQUAzfH6VizoDci/xGWwQGlwn/KC84qXENlGgY3j1wDKwZq7bDqb+QMe5dWBFRUnHQc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTub3wusprLoMRTPcbFBsYUAIWEyNoNtxcyRgZCXKyHR/9XMdb
	jvCxmF5cxEg1qgnz9aWydO8k1NwlpW7zScMZYpfp7opNs7S8Vzg0n5nlv4PVu5kpug1YUDQBsmP
	mQmdAtqnrT2LPQ9p125Y757dNkvgj2+Hnu1vvF2V8lcQGZKrnH+zcc4MOUds4del4CHvGjSjZzF
	5B3W6fgLNCHnTljac14P4GVLtmQnto
X-Gm-Gg: ASbGncs0XXArnQrrug6PK1aFqNu8c4HSh43NXC8FflMAmLmJiKWhDrrC96Y1ZYnAaSC
	8lnsSe4V8wHpaJ/Vdzrdt47i3XubKg21SMcRHT/tcoz822O5o0hMB6VDIvV5Z/OVM1Up+q6vD/Y
	Ux3mld/ersD8S/MkyIe/grTg==
X-Received: by 2002:a05:6a21:6d9a:b0:243:af34:8f80 with SMTP id adf61e73a8af0-243d6f0a00emr19321156637.33.1756870933322;
        Tue, 02 Sep 2025 20:42:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHanPhMKl5ZAvm2Qhwq+QdEgtJZ1BCJ/V8a82/77JVVc+iCktfnjs8inL16NihNJNK30sMh1UDZ/nyoOaphFLk=
X-Received: by 2002:a05:6a21:6d9a:b0:243:af34:8f80 with SMTP id
 adf61e73a8af0-243d6f0a00emr19321122637.33.1756870932854; Tue, 02 Sep 2025
 20:42:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-5-simon.schippers@tu-dortmund.de> <willemdebruijn.kernel.251eacee11eca@gmail.com>
In-Reply-To: <willemdebruijn.kernel.251eacee11eca@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 3 Sep 2025 11:42:01 +0800
X-Gm-Features: Ac12FXy-ZAK0_-Slu353Uz-vG-bLNLE-4F6AXp-hkWEm5GXoed80DFu99UnucK8
Message-ID: <CACGkMEshZGJfh+Og_xrPeZYoWkBAcvqW8e93_DCr7ix4oOaP8Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] netdev queue flow control for vhost_net
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>, mst@redhat.com, eperezma@redhat.com, 
	stephen@networkplumber.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, Tim Gebauer <tim.gebauer@tu-dortmund.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 3, 2025 at 5:31=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Simon Schippers wrote:
> > Stopping the queue is done in tun_net_xmit.
> >
> > Waking the queue is done by calling one of the helpers,
> > tun_wake_netdev_queue and tap_wake_netdev_queue. For that, in
> > get_wake_netdev_queue, the correct method is determined and saved in th=
e
> > function pointer wake_netdev_queue of the vhost_net_virtqueue. Then, ea=
ch
> > time after consuming a batch in vhost_net_buf_produce, wake_netdev_queu=
e
> > is called.
> >
> > Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> > ---
> >  drivers/net/tap.c      |  6 ++++++
> >  drivers/net/tun.c      |  6 ++++++
> >  drivers/vhost/net.c    | 34 ++++++++++++++++++++++++++++------
> >  include/linux/if_tap.h |  2 ++
> >  include/linux/if_tun.h |  3 +++
> >  5 files changed, 45 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> > index 4d874672bcd7..0bad9e3d59af 100644
> > --- a/drivers/net/tap.c
> > +++ b/drivers/net/tap.c
> > @@ -1198,6 +1198,12 @@ struct socket *tap_get_socket(struct file *file)
> >  }
> >  EXPORT_SYMBOL_GPL(tap_get_socket);
> >
> > +void tap_wake_netdev_queue(struct file *file)
> > +{
> > +     wake_netdev_queue(file->private_data);
> > +}
> > +EXPORT_SYMBOL_GPL(tap_wake_netdev_queue);
> > +
> >  struct ptr_ring *tap_get_ptr_ring(struct file *file)
> >  {
> >       struct tap_queue *q;
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index 735498e221d8..e85589b596ac 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -3739,6 +3739,12 @@ struct socket *tun_get_socket(struct file *file)
> >  }
> >  EXPORT_SYMBOL_GPL(tun_get_socket);
> >
> > +void tun_wake_netdev_queue(struct file *file)
> > +{
> > +     wake_netdev_queue(file->private_data);
> > +}
> > +EXPORT_SYMBOL_GPL(tun_wake_netdev_queue);
>
> Having multiple functions with the same name is tad annoying from a
> cscape PoV, better to call the internal functions
> __tun_wake_netdev_queue, etc.
>
> > +
> >  struct ptr_ring *tun_get_tx_ring(struct file *file)
> >  {
> >       struct tun_file *tfile;
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index 6edac0c1ba9b..e837d3a334f1 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -130,6 +130,7 @@ struct vhost_net_virtqueue {
> >       struct vhost_net_buf rxq;
> >       /* Batched XDP buffs */
> >       struct xdp_buff *xdp;
> > +     void (*wake_netdev_queue)(struct file *f);
>
> Indirect function calls are expensive post spectre. Probably
> preferable to just have a branch.
>
> A branch in `file->f_op !=3D &tun_fops` would be expensive still as it
> may touch a cold cacheline.
>
> How about adding a bit in struct ptr_ring itself. Pahole shows plenty
> of holes. Jason, WDYT?
>

I'm not sure I get the idea, did you mean a bit for classifying TUN
and TAP? If this is, I'm not sure it's a good idea as ptr_ring should
have no knowledge of its user.

Consider there were still indirect calls to sock->ops, maybe we can
start from the branch.

Thanks



Return-Path: <kvm+bounces-58117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72299B8826B
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32627524EDC
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 07:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 788962D191F;
	Fri, 19 Sep 2025 07:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NC6V1qvM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035DD2D1303
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 07:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758266755; cv=none; b=nB1QobPoJltUTjZNTihS01KDE1FweMLEeJkLKNdHYyD5pY4aHpn4FenPradRg3HjAY5ACXL80sZPjVmiNA6cIPFoWRJwnSFEvZrq2bV4QsCkkOT5opmvJLDenKKhFDX8ffbsbPGtEgo0Vdq5LyNxWWoEUofUM8maW7k0KpSt4oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758266755; c=relaxed/simple;
	bh=zkVkIoUOl03T+4kpYux31FAUF2pWUEphOE/XLbf//wU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UIHPydFty0mSZbEoWVgCQd8NooHCr7Y4Wfbea4uDNGQvTqzoTxF4whzlrnnhwi6dSH1t1on5uXhBhsiCvS/OZw/9gjdNrt3Tlb8uCiwCmu0ysuKKmGPVNATSoFoEpUWsoIcntLCRUrzSthi4QtfFPrGeS+hVMczjY57Evfswu/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NC6V1qvM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758266752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6bM94/nnEI8nwvokemjQlvg6Nu4kwWN6AkIyeAjLPwg=;
	b=NC6V1qvMHt5vyz+waxYjs2FNOPYCr3YBOomw4oVt6zstIdQoX4FKk3B5GruItjBq5UgK1+
	gxCypGDYvV3eUVg65fpM0f0rfxgPdSsuOl6aAF4+CU5r2qhAkZT6Vz9zIcl93zXuVpqcIz
	6yoZZ4WZvyI0ypykVANGXRXorWJq5sY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-rDLGM7UbOYqp9O6vRxT4gg-1; Fri, 19 Sep 2025 03:25:45 -0400
X-MC-Unique: rDLGM7UbOYqp9O6vRxT4gg-1
X-Mimecast-MFC-AGG-ID: rDLGM7UbOYqp9O6vRxT4gg_1758266744
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-32df881dce2so1842018a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758266744; x=1758871544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6bM94/nnEI8nwvokemjQlvg6Nu4kwWN6AkIyeAjLPwg=;
        b=feYmJFVOfRMnrbrrVO+w6B/Chw9UOHNxyylvif4cZB4EzRLfQNjv9RZa9QGWJrt5gs
         S8mO7F1hiJiyALuIovm4OHThkPotR7MSyXoCwmjRPbeijJoLcmxCoDCn1dAzWaxeHX5K
         xf7Yumw5hEgM7WjpvhFY2LGq9V/TNumdgrPFLJ6IOH+tWb4VdOPhDGT9qXVuXemaQ5Xh
         XtM7XUijRrBL2ovQOfbrP/ceReCotJtPnSEb7SVRFbPHSoA9kzUoW6dzFPxAqgT9aEpP
         HPbUik/tPs9IgNpaUKlHw8Vr1bCbz8LwAkQHLRGKvfVZVzKkIPRasZ5PyC67aiMqGxjG
         0x+g==
X-Forwarded-Encrypted: i=1; AJvYcCVIsasFNkLpZN8WbyRaA7uaERTQ2LBSU2LD6up7hb56aSv5OmOhv4A15xN/UFACcrMbwzw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8ejgaLcMXANyOpu9hCWpuJxA02NDR1/00fpRNmCuyaW/YsY3E
	OOqxtFYImVbrVjg1/bIM54C39RuIhE5sL//A8yk0bpGXXfEl2WtBGtYq4lgvHumdGkuOt+LfUix
	n569ryPZ4Tn/WBeOval+79QAyzw0zs+wMGTQWwKU5R7vP7Xve4A1Ljyo3mTOWTGtmDeZs1mklxS
	OeZCXWPVM43+4swaTQqIMfV7FEVHCM
X-Gm-Gg: ASbGncvI6kXr3NNE+PkGZ5rdg5C24ds+sYVodsPAcGMKjKKY3Tjy/VxNF4+Te+N8l6v
	efkTDddO9d78b1eEaDiCvult9IaFYf3xrbnfiHSDa2riN/CmK8j6a31gZ60IpO+JeDihcoy7u+P
	s1lj8seVEJ1iagzIPyxmF/ZQ==
X-Received: by 2002:a17:90b:4d:b0:321:9366:5865 with SMTP id 98e67ed59e1d1-3309838e07dmr3146550a91.33.1758266744220;
        Fri, 19 Sep 2025 00:25:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHioX/aUb/kf3X7YbtUfx1ZTiAhYMo4GyJt6XgUNBRLxjMQjBMLN0ziU1pYTAvo5cwkJNciXxXsSL6B3HEhWEE=
X-Received: by 2002:a17:90b:4d:b0:321:9366:5865 with SMTP id
 98e67ed59e1d1-3309838e07dmr3146523a91.33.1758266743790; Fri, 19 Sep 2025
 00:25:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917063045.2042-1-jasowang@redhat.com> <20250918105037-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250918105037-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 19 Sep 2025 15:25:32 +0800
X-Gm-Features: AS18NWCuouHf_lzYXemPvsvzosa6Qbb26dhl00LIb1AvW_Yc0kDUxptSh5xarsQ
Message-ID: <CACGkMEsUb0sXqt8yRwnNfhgmqWKm1nkMNYfgxSgz-5CtE3CSUA@mail.gmail.com>
Subject: Re: [PATCH vhost 1/3] vhost-net: unbreak busy polling
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: eperezma@redhat.com, jonah.palmer@oracle.com, kuba@kernel.org, 
	jon@nutanix.com, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 10:52=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com=
> wrote:
>
> On Wed, Sep 17, 2025 at 02:30:43PM +0800, Jason Wang wrote:
> > Commit 67a873df0c41 ("vhost: basic in order support") pass the number
> > of used elem to vhost_net_rx_peek_head_len() to make sure it can
> > signal the used correctly before trying to do busy polling. But it
> > forgets to clear the count, this would cause the count run out of sync
> > with handle_rx() and break the busy polling.
> >
> > Fixing this by passing the pointer of the count and clearing it after
> > the signaling the used.
> >
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 67a873df0c41 ("vhost: basic in order support")
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
>
> I queued this but no promises this gets into this release - depending
> on whether there is another rc or no. I had the console revert which
> I wanted in this release and don't want it to be held up.
>

I see.

> for the future, I expect either a cover letter explaining
> what unites the patchset, or just separate patches.

Ok.

Thanks

>
> > ---
> >  drivers/vhost/net.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index c6508fe0d5c8..16e39f3ab956 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -1014,7 +1014,7 @@ static int peek_head_len(struct vhost_net_virtque=
ue *rvq, struct sock *sk)
> >  }
> >
> >  static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct so=
ck *sk,
> > -                                   bool *busyloop_intr, unsigned int c=
ount)
> > +                                   bool *busyloop_intr, unsigned int *=
count)
> >  {
> >       struct vhost_net_virtqueue *rnvq =3D &net->vqs[VHOST_NET_VQ_RX];
> >       struct vhost_net_virtqueue *tnvq =3D &net->vqs[VHOST_NET_VQ_TX];
> > @@ -1024,7 +1024,8 @@ static int vhost_net_rx_peek_head_len(struct vhos=
t_net *net, struct sock *sk,
> >
> >       if (!len && rvq->busyloop_timeout) {
> >               /* Flush batched heads first */
> > -             vhost_net_signal_used(rnvq, count);
> > +             vhost_net_signal_used(rnvq, *count);
> > +             *count =3D 0;
> >               /* Both tx vq and rx socket were polled here */
> >               vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, true);
> >
> > @@ -1180,7 +1181,7 @@ static void handle_rx(struct vhost_net *net)
> >
> >       do {
> >               sock_len =3D vhost_net_rx_peek_head_len(net, sock->sk,
> > -                                                   &busyloop_intr, cou=
nt);
> > +                                                   &busyloop_intr, &co=
unt);
> >               if (!sock_len)
> >                       break;
> >               sock_len +=3D sock_hlen;
> > --
> > 2.34.1
>



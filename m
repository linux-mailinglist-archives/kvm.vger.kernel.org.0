Return-Path: <kvm+bounces-49569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDC5DADA69D
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 05:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4540B1890604
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 03:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2F528D8EE;
	Mon, 16 Jun 2025 03:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PkQvzwzR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0676A482FF
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 03:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750042919; cv=none; b=Z65K9fmbzeZBQLOSCvg43d1mLWVlS4VLMEbHd1HzFAz4ZUi/pxA7vHZqG0mdLDk9c+V+9t3uwuSDZ625nOHDNA07AZ/3AJ54J7kNUZce/FdkOHAUsD77GgRn81cdsUPUakGA/hmewiLlsQ2wjgb07bHYvw5aL8kbikbJqPaAOkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750042919; c=relaxed/simple;
	bh=82AhWuVQoAuMPbM6xTSjCUZ/9oJnawVRvPBYrGktsSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MCrBZGPKyOVWT6oaLGYB9PrkthYSuEzlod1aSSrJqjKw6CveflsmxK20KxrzniXdUb8y7KhCvq0fIodxxULgVO5RJh579oz4N2c0OtGOMUV1BvocT1O6h5hVrrlT/4YdeLEZof/ZW0UtFk3mwcdWtBWNcrlCOM+Lh3Z6ubCOS6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PkQvzwzR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750042916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vCKkRtoSzZbTAPs+ac64tFtNoEnWSOUuabd/mn0iDV4=;
	b=PkQvzwzRhQKMe2EtD+gHjF56hpJmJ3rjGRNeDte0T/qY99twS2y8hEvNFliFCWB5IVf3uw
	aKZl6rnPaKmOjsMtVebiCj5ViNGcZxGwFQtF48ThLLMVT9a3PkcLfRe8hISHZmhhg4NrOc
	N0aArv36RtyBXnIn6HpDcWmusHWV5F4=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-xjydjAc5PsaTsZ-lyPmmBA-1; Sun, 15 Jun 2025 23:01:55 -0400
X-MC-Unique: xjydjAc5PsaTsZ-lyPmmBA-1
X-Mimecast-MFC-AGG-ID: xjydjAc5PsaTsZ-lyPmmBA_1750042914
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3138f5e8ff5so3881455a91.3
        for <kvm@vger.kernel.org>; Sun, 15 Jun 2025 20:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750042914; x=1750647714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCKkRtoSzZbTAPs+ac64tFtNoEnWSOUuabd/mn0iDV4=;
        b=CnGMtD/gsIJBKSSNvS1w0EE+jEUpE4VP5Q0z7B11Xq4m6WKH17K8prZB+NTLIohaPD
         73xc/SN9o8Rzhs4+o3hZ0sHRk9eeBabQ34MH6069NlefOnTjgxfLbgkRkMaprUrx1guf
         7qmMfIy2/HoWqhrtRGUHdknX6/Rt0PTNcEezktfc2jaZtcFirsdem8euXtg3rZj8JVPL
         gytLMXJ5WzrGILsvTbNS8janVR7856HX5EWdQl7zDXxNhHDxdrcUvaxBSSae6GNLlRg9
         NJ+7JT/YU9JJIbxounAZRUJ3pPP6Gy7ZRgrekTlQ0kqZX3sVSpNSCcje+MzoQw+BX+eH
         ZR4w==
X-Forwarded-Encrypted: i=1; AJvYcCWJB0CI1namahLvmvm0NYcMBH7jkaiZ9GjFLAcPTHGjf+dFgx30IPh6TDunG95/2UbH7Eg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzOF/chzxvOxiTIaUdeARdQ8t9JfyZhPUtoiR3YMMTrFfwf8Vm
	X/YTCfWEm1BpEc1PTfhpYNpORlkV8mwhUtFVIxzDL3jxEbMfSPXDkGPKu4a7DMEtM0UXEQ58KyJ
	GYcAsrIjQh2xlPR7TYoXrSA+P+LWUK8cHlSvZiScpiW0rX4yrpxnftSv1atfo8PJBYTjH90QUm+
	juHmt5OHtgN/0VZchJKdKRd5Xks42A
X-Gm-Gg: ASbGncvOIAhub9+UGh+c1c8DAU1iQqOG2g/S/dF1WrtxxwNTbnjGrTtnrV1d0QvhVzC
	gvNmLZSfyzTxTLjQ457UB3Jm//4BpA3atXqTsDnH4MZlZbFqO3rqpxl+uanOkig25vC+v04Bfny
	q/UA==
X-Received: by 2002:a17:90b:4c09:b0:311:c939:c851 with SMTP id 98e67ed59e1d1-313f1ca12edmr11875512a91.4.1750042914292;
        Sun, 15 Jun 2025 20:01:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDgoqXu/ryVb1qiAXAGjdpMZc6vHNXfms6UXRPPQBfj+M9c5as5mZfMjZanre+4SB2mOQj6vOqZlGwhMGx3nQ=
X-Received: by 2002:a17:90b:4c09:b0:311:c939:c851 with SMTP id
 98e67ed59e1d1-313f1ca12edmr11875456a91.4.1750042913801; Sun, 15 Jun 2025
 20:01:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250612083213.2704-1-jasowang@redhat.com> <20250612083213.2704-2-jasowang@redhat.com>
 <684b89de38e3_dcc452944e@willemb.c.googlers.com.notmuch>
In-Reply-To: <684b89de38e3_dcc452944e@willemb.c.googlers.com.notmuch>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 16 Jun 2025 11:01:41 +0800
X-Gm-Features: AX0GCFsoBTIoj8eDkU_o6slNuA7yTes0y0TTyhZGfKJwDR3Xf-iokYyjHozULQs
Message-ID: <CACGkMEsKTLfD1nz-CQdn5+ZmxyWdVDwhBOAcB9fO4TUcwzuLPA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] vhost-net: reduce one userspace copy when
 building XDP buff
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, davem@davemloft.net, 
	andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2025 at 10:16=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Jason Wang wrote:
> > We used to do twice copy_from_iter() to copy virtio-net and packet
> > separately. This introduce overheads for userspace access hardening as
> > well as SMAP (for x86 it's stac/clac). So this patch tries to use one
> > copy_from_iter() to copy them once and move the virtio-net header
> > afterwards to reduce overheads.
> >
> > Testpmd + vhost_net shows 10% improvement from 5.45Mpps to 6.0Mpps.
> >
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
>
> Acked-by: Willem de Bruijn <willemb@google.com>
>
> > ---
> >  drivers/vhost/net.c | 13 ++++---------
> >  1 file changed, 4 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index 777eb6193985..2845e0a473ea 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -690,13 +690,13 @@ static int vhost_net_build_xdp(struct vhost_net_v=
irtqueue *nvq,
> >       if (unlikely(!buf))
> >               return -ENOMEM;
> >
> > -     copied =3D copy_from_iter(buf, sock_hlen, from);
> > -     if (copied !=3D sock_hlen) {
> > +     copied =3D copy_from_iter(buf + pad - sock_hlen, len, from);
> > +     if (copied !=3D len) {
> >               ret =3D -EFAULT;
> >               goto err;
> >       }
> >
> > -     gso =3D buf;
> > +     gso =3D buf + pad - sock_hlen;
> >
> >       if (!sock_hlen)
> >               memset(buf, 0, pad);
> > @@ -715,12 +715,7 @@ static int vhost_net_build_xdp(struct vhost_net_vi=
rtqueue *nvq,
> >               }
> >       }
> >
> > -     len -=3D sock_hlen;
> > -     copied =3D copy_from_iter(buf + pad, len, from);
> > -     if (copied !=3D len) {
> > -             ret =3D -EFAULT;
> > -             goto err;
> > -     }
> > +     memcpy(buf, buf + pad - sock_hlen, sock_hlen);
>
> It's not trivial to see that the dst and src do not overlap, and does
> does not need memmove.
>
> Minimal pad that I can find is 32B and and maximal sock_hlen is 12B.
>
> So this is safe. But not obviously so. Unfortunately, these offsets
> are not all known at compile time, so a BUILD_BUG_ON is not possible.

We had this:

int pad =3D SKB_DATA_ALIGN(VHOST_NET_RX_PAD + headroom + nvq->sock_hlen);
int sock_hlen =3D nvq->sock_hlen;

So pad - sock_len is guaranteed to be greater than zero.

If this is not obvious, I can add a comment in the next version.

Thanks

>
> >       xdp_init_buff(xdp, buflen, NULL);
> >       xdp_prepare_buff(xdp, buf, pad, len, true);
> > --
> > 2.34.1
> >
>
>



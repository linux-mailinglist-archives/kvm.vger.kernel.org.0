Return-Path: <kvm+bounces-64917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C125C90A4B
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 03:40:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E27114E3229
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 02:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE51427F19F;
	Fri, 28 Nov 2025 02:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dtp8CLyy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WUBPBups"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D1415B971
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 02:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764297614; cv=none; b=OIItQQF7kkGXSQQeK6J8ibFsUONyvBL2SP2AxPGntk3SD/gLt4I/+fAUZX1Q7aZL0IFcDsXPWY7Z2nh1eqhCXpRe4uz3m4p1IcATIVAjmMtu4iPnLXf/kbjpihnQtDvePf0h9fvrxFySvV7z+9OBcyj2u3JmuAk4RVi3DEpbvVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764297614; c=relaxed/simple;
	bh=nqBlYAzg6qxQEMzgk9fJKhYVwAMlfJjMd6zbIrDkIsA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PRkrBOlLUqhSPE3OGyyXc9Oafdr8G6VB2YDQjEeqztWMKiqozeHwnZ4mbxLD24viFeU8b/inAuMLaEd+0hbuxAujjfhXb9k7Km+gq5TOLkjxOLOpYkakZwDspKHu3xpyzrVB+GqtetR1eJCti6NLOiKfSn591z2CAvJuz4mbgPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dtp8CLyy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WUBPBups; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764297612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sgfHeihlC+8u1mHu0tUzhZgmVFrgBxrrACIpxiuhkOQ=;
	b=dtp8CLyyKRQXNaHy2h0DqYw002b993NEL55QQeWV650jqOXn/5yWY5CI5MbL8LBtmFodyp
	pq7cx9JjQhy2f+MKYCehG9YDx95BGkECU2k3Cgpk6dGNfxqmmSenBr3uzHNqbfSjYbtALH
	BEp9G6iFQhHlD/bFiaf/xgTmGz+yf94=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-6tOnD2ppMli-SAeAicW6PA-1; Thu, 27 Nov 2025 21:40:10 -0500
X-MC-Unique: 6tOnD2ppMli-SAeAicW6PA-1
X-Mimecast-MFC-AGG-ID: 6tOnD2ppMli-SAeAicW6PA_1764297609
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-342701608e2so1350756a91.1
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 18:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764297609; x=1764902409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgfHeihlC+8u1mHu0tUzhZgmVFrgBxrrACIpxiuhkOQ=;
        b=WUBPBupsLTGwrL4ustwHzBDcKuoNA5oKsMOehyx9mLuhCOA2lb6TQjmjkb0d4Dasif
         7aoYs5ij7ruDxYXAr+4ESxWkbxoDIFpmAaB0aLI9W8/vSBQd4wMnQNh+YDhkx1KvVT4e
         98iVKMpju8aNiaVHDShGYm0+K5a3d4+0b7CE8mFdYRe5TzX4x/zv+BcWJfzgysFydcRe
         5DnU9CgH9Npy9KoqWusAbN4at0lgC/ao05wD3jNHVaOD2Rr0NLWhyU8qmNGrQxyXxlZO
         d5ZKTlN+lOWgA80obEltLPpimpWBV8oorkYlOmJM9r2yrwMyx9KoyvgBuMlCWpfUvi5M
         rrwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764297609; x=1764902409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sgfHeihlC+8u1mHu0tUzhZgmVFrgBxrrACIpxiuhkOQ=;
        b=RF+EJHXSYHzBeu1oaPz4Ledw32LiNOMCTuZhO6ADxEr/rHURC612aKhI5GYMsa3IDD
         0tE+jD0jSBKdmX5MVNlW6PvAj4ffjCHo3JN9XPIamU1rrlhbnLotciyzZvvLigaIw6K2
         pmLiKWhtaj7orwucU0hp5asNBw8Mj68l7QCMPFHJAjlEILqd17y47DXBXKy9drZjCyJD
         UOJiz0GZ8gblAJVDVyqcl/dlqYdYynudYrcl6A4JlS0kC7clDGYP8lr9ms+Dn2vNG98l
         6W4NNE2lkyt+lSZfFODeNms27tStKf2CWPdm7vB6JL32TypJMgoWzmAxSYww8mYTr6t2
         00+w==
X-Forwarded-Encrypted: i=1; AJvYcCUipsahP2h0CYU0ALPKjE2RYl/fSKaWQvwdKYA+WjMqFafQvnYHpCZEPXlnhQnODsuaBXw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxJ4dLP/TkdK5Z/BrY7rXLHi0BdubsDPsM8MNbrjj38oLYJdjq
	sb1xiYognKWQYE7ZdNsqAaCrUG6F8ldi/szKYg5GWXOAu25kC9f1XvOorfdQ14SUenHkPR6IvG5
	a0XB6hb6avQaIjZjkGKxewmd70g+yudxCo6i6c6tT+A9oPufm+2vVkdg579Wkof54YBLmva/KB8
	TWklISH3wXnCA//MlDpqZIe6nffn4X
X-Gm-Gg: ASbGncsaXt7NsiH1xbhHagIjGD0i0cRze/t8lEl5EQLdJwx9Atk92SltC3V4Un+Ub38
	ag22qNhObS49f0SDCMmsyIV6BRnjGmw0N9hiBEDp520sEfjVuoswqxSqhU4EM9Wbr5YCADnc101
	gDxmy7iq0evbUSGa+UrAyBDC9Iy5z9wqgr6QTGahuJouAlIgM2fpU/WXxNkeZ+usOX
X-Received: by 2002:a17:90b:1c04:b0:340:dd2c:a3da with SMTP id 98e67ed59e1d1-3475ebe6a55mr11921901a91.8.1764297609150;
        Thu, 27 Nov 2025 18:40:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG4wo+b8mDxiFvbp2FfPvxTIFKnSoRJlDC8td/QTiw0D2SXKZ1egJpMpwXj6ItWG1NiPOtXpEz0QFH1u2tvrDA=
X-Received: by 2002:a17:90b:1c04:b0:340:dd2c:a3da with SMTP id
 98e67ed59e1d1-3475ebe6a55mr11921862a91.8.1764297608647; Thu, 27 Nov 2025
 18:40:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764225384.git.mst@redhat.com> <637e182e139980e5930d50b928ba5ac072d628a9.1764225384.git.mst@redhat.com>
In-Reply-To: <637e182e139980e5930d50b928ba5ac072d628a9.1764225384.git.mst@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 28 Nov 2025 10:39:57 +0800
X-Gm-Features: AWmQ_bm__a-YRsaDl414Cee-_MAMOHTjKQ-R-ohBFRIeA6P5kRzykoXAUMexjlk
Message-ID: <CACGkMEsw7mgQdJieHz6CT3p5Pew=vH1qp5H2BSag_55w+q9Vnw@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] vhost: switch to arrays of feature bits
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>, 
	Paolo Abeni <pabeni@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2025 at 2:40=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> The current interface where caller has to know in which 64 bit chunk
> each bit is, is inelegant and fragile.
> Let's simply use arrays of bits.
> By using unroll macros text size grows only slightly.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/net.c   | 19 ++++++++++---------
>  drivers/vhost/scsi.c  |  9 ++++++---
>  drivers/vhost/test.c  |  6 +++++-
>  drivers/vhost/vhost.h | 42 ++++++++++++++++++++++++++++++++++--------
>  drivers/vhost/vsock.c | 10 ++++++----
>  5 files changed, 61 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index d057ea55f5ad..f8ed39337f56 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -69,15 +69,15 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero C=
opy TX;"
>
>  #define VHOST_DMA_IS_DONE(len) ((__force u32)(len) >=3D (__force u32)VHO=
ST_DMA_DONE_LEN)
>
> -static const u64 vhost_net_features[VIRTIO_FEATURES_U64S] =3D {
> -       VHOST_FEATURES |
> -       (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
> -       (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> -       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> -       (1ULL << VIRTIO_F_RING_RESET) |
> -       (1ULL << VIRTIO_F_IN_ORDER),
> -       VIRTIO_BIT(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO) |
> -       VIRTIO_BIT(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO),
> +static const int vhost_net_bits[] =3D {
> +       VHOST_FEATURES,
> +       VHOST_NET_F_VIRTIO_NET_HDR,
> +       VIRTIO_NET_F_MRG_RXBUF,
> +       VIRTIO_F_ACCESS_PLATFORM,
> +       VIRTIO_F_RING_RESET,
> +       VIRTIO_F_IN_ORDER,
> +       VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO,
> +       VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO
>  };
>
>  enum {
> @@ -1720,6 +1720,7 @@ static long vhost_net_set_owner(struct vhost_net *n=
)
>  static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
>                             unsigned long arg)
>  {
> +       const DEFINE_VHOST_FEATURES_ARRAY(vhost_net_features, vhost_net_b=
its);
>         u64 all_features[VIRTIO_FEATURES_U64S];
>         struct vhost_net *n =3D f->private_data;
>         void __user *argp =3D (void __user *)arg;
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 98e4f68f4e3c..f43c1fe9fad9 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -197,11 +197,14 @@ enum {
>  };
>
>  /* Note: can't set VIRTIO_F_VERSION_1 yet, since that implies ANY_LAYOUT=
. */
> -enum {
> -       VHOST_SCSI_FEATURES =3D VHOST_FEATURES | (1ULL << VIRTIO_SCSI_F_H=
OTPLUG) |
> -                                              (1ULL << VIRTIO_SCSI_F_T10=
_PI)
> +static const int vhost_scsi_bits[] =3D {
> +       VHOST_FEATURES,
> +       VIRTIO_SCSI_F_HOTPLUG,
> +       VIRTIO_SCSI_F_T10_PI
>  };
>
> +#define VHOST_SCSI_FEATURES VHOST_FEATURES_U64(vhost_scsi_bits, 0)
> +
>  #define VHOST_SCSI_MAX_TARGET  256
>  #define VHOST_SCSI_MAX_IO_VQ   1024
>  #define VHOST_SCSI_MAX_EVENT   128
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index 94cd09f36f59..f592b2f548e8 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -28,7 +28,11 @@
>   */
>  #define VHOST_TEST_PKT_WEIGHT 256
>
> -#define VHOST_TEST_FEATURES VHOST_FEATURES
> +static const int vhost_test_bits[] =3D {
> +       VHOST_FEATURES
> +};
> +
> +#define VHOST_TEST_FEATURES VHOST_FEATURES_U64(vhost_test_features, 0)

Did you mean vhost_test_bits actually?

Thanks



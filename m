Return-Path: <kvm+bounces-17532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D19AB8C77D0
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 15:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F1EA1C21FAB
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 13:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6862143C4C;
	Thu, 16 May 2024 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b7lFkxFm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E37329CEA
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 13:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715866708; cv=none; b=H+pHuOPk5/eMVzKv6gDn2cB/MoDaiDPGIdxtUb4nQr3SvjeYlahfINVB3F0AidKxsgWURB5uvMZrE0KYD0T+DbYp+wU3W+LTuXnazmUbgA/ZIVxLICXgCsLYyR3UP0mJJ4YRZ+XwLjukIZmLEgEH7ut8hKKJz8pJavHpTBhkMA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715866708; c=relaxed/simple;
	bh=H4uJfIWjhvWKU9/lF6/ReCaGNL4KXA9cAwJNwXPUNXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iAq/V/nfoyAWY8c6EOHhFogpewyFRDJam7l5QJMIIfJvYatfEC/HaAk70/xAmX7FYYzqZXR3yj1PEyZ9ekQpxIatocUJadYdMz34LJDfXjk1b+VRBJHXIHrnAAKs5JEKXd/qN4v3MT2hAu697LUFgOV47/bwAxkMKokt1Rtf2s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b7lFkxFm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715866703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9MotCgp3e2fj15EogMUNC34bh/DK0Sdeid+nwujT2pQ=;
	b=b7lFkxFm8nK/6bydZdP3RcIqstGre374Xew1FrxPDZgtdnKwxyM3ox/wELTpIcB4F8xLJS
	Tnx3GiqMjEuSM6PGPZEIqaLWBWbg9kQhX99LxkzaMHD9lCdvDN2dEZvLJQZJ39Yg+1tilK
	nvjMALwimQjNH8jGTd8ACafSwhHF3Ss=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-r6fdIG3wMDO6V1sXpuKqFg-1; Thu, 16 May 2024 09:38:20 -0400
X-MC-Unique: r6fdIG3wMDO6V1sXpuKqFg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6202fd268c1so144231357b3.2
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 06:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715866699; x=1716471499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9MotCgp3e2fj15EogMUNC34bh/DK0Sdeid+nwujT2pQ=;
        b=fF5vutCABR0jo2JBW2gp+tN9gx0eYQLV46m1qemeer7hvvIpx98S4i80Jjip7+eFtW
         L9HDLSansbJYDkiW1TlcWZ6ooCk+nWUl6yBvteatUfCR1+cUxafWbP3b+EzNljNRAxS7
         sCPh22dZO1Rp1FRReGuJgf8WpsngLw4LYLfRmrU5ySy6NHR+NkkSF4B1ZGGLJ+M6RLM2
         cERZSo2Lr4/9X0prPSCXshE0la9GhLoeXRpcAtaswrFWdG0jcqdWmIXXfGNKs9ZwZsaw
         hAeapQVK+UnCQBdA3uMVhy11ztZkJt/h+osgL6ousJvDpgRqCJIW7CAzb6ODGjF7D8ZZ
         oG8w==
X-Forwarded-Encrypted: i=1; AJvYcCXHbFK2fUihB++hkoXCMrMirNYSegQThy90ExVA0Hil+V1DEH/gCiE6Jk8c9IYLRDPAPEoIxUwbrNViUQd1YU4PNyE+
X-Gm-Message-State: AOJu0YwuyhftXTOfaW/XodgWVIIhAq54LhHzWb9B21uZ+PKlorjlChKH
	xc/V70Kt9/wq/EqHn+r4gyTN4AY8AYX/SEmdocXhq0rrrKeZVZG8SpDHh36pjqcR4myHOAacC4q
	jdxEcD//EaYnPO/0fDxprGgNG5NX+WxGwkGGrCI+9fl/dT6Kx1QeBY0GA/hwiBF4S5oUovdj4XP
	l8LveSFJqrie2TKo0yGiUgnqqB
X-Received: by 2002:a05:690c:b9d:b0:615:8c1:d7ec with SMTP id 00721157ae682-622b00218ccmr188220077b3.33.1715866699394;
        Thu, 16 May 2024 06:38:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4QKAuxEG0E9OIW18GgVRzmoNCx6cWbvCv+mq9BFFlhSCQTKIOOTMs34WnZPrmXQWnkLEbeQ4BQeEoXduizoU=
X-Received: by 2002:a05:690c:b9d:b0:615:8c1:d7ec with SMTP id
 00721157ae682-622b00218ccmr188219907b3.33.1715866699113; Thu, 16 May 2024
 06:38:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <bcc17a060d93b198d8a17a9b87b593f41337ee28.1715785488.git.mst@redhat.com>
In-Reply-To: <bcc17a060d93b198d8a17a9b87b593f41337ee28.1715785488.git.mst@redhat.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 16 May 2024 15:37:42 +0200
Message-ID: <CAJaqyWd9-fhrxBv3gTq82bGnSVdC_vw_LXg+XVNHT3B6cD0VOg@mail.gmail.com>
Subject: Re: [PATCH] vhost/vsock: always initialize seqpacket_allow
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com, 
	Jeongjun Park <aha310510@gmail.com>, Arseny Krasnov <arseny.krasnov@kaspersky.com>, 
	"David S . Miller" <davem@davemloft.net>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2024 at 5:05=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> There are two issues around seqpacket_allow:
> 1. seqpacket_allow is not initialized when socket is
>    created. Thus if features are never set, it will be
>    read uninitialized.
> 2. if VIRTIO_VSOCK_F_SEQPACKET is set and then cleared,
>    then seqpacket_allow will not be cleared appropriately
>    (existing apps I know about don't usually do this but
>     it's legal and there's no way to be sure no one relies
>     on this).
>
> To fix:
>         - initialize seqpacket_allow after allocation
>         - set it unconditionally in set_features
>
> Reported-by: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com
> Reported-by: Jeongjun Park <aha310510@gmail.com>
> Fixes: ced7b713711f ("vhost/vsock: support SEQPACKET for transport").
> Cc: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> Tested-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>

Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!

> ---
>
>
> Reposting now it's been tested.
>
>  drivers/vhost/vsock.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index ec20ecff85c7..bf664ec9341b 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -667,6 +667,7 @@ static int vhost_vsock_dev_open(struct inode *inode, =
struct file *file)
>         }
>
>         vsock->guest_cid =3D 0; /* no CID assigned yet */
> +       vsock->seqpacket_allow =3D false;
>
>         atomic_set(&vsock->queued_replies, 0);
>
> @@ -810,8 +811,7 @@ static int vhost_vsock_set_features(struct vhost_vsoc=
k *vsock, u64 features)
>                         goto err;
>         }
>
> -       if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
> -               vsock->seqpacket_allow =3D true;
> +       vsock->seqpacket_allow =3D features & (1ULL << VIRTIO_VSOCK_F_SEQ=
PACKET);
>
>         for (i =3D 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>                 vq =3D &vsock->vqs[i];
> --
> MST
>



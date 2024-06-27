Return-Path: <kvm+bounces-20584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70895919DE8
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 05:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AF8C285686
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 03:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69185134A9;
	Thu, 27 Jun 2024 03:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nlUiITei"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1C917758;
	Thu, 27 Jun 2024 03:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719459461; cv=none; b=JB7foHW8B1bS74LT0xo8HayM0DknZNfa7agqtBsnXDTLbtAKEReA7LNHTM9GP3bRfhWkCNCEOgyTICFqIctQpqmC2NBcMIuuiQzkpfm4euVs0+Cz0BFfAwSwCfZlVp1bh3FaOEm2kvv2SOLXhCPT/4NUC9o3AZPPr03Fd7FRulQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719459461; c=relaxed/simple;
	bh=wJ7aj6V02RGQPLH6KMM+51qFYpgYMN3gYv3bgJwF+FM=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=ruuFZEP4h2986Zh5YSDN4cXgsjD8PCqKLz6srefKv2c1IWj6+EhmFafEAEiyOxT8JkrT6X2YBm8M3UxrMtx2iaz+4ynE8W0+ARTT3sg2C5sYHWl+y0DFqaFAP3240mr5bUH0wo7R5z3SziaKvNm331n59pD3VcJScNcEDmIrFBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nlUiITei; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3d566d5eda9so190857b6e.0;
        Wed, 26 Jun 2024 20:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719459458; x=1720064258; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=btL9frXHn5bucfqfBQ8J86OleIxFKMIHqIH1Tkvc2+Y=;
        b=nlUiITeimMEvjKNuFcVeDnY8pw51Ib27QCj/hsDT7W9TwOlCT9MWlRFqAggt7kyHUZ
         dZMGF3CEVmbQ5a5aEUzO5PzawJT5uO1yaeEvclnGSKx9u9c4ALUqKU/RCEoCHClcRTgl
         MNFxRUzvqUU1owHQVrdokHSZrBnUDTMiFxaKpHJam8mHd7nxPuy1seRSZ+TbKo2tWMTQ
         CGxysnZUwynMRIEpGnN95Jy8YunwVoh7mYduOZZocE/XxdVzujd55ftwkBG0hFLe1Sg3
         b6VZNQzwweZIDsrPosINiobQLNUMLELS0IHcL0VD4zJup1wfTglyfWGIp4Uh/tUs3PbU
         sreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719459458; x=1720064258;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=btL9frXHn5bucfqfBQ8J86OleIxFKMIHqIH1Tkvc2+Y=;
        b=Ws+4izpzFaObv+CYr2ISy/0y6Z8y6vUX9NgL7MXUyrz6DakCABxXYIIx4BbEXiRox8
         ItLAeKtLm/4IH//E1lnVU5owT7rU1O2bK/JeTw2mggdiyTzZb9w7Na80MV+MqP0W4pZX
         PWLkQ+g272vEw6LqmHRgKFWICnGH96SD0Q1A1E4LkZtgj9f6d+ZqVdcMlJbBW5g2BTZ6
         G2BiiXbbqrephhNc1xpUZfV71uJLIcSLwT4WQXO8eh9ZvhFBDIAecQO87oadlWLcI7ZW
         JeJJtJcZkwe2sNeyzSmg0G54RXK6XZcgKUldcMDPNHPbejA3YLU3UuBKmAH+zbiO9t3g
         qYpA==
X-Forwarded-Encrypted: i=1; AJvYcCWvQElgaEh9KORdWnQFsMeEzTIVisD3LZiLhW6l97rOldoHI9ABivDiCnCn+JK1s1q6yf+btX8DF2CKdLRuKN0f47UF7YxqD7BsjVQqMKX05XCBbH+O4m10wsKB
X-Gm-Message-State: AOJu0YxyxDbnNhYyucW80d4KK+1xEUqBQ3cXWk4OBPEaPUZuFs7n4ExL
	JcTjMuhpBLiO5KvFjyElAtl11LHySQw1VE/TwZ8NpB3bqQWUO5UhibYFy/jFM5Y=
X-Google-Smtp-Source: AGHT+IGVDdwvf48/nQa5AnQqEU/GPUM5E0o40jNlS5HJEw1xlJF7yk1hxW3f5GLk6bzUTo1BS4p2uQ==
X-Received: by 2002:a05:6808:170f:b0:3d5:1bd8:ab18 with SMTP id 5614622812f47-3d545979603mr13684952b6e.24.1719459457698;
        Wed, 26 Jun 2024 20:37:37 -0700 (PDT)
Received: from smtpclient.apple ([2001:e60:a809:eceb:bd02:cb72:6ee8:4792])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-706b4a07a30sm252681b3a.139.2024.06.26.20.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 20:37:37 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: =?utf-8?B?67CV7KCV7KSA?= <aha310510@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] vhost/vsock: always initialize seqpacket_allow
Date: Thu, 27 Jun 2024 12:37:24 +0900
Message-Id: <4C39A362-74E3-4762-82AD-D8B15AA38B10@gmail.com>
References: <bcc17a060d93b198d8a17a9b87b593f41337ee28.1715785488.git.mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
 syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com,
 Arseny Krasnov <arseny.krasnov@kaspersky.com>,
 "David S . Miller" <davem@davemloft.net>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?utf-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org
In-Reply-To: <bcc17a060d93b198d8a17a9b87b593f41337ee28.1715785488.git.mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
X-Mailer: iPhone Mail (21F90)

nice patch

> 2024. 5. 16. =EC=98=A4=EC=A0=84 12:05, Michael S. Tsirkin <mst@redhat.com>=
 =EC=9E=91=EC=84=B1:
>=20
> =EF=BB=BFThere are two issues around seqpacket_allow:
> 1. seqpacket_allow is not initialized when socket is
>   created. Thus if features are never set, it will be
>   read uninitialized.
> 2. if VIRTIO_VSOCK_F_SEQPACKET is set and then cleared,
>   then seqpacket_allow will not be cleared appropriately
>   (existing apps I know about don't usually do this but
>    it's legal and there's no way to be sure no one relies
>    on this).
>=20
> To fix:
>    - initialize seqpacket_allow after allocation
>    - set it unconditionally in set_features
>=20
> Reported-by: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com
> Reported-by: Jeongjun Park <aha310510@gmail.com>
> Fixes: ced7b713711f ("vhost/vsock: support SEQPACKET for transport").
> Cc: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> Tested-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>=20
> ---
>=20
>=20
> Reposting now it's been tested.
>=20
> drivers/vhost/vsock.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index ec20ecff85c7..bf664ec9341b 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -667,6 +667,7 @@ static int vhost_vsock_dev_open(struct inode *inode, s=
truct file *file)
>    }
>=20
>    vsock->guest_cid =3D 0; /* no CID assigned yet */
> +    vsock->seqpacket_allow =3D false;
>=20
>    atomic_set(&vsock->queued_replies, 0);
>=20
> @@ -810,8 +811,7 @@ static int vhost_vsock_set_features(struct vhost_vsock=
 *vsock, u64 features)
>            goto err;
>    }
>=20
> -    if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
> -        vsock->seqpacket_allow =3D true;
> +    vsock->seqpacket_allow =3D features & (1ULL << VIRTIO_VSOCK_F_SEQPACK=
ET);
>=20
>    for (i =3D 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>        vq =3D &vsock->vqs[i];
> --
> MST
>=20


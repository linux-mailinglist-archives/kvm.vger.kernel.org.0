Return-Path: <kvm+bounces-25114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C1EC95FED3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 04:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42E27282A21
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 02:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AB87C8C7;
	Tue, 27 Aug 2024 02:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8swLM5K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B06DDA8
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 02:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724724494; cv=none; b=SSJ5kfexOmGsGAW4aaEgc3tv8HWSQABeUa0RZNHfSbFyM1QjDQFjxkgjw3i/3uB5cryfN3D45zkF8V3zGvEnXReLSRRPxTyvK+MU9toM/g5UvDY3vFG+zSfx5MFFs2YfVD7+EjZVphrYqsx2HmGHvTcSRsdQ+3HWXRld9lbwGZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724724494; c=relaxed/simple;
	bh=bkIqnYbm1MnDHhp3BnO49M6sU40/6rF74ImOz9lvPxQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aW59s2No4IkC2IXv5Blso9cbSBUdiM/+M3qxGNVhRgPe7WT0i37rhwCtsT4+f4pIXmoLyETHGYviyjLIqDVNjSb6t85K0WesmDLPhzsFvksoOMUBzgWK9W3bEwp80CY0+CHnvoUmL02V8B8TlJWMcA6ZOiSECjnmRohdH26uiSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N8swLM5K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724724492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y7pcI0uinDu0qh7wzIUXLNqe/Y379MsoXNJobOcXZFk=;
	b=N8swLM5KE5NegyiUQy6S2A++iTf4ZW7qRgrQtF+aJVbPPh99N+llOffA4ClxB5XvMwDeaX
	RHhbseSH1oTIHFe86U1ELMWy4nS4NTz+Bj+GwzSZk1EaP2xNCBzXiX7ppMrhXObueSKliT
	mQq0PdlQm8wzvV4urmLkclPi5ahVyXE=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-G4EZLsGoNpGSPzs59IT8OA-1; Mon, 26 Aug 2024 22:08:10 -0400
X-MC-Unique: G4EZLsGoNpGSPzs59IT8OA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-7cd854e1869so4231942a12.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 19:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724724489; x=1725329289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y7pcI0uinDu0qh7wzIUXLNqe/Y379MsoXNJobOcXZFk=;
        b=e5Un4Ar1c8RvhLEYKFyPoTr0mv9utI8nqP/pTMfNV0yY6axexbATpE7IX7aHYd6jxA
         rGf4Si+Hdyhls8Cw0QcvovwSF2dRbSgKaNtknXMtbSYUb49IDzorvfFRjp+Y3Oy9vQpB
         HzrW1m+tlpCq525OaLNucbyCalzHldse+RJa9lMXlGPGbK+iJCksIAIFWTlPklslwon1
         +YP6jOH8xDayLk1NiRsQK4Fy/+PmQBHMsWavTTCqbgDjYQzinS3LXN6e8ZJBNJz/FXPi
         iwrphAd7apC1xALhzDPlfbx207GxzFtWuw6iV+2SeWZpbHf4fwHsFwyjC2E3+oCSaT8G
         k2TA==
X-Forwarded-Encrypted: i=1; AJvYcCU7IGJJmNIX46wbmtem0gFb5Cro6V+4qkhtq90JvHIHbNnO1BGl6AScz3f5r2i+UHAIieQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZOlJcNJNti4L2t/y1VE37fDQjMaUH3daWfwOLpM7QUQAqlUUz
	qHipQCZNrqRA9qlMl7WLgQyD/d2VitkrrKUBkIWoRrIDyVbqtgmEHE71rI3LmmeMekZR/16qQZm
	HQwg+uH/FVpVkB+coJ+OKytIdXIeXyEo7mwA09iVWT21a8WFuXk7IYlc9/+OvrA2gtTtW7enrq/
	Z/SFENjhutp8p9mImNX5apSslp
X-Received: by 2002:a05:6a21:58b:b0:1c2:8ece:97ae with SMTP id adf61e73a8af0-1cc8b5915ffmr14510373637.34.1724724489265;
        Mon, 26 Aug 2024 19:08:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOdz9GUVwrqpgYrcnv54Mbhz6HniCXDlhcxCvo3lyk4m1aYuTJUV32fINMe+2aJevHVEEISNfiUce4fHkbYZo=
X-Received: by 2002:a05:6a21:58b:b0:1c2:8ece:97ae with SMTP id
 adf61e73a8af0-1cc8b5915ffmr14510352637.34.1724724488682; Mon, 26 Aug 2024
 19:08:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
 <afcbf041-7613-48e6-8088-9d52edd907ff@nvidia.com> <8a15a46a-2744-4474-8add-7f6fb35552b3@digitalocean.com>
 <2a1a4dfb-aef1-47c1-81ce-b29ed302c923@nvidia.com> <1cb17652-3437-472e-b8d5-8078ba232d60@digitalocean.com>
In-Reply-To: <1cb17652-3437-472e-b8d5-8078ba232d60@digitalocean.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 27 Aug 2024 10:07:53 +0800
Message-ID: <CACGkMEvbc_4_KrnkZb-owH1moauntBmoKhHp1tsE5SL4RCMPog@mail.gmail.com>
Subject: Re: [RFC] Why is set_config not supported in mlx5_vnet?
To: Carlos Bilbao <cbilbao@digitalocean.com>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, eli@mellanox.com, mst@redhat.com, 
	xuanzhuo@linux.alibaba.com, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	eperezma@redhat.com, sashal@kernel.org, yuehaibing@huawei.com, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 3:23=E2=80=AFAM Carlos Bilbao <cbilbao@digitalocean=
.com> wrote:
>
> Hello,
>
> On 8/26/24 10:53 AM, Dragos Tatulea wrote:
> >
> > On 26.08.24 16:26, Carlos Bilbao wrote:
> >> Hello Dragos,
> >>
> >> On 8/26/24 4:06 AM, Dragos Tatulea wrote:
> >>> On 23.08.24 18:54, Carlos Bilbao wrote:
> >>>> Hello,
> >>>>
> >>>> I'm debugging my vDPA setup, and when using ioctl to retrieve the
> >>>> configuration, I noticed that it's running in half duplex mode:
> >>>>
> >>>> Configuration data (24 bytes):
> >>>>   MAC address: (Mac address)
> >>>>   Status: 0x0001
> >>>>   Max virtqueue pairs: 8
> >>>>   MTU: 1500
> >>>>   Speed: 0 Mb
> >>>>   Duplex: Half Duplex
> >>>>   RSS max key size: 0
> >>>>   RSS max indirection table length: 0
> >>>>   Supported hash types: 0x00000000
> >>>>
> >>>> I believe this might be contributing to the underperformance of vDPA=
.
> >>> mlx5_vdpa vDPA devicess currently do not support the VIRTIO_NET_F_SPE=
ED_DUPLEX
> >>> feature which reports speed and duplex. You can check the state on th=
e
> >>> PF.
> >>
> >> According to ethtool, all my devices are running at full duplex. I ass=
ume I
> >> can disregard this configuration output from the module then.
> >>
> > Yep.
> >
> >>>> While looking into how to change this option for Mellanox, I read th=
e following
> >>>> kernel code in mlx5_vnet.c:
> >>>>
> >>>> static void mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned =
int offset, const void *buf,
> >>>>                  unsigned int len)
> >>>> {
> >>>>     /* not supported */
> >>>> }
> >>>>
> >>>> I was wondering why this is the case.
> >>> TBH, I don't know why it was not added. But in general, the control V=
Q is the
> >>> better way as it's dynamic.
> >>>
> >>>> Is there another way for me to change
> >>>> these configuration settings?
> >>>>
> >>> The configuration is done using control VQ for most things (MTU, MAC,=
 VQs,
> >>> etc). Make sure that you have the CTRL_VQ feature set (should be on b=
y
> >>> default). It should appear in `vdpa mgmtdev show` and `vdpa dev confi=
g
> >>> show`.
> >>
> >> I see that CTRL_VQ is indeed enabled. Is there any documentation on ho=
w to
> >> use the control VQ to get/set vDPA configuration values?
> >>
> >>
> > You are most likely using it already through through qemu. You can chec=
k
> > if the CTR_VQ feature also shows up in the output of `vdpa dev config s=
how`.
> >
> > What values are you trying to configure btw?
>
>
> Yes, CTRL_VQ also shows up in vdpa dev config show. There isn't a specifi=
c
> value I want to configure ATM, but my vDPA isn't performing as expected, =
so
> I'm investigating potential issues. Below is the code I used to retrieve
> the configuration from the driver; I'd be happy to send it as a patch if
> you or someone else reviews it.
>
>
> >
> > Thanks,
> > Dragos
>
>
> Thanks,
> Carlos
>
> ---
>
> From ab6ea66c926eaf1e95eb5d73bc23183e0021ee27 Mon Sep 17 00:00:00 2001
> From: Carlos Bilbao <bilbao@vt.edu>
> Date: Sat, 24 Aug 2024 00:24:56 +0000
> Subject: [PATCH] mlx5: Add support to update the vDPA configuration
>
> This is needed for VHOST_VDPA_SET_CONFIG.
>
> Signed-off-by: Carlos Bilbao <cbilbao@digitalocean.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index b56aae3f7be3..da31c743b2b9 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2909,14 +2909,32 @@ static void mlx5_vdpa_get_config(struct vdpa_devi=
ce *vdev, unsigned int offset,
>      struct mlx5_vdpa_dev *mvdev =3D to_mvdev(vdev);
>      struct mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvdev);
>
> -    if (offset + len <=3D sizeof(struct virtio_net_config))
> +    if (offset + len <=3D sizeof(struct virtio_net_config)) {
>          memcpy(buf, (u8 *)&ndev->config + offset, len);
> +        }
> +        else
> +        {
> +            printk(KERN_ERR "%s: Offset and length out of bounds\n",
> +            __func__);
> +        }
> +
>  }
>
>  static void mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned int =
offset, const void *buf,
>                   unsigned int len)
>  {
> -    /* not supported */
> +    struct mlx5_vdpa_dev *mvdev =3D to_mvdev(vdev);
> +    struct mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvdev);
> +
> +    if (offset + len <=3D sizeof(struct virtio_net_config))
> +    {
> +        memcpy((u8 *)&ndev->config + offset, buf, len);
> +    }
> +    else
> +    {
> +        printk(KERN_ERR "%s: Offset and length out of bounds\n",
> +        __func__);
> +    }
>  }

This should follow the virtio-spec, for modern virtio-net devices,
most of the fields are read only.

Thanks

>
>  static u32 mlx5_vdpa_get_generation(struct vdpa_device *vdev)
> --
> 2.34.1
>
>



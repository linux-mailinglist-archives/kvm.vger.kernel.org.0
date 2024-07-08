Return-Path: <kvm+bounces-21083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89EAC929CB6
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 09:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B718C1C214F2
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 07:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A4FE1C287;
	Mon,  8 Jul 2024 07:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NYNGoYBm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318FA1CD06
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 07:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720422203; cv=none; b=p64V75RB20g7PxvD9dPFAMj/VwcTacD+e2dKHLFJtTw2IUhnGOtVkzQL5F2RBo98WO3SDhDTlm28G0o7JPAiuo4MboAWSFglpX14QbqD0sorgoEp3QW5xSMAXDnwJLhVKJX4relEMOSZMmyxA3+Avsi/xdOG3OPCirS54PxPzXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720422203; c=relaxed/simple;
	bh=4b92oNgXX3IO0nNjCs2UGVAK+tN4/8tvmYGO2+9x2s4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OH+ljS4ezSUvNUkqK0MGTzKdNIwm0qvRbiUyn2yrk+Ag8y4WwnQMdnPl2qMYwdtbQC7A4aJBPItH+aRzmI6uIHx2RpzxmBgE5OtD0cgrmB9hr6cmGVa4FWuhAtwGyVwbHNVoi70jyNHveI9RX4dAitLuV8pODHfJd+V03EekYxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NYNGoYBm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720422201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xafKe1ETPl2hs7RC1pIf/UXEnXlhBd+TTx+fx4z1CYs=;
	b=NYNGoYBmPZ14AQRQ8dC8PwEji/QVOzOYvIwaA8xptva5ui9M5PCX8lCBhJXRvI4qlcXrx6
	Vzhjtz8WwuEbAK1B6JjY8kWXXnfrnTUkS6HLFknaBymYAj2xrxW+6jx83QoslNqOW8Lpjx
	7ys0lCJap7yaaLW0DvA0z04ZSQ6IJZc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-AVdB3sOjMNSNIzPZvHbaOw-1; Mon, 08 Jul 2024 03:03:19 -0400
X-MC-Unique: AVdB3sOjMNSNIzPZvHbaOw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2c969c4a90cso3750419a91.1
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 00:03:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720422198; x=1721026998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xafKe1ETPl2hs7RC1pIf/UXEnXlhBd+TTx+fx4z1CYs=;
        b=m1GISg0IEhhU8f/K1oWppMNiJ4Iraq3+KPFT4PVS3m2nBgXVQtlmoQ0X0gQjwM5HKn
         oytbB6rgXSh0oJRRnRg8vyt0EbCrJdQ2wO2IgedzTwYA+AKpki2s3iEouq5lV73d5M3g
         zj9XW6fc8CEsDpWwAGDEl3gMcVtl2cS3QOtZuP+4KKUPuleG9NTD/8tktG8E0Chv8Wgc
         BFrG8eWeyeSN3VTUZ22XbZX1EddZ3Q6F7zG3LMwnbPdNKy9M4Xhk9yqV5eMf9xLWQoy5
         wxD5/wDZcuuYgP1yQEBummdAoDdZoOilMAmBUJzduw4hwwY5aTprX7ainkK9NRfQa+JY
         YBoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDcbgvB2i3yLBBMr2f/+7b3T0vHvWmGSWpiJApK5yjTsbQs1X9cLPGymQB7Bp6irpSYasy2t3R1OqjNRor+jfG4qhE
X-Gm-Message-State: AOJu0YzltiBCDli6VXaog7rmD+Wq42lmO3a9jDJZ4HHR1NIxHLJLRvk3
	u4bYK5yMTS748GBUthNUzYDCmlPaVQkvo6g3wgr0Zzm686YWt72cv6PZMkN7AwSQr2ynBveGKRE
	g8kkQuJIIBH7dllZN26M9p/yTyG/JQEpvvTBDUqJy8OC57YZ6sT4Rvo38V0fVm/QMHCTEuHeJRO
	8TO8FMQVUw1Y8yiFM3b8PWX5fB
X-Received: by 2002:a17:90a:c24d:b0:2c9:5a8b:ff7e with SMTP id 98e67ed59e1d1-2c99c5596e5mr8326627a91.25.1720422198728;
        Mon, 08 Jul 2024 00:03:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGK2xxHaGnbVCuiq17bw6Hrfo1LzM8sgBjdKSXFir13Qe5R6l6dUaQH4ufWN/M6OQHtNf5RO7L457uGVag88zo=
X-Received: by 2002:a17:90a:c24d:b0:2c9:5a8b:ff7e with SMTP id
 98e67ed59e1d1-2c99c5596e5mr8326615a91.25.1720422198391; Mon, 08 Jul 2024
 00:03:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708065549.89422-1-lulu@redhat.com>
In-Reply-To: <20240708065549.89422-1-lulu@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 8 Jul 2024 15:03:07 +0800
Message-ID: <CACGkMEtOP_Hz=SO+r5WQfWow3Pb-Sz552xnt0BqTgyGSuvJz_A@mail.gmail.com>
Subject: Re: [PATCH] vdpa/mlx5: Add the support of set mac address
To: Cindy Lu <lulu@redhat.com>
Cc: dtatulea@nvidia.com, mst@redhat.com, parav@nvidia.com, sgarzare@redhat.com, 
	netdev@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 2:56=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> Add the function to support setting the MAC address.
> For vdpa/mlx5, the function will use mlx5_mpfs_add_mac
> to set the mac address
>
> Tested in ConnectX-6 Dx device

Great.

>
> Signed-off-by: Cindy Lu <lulu@redhat.com>

I guess this should be part of the series "vdpa: support set mac
address from vdpa tool" ?

> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index 26ba7da6b410..f78701386690 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -3616,10 +3616,33 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_de=
v *v_mdev, struct vdpa_device *
>         destroy_workqueue(wq);
>         mgtdev->ndev =3D NULL;
>  }
> +static int mlx5_vdpa_set_attr_mac(struct vdpa_mgmt_dev *v_mdev,
> +                                 struct vdpa_device *dev,
> +                                 const struct vdpa_dev_set_config *add_c=
onfig)
> +{
> +       struct mlx5_vdpa_dev *mvdev =3D to_mvdev(dev);
> +       struct mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvdev);
> +       struct mlx5_core_dev *mdev =3D mvdev->mdev;
> +       struct virtio_net_config *config =3D &ndev->config;
> +       int err;
> +       struct mlx5_core_dev *pfmdev;
> +
> +       if (add_config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> +               if (!is_zero_ether_addr(add_config->net.mac)) {
> +                       memcpy(config->mac, add_config->net.mac, ETH_ALEN=
);
> +                       pfmdev =3D pci_get_drvdata(pci_physfn(mdev->pdev)=
);
> +                       err =3D mlx5_mpfs_add_mac(pfmdev, config->mac);
> +                       if (err)
> +                               return -1;
> +               }
> +       }
> +       return 0;
> +}
>
>  static const struct vdpa_mgmtdev_ops mdev_ops =3D {
>         .dev_add =3D mlx5_vdpa_dev_add,
>         .dev_del =3D mlx5_vdpa_dev_del,
> +       .dev_set_attr =3D mlx5_vdpa_set_attr_mac,

Let's rename this as we will add the support for mtu as well or not?

Thanks

>  };
>
>  static struct virtio_device_id id_table[] =3D {
> --
> 2.45.0
>



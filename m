Return-Path: <kvm+bounces-21156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A7CE92B139
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 09:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9BD7B21570
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 07:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1EC14534C;
	Tue,  9 Jul 2024 07:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VerlCW4B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B3913D516
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 07:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720510512; cv=none; b=k/+RGw7E9TsucORbEz3cqr4oR8u4mqGXbDAQAf1D/kA7o3vLsq36GHWOUgmxJRiXgS48BS3vZIKtOnzOKhABfqf2IScOFO6kg6Jz0zgHKK5kh8lUdUdoNI9U461jakd+ZYALB8+EHhkA3lphbf/cK1df7t7j6IrzgGN7NVkHCLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720510512; c=relaxed/simple;
	bh=DdRhbICaef9j8HkGlMP5Bgg0eQtDwpCDC9yQaq+5/6o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B2hLgIl5AfWQkie8/CMtbeBVcBO4ol6T7IdCb4++NEm6VRTgfZH4gfVanricQpb+cfauoEqLhi6GtU1hrqskveLQpl3MwgZNyrurhqOwwWixzVO0OiWT9UE+dMg0jEJMD33HGHIn4ohB/0pqP8yT22t/0Ral6a24CuhQKoVDvaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VerlCW4B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720510509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EIqC2mqFe9C8xKJMg5ba5cK9RsFhYLPxtTQe6Ed06hU=;
	b=VerlCW4BpO2V6xM4rUWVeZktEk9+kwHOE9Wd291p773K2o0zg+LNqC3+WsUfyaqS1npD7K
	vThnoaJ980nTNJ2w9zeuGfQVkaYXE7pmPSMduFfZQUe1jvLrCl62qPrg5wN0s1FE134YVs
	57aBiVJZ1HC72N0jXsHDUOCpi4jNLxc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-wQP3lDLwM9adJMFKIOWElg-1; Tue, 09 Jul 2024 03:35:07 -0400
X-MC-Unique: wQP3lDLwM9adJMFKIOWElg-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-58cdd86c091so3864764a12.3
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 00:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720510506; x=1721115306;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EIqC2mqFe9C8xKJMg5ba5cK9RsFhYLPxtTQe6Ed06hU=;
        b=CPpflgBBS+rc0nI5QTh0zfYmv57feSlPUsreWoXpiPGC9eKGv0CHbx9SdXHRYO7/0d
         /KbuBztenmS0gBCmzbWFnOeGH4wmYfooFeD58tQrEX6cKtl5/9eth3r7pJKXqp2wwGsL
         ltJU+2MncUafszCvPnbz+9afIWOgSfImWeB6S8C/SQb4nCZVsHdVf9MCP5+8i9FSwd56
         2L4vm/9RXPuHCptM+F7GhCO+sPCyLj60b9h4JoL0NZ20xzhsfL3iFbEkOmgPXklseZao
         g6qbZEYml6o4pHwZAdXHABvmSqAxvddTEK3QBHFppu8VEimdnro5NHE8biZHywAeSLSb
         xILA==
X-Forwarded-Encrypted: i=1; AJvYcCVyTk3b2noTP7gYT076oP372li+yK3BXe591m99dW7bcADFC1W83LI/5JGdCF6LNSoC8TCx6+Fyr6FcfoYfau877My3
X-Gm-Message-State: AOJu0Yy1c0lsqBKu6Z6L0Md0JUnaINHzvvl0cI7PsaVSO0FK+Rf8GArL
	CDdlJa4WKsJUwQy8WobEgW4YxKG8ZDut29xAKV42/5YDIFHdjBsqTQo87JKezVJu7No4vn2N68a
	M7z0I5NPkrt8+B1XR9bFRRLtlVfh+RZgTOHw65/BX7vFNBIt4waBXF0X/m9keIfJUb9XXxsC5YJ
	E01IhCqAzaFAvbPf/VA0QMqhlG
X-Received: by 2002:a05:6402:2742:b0:57c:610a:6e7f with SMTP id 4fb4d7f45d1cf-594baf8719fmr1467716a12.11.1720510506317;
        Tue, 09 Jul 2024 00:35:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEprGNtKtwZjWwZDrHR9spCqEFHlNDxGO/hw7rYsSyBxth5QJJ9oylIOl12jUvsQu4A55DuFRtIjAqAaxCAus8=
X-Received: by 2002:a05:6402:2742:b0:57c:610a:6e7f with SMTP id
 4fb4d7f45d1cf-594baf8719fmr1467693a12.11.1720510505896; Tue, 09 Jul 2024
 00:35:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708065549.89422-1-lulu@redhat.com> <20240708072603-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240708072603-mutt-send-email-mst@kernel.org>
From: Cindy Lu <lulu@redhat.com>
Date: Tue, 9 Jul 2024 15:34:28 +0800
Message-ID: <CACLfguU2OakNJPO6pR6V7D4SV0-VvC=okqDcwutMPztTUweMZA@mail.gmail.com>
Subject: Re: [PATCH] vdpa/mlx5: Add the support of set mac address
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: dtatulea@nvidia.com, jasowang@redhat.com, parav@nvidia.com, 
	sgarzare@redhat.com, netdev@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Jul 2024 at 19:26, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jul 08, 2024 at 02:55:49PM +0800, Cindy Lu wrote:
> > Add the function to support setting the MAC address.
> > For vdpa/mlx5, the function will use mlx5_mpfs_add_mac
> > to set the mac address
> >
> > Tested in ConnectX-6 Dx device
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
>
> Is this on top of your other patchset?
>
yes, Will send a new version of these patch
Thanks
cindy
> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 26ba7da6b410..f78701386690 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -3616,10 +3616,33 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
> >       destroy_workqueue(wq);
> >       mgtdev->ndev = NULL;
> >  }
> > +static int mlx5_vdpa_set_attr_mac(struct vdpa_mgmt_dev *v_mdev,
> > +                               struct vdpa_device *dev,
> > +                               const struct vdpa_dev_set_config *add_config)
> > +{
> > +     struct mlx5_vdpa_dev *mvdev = to_mvdev(dev);
> > +     struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> > +     struct mlx5_core_dev *mdev = mvdev->mdev;
> > +     struct virtio_net_config *config = &ndev->config;
> > +     int err;
> > +     struct mlx5_core_dev *pfmdev;
> > +
> > +     if (add_config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> > +             if (!is_zero_ether_addr(add_config->net.mac)) {
> > +                     memcpy(config->mac, add_config->net.mac, ETH_ALEN);
> > +                     pfmdev = pci_get_drvdata(pci_physfn(mdev->pdev));
> > +                     err = mlx5_mpfs_add_mac(pfmdev, config->mac);
> > +                     if (err)
> > +                             return -1;
> > +             }
> > +     }
> > +     return 0;
> > +}
> >
> >  static const struct vdpa_mgmtdev_ops mdev_ops = {
> >       .dev_add = mlx5_vdpa_dev_add,
> >       .dev_del = mlx5_vdpa_dev_del,
> > +     .dev_set_attr = mlx5_vdpa_set_attr_mac,
> >  };
> >
> >  static struct virtio_device_id id_table[] = {
> > --
> > 2.45.0
>



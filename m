Return-Path: <kvm+bounces-21158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 512E192B150
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 09:38:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C30FF1F22992
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 07:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EEE61514DD;
	Tue,  9 Jul 2024 07:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fKyqaQzW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E039014A615
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 07:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720510653; cv=none; b=p4EIbHdc/vKLOuFFqcKSJM4UYaysf1su5a0iPgkdEYTppGz06xNo8zW5u3St7wbmUjxjsR5Rk4Hj41u0wtekaDEwUC48GmPoTqp03+z3jMzLNB+6S84/jjkBR+8UUkLxuJC+GxZfbwz28+53UymsW2rgfAcbGs4gWn40JXWBxcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720510653; c=relaxed/simple;
	bh=R6uhElAMm4FTpUU4vkd99nDcZrma70iZDg9k9g3ocDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jY4es1jBNHdJFYKquTeeUJTb3lmDH3iIhczObIzOj/YI3U6eN3Zavw9BdVfwjLnUeaCmQHmAbyjqelgEhhoSZqgek5lHE3Z49A0IVDpwmLnagtbRDiXXSGwBlcupAXrgP27k8HOu4jpZYE5e750wfNx1Q1FPn8P+ElldMNuXWQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fKyqaQzW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720510650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A49qXoXkEsMzgDh5I6lFSA4XYzFZMk+NCFiOV4UimaA=;
	b=fKyqaQzW21EAsASSVBdhHZfGPwZH0BGQ/EBrclnEHSawjjVob5+w6x7xaC4CEfEeIyUMa3
	M9NJgGVrnsPhQxO8xFhx/RnmRCEzjkmuSqpc/T0n3ch1dGbQ3LuVyMnKEnFqyQOdXbb8c/
	O/8d4e1NhxT4s8LHzgNYaJXvcRIRz24=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-4lQEtU2KMCOO7ZM4vxPkcA-1; Tue, 09 Jul 2024 03:37:27 -0400
X-MC-Unique: 4lQEtU2KMCOO7ZM4vxPkcA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a77baa2fc0dso205959266b.3
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 00:37:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720510646; x=1721115446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A49qXoXkEsMzgDh5I6lFSA4XYzFZMk+NCFiOV4UimaA=;
        b=WPFYtB5qkqY9PUfWqngqZwJ4VO20c/d6Y2OVBGtEgis1ta7sm9fvLZFSPR5pN7AAmZ
         31EH9f0r+THLpm2/t2/0fiN8UbOph0zqwLCBlXj4qk0gR3JEbE8aoKTn3KQxoeaV7TKs
         b4iHIjNWf9Taktw3WkzSRcK32Q64yR95aGUi8+7jICTXAxLckHzC9H5eMkuTsNx/pVI7
         Me7lxcIhbcUckEA124k23+om876NkLpCR4Fu6HFVJENGajGlo+T/V1zTWnAn/3nQyvFQ
         QkXH0mvxDG6IYizNr3nboUNhHuFPIhZFMuclc2ELiJDKPZARsJguWJc6L8LK2EmZwCEZ
         blTw==
X-Forwarded-Encrypted: i=1; AJvYcCWez6S/t1+qJjJKPLAZd2PtoefTvGS3fvbXBw/4xS1hyptImsiSCGFmfnEiHG2cyj6tNN8Z8zFFfwWSKWGu3fbWWzb+
X-Gm-Message-State: AOJu0YwCgMpJS3fxI3eyWJpIfwTzI4IipwNO9QoIpS4LaAeRqFn3ATm7
	ozAOd3k5ZdpGlGFzPKfyMaMrHxnQL97xRCJqxn6PxjbTgTB4IwsptEGL2UTkA1QCBHOPEhcx+ZT
	B7fP6iu5l5cIToOCASs+tWpRj60nEIZgN/unhdVnoeLjluwO2wUCspVHezDiysHVzEcz6bXdq97
	zC6VbPHaC6gPayNK6ye05UUzjW
X-Received: by 2002:a05:6402:430b:b0:58c:3252:3ab8 with SMTP id 4fb4d7f45d1cf-594bcba83fcmr1671352a12.37.1720510645972;
        Tue, 09 Jul 2024 00:37:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvA5gcFgFWqNy3DfNk26q33q8PtgffuDdwkGspZQpCkB6LI+Z1lBCXYRy9/d//O/OXiMfXxo5/urdnIEt4WlE=
X-Received: by 2002:a05:6402:430b:b0:58c:3252:3ab8 with SMTP id
 4fb4d7f45d1cf-594bcba83fcmr1671317a12.37.1720510645548; Tue, 09 Jul 2024
 00:37:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708065549.89422-1-lulu@redhat.com> <34818d378285d011d0e7d73d497ef8d710861adc.camel@nvidia.com>
In-Reply-To: <34818d378285d011d0e7d73d497ef8d710861adc.camel@nvidia.com>
From: Cindy Lu <lulu@redhat.com>
Date: Tue, 9 Jul 2024 15:36:48 +0800
Message-ID: <CACLfguV5CXMs9AdWrN9a=st5PjUnT4B1bt2Uua=AYjuC0NwfNg@mail.gmail.com>
Subject: Re: [PATCH] vdpa/mlx5: Add the support of set mac address
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Parav Pandit <parav@nvidia.com>, "sgarzare@redhat.com" <sgarzare@redhat.com>, 
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>, 
	"jasowang@redhat.com" <jasowang@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Jul 2024 at 15:27, Dragos Tatulea <dtatulea@nvidia.com> wrote:
>
> On Mon, 2024-07-08 at 14:55 +0800, Cindy Lu wrote:
> > Add the function to support setting the MAC address.
> > For vdpa/mlx5, the function will use mlx5_mpfs_add_mac
> > to set the mac address
> >
> > Tested in ConnectX-6 Dx device
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/=
mlx5_vnet.c
> > index 26ba7da6b410..f78701386690 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -3616,10 +3616,33 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_=
dev *v_mdev, struct vdpa_device *
> >       destroy_workqueue(wq);
> >       mgtdev->ndev =3D NULL;
> >  }
> > +static int mlx5_vdpa_set_attr_mac(struct vdpa_mgmt_dev *v_mdev,
> > +                               struct vdpa_device *dev,
> > +                               const struct vdpa_dev_set_config *add_c=
onfig)
> > +{
> > +     struct mlx5_vdpa_dev *mvdev =3D to_mvdev(dev);
> > +     struct mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvdev);
> > +     struct mlx5_core_dev *mdev =3D mvdev->mdev;
> > +     struct virtio_net_config *config =3D &ndev->config;
> > +     int err;
> > +     struct mlx5_core_dev *pfmdev;
> > +
> You need to take the ndev->reslock.
>
thanks will change this
> > +     if (add_config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> > +             if (!is_zero_ether_addr(add_config->net.mac)) {
> > +                     memcpy(config->mac, add_config->net.mac, ETH_ALEN=
);
> I would do the memcpy after mlx5_mpfs_add_mac() was called successfully. =
This
> way the config gets changed only on success.
>
thanks Dragos=EF=BC=8C Will fix this
thanks
cindy
> > +                     pfmdev =3D pci_get_drvdata(pci_physfn(mdev->pdev)=
);
> > +                     err =3D mlx5_mpfs_add_mac(pfmdev, config->mac);
> > +                     if (err)
> > +                             return -1;
> > +             }
> > +     }
> > +     return 0;
> > +}
> >
> >  static const struct vdpa_mgmtdev_ops mdev_ops =3D {
> >       .dev_add =3D mlx5_vdpa_dev_add,
> >       .dev_del =3D mlx5_vdpa_dev_del,
> > +     .dev_set_attr =3D mlx5_vdpa_set_attr_mac,
> >  };
> >
> >  static struct virtio_device_id id_table[] =3D {
>
> Thanks,
> Dragos
>



Return-Path: <kvm+bounces-21155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4937B92B129
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 09:34:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6CAC281BDC
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 07:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349F4143C4D;
	Tue,  9 Jul 2024 07:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WXpRiFTd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FAB1422BC
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 07:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720510447; cv=none; b=Z862GvHWvY+fcUdzvpbKJKLIvGibml480tgv6lue34zmQLM4Pk4DZVYI474/cf/Rr3/3V0dXY2rsyZktgm4gJkW3TazZPquJHo+oIW2kkQkTRMY8UU+RqexIHaVmROXRnjByXN2ItHjsHJNDrbShZME8pmV1XpjE6Z9R7WoEuHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720510447; c=relaxed/simple;
	bh=LvqwmV+mNj/O+PlzBMrEoMU+zBOGk4FC9h2Eald0y+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P+6zOE+q7t6AOPVtJWmwN3XCxYCSsSVf+zTzMrjdIAtqo3V+rBMXXhahYVk7vSbGX9q0PVPuItbxUoc3MCd8PElMx5GmZ91+zQpx/zI/SeK8cewWaa7Munxo6tKa23my/pzYbMHD+h9mn9TeCRhrC2qsFDj7DOqYqYk1es7eFek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WXpRiFTd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720510444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gyffXFQ4XqEgnJu8KLX3RdgOxyAi68j9TS2gHHyn3kA=;
	b=WXpRiFTdl4p1XPdvphLTmy9y+3Fq3OWE0WbRh8Wed1WghrMnmaU25AcMdfxhNRQegQtzV6
	cKs4zA/ZV0Bc6JVeI3LFRVZ2+4I+FHdOmwT4zqwidqCMcBi+FxhAH/N3TN/i8uO2JlHeRu
	UBT8JCkOzTOFptCVd561Z7S/KODePZQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-GVJSOU8ZMjSYr-b7vUt09g-1; Tue, 09 Jul 2024 03:34:03 -0400
X-MC-Unique: GVJSOU8ZMjSYr-b7vUt09g-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-58e847f01f7so4030891a12.1
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 00:34:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720510442; x=1721115242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gyffXFQ4XqEgnJu8KLX3RdgOxyAi68j9TS2gHHyn3kA=;
        b=Ky0azpUd3oxFlhBNRI3tMS1mXTQdQsYgML0xrGgbeffmqfDVMxH4glSm0j7SE+UA1p
         Xt5CrkZiU3Kud/fMeesRaQ3bIrJ2gDd1wNC4PzmN5JqyHhRd+0iF8I6ZLqKd7t0zqycy
         eHhYOrooxPSFM/lpavdRPxli7EAjlrB8HqaAitNyYH1gIHcp41/Q/wAAyUzgWlSKTfAe
         Aek9W8neWszA3CZ89dLOVyQbiprLUOpntUaaSrD8+FiBunaTZOZzmzoVUiTlSKZPwFgg
         l6xP7H+TotQ2yjhPy7AGIKKszkVN6t+/z17xJ/b9h14lLbRXfkUvTi0+eQrv65yoSsp0
         z2Cg==
X-Forwarded-Encrypted: i=1; AJvYcCV+sUVqQF+IMLCVeMV6YR3tLy0UgJ75V+MpMDllvXEXhihIy4lVpJ4NgXfTQwpUqynxXeD5Cf76rX7Nd/7ANkCJzmRi
X-Gm-Message-State: AOJu0Ywzo9nDN4G87QxFQr8eXuve2BFD1ZRU5i/wgCYkcHi6FA9HvM/M
	txt1hl+JKcMxsuz3oQQHdNSLLV7AsG/ZWbVQWjRsxIYk++67AhdoaD+5U8sW+B8UnOZcdTusw+b
	VIWCuAKktJG45tkYbD5EYZOkTCsnLGjsTVu/HoTIHZnvAD+/mr3GGHaZJWkFyzGAx5LDJiVmWKM
	FSLDYEb2bmyJj6n6Kr/ctyiExI
X-Received: by 2002:a05:6402:651:b0:585:4048:129a with SMTP id 4fb4d7f45d1cf-594bc7c81camr942127a12.31.1720510442201;
        Tue, 09 Jul 2024 00:34:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjoc+fuN4z3jm6ivmOtDkLQnowZY0KxQCfvPi77uB0E9RhW33K2f9f+5Byd3P6tUmj0kBE7NSAeCnMjiI2G34=
X-Received: by 2002:a05:6402:651:b0:585:4048:129a with SMTP id
 4fb4d7f45d1cf-594bc7c81camr942110a12.31.1720510441792; Tue, 09 Jul 2024
 00:34:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708065549.89422-1-lulu@redhat.com> <CACGkMEtOP_Hz=SO+r5WQfWow3Pb-Sz552xnt0BqTgyGSuvJz_A@mail.gmail.com>
In-Reply-To: <CACGkMEtOP_Hz=SO+r5WQfWow3Pb-Sz552xnt0BqTgyGSuvJz_A@mail.gmail.com>
From: Cindy Lu <lulu@redhat.com>
Date: Tue, 9 Jul 2024 15:33:23 +0800
Message-ID: <CACLfguWqut4mf1=ad58Eb=HZCMnbgxzDk5DbFge-JU0beB1aFg@mail.gmail.com>
Subject: Re: [PATCH] vdpa/mlx5: Add the support of set mac address
To: Jason Wang <jasowang@redhat.com>
Cc: dtatulea@nvidia.com, mst@redhat.com, parav@nvidia.com, sgarzare@redhat.com, 
	netdev@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Jul 2024 at 15:03, Jason Wang <jasowang@redhat.com> wrote:
>
> On Mon, Jul 8, 2024 at 2:56=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
> >
> > Add the function to support setting the MAC address.
> > For vdpa/mlx5, the function will use mlx5_mpfs_add_mac
> > to set the mac address
> >
> > Tested in ConnectX-6 Dx device
>
> Great.
>
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
>
> I guess this should be part of the series "vdpa: support set mac
> address from vdpa tool" ?
>
yes, Will add this in next version
Thanks
cindy
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
> >         destroy_workqueue(wq);
> >         mgtdev->ndev =3D NULL;
> >  }
> > +static int mlx5_vdpa_set_attr_mac(struct vdpa_mgmt_dev *v_mdev,
> > +                                 struct vdpa_device *dev,
> > +                                 const struct vdpa_dev_set_config *add=
_config)
> > +{
> > +       struct mlx5_vdpa_dev *mvdev =3D to_mvdev(dev);
> > +       struct mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvdev);
> > +       struct mlx5_core_dev *mdev =3D mvdev->mdev;
> > +       struct virtio_net_config *config =3D &ndev->config;
> > +       int err;
> > +       struct mlx5_core_dev *pfmdev;
> > +
> > +       if (add_config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> > +               if (!is_zero_ether_addr(add_config->net.mac)) {
> > +                       memcpy(config->mac, add_config->net.mac, ETH_AL=
EN);
> > +                       pfmdev =3D pci_get_drvdata(pci_physfn(mdev->pde=
v));
> > +                       err =3D mlx5_mpfs_add_mac(pfmdev, config->mac);
> > +                       if (err)
> > +                               return -1;
> > +               }
> > +       }
> > +       return 0;
> > +}
> >
> >  static const struct vdpa_mgmtdev_ops mdev_ops =3D {
> >         .dev_add =3D mlx5_vdpa_dev_add,
> >         .dev_del =3D mlx5_vdpa_dev_del,
> > +       .dev_set_attr =3D mlx5_vdpa_set_attr_mac,
>
> Let's rename this as we will add the support for mtu as well or not?
>
sure ,will change this
Thanks
cindy
> Thanks
>
> >  };
> >
> >  static struct virtio_device_id id_table[] =3D {
> > --
> > 2.45.0
> >
>



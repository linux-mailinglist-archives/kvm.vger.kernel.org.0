Return-Path: <kvm+bounces-19580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 442A79073B8
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 15:30:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1FF41F21C33
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 13:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC9AE144D2C;
	Thu, 13 Jun 2024 13:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gn58lC0F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8067D144D0C
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 13:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718285388; cv=none; b=HsB+OWvpx8h5iob7bxy70tMEJ4a1UdOIqfBcDZZ+ogUYrLuDJqNPLGW22lvVimBRNO5a/Ksv+1QoCbrVcL1C3soky3HCRlg/4uHUH5PYiC1OY1rjSTPbv4Z2AOAYMxMVbQRB1UOVlqzSMxh+8ypP8PyQI+L/S1oqDRoVP3NKCB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718285388; c=relaxed/simple;
	bh=EwDYV86apdp1y3FgvqhXoUdcP6ZAutdGUFD8nB4Rupc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QjEVz9OjXQzJnor3JOw0mFG2QOJQpxftM5QiudBmh1ZPdRGhENAZ/4zB/IStYU5lZwCkQ5bL+OVM8f+VKoXLq2c79yscSwGCZMxm623fw8tZVSV1pUz3cdSZkhS8Fj1mOKpW4GjmR3lc4OD8ZpFUfz09inD1c8cEQItQpDcyats=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gn58lC0F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718285385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y9evobZ56tePgOcIz6BoUUANwCX8e2L9RTd9imGKDRo=;
	b=gn58lC0F7YRH1Ed+QnaEAiKC4OtiMuUVk+4wo2SmvW5BETV+97QmQnD89nVSDLcDgnlTDL
	W6in+YzPTT17GVDZn/Zi8lWp7OyMyK6A/TwNYOCVTbpZOUhzCtKVeWZNCULac1+pB46fr6
	TURmVhP8g8/kB78o/Y2ezjd/uOIzcHA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-n7uNFULUNge3gLubF-pavA-1; Thu, 13 Jun 2024 09:29:43 -0400
X-MC-Unique: n7uNFULUNge3gLubF-pavA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a6def6e9ef2so157368566b.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 06:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718285382; x=1718890182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9evobZ56tePgOcIz6BoUUANwCX8e2L9RTd9imGKDRo=;
        b=b3xBH52DZogmaai9mzXIFf7hGwffepvAzWv8HNTHMti/LLQlnuZy0/LSlFZL4NM01k
         TLksIGuCi/BQBwedIFsswwy3YOZS2GJaC/AXN427zoRiGBD7qnyybR3LS4dpUZ3hPiFg
         qdEZTJHNYS0f3MIBGjlADJGsecrR/tQJWGAh9WxAHAudiH4kqtAC8v8a3kKJ1e8sZqis
         zyQKtjh8l1XlXNJqKcTKuU1P0O8mNeir93Z+n3fixqfzShWdpp5cb9qXPa9HdlvQWpXL
         2QGZWKQR7Ks4OheaVUOz4eAAKrksh0cL5S0AefBN2LsTyw3sw2B+2UUbkUz/6rACzO8m
         KJag==
X-Forwarded-Encrypted: i=1; AJvYcCV7izSgHxq3R5/Lbk2T9N0ExHLdYh9WSwqsYNnFSz8APvOba0vm1xL/j57MziA1/wJjS/CaYcFLyyat1wkDSQhfRgtO
X-Gm-Message-State: AOJu0YwuOX4ADG/8hlE0FSEri2LhqfYcMcqT8M8Hq8FFmsd9eM5eFN7U
	N4NNl/PVx9I7NmNgiXixvBKku6y5KXrbBgTYj7xrt7Cq/QEErcG9N6o3wfD4q6ASEL5pEIqFHid
	m4rxXC0RWbeUT+Npbx+yHDMw/zx0EJqbNtuxJuVAATwRPSXHkP+jMw5VQkA6pq8DP05jNT+yaDi
	v+p7Yd21WQefyN+VO50LIwja+H
X-Received: by 2002:a17:906:f2cf:b0:a6f:1c0e:6776 with SMTP id a640c23a62f3a-a6f5240f021mr181403166b.16.1718285382604;
        Thu, 13 Jun 2024 06:29:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUeOJDpHV2LdwavarsbYi5bPL2vRysrQ5fKaLl/dCD/lbPcIEg1tjiBX4sLf6XM7kiJX4bP1FfUh1UTOsXPLI=
X-Received: by 2002:a17:906:f2cf:b0:a6f:1c0e:6776 with SMTP id
 a640c23a62f3a-a6f5240f021mr181401766b.16.1718285382121; Thu, 13 Jun 2024
 06:29:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611053239.516996-1-lulu@redhat.com> <20240613025548-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240613025548-mutt-send-email-mst@kernel.org>
From: Cindy Lu <lulu@redhat.com>
Date: Thu, 13 Jun 2024 21:29:04 +0800
Message-ID: <CACLfguWwkkfFA143uOavS0jDkW1Q0XEd5JZDdriOz-yywDkYng@mail.gmail.com>
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: dtatulea@nvidia.com, jasowang@redhat.com, 
	virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2024 at 2:59=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Jun 11, 2024 at 01:32:32PM +0800, Cindy Lu wrote:
> > Add new UAPI to support the mac address from vdpa tool
> > Function vdpa_nl_cmd_dev_config_set_doit() will get the
> > MAC address from the vdpa tool and then set it to the device.
> >
> > The usage is: vdpa dev set name vdpa_name mac **:**:**:**:**:**
> >
> > Here is sample:
> > root@L1# vdpa -jp dev config show vdpa0
> > {
> >     "config": {
> >         "vdpa0": {
> >             "mac": "82:4d:e9:5d:d7:e6",
> >             "link ": "up",
> >             "link_announce ": false,
> >             "mtu": 1500
> >         }
> >     }
> > }
> >
> > root@L1# vdpa dev set name vdpa0 mac 00:11:22:33:44:55
> >
> > root@L1# vdpa -jp dev config show vdpa0
> > {
> >     "config": {
> >         "vdpa0": {
> >             "mac": "00:11:22:33:44:55",
> >             "link ": "up",
> >             "link_announce ": false,
> >             "mtu": 1500
> >         }
> >     }
> > }
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
>
>
>
> I think actually the idea of allowing provisioning
> by specifying config of the device is actually valid.
> However
> - the name SET_CONFIG makes people think this allows
>   writing even when e.g. device is assigned to guest
> - having the internal api be mac specific is weird
>
> Shouldn't config be an attribute maybe, not a new command?
>
Got it. Thanks, Michael. I will change this.
Thanks
Cindy
>
> > ---
> >  drivers/vdpa/vdpa.c       | 71 +++++++++++++++++++++++++++++++++++++++
> >  include/linux/vdpa.h      |  2 ++
> >  include/uapi/linux/vdpa.h |  1 +
> >  3 files changed, 74 insertions(+)
> >
> > diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> > index a7612e0783b3..347ae6e7749d 100644
> > --- a/drivers/vdpa/vdpa.c
> > +++ b/drivers/vdpa/vdpa.c
> > @@ -1149,6 +1149,72 @@ static int vdpa_nl_cmd_dev_config_get_doit(struc=
t sk_buff *skb, struct genl_info
> >       return err;
> >  }
> >
> > +static int vdpa_nl_cmd_dev_config_set_doit(struct sk_buff *skb,
> > +                                        struct genl_info *info)
> > +{
> > +     struct vdpa_dev_set_config set_config =3D {};
> > +     struct nlattr **nl_attrs =3D info->attrs;
> > +     struct vdpa_mgmt_dev *mdev;
> > +     const u8 *macaddr;
> > +     const char *name;
> > +     int err =3D 0;
> > +     struct device *dev;
> > +     struct vdpa_device *vdev;
> > +
> > +     if (!info->attrs[VDPA_ATTR_DEV_NAME])
> > +             return -EINVAL;
> > +
> > +     name =3D nla_data(info->attrs[VDPA_ATTR_DEV_NAME]);
> > +
> > +     down_write(&vdpa_dev_lock);
> > +     dev =3D bus_find_device(&vdpa_bus, NULL, name, vdpa_name_match);
> > +     if (!dev) {
> > +             NL_SET_ERR_MSG_MOD(info->extack, "device not found");
> > +             err =3D -ENODEV;
> > +             goto dev_err;
> > +     }
> > +     vdev =3D container_of(dev, struct vdpa_device, dev);
> > +     if (!vdev->mdev) {
> > +             NL_SET_ERR_MSG_MOD(
> > +                     info->extack,
> > +                     "Fail to find the specified management device");
> > +             err =3D -EINVAL;
> > +             goto mdev_err;
> > +     }
> > +     mdev =3D vdev->mdev;
> > +     if (nl_attrs[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
> > +             if (!(mdev->supported_features & BIT_ULL(VIRTIO_NET_F_MAC=
))) {
> > +                     NL_SET_ERR_MSG_FMT_MOD(
> > +                             info->extack,
> > +                             "Missing features 0x%llx for provided att=
ributes",
> > +                             BIT_ULL(VIRTIO_NET_F_MAC));
> > +                     err =3D -EINVAL;
> > +                     goto mdev_err;
> > +             }
> > +             macaddr =3D nla_data(nl_attrs[VDPA_ATTR_DEV_NET_CFG_MACAD=
DR]);
> > +             memcpy(set_config.net.mac, macaddr, ETH_ALEN);
> > +             set_config.mask |=3D BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADD=
R);
> > +             if (mdev->ops->set_mac) {
> > +                     err =3D mdev->ops->set_mac(mdev, vdev, &set_confi=
g);
> > +             } else {
> > +                     NL_SET_ERR_MSG_FMT_MOD(
> > +                             info->extack,
> > +                             "%s device not support set mac address ",=
 name);
> > +             }
> > +
> > +     } else {
> > +             NL_SET_ERR_MSG_FMT_MOD(info->extack,
> > +                                    "%s device not support this config=
 ",
> > +                                    name);
> > +     }
> > +
> > +mdev_err:
> > +     put_device(dev);
> > +dev_err:
> > +     up_write(&vdpa_dev_lock);
> > +     return err;
> > +}
> > +
> >  static int vdpa_dev_config_dump(struct device *dev, void *data)
> >  {
> >       struct vdpa_device *vdev =3D container_of(dev, struct vdpa_device=
, dev);
> > @@ -1285,6 +1351,11 @@ static const struct genl_ops vdpa_nl_ops[] =3D {
> >               .doit =3D vdpa_nl_cmd_dev_stats_get_doit,
> >               .flags =3D GENL_ADMIN_PERM,
> >       },
> > +     {
> > +             .cmd =3D VDPA_CMD_DEV_CONFIG_SET,
> > +             .doit =3D vdpa_nl_cmd_dev_config_set_doit,
> > +             .flags =3D GENL_ADMIN_PERM,
> > +     },
> >  };
> >
> >  static struct genl_family vdpa_nl_family __ro_after_init =3D {
> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> > index db15ac07f8a6..c97f4f1da753 100644
> > --- a/include/linux/vdpa.h
> > +++ b/include/linux/vdpa.h
> > @@ -581,6 +581,8 @@ struct vdpa_mgmtdev_ops {
> >       int (*dev_add)(struct vdpa_mgmt_dev *mdev, const char *name,
> >                      const struct vdpa_dev_set_config *config);
> >       void (*dev_del)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *d=
ev);
> > +     int (*set_mac)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *de=
v,
> > +                    const struct vdpa_dev_set_config *config);
> >  };
> >
> >  /**
> > diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
> > index 54b649ab0f22..53f249fb26bc 100644
> > --- a/include/uapi/linux/vdpa.h
> > +++ b/include/uapi/linux/vdpa.h
> > @@ -19,6 +19,7 @@ enum vdpa_command {
> >       VDPA_CMD_DEV_GET,               /* can dump */
> >       VDPA_CMD_DEV_CONFIG_GET,        /* can dump */
> >       VDPA_CMD_DEV_VSTATS_GET,
> > +     VDPA_CMD_DEV_CONFIG_SET,
> >  };
> >
> >  enum vdpa_attr {
> > --
> > 2.45.0
>



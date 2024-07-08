Return-Path: <kvm+bounces-21088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7078929DDB
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 10:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D1542841A3
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 08:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A24C42077;
	Mon,  8 Jul 2024 08:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="boJp+ts7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FB03BBCB
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 08:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720425701; cv=none; b=Lupeh0fXWZ2+dpOcWg07tJGxWy3QwrD2edSE8Zz8RUP6dCH7QwovswvzLPEUfdC+Toekd//5uIKXatcDeZkvZ/5IKM8MMhPiAZJsWgZ5AnqUblsX7ijafOTxTGLDBzj7Ers8/EgiA9Y7ZTS1yUhlPAwLsyO3QaLThGAmPusqXoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720425701; c=relaxed/simple;
	bh=nlLhLflDa5bMvjhaApP9IsLVRkmOHEF5QWS4D2zNHw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uWsUqrNjPy3Vr6YPoyG/rUyUq3f9YKAkBsP/W8lZgQaAvdgzOipnYo5IjShkHag2xzWwL7vKT4T9b5VrVeMzv+sVoLm1veWfyiORCTJIoJsucMNUjweEZfvd6l1yd7D76CqglENpxvy9Z3FR8rSr73BqlVZWvkosPDm3QvgFe6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=boJp+ts7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720425699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=27lMaNCb81p4YFFh+LEEn0k8qDHH12ozaV7hZRSJBCA=;
	b=boJp+ts7ssmuUonQFnXVcWqf2uGMpEaeHrrGWuQc4Ftwv1Svg9fHe0EvEkFJT/A3EZOfNy
	PEAHQaPe9mUbLyCmgGsRGaxVIKP4sJ9LDfwj3znhfg1SMmKH7uNM9zHxHHXn2kdFo5ztNb
	takF+EWLjd385X5f2jWVB+RvS/T+WAY=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-DGUQJQtqONOE2OQqGDu2JA-1; Mon, 08 Jul 2024 04:01:34 -0400
X-MC-Unique: DGUQJQtqONOE2OQqGDu2JA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1fb268028d2so20288235ad.1
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 01:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720425693; x=1721030493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=27lMaNCb81p4YFFh+LEEn0k8qDHH12ozaV7hZRSJBCA=;
        b=J/3JqzBirGgzJYW3lGACQqjw57CdD7kGgUUoHyxTNPF/GOiOMUZxDIh9wtXGWKVMLu
         d/sQdbW2WUpDSoMw23XyjMJU6M2kkpQmuH1ORxO5cPrrAw7aKblJJ1s1eiNcx2PaaVZU
         HNpYX9z+m1QRkS/C/y4wChm+DYURvTJIYGBetzd26zq1Atwp0JJpe796e8dapZH1bsAh
         LaJTPnTuWxbEfLGysNTjPWgvIEhgLu4V4TREJVZ2OeCUQ6dOQQm6XAli2OluP1HAJJJQ
         CHjKYZZ/ndOK9eRdPQoclWjkxrN8rTW3EH7W0QppIYrQQXfM6jNJajh3rTbB1DVjM3IO
         UQbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUduRZoMIeUQZwvnXhcqkzEKNlYTxN5W/anvWYqSGVD1kfhg5ZUpKmj79cv9fxtKHzJ+kvWtKoq4jBUfEnLBylQKFuI
X-Gm-Message-State: AOJu0Yzg4wKfXScZaw48i21b0ioS6QNJvVSvg6RfPDX9BjN580S5G7of
	wmjmhJ78KLTSHqimtW/iR0b3fahhdM7c2VdV/HaMpmGIRBUg8VKidzQ/IHFRIxyWaIBE+XOBawl
	Y/f9am4cTqmlNzPCdFLBC5sqEnBHS52vZONyO/xhZHTsRtA2IwxT22LbFUdRArmbV1wWGUE0vaT
	+lnOFM80yy41SgoS8I/tN4ciGm
X-Received: by 2002:a17:903:1252:b0:1fb:a1c6:db75 with SMTP id d9443c01a7336-1fba1c6de04mr6881675ad.6.1720425693354;
        Mon, 08 Jul 2024 01:01:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7tEwJUQ3jL/FURLCL1Fmxt7rfHgT6zXgifTSPRjjPgC0FTxqJiDiptLT5gVxmpCf9aR+PWLt24EtwHzQHJqA=
X-Received: by 2002:a17:903:1252:b0:1fb:a1c6:db75 with SMTP id
 d9443c01a7336-1fba1c6de04mr6881415ad.6.1720425692886; Mon, 08 Jul 2024
 01:01:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708064820.88955-1-lulu@redhat.com> <20240708064820.88955-3-lulu@redhat.com>
 <CACGkMEum7Ufgkez9p4-o9tfYBqfvPUA+BPrxZD8gF7PmWVhE2g@mail.gmail.com> <CACLfguXdL_FvdvReQrzvKvzJrHnE9gcTv+rLYsCNB0HtvXC74w@mail.gmail.com>
In-Reply-To: <CACLfguXdL_FvdvReQrzvKvzJrHnE9gcTv+rLYsCNB0HtvXC74w@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 8 Jul 2024 16:01:21 +0800
Message-ID: <CACGkMEuOz_fsBnX8BNnbUHMdNo48S8cEUT4M6O0_oBsSKRJmLQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] vdpa_sim_net: Add the support of set mac address
To: Cindy Lu <lulu@redhat.com>
Cc: dtatulea@nvidia.com, mst@redhat.com, parav@nvidia.com, sgarzare@redhat.com, 
	netdev@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 3:19=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> On Mon, 8 Jul 2024 at 15:06, Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Mon, Jul 8, 2024 at 2:48=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote=
:
> > >
> > > Add the function to support setting the MAC address.
> > > For vdpa_sim_net, the driver will write the MAC address
> > > to the config space, and other devices can implement
> > > their own functions to support this.
> > >
> > > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > > ---
> > >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 19 ++++++++++++++++++-
> > >  1 file changed, 18 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa=
_sim/vdpa_sim_net.c
> > > index cfe962911804..a472c3c43bfd 100644
> > > --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> > > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> > > @@ -414,6 +414,22 @@ static void vdpasim_net_get_config(struct vdpasi=
m *vdpasim, void *config)
> > >         net_config->status =3D cpu_to_vdpasim16(vdpasim, VIRTIO_NET_S=
_LINK_UP);
> > >  }
> > >
> > > +static int vdpasim_net_set_attr(struct vdpa_mgmt_dev *mdev,
> > > +                               struct vdpa_device *dev,
> > > +                               const struct vdpa_dev_set_config *con=
fig)
> > > +{
> > > +       struct vdpasim *vdpasim =3D container_of(dev, struct vdpasim,=
 vdpa);
> > > +
> > > +       struct virtio_net_config *vio_config =3D vdpasim->config;
> > > +       if (config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> > > +               if (!is_zero_ether_addr(config->net.mac)) {
> > > +                       memcpy(vio_config->mac, config->net.mac, ETH_=
ALEN);
> > > +                       return 0;
> > > +               }
> > > +       }
> > > +       return -EINVAL;
> >
> > I think in the previous version, we agreed to have a lock to
> > synchronize the writing here?
> >
> > Thanks
> >
> Hi Jason
> I have moved the down_write(&vdev->cf_lock) and
> up_write(&vdev->cf_lock) to the function vdpa_dev_net_device_attr_set
> in vdpa/vdpa.c. Then the device itself doesn't need to call it again.
> Do you think this is ok?

I meant we have another path to modify the mac:

static virtio_net_ctrl_ack vdpasim_handle_ctrl_mac(struct vdpasim *vdpasim,
                                                   u8 cmd)
{
        struct virtio_net_config *vio_config =3D vdpasim->config;
        struct vdpasim_virtqueue *cvq =3D &vdpasim->vqs[2];
        virtio_net_ctrl_ack status =3D VIRTIO_NET_ERR;
        size_t read;

        switch (cmd) {
case VIRTIO_NET_CTRL_MAC_ADDR_SET:
                read =3D vringh_iov_pull_iotlb(&cvq->vring, &cvq->in_iov,
                                             vio_config->mac, ETH_ALEN);
                if (read =3D=3D ETH_ALEN)
            status =3D VIRTIO_NET_OK;
        break;
        default:
                break;
        }

        return status;
}

We need to serialize between them.

Thanks

> Thanks
> Cindy
> > > +}
> > > +
> > >  static void vdpasim_net_setup_config(struct vdpasim *vdpasim,
> > >                                      const struct vdpa_dev_set_config=
 *config)
> > >  {
> > > @@ -510,7 +526,8 @@ static void vdpasim_net_dev_del(struct vdpa_mgmt_=
dev *mdev,
> > >
> > >  static const struct vdpa_mgmtdev_ops vdpasim_net_mgmtdev_ops =3D {
> > >         .dev_add =3D vdpasim_net_dev_add,
> > > -       .dev_del =3D vdpasim_net_dev_del
> > > +       .dev_del =3D vdpasim_net_dev_del,
> > > +       .dev_set_attr =3D vdpasim_net_set_attr
> > >  };
> > >
> > >  static struct virtio_device_id id_table[] =3D {
> > > --
> > > 2.45.0
> > >
> >
>



Return-Path: <kvm+bounces-13822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D74E389AE50
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 05:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 643401F224D1
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 03:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71077460;
	Sun,  7 Apr 2024 03:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F18ZHTop"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537C117C9
	for <kvm@vger.kernel.org>; Sun,  7 Apr 2024 03:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712461103; cv=none; b=tKaP7xOHeL1bJQocWZxTEywNigkLh37UA2s5m13W6S9UbDj5oxNY92TwOsMvKYwral+K7lMFxmGFV84w5n4QIXBnbT6Nfi9Exh7W/EmpjWk2iLhBdM91NgkFAmnWTDf4Q62mdZsZNiNieFVxBsvDdB/TXTN/um50LP3WH2qV/YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712461103; c=relaxed/simple;
	bh=YQxadVvuF0J+SJvGU+MNROeYzSRs1jdUcSSxhujJhzk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZZ8i74HQ6IFp/cPINawPfcs/yQ7CB1jDNDYNskdnbRXzakeQwIBhf5aeuGp/TuNmKPapouCHWED6241LNIs/wgR9WF5dzQKI1x8hcEAop8x4+Mf4iJsGZnuEr0EKtOnxZGh0vtv0lMk6in2juTDz+9dsyLPVdTMDeYYn2YZ6fZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F18ZHTop; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712461100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JzWbsQPfAHE2Fu4sEEMuYyZFoRf+hMudhcgkTJElxG0=;
	b=F18ZHTopl6YMYzUB3O2/a04e3Aur+RQe59O4K+z5bGGMe2XiAHnSz/iA2gPdW/uQepuiwZ
	GHg5TktnmKVZiYxeYROI/G787pzR38UF5msrP0PTLhqSzs6AVcWGfqxxe0YBu8QrnEgHVk
	aoIuIFqX06Y3LuXJgR9igv4Jl4Pt0/E=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-4RYo2M8XPYu1V6EnJi3-3g-1; Sat, 06 Apr 2024 23:38:18 -0400
X-MC-Unique: 4RYo2M8XPYu1V6EnJi3-3g-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2a4b48d7a19so380069a91.1
        for <kvm@vger.kernel.org>; Sat, 06 Apr 2024 20:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712461097; x=1713065897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JzWbsQPfAHE2Fu4sEEMuYyZFoRf+hMudhcgkTJElxG0=;
        b=IY5QBpX0p5t60EwJytxjff1feLxOmnPXKWengBu0qFaTaVCb8srfG3ZAKp3z6waj1G
         RbHadK0YDMjcdPjuSo9nmHeihGaNMCNhXwyJAb3J9KVH3vdu+wbTI8IST3qDaA66QeLB
         eAUsGmv3LmdGSqecdxZarBp0zg9gTLsbZLNOST76nqh+WJjQMFEnYY0CfX8MStjg7jpM
         bREueh8E+Y1IvMzrLR/K+tAAcpPedmYunTP1589eP9/UMK0Mb67kTj0I9P6xVXFvVSz2
         Ef6PjFNM00YWQdDPNj18srDDUOYQr4XjLIIyAnzRgzmjPp45Q/r1PJcKdoQhsg5N4jXn
         D4Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWQCSDjI5jY+vSkBSL86S8fSJj1sDOo7v6Ki34l6DHYws51KhZAml5dQx0qY4gpkFFWaolHR1z9NtD+YaRnPTfZzq1T
X-Gm-Message-State: AOJu0YyVo38gbhbNpC1U+8x7V0mQ76aLjSsF4of42iJsz0CyoamI5oPQ
	3QTBdlfshJKYCRT7CSFsNTU8rVpxMbT2I2UjnlpL6qDYNGokW6C7NcGsFqL2Nl3ZoYRI8amEu3c
	mo8p31mDg3F2UFSttcsgDdVs0WQQhQATw8kwuN94m+7pmMSB3S3k/+85fEp0OkEseFyfqTp22R9
	kejCuwx55zcCX3KeQfEEKc1fIa
X-Received: by 2002:a17:90a:178b:b0:29f:76d4:306a with SMTP id q11-20020a17090a178b00b0029f76d4306amr6710460pja.24.1712461097571;
        Sat, 06 Apr 2024 20:38:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNALvsPcbitPftgtL8pJI/fSek5yRGrsuflUQovxhWJ3XJKMl1GIzz225ORIag6ldXLxQeiIItvz0/8Do5/DY=
X-Received: by 2002:a17:90a:178b:b0:29f:76d4:306a with SMTP id
 q11-20020a17090a178b00b0029f76d4306amr6710446pja.24.1712461097235; Sat, 06
 Apr 2024 20:38:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320101912.28210-1-w_angrong@163.com> <20240321025920-mutt-send-email-mst@kernel.org>
 <CACGkMEuHRf0ZfBiAYxyNHB3pxuzz=QCWt5VyHPLz-+-+LM=+bg@mail.gmail.com>
 <20240329051117-mutt-send-email-mst@kernel.org> <CACGkMEsdjdMNqe2OaJcpKGPSs0+BCK-qq6i6QZmJSvt+M5p8QQ@mail.gmail.com>
 <20240329064114-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240329064114-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Sun, 7 Apr 2024 11:38:06 +0800
Message-ID: <CACGkMEtEwe9rMD=3AKP-fZw+aiw5mAHcaqRo0dPnPnAyB-k3jw@mail.gmail.com>
Subject: Re: [PATCH v3] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Wang Rong <w_angrong@163.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 29, 2024 at 6:42=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, Mar 29, 2024 at 06:39:33PM +0800, Jason Wang wrote:
> > On Fri, Mar 29, 2024 at 5:13=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Wed, Mar 27, 2024 at 05:08:57PM +0800, Jason Wang wrote:
> > > > On Thu, Mar 21, 2024 at 3:00=E2=80=AFPM Michael S. Tsirkin <mst@red=
hat.com> wrote:
> > > > >
> > > > > On Wed, Mar 20, 2024 at 06:19:12PM +0800, Wang Rong wrote:
> > > > > > From: Rong Wang <w_angrong@163.com>
> > > > > >
> > > > > > Once enable iommu domain for one device, the MSI
> > > > > > translation tables have to be there for software-managed MSI.
> > > > > > Otherwise, platform with software-managed MSI without an
> > > > > > irq bypass function, can not get a correct memory write event
> > > > > > from pcie, will not get irqs.
> > > > > > The solution is to obtain the MSI phy base address from
> > > > > > iommu reserved region, and set it to iommu MSI cookie,
> > > > > > then translation tables will be created while request irq.
> > > > > >
> > > > > > Change log
> > > > > > ----------
> > > > > >
> > > > > > v1->v2:
> > > > > > - add resv iotlb to avoid overlap mapping.
> > > > > > v2->v3:
> > > > > > - there is no need to export the iommu symbol anymore.
> > > > > >
> > > > > > Signed-off-by: Rong Wang <w_angrong@163.com>
> > > > >
> > > > > There's in interest to keep extending vhost iotlb -
> > > > > we should just switch over to iommufd which supports
> > > > > this already.
> > > >
> > > > IOMMUFD is good but VFIO supports this before IOMMUFD.
> > >
> > > You mean VFIO migrated to IOMMUFD but of course they keep supporting
> > > their old UAPI?
> >
> > I meant VFIO support software managed MSI before IOMMUFD.
>
> And then they switched over and stopped adding new IOMMU
> related features. And so should vdpa?

For some cloud vendors, it means vDPA can't be used until

1) IOMMUFD support for vDPA is supported by upstream
2) IOMMUFD is backported

1) might be fine but 2) might be impossible.

Assuming IOMMUFD hasn't been done for vDPA. Adding small features like
this seems reasonable (especially considering it is supported by the
"legacy" VFIO container).

Thanks

>
>
> > > OK and point being?
> > >
> > > > This patch
> > > > makes vDPA run without a backporting of full IOMMUFD in the product=
ion
> > > > environment. I think it's worth.
> > >
> > > Where do we stop? saying no to features is the only tool maintainers
> > > have to make cleanups happen, otherwise people will just keep piling
> > > stuff up.
> >
> > I think we should not have more features than VFIO without IOMMUFD.
> >
> > Thanks
> >
> > >
> > > > If you worry about the extension, we can just use the vhost iotlb
> > > > existing facility to do this.
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > > ---
> > > > > >  drivers/vhost/vdpa.c | 59 ++++++++++++++++++++++++++++++++++++=
+++++---
> > > > > >  1 file changed, 56 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > > > index ba52d128aeb7..28b56b10372b 100644
> > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > @@ -49,6 +49,7 @@ struct vhost_vdpa {
> > > > > >       struct completion completion;
> > > > > >       struct vdpa_device *vdpa;
> > > > > >       struct hlist_head as[VHOST_VDPA_IOTLB_BUCKETS];
> > > > > > +     struct vhost_iotlb resv_iotlb;
> > > > > >       struct device dev;
> > > > > >       struct cdev cdev;
> > > > > >       atomic_t opened;
> > > > > > @@ -247,6 +248,7 @@ static int _compat_vdpa_reset(struct vhost_=
vdpa *v)
> > > > > >  static int vhost_vdpa_reset(struct vhost_vdpa *v)
> > > > > >  {
> > > > > >       v->in_batch =3D 0;
> > > > > > +     vhost_iotlb_reset(&v->resv_iotlb);
> > > > > >       return _compat_vdpa_reset(v);
> > > > > >  }
> > > > > >
> > > > > > @@ -1219,10 +1221,15 @@ static int vhost_vdpa_process_iotlb_upd=
ate(struct vhost_vdpa *v,
> > > > > >           msg->iova + msg->size - 1 > v->range.last)
> > > > > >               return -EINVAL;
> > > > > >
> > > > > > +     if (vhost_iotlb_itree_first(&v->resv_iotlb, msg->iova,
> > > > > > +                                     msg->iova + msg->size - 1=
))
> > > > > > +             return -EINVAL;
> > > > > > +
> > > > > >       if (vhost_iotlb_itree_first(iotlb, msg->iova,
> > > > > >                                   msg->iova + msg->size - 1))
> > > > > >               return -EEXIST;
> > > > > >
> > > > > > +
> > > > > >       if (vdpa->use_va)
> > > > > >               return vhost_vdpa_va_map(v, iotlb, msg->iova, msg=
->size,
> > > > > >                                        msg->uaddr, msg->perm);
> > > > > > @@ -1307,6 +1314,45 @@ static ssize_t vhost_vdpa_chr_write_iter=
(struct kiocb *iocb,
> > > > > >       return vhost_chr_write_iter(dev, from);
> > > > > >  }
> > > > > >
> > > > > > +static int vhost_vdpa_resv_iommu_region(struct iommu_domain *d=
omain, struct device *dma_dev,
> > > > > > +     struct vhost_iotlb *resv_iotlb)
> > > > > > +{
> > > > > > +     struct list_head dev_resv_regions;
> > > > > > +     phys_addr_t resv_msi_base =3D 0;
> > > > > > +     struct iommu_resv_region *region;
> > > > > > +     int ret =3D 0;
> > > > > > +     bool with_sw_msi =3D false;
> > > > > > +     bool with_hw_msi =3D false;
> > > > > > +
> > > > > > +     INIT_LIST_HEAD(&dev_resv_regions);
> > > > > > +     iommu_get_resv_regions(dma_dev, &dev_resv_regions);
> > > > > > +
> > > > > > +     list_for_each_entry(region, &dev_resv_regions, list) {
> > > > > > +             ret =3D vhost_iotlb_add_range_ctx(resv_iotlb, reg=
ion->start,
> > > > > > +                             region->start + region->length - =
1,
> > > > > > +                             0, 0, NULL);
> > > > > > +             if (ret) {
> > > > > > +                     vhost_iotlb_reset(resv_iotlb);
> > > > > > +                     break;
> > > > > > +             }
> > > > > > +
> > > > > > +             if (region->type =3D=3D IOMMU_RESV_MSI)
> > > > > > +                     with_hw_msi =3D true;
> > > > > > +
> > > > > > +             if (region->type =3D=3D IOMMU_RESV_SW_MSI) {
> > > > > > +                     resv_msi_base =3D region->start;
> > > > > > +                     with_sw_msi =3D true;
> > > > > > +             }
> > > > > > +     }
> > > > > > +
> > > > > > +     if (!ret && !with_hw_msi && with_sw_msi)
> > > > > > +             ret =3D iommu_get_msi_cookie(domain, resv_msi_bas=
e);
> > > > > > +
> > > > > > +     iommu_put_resv_regions(dma_dev, &dev_resv_regions);
> > > > > > +
> > > > > > +     return ret;
> > > > > > +}
> > > > > > +
> > > > > >  static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
> > > > > >  {
> > > > > >       struct vdpa_device *vdpa =3D v->vdpa;
> > > > > > @@ -1335,11 +1381,16 @@ static int vhost_vdpa_alloc_domain(stru=
ct vhost_vdpa *v)
> > > > > >
> > > > > >       ret =3D iommu_attach_device(v->domain, dma_dev);
> > > > > >       if (ret)
> > > > > > -             goto err_attach;
> > > > > > +             goto err_alloc_domain;
> > > > > >
> > > > > > -     return 0;
> > > > > > +     ret =3D vhost_vdpa_resv_iommu_region(v->domain, dma_dev, =
&v->resv_iotlb);
> > > > > > +     if (ret)
> > > > > > +             goto err_attach_device;
> > > > > >
> > > > > > -err_attach:
> > > > > > +     return 0;
> > > > > > +err_attach_device:
> > > > > > +     iommu_detach_device(v->domain, dma_dev);
> > > > > > +err_alloc_domain:
> > > > > >       iommu_domain_free(v->domain);
> > > > > >       v->domain =3D NULL;
> > > > > >       return ret;
> > > > > > @@ -1595,6 +1646,8 @@ static int vhost_vdpa_probe(struct vdpa_d=
evice *vdpa)
> > > > > >               goto err;
> > > > > >       }
> > > > > >
> > > > > > +     vhost_iotlb_init(&v->resv_iotlb, 0, 0);
> > > > > > +
> > > > > >       r =3D dev_set_name(&v->dev, "vhost-vdpa-%u", minor);
> > > > > >       if (r)
> > > > > >               goto err;
> > > > > > --
> > > > > > 2.27.0
> > > > > >
> > > > >
> > >
>



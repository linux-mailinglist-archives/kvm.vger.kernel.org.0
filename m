Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890F754F99C
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 16:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382947AbiFQOr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 10:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382945AbiFQOrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 10:47:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44B622DD
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 07:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655477251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uTqHz4jzt2D3Rjkah2DCrjZXWvdHUasIzpW9EJieYN8=;
        b=iTSV9W2XDcV7v+7fkIU9wbKCge/Yq1OLkYtWdlaH7A31+WD39KHxheBIMkqZHV2yIJIgDm
        u4DuFIYF8HwCtZCkeuL9iNPBs/N8bv+tenJrtk93VTlsFRq2l9E1C5NRBG90GkIh+bafct
        vka7jJQQdlfobDFjCH8T7evBjUAT1i0=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-BIlK40WXOnOX8G1E9wQMjA-1; Fri, 17 Jun 2022 10:47:30 -0400
X-MC-Unique: BIlK40WXOnOX8G1E9wQMjA-1
Received: by mail-io1-f71.google.com with SMTP id k5-20020a6bba05000000b00668eb755190so2629511iof.13
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 07:47:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uTqHz4jzt2D3Rjkah2DCrjZXWvdHUasIzpW9EJieYN8=;
        b=Oq2TS6u2JP95uHNCdHsQzu1z6Oh7RmtwoFb8Qfu1p4xPn8x90a8dhGktOhjciryybA
         9X22sC8s9fJXnRVjjJ524qW3mWtki3Oiz8PyuKFQTbzBTOtOjchuTZZpML2aXkG8semr
         dxipClhiRMSZsvgJU1OcHs8EdDiw1X3LFxFWVB9mf9+pKFMSYIzR7BnmONBm5Yf0o/Lp
         3+o4NQAuk7lL+WRmnPgmKVkdOPnUppa6Cq4XiyD7SoAcowHANPL6ZrDf60uJEeLsQhvi
         /+hHjQl+YMSJNusEi2rBk2IV/AbXFBkzP5TnM9lkxtdj2vVUMYdKh1wj69VwQExXynAE
         o5pg==
X-Gm-Message-State: AJIora/ECzUJDAcCOJFV8gxz7XrgNnQ+38QuiBc/uCYJA8XWY0cXHCSp
        QYfpWsofH5QO5YZ+vSSkuhU+Z7mlMY9xJAwFrCfzrlL1Oqltoa0ObzQC4QKb1spury3tiHgYdab
        l5zBYCPWjYs03
X-Received: by 2002:a05:6638:16ce:b0:332:44e:af98 with SMTP id g14-20020a05663816ce00b00332044eaf98mr5744756jat.112.1655477248529;
        Fri, 17 Jun 2022 07:47:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t/WdyPm/tbAetFO465ekvhkG5WL2gdb3wutpRvzaaIkLBAu7mb0OZapaUkMw0AOrSHRXbm3g==
X-Received: by 2002:a05:6638:16ce:b0:332:44e:af98 with SMTP id g14-20020a05663816ce00b00332044eaf98mr5744675jat.112.1655477246839;
        Fri, 17 Jun 2022 07:47:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k26-20020a02cb5a000000b00331b6dcfa07sm2288268jap.61.2022.06.17.07.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 07:47:26 -0700 (PDT)
Date:   Fri, 17 Jun 2022 08:47:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        liulongfang <liulongfang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>
Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Message-ID: <20220617084723.00298d67.alex.williamson@redhat.com>
In-Reply-To: <6f6b36765fe9408f902d1d644b149df3@huawei.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
        <20220606085619.7757-3-yishaih@nvidia.com>
        <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
        <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
        <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
        <20220616170118.497620ba.alex.williamson@redhat.com>
        <6f6b36765fe9408f902d1d644b149df3@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Jun 2022 08:50:00 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: 17 June 2022 00:01
> > To: Yishai Hadas <yishaih@nvidia.com>
> > Cc: Tian, Kevin <kevin.tian@intel.com>; maorg@nvidia.com;
> > cohuck@redhat.com; Shameerali Kolothum Thodi
> > <shameerali.kolothum.thodi@huawei.com>; liulongfang
> > <liulongfang@huawei.com>; kvm@vger.kernel.org; jgg@nvidia.com
> > Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main devic=
e ops
> >=20
> > On Thu, 16 Jun 2022 17:18:16 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >  =20
> > > On 13/06/2022 10:13, Yishai Hadas wrote: =20
> > > > On 10/06/2022 6:32, Tian, Kevin wrote: =20
> > > >>> From: Yishai Hadas <yishaih@nvidia.com>
> > > >>> Sent: Monday, June 6, 2022 4:56 PM
> > > >>>
> > > >>> vfio core checks whether the driver sets some migration op (e.g.
> > > >>> set_state/get_state) and accordingly calls its op.
> > > >>>
> > > >>> However, currently mlx5 driver sets the above ops without regards=
 to
> > > >>> its
> > > >>> migration caps.
> > > >>>
> > > >>> This might lead to unexpected usage/Oops if user space may call t=
o the
> > > >>> above ops even if the driver doesn't support migration. As for ex=
ample,
> > > >>> the migration state_mutex is not initialized in that case.
> > > >>>
> > > >>> The cleanest way to manage that seems to split the migration ops =
from
> > > >>> the main device ops, this will let the driver setting them separa=
tely
> > > >>> from the main ops when it's applicable.
> > > >>>
> > > >>> As part of that, changed HISI driver to match this scheme.
> > > >>>
> > > >>> This scheme may enable down the road to come with some extra =20
> > group of =20
> > > >>> ops (e.g. DMA log) that can be set without regards to the other o=
ptions
> > > >>> based on driver caps.
> > > >>>
> > > >>> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for ml=
x5
> > > >>> devices")
> > > >>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com> =20
> > > >> Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with one nit: =20
> > > >
> > > > Thanks Kevin, please see below.
> > > > =20
> > > >> =20
> > > >>> @@ -1534,8 +1534,8 @@ =20
> > vfio_ioctl_device_feature_mig_device_state(struct =20
> > > >>> vfio_device *device,
> > > >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct file *filp =3D NULL;
> > > >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> > > >>>
> > > >>> -=C2=A0=C2=A0=C2=A0 if (!device->ops->migration_set_state ||
> > > >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !device->ops->migrati=
on_get_state)
> > > >>> +=C2=A0=C2=A0=C2=A0 if (!device->mig_ops->migration_set_state ||
> > > >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !device->mig_ops->mig=
ration_get_state)
> > > >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EN=
OTTY; =20
> > > >> ...
> > > >> =20
> > > >>> @@ -1582,8 +1583,8 @@ static int
> > > >>> vfio_ioctl_device_feature_migration(struct vfio_device *device,
> > > >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
> > > >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> > > >>>
> > > >>> -=C2=A0=C2=A0=C2=A0 if (!device->ops->migration_set_state ||
> > > >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !device->ops->migrati=
on_get_state)
> > > >>> +=C2=A0=C2=A0=C2=A0 if (!device->mig_ops->migration_set_state ||
> > > >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !device->mig_ops->mig=
ration_get_state)
> > > >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EN=
OTTY;
> > > >>> =20
> > > >> Above checks can be done once when the device is registered then
> > > >> here replaced with a single check on device->mig_ops.
> > > >> =20
> > > > I agree, it may look as of below.
> > > >
> > > > Theoretically, this could be done even before this patch upon device
> > > > registration.
> > > >
> > > > We could check that both 'ops' were set and *not* only one of and
> > > > later check for the specific 'op' upon the feature request.
> > > >
> > > > Alex,
> > > >
> > > > Do you prefer to switch to the below as part of V2 or stay as of
> > > > current submission and I'll just add Kevin as Reviewed-by ?
> > > >
> > > > diff --git a/drivers/vfio/pci/vfio_pci_core.c
> > > > b/drivers/vfio/pci/vfio_pci_core.c
> > > > index a0d69ddaf90d..f42102a03851 100644
> > > > --- a/drivers/vfio/pci/vfio_pci_core.c
> > > > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > > > @@ -1855,6 +1855,11 @@ int vfio_pci_core_register_device(struct
> > > > vfio_pci_core_device *vdev)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pdev->hdr_type !=3D =
PCI_HEADER_TYPE_NORMAL)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> > > >
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (vdev->vdev.mig_ops &&
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !(vdev->vde=
v.mig_ops->migration_get_state &&
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 vdev->vdev.mig_ops->migration_get_state))
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 return -EINVAL;
> > > > +
> > > >
> > > > Yishai
> > > > =20
> > > Hi Alex,
> > >
> > > Did you have the chance to review the above note ?
> > >
> > > I would like to send V2 with Kevin's Reviewed-by tag for both patches,
> > > just wonder about the nit. =20
> >=20
> > The whole mig_ops handling seems rather ad-hoc to me.  What tells a
> > developer when mig_ops can be set?  Can they be unset?  Does this
> > enable a device feature callout to dynamically enable migration?  Why do
> > we init the device with vfio_device_ops, but then open code per driver
> > setting vfio_migration_ops?
> >=20
> > For the hisi_acc changes, they're specifically defining two device_ops,
> > one for migration and one without migration.  This patch oddly makes
> > them identical other than the name and doesn't simplify the setup path,
> > which should now only require a single call point for init-device with
> > the proposed API rather than the existing three. =20
>=20
> I think one of the reasons we ended up using two diff ops were to restrict
> exposing the migration BAR regions to Guest(and for that we only expose
> half of the BAR region now). And for nested assignments this may result
> in invalid BAR sizes if we do it for no migration cases. Hence we have
> overrides for read/write/mmap/ioctl functions in hisi_acc_vfio_pci_migrn_=
ops .

Darn, I always forget about that and skimmed too quickly, the close,
read, write, and mmap callbacks are all different.  Sorry about that.

> If we have to simplify the setup path, I guess we retain only the _migrn_=
ops and
> add explicit checks for migration support in the above override functions=
. =20

Yes, that's an option and none of those callbacks should be terribly
performance sensitive to an inline test, it's just a matter of where we
want to simplify the code.  Given the additional differences in
callbacks I'm not necessarily suggesting this is something we need to
change.

> > If we remove the migration callbacks from vfio_device_ops, there's also
> > an opportunity that we can fix the vfio_device_ops.name handling in
> > hisi_acc, where the only current user of this is to set the driver
> > override for spawned VFs from a vfio owned PF.  This is probably
> > irrelevant for this driver, but clearly we have an expectation there
> > that name is the name of the module providing the ops and we have no
> > module named hisi-acc-vfio-pci-migration.  Thanks,
> >  =20
>=20
> Since the driver is mainly to provide migration support, I am just thinki=
ng
> whether it make sense to return failure in probe() if migration cannot be
> supported and then if user wishes can bind to the generic vfio-pci driver
> instead.

That might be asking too much for userspace.  We're conveying to
userspace via the modinfo alias information which vfio-pci variant to
use for the device, but then to have the driver reject the device and
expect userspace to move to the next match seems like a lot to ask.  It
doesn't seem wrong for a driver to have multiple vfio_device_ops, but
we might need to think more about the purpose of the name field, if the
use of it for capturing VFs is valid, or if we'd rather have some sort
of explicit capture driver provided by the ops.  Thanks,

Alex


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46C854EDBD
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 01:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379306AbiFPXBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 19:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbiFPXBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 19:01:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7413F62A1A
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 16:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655420481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AtZCD9f+qlFXMDTWZkz1LxNlCcLoH4wkdjjpI3rMxm0=;
        b=ASFsgGHkLXLPSezVIRIfLJwqzaujjocijTLOsJ1zxBGv+e1/LFmoQgM4QE4Y0SNKcQ86Mf
        BNgQpY7yAodvOqblAC675P/8iSHTS8jwUxDP9NzhpJ4Cet9y2XlQitdb3FZIfjDl8L996e
        jLC33mIEjhTLkyPUIe1WyaiseJTjruc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-fg5nysO3MjWx0P4NZ4GgDw-1; Thu, 16 Jun 2022 19:01:20 -0400
X-MC-Unique: fg5nysO3MjWx0P4NZ4GgDw-1
Received: by mail-io1-f72.google.com with SMTP id k5-20020a6bba05000000b00668eb755190so1597858iof.13
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 16:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AtZCD9f+qlFXMDTWZkz1LxNlCcLoH4wkdjjpI3rMxm0=;
        b=U/6a75Aebwofo5jD3h4veUyZk4JHopfeINq9/S+Gz1yVvXlZFsYCs9VauPKHZDxO6E
         1rlc9VBV5m0Xvsas32+v/KUOo5EGlg/8skblM6z084ZY3gtjZyzXxpE71BGZNX3Ax5Fh
         7kULJhn8TsbG5NkXEXZhz3qM2UF+7cCG9NfD3/Hfut4Df5hoMXQvOM0GC60kUXrUR7G6
         lSDzrXzY1K+g2/MH6FVo9BHfWqYs0s1zLUBosUv5EMNm3BkGEnHIxE9M8GAttNocatIG
         cdzGRZ+OrtjaTUR+WXjnu5gfX49I+AooIuqh2Sqhl0GWH2etfKW3twYSmx/1ob3d8PfN
         dqNQ==
X-Gm-Message-State: AJIora+cIj14OZh92QG5MYdmtHqEHtusMuKvDgIs09fxwoUrwWK79Wlr
        0krMGFkH3o7ciEMMr6rKymoHR8KYhMElPw8Pyci510L1wOS+zuGOkTDK+nfcWS6vGLqnqBIYwif
        6lLhnOef8v4gx
X-Received: by 2002:a05:6638:3721:b0:332:f1:3f76 with SMTP id k33-20020a056638372100b0033200f13f76mr3868309jav.283.1655420479504;
        Thu, 16 Jun 2022 16:01:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vTT+b29Heh63A3I3SCC7shTLeeZVjnH9uQ340X5WVOxcHymMi799UB9I4CE7bAaptMT6MMEQ==
X-Received: by 2002:a05:6638:3721:b0:332:f1:3f76 with SMTP id k33-20020a056638372100b0033200f13f76mr3868295jav.283.1655420479243;
        Thu, 16 Jun 2022 16:01:19 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i40-20020a023b68000000b0032e3dd0c636sm1409446jaf.172.2022.06.16.16.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 16:01:18 -0700 (PDT)
Date:   Thu, 16 Jun 2022 17:01:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>
Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Message-ID: <20220616170118.497620ba.alex.williamson@redhat.com>
In-Reply-To: <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
        <20220606085619.7757-3-yishaih@nvidia.com>
        <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
        <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
        <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jun 2022 17:18:16 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 13/06/2022 10:13, Yishai Hadas wrote:
> > On 10/06/2022 6:32, Tian, Kevin wrote: =20
> >>> From: Yishai Hadas <yishaih@nvidia.com>
> >>> Sent: Monday, June 6, 2022 4:56 PM
> >>>
> >>> vfio core checks whether the driver sets some migration op (e.g.
> >>> set_state/get_state) and accordingly calls its op.
> >>>
> >>> However, currently mlx5 driver sets the above ops without regards to=
=20
> >>> its
> >>> migration caps.
> >>>
> >>> This might lead to unexpected usage/Oops if user space may call to the
> >>> above ops even if the driver doesn't support migration. As for exampl=
e,
> >>> the migration state_mutex is not initialized in that case.
> >>>
> >>> The cleanest way to manage that seems to split the migration ops from
> >>> the main device ops, this will let the driver setting them separately
> >>> from the main ops when it's applicable.
> >>>
> >>> As part of that, changed HISI driver to match this scheme.
> >>>
> >>> This scheme may enable down the road to come with some extra group of
> >>> ops (e.g. DMA log) that can be set without regards to the other optio=
ns
> >>> based on driver caps.
> >>>
> >>> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5=20
> >>> devices")
> >>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com> =20
> >> Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with one nit: =20
> >
> > Thanks Kevin, please see below.
> > =20
> >> =20
> >>> @@ -1534,8 +1534,8 @@ vfio_ioctl_device_feature_mig_device_state(stru=
ct
> >>> vfio_device *device,
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct file *filp =3D NULL;
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> >>>
> >>> -=C2=A0=C2=A0=C2=A0 if (!device->ops->migration_set_state ||
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !device->ops->migration_g=
et_state)
> >>> +=C2=A0=C2=A0=C2=A0 if (!device->mig_ops->migration_set_state ||
> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !device->mig_ops->migrati=
on_get_state)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOTTY=
; =20
> >> ...
> >> =20
> >>> @@ -1582,8 +1583,8 @@ static int
> >>> vfio_ioctl_device_feature_migration(struct vfio_device *device,
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> >>>
> >>> -=C2=A0=C2=A0=C2=A0 if (!device->ops->migration_set_state ||
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !device->ops->migration_g=
et_state)
> >>> +=C2=A0=C2=A0=C2=A0 if (!device->mig_ops->migration_set_state ||
> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !device->mig_ops->migrati=
on_get_state)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOTTY;
> >>> =20
> >> Above checks can be done once when the device is registered then
> >> here replaced with a single check on device->mig_ops.
> >> =20
> > I agree, it may look as of below.
> >
> > Theoretically, this could be done even before this patch upon device=20
> > registration.
> >
> > We could check that both 'ops' were set and *not* only one of and=20
> > later check for the specific 'op' upon the feature request.
> >
> > Alex,
> >
> > Do you prefer to switch to the below as part of V2 or stay as of=20
> > current submission and I'll just add Kevin as Reviewed-by ?
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c=20
> > b/drivers/vfio/pci/vfio_pci_core.c
> > index a0d69ddaf90d..f42102a03851 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -1855,6 +1855,11 @@ int vfio_pci_core_register_device(struct=20
> > vfio_pci_core_device *vdev)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pdev->hdr_type !=3D PCI_=
HEADER_TYPE_NORMAL)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> >
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (vdev->vdev.mig_ops &&
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !(vdev->vdev.mi=
g_ops->migration_get_state &&
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vde=
v->vdev.mig_ops->migration_get_state))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return -EINVAL;
> > +
> >
> > Yishai
> > =20
> Hi Alex,
>=20
> Did you have the chance to review the above note ?
>=20
> I would like to send V2 with Kevin's Reviewed-by tag for both patches,=20
> just wonder about the nit.

The whole mig_ops handling seems rather ad-hoc to me.  What tells a
developer when mig_ops can be set?  Can they be unset?  Does this
enable a device feature callout to dynamically enable migration?  Why do
we init the device with vfio_device_ops, but then open code per driver
setting vfio_migration_ops?

For the hisi_acc changes, they're specifically defining two device_ops,
one for migration and one without migration.  This patch oddly makes
them identical other than the name and doesn't simplify the setup path,
which should now only require a single call point for init-device with
the proposed API rather than the existing three.

If we remove the migration callbacks from vfio_device_ops, there's also
an opportunity that we can fix the vfio_device_ops.name handling in
hisi_acc, where the only current user of this is to set the driver
override for spawned VFs from a vfio owned PF.  This is probably
irrelevant for this driver, but clearly we have an expectation there
that name is the name of the module providing the ops and we have no
module named hisi-acc-vfio-pci-migration.  Thanks,

Alex


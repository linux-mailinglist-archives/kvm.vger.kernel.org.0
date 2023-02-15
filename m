Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4175E698549
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 21:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBOUKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 15:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBOUKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 15:10:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B7F3D905
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 12:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676491754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tESq3Kr/u9yLOnXdjifvftm+9NTQBLoMvmGrxgxjkhs=;
        b=CNROq74PXEaz1zgAyhCkQJs9/wLzie09wEm5gUe/suHCtdGW28sLvGNLuxWKiwRhf6Uwge
        tRr8I+PRiZm9ijisey4Lnw8qRoSUm25bAj+3KxTS9CL3ID4+ONBfEugP0hCco9a8GaDGL8
        b2xRzDi3EgaiISc4d9+tVadnuSlcgxQ=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-657-Kf5oEZ-_N3aqnnbicnVidg-1; Wed, 15 Feb 2023 15:09:12 -0500
X-MC-Unique: Kf5oEZ-_N3aqnnbicnVidg-1
Received: by mail-il1-f198.google.com with SMTP id n18-20020a056e02101200b0030f2b79c2ffso2001ilj.20
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 12:09:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tESq3Kr/u9yLOnXdjifvftm+9NTQBLoMvmGrxgxjkhs=;
        b=Hq2GyiSCuPw03G4RDllBbBlIHy5TKxnAnNmDSkEBOKkWsdKeLsjxQras+fMrCvwB+O
         /A82RqucM9ohRAD4Qu8PjPZG9ut/BTlpIEa87n9uh4VUDOQVKvc706iwS2EBZvWXb6sj
         tyijTbuP3Mq/S74szNz6Sf8Ktgtg1ZihdTBNHI5CxSPiKP7JLQ4qTvnNZEsxPXFZ1HW3
         9gbi7iyTA8umb12mrOV/MWTYFQWe3Qzkqs6h82zx2Xh8nsw3i9Bs490EdtR/oiUX0U79
         i5wM3q00aAED//42+o989pyUsRj+Gdt+8aabRTT36y16LcX6LzxkCBijLYzsKOqJvWDY
         TfhA==
X-Gm-Message-State: AO0yUKUzdhPVZV2gQ6/gs+LRhp0+3en7Hks7Xwleu2DEnAjsT3xuEW0g
        xUvuY4Co3QC4tCEWb96UEsSOdlzvoMz1W1tFd1FGHekH+FWElsJR0Mq6TZ8HV+BKfd5IRW0d7hC
        8i8lsOGGk/NdH
X-Received: by 2002:a05:6e02:20ea:b0:315:76c9:c691 with SMTP id q10-20020a056e0220ea00b0031576c9c691mr2079856ilv.19.1676491752150;
        Wed, 15 Feb 2023 12:09:12 -0800 (PST)
X-Google-Smtp-Source: AK7set8JBdO/SBIJXBNLRJ98reJHWQI1/84cDo+sGLa3gHSBo3sOQLxc6rg4k96BUs5PdS7dNlfyzQ==
X-Received: by 2002:a05:6e02:20ea:b0:315:76c9:c691 with SMTP id q10-20020a056e0220ea00b0031576c9c691mr2079826ilv.19.1676491751854;
        Wed, 15 Feb 2023 12:09:11 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o12-20020a92d4cc000000b00313d6576c4fsm3171873ilm.84.2023.02.15.12.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 12:09:11 -0800 (PST)
Date:   Wed, 15 Feb 2023 13:09:09 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "joro@8bytes.org" <joro@8bytes.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Message-ID: <20230215130909.5d98e878.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529CFCE99E8A77AAC76DC7CC3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
        <20230213124719.126eb828.alex.williamson@redhat.com>
        <DS0PR11MB75298788BCA03FD9513F991AC3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230214084720.74b3574e.alex.williamson@redhat.com>
        <DS0PR11MB7529CFCE99E8A77AAC76DC7CC3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Feb 2023 07:54:31 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, February 14, 2023 11:47 PM
> >=20
> > On Tue, 14 Feb 2023 01:55:17 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >  =20
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Tuesday, February 14, 2023 3:47 AM
> > > >
> > > > On Mon, 13 Feb 2023 07:13:33 -0800
> > > > Yi Liu <yi.l.liu@intel.com> wrote:
> > > > =20
> > > > > Existing VFIO provides group-centric user APIs for userspace. =20
> > Userspace =20
> > > > > opens the /dev/vfio/$group_id first before getting device fd and =
=20
> > hence =20
> > > > > getting access to device. This is not the desired model for iommu=
fd. =20
> > Per =20
> > > > > the conclusion of community discussion[1], iommufd provides devic=
e- =20
> > > > centric =20
> > > > > kAPIs and requires its consumer (like VFIO) to be device-centric =
user
> > > > > APIs. Such user APIs are used to associate device with iommufd an=
d =20
> > also =20
> > > > > the I/O address spaces managed by the iommufd.
> > > > >
> > > > > This series first introduces a per device file structure to be pr=
epared
> > > > > for further enhancement and refactors the kvm-vfio code to be =20
> > prepared =20
> > > > > for accepting device file from userspace. Then refactors the vfio=
 to be
> > > > > able to handle iommufd binding. This refactor includes the mechan=
ism =20
> > of =20
> > > > > blocking device access before iommufd bind, making =20
> > vfio_device_open() =20
> > > > be =20
> > > > > exclusive between the group path and the cdev path. Eventually, a=
dds =20
> > the =20
> > > > > cdev support for vfio device, and makes group infrastructure opti=
onal =20
> > as =20
> > > > > it is not needed when vfio device cdev is compiled.
> > > > >
> > > > > This is also a prerequisite for iommu nesting for vfio device[2].
> > > > >
> > > > > The complete code can be found in below branch, simple test done =
=20
> > with =20
> > > > the =20
> > > > > legacy group path and the cdev path. Draft QEMU branch can be fou=
nd =20
> > > > at[3] =20
> > > > >
> > > > > https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v3
> > > > > (config CONFIG_IOMMUFD=3Dy CONFIG_VFIO_DEVICE_CDEV=3Dy) =20
> > > >
> > > > Even using your branch[1], it seems like this has not been tested
> > > > except with cdev support enabled:
> > > >
> > > > /home/alwillia/Work/linux.git/drivers/vfio/vfio_main.c: In function
> > > > =E2=80=98vfio_device_add=E2=80=99:
> > > > /home/alwillia/Work/linux.git/drivers/vfio/vfio_main.c:253:48: erro=
r: =20
> > =E2=80=98struct =20
> > > > vfio_device=E2=80=99 has no member named =E2=80=98cdev=E2=80=99; di=
d you mean =E2=80=98dev=E2=80=99?
> > > >   253 |                 ret =3D cdev_device_add(&device->cdev, &dev=
ice->device);
> > > >       |                                                ^~~~
> > > >       |                                                dev
> > > > /home/alwillia/Work/linux.git/drivers/vfio/vfio_main.c: In function
> > > > =E2=80=98vfio_device_del=E2=80=99:
> > > > /home/alwillia/Work/linux.git/drivers/vfio/vfio_main.c:262:42: erro=
r: =20
> > =E2=80=98struct =20
> > > > vfio_device=E2=80=99 has no member named =E2=80=98cdev=E2=80=99; di=
d you mean =E2=80=98dev=E2=80=99?
> > > >   262 |                 cdev_device_del(&device->cdev, &device->dev=
ice);
> > > >       |                                          ^~~~
> > > >       |                                          dev =20
> > >
> > > Sorry for it. It is due to the cdev definition is under
> > > "#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)". While, in the code it
> > > uses "if (IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV))".  I think for
> > > readability, it would be better to always define cdev in vfio_device,
> > > and keep the using of cdev in code. How about your taste? =20
> >=20
> > It seems necessary unless we want to litter the code with #ifdefs. =20
>=20
> I've moved it to the header file and call cdev_device_add()
> under #if (IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV))".
>=20
> > > > Additionally the VFIO_ENABLE_GROUP Kconfig option doesn't make much
> > > > sense to me, it seems entirely redundant to VFIO_GROUP. =20
> > >
> > > The intention is to make the group code compiling match existing case.
> > > Currently, if VFIO is configured, group code is by default compiled.
> > > So VFIO_ENABLE_GROUP a hidden option, and VFIO_GROUP an option
> > > for user.  User needs to explicitly config VFIO_GROUP if VFIO_DEVICE_=
CDEV=3D=3Dy.
> > > If VFIO_DEVICE_CDEV=3D=3Dn, then no matter user configed VFIO_GROUP or
> > > not, the group code shall be compiled. =20
> >=20
> > I understand the mechanics, I still find VFIO_ENABLE_GROUP redundant
> > and unnecessary.  Also, Kconfig should not allow a configuration
> > without either VFIO_GROUP or VFIO_DEVICE_CDEV as this is not
> > functional.  Deselecting VFIO_GROUP should select VFIO_DEVICE_CDEV,
> > but  VFIO_DEVICE_CDEV should be an optional addition to VFIO_GROUP. =20
>=20
> How about below? As Jason's remark on patch 0003, cdev is not available
> for SPAPR.
>=20
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 0476abf154f2..96535adc2301 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -4,6 +4,8 @@ menuconfig VFIO
>  	select IOMMU_API
>  	depends on IOMMUFD || !IOMMUFD
>  	select INTERVAL_TREE
> +	select VFIO_GROUP if SPAPR_TCE_IOMMU
> +	select VFIO_DEVICE_CDEV if !VFIO_GROUP && (X86 || S390 || ARM || ARM64)
>  	select VFIO_CONTAINER if IOMMUFD=3Dn
>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
> @@ -14,7 +16,8 @@ menuconfig VFIO
>  if VFIO
>  config VFIO_DEVICE_CDEV
>  	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
>  	depends on IOMMUFD && (X86 || S390 || ARM || ARM64)
> +	default !VFIO_GROUP
>  	help
>  	  The VFIO device cdev is another way for userspace to get device
>  	  access. Userspace gets device fd by opening device cdev under
> @@ -23,9 +26,21 @@ config VFIO_DEVICE_CDEV
> =20
>  	  If you don't know what to do here, say N.
> =20
> +config VFIO_GROUP
> +	bool "Support for the VFIO group /dev/vfio/$group_id"
> +	default y
> +	help
> +	   VFIO group is legacy interface for userspace. As the introduction
> +	   of VFIO device cdev interface, this can be N. For now, before
> +	   userspace applications are fully converted to new vfio device cdev
> +	   interface, this should be Y.
> +
> +	   If you don't know what to do here, say Y.
> +

I think this does the correct thing, but I'll reserve final judgment
until I can try to break it ;)

This message needs some tuning though, we're not far enough along the
path of cdev access to consider the group interface "legacy" (imo) or
expect that there are any userspace applications converted.  There are
also multiple setting recommendations to befuddle a layperson.  Perhaps:

	VFIO group support provides the traditional model for accessing
	devices through VFIO and is used by the majority of userspace
	applications and drivers making use of VFIO.

	If you don't know what to do here, say Y.

Thanks,
Alex

>  config VFIO_CONTAINER
>  	bool "Support for the VFIO container /dev/vfio/vfio"
>  	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> +	depends on VFIO_GROUP
>  	default y
>  	help
>  	  The VFIO container is the classic interface to VFIO for establishing
>=20
> Regards,
> Yi Liu


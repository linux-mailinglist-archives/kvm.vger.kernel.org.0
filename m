Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7404F5703C8
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 15:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiGKNEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 09:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiGKNEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 09:04:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D7ED2E6AB
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 06:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657544690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dKqXi8PMlo20G5AbHYs31JO6l1IPu/ET8thRwWlo69o=;
        b=gr30TyGWzY7uPWFEaghs6YroiMOs2W/QoGiTEDsaaEC4Ho32vzfKQ0O3aFV8bST28KSoab
        8YAh9L8zFyIB3iWnnszeCSWIiyk5IaKsVpXyoOiEpi58UDL8Kop8/beH3AuTzEBAdeGaZg
        4Nt+r51DYub5iw5fKC63Xyb9g+uHp8I=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-Kj0Ld4I7NbGy3Eb8D4mrIw-1; Mon, 11 Jul 2022 09:04:49 -0400
X-MC-Unique: Kj0Ld4I7NbGy3Eb8D4mrIw-1
Received: by mail-io1-f70.google.com with SMTP id 205-20020a6b14d6000000b0067b7b6b3c77so2623055iou.14
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 06:04:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=dKqXi8PMlo20G5AbHYs31JO6l1IPu/ET8thRwWlo69o=;
        b=L5qObYHMGvoD+QsVP69Zz+zpqzfJQV2cA9u4Kf+8bCiWqJnnV7i2ofmUfBh3FlbnV4
         b7DaOHHnnxfxCzeBRm5PozoS5Bm3EirRYc+mJ74xC3nZDWHoFAT77lnQD7a7lO6JsGTM
         7guxUucAtI8F6BKQDsPnjLXBvU86zoQbq6tg9LckfaRvTlThMNhGX+RduQnj3iQCvyfl
         FqosEsov6xArWmhluPSgmCqCNvp+bW9o4tP25VGxqB8pC0GMykNHUDa0wNAgKPLTHnml
         h7MJSwd5+dRkQ8CdjuHk7o2AOWKq/C+FxreJrRpnjvATCqqLCoEiyPzgInSI3jQiehYF
         V/+w==
X-Gm-Message-State: AJIora8WvXq7vChPRT88KmA89/0lB/xs/87rHXq+eCCcuO4BAiFxFLqJ
        qiAiSDLkbGbjFXZBFiTaKg44ASlIQCQnf7/3QWuFcjCnikuNR1OBuRrUgjp2AQa97BjU5uhgCCg
        SW42Q9gt55lek
X-Received: by 2002:a05:6602:340b:b0:67b:8189:23c5 with SMTP id n11-20020a056602340b00b0067b818923c5mr5474230ioz.52.1657544688557;
        Mon, 11 Jul 2022 06:04:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tsqFYa3r6eVWmG4wFT4c38eKTLNLK+ljav9Zxw7SmU7kCyL+KLxXH75WqtbreWE1hM6yUiEg==
X-Received: by 2002:a05:6602:340b:b0:67b:8189:23c5 with SMTP id n11-20020a056602340b00b0067b818923c5mr5474207ioz.52.1657544688228;
        Mon, 11 Jul 2022 06:04:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a4-20020a056602148400b0067502f79e9esm3543725iow.52.2022.07.11.06.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 06:04:47 -0700 (PDT)
Date:   Mon, 11 Jul 2022 07:04:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v4 2/6] vfio: Add a new device feature for the power
 management
Message-ID: <20220711070446.2bd6ac80.alex.williamson@redhat.com>
In-Reply-To: <083b39f0-7ebf-cb8f-fc52-f9a29a4f3d3f@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
        <20220701110814.7310-3-abhsahu@nvidia.com>
        <20220706093959.3bd2cbbb.alex.williamson@redhat.com>
        <ad80eb14-18a1-8895-ecfb-32687a4ba021@nvidia.com>
        <20220708103612.18285301.alex.williamson@redhat.com>
        <083b39f0-7ebf-cb8f-fc52-f9a29a4f3d3f@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Jul 2022 15:13:13 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 7/8/2022 10:06 PM, Alex Williamson wrote:
> > On Fri, 8 Jul 2022 15:09:22 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >  =20
> >> On 7/6/2022 9:09 PM, Alex Williamson wrote: =20
> >>> On Fri, 1 Jul 2022 16:38:10 +0530
> >>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >>>    =20
> >>>> This patch adds the new feature VFIO_DEVICE_FEATURE_POWER_MANAGEMENT
> >>>> for the power management in the header file. The implementation for =
the
> >>>> same will be added in the subsequent patches.
> >>>>
> >>>> With the standard registers, all power states cannot be achieved. The
> >>>> platform-based power management needs to be involved to go into the
> >>>> lowest power state. For all the platform-based power management, this
> >>>> device feature can be used.
> >>>>
> >>>> This device feature uses flags to specify the different operations. =
In
> >>>> the future, if any more power management functionality is needed then
> >>>> a new flag can be added to it. It supports both GET and SET operatio=
ns.
> >>>>
> >>>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> >>>> ---
> >>>>  include/uapi/linux/vfio.h | 55 ++++++++++++++++++++++++++++++++++++=
+++
> >>>>  1 file changed, 55 insertions(+)
> >>>>
> >>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >>>> index 733a1cddde30..7e00de5c21ea 100644
> >>>> --- a/include/uapi/linux/vfio.h
> >>>> +++ b/include/uapi/linux/vfio.h
> >>>> @@ -986,6 +986,61 @@ enum vfio_device_mig_state {
> >>>>  	VFIO_DEVICE_STATE_RUNNING_P2P =3D 5,
> >>>>  };
> >>>> =20
> >>>> +/*
> >>>> + * Perform power management-related operations for the VFIO device.
> >>>> + *
> >>>> + * The low power feature uses platform-based power management to mo=
ve the
> >>>> + * device into the low power state.  This low power state is device=
-specific.
> >>>> + *
> >>>> + * This device feature uses flags to specify the different operatio=
ns.
> >>>> + * It supports both the GET and SET operations.
> >>>> + *
> >>>> + * - VFIO_PM_LOW_POWER_ENTER flag moves the VFIO device into the lo=
w power
> >>>> + *   state with platform-based power management.  This low power st=
ate will be
> >>>> + *   internal to the VFIO driver and the user will not come to know=
 which power
> >>>> + *   state is chosen.  Once the user has moved the VFIO device into=
 the low
> >>>> + *   power state, then the user should not do any device access wit=
hout moving
> >>>> + *   the device out of the low power state.   =20
> >>>
> >>> Except we're wrapping device accesses to make this possible.  This
> >>> should probably describe how any discrete access will wake the device
> >>> but ongoing access through mmaps will generate user faults.
> >>>    =20
> >>
> >>  Sure. I will add that details also.
> >> =20
> >>>> + *
> >>>> + * - VFIO_PM_LOW_POWER_EXIT flag moves the VFIO device out of the l=
ow power
> >>>> + *    state.  This flag should only be set if the user has previous=
ly put the
> >>>> + *    device into low power state with the VFIO_PM_LOW_POWER_ENTER =
flag.   =20
> >>>
> >>> Indenting.
> >>>    =20
> >> =20
> >>  I will fix this.
> >> =20
> >>>> + *
> >>>> + * - VFIO_PM_LOW_POWER_ENTER and VFIO_PM_LOW_POWER_EXIT are mutuall=
y exclusive.
> >>>> + *
> >>>> + * - VFIO_PM_LOW_POWER_REENTERY_DISABLE flag is only valid with
> >>>> + *   VFIO_PM_LOW_POWER_ENTER.  If there is any access for the VFIO =
device on
> >>>> + *   the host side, then the device will be moved out of the low po=
wer state
> >>>> + *   without the user's guest driver involvement.  Some devices req=
uire the
> >>>> + *   user's guest driver involvement for each low-power entry.  If =
this flag is
> >>>> + *   set, then the re-entry to the low power state will be disabled=
, and the
> >>>> + *   host kernel will not move the device again into the low power =
state.
> >>>> + *   The VFIO driver internally maintains a list of devices for whi=
ch low
> >>>> + *   power re-entry is disabled by default and for those devices, t=
he
> >>>> + *   re-entry will be disabled even if the user has not set this fl=
ag
> >>>> + *   explicitly.   =20
> >>>
> >>> Wrong polarity.  The kernel should not maintain the policy.  By defau=
lt
> >>> every wakeup, whether from host kernel accesses or via user accesses
> >>> that do a pm-get should signal a wakeup to userspace.  Userspace needs
> >>> to opt-out of that wakeup to let the kernel automatically re-enter low
> >>> power and userspace needs to maintain the policy for which devices it
> >>> wants that to occur.
> >>>    =20
> >> =20
> >>  Okay. So that means, in the kernel side, we don=E2=80=99t have to mai=
ntain
> >>  the list which currently contains NVIDIA device ID. Also, in our
> >>  updated approach, this opt-out of that wake-up means that user
> >>  has not provided eventfd in the feature SET ioctl. Correct ? =20
> >=20
> > Yes, I'm imagining that if the user hasn't provided a one-shot wake-up
> > eventfd, that's the opt-out for being notified of device wakes.  For
> > example, pm-resume would have something like:
> >=20
> > =09
> > 	if (vdev->pm_wake_eventfd) {
> > 		eventfd_signal(vdev->pm_wake_eventfd, 1);
> > 		vdev->pm_wake_eventfd =3D NULL;
> > 		pm_runtime_get_noresume(dev);
> > 	}
> >=20
> > (eventfd pseudo handling substantially simplified)
> >=20
> > So w/o a wake-up eventfd, the user would need to call the pm feature
> > exit ioctl to elevate the pm reference to prevent it going back to low
> > power.  The pm feature exit ioctl would be optional if a wake eventfd is
> > provided, so some piece of the eventfd context would need to remain to
> > determine whether a pm-get is necessary.
> >  =20
> >>>> + *
> >>>> + * For the IOCTL call with VFIO_DEVICE_FEATURE_GET:
> >>>> + *
> >>>> + * - VFIO_PM_LOW_POWER_ENTER will be set if the user has put the de=
vice into
> >>>> + *   the low power state, otherwise, VFIO_PM_LOW_POWER_EXIT will be=
 set.
> >>>> + *
> >>>> + * - If the device is in a normal power state currently, then
> >>>> + *   VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set for the devices=
 where low
> >>>> + *   power re-entry is disabled by default.  If the device is in th=
e low power
> >>>> + *   state currently, then VFIO_PM_LOW_POWER_REENTERY_DISABLE will =
be set
> >>>> + *   according to the current transition.   =20
> >>>
> >>> Very confusing semantics.
> >>>
> >>> What if the feature SET ioctl took an eventfd and that eventfd was one
> >>> time use.  Calling the ioctl would setup the eventfd to notify the us=
er
> >>> on wakeup and call pm-put.  Any access to the device via host, ioctl,
> >>> or region would be wrapped in pm-get/put and the pm-resume handler
> >>> would perform the matching pm-get to balance the feature SET and sign=
al
> >>> the eventfd.    =20
> >>
> >>  This seems a better option. It will help in making the ioctl simpler
> >>  and we don=E2=80=99t have to add a separate index for PME which I add=
ed in
> >>  patch 6.=20
> >> =20
> >>> If the user opts-out by not providing a wakeup eventfd,
> >>> then the pm-resume handler does not perform a pm-get. Possibly we
> >>> could even allow mmap access if a wake-up eventfd is provided.   =20
> >>
> >>  Sorry. I am not clear on this mmap part. We currently invalidates
> >>  mapping before going into runtime-suspend. Now, if use tries do
> >>  mmap then do we need some extra handling in the fault handler ?
> >>  Need your help in understanding this part. =20
> >=20
> > The option that I'm thinking about is if the mmap fault handler is
> > wrapped in a pm-get/put then we could actually populate the mmap.  In
> > the case where the pm-get triggers the wake-eventfd in pm-resume, the
> > device doesn't return to low power when the mmap fault handler calls
> > pm-put.  This possibly allows that we could actually invalidate mmaps on
> > pm-suspend rather than in the pm feature enter ioctl, essentially the
> > same as we're doing for intx.  I wonder though if this allows the
> > possibility that we just bounce between mmap fault and pm-suspend.  So
> > long as some work can be done, for instance the pm-suspend occurs
> > asynchronously to the pm-put, this might be ok.
> >  =20
>=20
>  We can do this. But in the normal use case, the situation should
>  never arise where user should access any mmaped region when user has
>  already put the device into D3 (D3hot or D3cold). This can only happen
>  if there is some bug in the guest driver or user is doing wrong
>  sequence. Do we need to add handling to officially support this part ?

We cannot rely on userspace drivers to be bug free or non-malicious,
but if we want to impose that an mmap access while low power is
enabled always triggers a fault, that's ok.

>  pm-get can take more than a second for resume for some devices and
>  will doing this in fault handler be safe ?
>=20
>  Also, we will add this support only when wake-eventfd is provided so
>  still w/o wake-eventfd case, the mmap access will still generate fault.
>  So, we will have different behavior. Will that be acceptable ?

Let's keep it simple, generate a fault for all cases.

> >>> The
> >>> feature GET ioctl would be used to exit low power behavior and would =
be
> >>> a no-op if the wakeup eventfd had already been signaled.  Thanks,
> >>>   =20
> >> =20
> >>  I will use the GET ioctl for low power exit instead of returning the
> >>  current status. =20
> >=20
> > Note that Yishai is proposing a device DMA dirty logging feature where
> > the stop and start are exposed via SET on separate features, rather
> > than SET/GET.  We should probably maintain some consistency between
> > these use cases.  Possibly we might even want two separate pm enter
> > ioctls, one with the wake eventfd and one without.  I think this is the
> > sort of thing Jason is describing for future expansion of the dirty
> > tracking uAPI.  Thanks,
> >=20
> > Alex
> >  =20
>=20
>  Okay. So, we need to add 3 device features in total.
>=20
>  VFIO_DEVICE_FEATURE_PM_ENTRY
>  VFIO_DEVICE_FEATURE_PM_ENTRY_WITH_WAKEUP
>  VFIO_DEVICE_FEATURE_PM_EXIT
>=20
>  And only the second one need structure which will have only one field
>  for eventfd and we need to return error if wakeup-eventfd is not
>  provided in the second feature ?

Yes, we'd use eventfd_ctx and fail on a bad fileget.

>  Do we need to support GET operation also for these ?
>  We can skip GET operation since that won=E2=80=99t be very useful.

What would they do?  Thanks,

Alex


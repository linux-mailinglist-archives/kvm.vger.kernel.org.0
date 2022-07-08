Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC63756C0ED
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 20:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbiGHQgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 12:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237919AbiGHQgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 12:36:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A04B13D23
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 09:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657298200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aXaw6mV20yQ5ht83Q/Jeg7QwbEoeLxfLXC0kSLs4Xks=;
        b=Ez295cuvcM6lDT5zMoJA55tP5MdCE4eokAYCTsVl2/EfFu9+4aD5EQsewR/RZSQdU+lSkp
        gmSF7e0Z1JWxEG0MANgg79fN3uhz2oYl2m6DDzHRybDfHFUH/gE9E+eJsvbNK0E8tTpCTH
        +63qu4H27JDztS7kvuAJk41NQQIOKpA=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-reIlD1Y4MKOHJmDXOhEIJQ-1; Fri, 08 Jul 2022 12:36:39 -0400
X-MC-Unique: reIlD1Y4MKOHJmDXOhEIJQ-1
Received: by mail-il1-f198.google.com with SMTP id n16-20020a056e02141000b002dabb875f0aso11295628ilo.10
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 09:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aXaw6mV20yQ5ht83Q/Jeg7QwbEoeLxfLXC0kSLs4Xks=;
        b=pyWc5ErYYFqS1Mt14eWTQ39TD+vNPaS7lPJxmZ806XvH+KuCD/A4XLS5+sxApp5KOI
         nXE3Hcv9i8q6PTCOEbgDjG0ewKL5MoAZgvVFJ4pSMCu22JfJ5WXSTO41LB0vjJgNyCgL
         AdMSBfmjuK/4Z6Pegs4dOf8wY36MDT9a1yaTuALGLPU0xYzesacLpOmWHB/f/utaNge4
         +y7Cr35ieJIHCRveCSBOv1aAjrJ2ocJqxFIitKAe1bT6OKZNMei98egwUM6nZQfAXIRp
         nLDdH3m9EvD+/+UcQbfH7G1iCP0lAKR6E6Lh7ff7jxuWgXXZnFURVbcb1ipbILr2qguQ
         8t5A==
X-Gm-Message-State: AJIora8WSJ00lPdzqVWhc8wIY2T3nXFIE23ds9nvw/WRHzTkBFYYRTO9
        BukCyWHeacif7a1ndrFNgUDzS2835V1zNeOR6O4ixbg0pTo600lC1zF/4oaHjnWxQH2Iqkxu1FD
        qLoLeiIoTpuS+
X-Received: by 2002:a05:6e02:1a42:b0:2dc:47fc:bf29 with SMTP id u2-20020a056e021a4200b002dc47fcbf29mr2691150ilv.234.1657298198358;
        Fri, 08 Jul 2022 09:36:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u59rSyM0Utfi7YcCrOgQqetSoF7uWlUfXmJjwRamr6W32ra0kATqOCXjVPSRz09F8bIG7MXw==
X-Received: by 2002:a05:6e02:1a42:b0:2dc:47fc:bf29 with SMTP id u2-20020a056e021a4200b002dc47fcbf29mr2691125ilv.234.1657298197957;
        Fri, 08 Jul 2022 09:36:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p3-20020a92da43000000b002daa3e1fe85sm12354636ilq.58.2022.07.08.09.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 09:36:37 -0700 (PDT)
Date:   Fri, 8 Jul 2022 10:36:12 -0600
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
Message-ID: <20220708103612.18285301.alex.williamson@redhat.com>
In-Reply-To: <ad80eb14-18a1-8895-ecfb-32687a4ba021@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
        <20220701110814.7310-3-abhsahu@nvidia.com>
        <20220706093959.3bd2cbbb.alex.williamson@redhat.com>
        <ad80eb14-18a1-8895-ecfb-32687a4ba021@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Jul 2022 15:09:22 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 7/6/2022 9:09 PM, Alex Williamson wrote:
> > On Fri, 1 Jul 2022 16:38:10 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >  =20
> >> This patch adds the new feature VFIO_DEVICE_FEATURE_POWER_MANAGEMENT
> >> for the power management in the header file. The implementation for the
> >> same will be added in the subsequent patches.
> >>
> >> With the standard registers, all power states cannot be achieved. The
> >> platform-based power management needs to be involved to go into the
> >> lowest power state. For all the platform-based power management, this
> >> device feature can be used.
> >>
> >> This device feature uses flags to specify the different operations. In
> >> the future, if any more power management functionality is needed then
> >> a new flag can be added to it. It supports both GET and SET operations.
> >>
> >> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> >> ---
> >>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 55 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index 733a1cddde30..7e00de5c21ea 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -986,6 +986,61 @@ enum vfio_device_mig_state {
> >>  	VFIO_DEVICE_STATE_RUNNING_P2P =3D 5,
> >>  };
> >> =20
> >> +/*
> >> + * Perform power management-related operations for the VFIO device.
> >> + *
> >> + * The low power feature uses platform-based power management to move=
 the
> >> + * device into the low power state.  This low power state is device-s=
pecific.
> >> + *
> >> + * This device feature uses flags to specify the different operations.
> >> + * It supports both the GET and SET operations.
> >> + *
> >> + * - VFIO_PM_LOW_POWER_ENTER flag moves the VFIO device into the low =
power
> >> + *   state with platform-based power management.  This low power stat=
e will be
> >> + *   internal to the VFIO driver and the user will not come to know w=
hich power
> >> + *   state is chosen.  Once the user has moved the VFIO device into t=
he low
> >> + *   power state, then the user should not do any device access witho=
ut moving
> >> + *   the device out of the low power state. =20
> >=20
> > Except we're wrapping device accesses to make this possible.  This
> > should probably describe how any discrete access will wake the device
> > but ongoing access through mmaps will generate user faults.
> >  =20
>=20
>  Sure. I will add that details also.
>=20
> >> + *
> >> + * - VFIO_PM_LOW_POWER_EXIT flag moves the VFIO device out of the low=
 power
> >> + *    state.  This flag should only be set if the user has previously=
 put the
> >> + *    device into low power state with the VFIO_PM_LOW_POWER_ENTER fl=
ag. =20
> >=20
> > Indenting.
> >  =20
> =20
>  I will fix this.
>=20
> >> + *
> >> + * - VFIO_PM_LOW_POWER_ENTER and VFIO_PM_LOW_POWER_EXIT are mutually =
exclusive.
> >> + *
> >> + * - VFIO_PM_LOW_POWER_REENTERY_DISABLE flag is only valid with
> >> + *   VFIO_PM_LOW_POWER_ENTER.  If there is any access for the VFIO de=
vice on
> >> + *   the host side, then the device will be moved out of the low powe=
r state
> >> + *   without the user's guest driver involvement.  Some devices requi=
re the
> >> + *   user's guest driver involvement for each low-power entry.  If th=
is flag is
> >> + *   set, then the re-entry to the low power state will be disabled, =
and the
> >> + *   host kernel will not move the device again into the low power st=
ate.
> >> + *   The VFIO driver internally maintains a list of devices for which=
 low
> >> + *   power re-entry is disabled by default and for those devices, the
> >> + *   re-entry will be disabled even if the user has not set this flag
> >> + *   explicitly. =20
> >=20
> > Wrong polarity.  The kernel should not maintain the policy.  By default
> > every wakeup, whether from host kernel accesses or via user accesses
> > that do a pm-get should signal a wakeup to userspace.  Userspace needs
> > to opt-out of that wakeup to let the kernel automatically re-enter low
> > power and userspace needs to maintain the policy for which devices it
> > wants that to occur.
> >  =20
> =20
>  Okay. So that means, in the kernel side, we don=E2=80=99t have to mainta=
in
>  the list which currently contains NVIDIA device ID. Also, in our
>  updated approach, this opt-out of that wake-up means that user
>  has not provided eventfd in the feature SET ioctl. Correct ?

Yes, I'm imagining that if the user hasn't provided a one-shot wake-up
eventfd, that's the opt-out for being notified of device wakes.  For
example, pm-resume would have something like:

=09
	if (vdev->pm_wake_eventfd) {
		eventfd_signal(vdev->pm_wake_eventfd, 1);
		vdev->pm_wake_eventfd =3D NULL;
		pm_runtime_get_noresume(dev);
	}

(eventfd pseudo handling substantially simplified)

So w/o a wake-up eventfd, the user would need to call the pm feature
exit ioctl to elevate the pm reference to prevent it going back to low
power.  The pm feature exit ioctl would be optional if a wake eventfd is
provided, so some piece of the eventfd context would need to remain to
determine whether a pm-get is necessary.

> >> + *
> >> + * For the IOCTL call with VFIO_DEVICE_FEATURE_GET:
> >> + *
> >> + * - VFIO_PM_LOW_POWER_ENTER will be set if the user has put the devi=
ce into
> >> + *   the low power state, otherwise, VFIO_PM_LOW_POWER_EXIT will be s=
et.
> >> + *
> >> + * - If the device is in a normal power state currently, then
> >> + *   VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set for the devices w=
here low
> >> + *   power re-entry is disabled by default.  If the device is in the =
low power
> >> + *   state currently, then VFIO_PM_LOW_POWER_REENTERY_DISABLE will be=
 set
> >> + *   according to the current transition. =20
> >=20
> > Very confusing semantics.
> >=20
> > What if the feature SET ioctl took an eventfd and that eventfd was one
> > time use.  Calling the ioctl would setup the eventfd to notify the user
> > on wakeup and call pm-put.  Any access to the device via host, ioctl,
> > or region would be wrapped in pm-get/put and the pm-resume handler
> > would perform the matching pm-get to balance the feature SET and signal
> > the eventfd.  =20
>=20
>  This seems a better option. It will help in making the ioctl simpler
>  and we don=E2=80=99t have to add a separate index for PME which I added =
in
>  patch 6.=20
>=20
> > If the user opts-out by not providing a wakeup eventfd,
> > then the pm-resume handler does not perform a pm-get. Possibly we
> > could even allow mmap access if a wake-up eventfd is provided. =20
>=20
>  Sorry. I am not clear on this mmap part. We currently invalidates
>  mapping before going into runtime-suspend. Now, if use tries do
>  mmap then do we need some extra handling in the fault handler ?
>  Need your help in understanding this part.

The option that I'm thinking about is if the mmap fault handler is
wrapped in a pm-get/put then we could actually populate the mmap.  In
the case where the pm-get triggers the wake-eventfd in pm-resume, the
device doesn't return to low power when the mmap fault handler calls
pm-put.  This possibly allows that we could actually invalidate mmaps on
pm-suspend rather than in the pm feature enter ioctl, essentially the
same as we're doing for intx.  I wonder though if this allows the
possibility that we just bounce between mmap fault and pm-suspend.  So
long as some work can be done, for instance the pm-suspend occurs
asynchronously to the pm-put, this might be ok.

> > The
> > feature GET ioctl would be used to exit low power behavior and would be
> > a no-op if the wakeup eventfd had already been signaled.  Thanks,
> > =20
> =20
>  I will use the GET ioctl for low power exit instead of returning the
>  current status.

Note that Yishai is proposing a device DMA dirty logging feature where
the stop and start are exposed via SET on separate features, rather
than SET/GET.  We should probably maintain some consistency between
these use cases.  Possibly we might even want two separate pm enter
ioctls, one with the wake eventfd and one without.  I think this is the
sort of thing Jason is describing for future expansion of the dirty
tracking uAPI.  Thanks,

Alex


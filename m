Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCED6B106C
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 18:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCHRud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 12:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCHRuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 12:50:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A7884824
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 09:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678297789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WgdFb9a/r4I/6TdwH5fprS/6S6YWoahUY0hwaQaBHxE=;
        b=aXPNgcAwH+55Eh5HHMy98zNM7c6TYLunb6YtCYGiL95/MQaorC3AXyPvLDab0I/8zsF8BC
        ThrrMOzXtLW9fBn4c7qD7Qowx8y6ZayCap16Q4BBnePLXRT3sJ2soOSuUN/nwQA+JowvVG
        yGr7cW+J890oKqlBaPhOY5YhP9gdLvs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-HFUonilINjOOxB3mIXovLQ-1; Wed, 08 Mar 2023 12:49:48 -0500
X-MC-Unique: HFUonilINjOOxB3mIXovLQ-1
Received: by mail-il1-f197.google.com with SMTP id w8-20020a92db48000000b00322124084f3so3758949ilq.3
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 09:49:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678297787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WgdFb9a/r4I/6TdwH5fprS/6S6YWoahUY0hwaQaBHxE=;
        b=qKQ9aERNXc80bCGVDclQTAGyNa/8+Tylr26mxht5lDIq9//pKFqUaUj76tXGnS+a4X
         F0agmxdtCwUa/AXy+TFnyBPLpeNOXmEsu/K1rmLxQPUepJ1LAadFl4oGSY+Q64wN7fJ9
         C5kpmmd+c+s8dDPBgEjGZmogCx/1Sm9q+bu28dAMDYBx0uCqjtZoCTWkTUGkfYe1exEk
         kii/hGi4A9dgLNTYsZ4KbqygctR0O+7jDxwSlxKrzGsbgXyOt5dM/vYu6cbGebN0MvUX
         040zQMCMcplkGmFfKmG8ea02r+lIwjzmb6/0Xri29C0Sdqz6XGeCTRsupxk3xB/i70fo
         EuOA==
X-Gm-Message-State: AO0yUKW43r/quoFUwI0lvsdhqXqZYzPB4cDGYhg4cLpQD+TNgBl6SG9M
        RNUFLuj6E3T3Ak2E6tbXudv++ZKxmZfDJQd7bceAHwk73LnuZfELZNSuozkX2k+sKUQzuVQK1vR
        Rn1s7LQLG/ygp
X-Received: by 2002:a6b:3b0f:0:b0:74c:9907:e5b4 with SMTP id i15-20020a6b3b0f000000b0074c9907e5b4mr17063889ioa.6.1678297787347;
        Wed, 08 Mar 2023 09:49:47 -0800 (PST)
X-Google-Smtp-Source: AK7set8OYIVemkemA8xPWwNCCOrWkEXAWthGjSV8k7moF0OEkSmcqT/tCLgVdMS9dE8mb1oayoGrVw==
X-Received: by 2002:a6b:3b0f:0:b0:74c:9907:e5b4 with SMTP id i15-20020a6b3b0f000000b0074c9907e5b4mr17063872ioa.6.1678297787018;
        Wed, 08 Mar 2023 09:49:47 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s13-20020a6bdc0d000000b0074c8a021d4csm5242741ioc.44.2023.03.08.09.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 09:49:46 -0800 (PST)
Date:   Wed, 8 Mar 2023 10:49:44 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Grzegorz Jaszczyk <jaz@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, dmy@semihalf.com, tn@semihalf.com,
        dbehr@google.com, upstream@semihalf.com, dtor@google.com,
        jgg@ziepe.ca, kevin.tian@intel.com, cohuck@redhat.com,
        abhsahu@nvidia.com, yishaih@nvidia.com, yi.l.liu@intel.com,
        kvm@vger.kernel.org, Dominik Behr <dbehr@chromium.org>,
        <libvir-list@redhat.com>
Subject: Re: [PATCH] vfio/pci: Propagate ACPI notifications to the
 user-space
Message-ID: <20230308104944.578d503c.alex.williamson@redhat.com>
In-Reply-To: <CAH76GKNapD8uB0B2+m70ZScDaOM8TmPNAii9TGqRSsgN4013+Q@mail.gmail.com>
References: <20230307220553.631069-1-jaz@semihalf.com>
        <20230307164158.4b41e32f.alex.williamson@redhat.com>
        <CAH76GKNapD8uB0B2+m70ZScDaOM8TmPNAii9TGqRSsgN4013+Q@mail.gmail.com>
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

[Cc +libvir-list]

On Wed, 8 Mar 2023 12:41:24 +0100
Grzegorz Jaszczyk <jaz@semihalf.com> wrote:

> =C5=9Br., 8 mar 2023 o 00:42 Alex Williamson <alex.williamson@redhat.com>=
 napisa=C5=82(a):
> >
> > On Tue,  7 Mar 2023 22:05:53 +0000
> > Grzegorz Jaszczyk <jaz@semihalf.com> wrote:
> > =20
> > > From: Dominik Behr <dbehr@chromium.org>
> > >
> > > Hitherto there was no support for propagating ACPI notifications to t=
he
> > > guest drivers. In order to provide such support, install a handler for
> > > notifications on an ACPI device during vfio-pci device registration. =
The
> > > handler role is to propagate such ACPI notifications to the user-space
> > > via acpi netlink events, which allows VMM to receive and propagate th=
em
> > > further to the VMs.
> > >
> > > Thanks to the above, the actual driver for the pass-through device,
> > > which belongs to the guest, can receive and react to device specific
> > > notifications. =20
>=20
> > What consumes these events? =20
>=20
> Those events are consumed by the VMM, which can have a built-in ACPI
> event listener.
>=20
> > Has this been proposed to any VM management tools like libvirt? =20
>=20
> This patch was evaluated and tested with crosvm VMM (but since the
> kernel part is not in the tree the implementation is marked as WIP).

Adding libvirt folks.  This intentionally designs the interface in a
way that requires a privileged intermediary to monitor netlink on the
host, associate messages to VMs based on an attached device, and
re-inject the event to the VMM.  Why wouldn't we use a channel
associated with the device for such events, such that the VMM has
direct access?  The netlink path seems like it has more moving pieces,
possibly scalability issues, and maybe security issues?

> > What sort of ACPI events are we expecting to see here and what does use=
r space do with them? =20
>=20
> With this patch we are expecting to see and propagate any device
> specific notifications, which are aimed to notify the proper device
> (driver) which belongs to the guest.
>=20
> Here is the description how propagating such notification could be
> implemented by VMM:
>=20
> 1) VMM could upfront generate proper virtual ACPI description for
> guest per vfio-pci device (more precisely it could be e.g.  ACPI GPE
> handler, which aim is only to notify relevant device):

The proposed interface really has no introspection, how does the VMM
know which devices need ACPI tables added "upfront"?  How do these
events factor into hotplug device support, where we may not be able to
dynamically inject ACPI code into the VM?

>=20
>         Scope (_GPE)
>         {
>             Method (_E00, 0, NotSerialized)  // _Exx: Edge-Triggered
> GPE, xx=3D0x00-0xFF
>             {
>                 Local0 =3D \_SB.PC00.PE08.NOTY
>                 Notify (\_SB.PC00.PE08, Local0)
>             }
>         }
>=20
> 2) Now, when the VMM receives ACPI netlink event (thanks to VMM
> builtin ACPI event listener, which is able to receive any event
> generated through acpi_bus_generate_netlink_event) VMM classifies it
> based on device_class ("vfio_pci" in this case) and parses it further
> to get device name and the notification value for it. This
> notification value is stored in a virtual register and VMM triggers
> GPE associated with the pci-vfio device.

Each VMM is listening for netlink events and sees all the netlink
traffic from the host, including events destined for other VMMs?  This
doesn't seem terribly acceptable from a security perspective.
=20
> 3) Guest kernel upon handling GPE, thanks to generated AML (ad 1.),
> triggers Notify on required pass-through device and therefore
> replicates the ACPI Notification on the guest side (Accessing
> \_SB.PC00.PE08.NOTY from above example, result with trap to VMM, which
> returns previously stored notify value).

The acpi_bus_generate_netlink_event() below really only seems to form a
u8 event type from the u32 event.  Is this something that could be
provided directly from the vfio device uAPI with an ioeventfd, thus
providing introspection that a device supports ACPI event notifications
and the ability for the VMM to exclusively monitor those events, and
only those events for the device, without additional privileges?
Thanks,

Alex
=20
> With above the ACPI notifications are actually replicated on the guest
> side and from a guest driver perspective they don't differ from native
> ones.
>=20
> > =20
> > > Signed-off-by: Dominik Behr <dbehr@chromium.org>
> > > Co-developed-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> > > Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_core.c | 33 ++++++++++++++++++++++++++++++=
++
> > >  1 file changed, 33 insertions(+)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio=
_pci_core.c
> > > index a5ab416cf476..92b8ed8d087c 100644
> > > --- a/drivers/vfio/pci/vfio_pci_core.c
> > > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > > @@ -10,6 +10,7 @@
> > >
> > >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > >
> > > +#include <linux/acpi.h>
> > >  #include <linux/aperture.h>
> > >  #include <linux/device.h>
> > >  #include <linux/eventfd.h>
> > > @@ -2120,10 +2121,20 @@ void vfio_pci_core_release_dev(struct vfio_de=
vice *core_vdev)
> > >  }
> > >  EXPORT_SYMBOL_GPL(vfio_pci_core_release_dev);
> > >
> > > +static void vfio_pci_core_acpi_notify(acpi_handle handle, u32 event,=
 void *data)
> > > +{
> > > +     struct vfio_pci_core_device *vdev =3D (struct vfio_pci_core_dev=
ice *)data;
> > > +     struct device *dev =3D &vdev->pdev->dev;
> > > +
> > > +     acpi_bus_generate_netlink_event("vfio_pci", dev_name(dev), even=
t, 0); =20
> >
> > Who listens to this?  Should there be an in-band means to provide
> > notifies related to the device?  How does a userspace driver know to
> > look for netlink events for a particular device? =20
>=20
> VMM which has implemented logic responsible for listening on acpi
> netlink events. This netlink message already passes the device name so
> VMM will associate it with a particular device. I've elaborated a bit
> more in my previous answer.
>=20
> > =20
> > > +}
> > > +
> > >  int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
> > >  {
> > > +     acpi_status status;
> > >       struct pci_dev *pdev =3D vdev->pdev;
> > >       struct device *dev =3D &pdev->dev;
> > > +     struct acpi_device *adev =3D ACPI_COMPANION(&pdev->dev);
> > >       int ret;
> > >
> > >       /* Drivers must set the vfio_pci_core_device to their drvdata */
> > > @@ -2201,8 +2212,24 @@ int vfio_pci_core_register_device(struct vfio_=
pci_core_device *vdev)
> > >       ret =3D vfio_register_group_dev(&vdev->vdev);
> > >       if (ret)
> > >               goto out_power;
> > > +
> > > +     if (!adev) {
> > > +             pci_info(pdev, "No ACPI companion"); =20
> >
> > This would be a log message generated for 99.99% of devices. =20
>=20
> Sure - I will remove that.
>=20
> > =20
> > > +             return 0;
> > > +     }
> > > +
> > > +     status =3D acpi_install_notify_handler(adev->handle, ACPI_DEVIC=
E_NOTIFY,
> > > +                                     vfio_pci_core_acpi_notify, (voi=
d *)vdev); =20
> >
> > vfio-pci supports non-ACPI platforms, I don't see any !CONFIG_ACPI
> > prototypes for this function.  Thanks, =20
>=20
> Good point, I will address this in the next version.
>=20
> Thank you,
> Grzegorz
>=20
> >
> > Alex
> > =20
> > > +
> > > +     if (ACPI_FAILURE(status)) {
> > > +             pci_err(pdev, "Failed to install notify handler");
> > > +             goto out_group_register;
> > > +     }
> > > +
> > >       return 0;
> > >
> > > +out_group_register:
> > > +     vfio_unregister_group_dev(&vdev->vdev);
> > >  out_power:
> > >       if (!disable_idle_d3)
> > >               pm_runtime_get_noresume(dev);
> > > @@ -2216,6 +2243,12 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_register_devic=
e);
> > >
> > >  void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vd=
ev)
> > >  {
> > > +     struct acpi_device *adev =3D ACPI_COMPANION(&vdev->pdev->dev);
> > > +
> > > +     if (adev)
> > > +             acpi_remove_notify_handler(adev->handle, ACPI_DEVICE_NO=
TIFY,
> > > +                                        vfio_pci_core_acpi_notify);
> > > +
> > >       vfio_pci_core_sriov_configure(vdev, 0);
> > >
> > >       vfio_unregister_group_dev(&vdev->vdev); =20
> > =20
>=20


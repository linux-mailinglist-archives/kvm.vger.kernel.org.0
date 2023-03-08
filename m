Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2315B6B062E
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 12:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjCHLln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 06:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjCHLlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 06:41:39 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16805D76F
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 03:41:36 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so1973136pjg.4
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 03:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1678275696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7nj+pHe/1/CKqda1EjvXBsi6L67ezaszgw4ADLXpYdM=;
        b=sSD4joYNdUCKCp67LB0Noo8HzQwOJrLJIye91A7vyWNmvRMJTkC2tfA6IDrNPNrqE9
         yMncsxBxeKmesianOwOoJakFXQtdc4TwRCaet5VLG1OnZg8IhEmZD5DM8OEqLlgxWnS/
         mK4baieyB8AaXmENaWYsA8OQAzTQo3DHVpp/QULSww/r1pLKVNdrkytVu09lBd9wNFJZ
         JQbgJ9SFQ5pqT53B6X3DwP6ujoLnBwGYj/9hGe8grYvjKPjkjoDE/htvtKRuiRuHz2qU
         bdAE42gbwDCfB0gCPC+wNn3woNeH5PuiHfRTnjxQvX0Ldd18c5WTCWLbFgSHYtaoHeLw
         3wLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678275696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7nj+pHe/1/CKqda1EjvXBsi6L67ezaszgw4ADLXpYdM=;
        b=KKNYjd9YYJr9iYFIjGjFP+6tUgV4+zq+bgvPWyM2JKutX0EHGf6kt476+UZToEVPbf
         w4qxDl9QkXx3FTvtHyrrA1UydhKkR7FCNIlymUVpv7CMS1T9CrgC6Po7Sx7M1hqzl6B2
         p1Mb2pK3NVvrl00lzWxI/2rw3dClbDEN0Wl8eGm7y2z9fL/fqGQoABurpAHjV2rZt+nP
         CVKTRxF2qGlkofpgV43JeAmF9h/mE/uABBWX7kOPLSchhnTcBKtzr2dVPfq41qxMcQcz
         ImOuC/xMs0bM3BipYuOUhvD8w23z4ZjgOCY7ZLp3MOpbCx4Inf4Xqx3kl3vV+WNWN9Bj
         78yA==
X-Gm-Message-State: AO0yUKW1DUZWU66CI67o4d5gEpFTZkQ+ZvWBSnYhczgV8msIGtKN8Zy6
        2AnXgW0FLMR1OHeQnb/jevW5k9j1mXZ41XBizX9LCA==
X-Google-Smtp-Source: AK7set8XZsRfdhwRjpsEqbqLyvUyGFylpHJIv0dvfj0QxwkZ+WkLBXwBqyvVlLIeVdvUK5Tw7MBCq8n6LZzSDlUiVvM=
X-Received: by 2002:a17:902:7e87:b0:198:fd60:df2c with SMTP id
 z7-20020a1709027e8700b00198fd60df2cmr6855693pla.11.1678275696290; Wed, 08 Mar
 2023 03:41:36 -0800 (PST)
MIME-Version: 1.0
References: <20230307220553.631069-1-jaz@semihalf.com> <20230307164158.4b41e32f.alex.williamson@redhat.com>
In-Reply-To: <20230307164158.4b41e32f.alex.williamson@redhat.com>
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
Date:   Wed, 8 Mar 2023 12:41:24 +0100
Message-ID: <CAH76GKNapD8uB0B2+m70ZScDaOM8TmPNAii9TGqRSsgN4013+Q@mail.gmail.com>
Subject: Re: [PATCH] vfio/pci: Propagate ACPI notifications to the user-space
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, dmy@semihalf.com, tn@semihalf.com,
        dbehr@google.com, upstream@semihalf.com, dtor@google.com,
        jgg@ziepe.ca, kevin.tian@intel.com, cohuck@redhat.com,
        abhsahu@nvidia.com, yishaih@nvidia.com, yi.l.liu@intel.com,
        kvm@vger.kernel.org, Dominik Behr <dbehr@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=C5=9Br., 8 mar 2023 o 00:42 Alex Williamson <alex.williamson@redhat.com> n=
apisa=C5=82(a):
>
> On Tue,  7 Mar 2023 22:05:53 +0000
> Grzegorz Jaszczyk <jaz@semihalf.com> wrote:
>
> > From: Dominik Behr <dbehr@chromium.org>
> >
> > Hitherto there was no support for propagating ACPI notifications to the
> > guest drivers. In order to provide such support, install a handler for
> > notifications on an ACPI device during vfio-pci device registration. Th=
e
> > handler role is to propagate such ACPI notifications to the user-space
> > via acpi netlink events, which allows VMM to receive and propagate them
> > further to the VMs.
> >
> > Thanks to the above, the actual driver for the pass-through device,
> > which belongs to the guest, can receive and react to device specific
> > notifications.

> What consumes these events?

Those events are consumed by the VMM, which can have a built-in ACPI
event listener.

> Has this been proposed to any VM management tools like libvirt?

This patch was evaluated and tested with crosvm VMM (but since the
kernel part is not in the tree the implementation is marked as WIP).

> What sort of ACPI events are we expecting to see here and what does user =
space do with them?

With this patch we are expecting to see and propagate any device
specific notifications, which are aimed to notify the proper device
(driver) which belongs to the guest.

Here is the description how propagating such notification could be
implemented by VMM:

1) VMM could upfront generate proper virtual ACPI description for
guest per vfio-pci device (more precisely it could be e.g.  ACPI GPE
handler, which aim is only to notify relevant device):

        Scope (_GPE)
        {
            Method (_E00, 0, NotSerialized)  // _Exx: Edge-Triggered
GPE, xx=3D0x00-0xFF
            {
                Local0 =3D \_SB.PC00.PE08.NOTY
                Notify (\_SB.PC00.PE08, Local0)
            }
        }

2) Now, when the VMM receives ACPI netlink event (thanks to VMM
builtin ACPI event listener, which is able to receive any event
generated through acpi_bus_generate_netlink_event) VMM classifies it
based on device_class ("vfio_pci" in this case) and parses it further
to get device name and the notification value for it. This
notification value is stored in a virtual register and VMM triggers
GPE associated with the pci-vfio device.

3) Guest kernel upon handling GPE, thanks to generated AML (ad 1.),
triggers Notify on required pass-through device and therefore
replicates the ACPI Notification on the guest side (Accessing
\_SB.PC00.PE08.NOTY from above example, result with trap to VMM, which
returns previously stored notify value).

With above the ACPI notifications are actually replicated on the guest
side and from a guest driver perspective they don't differ from native
ones.

>
> > Signed-off-by: Dominik Behr <dbehr@chromium.org>
> > Co-developed-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> > Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 33 ++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_p=
ci_core.c
> > index a5ab416cf476..92b8ed8d087c 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -10,6 +10,7 @@
> >
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >
> > +#include <linux/acpi.h>
> >  #include <linux/aperture.h>
> >  #include <linux/device.h>
> >  #include <linux/eventfd.h>
> > @@ -2120,10 +2121,20 @@ void vfio_pci_core_release_dev(struct vfio_devi=
ce *core_vdev)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_pci_core_release_dev);
> >
> > +static void vfio_pci_core_acpi_notify(acpi_handle handle, u32 event, v=
oid *data)
> > +{
> > +     struct vfio_pci_core_device *vdev =3D (struct vfio_pci_core_devic=
e *)data;
> > +     struct device *dev =3D &vdev->pdev->dev;
> > +
> > +     acpi_bus_generate_netlink_event("vfio_pci", dev_name(dev), event,=
 0);
>
> Who listens to this?  Should there be an in-band means to provide
> notifies related to the device?  How does a userspace driver know to
> look for netlink events for a particular device?

VMM which has implemented logic responsible for listening on acpi
netlink events. This netlink message already passes the device name so
VMM will associate it with a particular device. I've elaborated a bit
more in my previous answer.

>
> > +}
> > +
> >  int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
> >  {
> > +     acpi_status status;
> >       struct pci_dev *pdev =3D vdev->pdev;
> >       struct device *dev =3D &pdev->dev;
> > +     struct acpi_device *adev =3D ACPI_COMPANION(&pdev->dev);
> >       int ret;
> >
> >       /* Drivers must set the vfio_pci_core_device to their drvdata */
> > @@ -2201,8 +2212,24 @@ int vfio_pci_core_register_device(struct vfio_pc=
i_core_device *vdev)
> >       ret =3D vfio_register_group_dev(&vdev->vdev);
> >       if (ret)
> >               goto out_power;
> > +
> > +     if (!adev) {
> > +             pci_info(pdev, "No ACPI companion");
>
> This would be a log message generated for 99.99% of devices.

Sure - I will remove that.

>
> > +             return 0;
> > +     }
> > +
> > +     status =3D acpi_install_notify_handler(adev->handle, ACPI_DEVICE_=
NOTIFY,
> > +                                     vfio_pci_core_acpi_notify, (void =
*)vdev);
>
> vfio-pci supports non-ACPI platforms, I don't see any !CONFIG_ACPI
> prototypes for this function.  Thanks,

Good point, I will address this in the next version.

Thank you,
Grzegorz

>
> Alex
>
> > +
> > +     if (ACPI_FAILURE(status)) {
> > +             pci_err(pdev, "Failed to install notify handler");
> > +             goto out_group_register;
> > +     }
> > +
> >       return 0;
> >
> > +out_group_register:
> > +     vfio_unregister_group_dev(&vdev->vdev);
> >  out_power:
> >       if (!disable_idle_d3)
> >               pm_runtime_get_noresume(dev);
> > @@ -2216,6 +2243,12 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_register_device)=
;
> >
> >  void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev=
)
> >  {
> > +     struct acpi_device *adev =3D ACPI_COMPANION(&vdev->pdev->dev);
> > +
> > +     if (adev)
> > +             acpi_remove_notify_handler(adev->handle, ACPI_DEVICE_NOTI=
FY,
> > +                                        vfio_pci_core_acpi_notify);
> > +
> >       vfio_pci_core_sriov_configure(vdev, 0);
> >
> >       vfio_unregister_group_dev(&vdev->vdev);
>

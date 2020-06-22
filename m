Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA15204320
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 23:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgFVV7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 17:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgFVV7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 17:59:22 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3983DC061573
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 14:59:22 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w6so8228428ejq.6
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 14:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PwUdFXrwFkVyPkIftP7iCqzvQXGs9IO/IBuVMMXUV7g=;
        b=Y3DE+hmqsE5xA1oDB4IMZXEMRAuON0IM0cUBF8IK9Kr5KED9kbuh8MZQPbFwp74RBs
         Dvbyufw/D//tOSm2lSu7KS0U9D0nPSrCH2zqzcat2K/R1+lN4K3azPUQ4qw+F4lJAjzi
         QCj0kX+opXyEBr3iFPOVsAKfe/o4iXWV/S9rk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PwUdFXrwFkVyPkIftP7iCqzvQXGs9IO/IBuVMMXUV7g=;
        b=hqcJPDZxJGb7ddrq+SvqiODkq9N5K0vXFFbo53ayDwo0SP1d42j3NI/FGb1dZbCpbn
         YQuRtF13SeGMMyy7CKHuO6SLAFz+HxlNdijSBLYecX6ahbyAUuXTSvAgcfyW4BETHOH5
         jbt5zK7Nl0NYunLoGMd54wxL8FE514uZsqNil80wHMurrBZx6i4LzXkS3rKiTolsmaYG
         fgBnNU/dEOh0TFRAC4Qio6yrgAzBshUlhZdFAODPT18ejWJXSuPydVK4qVKRBPZH/BSD
         Kwc6bG4E/5RRTQG0wnNcnmns6XzT3LUqoMfmieIVjzFTARQ1FP7v2uW3iSr454jGIqAV
         yhHg==
X-Gm-Message-State: AOAM530ME9vYFh6oyWLzzR+HDfijDWYL02Elgribrd02X32lQJvkvRxZ
        MqbF/RETO+R6/Oj5NxbdW9UG26LlZaKuWD+KyAT+JQtnrwE=
X-Google-Smtp-Source: ABdhPJz/nU31eAca5x/SX/paN2te0DgNZiqoRbIZLWe68uCsQ0nwqCyJsc3WZfXrK2XRfjVDrieJAC32Hp7siXCI4ZE=
X-Received: by 2002:a17:906:d973:: with SMTP id rp19mr16534171ejb.475.1592863160689;
 Mon, 22 Jun 2020 14:59:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ-EccPU8KpU96PM2PtroLjdNVDbvnxwKwWJr2B+RBKuXEr7Vw@mail.gmail.com>
 <20200603182322.196940-1-mortonm@chromium.org> <CAJ-EccN0nXY1keytZdTK45mPus-VEbw_r6v_n7r+eU5YTfzJJw@mail.gmail.com>
 <20200619125147.72133184@w520.home> <CAJ-EccN3SUdb1pgzv9zVh4Ej7zyQaNQ7CKaQisWFn1voiFSa2g@mail.gmail.com>
In-Reply-To: <CAJ-EccN3SUdb1pgzv9zVh4Ej7zyQaNQ7CKaQisWFn1voiFSa2g@mail.gmail.com>
From:   Micah Morton <mortonm@chromium.org>
Date:   Mon, 22 Jun 2020 14:59:08 -0700
Message-ID: <CAJ-EccPeiSxg6Mq__gR0x8y=0QPpgboBQBRMSZv-M0VhsrQpow@mail.gmail.com>
Subject: Re: [PATCH] vfio: PoC patch for printing IRQs used by i2c devices
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 19, 2020 at 1:00 PM Micah Morton <mortonm@chromium.org> wrote:
>
> On Fri, Jun 19, 2020 at 11:51 AM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > On Tue, 9 Jun 2020 13:19:19 -0700
> > Micah Morton <mortonm@chromium.org> wrote:
> >
> > > On Wed, Jun 3, 2020 at 11:23 AM Micah Morton <mortonm@chromium.org> w=
rote:
> > > >
> > > > This patch accesses the ACPI system from vfio_pci_probe to print ou=
t
> > > > info if the PCI device being attached to vfio_pci is an i2c adapter=
 with
> > > > associated i2c client devices that use platform IRQs. The info prin=
ted
> > > > out is the IRQ numbers that are associated with the given i2c clien=
t
> > > > devices. This patch doesn't attempt to forward any additional IRQs =
into
> > > > the guest, but shows how it could be possible.
> > > >
> > > > Signed-off-by: Micah Morton <mortonm@chromium.org>
> > > >
> > > > Change-Id: I5c77d35f246781a4a80703820860631e2c2091cf
> > > > ---
> > > > What do you guys think about having code like this somewhere in
> > > > vfio_pci? There would have to be some logic added in vfio_pci to fo=
rward
> > > > these IRQs when they are found. For reference, below is what is pri=
nted
> > > > out during vfio_pci_probe on my development machine when I attach s=
ome
> > > > I2C adapter PCI devices to vfio_pci:
> > > >
> > > > [   48.742699] ACPI i2c client device WCOM50C1:00 uses irq 31
> > > > [   53.913295] ACPI i2c client device GOOG0005:00 uses irq 24
> > > > [   58.040076] ACPI i2c client device ACPI0C50:00 uses irq 51
> > > >
> > > > Ideally we could add code like this for other bus types (e.g. SPI).
> > > >
> > > > NOTE: developed on v5.4
> >
> > Sorry for the delay, this took some time to reach the top of the heap
> > and process.
> >
> > > >  drivers/vfio/pci/vfio_pci.c | 158 ++++++++++++++++++++++++++++++++=
++++
> >
> > I think we'd want a separate file with Kconfig options to turn it off
> > if we were to consider adding this sort of thing.  The ACPI
> > dependencies may not be present on all platforms anyway.
>
> Agreed.
>
> >
> > > >  1 file changed, 158 insertions(+)
> > > >
> > > > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pc=
i.c
> > > > index 02206162eaa9..9ce3f34aa548 100644
> > > > --- a/drivers/vfio/pci/vfio_pci.c
> > > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > > @@ -28,6 +28,10 @@
> > > >  #include <linux/vgaarb.h>
> > > >  #include <linux/nospec.h>
> > > >
> > > > +#include <linux/acpi.h>
> > > > +#include <acpi/actypes.h>
> > > > +#include <linux/i2c.h>
> > > > +
> > > >  #include "vfio_pci_private.h"
> > > >
> > > >  #define DRIVER_VERSION  "0.2"
> > > > @@ -1289,12 +1293,166 @@ static const struct vfio_device_ops vfio_p=
ci_ops =3D {
> > > >  static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
> > > >  static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
> > > >
> > > > +
> > > > +struct i2c_acpi_lookup {
> > > > +       struct i2c_board_info *info;
> > > > +       acpi_handle adapter_handle;
> > > > +       acpi_handle device_handle;
> > > > +       acpi_handle search_handle;
> > > > +       int n;
> > > > +       int index;
> > > > +       u32 speed;
> > > > +       u32 min_speed;
> > > > +       u32 force_speed;
> > > > +};
> > > > +
> > > > +static const struct acpi_device_id i2c_acpi_ignored_device_ids[] =
=3D {
> > > > +        /*
> > > > +         * ACPI video acpi_devices, which are handled by the acpi-=
video driver
> > > > +         * sometimes contain a SERIAL_TYPE_I2C ACPI resource, igno=
re these.
> > > > +         */
> > > > +        { ACPI_VIDEO_HID, 0 },
> >
> > I don't understand this, why are these devices special?  What other
> > devices might be special?  If the behavior of a host driver that's
> > independent of the PCI device driver makes it special, that seems like
> > a general problem with this approach, we can't have userspace and host
> > drivers competing for the same resources.
>
> Sorry, I just copied this code from drivers/i2c/i2c-core-acpi.c. It
> should have been removed. I think it is irrelevant to our discussion.
> In that case the i2c code is looking for i2c clients to register in
> the system and wants to avoid registering certain blacklisted devices
> and avoid attaching to them. This is not relevant to simply passing
> through the irq/MMIO/io port resources for an i2c client device. VFIO
> wouldn't actually be trying to attach any driver to the i2c clients in
> this case, and would defer to the host to choose what it wants to
> attach to.
>
> >
> > > > +        {}
> > > > +};
> > > > +
> > > > +static int i2c_acpi_get_info_for_node(struct acpi_resource *ares, =
void *data)
> > > > +{
> > > > +        struct i2c_acpi_lookup *lookup =3D data;
> > > > +        struct i2c_board_info *info =3D lookup->info;
> > > > +        struct acpi_resource_i2c_serialbus *sb;
> > > > +        acpi_status status;
> > > > +
> > > > +        if (info->addr || !i2c_acpi_get_i2c_resource(ares, &sb))
> > > > +                return 1;
> > > > +
> > > > +        if (lookup->index !=3D -1 && lookup->n++ !=3D lookup->inde=
x)
> > > > +                return 1;
> > > > +
> > > > +        status =3D acpi_get_handle(lookup->device_handle,
> > > > +                                 sb->resource_source.string_ptr,
> > > > +                                 &lookup->adapter_handle);
> > > > +        if (ACPI_FAILURE(status))
> > > > +                return 1;
> > > > +
> > > > +        info->addr =3D sb->slave_address;
> > > > +
> > > > +        return 1;
> > > > +}
> > > > +
> > > > +static int print_irq_info_if_i2c_slave(struct acpi_device *adev,
> > > > +                              struct i2c_acpi_lookup *lookup, acpi=
_handle adapter)
> > > > +{
> > > > +        struct i2c_board_info *info =3D lookup->info;
> > > > +        struct list_head resource_list, resource_list2;
> > > > +       struct resource_entry *entry;
> > > > +        int ret;
> > > > +
> > > > +        if (acpi_bus_get_status(adev) || !adev->status.present)
> > > > +                return -EINVAL;
> > > > +
> > > > +        if (acpi_match_device_ids(adev, i2c_acpi_ignored_device_id=
s) =3D=3D 0)
> > > > +                return -ENODEV;
> > > > +
> > > > +        memset(info, 0, sizeof(*info));
> > > > +        lookup->device_handle =3D acpi_device_handle(adev);
> > > > +
> > > > +        /* Look up for I2cSerialBus resource */
> > > > +        INIT_LIST_HEAD(&resource_list);
> > > > +        ret =3D acpi_dev_get_resources(adev, &resource_list,
> > > > +                                     i2c_acpi_get_info_for_node, l=
ookup);
> > > > +
> > > > +
> > > > +       if (ret < 0 || !info->addr) {
> > > > +               acpi_dev_free_resource_list(&resource_list);
> > > > +                return -EINVAL;
> > > > +       }
> > > > +
> > > > +        if (adapter) {
> > > > +                /* The adapter must match the one in I2cSerialBus(=
) connector */
> > > > +                if (adapter !=3D lookup->adapter_handle)
> > > > +                        return -ENODEV;
> > > > +       }
> > > > +
> > > > +        INIT_LIST_HEAD(&resource_list2);
> > > > +       ret =3D acpi_dev_get_resources(adev, &resource_list2, NULL,=
 NULL);
> > > > +       if (ret < 0)
> > > > +               return -EINVAL;
> > > > +
> > > > +        resource_list_for_each_entry(entry, &resource_list2) {
> >
> > Let me see if I understand what's happening here, first we walk all the
> > ACPI resources of the device to verify that it does have a
> > ACPI_RESOURCE_SERIAL_TYPE_I2C and we're able to get a handle for that
> > pathname.  info->addr is some throw-away data we use to determine
> > success (seems like we could return -1 on ACPI_FAILURE to stop
> > iterating at that point as we won't get past the index check for
> > anything else, and avoid info->addr).  Then once we know the device
> > includes the necessary i2c type, we collect all the resources (for some
> > reason using a different list even though our previous callback only
> > returns 1 so will never have anything added to the list).  Right?
>
> Yeah, its sloppy PoC code yanked out of drivers/i2c/i2c-core-acpi.c
> for the most part. I tried to cut out the easy parts of the code that
> didn't need to be there, but there would obviously be more work to do
> in optimizing the code for what we would actually want to happen in
> VFIO. Seems like we're on the same page on all the important points
> though.
>
> >
> > > > +                if (resource_type(entry->res) =3D=3D IORESOURCE_IR=
Q) {
> > >
> > > In reference to Eric's question, it's also simple to check for other
> > > types of resources here (like IORESOURCE_IO (I/O port) or
> > > IORESOURCE_MEM (MMIO)), which would allow for making those types of
> > > resources for devices behind the bus controller available to the gues=
t
> > > as well. I think MMIO would be simple enough. I/O ports would require
> > > a way for VFIO to tell KVM to set the right bits in the VMCS I/O port
> > > bitmap* when initializing the guest so that the guest can access the
> > > needed I/O ports without trapping to the host. Or I/O ports could jus=
t
> > > be trapped and then the read/write carried out in the host.
> >
> > The latter is how we support I/O port space, VFIO is a userspace driver
> > interface, not a KVM device interface.  I/O port access has not been
> > shown to be worth any further optimization.
>
> Makes sense, thanks.
>
> >
> > > Alex, does it seem reasonable to consult ACPI in this way and use thi=
s
> > > info to make sub-device resources available in the guest? I don't
> > > anticipate a case where any sub-devices are DMA-capable and could
> > > circumvent IOMMU translation to write to host memory. Do you see any
> > > other potential pitfalls? I guess the only drawback I see is needing
> > > code in the VMM to copy chunks of the ACPI tables from host to guest
> > > to tell it about the sub-devices -- but that's pretty doable.
> >
> > Is there a concern about shared versus exclusive resources?  For
> > example an interrupt could be shared among multiple i2c endpoints,
> > right?  We don't know who it might be shared with and we don't know
> > enough about our endpoint to know how to determine if our endpoint is
> > signaling the interrupt or how to mask it from signaling the interrupt
> > at the device level.  I assume where we handle SET_IRQS for this device
> > specific interrupt we'd therefore never use IRQF_SHARED, such that we
> > require an exclusive interrupt.  MMIO and I/O port resources seem

I think requiring an exclusive interrupt makes sense, since the
request_irq() in VFIO will fail when any other driver in the host has
a handler registered for that irq (shared or otherwise). This gets
into the territory of the user/VMM potentially needing to unbind an
ACPI driver from a device before assignment of the PCI
controller/adapter to the guest -- I guess that=E2=80=99s not too much to a=
sk
given the similar precedent for PCI devices. In fact, that would
probably be a requirement for this use case anyway to make sure no
drivers in the host are still trying to talk to the MMIOs/ports for a
device that is being assigned to a guest.

The only alternative I can think of to using exclusively exclusive
IRQs would be to have platform-device-specific routines in vfio-pci to
check if the device whose IRQ we want to forward into the guest was
the one that triggered the shared IRQ (sort of like what is done for
reset drivers in vfio-platform:
https://elixir.bootlin.com/linux/latest/source/drivers/vfio/platform/reset)=
.
This quirk-type approach is probably not the most appealing though.

> > straightforward to expose as device specific regions, but makes me
> > curious what we're really exposing.  I'm nervous that we're blurring
> > the line between one device and another, for example if an i2c endpoint
> > is only accessible via the i2c controller on the PCI device then we can
> > claim the user owns those sub-devices, but if the device responds to
> > MMIO or I/O port space independent of the ownership of the PCI i2c
> > controller itself, how do we know we're not conflicting with an ACPI
> > based driver that's already attached to this sub-device?  Is this
> > essentially the concern with the ACPI_VIDEO_HID exclusion above?  Do we
> > need to take the same approach of requiring an exclusive interrupt by
> > using request_resource() and error on conflicts?

When we discover ACPI sub-devices behind a given PCI device we could
just check whether there is any driver attached to that device and
deny binding the adapter to vfio-pci if so? The acpi_device struct we
get from acpi_bus_get_device() has a =E2=80=9Cdriver=E2=80=9D field that po=
ints to an
acpi_driver struct. I think if we can guarantee there are no drivers
attached to the sub-devices then we are in the clear in terms of
drivers in the host and guest fighting over MMIOs/ports. What do you
think? Maybe additional safeguards like request_resource() make sense
as well.

>
> I'm going to do some further thinking/research on this and will reply
> sometime early next week. Answering all the other questions now
> though.
>
> >
> > Seems like it might be prudent to not only have a Kconfig but require
> > and opt-in for this support at the vfio-pci module level.
>
> Agreed.
>
> >
> > Somehow we also need to factor in usability, for example how do we
> > provide enough context in describing the device specific region/irq to
> > the user that they can associate the object and perhaps avoid
> > independently parsing AML or providing a magic firmware blob.
> >
> > > I think this might be Intel specific, would have to check how to do
> > > the equivalent thing on AMD.
> >
> > This is all generic ACPI though, are you only suggesting different
> > conventions between the firmware implementations between vendors?
>
> Sorry, there was supposed to be an asterisk before that line pointing
> to the VMCS I/O port bitmap stuff. All I was saying is that the VMCS
> stuff may be Intel-specific. Doesn't really matter however as you
> pointed out its better just to emulate the I/O port access anyway.
>
> >
> > > > +                        printk(KERN_EMERG "ACPI i2c client device =
%s uses irq %d\n",
> > > > +                                               dev_name(&adev->dev=
), entry->res->start);
> > > > +                        break;
> > > > +                }
> > > > +        }
> > > > +
> > > > +        acpi_dev_free_resource_list(&resource_list2);
> > > > +
> > > > +        return 0;
> > > > +}
> > > > +
> > > > +static int i2c_acpi_get_info(struct acpi_device *adev,
> > > > +                             struct i2c_board_info *info,
> > > > +                             acpi_handle adapter,
> > > > +                             acpi_handle *adapter_handle)
> > > > +{
> > > > +        struct i2c_acpi_lookup lookup;
> > > > +
> > > > +
> > > > +        memset(&lookup, 0, sizeof(lookup));
> > > > +        lookup.info =3D info;
> > > > +        lookup.index =3D -1;
> > > > +
> > > > +        if (acpi_device_enumerated(adev))
> > > > +                return -EINVAL;
> > > > +
> > > > +        return print_irq_info_if_i2c_slave(adev, &lookup, adapter)=
;
> > > > +}
> > > > +
> > > > +static acpi_status process_acpi_node(acpi_handle handle, u32 level=
,
> > > > +                                       void *data, void **return_v=
alue)
> > > > +{
> > > > +        acpi_handle adapter =3D data;
> > > > +        struct acpi_device *adev;
> > > > +        struct i2c_board_info info;
> > > > +
> > > > +        if (acpi_bus_get_device(handle, &adev))
> > > > +                return AE_OK;
> > > > +
> > > > +        if (i2c_acpi_get_info(adev, &info, adapter, NULL))
> > > > +                return AE_OK;
> > > > +
> > > > +        return AE_OK;
> > > > +}
> > > > +
> > > > +#define MAX_SCAN_DEPTH 32
> >
> > Arbitrary?  Thanks,
>
> Again just copied what was done in drivers/i2c/i2c-core-acpi.c. Not
> really sure how they came up with that number. Seems potentially
> arbitrary.
>
> >
> > Alex
>
> Thanks for the reply, I'll get back to you with my thoughts on shared
> vs exclusive resource stuff.
>
> >
> > > > +
> > > > +void acpi_print_irqs_if_i2c(acpi_handle handle)
> > > > +{
> > > > +        acpi_status status;
> > > > +
> > > > +        status =3D acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
> > > > +                                     MAX_SCAN_DEPTH,
> > > > +                                     process_acpi_node, NULL,
> > > > +                                     handle, NULL);
> > > > +        if (ACPI_FAILURE(status))
> > > > +                printk(KERN_EMERG "failed to enumerate ACPI device=
s\n");
> > > > +}
> > > > +
> > > > +static void print_irqs_if_i2c_adapter(struct device *dev) {
> > > > +       acpi_handle handle =3D ACPI_HANDLE(dev);
> > > > +       acpi_print_irqs_if_i2c(handle);
> > > > +}
> > > > +
> > > >  static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_d=
evice_id *id)
> > > >  {
> > > >         struct vfio_pci_device *vdev;
> > > >         struct iommu_group *group;
> > > >         int ret;
> > > >
> > > > +        if (has_acpi_companion(&pdev->dev))
> > > > +               print_irqs_if_i2c_adapter(&pdev->dev);
> > > > +
> > > >         if (pdev->hdr_type !=3D PCI_HEADER_TYPE_NORMAL)
> > > >                 return -EINVAL;
> > > >
> > > > --
> > > > 2.26.2
> > > >
> > >
> >

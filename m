Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A90201ABF
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 20:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388216AbgFSSwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 14:52:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27298 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726990AbgFSSv7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 14:51:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592592717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9E9BbjiuvQuQ4rqWwtpLNM+wZOE6h2mj/lHn04p59eE=;
        b=FDVzt9Xv6urvIfupW2ouomuPslZAS9tED0dqh6VCt/r2LM/0avMaMkFIku8hAKoay6jPx7
        xWTyNcrpuZYWoxQUbHRK9Pqh9bDCgm0L8aw7BZ2Zrr9ADdmQHud6VX4NkgMF4KKVu5HdIq
        yk4FEYMrm4vUvXkDsFkF5b3rB01Mg8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-voZBJjYWNCm2NV2cXAQxUQ-1; Fri, 19 Jun 2020 14:51:52 -0400
X-MC-Unique: voZBJjYWNCm2NV2cXAQxUQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1C39107ACCD;
        Fri, 19 Jun 2020 18:51:51 +0000 (UTC)
Received: from w520.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DD3519D7B;
        Fri, 19 Jun 2020 18:51:48 +0000 (UTC)
Date:   Fri, 19 Jun 2020 12:51:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Micah Morton <mortonm@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio: PoC patch for printing IRQs used by i2c devices
Message-ID: <20200619125147.72133184@w520.home>
In-Reply-To: <CAJ-EccN0nXY1keytZdTK45mPus-VEbw_r6v_n7r+eU5YTfzJJw@mail.gmail.com>
References: <CAJ-EccPU8KpU96PM2PtroLjdNVDbvnxwKwWJr2B+RBKuXEr7Vw@mail.gmail.com>
 <20200603182322.196940-1-mortonm@chromium.org>
 <CAJ-EccN0nXY1keytZdTK45mPus-VEbw_r6v_n7r+eU5YTfzJJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Jun 2020 13:19:19 -0700
Micah Morton <mortonm@chromium.org> wrote:

> On Wed, Jun 3, 2020 at 11:23 AM Micah Morton <mortonm@chromium.org> wrote:
> >
> > This patch accesses the ACPI system from vfio_pci_probe to print out
> > info if the PCI device being attached to vfio_pci is an i2c adapter with
> > associated i2c client devices that use platform IRQs. The info printed
> > out is the IRQ numbers that are associated with the given i2c client
> > devices. This patch doesn't attempt to forward any additional IRQs into
> > the guest, but shows how it could be possible.
> >
> > Signed-off-by: Micah Morton <mortonm@chromium.org>
> >
> > Change-Id: I5c77d35f246781a4a80703820860631e2c2091cf
> > ---
> > What do you guys think about having code like this somewhere in
> > vfio_pci? There would have to be some logic added in vfio_pci to forward
> > these IRQs when they are found. For reference, below is what is printed
> > out during vfio_pci_probe on my development machine when I attach some
> > I2C adapter PCI devices to vfio_pci:
> >
> > [   48.742699] ACPI i2c client device WCOM50C1:00 uses irq 31
> > [   53.913295] ACPI i2c client device GOOG0005:00 uses irq 24
> > [   58.040076] ACPI i2c client device ACPI0C50:00 uses irq 51
> >
> > Ideally we could add code like this for other bus types (e.g. SPI).
> >
> > NOTE: developed on v5.4

Sorry for the delay, this took some time to reach the top of the heap
and process.

> >  drivers/vfio/pci/vfio_pci.c | 158 ++++++++++++++++++++++++++++++++++++

I think we'd want a separate file with Kconfig options to turn it off
if we were to consider adding this sort of thing.  The ACPI
dependencies may not be present on all platforms anyway.

> >  1 file changed, 158 insertions(+)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 02206162eaa9..9ce3f34aa548 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -28,6 +28,10 @@
> >  #include <linux/vgaarb.h>
> >  #include <linux/nospec.h>
> >
> > +#include <linux/acpi.h>
> > +#include <acpi/actypes.h>
> > +#include <linux/i2c.h>
> > +
> >  #include "vfio_pci_private.h"
> >
> >  #define DRIVER_VERSION  "0.2"
> > @@ -1289,12 +1293,166 @@ static const struct vfio_device_ops vfio_pci_ops = {
> >  static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
> >  static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
> >
> > +
> > +struct i2c_acpi_lookup {
> > +       struct i2c_board_info *info;
> > +       acpi_handle adapter_handle;
> > +       acpi_handle device_handle;
> > +       acpi_handle search_handle;
> > +       int n;
> > +       int index;
> > +       u32 speed;
> > +       u32 min_speed;
> > +       u32 force_speed;
> > +};
> > +
> > +static const struct acpi_device_id i2c_acpi_ignored_device_ids[] = {
> > +        /*
> > +         * ACPI video acpi_devices, which are handled by the acpi-video driver
> > +         * sometimes contain a SERIAL_TYPE_I2C ACPI resource, ignore these.
> > +         */
> > +        { ACPI_VIDEO_HID, 0 },

I don't understand this, why are these devices special?  What other
devices might be special?  If the behavior of a host driver that's
independent of the PCI device driver makes it special, that seems like
a general problem with this approach, we can't have userspace and host
drivers competing for the same resources.

> > +        {}
> > +};
> > +
> > +static int i2c_acpi_get_info_for_node(struct acpi_resource *ares, void *data)
> > +{
> > +        struct i2c_acpi_lookup *lookup = data;
> > +        struct i2c_board_info *info = lookup->info;
> > +        struct acpi_resource_i2c_serialbus *sb;
> > +        acpi_status status;
> > +
> > +        if (info->addr || !i2c_acpi_get_i2c_resource(ares, &sb))
> > +                return 1;
> > +
> > +        if (lookup->index != -1 && lookup->n++ != lookup->index)
> > +                return 1;
> > +
> > +        status = acpi_get_handle(lookup->device_handle,
> > +                                 sb->resource_source.string_ptr,
> > +                                 &lookup->adapter_handle);
> > +        if (ACPI_FAILURE(status))
> > +                return 1;
> > +
> > +        info->addr = sb->slave_address;
> > +
> > +        return 1;
> > +}
> > +
> > +static int print_irq_info_if_i2c_slave(struct acpi_device *adev,
> > +                              struct i2c_acpi_lookup *lookup, acpi_handle adapter)
> > +{
> > +        struct i2c_board_info *info = lookup->info;
> > +        struct list_head resource_list, resource_list2;
> > +       struct resource_entry *entry;
> > +        int ret;
> > +
> > +        if (acpi_bus_get_status(adev) || !adev->status.present)
> > +                return -EINVAL;
> > +
> > +        if (acpi_match_device_ids(adev, i2c_acpi_ignored_device_ids) == 0)
> > +                return -ENODEV;
> > +
> > +        memset(info, 0, sizeof(*info));
> > +        lookup->device_handle = acpi_device_handle(adev);
> > +
> > +        /* Look up for I2cSerialBus resource */
> > +        INIT_LIST_HEAD(&resource_list);
> > +        ret = acpi_dev_get_resources(adev, &resource_list,
> > +                                     i2c_acpi_get_info_for_node, lookup);
> > +
> > +
> > +       if (ret < 0 || !info->addr) {
> > +               acpi_dev_free_resource_list(&resource_list);
> > +                return -EINVAL;
> > +       }
> > +
> > +        if (adapter) {
> > +                /* The adapter must match the one in I2cSerialBus() connector */
> > +                if (adapter != lookup->adapter_handle)
> > +                        return -ENODEV;
> > +       }
> > +
> > +        INIT_LIST_HEAD(&resource_list2);
> > +       ret = acpi_dev_get_resources(adev, &resource_list2, NULL, NULL);
> > +       if (ret < 0)
> > +               return -EINVAL;
> > +
> > +        resource_list_for_each_entry(entry, &resource_list2) {

Let me see if I understand what's happening here, first we walk all the
ACPI resources of the device to verify that it does have a
ACPI_RESOURCE_SERIAL_TYPE_I2C and we're able to get a handle for that
pathname.  info->addr is some throw-away data we use to determine
success (seems like we could return -1 on ACPI_FAILURE to stop
iterating at that point as we won't get past the index check for
anything else, and avoid info->addr).  Then once we know the device
includes the necessary i2c type, we collect all the resources (for some
reason using a different list even though our previous callback only
returns 1 so will never have anything added to the list).  Right?

> > +                if (resource_type(entry->res) == IORESOURCE_IRQ) {  
> 
> In reference to Eric's question, it's also simple to check for other
> types of resources here (like IORESOURCE_IO (I/O port) or
> IORESOURCE_MEM (MMIO)), which would allow for making those types of
> resources for devices behind the bus controller available to the guest
> as well. I think MMIO would be simple enough. I/O ports would require
> a way for VFIO to tell KVM to set the right bits in the VMCS I/O port
> bitmap* when initializing the guest so that the guest can access the
> needed I/O ports without trapping to the host. Or I/O ports could just
> be trapped and then the read/write carried out in the host.

The latter is how we support I/O port space, VFIO is a userspace driver
interface, not a KVM device interface.  I/O port access has not been
shown to be worth any further optimization.
 
> Alex, does it seem reasonable to consult ACPI in this way and use this
> info to make sub-device resources available in the guest? I don't
> anticipate a case where any sub-devices are DMA-capable and could
> circumvent IOMMU translation to write to host memory. Do you see any
> other potential pitfalls? I guess the only drawback I see is needing
> code in the VMM to copy chunks of the ACPI tables from host to guest
> to tell it about the sub-devices -- but that's pretty doable.

Is there a concern about shared versus exclusive resources?  For
example an interrupt could be shared among multiple i2c endpoints,
right?  We don't know who it might be shared with and we don't know
enough about our endpoint to know how to determine if our endpoint is
signaling the interrupt or how to mask it from signaling the interrupt
at the device level.  I assume where we handle SET_IRQS for this device
specific interrupt we'd therefore never use IRQF_SHARED, such that we
require an exclusive interrupt.  MMIO and I/O port resources seem
straightforward to expose as device specific regions, but makes me
curious what we're really exposing.  I'm nervous that we're blurring
the line between one device and another, for example if an i2c endpoint
is only accessible via the i2c controller on the PCI device then we can
claim the user owns those sub-devices, but if the device responds to
MMIO or I/O port space independent of the ownership of the PCI i2c
controller itself, how do we know we're not conflicting with an ACPI
based driver that's already attached to this sub-device?  Is this
essentially the concern with the ACPI_VIDEO_HID exclusion above?  Do we
need to take the same approach of requiring an exclusive interrupt by
using request_resource() and error on conflicts?

Seems like it might be prudent to not only have a Kconfig but require
and opt-in for this support at the vfio-pci module level.

Somehow we also need to factor in usability, for example how do we
provide enough context in describing the device specific region/irq to
the user that they can associate the object and perhaps avoid
independently parsing AML or providing a magic firmware blob.

> I think this might be Intel specific, would have to check how to do
> the equivalent thing on AMD.

This is all generic ACPI though, are you only suggesting different
conventions between the firmware implementations between vendors?
 
> > +                        printk(KERN_EMERG "ACPI i2c client device %s uses irq %d\n",
> > +                                               dev_name(&adev->dev), entry->res->start);
> > +                        break;
> > +                }
> > +        }
> > +
> > +        acpi_dev_free_resource_list(&resource_list2);
> > +
> > +        return 0;
> > +}
> > +
> > +static int i2c_acpi_get_info(struct acpi_device *adev,
> > +                             struct i2c_board_info *info,
> > +                             acpi_handle adapter,
> > +                             acpi_handle *adapter_handle)
> > +{
> > +        struct i2c_acpi_lookup lookup;
> > +
> > +
> > +        memset(&lookup, 0, sizeof(lookup));
> > +        lookup.info = info;
> > +        lookup.index = -1;
> > +
> > +        if (acpi_device_enumerated(adev))
> > +                return -EINVAL;
> > +
> > +        return print_irq_info_if_i2c_slave(adev, &lookup, adapter);
> > +}
> > +
> > +static acpi_status process_acpi_node(acpi_handle handle, u32 level,
> > +                                       void *data, void **return_value)
> > +{
> > +        acpi_handle adapter = data;
> > +        struct acpi_device *adev;
> > +        struct i2c_board_info info;
> > +
> > +        if (acpi_bus_get_device(handle, &adev))
> > +                return AE_OK;
> > +
> > +        if (i2c_acpi_get_info(adev, &info, adapter, NULL))
> > +                return AE_OK;
> > +
> > +        return AE_OK;
> > +}
> > +
> > +#define MAX_SCAN_DEPTH 32

Arbitrary?  Thanks,

Alex

> > +
> > +void acpi_print_irqs_if_i2c(acpi_handle handle)
> > +{
> > +        acpi_status status;
> > +
> > +        status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
> > +                                     MAX_SCAN_DEPTH,
> > +                                     process_acpi_node, NULL,
> > +                                     handle, NULL);
> > +        if (ACPI_FAILURE(status))
> > +                printk(KERN_EMERG "failed to enumerate ACPI devices\n");
> > +}
> > +
> > +static void print_irqs_if_i2c_adapter(struct device *dev) {
> > +       acpi_handle handle = ACPI_HANDLE(dev);
> > +       acpi_print_irqs_if_i2c(handle);
> > +}
> > +
> >  static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >  {
> >         struct vfio_pci_device *vdev;
> >         struct iommu_group *group;
> >         int ret;
> >
> > +        if (has_acpi_companion(&pdev->dev))
> > +               print_irqs_if_i2c_adapter(&pdev->dev);
> > +
> >         if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
> >                 return -EINVAL;
> >
> > --
> > 2.26.2
> >  
> 


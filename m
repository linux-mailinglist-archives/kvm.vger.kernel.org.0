Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4750F1F47F9
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 22:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732824AbgFIUTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 16:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFIUTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 16:19:34 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD781C05BD1E
        for <kvm@vger.kernel.org>; Tue,  9 Jun 2020 13:19:32 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a25so28725ejg.5
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 13:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MrzLpWL146Otc70Mcejp1MXOGiScaZBPmCjobTIb7Vs=;
        b=M69wdhynd7o5mFBkC1rzpMaTTeOclmomB9f7MC5JnkhxC4rwfaMSANGp82UjKzy+w4
         kaldhEtBjG6HhIccbRBBFk/XfPEL7Z8/J67oTxnB8QFSU4vyDg/GP7wXQcA89k1/2ilG
         Bi9FFfa/2idNfai6PHNeWQ+dh3jBngM3hX79w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MrzLpWL146Otc70Mcejp1MXOGiScaZBPmCjobTIb7Vs=;
        b=hSVmWYM3aTjYSSnR27b8c4aA0C1cwvswGvlDsMZY8IMAgGvRphZ4e7zGZiA4o4JeXX
         ZzQ4x0MmF7Pyzchyv5MX9jnKOEEL9FVLqQmsmjS4Sr3ATyyVXYAGYX9wtQ4qbc/Fsb/R
         K+1I6OsrINkwhz23zwMhbfMARVm3ZdvQBqpt+auWCQcnsgyFFoKJiETK4cqxoCTZw0WX
         PeLW48a1RGoaUm6rZGeNcHE80AHN/ImoCcMNmj6JevnUWESBJ57JY0dq42KyplNEBwz+
         P2ox+BbpCfr6FGwLJdv/kx1FrFz7sMipiLJ7t0cVHVW5qfFa/YHtzGgn9aGIkFT2mdda
         8juQ==
X-Gm-Message-State: AOAM530My6U6a9hiUdBrHER7UnP2Vmo08cAyq1bIFMn/tkwzlqBsfkNE
        ahrh84kGhCY5KmevXzi5IAkhFP+7LB27fG35OL2VTw==
X-Google-Smtp-Source: ABdhPJyZ4+PS+cEyuJuIqe8jDcplfygviQP39EEleazhmydXvHX5GmYkkupsp5BE8Tqi5ZeE61EzhdEm91YeZDPhQvA=
X-Received: by 2002:a17:906:7e50:: with SMTP id z16mr107421ejr.277.1591733970944;
 Tue, 09 Jun 2020 13:19:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ-EccPU8KpU96PM2PtroLjdNVDbvnxwKwWJr2B+RBKuXEr7Vw@mail.gmail.com>
 <20200603182322.196940-1-mortonm@chromium.org>
In-Reply-To: <20200603182322.196940-1-mortonm@chromium.org>
From:   Micah Morton <mortonm@chromium.org>
Date:   Tue, 9 Jun 2020 13:19:19 -0700
Message-ID: <CAJ-EccN0nXY1keytZdTK45mPus-VEbw_r6v_n7r+eU5YTfzJJw@mail.gmail.com>
Subject: Re: [PATCH] vfio: PoC patch for printing IRQs used by i2c devices
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 3, 2020 at 11:23 AM Micah Morton <mortonm@chromium.org> wrote:
>
> This patch accesses the ACPI system from vfio_pci_probe to print out
> info if the PCI device being attached to vfio_pci is an i2c adapter with
> associated i2c client devices that use platform IRQs. The info printed
> out is the IRQ numbers that are associated with the given i2c client
> devices. This patch doesn't attempt to forward any additional IRQs into
> the guest, but shows how it could be possible.
>
> Signed-off-by: Micah Morton <mortonm@chromium.org>
>
> Change-Id: I5c77d35f246781a4a80703820860631e2c2091cf
> ---
> What do you guys think about having code like this somewhere in
> vfio_pci? There would have to be some logic added in vfio_pci to forward
> these IRQs when they are found. For reference, below is what is printed
> out during vfio_pci_probe on my development machine when I attach some
> I2C adapter PCI devices to vfio_pci:
>
> [   48.742699] ACPI i2c client device WCOM50C1:00 uses irq 31
> [   53.913295] ACPI i2c client device GOOG0005:00 uses irq 24
> [   58.040076] ACPI i2c client device ACPI0C50:00 uses irq 51
>
> Ideally we could add code like this for other bus types (e.g. SPI).
>
> NOTE: developed on v5.4
>
>  drivers/vfio/pci/vfio_pci.c | 158 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 158 insertions(+)
>
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 02206162eaa9..9ce3f34aa548 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -28,6 +28,10 @@
>  #include <linux/vgaarb.h>
>  #include <linux/nospec.h>
>
> +#include <linux/acpi.h>
> +#include <acpi/actypes.h>
> +#include <linux/i2c.h>
> +
>  #include "vfio_pci_private.h"
>
>  #define DRIVER_VERSION  "0.2"
> @@ -1289,12 +1293,166 @@ static const struct vfio_device_ops vfio_pci_ops = {
>  static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
>  static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
>
> +
> +struct i2c_acpi_lookup {
> +       struct i2c_board_info *info;
> +       acpi_handle adapter_handle;
> +       acpi_handle device_handle;
> +       acpi_handle search_handle;
> +       int n;
> +       int index;
> +       u32 speed;
> +       u32 min_speed;
> +       u32 force_speed;
> +};
> +
> +static const struct acpi_device_id i2c_acpi_ignored_device_ids[] = {
> +        /*
> +         * ACPI video acpi_devices, which are handled by the acpi-video driver
> +         * sometimes contain a SERIAL_TYPE_I2C ACPI resource, ignore these.
> +         */
> +        { ACPI_VIDEO_HID, 0 },
> +        {}
> +};
> +
> +static int i2c_acpi_get_info_for_node(struct acpi_resource *ares, void *data)
> +{
> +        struct i2c_acpi_lookup *lookup = data;
> +        struct i2c_board_info *info = lookup->info;
> +        struct acpi_resource_i2c_serialbus *sb;
> +        acpi_status status;
> +
> +        if (info->addr || !i2c_acpi_get_i2c_resource(ares, &sb))
> +                return 1;
> +
> +        if (lookup->index != -1 && lookup->n++ != lookup->index)
> +                return 1;
> +
> +        status = acpi_get_handle(lookup->device_handle,
> +                                 sb->resource_source.string_ptr,
> +                                 &lookup->adapter_handle);
> +        if (ACPI_FAILURE(status))
> +                return 1;
> +
> +        info->addr = sb->slave_address;
> +
> +        return 1;
> +}
> +
> +static int print_irq_info_if_i2c_slave(struct acpi_device *adev,
> +                              struct i2c_acpi_lookup *lookup, acpi_handle adapter)
> +{
> +        struct i2c_board_info *info = lookup->info;
> +        struct list_head resource_list, resource_list2;
> +       struct resource_entry *entry;
> +        int ret;
> +
> +        if (acpi_bus_get_status(adev) || !adev->status.present)
> +                return -EINVAL;
> +
> +        if (acpi_match_device_ids(adev, i2c_acpi_ignored_device_ids) == 0)
> +                return -ENODEV;
> +
> +        memset(info, 0, sizeof(*info));
> +        lookup->device_handle = acpi_device_handle(adev);
> +
> +        /* Look up for I2cSerialBus resource */
> +        INIT_LIST_HEAD(&resource_list);
> +        ret = acpi_dev_get_resources(adev, &resource_list,
> +                                     i2c_acpi_get_info_for_node, lookup);
> +
> +
> +       if (ret < 0 || !info->addr) {
> +               acpi_dev_free_resource_list(&resource_list);
> +                return -EINVAL;
> +       }
> +
> +        if (adapter) {
> +                /* The adapter must match the one in I2cSerialBus() connector */
> +                if (adapter != lookup->adapter_handle)
> +                        return -ENODEV;
> +       }
> +
> +        INIT_LIST_HEAD(&resource_list2);
> +       ret = acpi_dev_get_resources(adev, &resource_list2, NULL, NULL);
> +       if (ret < 0)
> +               return -EINVAL;
> +
> +        resource_list_for_each_entry(entry, &resource_list2) {
> +                if (resource_type(entry->res) == IORESOURCE_IRQ) {

In reference to Eric's question, it's also simple to check for other
types of resources here (like IORESOURCE_IO (I/O port) or
IORESOURCE_MEM (MMIO)), which would allow for making those types of
resources for devices behind the bus controller available to the guest
as well. I think MMIO would be simple enough. I/O ports would require
a way for VFIO to tell KVM to set the right bits in the VMCS I/O port
bitmap* when initializing the guest so that the guest can access the
needed I/O ports without trapping to the host. Or I/O ports could just
be trapped and then the read/write carried out in the host.

Alex, does it seem reasonable to consult ACPI in this way and use this
info to make sub-device resources available in the guest? I don't
anticipate a case where any sub-devices are DMA-capable and could
circumvent IOMMU translation to write to host memory. Do you see any
other potential pitfalls? I guess the only drawback I see is needing
code in the VMM to copy chunks of the ACPI tables from host to guest
to tell it about the sub-devices -- but that's pretty doable.

I think this might be Intel specific, would have to check how to do
the equivalent thing on AMD.

> +                        printk(KERN_EMERG "ACPI i2c client device %s uses irq %d\n",
> +                                               dev_name(&adev->dev), entry->res->start);
> +                        break;
> +                }
> +        }
> +
> +        acpi_dev_free_resource_list(&resource_list2);
> +
> +        return 0;
> +}
> +
> +static int i2c_acpi_get_info(struct acpi_device *adev,
> +                             struct i2c_board_info *info,
> +                             acpi_handle adapter,
> +                             acpi_handle *adapter_handle)
> +{
> +        struct i2c_acpi_lookup lookup;
> +
> +
> +        memset(&lookup, 0, sizeof(lookup));
> +        lookup.info = info;
> +        lookup.index = -1;
> +
> +        if (acpi_device_enumerated(adev))
> +                return -EINVAL;
> +
> +        return print_irq_info_if_i2c_slave(adev, &lookup, adapter);
> +}
> +
> +static acpi_status process_acpi_node(acpi_handle handle, u32 level,
> +                                       void *data, void **return_value)
> +{
> +        acpi_handle adapter = data;
> +        struct acpi_device *adev;
> +        struct i2c_board_info info;
> +
> +        if (acpi_bus_get_device(handle, &adev))
> +                return AE_OK;
> +
> +        if (i2c_acpi_get_info(adev, &info, adapter, NULL))
> +                return AE_OK;
> +
> +        return AE_OK;
> +}
> +
> +#define MAX_SCAN_DEPTH 32
> +
> +void acpi_print_irqs_if_i2c(acpi_handle handle)
> +{
> +        acpi_status status;
> +
> +        status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
> +                                     MAX_SCAN_DEPTH,
> +                                     process_acpi_node, NULL,
> +                                     handle, NULL);
> +        if (ACPI_FAILURE(status))
> +                printk(KERN_EMERG "failed to enumerate ACPI devices\n");
> +}
> +
> +static void print_irqs_if_i2c_adapter(struct device *dev) {
> +       acpi_handle handle = ACPI_HANDLE(dev);
> +       acpi_print_irqs_if_i2c(handle);
> +}
> +
>  static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>         struct vfio_pci_device *vdev;
>         struct iommu_group *group;
>         int ret;
>
> +        if (has_acpi_companion(&pdev->dev))
> +               print_irqs_if_i2c_adapter(&pdev->dev);
> +
>         if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>                 return -EINVAL;
>
> --
> 2.26.2
>

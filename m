Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CC77D3AE2
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 17:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjJWPeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 11:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjJWPeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 11:34:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00A2BC
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698075208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CVyXYnNlesI1s2bnyJgk2UUZk/foyIhU6sDI+zB3eeI=;
        b=hXwoYepAbKqLuKWbW+bQEzIKwnUvKe2pNci9lGTo6K2pVJg+xeT3xgxNA2awgid8gy9ENj
        4Vc6sLnEb3Wb9KDm6/1Z9NZwwIkthziIojIzJC7kvooUmOQGt9LMGVCJ4AXWp3svYVdwUi
        5P4HVICUgrJvSgWszq1K6V2UOfJB6tE=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-fxfW3nQkOUmyQK8K2zevMQ-1; Mon, 23 Oct 2023 11:33:26 -0400
X-MC-Unique: fxfW3nQkOUmyQK8K2zevMQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7a9415f941aso283447139f.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:33:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698075205; x=1698680005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CVyXYnNlesI1s2bnyJgk2UUZk/foyIhU6sDI+zB3eeI=;
        b=nKIDZEfMwglJG2d0NmTU+eNOSGEVRUaz/tOs9wimRdXdk+MBCCKFsmXs2qwnW9TXpw
         vQjKAQDfM+7oyP5+Yq32vHREhSf2nE0m/erY1/P5fUA9aTIBs8iFK8oVDSDineBauqK2
         21JRYdEWBpUa+oprY4ItV2PqNFLgN4nyASYdoIdKBkFO3p1WnvV2hHVLdL8O+58M6xI0
         jDFwV4y96VQeI0byBo7mXkjJR8GK/0MIU4BCzso6+jU+iy/LogucKAijVt8o3PjaFBwI
         FHaq+HNEncSmGJi4QpuCK5wpTU+XjxzO2zx+4EgnBycdGsskxxrppBw04vaeutbWCoPN
         MSbA==
X-Gm-Message-State: AOJu0YwgYLzKZCngifqjCOVtRSoUmXSX9wHrSwaYCS1DFOuP5Tyq88Uq
        kLz9eRcrY6nigHyAoUds2TYcD+n4S/q3mcrxl4EI5TglezmlAXztxGPoP6rnk3aoRxymlOq6B8s
        oVgSJmDoXwLso
X-Received: by 2002:a05:6602:1689:b0:7a9:629f:3c5a with SMTP id s9-20020a056602168900b007a9629f3c5amr2486004iow.14.1698075205154;
        Mon, 23 Oct 2023 08:33:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNHX8s1tVCBgdJ5d5FeQxPsEYzG+wkzJ4SpEaHuHvDxZeHq0lJujXcwqErqJeqpLdvp+UkIg==
X-Received: by 2002:a05:6602:1689:b0:7a9:629f:3c5a with SMTP id s9-20020a056602168900b007a9629f3c5amr2485973iow.14.1698075204809;
        Mon, 23 Oct 2023 08:33:24 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id d26-20020a056602185a00b0079fbb834232sm2459860ioi.19.2023.10.23.08.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 08:33:24 -0700 (PDT)
Date:   Mon, 23 Oct 2023 09:33:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <mst@redhat.com>, <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
        <feliu@nvidia.com>, <jiri@nvidia.com>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <jasowang@redhat.com>
Subject: Re: [PATCH V1 vfio 0/9] Introduce a vfio driver over virtio devices
Message-ID: <20231023093323.2a20b67c.alex.williamson@redhat.com>
In-Reply-To: <6e2c79c2-5d1d-3f3b-163b-29403c669049@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
        <6e2c79c2-5d1d-3f3b-163b-29403c669049@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 22 Oct 2023 11:20:31 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 17/10/2023 16:42, Yishai Hadas wrote:
> > This series introduce a vfio driver over virtio devices to support the
> > legacy interface functionality for VFs.
> >
> > Background, from the virtio spec [1].
> > --------------------------------------------------------------------
> > In some systems, there is a need to support a virtio legacy driver with
> > a device that does not directly support the legacy interface. In such
> > scenarios, a group owner device can provide the legacy interface
> > functionality for the group member devices. The driver of the owner
> > device can then access the legacy interface of a member device on behalf
> > of the legacy member device driver.
> >
> > For example, with the SR-IOV group type, group members (VFs) can not
> > present the legacy interface in an I/O BAR in BAR0 as expected by the
> > legacy pci driver. If the legacy driver is running inside a virtual
> > machine, the hypervisor executing the virtual machine can present a
> > virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
> > legacy driver accesses to this I/O BAR and forwards them to the group
> > owner device (PF) using group administration commands.
> > --------------------------------------------------------------------
> >
> > The first 6 patches are in the virtio area and handle the below:
> > - Fix common config map for modern device as was reported by Michael Tsirkin.
> > - Introduce the admin virtqueue infrastcture.
> > - Expose the layout of the commands that should be used for
> >    supporting the legacy access.
> > - Expose APIs to enable upper layers as of vfio, net, etc
> >    to execute admin commands.
> >
> > The above follows the virtio spec that was lastly accepted in that area
> > [1].
> >
> > The last 3 patches are in the vfio area and handle the below:
> > - Expose some APIs from vfio/pci to be used by the vfio/virtio driver.
> > - Introduce a vfio driver over virtio devices to support the legacy
> >    interface functionality for VFs.
> >
> > The series was tested successfully over virtio-net VFs in the host,
> > while running in the guest both modern and legacy drivers.
> >
> > [1]
> > https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
> >
> > Changes from V0: https://www.spinics.net/lists/linux-virtualization/msg63802.html
> >
> > Virtio:
> > - Fix the common config map size issue that was reported by Michael
> >    Tsirkin.
> > - Do not use vp_dev->vqs[] array upon vp_del_vqs() as was asked by
> >    Michael, instead skip the AQ specifically.
> > - Move admin vq implementation into virtio_pci_modern.c as was asked by
> >    Michael.
> > - Rename structure virtio_avq to virtio_pci_admin_vq and some extra
> >    corresponding renames.
> > - Remove exported symbols virtio_pci_vf_get_pf_dev(),
> >    virtio_admin_cmd_exec() as now callers are local to the module.
> > - Handle inflight commands as part of the device reset flow.
> > - Introduce APIs per admin command in virtio-pci as was asked by Michael.
> >
> > Vfio:
> > - Change to use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL for
> >    vfio_pci_core_setup_barmap() and vfio_pci_iowrite#xxx() as pointed by
> >    Alex.
> > - Drop the intermediate patch which prepares the commands and calls the
> >    generic virtio admin command API (i.e. virtio_admin_cmd_exec()).
> > - Instead, call directly to the new APIs per admin command that are
> >    exported from Virtio - based on Michael's request.
> > - Enable only virtio-net as part of the pci_device_id table to enforce
> >    upon binding only what is supported as suggested by Alex.
> > - Add support for byte-wise access (read/write) over the device config
> >    region as was asked by Alex.
> > - Consider whether MSIX is practically enabled/disabled to choose the
> >    right opcode upon issuing read/write admin command, as mentioned
> >    by Michael.
> > - Move to use VIRTIO_PCI_CONFIG_OFF instead of adding some new defines
> >    as was suggested by Michael.
> > - Set the '.close_device' op to vfio_pci_core_close_device() as was
> >    pointed by Alex.
> > - Adapt to Vfio multi-line comment style in a few places.
> > - Add virtualization@lists.linux-foundation.org in the MAINTAINERS file
> >    to be CCed for the new driver as was suggested by Jason.
> >
> > Yishai
> >
> > Feng Liu (5):
> >    virtio-pci: Fix common config map for modern device
> >    virtio: Define feature bit for administration virtqueue
> >    virtio-pci: Introduce admin virtqueue
> >    virtio-pci: Introduce admin command sending function
> >    virtio-pci: Introduce admin commands
> >
> > Yishai Hadas (4):
> >    virtio-pci: Introduce APIs to execute legacy IO admin commands
> >    vfio/pci: Expose vfio_pci_core_setup_barmap()
> >    vfio/pci: Expose vfio_pci_iowrite/read##size()
> >    vfio/virtio: Introduce a vfio driver over virtio devices
> >
> >   MAINTAINERS                            |   7 +
> >   drivers/vfio/pci/Kconfig               |   2 +
> >   drivers/vfio/pci/Makefile              |   2 +
> >   drivers/vfio/pci/vfio_pci_core.c       |  25 ++
> >   drivers/vfio/pci/vfio_pci_rdwr.c       |  38 +-
> >   drivers/vfio/pci/virtio/Kconfig        |  15 +
> >   drivers/vfio/pci/virtio/Makefile       |   4 +
> >   drivers/vfio/pci/virtio/main.c         | 577 +++++++++++++++++++++++++
> >   drivers/virtio/virtio.c                |  37 +-
> >   drivers/virtio/virtio_pci_common.c     |  14 +
> >   drivers/virtio/virtio_pci_common.h     |  20 +-
> >   drivers/virtio/virtio_pci_modern.c     | 441 ++++++++++++++++++-
> >   drivers/virtio/virtio_pci_modern_dev.c |  24 +-
> >   include/linux/vfio_pci_core.h          |  20 +
> >   include/linux/virtio.h                 |   8 +
> >   include/linux/virtio_config.h          |   4 +
> >   include/linux/virtio_pci_admin.h       |  18 +
> >   include/linux/virtio_pci_modern.h      |   5 +
> >   include/uapi/linux/virtio_config.h     |   8 +-
> >   include/uapi/linux/virtio_pci.h        |  66 +++
> >   20 files changed, 1295 insertions(+), 40 deletions(-)
> >   create mode 100644 drivers/vfio/pci/virtio/Kconfig
> >   create mode 100644 drivers/vfio/pci/virtio/Makefile
> >   create mode 100644 drivers/vfio/pci/virtio/main.c
> >   create mode 100644 include/linux/virtio_pci_admin.h
> >  
> Hi Michael,
> 
> Did you have the chance to review the virtio part of that series ?
> 
> IMO, we addressed all your notes on V0, I would be happy to get your 
> feedback on V1 before sending V2.
> 
> In my TO-DO list for V2, have for now the below minor items.
> Virtio:
> Patch #6: Fix a krobot note where it needs to include the H file as part 
> of the export symbols C file.
> Vfio:
> #patch #9: Rename the 'ops' variable to drop the 'acc' and potentially 
> some rename in the description of the module with regards to 'family'.
> 
> Alex,
> Are you fine to leave the provisioning of the VF including the control 
> of its transitional capability in the device hands as was suggested by 
> Jason ?

If this is the standard we're going to follow, ie. profiling of a
device is expected to occur prior to the probe of the vfio-pci variant
driver, then we should get the out-of-tree NVIDIA vGPU driver on board
with this too.

> Any specific recommendation following the discussion in the ML, for the 
> 'family' note ?

It's not super important, it's just overly broad vs what's actually
implemented.  Limiting the description to virtio-net for the current
implementation is fine.

> Once I'll have the above feedback I may prepare and send V2.

I'll try to take a more thorough look, but also note my comments to
Ankit relative to config space emulation.  This driver correctly
implements the flags for the IO Port BAR, but does not support sizing
of the BAR through config space, which I think is a shortcoming
relative to that implemented by vfio-pci.  QEMU doesn't rely on this,
but we don't know there aren't other userspaces that depend on this
behavior.  Thanks,

Alex


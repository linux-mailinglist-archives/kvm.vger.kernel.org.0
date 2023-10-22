Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AA97D2207
	for <lists+kvm@lfdr.de>; Sun, 22 Oct 2023 11:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjJVJNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Oct 2023 05:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjJVJNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Oct 2023 05:13:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3DF98
        for <kvm@vger.kernel.org>; Sun, 22 Oct 2023 02:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697965954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FNHUwQ+gSx+txVVRnUjc9VphJxZEWVVV7+qBxuJkqIU=;
        b=PQtRa/3azGAUZgMQh+wpkwq5/avCoY6cZPkATw8q3N/HXpzG47Pebe+h3R9br/fRquRTQZ
        ip80Ih9j0dKfWKaXGJV5wdj+UT2ODIENYwaR7J6LznkzhLNa3W+zPEOPC7GzVdqnDgr6WE
        7nEQv7wzsNbx5TMxyiBn7xZlsdjsfUA=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-r-Om3JD9MqaAKUind8JfsA-1; Sun, 22 Oct 2023 05:12:32 -0400
X-MC-Unique: r-Om3JD9MqaAKUind8JfsA-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-507cb169766so2141236e87.0
        for <kvm@vger.kernel.org>; Sun, 22 Oct 2023 02:12:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697965951; x=1698570751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNHUwQ+gSx+txVVRnUjc9VphJxZEWVVV7+qBxuJkqIU=;
        b=Ama9IrF9/pTw7ZsV5bD7Grag0E3ebQkcsJlLPyBWphXSYp65k/407hhH7U99Ibnf9J
         cKPVbHDZx8p3kzF4u+uNlcBhInDni/T5qKjmkEASvt/BVK60hYdOGbbdeY1hj8dhHylD
         EVvaijofxBH9tzhZRSktaLgDIDkXgAS/FHSN1DHvXGRf6vTQ1zdld2wu8O27ukIsafvm
         /KzuFtp3arG9NW03Rs39dEzDf38SDCjmoU+U1jv99BeWocqi0plcgjh2Q9uJpmiYk8V8
         2Ge8dZOq7IL4uwd8XLRFWcWhRqTMTIcZPIH+IItlr/4+jmuSw3gpyq2oo6E6aZszxqCg
         U6qw==
X-Gm-Message-State: AOJu0Yx2rbkO96GeC6NcO/O/nnDoyOHvRT6j/nPdw55HQKl/EsWzBdQ4
        UZ+f9fKqo2qwEyV9xR1s0O3TiyXaQ3ljEhiOorzFEr7xavVIkSDqOwsYjRS7/p3v+ERO2b+c+rS
        Q8rvlwPgzqhVo
X-Received: by 2002:a05:6512:2808:b0:507:aad2:96af with SMTP id cf8-20020a056512280800b00507aad296afmr4947043lfb.21.1697965951482;
        Sun, 22 Oct 2023 02:12:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpDIoeiID5+q2VY1rvi6/lb0ytyuPiQ006kkqPOxg332Wg5GnoAZPGhKqjAFeJKhh9a1wY7Q==
X-Received: by 2002:a05:6512:2808:b0:507:aad2:96af with SMTP id cf8-20020a056512280800b00507aad296afmr4947030lfb.21.1697965951086;
        Sun, 22 Oct 2023 02:12:31 -0700 (PDT)
Received: from redhat.com ([2.52.1.53])
        by smtp.gmail.com with ESMTPSA id fa10-20020a05600c518a00b004064741f855sm6376858wmb.47.2023.10.22.02.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Oct 2023 02:12:30 -0700 (PDT)
Date:   Sun, 22 Oct 2023 05:12:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jgg@nvidia.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, si-wei.liu@oracle.com,
        leonro@nvidia.com, maorg@nvidia.com, jasowang@redhat.com
Subject: Re: [PATCH V1 vfio 0/9] Introduce a vfio driver over virtio devices
Message-ID: <20231022051157-mutt-send-email-mst@kernel.org>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <6e2c79c2-5d1d-3f3b-163b-29403c669049@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e2c79c2-5d1d-3f3b-163b-29403c669049@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 22, 2023 at 11:20:31AM +0300, Yishai Hadas wrote:
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

Not yet, will take a couple more days.

> IMO, we addressed all your notes on V0, I would be happy to get your
> feedback on V1 before sending V2.
> 
> In my TO-DO list for V2, have for now the below minor items.
> Virtio:
> Patch #6: Fix a krobot note where it needs to include the H file as part of
> the export symbols C file.
> Vfio:
> #patch #9: Rename the 'ops' variable to drop the 'acc' and potentially some
> rename in the description of the module with regards to 'family'.
> 
> Alex,
> Are you fine to leave the provisioning of the VF including the control of
> its transitional capability in the device hands as was suggested by Jason ?
> Any specific recommendation following the discussion in the ML, for the
> 'family' note ?
> 
> Once I'll have the above feedback I may prepare and send V2.
> 
> Yishai


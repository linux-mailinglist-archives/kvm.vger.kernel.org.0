Return-Path: <kvm+bounces-2884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0142D7FEC87
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 11:08:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 801AD282272
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773493B2B4;
	Thu, 30 Nov 2023 10:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AR/iWa1v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B49F10D0
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 02:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701338875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QtfDLkSExiQyTaRP0VRSxx1VjUPNuwzi0ZFhLl7jwqw=;
	b=AR/iWa1vLRsdxGZq/Pq7u/45jgZyycOW+Dhvh9sFUEg2qBpCG45psmLTNZcujj/hup/TG9
	B+ReQ73WV6QpUUG4JWJRrFx57bmmQXbjUXkPJhdHXCuI05sNqMwvP1aRvMNJ+cWuN0hBjo
	Jk+ayobdViuRvr319AYh40AIiVd3E5M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-d1zqlgS8O-WRNHbRXzosAQ-1; Thu, 30 Nov 2023 05:07:51 -0500
X-MC-Unique: d1zqlgS8O-WRNHbRXzosAQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40b53c8194cso5574025e9.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 02:07:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701338870; x=1701943670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtfDLkSExiQyTaRP0VRSxx1VjUPNuwzi0ZFhLl7jwqw=;
        b=OWqqEqAGyxn0kA5wb0rJUb7CUetx2adIQWnD7dWi+9mGShbCZrpRXisy0tjKuW+Rdn
         xJeut+RAfZnNFXuKVfC/cFr3VKx5+0fSpRb9ibLub2jgm0j27N+Jzp8kEhgcSDU2n77j
         fJyOSABV/3R0b1RlmCvcE4lhohJ45krnUAMa7fAQIdh5WpJNu0g3/ughtgPwEViN5pgV
         qe23IcJYehTmgHfPD+r8zFjPicZkloh27nGMIp2qEl4e/B2UbNwah1OkaNM7vRkYOO5V
         j8xD1DnfOifiCckpWti4LNYDDY2+pIrWYWk+qieogA6cnXOge2lYTREQV2Gu+ZfkvHk0
         NuYg==
X-Gm-Message-State: AOJu0Yz10vBkXpMFNn+7TzG4VS1shrATy0eIecicRayp4mWWx4M7dQzr
	vq+aTca9kRY7cm78Z+TMf5vLOTk8P2i+5995pdVPyvjpA416BNVhR9WLh/ijeMSX3FX2gfSbsMN
	PT9oqvrDgw6QH
X-Received: by 2002:a05:600c:3b22:b0:407:5b54:bb10 with SMTP id m34-20020a05600c3b2200b004075b54bb10mr14923792wms.8.1701338870082;
        Thu, 30 Nov 2023 02:07:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEnPuGs2kkkIpzsTGu1BHiLakeSARybiCeNWrSo9a6jE3NJ2+o0sNJAcG/2Q4dXhsfhKqr63g==
X-Received: by 2002:a05:600c:3b22:b0:407:5b54:bb10 with SMTP id m34-20020a05600c3b2200b004075b54bb10mr14923770wms.8.1701338869664;
        Thu, 30 Nov 2023 02:07:49 -0800 (PST)
Received: from redhat.com ([2.55.57.48])
        by smtp.gmail.com with ESMTPSA id v9-20020a05600c444900b0040b461550c4sm5113825wmn.42.2023.11.30.02.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 02:07:49 -0800 (PST)
Date: Thu, 30 Nov 2023 05:07:45 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V4 vfio 0/9] Introduce a vfio driver over virtio devices
Message-ID: <20231130050648-mutt-send-email-mst@kernel.org>
References: <20231129143746.6153-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129143746.6153-1-yishaih@nvidia.com>

On Wed, Nov 29, 2023 at 04:37:37PM +0200, Yishai Hadas wrote:
> This series introduce a vfio driver over virtio devices to support the
> legacy interface functionality for VFs.
> 
> Background, from the virtio spec [1].
> --------------------------------------------------------------------
> In some systems, there is a need to support a virtio legacy driver with
> a device that does not directly support the legacy interface. In such
> scenarios, a group owner device can provide the legacy interface
> functionality for the group member devices. The driver of the owner
> device can then access the legacy interface of a member device on behalf
> of the legacy member device driver.
> 
> For example, with the SR-IOV group type, group members (VFs) can not
> present the legacy interface in an I/O BAR in BAR0 as expected by the
> legacy pci driver. If the legacy driver is running inside a virtual
> machine, the hypervisor executing the virtual machine can present a
> virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
> legacy driver accesses to this I/O BAR and forwards them to the group
> owner device (PF) using group administration commands.
> --------------------------------------------------------------------
> 
> The first 6 patches are in the virtio area and handle the below:
> - Introduce the admin virtqueue infrastcture.
> - Expose the layout of the commands that should be used for
>   supporting the legacy access.
> - Expose APIs to enable upper layers as of vfio, net, etc
>   to execute admin commands.
> 
> The above follows the virtio spec that was lastly accepted in that area
> [1].
> 
> The last 3 patches are in the vfio area and handle the below:
> - Expose some APIs from vfio/pci to be used by the vfio/virtio driver.
> - Introduce a vfio driver over virtio devices to support the legacy
>   interface functionality for VFs. 
> 
> The series was tested successfully over virtio-net VFs in the host,
> while running in the guest both modern and legacy drivers.
> 
> [1]
> https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c



I sent a minor question, but besides that, patches 1-6 look ok
Acked-by: Michael S. Tsirkin <mst@redhat.com>

I take no stance on patches 7-9 this is up to Alex.


> Changes from V3: https://www.spinics.net/lists/kvm/msg333008.html
> Virtio:
> - Rebase on top of 6.7 rc3.
> Vfio:
> - Fix a typo, drop 'acc' from 'virtiovf_acc_vfio_pci_tran_ops'.
> 
> Changes from V2: https://lore.kernel.org/all/20231029155952.67686-8-yishaih@nvidia.com/T/
> Virtio:
> - Rebase on top of 6.7 rc1.
> - Add a mutex to serialize admin commands execution and virtqueue
>   deletion, as was suggested by Michael.
> - Remove the 'ref_count' usage which is not needed any more.
> - Reduce the depth of the admin vq to match a single command at a given time.
> - Add a supported check upon command execution and move to use a single
>   flow of virtqueue_exec_admin_cmd().
> - Improve the description of the exported commands to better match the
>   specification and the expected usage as was asked by Michael.
> 
> Vfio:
> - Upon calling to virtio_pci_admin_legacy/common_device_io_read/write()
>   supply the 'offset' within the relevant configuration area, following
>   the virtio exported APIs.
> 
> Changes from V1: https://lore.kernel.org/all/20231023104548.07b3aa19.alex.williamson@redhat.com/T/
> Virtio:
> - Drop its first patch, it was accepted upstream already.
> - Add a new patch (#6) which initializes the supported admin commands
>   upon admin queue activation as was suggested by Michael.
> - Split the legacy_io_read/write commands per common/device
>   configuration as was asked by Michael.
> - Don't expose any more the list query/used APIs outside of virtio.
> - Instead, expose an API to check whether the legacy io functionality is
>   supported as was suggested by Michael.
> - Fix some Krobot's note by adding the missing include file.
> 
> Vfio:
> - Refer specifically to virtio-net as part of the driver/module description
>   as Alex asked.
> - Change to check MSIX enablement based on the irq type of the given vfio
>   core device. In addition, drop its capable checking from the probe flow
>   as was asked by Alex.
> - Adapt to use the new virtio exposed APIs and clean some code accordingly.
> - Adapt to some cleaner style code in some places (if/else) as was suggested
>   by Alex.
> - Fix the range_intersect_range() function and adapt its usage as was
>   pointed by Alex.
> - Make struct virtiovf_pci_core_device better packed.
> - Overwrite the subsystem vendor ID to be 0x1af4 as was discussed in
>   the ML.
> - Add support for the 'bar sizing negotiation' as was asked by Alex.
> - Drop the 'acc' from the 'ops' as Alex asked.
> 
> Changes from V0: https://www.spinics.net/lists/linux-virtualization/msg63802.html
> 
> Virtio:
> - Fix the common config map size issue that was reported by Michael
>   Tsirkin.
> - Do not use vp_dev->vqs[] array upon vp_del_vqs() as was asked by
>   Michael, instead skip the AQ specifically.
> - Move admin vq implementation into virtio_pci_modern.c as was asked by
>   Michael.
> - Rename structure virtio_avq to virtio_pci_admin_vq and some extra
>   corresponding renames.
> - Remove exported symbols virtio_pci_vf_get_pf_dev(),
>   virtio_admin_cmd_exec() as now callers are local to the module.
> - Handle inflight commands as part of the device reset flow.
> - Introduce APIs per admin command in virtio-pci as was asked by Michael.
> 
> Vfio:
> - Change to use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL for
>   vfio_pci_core_setup_barmap() and vfio_pci_iowrite#xxx() as pointed by
>   Alex.
> - Drop the intermediate patch which prepares the commands and calls the
>   generic virtio admin command API (i.e. virtio_admin_cmd_exec()).
> - Instead, call directly to the new APIs per admin command that are
>   exported from Virtio - based on Michael's request.
> - Enable only virtio-net as part of the pci_device_id table to enforce
>   upon binding only what is supported as suggested by Alex.
> - Add support for byte-wise access (read/write) over the device config
>   region as was asked by Alex.
> - Consider whether MSIX is practically enabled/disabled to choose the
>   right opcode upon issuing read/write admin command, as mentioned
>   by Michael.
> - Move to use VIRTIO_PCI_CONFIG_OFF instead of adding some new defines
>   as was suggested by Michael.
> - Set the '.close_device' op to vfio_pci_core_close_device() as was
>   pointed by Alex.
> - Adapt to Vfio multi-line comment style in a few places.
> - Add virtualization@lists.linux-foundation.org in the MAINTAINERS file
>   to be CCed for the new driver as was suggested by Jason.
> 
> Yishai
> 
> Feng Liu (4):
>   virtio: Define feature bit for administration virtqueue
>   virtio-pci: Introduce admin virtqueue
>   virtio-pci: Introduce admin command sending function
>   virtio-pci: Introduce admin commands
> 
> Yishai Hadas (5):
>   virtio-pci: Initialize the supported admin commands
>   virtio-pci: Introduce APIs to execute legacy IO admin commands
>   vfio/pci: Expose vfio_pci_core_setup_barmap()
>   vfio/pci: Expose vfio_pci_iowrite/read##size()
>   vfio/virtio: Introduce a vfio driver over virtio devices
> 
>  MAINTAINERS                            |   7 +
>  drivers/vfio/pci/Kconfig               |   2 +
>  drivers/vfio/pci/Makefile              |   2 +
>  drivers/vfio/pci/vfio_pci_core.c       |  25 ++
>  drivers/vfio/pci/vfio_pci_rdwr.c       |  38 +-
>  drivers/vfio/pci/virtio/Kconfig        |  16 +
>  drivers/vfio/pci/virtio/Makefile       |   4 +
>  drivers/vfio/pci/virtio/main.c         | 554 +++++++++++++++++++++++++
>  drivers/virtio/virtio.c                |  37 +-
>  drivers/virtio/virtio_pci_common.c     |  14 +
>  drivers/virtio/virtio_pci_common.h     |  21 +-
>  drivers/virtio/virtio_pci_modern.c     | 503 +++++++++++++++++++++-
>  drivers/virtio/virtio_pci_modern_dev.c |  24 +-
>  include/linux/vfio_pci_core.h          |  20 +
>  include/linux/virtio.h                 |   8 +
>  include/linux/virtio_config.h          |   4 +
>  include/linux/virtio_pci_admin.h       |  21 +
>  include/linux/virtio_pci_modern.h      |   2 +
>  include/uapi/linux/virtio_config.h     |   8 +-
>  include/uapi/linux/virtio_pci.h        |  71 ++++
>  20 files changed, 1342 insertions(+), 39 deletions(-)
>  create mode 100644 drivers/vfio/pci/virtio/Kconfig
>  create mode 100644 drivers/vfio/pci/virtio/Makefile
>  create mode 100644 drivers/vfio/pci/virtio/main.c
>  create mode 100644 include/linux/virtio_pci_admin.h
> 
> -- 
> 2.27.0



Return-Path: <kvm+bounces-4081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF77480D2F3
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 25365B2051A
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7EF4CDF6;
	Mon, 11 Dec 2023 16:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dd+K4R+O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C338B3
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702313713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KGVc8/OL2lxNoufsjp3KG2GQ05JrCvcQkaObosImAkA=;
	b=dd+K4R+O5ijd7xjLtqBv/QvrOEcHKDoqjOjIl/hzEm0su6vZmynU2E30tdyqnv32qrm9KI
	GdULgXrrdBh83oH6CqDThWccJtPRvLut654k4rWCqsItDQbasyTOKmSy/jdNsGe4DdEoA6
	lTsc6XjPdh7ZeihzY4nSoljEsApfbr0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-vQp6m8YKObmT4261ksL-SA-1; Mon, 11 Dec 2023 11:55:12 -0500
X-MC-Unique: vQp6m8YKObmT4261ksL-SA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40c2c144e60so30996875e9.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:55:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702313711; x=1702918511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGVc8/OL2lxNoufsjp3KG2GQ05JrCvcQkaObosImAkA=;
        b=tOf2PHymYDEjTY+ZN8NrzeDSmTfFj7aMzoqYV09aIBHfrKOLlAgLM8Tmo27EUngunC
         Gm0r/wS9XrEYdh6thM5GbGKD/gj7YqBOUxtT+4URK4sjpWsRgnCOg6/KvN5L30Nmk/yx
         wabCyTWM31uIHzjx6IikDpAB8piwsVhpMXQXMm8mPLspESDvzKNfzTb4tL7FeqgtUtl4
         Xu8PPZxe3IyTKJY0ofatkKc18ynwRTHcTpf/hUcytrZ8FS1CO8+RvcU61jIdxWn9XTEL
         dwjdU3y2yv43I/g5vRpCSsO5yB9Y9mxldwz6UEIjg8vuWJ6YZSrymUyVOwR9L5gxTbjd
         kHqg==
X-Gm-Message-State: AOJu0YxxODJHAzvIvgS4UdQSctIknK2NFuadB9JMzQWNXHkz6jCcj3c7
	S2hwCa1i1Pkqh1LnJA1DJNDSPjRGdo3tO7BuGIW+RtJMvbU6Lf2IJ/81vvQeKhGOJCvkX13fxfn
	xti+bQj63SBQd
X-Received: by 2002:a05:600c:2201:b0:40c:35d4:9548 with SMTP id z1-20020a05600c220100b0040c35d49548mr2462666wml.63.1702313710781;
        Mon, 11 Dec 2023 08:55:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEzjNDK9WpG8IKx8a2ioYx0oita2p1G4RmuZ2ECJdz5Bkkj5r/ZtyNU6NakoWKt8XaykgS8zA==
X-Received: by 2002:a05:600c:2201:b0:40c:35d4:9548 with SMTP id z1-20020a05600c220100b0040c35d49548mr2462654wml.63.1702313710354;
        Mon, 11 Dec 2023 08:55:10 -0800 (PST)
Received: from redhat.com ([2a06:c701:73ff:4f00:b091:120e:5537:ac67])
        by smtp.gmail.com with ESMTPSA id m14-20020a05600c4f4e00b0040b30be6244sm13580784wmq.24.2023.12.11.08.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 08:55:09 -0800 (PST)
Date: Mon, 11 Dec 2023 11:55:06 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, parav@nvidia.com,
	feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
	joao.m.martins@oracle.com, si-wei.liu@oracle.com, leonro@nvidia.com,
	maorg@nvidia.com, jasowang@redhat.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V7 vfio 0/9] Introduce a vfio driver over virtio devices
Message-ID: <20231211115432-mutt-send-email-mst@kernel.org>
References: <20231207102820.74820-1-yishaih@nvidia.com>
 <7929884c-f8f3-4977-9474-33830cde0a07@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7929884c-f8f3-4977-9474-33830cde0a07@nvidia.com>

On Mon, Dec 11, 2023 at 10:28:23AM +0200, Yishai Hadas wrote:
> On 07/12/2023 12:28, Yishai Hadas wrote:
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
> > Changes from V6: https://lore.kernel.org/kvm/20231206083857.241946-1-yishaih@nvidia.com/
> > Vfio:
> > - Put the pm_runtime stuff into translate_io_bar_to_mem_bar() and
> >    organize the callers to be more success oriented, as suggested by Jason.
> > - Add missing 'ops' (i.e. 'detach_ioas' and 'device_feature'), as mentioned by Jason.
> > - Clean virtiovf_bar0_exists() to cast to bool automatically, as
> >    suggested by Jason.
> > - Add Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>.
> > 
> > Changes from V5: https://lore.kernel.org/kvm/20231205170623.197877-1-yishaih@nvidia.com/
> > Vfio:
> > - Rename vfio_pci_iowrite64 to vfio_pci_core_iowrite64 as was mentioned
> >    by Alex.
> > 
> > Changes from V4: https://lore.kernel.org/all/20231129143746.6153-7-yishaih@nvidia.com/T/
> > Virtio:
> > - Drop the unused macro 'VIRTIO_ADMIN_MAX_CMD_OPCODE' as was asked by
> >    Michael.
> > - Add Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > Vfio:
> > - Export vfio_pci_core_setup_barmap() in place and rename
> >    vfio_pci_iowrite/read<xxx> to have the 'core' prefix as part of the
> >    functions names, as was discussed with Alex.
> > - Improve packing of struct virtiovf_pci_core_device, as was suggested
> >    by Alex.
> > - Upon reset, set 'pci_cmd' back to zero, in addition, if
> >    the user didn't set the 'PCI_COMMAND_IO' bit, return -EIO upon any
> >    read/write towards the IO bar, as was suggested by Alex.
> > - Enforce by BUILD_BUG_ON that 'bar0_virtual_buf_size' is power of 2 as
> >    part of virtiovf_pci_init_device() and clean the 'sizing calculation'
> >    code accordingly, as was suggested by Alex.
> > 
> > Changes from V3: https://www.spinics.net/lists/kvm/msg333008.html
> > Virtio:
> > - Rebase on top of 6.7 rc3.
> > Vfio:
> > - Fix a typo, drop 'acc' from 'virtiovf_acc_vfio_pci_tran_ops'.
> > 
> > Changes from V2: https://lore.kernel.org/all/20231029155952.67686-8-yishaih@nvidia.com/T/
> > Virtio:
> > - Rebase on top of 6.7 rc1.
> > - Add a mutex to serialize admin commands execution and virtqueue
> >    deletion, as was suggested by Michael.
> > - Remove the 'ref_count' usage which is not needed any more.
> > - Reduce the depth of the admin vq to match a single command at a given time.
> > - Add a supported check upon command execution and move to use a single
> >    flow of virtqueue_exec_admin_cmd().
> > - Improve the description of the exported commands to better match the
> >    specification and the expected usage as was asked by Michael.
> > 
> > Vfio:
> > - Upon calling to virtio_pci_admin_legacy/common_device_io_read/write()
> >    supply the 'offset' within the relevant configuration area, following
> >    the virtio exported APIs.
> > 
> > Changes from V1: https://lore.kernel.org/all/20231023104548.07b3aa19.alex.williamson@redhat.com/T/
> > Virtio:
> > - Drop its first patch, it was accepted upstream already.
> > - Add a new patch (#6) which initializes the supported admin commands
> >    upon admin queue activation as was suggested by Michael.
> > - Split the legacy_io_read/write commands per common/device
> >    configuration as was asked by Michael.
> > - Don't expose any more the list query/used APIs outside of virtio.
> > - Instead, expose an API to check whether the legacy io functionality is
> >    supported as was suggested by Michael.
> > - Fix some Krobot's note by adding the missing include file.
> > 
> > Vfio:
> > - Refer specifically to virtio-net as part of the driver/module description
> >    as Alex asked.
> > - Change to check MSIX enablement based on the irq type of the given vfio
> >    core device. In addition, drop its capable checking from the probe flow
> >    as was asked by Alex.
> > - Adapt to use the new virtio exposed APIs and clean some code accordingly.
> > - Adapt to some cleaner style code in some places (if/else) as was suggested
> >    by Alex.
> > - Fix the range_intersect_range() function and adapt its usage as was
> >    pointed by Alex.
> > - Make struct virtiovf_pci_core_device better packed.
> > - Overwrite the subsystem vendor ID to be 0x1af4 as was discussed in
> >    the ML.
> > - Add support for the 'bar sizing negotiation' as was asked by Alex.
> > - Drop the 'acc' from the 'ops' as Alex asked.
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
> > Feng Liu (4):
> >    virtio: Define feature bit for administration virtqueue
> >    virtio-pci: Introduce admin virtqueue
> >    virtio-pci: Introduce admin command sending function
> >    virtio-pci: Introduce admin commands
> > 
> > Yishai Hadas (5):
> >    virtio-pci: Initialize the supported admin commands
> >    virtio-pci: Introduce APIs to execute legacy IO admin commands
> >    vfio/pci: Expose vfio_pci_core_setup_barmap()
> >    vfio/pci: Expose vfio_pci_core_iowrite/read##size()
> >    vfio/virtio: Introduce a vfio driver over virtio devices
> > 
> >   MAINTAINERS                            |   7 +
> >   drivers/vfio/pci/Kconfig               |   2 +
> >   drivers/vfio/pci/Makefile              |   2 +
> >   drivers/vfio/pci/vfio_pci_rdwr.c       |  57 +--
> >   drivers/vfio/pci/virtio/Kconfig        |  16 +
> >   drivers/vfio/pci/virtio/Makefile       |   4 +
> >   drivers/vfio/pci/virtio/main.c         | 567 +++++++++++++++++++++++++
> >   drivers/virtio/virtio.c                |  37 +-
> >   drivers/virtio/virtio_pci_common.c     |  14 +
> >   drivers/virtio/virtio_pci_common.h     |  21 +-
> >   drivers/virtio/virtio_pci_modern.c     | 503 +++++++++++++++++++++-
> >   drivers/virtio/virtio_pci_modern_dev.c |  24 +-
> >   include/linux/vfio_pci_core.h          |  20 +
> >   include/linux/virtio.h                 |   8 +
> >   include/linux/virtio_config.h          |   4 +
> >   include/linux/virtio_pci_admin.h       |  21 +
> >   include/linux/virtio_pci_modern.h      |   2 +
> >   include/uapi/linux/virtio_config.h     |   8 +-
> >   include/uapi/linux/virtio_pci.h        |  68 +++
> >   19 files changed, 1349 insertions(+), 36 deletions(-)
> >   create mode 100644 drivers/vfio/pci/virtio/Kconfig
> >   create mode 100644 drivers/vfio/pci/virtio/Makefile
> >   create mode 100644 drivers/vfio/pci/virtio/main.c
> >   create mode 100644 include/linux/virtio_pci_admin.h
> > 
> 
> Hi Michael and Alex,
> 
> It seems that we are done with all the last notes here.
> 
> Michael,
> Based on Alex's note here [1] "the preferred merge approach would be that
> virtio maintainers take patches 1-6 and provide a branch or tag I can merge
> to bring 7-9 in through the vfio tree"
> 
> Can that please be done to proceed here ?

Hmm ok. Next week-ish, too busy this week.


> [1] https://patchwork.kernel.org/project/kvm/patch/20231205170623.197877-9-yishaih@nvidia.com/
> 
> Thanks,
> Yishai



Return-Path: <kvm+bounces-4511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F1F8133BB
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 15:59:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32AD6283135
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 14:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E6E5B5BC;
	Thu, 14 Dec 2023 14:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XYLmaO+r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAABABD
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 06:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702565951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1RLGe2L9X5Mr31nnAm9zgeYUzia+cx8yyVuWMarvBic=;
	b=XYLmaO+rPuRERS74niWHeU8fMuoIC0Lk8K72A+TqN7v+9tq8oKhLQMQPdGjhN4P0a2xMnl
	TmYu4/ot16GIsMJGd253RCW5YEdCioaCprgxPXACm3m89DyIlHmLyt1KvWK6mJ9+OQcQsL
	9/WTCJ5fbC57izqRcHBUydQZlSi2PMA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-frYUfwguOnG8o8Kfw3745w-1; Thu, 14 Dec 2023 09:59:08 -0500
X-MC-Unique: frYUfwguOnG8o8Kfw3745w-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7b6fc463798so831321239f.3
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 06:59:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702565948; x=1703170748;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1RLGe2L9X5Mr31nnAm9zgeYUzia+cx8yyVuWMarvBic=;
        b=NjsApaOlVlqcJiMvutJFH4KoGqj/iScMtOCu3bYXlPqRkpXh8P8zTAqWaHWTRdI+l1
         Au8hZor9jMHgPVTU/jNgownwruUz+GQB9XIeyi7mh55Ps5zBCQEpnYpg4fRhHJ7kCRLY
         BpPTF595ehlDDhEbvlc1bJZIONLXg7mlj/NYVYDjV5tBkxrL9tK5LisukQuBqkD58jZk
         PFc7qiNjEjdJZdxDNTmwhE4MW19WammUrz1ywPMHfaMRn3s/nw55yzTvxOEDe+izbFuI
         cCgAs4oII8rcoYNbNMlkEPXA9fOQUbta/M6veGNG3jgGkfc2ulxJ/HDgFdEcKmeWrGJ3
         BH2Q==
X-Gm-Message-State: AOJu0Yy0/lsPhAuR6eez0Bwb6nn/NueeV2/aJdZa/d5WXaB16nuS6ilB
	HaTafWjOCYwTuuMGOKKVutv2crTgmiSeGc8ox2DVqlLeww4NrMB6ARLaXCjGlPrke3ULhgDLNEz
	et3YuCc1DDFgt
X-Received: by 2002:a6b:f009:0:b0:7b4:28f8:15bf with SMTP id w9-20020a6bf009000000b007b428f815bfmr12307542ioc.31.1702565947658;
        Thu, 14 Dec 2023 06:59:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFbyAkggAWBbMXyUieCNYPA1mTiegP4hsTpomTs9qhK+tzWrCgwcP8YTtEv5oNfnATzPT5zbA==
X-Received: by 2002:a6b:f009:0:b0:7b4:28f8:15bf with SMTP id w9-20020a6bf009000000b007b428f815bfmr12307517ioc.31.1702565947300;
        Thu, 14 Dec 2023 06:59:07 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id v3-20020a023843000000b00466b43f6b54sm3423834jae.156.2023.12.14.06.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 06:59:06 -0800 (PST)
Date: Thu, 14 Dec 2023 07:59:05 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, <jasowang@redhat.com>,
 <jgg@nvidia.com>, <kvm@vger.kernel.org>,
 <virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
 <feliu@nvidia.com>, <jiri@nvidia.com>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>, <leonro@nvidia.com>,
 <maorg@nvidia.com>
Subject: Re: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231214075905.59a4a3ba.alex.williamson@redhat.com>
In-Reply-To: <37bcb2f0-a83d-4806-809c-ec5d004ddb20@nvidia.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
	<20231207102820.74820-10-yishaih@nvidia.com>
	<20231214013642-mutt-send-email-mst@kernel.org>
	<ea0cdfc9-35f4-4cc1-b0de-aaef0bebeb51@nvidia.com>
	<20231214041515-mutt-send-email-mst@kernel.org>
	<37bcb2f0-a83d-4806-809c-ec5d004ddb20@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 Dec 2023 11:37:10 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 14/12/2023 11:19, Michael S. Tsirkin wrote:
> > On Thu, Dec 14, 2023 at 11:03:49AM +0200, Yishai Hadas wrote:  
> >> On 14/12/2023 8:38, Michael S. Tsirkin wrote:  
> >>> On Thu, Dec 07, 2023 at 12:28:20PM +0200, Yishai Hadas wrote:  
> >>>> Introduce a vfio driver over virtio devices to support the legacy
> >>>> interface functionality for VFs.
> >>>>
> >>>> Background, from the virtio spec [1].
> >>>> --------------------------------------------------------------------
> >>>> In some systems, there is a need to support a virtio legacy driver with
> >>>> a device that does not directly support the legacy interface. In such
> >>>> scenarios, a group owner device can provide the legacy interface
> >>>> functionality for the group member devices. The driver of the owner
> >>>> device can then access the legacy interface of a member device on behalf
> >>>> of the legacy member device driver.
> >>>>
> >>>> For example, with the SR-IOV group type, group members (VFs) can not
> >>>> present the legacy interface in an I/O BAR in BAR0 as expected by the
> >>>> legacy pci driver. If the legacy driver is running inside a virtual
> >>>> machine, the hypervisor executing the virtual machine can present a
> >>>> virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
> >>>> legacy driver accesses to this I/O BAR and forwards them to the group
> >>>> owner device (PF) using group administration commands.
> >>>> --------------------------------------------------------------------
> >>>>
> >>>> Specifically, this driver adds support for a virtio-net VF to be exposed
> >>>> as a transitional device to a guest driver and allows the legacy IO BAR
> >>>> functionality on top.
> >>>>
> >>>> This allows a VM which uses a legacy virtio-net driver in the guest to
> >>>> work transparently over a VF which its driver in the host is that new
> >>>> driver.
> >>>>
> >>>> The driver can be extended easily to support some other types of virtio
> >>>> devices (e.g virtio-blk), by adding in a few places the specific type
> >>>> properties as was done for virtio-net.
> >>>>
> >>>> For now, only the virtio-net use case was tested and as such we introduce
> >>>> the support only for such a device.
> >>>>
> >>>> Practically,
> >>>> Upon probing a VF for a virtio-net device, in case its PF supports
> >>>> legacy access over the virtio admin commands and the VF doesn't have BAR
> >>>> 0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
> >>>> transitional device with I/O BAR in BAR 0.
> >>>>
> >>>> The existence of the simulated I/O bar is reported later on by
> >>>> overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
> >>>> exposes itself as a transitional device by overwriting some properties
> >>>> upon reading its config space.
> >>>>
> >>>> Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
> >>>> guest may use it via read/write calls according to the virtio
> >>>> specification.
> >>>>
> >>>> Any read/write towards the control parts of the BAR will be captured by
> >>>> the new driver and will be translated into admin commands towards the
> >>>> device.
> >>>>
> >>>> Any data path read/write access (i.e. virtio driver notifications) will
> >>>> be forwarded to the physical BAR which its properties were supplied by
> >>>> the admin command VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the
> >>>> probing/init flow.
> >>>>
> >>>> With that code in place a legacy driver in the guest has the look and
> >>>> feel as if having a transitional device with legacy support for both its
> >>>> control and data path flows.
> >>>>
> >>>> [1]
> >>>> https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
> >>>>
> >>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> >>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >>>> ---
> >>>>    MAINTAINERS                      |   7 +
> >>>>    drivers/vfio/pci/Kconfig         |   2 +
> >>>>    drivers/vfio/pci/Makefile        |   2 +
> >>>>    drivers/vfio/pci/virtio/Kconfig  |  16 +
> >>>>    drivers/vfio/pci/virtio/Makefile |   4 +
> >>>>    drivers/vfio/pci/virtio/main.c   | 567 +++++++++++++++++++++++++++++++
> >>>>    6 files changed, 598 insertions(+)
> >>>>    create mode 100644 drivers/vfio/pci/virtio/Kconfig
> >>>>    create mode 100644 drivers/vfio/pci/virtio/Makefile
> >>>>    create mode 100644 drivers/vfio/pci/virtio/main.c
> >>>>
> >>>> diff --git a/MAINTAINERS b/MAINTAINERS
> >>>> index 012df8ccf34e..b246b769092d 100644
> >>>> --- a/MAINTAINERS
> >>>> +++ b/MAINTAINERS
> >>>> @@ -22872,6 +22872,13 @@ L:	kvm@vger.kernel.org
> >>>>    S:	Maintained
> >>>>    F:	drivers/vfio/pci/mlx5/
> >>>> +VFIO VIRTIO PCI DRIVER
> >>>> +M:	Yishai Hadas <yishaih@nvidia.com>
> >>>> +L:	kvm@vger.kernel.org
> >>>> +L:	virtualization@lists.linux-foundation.org
> >>>> +S:	Maintained
> >>>> +F:	drivers/vfio/pci/virtio
> >>>> +
> >>>>    VFIO PCI DEVICE SPECIFIC DRIVERS
> >>>>    R:	Jason Gunthorpe <jgg@nvidia.com>
> >>>>    R:	Yishai Hadas <yishaih@nvidia.com>
> >>>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> >>>> index 8125e5f37832..18c397df566d 100644
> >>>> --- a/drivers/vfio/pci/Kconfig
> >>>> +++ b/drivers/vfio/pci/Kconfig
> >>>> @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
> >>>>    source "drivers/vfio/pci/pds/Kconfig"
> >>>> +source "drivers/vfio/pci/virtio/Kconfig"
> >>>> +
> >>>>    endmenu
> >>>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> >>>> index 45167be462d8..046139a4eca5 100644
> >>>> --- a/drivers/vfio/pci/Makefile
> >>>> +++ b/drivers/vfio/pci/Makefile
> >>>> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
> >>>>    obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
> >>>>    obj-$(CONFIG_PDS_VFIO_PCI) += pds/
> >>>> +
> >>>> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
> >>>> diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
> >>>> new file mode 100644
> >>>> index 000000000000..3a6707639220
> >>>> --- /dev/null
> >>>> +++ b/drivers/vfio/pci/virtio/Kconfig
> >>>> @@ -0,0 +1,16 @@
> >>>> +# SPDX-License-Identifier: GPL-2.0-only
> >>>> +config VIRTIO_VFIO_PCI
> >>>> +        tristate "VFIO support for VIRTIO NET PCI devices"
> >>>> +        depends on VIRTIO_PCI
> >>>> +        select VFIO_PCI_CORE
> >>>> +        help
> >>>> +          This provides support for exposing VIRTIO NET VF devices which support
> >>>> +          legacy IO access, using the VFIO framework that can work with a legacy
> >>>> +          virtio driver in the guest.
> >>>> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
> >>>> +          not indicate I/O Space.
> >>>> +          As of that this driver emulated I/O BAR in software to let a VF be
> >>>> +          seen as a transitional device in the guest and let it work with
> >>>> +          a legacy driver.
> >>>> +
> >>>> +          If you don't know what to do here, say N.  
> >>>
> >>> BTW shouldn't this driver be limited to X86? Things like lack of memory
> >>> barriers will make legacy virtio racy on e.g. ARM will they not?
> >>> And endian-ness will be broken on PPC ...
> >>>  
> >>
> >> OK, if so, we can come with the below extra code.
> >> Makes sense ?
> >>
> >> I'll squash it as part of V8 to the relevant patch.
> >>
> >> diff --git a/drivers/virtio/virtio_pci_modern.c
> >> b/drivers/virtio/virtio_pci_modern.c
> >> index 37a0035f8381..b652e91b9df4 100644
> >> --- a/drivers/virtio/virtio_pci_modern.c
> >> +++ b/drivers/virtio/virtio_pci_modern.c
> >> @@ -794,6 +794,9 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
> >> *pdev)
> >>          struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> >>          struct virtio_pci_device *vp_dev;
> >>
> >> +#ifndef CONFIG_X86
> >> +       return false;
> >> +#endif
> >>          if (!virtio_dev)
> >>                  return false;
> >>
> >> Yishai  
> > 
> > Isn't there going to be a bunch more dead code that compiler won't be
> > able to elide?
> >   
> 
> On my setup the compiler didn't complain about dead-code (I simulated it 
> by using ifdef CONFIG_X86 return false).
> 
> However, if we suspect that some compiler might complain, we can come 
> with the below instead.
> 
> Do you prefer that ?
> 
> index 37a0035f8381..53e29824d404 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -782,6 +782,7 @@ static void vp_modern_destroy_avq(struct 
> virtio_device *vdev)
>           BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
>           BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
> 
> +#ifdef CONFIG_X86
>   /*
>    * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
>    * commands are supported
> @@ -807,6 +808,12 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev 
> *pdev)
>                  return true;
>          return false;
>   }
> +#else
> +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
> +{
> +       return false;
> +}
> +#endif
>   EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);

Doesn't this also raise the question of the purpose of virtio-vfio-pci
on non-x86?  Without any other features it offers nothing over vfio-pci
and we should likely adjust the Kconfig for x86 or COMPILE_TEST.
Thanks,

Alex



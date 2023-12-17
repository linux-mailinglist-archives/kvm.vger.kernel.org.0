Return-Path: <kvm+bounces-4654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 48616815EF2
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 13:21:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3CBFB21CB0
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 12:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A154F32C84;
	Sun, 17 Dec 2023 12:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fFqHJja2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C9D321B6
	for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 12:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702815656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C7xBfSEC6aOxcgdV8HsWhdqCvIGW8g6rKuCu45+h/sg=;
	b=fFqHJja2erquYl/4QbswvjdnY4TGfVYi9Ki55oGY0jZHxhbog5eVd7CZwzgkx/qgAD3/lK
	P/UIS0+Me8Ok0rozDZecjzAOiJtogzPaUYMG523ph7dpuzCjcVc6nJVEVkfTy5CxwxHJBy
	/W8s0lKN4xLDvnYTdMyWdXTEPJ4TuMk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-mDW0GK5dM_uAeHm5uIP6QQ-1; Sun, 17 Dec 2023 07:20:54 -0500
X-MC-Unique: mDW0GK5dM_uAeHm5uIP6QQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3365d0bcef4so969780f8f.3
        for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 04:20:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702815653; x=1703420453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C7xBfSEC6aOxcgdV8HsWhdqCvIGW8g6rKuCu45+h/sg=;
        b=pJzpxowfMtoHqq3Xwmg/z6J8CiRvz/Uhi1f4uGegl+ldkETH95rpEzJWbhaGwMikLo
         MlXJJaYYCVgToqMXbu5H4B0014v9P2GLtc5FFaoopwLKVI31S5tcifrCQJYBeTNY2ZPp
         8wNErfqsz0nNgKT4TPitmyiQUIGQEVqLAlYO/0b/PLfOMLXJV0XMjFLn1+4fn/lN/2LV
         UyGQo6bF3Grt5u5NFzXAlgluuZwVHfPuP9fzXOHZl7V4fhSHK3lOD8jhWYrouPkt0zud
         5DEh0x7/8b9HVRWs6nwbt++UUXCCdryM+I54WwZlkmXbszG3S9792XRV+n2DcdLkD/Fu
         Bd0A==
X-Gm-Message-State: AOJu0YwmOYY8glGI/eQWpqSlR9+qwmvsqaor/lIC5aJQeNzhKMqV52I0
	5N9TCvJuIwSE+gIcmbbpgupEjuu9TO6UtMmG1WwH2/VQ2It4QaqxetrHK8ukKmX02AXxEIJJHqw
	WOS18+BSGltPj
X-Received: by 2002:a05:600c:3187:b0:40b:47dc:9b9d with SMTP id s7-20020a05600c318700b0040b47dc9b9dmr7197290wmp.40.1702815653406;
        Sun, 17 Dec 2023 04:20:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHIg4YrSa2nUy3p+q0jy/qwgxOgVejJckNydvLcyZF5z+9OiDQceHh4/iVWFXacV/fu7o502A==
X-Received: by 2002:a05:600c:3187:b0:40b:47dc:9b9d with SMTP id s7-20020a05600c318700b0040b47dc9b9dmr7197274wmp.40.1702815652959;
        Sun, 17 Dec 2023 04:20:52 -0800 (PST)
Received: from redhat.com ([2.52.20.16])
        by smtp.gmail.com with ESMTPSA id m27-20020a05600c3b1b00b0040b38292253sm39902045wms.30.2023.12.17.04.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Dec 2023 04:20:52 -0800 (PST)
Date: Sun, 17 Dec 2023 07:20:47 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, jasowang@redhat.com,
	jgg@nvidia.com, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, parav@nvidia.com,
	feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
	joao.m.martins@oracle.com, si-wei.liu@oracle.com, leonro@nvidia.com,
	maorg@nvidia.com
Subject: Re: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231217071404-mutt-send-email-mst@kernel.org>
References: <ea0cdfc9-35f4-4cc1-b0de-aaef0bebeb51@nvidia.com>
 <20231214041515-mutt-send-email-mst@kernel.org>
 <37bcb2f0-a83d-4806-809c-ec5d004ddb20@nvidia.com>
 <20231214075905.59a4a3ba.alex.williamson@redhat.com>
 <20231214100403-mutt-send-email-mst@kernel.org>
 <5b596e34-aac9-4786-8f13-4d85986803f0@nvidia.com>
 <20231214091501.4f843335.alex.williamson@redhat.com>
 <c838ad5a-e6ba-4b8e-a9a2-5d43da0ba5a4@nvidia.com>
 <20231214113649-mutt-send-email-mst@kernel.org>
 <efeff6cc-0df0-4572-8f05-2f16f4ac4b07@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efeff6cc-0df0-4572-8f05-2f16f4ac4b07@nvidia.com>

On Sun, Dec 17, 2023 at 12:39:48PM +0200, Yishai Hadas wrote:
> On 14/12/2023 18:40, Michael S. Tsirkin wrote:
> > On Thu, Dec 14, 2023 at 06:25:25PM +0200, Yishai Hadas wrote:
> > > On 14/12/2023 18:15, Alex Williamson wrote:
> > > > On Thu, 14 Dec 2023 18:03:30 +0200
> > > > Yishai Hadas <yishaih@nvidia.com> wrote:
> > > > 
> > > > > On 14/12/2023 17:05, Michael S. Tsirkin wrote:
> > > > > > On Thu, Dec 14, 2023 at 07:59:05AM -0700, Alex Williamson wrote:
> > > > > > > On Thu, 14 Dec 2023 11:37:10 +0200
> > > > > > > Yishai Hadas <yishaih@nvidia.com> wrote:
> > > > > > > > > > OK, if so, we can come with the below extra code.
> > > > > > > > > > Makes sense ?
> > > > > > > > > > 
> > > > > > > > > > I'll squash it as part of V8 to the relevant patch.
> > > > > > > > > > 
> > > > > > > > > > diff --git a/drivers/virtio/virtio_pci_modern.c
> > > > > > > > > > b/drivers/virtio/virtio_pci_modern.c
> > > > > > > > > > index 37a0035f8381..b652e91b9df4 100644
> > > > > > > > > > --- a/drivers/virtio/virtio_pci_modern.c
> > > > > > > > > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > > > > > > > > @@ -794,6 +794,9 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
> > > > > > > > > > *pdev)
> > > > > > > > > >             struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> > > > > > > > > >             struct virtio_pci_device *vp_dev;
> > > > > > > > > > 
> > > > > > > > > > +#ifndef CONFIG_X86
> > > > > > > > > > +       return false;
> > > > > > > > > > +#endif
> > > > > > > > > >             if (!virtio_dev)
> > > > > > > > > >                     return false;
> > > > > > > > > > 
> > > > > > > > > > Yishai
> > > > > > > > > 
> > > > > > > > > Isn't there going to be a bunch more dead code that compiler won't be
> > > > > > > > > able to elide?
> > > > > > > > 
> > > > > > > > On my setup the compiler didn't complain about dead-code (I simulated it
> > > > > > > > by using ifdef CONFIG_X86 return false).
> > > > > > > > 
> > > > > > > > However, if we suspect that some compiler might complain, we can come
> > > > > > > > with the below instead.
> > > > > > > > 
> > > > > > > > Do you prefer that ?
> > > > > > > > 
> > > > > > > > index 37a0035f8381..53e29824d404 100644
> > > > > > > > --- a/drivers/virtio/virtio_pci_modern.c
> > > > > > > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > > > > > > @@ -782,6 +782,7 @@ static void vp_modern_destroy_avq(struct
> > > > > > > > virtio_device *vdev)
> > > > > > > >              BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
> > > > > > > >              BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
> > > > > > > > 
> > > > > > > > +#ifdef CONFIG_X86
> > > > > > > >      /*
> > > > > > > >       * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
> > > > > > > >       * commands are supported
> > > > > > > > @@ -807,6 +808,12 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
> > > > > > > > *pdev)
> > > > > > > >                     return true;
> > > > > > > >             return false;
> > > > > > > >      }
> > > > > > > > +#else
> > > > > > > > +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
> > > > > > > > +{
> > > > > > > > +       return false;
> > > > > > > > +}
> > > > > > > > +#endif
> > > > > > > >      EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);
> > > > > > > 
> > > > > > > Doesn't this also raise the question of the purpose of virtio-vfio-pci
> > > > > > > on non-x86?  Without any other features it offers nothing over vfio-pci
> > > > > > > and we should likely adjust the Kconfig for x86 or COMPILE_TEST.
> > > > > > > Thanks,
> > > > > > > 
> > > > > > > Alex
> > > > > > 
> > > > > > Kconfig dependency is what I had in mind, yes. The X86 specific code in
> > > > > > virtio_pci_modern.c can be moved to a separate file then use makefile
> > > > > > tricks to skip it on other platforms.
> > > > > 
> > > > > The next feature for that driver will be the live migration support over
> > > > > virtio, once the specification which is WIP those day will be accepted.
> > > > > 
> > > > > The migration functionality is not X86 dependent and doesn't have the
> > > > > legacy virtio driver limitations that enforced us to run only on X86.
> > > > > 
> > > > > So, by that time we may need to enable in VFIO the loading of
> > > > > virtio-vfio-pci driver and put back the ifdef X86 inside VIRTIO, only on
> > > > > the legacy IO API, as I did already in V8.
> > > > > 
> > > > > So using a KCONFIG solution in VFIO is a short term one, which will be
> > > > > reverted just later on.
> > > > 
> > > > I understand the intent, but I don't think that justifies building a
> > > > driver that serves no purpose in the interim.  IF and when migration
> > > > support becomes a reality, it's trivial to update the depends line.
> > > > 
> > > 
> > > OK, so I'll add a KCONFIG dependency on X86 as you suggested as part of V9
> > > inside VFIO.
> > > 
> > > > > In addition, the virtio_pci_admin_has_legacy_io() API can be used in the
> > > > > future not only by VFIO, this was one of the reasons to put it inside
> > > > > VIRTIO.
> > > > 
> > > > Maybe this should be governed by a new Kconfig option which would be
> > > > selected by drivers like this.  Thanks,
> > > > 
> > > 
> > > We can still keep the simple ifdef X86 inside VIRTIO for future users/usage
> > > which is not only VFIO.
> > > 
> > > Michael,
> > > Can that work for you ?
> > > 
> > > Yishai
> > > 
> > > > Alex
> > > > 
> > 
> > I am not sure what is proposed exactly. General admin q infrastructure
> > can be kept as is. The legacy things however can never work outside X86.
> > Best way to limit it to x86 is to move it to a separate file and
> > only build that on X86. This way the only ifdef we need is where
> > we set the flags to enable legacy commands.
> > 
> > 
> 
> In VFIO we already agreed to add a dependency on X86 [1] as Alex asked.
> 
> As VIRTIO should be ready for other clients and be self contained, I thought
> to keep things simple and just return false from
> virtio_pci_admin_has_legacy_io() in non X86 systems as was sent in V8.
> 
> However, we can go with your approach as well and compile out all the legacy
> IO stuff in non X86 systems by moving its code to a separate file (i.e.
> virtio_pci_admin_legacy_io.c) and control this file upon the Makefile. In
> addition, you suggested to control the 'supported_cmds' by an ifdef. This
> will let the device know that we don't support legacy IO as well on non X86
> systems.
> 
> Please be aware that the above approach requires another ifdef on the H file
> which exposes the 6 exported symbols and some further changes inside virtio
> as of making vp_modern_admin_cmd_exec() non static as now we move the legacy
> IO stuff to another C file, etc.
> 
> Please see below how [2] it will look like.
> 
> If you prefer that, so OK, it will be part of V9.
> Please let me know.
> 
> 
> [1] diff --git a/drivers/vfio/pci/virtio/Kconfig
> b/drivers/vfio/pci/virtio/Kconfig
> index 050473b0e5df..a3e5d8ea22a0 100644
> --- a/drivers/vfio/pci/virtio/Kconfig
> +++ b/drivers/vfio/pci/virtio/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config VIRTIO_VFIO_PCI
>          tristate "VFIO support for VIRTIO NET PCI devices"
> -        depends on VIRTIO_PCI
> +        depends on X86 && VIRTIO_PCI
>          select VFIO_PCI_CORE
>          help
>            This provides support for exposing VIRTIO NET VF devices which
> support
> 
> [2] diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
> index 8e98d24917cc..a73358bb4ebb 100644
> --- a/drivers/virtio/Makefile
> +++ b/drivers/virtio/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
>  obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
>  virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
>  virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
> +virtio_pci-$(CONFIG_X86) += virtio_pci_admin_legacy_io.o
>  obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
>  obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
>  obj-$(CONFIG_VIRTIO_VDPA) += virtio_vdpa.o
> diff --git a/drivers/virtio/virtio_pci_common.h
> b/drivers/virtio/virtio_pci_common.h
> index af676b3b9907..9963e5d0e881 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -158,4 +158,14 @@ void virtio_pci_modern_remove(struct virtio_pci_device
> *);
> 
>  struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
> 
> +#define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
> +       (BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
> +        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
> +        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
> +        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
> +        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
> +


I'd add something like:

#ifdef CONFIG_X86
#define VIRTIO_ADMIN_CMD_BITMAP VIRTIO_LEGACY_ADMIN_CMD_BITMAP
#else
#define VIRTIO_ADMIN_CMD_BITMAP 0
#endif

Add a comment explaining why, please.


> +int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
> +                            struct virtio_admin_cmd *cmd);
> +
>  #endif
> diff --git a/drivers/virtio/virtio_pci_modern.c
> b/drivers/virtio/virtio_pci_modern.c
> index 53e29824d404..defb6282e1d7 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -75,8 +75,8 @@ static int virtqueue_exec_admin_cmd(struct
> virtio_pci_admin_vq *admin_vq,
>         return 0;
>  }
> 
> -static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
> -                                   struct virtio_admin_cmd *cmd)
> +int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
> +                            struct virtio_admin_cmd *cmd)
>  {
>         struct scatterlist *sgs[VIRTIO_AVQ_SGS_MAX], hdr, stat;
>         struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> @@ -172,6 +172,9 @@ static void virtio_pci_admin_cmd_list_init(struct
> virtio_device *virtio_dev)
>         if (ret)
>                 goto end;
> 
> +#ifndef CONFIG_X86
> +       *data &= ~(cpu_to_le64(VIRTIO_LEGACY_ADMIN_CMD_BITMAP));
> +#endif

Then here we don't need an ifdef just use VIRTIO_ADMIN_CMD_BITMAP.

>         sg_init_one(&data_sg, data, sizeof(*data));
>         cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
>         cmd.data_sg = &data_sg;
> @@ -775,257 +778,6 @@ static void vp_modern_destroy_avq(struct virtio_device
> *vdev)
>         vp_dev->del_vq(&vp_dev->admin_vq.info);
>  }
> 
> -#define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
> -       (BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
> -        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
> -        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
> -        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
> -        BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
> -
> -#ifdef CONFIG_X86
> -/*
> - * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
> - * commands are supported
> - * @dev: VF pci_dev
> - *
> - * Returns true on success.
> - */
> -bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
> -{
> -       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> -       struct virtio_pci_device *vp_dev;
> -
> -       if (!virtio_dev)
> -               return false;
> -
> -       if (!virtio_has_feature(virtio_dev, VIRTIO_F_ADMIN_VQ))
> -               return false;
> 
> 
> <other deletion to the new file>
> <other deletion to the new file>
> ..
> ..
> 
> diff --git a/drivers/virtio/virtio_pci_admin_legacy_io.c
> b/drivers/virtio/virtio_pci_admin_legacy_io.c
> new file mode 100644
> index 000000000000..c48eaaa7c086
> --- /dev/null
> +++ b/drivers/virtio/virtio_pci_admin_legacy_io.c
> @@ -0,0 +1,244 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include "virtio_pci_common.h"
> +
> +/*
> + * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
> + * commands are supported
> + * @dev: VF pci_dev
> + *
> + * Returns true on success.
> + */
> +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
> +{
> +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +       struct virtio_pci_device *vp_dev;
> +
> +       if (!virtio_dev)
> +               return false;
> +
> +       if (!virtio_has_feature(virtio_dev, VIRTIO_F_ADMIN_VQ))
> +               return false;
> +
> +       vp_dev = to_vp_device(virtio_dev);
> +
> +       if ((vp_dev->admin_vq.supported_cmds &
> VIRTIO_LEGACY_ADMIN_CMD_BITMAP) ==
> +               VIRTIO_LEGACY_ADMIN_CMD_BITMAP)
> +               return true;
> +       return false;
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);
> 
> 
> <other legacy IO code>
> <other legacy IO code>
> ...
> ...
> 
> 
> diff --git a/include/linux/virtio_pci_admin.h
> b/include/linux/virtio_pci_admin.h
> index 446ced8cb050..0c9c1f336d3f 100644
> --- a/include/linux/virtio_pci_admin.h
> +++ b/include/linux/virtio_pci_admin.h
> @@ -5,6 +5,7 @@
>  #include <linux/types.h>
>  #include <linux/pci.h>
> 
> +#ifdef CONFIG_X86
>  bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev);
>  int virtio_pci_admin_legacy_common_io_write(struct pci_dev *pdev, u8
> offset,
>                                             u8 size, u8 *buf);
> @@ -17,5 +18,6 @@ int virtio_pci_admin_legacy_device_io_read(struct pci_dev
> *pdev, u8 offset,
>  int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
>                                            u8 req_bar_flags, u8 *bar,
>                                            u64 *bar_offset);
> +#endif
> 
> Yishai



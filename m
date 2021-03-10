Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1004B33682A
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 00:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbhCJXxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 18:53:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233935AbhCJXxB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Mar 2021 18:53:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615420380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=udIsXj2/Qdllfep2hpZOoBYR1JgZNIiBljI7t2gtaus=;
        b=K7h4eNH2idypft6YeTHHj1G4XOnQ9e3CeZcsfyfove7a3BBYKQJgj8SOVrveRyrVXnVM1J
        ZZFNGq9eDvIamGzt/OmUta5250tiHH3EKTFlRIzB0gURiszUVP6RHY8xknEdRFkp13BsTC
        1nhZvoE+kGFZZdu7f/GErQ22r/yzWes=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-4nh9pexWOE2OPyl2b5hzKQ-1; Wed, 10 Mar 2021 18:52:55 -0500
X-MC-Unique: 4nh9pexWOE2OPyl2b5hzKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FC791074644;
        Wed, 10 Mar 2021 23:52:53 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A8955B6A8;
        Wed, 10 Mar 2021 23:52:48 +0000 (UTC)
Date:   Wed, 10 Mar 2021 16:52:47 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 00/10] Embed struct vfio_device in all sub-structures
Message-ID: <20210310165247.0f04b237@omen.home.shazbot.org>
In-Reply-To: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  9 Mar 2021 17:38:42 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:
> This series:
> 
> The main focus of this series is to make VFIO follow the normal kernel
> convention of structure embedding for structure inheritance instead of
> linking using a 'void *opaque'. Here we focus on moving the vfio_device to
> be a member of every struct vfio_XX_device that is linked by a
> vfio_add_group_dev().
> 
> In turn this allows 'struct vfio_device *' to be used everwhere, and the
> public API out of vfio.c can be cleaned to remove places using 'struct
> device *' and 'void *' as surrogates to refer to the device.
> 
> While this has the minor trade off of moving 'struct vfio_device' the
> clarity of the design is worth it. I can speak directly to this idea, as
> I've invested a fair amount of time carefully working backwards what all
> the type-erased APIs are supposed to be and it is certainly not trivial or
> intuitive.
> 
> When we get into mdev land things become even more inscrutable, and while
> I now have a pretty clear picture, it was hard to obtain. I think this
> agrees with the kernel style ideal of being explicit in typing and not
> sacrificing clarity to create opaque structs.
> 
> After this series the general rules are:
>  - Any vfio_XX_device * can be obtained at no cost from a vfio_device *
>    using container_of(), and the reverse is possible by &XXdev->vdev
> 
>    This is similar to how 'struct pci_device' and 'struct device' are
>    interrelated.
> 
>    This allows 'device_data' to be completely removed from the vfio.c API.
> 
>  - The drvdata for a struct device points at the vfio_XX_device that
>    belongs to the driver that was probed. drvdata is removed from the core
>    code, and only used as part of the implementation of the struct
>    device_driver.
> 
>  - The lifetime of vfio_XX_device and vfio_device are identical, they are
>    the same memory.
> 
>    This follows the existing model where vfio_del_group_dev() blocks until
>    all vfio_device_put()'s are completed. This in turn means the struct
>    device_driver remove() blocks, and thus under the driver_lock() a bound
>    driver must have a valid drvdata pointing at both vfio device
>    structs. A following series exploits this further.
> 
> Most vfio_XX_device structs have data that duplicates the 'struct
> device *dev' member of vfio_device, a following series removes that
> duplication too.
> 
> Jason
> 
> Jason Gunthorpe (10):
>   vfio: Simplify the lifetime logic for vfio_device
>   vfio: Split creation of a vfio_device into init and register ops
>   vfio/platform: Use vfio_init/register/unregister_group_dev
>   vfio/fsl-mc: Use vfio_init/register/unregister_group_dev
>   vfio/pci: Use vfio_init/register/unregister_group_dev
>   vfio/mdev: Use vfio_init/register/unregister_group_dev
>   vfio/mdev: Make to_mdev_device() into a static inline
>   vfio: Make vfio_device_ops pass a 'struct vfio_device *' instead of
>     'void *'
>   vfio/pci: Replace uses of vfio_device_data() with container_of
>   vfio: Remove device_data from the vfio bus driver API
> 
>  Documentation/driver-api/vfio.rst             |  48 ++--
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c             |  69 +++---
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h     |   1 +
>  drivers/vfio/mdev/mdev_private.h              |   5 +-
>  drivers/vfio/mdev/vfio_mdev.c                 |  57 +++--
>  drivers/vfio/pci/vfio_pci.c                   | 109 +++++----
>  drivers/vfio/pci/vfio_pci_private.h           |   1 +
>  drivers/vfio/platform/vfio_amba.c             |   8 +-
>  drivers/vfio/platform/vfio_platform.c         |  21 +-
>  drivers/vfio/platform/vfio_platform_common.c  |  56 ++---
>  drivers/vfio/platform/vfio_platform_private.h |   5 +-
>  drivers/vfio/vfio.c                           | 210 ++++++------------
>  include/linux/vfio.h                          |  37 +--
>  13 files changed, 299 insertions(+), 328 deletions(-)
> 

This looks great.  As Christoph noted, addressing those init vs
register races in the bus drivers don't seem too difficult or out of
scope for this series.  Thanks,

Alex


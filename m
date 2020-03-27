Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F66219603A
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 22:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgC0VLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 17:11:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:51364 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727352AbgC0VLv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 17:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585343510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pU369DtG86jsIbWwBlHqilmriJZlc4uAPV60W3fwUQ0=;
        b=Lb9nY48JAN9sf5a4eI/yi7f8wSJWOQ+UzlekKSZlrwbFXSNOIsSG9/KlkbsFcq9HAJcesu
        jM0t5n0tXbiDHisyLxmigTIhzycxNBQIWyXH8V0poYP/2lnLPSLymCKUqkL1v7+pZFOTYx
        qvVZ2u+fP86eTPl6tyZaNRH3eiyFFWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-w4oL4hpQNGqRf3z8J3_npA-1; Fri, 27 Mar 2020 17:11:44 -0400
X-MC-Unique: w4oL4hpQNGqRf3z8J3_npA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A1D3800D53;
        Fri, 27 Mar 2020 21:11:43 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8C901001B2D;
        Fri, 27 Mar 2020 21:11:42 +0000 (UTC)
Date:   Fri, 27 Mar 2020 15:11:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     kvm@vger.kernel.org, laurentiu.tudor@nxp.com,
        linux-arm-kernel@lists.infradead.org, bharatb.yadav@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] vfio/fsl-mc: VFIO support for FSL-MC devices
Message-ID: <20200327151142.79dd2554@w520.home>
In-Reply-To: <20200323171911.27178-1-diana.craciun@oss.nxp.com>
References: <20200323171911.27178-1-diana.craciun@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Mar 2020 19:19:02 +0200
Diana Craciun <diana.craciun@oss.nxp.com> wrote:

> DPAA2 (Data Path Acceleration Architecture) consists in
> mechanisms for processing Ethernet packets, queue management,
> accelerators, etc.
> 
> The Management Complex (mc) is a hardware entity that manages the DPAA2
> hardware resources. It provides an object-based abstraction for software
> drivers to use the DPAA2 hardware. The MC mediates operations such as
> create, discover, destroy of DPAA2 objects.
> The MC provides memory-mapped I/O command interfaces (MC portals) which
> DPAA2 software drivers use to operate on DPAA2 objects.
> 
> A DPRC is a container object that holds other types of DPAA2 objects.
> Each object in the DPRC is a Linux device and bound to a driver.
> The MC-bus driver is a platform driver (different from PCI or platform
> bus). The DPRC driver does runtime management of a bus instance. It
> performs the initial scan of the DPRC and handles changes in the DPRC
> configuration (adding/removing objects).
> 
> All objects inside a container share the same hardware isolation
> context, meaning that only an entire DPRC can be assigned to
> a virtual machine.
> When a container is assigned to a virtual machine, all the objects
> within that container are assigned to that virtual machine.
> The DPRC container assigned to the virtual machine is not allowed
> to change contents (add/remove objects) by the guest. The restriction
> is set by the host and enforced by the mc hardware.
> 
> The DPAA2 objects can be directly assigned to the guest. However
> the MC portals (the memory mapped command interface to the MC) need
> to be emulated because there are commands that configure the
> interrupts and the isolation IDs which are virtual in the guest.
> 
> Example:
> echo vfio-fsl-mc > /sys/bus/fsl-mc/devices/dprc.2/driver_override
> echo dprc.2 > /sys/bus/fsl-mc/drivers/vfio-fsl-mc/bind
> 
> The dprc.2 is bound to the VFIO driver and all the objects within
> dprc.2 are going to be bound to the VFIO driver.

What's the composition of the IOMMU group, does it start with the DPRC
and each of the objects within the container are added to the same
group as they're created?

For an alternative to the driver_override mechanism used in this series
of passing the override through various scan/create callbacks, you
might consider something like I did for PCI SR-IOV:

https://lore.kernel.org/lkml/158396395214.5601.11207416598267070486.stgit@gimli.home/

ie. using the bus notifier to setup the driver_override before driver
matching is done.  Thanks,

Alex

> More details about the DPAA2 objects can be found here:
> Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
> 
> The patches are dependent on some changes in the mc-bus (bus/fsl-mc)
> driver. The changes were needed in order to re-use code and to export
> some more functions that are needed by the VFIO driver.
> Currenlty the mc-bus patches are under review:
> https://www.spinics.net/lists/kernel/msg3447567.html
> 
> Bharat Bhushan (1):
>   vfio/fsl-mc: Add VFIO framework skeleton for fsl-mc devices
> 
> Diana Craciun (8):
>   vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc driver bind
>   vfio/fsl-mc: Implement VFIO_DEVICE_GET_INFO ioctl
>   vfio/fsl-mc: Implement VFIO_DEVICE_GET_REGION_INFO ioctl call
>   vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions
>   vfio/fsl-mc: Added lock support in preparation for interrupt handling
>   vfio/fsl-mc: Add irq infrastructure for fsl-mc devices
>   vfio/fsl-mc: trigger an interrupt via eventfd
>   vfio/fsl-mc: Add read/write support for fsl-mc devices
> 
>  MAINTAINERS                               |   6 +
>  drivers/vfio/Kconfig                      |   1 +
>  drivers/vfio/Makefile                     |   1 +
>  drivers/vfio/fsl-mc/Kconfig               |   9 +
>  drivers/vfio/fsl-mc/Makefile              |   4 +
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 660 ++++++++++++++++++++++
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 221 ++++++++
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  56 ++
>  include/uapi/linux/vfio.h                 |   1 +
>  9 files changed, 959 insertions(+)
>  create mode 100644 drivers/vfio/fsl-mc/Kconfig
>  create mode 100644 drivers/vfio/fsl-mc/Makefile
>  create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc.c
>  create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
>  create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> 


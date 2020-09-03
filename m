Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADA725C223
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 16:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgICOEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 10:04:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39506 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728867AbgICN7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 09:59:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599141548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4d0hEtzj1O3cLEd0CxX1kXJFeAKPS5/bs25SNIlY4YA=;
        b=F/9U2oX/nvKfX+twN3dBLXJYBhgEiF5BorWfU83DDwra9V1LTfY7gyUAvC9aAE03ZYR4kV
        1PSyKtiug1x6bK9nKmRFy5psPxg+/sU8S2VkvJ+2xyeZIpDYVcKG2GKniP2g9rzS9y7kqB
        JlX7pu/9XmkNeVUYywZpisZXy8pW1VQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70--m16VAb4NcG2EptIAfNEgQ-1; Thu, 03 Sep 2020 09:40:16 -0400
X-MC-Unique: -m16VAb4NcG2EptIAfNEgQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04D2380046A;
        Thu,  3 Sep 2020 13:40:15 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 183D61C4;
        Thu,  3 Sep 2020 13:40:07 +0000 (UTC)
Subject: Re: [PATCH v4 00/10] vfio/fsl-mc: VFIO support for FSL-MC device
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ae46be70-82d3-6137-6169-beb4bf8ae707@redhat.com>
Date:   Thu, 3 Sep 2020 15:40:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 8/26/20 11:33 AM, Diana Craciun wrote:
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
> 
> More details about the DPAA2 objects can be found here:
> Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
> 
> The patches are dependent on some changes in the mc-bus (bus/fsl-mc)
> driver. The changes were needed in order to re-use code and to export
> some more functions that are needed by the VFIO driver.
> Currenlty the mc-bus patches are under review:
> https://www.spinics.net/lists/kernel/msg3639226.html
Could you share a branch with both series? This would help the review.

Thanks

Eric
> 
> v3 --> v4
> - use bus provided functions to tear down the DPRC
> - added reset support
> 
> v2 --> v3
> - There is no need to align region size to page size
> - read/write implemented for all DPAA2 objects
> - review fixes
> 
> v1 --> v2
> - Fixed the container reset, a new flag added to the firmware command
> - Implement a bus notifier for setting driver_override
> 
> 
> Bharat Bhushan (1):
>   vfio/fsl-mc: Add VFIO framework skeleton for fsl-mc devices
> 
> Diana Craciun (9):
>   vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc driver bind
>   vfio/fsl-mc: Implement VFIO_DEVICE_GET_INFO ioctl
>   vfio/fsl-mc: Implement VFIO_DEVICE_GET_REGION_INFO ioctl call
>   vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions
>   vfio/fsl-mc: Added lock support in preparation for interrupt handling
>   vfio/fsl-mc: Add irq infrastructure for fsl-mc devices
>   vfio/fsl-mc: trigger an interrupt via eventfd
>   vfio/fsl-mc: Add read/write support for fsl-mc devices
>   vfio/fsl-mc: Add support for device reset
> 
>  MAINTAINERS                               |   6 +
>  drivers/vfio/Kconfig                      |   1 +
>  drivers/vfio/Makefile                     |   1 +
>  drivers/vfio/fsl-mc/Kconfig               |   9 +
>  drivers/vfio/fsl-mc/Makefile              |   4 +
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 684 ++++++++++++++++++++++
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 221 +++++++
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  56 ++
>  include/uapi/linux/vfio.h                 |   1 +
>  9 files changed, 983 insertions(+)
>  create mode 100644 drivers/vfio/fsl-mc/Kconfig
>  create mode 100644 drivers/vfio/fsl-mc/Makefile
>  create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc.c
>  create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
>  create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> 


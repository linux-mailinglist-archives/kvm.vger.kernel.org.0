Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDB7300CF1
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 20:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbhAVTv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 14:51:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730619AbhAVT0n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 14:26:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611343515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4t6fl3YyvtaW5Q6QVtUYAUfL/EREDZcuyCxL7CtIlEE=;
        b=PmHUShNPdgsh92U0DSJooKIffv/7xYfX4AyCN+LOF1PtkIkzryMxZhMKMcEjOyOuqTor3q
        2/4wyUtvLSNz91c42ROHjQ6SoatK4f2xSRkcT4YVKLGfFXN2QbNmMBDrTU6vHhGlVonyz6
        08dhr58TuxGh3UgKlz/nZmw103rk2bs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-_Rbew4IYNOOxyLYMTYM1UA-1; Fri, 22 Jan 2021 14:25:08 -0500
X-MC-Unique: _Rbew4IYNOOxyLYMTYM1UA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 071EA107ACE6;
        Fri, 22 Jan 2021 19:25:06 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 049055D746;
        Fri, 22 Jan 2021 19:25:04 +0000 (UTC)
Date:   Fri, 22 Jan 2021 12:25:03 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jgg@nvidia.com>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210122122503.4e492b96@omen.home.shazbot.org>
In-Reply-To: <20210117181534.65724-1-mgurtovoy@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 17 Jan 2021 18:15:31 +0000
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> Hi Alex and Cornelia,
> 
> This series split the vfio_pci driver into 2 parts: pci driver and a
> subsystem driver that will also be library of code. The pci driver,
> vfio_pci.ko will be used as before and it will bind to the subsystem
> driver vfio_pci_core.ko to register to the VFIO subsystem. This patchset
> if fully backward compatible. This is a typical Linux subsystem
> framework behaviour. This framework can be also adopted by vfio_mdev
> devices as we'll see in the below sketch.
> 
> This series is coming to solve the issues that were raised in the
> previous attempt for extending vfio-pci for vendor specific
> functionality: https://lkml.org/lkml/2020/5/17/376 by Yan Zhao.

Is the only significant difference here the fact that function
declarations remain in a private header?  Otherwise it seems to
have all the risks of previous attempts, ie. exported symbols with a
lot of implicit behavior shared between them.

> This solution is also deterministic in a sense that when a user will
> bind to a vendor specific vfio-pci driver, it will get all the special
> goodies of the HW.

That determinism really comes after the point where we were concerned
about deterministic behavior, ie. how does a user know which driver to
use for which device.  It seems with the aux bus approach we're letting
the default host driver expose sub-functions for assignment, similar to
mdev, but nothing about this code split requires such an approach.  As
noted in 2/3, IGD support could be a separate module, but that's a
direct assignment driver, so then the user must decide to use vfio-pci
or igd-vfio-pci, depending on which features they want.

> This subsystem framework will also ease on adding vendor specific
> functionality to VFIO devices in the future by allowing another module
> to provide the pci_driver that can setup number of details before
> registering to VFIO subsystem (such as inject its own operations).

Which leads us directly back to the problem that we then have numerous
drivers that a user might choose for a given device.
 
> Below we can see the proposed changes (this patchset only deals with
> VFIO_PCI subsystem but it can easily be extended to VFIO_MDEV subsystem
> as well):
> 
> +----------------------------------------------------------------------+
> |                                                                      |
> |                                VFIO                                  |
> |                                                                      |
> +----------------------------------------------------------------------+
> 
> +--------------------------------+    +--------------------------------+
> |                                |    |                                |
> |          VFIO_PCI_CORE         |    |          VFIO_MDEV_CORE        |
> |                                |    |                                |
> +--------------------------------+    +--------------------------------+
> 
> +---------------+ +--------------+    +---------------+ +--------------+
> |               | |              |    |               | |              |
> |               | |              |    |               | |              |
> | VFIO_PCI      | | MLX5_VFIO_PCI|    | VFIO_MDEV     | |MLX5_VFIO_MDEV|
> |               | |              |    |               | |              |
> |               | |              |    |               | |              |
> +---------------+ +--------------+    +---------------+ +--------------+
> 
> First 2 patches introduce the above changes for vfio_pci and
> vfio_pci_core.
> 
> Patch (3/3) introduces a new mlx5 vfio-pci module that registers to VFIO
> subsystem using vfio_pci_core. It also registers to Auxiliary bus for
> binding to mlx5_core that is the parent of mlx5-vfio-pci devices. This
> will allow extending mlx5-vfio-pci devices with HW specific features
> such as Live Migration (mlx5_core patches are not part of this series
> that comes for proposing the changes need for the vfio pci subsystem).
> 
> These devices will be seen on the Auxiliary bus as:
> mlx5_core.vfio_pci.2048 -> ../../../devices/pci0000:00/0000:00:02.0/0000:05:00.0/0000:06:00.0/0000:07:00.0/mlx5_core.vfio_pci.2048
> mlx5_core.vfio_pci.2304 -> ../../../devices/pci0000:00/0000:00:02.0/0000:05:00.0/0000:06:00.0/0000:07:00.1/mlx5_core.vfio_pci.2304
> 
> 2048 represents BDF 08:00.0 and 2304 represents BDF 09:00.0 in decimal

And what are devices 08:00.0 and 09:00.0 on the host?  We can only see
from above that they're children of a PCI device.

> view. In this manner, the administrator will be able to locate the
> correct vfio-pci module it should bind the desired BDF to (by finding
> the pointer to the module according to the Auxiliary driver of that
> BDF).

Sorry, clear as mud.  Are we really expecting users to decode a decimal
aux bus ID to a PCI BDF and how is the ID standardized among aux bus
devices?
 
> In this way, we'll use the HW vendor driver core to manage the lifecycle
> of these devices. This is reasonable since only the vendor driver knows
> exactly about the status on its internal state and the capabilities of
> its acceleratots, for example.

But mdev provides that too, or the vendor could write their own vfio
bus driver for the device, this doesn't really justify or delve deep
enough to show examples beyond "TODO" remarks for a vendor driver
actually interacting with vfio-pci-core in an extensible way.  One of
the concerns of previous efforts was that it's trying to directly
expose vfio-pci's implementation as an API for vendor drivers, I don't
really see that anything has changed in that respect here.  Thanks,

Alex

> TODOs:
> 1. For this RFC we still haven't cleaned all vendor specific stuff that
>    were merged in the past into vfio_pci (such as VFIO_PCI_IG and
>    VFIO_PCI_NVLINK2).
> 2. Create subsystem module for VFIO_MDEV. This can be used for vendor
>    specific scalable functions for example (SFs).
> 3. Add Live migration functionality for mlx5 SNAP devices
>    (NVMe/Virtio-BLK).
> 4. Add Live migration functionality for mlx5 VFs
> 5. Add the needed functionality for mlx5_core
> 
> I would like to thank the great team that was involved in this
> development, design and internal review:
> Oren, Liran, Jason, Leon, Aviad, Shahaf, Gary, Artem, Kirti, Neo, Andy
> and others.
> 
> This series applies cleanly on top of kernel 5.11-rc2+ commit 2ff90100ace8:
> "Merge tag 'hwmon-for-v5.11-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging"
> from Linus.
> 
> Note: Live migration for MLX5 SNAP devices is WIP and will be the first
>       example for adding vendor extension to vfio-pci devices. As the
>       changes to the subsystem must be defined as a pre-condition for
>       this work, we've decided to split the submission for now.
> 
> Max Gurtovoy (3):
>   vfio-pci: rename vfio_pci.c to vfio_pci_core.c
>   vfio-pci: introduce vfio_pci_core subsystem driver
>   mlx5-vfio-pci: add new vfio_pci driver for mlx5 devices
> 
>  drivers/vfio/pci/Kconfig            |   22 +-
>  drivers/vfio/pci/Makefile           |   16 +-
>  drivers/vfio/pci/mlx5_vfio_pci.c    |  253 +++
>  drivers/vfio/pci/vfio_pci.c         | 2386 +--------------------------
>  drivers/vfio/pci/vfio_pci_core.c    | 2311 ++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_private.h |   21 +
>  include/linux/mlx5/vfio_pci.h       |   36 +
>  7 files changed, 2734 insertions(+), 2311 deletions(-)
>  create mode 100644 drivers/vfio/pci/mlx5_vfio_pci.c
>  create mode 100644 drivers/vfio/pci/vfio_pci_core.c
>  create mode 100644 include/linux/mlx5/vfio_pci.h
> 


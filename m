Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A113155E6
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 00:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfEFWDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 18:03:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfEFWDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 18:03:14 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4A6B781E0F;
        Mon,  6 May 2019 22:03:14 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6C5C611C9;
        Mon,  6 May 2019 22:03:13 +0000 (UTC)
Date:   Mon, 6 May 2019 16:03:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, cjia@nvidia.com
Subject: Re: [PATCHv2 00/10] vfio/mdev: Improve vfio/mdev core module
Message-ID: <20190506160313.41c189f0@x1.home>
In-Reply-To: <20190430224937.57156-1-parav@mellanox.com>
References: <20190430224937.57156-1-parav@mellanox.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 06 May 2019 22:03:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Apr 2019 17:49:27 -0500
Parav Pandit <parav@mellanox.com> wrote:

> As we would like to use mdev subsystem for wider use case as
> discussed in [1], [2] apart from an offline discussion.
> This use case is also discussed with wider forum in [4] in track
> 'Lightweight NIC HW functions for container offload use cases'.
> 
> This series is prep-work and improves vfio/mdev module in following ways.
> 
> Patch-1 Fixes releasing parent dev reference during error unwinding
>         mdev parent registration.
> Patch-2 Simplifies mdev device for unused kref.
> Patch-3 Drops redundant extern prefix of exported symbols.
> Patch-4 Returns right error code from vendor driver.
> Patch-5 Fixes to use right sysfs remove sequence.
> Patch-6 Fixes removing all child devices if one of them fails.
> Patch-7 Remove unnecessary inline
> Patch-8 Improve the mdev create/remove sequence to match Linux
>         bus, device model
> Patch-9 Avoid recreating remove file on stale device to
>         eliminate call trace
> Patch-10 Fix race conditions of create/remove with parent removal
> This is improved version than using srcu as srcu can take
> seconds to minutes.
> 
> This series is tested using
> (a) mtty with VM using vfio_mdev driver for positive tests and
> device removal while device in use by VM using vfio_mdev driver
> 
> (b) mlx5 core driver using RFC patches [3] and internal patches.
> Internal patches are large and cannot be combined with this
> prep-work patches. It will posted once prep-work completes.
> 
> [1] https://www.spinics.net/lists/netdev/msg556978.html
> [2] https://lkml.org/lkml/2019/3/7/696
> [3] https://lkml.org/lkml/2019/3/8/819
> [4] https://netdevconf.org/0x13/session.html?workshop-hardware-offload
> 
> ---
> Changelog:
> ---
> v1->v2:
>  - Addressed comments from Alex
>  - Rebased
>  - Inserted the device checking loop in Patch-6 as original code
>  - Added patch 7 to 10
>  - Added fixes for race condition in create/remove with parent removal
>    Patch-10 uses simplified refcount and completion, instead of srcu
>    which might take seconds to minutes on busy system.
>  - Added fix for device create/remove sequence to match
>    Linux device, bus model
> v0->v1:
>  - Dropped device placement on bus sequence patch for this series
>  - Addressed below comments from Alex, Kirti, Maxim.
>  - Added Review-by tag for already reviewed patches.
>  - Dropped incorrect patch of put_device().
>  - Corrected Fixes commit tag for sysfs remove sequence fix
>  - Split last 8th patch to smaller refactor and fixes patch
>  - Following coding style commenting format
>  - Fixed accidental delete of mutex_lock in mdev_unregister_device
>  - Renamed remove helped to mdev_device_remove_common().
>  - Rebased for uuid/guid change
> 
> Parav Pandit (10):
>   vfio/mdev: Avoid release parent reference during error path
>   vfio/mdev: Removed unused kref
>   vfio/mdev: Drop redundant extern for exported symbols
>   vfio/mdev: Avoid masking error code to EBUSY
>   vfio/mdev: Follow correct remove sequence
>   vfio/mdev: Fix aborting mdev child device removal if one fails
>   vfio/mdev: Avoid inline get and put parent helpers
>   vfio/mdev: Improve the create/remove sequence
>   vfio/mdev: Avoid creating sysfs remove file on stale device removal
>   vfio/mdev: Synchronize device create/remove with parent removal
> 
>  drivers/vfio/mdev/mdev_core.c    | 162 +++++++++++++------------------
>  drivers/vfio/mdev/mdev_private.h |   9 +-
>  drivers/vfio/mdev/mdev_sysfs.c   |   8 +-
>  include/linux/mdev.h             |  21 ++--
>  4 files changed, 89 insertions(+), 111 deletions(-)
> 

Hi Parav,

I applied 1-7 to the vfio next branch for v5.2 since these are mostly
previously reviewed or trivial.  I'm not ruling out the rest for v5.2
as bug fixes yet, but they require a bit more to digest and hopefully
we'll get some feedback from others as well.  Thanks,

Alex

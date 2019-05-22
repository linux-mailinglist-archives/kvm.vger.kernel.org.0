Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A28260CC
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 11:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfEVJyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 05:54:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728406AbfEVJyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 05:54:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B44D20276;
        Wed, 22 May 2019 09:54:38 +0000 (UTC)
Received: from gondolin (dhcp-192-213.str.redhat.com [10.33.192.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 619E65DDF6;
        Wed, 22 May 2019 09:54:37 +0000 (UTC)
Date:   Wed, 22 May 2019 11:54:35 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com, cjia@nvidia.com
Subject: Re: [PATCHv3 1/3] vfio/mdev: Improve the create/remove sequence
Message-ID: <20190522115435.677b457c.cohuck@redhat.com>
In-Reply-To: <20190516233034.16407-2-parav@mellanox.com>
References: <20190516233034.16407-1-parav@mellanox.com>
        <20190516233034.16407-2-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 22 May 2019 09:54:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 May 2019 18:30:32 -0500
Parav Pandit <parav@mellanox.com> wrote:

> This patch addresses below two issues and prepares the code to address
> 3rd issue listed below.
> 
> 1. mdev device is placed on the mdev bus before it is created in the
> vendor driver. Once a device is placed on the mdev bus without creating
> its supporting underlying vendor device, mdev driver's probe() gets triggered.
> However there isn't a stable mdev available to work on.
> 
>    create_store()
>      mdev_create_device()
>        device_register()
>           ...
>          vfio_mdev_probe()
>         [...]
>         parent->ops->create()
>           vfio_ap_mdev_create()
>             mdev_set_drvdata(mdev, matrix_mdev);
>             /* Valid pointer set above */
> 
> Due to this way of initialization, mdev driver who wants to use the mdev,
> doesn't have a valid mdev to work on.
> 
> 2. Current creation sequence is,
>    parent->ops_create()
>    groups_register()
> 
> Remove sequence is,
>    parent->ops->remove()
>    groups_unregister()
> 
> However, remove sequence should be exact mirror of creation sequence.
> Once this is achieved, all users of the mdev will be terminated first
> before removing underlying vendor device.
> (Follow standard linux driver model).
> At that point vendor's remove() ops shouldn't fail because taking the
> device off the bus should terminate any usage.
> 
> 3. When remove operation fails, mdev sysfs removal attempts to add the
> file back on already removed device. Following call trace [1] is observed.
> 
> [1] call trace:
> kernel: WARNING: CPU: 2 PID: 9348 at fs/sysfs/file.c:327 sysfs_create_file_ns+0x7f/0x90
> kernel: CPU: 2 PID: 9348 Comm: bash Kdump: loaded Not tainted 5.1.0-rc6-vdevbus+ #6
> kernel: Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b 08/09/2016
> kernel: RIP: 0010:sysfs_create_file_ns+0x7f/0x90
> kernel: Call Trace:
> kernel: remove_store+0xdc/0x100 [mdev]
> kernel: kernfs_fop_write+0x113/0x1a0
> kernel: vfs_write+0xad/0x1b0
> kernel: ksys_write+0x5a/0xe0
> kernel: do_syscall_64+0x5a/0x210
> kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Therefore, mdev core is improved in following ways.
> 
> 1. Split the device registration/deregistration sequence so that some
> things can be done between initialization of the device and
> hooking it up to the bus respectively after deregistering it
> from the bus but before giving up our final reference.
> In particular, this means invoking the ->create and ->remove
> callbacks in those new windows. This gives the vendor driver an
> initialized mdev device to work with during creation.
> At the same time, a bus driver who wish to bind to mdev driver also

s/who wish/that wishes/

> gets initialized mdev device.
> 
> This follows standard Linux kernel bus and device model.
> 
> 2. During remove flow, first remove the device from the bus. This
> ensures that any bus specific devices are removed.
> Once device is taken off the mdev bus, invoke remove() of mdev
> from the vendor driver.
> 
> 3. The driver core device model provides way to register and auto
> unregister the device sysfs attribute groups at dev->groups.
> Make use of dev->groups to let core create the groups and eliminate
> code to avoid explicit groups creation and removal.
> 
> To ensure, that new sequence is solid, a below stack dump of a
> process is taken who attempts to remove the device while device is in
> use by vfio driver and user application.
> This stack dump validates that vfio driver guards against such device
> removal when device is in use.
> 
>  cat /proc/21962/stack
> [<0>] vfio_del_group_dev+0x216/0x3c0 [vfio]
> [<0>] mdev_remove+0x21/0x40 [mdev]
> [<0>] device_release_driver_internal+0xe8/0x1b0
> [<0>] bus_remove_device+0xf9/0x170
> [<0>] device_del+0x168/0x350
> [<0>] mdev_device_remove_common+0x1d/0x50 [mdev]
> [<0>] mdev_device_remove+0x8c/0xd0 [mdev]
> [<0>] remove_store+0x71/0x90 [mdev]
> [<0>] kernfs_fop_write+0x113/0x1a0
> [<0>] vfs_write+0xad/0x1b0
> [<0>] ksys_write+0x5a/0xe0
> [<0>] do_syscall_64+0x5a/0x210
> [<0>] entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [<0>] 0xffffffffffffffff
> 
> This prepares the code to eliminate calling device_create_file() in
> subsquent patch.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 94 +++++++++-----------------------
>  drivers/vfio/mdev/mdev_private.h |  2 +-
>  drivers/vfio/mdev/mdev_sysfs.c   |  2 +-
>  3 files changed, 27 insertions(+), 71 deletions(-)

Personally, I'd do a more compact patch description, but there's
nothing really wrong with yours, either.

Patch also seems sane to me, although I'd probably have merged this and
the next patch. But no reason to quibble further.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B74B33703
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfFCRnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 13:43:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbfFCRnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 13:43:39 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1732530C5857;
        Mon,  3 Jun 2019 17:43:39 +0000 (UTC)
Received: from gondolin (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B618C1001DE4;
        Mon,  3 Jun 2019 17:43:32 +0000 (UTC)
Date:   Mon, 3 Jun 2019 19:43:28 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com, cjia@nvidia.com
Subject: Re: [PATCHv5 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Message-ID: <20190603194328.135205a4.cohuck@redhat.com>
In-Reply-To: <20190530091928.49724-4-parav@mellanox.com>
References: <20190530091928.49724-1-parav@mellanox.com>
        <20190530091928.49724-4-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 03 Jun 2019 17:43:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 May 2019 04:19:28 -0500
Parav Pandit <parav@mellanox.com> wrote:

> In following sequences, child devices created while removing mdev parent
> device can be left out, or it may lead to race of removing half
> initialized child mdev devices.
> 
> issue-1:
> --------
>        cpu-0                         cpu-1
>        -----                         -----
>                                   mdev_unregister_device()
>                                     device_for_each_child()
>                                       mdev_device_remove_cb()
>                                         mdev_device_remove()
> create_store()
>   mdev_device_create()                   [...]
>     device_add()
>                                   parent_remove_sysfs_files()
> 
> /* BUG: device added by cpu-0
>  * whose parent is getting removed
>  * and it won't process this mdev.
>  */
> 
> issue-2:
> --------
> Below crash is observed when user initiated remove is in progress
> and mdev_unregister_driver() completes parent unregistration.
> 
>        cpu-0                         cpu-1
>        -----                         -----
> remove_store()
>    mdev_device_remove()
>    active = false;
>                                   mdev_unregister_device()
>                                   parent device removed.
>    [...]
>    parents->ops->remove()
>  /*
>   * BUG: Accessing invalid parent.
>   */
> 
> This is similar race like create() racing with mdev_unregister_device().
> 
> BUG: unable to handle kernel paging request at ffffffffc0585668
> PGD e8f618067 P4D e8f618067 PUD e8f61a067 PMD 85adca067 PTE 0
> Oops: 0000 [#1] SMP PTI
> CPU: 41 PID: 37403 Comm: bash Kdump: loaded Not tainted 5.1.0-rc6-vdevbus+ #6
> Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b 08/09/2016
> RIP: 0010:mdev_device_remove+0xfa/0x140 [mdev]
> Call Trace:
>  remove_store+0x71/0x90 [mdev]
>  kernfs_fop_write+0x113/0x1a0
>  vfs_write+0xad/0x1b0
>  ksys_write+0x5a/0xe0
>  do_syscall_64+0x5a/0x210
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Therefore, mdev core is improved as below to overcome above issues.
> 
> Wait for any ongoing mdev create() and remove() to finish before
> unregistering parent device.
> This continues to allow multiple create and remove to progress in
> parallel for different mdev devices as most common case.
> At the same time guard parent removal while parent is being access by

s/access/accessed/

> create() and remove callbacks.

s/remove/remove()/ (just to make it consistent)

> create()/remove() and unregister_device() are synchronized by the rwsem.
> 
> Refactor device removal code to mdev_device_remove_common() to avoid
> acquiring unreg_sem of the parent.
> 
> Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 60 ++++++++++++++++++++++++--------
>  drivers/vfio/mdev/mdev_private.h |  2 ++
>  2 files changed, 48 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 0bef0cae1d4b..62be131a22a1 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c

(...)

> @@ -265,6 +294,12 @@ int mdev_device_create(struct kobject *kobj,
>  
>  	mdev->parent = parent;
> 

/* Check if parent unregistration has started */
 
> +	ret = down_read_trylock(&parent->unreg_sem);
> +	if (!ret) {

Maybe write this as

if (!down_read_trylock(&parent->unreg_sem)) {

> +		ret = -ENODEV;
> +		goto mdev_fail;

I think this leaves a stale mdev device around (and on the mdev list).
Normally, giving up the last reference to the mdev will call the
release callback (which will remove it from the mdev list and free it),
but the device is not yet initialized here. I think you either have to
remove it from the list and free the memory manually, or move trying to
get the lock just before calling ->create().

> +	}
> +
>  	device_initialize(&mdev->dev);
>  	mdev->dev.parent  = dev;
>  	mdev->dev.bus     = &mdev_bus_type;

(...)

> @@ -329,18 +365,14 @@ int mdev_device_remove(struct device *dev)
>  	mdev->active = false;
>  	mutex_unlock(&mdev_list_lock);
>  
> -	type = to_mdev_type(mdev->type_kobj);
> -	mdev_remove_sysfs_files(dev, type);
> -	device_del(&mdev->dev);
>  	parent = mdev->parent;
> -	ret = parent->ops->remove(mdev);
> -	if (ret)
> -		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
> -
> -	/* Balances with device_initialize() */
> -	put_device(&mdev->dev);
> -	mdev_put_parent(parent);
> +	/* Check if parent unregistration has started */
> +	ret = down_read_trylock(&parent->unreg_sem);
> +	if (!ret)
> +		return -ENODEV;

Maybe also condense this one to

if (!down_read_trylock(&parent->unreg_sem))
	return -ENODEV;

>  
> +	mdev_device_remove_common(mdev);
> +	up_read(&parent->unreg_sem);
>  	return 0;
>  }
>  

Otherwise, looks good to me.

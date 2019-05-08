Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B247117EE6
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbfEHRKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:10:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55294 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbfEHRKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:10:08 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C192081E06;
        Wed,  8 May 2019 17:10:07 +0000 (UTC)
Received: from gondolin (ovpn-204-161.brq.redhat.com [10.40.204.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 478BA62676;
        Wed,  8 May 2019 17:10:01 +0000 (UTC)
Date:   Wed, 8 May 2019 19:09:57 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com, cjia@nvidia.com
Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove sequence
Message-ID: <20190508190957.673dd948.cohuck@redhat.com>
In-Reply-To: <20190430224937.57156-9-parav@mellanox.com>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-9-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 08 May 2019 17:10:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Apr 2019 17:49:35 -0500
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
> Due to this way of initialization, mdev driver who want to use the mdev,
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
> At that point vendor's remove() ops shouldn't failed because device is
> taken off the bus that should terminate the users.
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
> 1. Before placing mdev devices on the bus, perform vendor drivers
> creation which supports the mdev creation.
> This ensures that mdev specific all necessary fields are initialized
> before a given mdev can be accessed by bus driver.
> This follows standard Linux kernel bus and device model similar to other
> widely used PCI bus.
> 
> 2. During remove flow, first remove the device from the bus. This
> ensures that any bus specific devices and data is cleared.
> Once device is taken of the mdev bus, perform remove() of mdev from the
> vendor driver.
> 
> 3. Linux core device model provides way to register and auto unregister
> the device sysfs attribute groups at dev->groups.
> Make use of this groups to let core create the groups and simplify code
> to avoid explicit groups creation and removal.
> 
> A below stack dump of a mdev device remove process also ensures that
> vfio driver guards against device removal already in use.
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

I'm afraid I have a bit of a problem following this explanation, so let
me try to summarize what the patch does to make sure that I understand
it correctly:

- Add the sysfs groups to device->groups so that the driver core deals
  with proper registration/deregistration.
- Split the device registration/deregistration sequence so that some
  things can be done between initialization of the device and hooking
  it up to the infrastructure respectively after deregistering it from
  the infrastructure but before giving up our final reference. In
  particular, this means invoking the ->create and ->remove callback in
  those new windows. This gives the vendor driver an initialized mdev
  device to work with during creation.
- Don't allow ->remove to fail, as the device is already removed from
  the infrastructure at that point in time.

> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 94 +++++++++-----------------------
>  drivers/vfio/mdev/mdev_private.h |  2 +-
>  drivers/vfio/mdev/mdev_sysfs.c   |  2 +-
>  3 files changed, 27 insertions(+), 71 deletions(-)

(...)

> @@ -310,41 +265,43 @@ int mdev_device_create(struct kobject *kobj,
>  
>  	mdev->parent = parent;
>  
> +	device_initialize(&mdev->dev);
>  	mdev->dev.parent  = dev;
>  	mdev->dev.bus     = &mdev_bus_type;
>  	mdev->dev.release = mdev_device_release;
>  	dev_set_name(&mdev->dev, "%pUl", uuid);
> +	mdev->dev.groups = parent->ops->mdev_attr_groups;

I like that, that makes things much easier.

> +	mdev->type_kobj = kobj;
>  
> -	ret = device_register(&mdev->dev);
> -	if (ret) {
> -		put_device(&mdev->dev);
> -		goto mdev_fail;
> -	}
> +	ret = parent->ops->create(kobj, mdev);
> +	if (ret)
> +		goto ops_create_fail;
>  
> -	ret = mdev_device_create_ops(kobj, mdev);
> +	ret = device_add(&mdev->dev);
>  	if (ret)
> -		goto create_fail;
> +		goto add_fail;
>  
>  	ret = mdev_create_sysfs_files(&mdev->dev, type);
> -	if (ret) {
> -		mdev_device_remove_ops(mdev, true);
> -		goto create_fail;
> -	}
> +	if (ret)
> +		goto sysfs_fail;
>  
> -	mdev->type_kobj = kobj;
>  	mdev->active = true;
>  	dev_dbg(&mdev->dev, "MDEV: created\n");
>  
>  	return 0;
>  
> -create_fail:
> -	device_unregister(&mdev->dev);
> +sysfs_fail:
> +	device_del(&mdev->dev);
> +add_fail:
> +	parent->ops->remove(mdev);
> +ops_create_fail:
> +	put_device(&mdev->dev);
>  mdev_fail:
>  	mdev_put_parent(parent);
>  	return ret;
>  }
>  
> -int mdev_device_remove(struct device *dev, bool force_remove)
> +int mdev_device_remove(struct device *dev)
>  {
>  	struct mdev_device *mdev, *tmp;
>  	struct mdev_parent *parent;
> @@ -373,16 +330,15 @@ int mdev_device_remove(struct device *dev, bool force_remove)
>  	mutex_unlock(&mdev_list_lock);
>  
>  	type = to_mdev_type(mdev->type_kobj);
> +	mdev_remove_sysfs_files(dev, type);
> +	device_del(&mdev->dev);
>  	parent = mdev->parent;
> +	ret = parent->ops->remove(mdev);
> +	if (ret)
> +		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);

I think carrying on with removal regardless of the return code of the
->remove callback makes sense, as it simply matches usual practice.
However, are we sure that every vendor driver works well with that? I
think it should, as removal from bus unregistration (vs. from the sysfs
file) was always something it could not veto, but have you looked at
the individual drivers?

>  
> -	ret = mdev_device_remove_ops(mdev, force_remove);
> -	if (ret) {
> -		mdev->active = true;
> -		return ret;
> -	}
> -
> -	mdev_remove_sysfs_files(dev, type);
> -	device_unregister(dev);
> +	/* Balances with device_initialize() */
> +	put_device(&mdev->dev);
>  	mdev_put_parent(parent);
>  
>  	return 0;

I think that looks sane in general, but the commit message might
benefit from tweaking.

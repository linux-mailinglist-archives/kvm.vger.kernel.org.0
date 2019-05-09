Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B4B183E3
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 04:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfEICqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 22:46:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfEICqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 22:46:07 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7AC5A8665F;
        Thu,  9 May 2019 02:46:06 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3A2710027BB;
        Thu,  9 May 2019 02:46:05 +0000 (UTC)
Date:   Wed, 8 May 2019 20:46:05 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, cjia@nvidia.com
Subject: Re: [PATCHv2 10/10] vfio/mdev: Synchronize device create/remove
 with parent removal
Message-ID: <20190508204605.17294a7d@x1.home>
In-Reply-To: <20190430224937.57156-11-parav@mellanox.com>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-11-parav@mellanox.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 09 May 2019 02:46:06 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Apr 2019 17:49:37 -0500
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
> unregistering parent device using refcount and completion.
> This continues to allow multiple create and remove to progress in
> parallel for different mdev devices as most common case.
> At the same time guard parent removal while parent is being access by
> create() and remove callbacks.
> 
> Code is simplified from kref to use refcount as unregister_device() has
> to wait anyway for all create/remove to finish.
> 
> While removing mdev devices during parent unregistration, there isn't
> need to acquire refcount of parent device, hence code is restructured
> using mdev_device_remove_common() to avoid it.

Did you consider calling parent_remove_sysfs_files() earlier in
mdev_unregister_device() and adding srcu support to know there are no
in-flight callers of the create path?  I think that would address
issue-1.

Issue-2 suggests a bug in our handling of the parent device krefs, the
parent object should exist until all child devices which have a kref
reference to the parent are removed, but clearly
mdev_unregister_device() is not blocking for that to occur allowing the
parent driver .remove callback to finish.  This seems similar to
vfio_del_group_dev() where we need to block a vfio bus driver from
removing a device until it becomes unused, could a similar solution
with a wait_queue and wait_woken be used here?

I'm not immediately sold on the idea that removing a kref to solve this
problem is a good thing, it seems odd to me that mdevs don't hold a
reference to the parent throughout their life with this change, and the
remove_store path branch to exit if we find we're racing the parent
remove path is rather ugly.  BTW, why is the sanitization loop in
mdev_device_remove() still here, wasn't that fixed by the previous two
patches?  Thanks,

Alex

> Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 86 ++++++++++++++++++++------------
>  drivers/vfio/mdev/mdev_private.h |  6 ++-
>  2 files changed, 60 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 2b98da2ee361..a5da24d662f4 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -78,34 +78,41 @@ static struct mdev_parent *__find_parent_device(struct device *dev)
>  	return NULL;
>  }
>  
> -static void mdev_release_parent(struct kref *kref)
> +static bool mdev_try_get_parent(struct mdev_parent *parent)
>  {
> -	struct mdev_parent *parent = container_of(kref, struct mdev_parent,
> -						  ref);
> -	struct device *dev = parent->dev;
> -
> -	kfree(parent);
> -	put_device(dev);
> +	if (parent)
> +		return refcount_inc_not_zero(&parent->refcount);
> +	return false;
>  }
>  
> -static struct mdev_parent *mdev_get_parent(struct mdev_parent *parent)
> +static void mdev_put_parent(struct mdev_parent *parent)
>  {
> -	if (parent)
> -		kref_get(&parent->ref);
> -
> -	return parent;
> +	if (parent && refcount_dec_and_test(&parent->refcount))
> +		complete(&parent->unreg_completion);
>  }
>  
> -static void mdev_put_parent(struct mdev_parent *parent)
> +static void mdev_device_remove_common(struct mdev_device *mdev)
>  {
> -	if (parent)
> -		kref_put(&parent->ref, mdev_release_parent);
> +	struct mdev_parent *parent;
> +	struct mdev_type *type;
> +	int ret;
> +
> +	type = to_mdev_type(mdev->type_kobj);
> +	mdev_remove_sysfs_files(&mdev->dev, type);
> +	device_del(&mdev->dev);
> +	parent = mdev->parent;
> +	ret = parent->ops->remove(mdev);
> +	if (ret)
> +		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
> +
> +	/* Balances with device_initialize() */
> +	put_device(&mdev->dev);
>  }
>  
>  static int mdev_device_remove_cb(struct device *dev, void *data)
>  {
>  	if (dev_is_mdev(dev))
> -		mdev_device_remove(dev);
> +		mdev_device_remove_common(to_mdev_device(dev));
>  
>  	return 0;
>  }
> @@ -147,7 +154,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>  		goto add_dev_err;
>  	}
>  
> -	kref_init(&parent->ref);
> +	refcount_set(&parent->refcount, 1);
> +	init_completion(&parent->unreg_completion);
>  
>  	parent->dev = dev;
>  	parent->ops = ops;
> @@ -206,14 +214,27 @@ void mdev_unregister_device(struct device *dev)
>  	dev_info(dev, "MDEV: Unregistering\n");
>  
>  	list_del(&parent->next);
> +	mutex_unlock(&parent_list_lock);
> +
> +	/* Release the initial reference so that new create cannot start */
> +	mdev_put_parent(parent);
> +
> +	/*
> +	 * Wait for all the create and remove references to drop.
> +	 */
> +	wait_for_completion(&parent->unreg_completion);
> +
> +	/*
> +	 * New references cannot be taken and all users are done
> +	 * using the parent. So it is safe to unregister parent.
> +	 */
>  	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
>  
>  	device_for_each_child(dev, NULL, mdev_device_remove_cb);
>  
>  	parent_remove_sysfs_files(parent);
> -
> -	mutex_unlock(&parent_list_lock);
> -	mdev_put_parent(parent);
> +	kfree(parent);
> +	put_device(dev);
>  }
>  EXPORT_SYMBOL(mdev_unregister_device);
>  
> @@ -237,10 +258,11 @@ int mdev_device_create(struct kobject *kobj,
>  	struct mdev_parent *parent;
>  	struct mdev_type *type = to_mdev_type(kobj);
>  
> -	parent = mdev_get_parent(type->parent);
> -	if (!parent)
> +	if (!mdev_try_get_parent(type->parent))
>  		return -EINVAL;
>  
> +	parent = type->parent;
> +
>  	mutex_lock(&mdev_list_lock);
>  
>  	/* Check for duplicate */
> @@ -287,6 +309,7 @@ int mdev_device_create(struct kobject *kobj,
>  
>  	mdev->active = true;
>  	dev_dbg(&mdev->dev, "MDEV: created\n");
> +	mdev_put_parent(parent);
>  
>  	return 0;
>  
> @@ -306,7 +329,6 @@ int mdev_device_remove(struct device *dev)
>  	struct mdev_device *mdev, *tmp;
>  	struct mdev_parent *parent;
>  	struct mdev_type *type;
> -	int ret;
>  
>  	mdev = to_mdev_device(dev);
>  
> @@ -330,15 +352,17 @@ int mdev_device_remove(struct device *dev)
>  	mutex_unlock(&mdev_list_lock);
>  
>  	type = to_mdev_type(mdev->type_kobj);
> -	mdev_remove_sysfs_files(dev, type);
> -	device_del(&mdev->dev);
> -	parent = mdev->parent;
> -	ret = parent->ops->remove(mdev);
> -	if (ret)
> -		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
> +	if (!mdev_try_get_parent(type->parent)) {
> +		/*
> +		 * Parent unregistration have started.
> +		 * No need to remove here.
> +		 */
> +		mutex_unlock(&mdev_list_lock);
> +		return -ENODEV;
> +	}
>  
> -	/* Balances with device_initialize() */
> -	put_device(&mdev->dev);
> +	parent = mdev->parent;
> +	mdev_device_remove_common(mdev);
>  	mdev_put_parent(parent);
>  
>  	return 0;
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 067dc5d8c5de..781f111d66d2 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -19,7 +19,11 @@ void mdev_bus_unregister(void);
>  struct mdev_parent {
>  	struct device *dev;
>  	const struct mdev_parent_ops *ops;
> -	struct kref ref;
> +	/* Protects unregistration to wait until create/remove
> +	 * are completed.
> +	 */
> +	refcount_t refcount;
> +	struct completion unreg_completion;
>  	struct list_head next;
>  	struct kset *mdev_types_kset;
>  	struct list_head type_list;


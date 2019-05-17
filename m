Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499C321799
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 13:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfEQLWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 07:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728803AbfEQLWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 07:22:11 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A4541C09AD18;
        Fri, 17 May 2019 11:22:10 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68803173C5;
        Fri, 17 May 2019 11:22:09 +0000 (UTC)
Date:   Fri, 17 May 2019 13:22:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com, cjia@nvidia.com
Subject: Re: [PATCHv3 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Message-ID: <20190517132207.12d823f2.cohuck@redhat.com>
In-Reply-To: <20190516233034.16407-4-parav@mellanox.com>
References: <20190516233034.16407-1-parav@mellanox.com>
        <20190516233034.16407-4-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 17 May 2019 11:22:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 May 2019 18:30:34 -0500
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
> 
> Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 86 ++++++++++++++++++++------------
>  drivers/vfio/mdev/mdev_private.h |  6 ++-
>  2 files changed, 60 insertions(+), 32 deletions(-)

I'm still not quite happy with this patch. I think most of my dislike
comes from how you are using a member called 'refcount' vs. what I
believe a refcount actually is. See below.

> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 0bef0cae1d4b..ca33246c1dc3 100644
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

So far, this is "obtain a reference if the reference is not 0 (implying
the object is not ready to use) and notify waiters when the last
reference is dropped". This still looks idiomatic enough.

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

Initializing to 1 when creating is also fine.

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

The comment is confusing: We do drop one reference, but this does not
imply we're going to 0 (which would be the one thing that would block
creating new devices).

> +
> +	/*
> +	 * Wait for all the create and remove references to drop.
> +	 */
> +	wait_for_completion(&parent->unreg_completion);

It only reaches 0 after this wait.

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

If other calls are still running, the refcount won't be 0, and this
will succeed, even if we really want to get rid of the device.

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

Same here: Is there really a guarantee that the refcount is 0 when the
parent is going away?

> +		/*
> +		 * Parent unregistration have started.
> +		 * No need to remove here.
> +		 */
> +		mutex_unlock(&mdev_list_lock);

Btw., you already unlocked above.

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
> index 924ed2274941..55ebab0af7b0 100644
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

I think what's really needed is to split up the different needs and not
overload the 'refcount' concept.

- If we need to make sure that a reference to the parent is held so
  that the parent may not go away while still in use, we should
  continue to use the kref (in the idiomatic way it is used before this
  patch.)
- We need to protect against creation of new devices if the parent is
  going away. Maybe set a going_away marker in the parent structure for
  that so that creation bails out immediately? What happens if the
  creation has already started when parent removal kicks in, though?
  Do we need some child list locking and an indication whether a child
  is in progress of being registered/unregistered?
- We also need to protect against removal of devices while unregister
  is in progress (same mechanism as above?) The second issue you
  describe above should be fixed then if the children keep a reference
  of the parent.

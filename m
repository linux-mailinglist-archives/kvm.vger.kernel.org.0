Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA20023260
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 13:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732800AbfETL3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 07:29:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731297AbfETL3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 07:29:19 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 187B63082AC3;
        Mon, 20 May 2019 11:29:19 +0000 (UTC)
Received: from gondolin (ovpn-204-110.brq.redhat.com [10.40.204.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD3DE5D6A6;
        Mon, 20 May 2019 11:29:14 +0000 (UTC)
Date:   Mon, 20 May 2019 13:29:11 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: Re: [PATCHv3 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Message-ID: <20190520132911.4d56bfe5.cohuck@redhat.com>
In-Reply-To: <VI1PR0501MB227162B10E46947E7C4A1C83D10B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190516233034.16407-1-parav@mellanox.com>
        <20190516233034.16407-4-parav@mellanox.com>
        <20190517132207.12d823f2.cohuck@redhat.com>
        <VI1PR0501MB227162B10E46947E7C4A1C83D10B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 20 May 2019 11:29:19 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 May 2019 14:18:26 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > > @@ -206,14 +214,27 @@ void mdev_unregister_device(struct device *dev)
> > >  	dev_info(dev, "MDEV: Unregistering\n");
> > >
> > >  	list_del(&parent->next);
> > > +	mutex_unlock(&parent_list_lock);
> > > +
> > > +	/* Release the initial reference so that new create cannot start */
> > > +	mdev_put_parent(parent);  
> > 
> > The comment is confusing: We do drop one reference, but this does not
> > imply we're going to 0 (which would be the one thing that would block
> > creating new devices).
> >   
> Ok. How about below comment.
> /* Balance with initial reference init */

Well, 'release the initial reference' is fine; it's just the second
part that is confusing.

One thing that continues to irk me (and I'm sorry if I sound like a
broken record) is that you give up the initial reference and then
continue to use parent. For the more usual semantics of a reference
count, that would be a bug (as the structure would be freed if the
reference count dropped to zero), even though it is not a bug here.

> 
> > > +
> > > +	/*
> > > +	 * Wait for all the create and remove references to drop.
> > > +	 */
> > > +	wait_for_completion(&parent->unreg_completion);  
> > 
> > It only reaches 0 after this wait.
> >  
> Yes.
>  
> > > +
> > > +	/*
> > > +	 * New references cannot be taken and all users are done
> > > +	 * using the parent. So it is safe to unregister parent.
> > > +	 */
> > >  	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> > >
> > >  	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> > >
> > >  	parent_remove_sysfs_files(parent);
> > > -
> > > -	mutex_unlock(&parent_list_lock);
> > > -	mdev_put_parent(parent);
> > > +	kfree(parent);
> > > +	put_device(dev);
> > >  }
> > >  EXPORT_SYMBOL(mdev_unregister_device);
> > >
> > > @@ -237,10 +258,11 @@ int mdev_device_create(struct kobject *kobj,
> > >  	struct mdev_parent *parent;
> > >  	struct mdev_type *type = to_mdev_type(kobj);
> > >
> > > -	parent = mdev_get_parent(type->parent);
> > > -	if (!parent)
> > > +	if (!mdev_try_get_parent(type->parent))  
> > 
> > If other calls are still running, the refcount won't be 0, and this will succeed,
> > even if we really want to get rid of the device.
> >   
> Sure, if other calls are running, refcount won't be 0. Process creating them will eventually complete, and refcount will drop to zero.
> And new processes won't be able to start any more.
> So there is no differentiation between 'already in creation stage' and 'about to start' processes.

Does it really make sense to allow creation to start if the parent is
going away?

> 
> > >  		return -EINVAL;
> > >
> > > +	parent = type->parent;
> > > +
> > >  	mutex_lock(&mdev_list_lock);
> > >
> > >  	/* Check for duplicate */
> > > @@ -287,6 +309,7 @@ int mdev_device_create(struct kobject *kobj,
> > >
> > >  	mdev->active = true;
> > >  	dev_dbg(&mdev->dev, "MDEV: created\n");
> > > +	mdev_put_parent(parent);
> > >
> > >  	return 0;
> > >
> > > @@ -306,7 +329,6 @@ int mdev_device_remove(struct device *dev)
> > >  	struct mdev_device *mdev, *tmp;
> > >  	struct mdev_parent *parent;
> > >  	struct mdev_type *type;
> > > -	int ret;
> > >
> > >  	mdev = to_mdev_device(dev);
> > >
> > > @@ -330,15 +352,17 @@ int mdev_device_remove(struct device *dev)
> > >  	mutex_unlock(&mdev_list_lock);
> > >
> > >  	type = to_mdev_type(mdev->type_kobj);
> > > -	mdev_remove_sysfs_files(dev, type);
> > > -	device_del(&mdev->dev);
> > > -	parent = mdev->parent;
> > > -	ret = parent->ops->remove(mdev);
> > > -	if (ret)
> > > -		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
> > > +	if (!mdev_try_get_parent(type->parent)) {  
> > 
> > Same here: Is there really a guarantee that the refcount is 0 when the parent
> > is going away?  
> A WARN_ON after wait_for_completion or in freeing the parent is good to catch bugs.

I'd rather prefer to avoid having to add WARN_ONs :)

This looks like it is supposed to be an early exit. However, if some
other thread does any create or remove operation at the same time,
we'll still do the remove, and we still might have have a race window
(and this is getting really hard to follow in the code).

> 
> >   
> > > +		/*
> > > +		 * Parent unregistration have started.
> > > +		 * No need to remove here.
> > > +		 */
> > > +		mutex_unlock(&mdev_list_lock);  
> > 
> > Btw., you already unlocked above.
> >  
> You are right. This unlock is wrong. I will revise the patch.
>  
> > > +		return -ENODEV;
> > > +	}
> > >
> > > -	/* Balances with device_initialize() */
> > > -	put_device(&mdev->dev);
> > > +	parent = mdev->parent;
> > > +	mdev_device_remove_common(mdev);
> > >  	mdev_put_parent(parent);
> > >
> > >  	return 0;
> > > diff --git a/drivers/vfio/mdev/mdev_private.h
> > > b/drivers/vfio/mdev/mdev_private.h
> > > index 924ed2274941..55ebab0af7b0 100644
> > > --- a/drivers/vfio/mdev/mdev_private.h
> > > +++ b/drivers/vfio/mdev/mdev_private.h
> > > @@ -19,7 +19,11 @@ void mdev_bus_unregister(void);  struct  
> > mdev_parent  
> > > {
> > >  	struct device *dev;
> > >  	const struct mdev_parent_ops *ops;
> > > -	struct kref ref;
> > > +	/* Protects unregistration to wait until create/remove
> > > +	 * are completed.
> > > +	 */
> > > +	refcount_t refcount;
> > > +	struct completion unreg_completion;
> > >  	struct list_head next;
> > >  	struct kset *mdev_types_kset;
> > >  	struct list_head type_list;  
> > 
> > I think what's really needed is to split up the different needs and not
> > overload the 'refcount' concept.
> >   
> Refcount tells that how many active references are present for this parent device.
> Those active reference could be create/remove processes and mdev core itself.
> 
> So when parent unregisters, mdev module publishes that it is going away through this refcount.
> Hence new users cannot start.

But it does not actually do that -- if there are other create/remove
operations running, userspace can still trigger a new create/remove. If
it triggers enough create/remove processes, it can keep the parent
around (even though that really is a pathological case.)

> 
> > - If we need to make sure that a reference to the parent is held so
> >   that the parent may not go away while still in use, we should
> >   continue to use the kref (in the idiomatic way it is used before this
> >   patch.)
> > - We need to protect against creation of new devices if the parent is
> >   going away. Maybe set a going_away marker in the parent structure for
> >   that so that creation bails out immediately?   
> Such marker will help to not start new processes.
> So an additional marker can be added to improve mdev_try_get_parent().
> But I couldn't justify why differentiating those two users on time scale is desired.
> One reason could be that user continuously tries to create mdev and parent never gets a chance, to unregister?
> I guess, parent will run out mdev devices before this can happen.

They can also run remove tasks in parallel (see above).

> 
> Additionally a stop marker is needed (counter) to tell that all users are done accessing it.
> Both purposes are served using a refcount scheme.

Why not stop new create/remove tasks on remove, and do the final
cleanup asynchronously? I think a refcount is fine to track accesses,
but not to block new tasks.

> 
> > What happens if the
> >   creation has already started when parent removal kicks in, though?  
> That particular creation will succeed but newer cannot start, because mdev_put_parent() is done.
> 
> >   Do we need some child list locking and an indication whether a child
> >   is in progress of being registered/unregistered?
> > - We also need to protect against removal of devices while unregister
> >   is in progress (same mechanism as above?) The second issue you
> >   describe above should be fixed then if the children keep a reference
> >   of the parent.  
> Parent unregistration publishes that its going away first, so no new device removal from user can start.

I don't think that this actually works as intended (see above).

> Already on going removal by users anyway complete first.
> 
> Once all remove() users are done, parent is getting unregistered.

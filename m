Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDE224363
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 00:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfETWM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 18:12:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfETWM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 18:12:27 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 48E7885539;
        Mon, 20 May 2019 22:12:26 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD5E35D719;
        Mon, 20 May 2019 22:12:25 +0000 (UTC)
Date:   Mon, 20 May 2019 16:12:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: Re: [PATCHv3 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Message-ID: <20190520161225.5d7321e9@x1.home>
In-Reply-To: <VI1PR0501MB227135A8EE8B0E6CFA7870E3D1060@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190516233034.16407-1-parav@mellanox.com>
        <20190516233034.16407-4-parav@mellanox.com>
        <20190517132207.12d823f2.cohuck@redhat.com>
        <VI1PR0501MB227162B10E46947E7C4A1C83D10B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <20190520132911.4d56bfe5.cohuck@redhat.com>
        <VI1PR0501MB227135A8EE8B0E6CFA7870E3D1060@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 20 May 2019 22:12:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 May 2019 19:15:15 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Monday, May 20, 2019 6:29 AM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> > Subject: Re: [PATCHv3 3/3] vfio/mdev: Synchronize device create/remove
> > with parent removal
> > 
> > On Fri, 17 May 2019 14:18:26 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > > > @@ -206,14 +214,27 @@ void mdev_unregister_device(struct device  
> > *dev)  
> > > > >  	dev_info(dev, "MDEV: Unregistering\n");
> > > > >
> > > > >  	list_del(&parent->next);
> > > > > +	mutex_unlock(&parent_list_lock);
> > > > > +
> > > > > +	/* Release the initial reference so that new create cannot start */
> > > > > +	mdev_put_parent(parent);  
> > > >
> > > > The comment is confusing: We do drop one reference, but this does
> > > > not imply we're going to 0 (which would be the one thing that would
> > > > block creating new devices).
> > > >  
> > > Ok. How about below comment.
> > > /* Balance with initial reference init */  
> > 
> > Well, 'release the initial reference' is fine; it's just the second part that is
> > confusing.
> > 
> > One thing that continues to irk me (and I'm sorry if I sound like a broken
> > record) is that you give up the initial reference and then continue to use
> > parent. For the more usual semantics of a reference count, that would be a
> > bug (as the structure would be freed if the reference count dropped to zero),
> > even though it is not a bug here.
> >   
> Well, refcount cannot drop to zero if user is using it.
> But I understand that mdev_device caches it the parent in it, and hence it uses it.
> However, mdev_device child devices are terminated first when parent goes away, ensuring that no more parent user is active.
> So as you mentioned, its not a bug here.
> 
> > >  
> > > > > +
> > > > > +	/*
> > > > > +	 * Wait for all the create and remove references to drop.
> > > > > +	 */
> > > > > +	wait_for_completion(&parent->unreg_completion);  
> > > >
> > > > It only reaches 0 after this wait.
> > > >  
> > > Yes.
> > >  
> > > > > +
> > > > > +	/*
> > > > > +	 * New references cannot be taken and all users are done
> > > > > +	 * using the parent. So it is safe to unregister parent.
> > > > > +	 */
> > > > >  	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> > > > >
> > > > >  	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> > > > >
> > > > >  	parent_remove_sysfs_files(parent);
> > > > > -
> > > > > -	mutex_unlock(&parent_list_lock);
> > > > > -	mdev_put_parent(parent);
> > > > > +	kfree(parent);
> > > > > +	put_device(dev);
> > > > >  }
> > > > >  EXPORT_SYMBOL(mdev_unregister_device);
> > > > >
> > > > > @@ -237,10 +258,11 @@ int mdev_device_create(struct kobject *kobj,
> > > > >  	struct mdev_parent *parent;
> > > > >  	struct mdev_type *type = to_mdev_type(kobj);
> > > > >
> > > > > -	parent = mdev_get_parent(type->parent);
> > > > > -	if (!parent)
> > > > > +	if (!mdev_try_get_parent(type->parent))  
> > > >
> > > > If other calls are still running, the refcount won't be 0, and this
> > > > will succeed, even if we really want to get rid of the device.
> > > >  
> > > Sure, if other calls are running, refcount won't be 0. Process creating them  
> > will eventually complete, and refcount will drop to zero.  
> > > And new processes won't be able to start any more.
> > > So there is no differentiation between 'already in creation stage' and  
> > 'about to start' processes.
> > 
> > Does it really make sense to allow creation to start if the parent is going
> > away?
> >   
> Its really a small time window, on how we draw the line.
> But it has important note that if user continues to keep creating, removing, parent is blocked on removal.
> 
> > >  
> > > > >  		return -EINVAL;
> > > > >
> > > > > +	parent = type->parent;
> > > > > +
> > > > >  	mutex_lock(&mdev_list_lock);
> > > > >
> > > > >  	/* Check for duplicate */
> > > > > @@ -287,6 +309,7 @@ int mdev_device_create(struct kobject *kobj,
> > > > >
> > > > >  	mdev->active = true;
> > > > >  	dev_dbg(&mdev->dev, "MDEV: created\n");
> > > > > +	mdev_put_parent(parent);
> > > > >
> > > > >  	return 0;
> > > > >
> > > > > @@ -306,7 +329,6 @@ int mdev_device_remove(struct device *dev)
> > > > >  	struct mdev_device *mdev, *tmp;
> > > > >  	struct mdev_parent *parent;
> > > > >  	struct mdev_type *type;
> > > > > -	int ret;
> > > > >
> > > > >  	mdev = to_mdev_device(dev);
> > > > >
> > > > > @@ -330,15 +352,17 @@ int mdev_device_remove(struct device *dev)
> > > > >  	mutex_unlock(&mdev_list_lock);
> > > > >
> > > > >  	type = to_mdev_type(mdev->type_kobj);
> > > > > -	mdev_remove_sysfs_files(dev, type);
> > > > > -	device_del(&mdev->dev);
> > > > > -	parent = mdev->parent;
> > > > > -	ret = parent->ops->remove(mdev);
> > > > > -	if (ret)
> > > > > -		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
> > > > > +	if (!mdev_try_get_parent(type->parent)) {  
> > > >
> > > > Same here: Is there really a guarantee that the refcount is 0 when
> > > > the parent is going away?  
> > > A WARN_ON after wait_for_completion or in freeing the parent is good to  
> > catch bugs.
> > 
> > I'd rather prefer to avoid having to add WARN_ONs :)
> > 
> > This looks like it is supposed to be an early exit.   
> remove() is doing early exit if it doesn't get reference to its parent.
> mdev_device_remove_common().
> 
> > However, if some
> > other thread does any create or remove operation at the same time,
> > we'll still do the remove, and we still might have have a race window
> > (and this is getting really hard to follow in the code).
> >   
> Which part?
> We have only 4 functions to follow, register_device(), unregister_device(), create() and remove().
> 
> If you meant, two removes racing with each other?
> If so, that is currently guarded using not_so_well_defined active flag.
> I will cleanup that later once this series is done.
> 
> > >  
> > > >  
> > > > > +		/*
> > > > > +		 * Parent unregistration have started.
> > > > > +		 * No need to remove here.
> > > > > +		 */
> > > > > +		mutex_unlock(&mdev_list_lock);  
> > > >
> > > > Btw., you already unlocked above.
> > > >  
> > > You are right. This unlock is wrong. I will revise the patch.
> > >  
> > > > > +		return -ENODEV;
> > > > > +	}
> > > > >
> > > > > -	/* Balances with device_initialize() */
> > > > > -	put_device(&mdev->dev);
> > > > > +	parent = mdev->parent;
> > > > > +	mdev_device_remove_common(mdev);
> > > > >  	mdev_put_parent(parent);
> > > > >
> > > > >  	return 0;
> > > > > diff --git a/drivers/vfio/mdev/mdev_private.h
> > > > > b/drivers/vfio/mdev/mdev_private.h
> > > > > index 924ed2274941..55ebab0af7b0 100644
> > > > > --- a/drivers/vfio/mdev/mdev_private.h
> > > > > +++ b/drivers/vfio/mdev/mdev_private.h
> > > > > @@ -19,7 +19,11 @@ void mdev_bus_unregister(void);  struct  
> > > > mdev_parent  
> > > > > {
> > > > >  	struct device *dev;
> > > > >  	const struct mdev_parent_ops *ops;
> > > > > -	struct kref ref;
> > > > > +	/* Protects unregistration to wait until create/remove
> > > > > +	 * are completed.
> > > > > +	 */
> > > > > +	refcount_t refcount;
> > > > > +	struct completion unreg_completion;
> > > > >  	struct list_head next;
> > > > >  	struct kset *mdev_types_kset;
> > > > >  	struct list_head type_list;  
> > > >
> > > > I think what's really needed is to split up the different needs and not
> > > > overload the 'refcount' concept.
> > > >  
> > > Refcount tells that how many active references are present for this parent  
> > device.  
> > > Those active reference could be create/remove processes and mdev core  
> > itself.  
> > >
> > > So when parent unregisters, mdev module publishes that it is going away  
> > through this refcount.  
> > > Hence new users cannot start.  
> > 
> > But it does not actually do that -- if there are other create/remove
> > operations running, userspace can still trigger a new create/remove. If
> > it triggers enough create/remove processes, it can keep the parent
> > around (even though that really is a pathological case.)
> >   
> Yes. I agree that is still possible. And an extra flag can guard it.
> I see it as try_get_parent() can be improved as incremental to implement and honor that flag.
> Do you want to roll that flag in same patch in v4?
> 
> > >  
> > > > - If we need to make sure that a reference to the parent is held so
> > > >   that the parent may not go away while still in use, we should
> > > >   continue to use the kref (in the idiomatic way it is used before this
> > > >   patch.)
> > > > - We need to protect against creation of new devices if the parent is
> > > >   going away. Maybe set a going_away marker in the parent structure for
> > > >   that so that creation bails out immediately?  
> > > Such marker will help to not start new processes.
> > > So an additional marker can be added to improve mdev_try_get_parent().
> > > But I couldn't justify why differentiating those two users on time scale is  
> > desired.  
> > > One reason could be that user continuously tries to create mdev and  
> > parent never gets a chance, to unregister?  
> > > I guess, parent will run out mdev devices before this can happen.  
> > 
> > They can also run remove tasks in parallel (see above).
> >   
> Yes, remove() is guarded using active flag.
> 
> > >
> > > Additionally a stop marker is needed (counter) to tell that all users are  
> > done accessing it.  
> > > Both purposes are served using a refcount scheme.  
> > 
> > Why not stop new create/remove tasks on remove, and do the final
> > cleanup asynchronously? I think a refcount is fine to track accesses,
> > but not to block new tasks.
> >   
> So a new flag will guard new create/remove tasks by enhancing try_get_parent().
> I just didn't see it as critical fix, but it's doable. See above.
> 
> Async is certainly not a good idea.
> mdev_release_parent() in current code doesn't nothing other than freeing memory and parent reference.
> It take away the parent from the list early on, which is also wrong, because it was added to the list at the end.
> Unregister() sequence should be mirror image.
> Parent device files has to be removed before unregister_device() finishes, because they were added in register_device().
> Otherwise, parent device_del() might be done, but files are still created under it.
> 
> If we want to keep the memory around of parent, until kref drops, than we need two refcounts.
> One ensure that create and remove are done using it, other one that ensures that child are done using it.
> I fail to justify adding complexity of two counters, because such two_counter_desire hints that somehow child devices may be still active even after remove() calls are finished.
> And that should not be the case. Unless I miss such case.
> 
> > >  
> > > > What happens if the
> > > >   creation has already started when parent removal kicks in, though?  
> > > That particular creation will succeed but newer cannot start, because  
> > mdev_put_parent() is done.  
> > >  
> > > >   Do we need some child list locking and an indication whether a child
> > > >   is in progress of being registered/unregistered?
> > > > - We also need to protect against removal of devices while unregister
> > > >   is in progress (same mechanism as above?) The second issue you
> > > >   describe above should be fixed then if the children keep a reference
> > > >   of the parent.  
> > > Parent unregistration publishes that its going away first, so no new device  
> > removal from user can start.
> > 
> > I don't think that this actually works as intended (see above).
> >   
> It does work in most cases. Only if user space is creating hundreds of processes for creating mdevs, before they actually run out of creating new one.
> But as we talked a flag will guard it.
> 
> So if refcount is ok, I can enhance it for flag.

I agree with Connie's dislike of the refcount, where it seems we're
really just using it as a read-writer lock.  So why not simply use a
rwsem?  The parent unregistration path would do a down_write() and all
the ancillary paths would do a down_read_trylock() as they should never
see read contention unless the parent is being removed.  As a bonus, we
don't need to invent our own fairness algorithm, nor do we need to
remove the krefs as they're at least useful to validate we haven't
missed anyone.  Thanks,

Alex

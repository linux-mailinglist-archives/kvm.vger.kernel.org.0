Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F27187FC
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 11:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfEIJtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 05:49:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfEIJtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 05:49:23 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 951B83084212;
        Thu,  9 May 2019 09:49:23 +0000 (UTC)
Received: from gondolin (dhcp-192-213.str.redhat.com [10.33.192.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F80F60C6F;
        Thu,  9 May 2019 09:49:20 +0000 (UTC)
Date:   Thu, 9 May 2019 11:49:17 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Parav Pandit <parav@mellanox.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kwankhede@nvidia.com, cjia@nvidia.com
Subject: Re: [PATCHv2 10/10] vfio/mdev: Synchronize device create/remove
 with parent removal
Message-ID: <20190509114917.5e80e88d.cohuck@redhat.com>
In-Reply-To: <20190508204605.17294a7d@x1.home>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-11-parav@mellanox.com>
        <20190508204605.17294a7d@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 09 May 2019 09:49:23 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 May 2019 20:46:05 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 30 Apr 2019 17:49:37 -0500
> Parav Pandit <parav@mellanox.com> wrote:
> 
> > In following sequences, child devices created while removing mdev parent
> > device can be left out, or it may lead to race of removing half
> > initialized child mdev devices.
> > 
> > issue-1:
> > --------
> >        cpu-0                         cpu-1
> >        -----                         -----
> >                                   mdev_unregister_device()
> >                                     device_for_each_child()
> >                                       mdev_device_remove_cb()
> >                                         mdev_device_remove()
> > create_store()
> >   mdev_device_create()                   [...]
> >     device_add()
> >                                   parent_remove_sysfs_files()
> > 
> > /* BUG: device added by cpu-0
> >  * whose parent is getting removed
> >  * and it won't process this mdev.
> >  */
> > 
> > issue-2:
> > --------
> > Below crash is observed when user initiated remove is in progress
> > and mdev_unregister_driver() completes parent unregistration.
> > 
> >        cpu-0                         cpu-1
> >        -----                         -----
> > remove_store()
> >    mdev_device_remove()
> >    active = false;
> >                                   mdev_unregister_device()
> >                                   parent device removed.
> >    [...]
> >    parents->ops->remove()
> >  /*
> >   * BUG: Accessing invalid parent.
> >   */
> > 
> > This is similar race like create() racing with mdev_unregister_device().
> > 
> > BUG: unable to handle kernel paging request at ffffffffc0585668
> > PGD e8f618067 P4D e8f618067 PUD e8f61a067 PMD 85adca067 PTE 0
> > Oops: 0000 [#1] SMP PTI
> > CPU: 41 PID: 37403 Comm: bash Kdump: loaded Not tainted 5.1.0-rc6-vdevbus+ #6
> > Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b 08/09/2016
> > RIP: 0010:mdev_device_remove+0xfa/0x140 [mdev]
> > Call Trace:
> >  remove_store+0x71/0x90 [mdev]
> >  kernfs_fop_write+0x113/0x1a0
> >  vfs_write+0xad/0x1b0
> >  ksys_write+0x5a/0xe0
> >  do_syscall_64+0x5a/0x210
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > Therefore, mdev core is improved as below to overcome above issues.
> > 
> > Wait for any ongoing mdev create() and remove() to finish before
> > unregistering parent device using refcount and completion.
> > This continues to allow multiple create and remove to progress in
> > parallel for different mdev devices as most common case.
> > At the same time guard parent removal while parent is being access by
> > create() and remove callbacks.
> > 
> > Code is simplified from kref to use refcount as unregister_device() has
> > to wait anyway for all create/remove to finish.
> > 
> > While removing mdev devices during parent unregistration, there isn't
> > need to acquire refcount of parent device, hence code is restructured
> > using mdev_device_remove_common() to avoid it.  
> 
> Did you consider calling parent_remove_sysfs_files() earlier in
> mdev_unregister_device() and adding srcu support to know there are no
> in-flight callers of the create path?  I think that would address
> issue-1.
> 
> Issue-2 suggests a bug in our handling of the parent device krefs, the
> parent object should exist until all child devices which have a kref
> reference to the parent are removed, but clearly
> mdev_unregister_device() is not blocking for that to occur allowing the
> parent driver .remove callback to finish.  This seems similar to
> vfio_del_group_dev() where we need to block a vfio bus driver from
> removing a device until it becomes unused, could a similar solution
> with a wait_queue and wait_woken be used here?
> 
> I'm not immediately sold on the idea that removing a kref to solve this
> problem is a good thing, it seems odd to me that mdevs don't hold a
> reference to the parent throughout their life with this change, and the
> remove_store path branch to exit if we find we're racing the parent
> remove path is rather ugly.  BTW, why is the sanitization loop in
> mdev_device_remove() still here, wasn't that fixed by the previous two
> patches?  Thanks,

Agreed, I think not holding a reference to the parent is rather odd.

> 
> Alex
> 
> > Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 86 ++++++++++++++++++++------------
> >  drivers/vfio/mdev/mdev_private.h |  6 ++-
> >  2 files changed, 60 insertions(+), 32 deletions(-)

(...)

> > @@ -206,14 +214,27 @@ void mdev_unregister_device(struct device *dev)
> >  	dev_info(dev, "MDEV: Unregistering\n");
> >  
> >  	list_del(&parent->next);
> > +	mutex_unlock(&parent_list_lock);
> > +
> > +	/* Release the initial reference so that new create cannot start */
> > +	mdev_put_parent(parent);
> > +
> > +	/*
> > +	 * Wait for all the create and remove references to drop.
> > +	 */
> > +	wait_for_completion(&parent->unreg_completion);
> > +
> > +	/*
> > +	 * New references cannot be taken and all users are done
> > +	 * using the parent. So it is safe to unregister parent.
> > +	 */
> >  	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> >  
> >  	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> >  
> >  	parent_remove_sysfs_files(parent);
> > -
> > -	mutex_unlock(&parent_list_lock);
> > -	mdev_put_parent(parent);
> > +	kfree(parent);

Such a kfree() is usually a big, flashing warning sign to me, even
though it probably isn't strictly broken in this case.

> > +	put_device(dev);
> >  }
> >  EXPORT_SYMBOL(mdev_unregister_device);
> >  

I think one problem I'm having here is that two things are conflated
with that approach:

- Structures holding a reference to another structure, where they need
  to be sure that it isn't pulled out from under them.
- Structures being hooked up and discoverable from somewhere else.

I think what we actually need is that the code possibly creating a new
mdev device is not able to look up the parent device if removal has
been already triggered for it. Same for triggering mdev device removal.

Do we need to somehow tie getting an extra reference to looking up the
device? Any extra reference does not hurt, as long as we remember to
drop it again :)

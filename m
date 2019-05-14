Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38BB21E509
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 00:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfENWUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 18:20:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbfENWU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 18:20:29 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 55D9B307D8BE;
        Tue, 14 May 2019 22:20:28 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A37781001DE1;
        Tue, 14 May 2019 22:20:27 +0000 (UTC)
Date:   Tue, 14 May 2019 16:20:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove sequence
Message-ID: <20190514162027.55710507@x1.home>
In-Reply-To: <VI1PR0501MB227132A392D9CA41792AC44BD1080@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-9-parav@mellanox.com>
        <20190508190957.673dd948.cohuck@redhat.com>
        <VI1PR0501MB2271CFAFF2ACF145FDFD8E2ED1320@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <20190509110600.5354463c.cohuck@redhat.com>
        <VI1PR0501MB2271DD5EE143784B9F94D446D1330@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <VI1PR0501MB227132A392D9CA41792AC44BD1080@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 14 May 2019 22:20:28 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 May 2019 20:34:12 +0000
Parav Pandit <parav@mellanox.com> wrote:

> Hi Alex, Cornelia,
> 
> 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org <linux-kernel-  
> > owner@vger.kernel.org> On Behalf Of Parav Pandit  
> > Sent: Thursday, May 9, 2019 2:20 PM
> > To: Cornelia Huck <cohuck@redhat.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com;
> > Tony Krowiak <akrowiak@linux.ibm.com>; Pierre Morel
> > <pmorel@linux.ibm.com>; Halil Pasic <pasic@linux.ibm.com>
> > Subject: RE: [PATCHv2 08/10] vfio/mdev: Improve the create/remove
> > sequence
> > 
> > 
> >   
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Thursday, May 9, 2019 4:06 AM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com;
> > > Tony Krowiak <akrowiak@linux.ibm.com>; Pierre Morel
> > > <pmorel@linux.ibm.com>; Halil Pasic <pasic@linux.ibm.com>
> > > Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove
> > > sequence
> > >
> > > [vfio-ap folks: find a question regarding removal further down]
> > >
> > > On Wed, 8 May 2019 22:06:48 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >  
> > > > > -----Original Message-----
> > > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > > Sent: Wednesday, May 8, 2019 12:10 PM
> > > > > To: Parav Pandit <parav@mellanox.com>
> > > > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > > > kwankhede@nvidia.com; alex.williamson@redhat.com;  
> > cjia@nvidia.com  
> > > > > Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove
> > > > > sequence
> > > > >
> > > > > On Tue, 30 Apr 2019 17:49:35 -0500 Parav Pandit
> > > > > <parav@mellanox.com> wrote:
> > > > >  
> > > > > > This patch addresses below two issues and prepares the code to
> > > > > > address 3rd issue listed below.
> > > > > >
> > > > > > 1. mdev device is placed on the mdev bus before it is created in
> > > > > > the vendor driver. Once a device is placed on the mdev bus
> > > > > > without creating its supporting underlying vendor device, mdev
> > > > > > driver's
> > > > > > probe()  
> > > > > gets triggered.  
> > > > > > However there isn't a stable mdev available to work on.
> > > > > >
> > > > > >    create_store()
> > > > > >      mdev_create_device()
> > > > > >        device_register()
> > > > > >           ...
> > > > > >          vfio_mdev_probe()
> > > > > >         [...]
> > > > > >         parent->ops->create()
> > > > > >           vfio_ap_mdev_create()
> > > > > >             mdev_set_drvdata(mdev, matrix_mdev);
> > > > > >             /* Valid pointer set above */
> > > > > >
> > > > > > Due to this way of initialization, mdev driver who want to use
> > > > > > the  
> > >
> > > s/want/wants/
> > >  
> > > > > > mdev, doesn't have a valid mdev to work on.
> > > > > >
> > > > > > 2. Current creation sequence is,
> > > > > >    parent->ops_create()
> > > > > >    groups_register()
> > > > > >
> > > > > > Remove sequence is,
> > > > > >    parent->ops->remove()
> > > > > >    groups_unregister()
> > > > > >
> > > > > > However, remove sequence should be exact mirror of creation  
> > > sequence.  
> > > > > > Once this is achieved, all users of the mdev will be terminated
> > > > > > first before removing underlying vendor device.
> > > > > > (Follow standard linux driver model).
> > > > > > At that point vendor's remove() ops shouldn't failed because
> > > > > > device is  
> > >
> > > s/failed/fail/
> > >  
> > > > > > taken off the bus that should terminate the users.  
> > >
> > > "because taking the device off the bus should terminate any usage" ?
> > >  
> > > > > >
> > > > > > 3. When remove operation fails, mdev sysfs removal attempts to
> > > > > > add the file back on already removed device. Following call
> > > > > > trace [1] is  
> > > observed.  
> > > > > >
> > > > > > [1] call trace:
> > > > > > kernel: WARNING: CPU: 2 PID: 9348 at fs/sysfs/file.c:327
> > > > > > sysfs_create_file_ns+0x7f/0x90
> > > > > > kernel: CPU: 2 PID: 9348 Comm: bash Kdump: loaded Not tainted
> > > > > > 5.1.0-rc6-vdevbus+ #6
> > > > > > kernel: Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS
> > > > > > 2.0b
> > > > > > 08/09/2016
> > > > > > kernel: RIP: 0010:sysfs_create_file_ns+0x7f/0x90
> > > > > > kernel: Call Trace:
> > > > > > kernel: remove_store+0xdc/0x100 [mdev]
> > > > > > kernel: kernfs_fop_write+0x113/0x1a0
> > > > > > kernel: vfs_write+0xad/0x1b0
> > > > > > kernel: ksys_write+0x5a/0xe0
> > > > > > kernel: do_syscall_64+0x5a/0x210
> > > > > > kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > > > >
> > > > > > Therefore, mdev core is improved in following ways.
> > > > > >
> > > > > > 1. Before placing mdev devices on the bus, perform vendor
> > > > > > drivers creation which supports the mdev creation.  
> > >
> > > "invoke the vendor driver ->create callback" ?
> > >  
> > > > > > This ensures that mdev specific all necessary fields are
> > > > > > initialized  
> > >
> > > "that all necessary mdev specific fields are initialized" ?
> > >  
> > > > > > before a given mdev can be accessed by bus driver.
> > > > > > This follows standard Linux kernel bus and device model similar
> > > > > > to other widely used PCI bus.  
> > >
> > > "This follows standard practice on other Linux device model buses." ?
> > >  
> > > > > >
> > > > > > 2. During remove flow, first remove the device from the bus.
> > > > > > This ensures that any bus specific devices and data is cleared.
> > > > > > Once device is taken of the mdev bus, perform remove() of mdev
> > > > > > from  
> > >
> > > s/of/off/
> > >  
> > > > > > the vendor driver.
> > > > > >
> > > > > > 3. Linux core device model provides way to register and auto
> > > > > > unregister the device sysfs attribute groups at dev->groups.  
> > >
> > > "The driver core provides a way to automatically register and
> > > unregister sysfs attributes via dev->groups." ?
> > >  
> > > > > > Make use of this groups to let core create the groups and
> > > > > > simplify code to avoid explicit groups creation and removal.
> > > > > >
> > > > > > A below stack dump of a mdev device remove process also ensures
> > > > > > that vfio driver guards against device removal already in use.
> > > > > >
> > > > > >  cat /proc/21962/stack
> > > > > > [<0>] vfio_del_group_dev+0x216/0x3c0 [vfio] [<0>]
> > > > > > mdev_remove+0x21/0x40 [mdev] [<0>]
> > > > > > device_release_driver_internal+0xe8/0x1b0
> > > > > > [<0>] bus_remove_device+0xf9/0x170 [<0>] device_del+0x168/0x350
> > > > > > [<0>] mdev_device_remove_common+0x1d/0x50 [mdev] [<0>]
> > > > > > mdev_device_remove+0x8c/0xd0 [mdev] [<0>]  
> > > remove_store+0x71/0x90  
> > > > > > [mdev] [<0>] kernfs_fop_write+0x113/0x1a0 [<0>]
> > > > > > vfs_write+0xad/0x1b0 [<0>] ksys_write+0x5a/0xe0 [<0>]
> > > > > > do_syscall_64+0x5a/0x210 [<0>]
> > > > > > entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > > > > [<0>] 0xffffffffffffffff
> > > > > >
> > > > > > This prepares the code to eliminate calling device_create_file()
> > > > > > in subsquent patch.  
> > >
> > > I find this stack dump and explanation more confusing than enlightening.
> > > Maybe just drop it?
> > >  
> > > > >
> > > > > I'm afraid I have a bit of a problem following this explanation,
> > > > > so let me try to summarize what the patch does to make sure that I
> > > > > understand it
> > > > > correctly:
> > > > >
> > > > > - Add the sysfs groups to device->groups so that the driver core deals
> > > > >   with proper registration/deregistration.
> > > > > - Split the device registration/deregistration sequence so that some
> > > > >   things can be done between initialization of the device and hooking
> > > > >   it up to the infrastructure respectively after deregistering it from
> > > > >   the infrastructure but before giving up our final reference. In
> > > > >   particular, this means invoking the ->create and ->remove callback in
> > > > >   those new windows. This gives the vendor driver an initialized mdev
> > > > >   device to work with during creation.
> > > > > - Don't allow ->remove to fail, as the device is already removed from
> > > > >   the infrastructure at that point in time.
> > > > >  
> > > > You got all the points pretty accurate.  
> > >
> > > Ok, good.
> > >  
> > > >  
> > > > > >
> > > > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > > > ---
> > > > > >  drivers/vfio/mdev/mdev_core.c    | 94 +++++++++-----------------------
> > > > > >  drivers/vfio/mdev/mdev_private.h |  2 +-
> > > > > >  drivers/vfio/mdev/mdev_sysfs.c   |  2 +-
> > > > > >  3 files changed, 27 insertions(+), 71 deletions(-)  
> > > > >
> > > > > (...)  
> > >  
> > > > > > @@ -373,16 +330,15 @@ int mdev_device_remove(struct device  
> > *dev,  
> > > > > bool force_remove)  
> > > > > >  	mutex_unlock(&mdev_list_lock);
> > > > > >
> > > > > >  	type = to_mdev_type(mdev->type_kobj);
> > > > > > +	mdev_remove_sysfs_files(dev, type);
> > > > > > +	device_del(&mdev->dev);
> > > > > >  	parent = mdev->parent;
> > > > > > +	ret = parent->ops->remove(mdev);
> > > > > > +	if (ret)
> > > > > > +		dev_err(&mdev->dev, "Remove failed: err=%d\n",  
> > ret);  
> > > > >
> > > > > I think carrying on with removal regardless of the return code of
> > > > > the  
> > > > > ->remove callback makes sense, as it simply matches usual practice.  
> > > > > However, are we sure that every vendor driver works well with that?
> > > > > I think it should, as removal from bus unregistration (vs. from
> > > > > the sysfs
> > > > > file) was always something it could not veto, but have you looked
> > > > > at the individual drivers?
> > > > >  
> > > > I looked at following drivers a little while back.
> > > > Looked again now.
> > > >
> > > > drivers/gpu/drm/i915/gvt/kvmgt.c which clears the handle valid in  
> > > intel_vgpu_release(), which should finish first before remove() is invoked.  
> > > >
> > > > s390 vfio_ccw_mdev_remove() driver drivers/s390/cio/vfio_ccw_ops.c  
> > > remove() always returns 0.  
> > > > s39 crypo fails the remove() once vfio_ap_mdev_release marks kvm
> > > > null,  
> > > which should finish before remove() is invoked.
> > >
> > > That one is giving me a bit of a headache (the ->kvm reference is
> > > supposed to keep us from detaching while a vm is running), so let's cc:
> > > the vfio-ap maintainers to see whether they have any concerns.
> > >  
> > I probably wrote wrongly.
> > vfio_ap_mdev_remove() fails if the VM is already running (i.e.
> > vfio_ap_mdev_release() is not yet called).
> > 
> > And if VM is running it guarded by the vfio_mdev driver which is the one
> > who binds to the device mdev device.
> > That is why I shown the above stack trace in the commit log, indicating that
> > vfio driver is guarding it.
> >   
> > > > samples/vfio-mdev/mbochs.c mbochs_remove() always returns 0.
> > > >  
> > > > > >
> > > > > > -	ret = mdev_device_remove_ops(mdev, force_remove);
> > > > > > -	if (ret) {
> > > > > > -		mdev->active = true;
> > > > > > -		return ret;
> > > > > > -	}
> > > > > > -
> > > > > > -	mdev_remove_sysfs_files(dev, type);
> > > > > > -	device_unregister(dev);
> > > > > > +	/* Balances with device_initialize() */
> > > > > > +	put_device(&mdev->dev);
> > > > > >  	mdev_put_parent(parent);
> > > > > >
> > > > > >  	return 0;  
> > > > >
> > > > > I think that looks sane in general, but the commit message might
> > > > > benefit from tweaking.  
> > > > Part of your description is more crisp than my commit message, I can  
> > > probably take snippet from it to improve?  
> > > > Or any specific entries in commit message that I should address?  
> > >
> > > I have added some comments inline (mostly some wording tweaks).
> > >
> > > Feel free to take anything from my summary as well.  
> 
> I want to send v3 addressing commit log comment and take updated description from Cornelia, if this 3 patches looks reasonable enough.
> What do you think?

The kref removal in the last patch still makes me uncomfortable, but I
can't really find a reason to keep it or see any problems with the way
you're using refcount either.  It's probably good to see a new version
of the series regardless.  Thanks,

Alex

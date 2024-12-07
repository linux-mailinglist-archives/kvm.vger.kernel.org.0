Return-Path: <kvm+bounces-33245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5309E7F0E
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 09:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 078221883756
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 08:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179B214264A;
	Sat,  7 Dec 2024 08:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7XOu4Ly"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DC013E02A
	for <kvm@vger.kernel.org>; Sat,  7 Dec 2024 08:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733560773; cv=none; b=kcsHuM22/SMze+ocAz5OeuF9IwfMC8Un6dOdmUqCCnwbxS7n2gLuMVcwCgsurcXv6SUsLyCq/FhN95qevWx7+BwFc5SKir6TyEVZaPvASk2dZZFZILAsCrcXeeHJT7iDFjov8NR1hZ+kHWlQ/fkU46rQIjIPszu5jpsXdaxgdTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733560773; c=relaxed/simple;
	bh=HUwjpBN5/C1U8cCaqxj9ugFYVurlOz6yPgyAKY47jns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwykZA4A/BQeTOSvAPJqJ7Cg+sPpZOIdOVgHaWH7WvP3cX0cM30x0T1zBdKSuw3wsDhTfulmBPqXzNYT4e39ju9PFj/Ia37wmbQpymNtcjuMv33x6SSKvHZLSpcTrllIXbN4mia/HJlBRHxAuZ0vI/78qptv9oQKdjUOU/mqp14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7XOu4Ly; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE11C4CEDE;
	Sat,  7 Dec 2024 08:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733560772;
	bh=HUwjpBN5/C1U8cCaqxj9ugFYVurlOz6yPgyAKY47jns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s7XOu4Ly6fg1v9boNkth2yzLkQBqlM9qwFBiGLsTLD1TNEhJrOLVW9rhJsBVFk0jC
	 yNhDGrHMqrQcfwqiYGajxUiD6DzQ+IVqHhpM2sBmBqNBBo91h+ZrlRohw2S16svxSN
	 fQ1LTZXSW0MpTaYVu3AN12HDfH+Z6kKJECXBThTI=
Date: Sat, 7 Dec 2024 09:38:56 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <2024120721-parasite-thespian-84e0@gregkh>
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
 <0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
 <2024120430-boneless-wafer-bf0c@gregkh>
 <fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
 <2024120410-promoter-blandness-efa1@gregkh>
 <20241204123040.7e3483a4.alex.williamson@redhat.com>
 <9015ce52-e4f3-459c-bd74-b8707cf8fd88@gmail.com>
 <2024120617-icon-bagel-86b3@gregkh>
 <20241206093733.1d887dfc.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206093733.1d887dfc.alex.williamson@redhat.com>

On Fri, Dec 06, 2024 at 09:37:33AM -0700, Alex Williamson wrote:
> On Fri, 6 Dec 2024 08:42:02 +0100
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Fri, Dec 06, 2024 at 08:35:47AM +0100, Heiner Kallweit wrote:
> > > On 04.12.2024 20:30, Alex Williamson wrote:  
> > > > On Wed, 4 Dec 2024 19:16:03 +0100
> > > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > >   
> > > >> On Wed, Dec 04, 2024 at 06:01:36PM +0100, Heiner Kallweit wrote:  
> > > >>> On 04.12.2024 10:32, Greg Kroah-Hartman wrote:    
> > > >>>> On Tue, Dec 03, 2024 at 09:11:47PM +0100, Heiner Kallweit wrote:    
> > > >>>>> vfio/mdev is the last user of class_compat, and it doesn't use it for
> > > >>>>> the intended purpose. See kdoc of class_compat_register():
> > > >>>>> Compatibility class are meant as a temporary user-space compatibility
> > > >>>>> workaround when converting a family of class devices to a bus devices.    
> > > >>>>
> > > >>>> True, so waht is mdev doing here?
> > > >>>>     
> > > >>>>> In addition it uses only a part of the class_compat functionality.
> > > >>>>> So inline the needed functionality, and afterwards all class_compat
> > > >>>>> code can be removed.
> > > >>>>>
> > > >>>>> No functional change intended. Compile-tested only.
> > > >>>>>
> > > >>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > > >>>>> ---
> > > >>>>>  drivers/vfio/mdev/mdev_core.c | 12 ++++++------
> > > >>>>>  1 file changed, 6 insertions(+), 6 deletions(-)
> > > >>>>>
> > > >>>>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> > > >>>>> index ed4737de4..a22c49804 100644
> > > >>>>> --- a/drivers/vfio/mdev/mdev_core.c
> > > >>>>> +++ b/drivers/vfio/mdev/mdev_core.c
> > > >>>>> @@ -18,7 +18,7 @@
> > > >>>>>  #define DRIVER_AUTHOR		"NVIDIA Corporation"
> > > >>>>>  #define DRIVER_DESC		"Mediated device Core Driver"
> > > >>>>>  
> > > >>>>> -static struct class_compat *mdev_bus_compat_class;
> > > >>>>> +static struct kobject *mdev_bus_kobj;    
> > > >>>>
> > > >>>>
> > > >>>>     
> > > >>>>>  
> > > >>>>>  static LIST_HEAD(mdev_list);
> > > >>>>>  static DEFINE_MUTEX(mdev_list_lock);
> > > >>>>> @@ -76,7 +76,7 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> > > >>>>>  	if (ret)
> > > >>>>>  		return ret;
> > > >>>>>  
> > > >>>>> -	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
> > > >>>>> +	ret = sysfs_create_link(mdev_bus_kobj, &dev->kobj, dev_name(dev));    
> > > >>>>
> > > >>>> This feels really wrong, why create a link to a random kobject?  Who is
> > > >>>> using this kobject link?
> > > >>>>     
> > > >>>>>  	if (ret)
> > > >>>>>  		dev_warn(dev, "Failed to create compatibility class link\n");
> > > >>>>>  
> > > >>>>> @@ -98,7 +98,7 @@ void mdev_unregister_parent(struct mdev_parent *parent)
> > > >>>>>  	dev_info(parent->dev, "MDEV: Unregistering\n");
> > > >>>>>  
> > > >>>>>  	down_write(&parent->unreg_sem);
> > > >>>>> -	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
> > > >>>>> +	sysfs_remove_link(mdev_bus_kobj, dev_name(parent->dev));
> > > >>>>>  	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
> > > >>>>>  	parent_remove_sysfs_files(parent);
> > > >>>>>  	up_write(&parent->unreg_sem);
> > > >>>>> @@ -251,8 +251,8 @@ static int __init mdev_init(void)
> > > >>>>>  	if (ret)
> > > >>>>>  		return ret;
> > > >>>>>  
> > > >>>>> -	mdev_bus_compat_class = class_compat_register("mdev_bus");
> > > >>>>> -	if (!mdev_bus_compat_class) {
> > > >>>>> +	mdev_bus_kobj = class_pseudo_register("mdev_bus");    
> > > >>>>
> > > >>>> But this isn't a class, so let's not fake it please.  Let's fix this
> > > >>>> properly, odds are all of this code can just be removed entirely, right?
> > > >>>>     
> > > >>>
> > > >>> After I removed class_compat from i2c core, I asked Alex basically the
> > > >>> same thing: whether class_compat support can be removed from vfio/mdev too.
> > > >>>
> > > >>> His reply:
> > > >>> I'm afraid we have active userspace tools dependent on
> > > >>> /sys/class/mdev_bus currently, libvirt for one.  We link mdev parent
> > > >>> devices here and I believe it's the only way for userspace to find
> > > >>> those parent devices registered for creating mdev devices.  If there's a
> > > >>> desire to remove class_compat, we might need to add some mdev
> > > >>> infrastructure to register the class ourselves to maintain the parent
> > > >>> links.
> > > >>>
> > > >>>
> > > >>> It's my understanding that /sys/class/mdev_bus has nothing in common
> > > >>> with an actual class, it's just a container for devices which at least
> > > >>> partially belong to other classes. And there's user space tools depending
> > > >>> on this structure.    
> > > >>
> > > >> That's odd, when this was added, why was it added this way?  The
> > > >> class_compat stuff is for when classes move around, yet this was always
> > > >> done in this way?
> > > >>
> > > >> And what tools use this symlink today that can't be updated?  
> > > > 
> > > > It's been this way for 8 years, so it's hard to remember exact
> > > > motivation for using this mechanism, whether we just didn't look hard
> > > > enough at the class_compat or it didn't pass by the right set of eyes.
> > > > Yes, it's always been this way for the mdev_bus class.
> > > > 
> > > > The intention here is much like other classes, that we have a node in
> > > > sysfs where we can find devices that provide a common feature, in this
> > > > case providing support for creating and managing vfio mediated devices
> > > > (mdevs).  The perhaps unique part of this use case is that these devices
> > > > aren't strictly mdev providers, they might also belong to another class
> > > > and the mdev aspect of their behavior might be dynamically added after
> > > > the device itself is added.
> > > > 
> > > > I've done some testing with this series and it does indeed seem to
> > > > maintain compatibility with existing userspace tools, mdevctl and
> > > > libvirt.  We can update these tools, but then we get into the breaking  
> > > 
> > > Greg, is this testing, done by Alex, sufficient for you to take the series?  
> > 
> > Were devices actually removed from the system and all worked well?
> 
> Creating and removing virtual mdev devices as well as unloading and
> re-loading modules for the parent device providing the mdev support.
> 
> > > > userspace and deprecation period questions, where we may further delay
> > > > removal of class_compat.  Also if we were to re-implement this, is there
> > > > a better mechanism than proposed here within the class hierarchy, or
> > > > would you recommend a non-class approach?  Thanks,
> > > >   
> > > 
> > > You have /sys/bus/mdev. Couldn't we create a directory here which holds
> > > the links to the devices in question?  
> > 
> > Links to devices is not what class links are for, so why is this in
> > /sys/class/ at all?
> 
> Sorry, I'm confused.  I look in /sys/class/block and /sys/class/net and
> I only see links to devices.

Yes, they are linking to "class devices", i.e. things controlled by that
class, NOT just a driver bound to a device on a bus.

> /sys/class/mdev_bus has links to devices
> that have registered as supporting the mdev interface for creating
> devices in /sys/bus/mdev.

And that's the issue here, drivers binding to a device on a bus are NOT
class devices, they are bus devices (i.e. on the bus.)

This used to be much "clearer" when we had "struct class_device" but we
unified that a long time ago and now only have "struct device".

In short, a bus device is the thing that is on a "bus" that a driver
binds to (i.e. controls the hardware).  A class device is the thing that
a user talks to in a standardized way (input, block, tty, network, etc.)
that is INDEPENDENT of the hardware bus the device happens to be
attached to.

> We could link these devices somewhere else,
> but there are existing projects, userspace scripts, and documentation
> that references and relies on this layout.  Whatever we decide it
> should have been 8 years ago is going to need yet another compatibility
> interface/link to avoid breaking userspace.

What you did here is say "mdev is both a standard interface to talk to
userspace AND a standard bus", when really you should have made a mdev
class if you really wanted one.  Why not just do that now instead?
Nothing should be preventing that and then your bus code can be the same
too.

> > > Then user space would simply have to switch from /sys/class/mdev_bus
> > > to /sys/bus/mdev/<new_dir>.  
> >
> > I think you are confusing what /sys/class/ is for here, if you have
> > devices on a "bus" then they need to be in /sys/bus/   class has nothing
> > to do with that.
> > 
> > So can we just drop the /sys/class/ mistake entirely?
> 
> Not without breaking userspace.  /sys/bus/mdev is used for enumerating
> the virtual mdev devics that are created by devices supporting the mdev
> interface, where the latter are enumerated in /sys/class/mdev_bus.

Great, how about creating a mdev_bus "struct class" then and doing this
properly?  That would be the correct solution overall, not this
overloading of a symlink that causes confusion.

thanks,

greg k-h


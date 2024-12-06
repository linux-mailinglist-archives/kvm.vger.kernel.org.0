Return-Path: <kvm+bounces-33220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B419E763C
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 17:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A454C288863
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 16:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB390206285;
	Fri,  6 Dec 2024 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e+WycjEX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3378120626A
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733503062; cv=none; b=KWB8Fmkqdnbg25+Qu+5lro00eUgYlaU8C56eNVRxVXguQxZ/UYl6nHzHT+W/+/q5JJqhXTTLctxKYYolahzXlfS75L9xuJUfjvSUqecq26DdaDL+swjSTWmgc8WgEIYDAJ2k0XRX7T880hFCagF3Km6szYiSu98AssL04CYmjxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733503062; c=relaxed/simple;
	bh=ag9rjBlPw44EpJY29OIf7O7zLGGhTQJ6f6rb9lHDkgA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LJ8p5a9VUba9jKaZl9vamk7OECryPsoWKbpjdFOIIcUfJKlkOMx0nQtsu/w9WE0F595nfZmpTUik8RqWIqen4RXhoDpPOqJOuqAqEzjRVHSfEgAvC75sKXK4UFBAHVRYnXVNnu+qerIAqZOKHD55afa7XZAo9JCDv7TY0p1sdR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e+WycjEX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733503059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jbNEWBi7UVe/mWpAX6564dOBIGUrHu4kBVAh4Z+ELj0=;
	b=e+WycjEXAZcUrfluRH+Pf8ke/tqM6kzRRKbyZ3EhePDLCcxu+eoy2+mHQP85mu2zfiksWy
	Kpg7I9CHE+dyYQuBip7q1/U2EYMDUqcF/ayGIt3wUOvli0kGSKqcxByPgtIqtpmdWDAirU
	Wh/9XruMYmnjKApt7H/vbr7FBq5jDKI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-XJj_c-4eOYCphozq9nPe6g-1; Fri, 06 Dec 2024 11:37:36 -0500
X-MC-Unique: XJj_c-4eOYCphozq9nPe6g-1
X-Mimecast-MFC-AGG-ID: XJj_c-4eOYCphozq9nPe6g
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8418358cca3so20045939f.0
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2024 08:37:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733503056; x=1734107856;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jbNEWBi7UVe/mWpAX6564dOBIGUrHu4kBVAh4Z+ELj0=;
        b=NVfiK8J7dMaKJU4uD7BpELqaxWiHLdAkRe73/ZPzKUYCheaMYGqtZUXhlBJQOBBFjL
         qLLS54xeWzFym36Vovr2KTollHduI+c47W57pnyC/t4n8waGEM2IXhbhu/pa96locWoD
         f22U40Fv7qpzjUwd461P9sNroDhWXj5dgGVwBWOtdL5rVk75E2fzSKBjv+tDSHs2kOlL
         /1zfW3pk05iA/wJYTLQqLxJS7TyGRoOH22z7qePTEpE7oTfkwpS6qEP4+l73xMKLm1/1
         rTJikQG2AyJXH0yfprMkWmpB+lvK5MjYCluFXQf9FsT9GGnNVg3oXi5YZrlQP+6jJqPS
         /Mtg==
X-Forwarded-Encrypted: i=1; AJvYcCXiBHFJ+qX2M8jWp28ZMJEV35B8mbso5K/OX6AEheoNEt3dcOCQAPZJhdWSpgQ1K3W4Jcs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCsZr/NseHgOvOHVtcwRiLXlduXVFhSsnOAW3qwUOXoiPMiY0A
	nYCqPFXknQ0ftJ9Kop13Yx6PPMbtXtbiLR+Zbx6er7oJgNYUhOcgAMpVDM8udOAPCef8IzUNfh9
	A36HR5bFToNR/y3/6F+CYZGpyJzWHBA9yb52SeEoVIFgf9/C+rQ==
X-Gm-Gg: ASbGncvz1pJTdO9/a3WS6SfkD0sLWbVK56tOYtJaVWdDIl4O1IUcet1oQk2rjOo+ZKd
	YuQfe4IwKIs23az8SQtDUCa1G0iof/7rrhOwdCg0reSk1xfjJuIBF3/XQem2d9jh/ms3hzfKvyr
	IGpxyEP7hHVcAC+9xrAUXf0YqvE+Tisc8l4Id4ojSicAcqKkvy8Itu6yYenVeUX7avkIu4FEsBH
	8U+4bDZySWPXlNIjDebeqxk7DN7fcGdYdPT8PHN5Gn11oVmHhMY2Q==
X-Received: by 2002:a05:6602:2cd0:b0:83a:96ce:342e with SMTP id ca18e2360f4ac-8447e2d15aemr111007039f.3.1733503056164;
        Fri, 06 Dec 2024 08:37:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH6lR0UADeIvCD8kz9dScBrAvCVOGAV43dpKqlwuL73/CTC5i7AB2xfC3QH+xyFQzUHeuv3xw==
X-Received: by 2002:a05:6602:2cd0:b0:83a:96ce:342e with SMTP id ca18e2360f4ac-8447e2d15aemr111006339f.3.1733503055761;
        Fri, 06 Dec 2024 08:37:35 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84473a70800sm108404939f.46.2024.12.06.08.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 08:37:35 -0800 (PST)
Date: Fri, 6 Dec 2024 09:37:33 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Kirti Wankhede <kwankhede@nvidia.com>,
 kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <20241206093733.1d887dfc.alex.williamson@redhat.com>
In-Reply-To: <2024120617-icon-bagel-86b3@gregkh>
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
	<0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
	<2024120430-boneless-wafer-bf0c@gregkh>
	<fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
	<2024120410-promoter-blandness-efa1@gregkh>
	<20241204123040.7e3483a4.alex.williamson@redhat.com>
	<9015ce52-e4f3-459c-bd74-b8707cf8fd88@gmail.com>
	<2024120617-icon-bagel-86b3@gregkh>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 6 Dec 2024 08:42:02 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Fri, Dec 06, 2024 at 08:35:47AM +0100, Heiner Kallweit wrote:
> > On 04.12.2024 20:30, Alex Williamson wrote:  
> > > On Wed, 4 Dec 2024 19:16:03 +0100
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > >   
> > >> On Wed, Dec 04, 2024 at 06:01:36PM +0100, Heiner Kallweit wrote:  
> > >>> On 04.12.2024 10:32, Greg Kroah-Hartman wrote:    
> > >>>> On Tue, Dec 03, 2024 at 09:11:47PM +0100, Heiner Kallweit wrote:    
> > >>>>> vfio/mdev is the last user of class_compat, and it doesn't use it for
> > >>>>> the intended purpose. See kdoc of class_compat_register():
> > >>>>> Compatibility class are meant as a temporary user-space compatibility
> > >>>>> workaround when converting a family of class devices to a bus devices.    
> > >>>>
> > >>>> True, so waht is mdev doing here?
> > >>>>     
> > >>>>> In addition it uses only a part of the class_compat functionality.
> > >>>>> So inline the needed functionality, and afterwards all class_compat
> > >>>>> code can be removed.
> > >>>>>
> > >>>>> No functional change intended. Compile-tested only.
> > >>>>>
> > >>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > >>>>> ---
> > >>>>>  drivers/vfio/mdev/mdev_core.c | 12 ++++++------
> > >>>>>  1 file changed, 6 insertions(+), 6 deletions(-)
> > >>>>>
> > >>>>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> > >>>>> index ed4737de4..a22c49804 100644
> > >>>>> --- a/drivers/vfio/mdev/mdev_core.c
> > >>>>> +++ b/drivers/vfio/mdev/mdev_core.c
> > >>>>> @@ -18,7 +18,7 @@
> > >>>>>  #define DRIVER_AUTHOR		"NVIDIA Corporation"
> > >>>>>  #define DRIVER_DESC		"Mediated device Core Driver"
> > >>>>>  
> > >>>>> -static struct class_compat *mdev_bus_compat_class;
> > >>>>> +static struct kobject *mdev_bus_kobj;    
> > >>>>
> > >>>>
> > >>>>     
> > >>>>>  
> > >>>>>  static LIST_HEAD(mdev_list);
> > >>>>>  static DEFINE_MUTEX(mdev_list_lock);
> > >>>>> @@ -76,7 +76,7 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> > >>>>>  	if (ret)
> > >>>>>  		return ret;
> > >>>>>  
> > >>>>> -	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
> > >>>>> +	ret = sysfs_create_link(mdev_bus_kobj, &dev->kobj, dev_name(dev));    
> > >>>>
> > >>>> This feels really wrong, why create a link to a random kobject?  Who is
> > >>>> using this kobject link?
> > >>>>     
> > >>>>>  	if (ret)
> > >>>>>  		dev_warn(dev, "Failed to create compatibility class link\n");
> > >>>>>  
> > >>>>> @@ -98,7 +98,7 @@ void mdev_unregister_parent(struct mdev_parent *parent)
> > >>>>>  	dev_info(parent->dev, "MDEV: Unregistering\n");
> > >>>>>  
> > >>>>>  	down_write(&parent->unreg_sem);
> > >>>>> -	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
> > >>>>> +	sysfs_remove_link(mdev_bus_kobj, dev_name(parent->dev));
> > >>>>>  	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
> > >>>>>  	parent_remove_sysfs_files(parent);
> > >>>>>  	up_write(&parent->unreg_sem);
> > >>>>> @@ -251,8 +251,8 @@ static int __init mdev_init(void)
> > >>>>>  	if (ret)
> > >>>>>  		return ret;
> > >>>>>  
> > >>>>> -	mdev_bus_compat_class = class_compat_register("mdev_bus");
> > >>>>> -	if (!mdev_bus_compat_class) {
> > >>>>> +	mdev_bus_kobj = class_pseudo_register("mdev_bus");    
> > >>>>
> > >>>> But this isn't a class, so let's not fake it please.  Let's fix this
> > >>>> properly, odds are all of this code can just be removed entirely, right?
> > >>>>     
> > >>>
> > >>> After I removed class_compat from i2c core, I asked Alex basically the
> > >>> same thing: whether class_compat support can be removed from vfio/mdev too.
> > >>>
> > >>> His reply:
> > >>> I'm afraid we have active userspace tools dependent on
> > >>> /sys/class/mdev_bus currently, libvirt for one.  We link mdev parent
> > >>> devices here and I believe it's the only way for userspace to find
> > >>> those parent devices registered for creating mdev devices.  If there's a
> > >>> desire to remove class_compat, we might need to add some mdev
> > >>> infrastructure to register the class ourselves to maintain the parent
> > >>> links.
> > >>>
> > >>>
> > >>> It's my understanding that /sys/class/mdev_bus has nothing in common
> > >>> with an actual class, it's just a container for devices which at least
> > >>> partially belong to other classes. And there's user space tools depending
> > >>> on this structure.    
> > >>
> > >> That's odd, when this was added, why was it added this way?  The
> > >> class_compat stuff is for when classes move around, yet this was always
> > >> done in this way?
> > >>
> > >> And what tools use this symlink today that can't be updated?  
> > > 
> > > It's been this way for 8 years, so it's hard to remember exact
> > > motivation for using this mechanism, whether we just didn't look hard
> > > enough at the class_compat or it didn't pass by the right set of eyes.
> > > Yes, it's always been this way for the mdev_bus class.
> > > 
> > > The intention here is much like other classes, that we have a node in
> > > sysfs where we can find devices that provide a common feature, in this
> > > case providing support for creating and managing vfio mediated devices
> > > (mdevs).  The perhaps unique part of this use case is that these devices
> > > aren't strictly mdev providers, they might also belong to another class
> > > and the mdev aspect of their behavior might be dynamically added after
> > > the device itself is added.
> > > 
> > > I've done some testing with this series and it does indeed seem to
> > > maintain compatibility with existing userspace tools, mdevctl and
> > > libvirt.  We can update these tools, but then we get into the breaking  
> > 
> > Greg, is this testing, done by Alex, sufficient for you to take the series?  
> 
> Were devices actually removed from the system and all worked well?

Creating and removing virtual mdev devices as well as unloading and
re-loading modules for the parent device providing the mdev support.

> > > userspace and deprecation period questions, where we may further delay
> > > removal of class_compat.  Also if we were to re-implement this, is there
> > > a better mechanism than proposed here within the class hierarchy, or
> > > would you recommend a non-class approach?  Thanks,
> > >   
> > 
> > You have /sys/bus/mdev. Couldn't we create a directory here which holds
> > the links to the devices in question?  
> 
> Links to devices is not what class links are for, so why is this in
> /sys/class/ at all?

Sorry, I'm confused.  I look in /sys/class/block and /sys/class/net and
I only see links to devices.  /sys/class/mdev_bus has links to devices
that have registered as supporting the mdev interface for creating
devices in /sys/bus/mdev.  We could link these devices somewhere else,
but there are existing projects, userspace scripts, and documentation
that references and relies on this layout.  Whatever we decide it
should have been 8 years ago is going to need yet another compatibility
interface/link to avoid breaking userspace.

> > Then user space would simply have to switch from /sys/class/mdev_bus
> > to /sys/bus/mdev/<new_dir>.  
>
> I think you are confusing what /sys/class/ is for here, if you have
> devices on a "bus" then they need to be in /sys/bus/   class has nothing
> to do with that.
> 
> So can we just drop the /sys/class/ mistake entirely?

Not without breaking userspace.  /sys/bus/mdev is used for enumerating
the virtual mdev devics that are created by devices supporting the mdev
interface, where the latter are enumerated in /sys/class/mdev_bus.
Thanks,

Alex



Return-Path: <kvm+bounces-33248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F449E7F76
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 11:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1627A282029
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 10:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC0D13D891;
	Sat,  7 Dec 2024 10:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEFQnimS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E4822C6E3
	for <kvm@vger.kernel.org>; Sat,  7 Dec 2024 10:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733565980; cv=none; b=kElWMxqCeX8cUA8eFMDg1X3lc2I4N6ech6OancLw87ABACLw10lr2Aj+nyZJjnUELngCLfxxK1Ksk9FxwPbVY802/4jDp8pKjaFoWzVQYq141eMwg1UhfqO5dMA3/HNxsmONgryAdJtdmkjd2w5WU1+H+mmqIOAt/ZPYVJx7dfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733565980; c=relaxed/simple;
	bh=FeU/ApypNKiF+3/8RNOqJE/58WX7oBwF7RDuH09nfys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r4XmVIh02hqo3A50veJlYZlBssmpiuTL91bxlKUhhYLbpakY87kuEVCEyqoDoklqyDAxEMJSkM8SreLV5SM2Ieie7vdpEI+YJhi9psosaKdUT1KcsqTcv37FrcR4FLjepoWpxeK7QnYp74lbrEsb1whEjdGigRwi5tRXlczxY+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEFQnimS; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9f1c590ecdso447809866b.1
        for <kvm@vger.kernel.org>; Sat, 07 Dec 2024 02:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733565977; x=1734170777; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=TwvxPr6OSsdEWvFF1O/TpNFYFfrCAViVsE1abZb4fN0=;
        b=HEFQnimSXItfBrBlcBiGdD/7sx9Tefb2fSFsc633zA0n4ni+Z834jEtrIUbOwvLTOO
         3+XIXaNJ4lpkQml+cvGzaGlt3AIsmip6LjPd3Qg3Fc7n9h1pBt8RUTLPtLd9tJXSsiVe
         pO9sn3BzJPxDipx/ApLy9bJsoW5CkxZ30AvKhzdZb1uK7bdHKU3xySj3seEI/1PBT6Yp
         wIDVlf+3CLrSQtlvSQ5KJeHEMm6O2lp2R5ZjQqCIs74i9LTRaQbSqPMzk1p8rAP+pa8b
         HtHzXlKZhqIbkR9WHnkUir2oVVjZMfHAEgtNKkAa8Azlxg2XWcbWquzfTVmGXA436Muh
         rvGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733565977; x=1734170777;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwvxPr6OSsdEWvFF1O/TpNFYFfrCAViVsE1abZb4fN0=;
        b=MNxHp3SXBX0C7USCkr7BpDtF4GYgtef67mNhCP2CN4NsYQri2HlrtxelLa1+a9kRcR
         S0qryoUe2Z82pIXsaCkCrzbJz9051Xq/2QU3+resuI/2UKEePuKCmQ0EvJeFaOzBhtQa
         RzItyD391cS6LuOWAmoXt8wrK3el5r8bDfzok2XnCJ3F9e9GN9W1lmhHmx6SaBg8CAq6
         4ioCor+bExI3xdVEV6INu9pa1/bRjpRNv60Nb88FdQt8r7bj0e1O6Hf22FxcjY4ihgg8
         pqiNeF+9lMOG9/zaawyGKZV+89aQDLExQzp4qHaEPnTip2lin6vbwBepEcyFlz6axj5E
         nR1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVItQryXR+98+MiGtQ0sPXUiKasN5VbB0EHq467gkjuV8Sdqg2Gk/7sqX+Wr86RSaXjo8E=@vger.kernel.org
X-Gm-Message-State: AOJu0YztZZqBU3+cc9S6PFfTCGCZxEI2e2JLP32USOYaH25DE6u3YICV
	qPDJb7It7m/PeeO9dh70GTbR2S6qm6SAxMTqUPoTzIU6laS7zFHUffGg6g==
X-Gm-Gg: ASbGncsMdqK2We5yTbAYuXSrB/tEQFh62AOFvKm4qbBkF6E7BvD9OUjf2BeUPaPvaXl
	3yBkkS0prX9e5LWd3ZlATtQsmYhRBJadNyqg9XiPYiAN2nJUl15XEGz14O3s1jHEJ7diL2q/5KW
	jVMaYjLNbMcaWrkS8neRU35AXoUBc/U9kc2XWx4bAvyBMy5Y14qITjYSCxpwk8QSKQEgwJmQkoA
	M6fj2UbFldBwUaq2eZh8qt6JAR4w7Y8lMXCvmX7QZ6NDG2XKOYT/GdIaJdZHrovClb7Q6rI4jio
	p3rKDcH1ylkPLeqEF6Rzr84n4h6UK8707QjK0/geGI6xgfr7O9bQsCNsnJe+lJIIJtPWwtRX2Uo
	kPnQHE2oPvEpb6EzAcZFIckbvhU7hOMmpxTTre8s=
X-Google-Smtp-Source: AGHT+IEHDvrOwJgL8GKrGtR74EF8VeZeNRHM7T/fjrw/RTC3lxyU++1Gth1vJlDPZa9bjengys6LTw==
X-Received: by 2002:a17:907:7f24:b0:a99:f6ee:1ee3 with SMTP id a640c23a62f3a-aa63a21b678mr582362266b.43.1733565976404;
        Sat, 07 Dec 2024 02:06:16 -0800 (PST)
Received: from ?IPV6:2a02:3100:a9f3:900:e8bd:d32d:8176:c56e? (dynamic-2a02-3100-a9f3-0900-e8bd-d32d-8176-c56e.310.pool.telefonica.de. [2a02:3100:a9f3:900:e8bd:d32d:8176:c56e])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-aa6260e84bfsm366355266b.189.2024.12.07.02.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Dec 2024 02:06:15 -0800 (PST)
Message-ID: <4b9781d5-5cbc-4254-9753-014cf5a8438d@gmail.com>
Date: Sat, 7 Dec 2024 11:06:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
 Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
 <0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
 <2024120430-boneless-wafer-bf0c@gregkh>
 <fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
 <2024120410-promoter-blandness-efa1@gregkh>
 <20241204123040.7e3483a4.alex.williamson@redhat.com>
 <9015ce52-e4f3-459c-bd74-b8707cf8fd88@gmail.com>
 <2024120617-icon-bagel-86b3@gregkh>
 <20241206093733.1d887dfc.alex.williamson@redhat.com>
 <2024120721-parasite-thespian-84e0@gregkh>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
Autocrypt: addr=hkallweit1@gmail.com; keydata=
 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
In-Reply-To: <2024120721-parasite-thespian-84e0@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07.12.2024 09:38, Greg Kroah-Hartman wrote:
> On Fri, Dec 06, 2024 at 09:37:33AM -0700, Alex Williamson wrote:
>> On Fri, 6 Dec 2024 08:42:02 +0100
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>
>>> On Fri, Dec 06, 2024 at 08:35:47AM +0100, Heiner Kallweit wrote:
>>>> On 04.12.2024 20:30, Alex Williamson wrote:  
>>>>> On Wed, 4 Dec 2024 19:16:03 +0100
>>>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>>>   
>>>>>> On Wed, Dec 04, 2024 at 06:01:36PM +0100, Heiner Kallweit wrote:  
>>>>>>> On 04.12.2024 10:32, Greg Kroah-Hartman wrote:    
>>>>>>>> On Tue, Dec 03, 2024 at 09:11:47PM +0100, Heiner Kallweit wrote:    
>>>>>>>>> vfio/mdev is the last user of class_compat, and it doesn't use it for
>>>>>>>>> the intended purpose. See kdoc of class_compat_register():
>>>>>>>>> Compatibility class are meant as a temporary user-space compatibility
>>>>>>>>> workaround when converting a family of class devices to a bus devices.    
>>>>>>>>
>>>>>>>> True, so waht is mdev doing here?
>>>>>>>>     
>>>>>>>>> In addition it uses only a part of the class_compat functionality.
>>>>>>>>> So inline the needed functionality, and afterwards all class_compat
>>>>>>>>> code can be removed.
>>>>>>>>>
>>>>>>>>> No functional change intended. Compile-tested only.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>>>>>>> ---
>>>>>>>>>  drivers/vfio/mdev/mdev_core.c | 12 ++++++------
>>>>>>>>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>>>>>>>>> index ed4737de4..a22c49804 100644
>>>>>>>>> --- a/drivers/vfio/mdev/mdev_core.c
>>>>>>>>> +++ b/drivers/vfio/mdev/mdev_core.c
>>>>>>>>> @@ -18,7 +18,7 @@
>>>>>>>>>  #define DRIVER_AUTHOR		"NVIDIA Corporation"
>>>>>>>>>  #define DRIVER_DESC		"Mediated device Core Driver"
>>>>>>>>>  
>>>>>>>>> -static struct class_compat *mdev_bus_compat_class;
>>>>>>>>> +static struct kobject *mdev_bus_kobj;    
>>>>>>>>
>>>>>>>>
>>>>>>>>     
>>>>>>>>>  
>>>>>>>>>  static LIST_HEAD(mdev_list);
>>>>>>>>>  static DEFINE_MUTEX(mdev_list_lock);
>>>>>>>>> @@ -76,7 +76,7 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>>>>>>>>>  	if (ret)
>>>>>>>>>  		return ret;
>>>>>>>>>  
>>>>>>>>> -	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
>>>>>>>>> +	ret = sysfs_create_link(mdev_bus_kobj, &dev->kobj, dev_name(dev));    
>>>>>>>>
>>>>>>>> This feels really wrong, why create a link to a random kobject?  Who is
>>>>>>>> using this kobject link?
>>>>>>>>     
>>>>>>>>>  	if (ret)
>>>>>>>>>  		dev_warn(dev, "Failed to create compatibility class link\n");
>>>>>>>>>  
>>>>>>>>> @@ -98,7 +98,7 @@ void mdev_unregister_parent(struct mdev_parent *parent)
>>>>>>>>>  	dev_info(parent->dev, "MDEV: Unregistering\n");
>>>>>>>>>  
>>>>>>>>>  	down_write(&parent->unreg_sem);
>>>>>>>>> -	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
>>>>>>>>> +	sysfs_remove_link(mdev_bus_kobj, dev_name(parent->dev));
>>>>>>>>>  	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
>>>>>>>>>  	parent_remove_sysfs_files(parent);
>>>>>>>>>  	up_write(&parent->unreg_sem);
>>>>>>>>> @@ -251,8 +251,8 @@ static int __init mdev_init(void)
>>>>>>>>>  	if (ret)
>>>>>>>>>  		return ret;
>>>>>>>>>  
>>>>>>>>> -	mdev_bus_compat_class = class_compat_register("mdev_bus");
>>>>>>>>> -	if (!mdev_bus_compat_class) {
>>>>>>>>> +	mdev_bus_kobj = class_pseudo_register("mdev_bus");    
>>>>>>>>
>>>>>>>> But this isn't a class, so let's not fake it please.  Let's fix this
>>>>>>>> properly, odds are all of this code can just be removed entirely, right?
>>>>>>>>     
>>>>>>>
>>>>>>> After I removed class_compat from i2c core, I asked Alex basically the
>>>>>>> same thing: whether class_compat support can be removed from vfio/mdev too.
>>>>>>>
>>>>>>> His reply:
>>>>>>> I'm afraid we have active userspace tools dependent on
>>>>>>> /sys/class/mdev_bus currently, libvirt for one.  We link mdev parent
>>>>>>> devices here and I believe it's the only way for userspace to find
>>>>>>> those parent devices registered for creating mdev devices.  If there's a
>>>>>>> desire to remove class_compat, we might need to add some mdev
>>>>>>> infrastructure to register the class ourselves to maintain the parent
>>>>>>> links.
>>>>>>>
>>>>>>>
>>>>>>> It's my understanding that /sys/class/mdev_bus has nothing in common
>>>>>>> with an actual class, it's just a container for devices which at least
>>>>>>> partially belong to other classes. And there's user space tools depending
>>>>>>> on this structure.    
>>>>>>
>>>>>> That's odd, when this was added, why was it added this way?  The
>>>>>> class_compat stuff is for when classes move around, yet this was always
>>>>>> done in this way?
>>>>>>
>>>>>> And what tools use this symlink today that can't be updated?  
>>>>>
>>>>> It's been this way for 8 years, so it's hard to remember exact
>>>>> motivation for using this mechanism, whether we just didn't look hard
>>>>> enough at the class_compat or it didn't pass by the right set of eyes.
>>>>> Yes, it's always been this way for the mdev_bus class.
>>>>>
>>>>> The intention here is much like other classes, that we have a node in
>>>>> sysfs where we can find devices that provide a common feature, in this
>>>>> case providing support for creating and managing vfio mediated devices
>>>>> (mdevs).  The perhaps unique part of this use case is that these devices
>>>>> aren't strictly mdev providers, they might also belong to another class
>>>>> and the mdev aspect of their behavior might be dynamically added after
>>>>> the device itself is added.
>>>>>
>>>>> I've done some testing with this series and it does indeed seem to
>>>>> maintain compatibility with existing userspace tools, mdevctl and
>>>>> libvirt.  We can update these tools, but then we get into the breaking  
>>>>
>>>> Greg, is this testing, done by Alex, sufficient for you to take the series?  
>>>
>>> Were devices actually removed from the system and all worked well?
>>
>> Creating and removing virtual mdev devices as well as unloading and
>> re-loading modules for the parent device providing the mdev support.
>>
>>>>> userspace and deprecation period questions, where we may further delay
>>>>> removal of class_compat.  Also if we were to re-implement this, is there
>>>>> a better mechanism than proposed here within the class hierarchy, or
>>>>> would you recommend a non-class approach?  Thanks,
>>>>>   
>>>>
>>>> You have /sys/bus/mdev. Couldn't we create a directory here which holds
>>>> the links to the devices in question?  
>>>
>>> Links to devices is not what class links are for, so why is this in
>>> /sys/class/ at all?
>>
>> Sorry, I'm confused.  I look in /sys/class/block and /sys/class/net and
>> I only see links to devices.
> 
> Yes, they are linking to "class devices", i.e. things controlled by that
> class, NOT just a driver bound to a device on a bus.
> 
>> /sys/class/mdev_bus has links to devices
>> that have registered as supporting the mdev interface for creating
>> devices in /sys/bus/mdev.
> 
> And that's the issue here, drivers binding to a device on a bus are NOT
> class devices, they are bus devices (i.e. on the bus.)
> 
> This used to be much "clearer" when we had "struct class_device" but we
> unified that a long time ago and now only have "struct device".
> 
> In short, a bus device is the thing that is on a "bus" that a driver
> binds to (i.e. controls the hardware).  A class device is the thing that
> a user talks to in a standardized way (input, block, tty, network, etc.)
> that is INDEPENDENT of the hardware bus the device happens to be
> attached to.
> 
>> We could link these devices somewhere else,
>> but there are existing projects, userspace scripts, and documentation
>> that references and relies on this layout.  Whatever we decide it
>> should have been 8 years ago is going to need yet another compatibility
>> interface/link to avoid breaking userspace.
> 
> What you did here is say "mdev is both a standard interface to talk to
> userspace AND a standard bus", when really you should have made a mdev
> class if you really wanted one.  Why not just do that now instead?
> Nothing should be preventing that and then your bus code can be the same
> too.
> 
>>>> Then user space would simply have to switch from /sys/class/mdev_bus
>>>> to /sys/bus/mdev/<new_dir>.  
>>>
>>> I think you are confusing what /sys/class/ is for here, if you have
>>> devices on a "bus" then they need to be in /sys/bus/   class has nothing
>>> to do with that.
>>>
>>> So can we just drop the /sys/class/ mistake entirely?
>>
>> Not without breaking userspace.  /sys/bus/mdev is used for enumerating
>> the virtual mdev devics that are created by devices supporting the mdev
>> interface, where the latter are enumerated in /sys/class/mdev_bus.
> 
> Great, how about creating a mdev_bus "struct class" then and doing this
> properly?  That would be the correct solution overall, not this
> overloading of a symlink that causes confusion.
> 
Issue with this approach is that these "mdev parent" devices are partially
class devices belonging to other classes. See for example mtty_dev_init(),
there the device passed to us belongs to class mtty.

Here in mdev two types of devices are handled:
1. The "mdev parent" devices, which are linked to /sys/class/mdev_bus.
   These devices can be class devices of other classes.
2. The mdev devices, these are normal bus devices residing under /sys/bus/mdev.


> thanks,
> 
> greg k-h



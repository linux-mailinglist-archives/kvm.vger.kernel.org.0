Return-Path: <kvm+bounces-33222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEB9A9E76A6
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 18:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A0212823E3
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 17:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09A81F3D27;
	Fri,  6 Dec 2024 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FyJ+2//U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4552C206274
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733504752; cv=none; b=DNOPt1OXmvvQqzEvriWAAqBlThYt0cPx7XgU3vZNT9M4SJCsgkXE/6xJQqwXWFKVySNOgdufjI4WDO1wVzaJE0eGc94SWCMoX+PnPdW/NrKDRRwdSigpz61W3mKm+rkjjl8l3q3KW1Dx/nnyTgORSbhtytQMnKIjA3JNyDYzCU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733504752; c=relaxed/simple;
	bh=LrEeA8buT5B3dyLTC5xvcAWLINKeSBmP5N9WHdvVtto=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XBqaInYKkOa3hheUvDtomfccJ5laqgCkEtRCxWprQTRwcaxXJSQPwtrpBnlItmdXU1/X9Wx9/OJJvxYahx8IY2Bh3WSrtqAHrocQJgGXuUV966murRxfPycczBLE3Cxmr7RqurNuZbayOCQvzXXqi34C2Qb8JJh0Iu7VntAXcuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FyJ+2//U; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aa549d9dffdso330125366b.2
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2024 09:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733504748; x=1734109548; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=A3+hzYikzO9/tmleapvfxrBnpcUELQXPUucbIIUU6XM=;
        b=FyJ+2//UfGPLFRTx3rZ85Z03GD6c20puc83nykpcNU90MJ6BjaztLjmBcmOWJlLdf7
         D2+hE95XzCcF2xc2NV6XkU00R9Qy0JPyBGWGSAbA4Y5+LTxqdXEG0jEao5xF79e1f6iV
         5RUPaXhuGt+2/VzNTsB1D/iy1pSXv/VomD9mvT3Yr7RnbmLZfiPofgd1Fqxziun2K/ai
         LSBic0tnB2/lceCx99GDJ3ip/o15U4RppOdPQ4aFhqKJnr44FQ21CiH9j7L/0J+rBmzJ
         aEoD7GoFpqEaH6o3uUV9WEL8vRcdfRItVfMSCxapLydz1fW28B1LJpKl02DFwgTqhwsp
         NNHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733504748; x=1734109548;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A3+hzYikzO9/tmleapvfxrBnpcUELQXPUucbIIUU6XM=;
        b=A0si/eRu3PZ8JCzllV166nY+/jkVJaTOv3QKcVzL/n21HOCely9K60zhGOtyx+9lNi
         QJMsaXuy6a9FknNIMF2JTOg0UXGkE8b1QaaVN9TB/RsO2oAcA4d7HAURwql6mVB/CIkx
         EEnJcnai/JALSsGJCeJIi6gbP85L6iCpL2xD2zXvbUWYFHUD0bI3+OlXWE6yEdCct5rr
         B2R64XMjfEA/tCH7xyNU9nSAzWVCxYPNyyupN7i3IrIiElUOZsu0b+5J7dvQ9GbznKKv
         TYHlfQ5JCJ/rdNloXXzv1FA9hcdVRUfc+HQ7XgJoP/I+pKX3bn0LywdyQqZFVMAhbzmI
         LYlg==
X-Forwarded-Encrypted: i=1; AJvYcCVhPAfQ5evpY5Z49lnJGXpW8urTL2iswXgnwmqHEu1hmY7G6+vSmoz5q0RtHgZ5kOwjTFA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKD1qbrkPyMlneqJOFhm5EVNdO1mhFfI0KyvyFZe8RbBYWCppn
	TgS8yNjcq3eSLKBMOTTlCbCxd/Kn+f4Us9kTdA8COPsH/jpFK7Bh3mkE6A==
X-Gm-Gg: ASbGncu85LIYFemFwsloaU0CXHzLxxfxqLUpfqaWzI7Y3VuJm0XvGhm2YuNhmuVJkTs
	h3ddsNNtUt302Rdv7QPw82BpZHdKd8rHuJfvSJNn0Zt2jW/KR6wbGEsfzZUNaTcE/YsH2klOShC
	zS5CA+jtYqQPFX6qCEX433Va4uwD7rAht4Eq75LQIli9NBmuL3Wzfp2RAsjSr/Vz1SdV4Dvc+KW
	fh3VMJFriUvpvasf0Dzl7vcnLbjuDPjmhtdJ8PQVbrSa1A8b4iF3Mer9ufgojMjsd0qJ1IAmfbB
	LGpka0awo4pP4cIXVG8ubnggqXeeSpXGrKOu1EbjWDn1iKH2WY12hk5A3JXQOKLGYycoctusahK
	qb2QCXDvFLadh+AdoixAnpZdgdoZ4g4uijguF3HeyjQ==
X-Google-Smtp-Source: AGHT+IEWJqdYJaERl8gYM4EgAAKh2a6ISHsxei7XXMubgfzXOtVs/LxlKHofEZlml3jPBUgfBb6sHw==
X-Received: by 2002:a17:906:311a:b0:aa1:f9dc:f9bf with SMTP id a640c23a62f3a-aa639fa5cb7mr279791566b.10.1733504748030;
        Fri, 06 Dec 2024 09:05:48 -0800 (PST)
Received: from ?IPV6:2a02:3100:9c83:d900:bd98:d989:87e8:f429? (dynamic-2a02-3100-9c83-d900-bd98-d989-87e8-f429.310.pool.telefonica.de. [2a02:3100:9c83:d900:bd98:d989:87e8:f429])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-aa6260ebabesm264847466b.196.2024.12.06.09.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 09:05:46 -0800 (PST)
Message-ID: <48b592ee-dff6-4ced-b8c9-67ebe8da5886@gmail.com>
Date: Fri, 6 Dec 2024 18:05:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
 <0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
 <2024120430-boneless-wafer-bf0c@gregkh>
 <fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
 <2024120410-promoter-blandness-efa1@gregkh>
 <20241204123040.7e3483a4.alex.williamson@redhat.com>
 <9015ce52-e4f3-459c-bd74-b8707cf8fd88@gmail.com>
 <2024120617-icon-bagel-86b3@gregkh>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
Autocrypt: addr=hkallweit1@gmail.com; keydata=
 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
In-Reply-To: <2024120617-icon-bagel-86b3@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06.12.2024 08:42, Greg Kroah-Hartman wrote:
> On Fri, Dec 06, 2024 at 08:35:47AM +0100, Heiner Kallweit wrote:
>> On 04.12.2024 20:30, Alex Williamson wrote:
>>> On Wed, 4 Dec 2024 19:16:03 +0100
>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>
>>>> On Wed, Dec 04, 2024 at 06:01:36PM +0100, Heiner Kallweit wrote:
>>>>> On 04.12.2024 10:32, Greg Kroah-Hartman wrote:  
>>>>>> On Tue, Dec 03, 2024 at 09:11:47PM +0100, Heiner Kallweit wrote:  
>>>>>>> vfio/mdev is the last user of class_compat, and it doesn't use it for
>>>>>>> the intended purpose. See kdoc of class_compat_register():
>>>>>>> Compatibility class are meant as a temporary user-space compatibility
>>>>>>> workaround when converting a family of class devices to a bus devices.  
>>>>>>
>>>>>> True, so waht is mdev doing here?
>>>>>>   
>>>>>>> In addition it uses only a part of the class_compat functionality.
>>>>>>> So inline the needed functionality, and afterwards all class_compat
>>>>>>> code can be removed.
>>>>>>>
>>>>>>> No functional change intended. Compile-tested only.
>>>>>>>
>>>>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>>>>> ---
>>>>>>>  drivers/vfio/mdev/mdev_core.c | 12 ++++++------
>>>>>>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>>>>>>> index ed4737de4..a22c49804 100644
>>>>>>> --- a/drivers/vfio/mdev/mdev_core.c
>>>>>>> +++ b/drivers/vfio/mdev/mdev_core.c
>>>>>>> @@ -18,7 +18,7 @@
>>>>>>>  #define DRIVER_AUTHOR		"NVIDIA Corporation"
>>>>>>>  #define DRIVER_DESC		"Mediated device Core Driver"
>>>>>>>  
>>>>>>> -static struct class_compat *mdev_bus_compat_class;
>>>>>>> +static struct kobject *mdev_bus_kobj;  
>>>>>>
>>>>>>
>>>>>>   
>>>>>>>  
>>>>>>>  static LIST_HEAD(mdev_list);
>>>>>>>  static DEFINE_MUTEX(mdev_list_lock);
>>>>>>> @@ -76,7 +76,7 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>>>>>>>  	if (ret)
>>>>>>>  		return ret;
>>>>>>>  
>>>>>>> -	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
>>>>>>> +	ret = sysfs_create_link(mdev_bus_kobj, &dev->kobj, dev_name(dev));  
>>>>>>
>>>>>> This feels really wrong, why create a link to a random kobject?  Who is
>>>>>> using this kobject link?
>>>>>>   
>>>>>>>  	if (ret)
>>>>>>>  		dev_warn(dev, "Failed to create compatibility class link\n");
>>>>>>>  
>>>>>>> @@ -98,7 +98,7 @@ void mdev_unregister_parent(struct mdev_parent *parent)
>>>>>>>  	dev_info(parent->dev, "MDEV: Unregistering\n");
>>>>>>>  
>>>>>>>  	down_write(&parent->unreg_sem);
>>>>>>> -	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
>>>>>>> +	sysfs_remove_link(mdev_bus_kobj, dev_name(parent->dev));
>>>>>>>  	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
>>>>>>>  	parent_remove_sysfs_files(parent);
>>>>>>>  	up_write(&parent->unreg_sem);
>>>>>>> @@ -251,8 +251,8 @@ static int __init mdev_init(void)
>>>>>>>  	if (ret)
>>>>>>>  		return ret;
>>>>>>>  
>>>>>>> -	mdev_bus_compat_class = class_compat_register("mdev_bus");
>>>>>>> -	if (!mdev_bus_compat_class) {
>>>>>>> +	mdev_bus_kobj = class_pseudo_register("mdev_bus");  
>>>>>>
>>>>>> But this isn't a class, so let's not fake it please.  Let's fix this
>>>>>> properly, odds are all of this code can just be removed entirely, right?
>>>>>>   
>>>>>
>>>>> After I removed class_compat from i2c core, I asked Alex basically the
>>>>> same thing: whether class_compat support can be removed from vfio/mdev too.
>>>>>
>>>>> His reply:
>>>>> I'm afraid we have active userspace tools dependent on
>>>>> /sys/class/mdev_bus currently, libvirt for one.  We link mdev parent
>>>>> devices here and I believe it's the only way for userspace to find
>>>>> those parent devices registered for creating mdev devices.  If there's a
>>>>> desire to remove class_compat, we might need to add some mdev
>>>>> infrastructure to register the class ourselves to maintain the parent
>>>>> links.
>>>>>
>>>>>
>>>>> It's my understanding that /sys/class/mdev_bus has nothing in common
>>>>> with an actual class, it's just a container for devices which at least
>>>>> partially belong to other classes. And there's user space tools depending
>>>>> on this structure.  
>>>>
>>>> That's odd, when this was added, why was it added this way?  The
>>>> class_compat stuff is for when classes move around, yet this was always
>>>> done in this way?
>>>>
>>>> And what tools use this symlink today that can't be updated?
>>>
>>> It's been this way for 8 years, so it's hard to remember exact
>>> motivation for using this mechanism, whether we just didn't look hard
>>> enough at the class_compat or it didn't pass by the right set of eyes.
>>> Yes, it's always been this way for the mdev_bus class.
>>>
>>> The intention here is much like other classes, that we have a node in
>>> sysfs where we can find devices that provide a common feature, in this
>>> case providing support for creating and managing vfio mediated devices
>>> (mdevs).  The perhaps unique part of this use case is that these devices
>>> aren't strictly mdev providers, they might also belong to another class
>>> and the mdev aspect of their behavior might be dynamically added after
>>> the device itself is added.
>>>
>>> I've done some testing with this series and it does indeed seem to
>>> maintain compatibility with existing userspace tools, mdevctl and
>>> libvirt.  We can update these tools, but then we get into the breaking
>>
>> Greg, is this testing, done by Alex, sufficient for you to take the series?
> 
> Were devices actually removed from the system and all worked well?
> 
>>> userspace and deprecation period questions, where we may further delay
>>> removal of class_compat.  Also if we were to re-implement this, is there
>>> a better mechanism than proposed here within the class hierarchy, or
>>> would you recommend a non-class approach?  Thanks,
>>>
>>
>> You have /sys/bus/mdev. Couldn't we create a directory here which holds
>> the links to the devices in question?
> 
> Links to devices is not what class links are for, so why is this in
> /sys/class/ at all?
> 
Complementing what Alex just wrote:
It's my understanding that it's in /sys/class only, because back then, when
the mdev driver was written, class_compat seemed to be a convenient way
to achieve what was required: providing a generic container in sysfs for
arbitrary device links. So it wasn't an informed decision to use /sys/class.


>> Then user space would simply have to switch from /sys/class/mdev_bus
>> to /sys/bus/mdev/<new_dir>.
> 
> I think you are confusing what /sys/class/ is for here, if you have
> devices on a "bus" then they need to be in /sys/bus/   class has nothing
> to do with that.
> 
> So can we just drop the /sys/class/ mistake entirely?
> 
> thanks,
> 
> greg k-h



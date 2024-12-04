Return-Path: <kvm+bounces-33082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BCDB9E44B1
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:35:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAB001655EC
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB751C3C13;
	Wed,  4 Dec 2024 19:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+KGEU9d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7480E13D246
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 19:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733340913; cv=none; b=W0oHvl/0ZX7kgB3iidcUgTf2K7npx7zbjoQ8gBZqB3AVxNVBRVAeChKtP/nDKVDrRhZuwOnIsrxeNT//xt/sYJSQFJtfE8OyuJys4+swnzG0ZA94j3ij+07p9O1gXZ2z2GKi9o6R5bXBgq24ncLJce6POdl4bVIEEMLz6JG4oX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733340913; c=relaxed/simple;
	bh=yYiyOsqejGt8o4LHv7obH56BDK/q1UVsYKBJuyJwOAI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PGzB12wzSG9u0ceyU6usrYsUD4vY++IzH7Cn+Hcgp1vjozFDjw7Q6s+bYn85V/zIWZezpuYKWfksUpijUl88RzLNlI9AVVY/96oAoH2TJZct6ez9mNBJmAUpTjtAkBLRMlsiy05dFmN//pRGr+P/0M646hXug3Ef9zhmPsLVabQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q+KGEU9d; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aa5325af6a0so10436266b.2
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 11:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733340910; x=1733945710; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=M9AOdFldgYAIjGRurHNc/sx0kO7rIlxuapvHn9CwJA0=;
        b=Q+KGEU9dnCHeW4jCeknevXDBrqgxN+mqcrE2NHoaH41+HT0Iu5OYooqx6h+RQXZVDM
         KvlgFr9rklzM+CYmNN8S5pqrIGyqD0sgWuQ/40ts13AVCmIF+EQhr20hMY+37/5rryJT
         3lnMUWqqCkb28RlT0yO9Wuxng5qo72sXzWD7HErrQ/FCNJNqgLv299fmLeFszaF6cuVV
         BFfIW/tZc8pEmvrfN+PBKF85SldrIzgMhBUlqfoCTtvo/7sF1/fE4GwqrnU/0RTN87AE
         x1UEZz5QQQp4ca5y88zpZByUuoydxyGEqy+pesyqtzOWbKzoRI63Qk+BCbgYPhElVkPZ
         gBIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733340910; x=1733945710;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9AOdFldgYAIjGRurHNc/sx0kO7rIlxuapvHn9CwJA0=;
        b=FlU2swghJi5ys7w/7+9/AYagb6tPbqlT1QfAl9f3GvXAb5Sr2Z4QSDfI4cIrCU1rIQ
         Lg2UrgogbG6LvEA+cH/oG0oqOik9/GPihO/BVurZFowpjU690HycC5WXX7LJ7Xw3hvTD
         X/pH8PPZXcG8phJkY80hXvMBeieZSE8bb9+nesK+0Oe1yq+2Hn6LhWILJQ5vIquqstuJ
         2KVGZkuemPG5hERCmKQ8fSK2ZSph0W7DGeQgECZpEAwMqfifQBei7Sll5pgMQ03LhPYG
         tgaGXmk4Ts+cc1pEzjrmeMeoC1J3ziSiSILkplTXqx99NEBAt6d+Dy4CwpPPeZ5pxnQ5
         z1Qw==
X-Forwarded-Encrypted: i=1; AJvYcCXMiWLd+9/68KsTglfqAFlzW6hjxOZL+TQlsLlwYXKisPaQP2Z4kuXhtlfvwBINvuSovBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNwzkObw0taRklgexV50zNjXv8FLdxoAAVNT3HipLz9cZWbfs8
	jd4g9vX2FkBEgASqi7gJL7AjGTPriju5rpI2XLHkDkvHa2t8Zaes
X-Gm-Gg: ASbGnctpo/+/+dbrOPWLqLHQHhBFw4GWHqEUZT9rsSioexvLY7bSXjnD5MHIsPuXivz
	WG0iki6ChMiyy3pu8Qq1/P0/GYK3LdA+e3m4DJSlsfOXJ4k1vedS1/rVftmPXyvjMdnqLdwwht1
	M2L14r3N2VYifiZm8ihN/7IqdInAvmsfS+dJ21f4TgpEtwYXFw2g2mtTBliwlRZxkscIf+4joZO
	rjzekclKk2+J7br4SrDBDpMeX0m6DxqP9cTLwnOKv1wZYfEEQYNqDcJaheMNrDHynO7T8V3wsaC
	yhf+FiZc7SaFiJ3EdwyGN4dXfX8AbYLJozzsozaXN1YTeAykwEkyldsBzUJM0PkJf9iIlW7+1ZF
	uxPzfjT2aKnKyqvIGYbB/Wk2mDbgNnC7siirGQWk=
X-Google-Smtp-Source: AGHT+IEi7nq0vZmxSepp57BPIk2OvRSnv8PwuTygCTSjouZ0iDmgoQFbvOZtDB9VDLnshr3oSLeUjw==
X-Received: by 2002:a17:907:da6:b0:aa4:a3be:28dd with SMTP id a640c23a62f3a-aa5f7f2ac81mr814271066b.55.1733340909608;
        Wed, 04 Dec 2024 11:35:09 -0800 (PST)
Received: from ?IPV6:2a02:3100:b3a6:dc00:4df6:7a00:cfe0:a99? (dynamic-2a02-3100-b3a6-dc00-4df6-7a00-cfe0-0a99.310.pool.telefonica.de. [2a02:3100:b3a6:dc00:4df6:7a00:cfe0:a99])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-aa5999058fbsm763085166b.143.2024.12.04.11.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 11:35:09 -0800 (PST)
Message-ID: <45340112-3184-4be1-89a5-522e932c751e@gmail.com>
Date: Wed, 4 Dec 2024 20:35:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Kirti Wankhede <kwankhede@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, kvm@vger.kernel.org
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
 <0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
 <2024120430-boneless-wafer-bf0c@gregkh>
 <fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
 <2024120410-promoter-blandness-efa1@gregkh>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
Autocrypt: addr=hkallweit1@gmail.com; keydata=
 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
In-Reply-To: <2024120410-promoter-blandness-efa1@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04.12.2024 19:16, Greg Kroah-Hartman wrote:
> On Wed, Dec 04, 2024 at 06:01:36PM +0100, Heiner Kallweit wrote:
>> On 04.12.2024 10:32, Greg Kroah-Hartman wrote:
>>> On Tue, Dec 03, 2024 at 09:11:47PM +0100, Heiner Kallweit wrote:
>>>> vfio/mdev is the last user of class_compat, and it doesn't use it for
>>>> the intended purpose. See kdoc of class_compat_register():
>>>> Compatibility class are meant as a temporary user-space compatibility
>>>> workaround when converting a family of class devices to a bus devices.
>>>
>>> True, so waht is mdev doing here?
>>>
>>>> In addition it uses only a part of the class_compat functionality.
>>>> So inline the needed functionality, and afterwards all class_compat
>>>> code can be removed.
>>>>
>>>> No functional change intended. Compile-tested only.
>>>>
>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>> ---
>>>>  drivers/vfio/mdev/mdev_core.c | 12 ++++++------
>>>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>>>> index ed4737de4..a22c49804 100644
>>>> --- a/drivers/vfio/mdev/mdev_core.c
>>>> +++ b/drivers/vfio/mdev/mdev_core.c
>>>> @@ -18,7 +18,7 @@
>>>>  #define DRIVER_AUTHOR		"NVIDIA Corporation"
>>>>  #define DRIVER_DESC		"Mediated device Core Driver"
>>>>  
>>>> -static struct class_compat *mdev_bus_compat_class;
>>>> +static struct kobject *mdev_bus_kobj;
>>>
>>>
>>>
>>>>  
>>>>  static LIST_HEAD(mdev_list);
>>>>  static DEFINE_MUTEX(mdev_list_lock);
>>>> @@ -76,7 +76,7 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>>>>  	if (ret)
>>>>  		return ret;
>>>>  
>>>> -	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
>>>> +	ret = sysfs_create_link(mdev_bus_kobj, &dev->kobj, dev_name(dev));
>>>
>>> This feels really wrong, why create a link to a random kobject?  Who is
>>> using this kobject link?
>>>
>>>>  	if (ret)
>>>>  		dev_warn(dev, "Failed to create compatibility class link\n");
>>>>  
>>>> @@ -98,7 +98,7 @@ void mdev_unregister_parent(struct mdev_parent *parent)
>>>>  	dev_info(parent->dev, "MDEV: Unregistering\n");
>>>>  
>>>>  	down_write(&parent->unreg_sem);
>>>> -	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
>>>> +	sysfs_remove_link(mdev_bus_kobj, dev_name(parent->dev));
>>>>  	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
>>>>  	parent_remove_sysfs_files(parent);
>>>>  	up_write(&parent->unreg_sem);
>>>> @@ -251,8 +251,8 @@ static int __init mdev_init(void)
>>>>  	if (ret)
>>>>  		return ret;
>>>>  
>>>> -	mdev_bus_compat_class = class_compat_register("mdev_bus");
>>>> -	if (!mdev_bus_compat_class) {
>>>> +	mdev_bus_kobj = class_pseudo_register("mdev_bus");
>>>
>>> But this isn't a class, so let's not fake it please.  Let's fix this
>>> properly, odds are all of this code can just be removed entirely, right?
>>>
>>
>> After I removed class_compat from i2c core, I asked Alex basically the
>> same thing: whether class_compat support can be removed from vfio/mdev too.
>>
>> His reply:
>> I'm afraid we have active userspace tools dependent on
>> /sys/class/mdev_bus currently, libvirt for one.  We link mdev parent
>> devices here and I believe it's the only way for userspace to find
>> those parent devices registered for creating mdev devices.  If there's a
>> desire to remove class_compat, we might need to add some mdev
>> infrastructure to register the class ourselves to maintain the parent
>> links.
>>
>>
>> It's my understanding that /sys/class/mdev_bus has nothing in common
>> with an actual class, it's just a container for devices which at least
>> partially belong to other classes. And there's user space tools depending
>> on this structure.
> 
> That's odd, when this was added, why was it added this way?  The
> class_compat stuff is for when classes move around, yet this was always
> done in this way?
> 
I can only answer the when: in 2016, with the initial version of vfio/mdev
Kirti is the author, maybe she can provide some background.

> And what tools use this symlink today that can't be updated?
>
According to Alex: libvirt, not clear whether there are more users of the
                   current sysfs structure
I'm just the messenger here and can't comment on whether/how/who updating
user space.

> thanks,
> 
> greg k-h



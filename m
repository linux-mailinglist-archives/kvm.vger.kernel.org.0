Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5C05844A
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 16:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfF0OMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 10:12:43 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6121 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0OMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 10:12:43 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d14ced80001>; Thu, 27 Jun 2019 07:12:40 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Jun 2019 07:12:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Jun 2019 07:12:42 -0700
Received: from [10.24.71.89] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Jun
 2019 14:12:40 +0000
Subject: Re: [PATCH] mdev: Send uevents around parent device registration
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <156155924767.11505.11457229921502145577.stgit@gimli.home>
 <1ea5c171-cd42-1c10-966e-1b82a27351d9@nvidia.com>
 <20190626120551.788fa5ed@x1.home>
 <a6c2ec9e-b949-4346-13bc-4d7f9c35ea8b@nvidia.com>
 <20190627102107.3c7715d9.cohuck@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <107cbedf-6c66-a666-d26a-5842d8c24e83@nvidia.com>
Date:   Thu, 27 Jun 2019 19:42:32 +0530
MIME-Version: 1.0
In-Reply-To: <20190627102107.3c7715d9.cohuck@redhat.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL106.nvidia.com (172.18.146.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1561644760; bh=6NTgqdYmKUB0FuZ5KaLEDAzxkpV0k5+bVycHJQIZ0K8=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=jNQff2XdzD/1HxLc4NTYRxK1C4wixFSImTAkzyA3LhMuRyD7AIcG9zF2MuDQTc+9G
         O9En6hfpBf6Unv7uR/gGIZswozNhEP4BpUymnTcMhEvmDFL6eljPkj4rN5Q9U5PLH6
         0rVlnZgR80zyKVfCkmxR9m5KmKl3BhM/S5I9cGVc81JRH354FoOE1/FGUqVyRxDPCq
         1GNPpbHAh/XW9DLQAYtJog2SmLWq40TSAuqmZv7J5cBTtv0qSN5GdZ4FpOefyiO/XC
         g7NqYFNADieFlmgDzBdLBJLLOVrmLDPMjgdEIQNhm+2b9T2YdeRmoiFepYEw8mMQH0
         0Z3TTMZZ2JzIw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/27/2019 1:51 PM, Cornelia Huck wrote:
> On Thu, 27 Jun 2019 00:33:59 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 6/26/2019 11:35 PM, Alex Williamson wrote:
>>> On Wed, 26 Jun 2019 23:23:00 +0530
>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>   
>>>> On 6/26/2019 7:57 PM, Alex Williamson wrote:  
>>>>> This allows udev to trigger rules when a parent device is registered
>>>>> or unregistered from mdev.
>>>>>
>>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>>>> ---
>>>>>  drivers/vfio/mdev/mdev_core.c |   10 ++++++++--
>>>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>>>>> index ae23151442cb..ecec2a3b13cb 100644
>>>>> --- a/drivers/vfio/mdev/mdev_core.c
>>>>> +++ b/drivers/vfio/mdev/mdev_core.c
>>>>> @@ -146,6 +146,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>>>>>  {
>>>>>  	int ret;
>>>>>  	struct mdev_parent *parent;
>>>>> +	char *env_string = "MDEV_STATE=registered";
>>>>> +	char *envp[] = { env_string, NULL };
>>>>>  
>>>>>  	/* check for mandatory ops */
>>>>>  	if (!ops || !ops->create || !ops->remove || !ops->supported_type_groups)
>>>>> @@ -196,7 +198,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>>>>>  	list_add(&parent->next, &parent_list);
>>>>>  	mutex_unlock(&parent_list_lock);
>>>>>  
>>>>> -	dev_info(dev, "MDEV: Registered\n");
>>>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
>>>>> +    
>>>>
>>>> Its good to have udev event, but don't remove debug print from dmesg.
>>>> Same for unregister.  
>>>
>>> Who consumes these?  They seem noisy.  Thanks,
>>>   
>>
>> I don't think its noisy, its more of logging purpose. This is seen in
>> kernel log only when physical device is registered to mdev.
> 
> Yes; but why do you want to log success? If you need to log it
> somewhere, wouldn't a trace event be a much better choice?
> 

Trace events are not always collected in production environment, there
kernel log helps.

Thanks,
Kirti

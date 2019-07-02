Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9CE5C88B
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 06:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfGBEzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 00:55:20 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8794 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfGBEzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 00:55:20 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d1ae3b90000>; Mon, 01 Jul 2019 21:55:21 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 01 Jul 2019 21:55:18 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 01 Jul 2019 21:55:18 -0700
Received: from [10.24.70.16] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Jul
 2019 04:55:14 +0000
Subject: Re: [PATCH v2] mdev: Send uevents around parent device registration
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <156199271955.1646.13321360197612813634.stgit@gimli.home>
 <08597ab4-cc37-3973-8927-f1bc430f6185@nvidia.com>
 <20190701112442.176a8407@x1.home>
 <3b338e73-7929-df20-ca2b-3223ba4ead39@nvidia.com>
 <20190701140436.45eabf07@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <14783c81-0236-2f25-6193-c06aa83392c9@nvidia.com>
Date:   Tue, 2 Jul 2019 10:25:04 +0530
MIME-Version: 1.0
In-Reply-To: <20190701140436.45eabf07@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1562043321; bh=CZdkaj0XFhhMmhaSOWFllFY14IofOj9ERRNjXuWdkfg=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=QIrRc4ZnpGTLVdr9l5Wjq+vybQ4zVvZMBW5EsWqoAQQnsO7IfBggAnJHVeCemexGA
         V1XJdaFuT+hrBxWpf+ePfP7gt/nag0d9V4XTJ1bKEuXWy+PC54Mo0HiFzX8E36oBpR
         S8P15hTvlWPSW9I38n2/nCX6p+Y08dUmet0CbpmDTaZ4I7E7/wkMa65vrQBM7QBX4b
         kJPe0dzyqFQGa8kbwb3y14MFxYPqBTiBYnFol+pbHj9gNL36Chp35Kj7HuAH+xG95Z
         YPsuozpHiEKs0ESkxoR9XD4OU+DiKdCXGz2qtlEjZeuoCdA5u+kHpdN9nkWCoi1H1k
         HzDvy8hIs7PqA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/2/2019 1:34 AM, Alex Williamson wrote:
> On Mon, 1 Jul 2019 23:20:35 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 7/1/2019 10:54 PM, Alex Williamson wrote:
>>> On Mon, 1 Jul 2019 22:43:10 +0530
>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>   
>>>> On 7/1/2019 8:24 PM, Alex Williamson wrote:  
>>>>> This allows udev to trigger rules when a parent device is registered
>>>>> or unregistered from mdev.
>>>>>
>>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>>>> ---
>>>>>
>>>>> v2: Don't remove the dev_info(), Kirti requested they stay and
>>>>>     removing them is only tangential to the goal of this change.
>>>>>     
>>>>
>>>> Thanks.
>>>>
>>>>  
>>>>>  drivers/vfio/mdev/mdev_core.c |    8 ++++++++
>>>>>  1 file changed, 8 insertions(+)
>>>>>
>>>>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>>>>> index ae23151442cb..7fb268136c62 100644
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
>>>>> @@ -197,6 +199,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>>>>>  	mutex_unlock(&parent_list_lock);
>>>>>  
>>>>>  	dev_info(dev, "MDEV: Registered\n");
>>>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
>>>>> +
>>>>>  	return 0;
>>>>>  
>>>>>  add_dev_err:
>>>>> @@ -220,6 +224,8 @@ EXPORT_SYMBOL(mdev_register_device);
>>>>>  void mdev_unregister_device(struct device *dev)
>>>>>  {
>>>>>  	struct mdev_parent *parent;
>>>>> +	char *env_string = "MDEV_STATE=unregistered";
>>>>> +	char *envp[] = { env_string, NULL };
>>>>>  
>>>>>  	mutex_lock(&parent_list_lock);
>>>>>  	parent = __find_parent_device(dev);
>>>>> @@ -243,6 +249,8 @@ void mdev_unregister_device(struct device *dev)
>>>>>  	up_write(&parent->unreg_sem);
>>>>>  
>>>>>  	mdev_put_parent(parent);
>>>>> +
>>>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);    
>>>>
>>>> mdev_put_parent() calls put_device(dev). If this is the last instance
>>>> holding device, then on put_device(dev) dev would get freed.
>>>>
>>>> This event should be before mdev_put_parent()  
>>>
>>> So you're suggesting the vendor driver is calling
>>> mdev_unregister_device() without a reference to the struct device that
>>> it's passing to unregister?  Sounds bogus to me.  We take a
>>> reference to the device so that it can't disappear out from under us,
>>> the caller cannot rely on our reference and the caller provided the
>>> struct device.  Thanks,
>>>   
>>
>> 1. Register uevent is sent after mdev holding reference to device, then
>> ideally, unregister path should be mirror of register path, send uevent
>> and then release the reference to device.
> 
> I don't see the relevance here.  We're marking an event, not unwinding
> state of the device from the registration process.  Additionally, the
> event we're trying to mark is the completion of each process, so the
> notion that we need to mirror the ordering between the two is invalid.
> 
>> 2. I agree that vendor driver shouldn't call mdev_unregister_device()
>> without holding reference to device. But to be on safer side, if ever
>> such case occur, to avoid any segmentation fault in kernel, better to
>> send event before mdev release the reference to device.
> 
> I know that get_device() and put_device() are GPL symbols and that's a
> bit of an issue, but I don't think we should be kludging the code for a
> vendor driver that might have problems with that.  A) we're using the
> caller provided device  for the uevent, B) we're only releasing our own
> reference to the device that was acquired during registration, the
> vendor driver must have other references,

Are you going to assume that someone/vendor driver is always going to do
right thing?

> C) the parent device
> generally lives on a bus, with a vendor driver, there's an entire
> ecosystem of references to the device below mdev.  Is this a paranoia
> request or are you really concerned that your PCI device suddenly
> disappears when mdev's reference to it disappears. 

mdev infrastructure is not always used by PCI devices. It is designed to
be generic, so that other devices (other than PCI devices) can also use
this framework.
If there is a assumption that user of mdev framework or vendor drivers
are always going to use mdev in right way, then there is no need for
mdev core to held reference of the device?
This is not a "paranoia request". This is more of a ideal scenario, mdev
should use device by holding its reference rather than assuming (or
relying on) someone else holding the reference of device.

Thanks,
Kirti

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968365C24C
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 19:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfGARus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 13:50:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16637 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbfGARur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 13:50:47 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d1a47f50001>; Mon, 01 Jul 2019 10:50:46 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 01 Jul 2019 10:50:46 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 01 Jul 2019 10:50:46 -0700
Received: from [10.24.70.16] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Jul
 2019 17:50:44 +0000
Subject: Re: [PATCH v2] mdev: Send uevents around parent device registration
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <156199271955.1646.13321360197612813634.stgit@gimli.home>
 <08597ab4-cc37-3973-8927-f1bc430f6185@nvidia.com>
 <20190701112442.176a8407@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <3b338e73-7929-df20-ca2b-3223ba4ead39@nvidia.com>
Date:   Mon, 1 Jul 2019 23:20:35 +0530
MIME-Version: 1.0
In-Reply-To: <20190701112442.176a8407@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1562003446; bh=DBWgF3pGUCaBsjSxYbWQx/22PeKlBCN37/iCIS1y6gg=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=mhumOQ+gZPsB3h7k+ArAOBCvneeHVMuEanzf85P0rDHmwEneD6pLBW7Ucl/2D5Wy9
         gTCOWB45BPcYWnNwE0Hd8cc9+V+VBtsRARP3CrBIVJV+60qzqvkzy7OmIRtmJaLsyj
         2SEFn9KaxHj+fLokMaJwiomoUUHYmmJjn9dDZPhKFS0QAL1vUK82BkBImOmIEEvDhV
         rVNr0RDztrimN5CFS8PRPs5kh+B3x8QXdxu5PgQZwgzd29qEeBZoQZKe/ln5p4UBL7
         Iww+UgxohIwflcluolnlZ0qycnsEmXpBBI1EN0aTNcDXPtKyVJ0qTscErszjemoY+b
         HpyAHAr2rtQTQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/1/2019 10:54 PM, Alex Williamson wrote:
> On Mon, 1 Jul 2019 22:43:10 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 7/1/2019 8:24 PM, Alex Williamson wrote:
>>> This allows udev to trigger rules when a parent device is registered
>>> or unregistered from mdev.
>>>
>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>> ---
>>>
>>> v2: Don't remove the dev_info(), Kirti requested they stay and
>>>     removing them is only tangential to the goal of this change.
>>>   
>>
>> Thanks.
>>
>>
>>>  drivers/vfio/mdev/mdev_core.c |    8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>>> index ae23151442cb..7fb268136c62 100644
>>> --- a/drivers/vfio/mdev/mdev_core.c
>>> +++ b/drivers/vfio/mdev/mdev_core.c
>>> @@ -146,6 +146,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>>>  {
>>>  	int ret;
>>>  	struct mdev_parent *parent;
>>> +	char *env_string = "MDEV_STATE=registered";
>>> +	char *envp[] = { env_string, NULL };
>>>  
>>>  	/* check for mandatory ops */
>>>  	if (!ops || !ops->create || !ops->remove || !ops->supported_type_groups)
>>> @@ -197,6 +199,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>>>  	mutex_unlock(&parent_list_lock);
>>>  
>>>  	dev_info(dev, "MDEV: Registered\n");
>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
>>> +
>>>  	return 0;
>>>  
>>>  add_dev_err:
>>> @@ -220,6 +224,8 @@ EXPORT_SYMBOL(mdev_register_device);
>>>  void mdev_unregister_device(struct device *dev)
>>>  {
>>>  	struct mdev_parent *parent;
>>> +	char *env_string = "MDEV_STATE=unregistered";
>>> +	char *envp[] = { env_string, NULL };
>>>  
>>>  	mutex_lock(&parent_list_lock);
>>>  	parent = __find_parent_device(dev);
>>> @@ -243,6 +249,8 @@ void mdev_unregister_device(struct device *dev)
>>>  	up_write(&parent->unreg_sem);
>>>  
>>>  	mdev_put_parent(parent);
>>> +
>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);  
>>
>> mdev_put_parent() calls put_device(dev). If this is the last instance
>> holding device, then on put_device(dev) dev would get freed.
>>
>> This event should be before mdev_put_parent()
> 
> So you're suggesting the vendor driver is calling
> mdev_unregister_device() without a reference to the struct device that
> it's passing to unregister?  Sounds bogus to me.  We take a
> reference to the device so that it can't disappear out from under us,
> the caller cannot rely on our reference and the caller provided the
> struct device.  Thanks,
> 

1. Register uevent is sent after mdev holding reference to device, then
ideally, unregister path should be mirror of register path, send uevent
and then release the reference to device.

2. I agree that vendor driver shouldn't call mdev_unregister_device()
without holding reference to device. But to be on safer side, if ever
such case occur, to avoid any segmentation fault in kernel, better to
send event before mdev release the reference to device.

Thanks,
Kirti

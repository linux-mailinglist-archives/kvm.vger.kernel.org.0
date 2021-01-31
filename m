Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E581309EB1
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 21:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhAaUKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 15:10:44 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11335 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbhAaUIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 15:08:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6016fb180000>; Sun, 31 Jan 2021 10:46:48 -0800
Received: from [172.27.11.151] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 31 Jan
 2021 18:46:43 +0000
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
 <20210122122503.4e492b96@omen.home.shazbot.org>
 <20210122200421.GH4147@nvidia.com>
 <20210125172035.3b61b91b.cohuck@redhat.com>
 <20210125180440.GR4147@nvidia.com>
 <20210125163151.5e0aeecb@omen.home.shazbot.org>
 <20210126004522.GD4147@nvidia.com>
 <20210125203429.587c20fd@x1.home.shazbot.org>
 <1419014f-fad2-9599-d382-9bba7686f1c4@nvidia.com>
 <20210128172930.74baff41.cohuck@redhat.com>
 <20210128140256.178d3912@omen.home.shazbot.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <536caa01-7fef-7256-b281-03b40a6ca217@nvidia.com>
Date:   Sun, 31 Jan 2021 20:46:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210128140256.178d3912@omen.home.shazbot.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612118808; bh=J9K1UyCdN6hT0fXSVqz3xsl2XuJtDw8m2shiu+C2sQc=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=FIxMud6/faQxPd05T+BO+DIqmsu33N7xaKjJJYb3KwPs+LIvTHRcYvbYlfdUqgVOC
         n7Bjo4a25Byon59uJCxJSW+t5D74FXkQG9T/PhcqxQmCCN++kmu4JxdnaXWKuiiWho
         lHPzrJXvWS85NsgxJRE3oe5rLQxXAHJXDsvA/ObV1rDxJQ/o3OCJP75bRjydRFHq9E
         VcJ9xhVZVDw3+etmEt3bW/vaNYAGacCYUYDtNtEC+naau1SoR6o5IRSHq0xaX6dIuc
         ssUhIExXq6/le5JSvfnOomLb5HX4iG5A889OduDNq+haj4QKYs64BvOODUHkjJGMBq
         Ulu+6Y25jW8dA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/28/2021 11:02 PM, Alex Williamson wrote:
> On Thu, 28 Jan 2021 17:29:30 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> On Tue, 26 Jan 2021 15:27:43 +0200
>> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>>> On 1/26/2021 5:34 AM, Alex Williamson wrote:
>>>> On Mon, 25 Jan 2021 20:45:22 -0400
>>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>>     
>>>>> On Mon, Jan 25, 2021 at 04:31:51PM -0700, Alex Williamson wrote:
>>>>>> extensions potentially break vendor drivers, etc.  We're only even hand
>>>>>> waving that existing device specific support could be farmed out to new
>>>>>> device specific drivers without even going to the effort to prove that.
>>>>> This is a RFC, not a complete patch series. The RFC is to get feedback
>>>>> on the general design before everyone comits alot of resources and
>>>>> positions get dug in.
>>>>>
>>>>> Do you really think the existing device specific support would be a
>>>>> problem to lift? It already looks pretty clean with the
>>>>> vfio_pci_regops, looks easy enough to lift to the parent.
>>>>>     
>>>>>> So far the TODOs rather mask the dirty little secrets of the
>>>>>> extension rather than showing how a vendor derived driver needs to
>>>>>> root around in struct vfio_pci_device to do something useful, so
>>>>>> probably porting actual device specific support rather than further
>>>>>> hand waving would be more helpful.
>>>>> It would be helpful to get actual feedback on the high level design -
>>>>> someting like this was already tried in May and didn't go anywhere -
>>>>> are you surprised that we are reluctant to commit alot of resources
>>>>> doing a complete job just to have it go nowhere again?
>>>> That's not really what I'm getting from your feedback, indicating
>>>> vfio-pci is essentially done, the mlx stub driver should be enough to
>>>> see the direction, and additional concerns can be handled with TODO
>>>> comments.  Sorry if this is not construed as actual feedback, I think
>>>> both Connie and I are making an effort to understand this and being
>>>> hampered by lack of a clear api or a vendor driver that's anything more
>>>> than vfio-pci plus an aux bus interface.  Thanks,
>>> I think I got the main idea and I'll try to summarize it:
>>>
>>> The separation to vfio-pci.ko and vfio-pci-core.ko is acceptable, and we
>>> do need it to be able to create vendor-vfio-pci.ko driver in the future
>>> to include vendor special souse inside.
>> One other thing I'd like to bring up: What needs to be done in
>> userspace? Does a userspace driver like QEMU need changes to actually
>> exploit this? Does management software like libvirt need to be involved
>> in decision making, or does it just need to provide the knobs to make
>> the driver configurable?
> I'm still pretty nervous about the userspace aspect of this as well.
> QEMU and other actual vfio drivers are probably the least affected,
> at least for QEMU, it'll happily open any device that has a pointer to
> an IOMMU group that's reflected as a vfio group device.  Tools like
> libvirt, on the other hand, actually do driver binding and we need to
> consider how they make driver decisions. Jason suggested that the
> vfio-pci driver ought to be only spec compliant behavior, which sounds
> like some deprecation process of splitting out the IGD, NVLink, zpci,
> etc. features into sub-drivers and eventually removing that device
> specific support from vfio-pci.  Would we expect libvirt to know, "this
> is an 8086 graphics device, try to bind it to vfio-pci-igd" or "uname
> -m says we're running on s390, try to bind it to vfio-zpci"?  Maybe we
> expect derived drivers to only bind to devices they recognize, so
> libvirt could blindly try a whole chain of drivers, ending in vfio-pci.
> Obviously if we have competing drivers that support the same device in
> different ways, that quickly falls apart.

I think we can leave common arch specific stuff, such as s390 (IIUC) in 
the core driver. And only create vfio_pci drivers for 
vendor/device/subvendor specific stuff.

Also, the competing drivers issue can also happen today, right ? after 
adding new_id to vfio_pci I don't know how linux will behave if we'll 
plug new device with same id to the system. which driver will probe it ?

I don't really afraid of competing drivers since we can ask from vendor 
vfio pci_drivers to add vendor_id, device_id, subsystem_vendor and 
subsystem_device so we won't have this problem. I don't think that there 
will be 2 drivers that drive the same device with these 4 ids.

Userspace tool can have a map of ids to drivers and bind the device to 
the right vfio-pci vendor driver if it has one. if not, bind to vfio_pci.ko.

>
> Libvirt could also expand its available driver models for the user to
> specify a variant, I'd support that for overriding a choice that libvirt
> might make otherwise, but forcing the user to know this information is
> just passing the buck.

We can add a code to libvirt as mentioned above.

>
> Some derived drivers could probably actually include device IDs rather
> than only relying on dynamic ids, but then we get into the problem that
> we're competing with native host driver for a device.  The aux bus
> example here is essentially the least troublesome variation since it
> works in conjunction with the native host driver rather than replacing
> it.  Thanks,

same competition after we add new_id to vfio_pci, right ?

>
> Alex

A pointer to needed additions to libvirt will be awsome (or any other hint).

I'll send the V2 soon and then move to libvirt.

-Max.


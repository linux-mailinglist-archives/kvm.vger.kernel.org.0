Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AACC1C3077
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 02:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgEDAZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 20:25:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:3314 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgEDAZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 20:25:31 -0400
IronPort-SDR: sjCE19S3GHl4ZJ2nNglSm5xGNFVlUadqn6UxDQUSCh49u2sydvpvYjFG0C+cKXyRnCoHcrZz3g
 5shLJ8w/S68g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2020 17:25:30 -0700
IronPort-SDR: brpGf6YOXbEiaJ5u/jdtv1LzsE30+9enUNeIpNQ7635oSAodFRTy7A78KoBtp1FXaDlFJm3nHb
 8k1Wj+osPKrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,350,1583222400"; 
   d="scan'208";a="406317151"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.212.197.87]) ([10.212.197.87])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2020 17:25:29 -0700
Subject: Re: [PATCH RFC 04/15] drivers/base: Add support for a new IMS irq
 domain
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751205175.36773.1874642824360728883.stgit@djiang5-desk3.ch.intel.com>
 <20200423201118.GA29567@ziepe.ca>
 <35f701d9-1034-09c7-8117-87fb8796a017@linux.intel.com>
 <20200503222513.GS26002@ziepe.ca>
 <1ededeb8-deff-4db7-40e5-1d5e8a800f52@linux.intel.com>
 <20200503224659.GU26002@ziepe.ca>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <8ff2aace-0697-b8ef-de68-1bcc49d6727f@linux.intel.com>
Date:   Sun, 3 May 2020 17:25:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503224659.GU26002@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/3/2020 3:46 PM, Jason Gunthorpe wrote:
> On Sun, May 03, 2020 at 03:40:44PM -0700, Dey, Megha wrote:
>> On 5/3/2020 3:25 PM, Jason Gunthorpe wrote:
>>> On Fri, May 01, 2020 at 03:30:02PM -0700, Dey, Megha wrote:
>>>> Hi Jason,
>>>>
>>>> On 4/23/2020 1:11 PM, Jason Gunthorpe wrote:
>>>>> On Tue, Apr 21, 2020 at 04:34:11PM -0700, Dave Jiang wrote:
>>>>>> diff --git a/drivers/base/ims-msi.c b/drivers/base/ims-msi.c
>>>>>> new file mode 100644
>>>>>> index 000000000000..738f6d153155
>>>>>> +++ b/drivers/base/ims-msi.c
>>>>>> @@ -0,0 +1,100 @@
>>>>>> +// SPDX-License-Identifier: GPL-2.0-only
>>>>>> +/*
>>>>>> + * Support for Device Specific IMS interrupts.
>>>>>> + *
>>>>>> + * Copyright © 2019 Intel Corporation.
>>>>>> + *
>>>>>> + * Author: Megha Dey <megha.dey@intel.com>
>>>>>> + */
>>>>>> +
>>>>>> +#include <linux/dmar.h>
>>>>>> +#include <linux/irq.h>
>>>>>> +#include <linux/mdev.h>
>>>>>> +#include <linux/pci.h>
>>>>>> +
>>>>>> +/*
>>>>>> + * Determine if a dev is mdev or not. Return NULL if not mdev device.
>>>>>> + * Return mdev's parent dev if success.
>>>>>> + */
>>>>>> +static inline struct device *mdev_to_parent(struct device *dev)
>>>>>> +{
>>>>>> +	struct device *ret = NULL;
>>>>>> +	struct device *(*fn)(struct device *dev);
>>>>>> +	struct bus_type *bus = symbol_get(mdev_bus_type);
>>>>>> +
>>>>>> +	if (bus && dev->bus == bus) {
>>>>>> +		fn = symbol_get(mdev_dev_to_parent_dev);
>>>>>> +		ret = fn(dev);
>>>>>> +		symbol_put(mdev_dev_to_parent_dev);
>>>>>> +		symbol_put(mdev_bus_type);
>>>>>
>>>>> No, things like this are not OK in the drivers/base
>>>>>
>>>>> Whatever this is doing needs to be properly architected in some
>>>>> generic way.
>>>>
>>>> Basically what I am trying to do here is to determine if the device is an
>>>> mdev device or not.
>>>
>>> Why? mdev devices are virtual they don't have HW elements.
>>
>> Hmm yeah exactly, since they are virtual, they do not have an associated IRQ
>> domain right? So they use the irq domain of the parent device..
>>
>>>
>>> The caller should use the concrete pci_device to allocate
>>> platform_msi? What is preventing this?
>>
>> hmmm do you mean to say all platform-msi adhere to the rules of a PCI
>> device?
> 
> I mean where a platform-msi can work should be defined by the arch,
> and probably is related to things like having an irq_domain attached
> 
> So, like pci, drivers must only try to do platfor_msi stuff on
> particular devices. eg on pci_device and platform_device types.
> 
> Even so it may not even work, but I can't think of any reason why it
> should be made to work on a virtual device like mdev.
> 
>> The use case if when we have a device assigned to a guest and we
>> want to allocate IMS(platform-msi) interrupts for that
>> guest-assigned device. Currently, this is abstracted through a mdev
>> interface.
> 
> And the mdev has the pci_device internally, so it should simply pass
> that pci_device to the platform_msi machinery.

hmm i am not sure I follow this. mdev has a pci_device internally? which 
struct are you referring to here?

mdev is merely a micropartitioned PCI device right, which no real PCI 
resource backing. I am not how else we can find the IRQ domain 
associated with an mdev..

> 
> This is no different from something like pci_iomap() which must be
> used with the pci_device.
> 
> Jason
> 

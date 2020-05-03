Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBF81C3022
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 00:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgECWkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 18:40:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:10689 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729164AbgECWkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 18:40:46 -0400
IronPort-SDR: EuOpqDLD4b2P95cEP0BTy6VInRjSU9hzJ0hbZxP8RqlGrGJkXAUQrvEiXOHc6WMjhwumPRvSXH
 HpfWLOivvRGA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2020 15:40:46 -0700
IronPort-SDR: lLs1+0CnV12YbQv9q6ssdQiomWDrXJjlfgjCBwNpjFi6oITFAsyp8PeFa0HbLqWs0qB25BLdLH
 bQb3rZnrlZyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,349,1583222400"; 
   d="scan'208";a="406301231"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.212.197.87]) ([10.212.197.87])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2020 15:40:44 -0700
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
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <1ededeb8-deff-4db7-40e5-1d5e8a800f52@linux.intel.com>
Date:   Sun, 3 May 2020 15:40:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503222513.GS26002@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 5/3/2020 3:25 PM, Jason Gunthorpe wrote:
> On Fri, May 01, 2020 at 03:30:02PM -0700, Dey, Megha wrote:
>> Hi Jason,
>>
>> On 4/23/2020 1:11 PM, Jason Gunthorpe wrote:
>>> On Tue, Apr 21, 2020 at 04:34:11PM -0700, Dave Jiang wrote:
>>>> diff --git a/drivers/base/ims-msi.c b/drivers/base/ims-msi.c
>>>> new file mode 100644
>>>> index 000000000000..738f6d153155
>>>> +++ b/drivers/base/ims-msi.c
>>>> @@ -0,0 +1,100 @@
>>>> +// SPDX-License-Identifier: GPL-2.0-only
>>>> +/*
>>>> + * Support for Device Specific IMS interrupts.
>>>> + *
>>>> + * Copyright © 2019 Intel Corporation.
>>>> + *
>>>> + * Author: Megha Dey <megha.dey@intel.com>
>>>> + */
>>>> +
>>>> +#include <linux/dmar.h>
>>>> +#include <linux/irq.h>
>>>> +#include <linux/mdev.h>
>>>> +#include <linux/pci.h>
>>>> +
>>>> +/*
>>>> + * Determine if a dev is mdev or not. Return NULL if not mdev device.
>>>> + * Return mdev's parent dev if success.
>>>> + */
>>>> +static inline struct device *mdev_to_parent(struct device *dev)
>>>> +{
>>>> +	struct device *ret = NULL;
>>>> +	struct device *(*fn)(struct device *dev);
>>>> +	struct bus_type *bus = symbol_get(mdev_bus_type);
>>>> +
>>>> +	if (bus && dev->bus == bus) {
>>>> +		fn = symbol_get(mdev_dev_to_parent_dev);
>>>> +		ret = fn(dev);
>>>> +		symbol_put(mdev_dev_to_parent_dev);
>>>> +		symbol_put(mdev_bus_type);
>>>
>>> No, things like this are not OK in the drivers/base
>>>
>>> Whatever this is doing needs to be properly architected in some
>>> generic way.
>>
>> Basically what I am trying to do here is to determine if the device is an
>> mdev device or not.
> 
> Why? mdev devices are virtual they don't have HW elements.

Hmm yeah exactly, since they are virtual, they do not have an associated 
IRQ domain right? So they use the irq domain of the parent device..

> 
> The caller should use the concrete pci_device to allocate
> platform_msi? What is preventing this?

hmmm do you mean to say all platform-msi adhere to the rules of a PCI 
device? The use case if when we have a device assigned to a guest and we 
want to allocate IMS(platform-msi) interrupts for that guest-assigned 
device. Currently, this is abstracted through a mdev interface.

> 
>>>> +struct irq_domain *arch_create_ims_irq_domain(struct irq_domain *parent,
>>>> +					      const char *name)
>>>> +{
>>>> +	struct fwnode_handle *fn;
>>>> +	struct irq_domain *domain;
>>>> +
>>>> +	fn = irq_domain_alloc_named_fwnode(name);
>>>> +	if (!fn)
>>>> +		return NULL;
>>>> +
>>>> +	domain = msi_create_irq_domain(fn, &ims_ir_domain_info, parent);
>>>> +	if (!domain)
>>>> +		return NULL;
>>>> +
>>>> +	irq_domain_update_bus_token(domain, DOMAIN_BUS_PLATFORM_MSI);
>>>> +	irq_domain_free_fwnode(fn);
>>>> +
>>>> +	return domain;
>>>> +}
>>>
>>> I'm still not really clear why all this is called IMS.. This looks
>>> like the normal boilerplate to setup an IRQ domain? What is actually
>>> 'ims' in here?
>>
>> It is just a way to create a new domain specifically for IMS interrupts.
>> Although, since there is a platform_msi_create_irq_domain already, which
>> does something similar, I will use the same for IMS as well.
> 
> But this is all code already intended to be used by the platform, why
> is it in drivers/base?

yeah this code will not exist in the next version anyways..
> 
>> Also, since there is quite a stir over the name 'IMS' do you have any
>> suggestion for a more generic name for this?
> 
> It seems we have a name, this is called platform_msi in Linux?

yeah, ultimately IMS boils down to "Extended platform_msi" looks like ..
> 
> Jason
> 

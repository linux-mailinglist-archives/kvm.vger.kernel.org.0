Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB351C209D
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 00:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgEAWaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 18:30:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:49495 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAWaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 18:30:07 -0400
IronPort-SDR: 0lj3iCM1MktqXW8KGez7CSXdGitPQh4o9ryh692fkWax2gBITyP1d/uK2dXimdRNlT/y5NZHW5
 w7ncfsSAQOsQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 15:30:05 -0700
IronPort-SDR: LkBnsgMeaxfsZ9ofP1C5FXoMrClJS6NT//KK3eTQ07j/VTvabeiC6c21ePHRg6/tdrGTjzZOWj
 SuHAalGalvHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="248656703"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.251.135.85]) ([10.251.135.85])
  by fmsmga007.fm.intel.com with ESMTP; 01 May 2020 15:30:02 -0700
Subject: Re: [PATCH RFC 04/15] drivers/base: Add support for a new IMS irq
 domain
To:     Jason Gunthorpe <jgg@ziepe.ca>, Dave Jiang <dave.jiang@intel.com>
Cc:     vkoul@kernel.org, maz@kernel.org, bhelgaas@google.com,
        rafael@kernel.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751205175.36773.1874642824360728883.stgit@djiang5-desk3.ch.intel.com>
 <20200423201118.GA29567@ziepe.ca>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <35f701d9-1034-09c7-8117-87fb8796a017@linux.intel.com>
Date:   Fri, 1 May 2020 15:30:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423201118.GA29567@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 4/23/2020 1:11 PM, Jason Gunthorpe wrote:
> On Tue, Apr 21, 2020 at 04:34:11PM -0700, Dave Jiang wrote:
>> diff --git a/drivers/base/ims-msi.c b/drivers/base/ims-msi.c
>> new file mode 100644
>> index 000000000000..738f6d153155
>> +++ b/drivers/base/ims-msi.c
>> @@ -0,0 +1,100 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Support for Device Specific IMS interrupts.
>> + *
>> + * Copyright © 2019 Intel Corporation.
>> + *
>> + * Author: Megha Dey <megha.dey@intel.com>
>> + */
>> +
>> +#include <linux/dmar.h>
>> +#include <linux/irq.h>
>> +#include <linux/mdev.h>
>> +#include <linux/pci.h>
>> +
>> +/*
>> + * Determine if a dev is mdev or not. Return NULL if not mdev device.
>> + * Return mdev's parent dev if success.
>> + */
>> +static inline struct device *mdev_to_parent(struct device *dev)
>> +{
>> +	struct device *ret = NULL;
>> +	struct device *(*fn)(struct device *dev);
>> +	struct bus_type *bus = symbol_get(mdev_bus_type);
>> +
>> +	if (bus && dev->bus == bus) {
>> +		fn = symbol_get(mdev_dev_to_parent_dev);
>> +		ret = fn(dev);
>> +		symbol_put(mdev_dev_to_parent_dev);
>> +		symbol_put(mdev_bus_type);
> 
> No, things like this are not OK in the drivers/base
> 
> Whatever this is doing needs to be properly architected in some
> generic way.

Basically what I am trying to do here is to determine if the device is 
an mdev device or not. mdev devices have no IRQ domain associated to it 
and use their parent dev's IRQ domain to allocate interrupts.

The issue is that
1. all the vfio-mdev code today can be compiled as a module
2. None of the mdev macros/functions are being used outside of the 
drivers/vfio/mdev code path (where they are defined).

Hence, these definitions are not visible outside of drivers/vfio/mdev 
when compiled as a module and thus I have used symbol_get/put.

I will try asking the mdev folks if they would have a better solution 
for this or some of this code can be mde more generic.

> 
>> +static int dev_ims_prepare(struct irq_domain *domain, struct device *dev,
>> +			   int nvec, msi_alloc_info_t *arg)
>> +{
>> +	if (dev_is_mdev(dev))
>> +		dev = mdev_to_parent(dev);
> 
> Like maybe the caller shouldn't be passing in a mdev in the first
> place, or some generic driver layer scheme is needed to go from a
> child device (eg a mdev or one of these new virtual bus things) to the
> struct device that owns the IRQ interface.

In our current use case, IMS interrupts are only used by guest (mdev's), 
although they can be used by host as well. So the 'dev' passed by the 
caller of platform_msi_domain_alloc_irqs_group() is effectively an mdev.

I am not sure about how we could have a generic code to convert the 
'child' mdev device to struct device. Do you have any suggestions on how 
we could do this?

> 
>> +	init_irq_alloc_info(arg, NULL);
>> +	arg->dev = dev;
>> +	arg->type = X86_IRQ_ALLOC_TYPE_IMS;
> 
> Also very bewildering to see X86_* in drivers/base

Well, this needs to go for sure. I will replace it with something more 
generic.
> 
>> +struct irq_domain *arch_create_ims_irq_domain(struct irq_domain *parent,
>> +					      const char *name)
>> +{
>> +	struct fwnode_handle *fn;
>> +	struct irq_domain *domain;
>> +
>> +	fn = irq_domain_alloc_named_fwnode(name);
>> +	if (!fn)
>> +		return NULL;
>> +
>> +	domain = msi_create_irq_domain(fn, &ims_ir_domain_info, parent);
>> +	if (!domain)
>> +		return NULL;
>> +
>> +	irq_domain_update_bus_token(domain, DOMAIN_BUS_PLATFORM_MSI);
>> +	irq_domain_free_fwnode(fn);
>> +
>> +	return domain;
>> +}
> 
> I'm still not really clear why all this is called IMS.. This looks
> like the normal boilerplate to setup an IRQ domain? What is actually
> 'ims' in here?

It is just a way to create a new domain specifically for IMS interrupts. 
Although, since there is a platform_msi_create_irq_domain already, which 
does something similar, I will use the same for IMS as well.

Also, since there is quite a stir over the name 'IMS' do you have any 
suggestion for a more generic name for this?

> 
>> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
>> index 7d922950caaf..c21f1305a76b 100644
>> +++ b/drivers/vfio/mdev/mdev_private.h
>> @@ -36,7 +36,6 @@ struct mdev_device {
>>   };
>>   
>>   #define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
>> -#define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
>>   
>>   struct mdev_type {
>>   	struct kobject kobj;
>> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
>> index 0ce30ca78db0..fa2344e239ef 100644
>> +++ b/include/linux/mdev.h
>> @@ -144,5 +144,8 @@ void mdev_unregister_driver(struct mdev_driver *drv);
>>   struct device *mdev_parent_dev(struct mdev_device *mdev);
>>   struct device *mdev_dev(struct mdev_device *mdev);
>>   struct mdev_device *mdev_from_dev(struct device *dev);
>> +struct device *mdev_dev_to_parent_dev(struct device *dev);
>> +
>> +#define dev_is_mdev(dev) ((dev)->bus == symbol_get(mdev_bus_type))
> 
> NAK on the symbol_get

As I mentioned earlier, given the way the current mdev code is 
structured, the only way to use dev_is_mdev or other macros/functions in 
the mdev subsystem outside of drivers/vfio/mdev is to use 
symbol_get/put. Obviously, seems like this is not a correct thing to do, 
I will have to find another way.

> 
> Jason
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB181C3060
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 02:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgEDAMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 20:12:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:56733 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgEDAMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 20:12:00 -0400
IronPort-SDR: BUb1wmwrTteHMwS9G1BIQAkZltLofAjTbzrWHyfEAbuGmPWjKq4Du4wdanHS4Vw3BNQL9clfBx
 mrIsyKnXKjpg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2020 17:11:59 -0700
IronPort-SDR: HZTe/X6Tg1DxjC1F9bf8cTnUoxZDpelHbxlDYUgI1U8rb2ct1wKyoUDgjrSkiuqkqQTRuuJzuJ
 l4Du9YT4PuOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,349,1583222400"; 
   d="scan'208";a="406315407"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.212.197.87]) ([10.212.197.87])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2020 17:11:58 -0700
Subject: Re: [PATCH RFC 04/15] drivers/base: Add support for a new IMS irq
 domain
To:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751205175.36773.1874642824360728883.stgit@djiang5-desk3.ch.intel.com>
 <87pnbvtfdc.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <53df1de7-ca25-e1be-b31c-e57bd95f0564@linux.intel.com>
Date:   Sun, 3 May 2020 17:11:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87pnbvtfdc.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 4/25/2020 2:38 PM, Thomas Gleixner wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
>> From: Megha Dey <megha.dey@linux.intel.com>
>>
>> Add support for the creation of a new IMS irq domain. It creates a new
>> irq chip associated with the IMS domain and adds the necessary domain
>> operations to it.
> 
> And how is a X86 specific thingy related to drivers/base?

Well, clearly this file has both arch independent sand dependent code 
which is incorrect. From various discussions, we have now concluded that 
IMS is after all not a X86 specific thingy after all. IMS is just a name 
intel came up with, all it really means is device managed addr/data 
writes to generate interrupts.

> 
>> diff --git a/drivers/base/ims-msi.c b/drivers/base/ims-msi.c
> 
> This sits in drivers base because IMS is architecture independent, right?

Per my above comment, technically we can call something IMS even if 
device has its own location to store interrupts in non-pci standard 
mechanism, much like platform-msi indeed. We simply need to extend 
platform-msi to its address some of its shortcomings: increase number of 
interrupts to > 2048, enable dynamic allocation of interrupts, add 
mask/unmask callbacks in addition to write_msg etc.

I will be sending out an email shortly outlining the new design for IMS 
and what are the improvements we want to add to the already exisitng 
platform-msi infrastructure.

> 
>> new file mode 100644
>> index 000000000000..738f6d153155
>> --- /dev/null
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
> 
> symbol_get()?

mdev_bus_type is defined in driver/vfio/mdev/ directory. The entire 
vfio-mdev can be compiled as a module and if so, then this symbol is not 
visible outside of that directory and there are some linker errors. 
Currently, there these symbols sare self-contained and are not used 
outside of the directory where they are defined. I did not know earlier 
that is not advisible to use symbol_get() for this. I will try to come 
up with a better approach.

> 
>> +
>> +	if (bus && dev->bus == bus) {
>> +		fn = symbol_get(mdev_dev_to_parent_dev);
> 
> What's wrong with simple function calls?

Hmmm, same reason as above..
> 
>> +		ret = fn(dev);
>> +		symbol_put(mdev_dev_to_parent_dev);
>> +		symbol_put(mdev_bus_type);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static irq_hw_number_t dev_ims_get_hwirq(struct msi_domain_info *info,
>> +					 msi_alloc_info_t *arg)
>> +{
>> +	return arg->ims_hwirq;
>> +}
>> +
>> +static int dev_ims_prepare(struct irq_domain *domain, struct device *dev,
>> +			   int nvec, msi_alloc_info_t *arg)
>> +{
>> +	if (dev_is_mdev(dev))
>> +		dev = mdev_to_parent(dev);
> 
> This makes absolutely no sense. Somewhere you claimed that this is
> solely for mdev. Now this interface takes both a regular device and mdev.
> 
> Lack of explanation seems to be a common scheme here.

IMS can be used for mdev or a regular device. I do not think it is 
claimed anywhere that IMS is solely for mdev. In the current use case 
for DSA, IMS is used only by the guest (mdev) although it can very well 
be used by the host driver as well.

> 
>> +	init_irq_alloc_info(arg, NULL);
>> +	arg->dev = dev;
>> +	arg->type = X86_IRQ_ALLOC_TYPE_IMS;
>> +
>> +	return 0;
>> +}
>> +
>> +static void dev_ims_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
>> +{
>> +	arg->ims_hwirq = platform_msi_calc_hwirq(desc);
>> +}
>> +
>> +static struct msi_domain_ops dev_ims_domain_ops = {
>> +	.get_hwirq	= dev_ims_get_hwirq,
>> +	.msi_prepare	= dev_ims_prepare,
>> +	.set_desc	= dev_ims_set_desc,
>> +};
>> +
>> +static struct irq_chip dev_ims_ir_controller = {
>> +	.name			= "IR-DEV-IMS",
>> +	.irq_ack		= irq_chip_ack_parent,
>> +	.irq_retrigger		= irq_chip_retrigger_hierarchy,
>> +	.irq_set_vcpu_affinity	= irq_chip_set_vcpu_affinity_parent,
>> +	.flags			= IRQCHIP_SKIP_SET_WAKE,
>> +	.irq_write_msi_msg	= platform_msi_write_msg,
>> +};
>> +
>> +static struct msi_domain_info ims_ir_domain_info = {
>> +	.flags		= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS,
>> +	.ops		= &dev_ims_domain_ops,
>> +	.chip		= &dev_ims_ir_controller,
>> +	.handler	= handle_edge_irq,
>> +	.handler_name	= "edge",
>> +};
>> +
>> +struct irq_domain *arch_create_ims_irq_domain(struct irq_domain *parent,
>> +					      const char *name)
> 
> arch_create_ ???? In drivers/base ???

Needs to go away. On second thought, per Jason Gunthorpe's comment, this 
is not even required. We can simply use the existing 
platform_msi_create_irq_domain API itself.
> 
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
>> diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
>> index 2696aa75983b..59160e8cbfb1 100644
>> --- a/drivers/base/platform-msi.c
>> +++ b/drivers/base/platform-msi.c
>> @@ -31,12 +31,11 @@ struct platform_msi_priv_data {
>>   /* The devid allocator */
>>   static DEFINE_IDA(platform_msi_devid_ida);
>>   
>> -#ifdef GENERIC_MSI_DOMAIN_OPS
>>   /*
>>    * Convert an msi_desc to a globaly unique identifier (per-device
>>    * devid + msi_desc position in the msi_list).
>>    */
>> -static irq_hw_number_t platform_msi_calc_hwirq(struct msi_desc *desc)
>> +irq_hw_number_t platform_msi_calc_hwirq(struct msi_desc *desc)
>>   {
>>   	u32 devid;
>>   
>> @@ -45,6 +44,7 @@ static irq_hw_number_t platform_msi_calc_hwirq(struct msi_desc *desc)
>>   	return (devid << (32 - DEV_ID_SHIFT)) | desc->platform.msi_index;
>>   }
>>   
>> +#ifdef GENERIC_MSI_DOMAIN_OPS
>>   static void platform_msi_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
>>   {
>>   	arg->desc = desc;
>> @@ -76,7 +76,7 @@ static void platform_msi_update_dom_ops(struct msi_domain_info *info)
>>   		ops->set_desc = platform_msi_set_desc;
>>   }
>>   
>> -static void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
>> +void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
>>   {
>>   	struct msi_desc *desc = irq_data_get_msi_desc(data);
>>   	struct platform_msi_priv_data *priv_data;
>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>> index b558d4cfd082..cecc6a6bdbef 100644
>> --- a/drivers/vfio/mdev/mdev_core.c
>> +++ b/drivers/vfio/mdev/mdev_core.c
>> @@ -33,6 +33,12 @@ struct device *mdev_parent_dev(struct mdev_device *mdev)
>>   }
>>   EXPORT_SYMBOL(mdev_parent_dev);
>>   
>> +struct device *mdev_dev_to_parent_dev(struct device *dev)
>> +{
>> +	return to_mdev_device(dev)->parent->dev;
>> +}
>> +EXPORT_SYMBOL(mdev_dev_to_parent_dev);
> 
> And this needs to be EXPORT_SYMBOL because this is designed to support
> non GPL drivers from the very beginning, right? Ditto for the other
> exports in this file.

Hmm, I followed the same convention as the other exports here. Guess I 
would have to change all other exports to EXPORT_SYMBOL_GPL as well.

> 
>> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
>> index 7d922950caaf..c21f1305a76b 100644
>> --- a/drivers/vfio/mdev/mdev_private.h
>> +++ b/drivers/vfio/mdev/mdev_private.h
>> @@ -36,7 +36,6 @@ struct mdev_device {
>>   };
>>   
>>   #define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
>> -#define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
> 
> Moving stuff around 3 patches later makes tons of sense.

ok will add it earlier then.
>    
> Thanks,
> 
>          tglx
> 

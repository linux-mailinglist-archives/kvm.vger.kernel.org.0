Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EF91C3056
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 02:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgEDAId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 20:08:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:14764 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgEDAId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 20:08:33 -0400
IronPort-SDR: zen2xN4fKuL4l/RsXA6gz3cajm6wZlqxp8yarmeeAXKiv82MUOlxcH1Xd+XPEA93ziAosPIUXn
 vf31uybi1Amw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2020 17:08:25 -0700
IronPort-SDR: lI+Xfoe/HD3yjzLKmwyhlg1f9j0qEr1iFVr5QLo6S9mU00bdxp5jvpUyxFkAA0KxCcVV/wW7XY
 ruU+9gp4yOlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,349,1583222400"; 
   d="scan'208";a="406315023"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.212.197.87]) ([10.212.197.87])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2020 17:08:23 -0700
Subject: Re: [PATCH RFC 02/15] drivers/base: Introduce a new platform-msi list
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
 <158751203902.36773.2662739280103265908.stgit@djiang5-desk3.ch.intel.com>
 <87v9lntgjb.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <f0432c34-b3e4-84be-fdac-68bf880f430a@linux.intel.com>
Date:   Sun, 3 May 2020 17:08:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87v9lntgjb.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 4/25/2020 2:13 PM, Thomas Gleixner wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
> 
>> From: Megha Dey <megha.dey@linux.intel.com>
>>
>> This is a preparatory patch to introduce Interrupt Message Store (IMS).
>>
>> The struct device has a linked list ('msi_list') of the MSI (msi/msi-x,
>> platform-msi) descriptors of that device. This list holds only 1 type
>> of descriptor since it is not possible for a device to support more
>> than one of these descriptors concurrently.
>>
>> However, with the introduction of IMS, a device can support IMS as well
>> as MSI-X at the same time. Instead of sharing this list between IMS (a
>> type of platform-msi) and MSI-X descriptors, introduce a new linked list,
>> platform_msi_list, which will hold all the platform-msi descriptors.
>>
>> Thus, msi_list will point to the MSI/MSIX descriptors of a device, while
>> platform_msi_list will point to the platform-msi descriptors of a
>> device.
> 
> Will point?
> 

I meant to say msi_list will be the list head for the MSI/MSI-X 
descriptors whereas platform_msi_list will be the list head for all the 
platform-msi descriptors.

> You're failing to explain that this actually converts the existing
> platform code over to this new list. This also lacks an explanation why
> this is not a functional change.

Hmm yeah makes sense. I will add these details in the next version.

> 
>> Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
> 
> Lacks an SOB from you....

Yeah, will be added in the next version.

> 
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 139cdf7e7327..5a0116d1a8d0 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -1984,6 +1984,7 @@ void device_initialize(struct device *dev)
>>   	set_dev_node(dev, -1);
>>   #ifdef CONFIG_GENERIC_MSI_IRQ
>>   	INIT_LIST_HEAD(&dev->msi_list);
>> +	INIT_LIST_HEAD(&dev->platform_msi_list);
> 
>> --- a/drivers/base/platform-msi.c
>> +++ b/drivers/base/platform-msi.c
>> @@ -110,7 +110,8 @@ static void platform_msi_free_descs(struct device *dev, int base, int nvec)
>>   {
>>   	struct msi_desc *desc, *tmp;
>>   
>> -	list_for_each_entry_safe(desc, tmp, dev_to_msi_list(dev), list) {
>> +	list_for_each_entry_safe(desc, tmp, dev_to_platform_msi_list(dev),
>> +				 list) {
>>   		if (desc->platform.msi_index >= base &&
>>   		    desc->platform.msi_index < (base + nvec)) {
>>   			list_del(&desc->list);
>>   	datap = kzalloc(sizeof(*datap), GFP_KERNEL);
>> @@ -255,6 +256,8 @@ int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
>>   	struct platform_msi_priv_data *priv_data;
>>   	int err;
>>   
>> +	dev->platform_msi_type = GEN_PLAT_MSI;
> 
> What the heck is GEN_PLAT_MSI? Can you please use
> 
>     1) A proper name space starting with PLATFORM_MSI_ or such
> 
>     2) A proper suffix which is self explaining.
> 
> instead of coming up with nonsensical garbage which even lacks any
> explanation at the place where it is defined.

So basically, I wanted to differentiate between the existing 
platform-msi interrupts(GEN_PLAT_MSI) and the IMS interrupts.

But sure, I will try to come up with a more sensible name , 
PLATFORM_MSI_STATIC/DYNAMIC perhaps?

> 
>> diff --git a/include/linux/device.h b/include/linux/device.h
>> index ac8e37cd716a..cbcecb14584e 100644
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -567,6 +567,8 @@ struct device {
>>   #endif
>>   #ifdef CONFIG_GENERIC_MSI_IRQ
>>   	struct list_head	msi_list;
>> +	struct list_head	platform_msi_list;
>> +	unsigned int		platform_msi_type;
> 
> You use an enum for the types so why are you not using an enum for the
> struct member which stores it?

Ok, will change this in the next version.

> 
>>   
>> +/**
>> + * list_entry_select - get the correct struct for this entry based on condition
>> + * @condition:	the condition to choose a particular &struct list head pointer
>> + * @ptr_a:      the &struct list_head pointer if @condition is not met.
>> + * @ptr_b:      the &struct list_head pointer if @condition is met.
>> + * @type:       the type of the struct this is embedded in.
>> + * @member:     the name of the list_head within the struct.
>> + */
>> +#define list_entry_select(condition, ptr_a, ptr_b, type, member)\
>> +	(condition) ? list_entry(ptr_a, type, member) :		\
>> +		      list_entry(ptr_b, type, member)
> 
> This is related to $Subject in which way? It's not a entirely new
> process rule that infrastructure changes which touch a completely
> different subsystem have to be separate and explained and justified on
> their own.

True, this should be an independent change, I will add it as a separate 
patch next time.

> 
>>   
>> +enum platform_msi_type {
>> +	NOT_PLAT_MSI = 0,
> 
> NOT_PLAT_MSI? Not used anywhere and of course equally self explaining as
> the other one.

Ya, this seems unnecessary, will remove it.

> 
>> +	GEN_PLAT_MSI = 1,
>> +};
>> +
>>   /* Helpers to hide struct msi_desc implementation details */
>>   #define msi_desc_to_dev(desc)		((desc)->dev)
>>   #define dev_to_msi_list(dev)		(&(dev)->msi_list)
>> @@ -140,6 +145,22 @@ struct msi_desc {
>>   #define for_each_msi_entry_safe(desc, tmp, dev)	\
>>   	list_for_each_entry_safe((desc), (tmp), dev_to_msi_list((dev)), list)
>>   
>> +#define dev_to_platform_msi_list(dev)	(&(dev)->platform_msi_list)
>> +#define first_platform_msi_entry(dev)		\
>> +	list_first_entry(dev_to_platform_msi_list((dev)), struct msi_desc, list)
>> +#define for_each_platform_msi_entry(desc, dev)	\
>> +	list_for_each_entry((desc), dev_to_platform_msi_list((dev)), list)
>> +#define for_each_platform_msi_entry_safe(desc, tmp, dev)	\
>> +	list_for_each_entry_safe((desc), (tmp), dev_to_platform_msi_list((dev)), list)
> 
> New lines to seperate macros are bad for readability, right?

Sigh, I was trying to follow the same spacing scheme as is for the msi 
list above. Will make it readable next time around.

> 
>> +#define first_msi_entry_common(dev)	\
>> +	list_first_entry_select((dev)->platform_msi_type, dev_to_platform_msi_list((dev)),	\
>> +				dev_to_msi_list((dev)), struct msi_desc, list)
>> +
>> +#define for_each_msi_entry_common(desc, dev)	\
>> +	list_for_each_entry_select((dev)->platform_msi_type, desc, dev_to_platform_msi_list((dev)), \
>> +				   dev_to_msi_list((dev)), list)	\
>> +
>>   #ifdef CONFIG_IRQ_MSI_IOMMU
>>   static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
>>   {
>> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
>> index eb95f6106a1e..bc5f9e32387f 100644
>> --- a/kernel/irq/msi.c
>> +++ b/kernel/irq/msi.c
>> @@ -320,7 +320,7 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
>>   	struct msi_desc *desc;
>>   	int ret = 0;
>>   
>> -	for_each_msi_entry(desc, dev) {
>> +	for_each_msi_entry_common(desc, dev) {
> 
> This is absolutely unreadable. What's common here? You hide the decision
> which list to iterate behind a misnomed macro.

Hmm, so this macro is basically to be be used by the common code(kernel 
IRQ subsystem for instance) to know which list needs to be traversed, 
msi_list or platform_msi_list of a device.

Finding suitable names for macros is clearly my Achilles heel.

> 
> And looking at the implementation:
> 
>> +#define for_each_msi_entry_common(desc, dev)	\
>> +	list_for_each_entry_select((dev)->platform_msi_type, desc, dev_to_platform_msi_list((dev)), \
>> +				   dev_to_msi_list((dev)), list)	\
> 
> So you implicitely make the decision based on:
> 
>     (dev)->platform_msi_type != 0
> 
> What? How is that ever supposed to work? The changelog says:
> 
>> However, with the introduction of IMS, a device can support IMS as well
>> as MSI-X at the same time. Instead of sharing this list between IMS (a
>> type of platform-msi) and MSI-X descriptors, introduce a new linked list,
>> platform_msi_list, which will hold all the platform-msi descriptors.
> 
> So you are not serious about storing the decision in the device struct
> and then calling into common code?
> 
> That's insane at best. There is absolutely ZERO explanation how this is
> supposed to work and why this could even be remotely correct and safe.
> 

You are right. I think this code would have problems if there is 
concurrent access of the struct device. I probably need to impose some 
kind of locking mechanism here if a device supports both MSI-X and 
platform msi.

> Ever heard of the existance of function arguments?
> 
> Sorry, this is just voodoo programming and not going anywhere.

hmm, will try to ensure sane programming in the next attempt.
> 
> Thanks,
> 
>          tglx
> 

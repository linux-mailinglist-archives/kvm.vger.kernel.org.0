Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE8634DDDC
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 03:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhC3B6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 21:58:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:61672 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229842AbhC3B6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 21:58:04 -0400
IronPort-SDR: Q2pFH/D6ic7dDEl0Q1dHQMgSfJ3pWEO0E7i5ard5okAqYK7qH/fqMsTKecj0DZvfPAVKSsd9SW
 kP67cPlWH1LA==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="276831829"
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="276831829"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 18:58:03 -0700
IronPort-SDR: 4kBCccE83dlaNL80D5bdqGzxLDPB7kdzuqN0OJRCEslhjw4WhqBUSoiX0wmZgPL78MoAakqoM1
 Cwyk1mFWeGBQ==
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="454801775"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.209.158.242]) ([10.209.158.242])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 18:57:54 -0700
Subject: Re: [Patch V2 13/13] genirq/msi: Provide helpers to return Linux
 IRQ/dev_msi hw IRQ number
To:     Marc Zyngier <maz@kernel.org>
Cc:     tglx@linutronix.de, linux-kernel@vger.kernel.org,
        dave.jiang@intel.com, ashok.raj@intel.com, kevin.tian@intel.com,
        dwmw@amazon.co.uk, x86@kernel.org, tony.luck@intel.com,
        dan.j.williams@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
 <1614370277-23235-14-git-send-email-megha.dey@intel.com>
 <87y2ebqfw5.wl-maz@kernel.org>
 <5bed6fea-32e1-d909-0a5c-439d0f0a7dfe@intel.com>
 <87r1k2f4w2.wl-maz@kernel.org>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <64602269-5c82-46ce-b2a0-2586e68e258f@intel.com>
Date:   Tue, 30 Mar 2021 07:27:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <87r1k2f4w2.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/26/2021 6:28 PM, Marc Zyngier wrote:
> On Fri, 26 Mar 2021 01:02:43 +0000,
> "Dey, Megha" <megha.dey@intel.com> wrote:
>> Hi Marc,
>>
>> On 3/25/2021 10:53 AM, Marc Zyngier wrote:
>>> On Fri, 26 Feb 2021 20:11:17 +0000,
>>> Megha Dey <megha.dey@intel.com> wrote:
>>>> From: Dave Jiang <dave.jiang@intel.com>
>>>>
>>>> Add new helpers to get the Linux IRQ number and device specific index
>>>> for given device-relative vector so that the drivers don't need to
>>>> allocate their own arrays to keep track of the vectors and hwirq for
>>>> the multi vector device MSI case.
>>>>
>>>> Reviewed-by: Tony Luck <tony.luck@intel.com>
>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>>> Signed-off-by: Megha Dey <megha.dey@intel.com>
>>>> ---
>>>>    include/linux/msi.h |  2 ++
>>>>    kernel/irq/msi.c    | 44 ++++++++++++++++++++++++++++++++++++++++++++
>>>>    2 files changed, 46 insertions(+)
>>>>
>>>> diff --git a/include/linux/msi.h b/include/linux/msi.h
>>>> index 24abec0..d60a6ba 100644
>>>> --- a/include/linux/msi.h
>>>> +++ b/include/linux/msi.h
>>>> @@ -451,6 +451,8 @@ struct irq_domain *platform_msi_create_irq_domain(struct fwnode_handle *fwnode,
>>>>    int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
>>>>    				   irq_write_msi_msg_t write_msi_msg);
>>>>    void platform_msi_domain_free_irqs(struct device *dev);
>>>> +int msi_irq_vector(struct device *dev, unsigned int nr);
>>>> +int dev_msi_hwirq(struct device *dev, unsigned int nr);
>>>>      /* When an MSI domain is used as an intermediate domain */
>>>>    int msi_domain_prepare_irqs(struct irq_domain *domain, struct device *dev,
>>>> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
>>>> index 047b59d..f2a8f55 100644
>>>> --- a/kernel/irq/msi.c
>>>> +++ b/kernel/irq/msi.c
>>>> @@ -581,4 +581,48 @@ struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
>>>>    	return (struct msi_domain_info *)domain->host_data;
>>>>    }
>>>>    +/**
>>>> + * msi_irq_vector - Get the Linux IRQ number of a device vector
>>>> + * @dev: device to operate on
>>>> + * @nr: device-relative interrupt vector index (0-based).
>>>> + *
>>>> + * Returns the Linux IRQ number of a device vector.
>>>> + */
>>>> +int msi_irq_vector(struct device *dev, unsigned int nr)
>>>> +{
>>>> +	struct msi_desc *entry;
>>>> +	int i = 0;
>>>> +
>>>> +	for_each_msi_entry(entry, dev) {
>>>> +		if (i == nr)
>>>> +			return entry->irq;
>>>> +		i++;
>>> This obviously doesn't work with Multi-MSI, does it?
>> This API is only for devices that support device MSI interrupts. They
>> follow MSI-x format and don't support multi MSI (part of MSI).
>>
>> Not sure if I am missing something here, can you please let me know?
> Nothing in the prototype of the function indicates this limitation,
> nor does the documentation. And I'm not sure why you should exclude
> part of the MSI functionality here. It can't be for performance
> reason, so you might as well make sure this works for all the MSI
> variants:
>
> int msi_irq_vector(struct device *dev, unsigned int nr)
> {
> 	struct msi_desc *entry;
> 	int irq, index = 0;
>
> 	for_each_msi_vector(entry, irq, dev) {
> 		if (index == nr}
> 			return irq;
> 		index++;
> 	}
>
> 	return WARN_ON_ONCE(-EINVAL);
> }
Ok, got it!
>>>> +	}
>>>> +	WARN_ON_ONCE(1);
>>>> +	return -EINVAL;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(msi_irq_vector);
>>>> +
>>>> +/**
>>>> + * dev_msi_hwirq - Get the device MSI hw IRQ number of a device vector
>>>> + * @dev: device to operate on
>>>> + * @nr: device-relative interrupt vector index (0-based).
>>>> + *
>>>> + * Return the dev_msi hw IRQ number of a device vector.
>>>> + */
>>>> +int dev_msi_hwirq(struct device *dev, unsigned int nr)
>>>> +{
>>>> +	struct msi_desc *entry;
>>>> +	int i = 0;
>>>> +
>>>> +	for_each_msi_entry(entry, dev) {
>>>> +		if (i == nr)
>>>> +			return entry->device_msi.hwirq;
>>>> +		i++;
>>>> +	}
>>>> +	WARN_ON_ONCE(1);
>>>> +	return -EINVAL;
>>>> +}
> And this helper would be more generally useful if it returned the n-th
> msi_desc entry rather than some obscure field in a substructure.
>
> struct msi_desc *msi_get_nth_desc(struct device *dev, unsigned int nth)
> {
> 	struct msi_desc *entry = NULL;
> 	unsigned int i = 0;
>
> 	for_each_msi_entry(entry, dev) {
> 		if (i == nth)
> 			return entry;
>
> 		i++;
> 	}
>
> 	WARN_ON_ONCE(!entry);
> 	return entry;
> }
>
> You can always wrap it for your particular use case.
Yeah, makes sense.
>
>>>> +EXPORT_SYMBOL_GPL(dev_msi_hwirq);
>>>> +
>>>>    #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
>>> And what uses these helpers?]
>> These helpers are to be used by a driver series(Intel's IDXD driver)
>> which is currently stuck due to VFIO refactoring.
> Then I's suggest you keep the helpers together with the actual user,
> unless this can generally be useful to existing users (exported
> symbols without in-tree users is always a bit odd).
Yeah in the next submission, we will submit this patch series along with 
the user driver patch series.
>
> Thanks,
>
> 	M.
>

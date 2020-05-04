Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FF31C306A
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 02:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgEDARz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 20:17:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:28922 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgEDARy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 20:17:54 -0400
IronPort-SDR: Boee5l5/Sf5S6QTL7y217d5yff84l4CLFVjoaBhujATJX7gEEFibymSel9wvi8fgGHKo1lndK0
 t09MMhb7yaYg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2020 17:17:54 -0700
IronPort-SDR: +10vBGEU9KeZ43TSO5OBKmwCyM7MhliDlcNPs+FkB2TlmhYYHFah/eeM+xMgPO0qzg/mqgpr9p
 BaSQax47mRfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,349,1583222400"; 
   d="scan'208";a="406316182"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.212.197.87]) ([10.212.197.87])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2020 17:17:52 -0700
Subject: Re: [PATCH RFC 06/15] ims-msi: Enable IMS interrupts
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
 <158751206394.36773.12409950149228811741.stgit@djiang5-desk3.ch.intel.com>
 <87imhntdqx.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <2eecd3e7-8a13-9068-6dbc-a1f105584207@linux.intel.com>
Date:   Sun, 3 May 2020 17:17:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87imhntdqx.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 4/25/2020 3:13 PM, Thomas Gleixner wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
>>   
>> +struct irq_domain *dev_get_ims_domain(struct device *dev)
>> +{
>> +	struct irq_alloc_info info;
>> +
>> +	if (dev_is_mdev(dev))
>> +		dev = mdev_to_parent(dev);
>> +
>> +	init_irq_alloc_info(&info, NULL);
>> +	info.type = X86_IRQ_ALLOC_TYPE_IMS;
> 
> So all IMS capabale devices run on X86? I thought these things are PCIe
> cards which can be plugged into any platform which supports PCIe.

No, IMS is architecture independent.

and yes they are PCIe cards which can be plugged into any platform which 
supports PCIe.
> 
>> +	info.dev = dev;
>> +
>> +	return irq_remapping_get_irq_domain(&info);
>> +}
>> +
>>   static struct msi_domain_ops dev_ims_domain_ops = {
>>   	.get_hwirq	= dev_ims_get_hwirq,
>>   	.msi_prepare	= dev_ims_prepare,
>> diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
>> index 6d8840db4a85..204ce8041c17 100644
>> --- a/drivers/base/platform-msi.c
>> +++ b/drivers/base/platform-msi.c
>> @@ -118,6 +118,8 @@ static void platform_msi_free_descs(struct device *dev, int base, int nvec,
>>   			kfree(platform_msi_group);
>>   		}
>>   	}
>> +
>> +	dev->platform_msi_type = 0;
> 
> I can clearly see the advantage of using '0' over 'NOT_PLAT_MSI'
> here. '0' is definitely more intuitive.
> 

Hmm, this will no longer be needed in the next version of patches.
>>   }
>>   
>>   static int platform_msi_alloc_descs_with_irq(struct device *dev, int virq,
>> @@ -205,18 +207,22 @@ platform_msi_alloc_priv_data(struct device *dev, unsigned int nvec,
>>   	 * accordingly (which would impact the max number of MSI
>>   	 * capable devices).
>>   	 */
>> -	if (!dev->msi_domain || !platform_ops->write_msg || !nvec ||
>> -	    nvec > MAX_DEV_MSIS)
>> +	if (!platform_ops->write_msg || !nvec || nvec > MAX_DEV_MSIS)
>>   		return ERR_PTR(-EINVAL);
>> -	if (dev->msi_domain->bus_token != DOMAIN_BUS_PLATFORM_MSI) {
>> -		dev_err(dev, "Incompatible msi_domain, giving up\n");
>> -		return ERR_PTR(-EINVAL);
>> -	}
>> +	if (dev->platform_msi_type == GEN_PLAT_MSI) {
>> +		if (!dev->msi_domain)
>> +			return ERR_PTR(-EINVAL);
>> +
>> +		if (dev->msi_domain->bus_token != DOMAIN_BUS_PLATFORM_MSI) {
>> +			dev_err(dev, "Incompatible msi_domain, giving up\n");
>> +			return ERR_PTR(-EINVAL);
>> +		}
>>   
>> -	/* Already had a helping of MSI? Greed... */
>> -	if (!list_empty(platform_msi_current_group_entry_list(dev)))
>> -		return ERR_PTR(-EBUSY);
>> +		/* Already had a helping of MSI? Greed... */
>> +		if (!list_empty(platform_msi_current_group_entry_list(dev)))
>> +			return ERR_PTR(-EBUSY);
>> +	}
>>   
>>   	datap = kzalloc(sizeof(*datap), GFP_KERNEL);
>>   	if (!datap)
>> @@ -254,6 +260,7 @@ static void platform_msi_free_priv_data(struct platform_msi_priv_data *data)
>>   int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
>>   				   const struct platform_msi_ops *platform_ops)
>>   {
>> +	dev->platform_msi_type = GEN_PLAT_MSI;
>>   	return platform_msi_domain_alloc_irqs_group(dev, nvec, platform_ops,
>>   									NULL);
>>   }
>> @@ -265,12 +272,18 @@ int platform_msi_domain_alloc_irqs_group(struct device *dev, unsigned int nvec,
>>   {
>>   	struct platform_msi_group_entry *platform_msi_group;
>>   	struct platform_msi_priv_data *priv_data;
>> +	struct irq_domain *domain;
>>   	int err;
>>   
>> -	dev->platform_msi_type = GEN_PLAT_MSI;
> 
> Groan. If you move the type assignment to the caller then do so in a
> separate patch. These all in one combo changes are simply not reviewable
> without getting nuts.

sure, makes sense to add it as a separate patch.
> 
>> -	if (group_id)
>> +	if (!dev->platform_msi_type) {
> 
> That's really consistent. If the caller does not store a type upfront
> then it becomes IMS automagically. Can you pretty please stop to think
> that this IMS stuff is the center of the universe? To be clear, it's
> just another variant of half thought out hardware design fail as all the
> other stuff we already have to support.

well, as we have recently concluded, IMS is merely an extension and 
improvements over the already existing platform-msi. So well, it is not 
the center of the universe indeed.

> 
> Abusing dev->platform_msi_type to decide about the nature of the call
> and then decide that anything which does not set it upfront is IMS is
> really future proof.

Have to think of something else indeed <scratching my head>

> 
>>   		*group_id = ++dev->group_id;
>> +		dev->platform_msi_type = IMS;
> 
> Oh a new type name 'IMS'. Well suited into the naming scheme.

coming up with a coherent naming scheme in the next version of patches.
> 
>> +		domain = dev_get_ims_domain(dev);
> 
> No. This is completely inconsistent again and a blatant violation of
> layering.

yes, i earlier thought what differentiates the already existing 
platform-msi from IMS is that IMS has to have IR enabled and thus we 
need  to have some way to finding the IRQ domain corresponding to that 
interrupt remapping unit. Now that this theory is not true, we would not 
be needing this call after all.

> 
> Thanks,
> 
>          tglx
> 

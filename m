Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF178229D83
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731051AbgGVQuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:50:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:12009 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgGVQux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 12:50:53 -0400
IronPort-SDR: yiVEIujHbbYbaMEjiDiNcyTh5qmSgLPkrBiPOSmYpj6la6z/3lzSMs9ZwvI9PzJlF9sItzlAOc
 b/rp1EmHkp+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="215002841"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="215002841"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 09:50:51 -0700
IronPort-SDR: L+8m7J8RWmfQdUFP7nNVsRis/hvFKPt3CUmzdUuG4sPpU5xSTU/i5zwca/aG50/A9u2+9/d4gx
 vrvmDvcVD7gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="462526859"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga005.jf.intel.com with ESMTP; 22 Jul 2020 09:50:50 -0700
Received: from [10.254.181.38] (10.254.181.38) by ORSMSX101.amr.corp.intel.com
 (10.22.225.128) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 22 Jul
 2020 09:50:50 -0700
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Dave Jiang <dave.jiang@intel.com>
CC:     <vkoul@kernel.org>, <maz@kernel.org>, <bhelgaas@google.com>,
        <rafael@kernel.org>, <gregkh@linuxfoundation.org>,
        <tglx@linutronix.de>, <hpa@zytor.com>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
        <ashok.raj@intel.com>, <yi.l.liu@intel.com>, <baolu.lu@intel.com>,
        <kevin.tian@intel.com>, <sanjay.k.kumar@intel.com>,
        <tony.luck@intel.com>, <jing.lin@intel.com>,
        <dan.j.williams@intel.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <parav@mellanox.com>,
        <dave.hansen@intel.com>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        <pbonzini@redhat.com>, <samuel.ortiz@intel.com>,
        <mona.hossain@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <20200721161344.GA2021248@mellanox.com>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <a99af84f-f3ef-ee3c-1f94-680909e97868@intel.com>
Date:   Wed, 22 Jul 2020 09:50:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721161344.GA2021248@mellanox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.254.181.38]
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 7/21/2020 9:13 AM, Jason Gunthorpe wrote:
> On Tue, Jul 21, 2020 at 09:02:28AM -0700, Dave Jiang wrote:
>> From: Megha Dey <megha.dey@intel.com>
>>
>> Add support for the creation of a new DEV_MSI irq domain. It creates a
>> new irq chip associated with the DEV_MSI domain and adds the necessary
>> domain operations to it.
>>
>> Add a new config option DEV_MSI which must be enabled by any
>> driver that wants to support device-specific message-signaled-interrupts
>> outside of PCI-MSI(-X).
>>
>> Lastly, add device specific mask/unmask callbacks in addition to a write
>> function to the platform_msi_ops.
>>
>> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Megha Dey <megha.dey@intel.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>   arch/x86/include/asm/hw_irq.h |    5 ++
>>   drivers/base/Kconfig          |    7 +++
>>   drivers/base/Makefile         |    1
>>   drivers/base/dev-msi.c        |   95 +++++++++++++++++++++++++++++++++++++++++
>>   drivers/base/platform-msi.c   |   45 +++++++++++++------
>>   drivers/base/platform-msi.h   |   23 ++++++++++
>>   include/linux/msi.h           |    8 +++
>>   7 files changed, 168 insertions(+), 16 deletions(-)
>>   create mode 100644 drivers/base/dev-msi.c
>>   create mode 100644 drivers/base/platform-msi.h
>>
>> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
>> index 74c12437401e..8ecd7570589d 100644
>> +++ b/arch/x86/include/asm/hw_irq.h
>> @@ -61,6 +61,11 @@ struct irq_alloc_info {
>>   			irq_hw_number_t	msi_hwirq;
>>   		};
>>   #endif
>> +#ifdef CONFIG_DEV_MSI
>> +		struct {
>> +			irq_hw_number_t hwirq;
>> +		};
>> +#endif
> 
> Why is this in this patch? I didn't see an obvious place where it is
> used?

Since I have introduced the DEV-MSI domain and related ops, this is 
required in the dev_msi_set_hwirq and dev_msi_set_desc in this patch.

>>   
>> +static void __platform_msi_desc_mask_unmask_irq(struct msi_desc *desc, u32 mask)
>> +{
>> +	const struct platform_msi_ops *ops;
>> +
>> +	ops = desc->platform.msi_priv_data->ops;
>> +	if (!ops)
>> +		return;
>> +
>> +	if (mask) {
>> +		if (ops->irq_mask)
>> +			ops->irq_mask(desc);
>> +	} else {
>> +		if (ops->irq_unmask)
>> +			ops->irq_unmask(desc);
>> +	}
>> +}
>> +
>> +void platform_msi_mask_irq(struct irq_data *data)
>> +{
>> +	__platform_msi_desc_mask_unmask_irq(irq_data_get_msi_desc(data), 1);
>> +}
>> +
>> +void platform_msi_unmask_irq(struct irq_data *data)
>> +{
>> +	__platform_msi_desc_mask_unmask_irq(irq_data_get_msi_desc(data), 0);
>> +}
> 
> This is a bit convoluted, just call the op directly:
> 
> void platform_msi_unmask_irq(struct irq_data *data)
> {
> 	const struct platform_msi_ops *ops = desc->platform.msi_priv_data->ops;
> 
> 	if (ops->irq_unmask)
> 		ops->irq_unmask(desc);
> }
>

Sure, I will update this.

>> diff --git a/include/linux/msi.h b/include/linux/msi.h
>> index 7f6a8eb51aca..1da97f905720 100644
>> +++ b/include/linux/msi.h
>> @@ -323,9 +323,13 @@ enum {
>>   
>>   /*
>>    * platform_msi_ops - Callbacks for platform MSI ops
>> + * @irq_mask:   mask an interrupt source
>> + * @irq_unmask: unmask an interrupt source
>>    * @write_msg:	write message content
>>    */
>>   struct platform_msi_ops {
>> +	unsigned int            (*irq_mask)(struct msi_desc *desc);
>> +	unsigned int            (*irq_unmask)(struct msi_desc *desc);
> 
> Why do these functions return things if the only call site throws it
> away?

Hmmm, fair enough, I will change it to void.

> 
> Jason
> 

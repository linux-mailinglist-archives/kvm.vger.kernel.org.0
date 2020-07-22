Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510F6229DB9
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 19:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731378AbgGVRDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 13:03:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:13584 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbgGVRDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 13:03:49 -0400
IronPort-SDR: WncTuVHB6W+2q2Dku1w0kCI1soF6shXjWgHmIwAdhIj3Q62ob4p49w+dH2m3rXas8o6Bwj5EFo
 2k6EqhezeyNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="215007242"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="215007242"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 10:03:48 -0700
IronPort-SDR: kZ7E+EWBoHhQmGLIn6X8M9EMk6wAI4cZKfcD9O1Bld2YtAg/0tt7cAw/BySjHNbl5PjqTD9eQJ
 zNMN1KUY8iRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="328275881"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga007.jf.intel.com with ESMTP; 22 Jul 2020 10:03:48 -0700
Received: from [10.254.181.38] (10.254.181.38) by ORSMSX101.amr.corp.intel.com
 (10.22.225.128) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 22 Jul
 2020 10:03:48 -0700
Subject: Re: [PATCH RFC v2 03/18] irq/dev-msi: Create IR-DEV-MSI irq domain
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
 <159534735519.28840.10435935598386192252.stgit@djiang5-desk3.ch.intel.com>
 <20200721162104.GB2021248@mellanox.com>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <84fd4ae2-e7ee-4f9d-7686-6a034f3e2614@intel.com>
Date:   Wed, 22 Jul 2020 10:03:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721162104.GB2021248@mellanox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.254.181.38]
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dan,

On 7/21/2020 9:21 AM, Jason Gunthorpe wrote:
> On Tue, Jul 21, 2020 at 09:02:35AM -0700, Dave Jiang wrote:
>> From: Megha Dey <megha.dey@intel.com>
>>
>> When DEV_MSI is enabled, the dev_msi_default_domain is updated to the
>> base DEV-MSI irq  domain. If interrupt remapping is enabled, we create
>> a new IR-DEV-MSI irq domain and update the dev_msi_default domain to
>> the same.
>>
>> For X86, introduce a new irq_alloc_type which will be used by the
>> interrupt remapping driver.
> 
> Why? Shouldn't this by symmetrical with normal MSI? Does MSI do this?

Since I am introducing the new dev msi domain for the case when IR_REMAP 
is turned on, I have introduced the new type in this patch.

MSI/MSIX have their own irq alloc types which are also only used by the 
intel remapping driver..

> 
> I would have thought you'd want to switch to this remapping mode as
> part of vfio or something like current cases.

Can you let me know what current case you are referring to?
> 
>> +struct irq_domain *create_remap_dev_msi_irq_domain(struct irq_domain *parent,
>> +						   const char *name)
>> +{
>> +	struct fwnode_handle *fn;
>> +	struct irq_domain *domain;
>> +
>> +	fn = irq_domain_alloc_named_fwnode(name);
>> +	if (!fn)
>> +		return NULL;
>> +
>> +	domain = msi_create_irq_domain(fn, &dev_msi_ir_domain_info, parent);
>> +	if (!domain) {
>> +		pr_warn("failed to initialize irqdomain for IR-DEV-MSI.\n");
>> +		return ERR_PTR(-ENXIO);
>> +	}
>> +
>> +	irq_domain_update_bus_token(domain, DOMAIN_BUS_PLATFORM_MSI);
>> +
>> +	if (!dev_msi_default_domain)
>> +		dev_msi_default_domain = domain;
>> +
>> +	return domain;
>> +}
> 
> What about this code creates a "remap" ? ie why is the function called
> "create_remap" ?

Well, this function creates a new domain for the case when IR_REMAP is 
enabled, hence I called it create_remap...

> 
>> diff --git a/include/linux/msi.h b/include/linux/msi.h
>> index 1da97f905720..7098ba566bcd 100644
>> +++ b/include/linux/msi.h
>> @@ -378,6 +378,9 @@ void *platform_msi_get_host_data(struct irq_domain *domain);
>>   void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg);
>>   void platform_msi_unmask_irq(struct irq_data *data);
>>   void platform_msi_mask_irq(struct irq_data *data);
>> +
>> +int dev_msi_prepare(struct irq_domain *domain, struct device *dev,
>> +                           int nvec, msi_alloc_info_t *arg);
> 
> I wonder if this should use the popular #ifdef dev_msi_prepare scheme
> instead of a weak symbol?

Ok, I will look into the #ifdef option.
> 
> Jason
> 

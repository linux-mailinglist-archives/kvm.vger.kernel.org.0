Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59F11C3067
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 02:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgEDAQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 20:16:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:20142 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgEDAQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 20:16:21 -0400
IronPort-SDR: hZsb/znyya6IWicCjbNKIdLvLOpNKUlYWedml7PyPj7E/16xRBnV2Wns/3PAfZYare+dDWVa7s
 nzW+qjMSmgZQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2020 17:16:20 -0700
IronPort-SDR: 0TrHIBMO8krjniVOj8ku1aw5a1xa7KLZrorAxn5r61A2Mcmm+Pt0Hh/hJlGIe7ukIr2PHSH5HI
 z6N45QguWqlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,349,1583222400"; 
   d="scan'208";a="406316016"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.212.197.87]) ([10.212.197.87])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2020 17:16:18 -0700
Subject: Re: [PATCH RFC 05/15] ims-msi: Add mask/unmask routines
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
 <158751205785.36773.16321096654677399376.stgit@djiang5-desk3.ch.intel.com>
 <87lfmjtevb.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <cc3a136c-5f1f-20fb-86bd-d22230e0a372@linux.intel.com>
Date:   Sun, 3 May 2020 17:16:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87lfmjtevb.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 4/25/2020 2:49 PM, Thomas Gleixner wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
>>   
>> +static u32 __dev_ims_desc_mask_irq(struct msi_desc *desc, u32 flag)
> 
> ...mask_irq()? This is doing both mask and unmask depending on the
> availability of the ops callbacks.

yes, should have called it __dev_ims_desc_mask_unmask_irq perhaps.
> 
>> +{
>> +	u32 mask_bits = desc->platform.masked;
>> +	const struct platform_msi_ops *ops;
>> +
>> +	ops = desc->platform.msi_priv_data->ops;
>> +	if (!ops)
>> +		return 0;
>> +
>> +	if (flag) {
> 
> flag? Darn, this has a clear boolean meaning of mask or unmask and 'u32
> flag' is the most natural and obvious self explaining expression for
> this, right?

will change it a more meaningful name next time around ..
> 
>> +		if (ops->irq_mask)
>> +			mask_bits = ops->irq_mask(desc);
>> +	} else {
>> +		if (ops->irq_unmask)
>> +			mask_bits = ops->irq_unmask(desc);
>> +	}
>> +
>> +	return mask_bits;
> 
> What's mask_bits? This is about _ONE_ IMS interrupt. Can it have
> multiple mask bits and if so then the explanation which I decoded by
> crystal ball probably looks like this:
> 
> Bit  0:  Don't know whether it's masked
> Bit  1:  Perhaps it's masked
> Bit  2:  Probably it's masked
> Bit  3:  Mostly masked
> ...
> Bit 31:  Fully masked
> 
> Or something like that. Makes a lot of sense in a XKCD cartoon at least.
> 

After a close look, we can simply do away with this mask_bits. Looks 
like a crystal ball will not be required next time around after all.

>> +}
>> +
>> +/**
>> + * dev_ims_mask_irq - Generic irq chip callback to mask IMS interrupts
>> + * @data: pointer to irqdata associated to that interrupt
>> + */
>> +static void dev_ims_mask_irq(struct irq_data *data)
>> +{
>> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
>> +
>> +	desc->platform.masked = __dev_ims_desc_mask_irq(desc, 1);
> 
> The purpose of this masked information is?

serves no purpose, borrowed this concept from the PCI-msi code but is 
just junk here.  Will be removed next time around.

> 
> Thanks,
> 
>          tglx
> 

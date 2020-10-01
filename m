Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AD4280B53
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 01:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733197AbgJAX0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 19:26:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:39871 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727713AbgJAX0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 19:26:20 -0400
IronPort-SDR: HTCOHOC4ycNgr7vsenO6dLUImVwXD7CUBOuOAqz1rR7cccDRA6qCnhyjah8bhFXHtg6M3zCQNe
 wPB+rdrdrWgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="163721194"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="163721194"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 16:26:17 -0700
IronPort-SDR: KDe/TREHxMZMzvT4niiDF7Il7EMjmhE5m9PgMT3Joxrh2etHTNA5PR2x4tZfdyqQS0gmIyg8wV
 1zrVuGssbO4Q==
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="514963490"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.209.13.228]) ([10.209.13.228])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 16:26:15 -0700
Subject: Re: [PATCH v3 02/18] iommu/vt-d: Add DEV-MSI support
To:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, rafael@kernel.org,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021246905.67751.1674517279122764758.stgit@djiang5-desk3.ch.intel.com>
 <87zh57glow.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <694548eb-9e07-cf1d-72fa-fa29ce78a15c@intel.com>
Date:   Thu, 1 Oct 2020 16:26:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87zh57glow.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 9/30/2020 11:32 AM, Thomas Gleixner wrote:
> On Tue, Sep 15 2020 at 16:27, Dave Jiang wrote:
>> @@ -1303,9 +1303,10 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
>>   	case X86_IRQ_ALLOC_TYPE_HPET:
>>   	case X86_IRQ_ALLOC_TYPE_PCI_MSI:
>>   	case X86_IRQ_ALLOC_TYPE_PCI_MSIX:
>> +	case X86_IRQ_ALLOC_TYPE_DEV_MSI:
>>   		if (info->type == X86_IRQ_ALLOC_TYPE_HPET)
>>   			set_hpet_sid(irte, info->devid);
>> -		else
>> +		else if (info->type != X86_IRQ_ALLOC_TYPE_DEV_MSI)
>>   			set_msi_sid(irte,
>>   			msi_desc_to_pci_dev(info->desc));
> Gah. this starts to become unreadable.
hmm ok will change it.
>
> diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
> index 8f4ce72570ce..0c1ea8ceec31 100644
> --- a/drivers/iommu/intel/irq_remapping.c
> +++ b/drivers/iommu/intel/irq_remapping.c
> @@ -1271,6 +1271,16 @@ static struct irq_chip intel_ir_chip = {
>   	.irq_set_vcpu_affinity	= intel_ir_set_vcpu_affinity,
>   };
>   
> +static void irte_prepare_msg(struct msi_msg *msg, int index, int subhandle)
> +{
> +	msg->address_hi = MSI_ADDR_BASE_HI;
> +	msg->data = sub_handle;
> +	msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
> +			  MSI_ADDR_IR_SHV |
> +			  MSI_ADDR_IR_INDEX1(index) |
> +			  MSI_ADDR_IR_INDEX2(index);
> +}
> +
>   static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
>   					     struct irq_cfg *irq_cfg,
>   					     struct irq_alloc_info *info,
> @@ -1312,19 +1322,18 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
>   		break;
>   
>   	case X86_IRQ_ALLOC_TYPE_HPET:
> +		set_hpet_sid(irte, info->hpet_id);
> +		irte_prepare_msg(msg, index, sub_handle);
> +		break;
> +
>   	case X86_IRQ_ALLOC_TYPE_MSI:
>   	case X86_IRQ_ALLOC_TYPE_MSIX:
> -		if (info->type == X86_IRQ_ALLOC_TYPE_HPET)
> -			set_hpet_sid(irte, info->hpet_id);
> -		else
> -			set_msi_sid(irte, info->msi_dev);
> -
> -		msg->address_hi = MSI_ADDR_BASE_HI;
> -		msg->data = sub_handle;
> -		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
> -				  MSI_ADDR_IR_SHV |
> -				  MSI_ADDR_IR_INDEX1(index) |
> -				  MSI_ADDR_IR_INDEX2(index);
> +		set_msi_sid(irte, info->msi_dev);
> +		irte_prepare_msg(msg, index, sub_handle);
> +		break;
> +
> +	case X86_IRQ_ALLOC_TYPE_DEV_MSI:
> +		irte_prepare_msg(msg, index, sub_handle);
>   		break;
>   
>   	default:
>
> Hmm?

ok so I have no clue what happened here. This was the patch that was 
sent out:

https://lore.kernel.org/lkml/160021246905.67751.1674517279122764758.stgit@djiang5-desk3.ch.intel.com/

and this does not have the above change. Not sure what happened here.

Anyways, this should not be there.

>
> Thanks,
>
>          tglx

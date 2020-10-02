Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C704281109
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 13:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgJBLNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 07:13:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41954 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgJBLNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 07:13:11 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601637188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ae6uj54DLReKntwK3f3MhhctDW9LMS1yxz+NDrn5hYk=;
        b=R9sWRmIFJnHFbKoX49JTZ2uZAQJAUanuIbYBPTf4pU1iYxdYQpJ+ENHQDKSuYz+1E7Oi7I
        T8KUyP/j42tjoM71oYlWC82hT2FiPVw+Ul5B3zJQFg/f1pcavCDDGYTR/RZaHXrJCZyaXq
        PmCiX18BzvH11UzALdTMS4++BOV98QYXyAhYpX8lHNimD2fGjSM1xi9B6Qq9XVX9aECWar
        wQj+cLgv/m9ghYmIlXxNUxX4uXNTv2Htc3Pje7Nu+h5fTHCuMPzzvMmcX7e0fb/bJbY84r
        adq6tTJ6qSHS9kWjTsBjsXH7xG9+JIhyJMuE4GeW4Url+u7n4gjm3o7Ri6juIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601637188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ae6uj54DLReKntwK3f3MhhctDW9LMS1yxz+NDrn5hYk=;
        b=XjsXCfyC+vYZDb0I/+LVSBDs+bfpB6EywvozF7DG8PiQ98qmQWAbP/g5epAhNJbzy52lXT
        2ntevf+maiuabVBw==
To:     "Dey\, Megha" <megha.dey@intel.com>,
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
Subject: Re: [PATCH v3 02/18] iommu/vt-d: Add DEV-MSI support
In-Reply-To: <694548eb-9e07-cf1d-72fa-fa29ce78a15c@intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com> <160021246905.67751.1674517279122764758.stgit@djiang5-desk3.ch.intel.com> <87zh57glow.fsf@nanos.tec.linutronix.de> <694548eb-9e07-cf1d-72fa-fa29ce78a15c@intel.com>
Date:   Fri, 02 Oct 2020 13:13:08 +0200
Message-ID: <874kncev97.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 01 2020 at 16:26, Megha Dey wrote:
> On 9/30/2020 11:32 AM, Thomas Gleixner wrote:
>> diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
>> index 8f4ce72570ce..0c1ea8ceec31 100644
>> --- a/drivers/iommu/intel/irq_remapping.c
>> +++ b/drivers/iommu/intel/irq_remapping.c
>> @@ -1271,6 +1271,16 @@ static struct irq_chip intel_ir_chip = {
>>   	.irq_set_vcpu_affinity	= intel_ir_set_vcpu_affinity,
>>   };
>>   
>> +static void irte_prepare_msg(struct msi_msg *msg, int index, int subhandle)
>> +{
>> +	msg->address_hi = MSI_ADDR_BASE_HI;
>> +	msg->data = sub_handle;
>> +	msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
>> +			  MSI_ADDR_IR_SHV |
>> +			  MSI_ADDR_IR_INDEX1(index) |
>> +			  MSI_ADDR_IR_INDEX2(index);
>> +}
>> +
>>   static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
>>   					     struct irq_cfg *irq_cfg,
>>   					     struct irq_alloc_info *info,
>> @@ -1312,19 +1322,18 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
>>   		break;
>>   
>>   	case X86_IRQ_ALLOC_TYPE_HPET:
>> +		set_hpet_sid(irte, info->hpet_id);
>> +		irte_prepare_msg(msg, index, sub_handle);
>> +		break;
>> +
>>   	case X86_IRQ_ALLOC_TYPE_MSI:
>>   	case X86_IRQ_ALLOC_TYPE_MSIX:
>> -		if (info->type == X86_IRQ_ALLOC_TYPE_HPET)
>> -			set_hpet_sid(irte, info->hpet_id);
>> -		else
>> -			set_msi_sid(irte, info->msi_dev);
>> -
>> -		msg->address_hi = MSI_ADDR_BASE_HI;
>> -		msg->data = sub_handle;
>> -		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
>> -				  MSI_ADDR_IR_SHV |
>> -				  MSI_ADDR_IR_INDEX1(index) |
>> -				  MSI_ADDR_IR_INDEX2(index);
>> +		set_msi_sid(irte, info->msi_dev);
>> +		irte_prepare_msg(msg, index, sub_handle);
>> +		break;
>> +
>> +	case X86_IRQ_ALLOC_TYPE_DEV_MSI:
>> +		irte_prepare_msg(msg, index, sub_handle);
>>   		break;
>>   
>>   	default:
>>
>> Hmm?
>
> ok so I have no clue what happened here. This was the patch that was 
> sent out:
> and this does not have the above change. Not sure what happened here.

Of course it was not there. I added this in my reply obviously for
illustration. It's not '> ' quoted, right?

Thanks,

        tglx

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56A53372A7
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 13:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhCKMcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 07:32:11 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13879 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbhCKMcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 07:32:03 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Dx7Z970zlz7p3Q;
        Thu, 11 Mar 2021 20:30:09 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 20:31:49 +0800
Subject: Re: [PATCH v3 2/4] KVM: arm64: GICv4.1: Try to save hw pending state
 in save_pending_tables
To:     Marc Zyngier <maz@kernel.org>
CC:     Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210127121337.1092-1-lushenming@huawei.com>
 <20210127121337.1092-3-lushenming@huawei.com> <87v99yf450.wl-maz@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <3b47598f-0795-a165-1a64-abe02258b306@huawei.com>
Date:   Thu, 11 Mar 2021 20:31:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <87v99yf450.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/11 17:09, Marc Zyngier wrote:
> On Wed, 27 Jan 2021 12:13:35 +0000,
> Shenming Lu <lushenming@huawei.com> wrote:
>>
>> After pausing all vCPUs and devices capable of interrupting, in order
>> to save the information of all interrupts, besides flushing the pending
>> states in kvm’s vgic, we also try to flush the states of VLPIs in the
>> virtual pending tables into guest RAM, but we need to have GICv4.1 and
>> safely unmap the vPEs first.
>>
>> As for the saving of VSGIs, which needs the vPEs to be mapped and might
>> conflict with the saving of VLPIs, but since we will map the vPEs back
>> at the end of save_pending_tables and both savings require the kvm->lock
>> to be held (only happen serially), it will work fine.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v3.c | 61 +++++++++++++++++++++++++++++++----
>>  1 file changed, 55 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
>> index 52915b342351..06b1162b7a0a 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>> @@ -1,6 +1,8 @@
>>  // SPDX-License-Identifier: GPL-2.0-only
>>  
>>  #include <linux/irqchip/arm-gic-v3.h>
>> +#include <linux/irq.h>
>> +#include <linux/irqdomain.h>
>>  #include <linux/kvm.h>
>>  #include <linux/kvm_host.h>
>>  #include <kvm/arm_vgic.h>
>> @@ -356,6 +358,32 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
>>  	return 0;
>>  }
>>  
>> +/*
>> + * The deactivation of the doorbell interrupt will trigger the
>> + * unmapping of the associated vPE.
>> + */
>> +static void unmap_all_vpes(struct vgic_dist *dist)
>> +{
>> +	struct irq_desc *desc;
>> +	int i;
>> +
>> +	for (i = 0; i < dist->its_vm.nr_vpes; i++) {
>> +		desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
>> +		irq_domain_deactivate_irq(irq_desc_get_irq_data(desc));
>> +	}
>> +}
>> +
>> +static void map_all_vpes(struct vgic_dist *dist)
>> +{
>> +	struct irq_desc *desc;
>> +	int i;
>> +
>> +	for (i = 0; i < dist->its_vm.nr_vpes; i++) {
>> +		desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
>> +		irq_domain_activate_irq(irq_desc_get_irq_data(desc), false);
>> +	}
>> +}
>> +
>>  /**
>>   * vgic_v3_save_pending_tables - Save the pending tables into guest RAM
>>   * kvm lock and all vcpu lock must be held
>> @@ -365,14 +393,26 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
>>  	struct vgic_dist *dist = &kvm->arch.vgic;
>>  	struct vgic_irq *irq;
>>  	gpa_t last_ptr = ~(gpa_t)0;
>> -	int ret;
>> +	bool vlpi_avail = false;
>> +	int ret = 0;
>>  	u8 val;
>>  
>> +	/*
>> +	 * As a preparation for getting any VLPI states.
>> +	 * The vgic initialized check ensures that the allocation and
>> +	 * enabling of the doorbells have already been done.
>> +	 */
>> +	if (kvm_vgic_global_state.has_gicv4_1 && !WARN_ON(!vgic_initialized(kvm))) {
> 
> Should we bail out if we ever spot !vgic_initialized()? In general, I
> find the double negation horrible to read).

Ok, I will change it.

> 
>> +		unmap_all_vpes(dist);
>> +		vlpi_avail = true;
>> +	}
>> +
>>  	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
>>  		int byte_offset, bit_nr;
>>  		struct kvm_vcpu *vcpu;
>>  		gpa_t pendbase, ptr;
>>  		bool stored;
>> +		bool is_pending = irq->pending_latch;
>>  
>>  		vcpu = irq->target_vcpu;
>>  		if (!vcpu)
>> @@ -387,24 +427,33 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
>>  		if (ptr != last_ptr) {
>>  			ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
>>  			if (ret)
>> -				return ret;
>> +				goto out;
>>  			last_ptr = ptr;
>>  		}
>>  
>>  		stored = val & (1U << bit_nr);
>> -		if (stored == irq->pending_latch)
>> +
>> +		if (irq->hw && vlpi_avail)
>> +			vgic_v4_get_vlpi_state(irq, &is_pending);
> 
> Keep the 'is_pending = irq->pending_latch;' statement close to the VPT
> read, since they represent the same state.

Ok, make sense.

> 
>> +
>> +		if (stored == is_pending)
>>  			continue;
>>  
>> -		if (irq->pending_latch)
>> +		if (is_pending)
>>  			val |= 1 << bit_nr;
>>  		else
>>  			val &= ~(1 << bit_nr);
>>  
>>  		ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
>>  		if (ret)
>> -			return ret;
>> +			goto out;
>>  	}
>> -	return 0;
>> +
>> +out:
>> +	if (vlpi_avail)
>> +		map_all_vpes(dist);
> 
> I have asked that question in the past: is it actually safe to remap
> the vPEs and expect them to be runnable

In my opinion, logically it can work, but there might be problems like the
one below that I didn't notice...

> 
> Also, the current code assumes that VMAPP.PTZ can be advertised if a
> VPT is mapped for the first time. Clearly, it is unlikely that the VPT
> will be only populated with 0s, so you'll end up with state corruption
> on the first remap.

Oh, thanks for pointing it out.
And if we always signal PTZ when alloc = 1, does it mean that we can't remap the
vPE when the VPT is not empty, thus there is no chance to get the VLPI state?
Could we just assume that the VPT is not empty when first mapping the vPE?

Thanks,
Shenming

> 
> Thanks,
> 
> 	M.
> 

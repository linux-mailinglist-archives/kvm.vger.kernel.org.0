Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE13F351B5D
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237183AbhDASHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20114 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237727AbhDASEP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:04:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617300255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GFqm7MtswlDt29I18m6aQXuaNt4r3QEfuimxe7MXKE4=;
        b=E5uEMOJXbSIwreDX9j1ssBGNKOXahoCGTKBijxszmeB7HsHoyRR3NM6JQ5jfwjJ+kLVDpM
        9D+2xuXBA6N5kWLxKAmTKnO+VZtMNrQSkt3DGA4YgjtxephnuPnY3lRAj30hF8nU/mS0ID
        QsbkqaDMHADsJ3lBlA0YmNDKQGD8srs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-mwMCNo7GM2OTGZXmbFjXTw-1; Thu, 01 Apr 2021 13:03:30 -0400
X-MC-Unique: mwMCNo7GM2OTGZXmbFjXTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90C2C10059D0;
        Thu,  1 Apr 2021 17:03:29 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF9A919C46;
        Thu,  1 Apr 2021 17:03:26 +0000 (UTC)
Subject: Re: [PATCH v4 7/8] KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for
 userspace
To:     Marc Zyngier <maz@kernel.org>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20210401085238.477270-1-eric.auger@redhat.com>
 <20210401085238.477270-8-eric.auger@redhat.com>
 <87tuoqp1du.wl-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b2458147-cd53-8712-9120-7ee9b84152aa@redhat.com>
Date:   Thu, 1 Apr 2021 19:03:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <87tuoqp1du.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 4/1/21 3:42 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On Thu, 01 Apr 2021 09:52:37 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>>
>> Commit 23bde34771f1 ("KVM: arm64: vgic-v3: Drop the
>> reporting of GICR_TYPER.Last for userspace") temporarily fixed
>> a bug identified when attempting to access the GICR_TYPER
>> register before the redistributor region setting, but dropped
>> the support of the LAST bit.
>>
>> Emulating the GICR_TYPER.Last bit still makes sense for
>> architecture compliance though. This patch restores its support
>> (if the redistributor region was set) while keeping the code safe.
>>
>> We introduce a new helper, vgic_mmio_vcpu_rdist_is_last() which
>> computes whether a redistributor is the highest one of a series
>> of redistributor contributor pages.
>>
>> The spec says "Indicates whether this Redistributor is the
>> highest-numbered Redistributor in a series of contiguous
>> Redistributor pages."
>>
>> The code is a bit convulated since there is no guarantee
> 
> nit: convoluted
> 
>> redistributors are added in a given reditributor region in
>> ascending order. In that case the current implementation was
>> wrong. Also redistributor regions can be contiguous
>> and registered in non increasing base address order.
>>
>> So the index of redistributors are stored in an array within
>> the redistributor region structure.
>>
>> With this new implementation we do not need to have a uaccess
>> read accessor anymore.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> This patch also hurt my head, a lot more than the first one.  See
> below.
> 
>> ---
>>  arch/arm64/kvm/vgic/vgic-init.c    |  7 +--
>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 97 ++++++++++++++++++++----------
>>  arch/arm64/kvm/vgic/vgic.h         |  1 +
>>  include/kvm/arm_vgic.h             |  3 +
>>  4 files changed, 73 insertions(+), 35 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
>> index cf6faa0aeddb2..61150c34c268c 100644
>> --- a/arch/arm64/kvm/vgic/vgic-init.c
>> +++ b/arch/arm64/kvm/vgic/vgic-init.c
>> @@ -190,6 +190,7 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>>  	int i;
>>  
>>  	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
>> +	vgic_cpu->index = vcpu->vcpu_id;
> 
> Is it so that vgic_cpu->index is always equal to vcpu_id? If so, why
> do we need another field? We can always get to the vcpu using a
> container_of().
> 
>>  
>>  	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
>>  	raw_spin_lock_init(&vgic_cpu->ap_list_lock);
>> @@ -338,10 +339,8 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>>  	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
>>  
>>  	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
>> -		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list) {
>> -			list_del(&rdreg->list);
>> -			kfree(rdreg);
>> -		}
>> +		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list)
>> +			vgic_v3_free_redist_region(rdreg);
> 
> Consider moving the introduction of vgic_v3_free_redist_region() into
> a separate patch. On its own, that's a good readability improvement.
> 
>>  		INIT_LIST_HEAD(&dist->rd_regions);
>>  	} else {
>>  		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> index 987e366c80008..f6a7eed1d6adb 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> @@ -251,45 +251,57 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
>>  		vgic_enable_lpis(vcpu);
>>  }
>>  
>> +static bool vgic_mmio_vcpu_rdist_is_last(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	struct vgic_redist_region *rdreg = vgic_cpu->rdreg;
>> +
>> +	if (!rdreg)
>> +		return false;
>> +
>> +	if (rdreg->count && vgic_cpu->rdreg_index == (rdreg->count - 1)) {
>> +		/* check whether there is no other contiguous rdist region */
>> +		struct list_head *rd_regions = &vgic->rd_regions;
>> +		struct vgic_redist_region *iter;
>> +
>> +		list_for_each_entry(iter, rd_regions, list) {
>> +			if (iter->base == rdreg->base + rdreg->count * KVM_VGIC_V3_REDIST_SIZE &&
>> +				iter->free_index > 0) {
>> +			/* check the first rdist index of this region, if any */
>> +				if (vgic_cpu->index < iter->rdist_indices[0])
>> +					return false;
> 
> rdist_indices[] contains the vcpu_id of the vcpu associated with a
> given RD in the region. At this stage, you have established that there
> is another region that is contiguous with the one associated with our
> vcpu. You also know that this adjacent region has a vcpu mapped in
> (free_index isn't 0). Isn't that enough to declare that our vcpu isn't
> last?  I definitely don't understand what the index comparison does
> here.
Assume the following case:
2 RDIST region
region #0 contains rdist 1, 2, 4
region #1, adjacent to #0 contains rdist 3

Spec days:
"Indicates whether this Redistributor is the
highest-numbered Redistributor in a series of contiguous
Redistributor pages."

To me 4 is last and 3 is last too.


> 
> It also seem to me that some of the complexity could be eliminated if
> the regions were kept ordered at list insertion time.
yes
> 
>> +			}
>> +		}
>> +	} else if (vgic_cpu->rdreg_index < rdreg->free_index - 1) {
>> +		/* look at the index of next rdist */
>> +		int next_rdist_index = rdreg->rdist_indices[vgic_cpu->rdreg_index + 1];
>> +
>> +		if (vgic_cpu->index < next_rdist_index)
>> +			return false;
> 
> Same thing here. We are in the middle of the allocated part of a
> region, which means we cannot be last. I still don't get the index
> check.
Because within a region, nothing hinders rdist from being allocated in
non ascending order. I exercise those cases in the kvmselftests

one single RDIST region with the following rdists allocated there:
1, 3, 2

3 and 2 are "last", right? Or did I miss something. Yes that's totally
not natural to do that kind of allocation but the API allows to do that.


> 
>> +	}
>> +	return true;
>> +}
>> +
>>  static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>>  					      gpa_t addr, unsigned int len)
>>  {
>>  	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
>> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> -	struct vgic_redist_region *rdreg = vgic_cpu->rdreg;
>>  	int target_vcpu_id = vcpu->vcpu_id;
>> -	gpa_t last_rdist_typer = rdreg->base + GICR_TYPER +
>> -			(rdreg->free_index - 1) * KVM_VGIC_V3_REDIST_SIZE;
>>  	u64 value;
>>  
>>  	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
>>  	value |= ((target_vcpu_id & 0xffff) << 8);
>>  
>> -	if (addr == last_rdist_typer)
>> +	if (vgic_has_its(vcpu->kvm))
>> +		value |= GICR_TYPER_PLPIS;
>> +
>> +	if (vgic_mmio_vcpu_rdist_is_last(vcpu))
>>  		value |= GICR_TYPER_LAST;
>> -	if (vgic_has_its(vcpu->kvm))
>> -		value |= GICR_TYPER_PLPIS;
>>  
>>  	return extract_bytes(value, addr & 7, len);
>>  }
>>  
>> -static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
>> -						 gpa_t addr, unsigned int len)
>> -{
>> -	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
>> -	int target_vcpu_id = vcpu->vcpu_id;
>> -	u64 value;
>> -
>> -	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
>> -	value |= ((target_vcpu_id & 0xffff) << 8);
>> -
>> -	if (vgic_has_its(vcpu->kvm))
>> -		value |= GICR_TYPER_PLPIS;
>> -
>> -	/* reporting of the Last bit is not supported for userspace */
>> -	return extract_bytes(value, addr & 7, len);
>> -}
>> -
>>  static unsigned long vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
>>  					     gpa_t addr, unsigned int len)
>>  {
>> @@ -612,7 +624,7 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
>>  		VGIC_ACCESS_32bit),
>>  	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_TYPER,
>>  		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi,
>> -		vgic_uaccess_read_v3r_typer, vgic_mmio_uaccess_write_wi, 8,
>> +		NULL, vgic_mmio_uaccess_write_wi, 8,
>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>  	REGISTER_DESC_WITH_LENGTH(GICR_WAKER,
>>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
>> @@ -714,6 +726,16 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>>  		return -EINVAL;
>>  
>>  	vgic_cpu->rdreg = rdreg;
>> +	vgic_cpu->rdreg_index = rdreg->free_index;
>> +	if (!rdreg->count) {
>> +		void *p = krealloc(rdreg->rdist_indices,
>> +				   (vgic_cpu->rdreg_index + 1) * sizeof(u32),
>> +				   GFP_KERNEL);
>> +		if (!p)
>> +			return -ENOMEM;
>> +		rdreg->rdist_indices = p;
>> +	}
>> +	rdreg->rdist_indices[vgic_cpu->rdreg_index] = vgic_cpu->index;
> 
> I think I really have a problem with this array, which comes from me
> not understanding the two checks I previously commented on.

I hope the above clarified the array need.
> 
> If we stick to the definition of 'Last', all that matters is the
> position of the RD in a region (rdreg_index) and potentially the
> presence of another contiguous region with allocated RDs in it.

> 
> IIUC, the checks should read like this:
> 
> if (vcpu->rdreg_index < (vcpu->rdreg->free_index - 1))
> 	last = false;
> else if (vcpu->rdreg_index == (vcpu->rdreg->free_index - 1) &&
> 	 adjacent_region(vcpu->rdreg)->free_index > 0)
> 	last = false;
> else
> 	last = true;
> 
> So why do we need to track the vcpu_id associated to a region?
because the redistributors within a region can be in random order.
That's why I need to store their number.

Does that make more sense?

Thanks

Eric
> 
>>
>>  	rd_base = rdreg->base + rdreg->free_index * KVM_VGIC_V3_REDIST_SIZE;
>>  
>> @@ -768,7 +790,7 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
>>  }
>>  
>>  /**
>> - * vgic_v3_insert_redist_region - Insert a new redistributor region
>> + * vgic_v3_alloc_redist_region - Allocate a new redistributor region
>>   *
>>   * Performs various checks before inserting the rdist region in the list.
>>   * Those tests depend on whether the size of the rdist region is known
>> @@ -782,8 +804,8 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
>>   *
>>   * Return 0 on success, < 0 otherwise
>>   */
>> -static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>> -					gpa_t base, uint32_t count)
>> +static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
>> +				       gpa_t base, uint32_t count)
>>  {
>>  	struct vgic_dist *d = &kvm->arch.vgic;
>>  	struct vgic_redist_region *rdreg;
>> @@ -839,6 +861,13 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>>  	rdreg->count = count;
>>  	rdreg->free_index = 0;
>>  	rdreg->index = index;
>> +	if (count) {
>> +		rdreg->rdist_indices = kcalloc(count, sizeof(u32), GFP_KERNEL);
>> +		if (!rdreg->rdist_indices) {
>> +			ret = -ENOMEM;
>> +			goto free;
>> +		}
>> +	}
>>  
>>  	list_add_tail(&rdreg->list, rd_regions);
>>  	return 0;
>> @@ -847,11 +876,18 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>>  	return ret;
>>  }
>>  
>> +void vgic_v3_free_redist_region(struct vgic_redist_region *rdreg)
>> +{
>> +	list_del(&rdreg->list);
>> +	kfree(rdreg->rdist_indices);
>> +	kfree(rdreg);
>> +}
>> +
>>  int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
>>  {
>>  	int ret;
>>  
>> -	ret = vgic_v3_insert_redist_region(kvm, index, addr, count);
>> +	ret = vgic_v3_alloc_redist_region(kvm, index, addr, count);
>>  	if (ret)
>>  		return ret;
>>  
>> @@ -864,8 +900,7 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
>>  		struct vgic_redist_region *rdreg;
>>  
>>  		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
>> -		list_del(&rdreg->list);
>> -		kfree(rdreg);
>> +		vgic_v3_free_redist_region(rdreg);
>>  		return ret;
>>  	}
>>  
>> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
>> index 64fcd75111108..bc418c2c12141 100644
>> --- a/arch/arm64/kvm/vgic/vgic.h
>> +++ b/arch/arm64/kvm/vgic/vgic.h
>> @@ -293,6 +293,7 @@ vgic_v3_rd_region_size(struct kvm *kvm, struct vgic_redist_region *rdreg)
>>  
>>  struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
>>  							   u32 index);
>> +void vgic_v3_free_redist_region(struct vgic_redist_region *rdreg);
>>  
>>  bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
>>  
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 3d74f1060bd18..9a3f060ac3547 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -197,6 +197,7 @@ struct vgic_redist_region {
>>  	gpa_t base;
>>  	u32 count; /* number of redistributors or 0 if single region */
>>  	u32 free_index; /* index of the next free redistributor */
>> +	int *rdist_indices; /* indices of the redistributors */
> 
> You are treating it as an array of u32 when allocating it. Please
> choose one type or the other.
> 
>>  	struct list_head list;
>>  };
>>  
>> @@ -322,6 +323,8 @@ struct vgic_cpu {
>>  	 */
>>  	struct vgic_io_device	rd_iodev;
>>  	struct vgic_redist_region *rdreg;
>> +	u32 rdreg_index;
>> +	int index; /* vcpu index */
>>  
>>  	/* Contains the attributes and gpa of the LPI pending tables. */
>>  	u64 pendbaser;
> 
> Thanks,
> 
> 	M.
> 


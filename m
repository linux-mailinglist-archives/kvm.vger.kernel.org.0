Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FA63394AB
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 18:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbhCLR1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 12:27:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231557AbhCLR0t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 12:26:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615570009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OR0/k51F6TxYKU1HnP/mRxmRVbTi3FJJ5nch1XmI+Mk=;
        b=CWvjCkytYrURshM3BD7I6w1M4p5OVCZMVSoXETCO6rRam5lst++B4uByOaENOIfWVnG6QN
        aewRcs1NgBR5Y6HjYyUh5S2s2e13SsbGEIR/Q+One4m6C0+CnLC2lx45YMA+sRT+9Ivzgp
        cHvoOt5GSiwUM33l4eShrG6pNIJ1+RY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-CO1vD8xUOMO4Bfm7K6NtFg-1; Fri, 12 Mar 2021 12:26:46 -0500
X-MC-Unique: CO1vD8xUOMO4Bfm7K6NtFg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 260C2C290;
        Fri, 12 Mar 2021 17:26:45 +0000 (UTC)
Received: from [10.36.112.254] (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E44E60D06;
        Fri, 12 Mar 2021 17:26:41 +0000 (UTC)
Subject: Re: [PATCH 8/9] KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for
 userspace
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        drjones@redhat.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-9-eric.auger@redhat.com>
 <45a364ec-eac6-a04b-9654-e97970186839@arm.com>
 <7078b0a5-fb18-5e65-953a-8a55009aa2be@redhat.com>
 <a4ab6472-41d9-1259-9416-54b06eb11626@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <2cb0ca56-26ac-37ae-ba6a-920fd9ac1f36@redhat.com>
Date:   Fri, 12 Mar 2021 18:26:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <a4ab6472-41d9-1259-9416-54b06eb11626@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 1/20/21 5:13 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 1/14/21 10:16 AM, Auger Eric wrote:
>> Hi Alexandru,
>>
>> On 1/12/21 6:02 PM, Alexandru Elisei wrote:
>>> Hi Eric,
>>>
>>> On 12/12/20 6:50 PM, Eric Auger wrote:
>>>> Commit 23bde34771f1 ("KVM: arm64: vgic-v3: Drop the
>>>> reporting of GICR_TYPER.Last for userspace") temporarily fixed
>>>> a bug identified when attempting to access the GICR_TYPER
>>>> register before the redistributor region setting but dropped
>>>> the support of the LAST bit. This patch restores its
>>>> support (if the redistributor region was set) while keeping the
>>>> code safe.
>>> I suppose the reason for emulating GICR_TYPER.Last is for architecture compliance,
>>> right? I think that should be in the commit message.
>> OK added this in the commit msg.
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>> ---
>>>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 7 ++++++-
>>>>  include/kvm/arm_vgic.h             | 1 +
>>>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>>> index 581f0f490000..2f9ef6058f6e 100644
>>>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>>> @@ -277,6 +277,8 @@ static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
>>>>  						 gpa_t addr, unsigned int len)
>>>>  {
>>>>  	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
>>>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>>> +	struct vgic_redist_region *rdreg = vgic_cpu->rdreg;
>>>>  	int target_vcpu_id = vcpu->vcpu_id;
>>>>  	u64 value;
>>>>  
>>>> @@ -286,7 +288,9 @@ static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
>>>>  	if (vgic_has_its(vcpu->kvm))
>>>>  		value |= GICR_TYPER_PLPIS;
>>>>  
>>>> -	/* reporting of the Last bit is not supported for userspace */
>>>> +	if (rdreg && (vgic_cpu->rdreg_index == (rdreg->free_index - 1)))
>>>> +		value |= GICR_TYPER_LAST;
>>>> +
>>>>  	return extract_bytes(value, addr & 7, len);
>>>>  }
>>>>  
>>>> @@ -714,6 +718,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>>>>  		return -EINVAL;
>>>>  
>>>>  	vgic_cpu->rdreg = rdreg;
>>>> +	vgic_cpu->rdreg_index = rdreg->free_index;
>>> What happens if the next redistributor region we register has the base address
>>> adjacent to this one?
>>>
>>> I'm really not familiar with the code, but is it not possible to create two
>>> Redistributor regions (via
>>> KVM_DEV_ARM_VGIC_GRP_ADDR(KVM_VGIC_V3_ADDR_TYPE_REDIST)) where the second
>>> Redistributor region start address is immediately after the last Redistributor in
>>> the preceding region?
>> KVM_VGIC_V3_ADDR_TYPE_REDIST only allows to create a single rdist
>> region. Only KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION allows to register
>> several of them.
>>
>> with KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, it is possible to register
>> adjacent rdist regions. vgic_v3_rdist_free_slot() previously returned
>> the 1st rdist region where enough space remains for inserting the new
>> reg. We put the rdist at the free index there.
>>
>> But maybe I misunderstood your question?
> 
> Yes, I think you did a good job at answering my poorly worded question.
> 
> This is the case I am concerned about:
> 
> 1. Userspace sets first redistributor base address to 0x0 via
> KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION(count = 1, base = 0x0, flags = 0, index = 0).
> 
> 2. Userspace sets first redistributor base address to 0x0 + 128K, immediately
> following the previous Redistributor.
> 
> In that case the two Redistributors will be represented by two separate struct
> vgic_redist_region, but they are adjacent to one another and represent one
> contiguous memory region.
> 
> From what I understand from your patch, GICR_TYPER.Last will be set for both
> Redistributors, when it should be set only for the second Redistributor. Does any
> of that make sense?

Please forgive me for not having replied before on this thread.

This is a valid concern. Nothing prevents the redistributor regions from
being contiguous although this is not the goal. Also nothing prevents
vcpu rdists to be laid out within a redist region in non ascending
order. Also redist regions with ascending indices may not have
increasing base addresses.

So this becomes a gas factory for emulating a single bit but I have
reworked this in v3 ;-)

Thanks

Eric





> 
> Thanks,
> Alex
>>
>> Thanks
>>
>> Eric
>>> Thanks,
>>> Alex
>>>>  
>>>>  	rd_base = rdreg->base + rdreg->free_index * KVM_VGIC_V3_REDIST_SIZE;
>>>>  
>>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>>> index a8d8fdcd3723..596c069263a7 100644
>>>> --- a/include/kvm/arm_vgic.h
>>>> +++ b/include/kvm/arm_vgic.h
>>>> @@ -322,6 +322,7 @@ struct vgic_cpu {
>>>>  	 */
>>>>  	struct vgic_io_device	rd_iodev;
>>>>  	struct vgic_redist_region *rdreg;
>>>> +	u32 rdreg_index;
>>>>  
>>>>  	/* Contains the attributes and gpa of the LPI pending tables. */
>>>>  	u64 pendbaser;
> 


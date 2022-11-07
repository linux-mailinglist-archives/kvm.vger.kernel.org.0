Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2AD61F124
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 11:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiKGKsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 05:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiKGKsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 05:48:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E78819025
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 02:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667818068;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dHMORFRgxchzu7qGPOxw/7Z7UKa5NJNSGH76rj88AMM=;
        b=IvkAzrAFU5RUbJ52EVRGfSxx3ksuLZeaMPjm4hyo/XT2nXxwe6vVZsAteA8CQ8BgQef7Fe
        Grqsite+nFj4NmbzyHcAAS7CJy40THWoDoIFTPJv2Iz0qqjzXWtJpoAKZXEQGyvg0lv4ya
        7S/bCH0GqWTm/p6lz+a1OSyciN7aagQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-aA5YE0oSNGio5tOK5RX-Ig-1; Mon, 07 Nov 2022 05:47:47 -0500
X-MC-Unique: aA5YE0oSNGio5tOK5RX-Ig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 650A31C06ECB;
        Mon,  7 Nov 2022 10:47:46 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D2E01121314;
        Mon,  7 Nov 2022 10:47:39 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v8 4/7] KVM: arm64: Enable ring-based dirty memory
 tracking
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, dmatlack@google.com, will@kernel.org,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, peterx@redhat.com, seanjc@google.com,
        oliver.upton@linux.dev, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-5-gshan@redhat.com> <87mt94f5ev.wl-maz@kernel.org>
 <b46128d5-3a58-a33e-ad9e-7c4726c5feaa@redhat.com>
 <8635avqeop.wl-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <b1382847-f3aa-043e-6078-ce652470ec07@redhat.com>
Date:   Mon, 7 Nov 2022 18:47:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <8635avqeop.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 11/7/22 5:47 PM, Marc Zyngier wrote:
> On Sun, 06 Nov 2022 21:46:19 +0000,
> Gavin Shan <gshan@redhat.com> wrote:
>> On 11/6/22 11:50 PM, Marc Zyngier wrote:
>>> On Fri, 04 Nov 2022 23:40:46 +0000,
>>> Gavin Shan <gshan@redhat.com> wrote:
>>>>
>>>> Enable ring-based dirty memory tracking on arm64 by selecting
>>>> CONFIG_HAVE_KVM_DIRTY_{RING_ACQ_REL, RING_WITH_BITMAP} and providing
>>>> the ring buffer's physical page offset (KVM_DIRTY_LOG_PAGE_OFFSET).
>>>>
>>>> Besides, helper kvm_vgic_save_its_tables_in_progress() is added to
>>>> indicate if vgic/its tables are being saved or not. The helper is used
>>>> in ARM64's kvm_arch_allow_write_without_running_vcpu() to keep the
>>>> site of saving vgic/its tables out of no-running-vcpu radar.
>>>>
>>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>>> ---
>>>>    Documentation/virt/kvm/api.rst     |  2 +-
>>>>    arch/arm64/include/uapi/asm/kvm.h  |  1 +
>>>>    arch/arm64/kvm/Kconfig             |  2 ++
>>>>    arch/arm64/kvm/arm.c               |  3 +++
>>>>    arch/arm64/kvm/mmu.c               | 15 +++++++++++++++
>>>>    arch/arm64/kvm/vgic/vgic-its.c     |  3 +++
>>>>    arch/arm64/kvm/vgic/vgic-mmio-v3.c |  7 +++++++
>>>>    include/kvm/arm_vgic.h             |  2 ++
>>>>    8 files changed, 34 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>>> index 2ec32bd41792..2fc68f684ad8 100644
>>>> --- a/Documentation/virt/kvm/api.rst
>>>> +++ b/Documentation/virt/kvm/api.rst
>>>> @@ -7921,7 +7921,7 @@ regardless of what has actually been exposed through the CPUID leaf.
>>>>    8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
>>>>    ----------------------------------------------------------
>>>>    -:Architectures: x86
>>>> +:Architectures: x86, arm64
>>>>    :Parameters: args[0] - size of the dirty log ring
>>>>      KVM is capable of tracking dirty memory using ring buffers that
>>>> are
>>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>>>> index 316917b98707..a7a857f1784d 100644
>>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>>> @@ -43,6 +43,7 @@
>>>>    #define __KVM_HAVE_VCPU_EVENTS
>>>>      #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>>>> +#define KVM_DIRTY_LOG_PAGE_OFFSET 64
>>>>      #define KVM_REG_SIZE(id)
>>>> \
>>>>    	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
>>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>>> index 815cc118c675..066b053e9eb9 100644
>>>> --- a/arch/arm64/kvm/Kconfig
>>>> +++ b/arch/arm64/kvm/Kconfig
>>>> @@ -32,6 +32,8 @@ menuconfig KVM
>>>>    	select KVM_VFIO
>>>>    	select HAVE_KVM_EVENTFD
>>>>    	select HAVE_KVM_IRQFD
>>>> +	select HAVE_KVM_DIRTY_RING_ACQ_REL
>>>> +	select HAVE_KVM_DIRTY_RING_WITH_BITMAP
>>>>    	select HAVE_KVM_MSI
>>>>    	select HAVE_KVM_IRQCHIP
>>>>    	select HAVE_KVM_IRQ_ROUTING
>>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>>> index 94d33e296e10..6b097605e38c 100644
>>>> --- a/arch/arm64/kvm/arm.c
>>>> +++ b/arch/arm64/kvm/arm.c
>>>> @@ -746,6 +746,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>>>>      		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
>>>>    			return kvm_vcpu_suspend(vcpu);
>>>> +
>>>> +		if (kvm_dirty_ring_check_request(vcpu))
>>>> +			return 0;
>>>>    	}
>>>>      	return 1;
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index 60ee3d9f01f8..fbeb55e45f53 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -932,6 +932,21 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>>>>    	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
>>>>    }
>>>>    +/*
>>>> + * kvm_arch_allow_write_without_running_vcpu - allow writing guest memory
>>>> + * without the running VCPU when dirty ring is enabled.
>>>> + *
>>>> + * The running VCPU is required to track dirty guest pages when dirty ring
>>>> + * is enabled. Otherwise, the backup bitmap should be used to track the
>>>> + * dirty guest pages. When vgic/its tables are being saved, the backup
>>>> + * bitmap is used to track the dirty guest pages due to the missed running
>>>> + * VCPU in the period.
>>>> + */
>>>> +bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
>>>> +{
>>>> +	return kvm_vgic_save_its_tables_in_progress(kvm);
>>>
>>> I don't think we need the extra level of abstraction here. Just return
>>> kvm->arch.vgic.save_its_tables_in_progress and be done with it.
>>>
>>> You can also move the helper to the vgic-its code since they are
>>> closely related for now.
>>>
>>
>> Ok. After kvm_arch_allow_write_without_running_vcpu() is moved to vgic-its.c,
>> do we need to replace 'struct vgic_dist::save_its_tables_in_progress' with
>> a file-scoped variant ('bool vgic_its_saving_tables') ?
> 
> No, this still needs to be per-VM.
> 

Yeah, it's still per-VM state. Sorry for my dumb question :)

Thanks,
Gavin


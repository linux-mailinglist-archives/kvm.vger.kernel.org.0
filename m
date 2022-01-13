Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB5148D2BF
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 08:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiAMHVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 02:21:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229670AbiAMHVk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 02:21:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642058499;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8nRNr5aU4a8XQrLe04v5XgMtz6JohugAgXgShhheXBE=;
        b=SluXrY8rQLUuCrqmeK2oN9HJQv62ChaC7uSEZBP4/qYGDPy3wD1C/CdARHPe7o1+SQ//DJ
        DStf0F6FfN5h/HFi3/NVHzSWRG4ox3pNkvHspCZozjg9Fa2bjUPvTnuEMNqjb2T1FVZVEu
        qxf2ZBYI8ErYQ7DmoahBOXWcT2ec/B8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-fMeBDy2WOpahrl775iFFDw-1; Thu, 13 Jan 2022 02:21:36 -0500
X-MC-Unique: fMeBDy2WOpahrl775iFFDw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DFD0189DF41;
        Thu, 13 Jan 2022 07:21:35 +0000 (UTC)
Received: from [10.72.13.202] (ovpn-13-202.pek2.redhat.com [10.72.13.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 644CB1059104;
        Thu, 13 Jan 2022 07:21:28 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 01/15] KVM: async_pf: Move struct kvm_async_pf around
To:     Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
        shan.gavin@gmail.com, Jonathan.Cameron@huawei.com,
        pbonzini@redhat.com, vkuznets@redhat.com, will@kernel.org
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-2-gshan@redhat.com>
 <f05db974-1145-b83e-a8ba-e73dbf4bc880@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <b42a6ade-db3b-3d42-b385-3ad8483b1f49@redhat.com>
Date:   Thu, 13 Jan 2022 15:21:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <f05db974-1145-b83e-a8ba-e73dbf4bc880@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 11/10/21 11:37 PM, Eric Auger wrote:
> On 8/15/21 2:59 AM, Gavin Shan wrote:
>> This moves the definition of "struct kvm_async_pf" and the related
>> functions after "struct kvm_vcpu" so that newly added inline functions
>> in the subsequent patches can dereference "struct kvm_vcpu" properly.
>> Otherwise, the unexpected build error will be raised:
>>
>>     error: dereferencing pointer to incomplete type ‘struct kvm_vcpu’
>>     return !list_empty_careful(&vcpu->async_pf.done);
>>                                     ^~
>> Since we're here, the sepator between type and field in "struct kvm_vcpu"
> separator

Thanks, It will be fixed in next respin.

>> is replaced by tab. The empty stub kvm_check_async_pf_completion() is also
>> added on !CONFIG_KVM_ASYNC_PF, which is needed by subsequent patches to
>> support asynchronous page fault on ARM64.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   include/linux/kvm_host.h | 44 +++++++++++++++++++++-------------------
>>   1 file changed, 23 insertions(+), 21 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index ae7735b490b4..85b61a456f1c 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -199,27 +199,6 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>>   struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>>   					 gpa_t addr);
>>   
>> -#ifdef CONFIG_KVM_ASYNC_PF
>> -struct kvm_async_pf {
>> -	struct work_struct work;
>> -	struct list_head link;
>> -	struct list_head queue;
>> -	struct kvm_vcpu *vcpu;
>> -	struct mm_struct *mm;
>> -	gpa_t cr2_or_gpa;
>> -	unsigned long addr;
>> -	struct kvm_arch_async_pf arch;
>> -	bool   wakeup_all;
>> -	bool notpresent_injected;
>> -};
>> -
>> -void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
>> -void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
>> -bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>> -			unsigned long hva, struct kvm_arch_async_pf *arch);
>> -int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>> -#endif
>> -
>>   #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
>>   struct kvm_gfn_range {
>>   	struct kvm_memory_slot *slot;
>> @@ -346,6 +325,29 @@ struct kvm_vcpu {
>>   	struct kvm_dirty_ring dirty_ring;
>>   };
>>   
>> +#ifdef CONFIG_KVM_ASYNC_PF
>> +struct kvm_async_pf {
>> +	struct work_struct		work;
>> +	struct list_head		link;
>> +	struct list_head		queue;
>> +	struct kvm_vcpu			*vcpu;
>> +	struct mm_struct		*mm;
>> +	gpa_t				cr2_or_gpa;
>> +	unsigned long			addr;
>> +	struct kvm_arch_async_pf	arch;
>> +	bool				wakeup_all;
>> +	bool				notpresent_injected;
>> +};
>> +
>> +void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
>> +void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
>> +bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>> +			unsigned long hva, struct kvm_arch_async_pf *arch);
>> +int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>> +#else
>> +static inline void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu) { }
> why is that stub needed on ARM64 and not on the other archs?
> 

We use the following pattern, suggested by James Morse.

int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
{
         int r;
         switch (ext) {
           :
                 case KVM_CAP_ASYNC_PF:
         case KVM_CAP_ASYNC_PF_INT:
                 r = IS_ENABLED(CONFIG_KVM_ASYNC_PF) ? 1 : 0;
                 break;
         default:
                 r = 0;
         }

         return r;
}

Thanks,
Gavin

>> +#endif
>> +
>>   /* must be called with irqs disabled */
>>   static __always_inline void guest_enter_irqoff(void)
>>   {
>>
> 


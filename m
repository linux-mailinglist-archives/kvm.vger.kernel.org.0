Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8E53EEB29
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 12:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239626AbhHQKpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 06:45:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236594AbhHQKpG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 06:45:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629197073;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K9dQgKcIcb5DxDNrYk+u+HmdPC32i9z4SnfjuIY8WQo=;
        b=ZK9W+A0Zx2fwLc4cSq+/1qkuI6+EbLk1D+R8NMmWLK45HcVlazpXZ7omVRVbfpvakX1b6N
        cuQ5CLWbOW4PO1E8voW2b2iE5Lo9HM5SFz7iuDUAhQWecNHs4V8McS7/vZd1SWwuxlOxYO
        4N1PEffBBQptzF587qgulBWlch57jos=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-TQWeQCCfMaaKcTeWiUdCEA-1; Tue, 17 Aug 2021 06:44:30 -0400
X-MC-Unique: TQWeQCCfMaaKcTeWiUdCEA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95A185F9D4;
        Tue, 17 Aug 2021 10:44:28 +0000 (UTC)
Received: from [10.64.54.103] (vpn2-54-103.bne.redhat.com [10.64.54.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8495060C81;
        Tue, 17 Aug 2021 10:44:21 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 02/15] KVM: async_pf: Add helper function to check
 completion queue
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, shan.gavin@gmail.com,
        kvmarm@lists.cs.columbia.edu
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-3-gshan@redhat.com>
 <87bl5xmiu2.fsf@vitty.brq.redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <df8ab291-905e-2812-6e4d-fb3d209ee14d@redhat.com>
Date:   Tue, 17 Aug 2021 20:44:18 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87bl5xmiu2.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On 8/17/21 2:53 AM, Vitaly Kuznetsov wrote:
> Gavin Shan <gshan@redhat.com> writes:
> 
>> This adds inline helper kvm_check_async_pf_completion_queue() to
>> check if there are pending completion in the queue. The empty stub
>> is also added on !CONFIG_KVM_ASYNC_PF so that the caller needn't
>> consider if CONFIG_KVM_ASYNC_PF is enabled.
>>
>> All checks on the completion queue is done by the newly added inline
>> function since list_empty() and list_empty_careful() are interchangeable.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c       |  2 +-
>>   include/linux/kvm_host.h | 10 ++++++++++
>>   virt/kvm/async_pf.c      | 10 +++++-----
>>   virt/kvm/kvm_main.c      |  4 +---
>>   4 files changed, 17 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index e5d5c5ed7dd4..7f35d9324b99 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11591,7 +11591,7 @@ static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
>>   
>>   static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>>   {
>> -	if (!list_empty_careful(&vcpu->async_pf.done))
>> +	if (kvm_check_async_pf_completion_queue(vcpu))
>>   		return true;
>>   
>>   	if (kvm_apic_has_events(vcpu))
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 85b61a456f1c..a5f990f6dc35 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -339,12 +339,22 @@ struct kvm_async_pf {
>>   	bool				notpresent_injected;
>>   };
>>   
>> +static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> 
> Nitpicking: When not reading the implementation, I'm not exactly sure
> what this function returns as 'check' is too ambiguous ('true' when the
> queue is full? when it's empty? when it's not empty? when it was
> properly set up?). I'd suggest we go with a more specific:
> 
> kvm_async_pf_completion_queue_empty() or something like that instead
> (we'll have to invert the logic everywhere then).
> 
> Side note: x86 seems to already use a shortened 'apf' instead of
> 'async_pf' in a number of places (e.g. 'apf_put_user_ready()'), we may
> want to either fight this practice or support the rebelion by renaming
> all functions from below instead :-)
> 

Yeah, I was wandering if the name is ambiguous when I had it. The
reason why I had the name is to be consistent with the existing
one, which is kvm_check_async_pf_completion().

Yes, kvm_async_pf_completion_queue_empty() is much better and I
will include this in next revision.

It's correct that x86 functions include 'apf', but the generic
functions, shared by multiple architectures, use 'async_pf' if
my understanding is correct. So I wouldn't bother to change
the generic function names in this series :)

>> +{
>> +	return !list_empty_careful(&vcpu->async_pf.done);
>> +}
>> +
>>   void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
>>   void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
>>   bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>   			unsigned long hva, struct kvm_arch_async_pf *arch);
>>   int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>>   #else
>> +static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>> +{
>> +	return false;
>> +}
>> +
>>   static inline void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu) { }
>>   #endif
>>   
>> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
>> index dd777688d14a..d145a61a046a 100644
>> --- a/virt/kvm/async_pf.c
>> +++ b/virt/kvm/async_pf.c
>> @@ -70,7 +70,7 @@ static void async_pf_execute(struct work_struct *work)
>>   		kvm_arch_async_page_present(vcpu, apf);
>>   
>>   	spin_lock(&vcpu->async_pf.lock);
>> -	first = list_empty(&vcpu->async_pf.done);
>> +	first = !kvm_check_async_pf_completion_queue(vcpu);
>>   	list_add_tail(&apf->link, &vcpu->async_pf.done);
>>   	apf->vcpu = NULL;
>>   	spin_unlock(&vcpu->async_pf.lock);
>> @@ -122,7 +122,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>>   		spin_lock(&vcpu->async_pf.lock);
>>   	}
>>   
>> -	while (!list_empty(&vcpu->async_pf.done)) {
>> +	while (kvm_check_async_pf_completion_queue(vcpu)) {
>>   		struct kvm_async_pf *work =
>>   			list_first_entry(&vcpu->async_pf.done,
>>   					 typeof(*work), link);
>> @@ -138,7 +138,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>>   {
>>   	struct kvm_async_pf *work;
>>   
>> -	while (!list_empty_careful(&vcpu->async_pf.done) &&
>> +	while (kvm_check_async_pf_completion_queue(vcpu) &&
>>   	      kvm_arch_can_dequeue_async_page_present(vcpu)) {
>>   		spin_lock(&vcpu->async_pf.lock);
>>   		work = list_first_entry(&vcpu->async_pf.done, typeof(*work),
>> @@ -205,7 +205,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>>   	struct kvm_async_pf *work;
>>   	bool first;
>>   
>> -	if (!list_empty_careful(&vcpu->async_pf.done))
>> +	if (kvm_check_async_pf_completion_queue(vcpu))
>>   		return 0;
>>   
>>   	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
>> @@ -216,7 +216,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>>   	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
>>   
>>   	spin_lock(&vcpu->async_pf.lock);
>> -	first = list_empty(&vcpu->async_pf.done);
>> +	first = !kvm_check_async_pf_completion_queue(vcpu);
>>   	list_add_tail(&work->link, &vcpu->async_pf.done);
>>   	spin_unlock(&vcpu->async_pf.lock);
>>   
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index b50dbe269f4b..8795503651b1 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -3282,10 +3282,8 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
>>   	if (kvm_arch_dy_runnable(vcpu))
>>   		return true;
>>   
>> -#ifdef CONFIG_KVM_ASYNC_PF
>> -	if (!list_empty_careful(&vcpu->async_pf.done))
>> +	if (kvm_check_async_pf_completion_queue(vcpu))
>>   		return true;
>> -#endif
>>   
>>   	return false;
>>   }
> 

Thanks,
Gavin


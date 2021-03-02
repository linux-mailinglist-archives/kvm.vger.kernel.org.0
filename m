Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F04932A75A
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384785AbhCBQMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:12:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350912AbhCBM7E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 07:59:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614689795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M9fL7n3Tv5twMpsBGgac3V/MmjGJOrbN2fKp4Wp/lhk=;
        b=R5gAe6uues6+PEcUr3UwZPxiyBWtbbTyHbwIQVhrIejSLcFpnA/YKwvKXV01/7VdVfSz9u
        +5400peLiY+Pje+RdA4qkO5mkjelEsPlxsTyPX9Q9RllTnoP5FAbA3JfVAl2mwBcpcjVZX
        i3m4NGWd+6PaRkHHo3rHpu9a20R+dbk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-oaeMdRUFPTC5FrLTLYTNBQ-1; Tue, 02 Mar 2021 07:56:33 -0500
X-MC-Unique: oaeMdRUFPTC5FrLTLYTNBQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DD501E570;
        Tue,  2 Mar 2021 12:56:32 +0000 (UTC)
Received: from localhost.localdomain (ovpn-114-4.rdu2.redhat.com [10.10.114.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3EC060BFA;
        Tue,  2 Mar 2021 12:56:31 +0000 (UTC)
Subject: Re: [PATCH] KVM: nSVM: Optimize L12 to L2 vmcb.save copies
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wei.huang2@amd.com
References: <20210301200844.2000-1-cavery@redhat.com>
 <YD2N/4sDKS4RJdlR@google.com>
From:   Cathy Avery <cavery@redhat.com>
Message-ID: <9c7e4dec-2181-1720-5981-3ae25c5bb0d9@redhat.com>
Date:   Tue, 2 Mar 2021 07:56:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <YD2N/4sDKS4RJdlR@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/21 7:59 PM, Sean Christopherson wrote:
> On Mon, Mar 01, 2021, Cathy Avery wrote:
>>   	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
>>   	svm_set_efer(&svm->vcpu, vmcb12->save.efer);
>>   	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
>>   	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
> Why not utilize VMCB_CR?
I was going to tackle CR in a follow up patch. I should have mentioned 
that but it makes sense to go ahead and do it now.
>
>> -	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
>> +	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = vmcb12->save.cr2;
> Same question for VMCB_CR2.
>
> Also, isn't writing svm->vmcb->save.cr2 unnecessary since svm_vcpu_run()
> unconditionally writes it?
>
> Alternatively, it shouldn't be too much work to add proper dirty tracking for
> CR2.  VMX has to write the real CR2 every time because there's no VMCS field,
> but I assume can avoid the write and dirty update on the majority of VMRUNs.

I 'll take a look at CR2 as well.

Thanks for the feedback,

Cathy

>
>> +
>>   	kvm_rax_write(&svm->vcpu, vmcb12->save.rax);
>>   	kvm_rsp_write(&svm->vcpu, vmcb12->save.rsp);
>>   	kvm_rip_write(&svm->vcpu, vmcb12->save.rip);
>>   
>>   	/* In case we don't even reach vcpu_run, the fields are not updated */
>> -	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2;
>>   	svm->vmcb->save.rax = vmcb12->save.rax;
>>   	svm->vmcb->save.rsp = vmcb12->save.rsp;
>>   	svm->vmcb->save.rip = vmcb12->save.rip;
>>   
>> -	svm->vmcb->save.dr7 = vmcb12->save.dr7 | DR7_FIXED_1;
>> -	svm->vcpu.arch.dr6  = vmcb12->save.dr6 | DR6_ACTIVE_LOW;
>> -	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
>> +	/* These bits will be set properly on the first execution when new_vmc12 is true */
>> +	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
>> +		svm->vmcb->save.dr7 = vmcb12->save.dr7 | DR7_FIXED_1;
>> +		svm->vcpu.arch.dr6  = vmcb12->save.dr6 | DR6_ACTIVE_LOW;
>> +		vmcb_mark_dirty(svm->vmcb, VMCB_DR);
>> +	}
>>   }
>>   
>>   static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 54610270f66a..9761a7ca8100 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1232,6 +1232,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>>   	svm->asid = 0;
>>   
>>   	svm->nested.vmcb12_gpa = 0;
>> +	svm->nested.last_vmcb12_gpa = 0;
> We should use INVALID_PAGE, '0' is a legal physical address and could
> theoretically get a false negative on the "new_vmcb12" check.
>
>>   	vcpu->arch.hflags = 0;
>>   
>>   	if (!kvm_pause_in_guest(vcpu->kvm)) {
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index fbbb26dd0f73..911868d4584c 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -93,6 +93,7 @@ struct svm_nested_state {
>>   	u64 hsave_msr;
>>   	u64 vm_cr_msr;
>>   	u64 vmcb12_gpa;
>> +	u64 last_vmcb12_gpa;
>>   
>>   	/* These are the merged vectors */
>>   	u32 *msrpm;
>> @@ -247,6 +248,11 @@ static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
>>   	vmcb->control.clean &= ~(1 << bit);
>>   }
>>   
>> +static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
>> +{
>> +        return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
>> +}
>> +
>>   static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
>>   {
>>   	return container_of(vcpu, struct vcpu_svm, vcpu);
>> -- 
>> 2.26.2
>>


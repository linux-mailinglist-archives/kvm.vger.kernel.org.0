Return-Path: <kvm+bounces-47269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CABABF67D
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:45:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CA3A4E827A
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 13:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F7A7080C;
	Wed, 21 May 2025 13:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JMG2P2QD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B4A2AF1E
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747835111; cv=none; b=sxWbbc+nq51WS19ajYI86qt30mr1UZBjqbSDteCCIydedo7dj/e522uoaOPRFzDS6Bb/pFxXqcgeIsQ5hrs5DCqfSBpwRNlcIx2BFNlDgkwQ4FUj/65TYdCtCVC0Zij/RJPw0D0wNIhDQJw5r1TrZzdyrGI55Y+QomLeACtmlEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747835111; c=relaxed/simple;
	bh=ouZlFPguqP51BNKlZXO6i9l2Rr6iuR+ys4/uZFZZZ1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=trmVUWbdTCtstPqlMZWPcevwiQhfQN9+58ZqbKL0xSs//CQaY39g+DkNT4aVRgFXXClqr+ok7g9hnUdMg30dLjGL3rIxBI7UbICQ1EaAu1RlumFN0HdD9VR4TRPs4ZubCn1ksUHY9yWzcL6Lz5akHWPsOy+eGbIbPEmSBr1dXgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JMG2P2QD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747835108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MPM6XK2YeMamf++4sbak5ZKKQeQ657KFUF1TuEfC9JU=;
	b=JMG2P2QD8yH5PyTvvytf4ZaDLCuyWjVmDcccWIBmmcqNRTHQ486MQrcJWwI3IU8plN9lLi
	H3gvIfvvfZ/q7qbQt2uIhHEqvb8QbYNsWcFMRPVRNBuU6XLdAf0NSGljrfPXpCHlTezbBs
	DnJ8E8HXdfvEcTK5SZW+3JGS25DF7tE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-7m3MgoX3NtOASx-1eq975w-1; Wed, 21 May 2025 09:45:06 -0400
X-MC-Unique: 7m3MgoX3NtOASx-1eq975w-1
X-Mimecast-MFC-AGG-ID: 7m3MgoX3NtOASx-1eq975w_1747835105
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43cec217977so36198195e9.0
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 06:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747835105; x=1748439905;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MPM6XK2YeMamf++4sbak5ZKKQeQ657KFUF1TuEfC9JU=;
        b=FQkaQ9XhWebtG+/T9Ypx9wxNpRL49SRKxMXfs4uq5iPBYtyzMAVgc/c4xMcH+ydkEm
         Z5N8IAeBqNMn8h3EDuQ7rHU0k4J2l9sRnE04oVyDhqIPWtoytFzXNHsyX+1ywiU3OZ4e
         yrmUWlGiqh4ub+rK6MKO9SgVJ4SOxDYdV5PrbsUavUMZXbPNfbIw9YiiTu9KMKQPNBxP
         QXTdn5GwNqBTS6OdNSwHdQtASoiG1geeUC3aRK4RKW4Cr7hjfmt5bWrEoJdmjpp1WIM+
         hfNKNiZ/IjPfkEEoW6MW4MJQh0mawo8CfNUOPzrC93GmRtj5bbdflxyffVVMNTEwS/9v
         q+Sg==
X-Gm-Message-State: AOJu0YzdT9jSkw2VZbcy589TZ+P6s1w7FBD2PtAXUs/YoCQSlA/8NifM
	IfYIXnf7crUboOHv546DYANfoGggY79CIoX3GWFavEQTvI/lkYAmhkD/IgkeLSdXbYnytcdB3iA
	e6B66Lh4fnL36ZGl33ZnZpTUwUYX8wS+MhgvGpXNzSkzUplwrhgVGJj465JpbIhZ/
X-Gm-Gg: ASbGnctAQZeyWqPx2MPjo+tE+SqsFFcQr5eHJm7v/J5GtagLIj6R5gBtu8XSH0WFHow
	xu9ycC51m6hPsraG5n05Q642igcXrDVy4Scsx2DDuBrR+xtkxb2FuL7lTyGsW1eR9ChxdJo8MoR
	SvEfxBexd5iyTvtvHyt6sm2mWzKTvirBLa/kJUzn81T75Vcp3ON70vlf/7DarjkIQ9TvknTi6ry
	eT4TAZ7Rt9xznfxCvx2+jorTNvKSNBDP3k8d4fTakbid1oAXvUyrMjiDeQkGZVMjl4lqqKufQb3
	U7DmjwOLkci7GpYPKJh/sV7EOE0SgyyzEb5Pwkl5/npcaXqRNcFfa+zT19rBbWoUJXTMFMKDL9p
	lhpIqcfSGiCLy2A50jpG8MkT8LxO8hRIWgbnaXPs=
X-Received: by 2002:a05:600c:3b86:b0:43c:f513:958a with SMTP id 5b1f17b1804b1-442fefee241mr155476555e9.13.1747835105108;
        Wed, 21 May 2025 06:45:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8anogXTAjp5MGqQQXYpA1FZ6iLZ/X5/Y5AafpwUOQm8ZJdIRODIGN9PrpOlokrYqF3H9MzQ==
X-Received: by 2002:a05:600c:3b86:b0:43c:f513:958a with SMTP id 5b1f17b1804b1-442fefee241mr155475985e9.13.1747835104554;
        Wed, 21 May 2025 06:45:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60? (p200300d82f259c00e2c76eb58a511c60.dip0.t-ipconnect.de. [2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f6ffaa6esm71798335e9.16.2025.05.21.06.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 06:45:04 -0700 (PDT)
Message-ID: <dd15ec6c-264a-4b2a-baaf-7945be09475a@redhat.com>
Date: Wed, 21 May 2025 15:45:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/17] KVM: arm64: Enable mapping guest_memfd in arm64
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-15-tabba@google.com>
 <2084504e-2a11-404a-bbe8-930384106f53@redhat.com>
 <CA+EHjTyz4M4wGCTBzFwHLB_0LUJHq6J135f=DVOhGKQE4thrtQ@mail.gmail.com>
 <d5983511-6de3-42cb-9c2f-4a0377ea5e2d@redhat.com>
 <CA+EHjTxhirJDCR4hdTt4-FJ+vo9986PE-CGwikN8zN_1H1q5jQ@mail.gmail.com>
 <f6005b96-d408-450c-ad80-6241e35c6d26@redhat.com>
 <CA+EHjTzaE_vGPsB20eJ99fG4_gck9Gb7iaVQ3ie5YUnNe5wHgw@mail.gmail.com>
 <5da72da7-b82c-4d70-ac86-3710a046b836@redhat.com>
 <CA+EHjTwmgZ3i2oaBcnhr1HjLtFeycJM49utO5VhtsOH6E9WcXQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTwmgZ3i2oaBcnhr1HjLtFeycJM49utO5VhtsOH6E9WcXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.05.25 15:32, Fuad Tabba wrote:
> Hi David,
> 
> On Wed, 21 May 2025 at 14:22, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 21.05.25 15:15, Fuad Tabba wrote:
>>> Hi David,
>>>
>>> On Wed, 21 May 2025 at 13:44, David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 21.05.25 12:29, Fuad Tabba wrote:
>>>>> On Wed, 21 May 2025 at 11:26, David Hildenbrand <david@redhat.com> wrote:
>>>>>>
>>>>>> On 21.05.25 12:12, Fuad Tabba wrote:
>>>>>>> Hi David,
>>>>>>>
>>>>>>> On Wed, 21 May 2025 at 09:05, David Hildenbrand <david@redhat.com> wrote:
>>>>>>>>
>>>>>>>> On 13.05.25 18:34, Fuad Tabba wrote:
>>>>>>>>> Enable mapping guest_memfd in arm64. For now, it applies to all
>>>>>>>>> VMs in arm64 that use guest_memfd. In the future, new VM types
>>>>>>>>> can restrict this via kvm_arch_gmem_supports_shared_mem().
>>>>>>>>>
>>>>>>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>>>>>>>> ---
>>>>>>>>>       arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
>>>>>>>>>       arch/arm64/kvm/Kconfig            |  1 +
>>>>>>>>>       2 files changed, 11 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>>>>>>> index 08ba91e6fb03..2514779f5131 100644
>>>>>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>>>>>> @@ -1593,4 +1593,14 @@ static inline bool kvm_arch_has_irq_bypass(void)
>>>>>>>>>           return true;
>>>>>>>>>       }
>>>>>>>>>
>>>>>>>>> +static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>>>>>>>>> +{
>>>>>>>>> +     return IS_ENABLED(CONFIG_KVM_GMEM);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
>>>>>>>>> +{
>>>>>>>>> +     return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>>       #endif /* __ARM64_KVM_HOST_H__ */
>>>>>>>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>>>>>>>> index 096e45acadb2..8c1e1964b46a 100644
>>>>>>>>> --- a/arch/arm64/kvm/Kconfig
>>>>>>>>> +++ b/arch/arm64/kvm/Kconfig
>>>>>>>>> @@ -38,6 +38,7 @@ menuconfig KVM
>>>>>>>>>           select HAVE_KVM_VCPU_RUN_PID_CHANGE
>>>>>>>>>           select SCHED_INFO
>>>>>>>>>           select GUEST_PERF_EVENTS if PERF_EVENTS
>>>>>>>>> +     select KVM_GMEM_SHARED_MEM
>>>>>>>>>           help
>>>>>>>>>             Support hosting virtualized guest machines.
>>>>>>>>>
>>>>>>>>
>>>>>>>> Do we have to reject somewhere if we are given a guest_memfd that was
>>>>>>>> *not* created using the SHARED flag? Or will existing checks already
>>>>>>>> reject that?
>>>>>>>
>>>>>>> We don't reject, but I don't think we need to. A user can create a
>>>>>>> guest_memfd that's private in arm64, it would just be useless.
>>>>>>
>>>>>> But the arm64 fault routine would not be able to handle that properly, no?
>>>>>
>>>>> Actually it would. The function user_mem_abort() doesn't care whether
>>>>> it's private or shared. It would fault it into the guest correctly
>>>>> regardless.
>>>>
>>>>
>>>> I think what I meant is that: if it's !shared (private only), shared
>>>> accesses (IOW all access without CoCo) should be taken from the user
>>>> space mapping.
>>>>
>>>> But user_mem_abort() would blindly go to kvm_gmem_get_pfn() because
>>>> "is_gmem = kvm_slot_has_gmem(memslot) = true".
>>>
>>> Yes, since it is a gmem-backed slot.
>>>
>>>> In other words, arm64 would have to *ignore* guest_memfd that does not
>>>> support shared?
>>>>
>>>> That's why I was wondering whether we should just immediately refuse
>>>> such guest_memfds.
>>>
>>> My thinking is that if a user deliberately creates a
>>> guest_memfd-backed slot without designating it as being sharable, then
>>> either they would find out when they try to map that memory to the
>>> host userspace (mapping it would fail), or it could be that they
>>> deliberately want to set up a VM with memslots that not mappable at
>>> all by the host.
>>
>> Hm. But that would meant that we interpret "private" memory as a concept
>> that is not understood by the VM. Because the VM does not know what
>> "private" memory is ...
>>
>>> Perhaps to add some layer of security (although a
>>> very flimsy one, since it's not a confidential guest).
>>
>> Exactly my point. If you don't want to mmap it then ... don't mmap it :)
>>
>>>
>>> I'm happy to a check to prevent this. The question is, how to do it
>>> exactly (I assume it would be in kvm_gmem_create())? Would it be
>>> arch-specific, i.e., prevent arm64 from creating non-shared
>>> guest_memfd backed memslots? Or do it by VM type? Even if we do it by
>>> VM-type it would need to be arch-specific, since we allow private
>>> guest_memfd slots for the default VM in x86, but we wouldn't for
>>> arm64.
>>>
>>> We could add another function, along the lines of
>>> kvm_arch_supports_gmem_only_shared_mem(), but considering that it
>>> actually works, and (arguably) would behave as intended, I'm not sure
>>> if it's worth the complexity.
>>>
>>> What do you think?
>>
>> My thinking was to either block this at slot creation time or at
>> guest_memfd creation time. And we should probably block that for other
>> VM types as well that do not support private memory?
>>
>> I mean, creating guest_memfd for private memory when there is no concept
>> of private memory for the VM is ... weird, no? :)
> 
> Actually, I could add this as an arch-specific check in
> arch/arm64/kvm/mmu.c:kvm_arch_prepare_memory_region(). That way, core
> KVM/guest_memfd code doesn't need to handle this arm64-specific behavior.
> 
> Does that sound good?

Yes, but only do so if you agree.

-- 
Cheers,

David / dhildenb



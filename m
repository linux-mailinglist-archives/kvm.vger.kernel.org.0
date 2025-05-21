Return-Path: <kvm+bounces-47266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07715ABF5F5
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5F753A7905
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 13:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1745C274FFB;
	Wed, 21 May 2025 13:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EKRrQCZk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B46267B1F
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 13:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747833724; cv=none; b=eaBbR76Zjco0gRWD9JSEAcKcGWWauhZNf5xu/RPb8YDjHE3BhGbqG3y1Q66QYhSJdp2Gn91RZt/X52Q2Sw8kmCqfXR9wPZXmi7VMioQhheX3nLKOIn61JFZm9aFkydS99BR7sSXkGEIMt/R8M+foiGQqcMXeDB2P2Gi17xMXTjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747833724; c=relaxed/simple;
	bh=8olCS0Sx5CCX39e/3WtzMNixo5eA7VNxrCy9qYVLBEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JamJvNTapcaX+s5W07c5y5F65b1dYfBtwNJhtR/ELn8nHH/xJ8aVGl0hXiwp4AwFd6F8ZKtkBAEVT12QiAePtJJFmT7Y2Y1bhdgQoTxy9Lx6q8IXo4drl/nQeoWCH6byQfazCkoTTVMeJBXceYW/mNwpfam+a9xXlpsDzffGkmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EKRrQCZk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747833721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KsQJYx6nDK1tZ3e3TU1wDHuVWQTDFeAg/MT5bwAV0Pg=;
	b=EKRrQCZk4sjhpHu+EcHmk1Bp3CoLMYIuEDfTdRTTeMKFln6hhgrAjtnrGnAHfyGTWytZFZ
	BXr1TEtoKyJmkB9XRVYk3KBI1bH/h+7quQjDINOeelhleUjFMrzEzWg60LcBV2MuMGrIQy
	rPiyVB8sj9emp0LIa9Mx+nZjn/Baja0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-a5uKnWwHOsuUMNGPPCWIfQ-1; Wed, 21 May 2025 09:22:00 -0400
X-MC-Unique: a5uKnWwHOsuUMNGPPCWIfQ-1
X-Mimecast-MFC-AGG-ID: a5uKnWwHOsuUMNGPPCWIfQ_1747833719
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-442cd12d151so47961815e9.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 06:21:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747833719; x=1748438519;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KsQJYx6nDK1tZ3e3TU1wDHuVWQTDFeAg/MT5bwAV0Pg=;
        b=jDsEQ/sH+Rwsu3he6BTp864LMOrXFZqFWe9zJnoz9mBz4Z/jWF0Cupqs4OnHD3WkU1
         qRz/0FuQ2vg9XP2ndgwTaIw6bHExb6AvKsoomPUoCIXhf09XIruHERvBkO+SC3AI65Q/
         tjUsb55b611RbHadLrTjlvM38LOyUhhmadAfEO/KuoYutuLPk7uXoIKjWDKSco4K0D0i
         Kmx5sqIKED2OfCSrDHMPQCgf7nJZFYAJlQQxyUnmWfQk6YZjTV85SpwXin+jFjQfTkbw
         D0U5EeRLwfUJlDOzaBftLlCL2ZVYXdHpDZt3wZaxINlT1ApaCTtNhHn7HX3kTRofnT7P
         +euw==
X-Gm-Message-State: AOJu0Yxnb/ZsVV3Bd6QuLKJ4kS13SXJI9Mc1xoFIRk60S7qi3FRcjFb6
	3oBgNbGkLysWesRB21Z9dDG7XLvECXwzgD4Yv5R2quT8fuG8RuZRkH40Y68mmGFCg+T8KHSEXn7
	MIuRv4azs5oKr3cZPgefSXXE35OlFpaZb3v/B+zUDqEvv79xWR17Wug==
X-Gm-Gg: ASbGncsE1QpaGEwC4sa4bOKxjnYSlr1hX5a+xvAaNzLoOa0BtC+OWNIcCTln2jyOl4V
	HXDHKTb/3kQO/ExeA/HyfzeSZMhFscinyY/1/OStpHDCKdYJU7iusNRgyCdWOvPACSHvGMz2NDf
	B5Z+9vf5fC+dCD+7ZsjCdK5+dQj90275Up8XSAYN5ZlMpG6Mgbj7b6th4OnyyFGQ8RlqxmoLVGr
	SPxNNOQe3YUb0K/bpppZzh+T9mhRrKOI8Mj1Mpezc0V8BzP9CpXQOJNotZ4YA7ltPjROILRUUZo
	KEK/icIl98pdOuSVcb9cMW0XpMIF1mvvgG5CBzSIrrm9Zkd2xIqDU7VsmpVSv2Gr4m8J1MGYg7Y
	fJv6twsSbWKPEC2N728YbKTBomRgr7RM8ym9rJy8=
X-Received: by 2002:a05:600c:4fd4:b0:441:b00d:e9d1 with SMTP id 5b1f17b1804b1-442fd606ce9mr229517205e9.2.1747833718616;
        Wed, 21 May 2025 06:21:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFy+CftXV4gMRAM6oBQoBzBQVIMemnpDMWNi1QDQndq2cdcTHQbwX9zmyDym4oPvA+EqemP2w==
X-Received: by 2002:a05:600c:4fd4:b0:441:b00d:e9d1 with SMTP id 5b1f17b1804b1-442fd606ce9mr229516145e9.2.1747833717912;
        Wed, 21 May 2025 06:21:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60? (p200300d82f259c00e2c76eb58a511c60.dip0.t-ipconnect.de. [2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f1825193sm74096625e9.5.2025.05.21.06.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 06:21:57 -0700 (PDT)
Message-ID: <5da72da7-b82c-4d70-ac86-3710a046b836@redhat.com>
Date: Wed, 21 May 2025 15:21:54 +0200
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
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTzaE_vGPsB20eJ99fG4_gck9Gb7iaVQ3ie5YUnNe5wHgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.05.25 15:15, Fuad Tabba wrote:
> Hi David,
> 
> On Wed, 21 May 2025 at 13:44, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 21.05.25 12:29, Fuad Tabba wrote:
>>> On Wed, 21 May 2025 at 11:26, David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 21.05.25 12:12, Fuad Tabba wrote:
>>>>> Hi David,
>>>>>
>>>>> On Wed, 21 May 2025 at 09:05, David Hildenbrand <david@redhat.com> wrote:
>>>>>>
>>>>>> On 13.05.25 18:34, Fuad Tabba wrote:
>>>>>>> Enable mapping guest_memfd in arm64. For now, it applies to all
>>>>>>> VMs in arm64 that use guest_memfd. In the future, new VM types
>>>>>>> can restrict this via kvm_arch_gmem_supports_shared_mem().
>>>>>>>
>>>>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>>>>>> ---
>>>>>>>      arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
>>>>>>>      arch/arm64/kvm/Kconfig            |  1 +
>>>>>>>      2 files changed, 11 insertions(+)
>>>>>>>
>>>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>>>>> index 08ba91e6fb03..2514779f5131 100644
>>>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>>>> @@ -1593,4 +1593,14 @@ static inline bool kvm_arch_has_irq_bypass(void)
>>>>>>>          return true;
>>>>>>>      }
>>>>>>>
>>>>>>> +static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>>>>>>> +{
>>>>>>> +     return IS_ENABLED(CONFIG_KVM_GMEM);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
>>>>>>> +{
>>>>>>> +     return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
>>>>>>> +}
>>>>>>> +
>>>>>>>      #endif /* __ARM64_KVM_HOST_H__ */
>>>>>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>>>>>> index 096e45acadb2..8c1e1964b46a 100644
>>>>>>> --- a/arch/arm64/kvm/Kconfig
>>>>>>> +++ b/arch/arm64/kvm/Kconfig
>>>>>>> @@ -38,6 +38,7 @@ menuconfig KVM
>>>>>>>          select HAVE_KVM_VCPU_RUN_PID_CHANGE
>>>>>>>          select SCHED_INFO
>>>>>>>          select GUEST_PERF_EVENTS if PERF_EVENTS
>>>>>>> +     select KVM_GMEM_SHARED_MEM
>>>>>>>          help
>>>>>>>            Support hosting virtualized guest machines.
>>>>>>>
>>>>>>
>>>>>> Do we have to reject somewhere if we are given a guest_memfd that was
>>>>>> *not* created using the SHARED flag? Or will existing checks already
>>>>>> reject that?
>>>>>
>>>>> We don't reject, but I don't think we need to. A user can create a
>>>>> guest_memfd that's private in arm64, it would just be useless.
>>>>
>>>> But the arm64 fault routine would not be able to handle that properly, no?
>>>
>>> Actually it would. The function user_mem_abort() doesn't care whether
>>> it's private or shared. It would fault it into the guest correctly
>>> regardless.
>>
>>
>> I think what I meant is that: if it's !shared (private only), shared
>> accesses (IOW all access without CoCo) should be taken from the user
>> space mapping.
>>
>> But user_mem_abort() would blindly go to kvm_gmem_get_pfn() because
>> "is_gmem = kvm_slot_has_gmem(memslot) = true".
> 
> Yes, since it is a gmem-backed slot.
> 
>> In other words, arm64 would have to *ignore* guest_memfd that does not
>> support shared?
>>
>> That's why I was wondering whether we should just immediately refuse
>> such guest_memfds.
> 
> My thinking is that if a user deliberately creates a
> guest_memfd-backed slot without designating it as being sharable, then
> either they would find out when they try to map that memory to the
> host userspace (mapping it would fail), or it could be that they
> deliberately want to set up a VM with memslots that not mappable at
> all by the host. 

Hm. But that would meant that we interpret "private" memory as a concept 
that is not understood by the VM. Because the VM does not know what 
"private" memory is ...

> Perhaps to add some layer of security (although a
> very flimsy one, since it's not a confidential guest).

Exactly my point. If you don't want to mmap it then ... don't mmap it :)

> 
> I'm happy to a check to prevent this. The question is, how to do it
> exactly (I assume it would be in kvm_gmem_create())? Would it be
> arch-specific, i.e., prevent arm64 from creating non-shared
> guest_memfd backed memslots? Or do it by VM type? Even if we do it by
> VM-type it would need to be arch-specific, since we allow private
> guest_memfd slots for the default VM in x86, but we wouldn't for
> arm64.
> 
> We could add another function, along the lines of
> kvm_arch_supports_gmem_only_shared_mem(), but considering that it
> actually works, and (arguably) would behave as intended, I'm not sure
> if it's worth the complexity.
> 
> What do you think?

My thinking was to either block this at slot creation time or at 
guest_memfd creation time. And we should probably block that for other 
VM types as well that do not support private memory?

I mean, creating guest_memfd for private memory when there is no concept 
of private memory for the VM is ... weird, no? :)

-- 
Cheers,

David / dhildenb



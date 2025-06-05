Return-Path: <kvm+bounces-48574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9317ACF57D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A4373AE0E8
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FEF0275861;
	Thu,  5 Jun 2025 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WkCtoGBR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6011DC98C
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 17:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749144924; cv=none; b=UL20puz+uNrR5pph8duxn6x0TYV9/B+p5iJMRzZCgtLTjqNsj/5VULehks2tTA2u1x8187ZQSZDBnQqf5IwQObPAZS2F5uwo9r9NtKkWgihTnlrTYL8ZwkRjVEXOwntqHWqx1o7f5oHdBQT5gs0rqkZHrQI/A+nFE2zAe0gqswM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749144924; c=relaxed/simple;
	bh=ZM1/B1cU2fx73Q2nn3FIRzOp2WOBKvAOM4QEa/dcw6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=llTDPR00fC2f6OUC9i0be6ZAe6u4wwpZGSIwsMUdoztICIfyHdpZpyJ9NJt+6Jrn9o9xLpLJZZDKcLaHzOXfqspqlq64mZ5aQori0ClPLwWTcFmKd4ZQKK1tMMsdKBUyGseOcNU7UEXFGYkAu1B+JIW/ho5m8kj2FVC+lIR5dSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WkCtoGBR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749144921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YHsvHW0wJflK7mtQhXPcyJlvevlkpL1S6KNKNp+ibU8=;
	b=WkCtoGBRAcs/psY3hWR0miCstVbFovGqBxYEhaGQPnmlg9ecXgEUyhX/khbsazb7XCr/5U
	Z9rE33/YtLnp4eH6V9eTVYtNX7KWlqi6Sx63apbNuz+AmCFxi6OkVYJFgH0ZKOb4+RR0rX
	nqt4PFqRQjHHca9PQhPGvpHNn5+rnj8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-t0tDSC_fNYCgPB1Q0GumJA-1; Thu, 05 Jun 2025 13:35:19 -0400
X-MC-Unique: t0tDSC_fNYCgPB1Q0GumJA-1
X-Mimecast-MFC-AGG-ID: t0tDSC_fNYCgPB1Q0GumJA_1749144918
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-451d5600a54so9649725e9.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 10:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749144918; x=1749749718;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YHsvHW0wJflK7mtQhXPcyJlvevlkpL1S6KNKNp+ibU8=;
        b=OuoNoErJOO/9UJCGfXrcWmFe+iOPMo5l1OMcbUgKRQ8ZXPbSamN2ijSm5RkZXK8GLg
         UrPVwU/D4+hxAqS7xBO8lFO+6NqhKHmcF7Dj8ehiNMUN5hYlLqLdEBcvR3HJtlxEDjiF
         uuBXlUf7BpbYrmLlWjaxYRAZnso0goI+TYaGphVoZydaylczAg6z2cqAWqrSYrHYbr31
         sdXgztTsXlNcpvGSjBUQ8ZojVHQq0sBy9r9pUOoHum+v0pV0Xkk+oFcIKN9Jo8+SBq4p
         zKvbRiZeAtfcsWHe/nDRkjPAnaNzFDL/aQuFkWChN9rsHpRXI+r/hjgWE3PtE8mul/n9
         gjgA==
X-Gm-Message-State: AOJu0YxM6aRTQiRoRJQ23XT37e8pSeXALXGMjMxCUoasrgwV3dXBUi0l
	5the7U+FTB9KE+0ix4Y9dd09R26Ydi7l4g/RkhMbjRecv8B8sYTfmJJDpbt4MYZqxRlelFuLzKr
	rjmqr84uCUlsrhHsTB6LwNOBgY9LOsHlgegvrosipVOFZ8dKUfN3c6A==
X-Gm-Gg: ASbGncsTi29pIKi22rwa+/AXI0aN+jb+Oba4WZrNBRxZ6GVn8DhNbCXEYrd4Lhh20cJ
	p/7VgyoRtqMm41OBrSUL+GBZb1BcNWjPwI7bsaHgWixObwKQ5hT7LKWIHUXHm9+6yBMaNev9UC/
	n2yV9Ulrhhjq7QZmaLhv85GxDZ/VtUG/2xguXCthoi44DCOnwe/vVVbd7sY02kchGyz1fqDps3i
	5GOAqlPX8yfCGXnLH0TH0FraioCmqOQkx+BUaskuvb0qw+KS/XHqJ24oq5SUJsuOES62M4p1py6
	ZX7mA8RTremChA4uXdl79b86Z3bGTNL8iFvCBFvfKRCiMxUMU+8GhAqfJTZn/MSvJMmgTQ8oT27
	6e3rXyl8LZyAlKu2JOWl9lkB5wyVYzC2hfB15e/OjIfp1QPc=
X-Received: by 2002:a05:600c:1c83:b0:441:b5cb:4f94 with SMTP id 5b1f17b1804b1-4520136a9f3mr2205145e9.5.1749144917782;
        Thu, 05 Jun 2025 10:35:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeWqpmGoJTWPxqv5S09LHOZY9iDakcIuf6W1au637IKMq2wbzlBVa6p2mh1dhq0qkfePQsCg==
X-Received: by 2002:a05:600c:1c83:b0:441:b5cb:4f94 with SMTP id 5b1f17b1804b1-4520136a9f3mr2204785e9.5.1749144917304;
        Thu, 05 Jun 2025 10:35:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:ec00:4f4d:d38:ba97:9aa2? (p200300d82f27ec004f4d0d38ba979aa2.dip0.t-ipconnect.de. [2003:d8:2f27:ec00:4f4d:d38:ba97:9aa2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a5298a2c1esm2270925f8f.5.2025.06.05.10.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 10:35:16 -0700 (PDT)
Message-ID: <8782284c-0ffc-489d-adfe-b25d5ccb77b3@redhat.com>
Date: Thu, 5 Jun 2025 19:35:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 12/18] KVM: x86: Enable guest_memfd shared memory for
 SW-protected VMs
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-13-tabba@google.com>
 <4909d6dc-09f5-4960-b8be-5150b2a03e45@redhat.com>
 <CA+EHjTwnAV=tu1eUjixyKAhE4bpNc3XV7EhnMME3+WJ-cu6PNA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTwnAV=tu1eUjixyKAhE4bpNc3XV7EhnMME3+WJ-cu6PNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.06.25 18:11, Fuad Tabba wrote:
> On Thu, 5 Jun 2025 at 16:49, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 05.06.25 17:37, Fuad Tabba wrote:
>>> Define the architecture-specific macro to enable shared memory support
>>> in guest_memfd for relevant software-only VM types, specifically
>>> KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.
>>>
>>> Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
>>> enabled.
>>>
>>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    arch/x86/include/asm/kvm_host.h | 10 ++++++++++
>>>    arch/x86/kvm/Kconfig            |  1 +
>>>    arch/x86/kvm/x86.c              |  3 ++-
>>>    3 files changed, 13 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 709cc2a7ba66..ce9ad4cd93c5 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>>>
>>>    #ifdef CONFIG_KVM_GMEM
>>>    #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
>>> +
>>> +/*
>>> + * CoCo VMs with hardware support that use guest_memfd only for backing private
>>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
>>> + */
>>> +#define kvm_arch_supports_gmem_shared_mem(kvm)                       \
>>> +     (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
>>> +      ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
>>> +       (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
>>>    #else
>>>    #define kvm_arch_supports_gmem(kvm) false
>>> +#define kvm_arch_supports_gmem_shared_mem(kvm) false
>>>    #endif
>>>
>>>    #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
>>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>>> index b37258253543..fdf24b50af9d 100644
>>> --- a/arch/x86/kvm/Kconfig
>>> +++ b/arch/x86/kvm/Kconfig
>>> @@ -47,6 +47,7 @@ config KVM_X86
>>>        select KVM_GENERIC_HARDWARE_ENABLING
>>>        select KVM_GENERIC_PRE_FAULT_MEMORY
>>>        select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
>>> +     select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
>>>        select KVM_WERROR if WERROR
>>
>> Is $subject and this still true, given that it's now also supported for
>> KVM_X86_DEFAULT_VM?
> 
> True, just not the whole truth :)
> 
> I guess a better one would be, for Software VMs (remove protected)?

Now I am curious, what is a Hardware VM? :)

-- 
Cheers,

David / dhildenb



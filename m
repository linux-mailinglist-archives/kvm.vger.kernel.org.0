Return-Path: <kvm+bounces-9200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D0685BF79
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9205D1F23755
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 15:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2DD7745D0;
	Tue, 20 Feb 2024 15:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GtRuZe2y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8D171B41
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 15:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708441703; cv=none; b=e5hZezRqFKtaGFTGkv2aWlidrdZ4UipdA7UezhAzwFxs8BfmCEaaA7DCgI1LZtKDZ0rgf36zKQg1yslPcWJjWYQo4qpOv8JA9ErsIVQSKPNRz6Gci6tErusM657IOIr4tIaRZDon/JgzJGTpf9nrToGau4s7efqU3fpKoTjBsUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708441703; c=relaxed/simple;
	bh=8Z30Vc/p6L89aWbCJ1VziFZ9vHISrJrEHPKS5ftg42k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RGcWEcQijtbGUf7vR0y3/ttu74nrQbgtsINzl8nwbnwPij1nKtl9xDM2zNgDT2zki3Q10kHdNMDIX2FD+RvXpJLUNDmkXjKxR/aP6s5RvcLLQKFFVdf//ZhPrqS6HPmOibG2HpfM50QJBQnqfLUVygePX5G4DQ9B7Z/IElwI5Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GtRuZe2y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708441700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7ZlrA5IF5cJqD+Dl5ZUbAqsuZNshIgXHWFz7slzpNDg=;
	b=GtRuZe2ylil+52G+IAh8lh7tFepbGvuzQgdjqEIFys6ciA0wEbzfuG87W0qqPhZerl5Ec3
	8W6GJVXgzQdOjPl0H9/jsKFUC7M99fhULeZqbMjYQBqlZSb5RiiH7Q2VLJMPADRHlBL0J0
	+QKQVv71H8eRo5sOZ6ZROE4AL915gng=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-XIdKm5iYNmaVyhISUoXKKw-1; Tue, 20 Feb 2024 10:08:18 -0500
X-MC-Unique: XIdKm5iYNmaVyhISUoXKKw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4107469e8adso34683655e9.1
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 07:08:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708441697; x=1709046497;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ZlrA5IF5cJqD+Dl5ZUbAqsuZNshIgXHWFz7slzpNDg=;
        b=bJ2xCu9gI7kDXJNmtvWsQ+8QgWlrbzQ/heSCxiLtZV9tRvRSjhGIlt04bc6J2yzccW
         smj1gjABNFQE1jvPd11Ls607Q2Lt9FslmVbmwc2VTwTz+RZ7XTTWzhNjMJtVEjXqcywS
         sWGIo41zRknE/BkcQhLfvQyl67QKE6xYQ5Ql59Z0Mf6/08xKrrjqXColVRbNzYM60xxB
         UOMOfsMlvdy2N/M95qrWMJedN7B6qckRZcYkzWbNNuhrw06exnhOgl1vc5cdAmGlkLLi
         eTHynKp9Tlj3L0hXhZ1ZVA4XcP1gBctnUjY2vC1zny09S3SDbAHUVsUT5wqn9nH50V9J
         QB9A==
X-Forwarded-Encrypted: i=1; AJvYcCUlnirp6ie/SFg+tTYtul8xZRYuqJgfYkuITrwdz5eLyN91cAlM0q5HqKi27Xn7tSuNgbL/QSYXS1xwsZX8M6XP1Cng
X-Gm-Message-State: AOJu0YxC3LdWnuWlhNibBNh2Xr9oMYlqF9645d9fQGqy7+qNiVhdRMSt
	ADN1vZ1I5Lg3bKQXSQ1I+JxpacbLidireFkcym9Gg4rPZrXIlEhyNJDjYzubIf/IM940dF8q0Di
	36gLI+nYaQ1shhuS4jfNNJFnrFPJ1BeYHaWyVAVEkhcFSGNWO4w==
X-Received: by 2002:a05:600c:5197:b0:412:7061:d7f with SMTP id fa23-20020a05600c519700b0041270610d7fmr1082467wmb.1.1708441697363;
        Tue, 20 Feb 2024 07:08:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEBMmNPvdUNWc7NikEv0sF6oScEjQB6V9rmmAFfaI/CpEpGj8DvQdTUpM7rgmPio6bLn058iA==
X-Received: by 2002:a05:600c:5197:b0:412:7061:d7f with SMTP id fa23-20020a05600c519700b0041270610d7fmr1082448wmb.1.1708441696952;
        Tue, 20 Feb 2024 07:08:16 -0800 (PST)
Received: from ?IPV6:2003:cb:c72a:bc00:9a2d:8a48:ef51:96fb? (p200300cbc72abc009a2d8a48ef5196fb.dip0.t-ipconnect.de. [2003:cb:c72a:bc00:9a2d:8a48:ef51:96fb])
        by smtp.gmail.com with ESMTPSA id 6-20020a05600c22c600b004120537210esm14853048wmg.46.2024.02.20.07.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 07:08:16 -0800 (PST)
Message-ID: <631563e8-f063-4351-99d3-4c4a5d7c581e@redhat.com>
Date: Tue, 20 Feb 2024 16:08:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 33/66] i386/tdx: Make memory type private by default
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-34-xiaoyao.li@intel.com>
 <12d89ebd-3497-4e60-8900-7a7a1ffbd6e2@redhat.com>
 <86cda9fa-3921-458f-9930-d73d247ccaa1@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <86cda9fa-3921-458f-9930-d73d247ccaa1@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29.01.24 03:18, Xiaoyao Li wrote:
> On 1/26/2024 10:58 PM, David Hildenbrand wrote:
>> On 25.01.24 04:22, Xiaoyao Li wrote:
>>> By default (due to the recent UPM change), restricted memory attribute is
>>> shared.  Convert the memory region from shared to private at the memory
>>> slot creation time.
>>>
>>> add kvm region registering function to check the flag
>>> and convert the region, and add memory listener to TDX guest code to set
>>> the flag to the possible memory region.
>>>
>>> Without this patch
>>> - Secure-EPT violation on private area
>>> - KVM_MEMORY_FAULT EXIT (kvm -> qemu)
>>> - qemu converts the 4K page from shared to private
>>> - Resume VCPU execution
>>> - Secure-EPT violation again
>>> - KVM resolves EPT Violation
>>> This also prevents huge page because page conversion is done at 4K
>>> granularity.  Although it's possible to merge 4K private mapping into
>>> 2M large page, it slows guest boot.
>>>
>>> With this patch
>>> - After memory slot creation, convert the region from private to shared
>>> - Secure-EPT violation on private area.
>>> - KVM resolves EPT Violation
>>>
>>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> ---
>>>    include/exec/memory.h |  1 +
>>>    target/i386/kvm/tdx.c | 20 ++++++++++++++++++++
>>>    2 files changed, 21 insertions(+)
>>>
>>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>>> index 7229fcc0415f..f25959f6d30f 100644
>>> --- a/include/exec/memory.h
>>> +++ b/include/exec/memory.h
>>> @@ -850,6 +850,7 @@ struct IOMMUMemoryRegion {
>>>    #define MEMORY_LISTENER_PRIORITY_MIN            0
>>>    #define MEMORY_LISTENER_PRIORITY_ACCEL          10
>>>    #define MEMORY_LISTENER_PRIORITY_DEV_BACKEND    10
>>> +#define MEMORY_LISTENER_PRIORITY_ACCEL_HIGH     20
>>>    /**
>>>     * struct MemoryListener: callbacks structure for updates to the
>>> physical memory map
>>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>>> index 7b250d80bc1d..f892551821ce 100644
>>> --- a/target/i386/kvm/tdx.c
>>> +++ b/target/i386/kvm/tdx.c
>>> @@ -19,6 +19,7 @@
>>>    #include "standard-headers/asm-x86/kvm_para.h"
>>>    #include "sysemu/kvm.h"
>>>    #include "sysemu/sysemu.h"
>>> +#include "exec/address-spaces.h"
>>>    #include "hw/i386/x86.h"
>>>    #include "kvm_i386.h"
>>> @@ -621,6 +622,19 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>>        return 0;
>>>    }
>>> +static void tdx_guest_region_add(MemoryListener *listener,
>>> +                                 MemoryRegionSection *section)
>>> +{
>>> +    memory_region_set_default_private(section->mr);
>>> +}
>>
>> That looks fishy. Why is TDX to decide what happens to other memory
>> regions it doesn't own?
>>
>> We should define that behavior when creating these memory region, and
>> TDX could sanity check that they have been setup properly.
>>
>> Let me ask differently: For which memory region where we have
>> RAM_GUEST_MEMFD set would we *not* want to set private as default right
>> from the start?
> 
> All memory regions have RAM_GUEST_MEMFD set will benefit from being
> private as default, for TDX guest.
> 
> I will update the implementation to set RAM_DEFAULT_PRIVATE flag when
> guest_memfd is created successfully, like
> 
> diff --git a/system/physmem.c b/system/physmem.c
> index fc59470191ef..60676689c807 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -1850,6 +1850,8 @@ static void ram_block_add(RAMBlock *new_block,
> Error **errp)
>                qemu_mutex_unlock_ramlist();
>                return;
>            }
> +
> +        new_block->flags |= RAM_DEFAULT_PRIVATE;
>        }
> 
> then this patch can be dropped, and the calling of
> memory_region_set_default_private(mr) of Patch 45 can be dropped too.
> 
> I think this is what you suggested, right?

Yes, if that works, great!

-- 
Cheers,

David / dhildenb



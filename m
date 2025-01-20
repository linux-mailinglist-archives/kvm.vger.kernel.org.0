Return-Path: <kvm+bounces-36006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 54975A16CE8
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28529188163E
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8911E25E8;
	Mon, 20 Jan 2025 13:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RBAIOX7M"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E681E0E14
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737378388; cv=none; b=PncIiaxLYBJ+j0Fo+MazaIWvqrYtpxbsj8yOvurWCqH7qOTtxqHH0tOMKYqJEOIxdGrjsy3snxoNoJmkMs1RPmLQUHMpJ0EDGs9zWyK+TUdm9kuC8ElpViMSIObua+1y/K+o/0h+GENhhOsZv+LgCq26eOok+6tP1yo19UlelSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737378388; c=relaxed/simple;
	bh=5hDzLbYbPbucQz3I8YLhe/EKeTbe+d8Vez78oOH2AmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YX0DZOM2xnEZPod6aEFxn69p4KLI1HRM6O/qAh7CUjDxIyiAD8zjQfSDRushyLBmwrI6PVC280/8AvNo17UHShhsPLv4Esx6ndoPQrmCOKmPnjKE1F9Xhj2nFZ8d/biORKWYqjp5+Q4tpffuY3EoirJqA95QP1kVIC+SkHxqiUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RBAIOX7M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737378384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9n9dFNAdLyTwYhh9oI8AAgKSbWNe93W2ddbjG0sj8gc=;
	b=RBAIOX7MD+IkV2VkidvhFxacFeQ5ZiA6IWy3zFiICnzdQpIiepUE7XheDS9hOH7h1UWWme
	G+k9dq1P5VrvvYHbMzh8TruVKlpg6yAnwfkrANhRJ7uzUo2o/57GKtIEpnLACRfmwrwOj0
	wvpT4DvO3yN/LMtPGLyw8Rc/NFUIoYw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-56vMUpWCM36i89RDRNEFFA-1; Mon, 20 Jan 2025 08:06:23 -0500
X-MC-Unique: 56vMUpWCM36i89RDRNEFFA-1
X-Mimecast-MFC-AGG-ID: 56vMUpWCM36i89RDRNEFFA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4361ecebc5bso23354555e9.1
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 05:06:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737378382; x=1737983182;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9n9dFNAdLyTwYhh9oI8AAgKSbWNe93W2ddbjG0sj8gc=;
        b=niGN9jhEtcz8LtlMd8csSHqUuIWrcLkesqIhQNxWGlUt1pnJX639fhoISu1fLifjQe
         CRNcKDEaBAGgQ+OgnmpXNMuO7WBH4YS7IAPw3sWLWjrR7+7wy5krYU23YxhsjFCzVHp1
         YQwpL4cyRLzLAdwwgJrDmgYGMoZtwmycFriVgedGFgIr4g3b+hxtCS7S9+YrD5sJq/6k
         9DCNQZvxGIQAsbZrX1GMbizvq7xYWmz3sTDx5XuLjtosFdLp5XcuPr0lnvwqRkKFbM+o
         5xBqC9/bKyW/lfBG9GpkfE/aXW3iC1it3e6VFAXlBKQCJh0ygO1bS36zN8UBDj5lqlZa
         RhaA==
X-Forwarded-Encrypted: i=1; AJvYcCX4LlLNY7c+4QhSNJ3hefDLlEwn/5lGkf0ZURPJR16iABPhkMBPzb2xEcFQa1ggEqPpyR4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtW2qiAyvkSkMADldlMBYPKM+pMPMt6yeIbCwem7txosce14EV
	wGGjn9ubcjweA3Fo2EjA9dLwLHu2nCkWmrKj4sumy2CD4HclSm7OzgPzedSjH3Co9PPPQmTonhm
	ItdyXUfVWdqU8K0jT2+e0Y7qbENxw6M7MxLSV5LfXYraaRwhx9A==
X-Gm-Gg: ASbGncsVZwp6GBPHP6mFkFpRhPneFJP8N2RBxIXGO3Lq/rtO7+Rd6Fe5mfu72W65tFC
	Lq+5RKHftYhfbQeWun0PdkfSnDjXEyqoGt127kNIAqNg72fKUF+RJNkxYRHehX5oae5D07tjENb
	xoJSyL/ebGUO7LT2rClf13CPAfGNQg9MBngLVXAcLjBWgaSKUTU2Pdt3tAlezCRtWlJjEvJcaUL
	CPlMfRwvNSplCtMttmiRgUuM8Ycm5IbMHwSOKpoCjBpSBD/uY2w0/Fh09jVm32SC7PkzEnqxij/
	UDMEs8F9elhKhRAox8r4qqt9I0J/CwHNHHdbQJsrdwUiULCRMpY+O7mFUOn0PUuPa0WzVOVfSJv
	zLa5WTDep01xgAadafoH+Ew==
X-Received: by 2002:a05:600c:4f93:b0:436:6160:5b81 with SMTP id 5b1f17b1804b1-438913dbf79mr134993135e9.14.1737378382131;
        Mon, 20 Jan 2025 05:06:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHk73YqQKj2Mfi9Ss+A2la2pCUEUIEbd0xUqqWhhpXlgsaZBOZmbvIEZpFO1WxopwaLzVcSUw==
X-Received: by 2002:a05:600c:4f93:b0:436:6160:5b81 with SMTP id 5b1f17b1804b1-438913dbf79mr134992505e9.14.1737378381621;
        Mon, 20 Jan 2025 05:06:21 -0800 (PST)
Received: from ?IPV6:2003:d8:2f22:1000:d72d:fd5f:4118:c70b? (p200300d82f221000d72dfd5f4118c70b.dip0.t-ipconnect.de. [2003:d8:2f22:1000:d72d:fd5f:4118:c70b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3221c25sm10246722f8f.23.2025.01.20.05.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 05:06:21 -0800 (PST)
Message-ID: <59bd0e82-f269-4567-8f75-a32c9c997ca9@redhat.com>
Date: Mon, 20 Jan 2025 14:06:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] memory: Register the RamDiscardManager instance upon
 guest_memfd creation
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-6-chenyi.qiang@intel.com>
 <2582a187-fa16-427b-a925-2ac564848a69@amd.com>
 <5c999e10-772b-4ece-9eed-4d082712b570@intel.com>
 <09b82b7f-7dec-4dd9-bfc0-707f4af23161@amd.com>
 <13b85368-46e8-4b82-b517-01ecc87af00e@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
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
In-Reply-To: <13b85368-46e8-4b82-b517-01ecc87af00e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10.01.25 06:13, Chenyi Qiang wrote:
> 
> 
> On 1/9/2025 5:32 PM, Alexey Kardashevskiy wrote:
>>
>>
>> On 9/1/25 16:34, Chenyi Qiang wrote:
>>>
>>>
>>> On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>> Introduce the realize()/unrealize() callbacks to initialize/
>>>>> uninitialize
>>>>> the new guest_memfd_manager object and register/unregister it in the
>>>>> target MemoryRegion.
>>>>>
>>>>> Guest_memfd was initially set to shared until the commit bd3bcf6962
>>>>> ("kvm/memory: Make memory type private by default if it has guest memfd
>>>>> backend"). To align with this change, the default state in
>>>>> guest_memfd_manager is set to private. (The bitmap is cleared to 0).
>>>>> Additionally, setting the default to private can also reduce the
>>>>> overhead of mapping shared pages into IOMMU by VFIO during the bootup
>>>>> stage.
>>>>>
>>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>>> ---
>>>>>     include/sysemu/guest-memfd-manager.h | 27 +++++++++++++++++++++++
>>>>> ++++
>>>>>     system/guest-memfd-manager.c         | 28 +++++++++++++++++++++++
>>>>> ++++-
>>>>>     system/physmem.c                     |  7 +++++++
>>>>>     3 files changed, 61 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/
>>>>> guest-memfd-manager.h
>>>>> index 9dc4e0346d..d1e7f698e8 100644
>>>>> --- a/include/sysemu/guest-memfd-manager.h
>>>>> +++ b/include/sysemu/guest-memfd-manager.h
>>>>> @@ -42,6 +42,8 @@ struct GuestMemfdManager {
>>>>>     struct GuestMemfdManagerClass {
>>>>>         ObjectClass parent_class;
>>>>>     +    void (*realize)(GuestMemfdManager *gmm, MemoryRegion *mr,
>>>>> uint64_t region_size);
>>>>> +    void (*unrealize)(GuestMemfdManager *gmm);
>>>>>         int (*state_change)(GuestMemfdManager *gmm, uint64_t offset,
>>>>> uint64_t size,
>>>>>                             bool shared_to_private);
>>>>>     };
>>>>> @@ -61,4 +63,29 @@ static inline int
>>>>> guest_memfd_manager_state_change(GuestMemfdManager *gmm, uint6
>>>>>         return 0;
>>>>>     }
>>>>>     +static inline void guest_memfd_manager_realize(GuestMemfdManager
>>>>> *gmm,
>>>>> +                                              MemoryRegion *mr,
>>>>> uint64_t region_size)
>>>>> +{
>>>>> +    GuestMemfdManagerClass *klass;
>>>>> +
>>>>> +    g_assert(gmm);
>>>>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>>>>> +
>>>>> +    if (klass->realize) {
>>>>> +        klass->realize(gmm, mr, region_size);
>>>>
>>>> Ditch realize() hook and call guest_memfd_manager_realizefn() directly?
>>>> Not clear why these new hooks are needed.
>>>
>>>>
>>>>> +    }
>>>>> +}
>>>>> +
>>>>> +static inline void guest_memfd_manager_unrealize(GuestMemfdManager
>>>>> *gmm)
>>>>> +{
>>>>> +    GuestMemfdManagerClass *klass;
>>>>> +
>>>>> +    g_assert(gmm);
>>>>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>>>>> +
>>>>> +    if (klass->unrealize) {
>>>>> +        klass->unrealize(gmm);
>>>>> +    }
>>>>> +}
>>>>
>>>> guest_memfd_manager_unrealizefn()?
>>>
>>> Agree. Adding these wrappers seem unnecessary.
>>>
>>>>
>>>>
>>>>> +
>>>>>     #endif
>>>>> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-
>>>>> manager.c
>>>>> index 6601df5f3f..b6a32f0bfb 100644
>>>>> --- a/system/guest-memfd-manager.c
>>>>> +++ b/system/guest-memfd-manager.c
>>>>> @@ -366,6 +366,31 @@ static int
>>>>> guest_memfd_state_change(GuestMemfdManager *gmm, uint64_t offset,
>>>>>         return ret;
>>>>>     }
>>>>>     +static void guest_memfd_manager_realizefn(GuestMemfdManager *gmm,
>>>>> MemoryRegion *mr,
>>>>> +                                          uint64_t region_size)
>>>>> +{
>>>>> +    uint64_t bitmap_size;
>>>>> +
>>>>> +    gmm->block_size = qemu_real_host_page_size();
>>>>> +    bitmap_size = ROUND_UP(region_size, gmm->block_size) / gmm-
>>>>>> block_size;
>>>>
>>>> imho unaligned region_size should be an assert.
>>>
>>> There's no guarantee the region_size of the MemoryRegion is PAGE_SIZE
>>> aligned. So the ROUND_UP() is more appropriate.
>>
>> It is all about DMA so the smallest you can map is PAGE_SIZE so even if
>> you round up here, it is likely going to fail to DMA-map later anyway
>> (or not?).
> 
> Checked the handling of VFIO, if the size is less than PAGE_SIZE, it
> will just return and won't do DMA-map.
> 
> Here is a different thing. It tries to calculate the bitmap_size. The
> bitmap is used to track the private/shared status of the page. So if the
> size is less than PAGE_SIZE, we still use the one bit to track this
> small-size range.
> 
>>
>>
>>>>> +
>>>>> +    gmm->mr = mr;
>>>>> +    gmm->bitmap_size = bitmap_size;
>>>>> +    gmm->bitmap = bitmap_new(bitmap_size);
>>>>> +
>>>>> +    memory_region_set_ram_discard_manager(gmm->mr,
>>>>> RAM_DISCARD_MANAGER(gmm));
>>>>> +}
>>>>
>>>> This belongs to 2/7.
>>>>
>>>>> +
>>>>> +static void guest_memfd_manager_unrealizefn(GuestMemfdManager *gmm)
>>>>> +{
>>>>> +    memory_region_set_ram_discard_manager(gmm->mr, NULL);
>>>>> +
>>>>> +    g_free(gmm->bitmap);
>>>>> +    gmm->bitmap = NULL;
>>>>> +    gmm->bitmap_size = 0;
>>>>> +    gmm->mr = NULL;
>>>>
>>>> @gmm is being destroyed here, why bother zeroing?
>>>
>>> OK, will remove it.
>>>
>>>>
>>>>> +}
>>>>> +
>>>>
>>>> This function belongs to 2/7.
>>>
>>> Will move both realizefn() and unrealizefn().
>>
>> Yes.
>>
>>
>>>>
>>>>>     static void guest_memfd_manager_init(Object *obj)
>>>>>     {
>>>>>         GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>>>>> @@ -375,7 +400,6 @@ static void guest_memfd_manager_init(Object *obj)
>>>>>       static void guest_memfd_manager_finalize(Object *obj)
>>>>>     {
>>>>> -    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>>>>>     }
>>>>>       static void guest_memfd_manager_class_init(ObjectClass *oc, void
>>>>> *data)
>>>>> @@ -384,6 +408,8 @@ static void
>>>>> guest_memfd_manager_class_init(ObjectClass *oc, void *data)
>>>>>         RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>>>>           gmmc->state_change = guest_memfd_state_change;
>>>>> +    gmmc->realize = guest_memfd_manager_realizefn;
>>>>> +    gmmc->unrealize = guest_memfd_manager_unrealizefn;
>>>>>           rdmc->get_min_granularity =
>>>>> guest_memfd_rdm_get_min_granularity;
>>>>>         rdmc->register_listener = guest_memfd_rdm_register_listener;
>>>>> diff --git a/system/physmem.c b/system/physmem.c
>>>>> index dc1db3a384..532182a6dd 100644
>>>>> --- a/system/physmem.c
>>>>> +++ b/system/physmem.c
>>>>> @@ -53,6 +53,7 @@
>>>>>     #include "sysemu/hostmem.h"
>>>>>     #include "sysemu/hw_accel.h"
>>>>>     #include "sysemu/xen-mapcache.h"
>>>>> +#include "sysemu/guest-memfd-manager.h"
>>>>>     #include "trace.h"
>>>>>       #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
>>>>> @@ -1885,6 +1886,9 @@ static void ram_block_add(RAMBlock *new_block,
>>>>> Error **errp)
>>>>>                 qemu_mutex_unlock_ramlist();
>>>>>                 goto out_free;
>>>>>             }
>>>>> +
>>>>> +        GuestMemfdManager *gmm =
>>>>> GUEST_MEMFD_MANAGER(object_new(TYPE_GUEST_MEMFD_MANAGER));
>>>>> +        guest_memfd_manager_realize(gmm, new_block->mr, new_block-
>>>>>> mr->size);
>>>>
>>>> Wow. Quite invasive.
>>>
>>> Yeah... It creates a manager object no matter whether the user wants to
>>> us    e shared passthru or not. We assume some fields like private/shared
>>> bitmap may also be helpful in other scenario for future usage, and if no
>>> passthru device, the listener would just return, so it is acceptable.
>>
>> Explain these other scenarios in the commit log please as otherwise
>> making this an interface of HostMemoryBackendMemfd looks way cleaner.
>> Thanks,
> 
> Thanks for the suggestion. Until now, I think making this an interface
> of HostMemoryBackend is cleaner. The potential future usage for
> non-HostMemoryBackend guest_memfd-backed memory region I can think of is
> the the TEE I/O for iommufd P2P support? when it tries to initialize RAM
> device memory region with the attribute of shared/private. But I think
> it would be a long term story and we are not sure what it will be like
> in future.

As raised in #2, I'm don't think this belongs into HostMemoryBackend. It 
kind-of belongs to the RAMBlock, but we could have another object 
(similar to virtio-mem currently managing a single 
HostMemoryBackend->RAMBlock) that takes care of that for multiple memory 
backends.

-- 
Cheers,

David / dhildenb



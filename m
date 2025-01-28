Return-Path: <kvm+bounces-36795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 708E8A211BE
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 19:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87E8A3A3978
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 18:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B9E1DE4FA;
	Tue, 28 Jan 2025 18:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XEYz9usD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9170BE40
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 18:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738089716; cv=none; b=WlQADb2+c2rxzRdTgW3PiZEzoWTMW38c8J2wPTyDMZeq/Z5Jwv7/Mrllivxw+8TltD0yV4TP48Ho04FdY8CsoJixvCbg7CGxsEnvesY/MUfmv/3OBp9iuCdNVamhty9MriMpgkcIGDVBdPwJ8zV+ysgmjER4NPIqb4fCJkabHy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738089716; c=relaxed/simple;
	bh=TUZSRa+2Jw94fPageQAcvYUfI2IeUsCvG4+byhRGvLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kUjpZpN3jFo4iqVQKOAQL9tS0RTeen1Z9XVQreh6QHEf9NLsNtmte8jakxfD2BsyA82qlsjXKyWLeRZ6PohlKFhygohbFgSFj+wfrQhwF7bstWLr6nINa5r2onrCmbcDZLb27j19mrZNw7StBTbg3caJs+OTK+I/fK+Ch5/eECA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XEYz9usD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738089713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hFdkk8WNhqsppe9MpUmgNxGQD4WSUP8nhmUn2jukSYY=;
	b=XEYz9usD0sHJOtS0ncuDWx4i/75Bz20mdoCo5CLdwXVKdXl5x6YXYCuevuQh+mJ2s96mNA
	rOwPoFBIO+R8TSzGrRQz2rQudqqiA77rullZGbYEce7eIjQXAlrZ9WjAemqYaDHvov3k1g
	u0Egs7WBKKmF2QFo4mxTZN0EeR7UOhk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-cAwdgNt0OPmXN_5z_uHthg-1; Tue, 28 Jan 2025 13:41:52 -0500
X-MC-Unique: cAwdgNt0OPmXN_5z_uHthg-1
X-Mimecast-MFC-AGG-ID: cAwdgNt0OPmXN_5z_uHthg
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43582d49dacso41739475e9.2
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 10:41:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738089711; x=1738694511;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hFdkk8WNhqsppe9MpUmgNxGQD4WSUP8nhmUn2jukSYY=;
        b=So25SsWuU6phW8NvxcP70Z/gMxnZs0yGWoCpS7KFwYwom733AESEQopxkvVX7cVXRp
         SmqQvv9fDcl85kyWBCek1K4PkO6VuBYDbIEk89GpINtRWl1hrHooCq6HfaaXcnVYWOy8
         hjL6Wn20q5nxzcBXOub7Ax8k94yECK2JdZUkziGwA4ZyxC73ftQ9dii1PAB9qdFVZ15w
         +MspLmPYS9MndbYzUADu4kkE0fpxMZDeQf5aiRwsmGj3rvWAnDiFJcu9QObL2po7ANv+
         /t+vjOkuegFL7cwJCHv7pcZg+0iPt47C9o7QRg4u5YoydI/QhQHyXNO2IcY6fTnJrOhM
         8hJg==
X-Forwarded-Encrypted: i=1; AJvYcCUuAOIFnGWj8fUi3t17VkcOcYgwD2vMW9eOJOpCiOerw2QZpMJMHFXbzjhJG9+AZ8MjzXM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyxo/ynM6IT8SSh+QYEXDQ0J1EAWhNbAjpmtT7Iav6MNnv30XWI
	/nqtkTrH9D3HforERwuF5uWp7St3X6Xhff6Dv4MlrS9NrfsODFcjFb3lp/UbKtOlNdvMqWoY1U6
	JkZ+JyX443ONj84pekogfbhg/KqjlVg6NRXQZomfLqfWqA5PG2Q==
X-Gm-Gg: ASbGncvCnWG1iJIgdQfia5a1+JkuAiTMIvtR9yq+n5MKvRTkJPZpmRsXwsTqIdXUe/O
	yOJxt112Crsr2nZpx9XA8ExZHM4/s9HiNBBch5EGQP0JXibj3jPlc0hOVIPcLEOT3+HWS85mpP8
	ZUkyssgiEEyuhU5HKJef8HLqxmnKqvD68H0eMEEPYZhFnFM5FgFgGadEr20ucgs1yYixQ11EsIv
	lpwVK3mG6X4ia3kkdKGnCAP2uzk+RB6cQ3WvxU3C3b7x2ozmBw82uAw2LxH8IjjUAOa18ZS7KIi
	Lk4Ji1v6GvsxBjQnja7dZFDHdn9Zd7VGUw==
X-Received: by 2002:a05:600c:500d:b0:434:e9ee:c3d with SMTP id 5b1f17b1804b1-438dc40e4aamr49045e9.20.1738089710790;
        Tue, 28 Jan 2025 10:41:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE12RivI6XWkz5cpG4j6QYXp+ni2gDLNCy3t8U2iLzNsy6//bb43tudEHLAF+epO8I/De14sg==
X-Received: by 2002:a05:600c:500d:b0:434:e9ee:c3d with SMTP id 5b1f17b1804b1-438dc40e4aamr48715e9.20.1738089710358;
        Tue, 28 Jan 2025 10:41:50 -0800 (PST)
Received: from [192.168.3.141] (p5b0c6662.dip0.t-ipconnect.de. [91.12.102.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd507d60sm178265115e9.18.2025.01.28.10.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 10:41:49 -0800 (PST)
Message-ID: <c80016f9-63f3-469f-864b-ca9a2a74735b@redhat.com>
Date: Tue, 28 Jan 2025 19:41:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/6] system/physmem: handle hugetlb correctly in
 qemu_ram_remap()
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
 <20250110211405.2284121-2-william.roche@oracle.com>
 <2a79643f-1d9e-4122-8932-954743a18c21@redhat.com>
 <26617c43-1f6c-4870-b99f-50525acd9134@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <26617c43-1f6c-4870-b99f-50525acd9134@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27.01.25 22:16, William Roche wrote:
> On 1/14/25 15:02, David Hildenbrand wrote:
>> On 10.01.25 22:14, “William Roche wrote:
>>> From: William Roche <william.roche@oracle.com>
>>>
>>> The list of hwpoison pages used to remap the memory on reset
>>> is based on the backend real page size. When dealing with
>>> hugepages, we create a single entry for the entire page.
>>>
>>> To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete
>>> hugetlb page; hugetlb pages cannot be partially mapped.
>>>
>>> Co-developed-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: William Roche <william.roche@oracle.com>
>>> ---
>>
>> See my comments to v4 version and my patch proposal.
> 
> I'm copying and answering your comments here:
> 
> 
> On 1/14/25 14:56, David Hildenbrand wrote:
>> On 10.01.25 21:56, William Roche wrote:
>>> On 1/8/25 22:34, David Hildenbrand wrote:
>>>> On 14.12.24 14:45, “William Roche wrote:
>>>>> From: William Roche <william.roche@oracle.com>
>>>>> [...]
>>>>> @@ -1286,6 +1286,10 @@ static void kvm_unpoison_all(void *param)
>>>>>     void kvm_hwpoison_page_add(ram_addr_t ram_addr)
>>>>>     {
>>>>>         HWPoisonPage *page;
>>>>> +    size_t page_size = qemu_ram_pagesize_from_addr(ram_addr);
>>>>> +
>>>>> +    if (page_size > TARGET_PAGE_SIZE)
>>>>> +        ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);
>>>>
>>>> Is that part still required? I thought it would be sufficient (at least
>>>> in the context of this patch) to handle it all in qemu_ram_remap().
>>>>
>>>> qemu_ram_remap() will calculate the range to process based on the
>>>> RAMBlock page size. IOW, the QEMU_ALIGN_DOWN() we do now in
>>>> qemu_ram_remap().
>>>>
>>>> Or am I missing something?
>>>>
>>>> (sorry if we discussed that already; if there is a good reason it might
>>>> make sense to state it in the patch description)
>>>
>>> You are right, but at this patch level we still need to round up the
>>
>> s/round up/align_down/
>>
>>> address and doing it here is small enough.
>>
>> Let me explain.
>>
>> qemu_ram_remap() in this patch here doesn't need an aligned addr. It
>> will compute the offset into the block and align that down.
>>
>> The only case where we need the addr besides from that is the
>> error_report(), where I am not 100% sure if that is actually what we
>> want to print. We want to print something like ram_block_discard_range().
>>
>>
>> Note that ram_addr_t is a weird, separate address space. The alignment
>> does not have any guarantees / semantics there.
>>
>>
>> See ram_block_add() where we set
>>       new_block->offset = find_ram_offset(new_block->max_length);
>>
>> independent of any other RAMBlock properties.
>>
>> The only alignment we do is
>>       candidate = ROUND_UP(candidate, BITS_PER_LONG << TARGET_PAGE_BITS);
>>
>> There is no guarantee that new_block->offset will be aligned to 1 GiB with
>> a 1 GiB hugetlb mapping.
>>
>>
>> Note that there is another conceptual issue in this function: offset
>> should be of type uint64_t, it's not really ram_addr_t, but an
>> offset into the RAMBlock.
> 
> Ok.
> 
>>
>>> Of course, the code changes on patch 3/7 where we change both x86 and
>>> ARM versions of the code to align the memory pointer correctly in both
>>> cases.
>>
>> Thinking about it more, we should never try aligning ram_addr_t, only
>> the offset into the memory block or the virtual address.
>>
>> So please remove this from this ram_addr_t alignment from this patch,
>> and look into
>> aligning the virtual address / offset for the other user. Again, aligning
>> ram_addr_t is not guaranteed to work correctly.
>>
> 
> Thanks for the technical details.
> 
> The ram_addr_t value alignment on the beginning of the page was useful
> to create a single entry in the hwpoison_page_list for a large page, but
> I understand that this use of ram_addr alignment may not be always accurate.
> Removing this alignment (without replacing it with something else) will
> end up creating several page entries in this list for the same hugetlb
> page. Because when we loose a large page, we can receive several MCEs
> for the sub-page locations touched on this large page before the VM crashes.

Right, although the kernel will currently only a single event IIRC. At 
least for hugetlb.

> So the recovery phase on reset will go through the list to discard/remap
> all the entries, and the same hugetlb page can be treated several times.
> But when we had a single entry for a large page, this multiple
> discard/remap does not occur.
> 
> Now, it could be technically acceptable to discard/remap a hugetlb page
> several times. Other than not being optimal and taking time, the same
> page being mapped or discarded multiple times doesn't seem to be a problem.
> So we can leave the code like that  without complicating it with a block
> and offset attributes to the hwpoison_page_list entries for example.

Right, this is something to optimize when it really becomes a problem I 
think.

-- 
Cheers,

David / dhildenb



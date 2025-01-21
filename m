Return-Path: <kvm+bounces-36176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A53F7A18525
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 19:24:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 744333AA08E
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA081F540C;
	Tue, 21 Jan 2025 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdZU4ngi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86562185920
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 18:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483878; cv=none; b=nQI/k4+4rL47UNRLT6xHqobiAoE0FIDEc9LetbUW6U7lvlFjhdIgPS0XmjdXeY/KxkXsS+92IjjP/6ikvHL2WR/B3LIvxynyI1nT7kf7fbdH2cPnm9/B3V3mL0H8ZBWlfv2HcNRweomR+GY4sXO8XCWj7o9oNvjCP2aegiDW22Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483878; c=relaxed/simple;
	bh=HpHyUrMVA9BbGaey2qWPoT7rO6NGL1q5qmjxP+1T7JQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nSTFY2EYQsc4OHy5Fm6Q6Jllu1Cx2VP2CvJFEfLtQnZ6jMpWfIfYOYD/dJ/VeD4EBRhpF6PiEpPHTXF5zhKI6tMUaOLZamHHTeG/ASz7BjNt2deaitjYDa3RaJqxqVQU1tNbER4SjMngXXv0BB6u6IoIh5JGXcrlzxxCPvFqQ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BdZU4ngi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737483875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z3achXjfure4B4kI7vvZKQv8XjdszCG6tMj8eEymL2U=;
	b=BdZU4ngi4v8zWAs3nS6cCLvq04/O/rl64PEWsxDxH8LUp8ntxWnf6z62xpvEiJlR/2K7k8
	2EvDvrAAX5aI6wdgrXkQ0YP9nX9XQyxEP+rYbZ+cs1KiXwlhqVFFX5JroDbWMv23TeL+Pf
	tTOlDbqJ0DZm1cWYsTqt06UaO6ydQ4g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-RPlGfDe1OJWKX5NyiTOetA-1; Tue, 21 Jan 2025 13:24:33 -0500
X-MC-Unique: RPlGfDe1OJWKX5NyiTOetA-1
X-Mimecast-MFC-AGG-ID: RPlGfDe1OJWKX5NyiTOetA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361ac607b6so46199575e9.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 10:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737483873; x=1738088673;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z3achXjfure4B4kI7vvZKQv8XjdszCG6tMj8eEymL2U=;
        b=Flm7N/foOIpN9B+kEw4sGp6ChAPYVb8imxxSlDdeK0EDKp875nNTDHFCtEiTjk8ZSP
         A+rcsaLStSYG9m1IBWYuRy3o8h/oJLN9XDZsaUzz4RdRaahVeSrBYgoyVUZuFxGZPheG
         ZqRztgrGOfBcXEQhwgzBaptCaD6mXacMt1usFh/WNS2m0Y7JkX81CuumOCWU6OWdhh+g
         4b224MZbdDrd/w/c7FH5wSQsacUTSBQCR3khVKcVGDYsA6keghkwS9fhXul8Vn4r5rhc
         Q118LhcM5gYXxOwlEURmcggly9gyrxDiI+BspFbkMvMBmcfO+HeyHAzz9leEAlLCYUw9
         Y5CA==
X-Forwarded-Encrypted: i=1; AJvYcCVT3o1wOW1B+yvnXf9XgwBAcK5e+kkS2C16W8LLpRGXp6eL1z7Wi3N8+9d2U5cnSC5jvp4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw25Z1Asb+T3dJNFMIhis3m9ZWTbUkKTExwEIqSK1gbzWIjVX+m
	Krj1i4nweWorc2yU0TT8t2PqxhrJGyOH5P7IXFzIiiE5bpC352jZOLwlv+Kef7vHW7Vn1pQQfXP
	bEFub+1/JEjm+Y9aOXIhRR1cXNFJrmFRYKZ9wfdX+MYw1lMq34A==
X-Gm-Gg: ASbGncv/yxBefP7MwxmbXP1bSzT5gweRYzXswbC7WtpeSfpM/9zi6jBF83QKxw2/VDM
	1/WBkmWMvTtIYScyAMxGiUFNEt8zMV9IYWcYUfeNZOMyd+xxGqA/ZTHK5ikHkZeYS2Yk0S9Ctzj
	HJoazynfRr+6CWwu+vHxOQQqwDSq8AOckDK1rWpPD89TA1E833usC/DyQO1w8g50eCJ6p1Kh7Hv
	Ur/NBip7yUZtu2q8ZFGiPPYJ7JJBZavPjJhkySv+TtFnH3C/nAtuahwDtvcmyL5UVC6g1qawPKn
	jMlUOZmf2hxygukRY9nxqFhm1OjAdpDEeoQV083Zupsgs/a/Z2oEQ2ILYDUn17Fl0omEoJSNU5+
	4MBIRSYuhyefpzr5LWkkqig==
X-Received: by 2002:a05:600c:511b:b0:435:14d:f61a with SMTP id 5b1f17b1804b1-438914304a8mr135687015e9.25.1737483872619;
        Tue, 21 Jan 2025 10:24:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGugEDzx6DotqTVZMxWmyk6FJUbSeGGDY9M+0hEsu3zBQ/SDJu8N/EQfuFc1vfSSGhX6b6HkA==
X-Received: by 2002:a05:600c:511b:b0:435:14d:f61a with SMTP id 5b1f17b1804b1-438914304a8mr135686825e9.25.1737483872261;
        Tue, 21 Jan 2025 10:24:32 -0800 (PST)
Received: from ?IPV6:2003:cb:c709:6200:16ba:af70:999d:6a1a? (p200300cbc709620016baaf70999d6a1a.dip0.t-ipconnect.de. [2003:cb:c709:6200:16ba:af70:999d:6a1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c753bee8sm251379565e9.34.2025.01.21.10.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 10:24:30 -0800 (PST)
Message-ID: <fa29f4ef-f67d-44d7-93f0-753437cf12cb@redhat.com>
Date: Tue, 21 Jan 2025 19:24:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/49] HostMem: Add mechanism to opt in kvm guest memfd
 via MachineState
To: Peter Xu <peterx@redhat.com>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-8-michael.roth@amd.com> <Z4_b3Lrpbnyzyros@x1n>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z4_b3Lrpbnyzyros@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.01.25 18:39, Peter Xu wrote:
> On Wed, Mar 20, 2024 at 03:39:03AM -0500, Michael Roth wrote:
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> Add a new member "guest_memfd" to memory backends. When it's set
>> to true, it enables RAM_GUEST_MEMFD in ram_flags, thus private kvm
>> guest_memfd will be allocated during RAMBlock allocation.
>>
>> Memory backend's @guest_memfd is wired with @require_guest_memfd
>> field of MachineState. It avoid looking up the machine in phymem.c.
>>
>> MachineState::require_guest_memfd is supposed to be set by any VMs
>> that requires KVM guest memfd as private memory, e.g., TDX VM.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
>> ---
>> Changes in v4:
>>   - rename "require_guest_memfd" to "guest_memfd" in struct
>>     HostMemoryBackend;	(David Hildenbrand)
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   backends/hostmem-file.c  | 1 +
>>   backends/hostmem-memfd.c | 1 +
>>   backends/hostmem-ram.c   | 1 +
>>   backends/hostmem.c       | 1 +
>>   hw/core/machine.c        | 5 +++++
>>   include/hw/boards.h      | 2 ++
>>   include/sysemu/hostmem.h | 1 +
>>   7 files changed, 12 insertions(+)
>>
>> diff --git a/backends/hostmem-file.c b/backends/hostmem-file.c
>> index ac3e433cbd..3c69db7946 100644
>> --- a/backends/hostmem-file.c
>> +++ b/backends/hostmem-file.c
>> @@ -85,6 +85,7 @@ file_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
>>       ram_flags |= fb->readonly ? RAM_READONLY_FD : 0;
>>       ram_flags |= fb->rom == ON_OFF_AUTO_ON ? RAM_READONLY : 0;
>>       ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
>> +    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
>>       ram_flags |= fb->is_pmem ? RAM_PMEM : 0;
>>       ram_flags |= RAM_NAMED_FILE;
>>       return memory_region_init_ram_from_file(&backend->mr, OBJECT(backend), name,
>> diff --git a/backends/hostmem-memfd.c b/backends/hostmem-memfd.c
>> index 3923ea9364..745ead0034 100644
>> --- a/backends/hostmem-memfd.c
>> +++ b/backends/hostmem-memfd.c
>> @@ -55,6 +55,7 @@ memfd_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
>>       name = host_memory_backend_get_name(backend);
>>       ram_flags = backend->share ? RAM_SHARED : 0;
>>       ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
>> +    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
>>       return memory_region_init_ram_from_fd(&backend->mr, OBJECT(backend), name,
>>                                             backend->size, ram_flags, fd, 0, errp);
>>   }
>> diff --git a/backends/hostmem-ram.c b/backends/hostmem-ram.c
>> index d121249f0f..f7d81af783 100644
>> --- a/backends/hostmem-ram.c
>> +++ b/backends/hostmem-ram.c
>> @@ -30,6 +30,7 @@ ram_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
>>       name = host_memory_backend_get_name(backend);
>>       ram_flags = backend->share ? RAM_SHARED : 0;
>>       ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
>> +    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
>>       return memory_region_init_ram_flags_nomigrate(&backend->mr, OBJECT(backend),
>>                                                     name, backend->size,
>>                                                     ram_flags, errp);
> 
> These change look a bit confusing to me, as I don't see how gmemfd can be
> used with either file or ram typed memory backends..

I recall that the following should work:

"private" memory will come from guest_memfd, "shared" (as in, accessible 
by the host) will come from anonymous memory.

This "anon" memory cannot be "shared" with other processes, but 
virtio-kernel etc. can just use it.

To "share" the memory with other processes, we'd need memfd/file.

> 
> When specified gmemfd=on with those, IIUC it'll allocate both the memory
> (ramblock->host) and gmemfd, but without using ->host.  Meanwhile AFAIU the
> ramblock->host will start to conflict with gmemfd in the future when it
> might be able to be mapp-able (having valid ->host).

These will require a new guest_memfd memory backend (I recall that was 
discussed a couple of times).

> 
> I have a local fix for this (and actually more than below.. but starting
> from it), I'm not sure whether I overlooked something, but from reading the
> cover letter it's only using memfd backend which makes perfect sense to me
> so far. 

Does the anon+guest_memfd combination not work or are you speculating 
about the usability (which I hopefully addressed above).

-- 
Cheers,

David / dhildenb



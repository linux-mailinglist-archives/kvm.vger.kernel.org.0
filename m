Return-Path: <kvm+bounces-10828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D70A4870B77
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 21:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E9611F212AE
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 20:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0637A738;
	Mon,  4 Mar 2024 20:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YdfMfAxd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1047A736
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 20:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709583773; cv=none; b=RbA1DBn7XWlJ3fE6RUCkPsGFYDEktRVwmA8DShSKvZ7EfgywNAb5jiB5YgULgOSqkJRjb8AbFq09TyHLz1LnWazxhEBUdYeARsWlgyMkPqMalhZc0rE4evfB/dUly0Pcoh/YqY6Fcv0vwS04/wA3ZfBidwS9McsFez3RfsbAzyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709583773; c=relaxed/simple;
	bh=95soPNUvVFgtoy742s6zRUav8gzz7P3zB3tjSRBiWv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HAf0g+yMWtHCE3pbLBh3fcOWmkGMvWwGJKIsf/fjwGgVP+4GNGAP1V2isBsCNJE1pS3mrU+x/hRwQMYYuvWWvRP+Vx4GWlZ6q8wcc2hYHyiuDxwnvQdapOs1nwXpDPm4A/BDABk1Clv4kKFgWNXSBKqyp77wIGzA51WE6jhk6kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YdfMfAxd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709583770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vrXegXABZTyFa0KXs9B20qXl/6fycMW8Hyt3cgljlEk=;
	b=YdfMfAxdsF+Et5RWeXEMyme4jakTOdsIHWz9KjFGTVDl67wOPz2sIQfn6KTUkM6eT5icGP
	O10rruXlydP0JGEaBDMNOx24psbvKdzAPFXbVyevYZpTWyH/1Vm2JPiovDemRkEa5PwQRz
	FwwHnxE6lMSgSJe48fjieHbnH67k2I0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-rZtKd1Q-NUuCp50FWytxpA-1; Mon, 04 Mar 2024 15:22:49 -0500
X-MC-Unique: rZtKd1Q-NUuCp50FWytxpA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-41297aeece5so30144465e9.2
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 12:22:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709583768; x=1710188568;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vrXegXABZTyFa0KXs9B20qXl/6fycMW8Hyt3cgljlEk=;
        b=Yf2KaTkK4ysDL3x9LMCO0EERPYeT1QDiPC35eAQH7e9hft/25NTeB/SjLpOk0CAGfS
         aAFJIJODXqfYDvN/lcJFG+oOEYmsihZBh55nxt5lSVoyHhQOwutBAjSL6gqo7+rLBAfQ
         RKpI79Vax89BoVhVWiJ4yWtz+h/uNQZRopusw6IN+9Ppg6lT0xiSGXov3Uf7RL1DizZS
         56gQA7U6WHHssTqHbHRINDZ9MCxy0PkognbniGXU5EH/Hd86/O0UiY9sQAzRy9GK5YWU
         rqrdpWda6bN5GQPlaGCY3DnSul9hd7VTnyRxUPAemKAa66R3MvhOqkUETvzfoW2LWE8T
         tRJw==
X-Forwarded-Encrypted: i=1; AJvYcCV7YLOW2YyGbAJvDSx2lou8Zv7AozTutwye51AMQucIqigDMFOkZb4yi8QxXCFDGdJrF6/1wl/cKKmvnShqSSnXZo6+
X-Gm-Message-State: AOJu0YxKDlrN1BDBgHp0jK9CT0xisw27NT29C0YvLEe8B8mYHFpNWsoa
	YnSbHDhXjCTRvkiIhEVLdM2weYO9NT4Tq29AS6XeA6YtkdQ5fJRu92EbvkJrRR0TqAqOrC50Ona
	4WBhx2rfVosGK22USo+zBrYjQlBuxVMRVgf20RFCj5yayT74gdQ==
X-Received: by 2002:a05:600c:1d9a:b0:412:eaf0:110c with SMTP id p26-20020a05600c1d9a00b00412eaf0110cmr287845wms.21.1709583768025;
        Mon, 04 Mar 2024 12:22:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVonbyQf18GJ5r1CJamDk7YTuN3n8J70bYXzUcKsIFZNq58Twho/fKUjxWq4+76er9hUMYKQ==
X-Received: by 2002:a05:600c:1d9a:b0:412:eaf0:110c with SMTP id p26-20020a05600c1d9a00b00412eaf0110cmr287803wms.21.1709583767585;
        Mon, 04 Mar 2024 12:22:47 -0800 (PST)
Received: from ?IPV6:2003:cb:c733:f100:75e7:a0a4:9ac2:1abb? (p200300cbc733f10075e7a0a49ac21abb.dip0.t-ipconnect.de. [2003:cb:c733:f100:75e7:a0a4:9ac2:1abb])
        by smtp.gmail.com with ESMTPSA id i4-20020a05600c354400b004101f27737asm18975536wmq.29.2024.03.04.12.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 12:22:47 -0800 (PST)
Message-ID: <2773d2e1-9d73-4d38-97f1-4d90c17b2e26@redhat.com>
Date: Mon, 4 Mar 2024 21:22:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Quentin Perret <qperret@google.com>
Cc: Fuad Tabba <tabba@google.com>, Matthew Wilcox <willy@infradead.org>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 seanjc@google.com, brauner@kernel.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <CA+EHjTzHtsbhzrb-TWft1q3Ree3kgzZbsir+R9L0tDgSX-d-0g@mail.gmail.com>
 <20240229114526893-0800.eberman@hu-eberman-lv.qualcomm.com>
 <d8e6c848-e26a-4014-b0c2-f3a21fb4e636@redhat.com>
 <ZeXEUMPn27J5je8T@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZeXEUMPn27J5je8T@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.03.24 13:53, Quentin Perret wrote:
> On Friday 01 Mar 2024 at 12:16:54 (+0100), David Hildenbrand wrote:
>>>> I don't think that we can assume that only a single VMA covers a page.
>>>>
>>>>> But of course, no rmap walk is always better.
>>>>
>>>> We've been thinking some more about how to handle the case where the
>>>> host userspace has a mapping of a page that later becomes private.
>>>>
>>>> One idea is to refuse to run the guest (i.e., exit vcpu_run() to back
>>>> to the host with a meaningful exit reason) until the host unmaps that
>>>> page, and check for the refcount to the page as you mentioned earlier.
>>>> This is essentially what the RFC I sent does (minus the bugs :) ) .
>>>>
>>>> The other idea is to use the rmap walk as you suggested to zap that
>>>> page. If the host tries to access that page again, it would get a
>>>> SIGBUS on the fault. This has the advantage that, as you'd mentioned,
>>>> the host doesn't need to constantly mmap() and munmap() pages. It
>>>> could potentially be optimised further as suggested if we have a
>>>> cooperating VMM that would issue a MADV_DONTNEED or something like
>>>> that, but that's just an optimisation and we would still need to have
>>>> the option of the rmap walk. However, I was wondering how practical
>>>> this idea would be if more than a single VMA covers a page?
>>>>
>>>
>>> Agree with all your points here. I changed Gunyah's implementation to do
>>> the unmap instead of erroring out. I didn't observe a significant
>>> performance difference. However, doing unmap might be a little faster
>>> because we can check folio_mapped() before doing the rmap walk. When
>>> erroring out at mmap() level, we always have to do the walk.
>>
>> Right. On the mmap() level you won't really have to walk page tables, as the
>> the munmap() already zapped the page and removed the "problematic" VMA.
>>
>> Likely, you really want to avoid repeatedly calling mmap()+munmap() just to
>> access shared memory; but that's just my best guess about your user space
>> app :)
> 
> Ack, and expecting userspace to munmap the pages whenever we hit a valid
> mapping in userspace page-tables in the KVM faults path makes for a
> somewhat unusual interface IMO. Userspace can munmap, mmap again, and if
> it doesn't touch the pages, it can proceed to run the guest just fine,
> is that the expectation? If so, it feels like we're 'leaking' internal

It would be weird, and I would not suggest that. It's either

(1) you can leave it mmap'ed, but any access to private memory will 
SIGBUS. The kernel will try zapping pages inside a VMA itself.

(2) you cannot leave it mmap'ed. In order to convert shared -> private, 
you have to munmap. mmap will fail if it would cover a currently-private 
page.

So for (1) you could mmap once in user space and be done with it. For 
(2) you would have to mmap+munmap when accessing shared memory.

> kernel state somehow. The kernel is normally well within its rights to
> zap userspace mappings if it wants to e.g. swap. (Obviously mlock is a
> weird case, but even in that case, IIRC the kernel still has a certain
> amount of flexibility and can use compaction and friends). Similarly,
> it should be well within its right to proactively create them. How
> would this scheme work if, 10 years from now, something like
> Speculative Page Faults makes it into the kernel in a different form?

At least with (2), speculative page faults would never generate a 
SIGBUS. Just like HW must not generate a fault on speculative access.

> 
> Not requiring to userspace to unmap makes the userspace interface a lot
> simpler I think -- once a protected guest starts, you better not touch
> its memory if it's not been shared back or you'll get slapped on the
> wrist. Whether or not those pages have been accessed beforehand for
> example is irrelevant.

Yes. So the theory :)

-- 
Cheers,

David / dhildenb



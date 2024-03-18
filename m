Return-Path: <kvm+bounces-12027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A83187F2DD
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:03:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6978CB222E9
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C31D5A0FA;
	Mon, 18 Mar 2024 22:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GVJK/VQq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78B35A7A6
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 22:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799346; cv=none; b=Iil9wY/VgxHNdi1ELdOVok2Gmtih6j5FXsQ4VXoD/Y4EM+jOLuCQFa5U0nWiun/2Ny96qNdvxmrXxJeigGxlhAlrC0/CUts8rlb3METWiyPowos9+eKC+23d3hZOtkHshJUgAtrUttC8DoiUbw1Sg+Fplxv6P/efrJdmvJcY4bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799346; c=relaxed/simple;
	bh=q2hJf3vWjTz1U6QyrxoSQwaCjiImi6KyJaUbavnGkec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WYTZKh4zsVGrM6V20lzuKpfVJzV1bZFGrCdIgKALodTf7X8ucLGISvTOqf5J/ntfl5kP+I0Qv+l82DJE8/Uj4meR2JHKBj3eLFahFaQxzKtmv6CpO0wvbQ1lZpujc37sksxwDx1VFp1LDtEpzoPfCIxC4nGLplS01S4X66EqcZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GVJK/VQq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710799343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=558BlsrQU8bWToq/MP7ME6ElVXXDjRwjdLMSKlPG+J0=;
	b=GVJK/VQqz2U023kmjTT9+cL0eqjij6py8o7ePneLuEDrvjg4SmQDsWUP3d05LFvJKY3nVT
	zim/Ys5nKQ25ZgSpva/XigtEBWNEF5Ir31i/VU/tNPELI4/SUYiK4Q8ng0uipVUk0AS4Hm
	ysBU0lfeGQMFkmiTnqpi3IvvhkzBN4Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-VW_rD2MzN-mBfVtgU59i2w-1; Mon, 18 Mar 2024 18:02:22 -0400
X-MC-Unique: VW_rD2MzN-mBfVtgU59i2w-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40e40126031so32826345e9.0
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 15:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799341; x=1711404141;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=558BlsrQU8bWToq/MP7ME6ElVXXDjRwjdLMSKlPG+J0=;
        b=Iu9CwR+xe3CyGap0HuQlK4MGtx2AGOdIJpk6tS9/7azmCA7bLbChQn5JSYVhtP8Gms
         uBjbhznGIqm3oX4oztu1YeApXVn5Zn0XSFO9ouXcs0TtvjPDSC+ekBfNV30KX3xnyzPX
         WKdntf6bkCfNKgnHp+jAsf1lC7aqek0p/qchP/TVohi9WOspOAolF3ibXQ51256IvSaM
         dKjL0pnUR85t8Tq7JybqPMsyBO9TqrtqqdN6oimJt5Qtx1tslykUpA1gRX3cpyU9TFy9
         3VyGXZKNdONEv0CIKg/4Fqu1Wmzg0jJnVZH1gKCMHHubHWPTofx2SWx8u+GqBDgUHrox
         wMEw==
X-Forwarded-Encrypted: i=1; AJvYcCUtK6H4/1/q9oJrWOxeDz6GOpl6fNqlvOFh6IwIvgp8jmgpysAn6Cj4PCckCuApghs0iZNUDJLp9+tgu6Vh2nwPqJ0I
X-Gm-Message-State: AOJu0Yxwl1z2nx7FYi0304ftQyjppbNNaF5yEhArEN6gPi1mZgXMuIDD
	aSVy1SOsQWhXJeqvLdxEmEHNREycYBP9veS6kk3ukD3URHLPKlYdZMBqF7jMZecJ3LSnPXJyEEz
	pPwn6/Lo2UZPaUBR4lKtRy977VusyBSjbnI2nany3sP5tDmuMITxcy6Avfw==
X-Received: by 2002:a05:600c:35c8:b0:413:feed:b309 with SMTP id r8-20020a05600c35c800b00413feedb309mr7314843wmq.6.1710799341162;
        Mon, 18 Mar 2024 15:02:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGzQsQ2eeXECfnQ2qVVS8wQk/77pmqPtziULZ4wJM+/ieeO8zwTifNOEPyWmxkgY6V8FqR5A==
X-Received: by 2002:a05:600c:35c8:b0:413:feed:b309 with SMTP id r8-20020a05600c35c800b00413feedb309mr7314781wmq.6.1710799340608;
        Mon, 18 Mar 2024 15:02:20 -0700 (PDT)
Received: from ?IPV6:2003:cb:c737:1f00:94ff:246b:30d0:686b? (p200300cbc7371f0094ff246b30d0686b.dip0.t-ipconnect.de. [2003:cb:c737:1f00:94ff:246b:30d0:686b])
        by smtp.gmail.com with ESMTPSA id fa21-20020a05600c519500b004140f9f6f5bsm4998717wmb.25.2024.03.18.15.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 15:02:20 -0700 (PDT)
Message-ID: <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
Date: Mon, 18 Mar 2024 23:02:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Vishal Annapurve <vannapurve@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Quentin Perret <qperret@google.com>, Matthew Wilcox <willy@infradead.org>,
 Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com> <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18.03.24 18:06, Vishal Annapurve wrote:
> On Mon, Mar 4, 2024 at 12:17 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 04.03.24 20:04, Sean Christopherson wrote:
>>> On Mon, Mar 04, 2024, Quentin Perret wrote:
>>>>> As discussed in the sub-thread, that might still be required.
>>>>>
>>>>> One could think about completely forbidding GUP on these mmap'ed
>>>>> guest-memfds. But likely, there might be use cases in the future where you
>>>>> want to use GUP on shared memory inside a guest_memfd.
>>>>>
>>>>> (the iouring example I gave might currently not work because
>>>>> FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and
>>>>> guest_memfd will likely not be detected as shmem; 8ac268436e6d contains some
>>>>> details)
>>>>
>>>> Perhaps it would be wise to start with GUP being forbidden if the
>>>> current users do not need it (not sure if that is the case in Android,
>>>> I'll check) ? We can always relax this constraint later when/if the
>>>> use-cases arise, which is obviously much harder to do the other way
>>>> around.
>>>
>>> +1000.  At least on the KVM side, I would like to be as conservative as possible
>>> when it comes to letting anything other than the guest access guest_memfd.
>>
>> So we'll have to do it similar to any occurrences of "secretmem" in
>> gup.c. We'll have to see how to marry KVM guest_memfd with core-mm code
>> similar to e.g., folio_is_secretmem().
>>
>> IIRC, we might not be able to de-reference the actual mapping because it
>> could get free concurrently ...
>>
>> That will then prohibit any kind of GUP access to these pages, including
>> reading/writing for ptrace/debugging purposes, for core dumping purposes
>> etc. But at least, you know that nobody was able to optain page
>> references using GUP that might be used for reading/writing later.
>>
> 
> There has been little discussion about supporting 1G pages with
> guest_memfd for TDX/SNP or pKVM. I would like to restart this
> discussion [1]. 1G pages should be a very important usecase for guest
> memfd, especially considering large VM sizes supporting confidential
> GPU/TPU workloads.
> 
> Using separate backing stores for private and shared memory ranges is
> not going to work effectively when using 1G pages. Consider the
> following scenario of memory conversion when using 1G pages to back
> private memory:
> * Guest requests conversion of 4KB range from private to shared, host
> in response ideally does following steps:
>      a) Updates the guest memory attributes
>      b) Unbacks the corresponding private memory
>      c) Allocates corresponding shared memory or let it be faulted in
> when guest accesses it
> 
> Step b above can't be skipped here, otherwise we would have two
> physical pages (1 backing private memory, another backing the shared
> memory) for the same GPA range causing "double allocation".
> 
> With 1G pages, it would be difficult to punch KBs or even MBs sized
> hole since to support that:
> 1G page would need to be split (which hugetlbfs doesn't support today
> because of right reasons), causing -
>          - loss of vmemmap optimization [3]
>          - losing ability to reconstitute the huge page again,
> especially as private pages in CVMs are not relocatable today,
> increasing overall fragmentation over time.
>                - unless a smarter algorithm is devised for memory
> reclaim to reconstitute large pages for unmovable memory.
> 
> With the above limitations in place, best thing could be to allow:
>   - single backing store for both shared and private memory ranges
>   - host userspace to mmap the guest memfd (as this series is trying to do)
>   - allow userspace to fault in memfd file ranges that correspond to
> shared GPA ranges
>       - pagetable mappings will need to be restricted to shared memory
> ranges causing higher granularity mappings (somewhat similar to what
> HGM series from James [2] was trying to do) than 1G.
>   - Allow IOMMU also to map those pages (pfns would be requested using
> get_user_pages* APIs) to allow devices to access shared memory. IOMMU
> management code would have to be enlightened or somehow restricted to
> map only shared regions of guest memfd.
>   - Upon conversion from shared to private, host will have to ensure
> that there are no mappings/references present for the memory ranges
> being converted to private.
> 
> If the above usecase sounds reasonable, GUP access to guest memfd
> pages should be allowed.

To say it with nice words: "Not a fan".

First, I don't think only 1 GiB will be problematic. Already 2 MiB ones 
will be problematic and so far it is even unclear how guest_memfd will 
consume them in a way acceptable to upstream MM. Likely not using 
hugetlb from what I recall after the previous discussions with Mike.

Second, we should find better ways to let an IOMMU map these pages, 
*not* using GUP. There were already discussions on providing a similar 
fd+offset-style interface instead. GUP really sounds like the wrong 
approach here. Maybe we should look into passing not only guest_memfd, 
but also "ordinary" memfds.

Third, I don't think we should be using huge pages where huge pages 
don't make any sense. Using a 1 GiB page so the VM will convert some 
pieces to map it using PTEs will destroy the whole purpose of using 1 
GiB pages. It doesn't make any sense.

A direction that might make sense is either (A) enlighting the VM about 
the granularity in which memory can be converted (but also problematic 
for 1 GiB pages) and/or (B) physically restricting the memory that can 
be converted.

For example, one could create a GPA layout where some regions are backed 
by gigantic pages that cannot be converted/can only be converted as a 
whole, and some are backed by 4k pages that can be converted back and 
forth. We'd use multiple guest_memfds for that. I recall that physically 
restricting such conversions/locations (e.g., for bounce buffers) in 
Linux was already discussed somewhere, but I don't recall the details.

It's all not trivial and not easy to get "clean".

Concluding that individual pieces of a 1 GiB / 2 MiB huge page should 
not be converted back and forth might be a reasonable. Although I'm sure 
people will argue the opposite and develop hackish solutions in 
desperate ways to make it work somehow.

Huge pages, and especially gigantic pages, are simply a bad fit if the 
VM will convert individual 4k pages.


But to answer your last question: we might be able to avoid GUP by using 
a different mapping API, similar to the once KVM now provides.

-- 
Cheers,

David / dhildenb



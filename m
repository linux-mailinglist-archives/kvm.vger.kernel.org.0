Return-Path: <kvm+bounces-49824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64E0AADE554
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 10:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C3B63B9A42
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 08:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1870F27E06C;
	Wed, 18 Jun 2025 08:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="itElWmcg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C3835963
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 08:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750234635; cv=none; b=Td0SvTTxK1zAUBITzc1REHxPVOJoXjdDj6DDbJbreiCuwyS4x/r6MhR6RoOx7y0PRUKObK/AMgYWChuQBJWv/Ds2A2i5a/sYbCWgAVgTGtjGK83AZPa3DdG63dlOEobM9FdDzkVzlT+dEpEbI0gVW/MtIushwE9/CEhU1oKPLE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750234635; c=relaxed/simple;
	bh=W56tEEwIaLYy2gB/tGyxNxHHWEulCSPBBNoAeSq/4lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=URg6Tb1hAgBSuMJjWNcS8yG1vpdMH2+C6wzqoZsk0dLblfSBZ6t+j3AvuVhYktMtM+i5Vs/s5NLso0wfx8lCR72yHauXOZI8TDsz+Y6nBQ34pynOscnPm4C2IeKlrE0SHphzq8pSJDtIb8yhoquuBqqwwcpcOv00RF+l04LiGDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=itElWmcg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750234632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bOZoNJaujjdVlfR2AIdKYM54IJ4MIY01a/D0TQW0tiA=;
	b=itElWmcgQ5r+OMAdRdfDYvo+lUSN910AuGmT0mwP973ZdrCP2BjMfZmEZAekwRiopFzyIh
	Kf5Zlwf89uwCdaiGFBrzvji+KQqIY5fuIo4ydYSoMOxwlbzaxIQZSn03GwBjwTtrBQpYCf
	D5Yt3ySPd7nhQgh8PtbSwoRW+PhNB5Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-Msav015AMeipXkqTUESUzg-1; Wed, 18 Jun 2025 04:16:01 -0400
X-MC-Unique: Msav015AMeipXkqTUESUzg-1
X-Mimecast-MFC-AGG-ID: Msav015AMeipXkqTUESUzg_1750234560
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4f8192e2cso3217903f8f.3
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 01:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750234560; x=1750839360;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bOZoNJaujjdVlfR2AIdKYM54IJ4MIY01a/D0TQW0tiA=;
        b=XxpM6kCuoLWPNaYrgTUrRlW1DyfZ36D3+pc+qEb0aSLuPpQU3kA+IXmDf5ylfFO/iY
         st4+aayEUJVhL9OtrTql9Y6l5FOvf+AMp3zshTX19VldGFZ70bvlk2bnE3AZROtOSZ2/
         WhBYCwKV0CmqFLcDbphFNotbqDPLwg1JumyqOwuMr5yARA/bsa+bJMkQiVdnW73Tgy6g
         KlVEMGioDabz2qfXYiFEfzcI1FYELBWVQr2uIq8gCOKIzdmKICmk003hHHnBcpE35zHL
         6+KQv362dwkH9tyZyqSNlTfWbmAkdJPQ5ZlbaN94asaWfFvaN+YW8NjMs/CwOh+HNGHb
         xWYw==
X-Forwarded-Encrypted: i=1; AJvYcCWUCVUld4Pgo2geGpRIV05ItjoYaRk49qhyQm5luUpM8mre4DbuzhtSdR+POogMsW18SN8=@vger.kernel.org
X-Gm-Message-State: AOJu0YznNMMZcxFGbS+c6DFDBAokNDcvMsY4XX3Rd0qiZLUWOZnQDnKY
	+ZR+jcxIb/yyblOcSL932+iaJNu+SjJMGXqtrm12QMWytW36nRAJCcGTFASzmzYo/4HPEapG6uu
	H0Ozi3kaLuTkULNR7L1px3lJClAOfgcG71IdpDoRMaA6zlZZjdFc3hA==
X-Gm-Gg: ASbGncuRUpLvLVB07wD//RzS7u5f3UR4LRq6ZicESUnJt9Z3xG4ttnXeIs0rfL68Nur
	hs8bezuPsMIlBAieY9rGOIemMsq37ud3BGE2lTA+XohB2TBxRLG3AyEO6Yv/O/4fj5NMeh3dX2L
	Sc7FBdTRP9S6YuVssTYcsusorLBgolyhFPj42BHSncEK6w4mp22EcDs554Go9loZdGdJ5FSU6fc
	gILRES0sXF/ZwOl6BqqLPuhqFKtbZL8j6fOkonM03Zhfe41rqgsSaki8bFFwd2kHbkSoJxrNWh9
	l88wzYQAh+A+c26+J3LQOP2HdRxABdR1cUpmXCem0rx3X3mFd7aEXspNOH5Texq7x+2/Pb0X50e
	UWJ1DIJVz6QiqRAeC/U9WRZt3vWK6pQN6SCx0J5d/j223+HM=
X-Received: by 2002:a05:6000:4702:b0:3a4:f7e3:c63c with SMTP id ffacd0b85a97d-3a571894b7bmr15128770f8f.0.1750234559768;
        Wed, 18 Jun 2025 01:15:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGULgOxtyBoShvE9JSoEwQhPgXEf5lkCjWUOo2bSd3nW0M1xu6HvPbfcWE5OJ17ZOLdT+0Hgw==
X-Received: by 2002:a05:6000:4702:b0:3a4:f7e3:c63c with SMTP id ffacd0b85a97d-3a571894b7bmr15128720f8f.0.1750234559159;
        Wed, 18 Jun 2025 01:15:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2d:2400:4052:3b5:fff9:4ed0? (p200300d82f2d2400405203b5fff94ed0.dip0.t-ipconnect.de. [2003:d8:2f2d:2400:4052:3b5:fff9:4ed0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a547d2sm16556533f8f.19.2025.06.18.01.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 01:15:58 -0700 (PDT)
Message-ID: <3fb0e82b-f4ef-402d-a33c-0b12e8aa990c@redhat.com>
Date: Wed, 18 Jun 2025 10:15:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, Ira Weiny <ira.weiny@intel.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
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
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-9-tabba@google.com> <aEySD5XoxKbkcuEZ@google.com>
 <68501fa5dce32_2376af294d1@iweiny-mobl.notmuch>
 <bbc213c3-bc3d-4f57-b357-a79a9e9290c5@redhat.com>
 <CA+EHjTxvqDr1tavpx7d9OyC2VfUqAko864zH9Qn5+B0UQiM93g@mail.gmail.com>
 <701c8716-dd69-4bf6-9d36-4f8847f96e18@redhat.com>
 <aFIK9l6H7qOG0HYB@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aFIK9l6H7qOG0HYB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.06.25 02:40, Sean Christopherson wrote:
> On Mon, Jun 16, 2025, David Hildenbrand wrote:
>> On 16.06.25 16:16, Fuad Tabba wrote:
>>> On Mon, 16 Jun 2025 at 15:03, David Hildenbrand <david@redhat.com> wrote:
>>>>>> IMO, GUEST_MEMFD_FLAG_SHAREABLE would be more appropriate.  But even that is
>>>>>> weird to me.  For non-CoCo VMs, there is no concept of shared vs. private.  What's
>>>>>> novel and notable is that the memory is _mappable_.  Yeah, yeah, pKVM's use case
>>>>>> is to share memory, but that's a _use case_, not the property of guest_memfd that
>>>>>> is being controlled by userspace.
>>>>>>
>>>>>> And kvm_gmem_memslot_supports_shared() is even worse.  It's simply that the
>>>>>> memslot is bound to a mappable guest_memfd instance, it's that the guest_memfd
>>>>>> instance is the _only_ entry point to the memslot.
>>>>>>
>>>>>> So my vote would be "GUEST_MEMFD_FLAG_MAPPABLE", and then something like
>>>>>
>>>>> If we are going to change this; FLAG_MAPPABLE is not clear to me either.
>>>>> The guest can map private memory, right?  I see your point about shared
>>>>> being overloaded with file shared but it would not be the first time a
>>>>> term is overloaded.  kvm_slot_has_gmem() does makes a lot of sense.
>>>>>
>>>>> If it is going to change; how about GUEST_MEMFD_FLAG_USER_MAPPABLE?
>>>>
>>>> If "shared" is not good enough terminology ...
>>>>
>>>> ... can we please just find a way to name what this "non-private" memory
>>>> is called?
> 
> guest_memfd?  Not trying to be cheeky, I genuinely don't understand the need
> to come up with a different name.  Before CoCo came along, I can't think of a
> single time where we felt the need to describe guest memory.  There have been
> *many* instances of referring to the underlying backing store (e.g. HugeTLB vs.
> THP), and many instances where we've needed to talk about the types of mappings
> for guest memory, but I can't think of any cases where describing the state of
> guest memory itself was ever necessary or even useful.
 >   >>>> That something is mappable into $whatever is not the right
>>>> way to look at this IMHO.
> 
> Why not?  Honest question.  USER_MAPPABLE is very literal, but I think it's the
> right granularity.  E.g. we _could_ support read()/write()/etc, but it's not
> clear to me that we need/want to.  And so why bundle those under SHARED, or any
> other one-size-fits-all flag?

Let's take a step back. There are various ways to look at this:


1) Indicate support for guest_memfd operations:

"GUEST_MEMFD_FLAG_MMAP": we support the mmap() operation
"GUEST_MEMFD_FLAG_WRITE": we support the write() operation
"GUEST_MEMFD_FLAG_READ": we support the read() operation
...
"GUEST_MEMFD_FLAG_UFFD": we support userfaultfd operations


Absolutely fine with me. In this series, we'd be advertising 
GUEST_MEMFD_FLAG_MMAP. Because we support the mmap operation.

If the others are ever required remains to be seen [1].


2) Indicating the mmap mapping type (support for MMAP flags)

As you write below, one could indicate that we support 
"mmap(MAP_SHARED)" vs "mmap(MAP_PRIVATE)".

I don't think that's required for now, as MAP_SHARED is really the 
default that anything that supports mmap() supports. If someone ever 
needs MAP_PRIVATE (CoW) support they can add such a flag 
(GUEST_MEMFD_FLAG_MMAP_MAP_PRIVATE). I doubt we want that, but who knows.

As expressed elsewhere, the mmap mapping type was never what the 
"SHARED" in KVM_GMEM_SHARED_MEM implied.


3) *guest-memfd specific* memory access characteristics

"private (non-accessible, private, secure, protected, ...) vs. 
"non-private".

Traditionally, all was memory in guest-memfd was private, now we will 
make guest_memfd also support non-private memory. As this memory is 
"inaccessible" from a host point of view, any access to read/write it 
(fault it into user page tables, read(), write(), etc) will fail.



Mempolicy support wanted to support mmap() without that, though [2], 
which was one of the reasons I agreed that exposing the access 
characteristics (that affect what you can actually mmap() ) made sense.

In the last upstream meeting we agreed that we will not do that, but 
rather built up on MMAP+support for non-private memory support.


[1] 
https://lore.kernel.org/kvm/20250303130838.28812-1-kalyazin@amazon.com/T/
[2] 
https://lore.kernel.org/linux-mm/20250408112402.181574-1-shivankg@amd.com/

[...]

>>>> I'll further note that in the doc of KVM_SET_USER_MEMORY_REGION2 we talk
>>>> about "private" vs "shared" memory ... so that would have to be improved
>>>> as well.
>>>
>>> To add to what David just wrote, V1 of this series used the term
>>> "mappable" [1].  After a few discussions, I thought the consensus was
>>> that "shared" was a more accurate description --- i.e., mappability
>>> was a side effect of it being shared with the host.
> 
> As I mentioned in the other thread with respect to sharing between other
> entities, simply SHARED doesn't provide sufficient granularity.  HOST_SHAREABLE
> gets us closer, but I still don't like that because it implies the memory is
> 100% shareable, e.g. can be accessed just like normal memory.
> 
> And for non-CoCo x86 VMs, sharing with host userspace isn't even necessarily the
> goal, i.e. "sharing" is a side effect of needing to allow mmap() so that KVM can
> continue to function.

Does mmap() support imply "support for non-private" memory or does 
"support for non-private" imply mmap() support? :)

In this series we went for the latter. If I got you correctly, you argue 
for the former.

Maybe both things should simply be separated.

> 
>>> One could argue that non-CoCo VMs have no concept of "shared" vs
>>> "private".
> 
> I am that one :-)

Well, if the concept of "private" does not exist, I'd argue everything 
is "non-private" :)

> 
>> A different way of looking at it is, non-CoCo VMs have
>>> their state as shared by default.
> 
> Eh, there has to be another state for there to be a default.
> 
>> All memory of these VMs behaves similar to other memory-based shared memory
>> backends (memfd, shmem) in the system, yes. You can map it into multiple
>> processes and use it like shmem/memfd.
> 
> Ya, but that's more because guest_memfd only supports MAP_SHARED, versus KVM
> really wanting to truly share the memory with the entire system.
 > > Of course, that's also an argument to some extent against 
USER_MAPPABLE, because
> that name assumes we'll never want to support MAP_PRIVATE.  But letting userspace
> MAP_PRIVATE guest_memfd would completely defeat the purpose of guest_memfd, so
> unless I'm forgetting a wrinkle with MAP_PRIVATE vs. MAP_SHARED, that's an
> assumption I'm a-ok making.

So, first important question, are we okay with adding:

"GUEST_MEMFD_FLAG_MMAP": we support the mmap() operation

> 
> If we are really dead set on having SHARED in the name, it could be
> GUEST_MEMFD_FLAG_USER_MAPPABLE_SHARED or GUEST_MEMFD_FLAG_USER_MAP_SHARED?  But
> to me that's _too_ specific and again somewhat confusing given the unfortunate
> private vs. shared usage in CoCo-land.  And just playing the odds, I'm fine taking
> a risk of ending up with GUEST_MEMFD_FLAG_USER_MAPPABLE_PRIVATE or whatever,
> because I think that is comically unlikely to happen.

I think in addition to GUEST_MEMFD_FLAG_MMAP we want something to 
express "this is not your old guest_memfd that only supports private 
memory". And that's what I am struggling with.

Now, if you argue "support for mmap() implies support for non-private 
memory", I'm probably okay for that.

I could envision support for non-private memory even without mmap() 
support, how useful that might be, I don't know. But that's why I was 
arguing that we mmap() is just one way to consume non-private memory.

-- 
Cheers,

David / dhildenb



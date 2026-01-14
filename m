Return-Path: <kvm+bounces-68072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 39161D20E18
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 19:47:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C77F309F73A
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 18:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9791133AD9C;
	Wed, 14 Jan 2026 18:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vtHdUz7K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7E02FD1CA
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 18:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768416337; cv=none; b=krLQVxfhg8EPw6eTHLAwCIIfc7+BvfTmRmKDa0ObhotAUCBZxK7QvKAuUO56JvW7lOF4KG+uaj2tzkmKBiyLL6wwz61io9/kvKYaK/ZbQNn/7XT1AU3fi+LKWO46Qy2i5mC1R6l/WPlT+Zi+L2vgBLgJV+t+94+D0h2HcAnYz1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768416337; c=relaxed/simple;
	bh=K4rlJ8iT7dPAZ2tzyYwmGOZqOy3f7q5MBQ0scHGUjwQ=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pJ8pLmYLPCtPtR3KiB2YujzWclEmxgJDW8+fIN7EMyX77FQd9y0rsEHb+G6LXHIvANJINaV3dlepJXfetU6IHpVjHGxV3JZZ7vZeAmbG8pZk9LpGHG0dHqeVeTcbvoQooh+5Hc05g51PTdbIxJO18tqQL78hC5DkcDLjC1Oy+cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vtHdUz7K; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5eea9fbe4a4so49608137.0
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 10:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768416334; x=1769021134; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=rSA8PgyWzWzfu+Q9Uw1+/DUwHs0+nLAOCvWbgHlLObI=;
        b=vtHdUz7K/0TbkPLlR1RIg6Et5/BlIqz5J4T/ToODjuUdkoGHmz36PY3NMFBnvo8htW
         GGheqkDW8c24twPnebTYLJEXeGz3YVJDOi/j1ZW7PymmiC37dTkzNnNFvAj7fTKnSlUA
         SzbXKKUYeNcDvc6keLNva2SV7SgqKdlWtwxS8Kad3QTGXyewE7DNxJbNA/cER708yYGE
         lz0Cqw1twnfZ6jKLC9rL+bmvFdrqDQ6+u2APQBdwbYheK0yA6MtEP3Tpi63d1ZvMKi18
         oCbO8Sf/m+qGtrjvFdv28U+LNUUxcEKjnVRffld6rXA/F2zxD/C6+xP2PGgX00fcUhDR
         p4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768416334; x=1769021134;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rSA8PgyWzWzfu+Q9Uw1+/DUwHs0+nLAOCvWbgHlLObI=;
        b=cXcYjp0jl0jrnwmuQpY2ROQ0yZnq6udYfLPnJE5sQotBzUehaI/bxpS5LFW02I5pNv
         WJa1Vao/C21ApkPv8uQZ8jOGpOYEHTnkZe8Zlac8cg3np33CjyjTcRPwc12rUu1trl5r
         8FnnJif3/kgNrBqVcUEmxgygF1sWvtXBzdXbew8IzSNjyN8jowKoedISLYnNkFR3TDNj
         l+nItHpWJIG+LYKQPEBGo8D6YRvTEZVkq1pAAcGVZQ3FVc/PrO44fZ9hVRTEMTRsrNEJ
         jwqK8ounaogREmT4CJKEjaIeFq80HBkPB2XMGNyc7/IGw4HnqJ/XtOHecGqbMSnkQi43
         UGzw==
X-Forwarded-Encrypted: i=1; AJvYcCW9sy/ENCOil24MwMhBK+0T3IcTVos4fJ6FJmlFbMLtopGL77wM84KsG7B3dXuX+0NOZ54=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8iDTrQfKtIPobK4w43UmcjwoWiYZafb/MlKlXTo4YJgO2mBQC
	7DukHL57Hv0V+LTZC6wowDrTmU53Pk6OGc0s7elRZCdjK/zJGW7e1sj42pER3b7F5bOW94vrlOP
	4jhnN0LDXuF0acrcFcGzcZxKl64PO1UpLrEqXfiSR
X-Gm-Gg: AY/fxX7NMXNmWS7MOET2iFzn/Z49BC+2SGRkVtn+uJjM/0ER1m/sfRWEoC1rVTK3eSC
	Ho7XI3mm/dcDQn9GlxXizrFvygh2ACpd4LNP3SPU8sniFfHk8WE+g6+jgoTEtu/iWL4pvmXXkqY
	I9NxFBI6PC/SXdn/VX9/S6yxYih8p2bGtWvmDjOA3oYNkhwKXgLtUfEKFvOGRr+Ag8/o7Rtw7BX
	iwZcWkJZ6h9TGex/e0wQd8Oqc5dQnkbedSAUt458pE8JRd/OVQ8qvX8HlOlLCRqe2vnNb5NVHg7
	NuTWLjnBKJhZwd96xnYwRPG2Sw==
X-Received: by 2002:a05:6102:54a4:b0:5ee:a0e6:a9fa with SMTP id
 ada2fe7eead31-5f17f5ca280mr1655466137.23.1768416333917; Wed, 14 Jan 2026
 10:45:33 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 14 Jan 2026 10:45:32 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 14 Jan 2026 10:45:32 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aWe1tKpFw-As6VKg@google.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 14 Jan 2026 10:45:32 -0800
X-Gm-Features: AZwV_Qh-_6oaDprj-meFuWF9tPMl1Lv6slg9KRRGMmWMUXRdf5Dybb1RywSlNpQ
Message-ID: <CAEvNRgG40xtobd=ocReuFydJ-4iFwAQrdTPcjsVQPugMaaLi_A@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc: Vishal Annapurve <vannapurve@google.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

>>
>> [...snip...]
>>
>> > +100 to being careful, but at the same time I don't think we should get _too_
>> > fixated on the guest_memfd folio size.  E.g. similar to VM_PFNMAP, where there
>> > might not be a folio, if guest_memfd stopped using folios, then the entire
>> > discussion becomes moot.

+1, IMO the usage of folios on the guest_memfd <-> KVM boundary
(kvm_gmem_get_pfn()) is transitional, hopefully we get to a point where
guest_memfd will pass KVM pfn, order and no folios.

>> > And as above, the long-standing rule isn't about the implementation details so
>> > much as it is about KVM's behavior.  If the simplest solution to support huge
>> > guest_memfd pages is to decouple the max order from the folio, then so be it.
>> >
>> > That said, I'd very much like to get a sense of the alternatives, because at the
>> > end of the day, guest_memfd needs to track the max mapping sizes _somewhere_,
>> > and naively, tying that to the folio seems like an easy solution.

The upcoming attributes maple tree allows a lookup from guest_memfd
index to contiguous range, so the max mapping size (at least
guest_memfd's contribution to max mapping level, to be augmented by
contribution from lpage_info etc) would be the contiguous range in the
xarray containing the index, clamped to guest_memfd page size bounds
(both for huge pages and regular PAGE_SIZE pages).

The lookup complexity is mainly the maple tree lookup complexity. This
lookup happens on mapping and on trying to recover to the largest
mapping level, both of which shouldn't happen super often, so I think
this should be pretty good for now.

This max mapping size is currently memoized as folio size with all the
folio splitting work, but memoizing into a folio is expensive (struct
pages/folios are big). Hopefully guest_memfd gets to a point where it
also supports non-struct page backed memory, and that would save us a
bunch more memory.

>>
>> [...snip...]
>>
>> So, out of curiosity, do you know why linux kernel needs to unmap mappings from
>> both primary and secondary MMUs, and check folio refcount before performing
>> folio splitting?
>
> Because it's a straightforward rule for the primary MMU.  Similar to guest_memfd,
> if something is going through the effort of splitting a folio, then odds are very,
> very good that the new folios can't be safely mapped as a contiguous hugepage.
> Limiting mapping sizes to folios makes the rules/behavior straightfoward for core
> MM to implement, and for drivers/users to understand.
>
> Again like guest_memfd, there needs to be _some_ way for a driver/filesystem to
> communicate the maximum mapping size; folios are the "currency" for doing so.
>
> And then for edge cases that want to map a split folio as a hugepage (if any such
> edge cases exist), thus take on the responsibility of managing the lifecycle of
> the mappings, VM_PFNMAP and vmf_insert_pfn() provide the necessary functionality.
>

Here's my understanding, hope it helps: there might also be a
practical/simpler reason for first unmapping then check refcounts, and
then splitting folios, and guest_memfd kind of does the same thing.

Folio splitting races with lots of other things in the kernel, and the
folio lock isn't super useful because the lock itself is going to be
split up.

Folio splitting wants all users to stop using this folio, so one big
source of users is mappings. Hence, get those mappers (both primary and
secondary MMUs) to unmap.

Core-mm-managed mappings take a refcount, so those refcounts go away. Of
the secondary mmu notifiers, KVM doesn't take a refcount, but KVM does
unmap as requested, so that still falls in line with "stop using this
folio".

I think the refcounting check isn't actually necessary if all users of
folios STOP using the folio on request (via mmu notifiers or
otherwise). Unfortunately, there are other users other than mappers. The
best way to find these users is to check the refcount. The refcount
check is asking "how many other users are left?" and if the number of
users is as expected (just the filemap, or whatever else is expected),
then splitting can go ahead, since the splitting code is now confident
the remaining users won't try and use the folio metadata while splitting
is happening.


guest_memfd does a modified version of that on shared to private
conversions. guest_memfd will unmap from host userspace page tables for
the same reason, mainly to tell all the host users to unmap. The
unmapping also triggers mmu notifiers so the stage 2 mappings also go
away (TBD if this should be skipped) and this is okay because they're
shared pages. guest usage will just map them back in on any failure and
it doesn't break guests.

At this point all the mappers are gone, then guest_memfd checks
refcounts to make sure that guest_memfd itself is the only user of the
folio. If the refcount is as expected, guest_memfd is confident to
continue with splitting folios, since other folio accesses will be
locked out by the filemap invalidate lock.

The one main guest_memfd folio user that won't go away on an unmap call
is if the folios get pinned for IOMMU access. In this case, guest_memfd
fails the conversion and returns an error to userspace so userspace can
sort out the IOMMU unpinning.


As for private to shared conversions, folio merging would require the
same thing that nobody else is using the folios (the folio
metadata). guest_memfd skips that check because for private memory, KVM
is the only other user, and guest_memfd knows KVM doesn't use folio
metadata once the memory is mapped for the guest.

>>
>> [...snip...]
>>


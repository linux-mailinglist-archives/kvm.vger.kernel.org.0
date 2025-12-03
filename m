Return-Path: <kvm+bounces-65239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D409CCA1768
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 20:48:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DE563081832
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 19:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2572A312825;
	Wed,  3 Dec 2025 19:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TiFmfslp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7345926E6FD;
	Wed,  3 Dec 2025 19:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764791020; cv=none; b=XNhtmTBnMxCMQCza3si21FhKlD4S2Odk8rXa66my28tAFEy9NLFoJ4LOelY5ZJuhWWYNpc46h8wqUl3i1W7DPn71+tDbUK56/mpUcfsPIsdO215EzTCo1ZbKeN2vZrBm6B/XzCjCWvxsWNKaAovhYwcGf1LSBlF+AYDZNonYddQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764791020; c=relaxed/simple;
	bh=bWOZ0rCV1PNPpXj+8oUS6KZ5pRj/a3w/aJIWyjxRjp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pX1M7qBJTt6bcbfb7QGHstwVNgmWFKPMvEsz8GhNew5cQ766DO0Bk8zriy6RFv8pGBC3SIW+CwxQUoLJRfLbmLRq6/+USI8UnfPVJQI85CasQB0b3Yx58UsvCZD+rCW4Es+od7YIBUde9dn6OZjgJecwTA9Rhegfc5cfR85rnzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TiFmfslp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421D8C4CEF5;
	Wed,  3 Dec 2025 19:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764791019;
	bh=bWOZ0rCV1PNPpXj+8oUS6KZ5pRj/a3w/aJIWyjxRjp8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TiFmfslpXKpLMd4VGIQZGRENUANoV1GI4j6S6Z5rRyRvQfqwzhW2aet54FFCDaiUJ
	 lIap4P2tGkxv1DUxfUYcDYoWyF1jejpG702cshoYE82pVC1C/UqUQst0/Y/vZFs9Hc
	 MEJ7EQWKC9gAqa3M5+cEqiqTeen2xvvoLjzSrye4YJQ4lMgUtyWXcS6dAlNVqt/qr/
	 niko2ItLElc2hsDCRRRPSMB4cpD1DIWgPZZFrI6pIhPfejGzp0KItvjZk1r71W3vDZ
	 0W0QIHK0ZPAGQswyz3y2iS58WKVFHYRNVcc0EO2lk7WEpZdVphPlBrlBVn9z/9whhq
	 gR7C9vkQPvTJQ==
Message-ID: <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>
Date: Wed, 3 Dec 2025 20:43:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
To: Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 kernel-team@meta.com, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, kas@kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 muchun.song@linux.dev, osalvador@suse.de, x86@kernel.org,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>, David Rientjes <rientjes@google.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
 <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/3/25 19:01, Frank van der Linden wrote:
> On Wed, Dec 3, 2025 at 9:53 AM Gregory Price <gourry@gourry.net> wrote:
>>
>> On Wed, Dec 03, 2025 at 12:32:09PM -0500, Johannes Weiner wrote:
>>> On Wed, Dec 03, 2025 at 01:30:04AM -0500, Gregory Price wrote:
>>>> -           if (PageHuge(page))
>>>> -                   return false;
>>>> +           /*
>>>> +            * Only consider ranges containing hugepages if those pages are
>>>> +            * smaller than the requested contiguous region.  e.g.:
>>>> +            *     Move 2MB pages to free up a 1GB range.
>>>
>>> This one makes sense to me.
>>>
>>>> +            *     Don't move 1GB pages to free up a 2MB range.
>>>
>>> This one I might be missing something. We don't use cma for 2M pages,
>>> so I don't see how we can end up in this path for 2M allocations.
>>>
>>
>> I used 2MB as an example, but the other users (listed in the changelog)
>> would run into these as well.  The contiguous order size seemed
>> different between each of the 4 users (memtrace, tx, kfence, thp debug).
>>
>>> The reason I'm bringing this up is because this function overall looks
>>> kind of unnecessary. Page isolation checks all of these conditions
>>> already, and arbitrates huge pages on hugepage_migration_supported() -
>>> which seems to be the semantics you also desire here.
>>>
>>> Would it make sense to just remove pfn_range_valid_contig()?
>>
>> This seems like a pretty clear optimization that was added at some point
>> to prevent incurring the cost of starting to isolate 512MB of pages and
>> then having to go undo it because it ran into a single huge page.
>>
>>          for_each_zone_zonelist_nodemask(zone, z, zonelist,
>>                                          gfp_zone(gfp_mask), nodemask) {
>>
>>                  spin_lock_irqsave(&zone->lock, flags);
>>                  pfn = ALIGN(zone->zone_start_pfn, nr_pages);
>>                  while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>>                          if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
>>
>>                                  spin_unlock_irqrestore(&zone->lock, flags);
>>                                  ret = __alloc_contig_pages(pfn, nr_pages,
>>                                                          gfp_mask);
>>                                  spin_lock_irqsave(&zone->lock, flags);
>>
>>                          }
>>                          pfn += nr_pages;
>>                  }
>>                  spin_unlock_irqrestore(&zone->lock, flags);
>>          }
>>
>> and then
>>
>> __alloc_contig_pages
>>          ret = start_isolate_page_range(start, end, mode);
>>
>> This is called without pre-checking the range for unmovable pages.
>>
>> Seems dangerous to remove without significant data.
>>
>> ~Gregory
> 
> Yeah, the function itself makes sense: "check if this is actually a
> contiguous range available within this zone, so no holes and/or
> reserved pages".
> 
> The PageHuge() check seems a bit out of place there, if you just
> removed it altogether you'd get the same results, right? The isolation
> code will deal with it. But sure, it does potentially avoid doing some
> unnecessary work.

commit 4d73ba5fa710fe7d432e0b271e6fecd252aef66e
Author: Mel Gorman <mgorman@techsingularity.net>
Date:   Fri Apr 14 15:14:29 2023 +0100

     mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages
     
     A bug was reported by Yuanxi Liu where allocating 1G pages at runtime is
     taking an excessive amount of time for large amounts of memory.  Further
     testing allocating huge pages that the cost is linear i.e.  if allocating
     1G pages in batches of 10 then the time to allocate nr_hugepages from
     10->20->30->etc increases linearly even though 10 pages are allocated at
     each step.  Profiles indicated that much of the time is spent checking the
     validity within already existing huge pages and then attempting a
     migration that fails after isolating the range, draining pages and a whole
     lot of other useless work.
     
     Commit eb14d4eefdc4 ("mm,page_alloc: drop unnecessary checks from
     pfn_range_valid_contig") removed two checks, one which ignored huge pages
     for contiguous allocations as huge pages can sometimes migrate.  While
     there may be value on migrating a 2M page to satisfy a 1G allocation, it's
     potentially expensive if the 1G allocation fails and it's pointless to try
     moving a 1G page for a new 1G allocation or scan the tail pages for valid
     PFNs.
     
     Reintroduce the PageHuge check and assume any contiguous region with
     hugetlbfs pages is unsuitable for a new 1G allocation.

...

-- 
Cheers

David


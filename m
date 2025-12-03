Return-Path: <kvm+bounces-65244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 676F2CA1885
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 21:15:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BBC0230184FE
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 20:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187E930F552;
	Wed,  3 Dec 2025 20:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7/fiz9Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9ED3081DF;
	Wed,  3 Dec 2025 20:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764792893; cv=none; b=daoZw+yd4gRZmfrUWN/lRoL4KMxgHCFnsMt4QQV0LCKS5y1gjEPs9lWdaMCAKuOEF9p0cqij/ZFOCI6RhnSitAdo7gZm8lq8QoohqoK85FLMhJBMGRHxA2y3Zsq1fKQ1M+mNOYii3m8CADuDJBIc0JqEG6emcOnfjlxfT2WVex0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764792893; c=relaxed/simple;
	bh=ht+vh6+16UuYep6rtIc4a8JSt43bJeCIlAY9XU94BFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I+Ypi2T3eLIvJci9JPi2USKKSdQUWd9UOafXGMSpRs7t7B3a9cmtNGO10mK2+AcunZx3Fpz9cGgWp+/mKL19NrrqBHkjS7vMQf/Jfz0hNn+5hrsiuJWMJqAZgh5uZjLi1NvriuI3IGTW+rbrETH6rUaeub4M3MBOtaYXIoiIGv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J7/fiz9Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE524C4CEF5;
	Wed,  3 Dec 2025 20:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764792892;
	bh=ht+vh6+16UuYep6rtIc4a8JSt43bJeCIlAY9XU94BFI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J7/fiz9ZbIVzEhO5rTaQLWb1YLUXwZm8iuwrVBWsiVJO091ky6wPDHIDmf3vhDhSe
	 7nltTdMnjK3vfRWGEf69s+AO+6teNjsFIXRvRXsV0r2RynJbKuidFHFHcX1mInP5i2
	 NClqLjj2TViWfJQPnOpmYAp3MQBiZBiMUZlADmG3F8JUYWZysF0I3OZefLaG2V593e
	 gKUoQhQ4oMDJ4QEx0jC0A/2a5Khx52uJGOT68ZK16ImcGsAtoxj0z28oQAH7fvp3fF
	 kblhubcsJQPGoMRy5QYBz20KqMoAyP93OUKeVSYKXDLP9AYrtGf9T31sP4nDx59/cS
	 7BlmKSVZ1Z9Kw==
Message-ID: <f6b159c1-e07c-489e-ab9b-4d77551877f0@kernel.org>
Date: Wed, 3 Dec 2025 21:14:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
To: Gregory Price <gourry@gourry.net>
Cc: Frank van der Linden <fvdl@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
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
 <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>
 <aTCZEcJqcgGv8Zir@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aTCZEcJqcgGv8Zir@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 21:09, Gregory Price wrote:
> On Wed, Dec 03, 2025 at 08:43:29PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/3/25 19:01, Frank van der Linden wrote:
>>>
>>> The PageHuge() check seems a bit out of place there, if you just
>>> removed it altogether you'd get the same results, right? The isolation
>>> code will deal with it. But sure, it does potentially avoid doing some
>>> unnecessary work.
>>
>> commit 4d73ba5fa710fe7d432e0b271e6fecd252aef66e
>> Author: Mel Gorman <mgorman@techsingularity.net>
>> Date:   Fri Apr 14 15:14:29 2023 +0100
>>
>>      mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages
>>      A bug was reported by Yuanxi Liu where allocating 1G pages at runtime is
>>      taking an excessive amount of time for large amounts of memory.  Further
>>      testing allocating huge pages that the cost is linear i.e.  if allocating
>>      1G pages in batches of 10 then the time to allocate nr_hugepages from
>>      10->20->30->etc increases linearly even though 10 pages are allocated at
>>      each step.  Profiles indicated that much of the time is spent checking the
>>      validity within already existing huge pages and then attempting a
>>      migration that fails after isolating the range, draining pages and a whole
>>      lot of other useless work.
>>      Commit eb14d4eefdc4 ("mm,page_alloc: drop unnecessary checks from
>>      pfn_range_valid_contig") removed two checks, one which ignored huge pages
>>      for contiguous allocations as huge pages can sometimes migrate.  While
>>      there may be value on migrating a 2M page to satisfy a 1G allocation, it's
>>      potentially expensive if the 1G allocation fails and it's pointless to try
>>      moving a 1G page for a new 1G allocation or scan the tail pages for valid
>>      PFNs.
>>      Reintroduce the PageHuge check and assume any contiguous region with
>>      hugetlbfs pages is unsuitable for a new 1G allocation.
>>
> 
> Worth noting that because this check really only applies to gigantic
> page *reservation* (not faulting), this isn't necessarily incurred in a
> time critical path.  So, maybe i'm biased here, the reliability increase
> feels like a win even if the operation can take a very long time under
> memory pressure scenarios (which seems like an outliar anyway).

Not sure I understand correctly. I think the fix from Mel was the right 
thing to do.

It does not make sense to try migrating a 1GB page when allocating a 1GB 
page. Ever.

-- 
Cheers

David


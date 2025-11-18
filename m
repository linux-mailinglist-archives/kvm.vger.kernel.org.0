Return-Path: <kvm+bounces-63526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0507BC68676
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 938D32A88B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE36329C60;
	Tue, 18 Nov 2025 08:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mKRfFgxF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072B2304BAF;
	Tue, 18 Nov 2025 08:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763456372; cv=none; b=SMjWJ33bsG0lhHchoEWbQ0RmZIsnvsTFdLLqcbTvG20TZ+/w73kWR8IT9i/83LjXp8TGpJ9fbsCqlsEWuW+iMdEPIbJkJu02v97MuuCmSL/UOut97A9kGaKJRXQ7h9cNs1C1Gw+H2UTPCaNLvr61uJhNAT9Akr7dxY+d2MFrGDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763456372; c=relaxed/simple;
	bh=txFvhR2GSvG/fSic/DnF957pN+uvPclb/rdd8YhTQ+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OpJ7CXnmqkb6ZhLywFTzvDXo1pZAScb5UGMjT7I8bV1uwSWLmzRxuBFSWgK7ZdrVQuNy+rGV7LL49MM+wIRsbXpN3sTteQCqn5XkGbti9oIkDbzoNauCOJvJ2gDcXgZDpSCiK+rDtqUFrqmrw2bTm8WadhUaclsUK5+KhJODGF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mKRfFgxF; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763456370; x=1794992370;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=txFvhR2GSvG/fSic/DnF957pN+uvPclb/rdd8YhTQ+Y=;
  b=mKRfFgxF1nAQH6Fs+AMMHOQXSzqsUy1I+XfuY6lJ0qzR2TcXJQhPIPPc
   qi7ZMP3mZ+9jmLB2ZJbg0ukimo6qjYN7HBPtH/6vWOPL7sQkgXWmClQ+L
   ZVecfsg3AnPAt5wrWsB6GudniRwbe4jOQj8Vt2yQ4EwjIfCKM5Ax9PT22
   m3EzDm9ezbK/TQHvDNSkp5+g38l41vSqRM7g/5LVFptrey/pThQM3E6LE
   Cbfg6IJFql/8aKFcy698irWrzZSP5dNoHFyYu9V+27d/RDJjAPQUlbyEh
   yy3zbrTzAyZm7KaXL56wYRzEK8HEo84HCBAQBjiC05PYrzST0fuBS80WI
   A==;
X-CSE-ConnectionGUID: iDy3DWmVTpORhff4sg63mQ==
X-CSE-MsgGUID: JicMchiTQ6W8Z8SEwqg7gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="69340913"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="69340913"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 00:59:28 -0800
X-CSE-ConnectionGUID: Yy5PW6EPRBS3albwIXsngQ==
X-CSE-MsgGUID: j0DyO1GfR9+T/dNgHLpbKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="221365795"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 00:59:22 -0800
Message-ID: <c0b086cc-3ae3-47ed-8d6f-7f7abf488f9f@linux.intel.com>
Date: Tue, 18 Nov 2025 16:59:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
To: Yan Zhao <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>
Cc: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
 <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "michael.roth@amd.com" <michael.roth@amd.com>,
 "Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
 "pgonda@google.com" <pgonda@google.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094358.4607-1-yan.y.zhao@intel.com>
 <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
 <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
 <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
 <aRbHtnMcoqM1gmL9@yzhao56-desk.sh.intel.com>
 <f2fb7c2ed74f37fdf8ce69f593e9436acbdd93ee.camel@intel.com>
 <aRwSkc10XQqY8RfE@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aRwSkc10XQqY8RfE@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/18/2025 2:30 PM, Yan Zhao wrote:
[...]
>>>> Something like below:
>>>>
>>>> @@ -1558,7 +1558,9 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct
>>>> tdp_iter *iter,
>>>>   static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>>>>                                           struct kvm_mmu_page *root,
>>>>                                           gfn_t start, gfn_t end,
>>>> -                                        int target_level, bool shared)
>>>> +                                        int target_level, bool shared,
>>>> +                                        bool only_cross_boundary,
>>>> +                                        bool *split)
>>>>   {
>>>>          struct kvm_mmu_page *sp = NULL;
>>>>          struct tdp_iter iter;
>>>> @@ -1584,6 +1586,9 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>>>>                  if (!is_shadow_present_pte(iter.old_spte) ||
>>>> !is_large_pte(iter.old_spte))
>>>>                          continue;
>>>>   
>>>> +               if (only_cross_boundary && !iter_cross_boundary(&iter, start,
>>>> end))
>>>> +                       continue;
>>>> +
>>>>                  if (!sp) {
>>>>                          rcu_read_unlock();
>>>>   
>>>> @@ -1618,6 +1623,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>>>>                          goto retry;
>>>>   
>>>>                  sp = NULL;
>>>> +               *split = true;
>>>>          }
>>>>   
>>>>          rcu_read_unlock();
>>> This looks more reasonable for tdp_mmu_split_huge_pages_root();
>>>
>>> Given that splitting only adds a new page to the paging structure (unlike page
>>> merging), I currently can't think of any current use cases that would be broken
>>> by the lack of TLB flush before tdp_mmu_iter_cond_resched() releases the
>>> mmu_lock.
>>>
>>> This is because:
>>> 1) if the split is triggered in a fault path, the hardware shouldn't have cached
>>>     the old huge translation.
>>> 2) if the split is triggered in a zap or convert path,
>>>     - there shouldn't be concurrent faults on the range due to the protection of
>>>       mmu_invalidate_range*.
>>>     - for concurrent splits on the same range, though the other vCPUs may
>>>       temporally see stale huge TLB entries after they believe they have
>>>       performed a split, they will be kicked off to flush the cache soon after
>>>       tdp_mmu_split_huge_pages_root() returns in the first vCPU/host thread.
>>>       This should be acceptable since I don't see any special guest needs that
>>>       rely on pure splits.
>> Perhaps we should just go straight to the point:
>>
>>    What does "hugepage split" do, and what's the consequence of not flushing TLB.
>>
>> Per make_small_spte(), the new child PTEs will carry all bits of hugepage PTE
>> except they clear the 'hugepage bit (obviously)', and set the 'X' bit for NX
>> hugepage thing.
>>
>> That means if we leave the stale hugepage TLB, the CPU is still able to find the
>> correct PFN and AFAICT there shouldn't be any other problem here.
The comments in tdp_mmu_split_huge_page() echo this.

     /*
      * Replace the huge spte with a pointer to the populated lower level
      * page table. Since we are making this change without a TLB flush vCPUs
      * will see a mix of the split mappings and the original huge mapping,
      * depending on what's currently in their TLB. This is fine from a
      * correctness standpoint since the translation will be the same either
      * way.
      */

>>    For any fault
>> due to the stale hugepage TLB missing the 'X' permission, AFAICT KVM will just
>> treat this as a spurious fault, which isn't nice but should have no harm.
> Right, that isn't nice, though no harm.
According to SDM "Operations that Invalidate Cached Mappings":
The following operations invalidate cached mappings as indicated:
   - ...
   - An EPT violation invalidates any guest-physical mappings (associated with
     the current EPTRTA) that would be used to translate the guest-physical
     address that caused the EPT violation. If that guest-physical address was
     the translation of a linear address, the EPT violation also invalidates any
     combined mappings for that linear address associated with the current PCID,
     the current VPID and the current EPTRTA.
   - ...

If other CPUs have the stale hugepage TLB entry, there may be one spurious
fault each.
Agree that it's not nice, but no harm.


>
> Besides, I'm thinking of a scenario which is not currently existing though.
>
>      CPU 0                                 CPU 1
> a1. split pages
> a2. write protect pages
>                                         b1. split pages
>                                         b2. write protect pages
>                                         b3. start dirty page tracking
> a3. flush TLB
> a4. start dirty page tracking
>
>
> If CPU 1 does not flush TLB after b2 (e.g., due to it finds the pages have been
> split and write protected by a1&a2), it will miss some dirty pages.
>
> Currently CPU 1 always flush TLB before b3 unconditionally, so there's no
> problem.

Yes, for this write protection case, the TLB should be flushed.
And currently, all (indirect) callers of tdp_mmu_split_huge_pages_root() do the
TLB flush unconditionally.

For the TDX case, the TLB flush is done via the hook of secure EPT hugepage
split.

It seems that the callers can decide whether the TLB flush is needed or not
based on the following actions after hugepage split, may be with the info of
whether split actually occurs or not.


>
>>> So I tend to agree with your suggestion though the implementation in this patch
>>> is safer.
>> I am perhaps still missing something, as I am still trying to precisely
>> understand in what cases you want to flush TLB when splitting hugepage.
>>
>> I kinda tend to think you eventually want to flush TLB because eventually you
>> want to _ZAP_.  But needing to flush due to zap and needing to flush due to
>> split is kinda different I think.
> Though I currently couldn't find any use cases that depend on split alone, e.g.
> if there's any feature requiring the pages must be 4KB without any additional
> permission changes, I just wanted to make the code safer in case I missed any
> edge cases.
>
> We surely don't want the window for CPUs to see huge pages and small pages lasts
> long.
>
> Flushing TLB before releasing the mmu_lock allows other threads operating on the
> same range to see updated translations timely.



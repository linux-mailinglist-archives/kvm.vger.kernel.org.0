Return-Path: <kvm+bounces-36219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 376D1A18B61
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 06:38:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D47847A515F
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 05:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A11653;
	Wed, 22 Jan 2025 05:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nt7hdfrx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26971990CD
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 05:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737524302; cv=none; b=r9FQGmmIp2j5t5w3tSps7fvP9e7PCahM9kV75JqSslUpE5cja9BVBbGSeaHyjTaNczAwbvcS6yEiPj19eCw6jtHVEM9ZtvWJbHrtqCRsFgSQ7d85UPDiDHACCKzFopxJmBoPLZIeVGQzojRcose3z9aG73K104UgqG9bSc+iUPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737524302; c=relaxed/simple;
	bh=hCFELfX33+SpB61aujnTEhoiWRqMisYxArlO5OLg5PQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O604MkloWnrdmsLV5/Rvzs73+GCkJ/CuYaTYjW4A7JZZ/B7S8nVkEXdAdPOnKGlCiTc3yzBlkN1qlEGOkoHP3yrnQ1fUYvzkMp/NvYH9nmktWJYk6RzqRHwU2B9NaWGnTugtKx/2+yhdmzfGgDBby6I53n74PWrNbggIIwEEF6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nt7hdfrx; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737524301; x=1769060301;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hCFELfX33+SpB61aujnTEhoiWRqMisYxArlO5OLg5PQ=;
  b=nt7hdfrxm5JmGLmvplKd2vlVyUwJ5oCBLEjwWEIcCnUZLYSu4zPQKnSE
   IJq2L1ldDnZl4OFcXZVrQ01rpiohga2mx/uZ/38NkK6O03OvUlowGf69w
   Gh4JyFEUDNLomU+JoHmW8DYgWcQiTnoGFkcq+6/dApsZHhbszrZMi/4oS
   1xOj33dEmhapq8tjfG+TUVLjUtRYiZkehcpkQyFpaO9MOLROvqoUfODgj
   XSwEqwysStRi5ol/8RwjPq3YQn8UEuOkmUm+5vDOx0S+jGz44BlqNKQ1E
   HBvgOq1sgZZ3y0g6h8VXjiunHUuyE9wJ4BiQEZrOYhDwJGt6jg2Z0y5mC
   w==;
X-CSE-ConnectionGUID: JOrPHBd6TzaXG4NfLkovLg==
X-CSE-MsgGUID: qJ9qguGwSIyPG41fahY3pg==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="41640260"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="41640260"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 21:38:20 -0800
X-CSE-ConnectionGUID: JAzO+VjjTgiaYXv7+YRR9g==
X-CSE-MsgGUID: F1iyDj4KTDSKYmJGyxmekA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111643454"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 21:38:16 -0800
Message-ID: <9d4df308-2dfd-4fa0-a19b-ccbbce13a2fc@intel.com>
Date: Wed, 22 Jan 2025 13:38:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Chenyi Qiang <chenyi.qiang@intel.com>, Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
 <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
 <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com> <Z46GIsAcXJTPQ8yN@x1n>
 <7e60d2d8-9ee9-4e97-8a45-bd35a3b7b2a2@redhat.com> <Z46W7Ltk-CWjmCEj@x1n>
 <8e144c26-b1f4-4156-b959-93dc19ab2984@intel.com> <Z4_MvGSq2B4zptGB@x1n>
 <c5148428-9ebe-4659-953c-6c9d0eea1051@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <c5148428-9ebe-4659-953c-6c9d0eea1051@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/22/2025 11:28 AM, Chenyi Qiang wrote:
> 
> 
> On 1/22/2025 12:35 AM, Peter Xu wrote:
>> On Tue, Jan 21, 2025 at 09:35:26AM +0800, Chenyi Qiang wrote:
>>>
>>>
>>> On 1/21/2025 2:33 AM, Peter Xu wrote:
>>>> On Mon, Jan 20, 2025 at 06:54:14PM +0100, David Hildenbrand wrote:
>>>>> On 20.01.25 18:21, Peter Xu wrote:
>>>>>> On Mon, Jan 20, 2025 at 11:48:39AM +0100, David Hildenbrand wrote:
>>>>>>> Sorry, I was traveling end of last week. I wrote a mail on the train and
>>>>>>> apparently it was swallowed somehow ...
>>>>>>>
>>>>>>>>> Not sure that's the right place. Isn't it the (cc) machine that controls
>>>>>>>>> the state?
>>>>>>>>
>>>>>>>> KVM does, via MemoryRegion->RAMBlock->guest_memfd.
>>>>>>>
>>>>>>> Right; I consider KVM part of the machine.
>>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>> It's not really the memory backend, that's just the memory provider.
>>>>>>>>
>>>>>>>> Sorry but is not "providing memory" the purpose of "memory backend"? :)
>>>>>>>
>>>>>>> Hehe, what I wanted to say is that a memory backend is just something to
>>>>>>> create a RAMBlock. There are different ways to create a RAMBlock, even
>>>>>>> guest_memfd ones.
>>>>>>>
>>>>>>> guest_memfd is stored per RAMBlock. I assume the state should be stored per
>>>>>>> RAMBlock as well, maybe as part of a "guest_memfd state" thing.
>>>>>>>
>>>>>>> Now, the question is, who is the manager?
>>>>>>>
>>>>>>> 1) The machine. KVM requests the machine to perform the transition, and the
>>>>>>> machine takes care of updating the guest_memfd state and notifying any
>>>>>>> listeners.
>>>>>>>
>>>>>>> 2) The RAMBlock. Then we need some other Object to trigger that. Maybe
>>>>>>> RAMBlock would have to become an object, or we allocate separate objects.
>>>>>>>
>>>>>>> I'm leaning towards 1), but I might be missing something.
>>>>>>
>>>>>> A pure question: how do we process the bios gmemfds?  I assume they're
>>>>>> shared when VM starts if QEMU needs to load the bios into it, but are they
>>>>>> always shared, or can they be converted to private later?
>>>>>
>>>>> You're probably looking for memory_region_init_ram_guest_memfd().
>>>>
>>>> Yes, but I didn't see whether such gmemfd needs conversions there.  I saw
>>>> an answer though from Chenyi in another email:
>>>>
>>>> https://lore.kernel.org/all/fc7194ee-ed21-4f6b-bf87-147a47f5f074@intel.com/
>>>>
>>>> So I suppose the BIOS region must support private / share conversions too,
>>>> just like the rest part.
>>>
>>> Yes, the BIOS region can support conversion as well. I think guest_memfd
>>> backed memory regions all follow the same sequence during setup time:
>>>
>>> guest_memfd is shared when the guest_memfd fd is created by
>>> kvm_create_guest_memfd() in ram_block_add(), But it will sooner be
>>> converted to private just after kvm_set_user_memory_region() in
>>> kvm_set_phys_mem(). So at the boot time of cc VM, the default attribute
>>> is private. During runtime, the vBIOS can also do the conversion if it
>>> wants.
>>
>> I see.
>>
>>>
>>>>
>>>> Though in that case, I'm not 100% sure whether that could also be done by
>>>> reusing the major guest memfd with some specific offset regions.
>>>
>>> Not sure if I understand you clearly. guest_memfd is per-Ramblock. It
>>> will have its own slot. So the vBIOS can use its own guest_memfd to get
>>> the specific offset regions.
>>
>> Sorry to be confusing, please feel free to ignore my previous comment.
>> That came from a very limited mindset that maybe one confidential VM should
>> only have one gmemfd..
>>
>> Now I see it looks like it's by design open to multiple gmemfds for each
>> VM, then it's definitely ok that bios has its own.
>>
>> Do you know why the bios needs to be convertable?  I wonder whether the VM
>> can copy it over to a private region and do whatever it wants, e.g.  attest
>> the bios being valid.  However this is also more of a pure question.. and
>> it can be offtopic to this series, so feel free to ignore.
> 
> AFAIK, the vBIOS won't do conversion after it is set as private at the
> beginning. But in theory, the VM can do the conversion at runtime with
> current implementation. As for why make the vBIOS convertable, I'm also
> uncertain about it. Maybe convenient for managing the private/shared
> status by guest_memfd as it's also converted once at the beginning.

The reason is just that we are too lazy to implement a variant of guest 
memfd for vBIOS that is disallowed to be converted from private to shared.

>>
>> Thanks,
>>
> 



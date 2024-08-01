Return-Path: <kvm+bounces-22932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D09944951
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 12:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CACA6282127
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 10:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237E4183CD0;
	Thu,  1 Aug 2024 10:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="uE9BADz4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320D64503A;
	Thu,  1 Aug 2024 10:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722508231; cv=none; b=a0Tnzgdw5TMb8qkG/emuPZHQatDga5VxpRqFHNPsGO3pGAeDQIiYEdbq38bknH5Pbe/F5jruLOfaanhwe5sbq9b+I9s9vr1iK3nCmiKfwWG6CcXIiBT4SU4m4B0OiouuWh+B13LKvnglYvMQt+X2hAJ1f/q9NhDhFFKcOWXu5M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722508231; c=relaxed/simple;
	bh=TeXgvZtmVSsWOyWvwGwQNHpvFHcawwpfpA+OnYmmyEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZVKqfUonXyIT4AfOjqVTa6+lb9yI7bgGu9cUviihJGaTXsTR8yJgY8DoWvA1uxtGZUppVTBQaLGp7GM8FqmzMswccBvBJjSj9KazxakiCb14Yo3/O9X5+ztMLz4tiixTvi/GTLPgLzzXG4vXBF0HkKiVXqyUiIZ/duimB8rf6JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=uE9BADz4; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1722508229; x=1754044229;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OVVbgg3i7ObhzDXrRl+WHtJky+rbfnkhgnMTtTNFVvM=;
  b=uE9BADz43zxPo0mxslQCLpPSug259uDOe225dLLHnh8VPUOJHT09NVIF
   b55yT2g3Ss5cFmFNFBt34T3k5G/HGPPyrgjyexsCaA2PdyrjCTqPXBNvi
   4B1nprGZN62Iar9EsVF6k4ZN5u84KDjl0geThyPoMMyUXy6PYyE52v1Gd
   g=;
X-IronPort-AV: E=Sophos;i="6.09,254,1716249600"; 
   d="scan'208";a="418659193"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2024 10:30:26 +0000
Received: from EX19MTAUEA001.ant.amazon.com [10.0.0.204:41573]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.0.142:2525] with esmtp (Farcaster)
 id af2fe4b0-83dd-4544-a4ed-27a0ca73effc; Thu, 1 Aug 2024 10:30:25 +0000 (UTC)
X-Farcaster-Flow-ID: af2fe4b0-83dd-4544-a4ed-27a0ca73effc
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 1 Aug 2024 10:30:25 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 1 Aug 2024 10:30:25 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.252.135.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Thu, 1 Aug 2024 10:30:22 +0000
Message-ID: <e8663138-b75b-472d-8dcc-589b2ef91e53@amazon.co.uk>
Date: Thu, 1 Aug 2024 11:30:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 8/8] kvm: gmem: Allow restricted userspace mappings
To: David Hildenbrand <david@redhat.com>, <seanjc@google.com>, Fuad Tabba
	<tabba@google.com>
CC: <pbonzini@redhat.com>, <akpm@linux-foundation.org>, <dwmw@amazon.co.uk>,
	<rppt@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<willy@infradead.org>, <graf@amazon.com>, <derekmn@amazon.com>,
	<kalyazin@amazon.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <dmatlack@google.com>, <chao.p.peng@linux.intel.com>,
	<xmarcalx@amazon.co.uk>, James Gowans <jgowans@amazon.com>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <20240709132041.3625501-9-roypat@amazon.co.uk>
 <CA+EHjTynVpsqsudSVRgOBdNSP_XjdgKQkY_LwdqvPkpJAnAYKg@mail.gmail.com>
 <47ce1b10-e031-4ac1-b88f-9d4194533745@redhat.com>
 <f7106744-2add-4346-b3b6-49239de34b7f@amazon.co.uk>
 <f21d8157-a5e9-4acb-93fc-d040e9b585c8@redhat.com>
 <e26ec0bb-3c20-4732-a09b-83b6b6a6419a@amazon.co.uk>
 <ab528aa0-d4a5-4661-9715-43eb1681cfef@redhat.com>
From: Patrick Roy <roypat@amazon.co.uk>
Content-Language: en-US
Autocrypt: addr=roypat@amazon.co.uk; keydata=
 xjMEY0UgYhYJKwYBBAHaRw8BAQdA7lj+ADr5b96qBcdINFVJSOg8RGtKthL5x77F2ABMh4PN
 NVBhdHJpY2sgUm95IChHaXRodWIga2V5IGFtYXpvbikgPHJveXBhdEBhbWF6b24uY28udWs+
 wpMEExYKADsWIQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbAwULCQgHAgIiAgYVCgkI
 CwIEFgIDAQIeBwIXgAAKCRBVg4tqeAbEAmQKAQC1jMl/KT9pQHEdALF7SA1iJ9tpA5ppl1J9
 AOIP7Nr9SwD/fvIWkq0QDnq69eK7HqW14CA7AToCF6NBqZ8r7ksi+QLOOARjRSBiEgorBgEE
 AZdVAQUBAQdAqoMhGmiXJ3DMGeXrlaDA+v/aF/ah7ARbFV4ukHyz+CkDAQgHwngEGBYKACAW
 IQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbDAAKCRBVg4tqeAbEAtjHAQDkh5jZRIsZ
 7JMNkPMSCd5PuSy0/Gdx8LGgsxxPMZwePgEAn5Tnh4fVbf00esnoK588bYQgJBioXtuXhtom
 8hlxFQM=
In-Reply-To: <ab528aa0-d4a5-4661-9715-43eb1681cfef@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2024-07-30 at 11:15 +0100, David Hildenbrand wrote:
>>> Hi,
>>>
>>> sorry for the late reply. Yes, you could have joined .... too late.
>>
>> No worries, I did end up joining to listen in to y'all's discussion
>> anyway :)
> 
> Sorry for the late reply :(

No worries :)

>>
>>> There will be a summary posted soon. So far the agreement is that we're
>>> planning on allowing shared memory as part guest_memfd, and will allow
>>> that to get mapped and pinned. Private memory is not going to get mapped
>>> and pinned.
>>>
>>> If we have to disallow pinning of shared memory on top for some use
>>> cases (i.e., no directmap), I assume that could be added.
>>>
>>>>
>>>>> Note that just from staring at this commit, I don't understand the
>>>>> motivation *why* we would want to do that.
>>>>
>>>> Fair - I admittedly didn't get into that as much as I probably should
>>>> have. In our usecase, we do not have anything that pKVM would (I think)
>>>> call "guest-private" memory. I think our memory can be better described
>>>> as guest-owned, but always shared with the VMM (e.g. userspace), but
>>>> ideally never shared with the host kernel. This model lets us do a lot
>>>> of simplifying assumptions: Things like I/O can be handled in userspace
>>>> without the guest explicitly sharing I/O buffers (which is not exactly
>>>> what we would want long-term anyway, as sharing in the guest_memfd
>>>> context means sharing with the host kernel), we can easily do VM
>>>> snapshotting without needing things like TDX's TDH.EXPORT.MEM APIs, etc.
>>>
>>> Okay, so essentially you would want to use guest_memfd to only contain
>>> shard memory and disallow any pinning like for secretmem.
>>
>> Yeah, this is pretty much what I thought we wanted before listening in
>> on Wednesday.
>>
>> I've actually be thinking about this some more since then though. With
>> hugepages, if the VM is backed by, say, 2M pages, our on-demand direct
>> map insertion approach runs into the same problem that CoCo VMs have
>> when they're backed by hugepages: How to deal with the guest only
>> sharing a 4K range in a hugepage? If we want to restore the direct map
>> for e.g. the page containing kvm-clock data, then we can't simply go
>> ahead and restore the direct map for the entire 2M page, because there
>> very well might be stuff in the other 511 small guest pages that we
>> really do not want in the direct map. And we can't even take the
> 
> Right, you'd only want to restore the direct map for a fragment. Or
> dynamically map that fragment using kmap where required (as raised by
> Vlastimil).

Can the kmap approach work if the memory is supposed to be GUP-able?

>> approach of letting the guest deal with the problem, because here
>> "sharing" is driven by the host, not the guest, so the guest cannot
>> possibly know that it maybe should avoid putting stuff it doesn't want
>> shared into those remaining 511 pages! To me that sounds a lot like the
>> whole "breaking down huge folios to allow GUP to only some parts of it"
>> thing mentioned on Wednesday.
> 
> Yes. While it would be one logical huge page, it would be exposed to the
> remainder of the kernel as 512 individual pages.
> 
>>
>> Now, if we instead treat "guest memory without direct map entries" as
>> "private", and "guest memory with direct map entries" as "shared", then
>> the above will be solved by whatever mechanism allows gupping/mapping of
>> only the "shared" parts of huge folios, IIUC. The fact that GUP is then
>> also allowed for the "shared" parts is not actually a problem for us -
>> we went down the route of disabling GUP altogether here because based on
>> [1] it sounded like GUP for anything gmem related would never happen.
> 
> Right. Might there also be a case for removing the directmap for shared
> memory or is that not really a requirement so far?

No, not really - we would only mark as "shared" memory that _needs_ to
be in the direct map for functional reasons (e.g. MMIO instruction
emulation, etc.).

>> But after something is re-inserted into the direct map, we don't very
>> much care if it can be GUP-ed or not. In fact, allowing GUP for the
>> shared parts probably makes some things easier for us, as we can then do
>> I/O without bounce buffers by just in-place converting I/O-buffers to
>> shared, and then treating that shared slice of guest_memfd the same way
>> we treat traditional guest memory today.
> 
> Yes.
> 
>> In a very far-off future, we'd
>> like to be able to do I/O without ever reinserting pages into the direct
>> map, but I don't think adopting this private/shared model for gmem would
>> block us from doing that?
> 
> How would that I/O get triggered? GUP would require the directmap.

I was hoping that this "phyr" thing Matthew has been talking about [1]
would allow somehow doing I/O without direct map entries/GUP, but maybe
I am misunderstanding something.

>>
>> Although all of this does hinge on us being able to do the in-place
>> shared/private conversion without any guest involvement. Do you envision
>> that to be possible?
> 
> Who would trigger the conversion and how? I don't see a reason why --
> for your use case -- user space shouldn't be able to trigger conversion
> private <-> shared. At least nothing fundamental comes to mind that
> would prohibit that.

Either KVM itself would trigger the conversions whenever it wants to
access gmem (e.g. each place in this series where there is a
set_direct_map_{invalid,default} it would do a shared/private
conversion), or userspace would do it via some syscall/ioctl (the one
place I can think of right now is I/O, where the VMM receives a virtio
buffer from the guest and converts it from private to shared in-place.
Although I guess 2 syscalls for each I/O operation aren't great
perf-wise, so maybe swiotlb still wins out here?).

I actually see that Fuad just posted an RFC series that implements the
basic shared/private handling [2], so will probably also comment about
this over there after I had a closer look :)

> -- 
> Cheers,
> 
> David / dhildenb

Best, 
Patrick

[1]: https://lore.kernel.org/netdev/Yd0IeK5s%2FE0fuWqn@casper.infradead.org/T/
[2]: https://lore.kernel.org/kvm/20240801090117.3841080-1-tabba@google.com/T/#t


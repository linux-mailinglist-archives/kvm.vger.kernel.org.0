Return-Path: <kvm+bounces-21528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5C492FE04
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31602281C48
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CAC174EF9;
	Fri, 12 Jul 2024 15:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="Tf5p0h0N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE74812B171;
	Fri, 12 Jul 2024 15:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720799956; cv=none; b=iB6omTZRsRq8pEEIM14YYAyjDQn34wyN5dLdqv60UYDG09aEWpJoUPUyhoeTFFBSkyuTKvQDwM5Pe8k1IFbH68tWcxH+H8fmFKobGc/fsKpiExQfqOzoY5D88NiQM2gaOqvdAW20coIsu+lta8X/Z2MNpcPyIhLfqMpSJP4kpvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720799956; c=relaxed/simple;
	bh=1XxPkXT2cZSD8gaND0V1dsa/Ud1ckMXhXBO5kB+gWLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fLV2z51amVlHdgRlKEBvKuGapLtCbR6Fm3kYFlte/xEVcY4DivilGKk/FfHHM90dXISW+yrV8Q7aKKSPDKLoFMiB1FMsASoUvsczsAfxQ+2b53s4Iy9RQB+P5HqDRSzox71GB22/De1F/5wO16YqJKBW3tRv9Lh8bMVhG3yELgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=Tf5p0h0N; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720799955; x=1752335955;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GwKqpMAjyij41rR5tqu84wg1nwS/hoIAR0ee3YtldEI=;
  b=Tf5p0h0Nekm3iMbX/p0qiUmy83IznfXz8jjbLIneGP5S8ReY5OwpzCHY
   l5xFtHDdwACwA42exis0azlrbLMlWyFm65GhfnrNnx9OQREAbIPW2LP6P
   4N0y7R09D8B7JVU6SekBKtwrpXk+hecVx9PeVZf7Pa9P1MTbMgv8uSz+9
   8=;
X-IronPort-AV: E=Sophos;i="6.09,203,1716249600"; 
   d="scan'208";a="666998267"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2024 15:59:11 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.38.20:9937]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.123:2525] with esmtp (Farcaster)
 id 58fbeed2-d56e-4815-89ca-4919342de76b; Fri, 12 Jul 2024 15:59:11 +0000 (UTC)
X-Farcaster-Flow-ID: 58fbeed2-d56e-4815-89ca-4919342de76b
Received: from EX19D003UWB003.ant.amazon.com (10.13.138.116) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 12 Jul 2024 15:59:10 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D003UWB003.ant.amazon.com (10.13.138.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 12 Jul 2024 15:59:10 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Fri, 12 Jul 2024 15:59:06 +0000
Message-ID: <e26ec0bb-3c20-4732-a09b-83b6b6a6419a@amazon.co.uk>
Date: Fri, 12 Jul 2024 16:59:05 +0100
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
In-Reply-To: <f21d8157-a5e9-4acb-93fc-d040e9b585c8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hey,

On Wed, 2024-07-10 at 22:12 +0100, David Hildenbrand wrote:
> On 10.07.24 11:51, Patrick Roy wrote:
>>
>>
>> On 7/9/24 22:13, David Hildenbrand wrote:
>>> On 09.07.24 16:48, Fuad Tabba wrote:
>>>> Hi Patrick,
>>>>
>>>> On Tue, Jul 9, 2024 at 2:21 PM Patrick Roy <roypat@amazon.co.uk> wrote:
>>>>>
>>>>> Allow mapping guest_memfd into userspace. Since AS_INACCESSIBLE is set
>>>>> on the underlying address_space struct, no GUP of guest_memfd will be
>>>>> possible.
>>>>
>>>> This patch allows mapping guest_memfd() unconditionally. Even if it's
>>>> not guppable, there are other reasons why you wouldn't want to allow
>>>> this. Maybe a config flag to gate it? e.g.,
>>>
>>>
>>> As discussed with Jason, maybe not the direction we want to take with
>>> guest_memfd.
>>> If it's private memory, it shall not be mapped. Also not via magic
>>> config options.
>>>
>>> We'll likely discuss some of that in the meeting MM tomorrow I guess
>>> (having both shared and private memory in guest_memfd).
>>
>> Oh, nice. I'm assuming you mean this meeting:
>> https://lore.kernel.org/linux-mm/197a2f19-c71c-fbde-a62a-213dede1f4fd@google.com/T/?
>> Would it be okay if I also attend? I see it also mentions huge pages,
>> which is another thing we are interested in, actually :)
> 
> Hi,
> 
> sorry for the late reply. Yes, you could have joined .... too late.

No worries, I did end up joining to listen in to y'all's discussion
anyway :)

> There will be a summary posted soon. So far the agreement is that we're
> planning on allowing shared memory as part guest_memfd, and will allow
> that to get mapped and pinned. Private memory is not going to get mapped
> and pinned.
> 
> If we have to disallow pinning of shared memory on top for some use
> cases (i.e., no directmap), I assume that could be added.
> 
>>
>>> Note that just from staring at this commit, I don't understand the
>>> motivation *why* we would want to do that.
>>
>> Fair - I admittedly didn't get into that as much as I probably should
>> have. In our usecase, we do not have anything that pKVM would (I think)
>> call "guest-private" memory. I think our memory can be better described
>> as guest-owned, but always shared with the VMM (e.g. userspace), but
>> ideally never shared with the host kernel. This model lets us do a lot
>> of simplifying assumptions: Things like I/O can be handled in userspace
>> without the guest explicitly sharing I/O buffers (which is not exactly
>> what we would want long-term anyway, as sharing in the guest_memfd
>> context means sharing with the host kernel), we can easily do VM
>> snapshotting without needing things like TDX's TDH.EXPORT.MEM APIs, etc.
> 
> Okay, so essentially you would want to use guest_memfd to only contain
> shard memory and disallow any pinning like for secretmem.

Yeah, this is pretty much what I thought we wanted before listening in
on Wednesday.

I've actually be thinking about this some more since then though. With
hugepages, if the VM is backed by, say, 2M pages, our on-demand direct
map insertion approach runs into the same problem that CoCo VMs have
when they're backed by hugepages: How to deal with the guest only
sharing a 4K range in a hugepage? If we want to restore the direct map
for e.g. the page containing kvm-clock data, then we can't simply go
ahead and restore the direct map for the entire 2M page, because there
very well might be stuff in the other 511 small guest pages that we
really do not want in the direct map. And we can't even take the
approach of letting the guest deal with the problem, because here
"sharing" is driven by the host, not the guest, so the guest cannot
possibly know that it maybe should avoid putting stuff it doesn't want
shared into those remaining 511 pages! To me that sounds a lot like the
whole "breaking down huge folios to allow GUP to only some parts of it"
thing mentioned on Wednesday.

Now, if we instead treat "guest memory without direct map entries" as
"private", and "guest memory with direct map entries" as "shared", then
the above will be solved by whatever mechanism allows gupping/mapping of
only the "shared" parts of huge folios, IIUC. The fact that GUP is then
also allowed for the "shared" parts is not actually a problem for us -
we went down the route of disabling GUP altogether here because based on
[1] it sounded like GUP for anything gmem related would never happen.
But after something is re-inserted into the direct map, we don't very
much care if it can be GUP-ed or not. In fact, allowing GUP for the
shared parts probably makes some things easier for us, as we can then do
I/O without bounce buffers by just in-place converting I/O-buffers to
shared, and then treating that shared slice of guest_memfd the same way
we treat traditional guest memory today. In a very far-off future, we'd
like to be able to do I/O without ever reinserting pages into the direct
map, but I don't think adopting this private/shared model for gmem would
block us from doing that?

Although all of this does hinge on us being able to do the in-place
shared/private conversion without any guest involvement. Do you envision
that to be possible?

> If so, I wonder if it wouldn't be better to simply add KVM support to
> consume *real* secretmem memory? IIRC so far there was only demand to
> probably remove the directmap of private memory in guest_memfd, not of
> shared memory.
> -- 
> Cheers,
> 
> David / dhildenb

Best, 
Patrick

[1]: https://lore.kernel.org/all/ZdfoR3nCEP3HTtm1@casper.infradead.org/



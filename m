Return-Path: <kvm+bounces-36342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F40AA1A3A9
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 12:57:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B2C2169E2A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 11:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B7920E33E;
	Thu, 23 Jan 2025 11:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="MA4Rlu3E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4871229B0;
	Thu, 23 Jan 2025 11:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737633455; cv=none; b=JdvG6KkdqQOfNWZTW9XgE3Lvg+Sq+czYQXD8V6+/mZpqtp5eQDjJUXq9WaMHqDxezrCrgquND63b1b6GH/sEQh/CJkP0zebF1tnyT1YlPdDnmKkpTeZFt0Dag2wTwbO35R59Xox6bdKQBkhz9ZKYPhbnrfnts92QW7udFhDV85Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737633455; c=relaxed/simple;
	bh=+u2UYFgqgOSGz04sLrSBDVoAHxdcRHvP6boh889RNws=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EU3X/CWgM7D7Jn7sRZLDimX537xmXuLLs13ixQ+IyI2ClZGMSqZZQBFf/6pj+5hEzHIOZ6o0eK6kQj2ulXgAqLxu/a1qOqdDDO4vYcZWQxHC9aZ7CoUOsTF1Y+iErK3rH7X9pOb9O7uivpkZYHXZwqkZg1p3e/nU53yLICX1Wjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=MA4Rlu3E; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1737633453; x=1769169453;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9P/WI2TxBNhrzdT8yDOgB87cpcW0wU2g0ZhcVkOr4h4=;
  b=MA4Rlu3El5JGADeFzHBxJeeeTs0T220/gft8FT9tXPmhGoGbqcKMzVBW
   GJJnIhNcX7fPhFAuVFzAsJ4/M/S0hfgMBIBW5ChXpL090q0WkPYKIv4/P
   3LsaCNqg7fOOhw7FlvqexwavTpql/1HDCbZl3VG0sSXYUzqQu8tVT1NyV
   M=;
X-IronPort-AV: E=Sophos;i="6.13,228,1732579200"; 
   d="scan'208";a="166394565"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 11:57:30 +0000
Received: from EX19MTAUEC001.ant.amazon.com [10.0.44.209:55325]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.8.105:2525] with esmtp (Farcaster)
 id 85c0e4b1-62e6-4ea9-811e-22b15e9320a9; Thu, 23 Jan 2025 11:57:30 +0000 (UTC)
X-Farcaster-Flow-ID: 85c0e4b1-62e6-4ea9-811e-22b15e9320a9
Received: from EX19MTAUEB002.ant.amazon.com (10.252.135.47) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 23 Jan 2025 11:57:30 +0000
Received: from email-imr-corp-prod-pdx-all-2b-5ec155c2.us-west-2.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.135.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Thu, 23 Jan 2025 11:57:30 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-pdx-all-2b-5ec155c2.us-west-2.amazon.com (Postfix) with ESMTPS id AB40540C9C;
	Thu, 23 Jan 2025 11:57:17 +0000 (UTC)
Message-ID: <ef864674-bbcf-457b-a4e3-fec272fc2d8a@amazon.co.uk>
Date: Thu, 23 Jan 2025 11:57:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/9] KVM: guest_memfd: Add guest_memfd support to
 kvm_(read|/write)_guest_page()
To: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
CC: <kvm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
	<linux-mm@kvack.org>, <pbonzini@redhat.com>, <chenhuacai@kernel.org>,
	<mpe@ellerman.id.au>, <anup@brainfault.org>, <paul.walmsley@sifive.com>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <seanjc@google.com>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <xiaoyao.li@intel.com>, <yilun.xu@intel.com>,
	<chao.p.peng@linux.intel.com>, <jarkko@kernel.org>, <amoorthy@google.com>,
	<dmatlack@google.com>, <yu.c.zhang@linux.intel.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <michael.roth@amd.com>, <wei.w.wang@intel.com>,
	<liam.merwick@oracle.com>, <isaku.yamahata@gmail.com>,
	<kirill.shutemov@linux.intel.com>, <suzuki.poulose@arm.com>,
	<steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <shuah@kernel.org>,
	<hch@infradead.org>, <jgg@nvidia.com>, <rientjes@google.com>,
	<jhubbard@nvidia.com>, <fvdl@google.com>, <hughd@google.com>,
	<jthoughton@google.com>
References: <20250122152738.1173160-1-tabba@google.com>
 <20250122152738.1173160-3-tabba@google.com>
 <e6ea48d2-959f-4fbb-a170-0beaaf37f867@redhat.com>
 <CA+EHjTxNEoQ3MtZPi603=366vxt=SmBwetS4mFkvTK2r6u=UHw@mail.gmail.com>
 <82d8d3a3-6f06-4904-9d94-6f92bba89dbc@redhat.com>
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
In-Reply-To: <82d8d3a3-6f06-4904-9d94-6f92bba89dbc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit



On Thu, 2025-01-23 at 11:39 +0000, David Hildenbrand wrote:
> On 23.01.25 10:48, Fuad Tabba wrote:
>> On Wed, 22 Jan 2025 at 22:10, David Hildenbrand <david@redhat.com> wrote:
>>>
>>> On 22.01.25 16:27, Fuad Tabba wrote:
>>>> Make kvm_(read|/write)_guest_page() capable of accessing guest
>>>> memory for slots that don't have a userspace address, but only if
>>>> the memory is mappable, which also indicates that it is
>>>> accessible by the host.
>>>
>>> Interesting. So far my assumption was that, for shared memory, user
>>> space would simply mmap() guest_memdd and pass it as userspace address
>>> to the same memslot that has this guest_memfd for private memory.
>>>
>>> Wouldn't that be easier in the first shot? (IOW, not require this patch
>>> with the cost of faulting the shared page into the page table on access)
>>
> 
> In light of:
> 
> https://lkml.kernel.org/r/20250117190938.93793-4-imbrenda@linux.ibm.com
> 
> there can, in theory, be memslots that start at address 0 and have a
> "valid" mapping. This case is done from the kernel (and on special s390x
> hardware), though, so it does not apply here at all so far.
> 
> In practice, getting address 0 as a valid address is unlikely, because
> the default:
> 
> $ sysctl  vm.mmap_min_addr
> vm.mmap_min_addr = 65536
> 
> usually prohibits it for good reason.
> 
>> This has to do more with the ABI I had for pkvm and shared memory
>> implementations, in which you don't need to specify the userspace
>> address for memory in a guestmem memslot. The issue is there is no
>> obvious address to map it to. This would be the case in kvm:arm64 for
>> tracking paravirtualized time, which the userspace doesn't necessarily
>> need to interact with, but kvm does.
> 
> So I understand correctly: userspace wouldn't have to mmap it because it
> is not interested in accessing it, but there is nothing speaking against
> mmaping it, at least in the first shot.
> 
> I assume it would not be a private memslot (so far, my understanding is
> that internal memslots never have a guest_memfd attached).
> kvm_gmem_create() is only called via KVM_CREATE_GUEST_MEMFD, to be set
> on user-created memslots.
> 
>>
>> That said, we could always have a userspace address dedicated to
>> mapping shared locations, and use that address when the necessity
>> arises. Or we could always require that memslots have a userspace
>> address, even if not used. I don't really have a strong preference.
> 
> So, the simpler version where user space would simply mmap guest_memfd
> to provide the address via userspace_addr would at least work for the
> use case of paravirtualized time?

fwiw, I'm currently prototyping something like this for x86 (although
not by putting the gmem address into userspace_addr, but by adding a new
field to memslots, so that memory attributes continue working), based on
what we talked about at the last guest_memfd sync meeting (the whole
"how to get MMIO emulation working for non-CoCo VMs in guest_memfd"
story). So I guess if we're going down this route for x86, maybe it
makes sense to do the same on ARM, for consistency?

> It would get rid of the immediate need for this patch and patch #4 to
> get it flying.
> 
> 
> One interesting question is: when would you want shared memory in
> guest_memfd and *not* provide it as part of the same memslot. 

In my testing of non-CoCo gmem VMs on ARM, I've been able to get quite
far without giving KVM a way to internally access shared parts of gmem - 
it's why I was probing Fuad for this simplified series, because
KVM_SW_PROTECTED_VM + mmap (for loading guest kernel) is enough to get a
working non-CoCo VM on ARM (although I admittedly never looked at clocks
inside the guest - maybe that's one thing that breaks if KVM can't
access gmem. How to guest and host agree on the guest memory range
used to exchange paravirtual timekeeping information? Could that exchange
be intercepted in userspace, and set to shared via memory attributes (e.g.
placed outside gmem)? That's the route I'm going down the paravirtual
time on x86).

> One nice thing about the mmap might be that access go via user-space
> page tables: E.g., __kvm_read_guest_page can just access the memory
> without requiring the folio lock and an additional temporary folio
> reference on every access -- it's handled implicitly via the mapcount.
> 
> (of course, to map the page we still need that once on the fault path)

Doing a direct map access in kvm_{read,write}_guest() and friends will
also get tricky if guest_memfd folios ever don't have direct map
entries. On-demand restoration is painful, both complexity and
performance wise [1], while going through a userspace mapping of
guest_memfd would "just work".

> -- 
> Cheers,
> 
> David / dhildenb
> 


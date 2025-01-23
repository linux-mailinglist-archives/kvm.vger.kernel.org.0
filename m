Return-Path: <kvm+bounces-36360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D981A1A555
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CE993A4477
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 13:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A4E211474;
	Thu, 23 Jan 2025 13:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="k92sKvSG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D6E210F7E;
	Thu, 23 Jan 2025 13:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737640675; cv=none; b=JsV5Idvf/GoOAR7aoL0qsFkSNehf57qLEyL4MdSw8LuNoxECstCZf6cvXZvuH+VQnyjAqFBEuYVw2zJjsqo06vI3Qu3GpxiFsJZZTkKA5cVn3KJ6mRT7X2S3MEfNEJ1lya7vFbxT0nyQYiEmxL+T/V4c0JSiNjRmwpO+y3UumMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737640675; c=relaxed/simple;
	bh=NTRJc1vNNrSsKGxWubxtdZH3pNm7h5AtVOvJDIs0kTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KkRI8PaP2ecS2jAqGihX1ImGypMyYAZA0sRkPeDVlPugaVsK3dmEqiGwvNj/+QuCjD35LunpdNArhLZdcbySWPC3d+Z5gLVGXDyvaCIdzFTFU5z+2Jrb29HZyuydlLxMxdBRemO/7TpnDGjQkX0Bx8KvyXGbm5cOGu68HRHfCbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=k92sKvSG; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1737640675; x=1769176675;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0jTJgN8GxO5zlDk/fEj26ROo4npw/UxB9CSrdOxz2Ic=;
  b=k92sKvSG/duzyA0TEZJ40k4/ZlmezIX91th0LmlO3ai334tY7PIXhTw5
   OZjectrqw5WBr2RB/qTB1elbj6pLS54Nm0Z2Pkv3Jaq8Dul7OWzdW/rqf
   21Ddez51ciSBm2w0r0CZXrrRfVIyG/E+7G8dIZFrN6DlPVcR0Omcy9zmH
   k=;
X-IronPort-AV: E=Sophos;i="6.13,228,1732579200"; 
   d="scan'208";a="59960098"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 13:57:50 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.38.20:10688]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.32.70:2525] with esmtp (Farcaster)
 id ebf92873-7030-453e-8184-9a40e78536fc; Thu, 23 Jan 2025 13:57:48 +0000 (UTC)
X-Farcaster-Flow-ID: ebf92873-7030-453e-8184-9a40e78536fc
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 23 Jan 2025 13:57:48 +0000
Received: from email-imr-corp-prod-iad-all-1a-6ea42a62.us-east-1.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Thu, 23 Jan 2025 13:57:48 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-iad-all-1a-6ea42a62.us-east-1.amazon.com (Postfix) with ESMTPS id 7B86D40497;
	Thu, 23 Jan 2025 13:57:41 +0000 (UTC)
Message-ID: <bc59a2ec-7467-4a4e-8d73-9c4126b1c98b@amazon.co.uk>
Date: Thu, 23 Jan 2025 13:57:40 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/9] KVM: guest_memfd: Add guest_memfd support to
 kvm_(read|/write)_guest_page()
To: Fuad Tabba <tabba@google.com>
CC: David Hildenbrand <david@redhat.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>, <pbonzini@redhat.com>,
	<chenhuacai@kernel.org>, <mpe@ellerman.id.au>, <anup@brainfault.org>,
	<paul.walmsley@sifive.com>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
	<seanjc@google.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<willy@infradead.org>, <akpm@linux-foundation.org>, <xiaoyao.li@intel.com>,
	<yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>, <jarkko@kernel.org>,
	<amoorthy@google.com>, <dmatlack@google.com>, <yu.c.zhang@linux.intel.com>,
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
 <ef864674-bbcf-457b-a4e3-fec272fc2d8a@amazon.co.uk>
 <CA+EHjTxc0AwX2=htwC9to7+fYbFJsfVGT5d+BtEYVPncMgq1Mw@mail.gmail.com>
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
In-Reply-To: <CA+EHjTxc0AwX2=htwC9to7+fYbFJsfVGT5d+BtEYVPncMgq1Mw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit



On Thu, 2025-01-23 at 12:28 +0000, Fuad Tabba wrote:
> Hi Patrick,
> 
> On Thu, 23 Jan 2025 at 11:57, Patrick Roy <roypat@amazon.co.uk> wrote:
>>
>>
>>
>> On Thu, 2025-01-23 at 11:39 +0000, David Hildenbrand wrote:
>>> On 23.01.25 10:48, Fuad Tabba wrote:
>>>> On Wed, 22 Jan 2025 at 22:10, David Hildenbrand <david@redhat.com> wrote:
>>>>>
>>>>> On 22.01.25 16:27, Fuad Tabba wrote:
>>>>>> Make kvm_(read|/write)_guest_page() capable of accessing guest
>>>>>> memory for slots that don't have a userspace address, but only if
>>>>>> the memory is mappable, which also indicates that it is
>>>>>> accessible by the host.
>>>>>
>>>>> Interesting. So far my assumption was that, for shared memory, user
>>>>> space would simply mmap() guest_memdd and pass it as userspace address
>>>>> to the same memslot that has this guest_memfd for private memory.
>>>>>
>>>>> Wouldn't that be easier in the first shot? (IOW, not require this patch
>>>>> with the cost of faulting the shared page into the page table on access)
>>>>
>>>
>>> In light of:
>>>
>>> https://lkml.kernel.org/r/20250117190938.93793-4-imbrenda@linux.ibm.com
>>>
>>> there can, in theory, be memslots that start at address 0 and have a
>>> "valid" mapping. This case is done from the kernel (and on special s390x
>>> hardware), though, so it does not apply here at all so far.
>>>
>>> In practice, getting address 0 as a valid address is unlikely, because
>>> the default:
>>>
>>> $ sysctl  vm.mmap_min_addr
>>> vm.mmap_min_addr = 65536
>>>
>>> usually prohibits it for good reason.
>>>
>>>> This has to do more with the ABI I had for pkvm and shared memory
>>>> implementations, in which you don't need to specify the userspace
>>>> address for memory in a guestmem memslot. The issue is there is no
>>>> obvious address to map it to. This would be the case in kvm:arm64 for
>>>> tracking paravirtualized time, which the userspace doesn't necessarily
>>>> need to interact with, but kvm does.
>>>
>>> So I understand correctly: userspace wouldn't have to mmap it because it
>>> is not interested in accessing it, but there is nothing speaking against
>>> mmaping it, at least in the first shot.
>>>
>>> I assume it would not be a private memslot (so far, my understanding is
>>> that internal memslots never have a guest_memfd attached).
>>> kvm_gmem_create() is only called via KVM_CREATE_GUEST_MEMFD, to be set
>>> on user-created memslots.
>>>
>>>>
>>>> That said, we could always have a userspace address dedicated to
>>>> mapping shared locations, and use that address when the necessity
>>>> arises. Or we could always require that memslots have a userspace
>>>> address, even if not used. I don't really have a strong preference.
>>>
>>> So, the simpler version where user space would simply mmap guest_memfd
>>> to provide the address via userspace_addr would at least work for the
>>> use case of paravirtualized time?
>>
>> fwiw, I'm currently prototyping something like this for x86 (although
>> not by putting the gmem address into userspace_addr, but by adding a new
>> field to memslots, so that memory attributes continue working), based on
>> what we talked about at the last guest_memfd sync meeting (the whole
>> "how to get MMIO emulation working for non-CoCo VMs in guest_memfd"
>> story). So I guess if we're going down this route for x86, maybe it
>> makes sense to do the same on ARM, for consistency?
>>
>>> It would get rid of the immediate need for this patch and patch #4 to
>>> get it flying.
>>>
>>>
>>> One interesting question is: when would you want shared memory in
>>> guest_memfd and *not* provide it as part of the same memslot.
>>
>> In my testing of non-CoCo gmem VMs on ARM, I've been able to get quite
>> far without giving KVM a way to internally access shared parts of gmem -
>> it's why I was probing Fuad for this simplified series, because
>> KVM_SW_PROTECTED_VM + mmap (for loading guest kernel) is enough to get a
>> working non-CoCo VM on ARM (although I admittedly never looked at clocks
>> inside the guest - maybe that's one thing that breaks if KVM can't
>> access gmem. How to guest and host agree on the guest memory range
>> used to exchange paravirtual timekeeping information? Could that exchange
>> be intercepted in userspace, and set to shared via memory attributes (e.g.
>> placed outside gmem)? That's the route I'm going down the paravirtual
>> time on x86).
> 
> For an idea of what it looks like on arm64, here's how kvmtool handles it:
> https://github.com/kvmtool/kvmtool/blob/master/arm/aarch64/pvtime.c
> 
> Cheers,
> /fuad
 
Thanks! In that example, kvmtool actually allocates a separate memslot for
the pvclock stuff, so I guess it's always possible to simply put it into
a non-gmem memslot, which indeed sidesteps this issue as you mention in
your reply to David :D
  
>>> One nice thing about the mmap might be that access go via user-space
>>> page tables: E.g., __kvm_read_guest_page can just access the memory
>>> without requiring the folio lock and an additional temporary folio
>>> reference on every access -- it's handled implicitly via the mapcount.
>>>
>>> (of course, to map the page we still need that once on the fault path)
>>
>> Doing a direct map access in kvm_{read,write}_guest() and friends will
>> also get tricky if guest_memfd folios ever don't have direct map
>> entries. On-demand restoration is painful, both complexity and
>> performance wise [1], while going through a userspace mapping of
>> guest_memfd would "just work".
>>
>>> --
>>> Cheers,
>>>
>>> David / dhildenb
>>>



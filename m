Return-Path: <kvm+bounces-49836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 287DBADE957
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 12:43:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC28217E20A
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 10:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB434283FDC;
	Wed, 18 Jun 2025 10:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XgOx2snm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6054A1F542A;
	Wed, 18 Jun 2025 10:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750243410; cv=none; b=tVjb2Sx0N7ipnJ4rfs+s8kzT6h6u9YaOrolri3c3zxdKmHMOldDFUL8ORRowuB3/ZLwlngv5BKgffMxZAp6iJui0q8+xIyWo5mbcFzM3gjnAbZI0f0OOpV+BUZWNIzPTqAP0wI9eCHu75LCjcmfYqQyEmUqLUy3mzDHvoAZlpHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750243410; c=relaxed/simple;
	bh=I9PmKGx6C4Hu/BoA88yCIXxqN5ojWcA35Miba1RUffg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sEP06aNAMbOHdQ72yxBdjMfDEIjmxmJ+lMhPzMhlEVzApyGyh3rBd2CRLPJdfUwsILOgDKQq8A8mMW2Dp69JCxL435JQFbPu76ZGnvu5F3cBcQMubEFruqGgPy6lGYk7X21Tiogg2/k2tQtxWxXkWu6iMfrpjGx853b4i/ShwLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XgOx2snm; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750243408; x=1781779408;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I9PmKGx6C4Hu/BoA88yCIXxqN5ojWcA35Miba1RUffg=;
  b=XgOx2snm82/Eey/pBpfW5/+ahVKDfIwuL5sr+YA5dMjEn7jqf09qw29m
   FR9HCbM+NR8hsa2wLLn2+N3krSv2GGJ/nPDv+FZv8z148mvuAhxclIh1P
   DaUvZxSk5Mm9+V2OBlgelYLsHD1Xz5rAwmEnvsmxaluBq5IZoeIDogakE
   TFdX7rY1GSNv+Rybxo78kzgcqwimc9P8zCVkyfr/dwK4ogN3TmuTiCqyq
   l0hActRildWkMp7mJ7ROyKXVl52LUknmz+MVaU5+jXQ1MpeqPw/Kwoy64
   bwYhA/IbE4zRTS60r8yIxooCPlv0BgAxuDXEPJqrNNtrgVt1nuLmSJeiu
   Q==;
X-CSE-ConnectionGUID: 31tBF8OjT0WTR4RiWp6grQ==
X-CSE-MsgGUID: p+urGSlNQCyx2pa01AB3ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="56271992"
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="56271992"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 03:42:18 -0700
X-CSE-ConnectionGUID: TWdBwNcFRtSq2PYHbigelA==
X-CSE-MsgGUID: SccbtXZMQZq6raWpgFnzug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="150123348"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 03:42:05 -0700
Message-ID: <fa3cea2a-d005-44fd-8a2f-2bcea1dc9042@intel.com>
Date: Wed, 18 Jun 2025 18:42:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: David Hildenbrand <david@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, Ira Weiny <ira.weiny@intel.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-9-tabba@google.com> <aEySD5XoxKbkcuEZ@google.com>
 <68501fa5dce32_2376af294d1@iweiny-mobl.notmuch>
 <bbc213c3-bc3d-4f57-b357-a79a9e9290c5@redhat.com>
 <CA+EHjTxvqDr1tavpx7d9OyC2VfUqAko864zH9Qn5+B0UQiM93g@mail.gmail.com>
 <701c8716-dd69-4bf6-9d36-4f8847f96e18@redhat.com>
 <aFIK9l6H7qOG0HYB@google.com>
 <3fb0e82b-f4ef-402d-a33c-0b12e8aa990c@redhat.com>
 <5ee9bbb8-d100-408c-ac07-ea9c5b603545@intel.com>
 <5a55d95e-5e32-4239-a445-be13228ea80b@redhat.com>
 <45af2c0d-a416-49bc-8011-4ec57a56d6f5@intel.com>
 <40a5903b-f747-4eab-8959-06ddd6e88f82@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <40a5903b-f747-4eab-8959-06ddd6e88f82@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/18/2025 5:59 PM, David Hildenbrand wrote:
> On 18.06.25 11:44, Xiaoyao Li wrote:
>> On 6/18/2025 5:27 PM, David Hildenbrand wrote:
>>> On 18.06.25 11:20, Xiaoyao Li wrote:
>>>> On 6/18/2025 4:15 PM, David Hildenbrand wrote:
>>>>>> If we are really dead set on having SHARED in the name, it could be
>>>>>> GUEST_MEMFD_FLAG_USER_MAPPABLE_SHARED or
>>>>>> GUEST_MEMFD_FLAG_USER_MAP_SHARED?  But
>>>>>> to me that's _too_ specific and again somewhat confusing given the
>>>>>> unfortunate
>>>>>> private vs. shared usage in CoCo-land.  And just playing the odds, 
>>>>>> I'm
>>>>>> fine taking
>>>>>> a risk of ending up with GUEST_MEMFD_FLAG_USER_MAPPABLE_PRIVATE or
>>>>>> whatever,
>>>>>> because I think that is comically unlikely to happen.
>>>>>
>>>>> I think in addition to GUEST_MEMFD_FLAG_MMAP we want something to
>>>>> express "this is not your old guest_memfd that only supports private
>>>>> memory". And that's what I am struggling with.
>>>>
>>>> Sorry for chiming in.
>>>>
>>>> Per my understanding, (old) guest memfd only means it's the memory that
>>>> cannot be accessed by userspace. There should be no shared/private
>>>> concept on it.
>>>>
>>>> And "private" is the concept of KVM. Guest memfd can serve as private
>>>> memory, is just due to the character of it cannot be accessed from
>>>> userspace.
>>>>
>>>> So if the guest memfd can be mmap'ed, then it become userspace
>>>> accessable and cannot serve as private memory.
>>>>
>>>>> Now, if you argue "support for mmap() implies support for non-private
>>>>> memory", I'm probably okay for that.
>>>>
>>>> I would say, support for mmap() implies cannot be used as private 
>>>> memory.
>>>
>>> That's not where we're heading with in-place conversion support: you
>>> will have private (ianccessible) and non-private (accessible) parts, and
>>> while guest_memfd will support mmap() only the accessible parts can
>>> actually be accessed (faulted in etc).
>>
>> That's OK. The guestmemfd can be fine-grained, i.e., different
>> range/part of it can have different access property. But one rule never
>> change: only the sub-range is not accessible by userspace can it be
>> serve as private memory.
> 
> I'm sorry, I don't understand what you are getting at.
> 
> You said "So if the guest memfd can be mmap'ed, then it become userspace 
> accessable and cannot serve as private memory." and I say, with in-place 
> conversion support you are wrong.
> 
> The whole file can be mmaped(), that does not tell us anything about 
> which parts can be private or not.

So there is nothing prevent userspace from accessing it after a range is 
converted to private via KVM_GMEM_CONVERT_PRIVATE since the whole file 
can be mmaped()?

If so, then for TDX case, userspace can change the TD-owner bit of the 
private part by accessing it and later guest access will poison it and 
trigger #MC. If the #MC is only delivered to the PCPU that triggers it, 
it just leads to the TD guest being killed. If the #MC is broadcasted, 
it affects other in the system.

I just give it a try on real TDX system with in-place conversion. The TD 
is killed due to SIGBUS (host kernel handles the #MC and sends the 
SIGBUS). It seems OK if only the TD guest being affected due to 
userspace accesses the private memory. But I'm not sure if there is any 
corner case that will affect the host.



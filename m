Return-Path: <kvm+bounces-49830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38000ADE6B2
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:24:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B1063BA296
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 09:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B612281525;
	Wed, 18 Jun 2025 09:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cj4D32Pw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB5A280CDC;
	Wed, 18 Jun 2025 09:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750238527; cv=none; b=GaewLDv5TZ7bKE3/hV1uUWL5kpKusrS5TzdvvVcAIV+nYquYz8OadU/Lv2Zo2mv18c5UvNileDh6fzHGcxs/VhS93RaB5b3ZlTuEU3dq658HfHkyn2OPPv4mtp2wZSrGntOxrptZCu6z0UScNXTVMYeGoXx/wqWkEEAshFuX044=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750238527; c=relaxed/simple;
	bh=KdHjxfa6cu4WwYrW4xO3OoruUky1uXbLx+2tiz9VWgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f7TlhRIfTwxAGbGEdJkgh/40+aS+icS7ogphiYOrZ/cM943nYIVMZdkyiXg80X1ubb9KbZTceIsM3vjapgIWxYzYU1jhknWIvM9P4OnwxYOYp2TMksJL5/c4VSKtISSE0ACTh0xPzKG2cLlB/Njk89lgTXVPhjyUFALSW5Twoo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cj4D32Pw; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750238526; x=1781774526;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KdHjxfa6cu4WwYrW4xO3OoruUky1uXbLx+2tiz9VWgI=;
  b=cj4D32Pwp2pyICYQ/Xpwia9Wm94G6XMGQc9D1JReijpVCsedbdDeO4Bj
   7F8ru4f8rPua/RV+sjIIZFY4mWUNGla1Q9oDoMoadSALSZQvX5fNlrL5A
   u2PY96HR0YsldDPh8Utx7GtmO6hVnIdKsvw7/9fTsrABFAG1/Vq0COlxD
   VWJ5eltPaJuSJUD3CGPvRZ8A2pCS9NCwfes4J+pXHaT07AUlpZAoy5dYb
   9SQ1fN3n+jGCxpffw2DCkCjRkRRZIRLrU34btpSYH1eeIZ+XeyJB5thEt
   kI9jclV/og1SNrzplRQMZXxCvOSJUqwEh4OPgzYiqUj6URhoLR1T7JhkW
   w==;
X-CSE-ConnectionGUID: bq+HF2RFRBC0EFlfSs0bkg==
X-CSE-MsgGUID: rau9EXqbSNu8YPZyEufwYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="52314860"
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="52314860"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 02:20:57 -0700
X-CSE-ConnectionGUID: 3rSuwLJGTtGrXy+gzVICJA==
X-CSE-MsgGUID: X69ERuQKRmiRBrGfoErV1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="149359496"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 02:20:41 -0700
Message-ID: <5ee9bbb8-d100-408c-ac07-ea9c5b603545@intel.com>
Date: Wed, 18 Jun 2025 17:20:38 +0800
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
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <3fb0e82b-f4ef-402d-a33c-0b12e8aa990c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/18/2025 4:15 PM, David Hildenbrand wrote:
>> If we are really dead set on having SHARED in the name, it could be
>> GUEST_MEMFD_FLAG_USER_MAPPABLE_SHARED or 
>> GUEST_MEMFD_FLAG_USER_MAP_SHARED?  But
>> to me that's _too_ specific and again somewhat confusing given the 
>> unfortunate
>> private vs. shared usage in CoCo-land.  And just playing the odds, I'm 
>> fine taking
>> a risk of ending up with GUEST_MEMFD_FLAG_USER_MAPPABLE_PRIVATE or 
>> whatever,
>> because I think that is comically unlikely to happen.
> 
> I think in addition to GUEST_MEMFD_FLAG_MMAP we want something to 
> express "this is not your old guest_memfd that only supports private 
> memory". And that's what I am struggling with.

Sorry for chiming in.

Per my understanding, (old) guest memfd only means it's the memory that 
cannot be accessed by userspace. There should be no shared/private 
concept on it.

And "private" is the concept of KVM. Guest memfd can serve as private 
memory, is just due to the character of it cannot be accessed from 
userspace.

So if the guest memfd can be mmap'ed, then it become userspace 
accessable and cannot serve as private memory.

> Now, if you argue "support for mmap() implies support for non-private 
> memory", I'm probably okay for that.

I would say, support for mmap() implies cannot be used as private memory.

> I could envision support for non-private memory even without mmap() 
> support, how useful that might be, I don't know. But that's why I was 
> arguing that we mmap() is just one way to consume non-private memory.



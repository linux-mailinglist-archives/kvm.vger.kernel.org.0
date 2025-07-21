Return-Path: <kvm+bounces-52997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95470B0C6B3
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F1E94E7E97
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91BD8218AD4;
	Mon, 21 Jul 2025 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oI4S8zvx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1299A2DD5F3;
	Mon, 21 Jul 2025 14:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753108938; cv=none; b=DCloK7R8ec6sK5ENMMiqyL1u7+/oFrVZRNMN1Xi/R+JyYgVxJLtKyFStBg7T+H8JcnhfyFqGR4fEVN/EIgzbF0bRq+qFafrgP7mwZmENk4eOmkUskk/l2/4eRlaeRJkEKJPvD9a1/+Ihp+ecbH67RHyRFmSeC6gVrJ6NvvfC+N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753108938; c=relaxed/simple;
	bh=fHFhQnz1d9jkIQy6+wvI0Utsmrj/cSx28cBy/0zuK7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KYjBbIjgeOgBpXHugr0Ol6NMQoMASqChbrVJhsUlr11hTXNgCtYpX+pydCHQ+3BoTQZP/906SwxEsyihM4fe0+fZIeXxcLHFyuP8mmJXgww5FSD6U4G1SEGshI/Nt9nBkDckwELlGvCVz5WJAcF6SmRXUHbVI9cYA78ehfFUwFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oI4S8zvx; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753108937; x=1784644937;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fHFhQnz1d9jkIQy6+wvI0Utsmrj/cSx28cBy/0zuK7U=;
  b=oI4S8zvxfXW1EoffdJ8g7WI1Rx2Qkj9BfIj5I48LaxMl3bPcpT2j2zPX
   6C84lnmN6VOLdD6KLte9tgNZuEez+hdOnUiNrvoXxjrqu72zdxgKESMgu
   HQ5D3w8OPwb/HTI4uxE4rV5YWI4Xg3u/zMTcGD1VxUDpSJpkenLSI0RKo
   0MM3t3TOjLiVKI+0EnkyDpOGjB7BzWopd80h0ifJFwNwlzOk2Iocvg/vY
   T16VdOtII1/s1ooJyMWb12S1k2+XcRQcbLrjF0wCbLf3Jk08spobEGbYM
   PPlgD38PPBkWsDZehctl3JdZN8Pz2FlwzcGG46SgZNNN7px18Di0+gKfR
   g==;
X-CSE-ConnectionGUID: YrcLLfDbS+CenVt5wbGrzA==
X-CSE-MsgGUID: MIx7IPmdQvea93mfGH04gA==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="58985278"
X-IronPort-AV: E=Sophos;i="6.16,329,1744095600"; 
   d="scan'208";a="58985278"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 07:42:16 -0700
X-CSE-ConnectionGUID: qL0fP/21RrO2BIIqh5xu1g==
X-CSE-MsgGUID: xd+ebKGrR4KwX8aDa1+/mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,329,1744095600"; 
   d="scan'208";a="159582796"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 07:42:02 -0700
Message-ID: <131a3b2f-616f-428d-a41c-d490b9ca1b88@intel.com>
Date: Mon, 21 Jul 2025 22:42:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Vishal Annapurve <vannapurve@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, ackerleytng@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
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
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
 <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/21/2025 9:45 PM, Vishal Annapurve wrote:
> On Mon, Jul 21, 2025 at 5:22 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
>>> +/*
>>> + * CoCo VMs with hardware support that use guest_memfd only for backing private
>>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
>>> + */
>>> +#define kvm_arch_supports_gmem_mmap(kvm)             \
>>> +     (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&   \
>>> +      (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
>>
>> I want to share the findings when I do the POC to enable gmem mmap in QEMU.
>>
>> Actually, QEMU can use gmem with mmap support as the normal memory even
>> without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
>> on KVM_SET_USER_MEMORY_REGION2.
>>
>> Since the gmem is mmapable, QEMU can pass the userspace addr got from
>> mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It
>> works well for non-coco VMs on x86.
>>
>> Then it seems feasible to use gmem with mmap for the shared memory of
>> TDX, and an additional gmem without mmap for the private memory. i.e.,
>> For struct kvm_userspace_memory_region, the @userspace_addr is passed
>> with the uaddr returned from gmem0 with mmap, while @guest_memfd is
>> passed with another gmem1 fd without mmap.
>>
>> However, it fails actually, because the kvm_arch_suports_gmem_mmap()
>> returns false for TDX VMs, which means userspace cannot allocate gmem
>> with mmap just for shared memory for TDX.
> 
> Why do you want such a usecase to work?
> 
> If kvm allows mappable guest_memfd files for TDX VMs without
> conversion support, userspace will be able to use those for backing
> private memory unless:
> 1) KVM checks at binding time if the guest_memfd passed during memslot
> creation is not a mappable one and doesn't enforce "not mappable"
> requirement for TDX VMs at creation time.

yes, this is the additional change required.

> 2) KVM fetches shared faults through userspace page tables and not
> guest_memfd directly.

current KVM supports it already.

And as I described above,  current userspace can just mmap the gmem and 
pass the gotten addr to userspace_addr without passing guest_memfd, to 
force KVM to fetch through userspace page tables.

So if we want KVM to fetch page from guest memfd directly, should we add 
something in KVM to enforce it?

> I don't see value in trying to go out of way to support such a usecase.

 From my perspective, it's intuitive to think about this usecase when I 
tried to enable gmem mmap in QEMU. It seems a little strange that 
mmap'ed gmem can only serve as normal memory for non-CoCo VMs.

If KVM mandates any gmem must be passed via 
kvm_userspace_memory_region2.guest_memfd, no matter it's mmap'ed or not, 
it would make more sense (to me) to not support such usecase, since 
there is only one guest_memfd field in struct kvm_userspace_memory_region2.

At last, I just put it on the table, so people can be aware of it and 
make the call to support it or not. Either is OK to me.





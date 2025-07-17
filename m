Return-Path: <kvm+bounces-52684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58AA8B0829A
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 03:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADB601A65AE2
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 01:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A7A19ABD8;
	Thu, 17 Jul 2025 01:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LipIJguB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013BCFBF0;
	Thu, 17 Jul 2025 01:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752716909; cv=none; b=knqlsxxk+bC+m+zRRrUnfxVmN5yLsUI8xI438vCVnOTyAFWnk9za1GKZb+FlkqWf9hDLzOGqAqGWlfHIh3PGeKDn9PHWGK2+HE84lKohBsCPp4AfQQBjk19LcNdq/M9jPvnjucJr86JfCn76Z/L+68OBWmZGuU7pwN+gqSw3744=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752716909; c=relaxed/simple;
	bh=+vA6VjAD/msff3HcB4KHdm01AVdTtpQQAMZVpPzgeho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PRRRf0q71PgzuBWHMUl+2zCN11g8h94nir0Jd7Xw/QpQcMzCT8YAVyqkv+LOyu148pqNGdyv+mTGHY0pUlmzWnhS1WDbWrYZZDHx7PCiB90jFL0oH733qzZ3qSdA8uRy7srvF3Muc2wQIdJSdQZCGtYgu+axe0VgKNHl58HUcP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LipIJguB; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752716908; x=1784252908;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+vA6VjAD/msff3HcB4KHdm01AVdTtpQQAMZVpPzgeho=;
  b=LipIJguBWs9cJ04JcUad77inEHqq47UnlJRUMdY15fe6WkODYApDdpL6
   rF9xX4CKOEgnLZJPDDxcVzj787GhPn8dLPfBKd7OFkdPCv4Cocj3AuFIj
   l5kIVK6CaqvVKw+BmDzo8PjGMyRmhpH4TA8eBqWSEYsDME7VraWH/2AaT
   HWhm9yExVorGJscC2d9MSlqAXX26YjRLOrKAb2AZOIhiqeHhm+7gEnF4Z
   gaDbsWax3lejYqoYl5F+rN0tYCRZkoog9zr9Fd871lhJC3SFHqFhxfQnF
   k7rZiOm0tFWW9dPPae3wiyCDMpV39ojFtsRbMQ3h6RAvO5yuBdxdTNUsz
   Q==;
X-CSE-ConnectionGUID: HvD+JTPmRvmUWloLPTHFYQ==
X-CSE-MsgGUID: hG37pQ03SWq8Qatal+Knjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="58785937"
X-IronPort-AV: E=Sophos;i="6.16,317,1744095600"; 
   d="scan'208";a="58785937"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 18:48:27 -0700
X-CSE-ConnectionGUID: mucKBDNPTGiJAO6hz55JzA==
X-CSE-MsgGUID: KXDmfuCITFSe2NCia9MNQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,317,1744095600"; 
   d="scan'208";a="188650623"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 18:48:14 -0700
Message-ID: <fef1d856-8c13-4d97-ba8b-f443edb9beac@intel.com>
Date: Thu, 17 Jul 2025 09:48:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
To: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
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
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-5-tabba@google.com>
 <b5fe8f54-64df-4cfa-b86f-eed1cbddca7a@intel.com>
 <diqzwm87fzfc.fsf@ackerleytng-ctop.c.googlers.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <diqzwm87fzfc.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/2025 8:12 AM, Ackerley Tng wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
>>> Introduce a new boolean member, supports_gmem, to kvm->arch.
>>>
>>> Previously, the has_private_mem boolean within kvm->arch was implicitly
>>> used to indicate whether guest_memfd was supported for a KVM instance.
>>> However, with the broader support for guest_memfd, it's not exclusively
>>> for private or confidential memory. Therefore, it's necessary to
>>> distinguish between a VM's general guest_memfd capabilities and its
>>> support for private memory.
>>>
>>> This new supports_gmem member will now explicitly indicate guest_memfd
>>> support for a given VM, allowing has_private_mem to represent only
>>> support for private memory.
>>>
>>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>> Reviewed-by: Shivank Garg <shivankg@amd.com>
>>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>>> Co-developed-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>
>> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> Btw, it seems that supports_gmem can be enabled for all the types of VM?
>>
> 
> For now, not really, because supports_gmem allows mmap support, and mmap
> support enables KVM_MEMSLOT_GMEM_ONLY, and KVM_MEMSLOT_GMEM_ONLY will
> mean that shared faults also get faulted from guest_memfd.

No, mmap support is checked by kvm_arch_supports_gmem_mmap() which is 
independent to whether gmem is supported.

> A TDX VM that wants to use guest_memfd for private memory and some other
> backing memory for shared memory (let's call this use case "legacy CoCo
> VMs") will not work if supports_gmem is just enabled for all types of
> VMs, because then shared faults will also go to kvm_gmem_get_pfn().

This is not what this patch does. Please go back read this patch.

This patch sets kvm->arch.supports_gmem to true for 
KVM_X86_SNP_VM/tdx/KVM_X86_SW_PROTECTED_VM.

Further in patch 14, it sets kvm->arch.supports_gmem for KVM_X86_DEFAULT_VM.

After this series, supports_gmem remains false only for KVM_X86_SEV_VM 
and KVM_X86_SEV_ES_VM. And I don't see why cannot enable supports_gmem 
for them.

> This will be cleaned up when guest_memfd supports conversion
> (guest_memfd stage 2). There, a TDX VM will have .supports_gmem = true.
> 
> With guest_memfd stage-2 there will also be a
> KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING.
> KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaults to false, so for legacy
> CoCo VMs, shared faults will go to the other non-guest_memfd memory
> source that is configured in userspace_addr as before.
> 
> With guest_memfd stage-2, KVM_MEMSLOT_GMEM_ONLY will direct all EPT
> faults to kvm_gmem_get_pfn(), but KVM_MEMSLOT_GMEM_ONLY will only be
> allowed if KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING is true. TDX VMs
> wishing to use guest_memfd as the only source of memory for the guest
> should set KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING to true before
> creating the guest_memfd.
> 
>> Even without mmap support, allow all the types of VM to create
>> guest_memfd seems not something wrong. It's just that the guest_memfd
>> allocated might not be used, e.g., for KVM_X86_DEFAULT_VM.
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> p



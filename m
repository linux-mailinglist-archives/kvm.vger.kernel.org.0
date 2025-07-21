Return-Path: <kvm+bounces-53002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1DFCB0C744
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:07:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05BEC1886458
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 15:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A697D2DE213;
	Mon, 21 Jul 2025 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DKCfL4Kg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9967260A;
	Mon, 21 Jul 2025 15:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753110466; cv=none; b=W61qyJ/FUqrOeqvrj4XHPcAu4PpmroGnfLWOxNwKBdyBGu/SHnO52HtlTIL+qSP2Xzeh6gq2O9LcM4pwFusOmw6JoDzyOQxu5Yrwi1SK0WAC9c+rVSC6aF6M3eyG4JABPu6p+W34QWni+bt9Q4i2MtSJP1cw7LBd2Qqr3iteFTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753110466; c=relaxed/simple;
	bh=4YlAyrTgURcjQLLGh8M8Baulvlj/zb48j/Ays/Dbezo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DA7eKVLNt+PCykVLp7VXtZdsinN4v391An8YNb+o03rvhCk+S4aNsGtLhQBjkKLOfJamgwpPSt7eX3555/J/Pv9OxkNfdI164tHLO9iAB87fb8e6AEEGw5v4oq4e/g3fasvuWkou9kx4UpjJsBMeQGzt6nYM7lpXJkT62H3nDK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DKCfL4Kg; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753110465; x=1784646465;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4YlAyrTgURcjQLLGh8M8Baulvlj/zb48j/Ays/Dbezo=;
  b=DKCfL4Kgy0biNrISyDQkB6ziZ82LT+OfiTLvpty6S6zmqOBljn179h3J
   Tq/6lAHaMtroj+idMPbNhJzbuuGb+o34Vg0DuypaE3hIVMOfufo+F1A4F
   bUt0dOpX/NWmRKG941BWlXqMHIXsoKKoHxvt+aOiqJBMpEKiOSc1f3J2V
   rMWPtojJgldppF4GOqz4iSvMVmTAGi+awXy8ERKI8VJX1XsQt/WhrRbs/
   JtPNtNoEjoyvlFnRwQIUJWt6l0eIGISQMNfbJtUAML8V/vlxi2wTuw08E
   xEkD2S8kEBMTcGNL3FvRtsnzkHYzpv7gAmfp1c7tZ3VkihEW+KWq93SP7
   w==;
X-CSE-ConnectionGUID: mnJDQMyBRmeTIMQjCDNLgQ==
X-CSE-MsgGUID: AVro8gqhR7iIvC+b+myAug==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="80772516"
X-IronPort-AV: E=Sophos;i="6.16,329,1744095600"; 
   d="scan'208";a="80772516"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 08:07:42 -0700
X-CSE-ConnectionGUID: Y2/p+6F3S7qzVEpfid72dw==
X-CSE-MsgGUID: Fsb9V4BJTea2+1zJTwr/dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,329,1744095600"; 
   d="scan'208";a="163160761"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 08:07:28 -0700
Message-ID: <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
Date: Mon, 21 Jul 2025 23:07:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
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
 <aH5RxqcTXRnQbP5R@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aH5RxqcTXRnQbP5R@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/21/2025 10:42 PM, Sean Christopherson wrote:
> On Mon, Jul 21, 2025, Vishal Annapurve wrote:
>> On Mon, Jul 21, 2025 at 5:22 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>
>>> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
>>>> +/*
>>>> + * CoCo VMs with hardware support that use guest_memfd only for backing private
>>>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
>>>> + */
>>>> +#define kvm_arch_supports_gmem_mmap(kvm)             \
>>>> +     (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&   \
>>>> +      (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
>>>
>>> I want to share the findings when I do the POC to enable gmem mmap in QEMU.
>>>
>>> Actually, QEMU can use gmem with mmap support as the normal memory even
>>> without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
>>> on KVM_SET_USER_MEMORY_REGION2.
>>>
>>> Since the gmem is mmapable, QEMU can pass the userspace addr got from
>>> mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It
>>> works well for non-coco VMs on x86.
>>>
>>> Then it seems feasible to use gmem with mmap for the shared memory of
>>> TDX, and an additional gmem without mmap for the private memory. i.e.,
>>> For struct kvm_userspace_memory_region, the @userspace_addr is passed
>>> with the uaddr returned from gmem0 with mmap, while @guest_memfd is
>>> passed with another gmem1 fd without mmap.
>>>
>>> However, it fails actually, because the kvm_arch_suports_gmem_mmap()
>>> returns false for TDX VMs, which means userspace cannot allocate gmem
>>> with mmap just for shared memory for TDX.
>>
>> Why do you want such a usecase to work?
> 
> I'm guessing Xiaoyao was asking an honest question in response to finding a
> perceived flaw when trying to get this all working in QEMU.

I'm not sure if it is an flaw. Such usecase is not supported is just 
anti-intuition to me.

>> If kvm allows mappable guest_memfd files for TDX VMs without
>> conversion support, userspace will be able to use those for backing
> 
> s/able/unable?

I think vishal meant "able", because ...

>> private memory unless:
>> 1) KVM checks at binding time if the guest_memfd passed during memslot
>> creation is not a mappable one and doesn't enforce "not mappable"
>> requirement for TDX VMs at creation time.
> 
> Xiaoyao's question is about "just for shared memory", so this is irrelevant for
> the question at hand.

... if we allow gmem mmap for TDX, KVM needs to ensure the mmapable gmem 
should only be passed via userspace_addr. IOW, KVM needs to forbid 
userspace from passing the mmap'able guest_memfd to 
kvm_userspace_memory_region2.guest_memfd. Because it allows userspace to 
access the private mmeory.

>> 2) KVM fetches shared faults through userspace page tables and not
>> guest_memfd directly.
> 
> This is also irrelevant.  KVM _already_ supports resolving shared faults through
> userspace page tables.  That support won't go away as KVM will always need/want
> to support mapping VM_IO and/or VM_PFNMAP memory into the guest (even for TDX).
> 
>> I don't see value in trying to go out of way to support such a usecase.
> 
> But if/when KVM gains support for tracking shared vs. private in guest_memfd
> itself, i.e. when TDX _does_ support mmap() on guest_memfd, KVM won't have to go
> out of its to support using guest_memfd for the @userspace_addr backing store.
> Unless I'm missing something, the only thing needed to "support" this scenario is:

As above, we need 1) mentioned by Vishal as well, to prevent userspace 
from passing mmapable guest_memfd to serve as private memory.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index d01bd7a2c2bd..34403d2f1eeb 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -533,7 +533,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>          u64 flags = args->flags;
>          u64 valid_flags = 0;
>   
> -       if (kvm_arch_supports_gmem_mmap(kvm))
> +       // if (kvm_arch_supports_gmem_mmap(kvm))
>                  valid_flags |= GUEST_MEMFD_FLAG_MMAP;
>   
>          if (flags & ~valid_flags)
> 
> I think the question we actually want to answer is: do we want to go out of our
> way to *prevent* such a usecase.  E.g. is there any risk/danger that we need to
> mitigate, and would the cost of the mitigation be acceptable?
> 
> I think the answer is "no", because preventing userspace from using guest_memfd
> as shared-only memory would require resolving the VMA during hva_to_pfn() in order
> to fully prevent such behavior, and I defintely don't want to take mmap_lock
> around hva_to_pfn_fast().
> 
> I don't see any obvious danger lurking.  KVM's pre-guest_memfd memory management
> scheme is all about effectively making KVM behave like "just another" userspace
> agent.  E.g. if/when TDX/SNP support comes along, guest_memfd must not allow mapping
> private memory into userspace regardless of what KVM supports for page faults.
> 
> So unless I'm missing something, for now we do nothing, and let this support come
> along naturally once TDX support mmap() on guest_memfd.



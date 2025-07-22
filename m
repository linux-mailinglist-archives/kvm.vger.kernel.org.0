Return-Path: <kvm+bounces-53131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E39B0DEAE
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:32:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 998CC18854B0
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 909182C08B6;
	Tue, 22 Jul 2025 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="btKdHQNS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B10B288CA2;
	Tue, 22 Jul 2025 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753194505; cv=none; b=ngW1wfAEt38R0l+fnuL/VB9AZE0uDg+Szy7Ul2KD0zH7ATQJswmZla2EhQXhftLYBDTaaBi93JFyyQALcuBJDKNcuDS+AAQu8+iSaM2oJixyiAN0tJ+EYDpfaIRPDXrty3pAe0frs4ihj3I98NT3mcXlzfzUUA3/b9Fwj+Upaf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753194505; c=relaxed/simple;
	bh=CMfdm9bpoW6wxCW8WngkMggnv8KINp/BSbU+OViMmvQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=eBvfozcvXYuHnh3Ew24hNX6LWZI8xZqn/eY+hrZvJEoQKgqF92HS/MK36zisAiXwYqy6v6eaUwpem4U9Ffoqp7Tj0x56waw+D4jR5mN02zty0VH8uCoqs6U+Y7Z1SrU/PqSsX8VRmFM+juIsx7lmJVM/s+aoTt0etfNdNcTqq0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=btKdHQNS; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753194504; x=1784730504;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=CMfdm9bpoW6wxCW8WngkMggnv8KINp/BSbU+OViMmvQ=;
  b=btKdHQNSSLUuraiQ/1dgkYRqHonJObylk81WYWV/2OxzjZfZ6/K7abG1
   jNNs0+jwKFg8p2p2huseRqijnRmh9TUFfQujBHJqNBxTgJCRiIB9AWo+1
   HLJiOE8PU/eZqKUEYigcJXGxEbEHwBqT9YQZgpyaLt5Wlm7oMmpbQkJNj
   cUF87VgBdspRmtRuCgfUVE6y2CMNDfzk6pavJGLn0Dsg/IeSnsw66U/FW
   nGNKSWXglzEBRsPkpTu3ImdjbR+cWiFK8DV8hW6bg71XX0SCvqHw2AOSY
   8LUEXo+IsaLrql6YY9Zx2BLvvHiVPZUX+HvuGvTwoqd1yfzoD1OlYAJ6f
   w==;
X-CSE-ConnectionGUID: 95URano7TxifN+dkD8yUSw==
X-CSE-MsgGUID: JE9fm0NQSsG072jWHMIjbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="65709135"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="65709135"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 07:28:23 -0700
X-CSE-ConnectionGUID: 5acaJGK5Tm2vQvo6sRx0lQ==
X-CSE-MsgGUID: MJKyMwlDRwWPoO8Bms4RAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="158827953"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 07:28:09 -0700
Message-ID: <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
Date: Tue, 22 Jul 2025 22:28:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
Content-Language: en-US
In-Reply-To: <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/21/2025 8:22 PM, Xiaoyao Li wrote:
> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
>> +/*
>> + * CoCo VMs with hardware support that use guest_memfd only for 
>> backing private
>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping 
>> enabled.
>> + */
>> +#define kvm_arch_supports_gmem_mmap(kvm)        \
>> +    (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&    \
>> +     (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
> 
> I want to share the findings when I do the POC to enable gmem mmap in QEMU.
> 
> Actually, QEMU can use gmem with mmap support as the normal memory even 
> without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd 
> on KVM_SET_USER_MEMORY_REGION2.
> 
> Since the gmem is mmapable, QEMU can pass the userspace addr got from 
> mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It 
> works well for non-coco VMs on x86.

one more findings.

I tested with QEMU by creating normal (non-private) memory with mmapable 
guest memfd, and enforcily passing the fd of the gmem to struct 
kvm_userspace_memory_region2 when QEMU sets up memory region.

It hits the kvm_gmem_bind() error since QEMU tries to back different GPA 
region with the same gmem.

So, the question is do we want to allow the multi-binding for 
shared-only gmem?

> Then it seems feasible to use gmem with mmap for the shared memory of 
> TDX, and an additional gmem without mmap for the private memory. i.e.,
> For struct kvm_userspace_memory_region, the @userspace_addr is passed 
> with the uaddr returned from gmem0 with mmap, while @guest_memfd is 
> passed with another gmem1 fd without mmap.
> 
> However, it fails actually, because the kvm_arch_suports_gmem_mmap() 
> returns false for TDX VMs, which means userspace cannot allocate gmem 
> with mmap just for shared memory for TDX.
> 
> SO my question is do we want to support such case?
> 



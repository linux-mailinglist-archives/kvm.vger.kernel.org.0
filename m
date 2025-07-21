Return-Path: <kvm+bounces-52969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E39BFB0C3FF
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:22:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 469753BB971
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 12:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2993F2D3A80;
	Mon, 21 Jul 2025 12:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FSSQgbDm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16932C374B;
	Mon, 21 Jul 2025 12:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753100558; cv=none; b=P+MSUpssBh1BdOUfyzK4pHg5qqibmwCX4ABL5ptX/PKjDepwztlweT/EFr7J/hwv/lV3N9al3EdHO8y6HMsq/w4Cim/plDADUBQZvC5s9rJP3IWeWwBMpYDOmdPt/0KWplfYDPcNRXBd4AXL0b6j55yLVB1KCw1/HTKWrTNVYrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753100558; c=relaxed/simple;
	bh=3C686h11jQ44cFqomlzZu2sYzUWPMKguhYLmZCUvRLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G/Vs8eVT867MFhKom+F6UgXUnC86M23AZ5W9WeOzNOpbq0bSN941TBDH4z5MS7D3gX8k2k1UOJqUU5VU8wx/1DyMvytALBJhoOgnUIUECf65tP4yuQh+rFEHEi1bFnIRu0cEDnlR+e5i/HfIuqo8u4qtsKhC3xv+2uACUv5LHQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FSSQgbDm; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753100556; x=1784636556;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3C686h11jQ44cFqomlzZu2sYzUWPMKguhYLmZCUvRLM=;
  b=FSSQgbDmfDDn0xi6MDMsHiByasy4kxG+iD3gJ6Ba8GoH17NazQizjAjn
   DySOq7udHx8ZCfsrkXgGCWV3ag9+dWQijYf+P2OZy+GTatC1Mx1rnQ/nm
   KJXbrD8S3+1hdx2VkeuaEG/zWQkON+QBbIlWGjhbHShbJf5tYXX+rl2xD
   XOAdTjm5zm/UhDYC+xvF+Vqt3wOeAxJ0/0w0YHSd+sr3nmGVrz/lNfj8u
   egDz0bg1SCGdgEbhf++F6PLp0qFgEmJjr5SYe7XTXdgceWoAW/lW7aixP
   bVST5Z2qsSxQCOTx9/kQu4EoR11S7+ACRyHvDQGveEWVLE0yEfTsJR4jj
   A==;
X-CSE-ConnectionGUID: q/hH+/JJTPqXjw6hI2eJoA==
X-CSE-MsgGUID: 0nZc40eUSxu1xQuNEpZG1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="65572955"
X-IronPort-AV: E=Sophos;i="6.16,329,1744095600"; 
   d="scan'208";a="65572955"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 05:22:36 -0700
X-CSE-ConnectionGUID: 51MCPWwhTyuKi4jjJP9s+Q==
X-CSE-MsgGUID: 4PAEh2SPTSe+Evo/JBggNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,329,1744095600"; 
   d="scan'208";a="163048713"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 05:22:22 -0700
Message-ID: <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
Date: Mon, 21 Jul 2025 20:22:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
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
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250717162731.446579-15-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> +/*
> + * CoCo VMs with hardware support that use guest_memfd only for backing private
> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> + */
> +#define kvm_arch_supports_gmem_mmap(kvm)		\
> +	(IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&	\
> +	 (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)

I want to share the findings when I do the POC to enable gmem mmap in QEMU.

Actually, QEMU can use gmem with mmap support as the normal memory even 
without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd 
on KVM_SET_USER_MEMORY_REGION2.

Since the gmem is mmapable, QEMU can pass the userspace addr got from 
mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It 
works well for non-coco VMs on x86.

Then it seems feasible to use gmem with mmap for the shared memory of 
TDX, and an additional gmem without mmap for the private memory. i.e.,
For struct kvm_userspace_memory_region, the @userspace_addr is passed 
with the uaddr returned from gmem0 with mmap, while @guest_memfd is 
passed with another gmem1 fd without mmap.

However, it fails actually, because the kvm_arch_suports_gmem_mmap() 
returns false for TDX VMs, which means userspace cannot allocate gmem 
with mmap just for shared memory for TDX.

SO my question is do we want to support such case?


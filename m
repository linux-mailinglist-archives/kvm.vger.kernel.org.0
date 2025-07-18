Return-Path: <kvm+bounces-52858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB02AB09B28
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:11:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26B2E567C08
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8041F03C7;
	Fri, 18 Jul 2025 06:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A4HzCY8n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EC717578;
	Fri, 18 Jul 2025 06:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752819070; cv=none; b=b5Drj3HjVwZc8P1eIQM9oTvby0pHD3iigeDFTlobqP9va3MAdrR3bicc5CUyxVqBKEMCLbb/R83sXbKP4oD9xutzUw4l8unJA4pFhtK5NypkNKd3op+Xem5BeSrLkIRjU1eEke7DaePFEEGMfIfAlVxWxxQ3uCSvae4s51XO1sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752819070; c=relaxed/simple;
	bh=MUDYFfWZtE5SRJTEHysqovvMYxw7yMedHOfGB0dOsQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ItNYbXvsfOnQy3C3gFp1LZpSlUJQu8AnCkRyXRmlbAPO2UsqVS1DfAjbbVlDTqO9p51DW/aCIfFTBjS0hZxCKw9ggVTjwdu8jU8J/Bs3RT36PRIInfwr5hbsI145dI8GLzpsrW+oWeBzXbjTvtYr4+kw+MdSpXcrsOOjQvnV3W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A4HzCY8n; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752819069; x=1784355069;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MUDYFfWZtE5SRJTEHysqovvMYxw7yMedHOfGB0dOsQg=;
  b=A4HzCY8nClu6jZk5NmRvdXuppnEuo91i9GpRSmN0UAtrJPyemvtLtvdo
   DuohfwojFiRNVSsTw+IfRCKBGGfPtLIbmM769swGVBNRHqyu2cyGx6V1b
   Mif1uHmd8DTPZG4wzQXb/8lSuh54+0wcMzqrd6y/dF2dh75+UaFIxWB9a
   uIJWZHjUGT2mUJjUHUo3fyQNosIS3p7TPDejdKfGyGr4eRwGpz3yjist9
   bQqXrYUeU8yG8qvGT1kvHpnFLdRfbgankiWZR+C6XUun7nqSrG+9csVah
   +TPNlIHsC2Uc/r9AzvBuN8IUt+NGUEGBPkl5erL6BXvp1STuTAGzxq9Wm
   A==;
X-CSE-ConnectionGUID: By0u0kn2RMaNZ6HoOc0OHQ==
X-CSE-MsgGUID: nuN6l4JCQv+ylkPrGlIRQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="55047814"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="55047814"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 23:11:08 -0700
X-CSE-ConnectionGUID: suLoPW0jRu6qTo6awwoYtg==
X-CSE-MsgGUID: VMK2N62LTaahlHPocZSdbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="162280252"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 23:10:54 -0700
Message-ID: <7e70c7b9-294b-4e39-a4b6-8357a146dc78@intel.com>
Date: Fri, 18 Jul 2025 14:10:51 +0800
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
> Enable host userspace mmap support for guest_memfd-backed memory when
> running KVM with the KVM_X86_DEFAULT_VM type:
> 
> * Define kvm_arch_supports_gmem_mmap() for KVM_X86_DEFAULT_VM: Introduce
>    the architecture-specific kvm_arch_supports_gmem_mmap() macro,
>    specifically enabling mmap support for KVM_X86_DEFAULT_VM instances.
>    This macro, gated by CONFIG_KVM_GMEM_SUPPORTS_MMAP, ensures that only
>    the default VM type can leverage guest_memfd mmap functionality on
>    x86. This explicit enablement prevents CoCo VMs, which use guest_memfd
>    primarily for private memory and rely on hardware-enforced privacy,
>    from accidentally exposing guest memory via host userspace mappings.
> 
> * Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in KVM_X86: Enable the
>    CONFIG_KVM_GMEM_SUPPORTS_MMAP Kconfig option when KVM_X86 is selected.
>    This ensures that the necessary code for guest_memfd mmap support
>    (introduced earlier) is compiled into the kernel for x86. This Kconfig
>    option acts as a system-wide gate for the guest_memfd mmap capability.
>    It implicitly enables CONFIG_KVM_GMEM, making guest_memfd available,
>    and then layers the mmap capability on top specifically for the
>    default VM.
> 
> These changes make guest_memfd a more versatile memory backing for
> standard KVM guests, allowing VMMs to use a unified guest_memfd model
> for both private (CoCo) and non-private (default) VMs. This is a
> prerequisite for use cases such as running Firecracker guests entirely
> backed by guest_memfd and implementing direct map removal for non-CoCo
> VMs.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


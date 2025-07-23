Return-Path: <kvm+bounces-53245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8161DB0F3F7
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D2EC16932D
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 13:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8421B2E6D1C;
	Wed, 23 Jul 2025 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n3K8z28X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7E42080C0;
	Wed, 23 Jul 2025 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753277251; cv=none; b=c9yUACzuXaw1u3z8Eg1DqrK7FMrt+ns8/0ZK31u2DS5jOpRe7F+l7ApfqmZG/pY9QJbG2c4xDzc7E1z+BGTqdY9TvcrzvXXnshsq0fwqQNrIluwWWF3LB+ZNrcJW80SDmPpyxYhR/SS8MCFQJushg/hb07AoU9/4j1B7W3lRE8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753277251; c=relaxed/simple;
	bh=chDTWX5a3R65VeyMPmWT/vUkB2Kxq9PV37cbFxZXFmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uvm68S4f7K3LIGSiL7nEcTwt5Q3hD6j5tlrS0t7UYdmRCbD8edvh99cjCBUzzPLhWb6bSZxkIhZinng6CvFYlzVnE8ln1AQ+gclSXjWfm9HZu2N1bkCz+0UnJbAIY81cFCC1Hsfm6igC5n3/K9YcbrH2QErpA5rFjAkRnqTLDGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n3K8z28X; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753277250; x=1784813250;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=chDTWX5a3R65VeyMPmWT/vUkB2Kxq9PV37cbFxZXFmA=;
  b=n3K8z28Xzx1cstO7O1SVcuJHj4aVOz91OVWiaUAMjCDyEAr73fmXIewR
   tHp7CuxMnb4yongyhx0dIR6jBIJpACkoqlqzzbPkxzWu+wvy+hAav6lSv
   7AwBYsZ7s6C5fO53po285GS9SCTdRGg/w2f8Y5YlzDR2VuDGv6omKDk8a
   Y8WDmCz0s7WhEkEPN1C4vFvx1gItY02HcW4ofhUyipyWvBy/MF3m40TKc
   ij1mivjpKYW68r3yOQYmz5xeiGpDXODwWvbzL/hRg20NC2Q2ahdlYO9xK
   zt0pISLw2/f37EshziSGEMAkYIF2+qTaNT59bnBBe0qa4uRDF9c2dB5B3
   A==;
X-CSE-ConnectionGUID: fHlp2vUVSP2dg+g/K0JRRA==
X-CSE-MsgGUID: ueNlV+C7QOGaHuiq5VPsLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="58173891"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="58173891"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:27:29 -0700
X-CSE-ConnectionGUID: SWccDMwzSMqd/Mz7ntxyHA==
X-CSE-MsgGUID: rSy2YXBLRKqFAWkzayDTnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159275110"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:27:13 -0700
Message-ID: <a438c189-4152-4ad4-977e-6a5291a7dd40@intel.com>
Date: Wed, 23 Jul 2025 21:27:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/22] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
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
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-6-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-6-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/2025 6:46 PM, Fuad Tabba wrote:
> The original name was vague regarding its functionality. This Kconfig
> option specifically enables and gates the kvm_gmem_populate() function,
> which is responsible for populating a GPA range with guest data.
> 
> The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
> option: to enable arch-specific guest_memfd population mechanisms. It
> also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
> options.
> 
> This improves clarity for developers and ensures the name accurately
> reflects the functionality it controls, especially as guest_memfd
> support expands beyond purely "private" memory scenarios.
> 
> Note that the vm type KVM_X86_SW_PROTECTED_VM does not need the populate
> function. Therefore, ensure that the correct configuration is selected
> when KVM_SW_PROTECTED_VM is enabled.

the changelog needs to be enhanced. At least it doesn't talk about 
KVM_X86_PRIVATE_MEM at all.

If Sean is going to queue this version, I think he can help refine it 
when queuing.

> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/Kconfig     | 14 ++++++++++----
>   include/linux/kvm_host.h |  2 +-
>   virt/kvm/Kconfig         |  9 ++++-----
>   virt/kvm/guest_memfd.c   |  2 +-
>   4 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 13ab7265b505..c763446d9b9f 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -79,11 +79,16 @@ config KVM_WERROR
>   
>   	  If in doubt, say "N".
>   
> +config KVM_X86_PRIVATE_MEM
> +	select KVM_GENERIC_MEMORY_ATTRIBUTES
> +	select KVM_GUEST_MEMFD
> +	bool
> +
>   config KVM_SW_PROTECTED_VM
>   	bool "Enable support for KVM software-protected VMs"
>   	depends on EXPERT
>   	depends on KVM_X86 && X86_64
> -	select KVM_GENERIC_PRIVATE_MEM
> +	select KVM_X86_PRIVATE_MEM
>   	help
>   	  Enable support for KVM software-protected VMs.  Currently, software-
>   	  protected VMs are purely a development and testing vehicle for
> @@ -133,8 +138,8 @@ config KVM_INTEL_TDX
>   	bool "Intel Trust Domain Extensions (TDX) support"
>   	default y
>   	depends on INTEL_TDX_HOST
> -	select KVM_GENERIC_PRIVATE_MEM
> -	select KVM_GENERIC_MEMORY_ATTRIBUTES
> +	select KVM_X86_PRIVATE_MEM
> +	select HAVE_KVM_ARCH_GMEM_POPULATE
>   	help
>   	  Provides support for launching Intel Trust Domain Extensions (TDX)
>   	  confidential VMs on Intel processors.
> @@ -157,9 +162,10 @@ config KVM_AMD_SEV
>   	depends on KVM_AMD && X86_64
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>   	select ARCH_HAS_CC_PLATFORM
> -	select KVM_GENERIC_PRIVATE_MEM
> +	select KVM_X86_PRIVATE_MEM
>   	select HAVE_KVM_ARCH_GMEM_PREPARE
>   	select HAVE_KVM_ARCH_GMEM_INVALIDATE
> +	select HAVE_KVM_ARCH_GMEM_POPULATE
>   	help
>   	  Provides support for launching encrypted VMs which use Secure
>   	  Encrypted Virtualization (SEV), Secure Encrypted Virtualization with
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8cdc0b3cc1b1..ddfb6cfe20a6 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2534,7 +2534,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
>   #endif
>   
> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>   /**
>    * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
>    *
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index e4b400feff94..1b7d5be0b6c4 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -116,11 +116,6 @@ config KVM_GUEST_MEMFD
>          select XARRAY_MULTI
>          bool
>   
> -config KVM_GENERIC_PRIVATE_MEM
> -       select KVM_GENERIC_MEMORY_ATTRIBUTES
> -       select KVM_GUEST_MEMFD
> -       bool
> -
>   config HAVE_KVM_ARCH_GMEM_PREPARE
>          bool
>          depends on KVM_GUEST_MEMFD
> @@ -128,3 +123,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>   config HAVE_KVM_ARCH_GMEM_INVALIDATE
>          bool
>          depends on KVM_GUEST_MEMFD
> +
> +config HAVE_KVM_ARCH_GMEM_POPULATE
> +       bool
> +       depends on KVM_GUEST_MEMFD
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 7d85cc33c0bb..b2b50560e80e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -627,7 +627,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   }
>   EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
>   
> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>   long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
>   		       kvm_gmem_populate_cb post_populate, void *opaque)
>   {



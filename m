Return-Path: <kvm+bounces-53238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 971F6B0F348
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:10:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 916C61CC2BB0
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 13:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF36D2E7F3E;
	Wed, 23 Jul 2025 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MWJbRehx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4124628A1FE;
	Wed, 23 Jul 2025 13:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753275995; cv=none; b=IEgQ5U8o3Eic4pbtXuQxHzQLelVjgDtPofl8l4W1vXjbEhrxIsMtRQcfIBY3bCBod+aK+TKXSnqRxQZWar8tPxdEXsfxMArkOpYQeSrm0I/efqQq0rABq8a+w9PESv6d+M+RYpBXWmNdqLow3aMp1JZeeeU6zXVxuTeYxmkemdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753275995; c=relaxed/simple;
	bh=xpGnh9YJZRPC8hRQsB+1pAq5rzC1Pd9l2Hu5tdw8+wM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k7K35oi888a1SR/7il9ZI5YKv7JZBYS8LUX8PldpuzlncIR9lY5iB/a0AAryVAS9z0wXFa8kybvcDESB6K89WTsu0r+Oiu9UKHIFT2HFg+7JNCmjBmpJbOsgFPrQQzo2FLXyGbEP9GHUU6OtF+UoVnMGU6FCyYzN+5E3zbx0ddA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MWJbRehx; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753275995; x=1784811995;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xpGnh9YJZRPC8hRQsB+1pAq5rzC1Pd9l2Hu5tdw8+wM=;
  b=MWJbRehxC+H2Lhq1nMJDf0/YAKEYLyx39MrOabx8Jnp0DXQSmOqzajxZ
   YexpkBFF8xFLSLwvfkAwHvebRcye1mbjSvEDyIHsncpC6+Ru2NOYaDiIR
   xRFus4gsaI/q/0K6GxM3H58x2xL+BOYPzKu5qqD0fnoZfOl/2kSvVhKFi
   43pMyYe7CR56s/NVEYgCVI93JP9Lmy8K0RhGOeKkkbeFcNO78oBCEOf+1
   tIVcJ1XwHUiwxtQ27C9Aq5GAxKsNwzUtP7OXRvrcPQr7QFr/PviKEMa9p
   FiKJuOb7JxIWkzunPZiADP3If4qqYYJsXpFBGgGgCQA/0wC/5G8+X+TR2
   w==;
X-CSE-ConnectionGUID: an0I0Gk/R9CgeBCUFF/ExA==
X-CSE-MsgGUID: 9LpXJSpQT2SqV8ivs8mdqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66898746"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="66898746"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:06:34 -0700
X-CSE-ConnectionGUID: o54KMjg3Q8eDVfJynjs12w==
X-CSE-MsgGUID: W8NbhIYWSAWyZKxaUBNBxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159157117"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:06:20 -0700
Message-ID: <18491db5-2e9b-4914-9464-87166a83ffde@intel.com>
Date: Wed, 23 Jul 2025 21:06:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 02/22] KVM: x86: Have all vendor neutral sub-configs
 depend on KVM_X86, not just KVM
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
 <20250723104714.1674617-3-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-3-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/2025 6:46 PM, Fuad Tabba wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Make all vendor neutral KVM x86 configs depend on KVM_X86, not just KVM,
> i.e. gate them on at least one vendor module being enabled and thus on
> kvm.ko actually being built.  Depending on just KVM allows the user to
> select the configs even though they won't actually take effect, and more
> importantly, makes it all too easy to create unmet dependencies.  E.g.
> KVM_GENERIC_PRIVATE_MEM can't be selected by KVM_SW_PROTECTED_VM, because
> the KVM_GENERIC_MMU_NOTIFIER dependency is select by KVM_X86.
> 
> Hiding all sub-configs when neither KVM_AMD nor KVM_INTEL is selected also
> helps communicate to the user that nothing "interesting" is going on, e.g.
> 
>    --- Virtualization
>    <M>   Kernel-based Virtual Machine (KVM) support
>    < >   KVM for Intel (and compatible) processors support
>    < >   KVM for AMD processors support

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/kvm/Kconfig | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 2c86673155c9..9895fc3cd901 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -74,7 +74,7 @@ config KVM_WERROR
>   	# FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires special tuning.
>   	# Building KVM with -Werror and KASAN is still doable via enabling
>   	# the kernel-wide WERROR=y.
> -	depends on KVM && ((EXPERT && !KASAN) || WERROR)
> +	depends on KVM_X86 && ((EXPERT && !KASAN) || WERROR)
>   	help
>   	  Add -Werror to the build flags for KVM.
>   
> @@ -83,7 +83,7 @@ config KVM_WERROR
>   config KVM_SW_PROTECTED_VM
>   	bool "Enable support for KVM software-protected VMs"
>   	depends on EXPERT
> -	depends on KVM && X86_64
> +	depends on KVM_X86 && X86_64
>   	help
>   	  Enable support for KVM software-protected VMs.  Currently, software-
>   	  protected VMs are purely a development and testing vehicle for
> @@ -169,7 +169,7 @@ config KVM_AMD_SEV
>   config KVM_IOAPIC
>   	bool "I/O APIC, PIC, and PIT emulation"
>   	default y
> -	depends on KVM
> +	depends on KVM_X86
>   	help
>   	  Provides support for KVM to emulate an I/O APIC, PIC, and PIT, i.e.
>   	  for full in-kernel APIC emulation.
> @@ -179,7 +179,7 @@ config KVM_IOAPIC
>   config KVM_SMM
>   	bool "System Management Mode emulation"
>   	default y
> -	depends on KVM
> +	depends on KVM_X86
>   	help
>   	  Provides support for KVM to emulate System Management Mode (SMM)
>   	  in virtual machines.  This can be used by the virtual machine
> @@ -189,7 +189,7 @@ config KVM_SMM
>   
>   config KVM_HYPERV
>   	bool "Support for Microsoft Hyper-V emulation"
> -	depends on KVM
> +	depends on KVM_X86
>   	default y
>   	help
>   	  Provides KVM support for emulating Microsoft Hyper-V.  This allows KVM
> @@ -203,7 +203,7 @@ config KVM_HYPERV
>   
>   config KVM_XEN
>   	bool "Support for Xen hypercall interface"
> -	depends on KVM
> +	depends on KVM_X86
>   	help
>   	  Provides KVM support for the hosting Xen HVM guests and
>   	  passing Xen hypercalls to userspace.
> @@ -213,7 +213,7 @@ config KVM_XEN
>   config KVM_PROVE_MMU
>   	bool "Prove KVM MMU correctness"
>   	depends on DEBUG_KERNEL
> -	depends on KVM
> +	depends on KVM_X86
>   	depends on EXPERT
>   	help
>   	  Enables runtime assertions in KVM's MMU that are too costly to enable
> @@ -228,7 +228,7 @@ config KVM_EXTERNAL_WRITE_TRACKING
>   
>   config KVM_MAX_NR_VCPUS
>   	int "Maximum number of vCPUs per KVM guest"
> -	depends on KVM
> +	depends on KVM_X86
>   	range 1024 4096
>   	default 4096 if MAXSMP
>   	default 1024



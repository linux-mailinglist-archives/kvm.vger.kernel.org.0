Return-Path: <kvm+bounces-68601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F6CD3C3F6
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DCFC0528D35
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1DC23D1CB2;
	Tue, 20 Jan 2026 09:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Aam//2ns"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4B73C1FF4;
	Tue, 20 Jan 2026 09:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768901107; cv=none; b=rJ8ySPgkT4sSWydIuafMHEfqQbCdN1+ILpk17Mwm8ww4mqS4NeUJwZH8ujpBJ/QtdRyxNufXJRBDFxfkXMnIeBpEUS6BncrQ4eVTahnSjAeGjoBIZA3+AkLrZUxMDPMdizN5dqimP9siNhJWNsmVTOz2Ee1k0S+ghVLfJm2ROG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768901107; c=relaxed/simple;
	bh=nhPK1JZXUenL4rQIQZipg6x9EzUXxz3bTri22sH14mg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FbU1mwCw6FLhRSonPckTUNQQBIhATGFMsPYhHJhexbE0bPTur+kT8SyRPgC6soocLxN1One+YVQXeYgmwyOVf3qeY0uElao5wKTQVpCDE6eUMS8csR9aQpTXoTZnJpsEeLy1saLJrYvfG8zwRLyJB5JmjuE6j3wBBYx9EcyQxPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Aam//2ns; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768901104; x=1800437104;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nhPK1JZXUenL4rQIQZipg6x9EzUXxz3bTri22sH14mg=;
  b=Aam//2ns1yX4x8ajsGXyLKNvrzAwHzyPQ+hqBAVW0XdaWTZ+xWnvq077
   qlOR8rgu/0sLpKU9ZNNJREz5j2vD1p1dkJ4lz9bie1prwxfnkygiZt4wc
   Bb/MGkDVK6fS/SUaRFgQOrnSsa0/PNRgm1Ah3ZibnaHIx5O1HLf/6geKx
   yVTOMq+FAjVJDfeVp0T0aGUsK788XApQqyB3rFYiMTUZWw2xY+qP9eMVY
   5CzjJXZwVhwa9HyXjO7ByHSvfKi5aqFpKa6sccVerwnyXSry3iCmE7j7F
   UJsIQHqpib7ttMucaVufz/vRiA6hnZ2XXmC08yyq4YdEoqKEkq8P9LbJP
   g==;
X-CSE-ConnectionGUID: Fb8LSbVaRmyL70HqmEMhjw==
X-CSE-MsgGUID: P/9uDl+8Qbi8oby6+MFaBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="87686783"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="87686783"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 01:25:01 -0800
X-CSE-ConnectionGUID: wm8UANGbTzCReE+X9c/XoA==
X-CSE-MsgGUID: 774Q/J0wTkeRV4zJ24xUkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="236759098"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 01:24:57 -0800
Message-ID: <81bb8149-45c7-472a-a240-46d43bd33b5d@linux.intel.com>
Date: Tue, 20 Jan 2026 17:24:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 02/22] KVM: VMX: Initialize VM entry/exit FRED controls
 in vmcs_config
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
 corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
 hch@infradead.org, sohil.mehta@intel.com
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-3-xin@zytor.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251026201911.505204-3-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/27/2025 4:18 AM, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Setup VM entry/exit FRED controls in the global vmcs_config for proper
> FRED VMCS fields management:
>   1) load guest FRED state upon VM entry.
>   2) save guest FRED state during VM exit.
>   3) load host FRED state during VM exit.
> 

Nit:
I think it's worth noting that IA32_FRED_RSP0 and IA32_FRED_SSP0 are treated
differently. The change log might need more context on which MSRs are
atomically switched in order to describe that though.
  

> Also add FRED control consistency checks to the existing VM entry/exit
> consistency check framework.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> 
> Signed-off-by: Xin Li <xin3.li@intel.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> ---
> 
> Change in v5:
> * Remove the pair VM_ENTRY_LOAD_IA32_FRED/VM_EXIT_ACTIVATE_SECONDARY_CONTROLS,
>   since the secondary VM exit controls are unconditionally enabled anyway, and
>   there are features other than FRED needing it (Chao Gao).
> * Add TB from Xuelian Guo.
> 
> Change in v4:
> * Do VM exit/entry consistency checks using the new macro from Sean
>   Christopherson.
> 
> Changes in v3:
> * Add FRED control consistency checks to the existing VM entry/exit
>   consistency check framework (Sean Christopherson).
> * Just do the unnecessary FRED state load/store on every VM entry/exit
>   (Sean Christopherson).
> ---
>  arch/x86/include/asm/vmx.h | 4 ++++
>  arch/x86/kvm/vmx/vmx.c     | 2 ++
>  arch/x86/kvm/vmx/vmx.h     | 7 +++++--
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 1f60c04d11fb..dd79d027ea70 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -109,6 +109,9 @@
>  #define VM_EXIT_LOAD_CET_STATE                  0x10000000
>  #define VM_EXIT_ACTIVATE_SECONDARY_CONTROLS	0x80000000
>  
> +#define SECONDARY_VM_EXIT_SAVE_IA32_FRED	BIT_ULL(0)
> +#define SECONDARY_VM_EXIT_LOAD_IA32_FRED	BIT_ULL(1)
> +
>  #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
>  
>  #define VM_ENTRY_LOAD_DEBUG_CONTROLS            0x00000004
> @@ -122,6 +125,7 @@
>  #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
>  #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
>  #define VM_ENTRY_LOAD_CET_STATE                 0x00100000
> +#define VM_ENTRY_LOAD_IA32_FRED			0x00800000
>  
>  #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8de841c9c905..be48ba2d70e1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2622,6 +2622,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  		u32 entry_control;
>  		u64 exit_control;
>  	} const vmcs_entry_exit2_pairs[] = {
> +		{ VM_ENTRY_LOAD_IA32_FRED,
> +			SECONDARY_VM_EXIT_SAVE_IA32_FRED | SECONDARY_VM_EXIT_LOAD_IA32_FRED },
>  	};
>  
>  	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 349d96e68f96..645b0343e88c 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -487,7 +487,8 @@ static inline u8 vmx_get_rvi(void)
>  	 VM_ENTRY_LOAD_BNDCFGS |					\
>  	 VM_ENTRY_PT_CONCEAL_PIP |					\
>  	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
> -	 VM_ENTRY_LOAD_CET_STATE)
> +	 VM_ENTRY_LOAD_CET_STATE |					\
> +	 VM_ENTRY_LOAD_IA32_FRED)
>  
>  #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
>  	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
> @@ -514,7 +515,9 @@ static inline u8 vmx_get_rvi(void)
>  	       VM_EXIT_ACTIVATE_SECONDARY_CONTROLS)
>  
>  #define KVM_REQUIRED_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
> -#define KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
> +#define KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS			\
> +	     (SECONDARY_VM_EXIT_SAVE_IA32_FRED |			\
> +	      SECONDARY_VM_EXIT_LOAD_IA32_FRED)
>  
>  #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
>  	(PIN_BASED_EXT_INTR_MASK |					\



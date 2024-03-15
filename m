Return-Path: <kvm+bounces-11913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC36287D045
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 16:29:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D69BB20FB4
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 15:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FAD3D97F;
	Fri, 15 Mar 2024 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l8LH/gLD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6092E3BB52;
	Fri, 15 Mar 2024 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516585; cv=none; b=e8Zx/DrIgmZ6Q352wRHXq6fgLmllO54/JiwoC7BRwWJOw/U67Cd0lajLlrO9xOL4H3wvKjEX0UaFgiTuIGbw+n5BAgaAGvbUaKJSAj2vxuCsQfH0cHFhY1wTP8dMruzIbwFy81FVuNfyMgfqZMrWTpH004+XJHZ2tVc9fMsUrbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516585; c=relaxed/simple;
	bh=R06mqMbste955QlwqLX6TcfFJJQGgckIMGrx9d9a80A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QGKGAjiwtK9i/PCWGFYALk1pppHzehFOBv7yNmU9+eheM+LHQ+ul1zIOXXx75abXOn3mc/sirNybhNSUNjVeVqkDmY1oGEx7N2W64z29Fy3lSwwkTekCBiCZM1/lB8NLM87VOTr4milM//DVy4OM/3QSEGq713/Y8Hw/qKcEImE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l8LH/gLD; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710516584; x=1742052584;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R06mqMbste955QlwqLX6TcfFJJQGgckIMGrx9d9a80A=;
  b=l8LH/gLDv7U8YUwv4T4TSj4d/so5mOoKE0eqnbsfizQHFm1r8tnspbr/
   nNGuOeUDqxIBWETVipiqGJqQ9FAZ/jvGFGgggBImtUxp15qUvrGqXyl8p
   r8vKOX/YoR21zkmyB2JDQKb6fF6gxxxyd/INkEYxAifsJT4dEzWKy4bB5
   jh6/onCrlBFNOPCM3cLk+u5FU4owwdGVIZ0y79vT4p2S+jfwV4aZRhM2i
   PZ+o/H2PkPID6wa3wY8UElavm85FAvE5EJDUyZi9u9fxzK5uQVYoaoHad
   3V7xzmpZSGoUJEpBaSnKDhNutoqGBJpbomeC5PJiSmwy8pHkwXl8Rqxl1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="5258682"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="5258682"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 08:29:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="13155903"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 15 Mar 2024 08:29:39 -0700
Date: Fri, 15 Mar 2024 23:43:29 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Shan Kang <shan.kang@intel.com>,
	Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Subject: Re: [PATCH v6 7/9] KVM VMX: Move MSR_IA32_VMX_MISC bit defines to
 asm/vmx.h
Message-ID: <ZfRsoQQFWqSxJIfs@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-8-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240309012725.1409949-8-seanjc@google.com>

On Fri, Mar 08, 2024 at 05:27:23PM -0800, Sean Christopherson wrote:
> Date: Fri,  8 Mar 2024 17:27:23 -0800
> From: Sean Christopherson <seanjc@google.com>
> Subject: [PATCH v6 7/9] KVM VMX: Move MSR_IA32_VMX_MISC bit defines to
>  asm/vmx.h
> X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
> 
> Move the handful of MSR_IA32_VMX_MISC bit defines that are currently in
> msr-indx.h to vmx.h so that all of the VMX_MISC defines and wrappers can
> be found in a single location.
> 
> Opportunistically use BIT_ULL() instead of open coding hex values, add
> defines for feature bits that are architectural defined, and move the
> defines down in the file so that they are colocated with the helpers for
> getting fields from VMX_MISC.
> 
> No functional change intended.
> 
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/msr-index.h |  5 -----
>  arch/x86/include/asm/vmx.h       | 19 ++++++++++++-------
>  arch/x86/kvm/vmx/capabilities.h  |  4 ++--
>  arch/x86/kvm/vmx/nested.c        |  2 +-
>  arch/x86/kvm/vmx/nested.h        |  2 +-
>  5 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 5ca81ad509b5..3531856def3d 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1138,11 +1138,6 @@
>  #define MSR_IA32_SMBA_BW_BASE		0xc0000280
>  #define MSR_IA32_EVT_CFG_BASE		0xc0000400
>  
> -/* MSR_IA32_VMX_MISC bits */
> -#define MSR_IA32_VMX_MISC_INTEL_PT                 (1ULL << 14)
> -#define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS (1ULL << 29)
> -#define MSR_IA32_VMX_MISC_PREEMPTION_TIMER_SCALE   0x1F
> -
>  /* AMD-V MSRs */
>  #define MSR_VM_CR                       0xc0010114
>  #define MSR_VM_IGNNE                    0xc0010115
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index ce6d166fc3c5..6ff179b11235 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -120,13 +120,6 @@
>  
>  #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
>  
> -#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
> -#define VMX_MISC_SAVE_EFER_LMA			0x00000020
> -#define VMX_MISC_ACTIVITY_HLT			0x00000040
> -#define VMX_MISC_ACTIVITY_WAIT_SIPI		0x00000100
> -#define VMX_MISC_ZERO_LEN_INS			0x40000000
> -#define VMX_MISC_MSR_LIST_MULTIPLIER		512
> -
>  /* VMFUNC functions */
>  #define VMFUNC_CONTROL_BIT(x)	BIT((VMX_FEATURE_##x & 0x1f) - 28)
>  
> @@ -155,6 +148,18 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
>  	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
>  }
>  
> +#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
> +#define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
> +#define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
> +#define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
> +#define VMX_MISC_ACTIVITY_WAIT_SIPI		BIT_ULL(8)
> +#define VMX_MISC_INTEL_PT			BIT_ULL(14)
> +#define VMX_MISC_RDMSR_IN_SMM			BIT_ULL(15)
> +#define VMX_MISC_VMXOFF_BLOCK_SMI		BIT_ULL(28)
> +#define VMX_MISC_VMWRITE_SHADOW_RO_FIELDS	BIT_ULL(29)
> +#define VMX_MISC_ZERO_LEN_INS			BIT_ULL(30)
> +#define VMX_MISC_MSR_LIST_MULTIPLIER		512
> +

Maybe it's better to mention this patch also define some new bits:

* VMX_MISC_ACTIVITY_SHUTDOWN
* VMX_MISC_RDMSR_IN_SMM
* VMX_MISC_VMXOFF_BLOCK_SMI

Otherwise,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>



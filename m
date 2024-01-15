Return-Path: <kvm+bounces-6217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B967E82D688
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 10:59:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DB6D1F23599
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 09:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892DC1A27E;
	Mon, 15 Jan 2024 09:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M8ibVKFt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052B8F9F8;
	Mon, 15 Jan 2024 09:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705312740; x=1736848740;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FnC/nZmuddUBdeG5Xm4UWpZ9OeT15rIVRGGhetceRDc=;
  b=M8ibVKFt81ttoz/VFtoWuMdTzr47RGfytE30SBfxQR+2kTqHvbx3DY9N
   LOGDQR9Cxhs8o6cbq9KJtqss37WmjeQLQXblIR17e3Z+71gSVuUGwiuZP
   Z/Nx6kvNmtSysf6i9SGMSM0tPJzby/QbFuPVb/Z68l6ZvlN35+hMAKCON
   c0S/WWj0aHUc76pYzqVO4S6Dl548Z2M4BkMk5Inw4e/TaNRY1CYz4P8cj
   JvzR3VRx/gDCqAztSyZ5MT8YmGB8eiGs/eBxEJVGap1lJ6auAd1EPE4e1
   VXbXEsrCD03/EDiKNotrmH6uwFNBoyRphaGFCMzxrQxrRaehQFjB8gDGh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="396721364"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="396721364"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 01:58:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="907012613"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="907012613"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga004.jf.intel.com with ESMTP; 15 Jan 2024 01:58:55 -0800
Date: Mon, 15 Jan 2024 17:58:54 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	peterz@infradead.org, chao.gao@intel.com,
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com
Subject: Re: [PATCH v8 22/26] KVM: VMX: Set up interception for CET MSRs
Message-ID: <20240115095854.s4smn4ppfjfa2q2z@yy-desk-7060>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-23-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231221140239.4349-23-weijiang.yang@intel.com>
User-Agent: NeoMutt/20171215

On Thu, Dec 21, 2023 at 09:02:35AM -0500, Yang Weijiang wrote:
> Enable/disable CET MSRs interception per associated feature configuration.
> Shadow Stack feature requires all CET MSRs passed through to guest to make
> it supported in user and supervisor mode while IBT feature only depends on
> MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
>
> Note, this MSR design introduced an architectural limitation of SHSTK and
> IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
> to guest from architectual perspective since IBT relies on subset of SHSTK
> relevant MSRs.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 064a5fe87948..08058b182893 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -692,6 +692,10 @@ static bool is_valid_passthrough_msr(u32 msr)
>  	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>  		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
>  		return true;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> +		return true;
>  	}
>
>  	r = possible_passthrough_msr_slot(msr) != -ENOENT;
> @@ -7767,6 +7771,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>  		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>  }
>
> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
> +{
> +	bool incpt;
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> +
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		if (guest_cpuid_has(vcpu, X86_FEATURE_LM))

Looks this leading to MSR_IA32_INT_SSP_TAB not intercepted
after below steps:

Step 1. User space set cpuid w/  X86_FEATURE_LM, w/  SHSTK.
Step 2. User space set cpuid w/o X86_FEATURE_LM, w/o SHSTK.

Then MSR_IA32_INT_SSP_TAB won't be intercepted even w/o SHSTK
on guest cpuid, will this lead to inconsistency when do
rdmsr(MSR_IA32_INT_SSP_TAB) from guest in this scenario ?

> +			vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
> +						  MSR_TYPE_RW, incpt);
> +		if (!incpt)
> +			return;
> +	}
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
> +
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
> +					  MSR_TYPE_RW, incpt);
> +	}
> +}
> +
>  static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7845,6 +7885,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>
>  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>  	vmx_update_exception_bitmap(vcpu);
> +
> +	vmx_update_intercept_for_cet_msr(vcpu);
>  }
>
>  static u64 vmx_get_perf_capabilities(void)
> --
> 2.39.3
>
>


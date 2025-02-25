Return-Path: <kvm+bounces-39091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE66A4358E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 07:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DF2E189A5B8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 06:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A921257436;
	Tue, 25 Feb 2025 06:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O2OkrZlE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF8314D2BB;
	Tue, 25 Feb 2025 06:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740465804; cv=none; b=fkohm8cQsl4OesKFajtd2FuQQleCwSqGluR0yDzZUgXIArbffKPVsSRWqamSd578dJDXpnnNTvnBUttfpbaDt4WXthdS0ace+5QjLGfRNQ6fh5U5kKGZTdYe70s4mMjjQ0+qR5oYqXcqLLulaSvX90i69Fverp25EUbrZKIL0EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740465804; c=relaxed/simple;
	bh=zhSa0y8IU1iJ0MvV+FSzR83Oi1hhyhyeq0st+ZunzWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=psAcVYSzAoxnDRQ9bWVl84Nz52UM8RmD+asBWxHqiJUygI5vnXtBtLOPCewJxu7tT1s5Rd/3VHBsbn+8lIk7EE7FhBIYKvwHcEiF4lVECW7PxC8kSQzacpUl40WsWvwCLbH9Jsw/sNzvfggMY9zPYaKh6L1E+ZekILkVDcc9piw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O2OkrZlE; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740465804; x=1772001804;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zhSa0y8IU1iJ0MvV+FSzR83Oi1hhyhyeq0st+ZunzWA=;
  b=O2OkrZlEv3hFUxRIhkhKiT8II0Y9T015h+lWX5Ka08lkKCI1pPRNpiuY
   DNEHweeoYOKn8wdpiu2n8wSEXO7Iol5Fga2OJxGkhRD/xKPhpoQ7+DMCr
   /fk2uaHw6FfHhUh18gamYK60tu69nNFPaVp0TYWqUOBtQO4BsM2CTmjOY
   HEzf34e/+DZ9fqo9aiQ5+Cb+hHdamrvhrtQ8iFgmo3c8isPgMQZZ8Er0E
   c3bFA0B4Np4z60uaCfKwRB2/1wFiYTjW2yz6U5P2JaWHOjr9O401wGVIP
   Tn1bXRt7j/xfQogw9FSzWDXNZ0BYhgc20M9TXLxpILTEJW01lm74HoU57
   g==;
X-CSE-ConnectionGUID: L4k/Mr8pR/KrDiLkz+TY0g==
X-CSE-MsgGUID: tBDgIpEWQZ2hDOTPdj+VPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11355"; a="41101477"
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="41101477"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 22:43:23 -0800
X-CSE-ConnectionGUID: LxPxWLFrQf6SAGthAv49eA==
X-CSE-MsgGUID: trZNmStcS9WTJllyoPVHvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="147130898"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 22:43:17 -0800
Message-ID: <5cbb181c-f226-4d50-8b92-04775e8b65e0@intel.com>
Date: Tue, 25 Feb 2025 14:43:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 07/12] KVM: TDX: restore host xsave state when exit
 from the guest TD
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-8-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250129095902.16391-8-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/29/2025 5:58 PM, Adrian Hunter wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> On exiting from the guest TD, xsave state is clobbered.  Restore xsave
> state on TD exit.
> 
> Set up guest state so that existing kvm_load_host_xsave_state() can be
> used. Do not allow VCPU entry if guest state conflicts with the TD's
> configuration.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
> TD vcpu enter/exit v2:
>   - Drop PT and CET feature flags (Chao)
>   - Use cpu_feature_enabled() instead of static_cpu_has() (Chao)
>   - Restore PKRU only if the host value differs from defined
>     exit value (Chao)
>   - Use defined masks to separate XFAM bits into XCR0/XSS (Adrian)
>   - Use existing kvm_load_host_xsave_state() in place of
>     tdx_restore_host_xsave_state() by defining guest CR4, XCR0, XSS
>     and PKRU (Sean)
>   - Do not enter if vital guest state is invalid (Adrian)
> 
> TD vcpu enter/exit v1:
>   - Remove noinstr on tdx_vcpu_enter_exit() (Sean)
>   - Switch to kvm_host struct for xcr0 and xss
> 
> v19:
>   - Add EXPORT_SYMBOL_GPL(host_xcr0)
> 
> v15 -> v16:
>   - Added CET flag mask
> ---
>   arch/x86/kvm/vmx/tdx.c | 72 ++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 66 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 3f3d61935a58..e4355553569a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -83,16 +83,21 @@ static u64 tdx_get_supported_attrs(const struct tdx_sys_info_td_conf *td_conf)
>   	return val;
>   }
>   
> +/*
> + * Before returning from TDH.VP.ENTER, the TDX Module assigns:
> + *   XCR0 to the TD’s user-mode feature bits of XFAM (bits 7:0, 9, 18:17)
> + *   IA32_XSS to the TD's supervisor-mode feature bits of XFAM (bits 8, 16:10)
> + */
> +#define TDX_XFAM_XCR0_MASK	(GENMASK(7, 0) | BIT(9) | GENMASK(18, 17))
> +#define TDX_XFAM_XSS_MASK	(BIT(8) | GENMASK(16, 10))
> +#define TDX_XFAM_MASK		(TDX_XFAM_XCR0_MASK | TDX_XFAM_XSS_MASK)

No need to define TDX-specific mask for XFAM. kernel defines 
XFEATURE_MASK_* and you can define XFEATURE_XCR0_MASK and 
XFEATURE_XSS_MASK with XFEATURE_MASK_*.

>   static u64 tdx_get_supported_xfam(const struct tdx_sys_info_td_conf *td_conf)
>   {
>   	u64 val = kvm_caps.supported_xcr0 | kvm_caps.supported_xss;
>   
> -	/*
> -	 * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
> -	 * and, CET support.
> -	 */
> -	val |= XFEATURE_MASK_PT | XFEATURE_MASK_CET_USER |
> -	       XFEATURE_MASK_CET_KERNEL;
> +	/* Ensure features are in the masks */
> +	val &= TDX_XFAM_MASK;

It's unncessary.

kvm_caps.supported_xcr0 | kvm_caps.supported_xss must be the subset of 
TDX_XFAM_MASK;

>   	if ((val & td_conf->xfam_fixed1) != td_conf->xfam_fixed1)
>   		return 0;
> @@ -724,6 +729,19 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +
> +	return vcpu->arch.xcr0 != (kvm_tdx->xfam & TDX_XFAM_XCR0_MASK) ||
> +	       vcpu->arch.ia32_xss != (kvm_tdx->xfam & TDX_XFAM_XSS_MASK) ||
> +	       vcpu->arch.pkru ||
> +	       (cpu_feature_enabled(X86_FEATURE_XSAVE) &&
> +		!kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) ||
> +	       (cpu_feature_enabled(X86_FEATURE_XSAVES) &&
> +		!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES));

guest_cpu_cap_has() is better to put into the path when userspace 
configures the vcpu model. So that KVM can return error to userspace 
earlier before running the vcpu.

 > +}> +
>   static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -740,6 +758,8 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>   
>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   {
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
>   	/*
>   	 * force_immediate_exit requires vCPU entering for events injection with
>   	 * an immediately exit followed. But The TDX module doesn't guarantee
> @@ -750,10 +770,22 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   	 */
>   	WARN_ON_ONCE(force_immediate_exit);
>   
> +	if (WARN_ON_ONCE(tdx_guest_state_is_invalid(vcpu))) {
> +		/*
> +		 * Invalid exit_reason becomes KVM_EXIT_INTERNAL_ERROR, refer
> +		 * tdx_handle_exit().
> +		 */
> +		tdx->vt.exit_reason.full = -1u;
> +		tdx->vp_enter_ret = -1u;
> +		return EXIT_FASTPATH_NONE;
> +	}
> +
>   	trace_kvm_entry(vcpu, force_immediate_exit);
>   
>   	tdx_vcpu_enter_exit(vcpu);
>   
> +	kvm_load_host_xsave_state(vcpu);
> +
>   	vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
>   
>   	trace_kvm_exit(vcpu, KVM_ISA_VMX);
> @@ -1878,9 +1910,23 @@ static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>   	return r;
>   }
>   
> +static u64 tdx_guest_cr0(struct kvm_vcpu *vcpu, u64 cr4)
> +{
> +	u64 cr0 = ~CR0_RESERVED_BITS;
> +
> +	if (cr4 & X86_CR4_CET)
> +		cr0 |= X86_CR0_WP;
> +
> +	cr0 |= X86_CR0_PE | X86_CR0_NE;
> +	cr0 &= ~(X86_CR0_NW | X86_CR0_CD);
> +
> +	return cr0;
> +}
> +
>   static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>   {
>   	u64 apic_base;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
>   	int ret;
>   
> @@ -1903,6 +1949,20 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>   	if (ret)
>   		return ret;
>   
> +	vcpu->arch.cr4 = ~vcpu->arch.cr4_guest_rsvd_bits;

when userspace doesn't configure XFEATURE_MASK_PKRU in XFAM, it seems 
kvm_load_host_xsave_state() will skip restore host's PKRU value.

Besides, vcpu->arch.cr4_guest_rsvd_bits depends on KVM_SET_CPUID*, we 
need enfore the dependency that tdx_vcpu_init() needs to be called after 
vcpu model is configured.

> +	vcpu->arch.cr0 = tdx_guest_cr0(vcpu, vcpu->arch.cr4);
> +	/*
> +	 * On return from VP.ENTER, the TDX Module sets XCR0 and XSS to the
> +	 * maximal values supported by the guest, and zeroes PKRU, so from
> +	 * KVM's perspective, those are the guest's values at all times.
> +	 */

It's better to also call out that this is only to make 
kvm_load_host_xsave_state() work for TDX. They don't represent the real 
guest value.

> +	vcpu->arch.ia32_xss = kvm_tdx->xfam & TDX_XFAM_XSS_MASK;
> +	vcpu->arch.xcr0 = kvm_tdx->xfam & TDX_XFAM_XCR0_MASK;
> +	vcpu->arch.pkru = 0;
> +
> +	/* TODO: freeze vCPU model before kvm_update_cpuid_runtime() */
> +	kvm_update_cpuid_runtime(vcpu);
> +
>   	tdx->state = VCPU_TD_STATE_INITIALIZED;
>   
>   	return 0;



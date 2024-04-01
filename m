Return-Path: <kvm+bounces-13281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EE16893D22
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 17:50:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7B4528165C
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 15:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B5B47A62;
	Mon,  1 Apr 2024 15:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPzvmXCn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C900D47772;
	Mon,  1 Apr 2024 15:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986592; cv=none; b=BtVkJ3n8bb/nyb9/5yDJyC8E8RHA9gKhS0PgE75uNguT3f9wtqBOMnScFIBMubhFSQLujVr3+W0LEUnCheG7J+sTA5DaOMSfsH4LEBZieqJhHvKOBkOPN5tPmJ1Jd2vKJIDieh6Waxsl34R6K1e6q/uyTrCdPO+jvdPuKzQxdaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986592; c=relaxed/simple;
	bh=cKwZwSgMO3iwMGS0fBSShtKckUnmLG4vV6uS8ze9XNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oeaOMJ+glJ6Rd6tedxFjyWaH0D1GKTQwmKD5WMelxWbFNaTUDMKI5xWYP3aLvdLNMAV0NxP5E0GUROSXsrbOUIiksvyv7Vw2xefUyrUtRSSJUei9RiTC4moSg39ksLCVHKWxBTe/Nvtw8dkWun0xpTbYr4/2xUx0lWTxaEv73UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPzvmXCn; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711986590; x=1743522590;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cKwZwSgMO3iwMGS0fBSShtKckUnmLG4vV6uS8ze9XNw=;
  b=VPzvmXCnaNTPeV9iQMKxA9k3F0kVcljHWMo2ujbLMSJYb899gbq2s1SP
   bJXmqGHIvGfMWQLvOZwYWhTdKa/0RQpNevuQ5m+iN26Wl0HrNs95SlinP
   NHNcgmgwO+z3wT4TCAJf1vO2ic9arO2gHGseWd2ntXqvVJRJsGiYYoJnq
   oC0LCCccZbFxiik2D75sYZXvCk1bea075MDrT0AUOeErFkKrocSEMQClQ
   MY74xEg/oeHPQEJRl6hWuMhigZPlKaMvwtDtYyUMm/YegoXfG35TZ/uvT
   uZ5O9jlex9TsUXYqLhEC2BFyVrmZleToNufJL5ordWhNFZduPPilmAHtP
   g==;
X-CSE-ConnectionGUID: jJCJw5gOTGWquGpoYMepxA==
X-CSE-MsgGUID: OQ0t/Tp4QSq9a/qPbWqtwQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="17738552"
X-IronPort-AV: E=Sophos;i="6.07,172,1708416000"; 
   d="scan'208";a="17738552"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 08:49:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,172,1708416000"; 
   d="scan'208";a="22243457"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 08:49:45 -0700
Message-ID: <331fbd0d-f560-4bde-858f-e05678b42ff0@linux.intel.com>
Date: Mon, 1 Apr 2024 23:49:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 067/130] KVM: TDX: Add load_mmu_pgd method for TDX
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <bef7033b687e75c5436c0aee07691327d36734ea.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <bef7033b687e75c5436c0aee07691327d36734ea.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> For virtual IO, the guest TD shares guest pages with VMM without
> encryption.

Virtual IO is a use case of shared memory, it's better to use it
as a example instead of putting it at the beginning of the sentence.


>   Shared EPT is used to map guest pages in unprotected way.
>
> Add the VMCS field encoding for the shared EPTP, which will be used by
> TDX to have separate EPT walks for private GPAs (existing EPTP) versus
> shared GPAs (new shared EPTP).
>
> Set shared EPT pointer value for the TDX guest to initialize TDX MMU.
May have a mention that the EPTP for priavet GPAs is set by TDX module.

>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> v19:
> - Add WARN_ON_ONCE() to tdx_load_mmu_pgd() and drop unconditional mask
> ---
>   arch/x86/include/asm/vmx.h |  1 +
>   arch/x86/kvm/vmx/main.c    | 13 ++++++++++++-
>   arch/x86/kvm/vmx/tdx.c     |  6 ++++++
>   arch/x86/kvm/vmx/x86_ops.h |  4 ++++
>   4 files changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index f703bae0c4ac..9deb663a42e3 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -236,6 +236,7 @@ enum vmcs_field {
>   	TSC_MULTIPLIER_HIGH             = 0x00002033,
>   	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
>   	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
> +	SHARED_EPT_POINTER		= 0x0000203C,
>   	PID_POINTER_TABLE		= 0x00002042,
>   	PID_POINTER_TABLE_HIGH		= 0x00002043,
>   	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index d0f75020579f..076a471d9aea 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -123,6 +123,17 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	vmx_vcpu_reset(vcpu, init_event);
>   }
>   
> +static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> +			int pgd_level)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
> +		return;
> +	}
> +
> +	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
> +}
> +
>   static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -256,7 +267,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.write_tsc_offset = vmx_write_tsc_offset,
>   	.write_tsc_multiplier = vmx_write_tsc_multiplier,
>   
> -	.load_mmu_pgd = vmx_load_mmu_pgd,
> +	.load_mmu_pgd = vt_load_mmu_pgd,
>   
>   	.check_intercept = vmx_check_intercept,
>   	.handle_exit_irqoff = vmx_handle_exit_irqoff,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 54e0d4efa2bd..143a3c2a16bc 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -453,6 +453,12 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	 */
>   }
>   
> +void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
> +{
> +	WARN_ON_ONCE(root_hpa & ~PAGE_MASK);
> +	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
> +}
> +
>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>   {
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index f5820f617b2e..24161fa404aa 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -152,6 +152,8 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>   
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> +
> +void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
>   #else
>   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
>   static inline void tdx_hardware_unsetup(void) {}
> @@ -173,6 +175,8 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>   
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
> +
> +static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
>   #endif
>   
>   #endif /* __KVM_X86_VMX_X86_OPS_H */



Return-Path: <kvm+bounces-7957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B90584925B
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 03:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC5041F22217
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 02:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FA49474;
	Mon,  5 Feb 2024 02:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J1bgsNOE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3FD8F40;
	Mon,  5 Feb 2024 02:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707099823; cv=none; b=YFKyNUae8Nw0a6Vs+7Y7Xad4otfe1VlCY3DkfTJVkIs6rjHiVjmK4dkgo4mnJcmpHJf/AjMQt+U7IbOO96LX82cU/SBjysbxb2vMuFPqpQe8DRmAXnXx1NCO4Grqr8SMNIZ7q9IYi9HdxVsukcDnNTvEftSvEMzS16m7lNeIDGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707099823; c=relaxed/simple;
	bh=eDvLloA0UC+So4VeM9r+vgAoeJio7JKaXwdr8C6kQrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aPGROojLX+fzO2jYs1pQkxRyzWYa4W968swqUQOq5THn+DamIM0LbDyYXJQldPQDVmL58R+9MNevG5ef+J6CN5XzuFNMfa6y99H4ssN6nxke7t+PaGLg+1MxfDkBoB5hXtg+8Hl19yk5sGiucHzGlP1bsoU26GhmbC2/+XSxlBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J1bgsNOE; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707099822; x=1738635822;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eDvLloA0UC+So4VeM9r+vgAoeJio7JKaXwdr8C6kQrc=;
  b=J1bgsNOEg2UCzVuXUKr4dB3peUv7e0nWtyQuSoZe7vd9hg4/xQUO9Hg6
   tpMLqvQ9LiCB5PLmZ/sY5Q4LGUXRM538jmiluWteFvHaQcONGWVW8jxRv
   OVsLU/zS2Ugxmps1qyyD+3CBs3uQJ+HJEJZ6qfPBnGqCzbRLZEwF304ht
   +jVHQkGAJtDDEIIssxgytjWEi1b3+ob5Qjui04wlIz/OsWtOj9KRNNPhG
   Qd2W7UIj5fajeT1VSzhVTWMZXGh8ahcGSK81riI3QyFPpWZo1sF9GO0mW
   ZGUUW5OaHa5L1GFHGZNTRKFAgfQjDVtIGlSlgMdOmwNQvj0/QLVOiSdPC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="11174543"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="11174543"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 18:23:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="38013264"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 18:23:37 -0800
Message-ID: <9d024bfc-4b1d-4da5-81ba-36e60cf5e284@linux.intel.com>
Date: Mon, 5 Feb 2024 10:23:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 057/121] KVM: TDX: Add load_mmu_pgd method for TDX
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <bd5256f2f58c36c6e8712e8137525815eede3bc8.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <bd5256f2f58c36c6e8712e8137525815eede3bc8.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> For virtual IO, the guest TD shares guest pages with VMM without
> encryption.  Shared EPT is used to map guest pages in unprotected way.
>
> Add the VMCS field encoding for the shared EPTP, which will be used by
> TDX to have separate EPT walks for private GPAs (existing EPTP) versus
> shared GPAs (new shared EPTP).
>
> Set shared EPT pointer value for the TDX guest to initialize TDX MMU.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/vmx.h |  1 +
>   arch/x86/kvm/vmx/main.c    | 13 ++++++++++++-
>   arch/x86/kvm/vmx/tdx.c     |  5 +++++
>   arch/x86/kvm/vmx/x86_ops.h |  4 ++++
>   4 files changed, 22 insertions(+), 1 deletion(-)
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
> index 8059b44ed159..f55ac09edc60 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -147,6 +147,17 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
> @@ -279,7 +290,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.write_tsc_offset = vmx_write_tsc_offset,
>   	.write_tsc_multiplier = vmx_write_tsc_multiplier,
>   
> -	.load_mmu_pgd = vmx_load_mmu_pgd,
> +	.load_mmu_pgd = vt_load_mmu_pgd,
>   
>   	.check_intercept = vmx_check_intercept,
>   	.handle_exit_irqoff = vmx_handle_exit_irqoff,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 59d170709f82..25510b6740a3 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -501,6 +501,11 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	 */
>   }
>   
> +void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
> +{
> +	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);

If we have concern about the alignment of root_hpa, shouldn't we do some
check instead of masking the address quietly?

> +}
> +
>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>   {
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 5f8ee1c93cd1..a9e5caf880dd 100644
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



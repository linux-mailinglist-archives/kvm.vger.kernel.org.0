Return-Path: <kvm+bounces-41019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C3FA6078B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 03:36:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0DFD177C0D
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 02:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904CB42AA3;
	Fri, 14 Mar 2025 02:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YY3zkSNS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34E82E3364;
	Fri, 14 Mar 2025 02:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741919810; cv=none; b=kDAYxHCmUMPJVqRIGbf/QI997JP08PyrKtVK/DcRPZWo6Ar+2lUaMlQoMM0XsVdztvQWFsknfvRtCa/X223ZOdku1UCrbpEOQmSJPgFrUOP5nQhpDmMlbKrZpkGbnJnI9nmq3DHNPpty5mVRsqILKubvSSqPFC7lvF/dGMPTwLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741919810; c=relaxed/simple;
	bh=LnanVkXfTh7RXO0JmowPIVzjCd7u/lrefAHiW1FCTnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fw4DmroO1Mvc/WixxtnKc681GFn4ljte92BX49Fn3AR9JrbrIKl3kgcN2dX1U1ukaviHlwqvwZKVlj4N0UyABO9SVcTe0sMcVi4OMvnj3B4F6A9Uh10N/+4BPUaGKYwafhVJVct0nqiYxuFirWVXZWHzQG34+vqEeY/4Qi1Ezmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YY3zkSNS; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741919809; x=1773455809;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LnanVkXfTh7RXO0JmowPIVzjCd7u/lrefAHiW1FCTnM=;
  b=YY3zkSNSkVZO20W53etL3gw3t+ilFxOuKMVF3NKPvyC916xm/cchKilA
   RufpdxPaYMB1cOmEwtf7dIr+bc9FHtVr+qtBt3yHrVziYmgh+I/P+kky0
   h/6ZfT087epRwCshITwgZhchzh9VP2L5ui9WNv7Giypi8nusEuVrdjVVF
   OVKF/DMBRjkB9abjWPMS0QnKSnpPeq3qyiCubZumhZWMaWEk0p3VVKmht
   1zEP1u838WSRwgNwzhbjftKcAV/9Mhk/l5zxs6A59ZNnDD+peNfCiBRXA
   InVlzNxgZKAvg8US3FgqGFXs0zdBKveuDSA4+eSNtCcJC4tghBfaa/63T
   Q==;
X-CSE-ConnectionGUID: o/WnD/08QaWXCI35+Hy7FA==
X-CSE-MsgGUID: M10xHwAjShCjhDtTRgeHjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="46709641"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="46709641"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 19:36:48 -0700
X-CSE-ConnectionGUID: v+GV0h9WTU6t9RBQ+5IsHg==
X-CSE-MsgGUID: i8iziBRoRuWN4hNhyiJ9pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="122061086"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.54]) ([10.124.240.54])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 19:36:46 -0700
Message-ID: <24ada86a-131f-4624-8333-baa37e2a4a67@linux.intel.com>
Date: Fri, 14 Mar 2025 10:36:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] KVM: TDX: Move apicv_pre_state_restore to
 posted_intr.c
To: Vishal Verma <vishal.l.verma@intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20250313-vverma7-cleanup_x86_ops-v1-0-0346c8211a0c@intel.com>
 <20250313-vverma7-cleanup_x86_ops-v1-1-0346c8211a0c@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250313-vverma7-cleanup_x86_ops-v1-1-0346c8211a0c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/14/2025 3:30 AM, Vishal Verma wrote:
> In preparation for a cleanup of the x86_ops struct for TDX, which turns
> several of the ops definitions to macros, move the
> vt_apicv_pre_state_restore() helper into posted_intr.c.
>
> Based on a patch by Sean Christopherson <seanjc@google.com>
>
> Link: https://lore.kernel.org/kvm/Z6v9yjWLNTU6X90d@google.com/
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linxu.intel.com>

> ---
>   arch/x86/kvm/vmx/posted_intr.h |  1 +
>   arch/x86/kvm/vmx/main.c        | 10 +---------
>   arch/x86/kvm/vmx/posted_intr.c |  8 ++++++++
>   3 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
> index 68605ca7ef68..9d0677a2ba0e 100644
> --- a/arch/x86/kvm/vmx/posted_intr.h
> +++ b/arch/x86/kvm/vmx/posted_intr.h
> @@ -11,6 +11,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
>   void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
>   void pi_wakeup_handler(void);
>   void __init pi_init_cpu(int cpu);
> +void pi_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
>   bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
>   int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>   		       uint32_t guest_irq, bool set);
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 320c96e1e80a..9d201ddb794a 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -315,14 +315,6 @@ static void vt_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>   	return vmx_set_virtual_apic_mode(vcpu);
>   }
>   
> -static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
> -{
> -	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
> -
> -	pi_clear_on(pi);
> -	memset(pi->pir, 0, sizeof(pi->pir));
> -}
> -
>   static void vt_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -983,7 +975,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.set_apic_access_page_addr = vt_set_apic_access_page_addr,
>   	.refresh_apicv_exec_ctrl = vt_refresh_apicv_exec_ctrl,
>   	.load_eoi_exitmap = vt_load_eoi_exitmap,
> -	.apicv_pre_state_restore = vt_apicv_pre_state_restore,
> +	.apicv_pre_state_restore = pi_apicv_pre_state_restore,
>   	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
>   	.hwapic_isr_update = vt_hwapic_isr_update,
>   	.sync_pir_to_irr = vt_sync_pir_to_irr,
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index f2ca37b3f606..a140af060bb8 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -241,6 +241,14 @@ void __init pi_init_cpu(int cpu)
>   	raw_spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
>   }
>   
> +void pi_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
> +{
> +	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
> +
> +	pi_clear_on(pi);
> +	memset(pi->pir, 0, sizeof(pi->pir));
> +}
> +
>   bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
>   {
>   	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>



Return-Path: <kvm+bounces-57830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 729DCB7FF90
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 16:28:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63B457B47A0
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 08:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC113093BD;
	Wed, 17 Sep 2025 08:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cL9TFGmG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5D4263F36;
	Wed, 17 Sep 2025 08:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758098934; cv=none; b=AHTnDNdyHFHucDaU8Us34MgW7eQLiQXLZmGh76QlLy8LVSoH/V/SIsMxlnG47qiifj0lPNwJ2OLNZcy+/LFuK2QTnF6ZO0uIE3TKGh1MpTT/cuU3kiZ5j/aDNd23n9CcnonzZdc2Vqn1/Dugm8wUBzQ1K55+35jvv9p4Z1Wwphg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758098934; c=relaxed/simple;
	bh=rixibAhmB5Hqa79X5mnqGdoJxY6e/ufoNf8xrZo5teA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IO0jNJ0DGBVEEvbF1dVTsEgeNikUX2FVwuVWquN1zuVfoJgdcCeTjcImCPFhxDUr7rU4b6224cnhf5o2us/QzEyJlnpFzXAdcw5J70ySX3fXpnnlPKUJIoU0hLTxA4KwGF0HvCeKUY2xWmykrialTQR9Ia9Iq6sd9sLf7xMJYOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cL9TFGmG; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758098933; x=1789634933;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rixibAhmB5Hqa79X5mnqGdoJxY6e/ufoNf8xrZo5teA=;
  b=cL9TFGmGAPkheCAq0euWf8yQBT6k/1HryIJQ1+G9WvPbsQpZFVc2jl+F
   /7Y++aKc8VBrncJFfUIIY/VXrD4kCHsSX2xj2V73qmKfcjZTk0CdXbPUY
   QBH8TaKicnHRiefOFZ2jXp4YALr4F7nRlqkceQ/nEOgx0bAMmAenR9dlB
   H7Rv63U4xEwD11OiVpqZTEJMiZ8NRzWvjBm2k9kU9Nj6AMO6m7i33wjJA
   lCTRpdM6B0hAmBWlZr7H2PrJvKLXyLGLJfNWU4QuTNkN31H9laAUWeIBH
   glqEJlduGz2AopKFC2wghG694XScDCcnXv+I+u0g+tC1z4pmciRK71Zdb
   w==;
X-CSE-ConnectionGUID: 5QmGd1BTSIa3IZjH4DqpIg==
X-CSE-MsgGUID: p5OFSj/jS4yadhy/gozWkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="85836791"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="85836791"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:48:52 -0700
X-CSE-ConnectionGUID: kkSxahJ5Qca8dagxZK2XGA==
X-CSE-MsgGUID: XgMjX2QjQFaifMFquYyRhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="175583667"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:48:49 -0700
Message-ID: <65465d1e-a7bd-4eac-a0ba-8c6cce85e3ed@intel.com>
Date: Wed, 17 Sep 2025 16:48:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 17/41] KVM: VMX: Set host constant supervisor states
 to VMCS fields
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-18-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250912232319.429659-18-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/2025 7:22 AM, Sean Christopherson wrote:
...
> +static inline bool cpu_has_load_cet_ctrl(void)
> +{
> +	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
> +}

When looking at the patch 19, I realize that

   { VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE }

is added into vmcs_entry_exit_pairs[] there.

So ...

>   static inline bool cpu_has_vmx_mpx(void)
>   {
>   	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index adf5af30e537..e8155635cb42 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4320,6 +4320,21 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
>   
>   	if (cpu_has_load_ia32_efer())
>   		vmcs_write64(HOST_IA32_EFER, kvm_host.efer);
> +
> +	/*
> +	 * Supervisor shadow stack is not enabled on host side, i.e.,
> +	 * host IA32_S_CET.SHSTK_EN bit is guaranteed to 0 now, per SDM
> +	 * description(RDSSP instruction), SSP is not readable in CPL0,
> +	 * so resetting the two registers to 0s at VM-Exit does no harm
> +	 * to kernel execution. When execution flow exits to userspace,
> +	 * SSP is reloaded from IA32_PL3_SSP. Check SDM Vol.2A/B Chapter
> +	 * 3 and 4 for details.
> +	 */
> +	if (cpu_has_load_cet_ctrl()) {

... cpu_has_load_cet_ctrl() cannot ensure the existence of host CET 
fields, unless we change it to check vmcs_config.vmexit_ctrl or add CET 
entry_exit pair into the vmcs_entry_exit_pairs[] in this patch.

> +		vmcs_writel(HOST_S_CET, kvm_host.s_cet);
> +		vmcs_writel(HOST_SSP, 0);
> +		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
> +	}
>   }


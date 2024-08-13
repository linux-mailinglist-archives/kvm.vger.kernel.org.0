Return-Path: <kvm+bounces-23952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2A1495010B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 11:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F550287730
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 09:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A064F183CB5;
	Tue, 13 Aug 2024 09:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GoxUe6Qh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C7C3BB47;
	Tue, 13 Aug 2024 09:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723540535; cv=none; b=U26azifrMf1nzCSDH1LLLqYZ1G9dKEfIdQWAw/WNZNsNwlk9aVj042ktphA1gptOTyJEYCIDLPuKlztZ/P0NIyWODx5lWNWbzKigt32IojteliBXCFkP8LFSrW2mhS7j8wS7pOuTm43CgN0sVVHWMSS4l1jwft5kaQ+/uP8qZNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723540535; c=relaxed/simple;
	bh=PKnElOekxHXRG3WvWmm9EC/3/V9TPm4/L/L/JXal7YI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m7Q1nggvMPo7gtSV1DsVRK3TWTt6OWdWz/K/WC4iq3PWi2QEY20llxpNn9UPhXhMQ+wJHeqFe6GNCMVMRjyYUds6Ej9bsuTRPO18OXgEYUhVJDZxTOKyrG4hl4BUF+t73RyO4S2X4PVojINQRbW0xEp1IuZVZN1Fy1+xnHQSITU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GoxUe6Qh; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723540535; x=1755076535;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PKnElOekxHXRG3WvWmm9EC/3/V9TPm4/L/L/JXal7YI=;
  b=GoxUe6QhsvjLbYvlQ2dQbXRQ5s1cSJTuN8ZcohWgxGPUZ/90m3h18QSa
   EhdwDzjDVE83XzAfleRckaYNGpaIeiZ8YsFaAtbGGjSuEX0A/8UhQN/XT
   Jmfi/kf/kotSkBrdW5CmsIJAEaONQnpdd/CUFtIW0bsuMePfEOoaPFi8P
   qNpEIBI5Jqj2GON0IfXxq/jRFCoPHtSo+kdzygojkDaYSzjUJq94OhDuF
   VMWZfRFPDqfkRoFusilmYAXzca5QgDbniCsXkIblXVnsak22Uc31yERTT
   396nlmjcGy0K4uhuICxXC9Mv2QMo3XwTNdzcY0ewELIyN+R0bq7jzNVRW
   g==;
X-CSE-ConnectionGUID: GtMPKnhaShWeyHgi0PxlDw==
X-CSE-MsgGUID: GAAuVsn9SveFoqCrgdol1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="44212049"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="44212049"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 02:15:34 -0700
X-CSE-ConnectionGUID: RESNh+4vQqmIf046iR2EVw==
X-CSE-MsgGUID: mzo6rkFTT6e7/el7rtBtpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58532073"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 02:15:31 -0700
Message-ID: <c03df364-4cce-4c7e-b9db-191f7b10ca70@linux.intel.com>
Date: Tue, 13 Aug 2024 17:15:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/25] KVM: TDX: create/free TDX vcpu structure
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-18-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240812224820.34826-18-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Implement vcpu related stubs for TDX for create, reset and free.
>
> For now, create only the features that do not require the TDX SEAMCALL.
> The TDX specific vcpu initialization will be handled by KVM_TDX_INIT_VCPU.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>   - Dropped unnecessary WARN_ON_ONCE() in tdx_vcpu_create().
>     WARN_ON_ONCE(vcpu->arch.cpuid_entries),
>     WARN_ON_ONCE(vcpu->arch.cpuid_nent)
>   - Use kvm_tdx instead of to_kvm_tdx() in tdx_vcpu_create() (Chao)
>
> v19:
>   - removed stale comment in tdx_vcpu_create().
>
> v18:
>   - update commit log to use create instead of allocate because the patch
>     doesn't newly allocate memory for TDX vcpu.
>
> v16:
>   - Add AMX support as the KVM upstream supports it.
> --
> 2.46.0
> ---
>   arch/x86/kvm/vmx/main.c    | 44 ++++++++++++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/tdx.c     | 41 +++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h | 10 +++++++++
>   arch/x86/kvm/x86.c         |  2 ++
>   4 files changed, 93 insertions(+), 4 deletions(-)
>
[...]
> +
> +static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_reset(vcpu, init_event);
> +		return;
> +	}
> +
> +	vmx_vcpu_reset(vcpu, init_event);
> +}
> +
[...]
> +
> +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +
> +	/* Ignore INIT silently because TDX doesn't support INIT event. */
> +	if (init_event)
> +		return;
> +
> +	/* This is stub for now. More logic will come here. */
> +}
> +
For TDX, it actually doesn't do any thing meaningful in vcpu reset.
Maybe we can drop the helper and move the comments to vt_vcpu_reset()?

>   
>   #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ce2ef63f30f2..9cee326f5e7a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -488,6 +488,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	kvm_recalculate_apic_map(vcpu->kvm);
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(kvm_set_apic_base);
>   
>   /*
>    * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
> @@ -12630,6 +12631,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
>   {
>   	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
>   }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
>   
>   bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
>   {

kvm_set_apic_base() and kvm_vcpu_is_reset_bsp() is not used in
this patch. The symbol export should move to the next patch, which
uses them.



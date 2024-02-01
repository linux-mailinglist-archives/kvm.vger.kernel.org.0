Return-Path: <kvm+bounces-7689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F38845448
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 10:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFCF8287508
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED3D15CD52;
	Thu,  1 Feb 2024 09:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FPKKqRfT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013DC15CD46;
	Thu,  1 Feb 2024 09:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706780380; cv=none; b=CWIX+mbkHVaOH1/Na6WJsWOyXGApa80Cxv0CqE8PaNa+1kBGDEdfVfxUS+H5MbYMP2NlDVZ3vfyB5kwFJbXsLxVTA2A3m9w1B8XnpkDYVETZNPhlkC2By0HuiCZf+wulT/fqkaDXyZcA+IPDKTzPvsTWG0fBtcoPAA4u1J5TR4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706780380; c=relaxed/simple;
	bh=SxZGJXR/5Za9XHdSodFNXRgmS/8/RLHnfvyBWtyAkKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZbrhgiN8PxSlyDKtymVVks0X2kzNWT/53V95Q3qZEsWpWT3Kzk/9PkRhl5et2eXnkEeOtjdQAFjuvHqs1Tk95a4iTpYSG99PlGfFgvbIJyuPjORO4i9Z4hZW5gm0nFdB1ve72yGVE4j9Kias4wSZhHGsEJsGVUZz7Kw+rf9ZjzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FPKKqRfT; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706780379; x=1738316379;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SxZGJXR/5Za9XHdSodFNXRgmS/8/RLHnfvyBWtyAkKg=;
  b=FPKKqRfTsl+hfVXUQS+r9B1ghyNZubioGZfKFhuQMMdHmLfF3on2ymTw
   yUihFmviaUfH04TERCbuZA5EdPujxuEtn6EYMRV7wEOC+bbiHBUlSJrN7
   lcCBjWLrLPtTzjvW3ofXbbu2R7biLleOKxOPUhru7okKXaMZVK8qpsoNs
   qAK7hfRH0MpVT1OVubhW1ZNEAKEhUF+kHNUm1bnEDCLFlVXicdGVaBXwr
   HDkWGD+Z5I1k3uQSzJRCujRhXeUjZPllb4Nxt9nW3X/NnMYHxn86pAXAf
   hlMY+C47W9+vBpEH1zJuOhnZBfpka9z51UcdKJQi2BDsHIxdldX6iibHj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="402700434"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="402700434"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 01:39:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="788896822"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="788896822"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.33.17]) ([10.93.33.17])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 01:39:34 -0800
Message-ID: <750b9252-fc0a-490e-96e5-d90525053c4f@intel.com>
Date: Thu, 1 Feb 2024 17:39:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 009/121] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Content-Language: en-US
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <bb29cde17a53fc1afdabdf24cb88ad1d35d6b4a2.1705965634.git.isaku.yamahata@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <bb29cde17a53fc1afdabdf24cb88ad1d35d6b4a2.1705965634.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add placeholders TDX VM/vcpu structure that overlays with VMX VM/vcpu
> structures.  Initialize VM structure size and vcpu size/align so that x86
> KVM common code knows those size irrespective of VMX or TDX.  Those
> structures will be populated as guest creation logic develops.
> 
> Add helper functions to check if the VM is guest TD and add conversion
> functions between KVM VM/VCPU and TDX VM/VCPU.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> ---
> v14 -> v15:
> - use KVM_X86_TDX_VM
> ---
>   arch/x86/kvm/vmx/main.c | 18 +++++++++++++--
>   arch/x86/kvm/vmx/tdx.c  |  1 +
>   arch/x86/kvm/vmx/tdx.h  | 50 +++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 67 insertions(+), 2 deletions(-)
>   create mode 100644 arch/x86/kvm/vmx/tdx.h
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 1e1feaacac59..f6b66f18c070 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -5,6 +5,7 @@
>   #include "vmx.h"
>   #include "nested.h"
>   #include "pmu.h"
> +#include "tdx.h"
>   
>   static bool enable_tdx __ro_after_init;
>   module_param_named(tdx, enable_tdx, bool, 0444);
> @@ -216,6 +217,21 @@ static int __init vt_init(void)
>   	 */
>   	hv_init_evmcs();
>   
> +	/*
> +	 * kvm_x86_ops is updated with vt_x86_ops.  vt_x86_ops.vm_size must
> +	 * be set before kvm_x86_vendor_init().
> +	 */
> +	vcpu_size = sizeof(struct vcpu_vmx);
> +	vcpu_align = __alignof__(struct vcpu_vmx);
> +	if (enable_tdx) {

until now, 'enable_tdx' is totally decided by module_param, which might 
change from Y to N if tdx fails enabling. In this case, the below should 
not be updated.

> +		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
> +					   sizeof(struct kvm_tdx));
> +		vcpu_size = max_t(unsigned int, vcpu_size,
> +				  sizeof(struct vcpu_tdx));
> +		vcpu_align = max_t(unsigned int, vcpu_align,
> +				   __alignof__(struct vcpu_tdx));
> +	}
> +
>   	r = vmx_init();
>   	if (r)
>   		goto err_vmx_init;
> @@ -228,8 +244,6 @@ static int __init vt_init(void)
>   	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
>   	 * exposed to userspace!
>   	 */
> -	vcpu_size = sizeof(struct vcpu_vmx);
> -	vcpu_align = __alignof__(struct vcpu_vmx);
>   	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
>   	if (r)
>   		goto err_kvm_init;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8a378fb6f1d4..1c9884164566 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -6,6 +6,7 @@
>   #include "capabilities.h"
>   #include "x86_ops.h"
>   #include "x86.h"
> +#include "tdx.h"
>   
>   #undef pr_fmt
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> new file mode 100644
> index 000000000000..473013265bd8
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -0,0 +1,50 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __KVM_X86_TDX_H
> +#define __KVM_X86_TDX_H
> +
> +#ifdef CONFIG_INTEL_TDX_HOST
> +struct kvm_tdx {
> +	struct kvm kvm;
> +	/* TDX specific members follow. */
> +};
> +
> +struct vcpu_tdx {
> +	struct kvm_vcpu	vcpu;
> +	/* TDX specific members follow. */
> +};
> +
> +static inline bool is_td(struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type == KVM_X86_TDX_VM;
> +}
> +
> +static inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	return is_td(vcpu->kvm);
> +}
> +
> +static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
> +{
> +	return container_of(kvm, struct kvm_tdx, kvm);
> +}
> +
> +static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
> +{
> +	return container_of(vcpu, struct vcpu_tdx, vcpu);
> +}
> +#else
> +struct kvm_tdx {
> +	struct kvm kvm;
> +};
> +
> +struct vcpu_tdx {
> +	struct kvm_vcpu	vcpu;
> +};
> +
> +static inline bool is_td(struct kvm *kvm) { return false; }
> +static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
> +static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm) { return NULL; }
> +static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu) { return NULL; }
> +#endif /* CONFIG_INTEL_TDX_HOST */
> +
> +#endif /* __KVM_X86_TDX_H */



Return-Path: <kvm+bounces-11782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1531F87B7DD
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 07:21:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37A2C1C20BB2
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 06:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86482FC15;
	Thu, 14 Mar 2024 06:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HvYxXCXk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C075FF9DB;
	Thu, 14 Mar 2024 06:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710397275; cv=none; b=DFVPm9Y0E7/Rpe8nBmL+p6+aftveI9cxUxy8i/BbZzKfXF1JPyqsrV+4QLPVK03QDHYhZUfZvTyUjbATE2TmOvLh45Wuks0SkR1Gs0klgfdKJb6HXbG0RghIcZZfOaQz9kRWn9taOXxajEnLI4Kb+SRzBtfAf9Eq7QhMug2uUwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710397275; c=relaxed/simple;
	bh=wq2SC8j4x5uUSSHjNt99R5eSLr+S+hk7CUHtgGhkS5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PR75JQEh2uTe6szvLV36zFykTypzvWevdLE46J6Lou0VUfiyT9XTjqQlJzzFi1q7rDO0broDBA2sBSgE0cGDFmh99moVNxo3lHqXAk6tkEouZSPVYuYJFPZVvv++v9RDmGC+cdzsUt0Rycy/1ApeAtOqZah8aNDhPnXqkoTd21E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HvYxXCXk; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710397274; x=1741933274;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wq2SC8j4x5uUSSHjNt99R5eSLr+S+hk7CUHtgGhkS5Y=;
  b=HvYxXCXkZzaO4FpcHCwgFI5WmJ/7McFmz+dCJgc2u+wZrchB+Uv//mZn
   iAxOkWru9IPXGBNj6+8GVN5tCzjJUnbOPhueh3Zazp51AcDT26/4E30mh
   KO2Z7QkI+p6N6X8+RaMZUnyBeEVy0SZaWg63ZoVh3mvM1TDkeOFv6rhkP
   pFVxLBPvXKLNHpWFaUVFP9/5j5IEGAlW8ybjfcl7giAH+AmOQQPHbFTY7
   T/h9QCPIHiFQjO3l7RH0SAPfN8wCXvQIXZcNorhmkhIP3jPrstpeiyiP2
   v1YcEnth1QtiHVJFw6gAkYwkrr3nvKev2CJ20qO+LVnHxfR8VauTM0bWc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="15926210"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="15926210"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 23:21:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="12068681"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 23:21:06 -0700
Message-ID: <1ae483bc-b279-44ca-b396-04aa480e3781@linux.intel.com>
Date: Thu, 14 Mar 2024 14:21:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 024/130] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c857863a346e692837b0c35da8a0e03c45311496.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <c857863a346e692837b0c35da8a0e03c45311496.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
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
> v19:
> - correctly update ops.vm_size, vcpu_size and, vcpu_align by Xiaoyao
>
> v14 -> v15:
> - use KVM_X86_TDX_VM
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c | 14 ++++++++++++
>   arch/x86/kvm/vmx/tdx.c  |  1 +
>   arch/x86/kvm/vmx/tdx.h  | 50 +++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 65 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/tdx.h
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 18aef6e23aab..e11edbd19e7c 100644
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
> @@ -18,6 +19,9 @@ static __init int vt_hardware_setup(void)
>   		return ret;
>   
>   	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> +	if (enable_tdx)
> +		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
> +					   sizeof(struct kvm_tdx));
>   
>   	return 0;
>   }
> @@ -215,8 +219,18 @@ static int __init vt_init(void)
>   	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
>   	 * exposed to userspace!
>   	 */
> +	/*
> +	 * kvm_x86_ops is updated with vt_x86_ops.  vt_x86_ops.vm_size must
> +	 * be set before kvm_x86_vendor_init().

The comment is not right?
In this patch, vt_x86_ops.vm_size is set in  vt_hardware_setup(),
which is called in kvm_x86_vendor_init().

Since kvm_x86_ops is updated by kvm_ops_update() with the fields of
vt_x86_ops. I guess you wanted to say vt_x86_ops.vm_size must be set
before kvm_ops_update()?

> +	 */
>   	vcpu_size = sizeof(struct vcpu_vmx);
>   	vcpu_align = __alignof__(struct vcpu_vmx);
> +	if (enable_tdx) {
> +		vcpu_size = max_t(unsigned int, vcpu_size,
> +				  sizeof(struct vcpu_tdx));
> +		vcpu_align = max_t(unsigned int, vcpu_align,
> +				   __alignof__(struct vcpu_tdx));
> +	}
>   	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
>   	if (r)
>   		goto err_kvm_init;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 43c504fb4fed..14ef0ccd8f1a 100644
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



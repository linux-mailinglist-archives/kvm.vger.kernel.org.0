Return-Path: <kvm+bounces-7951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28388848C68
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 10:21:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB7F928305A
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 09:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF27118E2A;
	Sun,  4 Feb 2024 09:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KUXpAfRR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2283218E0E;
	Sun,  4 Feb 2024 09:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707038481; cv=none; b=SyIvPLkelAGvnyJBIpiFh1CHUYdYv/0zUs+0XNu9YR3wM5umAbqtKOorl6c21tIvg80CkENoQUR0A5HR11oEUYNwQiBSfXmG8RWwMGQH4olZw4XCde8teZvLX2M7y1DHHKuUaK2x5/ipfIGWDFquM2Ycwf8eVm5NeBhhqqYCWqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707038481; c=relaxed/simple;
	bh=igzb+GwK8rsfew2obxt6Oj0utoHph8HB+JdCy0g6+uQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J7JeHP/1ZFu7AtvCi7tHDx8I3eGsxTU18/yQ8jpiS4erxx9nESMgnsJ0TYgBLdu8At7MURxK6KD8F+wR9IIvTHtT0tzXVZEB6hKs5Y6SNDX4/h8B9/dxgQHQUYtk0kPVRZvhTKBHyJDcj5whMl0eqtJmGdLtvuYlhgiUHWLmjr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KUXpAfRR; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707038479; x=1738574479;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=igzb+GwK8rsfew2obxt6Oj0utoHph8HB+JdCy0g6+uQ=;
  b=KUXpAfRRHZE8WsRox3S26wKKpxexKLj7OS7z71pRX7isyhrjRprluqzD
   LmiGnnlCsWm08Yg6Ex9VtAw4snq3xORDFNItiy9YBY3U7CqxVKbdOjcdM
   Y9VFnfktKk+qq6goLJOk+/SCJrijNEMcQkpenA0KMJYmmxUveKDh8GOyb
   4ET8FPiAeKkK+EFIRmmEv3ixzsgDRaDdd4BJITrRAdeoaVbGQ7zaYBvOc
   5pKsSreXXx7TKktUmYh5TYC/LdNVBof9kD6JsK94eolda3YFdnEGHipCj
   Tff8qH1m7Gx/OjwkswaZi6mgIKho/FjVuroUrTmdZC9gb/dP+uqSgoraU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10973"; a="551320"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="551320"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 01:21:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="5074454"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 01:21:14 -0800
Message-ID: <040a00aa-2c21-46df-b94a-addf2502af75@linux.intel.com>
Date: Sun, 4 Feb 2024 17:21:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 055/121] KVM: VMX: Move setting of EPT MMU masks to
 common VT-x code
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <ded872753cfd4abdd7eb842b74c263539cb8f159.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ded872753cfd4abdd7eb842b74c263539cb8f159.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> EPT MMU masks are used commonly for VMX and TDX.  The value needs to be
> initialized in common code before both VMX/TDX-specific initialization
> code.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c | 9 +++++++++
>   arch/x86/kvm/vmx/vmx.c  | 4 ----
>   2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index de4b6f924a36..8059b44ed159 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -4,6 +4,7 @@
>   #include "x86_ops.h"
>   #include "vmx.h"
>   #include "nested.h"
> +#include "mmu.h"
>   #include "pmu.h"
>   #include "tdx.h"
>   #include "tdx_arch.h"
> @@ -54,6 +55,14 @@ static __init int vt_hardware_setup(void)
>   	if (ret)
>   		return ret;
>   
> +	/*
> +	 * As kvm_mmu_set_ept_masks() updates enable_mmio_caching, call it
> +	 * before checking enable_mmio_caching.
> +	 */
> +	if (enable_ept)
> +		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> +				      cpu_has_vmx_ept_execute_only());
> +
>   	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
>   
>   	return 0;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 185e22a2e101..c2da39ceb02b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8452,10 +8452,6 @@ __init int vmx_hardware_setup(void)
>   
>   	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
>   
> -	if (enable_ept)
> -		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> -				      cpu_has_vmx_ept_execute_only());
> -

 From hardware_setup aspect, vmx_hardware_setup() is the dependency of
tdx_hardware_setup() and vmx_hardware_setup() is called earlier than
tdx_hardware_setup(), it seems no need to move the code.


>   	/*
>   	 * Setup shadow_me_value/shadow_me_mask to include MKTME KeyID
>   	 * bits to shadow_zero_check.



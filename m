Return-Path: <kvm+bounces-58372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F212B8FA4E
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 10:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC3497AF882
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 08:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E30E9283FDC;
	Mon, 22 Sep 2025 08:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NQI7vfj1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FDA280318;
	Mon, 22 Sep 2025 08:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758530850; cv=none; b=mWuqeXhLWcxdkCYkfwoptO8SXnOR7nYQcAHhpJVEXtX197zci4KazkUtJhgnoILUX1hSsNb1IkEJYnCgjg/ejGDADvAzV7hcXzMktxWRkzl710yDM99caKogo7PcIWj+jbatxaAsUMrNf2QvJytTnquiqSMb0V7NkKV39IkWkXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758530850; c=relaxed/simple;
	bh=xK0IKlfmQV4KqP/ONXLLmX2l7B4IM2yv3wbTFnma9xE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nYpcNls6CrQmJcOpV3lWc8MWO94cTRRWNKFSgG7CoxwRrn+r+MH5M6UOgW1SMt/wpseSTZtR47rF8i2dlbPHxaxF577J3Qxzj5IWg2ZXXDgEzAlGy5jkB+3KeQPqXNmIkEfE79fj1MmdCB7xwCAOsFcKzxCegjAY4VQZcJ+1OLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NQI7vfj1; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758530848; x=1790066848;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xK0IKlfmQV4KqP/ONXLLmX2l7B4IM2yv3wbTFnma9xE=;
  b=NQI7vfj1hOWW1ydJuhHu/P6dbPU1e0qKi+TbNYWckTu4MfNxUTJGwdvk
   10WLYZO9zNNct8XaGGgCQ+Nuh4ngoVq3IXZimogFkkmV8Pwoeli06QevD
   WTLi6JXhIR7+DNLHuiDLqfMo1WnyAmLlYZHHQxbGgRmpSJE3HA5yKtSqf
   u+xHhcrK7m0FRjH/3Wln/mwvBtYQkthNraVHuyp7W5etAkRgXxUYwdiy6
   StNleTzbCCCOR5j0ppNdv/RT4MxgTOIgTdn1jX6n8iQH1H+WtqYB3FALq
   U1hUJqiXpGE31JdI4KR3oc2iwnUzfeOwGw46hku3fHuJfAqLmIUxMq/Za
   g==;
X-CSE-ConnectionGUID: 66Umf0ffSCez03hc2P7fEw==
X-CSE-MsgGUID: dAbgTQuRTt6j0nDx5CXj1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60905617"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="60905617"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:47:27 -0700
X-CSE-ConnectionGUID: Dtz3/7uUQyyNAPOwcMeeHg==
X-CSE-MsgGUID: qYg3TEY6TSmJuaULv0UDsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="175558701"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:47:24 -0700
Message-ID: <f06fe1c9-7042-4373-93b1-6a51acc4316b@linux.intel.com>
Date: Mon, 22 Sep 2025 16:47:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 32/51] KVM: nVMX: Add consistency checks for CR0.WP
 and CR4.CET
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-33-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-33-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> From: Chao Gao <chao.gao@intel.com>
>
> Add consistency checks for CR4.CET and CR0.WP in guest-state or host-state
> area in the VMCS12. This ensures that configurations with CR4.CET set and
> CR0.WP not set result in VM-entry failure, aligning with architectural
> behavior.
>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/nested.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 11e5d3569933..51c50ce9e011 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3110,6 +3110,9 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>   	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
>   		return -EINVAL;
>   
> +	if (CC(vmcs12->host_cr4 & X86_CR4_CET && !(vmcs12->host_cr0 & X86_CR0_WP)))
> +		return -EINVAL;
> +
>   	if (CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
>   	    CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
>   		return -EINVAL;
> @@ -3224,6 +3227,9 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>   	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
>   		return -EINVAL;
>   
> +	if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X86_CR0_WP)))
> +		return -EINVAL;
> +
>   	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
>   	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
>   	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))



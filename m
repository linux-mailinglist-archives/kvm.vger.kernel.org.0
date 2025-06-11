Return-Path: <kvm+bounces-48964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D95DAD4A19
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 06:38:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90E5C3A4F7A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 04:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232CC21B9C1;
	Wed, 11 Jun 2025 04:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cJzUcKiF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8D51B0411;
	Wed, 11 Jun 2025 04:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749616705; cv=none; b=GhzAESjWGDo7ApqYg8scbCzyW9kz1wPJEQSv0noZn3chGsdzKD9Hl9DMrX1fSX4yq0XZ+bFcgoPlboMrYKuE0CBhRk5nS+JSwWU0GDeTpvsxALKrbATPkveW9byWJhQdSTz/8ga2A4Tamb/oWuENPzlXBCe1CgwTrOAp3bbwMYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749616705; c=relaxed/simple;
	bh=KbXg0HmLXdWM4zba+PsRTH5m51SW5Hsv6pxMUcnQ9o0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hzjJPD249Mu6A3xbeKmPs8qN/plFa3vpaCOdmwQZj+wyaeXI8L1W/SVpItykUXnZsfO4QTo9wdomvsJ0/zA9Uc/bXRY+uUK+k+2fpDhMt18TuVbRLs8wrovxrkS16zop6UbtX5P8MyTG+7yi4lYrlJjjEcO8oIevtB0dJrXqx2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cJzUcKiF; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749616703; x=1781152703;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KbXg0HmLXdWM4zba+PsRTH5m51SW5Hsv6pxMUcnQ9o0=;
  b=cJzUcKiFGuL2hl0QZF4Od/USSFBgrIiqfxPy0leIXIlsRE424vxUbS4I
   EcI7cD9uA1yPX6b44xgENGTQshyEuSw8EbVhgoT9WYuR8OHmzKX67vLLa
   QMQJDDmUTapClrGK7t07mdpCEy0zBTXaJkL0GbGYfwBYlA2eT6bQEceHD
   gx0eFiTe15jaoPtY/5hDJ+l0hv4zrI9I7bi7qOi73136XTWnJa65KBqcg
   nMhwhXc94W5x5vPFuPCoSIXMD15XqmnPVbJr0sIi5HKrYGRleD7zQpGkS
   n7MEuu265J2L9mQueEY1W+Xetcyuf37LQb5apBJ8xvYW/nYmvlsLnpMb1
   g==;
X-CSE-ConnectionGUID: trMvHVKJTiq1iyh8LDZIVg==
X-CSE-MsgGUID: uPaEP4FkSlm79uXB+YLWbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="62783169"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="62783169"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 21:38:23 -0700
X-CSE-ConnectionGUID: l8HYpvXbRQKXDyxRt2LbEw==
X-CSE-MsgGUID: p0kOdQ4iQf2sNB4pZGSuBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="147619193"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 21:38:20 -0700
Message-ID: <629e0dc3-49b4-45f5-aeaa-8a9109e81d14@linux.intel.com>
Date: Wed, 11 Jun 2025 12:38:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/32] KVM: SVM: Disable interception of SPEC_CTRL iff
 the MSR exists for the guest
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>,
 Xin Li <xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 Manali Shukla <Manali.Shukla@amd.com>
References: <20250610225737.156318-1-seanjc@google.com>
 <20250610225737.156318-2-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250610225737.156318-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/11/2025 6:57 AM, Sean Christopherson wrote:
> Disable interception of SPEC_CTRL when the CPU virtualizes (i.e. context
> switches) SPEC_CTRL if and only if the MSR exists according to the vCPU's
> CPUID model.  Letting the guest access SPEC_CTRL is generally benign, but
> the guest would see inconsistent behavior if KVM happened to emulate an
> access to the MSR.
>
> Fixes: d00b99c514b3 ("KVM: SVM: Add support for Virtual SPEC_CTRL")
> Reported-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 0ad1a6d4fb6d..21e745acebc3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1362,11 +1362,14 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>   	svm_recalc_instruction_intercepts(vcpu, svm);
>   
>   	/*
> -	 * If the host supports V_SPEC_CTRL then disable the interception
> -	 * of MSR_IA32_SPEC_CTRL.
> +	 * If the CPU virtualizes MSR_IA32_SPEC_CTRL, i.e. KVM doesn't need to
> +	 * manually context switch the MSR, immediately configure interception
> +	 * of SPEC_CTRL, without waiting for the guest to access the MSR.
>   	 */
>   	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> -		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
> +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
> +				     guest_has_spec_ctrl_msr(vcpu),
> +				     guest_has_spec_ctrl_msr(vcpu));
Side topic, not related to this patch directly.

Setting to 1 for set_msr_interception() means to disable interception.
The name of the function seems a bit counterintuitive to me.
Maybe some description for the function can help people not familiar with
SVM code without further checking the implementation?


>   
>   	if (kvm_vcpu_apicv_active(vcpu))
>   		avic_init_vmcb(svm, vmcb);



Return-Path: <kvm+bounces-50621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64A8FAE785E
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:20:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CEAA3A4C3E
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365821FDA97;
	Wed, 25 Jun 2025 07:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hDC/R3/P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8373597E;
	Wed, 25 Jun 2025 07:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836010; cv=none; b=DyDk2kn7G3zaqBxkwR24Hwd3ZwVXXdpTCeaU4T9SkM/RI93QPf1DUoGx+SP2w/qqO30uVV4bVwoTVNdEyDD7ZbE4cdnV3Z9o9g04gnjCesjaxLnz8ClXAFKdnO0YQg09miAcJHuWrxFPxFH5tvzEdpPyV/0a02DHk21NmBhgb+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836010; c=relaxed/simple;
	bh=RPLd4t6ipjkqJfkXjKs264zuVlISuN2w0gSD4y/mTZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EsalTQHLaFMmcHzu32hIgz7X9Q17G4FiTvwXmAzJkoANG/u1LXfbUCrYVu92amce7t2XkisRulCG87KfulkR45AHfWtOpzk29fYKO3SX33h/RXpd2c+lwqh+5ost713jymVJAaoWwjFmhcs73okHNnU/Um0tyvsAadDbRh3Hyfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hDC/R3/P; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750836008; x=1782372008;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RPLd4t6ipjkqJfkXjKs264zuVlISuN2w0gSD4y/mTZ8=;
  b=hDC/R3/P9uKlPLkPD69dOh4O89cX7XFS6QxWEs711MplymAcOvaa1S0x
   3wDwDPnunezfOzo9c9aCD8GwZiTAeyVidpntSLEnDd2ICTGsARUQ8D8/M
   LRLKdxxvkddtjMEvyHcmNGRoif+DfXHw9gs1DHsVVox8lx/kQN8v5O7gr
   fLCYg/7Hm6LLRerpXLrSTPWt/tcHosvDIjfySfvh5ujxC3IA9MPddqQKW
   hf7f00Wzs9aFE1OsnlnM30ufkEPDk3Is3bA+l7e2Vz/Bb3yfMk00HdLrZ
   2opOcRmKB1fWhLa1+ehixsP8ahJ5Tk7IXGQ9k1yvbC1ENDYk5gx9cWAdE
   w==;
X-CSE-ConnectionGUID: 4JmA50O0SvajuP6YCf9Kcg==
X-CSE-MsgGUID: JpZTo/5MSTqUMX53+MN7ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="64450237"
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="64450237"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 00:20:07 -0700
X-CSE-ConnectionGUID: gMswdQAlQhm8RrqX9faUzg==
X-CSE-MsgGUID: PeBbTCAsS9ShF0sUhetUCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="152429511"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 00:20:07 -0700
Message-ID: <1822390b-468b-400d-b6e5-d936372653e1@linux.intel.com>
Date: Wed, 25 Jun 2025 15:20:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: SVM: Simplify MSR interception logic for
 IA32_XSS MSR
To: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, dapeng1.mi@linux.intel.com
References: <20250612081947.94081-1-chao.gao@intel.com>
 <20250612081947.94081-3-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250612081947.94081-3-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/12/2025 4:19 PM, Chao Gao wrote:
> Use svm_set_intercept_for_msr() directly to configure IA32_XSS MSR
> interception, ensuring consistency with other cases where MSRs are
> intercepted depending on guest caps and CPUIDs.
>
> No functional change intended.
>
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
> With this patch applied, svm_enable_intercept_for_msr() has no user.
> Should it be removed?
> ---
>   arch/x86/kvm/svm/sev.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6282c2930cda..504e8a87644a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4371,11 +4371,9 @@ void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>   	 * XSAVES being exposed to the guest so that KVM can at least honor
>   	 * guest CPUID for RDMSR and WRMSR.
>   	 */
> -	if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
> -	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> -		svm_disable_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW);
> -	else
> -		svm_enable_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW);
> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW,
> +				  !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) ||
> +				  !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES));
>   }
>   
>   void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)



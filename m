Return-Path: <kvm+bounces-28172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 269FC99601D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D82B128503F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 06:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06BF17B439;
	Wed,  9 Oct 2024 06:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oFUm3XkH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F04416B391;
	Wed,  9 Oct 2024 06:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728456573; cv=none; b=p6Bn+zXfAdIgANVqZ3pyAUDFY1xQJ0+/VMUgjLYM/RGfLw/gOLqAQkuG+BopJRdz49ahg/dE7Zo+pehuHwx+xNoAAJwqV1IAuIAuasV+dOOiP0msbGx9ZZzAUVD5zrfOK+3dlrpKh6Qi0JLYAjVbEqzowM8RPkrTchYK7dn3/pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728456573; c=relaxed/simple;
	bh=6fouhGGy4NBsOkx2jHsrlP91crtoTEei8M/ZW1+vE9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=echU1i76PH4VbNyqG+yoVGLtOVkTpYVoHhnLVLgwW5cZLhYTkmVcC0efLv/o9/+yvvOG0vjyMiXhzPwdmXdvtoHa6nmX/D371UvFvA2ccF7sWJo5mYL4M0oX+HP0G8g7kXoU/ZXMVP4Aiz+/zJROp4frMKH1YLEkW0A3J+rAAJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oFUm3XkH; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728456573; x=1759992573;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6fouhGGy4NBsOkx2jHsrlP91crtoTEei8M/ZW1+vE9E=;
  b=oFUm3XkHrpw6LS92K+HfdlmkM7Z5f2mwcypxmuG8p2Bz/uHje3IsAxy/
   igysEKbu75cjCjBYcK8ylozgluX1Z2wJRbPvA5qhi3ZbT0mKh2kcpp+aA
   il4t5prJmzqGQsdUebAUcDnb7FKCldWgjUimz5UIZosVJzvwFy3uGdjM4
   fyQsWickwjE8po8HnISgQ54UN9TMmWlmK8ZFj/bPvHgW8m8t7kMpaatD/
   AxjcqVuPTZO2bs+0K8JSXkjd7Ns+rFNO/Y436PUqvkspqD/hV2Lqujyi7
   F/qSDxHIAbyi7GK6x7iCKxVv2L/UuwYYymwz9BYGTvMoQJxKBeV7W6Jks
   A==;
X-CSE-ConnectionGUID: m+yGFyNwRlSk0+FDChgQiQ==
X-CSE-MsgGUID: mEXLN3/gRI2t6vtaJDUlSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="27857634"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="27857634"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 23:49:32 -0700
X-CSE-ConnectionGUID: lHZJ+GqASaSN/Bnqa2i/2w==
X-CSE-MsgGUID: XrNPf8kgSqabU4wB0TY/sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="76966752"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 23:49:29 -0700
Message-ID: <368f430b-3242-4d23-a737-3b13c30f6206@intel.com>
Date: Wed, 9 Oct 2024 14:49:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] KVM: x86: Use user_exit_on_hypercall() instead of
 opencode
To: Binbin Wu <binbin.wu@linux.intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, yuan.yao@linux.intel.com
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-3-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240826022255.361406-3-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/2024 10:22 AM, Binbin Wu wrote:
> Use user_exit_on_hypercall() instead of opencode.
> 
> No functional change intended.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/svm/sev.c | 4 ++--
>   arch/x86/kvm/x86.c     | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 714c517dd4b7..9b3d55474922 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3637,7 +3637,7 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
>   		return 1; /* resume guest */
>   	}
>   
> -	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
> +	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
>   		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
>   		return 1; /* resume guest */
>   	}
> @@ -3720,7 +3720,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
>   	bool huge;
>   	u64 gfn;
>   
> -	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
> +	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
>   		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
>   		return 1;
>   	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e521f14ad2b2..c41ba387cc8c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10165,7 +10165,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   		u64 gpa = a0, npages = a1, attrs = a2;
>   
>   		ret = -KVM_ENOSYS;
> -		if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE)))
> +		if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE))
>   			break;
>   
>   		if (!PAGE_ALIGNED(gpa) || !npages ||



Return-Path: <kvm+bounces-19389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 529AB9048AB
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1A04B21C4C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADE38C1E;
	Wed, 12 Jun 2024 01:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CJ+Kjvpv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195F44696;
	Wed, 12 Jun 2024 01:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718157585; cv=none; b=tmZRSIScfyBI7+yyeGkCJElQAk2e5PvZuAreCgsSCAn9tyjpbfxaJ4EgDXzm97YV+WGdeRokPqXBaYdwUF0JflsfpLuZS2iAC+/h7OoQuUNpoolvr2ush+Px9V5jpsZQ27/kmpRTu28uVVOHUH0NqPINZvYW2BfFZIRanQ/fiXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718157585; c=relaxed/simple;
	bh=864XpaVKILlfYw0eJqI5Z58BDDy0cJ3P9fgW1Ko95xQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hGhs1pVRD8KkgLTT2c+D19O9kdfexofKDDojsu05fZqI7SiVZUlaXT6fCmKQdLneuMv8i2JnHELZfGKrczXDmttf6NLX+vp1ZIu/D9ltXN/wmDJnpkeABFTZ9l/8Ov8mTAPh4urvvCOaNHJGS2PXXiwdvETz9i72Y5+SIXmDpRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CJ+Kjvpv; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718157584; x=1749693584;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=864XpaVKILlfYw0eJqI5Z58BDDy0cJ3P9fgW1Ko95xQ=;
  b=CJ+Kjvpv/UlJU6uyJU4p+G94fgmXaNPnHuQHlKyTJhTg5VDEhIoI58b1
   qBejoTKzXA5kTNJAjeIOQECmNLofsVDbhpr5dP8WRZKdJMnGLSLZVsDu9
   DKE4MM+tIG5AzpCsTreQGrVNm7r3nZnkXnKtuPdNtnEyORmzKWJ2wNbqu
   VeHTyB5oqZmnZNZdmgwaM0arxJsUuwinuw3KBHvSgSUvti5hftOUM5va3
   mHHDyBdGyudKF16vXgVFhFbusAC1GkXGI1FkgpRumTKA+/AIrdwSlXSZ2
   Y4WJlfOm4g3geQ0mnWEdoh08BdT30Rnrqa+7G4Rai0AvRR7G9ExwwNvxA
   w==;
X-CSE-ConnectionGUID: XbRW/3pFTFqdChYHGM07RQ==
X-CSE-MsgGUID: ir+f7X/VR9ezAEGMn3BJrA==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14627031"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="14627031"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 18:59:44 -0700
X-CSE-ConnectionGUID: 5HB6WzFSSMGKudJkHqD1gA==
X-CSE-MsgGUID: yNpNGTL4TJCH+F1tV7HboQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="39688397"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.51]) ([10.124.227.51])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 18:59:42 -0700
Message-ID: <04b27f2d-5509-4fd0-ac97-ae61d6105b4d@intel.com>
Date: Wed, 12 Jun 2024 09:59:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/mmu: Rephrase comment about synthetic PFERR
 flags in #PF handler
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240608001108.3296879-1-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240608001108.3296879-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/8/2024 8:11 AM, Sean Christopherson wrote:
> Reword the BUILD_BUG_ON() comment in the legacy #PF handler to explicitly
> describe how asserting that synthetic PFERR flags are limited to bits 31:0
> protects KVM against inadvertently passing a synthetic flag to the common
> page fault handler.
> 
> No functional change intended.
> 
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/mmu.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8d7115230739..2421d971ce1b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4599,7 +4599,10 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>   	if (WARN_ON_ONCE(error_code >> 32))
>   		error_code = lower_32_bits(error_code);
>   
> -	/* Ensure the above sanity check also covers KVM-defined flags. */
> +	/*
> +	 * Restrict KVM-defined flags to bits 63:32 so that it's impossible for
> +	 * them to conflict with #PF error codes, which are limited to 32 bits.
> +	 */
>   	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
>   
>   	vcpu->arch.l1tf_flush_l1d = true;
> 
> base-commit: b9adc10edd4e14e66db4f7289a88fdbfa45ae7a8



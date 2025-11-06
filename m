Return-Path: <kvm+bounces-62149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AA78C39376
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 07:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0068D3A7EFF
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 06:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B912DBF43;
	Thu,  6 Nov 2025 06:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KFPwZs02"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB6C2C21F4;
	Thu,  6 Nov 2025 06:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762409245; cv=none; b=Cs4pT+qBLw8NFoAA6hrfSV9U/DeqaM24kb0uVvESt7Txgp/aLZiW/P/fPIzvT2Y2u0LbI22/0Nu29cTOX8dcy//QkAW+FvMX9EIZmaLwTPoLrXIsNPIXoiV6FRTbfwsGFNMyIygbbBvXe7JpuUraCXUr7kAufA+YrBc5TQdTVTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762409245; c=relaxed/simple;
	bh=pq1aK/oPtZOEg/u3oNmbWdBHicGK/msJGbMr7GFbUPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LOuKwBbAHb1ov3IEbpW1i5jHtHlMKmzSFl0eQ1l7dsXBfQUIhXaH8V4t+9K5ka44UXQpzKDf5IjIsEZUW8feaRQt6kHy0Slh7FEwJWlFV60coSwPy5612Hlga1aGtl+yeRiY7j5ZENo4gZiqiCz7ZcRHMvJDtdllrorcV//vmoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KFPwZs02; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762409244; x=1793945244;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pq1aK/oPtZOEg/u3oNmbWdBHicGK/msJGbMr7GFbUPc=;
  b=KFPwZs02HKDTMUNkZxKA+glo/AfCWbqe9NF4TFXntbdTX6N04qo0QdBy
   30n5bsdH2Q1jNRplva7y/p7417iuUfJQdwlQ53Q1XiK4xFq6WTtSDw45X
   Mg+yoHvAuYtqKPBufvnMaSpkPxdO29ckcuQ5J9408WxLTt1IoTGlsyPPr
   wn9T53EkjEPK5/1WVRWqX8kXP6Qnu4MB+TlXamOeG/I9vSzYGyuYYvbzM
   KWlnBuaDUjkjWebpyI2WC5IcnUObtBk3kaHSXWbL2iniQlBqQ2pY0uHE9
   4A4GnNuENjSp72r/1oF7Yc3QS4Ps3gqtebvo/rr6RoSuRbCN9sJN9Y+DE
   A==;
X-CSE-ConnectionGUID: c45iMpi4T+e5aqsM5TY4yQ==
X-CSE-MsgGUID: gjnKrwUKRwGCjpa48S9mqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64444638"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64444638"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 22:07:23 -0800
X-CSE-ConnectionGUID: GQ5FlYmkStSOY5w6muPeRQ==
X-CSE-MsgGUID: gym1Dqo7SRKswtrTf6B94w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="218328429"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.49]) ([10.124.240.49])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 22:07:19 -0800
Message-ID: <5802ecf9-3dfa-40a2-b61f-60b2f9985640@intel.com>
Date: Thu, 6 Nov 2025 14:07:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: VMX: Fix check for valid GVA on an EPT violation
To: Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Yuan Yao <yuan.yao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251106052853.3071088-1-Sukrit.Bhatnagar@sony.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251106052853.3071088-1-Sukrit.Bhatnagar@sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/2025 1:28 PM, Sukrit Bhatnagar wrote:
> On an EPT violation, bit 7 of the exit qualification is set if the
> guest linear-address is valid. The derived page fault error code
> should not be checked for this bit.
> 
> Fixes: f3009482512e ("KVM: VMX: Set PFERR_GUEST_{FINAL,PAGE}_MASK if and only if the GVA is valid")
> Signed-off-by: Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/vmx/common.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index bc5ece76533a..412d0829d7a2 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -98,7 +98,7 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>   	error_code |= (exit_qualification & EPT_VIOLATION_PROT_MASK)
>   		      ? PFERR_PRESENT_MASK : 0;
>   
> -	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
> +	if (exit_qualification & EPT_VIOLATION_GVA_IS_VALID)
>   		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
>   			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
>   



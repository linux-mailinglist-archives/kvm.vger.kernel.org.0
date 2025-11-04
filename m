Return-Path: <kvm+bounces-61960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E45CEC3061E
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 10:58:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4C8C84F7700
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 09:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FEA2314D1E;
	Tue,  4 Nov 2025 09:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DQI/Xra/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1840A313544;
	Tue,  4 Nov 2025 09:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762250191; cv=none; b=faXHGB9JSi4CSJ7Hurpuwpv/WjV5ijmfvxtu33+Rp8LqYYl31rvUtyQnB3Q2VegyNfas2wSWEGKZ6D47zwrJU3fAKAUf5PlT2K15E7yNv60YBdSNYa7gxVwpPLHUsxfhEejzC4ys5CAp0oBMTrhGO+Rr+ZXmK6O3j3RXBItVpZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762250191; c=relaxed/simple;
	bh=tW9gsdIOQn8xhR60DE+ues5vAhWhmuyUp0xEp6ncD3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CXuFFfvu9vjwKLH4EHGIbG/iGeHZ/6e7320SAW6LfU+0LNp7Gh0wgpoOnrE6aTRmM/Ktiwz6SwB3zl58tj63oo5Vb5+dfkNEdR1j5mvdmFbiTnZTHSzOuVuNlFYGLbHhypYAzLE4An9vjqUBoHuvWsL6IWthALrF0llzJxXOXCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DQI/Xra/; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762250190; x=1793786190;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tW9gsdIOQn8xhR60DE+ues5vAhWhmuyUp0xEp6ncD3Y=;
  b=DQI/Xra/9eDA0bJv1Nc2S7ahx2yv6EzbGb4qA+3z98nRl4El5+1HKsVC
   BzURFdOMR7AqktO9ZIRnpvEqLhJUYhedvFvPvld8in9GTRvRCkMuc+gqJ
   eNRK0xwTKMFivAqmIOtNal4VAfm47dCpqEMlez0IOk4AisvrVwrbgNx86
   7zgz/7wfDgSepunmBjRYU/MHuSMQ0ji+uMBo69HrDQyxQQiwzIi1X/FLl
   MavyOkzcTZ8Q23FdmDO88qFrlF+zYticquaeAdCCfLE9XSBfGoAutFsoJ
   YMMP9H0k5EzYP7Zngkg26fQYf61xRqKdhRs3Vws4tyhBZBYM/QEaA9DiZ
   g==;
X-CSE-ConnectionGUID: wxO9fC2lS9qAOiVdKMZq0w==
X-CSE-MsgGUID: J2T3C5ulQaec9irnDaKSVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64244757"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64244757"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:56:30 -0800
X-CSE-ConnectionGUID: dTvwCAMoQ/y4+ke5hnczVA==
X-CSE-MsgGUID: +xGWQw7tRxmGAByjZgnUfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="187267438"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.49]) ([10.124.240.49])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:56:27 -0800
Message-ID: <cea597f3-3a59-4775-b416-f95360d52b0f@intel.com>
Date: Tue, 4 Nov 2025 17:56:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2][PATCH 2/2] x86/virt/tdx: Fix sparse warnings from using 0
 for NULL
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, x86@kernel.org
References: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
 <20251103234439.DC8227E4@davehans-spike.ostc.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251103234439.DC8227E4@davehans-spike.ostc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/2025 7:44 AM, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Stop using 0 for NULL.
> 
> sparse moans:
> 
> 	... arch/x86/kvm/vmx/tdx.c:859:38: warning: Using plain integer as NULL pointer
> 
> for several TDX pointer initializations. While I love a good ptr=0
> now and then, it's good to have quiet sparse builds.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Fixes: a50f673f25e0 ("KVM: TDX: Do TDX specific vcpu initialization")
> Fixes: 8d032b683c29 ("KVM: TDX: create/destroy VM structure")
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Kirill A. Shutemov" <kas@kernel.org>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>   b/arch/x86/kvm/vmx/tdx.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff -puN arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-1 arch/x86/kvm/vmx/tdx.c
> --- a/arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-1	2025-11-03 15:11:28.177643833 -0800
> +++ b/arch/x86/kvm/vmx/tdx.c	2025-11-03 15:11:28.185644508 -0800
> @@ -856,7 +856,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu
>   	}
>   	if (tdx->vp.tdvpr_page) {
>   		tdx_reclaim_control_page(tdx->vp.tdvpr_page);
> -		tdx->vp.tdvpr_page = 0;
> +		tdx->vp.tdvpr_page = NULL;
>   		tdx->vp.tdvpr_pa = 0;
>   	}
>   
> @@ -2642,7 +2642,7 @@ free_tdcs:
>   free_tdr:
>   	if (tdr_page)
>   		__free_page(tdr_page);
> -	kvm_tdx->td.tdr_page = 0;
> +	kvm_tdx->td.tdr_page = NULL;
>   
>   free_hkid:
>   	tdx_hkid_free(kvm_tdx);
> @@ -3016,7 +3016,7 @@ free_tdcx:
>   free_tdvpr:
>   	if (tdx->vp.tdvpr_page)
>   		__free_page(tdx->vp.tdvpr_page);
> -	tdx->vp.tdvpr_page = 0;
> +	tdx->vp.tdvpr_page = NULL;
>   	tdx->vp.tdvpr_pa = 0;
>   
>   	return ret;
> _



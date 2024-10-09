Return-Path: <kvm+bounces-28171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D84BA996017
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:49:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15EEE1C22D23
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 06:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F74C178378;
	Wed,  9 Oct 2024 06:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PSs8Riwq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979081E48A;
	Wed,  9 Oct 2024 06:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728456540; cv=none; b=C1JffNT/am5Bx3nQ1csJWgXO75Lb4RKpgP8Qzt+/n5/rlZPjev/8o5vUbxfXGNRxMW7XrbRAS2mrebyZsWfrhVdN4GnD24aIl6SToOsyPdxjRtuWbELtKDuNmWKim29LpnPJ43JJ1T2r1Ua+2hgJgUMIirewBPmRePG+T4urd5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728456540; c=relaxed/simple;
	bh=jPRpFBnZ9EW+XfbGBqpSEExPTiRtM1xiovaVIbI+5Sg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=khHGWzp1Cp4KI3EoM7dgP4FfU6QYoiQnl1MDFJQrD9aiOv+3tvvRWvS6iYjwgWDt1OYuRiMBBiNRzL68Wuck0WJLxbqnHHhyaLKgx0UPXepAIR2rkhfXwyBMQ1AmOEnoepyyGQ5QPYUBqSwK+Qb+Yzqs+FOy+OTMaUCcwOFMtKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PSs8Riwq; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728456539; x=1759992539;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jPRpFBnZ9EW+XfbGBqpSEExPTiRtM1xiovaVIbI+5Sg=;
  b=PSs8RiwqUyxoHGsw7i+x9ALf/2Ur5f9AMq3U0Zi1ytbGDCnXcVXggdDR
   ZgPDBJFm/OH71TdzjoN8o3ziH33PcVNI1/IU+uQMpws35pkoduNwVfs0i
   ThqYKaxGnXRqB5iTXJoCpy7TyZzvAGvlR0wITxFPk6vIA1K7n24i/nAl2
   h2wsRy9xecZsDuxrbFIABnmpjGWEfrAuFLesGfnhwiEEVwHNAXJfj6dFU
   lvktrQ/qn1puIasJPquG9G0HQVc/t2o6V1wzD8Oy62hh1HeLZ18g7RIaK
   Ku39ZV352Z4yyuVg+gDbkspabqwiXtO1pVVyQsjEiA3lNYFxgDoaU93y/
   A==;
X-CSE-ConnectionGUID: 2bDFut/6QviEOnoncixigA==
X-CSE-MsgGUID: LnO7j72tT3qK7c2joTDvoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="27857520"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="27857520"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 23:48:58 -0700
X-CSE-ConnectionGUID: yfTQ/r2iS3uHAH0RgL2+FQ==
X-CSE-MsgGUID: aPyIOzoBSMiDKQRHtJWsGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="76966519"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 23:48:53 -0700
Message-ID: <d7bf51a9-fcbc-4f7a-af5c-459f5c576e3f@intel.com>
Date: Wed, 9 Oct 2024 14:48:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: Binbin Wu <binbin.wu@linux.intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, yuan.yao@linux.intel.com
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240826022255.361406-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/2024 10:22 AM, Binbin Wu wrote:
> Check whether a KVM hypercall needs to exit to userspace or not based on
> hypercall_exit_enabled field of struct kvm_arch.
> 
> Userspace can request a hypercall to exit to userspace for handling by
> enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
> hypercall_exit_enabled.  Make the check code generic based on it.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/kvm/x86.c | 5 +++--
>   arch/x86/kvm/x86.h | 4 ++++
>   2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 966fb301d44b..e521f14ad2b2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10220,8 +10220,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   	cpl = kvm_x86_call(get_cpl)(vcpu);
>   
>   	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> -		/* MAP_GPA tosses the request to the user space. */
> +	/* Check !ret first to make sure nr is a valid KVM hypercall. */
> +	if (!ret && user_exit_on_hypercall(vcpu->kvm, nr))
> +		/* The hypercall is requested to exit to userspace. */

Nit: Above comment is unnecessary since the name of 
user_exit_on_hypercall() is self documenting.

Otherwise,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>   		return 0;
>   
>   	if (!op_64_bit)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6556a43f1915..bc1a9e080acb 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -561,4 +561,8 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>   			 unsigned int port, void *data,  unsigned int count,
>   			 int in);
>   
> +static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
> +{
> +	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
> +}
>   #endif



Return-Path: <kvm+bounces-48245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85254ACBEA0
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 04:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20E3C3A2E16
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 02:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25EF185B67;
	Tue,  3 Jun 2025 02:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y87UouRb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5F23FE4;
	Tue,  3 Jun 2025 02:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748919233; cv=none; b=OXztfRMxZg8SXgf4tx6NM+bAbaKeTCjfbRoiqBngIB9gy45bl6FdTairkECBLeHSr6/ZQJyHqQIjts3mUSHU2sG6lZ3iTYVu6m07ulj+B0fuWWmBdk6PORXb6l9S8vDNHDohTuN8eq1xOGD+YVJlLLRR8tjYirXNx9AtLvDBQF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748919233; c=relaxed/simple;
	bh=RmYnZU2d+cHjD/svsuWl4GjzGcbuPz3LwEUcmurO348=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pTQL2D5vs4sKxUH2h2RRrq1e41Seh/pxlXviwWGWrQEKms/Mh8ulDVE4xwQ0ZjI0gncXVX3tBWwQx0NOOpvqUoUvA7YFFCVdYDgLobAOpNljYvm7ewuJTsrwwEjzPFwfpK9NoS0nNYYcAoX5hXkeY4j82NeHO+amPobDumV7JpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y87UouRb; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748919231; x=1780455231;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RmYnZU2d+cHjD/svsuWl4GjzGcbuPz3LwEUcmurO348=;
  b=Y87UouRbIsNvp2sZiDXEnEgIGWVqp/43cfU9vWAE3GOcm4/9hOxazI8q
   Tznw/kctEpVc7doG50lfdax05Dy22c0X7PHR2yX5oRQODz5cOenkNfXDV
   PhTeZcchf2VIZPWP4BTWsRsdbPNqu0yAmshhzJZqt3QIjEF/Je/tWHgt7
   p3ENZNOpD3nw8xMfipv+yOmRS9veybpvdIgQo9hCHQrIHztaeu/fY8T85
   H74yqgIdjImGPPeKf1tr3jA91wdxKxYm93OT1Pk8wb7gNSV8pRXw5eME0
   Xuav7O8wh8qMbMFwoQh1fO3Hy5KvTNdZkd2aVpXAcMLciVNTM1jMwUgLD
   w==;
X-CSE-ConnectionGUID: kdDUhfnRQdGH8VidzSb0rw==
X-CSE-MsgGUID: swUI/BeQSLeJ+kDnSwNziw==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="51088581"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="51088581"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 19:53:50 -0700
X-CSE-ConnectionGUID: oxGiuzlmSPuDct+Vz6EVPA==
X-CSE-MsgGUID: CzipgH+NQ0idJe9Z9AfLJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="148576876"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 19:53:48 -0700
Message-ID: <89f7a456-dc40-44a8-830e-4ea97ce86638@linux.intel.com>
Date: Tue, 3 Jun 2025 10:53:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/28] KVM: x86: Use non-atomic bit ops to manipulate
 "shadow" MSR intercepts
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Chao Gao <chao.gao@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-6-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529234013.3826933-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/30/2025 7:39 AM, Sean Christopherson wrote:
> Manipulate the MSR bitmaps using non-atomic bit ops APIs (two underscores),
> as the bitmaps are per-vCPU and are only ever accessed while vcpu->mutex is
> held.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 12 ++++++------
>  arch/x86/kvm/vmx/vmx.c |  8 ++++----
>  2 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d5d11cb0c987..b55a60e79a73 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -789,14 +789,14 @@ static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
>  
>  	/* Set the shadow bitmaps to the desired intercept states */
>  	if (read)
> -		set_bit(slot, svm->shadow_msr_intercept.read);
> +		__set_bit(slot, svm->shadow_msr_intercept.read);
>  	else
> -		clear_bit(slot, svm->shadow_msr_intercept.read);
> +		__clear_bit(slot, svm->shadow_msr_intercept.read);
>  
>  	if (write)
> -		set_bit(slot, svm->shadow_msr_intercept.write);
> +		__set_bit(slot, svm->shadow_msr_intercept.write);
>  	else
> -		clear_bit(slot, svm->shadow_msr_intercept.write);
> +		__clear_bit(slot, svm->shadow_msr_intercept.write);
>  }
>  
>  static bool valid_msr_intercept(u32 index)
> @@ -862,8 +862,8 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
>  	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
>  		return;
>  
> -	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
> -	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
> +	read  ? __clear_bit(bit_read,  &tmp) : __set_bit(bit_read,  &tmp);
> +	write ? __clear_bit(bit_write, &tmp) : __set_bit(bit_write, &tmp);
>  
>  	msrpm[offset] = tmp;
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9ff00ae9f05a..8f7fe04a1998 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4029,9 +4029,9 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  	idx = vmx_get_passthrough_msr_slot(msr);
>  	if (idx >= 0) {
>  		if (type & MSR_TYPE_R)
> -			clear_bit(idx, vmx->shadow_msr_intercept.read);
> +			__clear_bit(idx, vmx->shadow_msr_intercept.read);
>  		if (type & MSR_TYPE_W)
> -			clear_bit(idx, vmx->shadow_msr_intercept.write);
> +			__clear_bit(idx, vmx->shadow_msr_intercept.write);
>  	}
>  
>  	if ((type & MSR_TYPE_R) &&
> @@ -4071,9 +4071,9 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  	idx = vmx_get_passthrough_msr_slot(msr);
>  	if (idx >= 0) {
>  		if (type & MSR_TYPE_R)
> -			set_bit(idx, vmx->shadow_msr_intercept.read);
> +			__set_bit(idx, vmx->shadow_msr_intercept.read);
>  		if (type & MSR_TYPE_W)
> -			set_bit(idx, vmx->shadow_msr_intercept.write);
> +			__set_bit(idx, vmx->shadow_msr_intercept.write);
>  	}
>  
>  	if (type & MSR_TYPE_R)

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>





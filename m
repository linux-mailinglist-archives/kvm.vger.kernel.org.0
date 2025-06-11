Return-Path: <kvm+bounces-48968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1396AD4BEA
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 08:39:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B11E3A64BF
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 06:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777EF22CBC8;
	Wed, 11 Jun 2025 06:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GURpz9Zn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C22155342;
	Wed, 11 Jun 2025 06:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749623945; cv=none; b=Lnt7ZhZoGYmtrSN1Let6sebnO4sRXYXdW2PCZfgvw1J52vh/PyaDqqi8K/5V4hSOfJV76bOyryypHo2wCi5Q0Lkvavqa5YjhpqgYt7cG4W77cfwOvoKZtn7YnBzMkFVMB9JdqX2ozYVYLhXZOhIkWq07tztuEwpY2Eioy4eClzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749623945; c=relaxed/simple;
	bh=1IYbHj4tdUvUVcZCReCBbcjzyo+xZaS1N9jhOBqwUUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TbUOliV10daHTE99YBR1wd21QINEubsiUxe0jio+CpsEkjWX2VgPvMMAHIjLC47Hf9HN2+x02n1X9N0TZLmvh7iAF17/aTXqz7l21quZt7ZVZ/o/u7pl4tvynw8qv+PymnhXP19KDqsl5jkWp17fiWnA6w9FRbqMWZEJvSW/UTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GURpz9Zn; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749623944; x=1781159944;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1IYbHj4tdUvUVcZCReCBbcjzyo+xZaS1N9jhOBqwUUg=;
  b=GURpz9Zn7McXgQ8ZyTCADbHPGk447+0b3hO3q6ASn0yIy2vPWD0u78bX
   FjzECpxAGrkHFQJskxmPbkvlRjdOcbrjJscgDzs/aOOpk/TSN9QolQCZw
   M+1uYf3KZ8P5FXy92G5HU1XZ8ZQ8bjtQCWgoedgq/IIpyt1r5I/Nnff8h
   sYR3h6ar8qumrJVw8VJ4uJ95HFVDgo0miQUvW+E/tpi+Zy2yyzrv/nc+B
   Y0Jpz30dnS/2eSd5EYk45cofqifXxRflTgnpY6frSus+f7TnP6/vKG1CX
   w++yQqTl8Gy7kC2WP1fhZYwk02PhmJzErpkTluexiqyeLxltitdX+mXHD
   g==;
X-CSE-ConnectionGUID: XrZ4ofxuTBu7WWeRP3PdDw==
X-CSE-MsgGUID: rJARdT0VRCu1s76C2Z947A==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="62369831"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="62369831"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 23:39:03 -0700
X-CSE-ConnectionGUID: DsQHjbLuSO648jA2TLRxig==
X-CSE-MsgGUID: MDdkl/NoTtOo2vUEa0P1gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="150921102"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 23:39:01 -0700
Message-ID: <ace63fad-647d-48ff-88bd-9029f9fe0adb@linux.intel.com>
Date: Wed, 11 Jun 2025 14:38:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/32] KVM: x86: Use non-atomic bit ops to manipulate
 "shadow" MSR intercepts
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 Manali Shukla <Manali.Shukla@amd.com>
References: <20250610225737.156318-1-seanjc@google.com>
 <20250610225737.156318-8-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250610225737.156318-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/11/2025 6:57 AM, Sean Christopherson wrote:
> Manipulate the MSR bitmaps using non-atomic bit ops APIs (two underscores),
> as the bitmaps are per-vCPU and are only ever accessed while vcpu->mutex is
> held.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/svm/svm.c | 12 ++++++------
>   arch/x86/kvm/vmx/vmx.c |  8 ++++----
>   2 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7e39b9df61f1..ec97ea1d7b38 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -789,14 +789,14 @@ static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
>   
>   	/* Set the shadow bitmaps to the desired intercept states */
>   	if (read)
> -		set_bit(slot, svm->shadow_msr_intercept.read);
> +		__set_bit(slot, svm->shadow_msr_intercept.read);
>   	else
> -		clear_bit(slot, svm->shadow_msr_intercept.read);
> +		__clear_bit(slot, svm->shadow_msr_intercept.read);
>   
>   	if (write)
> -		set_bit(slot, svm->shadow_msr_intercept.write);
> +		__set_bit(slot, svm->shadow_msr_intercept.write);
>   	else
> -		clear_bit(slot, svm->shadow_msr_intercept.write);
> +		__clear_bit(slot, svm->shadow_msr_intercept.write);
>   }
>   
>   static bool valid_msr_intercept(u32 index)
> @@ -862,8 +862,8 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
>   	bit_write = 2 * (msr & 0x0f) + 1;
>   	tmp       = msrpm[offset];
>   
> -	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
> -	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
> +	read  ? __clear_bit(bit_read,  &tmp) : __set_bit(bit_read,  &tmp);
> +	write ? __clear_bit(bit_write, &tmp) : __set_bit(bit_write, &tmp);
>   
>   	msrpm[offset] = tmp;
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9ff00ae9f05a..8f7fe04a1998 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4029,9 +4029,9 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>   	idx = vmx_get_passthrough_msr_slot(msr);
>   	if (idx >= 0) {
>   		if (type & MSR_TYPE_R)
> -			clear_bit(idx, vmx->shadow_msr_intercept.read);
> +			__clear_bit(idx, vmx->shadow_msr_intercept.read);
>   		if (type & MSR_TYPE_W)
> -			clear_bit(idx, vmx->shadow_msr_intercept.write);
> +			__clear_bit(idx, vmx->shadow_msr_intercept.write);
>   	}
>   
>   	if ((type & MSR_TYPE_R) &&
> @@ -4071,9 +4071,9 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>   	idx = vmx_get_passthrough_msr_slot(msr);
>   	if (idx >= 0) {
>   		if (type & MSR_TYPE_R)
> -			set_bit(idx, vmx->shadow_msr_intercept.read);
> +			__set_bit(idx, vmx->shadow_msr_intercept.read);
>   		if (type & MSR_TYPE_W)
> -			set_bit(idx, vmx->shadow_msr_intercept.write);
> +			__set_bit(idx, vmx->shadow_msr_intercept.write);
>   	}
>   
>   	if (type & MSR_TYPE_R)



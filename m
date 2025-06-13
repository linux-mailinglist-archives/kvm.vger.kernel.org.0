Return-Path: <kvm+bounces-49353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC8AAAD8060
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 03:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6736B3B3DB1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 01:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D18B11DE3CB;
	Fri, 13 Jun 2025 01:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mIRJkkGB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88D02F4317;
	Fri, 13 Jun 2025 01:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749778671; cv=none; b=Yi/9331RVK9zcd0PmR2MR0jVEZKryamG6j8teDcPdqtisG3lczf4lhW6Ej4pkERCqJAskXux/mFuvak5RGrrzJiFaShNmSFeP3DL7A7aB+6/uXsSNBovT13EeiEu3LWrj+lpr9T41+kiNqrA4asGZ0Oi68/2ohaMJnRDO9RkHGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749778671; c=relaxed/simple;
	bh=JdjnJoXwFxt6MMfWyhD6AFSzvj1/Y0xGVzxgB2RjyrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MnVI9p8s7ShRTvjD1QGUZ7yqfhKiG1kZaj228Tq5E7pS58xSDLiE7lO9nL1vE8mvbtbnw4kPcgm4P1bBJ3eTsZ9FKjzc1M604Z8cioQTeZa+FYHUZhpLu+42w1hAd42AwWNo2fkyq1MPlf43wp963jY11FJuKTu9UKJ+wpdQZak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mIRJkkGB; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749778669; x=1781314669;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JdjnJoXwFxt6MMfWyhD6AFSzvj1/Y0xGVzxgB2RjyrI=;
  b=mIRJkkGB/oySdw12JUl0ig7bxbwsI0iYAVcZ2GAh1lb4cBhUD3c3RZGy
   3LruHngWmQIClUzBV1++OAjn5Wq3s6+39yKfnaCKCty2IbmUu6RK9+ntX
   kTMa2a7zExWqXSfu57L0Do57Vt4jG3j5V0Bw9Mmy3xBbU5F8YGEpmFaN/
   cjGAROsroORequrQUhtub4XCA2/sFjNHHzt7Tsf2OnNZeL7bRKzDzxPGA
   UDPGxqG09w306hG6pA4Iw4eVZnxGQuoVbI7mWigjZgLrpxB3hwHzc9+3k
   UmqSOK1lgV55piVQqXkUW8o4SmYfAKpL1iaMd7jSlzT7D+mR2JAD2GWse
   g==;
X-CSE-ConnectionGUID: mE0k6qDUQY+p5nOKpQaGLw==
X-CSE-MsgGUID: PAVzREJbRMW6EumGlFa35w==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="62636945"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="62636945"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 18:37:48 -0700
X-CSE-ConnectionGUID: znXLCPfZRoCR9YShTX4t8Q==
X-CSE-MsgGUID: sFI1Seh4SgWrdP8kE1Hf1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="147566287"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 18:37:45 -0700
Message-ID: <0d1e9a86-41aa-46dd-812b-308db5861b16@linux.intel.com>
Date: Fri, 13 Jun 2025 09:37:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Deduplicate MSR interception enabling and
 disabling
To: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com
References: <20250612081947.94081-1-chao.gao@intel.com>
 <20250612081947.94081-2-chao.gao@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250612081947.94081-2-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 6/12/2025 4:19 PM, Chao Gao wrote:
> Extract a common function from MSR interception disabling logic and create
> disabling and enabling functions based on it. This removes most of the
> duplicated code for MSR interception disabling/enabling.
>
> No functional change intended.
>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/kvm/svm/svm.c | 23 +++++++++--------------
>  arch/x86/kvm/svm/svm.h | 10 +---------
>  arch/x86/kvm/vmx/vmx.c | 25 +++++++++----------------
>  arch/x86/kvm/vmx/vmx.h | 10 +---------
>  4 files changed, 20 insertions(+), 48 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5453478d1ca3..cc5f81afd8af 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -685,21 +685,21 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
>  	return svm_test_msr_bitmap_write(msrpm, msr);
>  }
>  
> -void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
> +void svm_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool enable)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	void *msrpm = svm->msrpm;
>  
>  	/* Don't disable interception for MSRs userspace wants to handle. */
>  	if (type & MSR_TYPE_R) {
> -		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
> +		if (!enable && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
>  			svm_clear_msr_bitmap_read(msrpm, msr);
>  		else
>  			svm_set_msr_bitmap_read(msrpm, msr);
>  	}
>  
>  	if (type & MSR_TYPE_W) {
> -		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
> +		if (!enable && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
>  			svm_clear_msr_bitmap_write(msrpm, msr);
>  		else
>  			svm_set_msr_bitmap_write(msrpm, msr);
> @@ -709,19 +709,14 @@ void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  	svm->nested.force_msr_bitmap_recalc = true;
>  }
>  
> -void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
> +void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  {
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -	void *msrpm = svm->msrpm;
> -
> -	if (type & MSR_TYPE_R)
> -		svm_set_msr_bitmap_read(msrpm, msr);
> -
> -	if (type & MSR_TYPE_W)
> -		svm_set_msr_bitmap_write(msrpm, msr);
> +	svm_set_intercept_for_msr(vcpu, msr, type, false);
> +}
>  
> -	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
> -	svm->nested.force_msr_bitmap_recalc = true;
> +void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
> +{
> +	svm_set_intercept_for_msr(vcpu, msr, type, true);
>  }
>  
>  void *svm_alloc_permissions_map(unsigned long size, gfp_t gfp_mask)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8d3279563261..faa478d9fc62 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -696,15 +696,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
>  
>  void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>  void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
> -
> -static inline void svm_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
> -					     int type, bool enable_intercept)
> -{
> -	if (enable_intercept)
> -		svm_enable_intercept_for_msr(vcpu, msr, type);
> -	else
> -		svm_disable_intercept_for_msr(vcpu, msr, type);
> -}
> +void svm_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool enable);
>  
>  /* nested.c */
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 277c6b5b5d5f..559261b18512 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3952,7 +3952,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
>  	vmx->nested.force_msr_bitmap_recalc = true;
>  }
>  
> -void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
> +void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool enable)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> @@ -3963,35 +3963,28 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  	vmx_msr_bitmap_l01_changed(vmx);
>  
>  	if (type & MSR_TYPE_R) {
> -		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
> +		if (!enable && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
>  			vmx_clear_msr_bitmap_read(msr_bitmap, msr);
>  		else
>  			vmx_set_msr_bitmap_read(msr_bitmap, msr);
>  	}
>  
>  	if (type & MSR_TYPE_W) {
> -		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
> +		if (!enable && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
>  			vmx_clear_msr_bitmap_write(msr_bitmap, msr);
>  		else
>  			vmx_set_msr_bitmap_write(msr_bitmap, msr);
>  	}
>  }
>  
> -void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
> +void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  {
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> -
> -	if (!cpu_has_vmx_msr_bitmap())
> -		return;
> -
> -	vmx_msr_bitmap_l01_changed(vmx);
> -
> -	if (type & MSR_TYPE_R)
> -		vmx_set_msr_bitmap_read(msr_bitmap, msr);
> +	vmx_set_intercept_for_msr(vcpu, msr, type, false);
> +}
>  
> -	if (type & MSR_TYPE_W)
> -		vmx_set_msr_bitmap_write(msr_bitmap, msr);
> +void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
> +{
> +	vmx_set_intercept_for_msr(vcpu, msr, type, true);
>  }
>  
>  static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index a26fe3d9e1d2..31acd8c726e3 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -388,21 +388,13 @@ void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
>  
>  void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>  void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
> +void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool enable);
>  
>  u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>  u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>  
>  gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
>  
> -static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
> -					     int type, bool value)
> -{
> -	if (value)
> -		vmx_enable_intercept_for_msr(vcpu, msr, type);
> -	else
> -		vmx_disable_intercept_for_msr(vcpu, msr, type);
> -}
> -
>  void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
>  
>  /*

The change looks good to me. 

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

Just curious, is there a preference on using these 3 interfaces? When
should we use the disable/enable interfaces? When should be we use the set
interface?  or no preference?




Return-Path: <kvm+bounces-40582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5086AA58CDD
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:25:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA015188ADB3
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5766A1D7E3E;
	Mon, 10 Mar 2025 07:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OjVxBPmi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CAB17BA5;
	Mon, 10 Mar 2025 07:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741591524; cv=none; b=BEXHHxN3/ndukiIl1ZQdqBTABQ4c5cWmkMt1or/kSRbSs1guPhOK6f65EaQbT8r2Qe/xGENaPhb8WNz+AhjtYO/bkd/13Sit2RLdUwrv4/XSGa5irjbUWGe2SGdC9o/wkZhOtOF5z6TZR9yUsxqdd6yzL4gqCHOt/SUUL5XhXKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741591524; c=relaxed/simple;
	bh=W67DMzEwuogDvPpLCC4fTWcsWd7acCqkfXpDWz+haC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t4zIjjbo8SIeN0hW6GbjzISb7x9FKn2KawzS1RfdjGkd+WW4YrF53WpaDNXtVyy0vmMp5EjRCE/sIZ11UeyCCk8BmyyKpg3/fYXgkRSmbw1g1/tOpePb4BpuvEpS7XW07KuUMRX48MBP8b+NXrmy7v0u9Dxb4Boe+jS+KwvaJYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OjVxBPmi; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741591522; x=1773127522;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=W67DMzEwuogDvPpLCC4fTWcsWd7acCqkfXpDWz+haC4=;
  b=OjVxBPmi0e5YlTC1q0jt7g1m/7GRcT0JQ1pehoPJeYsXv3sZK0B6Gt4w
   GFvrokKa4vCPacaZP3eDk0qbY2EHdl9Us0X2cDq7Q5y/Qs4l/3gpmPcgG
   2k8nXJXeYazVLnz+5Ob1XrcRmi/pR3SnYkJFbTGPeY9luDNmjazcWwClf
   IsyMAp5bzB0al+hj2vr7ixO8aSsdZxxohJN0khgUCOS0DBH58pfPpX7fR
   UdudMGK3+CtTCqVqADIacugr636wHN0fNGVrjVI7oPiWBGRszVVRfK9PW
   t3gQBdZur6BmrqCLx4c6a2QHehIvn40SO5mBBlHaCwmMP44ARroHQuvPt
   g==;
X-CSE-ConnectionGUID: HU0yBssMRuu1i8HsmHuy/Q==
X-CSE-MsgGUID: 7HRxNCD2QYaNgRfl8OqRVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="60124647"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="60124647"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:25:22 -0700
X-CSE-ConnectionGUID: 7oSOCb+dSs+ncJlZdy1FGQ==
X-CSE-MsgGUID: gmx0jSDrRCyVFNM7TMvFKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="120072176"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:25:19 -0700
Message-ID: <87def3e5-2e44-4e63-bc6c-9a07077a8c8b@intel.com>
Date: Mon, 10 Mar 2025 15:25:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/10] KVM: x86: Allow to update cached values in
 kvm_user_return_msrs w/o wrmsr
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: adrian.hunter@intel.com, seanjc@google.com, rick.p.edgecombe@intel.com,
 Chao Gao <chao.gao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20250307212053.2948340-1-pbonzini@redhat.com>
 <20250307212053.2948340-7-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250307212053.2948340-7-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/2025 5:20 AM, Paolo Bonzini wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> Several MSRs are constant and only used in userspace(ring 3).  But VMs may
> have different values.  KVM uses kvm_set_user_return_msr() to switch to
> guest's values and leverages user return notifier to restore them when the
> kernel is to return to userspace.  To eliminate unnecessary wrmsr, KVM also
> caches the value it wrote to an MSR last time.
> 
> TDX module unconditionally resets some of these MSRs to architectural INIT
> state on TD exit.  It makes the cached values in kvm_user_return_msrs are
> inconsistent with values in hardware.  This inconsistency needs to be
> fixed.  Otherwise, it may mislead kvm_on_user_return() to skip restoring
> some MSRs to the host's values.  kvm_set_user_return_msr() can help correct
> this case, but it is not optimal as it always does a wrmsr.  So, introduce
> a variation of kvm_set_user_return_msr() to update cached values and skip
> that wrmsr.

My Reviewed-by for the previous version isn't tracked. So again:

Reviewed-by: Xiayao Li <xiaoyao.li@intel.com>

> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-ID: <20250129095902.16391-9-adrian.hunter@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/x86.c              | 24 +++++++++++++++++++-----
>   2 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c89130fda012..1208aee90df1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2326,6 +2326,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>   int kvm_add_user_return_msr(u32 msr);
>   int kvm_find_user_return_msr(u32 msr);
>   int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
> +void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
>   
>   static inline bool kvm_is_supported_user_return_msr(u32 msr)
>   {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e7f8cb43c12..6dcf8998a34f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -636,6 +636,15 @@ static void kvm_user_return_msr_cpu_online(void)
>   	}
>   }
>   
> +static void kvm_user_return_register_notifier(struct kvm_user_return_msrs *msrs)
> +{
> +	if (!msrs->registered) {
> +		msrs->urn.on_user_return = kvm_on_user_return;
> +		user_return_notifier_register(&msrs->urn);
> +		msrs->registered = true;
> +	}
> +}
> +
>   int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>   {
>   	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> @@ -649,15 +658,20 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>   		return 1;
>   
>   	msrs->values[slot].curr = value;
> -	if (!msrs->registered) {
> -		msrs->urn.on_user_return = kvm_on_user_return;
> -		user_return_notifier_register(&msrs->urn);
> -		msrs->registered = true;
> -	}
> +	kvm_user_return_register_notifier(msrs);
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
>   
> +void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
> +{
> +	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> +
> +	msrs->values[slot].curr = value;
> +	kvm_user_return_register_notifier(msrs);
> +}
> +EXPORT_SYMBOL_GPL(kvm_user_return_msr_update_cache);
> +
>   static void drop_user_return_notifiers(void)
>   {
>   	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);



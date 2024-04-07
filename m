Return-Path: <kvm+bounces-13827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D3389AEAD
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 07:37:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68F721F220E2
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 05:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BAE86AC0;
	Sun,  7 Apr 2024 05:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pf/7woyR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCD2184D;
	Sun,  7 Apr 2024 05:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712468226; cv=none; b=GG/uww5TFzXKeCMfiIOzmN6DRn1ld86bgTXh19JaC4SURCPDvYezm6zQfm3kyYwZw+KPCBxjQTqCM95okP4hyVSc6GO+FWvPPc6CbNOyoPxORc8QkxjZWGbXsjLOBs8zN5hVrDudFo5pfLspnXNExByrhRZexxlcJxnWRxjyxCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712468226; c=relaxed/simple;
	bh=p1++XEct0zqjkvfqOY79k0HaC8ytkpJhtyCReqfXBWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HLQpX7VUl6ZoMSX2NVjh/WPzGQUdk1Cean7dCqa3+IwS1OOwjO1JwZbpvTWkXvfq5D574AfKBuBUqYwJaudbUsrItGDQC/JtRh6/5mUDG2v2pZyR6ImFAgnZE4NhaeRwarh+OWeIilTVO2xk6K3JFCxLusEBhCF8rf9AIQbQr8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pf/7woyR; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712468225; x=1744004225;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p1++XEct0zqjkvfqOY79k0HaC8ytkpJhtyCReqfXBWo=;
  b=Pf/7woyRL+Ie8O5R00MnnMOVMQ4RdPQcy2C/OibEjUhg/eyBRnAi7enC
   ERrcYYtMyIbBHk4/FKeSUv0wqC1IAvf3GXWI89UwBcj1pD/U1OmXe7kYP
   8ukG0rBVqHZEhL5dSlTI8DS+V+gIRIxS7HcGo0dUgsg5OWUEZYzVOarky
   G4osX1q0YHrfiKyRkxxHjfVwqumaOnhZZlEhNjUROGq2652DaJ0lC61/w
   XEmz4qS+JcKKaAFNuziYxsSU54FLZuMrg6CO2sYDF38P9wRPWus5f0hye
   QFfKz7IHGl/IHIRkr+UBoXNJS3zNYsGphWHWymS4GoujF950w2I2w12Mf
   w==;
X-CSE-ConnectionGUID: Ax+siIQiR+S70+vvq7Qm1A==
X-CSE-MsgGUID: tsfNep0QRMOaJHAZapQCow==
X-IronPort-AV: E=McAfee;i="6600,9927,11036"; a="7621846"
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="7621846"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 22:37:04 -0700
X-CSE-ConnectionGUID: DrxeY2GYTOqwLNTdzyBxIQ==
X-CSE-MsgGUID: g5DrH5lsQd6L7ZYsAR2Cdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="24043213"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 22:37:01 -0700
Message-ID: <bd193eed-25c0-4b00-86be-cc08d994343e@linux.intel.com>
Date: Sun, 7 Apr 2024 13:36:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 081/130] KVM: x86: Allow to update cached values in
 kvm_user_return_msrs w/o wrmsr
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Chao Gao <chao.gao@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ac270005b09c45512504e1e99a80c56f3019496a.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ac270005b09c45512504e1e99a80c56f3019496a.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
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
                                                                        ^
                                                                extra "are"
> inconsistent with values in hardware.  This inconsistency needs to be
> fixed.  Otherwise, it may mislead kvm_on_user_return() to skip restoring
> some MSRs to the host's values.  kvm_set_user_return_msr() can help correct
> this case, but it is not optimal as it always does a wrmsr.  So, introduce
> a variation of kvm_set_user_return_msr() to update cached values and skip
> that wrmsr.
>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/x86.c              | 25 ++++++++++++++++++++-----
>   2 files changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 36694e784c27..3ab85c3d86ee 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2259,6 +2259,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>   int kvm_add_user_return_msr(u32 msr);
>   int kvm_find_user_return_msr(u32 msr);
>   int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
> +void kvm_user_return_update_cache(unsigned int index, u64 val);
>   
>   static inline bool kvm_is_supported_user_return_msr(u32 msr)
>   {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b361d948140f..1b189e86a1f1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -440,6 +440,15 @@ static void kvm_user_return_msr_cpu_online(void)
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
>   	unsigned int cpu = smp_processor_id();
> @@ -454,15 +463,21 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
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
> +/* Update the cache, "curr", and register the notifier */
Not sure this comment is necessary, since the code is simple.

> +void kvm_user_return_update_cache(unsigned int slot, u64 value)

As a public API, is it better to use "kvm_user_return_msr_update_cache" 
instead of "kvm_user_return_update_cache"?
Although it makes the API name longer...

> +{
> +	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> +
> +	msrs->values[slot].curr = value;
> +	kvm_user_return_register_notifier(msrs);
> +}
> +EXPORT_SYMBOL_GPL(kvm_user_return_update_cache);
> +
>   static void drop_user_return_notifiers(void)
>   {
>   	unsigned int cpu = smp_processor_id();



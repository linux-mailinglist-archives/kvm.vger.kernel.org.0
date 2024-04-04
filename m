Return-Path: <kvm+bounces-13613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD9B899069
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 23:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C40C1F265C7
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 21:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577A913BAD6;
	Thu,  4 Apr 2024 21:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wz6eEZaJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A9A13BACE;
	Thu,  4 Apr 2024 21:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712266232; cv=none; b=D4Cj3bvUfmF29SvcIx7TU3e+0bV7pubBeaZ+Hac5HX9f5wm5mJQU0yoeTQoGbq2qysq9UbmmUQeZErXr/WFXU4gmLcSvTpdyaKaBPGKO0p5KC+jYiX/6wHm36DAR5FNyrfGcSrQO1IvPjPrCz8x/PaVF2QTUpBPjUlEOvAnrvws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712266232; c=relaxed/simple;
	bh=zrMhg+chIdUlUIfaxG9iqXyU9uU2QCYMuBzDWEPDRpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgA6O6DhNDKjvrKIapozlqHlYKvmlWtKVJ/tpazx1592VIHUhZFLB7UvoJ77fLVYL/yWr5lifmIKo3D10OChIiobM2KNAiOEg1n105a37yI71I3XY3IEDP3jJdOQrjLNZhBpf5V9B3Qn4FNTdX6IVWlN3E3SK+qGI/FJ7sMGKP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wz6eEZaJ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712266230; x=1743802230;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zrMhg+chIdUlUIfaxG9iqXyU9uU2QCYMuBzDWEPDRpk=;
  b=Wz6eEZaJKG1iESY2J4MahimBV1fpsHNhGDKnmZTmX0y+JIG55fwU3gz0
   WQ4P18cLq9Q1Ur/03WvvtXxu5z0Svk+95Rthko629j4QsCNMMEhTPtgmW
   QBmc66Eb+07nfNzw56PIuTaqaorBQHmTgDAUXzVg+/wyT25NbdAlRAZ9k
   IJ7qwtteoBJTJtTHJ7f4V4RkSmF80+bCIXchjTfZpY4RBzc+Eljrqe68d
   yaJCxQ4A+URIjfoSJ0CZxWQHtw7tX7HLRRuqx8IkLeaR0HxSPvianuruz
   ZX9Nh8f6INW8aXewwHtnvw854mvs7gOgUU3JfCXzlDNlXeqldEo5kbtAS
   w==;
X-CSE-ConnectionGUID: KyD55J4ySN21jjYDqXtXVw==
X-CSE-MsgGUID: Hdo8aW/sRcWPRYMSbZieqg==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="7681787"
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="7681787"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 14:30:30 -0700
X-CSE-ConnectionGUID: bU8zSvV6RtyJxtBaW4nT4g==
X-CSE-MsgGUID: FwNC0MB3QCyxA9M+sYFwjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="18894465"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 14:30:28 -0700
Date: Thu, 4 Apr 2024 14:30:28 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com,
	isaku.yamahata@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v5 04/17] KVM: introduce new vendor op for
 KVM_GET_DEVICE_ATTR
Message-ID: <20240404213028.GQ2444378@ls.amr.corp.intel.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
 <20240404121327.3107131-5-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240404121327.3107131-5-pbonzini@redhat.com>

On Thu, Apr 04, 2024 at 08:13:14AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Allow vendor modules to provide their own attributes on /dev/kvm.
> To avoid proliferation of vendor ops, implement KVM_HAS_DEVICE_ATTR
> and KVM_GET_DEVICE_ATTR in terms of the same function.  You're not
> supposed to use KVM_GET_DEVICE_ATTR to do complicated computations,
> especially on /dev/kvm.
> 
> Reviewed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/x86.c                 | 38 +++++++++++++++++++-----------
>  3 files changed, 26 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 110d7f29ca9a..5187fcf4b610 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -121,6 +121,7 @@ KVM_X86_OP(enter_smm)
>  KVM_X86_OP(leave_smm)
>  KVM_X86_OP(enable_smi_window)
>  #endif
> +KVM_X86_OP_OPTIONAL(dev_get_attr)
>  KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 16e07a2eee19..04c430eb25cf 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1778,6 +1778,7 @@ struct kvm_x86_ops {
>  	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
>  #endif
>  
> +	int (*dev_get_attr)(u32 group, u64 attr, u64 *val);
>  	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
>  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3d2029402513..3934e7682734 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4842,34 +4842,44 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	return r;
>  }
>  
> -static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
> +static int __kvm_x86_dev_get_attr(struct kvm_device_attr *attr, u64 *val)
>  {
> -	u64 __user *uaddr = u64_to_user_ptr(attr->addr);
> -
> -	if (attr->group)
> +	if (attr->group) {
> +		if (kvm_x86_ops.dev_get_attr)
> +			return static_call(kvm_x86_dev_get_attr)(attr->group, attr->attr, val);
>  		return -ENXIO;
> +	}
>  
>  	switch (attr->attr) {
>  	case KVM_X86_XCOMP_GUEST_SUPP:
> -		if (put_user(kvm_caps.supported_xcr0, uaddr))
> -			return -EFAULT;
> +		*val = kvm_caps.supported_xcr0;
>  		return 0;
>  	default:
>  		return -ENXIO;
>  	}
>  }
>  
> +static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
> +{
> +	u64 __user *uaddr = u64_to_user_ptr(attr->addr);
> +	int r;
> +	u64 val;
> +
> +	r = __kvm_x86_dev_get_attr(attr, &val);
> +	if (r < 0)
> +		return r;
> +
> +	if (put_user(val, uaddr))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  static int kvm_x86_dev_has_attr(struct kvm_device_attr *attr)
>  {
> -	if (attr->group)
> -		return -ENXIO;
> +	u64 val;
>  
> -	switch (attr->attr) {
> -	case KVM_X86_XCOMP_GUEST_SUPP:
> -		return 0;
> -	default:
> -		return -ENXIO;
> -	}
> +	return __kvm_x86_dev_get_attr(attr, &val);
>  }
>  
>  long kvm_arch_dev_ioctl(struct file *filp,
> -- 
> 2.43.0
> 
> 
> 

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@intel.com>


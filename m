Return-Path: <kvm+bounces-21662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4013F931D19
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 00:18:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 720621C21A0E
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 22:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD2613D63D;
	Mon, 15 Jul 2024 22:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dgv/gLk4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AF961FFA
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 22:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721081889; cv=none; b=JGzULfsLooaDNRY30F+UOxmcO766N+TJ5WfqWcJNuIDR7qM/q31JsfMR55/ZKv+4V6Akz+CobjQGsXUxpuoa6d1n5gWQ+Tcc5SshF7tt83q5YALHQi2TE+kgsqqcwOYJ49JPOKb2q0rXSNY1pRem+CWXmXTG7RVhsloKpncF4pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721081889; c=relaxed/simple;
	bh=2YgFoHODqt4L+Pm9WlXpmTOMLOXM6RHzyurXphg1p8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gWangJKtGdXRHEY5vnBY5DI8zVjCKBoicTo21D+UYJ5O1/eESLVV42uUI9hJEhWX8TghQ9NJHWQPw4Yoa470/OmnRZ20elRs8q5hDoCzLQc61aY3AgPVRm/6dpk6FG0xqeNa/pbQ4W0kI6bQGfU8bV3AU08Xs5eC9+o5pi2k5jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dgv/gLk4; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721081888; x=1752617888;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2YgFoHODqt4L+Pm9WlXpmTOMLOXM6RHzyurXphg1p8Y=;
  b=dgv/gLk4bwmv+vdHajjfJx4Bwy946rxrR137QgPBR7Bfiw88j7BZuGpa
   2d2Mc9I1+IqcnaFAcAF/OvNDoGrDtGZLRAxjTNq4grI0P5nX9970RnCej
   S8vVOSb76XFNfEusxw+BRPCCcP5JXdosLX9oBzdatY4xqaQPOKge7KDmX
   t1patAr4PPmlTNrNM1vYVlrye28B0cOls6LsxHEoYdAJ0aJFmiPzFqMpN
   yIXumPsOGcfRz84WYo/vyhbxZvyDrmz1YkzbphJ1L+qDQTT+d0v45Y29k
   ne9ryCnZ3AOsaOkb+sFJrywAIoOqtfLhNZQZDCW2kg8kSz2kZd9hK2RHd
   w==;
X-CSE-ConnectionGUID: Syb7E2qcTR+MGu5g+PrM5A==
X-CSE-MsgGUID: hFg9R3b9Tm22/s834Ntefw==
X-IronPort-AV: E=McAfee;i="6700,10204,11134"; a="18683578"
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="18683578"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 15:18:07 -0700
X-CSE-ConnectionGUID: Mas0uYIbTQyIrIQyyRq/3g==
X-CSE-MsgGUID: 8W8PHA3NSL6zfuM+4XgHKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="54313872"
Received: from unknown (HELO [10.124.109.200]) ([10.124.109.200])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 15:18:06 -0700
Message-ID: <f8f2cfb9-1128-4e1f-a152-3f88587927a1@intel.com>
Date: Mon, 15 Jul 2024 15:18:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] target/i386/kvm: Clean up return values of MSR
 filter related functions
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240715044955.3954304-1-zhao1.liu@intel.com>
 <20240715044955.3954304-8-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240715044955.3954304-8-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/14/2024 9:49 PM, Zhao Liu wrote:
> @@ -5274,13 +5272,13 @@ void kvm_arch_update_guest_debug(CPUState *cpu, struct kvm_guest_debug *dbg)
>      }
>  }
>  
> -static bool kvm_install_msr_filters(KVMState *s)
> +static int kvm_install_msr_filters(KVMState *s)
>  {
>      uint64_t zero = 0;
>      struct kvm_msr_filter filter = {
>          .flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
>      };
> -    int r, i, j = 0;
> +    int ret, i, j = 0;
>  
>      for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {

Nit: Since it's a clean up patch, how about replace
KVM_MSR_FILTER_MAX_RANGES with ARRAY_SIZE(msr_handlers), to make the
code consistent in other places to refer to the array size of
msr_handlers[].

>          KVMMSRHandlers *handler = &msr_handlers[i];
> @@ -5304,18 +5302,18 @@ static bool kvm_install_msr_filters(KVMState *s)
>          }
>      }
>  
> -    r = kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
> -    if (r) {
> -        return false;
> +    ret = kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
> +    if (ret) {
> +        return ret;
>      }
>  
> -    return true;
> +    return 0;
>  }

Nit: Seems ret is not needed here, and can directly return kvm_vm_ioctl();


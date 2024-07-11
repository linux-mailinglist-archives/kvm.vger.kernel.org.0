Return-Path: <kvm+bounces-21394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F6092DFA7
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 07:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87C821F22ADA
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 05:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EFAC7B3FD;
	Thu, 11 Jul 2024 05:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MBEmQ77T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFAE76034;
	Thu, 11 Jul 2024 05:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720676223; cv=none; b=B4eB6HhpaiG59DNkwS19rcIBTh5DzVsnGUfglhNrJJ62EzD2R0htl2aJe3A8wN7VkFZQHjC6t82pKnyYXKxg8VZI4iyHRlGxbovOG78wZ8m2IjDrAE3k/PXtORSmX6kJ5chJ3Jwuq8xqC9KUDRWMQ1tFZxjn8kFRiZVKc+x9nPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720676223; c=relaxed/simple;
	bh=RY7j047eHSucxb/myX4oFbdM21wmMkFAciMa0GJ9Sjg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WBbqNwZBJQeOoetSv8Uu/d2/hBCh7ekS0wbkraYEkBcC8aH7x2d4bOnV9L6nyRTaHy+FHR92jjgVYFFWWPbfLd8oyl7VDFtRicvUbDCTcTSKe3d5v+yyC/LOXrym+KllA6WU67lN8T/LoOrpfVYd3i4li3H1+Gmw+DLMMKy61Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MBEmQ77T; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720676222; x=1752212222;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RY7j047eHSucxb/myX4oFbdM21wmMkFAciMa0GJ9Sjg=;
  b=MBEmQ77TcJE2FQ2rFVd+3LgeRVRGR59HHs3yPWRnYeLaftPRBVgy2h8D
   ngHl8IkCpn9oI33JB4sIrM+QQZA31yx099dqGvyT/JGY6YAGpyS0v2H8n
   ns/F4K0Ax4xV/6uUeD9UeB4O4se9BTOkVl6uBx//ir8i2EiNg4Fz9lQVl
   T/3vlwkxeeCFUS5Y/TEKhmmrW5QQVLWcOKld5Jsiaxlpz4uHfxlEH5VcY
   FRl9TznEhhbc2zDkbt9XIOYGv8WeCve87FkdbCGBFgs5KilBkI4pZqyLU
   SmsuMgGwRL5XbqPNw6D9d6CM9DhPJOPU2GOO61ktQjmvPWxYAMiJfBY06
   w==;
X-CSE-ConnectionGUID: wTi1zaBaSLCRJy225tXhww==
X-CSE-MsgGUID: L2TTcFzbQ3GEzl0LJhJahw==
X-IronPort-AV: E=McAfee;i="6700,10204,11129"; a="21796781"
X-IronPort-AV: E=Sophos;i="6.09,199,1716274800"; 
   d="scan'208";a="21796781"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 22:37:02 -0700
X-CSE-ConnectionGUID: aLeeabu9ST2cGkFNx8MHtA==
X-CSE-MsgGUID: bdHrqi43RLynhMs56uwD2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,199,1716274800"; 
   d="scan'208";a="53267014"
Received: from taofen1x-mobl1.ccr.corp.intel.com (HELO [10.238.11.85]) ([10.238.11.85])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 22:36:58 -0700
Message-ID: <cd52fe00-b57b-495c-b55c-54fd381f7c66@linux.intel.com>
Date: Thu, 11 Jul 2024 13:36:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] KVM: x86: Implement
 kvm_arch_vcpu_pre_fault_memory()
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com, seanjc@google.com, xiaoyao.li@intel.com
References: <20240710174031.312055-1-pbonzini@redhat.com>
 <20240710174031.312055-7-pbonzini@redhat.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240710174031.312055-7-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/11/2024 1:40 AM, Paolo Bonzini wrote:
> Wire KVM_PRE_FAULT_MEMORY ioctl to __kvm_mmu_do_page_fault() to populate guest

__kvm_mmu_do_page_fault() -> kvm_mmu_do_page_fault()



> memory.  It can be called right after KVM_CREATE_VCPU creates a vCPU,
> since at that point kvm_mmu_create() and kvm_init_mmu() are called and
> the vCPU is ready to invoke the KVM page fault handler.
>
> The helper function kvm_mmu_map_tdp_page take care of the logic to

kvm_mmu_map_tdp_page -> kvm_tdp_map_page()?



> process RET_PF_* return values and convert them to success or errno.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-ID: <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/Kconfig   |  1 +
>   arch/x86/kvm/mmu/mmu.c | 73 ++++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/x86.c     |  3 ++
>   3 files changed, 77 insertions(+)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 80e5afde69f4..4287a8071a3a 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -44,6 +44,7 @@ config KVM
>   	select KVM_VFIO
>   	select HAVE_KVM_PM_NOTIFIER if PM
>   	select KVM_GENERIC_HARDWARE_ENABLING
> +	select KVM_GENERIC_PRE_FAULT_MEMORY
>   	select KVM_WERROR if WERROR
>   	help
>   	  Support hosting fully virtualized guest machines using hardware
[...]
> index ba0ad76f53bc..a6968eadd418 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4705,6 +4705,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_MEMORY_FAULT_INFO:
>   		r = 1;
>   		break;
> +	case KVM_CAP_PRE_FAULT_MEMORY:
> +		r = tdp_enabled;
> +		break;
If !CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY, this should return 0.

>   	case KVM_CAP_EXIT_HYPERCALL:
>   		r = KVM_EXIT_HYPERCALL_VALID_MASK;
>   		break;



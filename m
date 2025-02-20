Return-Path: <kvm+bounces-38687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7966A3DA2C
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EDB53BE4AC
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284941F4276;
	Thu, 20 Feb 2025 12:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ivO0TQN2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB4817BD9;
	Thu, 20 Feb 2025 12:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740054951; cv=none; b=aypvXy0G6tIlRbt85Xr/bN+m1EUEFYpqxsnZZNkmMY0jeEOhYg/tvkEqy9bjurYdJfeBH2u2/2jdyxbU5Ktm3p1t7uwzDdH1rhd43dLLLIuGG8Ym+KFmgrEst07FJxQO+2vF8oXa5XE+c0yLcIVcvNcmyKCw3Mm0xvZ3f8Cn9sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740054951; c=relaxed/simple;
	bh=0QwIgkWVP2/Cav3UV0ci9w0d+vAkrrudhx5U24fyz2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SLleONM5WnPbBMdZ2SCfpQ8eNo9THCLE1jUCXGfk7L0BGO9p8UFwZsclZRx0GlCirg6EQZukkzC2Aj2Ew0etiTnvlLzQy9pX46ZvqQZizq1eRlxgVcHERaX8C0R8SUERgF2Y7cJg9HwXRWVHXzFVmXqIE7WwBocfWW05pXLSorY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ivO0TQN2; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740054949; x=1771590949;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0QwIgkWVP2/Cav3UV0ci9w0d+vAkrrudhx5U24fyz2w=;
  b=ivO0TQN203D1q28hoEruxD7vLtxbLl9Ou/sJvBZDnF7oWwY1740WPxuX
   Z5AEMojYHalBoXcpgc5DgsLR2ks1eM1C6xJiA7gwkWPOed9MWn9odlAI1
   QmGMUxZvOXG/TZMJdEFNo1Z69DmtMy3Jp62gSn9qnyLURW0r6xJ/De5pH
   7GCZzz8yIZuT0EnNFJeJ9CCZwCWEYMQU9JSP81RZrkEXljPd8fk/s5xV7
   M2RBdk1WZcwfvZoX7r8n2Wd0yYcGMcxan1IwZYpQ7S/gxCmB7GBsSjxdf
   XOCpZc5sCUqy/rjiGzL4OCHfsB+JaHQhPW/9KU2KZtJfw/QwFThUiIOK3
   A==;
X-CSE-ConnectionGUID: EJ8jNgTgTzulQqC61YZp+w==
X-CSE-MsgGUID: jRmuQCqaS/SA+2uTMv7xqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="44480347"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="44480347"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 04:35:49 -0800
X-CSE-ConnectionGUID: C3Z51hfVRRuhOTs8A+nHyg==
X-CSE-MsgGUID: 0KGcxSdjS+uZY5hbfHqRnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="145880883"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 04:35:44 -0800
Message-ID: <53e4e2f5-3769-4bbe-b68c-bd9d09a06805@intel.com>
Date: Thu, 20 Feb 2025 20:35:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 03/12] KVM: TDX: Set arch.has_protected_state to true
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-4-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250129095902.16391-4-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/2025 5:58 PM, Adrian Hunter wrote:
> TDX VMs have protected state. Accordingly, set arch.has_protected_state to
> true.
> 
> This will cause the following IOCTL functions to return an error:
> 
> 	kvm_arch_vcpu_ioctl()	case KVM_GET_SREGS2
> 	kvm_arch_vcpu_ioctl()	case KVM_SET_SREGS2
> 	kvm_arch_vcpu_ioctl_get_regs()
> 	kvm_arch_vcpu_ioctl_set_regs()
> 	kvm_arch_vcpu_ioctl_get_sregs()
> 	kvm_arch_vcpu_ioctl_set_sregs()
> 	kvm_vcpu_ioctl_x86_get_debugregs()
> 	kvm_vcpu_ioctl_x86_set_debugregs
> 	kvm_vcpu_ioctl_x86_get_xcrs()
> 	kvm_vcpu_ioctl_x86_set_xcrs()
> 
> In addition, the following will error for confidential FPU state:
> 
> 	kvm_vcpu_ioctl_x86_get_xsave ()
> 	kvm_vcpu_ioctl_x86_get_xsave2()
> 	kvm_vcpu_ioctl_x86_set_xsave()
> 	kvm_arch_vcpu_ioctl_get_fpu()
> 	kvm_arch_vcpu_ioctl_set_fpu()
> 
> And finally, in accordance with commit 66155de93bcf ("KVM: x86: Disallow
> read-only memslots for SEV-ES and SEV-SNP (and TDX)"), read-only
> memslots will be disallowed.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
> TD vcpu enter/exit v2:
>   - New patch
> ---
>   arch/x86/kvm/vmx/tdx.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ea9498028212..a7ebdafdfd82 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -553,6 +553,7 @@ int tdx_vm_init(struct kvm *kvm)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>   
> +	kvm->arch.has_protected_state = true;

This can be squashed into the one that implements the tdx_vm_init();

>   	kvm->arch.has_private_mem = true;
>   
>   	/*



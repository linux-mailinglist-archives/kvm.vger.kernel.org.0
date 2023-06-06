Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCC8723628
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 06:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbjFFEUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 00:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjFFEUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 00:20:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE7219C;
        Mon,  5 Jun 2023 21:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686025209; x=1717561209;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nnz9fZvyDWSFCGNXmQbJTPH46HIsD8UF+79vDgHHkkE=;
  b=ebKEmJoN3pr7fJvr5aS66vdBwRHY7PZfKchFUxL933DpGECr0x8Fe7BZ
   od36wVa7gjL0eptRVb8EBIy2n824FrMNypgicXgirXrag0cGlehBsMrCf
   QrfymbjKpdWSGAVX9ZT+1ZRXeq2g7x+zwEFOIsedUSnZo/p1PtD6aFKrQ
   I5WKohvxm7HcOvTyLrBLWk4wo3BFOht+CpIWb6sFACYQZVWBrfAndp393
   0kSK0qlBT6bML2VEQmrN7G+7V96Sd1+rYJIZg46562Shbo9EbU79dOzvi
   TOe1kXhjxj0qsVYMpwjrL0001sRiDTfRvSrWHuXVWbgNF/2iFryITPvgX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="346154734"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="346154734"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 21:20:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="955590355"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="955590355"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.210.225]) ([10.254.210.225])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 21:20:05 -0700
Message-ID: <a8e89abd-3480-8568-afcb-2645d2cd3d31@linux.intel.com>
Date:   Tue, 6 Jun 2023 12:20:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v1 5/6] KVM: x86: LASS protection on KVM emulation
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-6-guang.zeng@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230601142309.6307-6-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/1/2023 10:23 PM, Zeng Guang wrote:
> Do LASS violation check for instructions emulated by KVM. Note that for
> instructions executed in the guest directly, hardware will perform the
> check.
>
> Not all instruction emulation leads to accesses to guest linear addresses
> because 1) some instructions like CPUID, RDMSR, don't take memory as
> operands 2) instruction fetch in most cases is already done inside the
> guest.
>
> Four cases in which KVM uses a linear address to access guest memory:
> - KVM emulates instruction fetches or data accesses
> - KVM emulates implicit data access to a system data structure
> - VMX instruction emulation
> - SGX ENCLS instruction emulation
>
> LASS violation check applies to these linear addresses so as to enforce
> mode-based protections as hardware behaves.
>
> As exceptions, the target memory address of emulation of invlpg, branch
> and call instructions doesn't require LASS violation check.
I think LASS doesn't apply to the target addresses in the descriptors of 
INVPCID and INVVPID.
Although no code change needed, IMHO, it's better to describe it in the 
changelog or/and comments.

>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
>   arch/x86/kvm/emulate.c    | 30 ++++++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/nested.c |  3 +++
>   arch/x86/kvm/vmx/sgx.c    |  4 ++++
>   3 files changed, 35 insertions(+), 2 deletions(-)
>
[...]
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e35cf0bd0df9..bb1c3fa13c13 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4986,6 +4986,9 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>   		 * destination for long mode!
>   		 */
>   		exn = is_noncanonical_address(*ret, vcpu);
> +
> +		if (!exn)
> +			exn = vmx_check_lass(vcpu, 0, *ret, 0);
Can be simpler by using logical-or:

exn = is_noncanonical_address(*ret, vcpu) || vmx_check_lass(vcpu, 0, *ret, 0);



>   	} else {
>   		/*
>   		 * When not in long mode, the virtual/linear address is
> diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> index 2261b684a7d4..3825275827eb 100644
> --- a/arch/x86/kvm/vmx/sgx.c
> +++ b/arch/x86/kvm/vmx/sgx.c
> @@ -46,6 +46,10 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
>   			((s.base != 0 || s.limit != 0xffffffff) &&
>   			(((u64)*gva + size - 1) > s.limit + 1));
>   	}
> +
> +	if (!fault && is_long_mode(vcpu))
> +		fault = vmx_check_lass(vcpu, 0, *gva, 0);
> +
>   	if (fault)
>   		kvm_inject_gp(vcpu, 0);
>   	return fault ? -EINVAL : 0;


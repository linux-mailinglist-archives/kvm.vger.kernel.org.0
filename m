Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7697A1BADA6
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 21:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgD0TO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 15:14:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:10084 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgD0TO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 15:14:26 -0400
IronPort-SDR: HwlomlydnxAdLRAkrQ87jo2wrOqY0U2peL1lvnUVp9lh8M+crj32OL17I6/QpY0qJVNMHxrQkO
 AU52vLCka0FA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 12:14:25 -0700
IronPort-SDR: gzUxp7x/wVIYo8UjIVrdMQiya1O8wrcACOFA7QL2i0M2fQTRuBjb0pGYtP2DI74hpvKmKkUGKk
 Lk+VBsDEglCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="431885692"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 27 Apr 2020 12:14:25 -0700
Date:   Mon, 27 Apr 2020 12:14:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: VMX: Remove unneeded __ASM_SIZE usage with POP
 instruction
Message-ID: <20200427191425.GS14870@linux.intel.com>
References: <20200426123038.359779-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426123038.359779-1-ubizjak@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 26, 2020 at 02:30:38PM +0200, Uros Bizjak wrote:
> POP instruction always operates in word size, no need to
> use __ASM_SIZE macro to force operating mode.

Nit, "always operates in word size" isn't quite correct, it'd be more
accurate to state "POP [mem] defaults to the word size, and the only
legal non-default size is 16 bits, e.g. a 32-bit POP will #UD in 64-bit
mode and vice versa, no need ...".

With a tweaked changelog:

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 87f3f24fef37..94b8794bdd2a 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -163,13 +163,13 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	mov WORD_SIZE(%_ASM_SP), %_ASM_AX
>  
>  	/* Save all guest registers, including RAX from the stack */
> -	__ASM_SIZE(pop) VCPU_RAX(%_ASM_AX)
> -	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
> -	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
> -	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
> -	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
> -	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
> -	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
> +	pop           VCPU_RAX(%_ASM_AX)
> +	mov %_ASM_CX, VCPU_RCX(%_ASM_AX)
> +	mov %_ASM_DX, VCPU_RDX(%_ASM_AX)
> +	mov %_ASM_BX, VCPU_RBX(%_ASM_AX)
> +	mov %_ASM_BP, VCPU_RBP(%_ASM_AX)
> +	mov %_ASM_SI, VCPU_RSI(%_ASM_AX)
> +	mov %_ASM_DI, VCPU_RDI(%_ASM_AX)
>  #ifdef CONFIG_X86_64
>  	mov %r8,  VCPU_R8 (%_ASM_AX)
>  	mov %r9,  VCPU_R9 (%_ASM_AX)
> -- 
> 2.25.3
> 

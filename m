Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189DE1BADD8
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 21:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgD0TZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 15:25:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:11840 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgD0TZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 15:25:12 -0400
IronPort-SDR: 5cRvX6ZSLWAmqohrgDgIlxx+tluWeUiHSSJSPLK/BfXKbNweb8XQU/zDozoAvEV7/lFGvNsKp8
 Q38JgY5f2yNw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 12:25:12 -0700
IronPort-SDR: Cx7K0NL+wJX8a1A2fM3ex6v+A5Yqfvx6X7jhEGbZm09FHH0X22r15RLoyoC5kPHC4TDQlkHHa+
 QkLdoO1SCduQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="293631514"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 27 Apr 2020 12:25:12 -0700
Date:   Mon, 27 Apr 2020 12:25:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: VMX: Improve handle_external_interrupt_irqoff
 inline assembly
Message-ID: <20200427192512.GT14870@linux.intel.com>
References: <20200426115255.305060-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426115255.305060-1-ubizjak@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 26, 2020 at 01:52:55PM +0200, Uros Bizjak wrote:
> Improve handle_external_interrupt_irqoff inline assembly in several ways:
> - use "n" operand constraint instead of "i" and remove

What's the motivation for using 'n'?  The 'i' variant is much more common,
i.e. less likely to trip up readers.

  $ git grep -E "\"i\"\s*\(" | wc -l
  768
  $ git grep -E "\"n\"\s*\(" | wc -l
  11

>   unneeded %c operand modifiers and "$" prefixes
> - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> - use $-16 immediate to align %rsp

Heh, this one depends on the reader, I find 0xfffffffffffffff0 to be much
more intuitive, though admittedly also far easier to screw up.

> - remove unneeded use of __ASM_SIZE macro
> - define "ss" named operand only for X86_64
> 
> The patch introduces no functional changes.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c2c6335a998c..7471f1b948b3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6283,13 +6283,13 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  
>  	asm volatile(
>  #ifdef CONFIG_X86_64
> -		"mov %%" _ASM_SP ", %[sp]\n\t"
> -		"and $0xfffffffffffffff0, %%" _ASM_SP "\n\t"
> -		"push $%c[ss]\n\t"
> +		"mov %%rsp, %[sp]\n\t"
> +		"and $-16, %%rsp\n\t"
> +		"push %[ss]\n\t"
>  		"push %[sp]\n\t"
>  #endif
>  		"pushf\n\t"
> -		__ASM_SIZE(push) " $%c[cs]\n\t"
> +		"push %[cs]\n\t"
>  		CALL_NOSPEC
>  		:
>  #ifdef CONFIG_X86_64
> @@ -6298,8 +6298,10 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  		ASM_CALL_CONSTRAINT
>  		:
>  		[thunk_target]"r"(entry),
> -		[ss]"i"(__KERNEL_DS),
> -		[cs]"i"(__KERNEL_CS)
> +#ifdef CONFIG_X86_64
> +		[ss]"n"(__KERNEL_DS),
> +#endif
> +		[cs]"n"(__KERNEL_CS)
>  	);
>  
>  	kvm_after_interrupt(vcpu);
> -- 
> 2.25.3
> 

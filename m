Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F7F1C3E6C
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgEDPZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 11:25:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:54713 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729217AbgEDPZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 11:25:21 -0400
IronPort-SDR: KXKsBcF2PTe9aqYYS1HW2f4HLq+ZcXssb1rbjKABGWXW5qEgQhlAEnEax4c76ietUHVXNgjB5j
 H22vr1NeebIg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 08:25:20 -0700
IronPort-SDR: Oz75ZeQHnctQQzLc23r9N2oYgoc0ARf1BAVA2t59kRZhHaXovh0EkPk+9fXiAJqDmcyrgHLJ3l
 DARvYyW1WPKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,352,1583222400"; 
   d="scan'208";a="294653947"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 04 May 2020 08:25:19 -0700
Date:   Mon, 4 May 2020 08:25:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4] KVM: VMX: Improve handle_external_interrupt_irqoff
 inline assembly
Message-ID: <20200504152519.GC16949@linux.intel.com>
References: <20200503230545.442042-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200503230545.442042-1-ubizjak@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 01:05:45AM +0200, Uros Bizjak wrote:
> Improve handle_external_interrupt_irqoff inline assembly in several ways:
> - use "re" operand constraint instead of "i" and remove
>   unneeded %c operand modifiers and "$" prefixes
> - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> - use $-16 immediate to align %rsp
> - remove unneeded use of __ASM_SIZE macro
> - define "ss" named operand only for X86_64
> 
> The patch introduces no functional changes.

Hmm, for handcoded assembly I would argue that the switch from "i" to "re"
is a functional change of sorts.  The switch also needs explicit
justification to explain why it's correct/desirable.  Maybe make it a
separate patch?

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c2c6335a998c..56c742effb30 100644
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
> +		[ss]"re"(__KERNEL_DS),
> +#endif
> +		[cs]"re"(__KERNEL_CS)
>  	);
>  
>  	kvm_after_interrupt(vcpu);
> -- 
> 2.25.4
> 

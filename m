Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D78C180626
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 19:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgCJSYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 14:24:23 -0400
Received: from mga17.intel.com ([192.55.52.151]:3919 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgCJSYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 14:24:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 11:24:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,537,1574150400"; 
   d="scan'208";a="231413756"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 10 Mar 2020 11:24:22 -0700
Date:   Tue, 10 Mar 2020 11:24:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: VMX: access regs array in vmenter.S in its natural
 order
Message-ID: <20200310182422.GG9305@linux.intel.com>
References: <20200310171024.15528-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310171024.15528-1-ubizjak@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 06:10:24PM +0100, Uros Bizjak wrote:
> Registers in "regs" array are indexed as rax/rcx/rdx/.../rsi/rdi/r8/...
> Reorder access to "regs" array in vmenter.S to follow its natural order.

Any reason other than preference?  I wouldn't exactly call the register
indices "natural", e.g. IMO it's easier to visually confirm correctness if
A/B/C/D are ordered alphabetically.

> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 81ada2ce99e7..ca2065166d1d 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -135,12 +135,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	cmpb $0, %bl
>  
>  	/* Load guest registers.  Don't clobber flags. */
> -	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
>  	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
>  	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
> +	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
> +	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
>  	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
>  	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
> -	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
>  #ifdef CONFIG_X86_64
>  	mov VCPU_R8 (%_ASM_AX),  %r8
>  	mov VCPU_R9 (%_ASM_AX),  %r9
> @@ -168,12 +168,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  
>  	/* Save all guest registers, including RAX from the stack */
>  	__ASM_SIZE(pop) VCPU_RAX(%_ASM_AX)
> -	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
>  	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
>  	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
> +	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
> +	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
>  	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
>  	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
> -	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
>  #ifdef CONFIG_X86_64
>  	mov %r8,  VCPU_R8 (%_ASM_AX)
>  	mov %r9,  VCPU_R9 (%_ASM_AX)
> @@ -197,12 +197,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	 * free.  RSP and RAX are exempt as RSP is restored by hardware during
>  	 * VM-Exit and RAX is explicitly loaded with 0 or 1 to return VM-Fail.
>  	 */
> -1:	xor %ebx, %ebx
> -	xor %ecx, %ecx
> +1:	xor %ecx, %ecx
>  	xor %edx, %edx
> +	xor %ebx, %ebx
> +	xor %ebp, %ebp
>  	xor %esi, %esi
>  	xor %edi, %edi
> -	xor %ebp, %ebp
>  #ifdef CONFIG_X86_64
>  	xor %r8d,  %r8d
>  	xor %r9d,  %r9d
> -- 
> 2.24.1
> 

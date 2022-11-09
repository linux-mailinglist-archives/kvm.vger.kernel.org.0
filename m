Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2664622371
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 06:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiKIFd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 00:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKIFdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 00:33:25 -0500
X-Greylist: delayed 960 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Nov 2022 21:33:17 PST
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E717C1BE93;
        Tue,  8 Nov 2022 21:33:17 -0800 (PST)
Received: from c-24-17-218-140.hsd1.wa.comcast.net ([24.17.218.140] helo=srivatsab-a02.vmware.com)
        by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1osdS2-00BI8O-Pa;
        Wed, 09 Nov 2022 00:16:38 -0500
To:     Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20221020091950.6741-1-jgross@suse.com>
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Subject: Re: [PATCH] x86/paravirt: use common macro for creating simple asm
 paravirt functions
Message-ID: <7f620a41-c68d-20ad-cdde-cd545c772014@csail.mit.edu>
Date:   Tue, 8 Nov 2022 21:16:34 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20221020091950.6741-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Juergen,

Sorry for the delay in reviewing this patch!

On 10/20/22 2:19 AM, Juergen Gross wrote:
> There are some paravirt assembler functions which are sharing a common
> pattern. Introduce a macro DEFINE_PARAVIRT_ASM() for creating them.
> 
> The explicit _paravirt_nop() prototype in paravirt.c isn't needed, as
> it is included in paravirt_types.h already.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

I just wanted to make a note that the part of this patch that's not
purely cleanup is the addition of the alignment (__ALIGN_STR) to
__raw_callee_save___kvm_vcpu_is_preempted(), _paravirt_nop() and
paravirt_ret0(). Maybe that's worth calling out in the commit message?

Reviewed-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>

Regards,
Srivatsa
VMware Photon OS

> ---
>  arch/x86/include/asm/paravirt.h           | 12 ++++++
>  arch/x86/include/asm/qspinlock_paravirt.h | 46 ++++++++++-------------
>  arch/x86/kernel/kvm.c                     | 19 +++-------
>  arch/x86/kernel/paravirt.c                | 22 ++---------
>  4 files changed, 40 insertions(+), 59 deletions(-)
> 
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 2a0b8dd4ec33..479bf264b8aa 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -730,6 +730,18 @@ static __always_inline unsigned long arch_local_irq_save(void)
>  #undef PVOP_VCALL4
>  #undef PVOP_CALL4
>  
> +#define DEFINE_PARAVIRT_ASM(func, instr, sec)		\
> +	asm (".pushsection " #sec ", \"ax\"\n"		\
> +	     ".global " #func "\n\t"			\
> +	     ".type " #func ", @function\n\t"		\
> +	     __ALIGN_STR "\n"				\
> +	     #func ":\n\t"				\
> +	     ASM_ENDBR					\
> +	     instr					\
> +	     ASM_RET					\
> +	     ".size " #func ", . - " #func "\n\t"	\
> +	     ".popsection")
> +
>  extern void default_banner(void);
>  
>  #else  /* __ASSEMBLY__ */
> diff --git a/arch/x86/include/asm/qspinlock_paravirt.h b/arch/x86/include/asm/qspinlock_paravirt.h
> index 60ece592b220..c490f5eb9f3e 100644
> --- a/arch/x86/include/asm/qspinlock_paravirt.h
> +++ b/arch/x86/include/asm/qspinlock_paravirt.h
> @@ -14,8 +14,6 @@
>  
>  __PV_CALLEE_SAVE_REGS_THUNK(__pv_queued_spin_unlock_slowpath, ".spinlock.text");
>  #define __pv_queued_spin_unlock	__pv_queued_spin_unlock
> -#define PV_UNLOCK		"__raw_callee_save___pv_queued_spin_unlock"
> -#define PV_UNLOCK_SLOWPATH	"__raw_callee_save___pv_queued_spin_unlock_slowpath"
>  
>  /*
>   * Optimized assembly version of __raw_callee_save___pv_queued_spin_unlock
> @@ -37,32 +35,26 @@ __PV_CALLEE_SAVE_REGS_THUNK(__pv_queued_spin_unlock_slowpath, ".spinlock.text");
>   *   rsi = lockval           (second argument)
>   *   rdx = internal variable (set to 0)
>   */
> -asm    (".pushsection .spinlock.text;"
> -	".globl " PV_UNLOCK ";"
> -	".type " PV_UNLOCK ", @function;"
> -	".align 4,0x90;"
> -	PV_UNLOCK ": "
> -	ASM_ENDBR
> -	FRAME_BEGIN
> -	"push  %rdx;"
> -	"mov   $0x1,%eax;"
> -	"xor   %edx,%edx;"
> -	LOCK_PREFIX "cmpxchg %dl,(%rdi);"
> -	"cmp   $0x1,%al;"
> -	"jne   .slowpath;"
> -	"pop   %rdx;"
> +#define PV_UNLOCK_ASM							\
> +	FRAME_BEGIN							\
> +	"push  %rdx\n\t"						\
> +	"mov   $0x1,%eax\n\t"						\
> +	"xor   %edx,%edx\n\t"						\
> +	LOCK_PREFIX "cmpxchg %dl,(%rdi)\n\t"				\
> +	"cmp   $0x1,%al\n\t"						\
> +	"jne   .slowpath\n\t"						\
> +	"pop   %rdx\n\t"						\
> +	FRAME_END							\
> +	ASM_RET								\
> +	".slowpath:\n\t"						\
> +	"push   %rsi\n\t"						\
> +	"movzbl %al,%esi\n\t"						\
> +	"call __raw_callee_save___pv_queued_spin_unlock_slowpath\n\t"	\
> +	"pop    %rsi\n\t"						\
> +	"pop    %rdx\n\t"						\
>  	FRAME_END
> -	ASM_RET
> -	".slowpath: "
> -	"push   %rsi;"
> -	"movzbl %al,%esi;"
> -	"call " PV_UNLOCK_SLOWPATH ";"
> -	"pop    %rsi;"
> -	"pop    %rdx;"
> -	FRAME_END
> -	ASM_RET
> -	".size " PV_UNLOCK ", .-" PV_UNLOCK ";"
> -	".popsection");
> +DEFINE_PARAVIRT_ASM(__raw_callee_save___pv_queued_spin_unlock, PV_UNLOCK_ASM,
> +		    .spinlock.text);
>  
>  #else /* CONFIG_64BIT */
>  
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index d4e48b4a438b..856708cc78e7 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -798,19 +798,12 @@ extern bool __raw_callee_save___kvm_vcpu_is_preempted(long);
>   * Hand-optimize version for x86-64 to avoid 8 64-bit register saving and
>   * restoring to/from the stack.
>   */
> -asm(
> -".pushsection .text;"
> -".global __raw_callee_save___kvm_vcpu_is_preempted;"
> -".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
> -"__raw_callee_save___kvm_vcpu_is_preempted:"
> -ASM_ENDBR
> -"movq	__per_cpu_offset(,%rdi,8), %rax;"
> -"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
> -"setne	%al;"
> -ASM_RET
> -".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
> -".popsection");
> -
> +#define PV_VCPU_PREEMPTED_ASM						     \
> + "movq   __per_cpu_offset(,%rdi,8), %rax\n\t"				     \
> + "cmpb   $0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax)\n\t" \
> + "setne  %al\n\t"
> +DEFINE_PARAVIRT_ASM(__raw_callee_save___kvm_vcpu_is_preempted,
> +		    PV_VCPU_PREEMPTED_ASM, .text);
>  #endif
>  
>  static void __init kvm_guest_init(void)
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 7ca2d46c08cc..6f306f885caf 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -37,27 +37,11 @@
>   * nop stub, which must not clobber anything *including the stack* to
>   * avoid confusing the entry prologues.
>   */
> -extern void _paravirt_nop(void);
> -asm (".pushsection .entry.text, \"ax\"\n"
> -     ".global _paravirt_nop\n"
> -     "_paravirt_nop:\n\t"
> -     ASM_ENDBR
> -     ASM_RET
> -     ".size _paravirt_nop, . - _paravirt_nop\n\t"
> -     ".type _paravirt_nop, @function\n\t"
> -     ".popsection");
> +DEFINE_PARAVIRT_ASM(_paravirt_nop, "", .entry.text);
>  
>  /* stub always returning 0. */
> -asm (".pushsection .entry.text, \"ax\"\n"
> -     ".global paravirt_ret0\n"
> -     "paravirt_ret0:\n\t"
> -     ASM_ENDBR
> -     "xor %" _ASM_AX ", %" _ASM_AX ";\n\t"
> -     ASM_RET
> -     ".size paravirt_ret0, . - paravirt_ret0\n\t"
> -     ".type paravirt_ret0, @function\n\t"
> -     ".popsection");
> -
> +#define PV_RET0_ASM	"xor %" _ASM_AX ", %" _ASM_AX "\n\t"
> +DEFINE_PARAVIRT_ASM(paravirt_ret0, PV_RET0_ASM, .entry.text);
>  
>  void __init default_banner(void)
>  {
> 

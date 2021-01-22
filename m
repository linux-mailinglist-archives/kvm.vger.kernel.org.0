Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1B43001DF
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 12:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbhAVLpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 06:45:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:33648 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbhAVLpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 06:45:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 15170AF9C;
        Fri, 22 Jan 2021 11:44:35 +0000 (UTC)
Date:   Fri, 22 Jan 2021 12:44:30 +0100
From:   Borislav Petkov <bp@suse.de>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org, len.brown@intel.com, dave.hansen@intel.com,
        jing2.liu@intel.com, ravi.v.shankar@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 06/21] x86/fpu/xstate: Calculate and remember dynamic
 xstate buffer sizes
Message-ID: <20210122114430.GB5123@zn.tnic>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-7-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201223155717.19556-7-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 23, 2020 at 07:57:02AM -0800, Chang S. Bae wrote:
> The xstate buffer is currently in-line with static size. To accommodatea

"in-line" doesn't fit in this context, especially since "inline"
is a keyword with another meaning. Please replace it with a better
formulation in this patch.

> dynamic user xstates, introduce variables to represent the maximum and
> minimum buffer sizes.
> 
> do_extra_xstate_size_checks() calculates the maximum xstate size and sanity
> checks it with CPUID. It calculates the static in-line buffer size by
> excluding the dynamic user states from the maximum xstate size.
> 
> No functional change, until the kernel enables dynamic buffer support.
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> Reviewed-by: Len Brown <len.brown@intel.com>
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm@vger.kernel.org
> ---
> Changes from v2:
> * Updated the changelog with task->fpu removed. (Boris Petkov)
> * Renamed the in-line size variable.
> * Updated some code comments.
> ---
>  arch/x86/include/asm/processor.h | 10 +++----
>  arch/x86/kernel/fpu/core.c       |  6 ++---
>  arch/x86/kernel/fpu/init.c       | 36 ++++++++++++++++---------
>  arch/x86/kernel/fpu/signal.c     |  2 +-
>  arch/x86/kernel/fpu/xstate.c     | 46 +++++++++++++++++++++-----------
>  arch/x86/kernel/process.c        |  6 +++++
>  arch/x86/kvm/x86.c               |  2 +-
>  7 files changed, 67 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 82a08b585818..c9c608f8af91 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -477,7 +477,8 @@ DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
>  DECLARE_PER_CPU(struct irq_stack *, softirq_stack_ptr);
>  #endif	/* X86_64 */
>  
> -extern unsigned int fpu_kernel_xstate_size;
> +extern unsigned int fpu_kernel_xstate_min_size;
> +extern unsigned int fpu_kernel_xstate_max_size;

Is it time to group this into a struct so that all those settings go
together instead in single variables?

struct fpu_xstate {
	unsigned int min_size, max_size;
	unsigned int user_size;
	...
};

etc.

>  extern unsigned int fpu_user_xstate_size;
>  
>  struct perf_event;
> @@ -545,12 +546,7 @@ struct thread_struct {
>  };
>  
>  /* Whitelist the FPU state from the task_struct for hardened usercopy. */
> -static inline void arch_thread_struct_whitelist(unsigned long *offset,
> -						unsigned long *size)
> -{
> -	*offset = offsetof(struct thread_struct, fpu.state);
> -	*size = fpu_kernel_xstate_size;
> -}
> +extern void arch_thread_struct_whitelist(unsigned long *offset, unsigned long *size);

What's that move for?

> diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
> index 74e03e3bc20f..5dac97158030 100644
> --- a/arch/x86/kernel/fpu/init.c
> +++ b/arch/x86/kernel/fpu/init.c
> @@ -130,13 +130,20 @@ static void __init fpu__init_system_generic(void)
>  }
>  
>  /*
> - * Size of the FPU context state. All tasks in the system use the
> - * same context size, regardless of what portion they use.
> - * This is inherent to the XSAVE architecture which puts all state
> - * components into a single, continuous memory block:
> + * Size of the minimally allocated FPU context state. All threads have this amount
> + * of xstate buffer at minimum.
> + *
> + * This buffer is inherent to the XSAVE architecture which puts all state components
> + * into a single, continuous memory block:
> + */
> +unsigned int fpu_kernel_xstate_min_size;
> +EXPORT_SYMBOL_GPL(fpu_kernel_xstate_min_size);
> +
> +/*
> + * Size of the maximum FPU context state. When using the compacted format, the buffer
> + * can be dynamically expanded to include some states up to this size.
>   */
> -unsigned int fpu_kernel_xstate_size;
> -EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
> +unsigned int fpu_kernel_xstate_max_size;

And since we're probably going to start querying different aspects about
the buffer, instead of exporting all kinds of variables in the future,
maybe this should be a single exported function called

get_xstate_buffer_attr(typedef buffer_attr)

which gives you what you wanna know about it... For example:

get_xstate_buffer_attr(MIN_SIZE);
get_xstate_buffer_attr(MAX_SIZE);
...

> diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
> index 414a13427934..b6d2706b6886 100644
> --- a/arch/x86/kernel/fpu/signal.c
> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -289,8 +289,8 @@ static int copy_user_to_fpregs_zeroing(void __user *buf, u64 xbv, int fx_only)
>  
>  static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
>  {
> +	int state_size = fpu_kernel_xstate_min_size;
>  	struct user_i387_ia32_struct *envp = NULL;
> -	int state_size = fpu_kernel_xstate_size;
>  	int ia32_fxstate = (buf != buf_fx);
>  	struct task_struct *tsk = current;
>  	struct fpu *fpu = &tsk->thread.fpu;
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index 6620d0a3caff..2012b17b1793 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -627,13 +627,18 @@ static void check_xstate_against_struct(int nr)
>   */

<-- There's a comment over this function that might need adjustment.

>  static void do_extra_xstate_size_checks(void)
>  {
> -	int paranoid_xstate_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
> +	int paranoid_min_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
> +	int paranoid_max_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
>  	int i;

...

> @@ -744,27 +758,27 @@ static bool is_supported_xstate_size(unsigned int test_xstate_size)
>  static int __init init_xstate_size(void)
>  {
>  	/* Recompute the context size for enabled features: */
> -	unsigned int possible_xstate_size;
> +	unsigned int possible_max_xstate_size;
>  	unsigned int xsave_size;
>  
>  	xsave_size = get_xsave_size();
>  
>  	if (boot_cpu_has(X86_FEATURE_XSAVES))

using_compacted_format()

FPU code needs to agree on one helper and not use both. :-\

> -		possible_xstate_size = get_xsaves_size_no_dynamic();
> +		possible_max_xstate_size = get_xsaves_size_no_dynamic();
>  	else
> -		possible_xstate_size = xsave_size;
> -
> -	/* Ensure we have the space to store all enabled: */
> -	if (!is_supported_xstate_size(possible_xstate_size))
> -		return -EINVAL;
> +		possible_max_xstate_size = xsave_size;
>  
>  	/*
>  	 * The size is OK, we are definitely going to use xsave,
>  	 * make it known to the world that we need more space.
>  	 */
> -	fpu_kernel_xstate_size = possible_xstate_size;
> +	fpu_kernel_xstate_max_size = possible_max_xstate_size;
>  	do_extra_xstate_size_checks();
>  
> +	/* Ensure we have the supported in-line space: */

Who's "we"?

> +	if (!is_supported_xstate_size(fpu_kernel_xstate_min_size))
> +		return -EINVAL;
> +
>  	/*
>  	 * User space is always in standard format.
>  	 */

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg

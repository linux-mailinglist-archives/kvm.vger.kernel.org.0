Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEE718DCBD
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 01:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgCUAsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 20:48:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:38993 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUAsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 20:48:11 -0400
IronPort-SDR: 5R15SZoh7AZiclf1w9evz1bU7LMdhcUjdQ44lKItTBQiFG63ouhJimwQoxt1r4Nf74eJgnDqYm
 ZKBIo82Hz35A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 17:48:10 -0700
IronPort-SDR: i5vQ175Ng+lcCjl+Bl79blk5YiTScZY6WjHYMecLuiIj/YLsjx59boYwX4W0kSCQFartxO1zC0
 qaVTNFI0JdcQ==
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="237376262"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 17:48:10 -0700
Date:   Fri, 20 Mar 2020 17:48:09 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v5 4/9] x86/split_lock: Export handle_user_split_lock()
Message-ID: <20200321004809.GD6578@agluck-desk2.amr.corp.intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
 <20200315050517.127446-5-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200315050517.127446-5-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 15, 2020 at 01:05:12PM +0800, Xiaoyao Li wrote:
> In the future, KVM will use handle_user_split_lock() to handle #AC
> caused by split lock in guest. Due to the fact that KVM doesn't have
> a @regs context and will pre-check EFLASG.AC, move the EFLAGS.AC check
> to do_alignment_check().
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/include/asm/cpu.h  | 4 ++--
>  arch/x86/kernel/cpu/intel.c | 7 ++++---
>  arch/x86/kernel/traps.c     | 2 +-
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index ff6f3ca649b3..ff567afa6ee1 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -43,11 +43,11 @@ unsigned int x86_stepping(unsigned int sig);
>  #ifdef CONFIG_CPU_SUP_INTEL
>  extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
>  extern void switch_to_sld(unsigned long tifn);
> -extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
> +extern bool handle_user_split_lock(unsigned long ip);
>  #else
>  static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
>  static inline void switch_to_sld(unsigned long tifn) {}
> -static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
> +static inline bool handle_user_split_lock(unsigned long ip)
>  {
>  	return false;
>  }
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 3eeab717a0d0..c401d174c8db 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -1102,13 +1102,13 @@ static void split_lock_init(struct cpuinfo_x86 *c)
>  	sld_state = sld_disable;
>  }
>  
> -bool handle_user_split_lock(struct pt_regs *regs, long error_code)
> +bool handle_user_split_lock(unsigned long ip)
>  {
> -	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
> +	if (sld_state == sld_fatal)
>  		return false;
>  
>  	pr_warn_ratelimited("#AC: %s/%d took a split_lock trap at address: 0x%lx\n",
> -			    current->comm, current->pid, regs->ip);
> +			    current->comm, current->pid, ip);
>  
>  	/*
>  	 * Disable the split lock detection for this task so it can make
> @@ -1119,6 +1119,7 @@ bool handle_user_split_lock(struct pt_regs *regs, long error_code)
>  	set_tsk_thread_flag(current, TIF_SLD);
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(handle_user_split_lock);
>  
>  /*
>   * This function is called only when switching between tasks with
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 0ef5befaed7d..407ff9be610f 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -304,7 +304,7 @@ dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
>  
>  	local_irq_enable();
>  
> -	if (handle_user_split_lock(regs, error_code))
> +	if (!(regs->flags & X86_EFLAGS_AC) && handle_user_split_lock(regs->ip))
>  		return;
>  
>  	do_trap(X86_TRAP_AC, SIGBUS, "alignment check", regs,
> -- 
> 2.20.1
> 

Looks good to me.

Reviewed-by: Tony Luck <tony.luck@intel.com>


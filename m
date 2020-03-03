Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3FA178294
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 20:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgCCSmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 13:42:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:25430 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgCCSmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 13:42:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 10:42:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="263306240"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 03 Mar 2020 10:42:09 -0800
Date:   Tue, 3 Mar 2020 10:42:09 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com,
        peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/8] x86/split_lock: Export handle_user_split_lock()
Message-ID: <20200303184209.GP1439@linux.intel.com>
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
 <20200206070412.17400-2-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206070412.17400-2-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 03:04:05PM +0800, Xiaoyao Li wrote:
> Move the EFLAGS.AC check to do_alignment_check() so that
> handle_user_split_lock() can be used by KVM in the future to handle #AC
> caused by split lock in guest.

Probably worth explaining that KVM doesn't have a @regs context and will
pre-check EFLAGS.AC.

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
> index db3e745e5d47..2b3874a96bd4 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -1058,13 +1058,13 @@ static void split_lock_init(void)
>  	sld_state = sld_off;
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
> @@ -1075,6 +1075,7 @@ bool handle_user_split_lock(struct pt_regs *regs, long error_code)
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
> 2.23.0
> 

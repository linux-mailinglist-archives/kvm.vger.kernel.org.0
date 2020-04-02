Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0A819C78C
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 19:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390010AbgDBRCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 13:02:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38678 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732625AbgDBRCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 13:02:43 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jK3E5-0008K9-3R; Thu, 02 Apr 2020 19:01:57 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 81E1F100D52; Thu,  2 Apr 2020 19:01:56 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/split_lock: Refactor and export handle_user_split_lock() for KVM
In-Reply-To: <20200402155554.27705-3-sean.j.christopherson@intel.com>
References: <20200402124205.334622628@linutronix.de> <20200402155554.27705-1-sean.j.christopherson@intel.com> <20200402155554.27705-3-sean.j.christopherson@intel.com>
Date:   Thu, 02 Apr 2020 19:01:56 +0200
Message-ID: <87v9mhn7nf.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> In the future, KVM will use handle_user_split_lock() to handle #AC
> caused by split lock in guest. Due to the fact that KVM doesn't have
> a @regs context and will pre-check EFLAGS.AC, move the EFLAGS.AC check
> to do_alignment_check().
>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
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

This is necessary because VMX can be compiled without CPU_SUP_INTEL?

>  {
>  	return false;
>  }
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 9a26e972cdea..7688f51aabdb 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -1066,13 +1066,13 @@ static void split_lock_init(void)
>  	split_lock_verify_msr(sld_state != sld_off);
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

So this returns true even in the case that sld_state == off.

Should never happen, but I rather have an extra check and be both
verbose and correct. See the variant I did.

Thanks,

        tglx



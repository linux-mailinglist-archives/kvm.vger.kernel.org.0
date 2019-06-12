Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5B3420F0
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437436AbfFLJfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:35:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37286 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436605AbfFLJfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=h498uX1FwZ5CaVxq4breWnlhdBuCKw4wm3JuGKcEDYM=; b=CFmrBMcg/5ikP86sa4CoaV8j2h
        g7vfpH3ljUDpl2uxaARxCcnkcRs5VZLjY+pVXX3bQ8kOr/EVzW+vlofeECoH1/Qg5kG83RAFWzP9f
        Aw81oKqs2Y39AN0OqYXe1YlM+OZd69q7FdHskLAf8HcIjqqaY8o/GF0y4895iKm6SsiNJwjBs9Hk1
        J/d9FIcAyIdYB5nzW4J9GHguIaDfR8q52zsUDUsT7b1NCwCYwdmCQq74nLn3Q3yIsfmEwF7PPBDuQ
        RC1bSQPl31ZATcjfIyDt0t8x9P/a0/34ktvWyNEDQWn+I8sFr4Y8sU1Ckd/0/JZXIivYU/QdAigTX
        hpuvWHcQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hazet-0004gz-Qa; Wed, 12 Jun 2019 09:35:08 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 273FE2096E50D; Wed, 12 Jun 2019 11:35:06 +0200 (CEST)
Date:   Wed, 12 Jun 2019 11:35:06 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org,
        Prasanna Panchamukhi <panchamukhi@arista.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Cathy Avery <cavery@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>,
        Mohammed Gamal <mmorsy@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/hyperv: Disable preemption while setting
 reenlightenment vector
Message-ID: <20190612093506.GH3436@hirez.programming.kicks-ass.net>
References: <20190611212003.26382-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190611212003.26382-1-dima@arista.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 11, 2019 at 10:20:03PM +0100, Dmitry Safonov wrote:
> KVM support may be compiled as dynamic module, which triggers the
> following splat on modprobe:
> 
>  KVM: vmx: using Hyper-V Enlightened VMCS
>  BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/466 caller is debug_smp_processor_id+0x17/0x19
>  CPU: 0 PID: 466 Comm: modprobe Kdump: loaded Not tainted 4.19.43 #1
>  Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090007  06/02/2017
>  Call Trace:
>   dump_stack+0x61/0x7e
>   check_preemption_disabled+0xd4/0xe6
>   debug_smp_processor_id+0x17/0x19
>   set_hv_tscchange_cb+0x1b/0x89
>   kvm_arch_init+0x14a/0x163 [kvm]
>   kvm_init+0x30/0x259 [kvm]
>   vmx_init+0xed/0x3db [kvm_intel]
>   do_one_initcall+0x89/0x1bc
>   do_init_module+0x5f/0x207
>   load_module+0x1b34/0x209b
>   __ia32_sys_init_module+0x17/0x19
>   do_fast_syscall_32+0x121/0x1fa
>   entry_SYSENTER_compat+0x7f/0x91
> 
> The easiest solution seems to be disabling preemption while setting up
> reenlightment MSRs. While at it, fix hv_cpu_*() callbacks.
> 
> Fixes: 93286261de1b4 ("x86/hyperv: Reenlightenment notifications
> support")
> 
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Cathy Avery <cavery@redhat.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
> Cc: Mohammed Gamal <mmorsy@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Roman Kagan <rkagan@virtuozzo.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> Cc: devel@linuxdriverproject.org
> Cc: kvm@vger.kernel.org
> Cc: linux-hyperv@vger.kernel.org
> Cc: x86@kernel.org
> Reported-by: Prasanna Panchamukhi <panchamukhi@arista.com>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>  arch/x86/hyperv/hv_init.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index 1608050e9df9..0bdd79ecbff8 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -91,7 +91,7 @@ EXPORT_SYMBOL_GPL(hv_max_vp_index);
>  static int hv_cpu_init(unsigned int cpu)
>  {
>  	u64 msr_vp_index;
> -	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[smp_processor_id()];
> +	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[cpu];
>  	void **input_arg;
>  	struct page *pg;
>  
> @@ -103,7 +103,7 @@ static int hv_cpu_init(unsigned int cpu)
>  
>  	hv_get_vp_index(msr_vp_index);
>  
> -	hv_vp_index[smp_processor_id()] = msr_vp_index;
> +	hv_vp_index[cpu] = msr_vp_index;
>  
>  	if (msr_vp_index > hv_max_vp_index)
>  		hv_max_vp_index = msr_vp_index;
> @@ -182,7 +182,6 @@ void set_hv_tscchange_cb(void (*cb)(void))
>  	struct hv_reenlightenment_control re_ctrl = {
>  		.vector = HYPERV_REENLIGHTENMENT_VECTOR,
>  		.enabled = 1,
> -		.target_vp = hv_vp_index[smp_processor_id()]
>  	};
>  	struct hv_tsc_emulation_control emu_ctrl = {.enabled = 1};
>  
> @@ -196,7 +195,11 @@ void set_hv_tscchange_cb(void (*cb)(void))
>  	/* Make sure callback is registered before we write to MSRs */
>  	wmb();
>  
> +	preempt_disable();
> +	re_ctrl.target_vp = hv_vp_index[smp_processor_id()];
>  	wrmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
> +	preempt_enable();
> +
>  	wrmsrl(HV_X64_MSR_TSC_EMULATION_CONTROL, *((u64 *)&emu_ctrl));
>  }
>  EXPORT_SYMBOL_GPL(set_hv_tscchange_cb);

This looks bogus, MSRs are a per-cpu resource, you had better know what
CPUs you're on and be stuck to it when you do wrmsr. This just fudges
the code to make the warning go away and doesn't fix the actual problem
afaict.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2FE445132
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 10:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhKDJfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 05:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhKDJfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 05:35:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9925C061714;
        Thu,  4 Nov 2021 02:32:35 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id m26so5300214pff.3;
        Thu, 04 Nov 2021 02:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=xc0JBrJOB9+yVQnMStNToryhrhjrwmhOIz4w47Lw54c=;
        b=SyXfkfdvicspq1qwxqg2f7wZmQHTvyhN8XNqj5y7NNSR4079c7521i+HTiNyT/uYIt
         c6LDDje7fPfiTS0HR7tCwaCB91LPM/cTdMsr4ZsgURhtunmbSPGiwDcyGfSgzgxLtlp+
         rvax61jfawG6zqb/uTGWFQYC5BAcMY1/t+UqCl8TNdV5JPcuGjBIZ5h1AA6dXBZomOJb
         DlDOifc7466hgJifR3RsbL12BAGRXuLkOGPURUFv8EAJQApk/y1kFT6mHgWhdLoCRAe9
         ITNWNK13VRNRpA/1kJ5e7IEq4Ra2RuPAyv/7F8SpTLM332/+s8n1sl90sqiR0niRvK7o
         hvCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=xc0JBrJOB9+yVQnMStNToryhrhjrwmhOIz4w47Lw54c=;
        b=vK9dd9fQwL8+AxqdkcTPZgWdTpYI+oseq79gpz1qhPuWsLF3qSK5x1qj2ws8ODFYMP
         5De+N1zG0Vuc1ZVpZTrlKcaC0wiILL/wCcL2hrgK9xbH/JLLIkLJKRxs0BkOOM9BZWk3
         CXEZPbDuh61D5oKzyTCZNcjH0zmT8jrrH87GhF3M0RxP1kx67VmTB/70ly97msVb99TP
         DHggPvBt3e3tcGNRdXbp5KVQELrir6ImQq3VB8kIsc31hQ1DpLq00CZUddb4b+MxxFuO
         y9U1z+LZdQtRHsAWyad1GwmI07nOyO62VoNcGukH4m8INPo+SJbNe6CmlQp9T0b3UFwj
         w4vw==
X-Gm-Message-State: AOAM530SfdnsU1jTth9Fbu3CSXpIySZvkP1j9O5PCh4xpkn71kPogw0g
        i+lxTN7VW6R1moihkKH9bA1dj89h/ONK4Rih
X-Google-Smtp-Source: ABdhPJwm9vetu2mRo6NPhZbdTexC59YzvjJqoliFt1MyPiF48kiTnDdrFnE7rf61S+Y62nMo0nPXPQ==
X-Received: by 2002:a05:6a00:1c4a:b0:480:fb90:3ab7 with SMTP id s10-20020a056a001c4a00b00480fb903ab7mr32323406pfw.3.1636018355134;
        Thu, 04 Nov 2021 02:32:35 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ng9sm7166405pjb.4.2021.11.04.02.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 02:32:34 -0700 (PDT)
Message-ID: <77e3a76a-016b-8945-a1d5-aae4075e2147@gmail.com>
Date:   Thu, 4 Nov 2021 17:32:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v3 01/16] perf: Ensure perf_guest_cbs aren't reloaded
 between !NULL check and deref
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-csky@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Ingo Molnar <mingo@redhat.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greentime Hu <green.hu@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Marc Zyngier <maz@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Guo Ren <guoren@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-2-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20210922000533.713300-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/9/2021 8:05 am, Sean Christopherson wrote:
> Protect perf_guest_cbs with READ_ONCE/WRITE_ONCE to ensure it's not
> reloaded between a !NULL check and a dereference, and wait for all
> readers via syncrhonize_rcu() to prevent use-after-free, e.g. if the
> callbacks are being unregistered during module unload.  Because the
> callbacks are global, it's possible for readers to run in parallel with
> an unregister operation.
> 
> The bug has escaped notice because all dereferences of perf_guest_cbs
> follow the same "perf_guest_cbs && perf_guest_cbs->is_in_guest()" pattern,
> and it's extremely unlikely a compiler will reload perf_guest_cbs in this
> sequence.  Compilers do reload perf_guest_cbs for future derefs, e.g. for
> ->is_user_mode(), but the ->is_in_guest() guard all but guarantees the
> PMI handler will win the race, e.g. to nullify perf_guest_cbs, KVM has to
> completely exit the guest and teardown down all VMs before KVM start its
> module unload / unregister sequence.
> 
> But with help, unloading kvm_intel can trigger a NULL pointer derference,
> e.g. wrapping perf_guest_cbs with READ_ONCE in perf_misc_flags() while
> spamming kvm_intel module load/unload leads to:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000000000
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: 0000 [#1] PREEMPT SMP
>    CPU: 6 PID: 1825 Comm: stress Not tainted 5.14.0-rc2+ #459
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>    RIP: 0010:perf_misc_flags+0x1c/0x70
>    Call Trace:
>     perf_prepare_sample+0x53/0x6b0
>     perf_event_output_forward+0x67/0x160
>     __perf_event_overflow+0x52/0xf0
>     handle_pmi_common+0x207/0x300
>     intel_pmu_handle_irq+0xcf/0x410
>     perf_event_nmi_handler+0x28/0x50
>     nmi_handle+0xc7/0x260
>     default_do_nmi+0x6b/0x170
>     exc_nmi+0x103/0x130
>     asm_exc_nmi+0x76/0xbf
> 
> Fixes: 39447b386c84 ("perf: Enhance perf to allow for guest statistic collection from host")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm/kernel/perf_callchain.c   | 17 +++++++++++------
>   arch/arm64/kernel/perf_callchain.c | 18 ++++++++++++------
>   arch/csky/kernel/perf_callchain.c  |  6 ++++--
>   arch/nds32/kernel/perf_event_cpu.c | 17 +++++++++++------
>   arch/riscv/kernel/perf_callchain.c |  7 +++++--
>   arch/x86/events/core.c             | 17 +++++++++++------
>   arch/x86/events/intel/core.c       |  9 ++++++---
>   include/linux/perf_event.h         |  8 ++++++++
>   kernel/events/core.c               | 11 +++++++++--
>   9 files changed, 77 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_callchain.c b/arch/arm/kernel/perf_callchain.c
> index 3b69a76d341e..1626dfc6f6ce 100644
> --- a/arch/arm/kernel/perf_callchain.c
> +++ b/arch/arm/kernel/perf_callchain.c
> @@ -62,9 +62,10 @@ user_backtrace(struct frame_tail __user *tail,
>   void
>   perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct frame_tail __user *tail;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
>   		/* We don't support guest os callchain now */
>   		return;
>   	}
> @@ -98,9 +99,10 @@ callchain_trace(struct stackframe *fr,
>   void
>   perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct stackframe fr;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
>   		/* We don't support guest os callchain now */
>   		return;
>   	}
> @@ -111,18 +113,21 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
>   
>   unsigned long perf_instruction_pointer(struct pt_regs *regs)
>   {
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
> -		return perf_guest_cbs->get_guest_ip();
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> +
> +	if (guest_cbs && guest_cbs->is_in_guest())
> +		return guest_cbs->get_guest_ip();
>   
>   	return instruction_pointer(regs);
>   }
>   
>   unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	int misc = 0;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> -		if (perf_guest_cbs->is_user_mode())
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
> +		if (guest_cbs->is_user_mode())
>   			misc |= PERF_RECORD_MISC_GUEST_USER;
>   		else
>   			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
> index 4a72c2727309..86d9f2013172 100644
> --- a/arch/arm64/kernel/perf_callchain.c
> +++ b/arch/arm64/kernel/perf_callchain.c
> @@ -102,7 +102,9 @@ compat_user_backtrace(struct compat_frame_tail __user *tail,
>   void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   			 struct pt_regs *regs)
>   {
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> +
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
>   		/* We don't support guest os callchain now */
>   		return;
>   	}
> @@ -147,9 +149,10 @@ static bool callchain_trace(void *data, unsigned long pc)
>   void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   			   struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct stackframe frame;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
>   		/* We don't support guest os callchain now */
>   		return;
>   	}
> @@ -160,18 +163,21 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   
>   unsigned long perf_instruction_pointer(struct pt_regs *regs)
>   {
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
> -		return perf_guest_cbs->get_guest_ip();
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> +
> +	if (guest_cbs && guest_cbs->is_in_guest())
> +		return guest_cbs->get_guest_ip();
>   
>   	return instruction_pointer(regs);
>   }
>   
>   unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	int misc = 0;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> -		if (perf_guest_cbs->is_user_mode())
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
> +		if (guest_cbs->is_user_mode())
>   			misc |= PERF_RECORD_MISC_GUEST_USER;
>   		else
>   			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> diff --git a/arch/csky/kernel/perf_callchain.c b/arch/csky/kernel/perf_callchain.c
> index ab55e98ee8f6..35318a635a5f 100644
> --- a/arch/csky/kernel/perf_callchain.c
> +++ b/arch/csky/kernel/perf_callchain.c
> @@ -86,10 +86,11 @@ static unsigned long user_backtrace(struct perf_callchain_entry_ctx *entry,
>   void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   			 struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	unsigned long fp = 0;
>   
>   	/* C-SKY does not support virtualization. */
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
> +	if (guest_cbs && guest_cbs->is_in_guest())
>   		return;
>   
>   	fp = regs->regs[4];
> @@ -110,10 +111,11 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   			   struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct stackframe fr;
>   
>   	/* C-SKY does not support virtualization. */
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
>   		pr_warn("C-SKY does not support perf in guest mode!");
>   		return;
>   	}
> diff --git a/arch/nds32/kernel/perf_event_cpu.c b/arch/nds32/kernel/perf_event_cpu.c
> index 0ce6f9f307e6..f38791960781 100644
> --- a/arch/nds32/kernel/perf_event_cpu.c
> +++ b/arch/nds32/kernel/perf_event_cpu.c
> @@ -1363,6 +1363,7 @@ void
>   perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   		    struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	unsigned long fp = 0;
>   	unsigned long gp = 0;
>   	unsigned long lp = 0;
> @@ -1371,7 +1372,7 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   
>   	leaf_fp = 0;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
>   		/* We don't support guest os callchain now */
>   		return;
>   	}
> @@ -1479,9 +1480,10 @@ void
>   perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   		      struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct stackframe fr;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
>   		/* We don't support guest os callchain now */
>   		return;
>   	}
> @@ -1493,20 +1495,23 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   
>   unsigned long perf_instruction_pointer(struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> +
>   	/* However, NDS32 does not support virtualization */
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
> -		return perf_guest_cbs->get_guest_ip();
> +	if (guest_cbs && guest_cbs->is_in_guest())
> +		return guest_cbs->get_guest_ip();
>   
>   	return instruction_pointer(regs);
>   }
>   
>   unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	int misc = 0;
>   
>   	/* However, NDS32 does not support virtualization */
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> -		if (perf_guest_cbs->is_user_mode())
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
> +		if (guest_cbs->is_user_mode())
>   			misc |= PERF_RECORD_MISC_GUEST_USER;
>   		else
>   			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> diff --git a/arch/riscv/kernel/perf_callchain.c b/arch/riscv/kernel/perf_callchain.c
> index 0bb1854dce83..8ecfc4c128bc 100644
> --- a/arch/riscv/kernel/perf_callchain.c
> +++ b/arch/riscv/kernel/perf_callchain.c
> @@ -56,10 +56,11 @@ static unsigned long user_backtrace(struct perf_callchain_entry_ctx *entry,
>   void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>   			 struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	unsigned long fp = 0;
>   
>   	/* RISC-V does not support perf in guest mode. */
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
> +	if (guest_cbs && guest_cbs->is_in_guest())
>   		return;
>   
>   	fp = regs->s0;
> @@ -78,8 +79,10 @@ static bool fill_callchain(void *entry, unsigned long pc)
>   void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>   			   struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> +
>   	/* RISC-V does not support perf in guest mode. */
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
>   		pr_warn("RISC-V does not support perf in guest mode!");
>   		return;
>   	}
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 1eb45139fcc6..ffb3e6c0d367 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2761,10 +2761,11 @@ static bool perf_hw_regs(struct pt_regs *regs)
>   void
>   perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct unwind_state state;
>   	unsigned long addr;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
>   		/* TODO: We don't support guest os callchain now */
>   		return;
>   	}
> @@ -2864,10 +2865,11 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry_ctx *ent
>   void
>   perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	struct stack_frame frame;
>   	const struct stack_frame __user *fp;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
>   		/* TODO: We don't support guest os callchain now */
>   		return;
>   	}
> @@ -2944,18 +2946,21 @@ static unsigned long code_segment_base(struct pt_regs *regs)
>   
>   unsigned long perf_instruction_pointer(struct pt_regs *regs)
>   {
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
> -		return perf_guest_cbs->get_guest_ip();
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
> +
> +	if (guest_cbs && guest_cbs->is_in_guest())
> +		return guest_cbs->get_guest_ip();
>   
>   	return regs->ip + code_segment_base(regs);
>   }
>   
>   unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
> +	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
>   	int misc = 0;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> -		if (perf_guest_cbs->is_user_mode())
> +	if (guest_cbs && guest_cbs->is_in_guest()) {
> +		if (guest_cbs->is_user_mode())
>   			misc |= PERF_RECORD_MISC_GUEST_USER;
>   		else
>   			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index fca7a6e2242f..9baa46185d94 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -2786,6 +2786,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>   {
>   	struct perf_sample_data data;
>   	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
> +	struct perf_guest_info_callbacks *guest_cbs;
>   	int bit;
>   	int handled = 0;
>   	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
> @@ -2852,9 +2853,11 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>   	 */
>   	if (__test_and_clear_bit(GLOBAL_STATUS_TRACE_TOPAPMI_BIT, (unsigned long *)&status)) {
>   		handled++;
> -		if (unlikely(perf_guest_cbs && perf_guest_cbs->is_in_guest() &&
> -			perf_guest_cbs->handle_intel_pt_intr))
> -			perf_guest_cbs->handle_intel_pt_intr();
> +
> +		guest_cbs = perf_get_guest_cbs();
> +		if (unlikely(guest_cbs && guest_cbs->is_in_guest() &&
> +			     guest_cbs->handle_intel_pt_intr))
> +			guest_cbs->handle_intel_pt_intr();
>   		else
>   			intel_pt_interrupt();
>   	}
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 2d510ad750ed..6b0405e578c1 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1237,6 +1237,14 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
>   				 u16 flags);
>   
>   extern struct perf_guest_info_callbacks *perf_guest_cbs;
> +static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
> +{
> +	/* Reg/unreg perf_guest_cbs waits for readers via synchronize_rcu(). */
> +	lockdep_assert_preemption_disabled();
> +
> +	/* Prevent reloading between a !NULL check and dereferences. */
> +	return READ_ONCE(perf_guest_cbs);
> +}
>   extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
>   extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
>   
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 464917096e73..80ff050a7b55 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6491,14 +6491,21 @@ struct perf_guest_info_callbacks *perf_guest_cbs;
>   
>   int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>   {
> -	perf_guest_cbs = cbs;
> +	if (WARN_ON_ONCE(perf_guest_cbs))
> +		return -EBUSY;
> +
> +	WRITE_ONCE(perf_guest_cbs, cbs);

So per Paolo's comment [1], does it help to use
	smp_store_release(perf_guest_cbs, cbs)
or
	rcu_assign_pointer(perf_guest_cbs, cbs)
here?

[1] https://lore.kernel.org/kvm/37afc465-c12f-01b9-f3b6-c2573e112d76@redhat.com/

>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
>   
>   int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>   {
> -	perf_guest_cbs = NULL;
> +	if (WARN_ON_ONCE(perf_guest_cbs != cbs))
> +		return -EINVAL;
> +
> +	WRITE_ONCE(perf_guest_cbs, NULL);
> +	synchronize_rcu();
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E766A5CE4
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 17:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjB1QOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 11:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjB1QOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 11:14:02 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA1020548;
        Tue, 28 Feb 2023 08:13:59 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677600835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yzn4ZC6rxI44VXytBI5Fnc7+a5GIfbz7OrWhI6HHXwo=;
        b=BGato9Jn5a3ROBz+NS5V3X407E3+wK948iylyHOQz+LAVewkjsmWZaFoyqMAxPdKxG1cxs
        8Plkbv03K77D5nmyS5mUZCNtJTIDT4vpRLvFyMbYTZYkqNqi80vJInfZMtKwDVZGBxp5NM
        4D9CAi7RoRSJWUDUtSWWDKpYv1MhVuuEiRVD/LN4QHg+1miSt2II0JhMuU12OHq+UgzZE4
        aqLa9UHgD8AIV9GH9HttxZDpJOg9krtK/k4uskuCKSEi8awzLF6H/Zh+jF8hwwii624jov
        5WiEdfjAmfFXWm9H0ABdxLYYMbZOHbzpsw3DWm2ohXCIFcUJtpGGxbVA03DgcQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677600835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yzn4ZC6rxI44VXytBI5Fnc7+a5GIfbz7OrWhI6HHXwo=;
        b=uTdd0PBkQ0wwFhY/RHnddcbIfbACiZwiWoUzLdsnStv6mgQUAkR3RjqLHgtZe0BV2KIPS9
        mJ8m2Snp1P3zQhDw==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v12 06/11] x86/smpboot: Remove initial_stack on 64-bit
In-Reply-To: <20230226110802.103134-7-usama.arif@bytedance.com>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-7-usama.arif@bytedance.com>
Date:   Tue, 28 Feb 2023 17:13:55 +0100
Message-ID: <87k001n4xo.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 26 2023 at 11:07, Usama Arif wrote:
> From: Brian Gerst <brgerst@gmail.com>
>
> Eliminating global variables from the CPU startup path in order to simplify
> it and facilitate parallel startup.

As this patch is now part of the parallel boot series and actually
introduces smpboot_control, the above is neither accurate nor useful.

Folks, really.

> Remove initial_stack, and load RSP from current_task->thread.sp instead.

  
>  #ifdef CONFIG_SMP
> -	initial_stack = (unsigned long)temp_stack + sizeof(temp_stack);
> +	current->thread.sp = (unsigned long)temp_stack + sizeof(temp_stack);

This lacks a comment about the temporary (ab)use of current->thread.sp

>  	early_gdt_descr.address =
>  			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
>  	initial_gs = per_cpu_offset(smp_processor_id());
> +	smpboot_control = smp_processor_id();
>  #endif

> @@ -241,6 +241,24 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>  	UNWIND_HINT_EMPTY
>  	ANNOTATE_NOENDBR // above
>  
> +#ifdef CONFIG_SMP
> +	movl	smpboot_control(%rip), %ecx
> +
> +	/* Get the per cpu offset for the given CPU# which is in ECX */
> +	movq	__per_cpu_offset(,%rcx,8), %rdx
> +#else
> +	xorl	%edx, %edx
> +#endif /* CONFIG_SMP */

Sigh, we should finally make CONFIG_SMP def_bool y ...

> +	/*
> +	 * Setup a boot time stack - Any secondary CPU will have lost its stack
> +	 * by now because the cr3-switch above unmaps the real-mode stack.
> +	 *
> +	 * RDX contains the per-cpu offset
> +	 */
> +	movq	pcpu_hot + X86_current_task(%rdx), %rax
> +	movq	TASK_threadsp(%rax), %rsp
> +
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index b18c1385e181..62e3bf37f0b8 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1112,7 +1112,12 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
>  	idle->thread.sp = (unsigned long)task_pt_regs(idle);
>  	early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
>  	initial_code = (unsigned long)start_secondary;
> -	initial_stack  = idle->thread.sp;
> +
> +	if (IS_ENABLED(CONFIG_X86_32)) {
> +		initial_stack  = idle->thread.sp;
> +	} else {
> +		smpboot_control = cpu;
> +	}

Please remove the pointless brackets.
  
Thanks,

        tglx

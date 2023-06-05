Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920E07227A7
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbjFENlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjFENlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:41:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5B692;
        Mon,  5 Jun 2023 06:41:39 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685972497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o7YMnuPT/PoUCy2frs3isEXM8tusYD1fNAt1WEsbd9Y=;
        b=KRajMS3wG1CVnZeOHrppxjrE5Qdwie9fH6q/fl7klVaJGyhAfRB7pCuWZ2wP+0OCLWuU5l
        cyGwXTehS5kQaxNfkmK1bw06xDLPeSq1EaR0M4oSxOMKEqFlDkUO6nBvqH2+Drn5fY+ALk
        GqZkO1JUCVEekI6VYV0n2cetXdfRgaRYzXM1I8cRbfV14Ow3yns4/Kajs1MV2GQiYCUSeh
        ZRswm+cmyyK/+ZFs4qAAhagmq0q2voe4LlhcUFIqHd6niy4Da1ntBvbWEO0X+Tj5j7PYoI
        8cObjGVOaO1mnvyF1j3za+rxe0nxu2hpTJQQEcyyyqT2grUEXNntLBpH6Nn7xw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685972497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o7YMnuPT/PoUCy2frs3isEXM8tusYD1fNAt1WEsbd9Y=;
        b=H6czvWRQjMvQehgzL3tVQDTlQt0YcfckcB8sGQMuOStzUW7iQYFPdy5v2AXad3dYvQ3FSW
        DhEMNujBdZ7K8fAA==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 21/33] x86/fred: FRED initialization code
In-Reply-To: <20230410081438.1750-22-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-22-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 15:41:37 +0200
Message-ID: <87cz2a6n72.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
>  
> +/*
> + * The actual assembly entry and exit points
> + */
> +extern __visible void fred_entrypoint_user(void);

Why is this defined in this patch and not at the point where the
function is introduced?

> +/*
> + * Initialization
> + */
> +void cpu_init_fred_exceptions(void);
> +void fred_setup_apic(void);
> +
>  #endif /* __ASSEMBLY__ */
>  
> +#else
> +#define cpu_init_fred_exceptions() BUG()
> +#define fred_setup_apic() BUG()

static inline stubs please.

> @@ -2054,28 +2055,6 @@ static void wrmsrl_cstar(unsigned long val)
>  /* May not be marked __init: used by software suspend */
>  void syscall_init(void)
>  {
> -	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
> -	wrmsrl(MSR_LSTAR, (unsigned long)entry_SYSCALL_64);
> -
> -#ifdef CONFIG_IA32_EMULATION
> -	wrmsrl_cstar((unsigned long)entry_SYSCALL_compat);
> -	/*
> -	 * This only works on Intel CPUs.
> -	 * On AMD CPUs these MSRs are 32-bit, CPU truncates MSR_IA32_SYSENTER_EIP.
> -	 * This does not cause SYSENTER to jump to the wrong location, because
> -	 * AMD doesn't allow SYSENTER in long mode (either 32- or 64-bit).
> -	 */
> -	wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);
> -	wrmsrl_safe(MSR_IA32_SYSENTER_ESP,
> -		    (unsigned long)(cpu_entry_stack(smp_processor_id()) + 1));
> -	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, (u64)entry_SYSENTER_compat);
> -#else
> -	wrmsrl_cstar((unsigned long)ignore_sysret);
> -	wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)GDT_ENTRY_INVALID_SEG);
> -	wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
> -	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, 0ULL);
> -#endif
> -
>  	/*
>  	 * Flags to clear on syscall; clear as much as possible
>  	 * to minimize user space-kernel interference.
> @@ -2086,6 +2065,41 @@ void syscall_init(void)
>  	       X86_EFLAGS_IF|X86_EFLAGS_DF|X86_EFLAGS_OF|
>  	       X86_EFLAGS_IOPL|X86_EFLAGS_NT|X86_EFLAGS_RF|
>  	       X86_EFLAGS_AC|X86_EFLAGS_ID);
> +
> +	/*
> +	 * The default user and kernel segments
> +	 */
> +	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
> +
> +	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
> +		/* Both sysexit and sysret cause #UD when FRED is enabled */
> +		wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)GDT_ENTRY_INVALID_SEG);
> +		wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
> +		wrmsrl_safe(MSR_IA32_SYSENTER_EIP, 0ULL);
> +	} else {
> +		wrmsrl(MSR_LSTAR, (unsigned long)entry_SYSCALL_64);
> +
> +#ifdef CONFIG_IA32_EMULATION
> +		wrmsrl_cstar((unsigned long)entry_SYSCALL_compat);
> +		/*
> +		 * This only works on Intel CPUs.
> +		 * On AMD CPUs these MSRs are 32-bit, CPU truncates
> +		 * MSR_IA32_SYSENTER_EIP.
> +		 * This does not cause SYSENTER to jump to the wrong
> +		 * location, because AMD doesn't allow SYSENTER in
> +		 * long mode (either 32- or 64-bit).
> +		 */
> +		wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);
> +		wrmsrl_safe(MSR_IA32_SYSENTER_ESP,
> +			    (unsigned long)(cpu_entry_stack(smp_processor_id()) + 1));
> +		wrmsrl_safe(MSR_IA32_SYSENTER_EIP, (u64)entry_SYSENTER_compat);
> +#else
> +		wrmsrl_cstar((unsigned long)ignore_sysret);
> +		wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)GDT_ENTRY_INVALID_SEG);
> +		wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
> +		wrmsrl_safe(MSR_IA32_SYSENTER_EIP, 0ULL);
> +#endif
> +	}
>  }

Sigh. Can you please split this into

static void idt_syscall_init(void)
{
        All the existing gunk
}

void syscall_init(void)
{
	/* The default user and kernel segments */
	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);

        idt_syscall_init();
}

in a first step and then in the next patch add the FRED muck?

> +/*
> + * Initialize FRED on this CPU. This cannot be __init as it is called
> + * during CPU hotplug.

Really no need to repeat this comment vs. __init all over the place.

> + */
> +void cpu_init_fred_exceptions(void)
> +{
> +	wrmsrl(MSR_IA32_FRED_CONFIG,
> +	       FRED_CONFIG_REDZONE | /* Reserve for CALL emulation */

Please don't use tail comments. Nowhere.

> +	       FRED_CONFIG_INT_STKLVL(0) |
> +	       FRED_CONFIG_ENTRYPOINT(fred_entrypoint_user));
> +
> +/*
> + * Initialize system vectors from a FRED perspective, so
> + * lapic_assign_system_vectors() can do its job.
> + */
> +void __init fred_setup_apic(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
> +		set_bit(i, system_vectors);

> +	/*
> +	 * Don't set the non assigned system vectors in the
> +	 * system_vectors bitmap. Otherwise they show up in
> +	 * /proc/interrupts.
> +	 */
> +#ifdef CONFIG_SMP
> +	set_bit(IRQ_MOVE_CLEANUP_VECTOR, system_vectors);
> +#endif
> +
> +	for (i = 0; i < NR_SYSTEM_VECTORS; i++) {
> +		if (get_system_interrupt_handler(i) != NULL) {

This _cannot be NULL. The system vector table must be fully populated
with either the real handler or the spurious handler. Otherwise you need
a NULL pointer check in the dispatch path.

> +			set_bit(i + FIRST_SYSTEM_VECTOR, system_vectors);
> +		}
> +	}


> +
> +	/* The rest are fair game... */

Can you please refrain from adding useless comments. Commenting the
obvious is a distraction and not helpful in any way. Comment the things
which are not obvious in the first place.

> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -1537,6 +1537,14 @@ static system_interrupt_handler system_interrupt_handlers[NR_SYSTEM_VECTORS] = {
>  
>  #undef SYSV
>  
> +system_interrupt_handler get_system_interrupt_handler(unsigned int i)
> +{
> +	if (i >= NR_SYSTEM_VECTORS)
> +		return NULL;

Seriously?

> +	return system_interrupt_handlers[i];

Get rid of this completely confusing and useless function and look the
table up at the only call site. I'm all for defensive programming, but
this is hideous.

Thanks,

        tglx

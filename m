Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0114F67DFAE
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 10:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbjA0JIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 04:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjA0JIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 04:08:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7CB4C10;
        Fri, 27 Jan 2023 01:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=Xpz/QULLJcOrnceK3ZK8cywK46+XMRPKfnae2QLSgRU=; b=pVTmJrX1N/UYb5xMW60Qtbkgrc
        J9gI3wwvRVzNW4xJWHUmy5iJ6RJlK8eXxoT0i1izeHHmot4YIogrHoPqKJBt5EY9ofPjNfjyvicPe
        MCYOlbCU5wckcSklv7Kwlf1aP+/VqVA897buSmvrUMuEMJztQOTUVoDlpyflSR59TAbLWCdEItL9I
        5wTnkAHpF4bY8II616wTR2YQ58mo+gGVgMFhc93hfJmEBKm+9bPw6ILXS8zm5mFY4ViIhn0T/FCe6
        uqXEaCiOZuV83eeLM1B+mIHso8hBMWIrtf69vwm7eJOY9IWMjH9MxJ5p9Hyl6X1dv76HNwSDS4GNF
        Fn/l70BA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pLKiX-007Yfn-C3; Fri, 27 Jan 2023 09:08:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2622E3002BF;
        Fri, 27 Jan 2023 10:08:15 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E17562084B93F; Fri, 27 Jan 2023 10:08:14 +0100 (CET)
Date:   Fri, 27 Jan 2023 10:08:14 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, joro@8bytes.org
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Message-ID: <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
References: <20230127035616.508966-1-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230127035616.508966-1-aik@amd.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 02:56:16PM +1100, Alexey Kardashevskiy wrote:
> AMD SEV-ES guest kernels compiled without CONFIG_PARAVIRT crash when
> "perf" executes. "./perf record sleep 20" is an example.
>
> Some debugging revealed this happens when CONFIG_PARAVIRT_XXL is not
> defined. The problem seems to be that between DEFINE_IDTENTRY_RAW(exc_nmi)
> and actual reading of DB7 (which in turn causes #VC) every function is
> inlined

Very much on purpose.

> and no stack frame is created (?).

Silly compilers ;-) I think you can force it to by using inline asm with
a rsp dependency or somesuch.

> Replacing __always_inline with
> noinline in  local_db_save() or native_get_debugreg() fixes the problem.

It will create others.

> Why is this crash happening and how to fix that? I am still reading
> the assembly but was hoping for a shortcut here :) Thanks,

Welcome to the wonderful shit show that is x86 exceptions :/

I thought sev_es_*() is supposed to fix this. Joerg, any clue?

> aik-Standard-PC-i440FX-PIIX-1996 login: =1B[A[   15.775303] BUG: NMI stac=
k guard page was hit at 0000000003983d50 (stack is 000000007feb1fa4..000000=
00574369c2)
> [   15.775314] stack guard page: 0000 [#1] PREEMPT SMP NOPTI
> [   15.775316] CPU: 0 PID: 790 Comm: sleep Not tainted 6.2.0-rc4_aik-debu=
gswap_ruby-954bhost #73
> [   15.775322] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS u=
nknown unknown
> [   15.775323] RIP: 0010:error_entry+0x17/0x140
> [   15.775326] Code: f8 e9 98 fd ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 6=
6 90 56 48 8b 74 24 08 48 89 7c 24 08 52 51 50 41 50 41 51 41 52 41 53 53 <=
55> 41 54 41 55 41 56 41 57 56 31 f6 31 d2 31 c9 45 31 c0 45 31 c9
> [   15.775328] RSP: 0000:fffffe2446b2b000 EFLAGS: 00010097
> [   15.775332] RAX: fffffe2446b2b0a8 RBX: 0000000000000000 RCX: ffffffffb=
3a00fed
> [   15.775333] RDX: 0000000000000000 RSI: ffffffffb3a00b69 RDI: fffffe244=
6b2b0a8
> [   15.775336] RBP: fffffe2446b2b0a8 R08: 0000000000000000 R09: 000000000=
0000000
> [   15.775337] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000=
0000000
> [   15.775338] R13: 0000000000000000 R14: 000000000002dd80 R15: 000000000=
0000000
> [   15.775339] FS:  0000000000000000(0000) GS:ffff94b17dc00000(0000) knlG=
S:ffff94b17dc00000
> [   15.775340] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   15.775341] CR2: fffffe2446b2aff8 CR3: 00080000167b8000 CR4: 000000000=
03506f0
> [   15.775342] Call Trace:
> [   15.775352]  <NMI>

<snip>

> [   15.775495]  ? asm_exc_page_fault+0x22/0x30
> [   15.775496]  ? restore_regs_and_return_to_kernel+0x22/0x22
> [   15.775497]  ? exc_page_fault+0x11/0x120
> [   15.775499]  ? asm_exc_page_fault+0x22/0x30
> [   15.775500]  ? check_preemption_disabled+0x8/0xe0
> [   15.775502]  ? __sev_es_ist_enter+0x13/0x100
> [   15.775503]  ? exc_nmi+0x10e/0x150
> [   15.775505]  ? end_repeat_nmi+0x16/0x67
> [   15.775506]  ? asm_exc_double_fault+0x30/0x30
> [   15.775507]  ? asm_exc_double_fault+0x30/0x30
> [   15.775508]  ? asm_exc_double_fault+0x30/0x30
> [   15.775509]  </NMI>
> [   15.775509]  <#VC>
> [   15.775510]  ? __show_regs.cold+0x18e/0x23d
> [   15.775511]  </#VC>
> [   15.775511]  <#DF>
> [   15.775512]  ? __die_body.cold+0x1a/0x1f
> [   15.775513]  ? die+0x26/0x40
> [   15.775517]  ? handle_stack_overflow+0x44/0x60
> [   15.775518]  ? exc_double_fault+0x14b/0x180
> [   15.775519]  ? asm_exc_double_fault+0x1f/0x30
> [   15.775520]  ? restore_regs_and_return_to_kernel+0x22/0x22
> [   15.775521]  ? asm_exc_page_fault+0x9/0x30
> [   15.775522]  ? error_entry+0x17/0x140
> [   15.775523]  </#DF>
> [   15.775523] WARNING: stack recursion on stack type 6
> [   15.775524] Modules linked in: msr efivarfs
> [   15.837935] ---[ end trace 0000000000000000 ]---
>=20
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  arch/x86/include/asm/debugreg.h | 29 ++++++++++++++++++++
>  arch/x86/kernel/nmi.c           |  2 +-
>  2 files changed, 30 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debug=
reg.h
> index b049d950612f..396e2ea114dc 100644
> --- a/arch/x86/include/asm/debugreg.h
> +++ b/arch/x86/include/asm/debugreg.h
> @@ -125,6 +125,35 @@ static __always_inline void local_db_restore(unsigne=
d long dr7)
>  		set_debugreg(dr7, 7);
>  }
> =20
> +/* noinline here inline __always_inline'd native_get_debugreg(int regno)=
 */
> +static noinline unsigned long native_get_debugreg7(void)
> +{
> +	unsigned long dr7;
> +	asm("mov %%db7, %0" :"=3Dr" (dr7));
> +	return dr7;
> +}
> +
> +static __always_inline unsigned long local_db_save_exc_nmi(void)
> +{
> +	unsigned long dr7;
> +
> +	if (static_cpu_has(X86_FEATURE_HYPERVISOR) && !hw_breakpoint_active())
> +		return 0;
> +
> +	dr7 =3D native_get_debugreg7();
> +	dr7 &=3D ~0x400; /* architecturally set bit */
> +	if (dr7)
> +		set_debugreg(0, 7);
> +	/*
> +	 * Ensure the compiler doesn't lower the above statements into
> +	 * the critical section; disabling breakpoints late would not
> +	 * be good.
> +	 */
> +	barrier();
> +
> +	return dr7;
> +}

This is broken, and building with DEBUG_ENTRY=3Dy would've told you.

> +
>  #ifdef CONFIG_CPU_SUP_AMD
>  extern void set_dr_addr_mask(unsigned long mask, int dr);
>  #else
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index cec0bfa3bc04..400b5b6b74f6 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -503,7 +503,7 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
>  	 */
>  	sev_es_ist_enter(regs);
> =20
> -	this_cpu_write(nmi_dr7, local_db_save());
> +	this_cpu_write(nmi_dr7, local_db_save_exc_nmi());
> =20
>  	irq_state =3D irqentry_nmi_enter(regs);

So what I don't get is why sev_es_ist_enter() doesn't cause us to make a
stack frame, that has an actual call in it (although admittedly
conditional).

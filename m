Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBB267F84E
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 14:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbjA1Nw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 08:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbjA1Nw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 08:52:26 -0500
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6AA722659E;
        Sat, 28 Jan 2023 05:52:24 -0800 (PST)
Received: from 8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id DB0FF2602D3;
        Sat, 28 Jan 2023 14:52:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1674913943;
        bh=pwS9QMn9X+JPuuplngGyQsswZ0q+EpivgqmV4KbdGB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MsHVwGkKcBJcmRSSSV3FRkDkaB+pjOqOQnuBEDdUnWPfFGwD29xg+ZroUSMDYxGF0
         5eaNS8zYN5nFjUTuCu547K1OJFhoWT82xaHixQRM/QXF/8diLjagjRrazPHirbS2Q6
         35DLMl8E7JD4cYffDU74nbXh+lxm5JLwra6GHKOIKrwKZck+s2RfsMGF0ETdFNvafQ
         qQCgqUItRh5KGRZlj+z9Jd9/TLjuRzYf3NjU2qn/JcrKVepNFB+E5ntkmUt5kMnJE9
         HzZhXYK/p4ml8zXv9FnKeIGkF2isVTFPUKY8KWadg1hOrQo2LAvcbgg9FQhtxdTAdG
         YP2j/Bt8WKL0Q==
Date:   Sat, 28 Jan 2023 14:52:21 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Message-ID: <Y9UolYXFzvocxIcn@8bytes.org>
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
 <Y9OpcoSacyOkPkvl@8bytes.org>
 <b7880f0b-a592-cf2d-03b9-1ccfd83f8223@amd.com>
 <Y9QI9JwCVvRmtbr+@8bytes.org>
 <3bb3e080-caee-8bc8-7de9-f44969f16e75@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bb3e080-caee-8bc8-7de9-f44969f16e75@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023 at 10:24:56PM +1100, Alexey Kardashevskiy wrote:
> (out of curiosity) where do you see these NOPs? "objdump -D vmlinux" does
> not show any, is this after lifepatching?

Here is the disassembly of exc_nmi of a kernel built from tip/master
with CONFIG_PARAVIRT=n:

<exc_nmi>:
       41 54                   push   %r12
       55                      push   %rbp
       48 89 fd                mov    %rdi,%rbp
       53                      push   %rbx
       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
       65 8b 05 69 66 41 7e    mov    %gs:0x7e416669(%rip),%eax        # 3254c <pcpu_hot+0xc>
       48 98                   cltq
       48 0f a3 05 33 00 2b    bt     %rax,0x12b0033(%rip)        # ffffffff82ecbf20 <__cpu_online_mask>
       01 
       0f 83 c9 00 00 00       jae    ffffffff81c1bfbc <exc_nmi+0xec>
       65 8b 05 f6 41 40 7e    mov    %gs:0x7e4041f6(%rip),%eax        # 200f0 <nmi_state>
       85 c0                   test   %eax,%eax
       0f 85 f8 00 00 00       jne    ffffffff81c1bffa <exc_nmi+0x12a>
       65 c7 05 e3 41 40 7e    movl   $0x1,%gs:0x7e4041e3(%rip)        # 200f0 <nmi_state>
       01 00 00 00 
       0f 20 d0                mov    %cr2,%rax
       65 48 89 05 d0 41 40    mov    %rax,%gs:0x7e4041d0(%rip)        # 200e8 <nmi_cr2>
       7e 
       41 0f 21 fc             mov    %db7,%r12			<-- here is the DR7 read
       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)		<-- here are the NOPS that become a
       								    call to sev_es_ist_enter() in
								    SEV-ES guests

The DR7 read will cause a #VC exception, switching to the #VC IST stack.
If the NMI was raised while already on the #VC IST stack, this DR7 read
will overwrite the previous stack frame and cause stack recursion, with
all funny side effects.


> diff --git a/arch/x86/include/asm/debugreg.h
> b/arch/x86/include/asm/debugreg.h
> index b049d950612f..687b15297057 100644
> --- a/arch/x86/include/asm/debugreg.h
> +++ b/arch/x86/include/asm/debugreg.h
> @@ -39,7 +39,7 @@ static __always_inline unsigned long
> native_get_debugreg(int regno)
>                 asm("mov %%db6, %0" :"=r" (val));
>                 break;
>         case 7:
> -               asm("mov %%db7, %0" :"=r" (val));
> +               asm volatile ("mov %%db7, %0" :"=r" (val));

Yeah, something like this will be the fix. I am still thinking about
the right place to put the volatile to make it explicit to the situation
we are encountering here (which is SEV-ES specific).

Best would be an explicit barrier in C code between sev_es_ist_enter()
and the DR7 read, but all barriers I tried to far only seem to affect
memory instructions and had no influence on the DR7 read (which is
obviously not considered as a memory read by the compiler).

The best place to put the barrier is in the sev_es_ist_enter() inline
function, right after the static_call to __sev_es_ist_enter().

Regards,

	Joerg

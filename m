Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026EF2568D9
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 17:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgH2Pze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Aug 2020 11:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728350AbgH2Pza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Aug 2020 11:55:30 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3FDC061239;
        Sat, 29 Aug 2020 08:55:29 -0700 (PDT)
Received: from zn.tnic (p200300ec2f20450061bc46564a6ab4aa.dip0.t-ipconnect.de [IPv6:2003:ec:2f20:4500:61bc:4656:4a6a:b4aa])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EDDB41EC037C;
        Sat, 29 Aug 2020 17:55:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598716528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/hKrT6Agxsa0U42BH+OXVujqtR6Nrnq1ZKABoxchmnQ=;
        b=S7HKF4Tptffv/o1WtKtqUzdKtdftwyIQBtMOCSEWGCYytv/FZEnVROCv9pXhDh6fn4saNE
        ExIP/iUquIhslj/obBhSNv7pw8mAkwV0T+DA+QEsGeLvuXZWkElDhiFiSyTCZ1F9bUVRmw
        l9HDLUPGTfCtTdr1HNIiZ5XGTFxKUmQ=
Date:   Sat, 29 Aug 2020 17:55:25 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 38/76] x86/head/64: Set CR4.FSGSBASE early
Message-ID: <20200829155525.GB29091@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-39-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-39-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:33AM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Early exception handling will use rd/wrgsbase in paranoid_entry/exit.
> Enable the feature to avoid #UD exceptions on boot APs.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Link: https://lore.kernel.org/r/20200724160336.5435-38-joro@8bytes.org
> ---
>  arch/x86/kernel/head_64.S | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 08412f308de3..4622940134a5 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -153,6 +153,13 @@ SYM_CODE_START(secondary_startup_64)
>  	orl	$X86_CR4_LA57, %ecx
>  1:
>  #endif
> +
> +	ALTERNATIVE "jmp .Lstartup_write_cr4", "", X86_FEATURE_FSGSBASE
> +
> +	/* Early exception handling uses FSGSBASE on APs */
> +	orl	$X86_CR4_FSGSBASE, %ecx

How is this supposed to work?

Alternatives haven't run that early yet and that piece of code looks
like this:

ffffffff81000067:       eb 06                   jmp    ffffffff8100006f <secondary_startup_64+0x1f>
ffffffff81000069:       81 c9 00 00 01 00       or     $0x10000,%ecx
ffffffff8100006f:       0f 22 e1                mov    %rcx,%cr4

so we'll never set X86_CR4_FSGSBASE during early boot.

Stopping a guest with gdb just before that shows the same thing:

Dump of assembler code from 0x1000069 to 0x100007b:
=> 0x0000000001000069:  eb 06   jmp    0x1000071
   0x000000000100006b:  81 c9 00 00 01 00       or     $0x10000,%ecx
   0x0000000001000071:  0f 22 e1        mov    %rcx,%cr4
   0x0000000001000074:  48 03 05 95 ff 20 01    add    0x120ff95(%rip),%rax        # 0x2210010

the unconditional JMP is there and it hasn't been patched out yet.

If you really need to test CPUID flags, you need to do something similar
to what verify_cpu does that early. And looking at that thing:

 *      verify_cpu, returns the status of longmode and SSE in register %eax.
 *              0: Success    1: Failure

you could return the FSGSBASE CPUID bit there too and act accordingly.

Hmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

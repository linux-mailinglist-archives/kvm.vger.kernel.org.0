Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAFD323AC5
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 11:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbhBXKuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 05:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbhBXKuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 05:50:37 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BADC061574;
        Wed, 24 Feb 2021 02:49:57 -0800 (PST)
Received: from zn.tnic (p200300ec2f0d180081510bd8ee909965.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1800:8151:bd8:ee90:9965])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 440591EC0598;
        Wed, 24 Feb 2021 11:49:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614163794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZM0t91q7XsXZUuvaXIua4IFViIknTuFeIw/XCzZmzfA=;
        b=FJbcg0KGjeOlpWEgwB8zHiDdWukpITxv+sFNTzRnRtpdlU2qTiax8xEaHYXgBEnFwxx8HH
        vdFObudelZT9IVnuTvkPx822sDrD7zQ3kZV0BlrzTeLrbrPEcZmPRgOsqlrTVEtQ8soXig
        oQuooKEsfTjRO5XXnaqiWC/ERlBo9nI=
Date:   Wed, 24 Feb 2021 11:49:52 +0100
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
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/7] x86/boot/compressed/64: Setup IDT in startup_32 boot
 path
Message-ID: <20210224104952.GA20344@zn.tnic>
References: <20210210102135.30667-1-joro@8bytes.org>
 <20210210102135.30667-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210210102135.30667-4-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 11:21:31AM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> This boot path needs exception handling when it is used with SEV-ES.

For ?

Let's explain pls.

> Setup an IDT and provide a helper function to write IDT entries for
> use in 32-bit protected mode.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/boot/compressed/head_64.S | 73 +++++++++++++++++++++++++++++-
>  1 file changed, 72 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index c59c80ca546d..8deeec78cdb4 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -116,6 +116,11 @@ SYM_FUNC_START(startup_32)
>  	lretl
>  1:
>  
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +	/* Setup Exception handling for SEV-ES */
> +	call	startup32_load_idt
> +#endif
> +

You can push that ifdeffery out of the main path (diff ontop):

---
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 8deeec78cdb4..cb5a6849fb29 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -116,10 +116,7 @@ SYM_FUNC_START(startup_32)
 	lretl
 1:
 
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-	/* Setup Exception handling for SEV-ES */
 	call	startup32_load_idt
-#endif
 
 	/* Make sure cpu supports long mode. */
 	call	verify_cpu
@@ -854,16 +851,18 @@ SYM_FUNC_START(startup32_set_idt_entry)
 	pop     %ebx
 	ret
 SYM_FUNC_END(startup32_set_idt_entry)
+#endif
 
+/* Setup Exception handling for SEV-ES */
 SYM_FUNC_START(startup32_load_idt)
+#ifdef CONFIG_AMD_MEM_ENCRYPT
 	/* Load IDT */
 	leal	rva(boot32_idt)(%ebp), %eax
 	movl	%eax, rva(boot32_idt_desc+2)(%ebp)
 	lidt    rva(boot32_idt_desc)(%ebp)
-
+#endif
 	ret
 SYM_FUNC_END(startup32_load_idt)
-#endif
 /*
  * Stack and heap for uncompression
  */
---

> +SYM_FUNC_START(startup32_set_idt_entry)
> +	push    %ebx
> +	push    %ecx
> +
> +	/* IDT entry address to %ebx */
> +	leal    rva(boot32_idt)(%ebp), %ebx
> +	shl	$3, %edx
> +	addl    %edx, %ebx
> +
> +	/* Build IDT entry, lower 4 bytes */
> +	movl    %eax, %edx

Let's add some side comments here:

 +	andl    $0x0000ffff, %edx		# Target code segment offset [15:0]


 +	movl    $__KERNEL32_CS, %ecx		# Target code segment selector 
> +	shl     $16, %ecx
> +	orl     %ecx, %edx
> +
> +	/* Store lower 4 bytes to IDT */
> +	movl    %edx, (%ebx)
> +
> +	/* Build IDT entry, upper 4 bytes */
> +	movl    %eax, %edx
 +	andl    $0xffff0000, %edx		# Target code segment offset [31:16]
 +	orl     $0x00008e00, %edx		# Present, Type 32-bit Interrupt Gate

so that a reader like me can quickly find interrupt gates in the docs.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

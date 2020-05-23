Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB651DF5D6
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 09:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387748AbgEWH7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 03:59:32 -0400
Received: from mail.skyhub.de ([5.9.137.197]:57804 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387627AbgEWH7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 03:59:31 -0400
Received: from zn.tnic (p200300ec2f1b96004c59f332ede330a0.dip0.t-ipconnect.de [IPv6:2003:ec:2f1b:9600:4c59:f332:ede3:30a0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 215841EC0338;
        Sat, 23 May 2020 09:59:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590220770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PIo+t2JcI6yVRedmlgz10X421O+M066c0hltaVL112k=;
        b=ZLEXWPqMrm4G0DwJpbs8Xgi9xF4kgV5KjgjmvT9VK9gOBCLZtVjao6/GkCbl6+4X+V5fwU
        RC9EWJFZV06I1nR899eptspZxrdViE5apbzfahsF0PgTl3LX1V8HCCJUtgslfPsCUj9YUS
        /PGarM2WPPCDvyJoyVnqQyWd5w4+ROU=
Date:   Sat, 23 May 2020 09:59:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 47/75] x86/sev-es: Add Runtime #VC Exception Handler
Message-ID: <20200523075924.GB27431@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-48-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-48-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:57PM +0200, Joerg Roedel wrote:
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index a4fa7f351bf2..bc3a58427028 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -10,6 +10,7 @@
>  #include <linux/sched/debug.h>	/* For show_regs() */
>  #include <linux/percpu-defs.h>
>  #include <linux/mem_encrypt.h>
> +#include <linux/lockdep.h>
>  #include <linux/printk.h>
>  #include <linux/mm_types.h>
>  #include <linux/set_memory.h>
> @@ -25,7 +26,7 @@
>  #include <asm/insn-eval.h>
>  #include <asm/fpu/internal.h>
>  #include <asm/processor.h>
> -#include <asm/trap_defs.h>
> +#include <asm/traps.h>
>  #include <asm/svm.h>
>  
>  /* For early boot hypervisor communication in SEV-ES enabled guests */
> @@ -46,10 +47,26 @@ struct sev_es_runtime_data {
>  
>  	/* Physical storage for the per-cpu IST stacks of the #VC handler */
>  	struct vmm_exception_stacks vc_stacks __aligned(PAGE_SIZE);
> +
> +	/* Reserve on page per CPU as backup storage for the unencrypted GHCB */

		  one

> +	struct ghcb backup_ghcb;

I could use some text explaining what those backups are for?

> +	/*
> +	 * Mark the per-cpu GHCBs as in-use to detect nested #VC exceptions.
> +	 * There is no need for it to be atomic, because nothing is written to
> +	 * the GHCB between the read and the write of ghcb_active. So it is safe
> +	 * to use it when a nested #VC exception happens before the write.
> +	 */

Looks liks that is that text... support for nested #VC exceptions.
I'm sure this has come up already but why do we even want to support
nested #VCs? IOW, can we do without them first or are they absolutely
necessary?

I'm guessing VC exceptions inside the VC handler but what are the
sensible use cases?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

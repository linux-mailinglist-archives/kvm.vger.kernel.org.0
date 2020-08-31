Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7E825774A
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 12:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgHaK1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 06:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgHaK1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 06:27:09 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBC7C061573;
        Mon, 31 Aug 2020 03:27:08 -0700 (PDT)
Received: from zn.tnic (p200300ec2f085000329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5000:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 31A0E1EC02F2;
        Mon, 31 Aug 2020 12:27:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598869626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZuWmCteGQZKM0ko0ElODot8ukDLVFBwRtcdceTKHyJE=;
        b=V08T2WeqYCMhRjX3D5H2r4EqFkI0JVoF2Ohes825PrLzETVPYkLxl1GPEn/7TSpDZdWzbp
        8UU4qAGxRwPluiQYH2jRl0uT9qfcF9eCrrfw4Kf6Zk2aeZzG/dgYcnPaS16JfQ63jhp5ya
        pEpx11HroUZ5WqYtb7XAL7poJus3OKU=
Date:   Mon, 31 Aug 2020 12:27:01 +0200
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
Subject: Re: [PATCH v6 45/76] x86/sev-es: Allocate and Map IST stack for #VC
 handler
Message-ID: <20200831102701.GE27517@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-46-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-46-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:40AM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Allocate and map an IST stack and an additional fall-back stack for
> the #VC handler.  The memory for the stacks is allocated only when
> SEV-ES is active.
> 
> The #VC handler needs to use an IST stack because it could be raised
> from kernel space with unsafe stack, e.g. in the SYSCALL entry path.
> 
> Since the #VC exception can be nested, the #VC handler switches back to
> the interrupted stack when entered from kernel space. If switching back
> is not possible the fall-back stack is used.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Link: https://lore.kernel.org/r/20200724160336.5435-45-joro@8bytes.org
> ---
>  arch/x86/include/asm/cpu_entry_area.h | 33 +++++++++++++++++----------
>  arch/x86/include/asm/page_64_types.h  |  1 +
>  arch/x86/kernel/cpu/common.c          |  2 ++
>  arch/x86/kernel/dumpstack_64.c        |  8 +++++--
>  arch/x86/kernel/sev-es.c              | 33 +++++++++++++++++++++++++++
>  5 files changed, 63 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
> index 8902fdb7de13..f87e4c0c16f4 100644
> --- a/arch/x86/include/asm/cpu_entry_area.h
> +++ b/arch/x86/include/asm/cpu_entry_area.h
> @@ -11,25 +11,29 @@
>  #ifdef CONFIG_X86_64
>  
>  /* Macro to enforce the same ordering and stack sizes */
> -#define ESTACKS_MEMBERS(guardsize)		\
> -	char	DF_stack_guard[guardsize];	\
> -	char	DF_stack[EXCEPTION_STKSZ];	\
> -	char	NMI_stack_guard[guardsize];	\
> -	char	NMI_stack[EXCEPTION_STKSZ];	\
> -	char	DB_stack_guard[guardsize];	\
> -	char	DB_stack[EXCEPTION_STKSZ];	\
> -	char	MCE_stack_guard[guardsize];	\
> -	char	MCE_stack[EXCEPTION_STKSZ];	\
> -	char	IST_top_guard[guardsize];	\
> +#define ESTACKS_MEMBERS(guardsize, optional_stack_size)		\
> +	char	DF_stack_guard[guardsize];			\
> +	char	DF_stack[EXCEPTION_STKSZ];			\
> +	char	NMI_stack_guard[guardsize];			\
> +	char	NMI_stack[EXCEPTION_STKSZ];			\
> +	char	DB_stack_guard[guardsize];			\
> +	char	DB_stack[EXCEPTION_STKSZ];			\
> +	char	MCE_stack_guard[guardsize];			\
> +	char	MCE_stack[EXCEPTION_STKSZ];			\
> +	char	VC_stack_guard[guardsize];			\
> +	char	VC_stack[optional_stack_size];			\
> +	char	VC2_stack_guard[guardsize];			\
> +	char	VC2_stack[optional_stack_size];			\

So the VC* stuff needs to be ifdefferied and enabled only on
CONFIG_AMD_MEM_ENCRYPT... here and below.

I had that in my previous review too:

"All those things should be under an CONFIG_AMD_MEM_ENCRYPT ifdeffery."

> +	char	IST_top_guard[guardsize];			\
>  
>  /* The exception stacks' physical storage. No guard pages required */
>  struct exception_stacks {
> -	ESTACKS_MEMBERS(0)
> +	ESTACKS_MEMBERS(0, 0)
>  };
>  
>  /* The effective cpu entry area mapping with guard pages. */
>  struct cea_exception_stacks {
> -	ESTACKS_MEMBERS(PAGE_SIZE)
> +	ESTACKS_MEMBERS(PAGE_SIZE, EXCEPTION_STKSZ)
>  };
>  
>  /*
> @@ -40,6 +44,8 @@ enum exception_stack_ordering {
>  	ESTACK_NMI,
>  	ESTACK_DB,
>  	ESTACK_MCE,
> +	ESTACK_VC,
> +	ESTACK_VC2,
>  	N_EXCEPTION_STACKS
>  };
>  
> @@ -139,4 +145,7 @@ static inline struct entry_stack *cpu_entry_stack(int cpu)
>  #define __this_cpu_ist_top_va(name)					\
>  	CEA_ESTACK_TOP(__this_cpu_read(cea_exception_stacks), name)
>  
> +#define __this_cpu_ist_bot_va(name)					\

"bottom" please. I was wondering for a bit, what "bot"? And I know it is
CEA_ESTACK_BOT but that's not readable.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

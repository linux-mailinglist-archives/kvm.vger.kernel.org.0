Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215301DE7A3
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 15:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgEVNG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 09:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbgEVNGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 09:06:54 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66EFC061A0E;
        Fri, 22 May 2020 06:06:51 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0d4900a503efeda57d2ecc.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:4900:a503:efed:a57d:2ecc])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2897F1EC02DD;
        Fri, 22 May 2020 15:06:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590152808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=f1OkI+Vzd1wskJk7/8gnkbFS2SZjRjcQWBV0MrHyvlg=;
        b=bJ2ETP+3jHY1hqbeNezyvTjFa461+jPOrZry8F9S8xH16sZfFsvcFIHR4ksBQqYeiw+S2+
        QwhfpseLeEH4DgPNmZaOuxK5/qhQKZmV5EWN7wNcKxZf54FA6/HkFcfoZwM5iM2FqzJBsF
        Haik+YqW5g+WJyUteTXbhb/9XVBguPo=
Date:   Fri, 22 May 2020 15:06:41 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 45/75] x86/dumpstack/64: Handle #VC exception stacks
Message-ID: <20200522130641.GE28750@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-46-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-46-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:55PM +0200, Joerg Roedel wrote:
> diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
> index 14db05086bbf..2f3534ef4b5f 100644
> --- a/arch/x86/include/asm/stacktrace.h
> +++ b/arch/x86/include/asm/stacktrace.h
> @@ -21,6 +21,10 @@ enum stack_type {
>  	STACK_TYPE_ENTRY,
>  	STACK_TYPE_EXCEPTION,
>  	STACK_TYPE_EXCEPTION_LAST = STACK_TYPE_EXCEPTION + N_EXCEPTION_STACKS-1,
> +#ifdef CONFIG_X86_64

CONFIG_AMD_MEM_ENCRYPT

> +	STACK_TYPE_VC,
> +	STACK_TYPE_VC_LAST = STACK_TYPE_VC + N_VC_STACKS - 1,
> +#endif
>  };
>  
>  struct stack_info {
> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> index 87b97897a881..2468963c1424 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -18,6 +18,7 @@
>  
>  #include <asm/cpu_entry_area.h>
>  #include <asm/stacktrace.h>
> +#include <asm/sev-es.h>
>  
>  static const char * const exception_stack_names[] = {
>  		[ ESTACK_DF	]	= "#DF",
> @@ -47,6 +48,9 @@ const char *stack_type_name(enum stack_type type)
>  	if (type >= STACK_TYPE_EXCEPTION && type <= STACK_TYPE_EXCEPTION_LAST)
>  		return exception_stack_names[type - STACK_TYPE_EXCEPTION];
>  
> +	if (type >= STACK_TYPE_VC && type <= STACK_TYPE_VC_LAST)

That test can be inside vc_stack_name() so that it gets optimized away
for !CONFIG_AMD_MEM_ENCRYPT and there's no need for ifdeffery.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

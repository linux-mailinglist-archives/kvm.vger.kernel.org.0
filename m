Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AF31E78F1
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgE2JCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:02:30 -0400
Received: from mail.skyhub.de ([5.9.137.197]:44990 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2JC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 05:02:29 -0400
Received: from zn.tnic (p200300ec2f0f5e00e15a1b2e1d2ace20.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:5e00:e15a:1b2e:1d2a:ce20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 35F751EC03D2;
        Fri, 29 May 2020 11:02:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590742948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YgI+deux/7QqPwTMEpnAWUAEJvChvf4UJKUuseczbb4=;
        b=PvGwZ3rYkyScKSVfHSnOMSijlVOIzSrLpHiSrsUElDG4vAzwAYEsx6De23tXnYVphT6ZgT
        Dr4h4i5vlcTx2lq79mmX7QhWu+2bY+eytnB7asc3JQXZjR8YwcsapWBxZvRxBUX7Wwrh7X
        U2INYoyOAHuXtTHPwVuZtStgsNeMBEs=
Date:   Fri, 29 May 2020 11:02:22 +0200
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
Subject: Re: [PATCH v3 69/75] x86/realmode: Setup AP jump table
Message-ID: <20200529090222.GA9011@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-70-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-70-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:19PM +0200, Joerg Roedel wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Setup the AP jump table to point to the SEV-ES trampoline code so that
> the APs can boot.

Tom, in his laconic way, doesn't want to explain to us why is this even
needed...

:)

/me reads the code

/me reads the GHCB spec

aha, it gets it from the HV. And it can be set by the guest too...

So how about expanding that commit message as to why this is done, why
needed, etc?

Thx.

> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index 262f83cad355..1c5cbfd102d5 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -9,6 +9,7 @@
>  #include <asm/realmode.h>
>  #include <asm/tlbflush.h>
>  #include <asm/crash.h>
> +#include <asm/sev-es.h>
>  
>  struct real_mode_header *real_mode_header;
>  u32 *trampoline_cr4_features;
> @@ -107,6 +108,11 @@ static void __init setup_real_mode(void)
>  	if (sme_active())
>  		trampoline_header->flags |= TH_FLAGS_SME_ACTIVE;
>  
> +	if (sev_es_active()) {
> +		if (sev_es_setup_ap_jump_table(real_mode_header))
> +			panic("Failed to update SEV-ES AP Jump Table");
> +	}
> +

So this function gets slowly sprinkled with

	if (sev-something)
		bla

Please wrap at least those last two into a

	sev_setup_real_mode()

or so.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CDB37A373
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 11:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhEKJYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 05:24:18 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45216 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230126AbhEKJYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 05:24:17 -0400
Received: from zn.tnic (p200300ec2f0ec70079cd82bef3234244.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:c700:79cd:82be:f323:4244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 03AA81EC04DE;
        Tue, 11 May 2021 11:23:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620724990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=2BFJfXAt4RasctGcG7XZvImeLDWYB+zm7FzMoySZHus=;
        b=Ww1QaJQl377xw7ZOtlWjvHoC8Dgd0+Snh9DpsXI7OhvodVQZktNpt0QVAVcZe4k8CVAsUN
        +AWstQUXWdbXbrueFkK0CdCKMm6efG7Z9dXFXWTEuFMbVw4q2/HPEldWGfXjt4CzpeLj2V
        8ZMzByLEDYSDLwEKEFC5UX9VI5APT7s=
Date:   Tue, 11 May 2021 11:23:05 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 02/20] x86/sev: Save the negotiated GHCB
 version
Message-ID: <YJpM+VZaEr68hTwZ@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-3-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210430121616.2295-3-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:15:58AM -0500, Brijesh Singh wrote:
> The SEV-ES guest calls the sev_es_negotiate_protocol() to negotiate the
> GHCB protocol version before establishing the GHCB. Cache the negotiated
> GHCB version so that it can be used later.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev.h   |  2 +-
>  arch/x86/kernel/sev-shared.c | 15 ++++++++++++---
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index fa5cd05d3b5b..7ec91b1359df 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -12,7 +12,7 @@
>  #include <asm/insn.h>
>  #include <asm/sev-common.h>
>  
> -#define GHCB_PROTO_OUR		0x0001UL
> +#define GHCB_PROTOCOL_MIN	1ULL
>  #define GHCB_PROTOCOL_MAX	1ULL
>  #define GHCB_DEFAULT_USAGE	0ULL
>  
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 6ec8b3bfd76e..48a47540b85f 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -14,6 +14,13 @@
>  #define has_cpuflag(f)	boot_cpu_has(f)
>  #endif
>  
> +/*
> + * Since feature negotitation related variables are set early in the boot
> + * process they must reside in the .data section so as not to be zeroed
> + * out when the .bss section is later cleared.

  *
  * GHCB protocol version negotiated with the hypervisor.
  */

> +static u16 ghcb_version __section(".data") = 0;

Did you not see this when running checkpatch.pl on your patch?

ERROR: do not initialise statics to 0
#141: FILE: arch/x86/kernel/sev-shared.c:22:
+static u16 ghcb_version __section(".data") = 0;

>  static bool __init sev_es_check_cpu_features(void)
>  {
>  	if (!has_cpuflag(X86_FEATURE_RDRAND)) {
> @@ -54,10 +61,12 @@ static bool sev_es_negotiate_protocol(void)
>  	if (GHCB_MSR_INFO(val) != GHCB_MSR_SEV_INFO_RESP)
>  		return false;
>  
> -	if (GHCB_MSR_PROTO_MAX(val) < GHCB_PROTO_OUR ||
> -	    GHCB_MSR_PROTO_MIN(val) > GHCB_PROTO_OUR)
> +	if (GHCB_MSR_PROTO_MAX(val) < GHCB_PROTOCOL_MIN ||
> +	    GHCB_MSR_PROTO_MIN(val) > GHCB_PROTOCOL_MAX)
>  		return false;
>  
> +	ghcb_version = min_t(size_t, GHCB_MSR_PROTO_MAX(val), GHCB_PROTOCOL_MAX);

How is that even supposed to work? GHCB_PROTOCOL_MAX is 1 so
ghcb_version will be always 1 when you do min_t() on values one of which
is 1.

Maybe I'm missing something...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

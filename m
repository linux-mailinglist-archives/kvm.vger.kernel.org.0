Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 436C015B9C5
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 07:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbgBMGvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 01:51:41 -0500
Received: from mail.skyhub.de ([5.9.137.197]:43696 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgBMGvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 01:51:41 -0500
Received: from zn.tnic (p200300EC2F07F600C900F9734EF2E51F.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:f600:c900:f973:4ef2:e51f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C4EDE1EC0CD2;
        Thu, 13 Feb 2020 07:51:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1581576699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=wf2AmwI9fi4Vl0/u0IIy7+8D26tMI5ezRzlAF6DDWs8=;
        b=P65ey5vigoXjTd7ueflajmSjmkBu2Bllf6vzf1XgbPemXuoGDfOlbNXaqfPNcgyGSr2EWy
        NAYs2muwd1lcDwmLVWFQhoOPxBscCFa9RaScvP8CC7axukYg6aiImLSWDraOolnsBUbBFG
        sXhEd0CHSK5zjMfgt/gRS63dnJk8QHk=
Date:   Thu, 13 Feb 2020 07:51:30 +0100
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 03/62] x86/cpufeatures: Add SEV-ES CPU feature
Message-ID: <20200213065130.GC31799@zn.tnic>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211135256.24617-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200211135256.24617-4-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:51:57PM +0100, Joerg Roedel wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Add CPU feature detection for Secure Encrypted Virtualization with
> Encrypted State. This feature enhances SEV by also encrypting the
> guest register state, making it in-accessible to the hypervisor.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kernel/cpu/amd.c          | 4 +++-
>  arch/x86/kernel/cpu/scattered.c    | 1 +
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index f3327cb56edf..26e4ee209f7b 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -285,6 +285,7 @@
>  #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
>  #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
>  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
> +#define X86_FEATURE_SEV_ES		(11*32+ 6) /* AMD Secure Encrypted Virtualization - Encrypted State */

Let's put this in word 8 which is for virt flags. X86_FEATURE_SEV could
go there too but that should be a separate patch anyway, if at all.

>  /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
>  #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index ac83a0fef628..aad2223862ef 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -580,7 +580,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>  	 *	      If BIOS has not enabled SME then don't advertise the
>  	 *	      SME feature (set in scattered.c).
>  	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
> -	 *            SEV feature (set in scattered.c).
> +	 *            SEV and SEV_ES feature (set in scattered.c).
>  	 *
>  	 *   In all cases, since support for SME and SEV requires long mode,
>  	 *   don't advertise the feature under CONFIG_X86_32.
> @@ -611,6 +611,8 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>  		setup_clear_cpu_cap(X86_FEATURE_SME);
>  clear_sev:
>  		setup_clear_cpu_cap(X86_FEATURE_SEV);
> +		setup_clear_cpu_cap(X86_FEATURE_SEV);

X86_FEATURE_SEV twice? Because once didn't stick?

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

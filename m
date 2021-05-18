Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18812387F49
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 20:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhERSMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 14:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhERSMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 14:12:22 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09865C061573;
        Tue, 18 May 2021 11:11:04 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ae2009fe1e516c71afc1c.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:e200:9fe1:e516:c71a:fc1c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9493D1EC01FC;
        Tue, 18 May 2021 20:11:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621361462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=H+AAW4A6m8o6twO3DiK42b5ehfbbYGXWC1hdtJSpaJY=;
        b=O7Le8f7cFnhzlzMdpwHKFu2CIFXU9XxzGYPR16ZMFYdxxzl3kwSCmvjOGk6nxVAFBLD0zh
        n3JtVgFXKZ4wO1CQ8Hxpku6dZNOaBLhF/lV5yN1z5fmlHdQEIBcOMpCLnqeQutBh5WOAZr
        TxHoqTlIBZ9So4zAcwVaJ5RKU0NXkg8=
Date:   Tue, 18 May 2021 20:11:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 08/20] x86/mm: Add sev_snp_active() helper
Message-ID: <YKQDNg3keYJGnEwg@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-9-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210430121616.2295-9-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:16:04AM -0500, Brijesh Singh wrote:
> The sev_snp_active() helper can be used by the guest to query whether the
> SNP - Secure Nested Paging feature is active.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/mem_encrypt.h | 2 ++
>  arch/x86/include/asm/msr-index.h   | 2 ++
>  arch/x86/mm/mem_encrypt.c          | 9 +++++++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 31c4df123aa0..d99aa260d328 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -54,6 +54,7 @@ void __init sev_es_init_vc_handling(void);
>  bool sme_active(void);
>  bool sev_active(void);
>  bool sev_es_active(void);
> +bool sev_snp_active(void);
>  
>  #define __bss_decrypted __section(".bss..decrypted")
>  
> @@ -79,6 +80,7 @@ static inline void sev_es_init_vc_handling(void) { }
>  static inline bool sme_active(void) { return false; }
>  static inline bool sev_active(void) { return false; }
>  static inline bool sev_es_active(void) { return false; }
> +static inline bool sev_snp_active(void) { return false; }

Uff, yet another sev-something helper. So I already had this idea:

https://lore.kernel.org/kvm/20210421144402.GB5004@zn.tnic/

How about you add the sev_feature_enabled() thing

which will return a boolean value depending on which SEV feature has
been queried and instead of having yet another helper, do

	if (sev_feature_enabled(SEV_SNP))

or so?

I.e., just add the facility and the SNP bit - we will convert the rest
in time.

So that we can redesign this cleanly...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

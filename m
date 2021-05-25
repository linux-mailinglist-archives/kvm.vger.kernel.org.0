Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECA538FFD6
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 13:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhEYLQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 07:16:04 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54362 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231321AbhEYLPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 07:15:48 -0400
Received: from zn.tnic (p4fed31b3.dip0.t-ipconnect.de [79.237.49.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DF24B1EC0257;
        Tue, 25 May 2021 13:14:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621941256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3WUEjvyF9yEtk54sAKl6O+BqtnsSwU8FDEFqA7AwfNo=;
        b=Avet1harNC20FDGsndm5GkQtMcSXZ3VZBTO1N1jFtCzGKphtkq/Fi9m2p4KTUkLVlKyGev
        OQBZdZQ1fXmr070dY1EkStjDMPZJPYdLF1jJHpXpqjgQmRxjh4DtTqueQ8uUeQYtoA17/0
        bqj1uN84/BG7RIGgEjx6LNcXn3c2Tkg=
Date:   Tue, 25 May 2021 13:11:59 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 13/20] x86/sev: Register GHCB memory when
 SEV-SNP is active
Message-ID: <YKzbfwD6nHL7ChcJ@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-14-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210430121616.2295-14-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:16:09AM -0500, Brijesh Singh wrote:
> The SEV-SNP guest is required to perform GHCB GPA registration. This is
> because the hypervisor may prefer that a guest use a consistent and/or
> specific GPA for the GHCB associated with a vCPU. For more information,
> see the GHCB specification section GHCB GPA Registration.
> 
> During the boot, init_ghcb() allocates a per-cpu GHCB page. On very first
> VC exception, the exception handler switch to using the per-cpu GHCB page
> allocated during the init_ghcb(). The GHCB page must be registered in
> the current vcpu context.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kernel/sev.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 8c8c939a1754..e6819f170ec4 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -88,6 +88,13 @@ struct sev_es_runtime_data {
>  	 * is currently unsupported in SEV-ES guests.
>  	 */
>  	unsigned long dr7;
> +
> +	/*
> +	 * SEV-SNP requires that the GHCB must be registered before using it.
> +	 * The flag below will indicate whether the GHCB is registered, if its
> +	 * not registered then sev_es_get_ghcb() will perform the registration.
> +	 */
> +	bool snp_ghcb_registered;
>  };
>  
>  struct ghcb_state {
> @@ -100,6 +107,9 @@ DEFINE_STATIC_KEY_FALSE(sev_es_enable_key);
>  /* Needed in vc_early_forward_exception */
>  void do_early_exception(struct pt_regs *regs, int trapnr);
>  
> +/* Defined in sev-shared.c */
> +static void snp_register_ghcb(unsigned long paddr);

Can we get rid of those forward declarations pls? Due to sev-shared.c
this file is starting to spawn those and that's ugly.

Either through a code reorg or even defining a sev-internal.h header
which contains all those so that they don't pollute the code?

Thx.

> +
>  static void __init setup_vc_stacks(int cpu)
>  {
>  	struct sev_es_runtime_data *data;
> @@ -218,6 +228,12 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
>  		data->ghcb_active = true;
>  	}
>  
> +	/* SEV-SNP guest requires that GHCB must be registered before using it. */
> +	if (sev_snp_active() && !data->snp_ghcb_registered) {
> +		snp_register_ghcb(__pa(ghcb));
> +		data->snp_ghcb_registered = true;
> +	}

More missed review from last time:

"This needs to be set to true in the function itself, in the success
case."

Can you please be more careful and go through all review comments so
that I don't have to do the same work twice?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
